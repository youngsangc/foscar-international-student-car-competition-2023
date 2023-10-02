;; Auto-generated. Do not edit!


(when (boundp 'waypoint_maker::ObjectInfo)
  (if (not (find-package "WAYPOINT_MAKER"))
    (make-package "WAYPOINT_MAKER"))
  (shadow 'ObjectInfo (find-package "WAYPOINT_MAKER")))
(unless (find-package "WAYPOINT_MAKER::OBJECTINFO")
  (make-package "WAYPOINT_MAKER::OBJECTINFO"))

(in-package "ROS")
;;//! \htmlinclude ObjectInfo.msg.html


(defclass waypoint_maker::ObjectInfo
  :super ros::object
  :slots (_total _x _y _r ))

(defmethod waypoint_maker::ObjectInfo
  (:init
   (&key
    ((:total __total) 0)
    ((:x __x) (make-array 30 :initial-element 0.0 :element-type :float))
    ((:y __y) (make-array 30 :initial-element 0.0 :element-type :float))
    ((:r __r) (make-array 30 :initial-element 0.0 :element-type :float))
    )
   (send-super :init)
   (setq _total (round __total))
   (setq _x __x)
   (setq _y __y)
   (setq _r __r)
   self)
  (:total
   (&optional __total)
   (if __total (setq _total __total)) _total)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:r
   (&optional __r)
   (if __r (setq _r __r)) _r)
  (:serialization-length
   ()
   (+
    ;; uint16 _total
    2
    ;; float64[30] _x
    (* 8    30)
    ;; float64[30] _y
    (* 8    30)
    ;; float64[30] _r
    (* 8    30)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint16 _total
       (write-word _total s)
     ;; float64[30] _x
     (dotimes (i 30)
       (sys::poke (elt _x i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;; float64[30] _y
     (dotimes (i 30)
       (sys::poke (elt _y i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;; float64[30] _r
     (dotimes (i 30)
       (sys::poke (elt _r i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint16 _total
     (setq _total (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; float64[30] _x
   (dotimes (i (length _x))
     (setf (elt _x i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     )
   ;; float64[30] _y
   (dotimes (i (length _y))
     (setf (elt _y i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     )
   ;; float64[30] _r
   (dotimes (i (length _r))
     (setf (elt _r i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     )
   ;;
   self)
  )

(setf (get waypoint_maker::ObjectInfo :md5sum-) "93078c6225133f2d27cf0a8b110ab31c")
(setf (get waypoint_maker::ObjectInfo :datatype-) "waypoint_maker/ObjectInfo")
(setf (get waypoint_maker::ObjectInfo :definition-)
      "uint16 total
float64[30] x
float64[30] y
float64[30] r
")



(provide :waypoint_maker/ObjectInfo "93078c6225133f2d27cf0a8b110ab31c")


