;; Auto-generated. Do not edit!


(when (boundp 'avoid_obstacle::PointObstacles)
  (if (not (find-package "AVOID_OBSTACLE"))
    (make-package "AVOID_OBSTACLE"))
  (shadow 'PointObstacles (find-package "AVOID_OBSTACLE")))
(unless (find-package "AVOID_OBSTACLE::POINTOBSTACLES")
  (make-package "AVOID_OBSTACLE::POINTOBSTACLES"))

(in-package "ROS")
;;//! \htmlinclude PointObstacles.msg.html


(defclass avoid_obstacle::PointObstacles
  :super ros::object
  :slots (_x _y _radius _true_radius ))

(defmethod avoid_obstacle::PointObstacles
  (:init
   (&key
    ((:x __x) 0.0)
    ((:y __y) 0.0)
    ((:radius __radius) 0.0)
    ((:true_radius __true_radius) 0.0)
    )
   (send-super :init)
   (setq _x (float __x))
   (setq _y (float __y))
   (setq _radius (float __radius))
   (setq _true_radius (float __true_radius))
   self)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:radius
   (&optional __radius)
   (if __radius (setq _radius __radius)) _radius)
  (:true_radius
   (&optional __true_radius)
   (if __true_radius (setq _true_radius __true_radius)) _true_radius)
  (:serialization-length
   ()
   (+
    ;; float64 _x
    8
    ;; float64 _y
    8
    ;; float64 _radius
    8
    ;; float64 _true_radius
    8
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float64 _x
       (sys::poke _x (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _y
       (sys::poke _y (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _radius
       (sys::poke _radius (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _true_radius
       (sys::poke _true_radius (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float64 _x
     (setq _x (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _y
     (setq _y (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _radius
     (setq _radius (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _true_radius
     (setq _true_radius (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;;
   self)
  )

(setf (get avoid_obstacle::PointObstacles :md5sum-) "cdfd5df64a7b05d16d4097ba2128a420")
(setf (get avoid_obstacle::PointObstacles :datatype-) "avoid_obstacle/PointObstacles")
(setf (get avoid_obstacle::PointObstacles :definition-)
      "float64 x                       # Central point X [m]
float64 y                       # Central point Y [m]
float64 radius                  # Radius with added margin [m]
float64 true_radius             # True measured radius [m]
")



(provide :avoid_obstacle/PointObstacles "cdfd5df64a7b05d16d4097ba2128a420")


