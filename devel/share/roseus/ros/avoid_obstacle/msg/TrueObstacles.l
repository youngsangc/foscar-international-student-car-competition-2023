;; Auto-generated. Do not edit!


(when (boundp 'avoid_obstacle::TrueObstacles)
  (if (not (find-package "AVOID_OBSTACLE"))
    (make-package "AVOID_OBSTACLE"))
  (shadow 'TrueObstacles (find-package "AVOID_OBSTACLE")))
(unless (find-package "AVOID_OBSTACLE::TRUEOBSTACLES")
  (make-package "AVOID_OBSTACLE::TRUEOBSTACLES"))

(in-package "ROS")
;;//! \htmlinclude TrueObstacles.msg.html


(defclass avoid_obstacle::TrueObstacles
  :super ros::object
  :slots (_detected ))

(defmethod avoid_obstacle::TrueObstacles
  (:init
   (&key
    ((:detected __detected) 0)
    )
   (send-super :init)
   (setq _detected (round __detected))
   self)
  (:detected
   (&optional __detected)
   (if __detected (setq _detected __detected)) _detected)
  (:serialization-length
   ()
   (+
    ;; int32 _detected
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int32 _detected
       (write-long _detected s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int32 _detected
     (setq _detected (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get avoid_obstacle::TrueObstacles :md5sum-) "b915f91311c8f5d6b235ceb818d53f80")
(setf (get avoid_obstacle::TrueObstacles :datatype-) "avoid_obstacle/TrueObstacles")
(setf (get avoid_obstacle::TrueObstacles :definition-)
      "int32 detected

")



(provide :avoid_obstacle/TrueObstacles "b915f91311c8f5d6b235ceb818d53f80")


