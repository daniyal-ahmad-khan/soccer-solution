#!/bin/bash

# Navigate to the correct directory
cd /app/Models/yolov8-demo-model/train/weights/nano

# Perform the GPU-dependent operation
yolo export model=best.pt format=engine half=True device=0

# Continue with the original startup commands
cd /app/Usage/soccer-demo/src
python3 main.py