; Auto-generated. Do not edit!


(cl:in-package ublox_msgs-msg)


;//! \htmlinclude NavHPPOSECEF.msg.html

(cl:defclass <NavHPPOSECEF> (roslisp-msg-protocol:ros-message)
  ((version
    :reader version
    :initarg :version
    :type cl:fixnum
    :initform 0)
   (reserved0
    :reader reserved0
    :initarg :reserved0
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 3 :element-type 'cl:fixnum :initial-element 0))
   (iTOW
    :reader iTOW
    :initarg :iTOW
    :type cl:integer
    :initform 0)
   (ecefX
    :reader ecefX
    :initarg :ecefX
    :type cl:integer
    :initform 0)
   (ecefY
    :reader ecefY
    :initarg :ecefY
    :type cl:integer
    :initform 0)
   (ecefZ
    :reader ecefZ
    :initarg :ecefZ
    :type cl:integer
    :initform 0)
   (ecefXHp
    :reader ecefXHp
    :initarg :ecefXHp
    :type cl:fixnum
    :initform 0)
   (ecefYHp
    :reader ecefYHp
    :initarg :ecefYHp
    :type cl:fixnum
    :initform 0)
   (ecefZHp
    :reader ecefZHp
    :initarg :ecefZHp
    :type cl:fixnum
    :initform 0)
   (flags
    :reader flags
    :initarg :flags
    :type cl:fixnum
    :initform 0)
   (pAcc
    :reader pAcc
    :initarg :pAcc
    :type cl:integer
    :initform 0))
)

(cl:defclass NavHPPOSECEF (<NavHPPOSECEF>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <NavHPPOSECEF>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'NavHPPOSECEF)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ublox_msgs-msg:<NavHPPOSECEF> is deprecated: use ublox_msgs-msg:NavHPPOSECEF instead.")))

(cl:ensure-generic-function 'version-val :lambda-list '(m))
(cl:defmethod version-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:version-val is deprecated.  Use ublox_msgs-msg:version instead.")
  (version m))

(cl:ensure-generic-function 'reserved0-val :lambda-list '(m))
(cl:defmethod reserved0-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:reserved0-val is deprecated.  Use ublox_msgs-msg:reserved0 instead.")
  (reserved0 m))

(cl:ensure-generic-function 'iTOW-val :lambda-list '(m))
(cl:defmethod iTOW-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:iTOW-val is deprecated.  Use ublox_msgs-msg:iTOW instead.")
  (iTOW m))

(cl:ensure-generic-function 'ecefX-val :lambda-list '(m))
(cl:defmethod ecefX-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:ecefX-val is deprecated.  Use ublox_msgs-msg:ecefX instead.")
  (ecefX m))

(cl:ensure-generic-function 'ecefY-val :lambda-list '(m))
(cl:defmethod ecefY-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:ecefY-val is deprecated.  Use ublox_msgs-msg:ecefY instead.")
  (ecefY m))

(cl:ensure-generic-function 'ecefZ-val :lambda-list '(m))
(cl:defmethod ecefZ-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:ecefZ-val is deprecated.  Use ublox_msgs-msg:ecefZ instead.")
  (ecefZ m))

(cl:ensure-generic-function 'ecefXHp-val :lambda-list '(m))
(cl:defmethod ecefXHp-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:ecefXHp-val is deprecated.  Use ublox_msgs-msg:ecefXHp instead.")
  (ecefXHp m))

(cl:ensure-generic-function 'ecefYHp-val :lambda-list '(m))
(cl:defmethod ecefYHp-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:ecefYHp-val is deprecated.  Use ublox_msgs-msg:ecefYHp instead.")
  (ecefYHp m))

(cl:ensure-generic-function 'ecefZHp-val :lambda-list '(m))
(cl:defmethod ecefZHp-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:ecefZHp-val is deprecated.  Use ublox_msgs-msg:ecefZHp instead.")
  (ecefZHp m))

(cl:ensure-generic-function 'flags-val :lambda-list '(m))
(cl:defmethod flags-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:flags-val is deprecated.  Use ublox_msgs-msg:flags instead.")
  (flags m))

(cl:ensure-generic-function 'pAcc-val :lambda-list '(m))
(cl:defmethod pAcc-val ((m <NavHPPOSECEF>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:pAcc-val is deprecated.  Use ublox_msgs-msg:pAcc instead.")
  (pAcc m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<NavHPPOSECEF>)))
    "Constants for message type '<NavHPPOSECEF>"
  '((:CLASS_ID . 1)
    (:MESSAGE_ID . 19))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'NavHPPOSECEF)))
    "Constants for message type 'NavHPPOSECEF"
  '((:CLASS_ID . 1)
    (:MESSAGE_ID . 19))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <NavHPPOSECEF>) ostream)
  "Serializes a message object of type '<NavHPPOSECEF>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'version)) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream))
   (cl:slot-value msg 'reserved0))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) ostream)
  (cl:let* ((signed (cl:slot-value msg 'ecefX)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'ecefY)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'ecefZ)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'ecefXHp)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'ecefYHp)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'ecefZHp)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'flags)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'pAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'pAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'pAcc)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'pAcc)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <NavHPPOSECEF>) istream)
  "Deserializes a message object of type '<NavHPPOSECEF>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'version)) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'reserved0) (cl:make-array 3))
  (cl:let ((vals (cl:slot-value msg 'reserved0)))
    (cl:dotimes (i 3)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'ecefX) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'ecefY) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'ecefZ) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'ecefXHp) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'ecefYHp) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'ecefZHp) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'flags)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'pAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'pAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'pAcc)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'pAcc)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<NavHPPOSECEF>)))
  "Returns string type for a message object of type '<NavHPPOSECEF>"
  "ublox_msgs/NavHPPOSECEF")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'NavHPPOSECEF)))
  "Returns string type for a message object of type 'NavHPPOSECEF"
  "ublox_msgs/NavHPPOSECEF")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<NavHPPOSECEF>)))
  "Returns md5sum for a message object of type '<NavHPPOSECEF>"
  "41fbf0937e53f84ca89afe3287f85e50")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'NavHPPOSECEF)))
  "Returns md5sum for a message object of type 'NavHPPOSECEF"
  "41fbf0937e53f84ca89afe3287f85e50")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<NavHPPOSECEF>)))
  "Returns full string definition for message of type '<NavHPPOSECEF>"
  (cl:format cl:nil "# NAV-HPPOSECEF (0x01 0x13)~%# High Precision Position Solution in ECEF~%#~%# See important comments concerning validity of position given in section~%# Navigation Output Filters.~%#~%~%uint8 CLASS_ID = 1~%uint8 MESSAGE_ID = 19~%~%uint8 version~%uint8[3] reserved0~%~%uint32 iTOW             # GPS Millisecond Time of Week [ms]~%~%int32 ecefX             # ECEF X coordinate [cm]~%int32 ecefY             # ECEF Y coordinate [cm]~%int32 ecefZ             # ECEF Z coordinate [cm]~%~%int8 ecefXHp            # ECEF X high precision component [0.1mm]~%int8 ecefYHp            # ECEF Y high precision component [0.1mm]~%int8 ecefZHp            # ECEF Z high precision component [0.1mm]~%uint8 flags~%~%uint32 pAcc             # Position Accuracy Estimate [0.1mm]~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'NavHPPOSECEF)))
  "Returns full string definition for message of type 'NavHPPOSECEF"
  (cl:format cl:nil "# NAV-HPPOSECEF (0x01 0x13)~%# High Precision Position Solution in ECEF~%#~%# See important comments concerning validity of position given in section~%# Navigation Output Filters.~%#~%~%uint8 CLASS_ID = 1~%uint8 MESSAGE_ID = 19~%~%uint8 version~%uint8[3] reserved0~%~%uint32 iTOW             # GPS Millisecond Time of Week [ms]~%~%int32 ecefX             # ECEF X coordinate [cm]~%int32 ecefY             # ECEF Y coordinate [cm]~%int32 ecefZ             # ECEF Z coordinate [cm]~%~%int8 ecefXHp            # ECEF X high precision component [0.1mm]~%int8 ecefYHp            # ECEF Y high precision component [0.1mm]~%int8 ecefZHp            # ECEF Z high precision component [0.1mm]~%uint8 flags~%~%uint32 pAcc             # Position Accuracy Estimate [0.1mm]~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <NavHPPOSECEF>))
  (cl:+ 0
     1
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'reserved0) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 1)))
     4
     4
     4
     4
     1
     1
     1
     1
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <NavHPPOSECEF>))
  "Converts a ROS message object to a list"
  (cl:list 'NavHPPOSECEF
    (cl:cons ':version (version msg))
    (cl:cons ':reserved0 (reserved0 msg))
    (cl:cons ':iTOW (iTOW msg))
    (cl:cons ':ecefX (ecefX msg))
    (cl:cons ':ecefY (ecefY msg))
    (cl:cons ':ecefZ (ecefZ msg))
    (cl:cons ':ecefXHp (ecefXHp msg))
    (cl:cons ':ecefYHp (ecefYHp msg))
    (cl:cons ':ecefZHp (ecefZHp msg))
    (cl:cons ':flags (flags msg))
    (cl:cons ':pAcc (pAcc msg))
))
