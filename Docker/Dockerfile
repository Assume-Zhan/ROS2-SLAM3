FROM osrf/ros:humble-desktop

ARG USERNAME=assume

# Update
RUN apt update && \
    apt install sudo vim curl tree -y

# Set the timezone
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata
RUN TZ=Asia/Taipei && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata 

# add user with default bash
# --disabled-password to disable run passwd, 
# the user account will active until passwd is set
# --gecos '' makes adduser only ask info we specified
# adduser to sudo group
# make user login without password by echo NOPASSWD to user priviledge settings
RUN adduser --disabled-password --gecos '' --shell /bin/bash ${USERNAME} && \
    adduser ${USERNAME} sudo && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Login with user
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# --- Install required packages ---
RUN curl -sSL http://get.gazebosim.org | sh
RUN sudo apt update && sudo apt install \
             # ROS2 navigation and localization packages
             ros-$ROS_DISTRO-navigation2 \
             ros-$ROS_DISTRO-nav2-bringup \
             ros-$ROS_DISTRO-turtlebot3 \
             ros-$ROS_DISTRO-turtlebot3-gazebo \
             ros-$ROS_DISTRO-joint-state-publisher-gui \
             ros-$ROS_DISTRO-xacro \
             ros-$ROS_DISTRO-gazebo-ros-pkgs \
             ros-$ROS_DISTRO-rqt-robot-steering \ 
             ros-$ROS_DISTRO-robot-localization \
             ros-$ROS_DISTRO-vision-opencv \ 
             ros-$ROS_DISTRO-message-filters \
             # Install orb-slam required packages
             libopencv-dev opencv-data \
             libglew-dev ffmpeg libboost-system-dev libeigen3-dev -y


# --- Build Pangolin from source ---
RUN git clone https://github.com/stevenlovegrove/Pangolin.git
RUN mkdir -p /home/${USERNAME}/Pangolin/build
RUN cd Pangolin/build && cmake .. && cmake --build .

