#!/bin/bash

# Navigate to the correct directory
cd /app/python-app/Models/yolov8-demo-model/train/weights/nano

# Perform the GPU-dependent operation
yolo export model=best.pt format=engine device=0

# Continue with the original startup commands
cd /app
./start.sh
