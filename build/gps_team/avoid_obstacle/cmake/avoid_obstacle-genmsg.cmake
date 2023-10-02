# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "avoid_obstacle: 3 messages, 0 services")

set(MSG_I_FLAGS "-Iavoid_obstacle:/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(avoid_obstacle_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg" NAME_WE)
add_custom_target(_avoid_obstacle_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "avoid_obstacle" "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg" NAME_WE)
add_custom_target(_avoid_obstacle_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "avoid_obstacle" "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg" "avoid_obstacle/PointObstacles"
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg" NAME_WE)
add_custom_target(_avoid_obstacle_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "avoid_obstacle" "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg" ""
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_cpp(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_cpp(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/avoid_obstacle
)

### Generating Services

### Generating Module File
_generate_module_cpp(avoid_obstacle
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/avoid_obstacle
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(avoid_obstacle_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(avoid_obstacle_generate_messages avoid_obstacle_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_cpp _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_cpp _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_cpp _avoid_obstacle_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(avoid_obstacle_gencpp)
add_dependencies(avoid_obstacle_gencpp avoid_obstacle_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS avoid_obstacle_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_eus(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_eus(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/avoid_obstacle
)

### Generating Services

### Generating Module File
_generate_module_eus(avoid_obstacle
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/avoid_obstacle
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(avoid_obstacle_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(avoid_obstacle_generate_messages avoid_obstacle_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_eus _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_eus _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_eus _avoid_obstacle_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(avoid_obstacle_geneus)
add_dependencies(avoid_obstacle_geneus avoid_obstacle_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS avoid_obstacle_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_lisp(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_lisp(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/avoid_obstacle
)

### Generating Services

### Generating Module File
_generate_module_lisp(avoid_obstacle
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/avoid_obstacle
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(avoid_obstacle_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(avoid_obstacle_generate_messages avoid_obstacle_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_lisp _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_lisp _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_lisp _avoid_obstacle_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(avoid_obstacle_genlisp)
add_dependencies(avoid_obstacle_genlisp avoid_obstacle_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS avoid_obstacle_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_nodejs(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_nodejs(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/avoid_obstacle
)

### Generating Services

### Generating Module File
_generate_module_nodejs(avoid_obstacle
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/avoid_obstacle
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(avoid_obstacle_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(avoid_obstacle_generate_messages avoid_obstacle_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_nodejs _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_nodejs _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_nodejs _avoid_obstacle_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(avoid_obstacle_gennodejs)
add_dependencies(avoid_obstacle_gennodejs avoid_obstacle_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS avoid_obstacle_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_py(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/avoid_obstacle
)
_generate_msg_py(avoid_obstacle
  "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/avoid_obstacle
)

### Generating Services

### Generating Module File
_generate_module_py(avoid_obstacle
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/avoid_obstacle
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(avoid_obstacle_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(avoid_obstacle_generate_messages avoid_obstacle_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/PointObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_py _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/DetectedObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_py _avoid_obstacle_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/gps_team/avoid_obstacle/msg/TrueObstacles.msg" NAME_WE)
add_dependencies(avoid_obstacle_generate_messages_py _avoid_obstacle_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(avoid_obstacle_genpy)
add_dependencies(avoid_obstacle_genpy avoid_obstacle_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS avoid_obstacle_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/avoid_obstacle)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/avoid_obstacle
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(avoid_obstacle_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/avoid_obstacle)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/avoid_obstacle
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(avoid_obstacle_generate_messages_eus std_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/avoid_obstacle)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/avoid_obstacle
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(avoid_obstacle_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/avoid_obstacle)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/avoid_obstacle
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(avoid_obstacle_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/avoid_obstacle)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/avoid_obstacle\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/avoid_obstacle
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(avoid_obstacle_generate_messages_py std_msgs_generate_messages_py)
endif()
