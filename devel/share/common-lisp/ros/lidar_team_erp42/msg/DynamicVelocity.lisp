; Auto-generated. Do not edit!


(cl:in-package lidar_team_erp42-msg)


;//! \htmlinclude DynamicVelocity.msg.html

(cl:defclass <DynamicVelocity> (roslisp-msg-protocol:ros-message)
  ((throttle
    :reader throttle
    :initarg :throttle
    :type cl:float
    :initform 0.0))
)

(cl:defclass DynamicVelocity (<DynamicVelocity>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <DynamicVelocity>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'DynamicVelocity)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name lidar_team_erp42-msg:<DynamicVelocity> is deprecated: use lidar_team_erp42-msg:DynamicVelocity instead.")))

(cl:ensure-generic-function 'throttle-val :lambda-list '(m))
(cl:defmethod throttle-val ((m <DynamicVelocity>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader lidar_team_erp42-msg:throttle-val is deprecated.  Use lidar_team_erp42-msg:throttle instead.")
  (throttle m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DynamicVelocity>) ostream)
  "Serializes a message object of type '<DynamicVelocity>"
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'throttle))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DynamicVelocity>) istream)
  "Deserializes a message object of type '<DynamicVelocity>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'throttle) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<DynamicVelocity>)))
  "Returns string type for a message object of type '<DynamicVelocity>"
  "lidar_team_erp42/DynamicVelocity")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DynamicVelocity)))
  "Returns string type for a message object of type 'DynamicVelocity"
  "lidar_team_erp42/DynamicVelocity")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<DynamicVelocity>)))
  "Returns md5sum for a message object of type '<DynamicVelocity>"
  "a0e4c91f838bf9ac9a81509ea028ea0b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DynamicVelocity)))
  "Returns md5sum for a message object of type 'DynamicVelocity"
  "a0e4c91f838bf9ac9a81509ea028ea0b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DynamicVelocity>)))
  "Returns full string definition for message of type '<DynamicVelocity>"
  (cl:format cl:nil "float64 throttle~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DynamicVelocity)))
  "Returns full string definition for message of type 'DynamicVelocity"
  (cl:format cl:nil "float64 throttle~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DynamicVelocity>))
  (cl:+ 0
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DynamicVelocity>))
  "Converts a ROS message object to a list"
  (cl:list 'DynamicVelocity
    (cl:cons ':throttle (throttle msg))
))
