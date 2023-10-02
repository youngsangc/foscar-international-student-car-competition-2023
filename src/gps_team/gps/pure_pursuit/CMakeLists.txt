cmake_minimum_required(VERSION 2.8.3)
project(pure_pursuit)

find_package(
  catkin REQUIRED COMPONENTS
    pcl_conversions  
    pcl_ros
    sensor_msgs
    nav_msgs
    message_generation
    dynamic_reconfigure
    morai_msgs
    geometry_msgs
    roscpp
    roslint
    rostest
    roslib
    rosunit
    std_msgs
    tf
    tf2
    race

)

generate_dynamic_reconfigure_options(
  cfg/config.cfg
)


catkin_package(
  INCLUDE_DIRS include
)

SET(CMAKE_CXX_FLAGS "-O2 -g -Wall ${CMAKE_CXX_FLAGS}")

set(ROSLINT_CPP_OPTS "--filter=-build/c++11")

#터널 정적장애물 추가
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

roslint_cpp()

add_compile_options(-std=c++11)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)

add_compile_options(-std=c++11)

add_executable(
  pure_pursuit
  src/pure_pursuit_node.cpp
  src/pure_pursuit.cpp
  src/pure_pursuit_core.cpp
  #src/pure_pursuit_core_school.cpp
)

add_executable(
  pure_pursuit2
  src/pure_pursuit_node.cpp
  src/pure_pursuit.cpp
  #src/pure_pursuit_core_final.cpp
  src/pure_pursuit_core_semi_final.cpp
)

add_executable(
  encoder_value
  src/encoder_value.cpp
)



# add_executable(
#   pure_pursuit3
#   src/pure_pursuit_node.cpp
#   src/pure_pursuit.cpp
#   src/pure_pursuit_delivery.cpp
# )

# add_executable(
#   pure_pursuit_2_delivery
#   src/pure_pursuit_node.cpp
#   src/pure_pursuit.cpp
#   src/pure_pursuit_core2_vision.cpp
# )

# target_link_libraries(pure_pursuit_core_with_traffic ${catkin_LIBRARIES})
target_link_libraries(pure_pursuit ${catkin_LIBRARIES})
add_dependencies(pure_pursuit ${catkin_EXPORTED_TARGETS})

target_link_libraries(pure_pursuit2 ${catkin_LIBRARIES})
add_dependencies(pure_pursuit2 ${catkin_EXPORTED_TARGETS})

# target_link_libraries(pure_pursuit3 ${catkin_LIBRARIES})
# add_dependencies(pure_pursuit3 ${catkin_EXPORTED_TARGETS})

# target_link_libraries(pure_pursuit_2_delivery ${catkin_LIBRARIES})
# add_dependencies(pure_pursuit_2_delivery ${catkin_EXPORTED_TARGETS})


target_link_libraries(encoder_value ${catkin_LIBRARIES})
add_dependencies(encoder_value ${catkin_EXPORTED_TARGETS})



add_executable(coordinate2pos src/coordinate2pos.cpp)
target_link_libraries(coordinate2pos ${catkin_LIBRARIES})
add_dependencies(coordinate2pos ${catkin_EXPORTED_TARGETS})

add_executable(get_imu src/get_imu.cpp)
target_link_libraries(get_imu ${catkin_LIBRARIES})
add_dependencies(get_imu ${catkin_EXPORTED_TARGETS})

add_executable(pid_throttle src/pid_throttle.cpp)
target_link_libraries(pid_throttle ${catkin_LIBRARIES})
add_dependencies(pid_throttle ${catkin_EXPORTED_TARGETS})


add_executable(pid_throttle_2 src/pid_throttle_2.cpp)
target_link_libraries(pid_throttle_2 ${catkin_LIBRARIES})
add_dependencies(pid_throttle_2 ${catkin_EXPORTED_TARGETS})

# add_executable(get_gps_diagnostic src/get_gps_diagnostic.cpp)
# target_link_libraries(get_gps_diagnostic ${catkin_LIBRARIES})
# add_dependencies(get_gps_diagnostic ${catkin_EXPORTED_TARGETS})



install(
  TARGETS pure_pursuit
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(
  DIRECTORY launch/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/launch
)

#if(CATKIN_ENABLE_TESTING)
#  find_package(rostest REQUIRED)
#
#  add_rostest_gtest(
#    test-pure_pursuit
#    test/test_pure_pursuit.test
#    test/src/test_pure_pursuit.cpp
#    src/pure_pursuit_core.cpp
#    src/pure_pursuit.cpp src/pure_pursuit_viz.cpp
#  )
#  add_dependencies(test-pure_pursuit ${catkin_EXPORTED_TARGETS})
#  target_link_libraries(test-pure_pursuit ${catkin_LIBRARIES})

#  roslint_add_test()
#endif()
