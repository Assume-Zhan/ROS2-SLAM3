FROM osrf/ros:humble-desktop

ARG USERNAME=assume
ARG ROS_ORB_WS=orbslam3_ws


#############################################
# --- Basic setup ---
RUN apt update && \
    apt install sudo vim curl tree -y

# Set the timezone
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata
RUN TZ=Asia/Taipei && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata 

# Add user
RUN adduser --disabled-password --gecos '' --shell /bin/bash ${USERNAME} && \
    adduser ${USERNAME} sudo && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Login with user
USER ${USERNAME}
WORKDIR /home/${USERNAME}


#############################################
# --- Install required packages ---
RUN curl -sSL http://get.gazebosim.org | sh
RUN sudo apt update && sudo apt install software-properties-common \
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


#############################################
# --- Build Pangolin from source ---
RUN git clone https://github.com/stevenlovegrove/Pangolin.git
RUN mkdir -p /home/${USERNAME}/Pangolin/build
RUN cd Pangolin/build && cmake .. && cmake --build .


#############################################
# --- Build ORB-SLAM3 from source
WORKDIR /home/${USERNAME}

RUN git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git ~/ORB_SLAM3

# Change to c++14 for compile error
# Ref : https://github.com/UZ-SLAMLab/ORB_SLAM3/issues/387
# Ref : https://github.com/Soldann/MORB_SLAM/issues/3
RUN sed -i 's/++11/++14/g' ORB_SLAM3/CMakeLists.txt && \
    sed -i 's/++11/++14/g' ORB_SLAM3/Thirdparty/g2o/CMakeLists.txt && \
    sed -i 's/++11/++14/g' ORB_SLAM3/Thirdparty/Sophus/CMakeLists.txt

RUN cd ORB_SLAM3 && ./build.sh && \
    cd Thirdparty/Sophus/build && sudo make install


#############################################
# --- Build ros2-orbslam3 package ---
RUN mkdir -p /home/${USERNAME}/${ROS_ORB_WS}/src

WORKDIR /home/${USERNAME}/${ROS_ORB_WS}

RUN colcon build && git clone https://github.com/zang09/ORB_SLAM3_ROS2.git ./src/orbslam3_ros2

# Fix path error and colcon build error
# Ref : https://github.com/alsora/ros2-ORB_SLAM2/issues/8#issuecomment-1461570970
RUN sed -i 's/foxy\/lib\/python3.8/humble\/lib\/python3.10/g' src/orbslam3_ros2/CMakeLists.txt && \
    sed -i 's/Pangolin)/Pangolin OpenCV)/g' src/orbslam3_ros2/CMakeLists.txt && \
    sed -i 's/Install\/ORB_SLAM\/ORB_SLAM3/ORB_SLAM3/g' src/orbslam3_ros2/CMakeModules/FindORB_SLAM3.cmake && \
    # Source and build the package
    . /opt/ros/humble/setup.sh && colcon build --symlink-install --packages-select orbslam3

WORKDIR /home/${USERNAME}/ros_ws

#############################################
# --- Optional - fish shell setup ---
RUN sudo apt-add-repository ppa:fish-shell/release-3
RUN sudo apt install fish -y

COPY config/fish_plugin.sh /home/${USERNAME}/fish_install.sh
COPY config/startup.sh /home/${USERNAME}/startup.sh

RUN /home/${USERNAME}/fish_install.sh
RUN /home/${USERNAME}/startup.sh

# Enter container with fish shell
CMD ["fish"]