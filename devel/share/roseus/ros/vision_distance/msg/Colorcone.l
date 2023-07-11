;; Auto-generated. Do not edit!


(when (boundp 'vision_distance::Colorcone)
  (if (not (find-package "VISION_DISTANCE"))
    (make-package "VISION_DISTANCE"))
  (shadow 'Colorcone (find-package "VISION_DISTANCE")))
(unless (find-package "VISION_DISTANCE::COLORCONE")
  (make-package "VISION_DISTANCE::COLORCONE"))

(in-package "ROS")
;;//! \htmlinclude Colorcone.msg.html


(defclass vision_distance::Colorcone
  :super ros::object
  :slots (_flag _x _y ))

(defmethod vision_distance::Colorcone
  (:init
   (&key
    ((:flag __flag) 0)
    ((:x __x) 0.0)
    ((:y __y) 0.0)
    )
   (send-super :init)
   (setq _flag (round __flag))
   (setq _x (float __x))
   (setq _y (float __y))
   self)
  (:flag
   (&optional __flag)
   (if __flag (setq _flag __flag)) _flag)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:serialization-length
   ()
   (+
    ;; int32 _flag
    4
    ;; float64 _x
    8
    ;; float64 _y
    8
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int32 _flag
       (write-long _flag s)
     ;; float64 _x
       (sys::poke _x (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _y
       (sys::poke _y (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int32 _flag
     (setq _flag (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; float64 _x
     (setq _x (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _y
     (setq _y (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;;
   self)
  )

(setf (get vision_distance::Colorcone :md5sum-) "d2c9ea7b706b77c8e5621805ab397745")
(setf (get vision_distance::Colorcone :datatype-) "vision_distance/Colorcone")
(setf (get vision_distance::Colorcone :definition-)
      "int32 flag
float64 x
float64 y

")



(provide :vision_distance/Colorcone "d2c9ea7b706b77c8e5621805ab397745")


