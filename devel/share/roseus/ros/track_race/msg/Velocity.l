;; Auto-generated. Do not edit!


(when (boundp 'track_race::Velocity)
  (if (not (find-package "TRACK_RACE"))
    (make-package "TRACK_RACE"))
  (shadow 'Velocity (find-package "TRACK_RACE")))
(unless (find-package "TRACK_RACE::VELOCITY")
  (make-package "TRACK_RACE::VELOCITY"))

(in-package "ROS")
;;//! \htmlinclude Velocity.msg.html


(defclass track_race::Velocity
  :super ros::object
  :slots (_velocity ))

(defmethod track_race::Velocity
  (:init
   (&key
    ((:velocity __velocity) 0.0)
    )
   (send-super :init)
   (setq _velocity (float __velocity))
   self)
  (:velocity
   (&optional __velocity)
   (if __velocity (setq _velocity __velocity)) _velocity)
  (:serialization-length
   ()
   (+
    ;; float32 _velocity
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _velocity
       (sys::poke _velocity (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _velocity
     (setq _velocity (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get track_race::Velocity :md5sum-) "e4ff88b32504f688719a85e0753f63ce")
(setf (get track_race::Velocity :datatype-) "track_race/Velocity")
(setf (get track_race::Velocity :definition-)
      "float32 velocity
")



(provide :track_race/Velocity "e4ff88b32504f688719a85e0753f63ce")


