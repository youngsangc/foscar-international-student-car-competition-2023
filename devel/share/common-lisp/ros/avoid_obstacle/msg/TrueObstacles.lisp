; Auto-generated. Do not edit!


(cl:in-package avoid_obstacle-msg)


;//! \htmlinclude TrueObstacles.msg.html

(cl:defclass <TrueObstacles> (roslisp-msg-protocol:ros-message)
  ((detected
    :reader detected
    :initarg :detected
    :type cl:integer
    :initform 0))
)

(cl:defclass TrueObstacles (<TrueObstacles>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <TrueObstacles>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'TrueObstacles)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name avoid_obstacle-msg:<TrueObstacles> is deprecated: use avoid_obstacle-msg:TrueObstacles instead.")))

(cl:ensure-generic-function 'detected-val :lambda-list '(m))
(cl:defmethod detected-val ((m <TrueObstacles>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader avoid_obstacle-msg:detected-val is deprecated.  Use avoid_obstacle-msg:detected instead.")
  (detected m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <TrueObstacles>) ostream)
  "Serializes a message object of type '<TrueObstacles>"
  (cl:let* ((signed (cl:slot-value msg 'detected)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <TrueObstacles>) istream)
  "Deserializes a message object of type '<TrueObstacles>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'detected) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<TrueObstacles>)))
  "Returns string type for a message object of type '<TrueObstacles>"
  "avoid_obstacle/TrueObstacles")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'TrueObstacles)))
  "Returns string type for a message object of type 'TrueObstacles"
  "avoid_obstacle/TrueObstacles")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<TrueObstacles>)))
  "Returns md5sum for a message object of type '<TrueObstacles>"
  "b915f91311c8f5d6b235ceb818d53f80")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'TrueObstacles)))
  "Returns md5sum for a message object of type 'TrueObstacles"
  "b915f91311c8f5d6b235ceb818d53f80")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<TrueObstacles>)))
  "Returns full string definition for message of type '<TrueObstacles>"
  (cl:format cl:nil "int32 detected~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'TrueObstacles)))
  "Returns full string definition for message of type 'TrueObstacles"
  (cl:format cl:nil "int32 detected~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <TrueObstacles>))
  (cl:+ 0
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <TrueObstacles>))
  "Converts a ROS message object to a list"
  (cl:list 'TrueObstacles
    (cl:cons ':detected (detected msg))
))
