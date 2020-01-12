"""
Helper utilities for repo.
"""

import numpy as np


def get_scaled_to_max_image(image):
    max_value = image.max()
    scalar = 255.0 / max_value
    return (image * scalar).astype("uint8")


def get_three_channel_image_from_one_channel(image):
    assert len(image.shape) == 2
    w, h = image.shape
    three_channel_image = np.zeros((w, h, 3))
    three_channel_image[:, :, 0] = image
    three_channel_image[:, :, 1] = image
    three_channel_image[:, :, 2] = image
    return three_channel_image.astype("uint8")
