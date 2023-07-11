# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "vision_distance: 6 messages, 0 services")

set(MSG_I_FLAGS "-Ivision_distance:/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(vision_distance_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg" NAME_WE)
add_custom_target(_vision_distance_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "vision_distance" "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg" NAME_WE)
add_custom_target(_vision_distance_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "vision_distance" "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg" "vision_distance/Colorcone"
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg" NAME_WE)
add_custom_target(_vision_distance_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "vision_distance" "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg" NAME_WE)
add_custom_target(_vision_distance_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "vision_distance" "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg" "vision_distance/Colorcone_lidar"
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg" NAME_WE)
add_custom_target(_vision_distance_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "vision_distance" "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg" ""
)

get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg" NAME_WE)
add_custom_target(_vision_distance_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "vision_distance" "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg" "vision_distance/Delivery"
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/vision_distance
)
_generate_msg_cpp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/vision_distance
)
_generate_msg_cpp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/vision_distance
)
_generate_msg_cpp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/vision_distance
)
_generate_msg_cpp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/vision_distance
)
_generate_msg_cpp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/vision_distance
)

### Generating Services

### Generating Module File
_generate_module_cpp(vision_distance
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/vision_distance
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(vision_distance_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(vision_distance_generate_messages vision_distance_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_cpp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_cpp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_cpp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_cpp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_cpp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_cpp _vision_distance_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(vision_distance_gencpp)
add_dependencies(vision_distance_gencpp vision_distance_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS vision_distance_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/vision_distance
)
_generate_msg_eus(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/vision_distance
)
_generate_msg_eus(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/vision_distance
)
_generate_msg_eus(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/vision_distance
)
_generate_msg_eus(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/vision_distance
)
_generate_msg_eus(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/vision_distance
)

### Generating Services

### Generating Module File
_generate_module_eus(vision_distance
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/vision_distance
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(vision_distance_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(vision_distance_generate_messages vision_distance_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_eus _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_eus _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_eus _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_eus _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_eus _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_eus _vision_distance_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(vision_distance_geneus)
add_dependencies(vision_distance_geneus vision_distance_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS vision_distance_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/vision_distance
)
_generate_msg_lisp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/vision_distance
)
_generate_msg_lisp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/vision_distance
)
_generate_msg_lisp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/vision_distance
)
_generate_msg_lisp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/vision_distance
)
_generate_msg_lisp(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/vision_distance
)

### Generating Services

### Generating Module File
_generate_module_lisp(vision_distance
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/vision_distance
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(vision_distance_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(vision_distance_generate_messages vision_distance_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_lisp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_lisp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_lisp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_lisp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_lisp _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_lisp _vision_distance_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(vision_distance_genlisp)
add_dependencies(vision_distance_genlisp vision_distance_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS vision_distance_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/vision_distance
)
_generate_msg_nodejs(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/vision_distance
)
_generate_msg_nodejs(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/vision_distance
)
_generate_msg_nodejs(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/vision_distance
)
_generate_msg_nodejs(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/vision_distance
)
_generate_msg_nodejs(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/vision_distance
)

### Generating Services

### Generating Module File
_generate_module_nodejs(vision_distance
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/vision_distance
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(vision_distance_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(vision_distance_generate_messages vision_distance_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_nodejs _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_nodejs _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_nodejs _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_nodejs _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_nodejs _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_nodejs _vision_distance_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(vision_distance_gennodejs)
add_dependencies(vision_distance_gennodejs vision_distance_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS vision_distance_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance
)
_generate_msg_py(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance
)
_generate_msg_py(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance
)
_generate_msg_py(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance
)
_generate_msg_py(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance
)
_generate_msg_py(vision_distance
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg"
  "${MSG_I_FLAGS}"
  "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance
)

### Generating Services

### Generating Module File
_generate_module_py(vision_distance
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(vision_distance_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(vision_distance_generate_messages vision_distance_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_py _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_py _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Colorcone_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_py _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/ColorconeArray_lidar.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_py _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/Delivery.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_py _vision_distance_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/msg/DeliveryArray.msg" NAME_WE)
add_dependencies(vision_distance_generate_messages_py _vision_distance_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(vision_distance_genpy)
add_dependencies(vision_distance_genpy vision_distance_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS vision_distance_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/vision_distance)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/vision_distance
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(vision_distance_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/vision_distance)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/vision_distance
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(vision_distance_generate_messages_eus std_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/vision_distance)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/vision_distance
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(vision_distance_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/vision_distance)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/vision_distance
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(vision_distance_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/vision_distance
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(vision_distance_generate_messages_py std_msgs_generate_messages_py)
endif()
