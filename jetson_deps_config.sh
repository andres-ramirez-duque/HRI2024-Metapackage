# --- This document aims to gather the necessary commands to correctly configure the repository, each command must be executed manually and should not be continued until each step is successfully completed. Some instructions require manually downloading and installing some components from the indicated urls. ---

sudo apt install cmake g++-8 git make python3
sudo -H pip3 install -U jetson-stats

# Cloning ZED GStreamer plugins
echo "Cloning ZED GStreamer plugins repo..."
sudo apt install libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstrtspserver-1.0-dev
mkdir -p ~/usrlib
cd ~/usrlib
git clone https://github.com/stereolabs/zed-gstreamer.git
cd zed-gstreamer
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install
echo "ZED GStreamer plugins successfully installed."

# Install NVIDIA DeepStream Software Development Kit (SDK)
sed 's/<platform>/t210/' /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
sudo apt install libjansson4=2.11-1
sudo apt install --reinstall nvidia-l4t-gstreamer
sudo apt install --reinstall nvidia-l4t-multimedia
sudo apt install --reinstall nvidia-l4t-core
# get the .deb file from nvidia servers before try the next line https://docs.nvidia.com/metropolis/deepstream/6.0/dev-guide/text/DS_Quickstart.html#install-the-deepstream-sdk
# use Method 3 and copy the file into jetson downloads folder
sudo apt-get install ./Downloads/deepstream-6.0_6.0.0-1_arm64.deb
echo "export CUDA_VER=10.2" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/nvidia/deepstream/deepstream/lib/cvcore_libs" >> ~/.bashrc
source ~/.bashrc

# Install Dlib and OpenFace
cd ~/usrlib
sudo apt-get install libboost-all-dev
wget http://dlib.net/files/dlib-19.23.tar.bz2
tar xf dlib-19.23.tar.bz2
cd dlib-19.23
mkdir build
cd build
cmake ..
cmake --build . --config Release
sudo make install
sudo ldconfig
cd ~/usrlib
git clone https://github.com/omitted/OpenFace.git
sudo apt-get install liblapack-dev liblapacke-dev libopenblas-dev # not sure this is necessary
cd OpenFace
bash ./download_models.sh
mkdir build
cd build
cmake -D CMAKE_CXX_COMPILER=g++-8 -D CMAKE_C_COMPILER=gcc-8 -D CMAKE_BUILD_TYPE=RELEASE ..
make
sudo make install

# Configure a catkin workspace
echo "Cloning custom ROS repos..."nano
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin_make
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

# Download Drivers
cd ~/Downloads
wget https://stereolabs.sfo2.cdn.digitaloceanspaces.com/zedsdk/3.8/ZED_SDK_Tegra_L4T32.7_v3.8.1.zstd.run
sudo chmod +x ZED_SDK_Tegra_L4T32.7_v3.8.1.zstd.run
./ZED_SDK_Tegra_L4T32.7_v3.8.1.zstd.run

# Cloning ZED ROS wrapper
echo "Cloning ZED ROS wrapper repo..."
cd ~/catkin_ws/src
git clone --recursive https://github.com/stereolabs/zed-ros-wrapper.git
cd ~/catkin_ws
rosdep install --from-paths src --ignore-src -r -y
catkin_make -DCMAKE_BUILD_TYPE=Release
echo "ZED ROS Wrapper successfully installed."

# Cloning ROS Nodes 
cd ~/catkin_ws/src
git clone https://github.com/omitted/charuco_detector.git
git clone https://github.com/ros4hri/hri_msgs.git
git clone https://github.com/omitted/tobo_perception.git
cd ~/catkin_ws
source ~/.bashrc
catkin_make

cd ~/usrlib
git clone https://github.com/omitted/tobo_extras.git
echo "ROS repos successfully installed."
# Cloning Tobo_extras (ML models, config files, custom_parser_files...)
sudo echo "Cmnd_Alias CLOCKS_CMD = /usr/bin/jetson_clocks" >> /etc/sudoers
sudo echo "nano ALL=(ALL:ALL) NOPASSWD: CLOCKS_CMD" >> /etc/sudoers
echo "sudo jetson_clocks" >> ~/.bashrc
sudo systemctl set-default multi-user.target
sudo nmcli con mod tobo connection.autoconnect yes
sudo nmcli con modify tobo connection.permissions ''

# add ros master uri as know host in /etc/hosts
# Include the following lines on file /opt/ros/melodic/env_tobojetuk.sh
sudo echo "#!/bin/bash" >> /opt/ros/melodic/env_tobojetuk.sh
sudo echo "source /opt/ros/melodic/setup.bash" >> /opt/ros/melodic/env_tobojetuk.sh
sudo echo "source /home/tobojetuk/catkin_ws/devel/setup.bash" >> /opt/ros/melodic/env_tobojetuk.sh
sudo echo "export ROS_MASTER_URI=http://10.42.0.254:11311" >> /opt/ros/melodic/env_tobojetuk.sh
sudo echo "export ROS_IP=10.42.0.1" >> /opt/ros/melodic/env_tobojetuk.sh
sudo echo "export CUDA_VER=10.2" >> /opt/ros/melodic/env_tobojetuk.sh
sudo echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/nvidia/deepstream/deepstream/lib/cvcore_libs" >> /opt/ros/melodic/env_tobojetuk.sh
sudo echo 'exec "$@"' >> /opt/ros/melodic/env_tobojetuk.sh
