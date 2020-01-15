"""
For creating views from a pointcloud.
"""
import numpy as np


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

        max_width_height = max(self.width, self.height)
        focal_length = 1.2 * max_width_height
        self.intrinsics = np.array(
            [
                [focal_length, 0, self.width / 2],
                [0, focal_length, self.height / 2],
                [0, 0, 1]
            ],
            dtype="float64"
        )
        self.intrinsics_inv = np.linalg.inv(self.intrinsics)
        self.extrinsics = np.array(
            [
                [1, 0, 0, 0],
                [0, 1, 0, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1]
            ],
            dtype="float64"
        )

        self.create_xyz_points()

    def create_xyz_points(self):
        pixels = []
        colors = []
        for i in range(self.width):
            for j in range(self.height):
                depth = self.depth[j, i]
                pixels.append(
                    [i * depth, j * depth, depth]
                )
                colors.append(self.bgr[j, i, :])
        pixels = np.array(pixels)

        self.xyz_points = self.intrinsics_inv @ np.transpose(pixels)
        self.color_points = colors

    def get_num_xyz_points(self):
        return self.xyz_points.shape[1]

    def get_image_from_pointcloud(self, intrinsics=None, extrinsics=None):
        if not isinstance(intrinsics, (np.ndarray, np.generic)):
            intrinsics = self.intrinsics
        if not isinstance(extrinsics, (np.ndarray, np.generic)):
            extrinsics = self.extrinsics
        image = np.zeros((self.height, self.width, 3), dtype="uint8")
        num_points = self.get_num_xyz_points()
        ones = np.ones((1, num_points))
        xyzw_points = np.concatenate((self.xyz_points, ones), axis=0)

        temp = extrinsics @ xyzw_points
        temp = temp[:3, :] / temp[3, :]
        uv_points = intrinsics @ temp
        uv_points = uv_points[:2, :] / uv_points[2, :]
        uv_points = np.transpose(uv_points)

        for uv_point, color in zip(uv_points, self.color_points):
            u, v = uv_point.astype(int)
            if 0 <= v and v < self.height and 0 <= u and u < self.width:
                # color is three channels
                image[v, u] = color
        return image
