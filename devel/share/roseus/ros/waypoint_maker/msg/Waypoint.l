;; Auto-generated. Do not edit!


(when (boundp 'waypoint_maker::Waypoint)
  (if (not (find-package "WAYPOINT_MAKER"))
    (make-package "WAYPOINT_MAKER"))
  (shadow 'Waypoint (find-package "WAYPOINT_MAKER")))
(unless (find-package "WAYPOINT_MAKER::WAYPOINT")
  (make-package "WAYPOINT_MAKER::WAYPOINT"))

(in-package "ROS")
;;//! \htmlinclude Waypoint.msg.html


(defclass waypoint_maker::Waypoint
  :super ros::object
  :slots (_cnt _x_arr _y_arr ))

(defmethod waypoint_maker::Waypoint
  (:init
   (&key
    ((:cnt __cnt) 0)
    ((:x_arr __x_arr) (make-array 200 :initial-element 0.0 :element-type :float))
    ((:y_arr __y_arr) (make-array 200 :initial-element 0.0 :element-type :float))
    )
   (send-super :init)
   (setq _cnt (round __cnt))
   (setq _x_arr __x_arr)
   (setq _y_arr __y_arr)
   self)
  (:cnt
   (&optional __cnt)
   (if __cnt (setq _cnt __cnt)) _cnt)
  (:x_arr
   (&optional __x_arr)
   (if __x_arr (setq _x_arr __x_arr)) _x_arr)
  (:y_arr
   (&optional __y_arr)
   (if __y_arr (setq _y_arr __y_arr)) _y_arr)
  (:serialization-length
   ()
   (+
    ;; int32 _cnt
    4
    ;; float32[200] _x_arr
    (* 4    200)
    ;; float32[200] _y_arr
    (* 4    200)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int32 _cnt
       (write-long _cnt s)
     ;; float32[200] _x_arr
     (dotimes (i 200)
       (sys::poke (elt _x_arr i) (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
       )
     ;; float32[200] _y_arr
     (dotimes (i 200)
       (sys::poke (elt _y_arr i) (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int32 _cnt
     (setq _cnt (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; float32[200] _x_arr
   (dotimes (i (length _x_arr))
     (setf (elt _x_arr i) (sys::peek buf ptr- :float)) (incf ptr- 4)
     )
   ;; float32[200] _y_arr
   (dotimes (i (length _y_arr))
     (setf (elt _y_arr i) (sys::peek buf ptr- :float)) (incf ptr- 4)
     )
   ;;
   self)
  )

(setf (get waypoint_maker::Waypoint :md5sum-) "ef3b913564c2c1d5123a607b0c2cca14")
(setf (get waypoint_maker::Waypoint :datatype-) "waypoint_maker/Waypoint")
(setf (get waypoint_maker::Waypoint :definition-)
      "int32 cnt
float32[200] x_arr
float32[200] y_arr

")



(provide :waypoint_maker/Waypoint "ef3b913564c2c1d5123a607b0c2cca14")


