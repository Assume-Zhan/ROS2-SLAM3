#!/bin/fish

set USERNAME Assume-Zhan
set USEREMAIL assume0701@gmail.com

# Setup git configuration
git config --global user.name "$USERNAME"
git config --global user.email $USEREMAIL
git config --global --add url."git@github.com:".insteadOf "https://github.com/"

# ROS 2 setup
echo "bass source /opt/ros/humble/setup.bash" >> ~/.config/fish/config.fish
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc