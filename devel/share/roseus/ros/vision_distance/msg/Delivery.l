;; Auto-generated. Do not edit!


(when (boundp 'vision_distance::Delivery)
  (if (not (find-package "VISION_DISTANCE"))
    (make-package "VISION_DISTANCE"))
  (shadow 'Delivery (find-package "VISION_DISTANCE")))
(unless (find-package "VISION_DISTANCE::DELIVERY")
  (make-package "VISION_DISTANCE::DELIVERY"))

(in-package "ROS")
;;//! \htmlinclude Delivery.msg.html


(defclass vision_distance::Delivery
  :super ros::object
  :slots (_flag _dist_x _dist_y ))

(defmethod vision_distance::Delivery
  (:init
   (&key
    ((:flag __flag) 0)
    ((:dist_x __dist_x) 0.0)
    ((:dist_y __dist_y) 0.0)
    )
   (send-super :init)
   (setq _flag (round __flag))
   (setq _dist_x (float __dist_x))
   (setq _dist_y (float __dist_y))
   self)
  (:flag
   (&optional __flag)
   (if __flag (setq _flag __flag)) _flag)
  (:dist_x
   (&optional __dist_x)
   (if __dist_x (setq _dist_x __dist_x)) _dist_x)
  (:dist_y
   (&optional __dist_y)
   (if __dist_y (setq _dist_y __dist_y)) _dist_y)
  (:serialization-length
   ()
   (+
    ;; int32 _flag
    4
    ;; float64 _dist_x
    8
    ;; float64 _dist_y
    8
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int32 _flag
       (write-long _flag s)
     ;; float64 _dist_x
       (sys::poke _dist_x (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _dist_y
       (sys::poke _dist_y (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int32 _flag
     (setq _flag (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; float64 _dist_x
     (setq _dist_x (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _dist_y
     (setq _dist_y (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;;
   self)
  )

(setf (get vision_distance::Delivery :md5sum-) "f94403809a4a82603b54e67d56403620")
(setf (get vision_distance::Delivery :datatype-) "vision_distance/Delivery")
(setf (get vision_distance::Delivery :definition-)
      "int32 flag
float64 dist_x
float64 dist_y

")



(provide :vision_distance/Delivery "f94403809a4a82603b54e67d56403620")


