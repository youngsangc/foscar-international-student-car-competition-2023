; Auto-generated. Do not edit!


(cl:in-package vision_distance-msg)


;//! \htmlinclude DeliveryArray.msg.html

(cl:defclass <DeliveryArray> (roslisp-msg-protocol:ros-message)
  ((visions
    :reader visions
    :initarg :visions
    :type (cl:vector vision_distance-msg:Delivery)
   :initform (cl:make-array 0 :element-type 'vision_distance-msg:Delivery :initial-element (cl:make-instance 'vision_distance-msg:Delivery))))
)

(cl:defclass DeliveryArray (<DeliveryArray>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <DeliveryArray>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'DeliveryArray)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name vision_distance-msg:<DeliveryArray> is deprecated: use vision_distance-msg:DeliveryArray instead.")))

(cl:ensure-generic-function 'visions-val :lambda-list '(m))
(cl:defmethod visions-val ((m <DeliveryArray>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader vision_distance-msg:visions-val is deprecated.  Use vision_distance-msg:visions instead.")
  (visions m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DeliveryArray>) ostream)
  "Serializes a message object of type '<DeliveryArray>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'visions))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'visions))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DeliveryArray>) istream)
  "Deserializes a message object of type '<DeliveryArray>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'visions) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'visions)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'vision_distance-msg:Delivery))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<DeliveryArray>)))
  "Returns string type for a message object of type '<DeliveryArray>"
  "vision_distance/DeliveryArray")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DeliveryArray)))
  "Returns string type for a message object of type 'DeliveryArray"
  "vision_distance/DeliveryArray")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<DeliveryArray>)))
  "Returns md5sum for a message object of type '<DeliveryArray>"
  "feb4980b2e15e2383a554067acde5244")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DeliveryArray)))
  "Returns md5sum for a message object of type 'DeliveryArray"
  "feb4980b2e15e2383a554067acde5244")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DeliveryArray>)))
  "Returns full string definition for message of type '<DeliveryArray>"
  (cl:format cl:nil "vision_distance/Delivery[] visions~%~%================================================================================~%MSG: vision_distance/Delivery~%int32 flag~%float64 dist_x~%float64 dist_y~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DeliveryArray)))
  "Returns full string definition for message of type 'DeliveryArray"
  (cl:format cl:nil "vision_distance/Delivery[] visions~%~%================================================================================~%MSG: vision_distance/Delivery~%int32 flag~%float64 dist_x~%float64 dist_y~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DeliveryArray>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'visions) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DeliveryArray>))
  "Converts a ROS message object to a list"
  (cl:list 'DeliveryArray
    (cl:cons ':visions (visions msg))
))
