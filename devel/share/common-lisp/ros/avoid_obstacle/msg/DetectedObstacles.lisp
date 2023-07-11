; Auto-generated. Do not edit!


(cl:in-package avoid_obstacle-msg)


;//! \htmlinclude DetectedObstacles.msg.html

(cl:defclass <DetectedObstacles> (roslisp-msg-protocol:ros-message)
  ((obstacles
    :reader obstacles
    :initarg :obstacles
    :type (cl:vector avoid_obstacle-msg:PointObstacles)
   :initform (cl:make-array 0 :element-type 'avoid_obstacle-msg:PointObstacles :initial-element (cl:make-instance 'avoid_obstacle-msg:PointObstacles))))
)

(cl:defclass DetectedObstacles (<DetectedObstacles>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <DetectedObstacles>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'DetectedObstacles)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name avoid_obstacle-msg:<DetectedObstacles> is deprecated: use avoid_obstacle-msg:DetectedObstacles instead.")))

(cl:ensure-generic-function 'obstacles-val :lambda-list '(m))
(cl:defmethod obstacles-val ((m <DetectedObstacles>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader avoid_obstacle-msg:obstacles-val is deprecated.  Use avoid_obstacle-msg:obstacles instead.")
  (obstacles m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DetectedObstacles>) ostream)
  "Serializes a message object of type '<DetectedObstacles>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'obstacles))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'obstacles))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DetectedObstacles>) istream)
  "Deserializes a message object of type '<DetectedObstacles>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'obstacles) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'obstacles)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'avoid_obstacle-msg:PointObstacles))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<DetectedObstacles>)))
  "Returns string type for a message object of type '<DetectedObstacles>"
  "avoid_obstacle/DetectedObstacles")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DetectedObstacles)))
  "Returns string type for a message object of type 'DetectedObstacles"
  "avoid_obstacle/DetectedObstacles")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<DetectedObstacles>)))
  "Returns md5sum for a message object of type '<DetectedObstacles>"
  "fa7a17ca5db5a73d6a4b2807ae3490ab")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DetectedObstacles)))
  "Returns md5sum for a message object of type 'DetectedObstacles"
  "fa7a17ca5db5a73d6a4b2807ae3490ab")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DetectedObstacles>)))
  "Returns full string definition for message of type '<DetectedObstacles>"
  (cl:format cl:nil "avoid_obstacle/PointObstacles[] obstacles~%~%================================================================================~%MSG: avoid_obstacle/PointObstacles~%float64 x                       # Central point X [m]~%float64 y                       # Central point Y [m]~%float64 radius                  # Radius with added margin [m]~%float64 true_radius             # True measured radius [m]~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DetectedObstacles)))
  "Returns full string definition for message of type 'DetectedObstacles"
  (cl:format cl:nil "avoid_obstacle/PointObstacles[] obstacles~%~%================================================================================~%MSG: avoid_obstacle/PointObstacles~%float64 x                       # Central point X [m]~%float64 y                       # Central point Y [m]~%float64 radius                  # Radius with added margin [m]~%float64 true_radius             # True measured radius [m]~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DetectedObstacles>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'obstacles) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DetectedObstacles>))
  "Converts a ROS message object to a list"
  (cl:list 'DetectedObstacles
    (cl:cons ':obstacles (obstacles msg))
))
