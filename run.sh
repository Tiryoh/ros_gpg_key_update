#!/usr/bin/env bash
set -eu

# delete old key used before June 2019
if [[ $(APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key list | grep -q 421C365BD9FF1F717815A3895523BAEEB01FA116) ]]; then
	sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
	sudo apt-key del 421C365BD9FF1F717815A3895523BAEEB01FA116
fi

# update the GPG key
# APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add -
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
# update the sources.list
sudo sed -i -e "s#deb \[arch=$(dpkg --print-architecture)\] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main#deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main#g" /etc/apt/sources.list.d/ros2-latest.list
sudo sed -i -e "s#deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main#deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main#g" /etc/apt/sources.list.d/ros2-latest.list
sudo sed -i -e "s#deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main#deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main#g" /etc/apt/sources.list.d/ros-latest.list

echo "ROS GPG key has been successfully updated. Run 'apt update'."
