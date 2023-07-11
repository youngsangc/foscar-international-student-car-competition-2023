# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "track_race: 3 messages, 0 services")

set(MSG_I_FLAGS "-Itrack_race:/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(track_race_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg" NAME_WE)
add_custom_target(_track_race_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "track_race" "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg" NAME_WE)
add_custom_target(_track_race_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "track_race" "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg" NAME_WE)
add_custom_target(_track_race_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "track_race" "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg" ""
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/track_race
)
_generate_msg_cpp(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/track_race
)
_generate_msg_cpp(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/track_race
)

### Generating Services

### Generating Module File
_generate_module_cpp(track_race
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/track_race
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(track_race_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(track_race_generate_messages track_race_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg" NAME_WE)
add_dependencies(track_race_generate_messages_cpp _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg" NAME_WE)
add_dependencies(track_race_generate_messages_cpp _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg" NAME_WE)
add_dependencies(track_race_generate_messages_cpp _track_race_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(track_race_gencpp)
add_dependencies(track_race_gencpp track_race_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS track_race_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/track_race
)
_generate_msg_eus(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/track_race
)
_generate_msg_eus(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/track_race
)

### Generating Services

### Generating Module File
_generate_module_eus(track_race
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/track_race
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(track_race_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(track_race_generate_messages track_race_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg" NAME_WE)
add_dependencies(track_race_generate_messages_eus _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg" NAME_WE)
add_dependencies(track_race_generate_messages_eus _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg" NAME_WE)
add_dependencies(track_race_generate_messages_eus _track_race_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(track_race_geneus)
add_dependencies(track_race_geneus track_race_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS track_race_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/track_race
)
_generate_msg_lisp(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/track_race
)
_generate_msg_lisp(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/track_race
)

### Generating Services

### Generating Module File
_generate_module_lisp(track_race
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/track_race
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(track_race_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(track_race_generate_messages track_race_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg" NAME_WE)
add_dependencies(track_race_generate_messages_lisp _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg" NAME_WE)
add_dependencies(track_race_generate_messages_lisp _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg" NAME_WE)
add_dependencies(track_race_generate_messages_lisp _track_race_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(track_race_genlisp)
add_dependencies(track_race_genlisp track_race_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS track_race_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/track_race
)
_generate_msg_nodejs(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/track_race
)
_generate_msg_nodejs(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/track_race
)

### Generating Services

### Generating Module File
_generate_module_nodejs(track_race
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/track_race
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(track_race_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(track_race_generate_messages track_race_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg" NAME_WE)
add_dependencies(track_race_generate_messages_nodejs _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg" NAME_WE)
add_dependencies(track_race_generate_messages_nodejs _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg" NAME_WE)
add_dependencies(track_race_generate_messages_nodejs _track_race_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(track_race_gennodejs)
add_dependencies(track_race_gennodejs track_race_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS track_race_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/track_race
)
_generate_msg_py(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/track_race
)
_generate_msg_py(track_race
  "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/track_race
)

### Generating Services

### Generating Module File
_generate_module_py(track_race
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/track_race
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(track_race_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(track_race_generate_messages track_race_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Velocity.msg" NAME_WE)
add_dependencies(track_race_generate_messages_py _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Steering.msg" NAME_WE)
add_dependencies(track_race_generate_messages_py _track_race_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/lidar_team/track_race/msg/Test.msg" NAME_WE)
add_dependencies(track_race_generate_messages_py _track_race_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(track_race_genpy)
add_dependencies(track_race_genpy track_race_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS track_race_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/track_race)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/track_race
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(track_race_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/track_race)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/track_race
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(track_race_generate_messages_eus std_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/track_race)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/track_race
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(track_race_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/track_race)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/track_race
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(track_race_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/track_race)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/track_race\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/track_race
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(track_race_generate_messages_py std_msgs_generate_messages_py)
endif()
