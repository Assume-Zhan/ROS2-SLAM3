#!/bin/bash

DOCKERFILE=Dockerfile
IMAGE_NAME=orbslam/humble
CONTAINER_NAME=test

# remove old containers
docker ps -a | grep $IMAGE_NAME | awk '{print $1}' | xargs -r docker rm

# remove old images
docker rmi $IMAGE_NAME

# build
docker build -t $IMAGE_NAME -f $DOCKERFILE .

# run
docker run \
    -it \
    --rm \
    --gpus all \
    -h $(hostname) $2 \
    --network host \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=/tmp/xauth \
    -v ~/.Xauthority:/tmp/xauth \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/assume/ubuntu_ws/ros_ws:/home/assume/ros_ws \
    --name $CONTAINER_NAME \
    $IMAGE_NAME