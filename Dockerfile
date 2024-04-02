# Ultralytics YOLO 🚀, AGPL-3.0 license
# Builds ultralytics/ultralytics:latest image on DockerHub https://hub.docker.com/r/ultralytics/ultralytics
# Image is CUDA-optimized for YOLOv8 single/multi-GPU training and inference

# Start FROM PyTorch image https://hub.docker.com/r/pytorch/pytorch or nvcr.io/nvidia/pytorch:23.03-py3
FROM pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime
RUN pip install --no-cache nvidia-tensorrt --index-url https://pypi.ngc.nvidia.com

# Downloads to user config dir
ADD https://github.com/ultralytics/assets/releases/download/v0.0.0/Arial.ttf \
    https://github.com/ultralytics/assets/releases/download/v0.0.0/Arial.Unicode.ttf \
    /root/.config/Ultralytics/



# Install linux packages
# g++ required to build 'tflite_support' and 'lap' packages, libusb-1.0-0 required for 'tflite_support' package
RUN apt update \
    && apt install --no-install-recommends -y gcc git zip curl htop libgl1 libglib2.0-0 libpython3-dev gnupg g++ libusb-1.0-0

# Security updates
# https://security.snyk.io/vuln/SNYK-UBUNTU1804-OPENSSL-3314796
RUN apt upgrade --no-install-recommends -y openssl tar

# Create working directory
WORKDIR /usr/src/ultralytics

# Copy contents
# COPY . /usr/src/ultralytics  # git permission issues inside container
RUN git clone https://github.com/ultralytics/ultralytics -b main /usr/src/ultralytics
ADD https://github.com/ultralytics/assets/releases/download/v8.1.0/yolov8n.pt /usr/src/ultralytics/

# Install pip packages
RUN python3 -m pip install --upgrade pip wheel
RUN pip install --no-cache -e ".[export]" albumentations comet pycocotools

# Run exports to AutoInstall packages
# Edge TPU export fails the first time so is run twice here
RUN yolo export model=tmp/yolov8n.pt format=edgetpu imgsz=32 || yolo export model=tmp/yolov8n.pt format=edgetpu imgsz=32
RUN yolo export model=tmp/yolov8n.pt format=ncnn imgsz=32
# Requires <= Python 3.10, bug with paddlepaddle==2.5.0 https://github.com/PaddlePaddle/X2Paddle/issues/991
RUN pip install --no-cache paddlepaddle>=2.6.0 x2paddle
# Fix error: `np.bool` was a deprecated alias for the builtin `bool` segmentation error in Tests
RUN pip install --no-cache numpy==1.23.5
# Remove exported models
RUN rm -rf tmp

# Set environment variables
ENV OMP_NUM_THREADS=8
# Avoid DDP error "MKL_THREADING_LAYER=INTEL is incompatible with libgomp.so.1 library" https://github.com/pytorch/pytorch/issues/37377
ENV MKL_THREADING_LAYER=GNU

# Install necessary packages for Node.js, npm, and any other dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
# Copy the local React dashboard repository into the Docker image
RUN git clone https://github.com/daniyal-ahmad-khan/soccer-solution.git


# Install dependencies for the React dashboard
WORKDIR /app/soccer-solution/frontend
RUN npm install
WORKDIR /app/soccer-solution
RUN pip3 install websockets
# Expose the port for the React dashboard
EXPOSE 3000


RUN chmod +x /app/soccer-solution/entrypoint.sh
RUN chmod +x /app/soccer-solution/start.sh

# Set the entrypoint script to be executed
ENTRYPOINT ["/app/soccer-solution/entrypoint.sh"]

