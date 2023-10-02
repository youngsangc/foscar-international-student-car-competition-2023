;; Auto-generated. Do not edit!


(when (boundp 'race::drive_values)
  (if (not (find-package "RACE"))
    (make-package "RACE"))
  (shadow 'drive_values (find-package "RACE")))
(unless (find-package "RACE::DRIVE_VALUES")
  (make-package "RACE::DRIVE_VALUES"))

(in-package "ROS")
;;//! \htmlinclude drive_values.msg.html


(defclass race::drive_values
  :super ros::object
  :slots (_throttle _steering _brake ))

(defmethod race::drive_values
  (:init
   (&key
    ((:throttle __throttle) 0)
    ((:steering __steering) 0.0)
    ((:brake __brake) 0.0)
    )
   (send-super :init)
   (setq _throttle (round __throttle))
   (setq _steering (float __steering))
   (setq _brake (float __brake))
   self)
  (:throttle
   (&optional __throttle)
   (if __throttle (setq _throttle __throttle)) _throttle)
  (:steering
   (&optional __steering)
   (if __steering (setq _steering __steering)) _steering)
  (:brake
   (&optional __brake)
   (if __brake (setq _brake __brake)) _brake)
  (:serialization-length
   ()
   (+
    ;; int16 _throttle
    2
    ;; float64 _steering
    8
    ;; float64 _brake
    8
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int16 _throttle
       (write-word _throttle s)
     ;; float64 _steering
       (sys::poke _steering (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _brake
       (sys::poke _brake (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int16 _throttle
     (setq _throttle (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; float64 _steering
     (setq _steering (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _brake
     (setq _brake (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;;
   self)
  )

(setf (get race::drive_values :md5sum-) "1426dadf0c13360c5b48826f6ea8e4b3")
(setf (get race::drive_values :datatype-) "race/drive_values")
(setf (get race::drive_values :definition-)
      "int16 throttle
float64 steering
float64 brake
")



(provide :race/drive_values "1426dadf0c13360c5b48826f6ea8e4b3")


