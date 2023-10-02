; Auto-generated. Do not edit!


(cl:in-package ublox_msgs-msg)


;//! \htmlinclude NavHPPOSLLH.msg.html

(cl:defclass <NavHPPOSLLH> (roslisp-msg-protocol:ros-message)
  ((version
    :reader version
    :initarg :version
    :type cl:fixnum
    :initform 0)
   (reserved1
    :reader reserved1
    :initarg :reserved1
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 2 :element-type 'cl:fixnum :initial-element 0))
   (invalid_llh
    :reader invalid_llh
    :initarg :invalid_llh
    :type cl:fixnum
    :initform 0)
   (iTOW
    :reader iTOW
    :initarg :iTOW
    :type cl:integer
    :initform 0)
   (lon
    :reader lon
    :initarg :lon
    :type cl:integer
    :initform 0)
   (lat
    :reader lat
    :initarg :lat
    :type cl:integer
    :initform 0)
   (height
    :reader height
    :initarg :height
    :type cl:integer
    :initform 0)
   (hMSL
    :reader hMSL
    :initarg :hMSL
    :type cl:integer
    :initform 0)
   (lonHp
    :reader lonHp
    :initarg :lonHp
    :type cl:fixnum
    :initform 0)
   (latHp
    :reader latHp
    :initarg :latHp
    :type cl:fixnum
    :initform 0)
   (heightHp
    :reader heightHp
    :initarg :heightHp
    :type cl:fixnum
    :initform 0)
   (hMSLHp
    :reader hMSLHp
    :initarg :hMSLHp
    :type cl:fixnum
    :initform 0)
   (hAcc
    :reader hAcc
    :initarg :hAcc
    :type cl:integer
    :initform 0)
   (vAcc
    :reader vAcc
    :initarg :vAcc
    :type cl:integer
    :initform 0))
)

(cl:defclass NavHPPOSLLH (<NavHPPOSLLH>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <NavHPPOSLLH>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'NavHPPOSLLH)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ublox_msgs-msg:<NavHPPOSLLH> is deprecated: use ublox_msgs-msg:NavHPPOSLLH instead.")))

(cl:ensure-generic-function 'version-val :lambda-list '(m))
(cl:defmethod version-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:version-val is deprecated.  Use ublox_msgs-msg:version instead.")
  (version m))

(cl:ensure-generic-function 'reserved1-val :lambda-list '(m))
(cl:defmethod reserved1-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:reserved1-val is deprecated.  Use ublox_msgs-msg:reserved1 instead.")
  (reserved1 m))

(cl:ensure-generic-function 'invalid_llh-val :lambda-list '(m))
(cl:defmethod invalid_llh-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:invalid_llh-val is deprecated.  Use ublox_msgs-msg:invalid_llh instead.")
  (invalid_llh m))

(cl:ensure-generic-function 'iTOW-val :lambda-list '(m))
(cl:defmethod iTOW-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:iTOW-val is deprecated.  Use ublox_msgs-msg:iTOW instead.")
  (iTOW m))

(cl:ensure-generic-function 'lon-val :lambda-list '(m))
(cl:defmethod lon-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:lon-val is deprecated.  Use ublox_msgs-msg:lon instead.")
  (lon m))

(cl:ensure-generic-function 'lat-val :lambda-list '(m))
(cl:defmethod lat-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:lat-val is deprecated.  Use ublox_msgs-msg:lat instead.")
  (lat m))

(cl:ensure-generic-function 'height-val :lambda-list '(m))
(cl:defmethod height-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:height-val is deprecated.  Use ublox_msgs-msg:height instead.")
  (height m))

(cl:ensure-generic-function 'hMSL-val :lambda-list '(m))
(cl:defmethod hMSL-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:hMSL-val is deprecated.  Use ublox_msgs-msg:hMSL instead.")
  (hMSL m))

(cl:ensure-generic-function 'lonHp-val :lambda-list '(m))
(cl:defmethod lonHp-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:lonHp-val is deprecated.  Use ublox_msgs-msg:lonHp instead.")
  (lonHp m))

(cl:ensure-generic-function 'latHp-val :lambda-list '(m))
(cl:defmethod latHp-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:latHp-val is deprecated.  Use ublox_msgs-msg:latHp instead.")
  (latHp m))

(cl:ensure-generic-function 'heightHp-val :lambda-list '(m))
(cl:defmethod heightHp-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:heightHp-val is deprecated.  Use ublox_msgs-msg:heightHp instead.")
  (heightHp m))

(cl:ensure-generic-function 'hMSLHp-val :lambda-list '(m))
(cl:defmethod hMSLHp-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:hMSLHp-val is deprecated.  Use ublox_msgs-msg:hMSLHp instead.")
  (hMSLHp m))

(cl:ensure-generic-function 'hAcc-val :lambda-list '(m))
(cl:defmethod hAcc-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:hAcc-val is deprecated.  Use ublox_msgs-msg:hAcc instead.")
  (hAcc m))

(cl:ensure-generic-function 'vAcc-val :lambda-list '(m))
(cl:defmethod vAcc-val ((m <NavHPPOSLLH>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:vAcc-val is deprecated.  Use ublox_msgs-msg:vAcc instead.")
  (vAcc m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<NavHPPOSLLH>)))
    "Constants for message type '<NavHPPOSLLH>"
  '((:CLASS_ID . 1)
    (:MESSAGE_ID . 20))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'NavHPPOSLLH)))
    "Constants for message type 'NavHPPOSLLH"
  '((:CLASS_ID . 1)
    (:MESSAGE_ID . 20))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <NavHPPOSLLH>) ostream)
  "Serializes a message object of type '<NavHPPOSLLH>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'version)) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream))
   (cl:slot-value msg 'reserved1))
  (cl:let* ((signed (cl:slot-value msg 'invalid_llh)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) ostream)
  (cl:let* ((signed (cl:slot-value msg 'lon)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'lat)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'height)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'hMSL)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'lonHp)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'latHp)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'heightHp)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'hMSLHp)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'hAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'hAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'hAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'hAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'vAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'vAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'vAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'vAcc)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <NavHPPOSLLH>) istream)
  "Deserializes a message object of type '<NavHPPOSLLH>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'version)) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'reserved1) (cl:make-array 2))
  (cl:let ((vals (cl:slot-value msg 'reserved1)))
    (cl:dotimes (i 2)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'invalid_llh) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'lon) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'lat) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'height) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'hMSL) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'lonHp) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'latHp) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'heightHp) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'hMSLHp) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'hAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'hAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'hAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'hAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'vAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'vAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'vAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'vAcc)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<NavHPPOSLLH>)))
  "Returns string type for a message object of type '<NavHPPOSLLH>"
  "ublox_msgs/NavHPPOSLLH")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'NavHPPOSLLH)))
  "Returns string type for a message object of type 'NavHPPOSLLH"
  "ublox_msgs/NavHPPOSLLH")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<NavHPPOSLLH>)))
  "Returns md5sum for a message object of type '<NavHPPOSLLH>"
  "9da6664837183254bd840fe05c8c1e4b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'NavHPPOSLLH)))
  "Returns md5sum for a message object of type 'NavHPPOSLLH"
  "9da6664837183254bd840fe05c8c1e4b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<NavHPPOSLLH>)))
  "Returns full string definition for message of type '<NavHPPOSLLH>"
  (cl:format cl:nil "# NAV-HPPOSLLH (0x01 0x14)~%# High Precision Geodetic Position Solution~%#~%# See important comments concerning validity of position given in section~%# Navigation Output Filters.~%# This message outputs the Geodetic position in the currently selected~%# Ellipsoid. The default is the WGS84 Ellipsoid, but can be changed with the~%# message CFG-DAT.~%#~%~%uint8 CLASS_ID = 1~%uint8 MESSAGE_ID = 20~%~%uint8 version~%uint8[2] reserved1~%int8 invalid_llh~%~%uint32 iTOW             # GPS Millisecond Time of Week [ms]~%~%int32 lon               # Longitude [deg / 1e-7]~%int32 lat               # Latitude [deg / 1e-7]~%int32 height            # Height above Ellipsoid [mm]~%int32 hMSL              # Height above mean sea level [mm]~%int8 lonHp              # Longitude [deg / 1e-9, range -99 to +99]~%int8 latHp              # Latitude [deg / 1e-9, range -99 to +99]~%int8 heightHp          # Height above Ellipsoid [mm / 0.1, range -9 to +9]~%int8 hMSLHp            # Height above mean sea level [mm / 0.1, range -9 to +9]~%uint32 hAcc             # Horizontal Accuracy Estimate [mm / 0.1]~%uint32 vAcc             # Vertical Accuracy Estimate [mm / 0.1]~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'NavHPPOSLLH)))
  "Returns full string definition for message of type 'NavHPPOSLLH"
  (cl:format cl:nil "# NAV-HPPOSLLH (0x01 0x14)~%# High Precision Geodetic Position Solution~%#~%# See important comments concerning validity of position given in section~%# Navigation Output Filters.~%# This message outputs the Geodetic position in the currently selected~%# Ellipsoid. The default is the WGS84 Ellipsoid, but can be changed with the~%# message CFG-DAT.~%#~%~%uint8 CLASS_ID = 1~%uint8 MESSAGE_ID = 20~%~%uint8 version~%uint8[2] reserved1~%int8 invalid_llh~%~%uint32 iTOW             # GPS Millisecond Time of Week [ms]~%~%int32 lon               # Longitude [deg / 1e-7]~%int32 lat               # Latitude [deg / 1e-7]~%int32 height            # Height above Ellipsoid [mm]~%int32 hMSL              # Height above mean sea level [mm]~%int8 lonHp              # Longitude [deg / 1e-9, range -99 to +99]~%int8 latHp              # Latitude [deg / 1e-9, range -99 to +99]~%int8 heightHp          # Height above Ellipsoid [mm / 0.1, range -9 to +9]~%int8 hMSLHp            # Height above mean sea level [mm / 0.1, range -9 to +9]~%uint32 hAcc             # Horizontal Accuracy Estimate [mm / 0.1]~%uint32 vAcc             # Vertical Accuracy Estimate [mm / 0.1]~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <NavHPPOSLLH>))
  (cl:+ 0
     1
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'reserved1) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 1)))
     1
     4
     4
     4
     4
     4
     1
     1
     1
     1
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <NavHPPOSLLH>))
  "Converts a ROS message object to a list"
  (cl:list 'NavHPPOSLLH
    (cl:cons ':version (version msg))
    (cl:cons ':reserved1 (reserved1 msg))
    (cl:cons ':invalid_llh (invalid_llh msg))
    (cl:cons ':iTOW (iTOW msg))
    (cl:cons ':lon (lon msg))
    (cl:cons ':lat (lat msg))
    (cl:cons ':height (height msg))
    (cl:cons ':hMSL (hMSL msg))
    (cl:cons ':lonHp (lonHp msg))
    (cl:cons ':latHp (latHp msg))
    (cl:cons ':heightHp (heightHp msg))
    (cl:cons ':hMSLHp (hMSLHp msg))
    (cl:cons ':hAcc (hAcc msg))
    (cl:cons ':vAcc (vAcc msg))
))
