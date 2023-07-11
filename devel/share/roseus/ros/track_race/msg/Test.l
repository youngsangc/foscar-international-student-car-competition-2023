;; Auto-generated. Do not edit!


(when (boundp 'track_race::Test)
  (if (not (find-package "TRACK_RACE"))
    (make-package "TRACK_RACE"))
  (shadow 'Test (find-package "TRACK_RACE")))
(unless (find-package "TRACK_RACE::TEST")
  (make-package "TRACK_RACE::TEST"))

(in-package "ROS")
;;//! \htmlinclude Test.msg.html


(defclass track_race::Test
  :super ros::object
  :slots (_delta _speed ))

(defmethod track_race::Test
  (:init
   (&key
    ((:delta __delta) 0.0)
    ((:speed __speed) 0.0)
    )
   (send-super :init)
   (setq _delta (float __delta))
   (setq _speed (float __speed))
   self)
  (:delta
   (&optional __delta)
   (if __delta (setq _delta __delta)) _delta)
  (:speed
   (&optional __speed)
   (if __speed (setq _speed __speed)) _speed)
  (:serialization-length
   ()
   (+
    ;; float32 _delta
    4
    ;; float32 _speed
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _delta
       (sys::poke _delta (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _speed
       (sys::poke _speed (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _delta
     (setq _delta (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _speed
     (setq _speed (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get track_race::Test :md5sum-) "6d9346376c8249865364e5146af93372")
(setf (get track_race::Test :datatype-) "track_race/Test")
(setf (get track_race::Test :definition-)
      "float32 delta
float32 speed
")



(provide :track_race/Test "6d9346376c8249865364e5146af93372")


