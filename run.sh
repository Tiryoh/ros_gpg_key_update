#!/usr/bin/env bash
set -eu

### delete old keys ###
# delete old key used before June 2019
OLD_KEY_REGEX_2019='421C[[:space:]]*365B[[:space:]]*D9FF[[:space:]]*1F71[[:space:]]*7815[[:space:]]*A389[[:space:]]*5523[[:space:]]*BAEE[[:space:]]*B01F[[:space:]]*A116|421C365BD9FF1F717815A3895523BAEEB01FA116'
if [[ $(APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key list | grep -q -E "${OLD_KEY_REGEX_2019}") ]]; then
	sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
	sudo apt-key del 421C365BD9FF1F717815A3895523BAEEB01FA116
fi
# delete old key expired in May 2025
OLD_KEY_REGEX_2025='C1CF[[:space:]]*6E31[[:space:]]*E6BA[[:space:]]*DE88[[:space:]]*68B1[[:space:]]*72B4[[:space:]]*F42E[[:space:]]*D6FB[[:space:]]*AB17[[:space:]]*C654|C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'
if [[ $(APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key list | grep -q -E "${OLD_KEY_REGEX_2025}") ]]; then
	sudo apt-key del C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
fi


### update the GPG key ###
# recommended method
echo 'downloading new key from GitHub.com/ros/rosdistro'
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
# use this if you wan to use apt-key (not recommended)
# APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add -

### update the sources.list ###
# ROS 2
if [ -e /etc/apt/sources.list.d/ros2-latest.list ]; then
	sudo sed -i -e "s#deb \[arch=\(.*\)\] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") main#deb [arch=\1 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") main#g" /etc/apt/sources.list.d/ros2-latest.list
	sudo sed -i -e "s#deb http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") main#deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") main#g" /etc/apt/sources.list.d/ros2-latest.list
fi

# ROS 1
if [ -e /etc/apt/sources.list.d/ros-latest.list ]; then
	sudo sed -i -e "s#deb http://packages.ros.org/ros/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") main#deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") main#g" /etc/apt/sources.list.d/ros-latest.list
elif [ -e /etc/apt/sources.list.d/ros1-latest.list ]; then
	sudo sed -i -e "s#deb http://packages.ros.org/ros/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") main#deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") main#g" /etc/apt/sources.list.d/ros1-latest.list
fi

echo "ROS GPG key has been successfully updated. Run 'sudo apt update'."
