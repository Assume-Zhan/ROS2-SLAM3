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

# Install required ROS2 packages
RUN curl -sSL http://get.gazebosim.org | sh
RUN sudo apt update
RUN sudo apt install \
             ros-humble-navigation2 \
             ros-humble-nav2-bringup \
             ros-humble-turtlebot3 \
             ros-humble-turtlebot3-gazebo \
             ros-humble-joint-state-publisher-gui \
             ros-humble-xacro \
             ros-humble-gazebo-ros-pkgs \
             ros-humble-rqt-robot-steering \ 
             ros-humble-robot-localization -y