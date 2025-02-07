#!/bin/bash

set -e  # Exit the script if an error occurs

# Add ROS repository and key
echo "Adding ROS repository..."
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Update repositories
apt update

# Install generic kernel headers
echo "Installing generic kernel headers..."
apt install -y linux-headers-generic

# Install ROS Noetic Desktop-Full
echo "Installing ROS Noetic Desktop-Full..."
apt install -y ros-noetic-desktop #-full

# Install dependencies to build ROS packages
echo "Installing dependencies to build ROS packages..."
apt install -y \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential

# Initialize rosdep
echo "Initializing rosdep..."
rosdep init
rosdep update

# Add other ROS packages here
#apt install -y \

echo "Installation and configuration of ROS Noetic completed successfully."
