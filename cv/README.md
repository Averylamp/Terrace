# cv (computer vision)

Documentation for all CV stuff, including the image framework.

# Setup

```
# create pip virtual environment
python3 -m venv venv

# start virtual environment
source venv/bin/activate

# close virtual environment
deactivate

# install packages
pip install --upgrade pip
pip install -r requirements.txt

# install Kernel to use with notebooks
python -m ipykernel install --user --display-name "imagear"
```

# Usage

```
# main program
python main.py --path inputs/KDWm2mJrR7s_25100000/

# detectron2 mask-rcnn on image
cd data_science/detectron2
python demo/demo.py --config-file configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml   --input ../../inputs/KDWm2mJrR7s_25100000/rgb.png --opts MODEL.WEIGHTS detectron2://COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x/137849600/model_final_f10217.pkl MODEL.DEVICE cpu
```

# Notes

- find good rgb / depth pair to test with
- with known segmentation masks for ken burns effect
- then create segmentation mask with tool

# Resources

```
#TODO(ethan): check this out
https://www.raywenderlich.com/5999357-video-depth-maps-tutorial-for-ios-getting-started

data_science/3d-ken-burns
git@github.com:sniklaus/3d-ken-burns.git
# pip install cupy

data_science/mannequinchallenge
git@github.com:google/mannequinchallenge.git

data_science/detectron2
git@github.com:facebookresearch/detectron2.git
# pip install 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'
# pip install 'git+https://github.com/facebookresearch/detectron2.git'
```