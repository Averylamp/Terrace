"""
For creating views from a pointcloud.
"""
from scipy.spatial.transform import Rotation as R
from scipy.interpolate import griddata
import matplotlib.pyplot as plt
import numpy as np
import trimesh
import sys
import pyrender
import matplotlib
from tqdm import tqdm
import cv2
matplotlib.use("Qt5Agg")


class PointClouder(object):
    """
    Class that deals with 2d -> 3d -> 2d projections.
    This is used to create novel views of a point cloud.
    """

    def __init__(self, bgr, depth):
        # TODO: this will need more data than just the image and depth
        self.bgr = bgr
        self.depth = depth
        self.height, self.width = self.bgr.shape[:2]

        # points and corresponding bgr color
        self.xyz_points = None
        self.color_points = None
        self.xyzw_points = None  # same as xyz_points with 1s in 4th dim
        self.my_pixels = None

        # approximation of focal length
        max_width_height = max(self.width, self.height)
        self.focal_length = 1.2 * max_width_height
        self.intrinsics = np.array(
            [
                [self.focal_length, 0, self.width / 2],
                [0, self.focal_length, self.height / 2],
                [0, 0, 1]
            ],
            dtype="float64"
        )
        self.intrinsics_inv = np.linalg.inv(self.intrinsics)
        self.extrinsics = np.array(
            [
                [1, 0, 0, 0],
                [0, 1, 0, 0],
                [0, 0, 1, 0]
            ],
            dtype="float64"
        )

        self.create_point_cloud()

    def create_point_cloud(self):
        """Create the point cloud
        """
        pixels = []
        colors = []
        my_pixels = []
        for j in range(self.height):
            for i in range(self.width):
                depth = self.depth[j, i]
                pixels.append(
                    [i * depth, j * depth, depth]
                )
                my_pixels.append(
                    [i, j, 1]
                )
                # make rgb with flip()
                colors.append(np.flip(self.bgr[j, i, :]))
                # colors.append(self.bgr[j, i, :])
        self.my_pixels = my_pixels
        pixels = np.array(pixels)

        # project pixels to camera space
        self.xyz_points = self.intrinsics_inv @ np.transpose(pixels)
        self.color_points = colors

        # now add 1s to the points for homogenous coordinates
        num_points = self.get_num_xyz_points()
        ones = np.ones((1, num_points))
        self.xyzw_points = np.concatenate((self.xyz_points, ones), axis=0)

        self.scene = None
        self.camera_pose = None
        self.nm = None
        self.nl = None
        self.nc = None
        self.create_mesh()

    def get_faces(self):
        """returns list of faces from image
        """
        faces = []
        for j in range(0, self.height - 1):
            for i in range(0, self.width - 1):
                # add the two triangle faces
                tl = (j * self.width) + i
                tr = (j * self.width) + i + 1
                bl = ((j+1) * self.width) + i
                br = ((j+1) * self.width) + i + 1

                face = [bl, tr, tl]
                faces.append(face)
                face = [bl, br, tr]
                faces.append(face)
        return faces

    def get_distance_between_points(self, i, j):
        points = self.xyz_points.T
        return np.linalg.norm(
            points[i]-points[j]
        )

    # def get_filtered_faces(self, faces):
    #     filtered_faces = []
    #     for face in faces:
    #         i, j, k = face
    #         thresh = 100.0
    #         if self.get_distance_between_points(i, j) > thresh:
    #             continue
    #         elif self.get_distance_between_points(j, k) > thresh:
    #             continue
    #         elif self.get_distance_between_points(i, k) > thresh:
    #             continue
    #         filtered_faces.append(face)
    #     return filtered_faces

    def create_mesh(self):
        """Use the points to create a mesh.
        """
        print("create_mesh")
        faces = self.get_faces()
        print("num faces: {}".format(len(faces)))
        # filtered_faces = self.get_filtered_faces(faces)
        # print("num filtered faces: {}".format(len(filtered_faces)))

        vertices = self.xyz_points.T
        trimesh_mesh = trimesh.Trimesh(
            vertices=vertices, faces=faces, vertex_colors=self.color_points, process=False)
        print("is_watertight: {}".format(trimesh_mesh.is_watertight))
        print("volumne: {}".format(trimesh_mesh.volume))
        # trimesh_mesh.export(file_obj="mymesh.ply")
        # trimesh_mesh.show()
        # (trimesh_mesh + trimesh_mesh.bounding_box_oriented).show()

        mesh = pyrender.Mesh.from_trimesh(trimesh_mesh, smooth=False)

        self.scene = pyrender.Scene()
        # scene.add(mesh)
        # pyrender.Viewer(scene, use_raymond_lighting=True)
        camera = pyrender.IntrinsicsCamera(
            self.focal_length, self.focal_length, self.width / 2, self.height / 2
        )
        self.camera_pose = np.array([
            [1.0, 0.0, 0.0, 0.0],
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
            [0.0, 0.0, 0.0, 1.0],
        ])
        # https://pyrender.readthedocs.io/en/latest/examples/cameras.html#creating-cameras
        # https://docs.scipy.org/doc/scipy/reference/generated/scipy.spatial.transform.Rotation.html
        r = R.from_rotvec(np.array([0, np.pi, 0]))
        r = R.from_rotvec(np.array([0.0, 0, np.pi])) * r
        matrix = r.as_matrix()
        self.camera_pose[:3, :3] = matrix

        # # apply some shift to the camera
        # # TODO: do the shift to the points
        # extrinsics = np.array(
        #     [
        #         [1, 0, 0, 0.1],
        #         [0, 1, 0, 0],
        #         [0, 0, 1, 0],
        #         [0, 0, 0, 1]
        #     ],
        #     dtype="float64"
        # )
        # temppose = extrinsics @ camera_pose
        # scene.add(camera, pose=temppose)
        light = pyrender.DirectionalLight(
            intensity=3.0
        )
        # scene.add(light, pose=temppose)

        self.nm = pyrender.Node(mesh=mesh, matrix=np.eye(4))
        self.nl = pyrender.Node(light=light, matrix=np.eye(4))
        self.nc = pyrender.Node(camera=camera, matrix=np.eye(4))
        self.scene.add_node(self.nm)
        self.scene.add_node(self.nl)
        self.scene.add_node(self.nc)

        # pyrender.Viewer(self.scene, use_raymond_lighting=True,
        #                 viewport_size=(self.width, self.height))

        # path = list(np.linspace(0.0, 0.1, 2)) + \
        #     list(np.linspace(0.1, -0.1, 4)) + list(np.linspace(-0.1, -0.0, 2))
        # # move camera in x direction
        # print("processing x path")
        # for x in tqdm(path):
        #     extrinsics = np.array(
        #         [
        #             [1, 0, 0, x],
        #             [0, 1, 0, 0],
        #             [0, 0, 1, 0],
        #             [0, 0, 0, 1]
        #         ],
        #         dtype="float64"
        #     )
        #     temppose = extrinsics @ camera_pose
        #     scene.set_pose(nl, pose=temppose)
        #     scene.set_pose(nc, pose=temppose)

        #     r = pyrender.OffscreenRenderer(self.width, self.height)
        #     color, depth = r.render(scene)
        #     # print(color)
        #     # print(color.shape)
        #     cv2.imshow("pyrender", color[:, :, ::-1])
        #     cv2.waitKey(0)
        # sys.exit()

    def get_num_xyz_points(self):
        return self.xyz_points.shape[1]

    def get_image_from_pointcloud(self, intrinsics=None, extrinsics=None):
        if not isinstance(intrinsics, (np.ndarray, np.generic)):
            intrinsics = self.intrinsics
        if not isinstance(extrinsics, (np.ndarray, np.generic)):
            extrinsics = self.extrinsics
        image = np.zeros((self.height, self.width, 3), dtype="uint8")

        uv_points = intrinsics @ (extrinsics @ self.xyzw_points)
        uv_points = uv_points[:2, :] / uv_points[2, :]
        uv_points = np.transpose(uv_points)

        iy = []
        ix = []
        samples = []
        y_to_interpolate = []
        x_to_interpolate = []
        for uv_point, color in zip(uv_points, self.color_points):
            # rounds down
            u, v = uv_point.astype(int)
            if 0 <= v and v < self.height and 0 <= u and u < self.width:
                # color is three channels
                image[v, u] = color

                # set values to use for interpolation
                # use floating point values
                ix.append(uv_point[0])
                iy.append(uv_point[1])
                samples.append(color)

        # interpolate where no pixels are
        for i in range(self.width):
            for j in range(self.height):
                val = image[j, i]
                if np.max(val) == 0:
                    x_to_interpolate.append(i)
                    y_to_interpolate.append(j)

        # https://docs.scipy.org/doc/scipy/reference/generated/scipy.interpolate.griddata.html
        # https://scipython.com/book/chapter-8-scipy/additional-examples/interpolation-of-an-image/
        interpolated_image = griddata(
            (iy, ix), samples, (y_to_interpolate, x_to_interpolate), fill_value=0, method="linear")
        interpolated_image = np.clip(
            interpolated_image, 0, 255).astype("uint8")

        # set the values
        for x, y, value in zip(x_to_interpolate, y_to_interpolate, interpolated_image):
            image[y, x] = value

        # print(interpolated_image)
        # raise ValueError('stop')
        return image

    def get_image_from_mesh(self, intrinsics=None, extrinsics=None):
        if not isinstance(intrinsics, (np.ndarray, np.generic)):
            intrinsics = self.intrinsics
        if not isinstance(extrinsics, (np.ndarray, np.generic)):
            extrinsics = self.extrinsics
        image = np.zeros((self.height, self.width, 3), dtype="uint8")

        temppose = extrinsics @ self.camera_pose
        self.scene.set_pose(self.nl, pose=temppose)
        self.scene.set_pose(self.nc, pose=temppose)
        r = pyrender.OffscreenRenderer(self.width, self.height)
        image, depth = r.render(self.scene)
        # cv2.imshow("pyrender", color[:, :, ::-1])
        # cv2.waitKey(0)

        # print(interpolated_image)
        # raise ValueError('stop')
        return image
