# --- This document aims to gather the necessary commands to correctly configure the repository, each command must be executed manually and should not be continued until each step is successfully completed. Some instructions require manually downloading and installing some components from the indicated urls. ---

sudo apt install cmake g++ git make python3 python-pip
pip install oyaml networkx
sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio 
sudo apt-get install ffmpeg

# Cloning prp
echo "Cloning prp repo..."
mkdir -p ~/usrlib
cd ~/usrlib
git clone https://github.com/omitted/planner-for-relevant-policies.git prp
cd prp/src/
./build_all
echo "Planner for Relevant Policies successfully installed."

# Cloning ROS Nodes 
echo "Cloning custom ROS repos..."
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin_make
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc
cd src
sudo apt-get install ros-melodic-rosbridge-server
sudo apt-get install ros-melodic-naoqi-bridge-msgs
sudo apt-get install ros-melodic-naoqi-libqi
sudo apt-get install ros-melodic-naoqi-libqicore
# Add dependencies to packages.xml files 
git clone --branch modelpnine https://github.com/omitted/tobo_planner.git
git clone https://github.com/omitted/naoqi_driver.git
rosdep install -i -y --from-paths ./naoqi_driver
git clone https://github.com/omitted/tobouk_core.git
git clone https://github.com/omitted/tobouk_web_gui.git
cd ..
source ~/.bashrc
catkin_make
echo "export PRP_PATH=~/usrlib/prp" >> ~/.bashrc
echo "export PYTHONPATH=${PYTHONPATH}:~/usrlib/prp/prp-scripts" >> ~/.bashrc
echo "ROS repos successfully installed."
# Install Shellinabox
sudo apt install openssl shellinabox
sudo nano /etc/default/shellinabox
# Change the following line 
# SHELLINABOX_ARGS="--no-beep" for 
# SHELLINABOX_ARGS="--no-beep -t -m '*'"
# and
# OPTS="-s /:SSH:localhost"
sudo systemctl restart shellinabox
sudo systemctl status shellinabox 
# Config SSH pass Shellinabox
ssh-keygen -t rsa -b 4096
# press enter
# set passphrase
ssh-copy-id jetson@jetson-ip
# enter remote user password
sudo apt install keychain
# add the following lines to .bashrc file
echo "/usr/bin/keychain $HOME/.ssh/id_rsa" >> ~/.bashrc
echo "source $HOME/.keychain/$HOSTNAME-sh" >> ~/.bashrc
# create Know hosts
ssh -oHostKeyAlgorithms='ssh-rsa' jetson@jetson_ip

# create httpserver boot launch
sudo touch /lib/systemd/system/tobo_web.service
sudo echo "[Unit]" >> /lib/systemd/system/tobo_web.service
sudo echo "Description=Dash Button Sniffer" >> /lib/systemd/system/tobo_web.service
sudo echo "After=network.target" >> /lib/systemd/system/tobo_web.service
sudo echo "" >> /lib/systemd/system/tobo_web.service
sudo echo "[Service]" >> /lib/systemd/system/tobo_web.service
sudo echo "Type=simple" >> /lib/systemd/system/tobo_web.service
sudo echo "ExecStart=/usr/bin/tobo_web.sh" >> /lib/systemd/system/tobo_web.service
sudo echo "" >> /lib/systemd/system/tobo_web.service
sudo echo "[Install]" >> /lib/systemd/system/tobo_web.service
sudo echo "WantedBy=multi-user.target" >> /lib/systemd/system/tobo_web.service

sudo touch /usr/bin/tobo_web.sh
sudo echo "#! /bin/bash" >> /usr/bin/tobo_web.sh
sudo echo "export HOME=/home/toboraspuk" >> /usr/bin/tobo_web.sh
sudo echo "source /opt/ros/melodic/setup.bash" >> /usr/bin/tobo_web.sh
sudo echo "source ${HOME}/catkin_ws/devel/setup.bash" >> /usr/bin/tobo_web.sh
sudo echo "export PRP_PATH=${HOME}/usrlib/prp" >> /usr/bin/tobo_web.sh
sudo echo "export PYTHONPATH=${PYTHONPATH}:${PRP_PATH}/prp-scripts" >> /usr/bin/tobo_web.sh
sudo echo "export ROS_MASTER_URI="http://10.42.0.254:11311"" >> /usr/bin/tobo_web.sh
sudo echo "export ROS_IP="10.42.0.254"" >> /usr/bin/tobo_web.sh
sudo echo "roslaunch tobouk_web_gui tobouk_web_gui_2.launch" >> /usr/bin/tobo_web.sh

sudo chmod +x /usr/bin/tobo_web.sh
sudo systemctl daemon-reload
sudo systemctl enable tobo_web.service
sudo systemctl restart tobo_web.service
sudo systemctl status tobo_web.service

