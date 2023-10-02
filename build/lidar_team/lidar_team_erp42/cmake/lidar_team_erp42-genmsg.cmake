# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "lidar_team_erp42: 5 messages, 0 services")

set(MSG_I_FLAGS "-Ilidar_team_erp42:/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg;-Isensor_msgs:/opt/ros/noetic/share/sensor_msgs/cmake/../msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/noetic/share/geometry_msgs/cmake/../msg;-Inav_msgs:/opt/ros/noetic/share/nav_msgs/cmake/../msg;-Iactionlib_msgs:/opt/ros/noetic/share/actionlib_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(lidar_team_erp42_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg" NAME_WE)
add_custom_target(_lidar_team_erp42_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "lidar_team_erp42" "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg" NAME_WE)
add_custom_target(_lidar_team_erp42_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "lidar_team_erp42" "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg" NAME_WE)
add_custom_target(_lidar_team_erp42_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "lidar_team_erp42" "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg" NAME_WE)
add_custom_target(_lidar_team_erp42_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "lidar_team_erp42" "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg" NAME_WE)
add_custom_target(_lidar_team_erp42_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "lidar_team_erp42" "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg" ""
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_cpp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_cpp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_cpp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_cpp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/lidar_team_erp42
)

### Generating Services

### Generating Module File
_generate_module_cpp(lidar_team_erp42
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/lidar_team_erp42
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(lidar_team_erp42_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(lidar_team_erp42_generate_messages lidar_team_erp42_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_cpp _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_cpp _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_cpp _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_cpp _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_cpp _lidar_team_erp42_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(lidar_team_erp42_gencpp)
add_dependencies(lidar_team_erp42_gencpp lidar_team_erp42_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS lidar_team_erp42_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_eus(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_eus(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_eus(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_eus(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/lidar_team_erp42
)

### Generating Services

### Generating Module File
_generate_module_eus(lidar_team_erp42
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/lidar_team_erp42
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(lidar_team_erp42_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(lidar_team_erp42_generate_messages lidar_team_erp42_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_eus _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_eus _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_eus _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_eus _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_eus _lidar_team_erp42_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(lidar_team_erp42_geneus)
add_dependencies(lidar_team_erp42_geneus lidar_team_erp42_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS lidar_team_erp42_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_lisp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_lisp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_lisp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_lisp(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/lidar_team_erp42
)

### Generating Services

### Generating Module File
_generate_module_lisp(lidar_team_erp42
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/lidar_team_erp42
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(lidar_team_erp42_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(lidar_team_erp42_generate_messages lidar_team_erp42_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_lisp _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_lisp _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_lisp _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_lisp _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_lisp _lidar_team_erp42_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(lidar_team_erp42_genlisp)
add_dependencies(lidar_team_erp42_genlisp lidar_team_erp42_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS lidar_team_erp42_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_nodejs(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_nodejs(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_nodejs(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_nodejs(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/lidar_team_erp42
)

### Generating Services

### Generating Module File
_generate_module_nodejs(lidar_team_erp42
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/lidar_team_erp42
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(lidar_team_erp42_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(lidar_team_erp42_generate_messages lidar_team_erp42_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_nodejs _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_nodejs _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_nodejs _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_nodejs _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_nodejs _lidar_team_erp42_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(lidar_team_erp42_gennodejs)
add_dependencies(lidar_team_erp42_gennodejs lidar_team_erp42_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS lidar_team_erp42_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_py(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_py(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_py(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/lidar_team_erp42
)
_generate_msg_py(lidar_team_erp42
  "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/lidar_team_erp42
)

### Generating Services

### Generating Module File
_generate_module_py(lidar_team_erp42
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/lidar_team_erp42
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(lidar_team_erp42_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(lidar_team_erp42_generate_messages lidar_team_erp42_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Waypoint.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_py _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Boundingbox.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_py _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DriveValues.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_py _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/Delivery.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_py _lidar_team_erp42_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/lidar_team_erp42/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(lidar_team_erp42_generate_messages_py _lidar_team_erp42_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(lidar_team_erp42_genpy)
add_dependencies(lidar_team_erp42_genpy lidar_team_erp42_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS lidar_team_erp42_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/lidar_team_erp42)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/lidar_team_erp42
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_cpp)
  add_dependencies(lidar_team_erp42_generate_messages_cpp sensor_msgs_generate_messages_cpp)
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(lidar_team_erp42_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(lidar_team_erp42_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()
if(TARGET nav_msgs_generate_messages_cpp)
  add_dependencies(lidar_team_erp42_generate_messages_cpp nav_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/lidar_team_erp42)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/lidar_team_erp42
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_eus)
  add_dependencies(lidar_team_erp42_generate_messages_eus sensor_msgs_generate_messages_eus)
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(lidar_team_erp42_generate_messages_eus std_msgs_generate_messages_eus)
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(lidar_team_erp42_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()
if(TARGET nav_msgs_generate_messages_eus)
  add_dependencies(lidar_team_erp42_generate_messages_eus nav_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/lidar_team_erp42)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/lidar_team_erp42
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_lisp)
  add_dependencies(lidar_team_erp42_generate_messages_lisp sensor_msgs_generate_messages_lisp)
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(lidar_team_erp42_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(lidar_team_erp42_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()
if(TARGET nav_msgs_generate_messages_lisp)
  add_dependencies(lidar_team_erp42_generate_messages_lisp nav_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/lidar_team_erp42)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/lidar_team_erp42
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_nodejs)
  add_dependencies(lidar_team_erp42_generate_messages_nodejs sensor_msgs_generate_messages_nodejs)
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(lidar_team_erp42_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(lidar_team_erp42_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()
if(TARGET nav_msgs_generate_messages_nodejs)
  add_dependencies(lidar_team_erp42_generate_messages_nodejs nav_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/lidar_team_erp42)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/lidar_team_erp42\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/lidar_team_erp42
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_py)
  add_dependencies(lidar_team_erp42_generate_messages_py sensor_msgs_generate_messages_py)
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(lidar_team_erp42_generate_messages_py std_msgs_generate_messages_py)
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(lidar_team_erp42_generate_messages_py geometry_msgs_generate_messages_py)
endif()
if(TARGET nav_msgs_generate_messages_py)
  add_dependencies(lidar_team_erp42_generate_messages_py nav_msgs_generate_messages_py)
endif()
