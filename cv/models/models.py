"""
Run an image through models to get outputs.
"""

import cv2
import numpy as np


class Modeler(object):
    """
    The Modeler class is used to run models or algorithms on input images
    to generate the necessary input for the Effector.
    """

    def __init__(self, bgr):
        self.bgr = bgr


class InpaintModule(Modeler):
    """
    For image inpainting.
    """

    def __init__(self):
        pass

    @staticmethod
    def get_opencv_inpainted_image(image):
        mask = np.where(image[:, :, 0] == 0, 1.0, 0.0).astype("uint8")
        return cv2.inpaint(image, mask, 3, cv2.INPAINT_TELEA)


class SegmentModule(Modeler):
    """
    For image segmentation.
    """

    def __init__(self):
        pass


class DepthModule(Modeler):
    """
    For depth estimation.
    """

    def __init__(self):
        pass
