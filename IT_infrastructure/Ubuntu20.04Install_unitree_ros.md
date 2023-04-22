# 安装unitree ros

* 安装unitree ros前提是安装好ros

## 1.安装ROS
### 1.1配置安装源
``` shell
sudo sh -c '. /etc/lsb-release && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
```
### 1.2设置key

``` shell
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
```

``` shell
sudo apt update
sudo apt-cache search ros-noetic
sudo apt install ros-noetic-desktop-full
```
### 1.3设置环境
``` shell
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```
### 1.4首先安装构建依赖的相关工具

``` shell
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
```
### 1.5初始化rosdep

``` shell
sudo rosdep init
rosdep update
```
### 1.6 验证，运行小乌龟

``` shell
rosrun turtlesim turtlesim_node
rosrun turtlesim turtle_teleop_key # 通过方向键控制小乌龟运动
```

## 2.安装unitree ros

### 2.1获取unitree_ros源码并修改文件
``` shell
git clone https://github.com/unitreerobotics/unitree_ros.git
```
#### 2.1.1修改文件 /home/jingtai/catkin_ws/src/unitree_ros/unitree_gazebo/worlds/stairs.world
``` 
<uri>/home/jingtai/catkin_ws/src/unitree_ros/unitree_gazebo/worlds/building_editor_models/stairs</uri>
```
#### 2.1.2修改文件 /home/jingtai/catkin_ws/src/unitree_ros/unitree_gazebo/plugin/draw_force_plugin.cc
```
this->line->AddPoint(ignition::math::Vector3d(0, 0, 0), ignition::math::Color::Red);
// this->line->AddPoint(ignition::math::Vector3d(0, 0, 0), ignition::math::Color(0, 1, 0, 1.0));
this->line->AddPoint(ignition::math::Vector3d(1, 1, 1), ignition::math::Color::Red);
// this->line->AddPoint(ignition::math::Vector3d(1, 1, 1), ignition::math::Color(0, 1, 0, 1.0));
```


### 2.2安装unitree_legged_sdk
* unitree_legged_sdk依赖Boost(version 1.5.4 or higher)，CMake(version 2.8.3 or higher)，g++(version 8.3.0 or higher)，LCM．前三个都是编译工具，最后一个是通信协议，直接上官网下就OK了

#### 2.2.1安装LCM

``` shell
sudo apt-get install build-essential autoconf automake autopoint libglib2.0-dev libtool openjdk-8-jdk python-dev
tar -zxvf lcm-1.4.0.tar.gz
cd lcm-1.4.0
mkdir build
cd build
cmake ..
export LCM_INSTALL_DIR=/usr/local/lib
sudo make install
```

* 最后，输入lcm-spy，如果正常运行，则安装成功。

#### 2.2.2安装boost依赖

``` shell
tar -zxvf boost_1_80_0.tar.gz
cd boost_1_80_0/
sudo ./bootstrap.sh
sudo ./b2
sudo ./b2 install
```
#### 2.2.3安装unitree_legged_sdk
``` shell
tar -zxvf unitree_legged_sdk-3.4.2.tar.gz
cd unitree_legged_sdk-3.4.2
mkdir build
cd build
cmake ../
make
```
* 可以在build文件夹中./example_walk验证。

### 2.3 克隆unitree_ros_to_real-3.4.0，修改文件并复制到对应目录（/home/jingtai/catkin_ws/src）下
#### 2.3.1修改/home/jingtai/unitree_ros_to_real-3.4.0/unitree_legged_real/CMakeLists.txt
```
include_directories(/home/$ENV{USER}/Robot_SDK/unitree_legged_sdk/include)
# link_directories(/home/$ENV{USER}/Robot_SDK/unitree_legged_sdk/lib)
link_directories(/home/jingtai/unitree_legged_sdk-3.4.2/lib)
string(CONCAT LEGGED_SDK_NAME libunitree_legged_sdk_amd64.so)
set(EXTRA_LIBS ${LEGGED_SDK_NAME} lcm)

# add_executable(lcm_server /home/$ENV{USER}/Robot_SDK/unitree_legged_sdk/examples/lcm_server.cpp)
add_executable(lcm_server /home/jingtai/unitree_legged_sdk-3.4.2/examples/lcm_server.cpp)
target_link_libraries(lcm_server ${EXTRA_LIBS} ${catkin_LIBRARIES})
add_dependencies(lcm_server ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
```
#### 2.3.2将SDK中的文件夹unitree_legged_sdk复制到/home/jingtai/catkin_ws/src/unitree_ros_to_real-3.4.0/unitree_legged_real/include下面
* 将/home/jingtai/unitree_legged_sdk-3.4.2/include/中的文件夹unitree_legged_sdk复制到/home/jingtai/catkin_ws/src/unitree_ros_to_real-3.4.0/unitree_legged_real/include下面，编译/home/jingtai/catkin_ws/src/unitree_ros_to_real-3.4.0/unitree_legged_real/include/convert.h需要用到。


#### 2.3.3将unitree_ros_to_real文件夹复制到/home/jingtai/catkin_ws/src/下

## 3.验证
### 3.1依赖验证（可选步骤）
``` shell
$ sudo find / -name "genmsg"
```
### 3.2catkin_make，并验证

``` shell
:~/catkin_ws$ catkin_make
roslaunch laikago_description laikago_rviz.launch
```