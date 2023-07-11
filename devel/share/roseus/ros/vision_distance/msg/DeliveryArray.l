;; Auto-generated. Do not edit!


(when (boundp 'vision_distance::DeliveryArray)
  (if (not (find-package "VISION_DISTANCE"))
    (make-package "VISION_DISTANCE"))
  (shadow 'DeliveryArray (find-package "VISION_DISTANCE")))
(unless (find-package "VISION_DISTANCE::DELIVERYARRAY")
  (make-package "VISION_DISTANCE::DELIVERYARRAY"))

(in-package "ROS")
;;//! \htmlinclude DeliveryArray.msg.html


(defclass vision_distance::DeliveryArray
  :super ros::object
  :slots (_visions ))

(defmethod vision_distance::DeliveryArray
  (:init
   (&key
    ((:visions __visions) ())
    )
   (send-super :init)
   (setq _visions __visions)
   self)
  (:visions
   (&rest __visions)
   (if (keywordp (car __visions))
       (send* _visions __visions)
     (progn
       (if __visions (setq _visions (car __visions)))
       _visions)))
  (:serialization-length
   ()
   (+
    ;; vision_distance/Delivery[] _visions
    (apply #'+ (send-all _visions :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; vision_distance/Delivery[] _visions
     (write-long (length _visions) s)
     (dolist (elem _visions)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; vision_distance/Delivery[] _visions
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _visions (let (r) (dotimes (i n) (push (instance vision_distance::Delivery :init) r)) r))
     (dolist (elem- _visions)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get vision_distance::DeliveryArray :md5sum-) "feb4980b2e15e2383a554067acde5244")
(setf (get vision_distance::DeliveryArray :datatype-) "vision_distance/DeliveryArray")
(setf (get vision_distance::DeliveryArray :definition-)
      "vision_distance/Delivery[] visions

================================================================================
MSG: vision_distance/Delivery
int32 flag
float64 dist_x
float64 dist_y

")



(provide :vision_distance/DeliveryArray "feb4980b2e15e2383a554067acde5244")


