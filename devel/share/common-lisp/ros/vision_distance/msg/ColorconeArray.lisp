; Auto-generated. Do not edit!


(cl:in-package vision_distance-msg)


;//! \htmlinclude ColorconeArray.msg.html

(cl:defclass <ColorconeArray> (roslisp-msg-protocol:ros-message)
  ((visions
    :reader visions
    :initarg :visions
    :type (cl:vector vision_distance-msg:Colorcone)
   :initform (cl:make-array 0 :element-type 'vision_distance-msg:Colorcone :initial-element (cl:make-instance 'vision_distance-msg:Colorcone))))
)

(cl:defclass ColorconeArray (<ColorconeArray>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ColorconeArray>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ColorconeArray)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name vision_distance-msg:<ColorconeArray> is deprecated: use vision_distance-msg:ColorconeArray instead.")))

(cl:ensure-generic-function 'visions-val :lambda-list '(m))
(cl:defmethod visions-val ((m <ColorconeArray>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader vision_distance-msg:visions-val is deprecated.  Use vision_distance-msg:visions instead.")
  (visions m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ColorconeArray>) ostream)
  "Serializes a message object of type '<ColorconeArray>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'visions))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'visions))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ColorconeArray>) istream)
  "Deserializes a message object of type '<ColorconeArray>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'visions) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'visions)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'vision_distance-msg:Colorcone))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ColorconeArray>)))
  "Returns string type for a message object of type '<ColorconeArray>"
  "vision_distance/ColorconeArray")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ColorconeArray)))
  "Returns string type for a message object of type 'ColorconeArray"
  "vision_distance/ColorconeArray")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ColorconeArray>)))
  "Returns md5sum for a message object of type '<ColorconeArray>"
  "ac69fdcb59f6be81c060279a9cb29dcb")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ColorconeArray)))
  "Returns md5sum for a message object of type 'ColorconeArray"
  "ac69fdcb59f6be81c060279a9cb29dcb")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ColorconeArray>)))
  "Returns full string definition for message of type '<ColorconeArray>"
  (cl:format cl:nil "vision_distance/Colorcone[] visions~%~%================================================================================~%MSG: vision_distance/Colorcone~%int32 flag~%float64 x~%float64 y~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ColorconeArray)))
  "Returns full string definition for message of type 'ColorconeArray"
  (cl:format cl:nil "vision_distance/Colorcone[] visions~%~%================================================================================~%MSG: vision_distance/Colorcone~%int32 flag~%float64 x~%float64 y~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ColorconeArray>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'visions) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ColorconeArray>))
  "Converts a ROS message object to a list"
  (cl:list 'ColorconeArray
    (cl:cons ':visions (visions msg))
))
