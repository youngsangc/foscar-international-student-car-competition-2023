;; Auto-generated. Do not edit!


(when (boundp 'lidar_team_erp42::Boundingbox)
  (if (not (find-package "LIDAR_TEAM_ERP42"))
    (make-package "LIDAR_TEAM_ERP42"))
  (shadow 'Boundingbox (find-package "LIDAR_TEAM_ERP42")))
(unless (find-package "LIDAR_TEAM_ERP42::BOUNDINGBOX")
  (make-package "LIDAR_TEAM_ERP42::BOUNDINGBOX"))

(in-package "ROS")
;;//! \htmlinclude Boundingbox.msg.html


(defclass lidar_team_erp42::Boundingbox
  :super ros::object
  :slots (_x _y _z _volume _distance ))

(defmethod lidar_team_erp42::Boundingbox
  (:init
   (&key
    ((:x __x) 0.0)
    ((:y __y) 0.0)
    ((:z __z) 0.0)
    ((:volume __volume) 0.0)
    ((:distance __distance) 0.0)
    )
   (send-super :init)
   (setq _x (float __x))
   (setq _y (float __y))
   (setq _z (float __z))
   (setq _volume (float __volume))
   (setq _distance (float __distance))
   self)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:z
   (&optional __z)
   (if __z (setq _z __z)) _z)
  (:volume
   (&optional __volume)
   (if __volume (setq _volume __volume)) _volume)
  (:distance
   (&optional __distance)
   (if __distance (setq _distance __distance)) _distance)
  (:serialization-length
   ()
   (+
    ;; float64 _x
    8
    ;; float64 _y
    8
    ;; float64 _z
    8
    ;; float64 _volume
    8
    ;; float64 _distance
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
     ;; float64 _z
       (sys::poke _z (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _volume
       (sys::poke _volume (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _distance
       (sys::poke _distance (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float64 _x
     (setq _x (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _y
     (setq _y (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _z
     (setq _z (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _volume
     (setq _volume (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _distance
     (setq _distance (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;;
   self)
  )

(setf (get lidar_team_erp42::Boundingbox :md5sum-) "a9ca733902fb20b3437213619205592f")
(setf (get lidar_team_erp42::Boundingbox :datatype-) "lidar_team_erp42/Boundingbox")
(setf (get lidar_team_erp42::Boundingbox :definition-)
      "float64 x
float64 y
float64 z
float64 volume
float64 distance

")



(provide :lidar_team_erp42/Boundingbox "a9ca733902fb20b3437213619205592f")


