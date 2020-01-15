"""
Class related to specific effects.
"""
# import matplotlib
# matplotlib.use("Qt5Agg")
import cv2

from models.models import (
    InpaintModule
)

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation

from pointcloud import PointClouder


class Effect(object):
    """
    Class for handling effects.
    """

    def __init__(self, bgr, depth, show_gui=False, output_filename=None):
        """
        Args:
        bgr
        depth
        show_gui
        output_filename - "effects.mp4" for example
        """
        # pointcloud class
        self.pointclouder = PointClouder(bgr, depth)
        # effect image sequence
        self.images_sequence = []
        # store the animation
        self.ani = None
        # params
        self.show_gui = show_gui
        self.output_filename = output_filename

    def generate_image_sequence(self):
        """
        Write a sequences of images to product the effect.
        """
        raise NotImplementedError

    def produce_animation(self):
        print("Producing animation")
        fig = plt.figure()
        ims = []
        for image in self.images_sequence:
            # need to reverse bgr to rgb
            im = plt.imshow(image[:, :, ::-1], animated=True)
            ims.append([im])

        self.ani = animation.ArtistAnimation(fig, ims, interval=50, blit=True,
                                             repeat_delay=1000)
        if self.output_filename:
            print("Saving animation to {}".format(self.output_filename))
            self.ani.save(self.output_filename)
        if self.show_gui:
            print("Showing gui")
            plt.show()

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

    def __init__(self, bgr, depth, show_gui=False):
        super().__init__(bgr, depth, show_gui=show_gui)

    def generate_image_sequence(self):
        path = list(np.linspace(0.0, 0.1, 2)) + \
            list(np.linspace(0.1, -0.1, 4)) + list(np.linspace(-0.1, -0.0, 2))
        # move camera in x direction
        for x in path:
            extrinsics = np.identity(4, dtype="float64")
            extrinsics[0][3] = x
            image = self.pointclouder.get_image_from_pointcloud(
                extrinsics=extrinsics
            )
            self.images_sequence.append(image)
        # move camera in y direction
        for y in path:
            extrinsics = np.identity(4, dtype="float64")
            extrinsics[1][3] = y
            image = self.pointclouder.get_image_from_pointcloud(
                extrinsics=extrinsics
            )
            self.images_sequence.append(image)


class Dolly(Effect):
    """
    Dolly zoom effect.
    """

    def __init__(self, bgr, depth, show_gui=False):
        super().__init__(bgr, depth, show_gui=show_gui)

    def generate_image_sequence(self):
        path = list(np.linspace(0.0, -0.5, 10))

        # move camera in z direction
        scalar = -1.0
        for z in path:
            # modify the focal lengths
            intrinsics = self.pointclouder.intrinsics
            original_focal_length = intrinsics[0][0]
            intrinsics[0][0] = original_focal_length + (scalar * z)
            intrinsics[1][1] = original_focal_length + (scalar * z)

            extrinsics = np.identity(4, dtype="float64")
            extrinsics[2][3] = z
            image = self.pointclouder.get_image_from_pointcloud(
                extrinsics=extrinsics
            )
            # TODO: run inpainting after interpolation
            # TODO: make this inpainting more robust
            inpainted_image = InpaintModule.get_opencv_inpainted_image(image)
            self.images_sequence.append(inpainted_image)
