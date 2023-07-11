;; Auto-generated. Do not edit!


(when (boundp 'lidar_team_erp42::DynamicVelocity)
  (if (not (find-package "LIDAR_TEAM_ERP42"))
    (make-package "LIDAR_TEAM_ERP42"))
  (shadow 'DynamicVelocity (find-package "LIDAR_TEAM_ERP42")))
(unless (find-package "LIDAR_TEAM_ERP42::DYNAMICVELOCITY")
  (make-package "LIDAR_TEAM_ERP42::DYNAMICVELOCITY"))

(in-package "ROS")
;;//! \htmlinclude DynamicVelocity.msg.html


(defclass lidar_team_erp42::DynamicVelocity
  :super ros::object
  :slots (_throttle ))

(defmethod lidar_team_erp42::DynamicVelocity
  (:init
   (&key
    ((:throttle __throttle) 0.0)
    )
   (send-super :init)
   (setq _throttle (float __throttle))
   self)
  (:throttle
   (&optional __throttle)
   (if __throttle (setq _throttle __throttle)) _throttle)
  (:serialization-length
   ()
   (+
    ;; float64 _throttle
    8
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float64 _throttle
       (sys::poke _throttle (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float64 _throttle
     (setq _throttle (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;;
   self)
  )

(setf (get lidar_team_erp42::DynamicVelocity :md5sum-) "a0e4c91f838bf9ac9a81509ea028ea0b")
(setf (get lidar_team_erp42::DynamicVelocity :datatype-) "lidar_team_erp42/DynamicVelocity")
(setf (get lidar_team_erp42::DynamicVelocity :definition-)
      "float64 throttle
")



(provide :lidar_team_erp42/DynamicVelocity "a0e4c91f838bf9ac9a81509ea028ea0b")


