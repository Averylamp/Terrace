"""
Class related to specific effects.
"""
# import matplotlib
# matplotlib.use("Qt5Agg")
import cv2
import imageio
import os

from models.models import (
    InpaintModule
)

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation
from tqdm import tqdm

from pointcloud import PointClouder


class Effect(object):
    """
    Class for handling effects.
    """

    def __init__(self, args, bgr, depth, show_gui=False, output_filename=None):
        """
        Args:
        bgr
        depth
        show_gui
        output_filename - "effect.mp4" for example
        """
        # input args
        self.args = args
        # pointcloud class
        self.pointclouder = PointClouder(args, bgr, depth)
        # effect image sequence
        self.images_sequence = []
        # store the animation
        self.ani = None
        # params
        self.show_gui = show_gui
        if output_filename:
            self.output_filename = output_filename
        else:
            self.output_filename = args.effect + ".gif"

    def generate_image_sequence(self):
        """
        Write a sequences of images to product the effect.
        """
        raise NotImplementedError

    def produce_animation(self):
        print("Producing animation")
        # https://stackoverflow.com/questions/753190/programmatically-generate-video-or-animated-gif-in-python
        ims = []
        for image in self.images_sequence:
            # need to reverse bgr to rgb
            # ims.append(image[:, :, ::-1])
            ims.append(image)

        if self.output_filename:
            print("Saving animation to {}".format(self.output_filename))
            imageio.mimsave(os.path.join(self.args.path, self.output_filename), ims)

    def run_effect(self):
        """
        Run the entire effect.
        """
        print("Running effect")
        self.generate_image_sequence()
        if self.images_sequence == []:
            raise ValueError(
                "generate_image_sequence() must generate an image sequence.")
        self.produce_animation()


class TDKenBurns(Effect):
    """
    3D Ken burns effect.
    """

    def __init__(self, args, bgr, depth, show_gui=False):
        super().__init__(args, bgr, depth, show_gui=show_gui)

    def generate_image_sequence(self):
        path = list(np.linspace(0.0, 0.1, 2)) + \
            list(np.linspace(0.1, -0.1, 4)) + list(np.linspace(-0.1, -0.0, 2))
        # move camera in x direction
        print("processing x path")
        for x in tqdm(path):
            extrinsics = np.array(
                [
                    [1, 0, 0, x],
                    [0, 1, 0, 0],
                    [0, 0, 1, 0]
                ],
                dtype="float64"
            )
            image = self.pointclouder.get_image_from_pointcloud(
                extrinsics=extrinsics
            )
            self.images_sequence.append(image)
        # move camera in y direction
        print("processing y path")
        for y in tqdm(path):
            extrinsics = np.array(
                [
                    [1, 0, 0, 0],
                    [0, 1, 0, y],
                    [0, 0, 1, 0]
                ],
                dtype="float64"
            )
            image = self.pointclouder.get_image_from_pointcloud(
                extrinsics=extrinsics
            )
            self.images_sequence.append(image)


class Dolly(Effect):
    """
    Dolly zoom effect.
    """

    def __init__(self, args, bgr, depth, show_gui=False):
        super().__init__(args, bgr, depth, show_gui=show_gui)

    def generate_image_sequence(self):
        path = list(np.linspace(0.0, -5.0, 50))

        # move camera in z direction
        for z in path:
            # modify the focal lengths
            intrinsics = self.pointclouder.intrinsics
            original_focal_length = intrinsics[0][0]
            intrinsics[0][0] = original_focal_length - z
            intrinsics[1][1] = original_focal_length - z

            extrinsics = np.identity(4, dtype="float64")
            extrinsics[2][3] = z
            image = self.pointclouder.get_image_from_mesh(
                intrinsics=intrinsics, extrinsics=extrinsics
            )
            # TODO: run inpainting after interpolation
            # TODO: make this inpainting more robust
            inpainted_image = InpaintModule.get_opencv_inpainted_image(image)
            self.images_sequence.append(inpainted_image)


class MeshTDKenBurns(Effect):
    """
    Mesh 3D Ken burns effect.
    """

    def __init__(self, args, bgr, depth, show_gui=False):
        super().__init__(args, bgr, depth, show_gui=show_gui)

    def generate_image_sequence(self):
        path = list(np.linspace(0.0, 0.2, 10)) + \
            list(np.linspace(0.2, -0.2, 20)) + \
            list(np.linspace(-0.2, -0.0, 10))
        # move camera in x direction
        print("processing x path")
        for x in tqdm(path):
            extrinsics = np.array(
                [
                    [1, 0, 0, x],
                    [0, 1, 0, 0],
                    [0, 0, 1, 0],
                    [0, 0, 0, 1]
                ],
                dtype="float64"
            )
            image = self.pointclouder.get_image_from_mesh(
                extrinsics=extrinsics
            )
            self.images_sequence.append(image)
        # move camera in y direction
        print("processing y path")
        for y in tqdm(path):
            extrinsics = np.array(
                [
                    [1, 0, 0, 0],
                    [0, 1, 0, y],
                    [0, 0, 1, 0],
                    [0, 0, 0, 1]
                ],
                dtype="float64"
            )
            image = self.pointclouder.get_image_from_mesh(
                extrinsics=extrinsics
            )
            self.images_sequence.append(image)
