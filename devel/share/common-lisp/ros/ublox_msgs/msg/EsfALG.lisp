; Auto-generated. Do not edit!


(cl:in-package ublox_msgs-msg)


;//! \htmlinclude EsfALG.msg.html

(cl:defclass <EsfALG> (roslisp-msg-protocol:ros-message)
  ((iTOW
    :reader iTOW
    :initarg :iTOW
    :type cl:integer
    :initform 0)
   (version
    :reader version
    :initarg :version
    :type cl:fixnum
    :initform 0)
   (flags
    :reader flags
    :initarg :flags
    :type cl:fixnum
    :initform 0)
   (errors
    :reader errors
    :initarg :errors
    :type cl:fixnum
    :initform 0)
   (reserved0
    :reader reserved0
    :initarg :reserved0
    :type cl:fixnum
    :initform 0)
   (yaw
    :reader yaw
    :initarg :yaw
    :type cl:integer
    :initform 0)
   (pitch
    :reader pitch
    :initarg :pitch
    :type cl:fixnum
    :initform 0)
   (roll
    :reader roll
    :initarg :roll
    :type cl:fixnum
    :initform 0))
)

(cl:defclass EsfALG (<EsfALG>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <EsfALG>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'EsfALG)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ublox_msgs-msg:<EsfALG> is deprecated: use ublox_msgs-msg:EsfALG instead.")))

(cl:ensure-generic-function 'iTOW-val :lambda-list '(m))
(cl:defmethod iTOW-val ((m <EsfALG>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:iTOW-val is deprecated.  Use ublox_msgs-msg:iTOW instead.")
  (iTOW m))

(cl:ensure-generic-function 'version-val :lambda-list '(m))
(cl:defmethod version-val ((m <EsfALG>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:version-val is deprecated.  Use ublox_msgs-msg:version instead.")
  (version m))

(cl:ensure-generic-function 'flags-val :lambda-list '(m))
(cl:defmethod flags-val ((m <EsfALG>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:flags-val is deprecated.  Use ublox_msgs-msg:flags instead.")
  (flags m))

(cl:ensure-generic-function 'errors-val :lambda-list '(m))
(cl:defmethod errors-val ((m <EsfALG>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:errors-val is deprecated.  Use ublox_msgs-msg:errors instead.")
  (errors m))

(cl:ensure-generic-function 'reserved0-val :lambda-list '(m))
(cl:defmethod reserved0-val ((m <EsfALG>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:reserved0-val is deprecated.  Use ublox_msgs-msg:reserved0 instead.")
  (reserved0 m))

(cl:ensure-generic-function 'yaw-val :lambda-list '(m))
(cl:defmethod yaw-val ((m <EsfALG>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:yaw-val is deprecated.  Use ublox_msgs-msg:yaw instead.")
  (yaw m))

(cl:ensure-generic-function 'pitch-val :lambda-list '(m))
(cl:defmethod pitch-val ((m <EsfALG>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:pitch-val is deprecated.  Use ublox_msgs-msg:pitch instead.")
  (pitch m))

(cl:ensure-generic-function 'roll-val :lambda-list '(m))
(cl:defmethod roll-val ((m <EsfALG>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:roll-val is deprecated.  Use ublox_msgs-msg:roll instead.")
  (roll m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<EsfALG>)))
    "Constants for message type '<EsfALG>"
  '((:CLASS_ID . 16)
    (:MESSAGE_ID . 20)
    (:FLAGS_AUTO_MNT_ALG_ON . 0)
    (:FLAGS_STATUS . 14)
    (:FLAGS_STATUS_USER_FIXED_ANGLES_USED . 0)
    (:FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING . 1)
    (:FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING . 2)
    (:FLAGS_STATUS_COARSE_ALIGNMENT_USED . 3)
    (:FLAGS_STATUS_FINE_ALIGNEMENT_USED . 4)
    (:ERROR_TILT_ARG_ERROR . 1)
    (:ERROR_YAW_ARG_ERROR . 2)
    (:ERROR_ANGLE_ERROR . 3))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'EsfALG)))
    "Constants for message type 'EsfALG"
  '((:CLASS_ID . 16)
    (:MESSAGE_ID . 20)
    (:FLAGS_AUTO_MNT_ALG_ON . 0)
    (:FLAGS_STATUS . 14)
    (:FLAGS_STATUS_USER_FIXED_ANGLES_USED . 0)
    (:FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING . 1)
    (:FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING . 2)
    (:FLAGS_STATUS_COARSE_ALIGNMENT_USED . 3)
    (:FLAGS_STATUS_FINE_ALIGNEMENT_USED . 4)
    (:ERROR_TILT_ARG_ERROR . 1)
    (:ERROR_YAW_ARG_ERROR . 2)
    (:ERROR_ANGLE_ERROR . 3))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <EsfALG>) ostream)
  "Serializes a message object of type '<EsfALG>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'version)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'flags)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'errors)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'reserved0)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'yaw)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'yaw)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'yaw)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'yaw)) ostream)
  (cl:let* ((signed (cl:slot-value msg 'pitch)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'roll)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <EsfALG>) istream)
  "Deserializes a message object of type '<EsfALG>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'version)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'flags)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'errors)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'reserved0)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'yaw)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'yaw)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'yaw)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'yaw)) (cl:read-byte istream))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'pitch) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'roll) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<EsfALG>)))
  "Returns string type for a message object of type '<EsfALG>"
  "ublox_msgs/EsfALG")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'EsfALG)))
  "Returns string type for a message object of type 'EsfALG"
  "ublox_msgs/EsfALG")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<EsfALG>)))
  "Returns md5sum for a message object of type '<EsfALG>"
  "9a16c82ca78b0658bd506bfde3a1b262")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'EsfALG)))
  "Returns md5sum for a message object of type 'EsfALG"
  "9a16c82ca78b0658bd506bfde3a1b262")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<EsfALG>)))
  "Returns full string definition for message of type '<EsfALG>"
  (cl:format cl:nil "# ESF-ALG (0x10 0x14)~%# IMU alignment information~%#~%# This message outputs the IMU alignment angles which define the rotation from the installation-frame to the~%# IMU-frame. In addition, it indicates the automatic IMU-mount alignment status.~%#~%~%uint8 CLASS_ID = 16~%uint8 MESSAGE_ID = 20~%~%uint8 FLAGS_AUTO_MNT_ALG_ON = 0~%uint32 FLAGS_STATUS = 14~%~%uint8 FLAGS_STATUS_USER_FIXED_ANGLES_USED = 0~%uint8 FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING = 1~%uint8 FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING = 2~%uint8 FLAGS_STATUS_COARSE_ALIGNMENT_USED = 3~%uint8 FLAGS_STATUS_FINE_ALIGNEMENT_USED = 4~%~%uint8 ERROR_TILT_ARG_ERROR = 1~%uint8 ERROR_YAW_ARG_ERROR = 2~%uint8 ERROR_ANGLE_ERROR = 3~%~%uint32 iTOW~%uint8 version~%uint8 flags~%uint8 errors~%uint8 reserved0~%uint32 yaw # IMU-mount yaw angle [0, 360]~%int16 pitch # IMU-mount pitch angle [-90, 90]~%int16 roll # IMU-mount roll angle [-180, 180]~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'EsfALG)))
  "Returns full string definition for message of type 'EsfALG"
  (cl:format cl:nil "# ESF-ALG (0x10 0x14)~%# IMU alignment information~%#~%# This message outputs the IMU alignment angles which define the rotation from the installation-frame to the~%# IMU-frame. In addition, it indicates the automatic IMU-mount alignment status.~%#~%~%uint8 CLASS_ID = 16~%uint8 MESSAGE_ID = 20~%~%uint8 FLAGS_AUTO_MNT_ALG_ON = 0~%uint32 FLAGS_STATUS = 14~%~%uint8 FLAGS_STATUS_USER_FIXED_ANGLES_USED = 0~%uint8 FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING = 1~%uint8 FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING = 2~%uint8 FLAGS_STATUS_COARSE_ALIGNMENT_USED = 3~%uint8 FLAGS_STATUS_FINE_ALIGNEMENT_USED = 4~%~%uint8 ERROR_TILT_ARG_ERROR = 1~%uint8 ERROR_YAW_ARG_ERROR = 2~%uint8 ERROR_ANGLE_ERROR = 3~%~%uint32 iTOW~%uint8 version~%uint8 flags~%uint8 errors~%uint8 reserved0~%uint32 yaw # IMU-mount yaw angle [0, 360]~%int16 pitch # IMU-mount pitch angle [-90, 90]~%int16 roll # IMU-mount roll angle [-180, 180]~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <EsfALG>))
  (cl:+ 0
     4
     1
     1
     1
     1
     4
     2
     2
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <EsfALG>))
  "Converts a ROS message object to a list"
  (cl:list 'EsfALG
    (cl:cons ':iTOW (iTOW msg))
    (cl:cons ':version (version msg))
    (cl:cons ':flags (flags msg))
    (cl:cons ':errors (errors msg))
    (cl:cons ':reserved0 (reserved0 msg))
    (cl:cons ':yaw (yaw msg))
    (cl:cons ':pitch (pitch msg))
    (cl:cons ':roll (roll msg))
))
