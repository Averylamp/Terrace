"""
Python playground for image effects.
"""

import cv2
import argparse
import sys
import os
import numpy as np


class Effector(object):
    """
    The Effector class will perform effects on an input filepath.
    Note that the Effector will call the same C++ functions that
    the iOS application will call.
    """
    effects = {
        "boomerang",
        "hyperlapse",
        "3d_ken_burns",
        "2d_ken_burns",
        "dolly",
        "space_elevator"
    }

    def __init__(self, path, effect):
        self.path = path
        self.effect = effect
        
        # cv2 image to be loaded.
        self.bgr = None
        self.masks = None
        self.depth = None
        # name of gui window
        self.window_name = "main window"

        # Make sure that the specified effect is valid.
        if self.effect not in self.effects:
            raise AssertionError("{} not a valid effect.".format(self.effect))

        self.load_data()
        self.start_gui()

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

    def start_gui(self):
        """
        Load from filepath and start gui.
        """
        # TODO: load image(s), create window
        cv2.namedWindow(self.window_name)
        cv2.imshow(self.window_name, self.bgr)
        cv2.waitKey(0)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
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
