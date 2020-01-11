"""
Writes mannequinchallenge output to input folder.
Usage:
cd data_science
python write_mann_to_inputs.py --input /path/to/hdf5/file --output /path/to/inputs/folder/

Example:
python write_mann_to_inputs.py \
    --input mannequinchallenge/test_data/viz_predictions/tum_hdf5/KDWm2mJrR7s_25100000.jpg.h5 \
    --output ../inputs/
"""

import cv2
import argparse
import sys
import h5py
import numpy as np
import matplotlib.pyplot as plt
import os
import shutil

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=str,
                        help="Input hdf5 path.")
    parser.add_argument("--output", type=str,
                        help="Path to inputs folder.")
    args = parser.parse_args()

    filepath = args.input
    hdf = h5py.File(filepath,'r')
    # [()] is equivalent to .value and converts to numpy
    img = (hdf["prediction/img"][()] * 256.0).astype("uint8")
    pred_depth = hdf["prediction/pred_depth"][()]
    gt_depth = hdf["prediction/gt_depth"][()]
    gt_mask = hdf["prediction/gt_mask"][()]
    input_confidence = hdf["prediction/input_confidence"][()]
    human_mask = hdf["prediction/human_mask"][()]

    last_part = args.input.split("/")[-1]
    output_folder_name = last_part[:last_part.find("."):]
    output_folder = os.path.join(args.output, output_folder_name)
    if os.path.exists(output_folder):
        shutil.rmtree(output_folder)
    os.makedirs(output_folder)

    # write image to input folder
    # need the rgb image, the masks, and the depths to create good effects
    img_bgr = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
    cv2.imwrite(os.path.join(output_folder, "rgb.png"), img_bgr)
    np.save(os.path.join(output_folder, "masks.npy"), human_mask)
    np.save(os.path.join(output_folder, "depth.npy"), pred_depth)
