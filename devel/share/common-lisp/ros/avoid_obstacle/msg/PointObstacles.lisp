; Auto-generated. Do not edit!


(cl:in-package avoid_obstacle-msg)


;//! \htmlinclude PointObstacles.msg.html

(cl:defclass <PointObstacles> (roslisp-msg-protocol:ros-message)
  ((x
    :reader x
    :initarg :x
    :type cl:float
    :initform 0.0)
   (y
    :reader y
    :initarg :y
    :type cl:float
    :initform 0.0)
   (radius
    :reader radius
    :initarg :radius
    :type cl:float
    :initform 0.0)
   (true_radius
    :reader true_radius
    :initarg :true_radius
    :type cl:float
    :initform 0.0))
)

(cl:defclass PointObstacles (<PointObstacles>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <PointObstacles>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'PointObstacles)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name avoid_obstacle-msg:<PointObstacles> is deprecated: use avoid_obstacle-msg:PointObstacles instead.")))

(cl:ensure-generic-function 'x-val :lambda-list '(m))
(cl:defmethod x-val ((m <PointObstacles>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader avoid_obstacle-msg:x-val is deprecated.  Use avoid_obstacle-msg:x instead.")
  (x m))

(cl:ensure-generic-function 'y-val :lambda-list '(m))
(cl:defmethod y-val ((m <PointObstacles>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader avoid_obstacle-msg:y-val is deprecated.  Use avoid_obstacle-msg:y instead.")
  (y m))

(cl:ensure-generic-function 'radius-val :lambda-list '(m))
(cl:defmethod radius-val ((m <PointObstacles>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader avoid_obstacle-msg:radius-val is deprecated.  Use avoid_obstacle-msg:radius instead.")
  (radius m))

(cl:ensure-generic-function 'true_radius-val :lambda-list '(m))
(cl:defmethod true_radius-val ((m <PointObstacles>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader avoid_obstacle-msg:true_radius-val is deprecated.  Use avoid_obstacle-msg:true_radius instead.")
  (true_radius m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <PointObstacles>) ostream)
  "Serializes a message object of type '<PointObstacles>"
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'x))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'y))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'radius))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'true_radius))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <PointObstacles>) istream)
  "Deserializes a message object of type '<PointObstacles>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'x) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'y) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'radius) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'true_radius) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<PointObstacles>)))
  "Returns string type for a message object of type '<PointObstacles>"
  "avoid_obstacle/PointObstacles")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'PointObstacles)))
  "Returns string type for a message object of type 'PointObstacles"
  "avoid_obstacle/PointObstacles")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<PointObstacles>)))
  "Returns md5sum for a message object of type '<PointObstacles>"
  "cdfd5df64a7b05d16d4097ba2128a420")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'PointObstacles)))
  "Returns md5sum for a message object of type 'PointObstacles"
  "cdfd5df64a7b05d16d4097ba2128a420")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<PointObstacles>)))
  "Returns full string definition for message of type '<PointObstacles>"
  (cl:format cl:nil "float64 x                       # Central point X [m]~%float64 y                       # Central point Y [m]~%float64 radius                  # Radius with added margin [m]~%float64 true_radius             # True measured radius [m]~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'PointObstacles)))
  "Returns full string definition for message of type 'PointObstacles"
  (cl:format cl:nil "float64 x                       # Central point X [m]~%float64 y                       # Central point Y [m]~%float64 radius                  # Radius with added margin [m]~%float64 true_radius             # True measured radius [m]~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <PointObstacles>))
  (cl:+ 0
     8
     8
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <PointObstacles>))
  "Converts a ROS message object to a list"
  (cl:list 'PointObstacles
    (cl:cons ':x (x msg))
    (cl:cons ':y (y msg))
    (cl:cons ':radius (radius msg))
    (cl:cons ':true_radius (true_radius msg))
))
