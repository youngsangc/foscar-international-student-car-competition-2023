; Auto-generated. Do not edit!


(cl:in-package track_race-msg)


;//! \htmlinclude Steering.msg.html

(cl:defclass <Steering> (roslisp-msg-protocol:ros-message)
  ((steering
    :reader steering
    :initarg :steering
    :type cl:float
    :initform 0.0))
)

(cl:defclass Steering (<Steering>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Steering>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Steering)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name track_race-msg:<Steering> is deprecated: use track_race-msg:Steering instead.")))

(cl:ensure-generic-function 'steering-val :lambda-list '(m))
(cl:defmethod steering-val ((m <Steering>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader track_race-msg:steering-val is deprecated.  Use track_race-msg:steering instead.")
  (steering m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Steering>) ostream)
  "Serializes a message object of type '<Steering>"
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'steering))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Steering>) istream)
  "Deserializes a message object of type '<Steering>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'steering) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Steering>)))
  "Returns string type for a message object of type '<Steering>"
  "track_race/Steering")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Steering)))
  "Returns string type for a message object of type 'Steering"
  "track_race/Steering")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Steering>)))
  "Returns md5sum for a message object of type '<Steering>"
  "5e5c60c40f2709684823442181fe6011")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Steering)))
  "Returns md5sum for a message object of type 'Steering"
  "5e5c60c40f2709684823442181fe6011")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Steering>)))
  "Returns full string definition for message of type '<Steering>"
  (cl:format cl:nil "float32 steering~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Steering)))
  "Returns full string definition for message of type 'Steering"
  (cl:format cl:nil "float32 steering~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Steering>))
  (cl:+ 0
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Steering>))
  "Converts a ROS message object to a list"
  (cl:list 'Steering
    (cl:cons ':steering (steering msg))
))
