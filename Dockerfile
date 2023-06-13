FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel

ARG USERNAME
ARG USER_UID
ARG USER_GID

ENV SHELL /bin/bash

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && rm /etc/apt/sources.list.d/cuda.list \
    && rm /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y sudo curl wget git tmux libglib2.0-0 libsm6 libxrender1 libxext6 libgl1-mesa-dev \
    && conda install -c pytorch \
    && rm -rf /var/lib/apt/lists/* \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

WORKDIR /workspace
COPY ./requirements.txt /workspace/

RUN pip install --upgrade pip \
    && pip install --user --no-cache-dir -r /workspace/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple