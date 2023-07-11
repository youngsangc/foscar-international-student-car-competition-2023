;; Auto-generated. Do not edit!


(when (boundp 'track_race::Steering)
  (if (not (find-package "TRACK_RACE"))
    (make-package "TRACK_RACE"))
  (shadow 'Steering (find-package "TRACK_RACE")))
(unless (find-package "TRACK_RACE::STEERING")
  (make-package "TRACK_RACE::STEERING"))

(in-package "ROS")
;;//! \htmlinclude Steering.msg.html


(defclass track_race::Steering
  :super ros::object
  :slots (_steering ))

(defmethod track_race::Steering
  (:init
   (&key
    ((:steering __steering) 0.0)
    )
   (send-super :init)
   (setq _steering (float __steering))
   self)
  (:steering
   (&optional __steering)
   (if __steering (setq _steering __steering)) _steering)
  (:serialization-length
   ()
   (+
    ;; float32 _steering
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _steering
       (sys::poke _steering (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _steering
     (setq _steering (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get track_race::Steering :md5sum-) "5e5c60c40f2709684823442181fe6011")
(setf (get track_race::Steering :datatype-) "track_race/Steering")
(setf (get track_race::Steering :definition-)
      "float32 steering

")



(provide :track_race/Steering "5e5c60c40f2709684823442181fe6011")


