;; Auto-generated. Do not edit!


(when (boundp 'avoid_obstacle::DetectedObstacles)
  (if (not (find-package "AVOID_OBSTACLE"))
    (make-package "AVOID_OBSTACLE"))
  (shadow 'DetectedObstacles (find-package "AVOID_OBSTACLE")))
(unless (find-package "AVOID_OBSTACLE::DETECTEDOBSTACLES")
  (make-package "AVOID_OBSTACLE::DETECTEDOBSTACLES"))

(in-package "ROS")
;;//! \htmlinclude DetectedObstacles.msg.html


(defclass avoid_obstacle::DetectedObstacles
  :super ros::object
  :slots (_obstacles ))

(defmethod avoid_obstacle::DetectedObstacles
  (:init
   (&key
    ((:obstacles __obstacles) ())
    )
   (send-super :init)
   (setq _obstacles __obstacles)
   self)
  (:obstacles
   (&rest __obstacles)
   (if (keywordp (car __obstacles))
       (send* _obstacles __obstacles)
     (progn
       (if __obstacles (setq _obstacles (car __obstacles)))
       _obstacles)))
  (:serialization-length
   ()
   (+
    ;; avoid_obstacle/PointObstacles[] _obstacles
    (apply #'+ (send-all _obstacles :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; avoid_obstacle/PointObstacles[] _obstacles
     (write-long (length _obstacles) s)
     (dolist (elem _obstacles)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; avoid_obstacle/PointObstacles[] _obstacles
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _obstacles (let (r) (dotimes (i n) (push (instance avoid_obstacle::PointObstacles :init) r)) r))
     (dolist (elem- _obstacles)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get avoid_obstacle::DetectedObstacles :md5sum-) "fa7a17ca5db5a73d6a4b2807ae3490ab")
(setf (get avoid_obstacle::DetectedObstacles :datatype-) "avoid_obstacle/DetectedObstacles")
(setf (get avoid_obstacle::DetectedObstacles :definition-)
      "avoid_obstacle/PointObstacles[] obstacles

================================================================================
MSG: avoid_obstacle/PointObstacles
float64 x                       # Central point X [m]
float64 y                       # Central point Y [m]
float64 radius                  # Radius with added margin [m]
float64 true_radius             # True measured radius [m]
")



(provide :avoid_obstacle/DetectedObstacles "fa7a17ca5db5a73d6a4b2807ae3490ab")


