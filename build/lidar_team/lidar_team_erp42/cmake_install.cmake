# Install script for directory: /home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/youngsangcho/ISCC_2023/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/lidar_team_erp42/msg" TYPE FILE FILES
    "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg"
    "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg"
    "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg"
    "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg"
    "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/lidar_team_erp42/cmake" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/build/lidar_team/lidar_team_erp42/catkin_generated/installspace/lidar_team_erp42-msg-paths.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/home/youngsangcho/ISCC_2023/devel/include/lidar_team_erp42")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/roseus/ros" TYPE DIRECTORY FILES "/home/youngsangcho/ISCC_2023/devel/share/roseus/ros/lidar_team_erp42")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/home/youngsangcho/ISCC_2023/devel/share/common-lisp/ros/lidar_team_erp42")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gennodejs/ros" TYPE DIRECTORY FILES "/home/youngsangcho/ISCC_2023/devel/share/gennodejs/ros/lidar_team_erp42")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/usr/bin/python3" -m compileall "/home/youngsangcho/ISCC_2023/devel/lib/python3/dist-packages/lidar_team_erp42")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages" TYPE DIRECTORY FILES "/home/youngsangcho/ISCC_2023/devel/lib/python3/dist-packages/lidar_team_erp42")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lidar_team_erp42" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/devel/include/lidar_team_erp42/hyper_parameterConfig.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lidar_team_erp42" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/devel/include/lidar_team_erp42/dy_hyper_parameterConfig.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lidar_team_erp42" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/devel/include/lidar_team_erp42/small_st_hyper_parameterConfig.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lidar_team_erp42" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/devel/include/lidar_team_erp42/large_st_hyper_parameterConfig.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lidar_team_erp42" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/devel/include/lidar_team_erp42/de_hyper_parameterConfig.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lidar_team_erp42" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/devel/include/lidar_team_erp42/pk_hyper_parameterConfig.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lidar_team_erp42" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/devel/include/lidar_team_erp42/uturn_hyper_parameterConfig.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages/lidar_team_erp42" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/devel/lib/python3/dist-packages/lidar_team_erp42/__init__.py")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/usr/bin/python3" -m compileall "/home/youngsangcho/ISCC_2023/devel/lib/python3/dist-packages/lidar_team_erp42/cfg")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages/lidar_team_erp42" TYPE DIRECTORY FILES "/home/youngsangcho/ISCC_2023/devel/lib/python3/dist-packages/lidar_team_erp42/cfg")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/build/lidar_team/lidar_team_erp42/catkin_generated/installspace/lidar_team_erp42.pc")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/lidar_team_erp42/cmake" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/build/lidar_team/lidar_team_erp42/catkin_generated/installspace/lidar_team_erp42-msg-extras.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/lidar_team_erp42/cmake" TYPE FILE FILES
    "/home/youngsangcho/ISCC_2023/build/lidar_team/lidar_team_erp42/catkin_generated/installspace/lidar_team_erp42Config.cmake"
    "/home/youngsangcho/ISCC_2023/build/lidar_team/lidar_team_erp42/catkin_generated/installspace/lidar_team_erp42Config-version.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/lidar_team_erp42" TYPE FILE FILES "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/package.xml")
endif()

