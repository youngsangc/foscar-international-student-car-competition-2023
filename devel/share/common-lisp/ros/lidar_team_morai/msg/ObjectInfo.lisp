; Auto-generated. Do not edit!


(cl:in-package lidar_team_morai-msg)


;//! \htmlinclude ObjectInfo.msg.html

(cl:defclass <ObjectInfo> (roslisp-msg-protocol:ros-message)
  ((total
    :reader total
    :initarg :total
    :type cl:fixnum
    :initform 0)
   (x
    :reader x
    :initarg :x
    :type (cl:vector cl:float)
   :initform (cl:make-array 30 :element-type 'cl:float :initial-element 0.0))
   (y
    :reader y
    :initarg :y
    :type (cl:vector cl:float)
   :initform (cl:make-array 30 :element-type 'cl:float :initial-element 0.0))
   (r
    :reader r
    :initarg :r
    :type (cl:vector cl:float)
   :initform (cl:make-array 30 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass ObjectInfo (<ObjectInfo>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ObjectInfo>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ObjectInfo)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name lidar_team_morai-msg:<ObjectInfo> is deprecated: use lidar_team_morai-msg:ObjectInfo instead.")))

(cl:ensure-generic-function 'total-val :lambda-list '(m))
(cl:defmethod total-val ((m <ObjectInfo>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader lidar_team_morai-msg:total-val is deprecated.  Use lidar_team_morai-msg:total instead.")
  (total m))

(cl:ensure-generic-function 'x-val :lambda-list '(m))
(cl:defmethod x-val ((m <ObjectInfo>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader lidar_team_morai-msg:x-val is deprecated.  Use lidar_team_morai-msg:x instead.")
  (x m))

(cl:ensure-generic-function 'y-val :lambda-list '(m))
(cl:defmethod y-val ((m <ObjectInfo>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader lidar_team_morai-msg:y-val is deprecated.  Use lidar_team_morai-msg:y instead.")
  (y m))

(cl:ensure-generic-function 'r-val :lambda-list '(m))
(cl:defmethod r-val ((m <ObjectInfo>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader lidar_team_morai-msg:r-val is deprecated.  Use lidar_team_morai-msg:r instead.")
  (r m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ObjectInfo>) ostream)
  "Serializes a message object of type '<ObjectInfo>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'total)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'total)) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'x))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'y))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'r))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ObjectInfo>) istream)
  "Deserializes a message object of type '<ObjectInfo>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'total)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'total)) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'x) (cl:make-array 30))
  (cl:let ((vals (cl:slot-value msg 'x)))
    (cl:dotimes (i 30)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits)))))
  (cl:setf (cl:slot-value msg 'y) (cl:make-array 30))
  (cl:let ((vals (cl:slot-value msg 'y)))
    (cl:dotimes (i 30)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits)))))
  (cl:setf (cl:slot-value msg 'r) (cl:make-array 30))
  (cl:let ((vals (cl:slot-value msg 'r)))
    (cl:dotimes (i 30)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ObjectInfo>)))
  "Returns string type for a message object of type '<ObjectInfo>"
  "lidar_team_morai/ObjectInfo")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ObjectInfo)))
  "Returns string type for a message object of type 'ObjectInfo"
  "lidar_team_morai/ObjectInfo")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ObjectInfo>)))
  "Returns md5sum for a message object of type '<ObjectInfo>"
  "93078c6225133f2d27cf0a8b110ab31c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ObjectInfo)))
  "Returns md5sum for a message object of type 'ObjectInfo"
  "93078c6225133f2d27cf0a8b110ab31c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ObjectInfo>)))
  "Returns full string definition for message of type '<ObjectInfo>"
  (cl:format cl:nil "uint16 total~%float64[30] x~%float64[30] y~%float64[30] r~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ObjectInfo)))
  "Returns full string definition for message of type 'ObjectInfo"
  (cl:format cl:nil "uint16 total~%float64[30] x~%float64[30] y~%float64[30] r~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ObjectInfo>))
  (cl:+ 0
     2
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'x) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'y) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'r) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ObjectInfo>))
  "Converts a ROS message object to a list"
  (cl:list 'ObjectInfo
    (cl:cons ':total (total msg))
    (cl:cons ':x (x msg))
    (cl:cons ':y (y msg))
    (cl:cons ':r (r msg))
))
