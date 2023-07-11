; Auto-generated. Do not edit!


(cl:in-package vision_distance-msg)


;//! \htmlinclude ColorconeArray_lidar.msg.html

(cl:defclass <ColorconeArray_lidar> (roslisp-msg-protocol:ros-message)
  ((colorcone
    :reader colorcone
    :initarg :colorcone
    :type (cl:vector vision_distance-msg:Colorcone_lidar)
   :initform (cl:make-array 0 :element-type 'vision_distance-msg:Colorcone_lidar :initial-element (cl:make-instance 'vision_distance-msg:Colorcone_lidar))))
)

(cl:defclass ColorconeArray_lidar (<ColorconeArray_lidar>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ColorconeArray_lidar>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ColorconeArray_lidar)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name vision_distance-msg:<ColorconeArray_lidar> is deprecated: use vision_distance-msg:ColorconeArray_lidar instead.")))

(cl:ensure-generic-function 'colorcone-val :lambda-list '(m))
(cl:defmethod colorcone-val ((m <ColorconeArray_lidar>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader vision_distance-msg:colorcone-val is deprecated.  Use vision_distance-msg:colorcone instead.")
  (colorcone m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ColorconeArray_lidar>) ostream)
  "Serializes a message object of type '<ColorconeArray_lidar>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'colorcone))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'colorcone))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ColorconeArray_lidar>) istream)
  "Deserializes a message object of type '<ColorconeArray_lidar>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'colorcone) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'colorcone)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'vision_distance-msg:Colorcone_lidar))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ColorconeArray_lidar>)))
  "Returns string type for a message object of type '<ColorconeArray_lidar>"
  "vision_distance/ColorconeArray_lidar")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ColorconeArray_lidar)))
  "Returns string type for a message object of type 'ColorconeArray_lidar"
  "vision_distance/ColorconeArray_lidar")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ColorconeArray_lidar>)))
  "Returns md5sum for a message object of type '<ColorconeArray_lidar>"
  "9e6e1a7ba6469e9996876e5e3ae62dc4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ColorconeArray_lidar)))
  "Returns md5sum for a message object of type 'ColorconeArray_lidar"
  "9e6e1a7ba6469e9996876e5e3ae62dc4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ColorconeArray_lidar>)))
  "Returns full string definition for message of type '<ColorconeArray_lidar>"
  (cl:format cl:nil "vision_distance/Colorcone_lidar[] colorcone~%~%================================================================================~%MSG: vision_distance/Colorcone_lidar~%int32 flag~%float64 dist_x~%float64 dist_y~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ColorconeArray_lidar)))
  "Returns full string definition for message of type 'ColorconeArray_lidar"
  (cl:format cl:nil "vision_distance/Colorcone_lidar[] colorcone~%~%================================================================================~%MSG: vision_distance/Colorcone_lidar~%int32 flag~%float64 dist_x~%float64 dist_y~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ColorconeArray_lidar>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'colorcone) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ColorconeArray_lidar>))
  "Converts a ROS message object to a list"
  (cl:list 'ColorconeArray_lidar
    (cl:cons ':colorcone (colorcone msg))
))
