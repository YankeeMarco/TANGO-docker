# Use the NVIDIA CUDA base image
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# Set environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3.9 \
    python3.9-venv \
    python3.9-dev \
    build-essential \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up a virtual environment
RUN python3.9 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN pip install --upgrade pip

# Prepare the Tango working directory
WORKDIR /opt/tango

# Clone the TANGO repository
RUN git clone https://github.com/CyberAgentAILab/TANGO.git .
RUN git clone https://github.com/justinjohn0306/Wav2Lip.git
RUN git clone https://github.com/dajes/frame-interpolation-pytorch.git

# Install Python dependencies
COPY pre-requirements.txt requirements.txt ./
RUN pip install -r pre-requirements.txt
RUN pip install -r requirements.txt

# Expose necessary ports (if the application requires it)
EXPOSE 8675

# Command to run inference or any other script
CMD ["python", "app.py"]