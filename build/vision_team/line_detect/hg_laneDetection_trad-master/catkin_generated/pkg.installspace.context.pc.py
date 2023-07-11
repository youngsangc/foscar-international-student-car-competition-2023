# generated from catkin/cmake/template/pkg.context.pc.in
CATKIN_PACKAGE_PREFIX = ""
PROJECT_PKG_CONFIG_INCLUDE_DIRS = "${prefix}/include".split(';') if "${prefix}/include" != "" else []
PROJECT_CATKIN_DEPENDS = "cv_bridge;image_transport;roscpp;rospy;sensor_msgs;std_msgs".replace(';', ' ')
PKG_CONFIG_LIBRARIES_WITH_PREFIX = "-lhg_lineDetection;-lopencv".split(';') if "-lhg_lineDetection;-lopencv" != "" else []
PROJECT_NAME = "hg_lineDetection"
PROJECT_SPACE_DIR = "/home/youngsangcho/ISCC_2023/install"
PROJECT_VERSION = "0.0.0"
