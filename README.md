# soccer-solution

## Prerequisites

Before proceeding, ensure your Windows system meets the following requirements:

- Windows 10 or later.
- Hardware support for virtualization.
- NVIDIA GPU with the latest NVIDIA drivers installed.

## Setup Instructions

### 1. Install WSL

WSL allows you to run a Linux distribution alongside your Windows installation. To install WSL, follow these steps:

1. Open PowerShell as Administrator and run:
    ```powershell
    wsl --install
    ```
2. Restart your computer when prompted.


### 2. Set up NVIDIA GPU with WSL

To enable GPU acceleration within WSL, follow the instructions provided by NVIDIA for [WSL setup](https://developer.nvidia.com/cuda/wsl). This typically involves installing the latest NVIDIA drivers that support WSL2 and configuring your system accordingly.

### 3. Install Docker Desktop

Download and install Docker Desktop for Windows from the [official Docker website](https://www.docker.com/products/docker-desktop). Ensure you enable the WSL 2 backend during installation.

### 4. Configure Docker and NVIDIA Integration

Ensure Docker Desktop is configured to use the WSL 2 backend and has integration enabled for your Linux distribution. You might also need to install the `nvidia-docker2` package inside your WSL distribution to enable NVIDIA container support.

### 5. Clone the Repository

Open your WSL terminal, navigate to the desired directory, and clone the repository:

```bash
git clone <repository-url>
cd <repository-directory>
```
### 6. Build and Start
From within the cloned directory, run the following command to build and start the app:
```bash
docker-compose up --build
```

#### Note on Backend Initialization
The first time you start the docker the backend initialization, will take some time to initialize. This delay is due to the conversion of .pt weights to TensorRT .engine format. This conversion is necessary because .engine weights are optimized for the CUDA version and operating system they are generated on, ensuring optimal performance.
