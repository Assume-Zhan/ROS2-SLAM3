#!/bin/bash

DOCKERFILE=Dockerfile
IMAGE_NAME=orbslam3/humble
CONTAINER_NAME=orbslam3

# remove old containers
docker ps -a | grep $IMAGE_NAME | awk '{print $1}' | xargs -r docker rm

# remove old images
docker rmi $IMAGE_NAME

# build
docker build -t $IMAGE_NAME -f $DOCKERFILE .

# run
docker run -it $1 \
    --gpus all \
    --name $CONTAINER_NAME \
    --network host --privileged \
    -h $(hostname) \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=/tmp/xauth \
    -v ~/.Xauthority:/tmp/xauth \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/assume/ubuntu_ws/ros_ws:/home/assume/ros_ws \
    $IMAGE_NAME