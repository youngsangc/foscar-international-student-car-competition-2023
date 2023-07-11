; Auto-generated. Do not edit!


(cl:in-package ublox_msgs-msg)


;//! \htmlinclude NavRELPOSNED9.msg.html

(cl:defclass <NavRELPOSNED9> (roslisp-msg-protocol:ros-message)
  ((version
    :reader version
    :initarg :version
    :type cl:fixnum
    :initform 0)
   (reserved1
    :reader reserved1
    :initarg :reserved1
    :type cl:fixnum
    :initform 0)
   (refStationId
    :reader refStationId
    :initarg :refStationId
    :type cl:fixnum
    :initform 0)
   (iTOW
    :reader iTOW
    :initarg :iTOW
    :type cl:integer
    :initform 0)
   (relPosN
    :reader relPosN
    :initarg :relPosN
    :type cl:integer
    :initform 0)
   (relPosE
    :reader relPosE
    :initarg :relPosE
    :type cl:integer
    :initform 0)
   (relPosD
    :reader relPosD
    :initarg :relPosD
    :type cl:integer
    :initform 0)
   (relPosLength
    :reader relPosLength
    :initarg :relPosLength
    :type cl:integer
    :initform 0)
   (relPosHeading
    :reader relPosHeading
    :initarg :relPosHeading
    :type cl:integer
    :initform 0)
   (reserved2
    :reader reserved2
    :initarg :reserved2
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 4 :element-type 'cl:fixnum :initial-element 0))
   (relPosHPN
    :reader relPosHPN
    :initarg :relPosHPN
    :type cl:fixnum
    :initform 0)
   (relPosHPE
    :reader relPosHPE
    :initarg :relPosHPE
    :type cl:fixnum
    :initform 0)
   (relPosHPD
    :reader relPosHPD
    :initarg :relPosHPD
    :type cl:fixnum
    :initform 0)
   (relPosHPLength
    :reader relPosHPLength
    :initarg :relPosHPLength
    :type cl:fixnum
    :initform 0)
   (accN
    :reader accN
    :initarg :accN
    :type cl:integer
    :initform 0)
   (accE
    :reader accE
    :initarg :accE
    :type cl:integer
    :initform 0)
   (accD
    :reader accD
    :initarg :accD
    :type cl:integer
    :initform 0)
   (accLength
    :reader accLength
    :initarg :accLength
    :type cl:integer
    :initform 0)
   (accHeading
    :reader accHeading
    :initarg :accHeading
    :type cl:integer
    :initform 0)
   (reserved3
    :reader reserved3
    :initarg :reserved3
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 4 :element-type 'cl:fixnum :initial-element 0))
   (flags
    :reader flags
    :initarg :flags
    :type cl:integer
    :initform 0))
)

(cl:defclass NavRELPOSNED9 (<NavRELPOSNED9>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <NavRELPOSNED9>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'NavRELPOSNED9)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ublox_msgs-msg:<NavRELPOSNED9> is deprecated: use ublox_msgs-msg:NavRELPOSNED9 instead.")))

(cl:ensure-generic-function 'version-val :lambda-list '(m))
(cl:defmethod version-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:version-val is deprecated.  Use ublox_msgs-msg:version instead.")
  (version m))

(cl:ensure-generic-function 'reserved1-val :lambda-list '(m))
(cl:defmethod reserved1-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:reserved1-val is deprecated.  Use ublox_msgs-msg:reserved1 instead.")
  (reserved1 m))

(cl:ensure-generic-function 'refStationId-val :lambda-list '(m))
(cl:defmethod refStationId-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:refStationId-val is deprecated.  Use ublox_msgs-msg:refStationId instead.")
  (refStationId m))

(cl:ensure-generic-function 'iTOW-val :lambda-list '(m))
(cl:defmethod iTOW-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:iTOW-val is deprecated.  Use ublox_msgs-msg:iTOW instead.")
  (iTOW m))

(cl:ensure-generic-function 'relPosN-val :lambda-list '(m))
(cl:defmethod relPosN-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:relPosN-val is deprecated.  Use ublox_msgs-msg:relPosN instead.")
  (relPosN m))

(cl:ensure-generic-function 'relPosE-val :lambda-list '(m))
(cl:defmethod relPosE-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:relPosE-val is deprecated.  Use ublox_msgs-msg:relPosE instead.")
  (relPosE m))

(cl:ensure-generic-function 'relPosD-val :lambda-list '(m))
(cl:defmethod relPosD-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:relPosD-val is deprecated.  Use ublox_msgs-msg:relPosD instead.")
  (relPosD m))

(cl:ensure-generic-function 'relPosLength-val :lambda-list '(m))
(cl:defmethod relPosLength-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:relPosLength-val is deprecated.  Use ublox_msgs-msg:relPosLength instead.")
  (relPosLength m))

(cl:ensure-generic-function 'relPosHeading-val :lambda-list '(m))
(cl:defmethod relPosHeading-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:relPosHeading-val is deprecated.  Use ublox_msgs-msg:relPosHeading instead.")
  (relPosHeading m))

(cl:ensure-generic-function 'reserved2-val :lambda-list '(m))
(cl:defmethod reserved2-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:reserved2-val is deprecated.  Use ublox_msgs-msg:reserved2 instead.")
  (reserved2 m))

(cl:ensure-generic-function 'relPosHPN-val :lambda-list '(m))
(cl:defmethod relPosHPN-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:relPosHPN-val is deprecated.  Use ublox_msgs-msg:relPosHPN instead.")
  (relPosHPN m))

(cl:ensure-generic-function 'relPosHPE-val :lambda-list '(m))
(cl:defmethod relPosHPE-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:relPosHPE-val is deprecated.  Use ublox_msgs-msg:relPosHPE instead.")
  (relPosHPE m))

(cl:ensure-generic-function 'relPosHPD-val :lambda-list '(m))
(cl:defmethod relPosHPD-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:relPosHPD-val is deprecated.  Use ublox_msgs-msg:relPosHPD instead.")
  (relPosHPD m))

(cl:ensure-generic-function 'relPosHPLength-val :lambda-list '(m))
(cl:defmethod relPosHPLength-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:relPosHPLength-val is deprecated.  Use ublox_msgs-msg:relPosHPLength instead.")
  (relPosHPLength m))

(cl:ensure-generic-function 'accN-val :lambda-list '(m))
(cl:defmethod accN-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:accN-val is deprecated.  Use ublox_msgs-msg:accN instead.")
  (accN m))

(cl:ensure-generic-function 'accE-val :lambda-list '(m))
(cl:defmethod accE-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:accE-val is deprecated.  Use ublox_msgs-msg:accE instead.")
  (accE m))

(cl:ensure-generic-function 'accD-val :lambda-list '(m))
(cl:defmethod accD-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:accD-val is deprecated.  Use ublox_msgs-msg:accD instead.")
  (accD m))

(cl:ensure-generic-function 'accLength-val :lambda-list '(m))
(cl:defmethod accLength-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:accLength-val is deprecated.  Use ublox_msgs-msg:accLength instead.")
  (accLength m))

(cl:ensure-generic-function 'accHeading-val :lambda-list '(m))
(cl:defmethod accHeading-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:accHeading-val is deprecated.  Use ublox_msgs-msg:accHeading instead.")
  (accHeading m))

(cl:ensure-generic-function 'reserved3-val :lambda-list '(m))
(cl:defmethod reserved3-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:reserved3-val is deprecated.  Use ublox_msgs-msg:reserved3 instead.")
  (reserved3 m))

(cl:ensure-generic-function 'flags-val :lambda-list '(m))
(cl:defmethod flags-val ((m <NavRELPOSNED9>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ublox_msgs-msg:flags-val is deprecated.  Use ublox_msgs-msg:flags instead.")
  (flags m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<NavRELPOSNED9>)))
    "Constants for message type '<NavRELPOSNED9>"
  '((:CLASS_ID . 1)
    (:MESSAGE_ID . 60)
    (:FLAGS_GNSS_FIX_OK . 1)
    (:FLAGS_DIFF_SOLN . 2)
    (:FLAGS_REL_POS_VALID . 4)
    (:FLAGS_CARR_SOLN_MASK . 24)
    (:FLAGS_CARR_SOLN_NONE . 0)
    (:FLAGS_CARR_SOLN_FLOAT . 8)
    (:FLAGS_CARR_SOLN_FIXED . 16)
    (:FLAGS_IS_MOVING . 32)
    (:FLAGS_REF_POS_MISS . 64)
    (:FLAGS_REF_OBS_MISS . 128)
    (:FLAGS_REL_POS_HEAD_VALID . 256)
    (:FLAGS_REL_POS_NORM . 512))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'NavRELPOSNED9)))
    "Constants for message type 'NavRELPOSNED9"
  '((:CLASS_ID . 1)
    (:MESSAGE_ID . 60)
    (:FLAGS_GNSS_FIX_OK . 1)
    (:FLAGS_DIFF_SOLN . 2)
    (:FLAGS_REL_POS_VALID . 4)
    (:FLAGS_CARR_SOLN_MASK . 24)
    (:FLAGS_CARR_SOLN_NONE . 0)
    (:FLAGS_CARR_SOLN_FLOAT . 8)
    (:FLAGS_CARR_SOLN_FIXED . 16)
    (:FLAGS_IS_MOVING . 32)
    (:FLAGS_REF_POS_MISS . 64)
    (:FLAGS_REF_OBS_MISS . 128)
    (:FLAGS_REL_POS_HEAD_VALID . 256)
    (:FLAGS_REL_POS_NORM . 512))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <NavRELPOSNED9>) ostream)
  "Serializes a message object of type '<NavRELPOSNED9>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'version)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'reserved1)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'refStationId)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'refStationId)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) ostream)
  (cl:let* ((signed (cl:slot-value msg 'relPosN)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'relPosE)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'relPosD)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'relPosLength)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'relPosHeading)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream))
   (cl:slot-value msg 'reserved2))
  (cl:let* ((signed (cl:slot-value msg 'relPosHPN)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'relPosHPE)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'relPosHPD)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'relPosHPLength)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accN)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accN)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accN)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accN)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accE)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accE)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accE)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accE)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accD)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accD)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accD)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accD)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accLength)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accLength)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accLength)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accLength)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accHeading)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accHeading)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accHeading)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accHeading)) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream))
   (cl:slot-value msg 'reserved3))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'flags)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'flags)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'flags)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'flags)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <NavRELPOSNED9>) istream)
  "Deserializes a message object of type '<NavRELPOSNED9>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'version)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'reserved1)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'refStationId)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'refStationId)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'iTOW)) (cl:read-byte istream))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'relPosN) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'relPosE) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'relPosD) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'relPosLength) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'relPosHeading) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  (cl:setf (cl:slot-value msg 'reserved2) (cl:make-array 4))
  (cl:let ((vals (cl:slot-value msg 'reserved2)))
    (cl:dotimes (i 4)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'relPosHPN) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'relPosHPE) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'relPosHPD) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'relPosHPLength) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accN)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accN)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accN)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accN)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accE)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accE)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accE)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accE)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accD)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accD)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accD)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accD)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accLength)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accLength)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accLength)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accLength)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'accHeading)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'accHeading)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'accHeading)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'accHeading)) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'reserved3) (cl:make-array 4))
  (cl:let ((vals (cl:slot-value msg 'reserved3)))
    (cl:dotimes (i 4)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'flags)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'flags)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'flags)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'flags)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<NavRELPOSNED9>)))
  "Returns string type for a message object of type '<NavRELPOSNED9>"
  "ublox_msgs/NavRELPOSNED9")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'NavRELPOSNED9)))
  "Returns string type for a message object of type 'NavRELPOSNED9"
  "ublox_msgs/NavRELPOSNED9")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<NavRELPOSNED9>)))
  "Returns md5sum for a message object of type '<NavRELPOSNED9>"
  "5acd7899c1f1094e1680da583d0ff1f9")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'NavRELPOSNED9)))
  "Returns md5sum for a message object of type 'NavRELPOSNED9"
  "5acd7899c1f1094e1680da583d0ff1f9")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<NavRELPOSNED9>)))
  "Returns full string definition for message of type '<NavRELPOSNED9>"
  (cl:format cl:nil "# NAV-RELPOSNED (0x01 0x3C)~%# Relative Positioning Information in NED frame~%#~%# The NED frame is defined as the local topological system at the reference~%# station. The relative position vector components in this message, along with~%# their associated accuracies, are given in that local topological system~%# This message contains the relative position vector from the Reference Station~%# to the Rover, including accuracy figures, in the local topological system~%# defined at the reference station~%#~%# Supported on:~%#  - u-blox 9 from protocol version 27.11 (only with High Precision GNSS products)~%#~%~%uint8 CLASS_ID = 1~%uint8 MESSAGE_ID = 60~%~%uint8 version                     # Message version (0x00 for this version)~%uint8 reserved1                   # Reserved~%uint16 refStationId               # Reference Station ID. Must be in the range~%                                  # 0..4095~%uint32 iTOW                       # GPS time of week of the navigation epoch~%                                  # [ms]~%~%int32 relPosN                     # North component of relative position vector~%                                  # [cm]~%int32 relPosE                     # East component of relative position vector~%                                  # [cm]~%int32 relPosD                     # Down component of relative position vector~%                                  # [cm]~%int32 relPosLength                # Length of the relative position vector~%                                  # [cm]~%int32 relPosHeading               # Heading of the relative position vector~%                                  # [1e-5 deg]~%uint8[4] reserved2                # Reserved~%int8 relPosHPN                    # High-precision North component of relative~%                                  # position vector. [0.1 mm]~%                                  # Must be in the range -99 to +99.~%                                  # The full North component of the relative~%                                  # position vector, in units of cm, is given by~%                                  # relPosN + (relPosHPN * 1e-2)~%int8 relPosHPE                    # High-precision East component of relative~%                                  # position vector. [0.1 mm]~%                                  # Must be in the range -99 to +99.~%                                  # The full East component of the relative~%                                  # position vector, in units of cm, is given by~%                                  # relPosE + (relPosHPE * 1e-2)~%int8 relPosHPD                    # High-precision Down component of relative~%                                  # position vector. [0.1 mm]~%                                  # Must be in the range -99 to +99.~%                                  # The full Down component of the relative~%                                  # position vector, in units of cm, is given by~%                                  # relPosD + (relPosHPD * 1e-2)~%int8 relPosHPLength               # High-precision component of the length of~%                                  # the relative position vector.~%                                  # Must be in the range -99 to +99.~%                                  # The full length of the relative position~%                                  # vector, in units of cm, is given by~%                                  # relPosLength + (relPosHPLength * 1e-2)~%~%uint32 accN                       # Accuracy of relative position North~%                                  # component [0.1 mm]~%uint32 accE                       # Accuracy of relative position East component~%                                  # [0.1 mm]~%uint32 accD                       # Accuracy of relative position Down component~%                                  # [0.1 mm]~%uint32 accLength                  # Accuracy of length of the relative position~%                                  # vector [0.1 mm]~%uint32 accHeading                 # Accuracy of heading of the relative position~%                                  # vector [1e-5 deg]~%~%uint8[4] reserved3                # Reserved~%~%uint32 flags~%uint32 FLAGS_GNSS_FIX_OK = 1      # A valid fix (i.e within DOP & accuracy~%                                  # masks)~%uint32 FLAGS_DIFF_SOLN = 2        # Set if differential corrections were applied~%uint32 FLAGS_REL_POS_VALID = 4    # Set if relative position components and~%                                  # accuracies are valid~%uint32 FLAGS_CARR_SOLN_MASK = 24  # Carrier phase range solution status:~%uint32 FLAGS_CARR_SOLN_NONE = 0     # No carrier phase range solution~%uint32 FLAGS_CARR_SOLN_FLOAT = 8    # Float solution. No fixed integer carrier~%                                    # phase measurements have been used to~%                                    # calculate the solution~%uint32 FLAGS_CARR_SOLN_FIXED = 16   # Fixed solution. One or more fixed~%                                    # integer carrier phase range measurements~%                                    # have been used to calculate the solution~%uint32 FLAGS_IS_MOVING = 32       # if the receiver is operating in moving~%                                  # baseline mode (not supported in protocol~%                                  # versions less than 20.3)~%uint32 FLAGS_REF_POS_MISS = 64    # Set if extrapolated reference position was~%                                  # used to compute moving baseline solution~%                                  # this epoch (not supported in protocol~%                                  # versions less than 20.3)~%uint32 FLAGS_REF_OBS_MISS = 128   # Set if extrapolated reference observations~%                                  # were used to compute moving baseline~%                                  # solution this epoch (not supported in~%                                  # protocol versions less than 20.3)~%uint32 FLAGS_REL_POS_HEAD_VALID = 256   # Set if extrapolated reference observations~%                                        # were used to compute moving baseline~%                                        # solution this epoch (not supported in~%                                        # protocol versions less than 20.3)~%uint32 FLAGS_REL_POS_NORM = 512   # Set if extrapolated reference observations~%                                  # were used to compute moving baseline~%                                  # solution this epoch (not supported in~%                                  # protocol versions less than 20.3)~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'NavRELPOSNED9)))
  "Returns full string definition for message of type 'NavRELPOSNED9"
  (cl:format cl:nil "# NAV-RELPOSNED (0x01 0x3C)~%# Relative Positioning Information in NED frame~%#~%# The NED frame is defined as the local topological system at the reference~%# station. The relative position vector components in this message, along with~%# their associated accuracies, are given in that local topological system~%# This message contains the relative position vector from the Reference Station~%# to the Rover, including accuracy figures, in the local topological system~%# defined at the reference station~%#~%# Supported on:~%#  - u-blox 9 from protocol version 27.11 (only with High Precision GNSS products)~%#~%~%uint8 CLASS_ID = 1~%uint8 MESSAGE_ID = 60~%~%uint8 version                     # Message version (0x00 for this version)~%uint8 reserved1                   # Reserved~%uint16 refStationId               # Reference Station ID. Must be in the range~%                                  # 0..4095~%uint32 iTOW                       # GPS time of week of the navigation epoch~%                                  # [ms]~%~%int32 relPosN                     # North component of relative position vector~%                                  # [cm]~%int32 relPosE                     # East component of relative position vector~%                                  # [cm]~%int32 relPosD                     # Down component of relative position vector~%                                  # [cm]~%int32 relPosLength                # Length of the relative position vector~%                                  # [cm]~%int32 relPosHeading               # Heading of the relative position vector~%                                  # [1e-5 deg]~%uint8[4] reserved2                # Reserved~%int8 relPosHPN                    # High-precision North component of relative~%                                  # position vector. [0.1 mm]~%                                  # Must be in the range -99 to +99.~%                                  # The full North component of the relative~%                                  # position vector, in units of cm, is given by~%                                  # relPosN + (relPosHPN * 1e-2)~%int8 relPosHPE                    # High-precision East component of relative~%                                  # position vector. [0.1 mm]~%                                  # Must be in the range -99 to +99.~%                                  # The full East component of the relative~%                                  # position vector, in units of cm, is given by~%                                  # relPosE + (relPosHPE * 1e-2)~%int8 relPosHPD                    # High-precision Down component of relative~%                                  # position vector. [0.1 mm]~%                                  # Must be in the range -99 to +99.~%                                  # The full Down component of the relative~%                                  # position vector, in units of cm, is given by~%                                  # relPosD + (relPosHPD * 1e-2)~%int8 relPosHPLength               # High-precision component of the length of~%                                  # the relative position vector.~%                                  # Must be in the range -99 to +99.~%                                  # The full length of the relative position~%                                  # vector, in units of cm, is given by~%                                  # relPosLength + (relPosHPLength * 1e-2)~%~%uint32 accN                       # Accuracy of relative position North~%                                  # component [0.1 mm]~%uint32 accE                       # Accuracy of relative position East component~%                                  # [0.1 mm]~%uint32 accD                       # Accuracy of relative position Down component~%                                  # [0.1 mm]~%uint32 accLength                  # Accuracy of length of the relative position~%                                  # vector [0.1 mm]~%uint32 accHeading                 # Accuracy of heading of the relative position~%                                  # vector [1e-5 deg]~%~%uint8[4] reserved3                # Reserved~%~%uint32 flags~%uint32 FLAGS_GNSS_FIX_OK = 1      # A valid fix (i.e within DOP & accuracy~%                                  # masks)~%uint32 FLAGS_DIFF_SOLN = 2        # Set if differential corrections were applied~%uint32 FLAGS_REL_POS_VALID = 4    # Set if relative position components and~%                                  # accuracies are valid~%uint32 FLAGS_CARR_SOLN_MASK = 24  # Carrier phase range solution status:~%uint32 FLAGS_CARR_SOLN_NONE = 0     # No carrier phase range solution~%uint32 FLAGS_CARR_SOLN_FLOAT = 8    # Float solution. No fixed integer carrier~%                                    # phase measurements have been used to~%                                    # calculate the solution~%uint32 FLAGS_CARR_SOLN_FIXED = 16   # Fixed solution. One or more fixed~%                                    # integer carrier phase range measurements~%                                    # have been used to calculate the solution~%uint32 FLAGS_IS_MOVING = 32       # if the receiver is operating in moving~%                                  # baseline mode (not supported in protocol~%                                  # versions less than 20.3)~%uint32 FLAGS_REF_POS_MISS = 64    # Set if extrapolated reference position was~%                                  # used to compute moving baseline solution~%                                  # this epoch (not supported in protocol~%                                  # versions less than 20.3)~%uint32 FLAGS_REF_OBS_MISS = 128   # Set if extrapolated reference observations~%                                  # were used to compute moving baseline~%                                  # solution this epoch (not supported in~%                                  # protocol versions less than 20.3)~%uint32 FLAGS_REL_POS_HEAD_VALID = 256   # Set if extrapolated reference observations~%                                        # were used to compute moving baseline~%                                        # solution this epoch (not supported in~%                                        # protocol versions less than 20.3)~%uint32 FLAGS_REL_POS_NORM = 512   # Set if extrapolated reference observations~%                                  # were used to compute moving baseline~%                                  # solution this epoch (not supported in~%                                  # protocol versions less than 20.3)~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <NavRELPOSNED9>))
  (cl:+ 0
     1
     1
     2
     4
     4
     4
     4
     4
     4
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'reserved2) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 1)))
     1
     1
     1
     1
     4
     4
     4
     4
     4
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'reserved3) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 1)))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <NavRELPOSNED9>))
  "Converts a ROS message object to a list"
  (cl:list 'NavRELPOSNED9
    (cl:cons ':version (version msg))
    (cl:cons ':reserved1 (reserved1 msg))
    (cl:cons ':refStationId (refStationId msg))
    (cl:cons ':iTOW (iTOW msg))
    (cl:cons ':relPosN (relPosN msg))
    (cl:cons ':relPosE (relPosE msg))
    (cl:cons ':relPosD (relPosD msg))
    (cl:cons ':relPosLength (relPosLength msg))
    (cl:cons ':relPosHeading (relPosHeading msg))
    (cl:cons ':reserved2 (reserved2 msg))
    (cl:cons ':relPosHPN (relPosHPN msg))
    (cl:cons ':relPosHPE (relPosHPE msg))
    (cl:cons ':relPosHPD (relPosHPD msg))
    (cl:cons ':relPosHPLength (relPosHPLength msg))
    (cl:cons ':accN (accN msg))
    (cl:cons ':accE (accE msg))
    (cl:cons ':accD (accD msg))
    (cl:cons ':accLength (accLength msg))
    (cl:cons ':accHeading (accHeading msg))
    (cl:cons ':reserved3 (reserved3 msg))
    (cl:cons ':flags (flags msg))
))
