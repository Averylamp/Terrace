"""
Python playground for image effects.

Example usage:
cd cv
python main.py --path inputs/KDWm2mJrR7s_25100000/
"""
import open3d as o3d
import utils
import numpy as np
import os
import sys
import argparse
import cv2
import matplotlib.pyplot as plt
from open3d.open3d.geometry import create_rgbd_image_from_color_and_depth
import time
from scipy.spatial.transform import Rotation as R
from models.models import (
    Modeler
)
from effects.effects import (
    TDKenBurns,
    Dolly,
    MeshTDKenBurns,
    Effect  # base class
)
import matplotlib
matplotlib.use("Qt5Agg")


class Effector(object):
    """
    The Effector class will perform effects on an input filepath.
    Note that the Effector will call the same C++ functions that
    the iOS application will call.
    """
    effects = {
        "boomerang": None,
        "hyperlapse": None,
        "3d_ken_burns": TDKenBurns,
        "2d_ken_burns": None,
        "dolly": Dolly,
        "space_elevator": None,
        "mesh_3d_ken_burns": MeshTDKenBurns,
    }

    index_to_type = {
        0: "bgr",
        1: "masks",
        2: "depth"
    }

    def __init__(self, path, effect):
        """
        Path can be folder or image.
        if folder -> get bgr, masks, and depth from it
        if image -> create bgr, masks, and depth

        effect -> the type of effect to create
        type -> folder or image
        """
        self.path = path
        self.effect = effect

        # cv2 image to be loaded.
        self.bgr = None
        self.masks = None
        self.depth = None
        # name of gui window
        self.window_name = "main window"
        self.window_image = None

        # keep track of where the cursor is
        # "type": bgr, masks, or depth
        # "location": (x,y) tuple for pixel location
        self.cursor = {
            "type": (0, 0),
            "location": (0, 0)
        }

        # Make sure that the specified effect is valid.
        if self.effect not in self.effects:
            raise AssertionError("{} not a valid effect.".format(self.effect))

        # either lood data or create data
        # depends on the input
        if utils.is_image(self.path):
            self.create_data()
        else:
            self.load_data()

        # TODO: make this an option
        # self.start_gui()

        # choose which effect to use and initialize the class
        self.effect_module = self.effects[self.effect](
            self.bgr, self.depth, show_gui=True
        )
        assert isinstance(self.effect_module, Effect)

        # run the effect
        self.effect_module.run_effect()

    def create_data(self):
        """
        Create data with modeler.
        """
        pass

    def load_data(self):
        """
        Load data.
        """
        self.bgr = cv2.imread(
            os.path.join(self.path, "rgb.png")
        )
        self.masks = np.load(
            os.path.join(self.path, "masks.npy")
        )
        self.depth = np.load(
            os.path.join(self.path, "depth.npy")
        )

    def get_type_from_x_location(self, x):
        height, width, _ = self.bgr.shape
        index = int(x / width)
        return self.index_to_type[index]

    def print_window_information(self):
        cursor_type = self.cursor["type"]
        x, y = self.cursor["location"]
        string = "type: {}".format(cursor_type)
        string += "\nlocation: (x: {}, y: {})".format(x, y)
        if cursor_type == "bgr":
            pixel_values = self.bgr[y, x]
            string += "\nbgr value: {}".format(pixel_values)
        elif cursor_type == "masks":
            pixel_value = self.masks[y, x]
            string += "\nmasks value: {}".format(pixel_value)
        elif cursor_type == "depth":
            pixel_value = self.depth[y, x]
            string += "\ndepth value: {}".format(pixel_value)
        print(string)

    def window_callback(self, event, x, y, flags, param):
        # TODO: handle user input
        cursor_type = self.get_type_from_x_location(x)
        # self.rgb.shape[1] is the width
        x_loc = x % self.bgr.shape[1]
        location = (x_loc, y)
        self.cursor = {
            "type": cursor_type,
            "location": location
        }
        self.print_window_information()

    def start_gui(self):
        """
        Show the inputs: (bgr, masks, depth).
        """
        # use cv2.WINDOW_NORMAL to resize as desired
        cv2.namedWindow(self.window_name)  # , cv2.WINDOW_NORMAL)
        cv2.setMouseCallback(self.window_name, self.window_callback)
        rgb_image = self.bgr
        masks_image = utils.get_scaled_to_max_image(
            utils.get_three_channel_image_from_one_channel(self.masks)
        )
        visible_depth_image = utils.get_three_channel_image_from_one_channel(
            utils.get_scaled_to_max_image(self.depth)
        )
        self.window_image = np.hstack(
            [rgb_image, masks_image, visible_depth_image])
        cv2.imshow(self.window_name, self.window_image)
        cv2.waitKey(0)

    def show_depth(self):
        print("Showing depth.")
        # TODO: might need to be rgb
        color_raw = o3d.geometry.Image(self.bgr)
        depth_raw = o3d.geometry.Image(self.depth)
        # https://github.com/intel-isl/Open3D/issues/1024#issuecomment-506206087
        rgbd_image = create_rgbd_image_from_color_and_depth(
            color_raw, depth_raw)

        # https://github.com/intel-isl/Open3D/issues/1024#issuecomment-515235233
        # https://github.com/openMVG/openMVG/issues/669
        h, w = self.bgr.shape[:2]
        max_width_height = max(w, h)
        focal_length = 1.2 * max_width_height
        intrinsic = o3d.camera.PinholeCameraIntrinsic(
            w, h, focal_length, focal_length, w / 2, h / 2)
        pcd = o3d.geometry.create_point_cloud_from_rgbd_image(
            rgbd_image,
            intrinsic)
        # Flip it, otherwise the pointcloud will be upside down
        pcd.transform([[1, 0, 0, 0], [0, -1, 0, 0],
                       [0, 0, -1, 0], [0, 0, 0, 1]])
        o3d.visualization.draw_geometries([pcd])


if __name__ == "__main__":
    # For creating input folder.
    parser = argparse.ArgumentParser()
    parser.add_argument("--create_input_folder", action='store_true',
                        help="Flag if creating input folder.")
    parser.add_argument("--input_filename", type=str,
                        default="Path to input image.")

    # For visualization of input folder.
    parser.add_argument("--visualize_input_folder", action='store_true',
                        help="Flag if visualizing input folder.")
    parser.add_argument("--path", type=str,
                        help="Input to the program. Should be a filepath.")
    parser.add_argument("--effect", type=str, default="3d_ken_burns",
                        help="Effect to run the program with.")
    args = parser.parse_args()

    if not args.path:
        print("Need to specify path. Exiting.")
        sys.exit()

    print("Running with filepath: {}".format(args.path))
    effector = Effector(args.path, args.effect)
