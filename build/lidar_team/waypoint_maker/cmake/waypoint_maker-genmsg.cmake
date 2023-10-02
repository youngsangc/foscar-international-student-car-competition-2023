# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "waypoint_maker: 4 messages, 0 services")

set(MSG_I_FLAGS "-Iwaypoint_maker:/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg;-Isensor_msgs:/opt/ros/noetic/share/sensor_msgs/cmake/../msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/noetic/share/geometry_msgs/cmake/../msg;-Inav_msgs:/opt/ros/noetic/share/nav_msgs/cmake/../msg;-Imorai_msgs:/home/youngsangcho/ISCC_2023/src/morai_msgs/msg;-Iactionlib_msgs:/opt/ros/noetic/share/actionlib_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(waypoint_maker_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg" NAME_WE)
add_custom_target(_waypoint_maker_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "waypoint_maker" "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg" NAME_WE)
add_custom_target(_waypoint_maker_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "waypoint_maker" "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg" NAME_WE)
add_custom_target(_waypoint_maker_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "waypoint_maker" "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg" NAME_WE)
add_custom_target(_waypoint_maker_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "waypoint_maker" "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg" ""
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_maker
)
_generate_msg_cpp(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_maker
)
_generate_msg_cpp(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_maker
)
_generate_msg_cpp(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_maker
)

### Generating Services

### Generating Module File
_generate_module_cpp(waypoint_maker
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_maker
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(waypoint_maker_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(waypoint_maker_generate_messages waypoint_maker_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_cpp _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_cpp _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_cpp _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_cpp _waypoint_maker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_maker_gencpp)
add_dependencies(waypoint_maker_gencpp waypoint_maker_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_maker_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_maker
)
_generate_msg_eus(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_maker
)
_generate_msg_eus(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_maker
)
_generate_msg_eus(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_maker
)

### Generating Services

### Generating Module File
_generate_module_eus(waypoint_maker
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_maker
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(waypoint_maker_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(waypoint_maker_generate_messages waypoint_maker_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_eus _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_eus _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_eus _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_eus _waypoint_maker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_maker_geneus)
add_dependencies(waypoint_maker_geneus waypoint_maker_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_maker_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_maker
)
_generate_msg_lisp(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_maker
)
_generate_msg_lisp(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_maker
)
_generate_msg_lisp(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_maker
)

### Generating Services

### Generating Module File
_generate_module_lisp(waypoint_maker
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_maker
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(waypoint_maker_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(waypoint_maker_generate_messages waypoint_maker_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_lisp _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_lisp _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_lisp _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_lisp _waypoint_maker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_maker_genlisp)
add_dependencies(waypoint_maker_genlisp waypoint_maker_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_maker_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_maker
)
_generate_msg_nodejs(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_maker
)
_generate_msg_nodejs(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_maker
)
_generate_msg_nodejs(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_maker
)

### Generating Services

### Generating Module File
_generate_module_nodejs(waypoint_maker
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_maker
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(waypoint_maker_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(waypoint_maker_generate_messages waypoint_maker_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_nodejs _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_nodejs _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_nodejs _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_nodejs _waypoint_maker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_maker_gennodejs)
add_dependencies(waypoint_maker_gennodejs waypoint_maker_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_maker_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_maker
)
_generate_msg_py(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_maker
)
_generate_msg_py(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_maker
)
_generate_msg_py(waypoint_maker
  "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_maker
)

### Generating Services

### Generating Module File
_generate_module_py(waypoint_maker
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_maker
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(waypoint_maker_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(waypoint_maker_generate_messages waypoint_maker_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Waypoint.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_py _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/Boundingbox.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_py _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/DynamicVelocity.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_py _waypoint_maker_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/waypoint_maker/msg/ObjectInfo.msg" NAME_WE)
add_dependencies(waypoint_maker_generate_messages_py _waypoint_maker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(waypoint_maker_genpy)
add_dependencies(waypoint_maker_genpy waypoint_maker_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS waypoint_maker_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_maker)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/waypoint_maker
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_cpp)
  add_dependencies(waypoint_maker_generate_messages_cpp sensor_msgs_generate_messages_cpp)
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(waypoint_maker_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(waypoint_maker_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()
if(TARGET nav_msgs_generate_messages_cpp)
  add_dependencies(waypoint_maker_generate_messages_cpp nav_msgs_generate_messages_cpp)
endif()
if(TARGET morai_msgs_generate_messages_cpp)
  add_dependencies(waypoint_maker_generate_messages_cpp morai_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_maker)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/waypoint_maker
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_eus)
  add_dependencies(waypoint_maker_generate_messages_eus sensor_msgs_generate_messages_eus)
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(waypoint_maker_generate_messages_eus std_msgs_generate_messages_eus)
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(waypoint_maker_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()
if(TARGET nav_msgs_generate_messages_eus)
  add_dependencies(waypoint_maker_generate_messages_eus nav_msgs_generate_messages_eus)
endif()
if(TARGET morai_msgs_generate_messages_eus)
  add_dependencies(waypoint_maker_generate_messages_eus morai_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_maker)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/waypoint_maker
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_lisp)
  add_dependencies(waypoint_maker_generate_messages_lisp sensor_msgs_generate_messages_lisp)
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(waypoint_maker_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(waypoint_maker_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()
if(TARGET nav_msgs_generate_messages_lisp)
  add_dependencies(waypoint_maker_generate_messages_lisp nav_msgs_generate_messages_lisp)
endif()
if(TARGET morai_msgs_generate_messages_lisp)
  add_dependencies(waypoint_maker_generate_messages_lisp morai_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_maker)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/waypoint_maker
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_nodejs)
  add_dependencies(waypoint_maker_generate_messages_nodejs sensor_msgs_generate_messages_nodejs)
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(waypoint_maker_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(waypoint_maker_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()
if(TARGET nav_msgs_generate_messages_nodejs)
  add_dependencies(waypoint_maker_generate_messages_nodejs nav_msgs_generate_messages_nodejs)
endif()
if(TARGET morai_msgs_generate_messages_nodejs)
  add_dependencies(waypoint_maker_generate_messages_nodejs morai_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_maker)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_maker\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/waypoint_maker
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET sensor_msgs_generate_messages_py)
  add_dependencies(waypoint_maker_generate_messages_py sensor_msgs_generate_messages_py)
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(waypoint_maker_generate_messages_py std_msgs_generate_messages_py)
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(waypoint_maker_generate_messages_py geometry_msgs_generate_messages_py)
endif()
if(TARGET nav_msgs_generate_messages_py)
  add_dependencies(waypoint_maker_generate_messages_py nav_msgs_generate_messages_py)
endif()
if(TARGET morai_msgs_generate_messages_py)
  add_dependencies(waypoint_maker_generate_messages_py morai_msgs_generate_messages_py)
endif()
