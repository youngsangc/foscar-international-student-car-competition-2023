용량문제로 github에 업데이트 안되는 파일들 목록

lane_pkg폴더 안에 
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src.tar.xz
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src.zip
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src/Lanenet
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src/Notebook-experiment
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src/TUSIMPLE
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src/__pycache__
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src/dataset
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src/github
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src/hg_laneDetection_trad-master
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src/img
/home/youngsangcho/ISCC_2023_3/src/lane_pkg/src/utils

yolov7 폴더 안에
/home/youngsangcho/ISCC_2023_3/src/yolov7-ros/weights

이외에도 ublox, handsfree_ros_imu, velodyne은 라이센스 정책에 따라 업로드되지 않음
해당 사이트 첨부

###ublox pkg :

github ropository : https://github.com/KumarRobotics/ublox
git clone https://github.com/KumarRobotics/ublox.git

###handsfree_ros_imu pkg :

https://github.com/HANDS-FREE/handsfree_ros_imu/blob/master/tutorials/doc.md

위 글을 읽으면서 본인 버전에 맞는 방식으로 하면 됨

ros noetic version

sudo apt-get install ros-noetic-imu-tools ros-noetic-rviz-imu-plugin

mkdir -p  ~/handsfree/handsfree_ros_ws/src/
cd ~/handsfree/handsfree_ros_ws/src/
git clone https://gitee.com/HANDS-FREE/handsfree_ros_imu.git
cd ~/handsfree/handsfree_ros_ws/
catkin_make
cd ~/handsfree/handsfree_ros_ws/src/handsfree_ros_imu/scripts/
sudo chmod 777 *.py
echo "source ~/handsfree/handsfree_ros_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc
ls /dev/ttyUSB0
sudo chmod 777 /dev/ttyUSB0

IMU 뿐만 아니라 다른 usb연결시에도 항상 포트설정해야함. rules 파일 수정해야함.

###velodyne pkg

http://daddynkidsmakers.blogspot.com/2019/06/odroid-veloview-ros.html

여기서 설명나온대로 그대로 따라하면 됨.
명령어 상에서 VERSION 과같이 되어있는 부분들은 내가 사용하고 있는 ros 버전 이름으로 바꿔서 적어줘야함.

LiDAR 설정단계는 다음과 같다.
터미널에서 다음 명령 입력. sudo ifconfig eth0 192.168.3.100
LiDAR IP 주소에 고정 라운트를 추가함. IP주소는 제품 CD 케이스에 포함되어 있음 (참고로 벨로다인 VLP16 라이다에 기본 설정된 IP는 192.168.1.201 임). sudo route add 192.168.XX.YY eth0 
LiDAR 설정 체크를 위해, 인터넷 브라우저에 192.168.XX.YY 입력해 세부 설정 화인

sudo apt install net-tools를 설치해야 ifconfig 사용가능

이전에 확인해줘야하는게 터미널 상에 ifconfig를 통해 라이다가 연결되어있는 ip주소를 찾고 그것을 위에 설명상에 eth0대신 입력해줘야한다.

https://gosury32.tistory.com/3
이사이트가 더 자세한거 같다. 쨋튼 eth0였나 뭘 ifconfig에서 찾은거로 바꿔줘야함.








