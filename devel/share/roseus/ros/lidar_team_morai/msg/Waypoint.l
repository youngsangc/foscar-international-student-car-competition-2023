;; Auto-generated. Do not edit!


(when (boundp 'lidar_team_morai::Waypoint)
  (if (not (find-package "LIDAR_TEAM_MORAI"))
    (make-package "LIDAR_TEAM_MORAI"))
  (shadow 'Waypoint (find-package "LIDAR_TEAM_MORAI")))
(unless (find-package "LIDAR_TEAM_MORAI::WAYPOINT")
  (make-package "LIDAR_TEAM_MORAI::WAYPOINT"))

(in-package "ROS")
;;//! \htmlinclude Waypoint.msg.html


(defclass lidar_team_morai::Waypoint
  :super ros::object
  :slots (_cnt _x_arr _y_arr _tangent ))

(defmethod lidar_team_morai::Waypoint
  (:init
   (&key
    ((:cnt __cnt) 0)
    ((:x_arr __x_arr) (make-array 200 :initial-element 0.0 :element-type :float))
    ((:y_arr __y_arr) (make-array 200 :initial-element 0.0 :element-type :float))
    ((:tangent __tangent) 0.0)
    )
   (send-super :init)
   (setq _cnt (round __cnt))
   (setq _x_arr __x_arr)
   (setq _y_arr __y_arr)
   (setq _tangent (float __tangent))
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
  (:tangent
   (&optional __tangent)
   (if __tangent (setq _tangent __tangent)) _tangent)
  (:serialization-length
   ()
   (+
    ;; int32 _cnt
    4
    ;; float32[200] _x_arr
    (* 4    200)
    ;; float32[200] _y_arr
    (* 4    200)
    ;; float32 _tangent
    4
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
     ;; float32 _tangent
       (sys::poke _tangent (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
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
   ;; float32 _tangent
     (setq _tangent (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get lidar_team_morai::Waypoint :md5sum-) "9cd343b2e99d9973cec61868c04b75bc")
(setf (get lidar_team_morai::Waypoint :datatype-) "lidar_team_morai/Waypoint")
(setf (get lidar_team_morai::Waypoint :definition-)
      "int32 cnt
float32[200] x_arr
float32[200] y_arr
float32 tangent
")



(provide :lidar_team_morai/Waypoint "9cd343b2e99d9973cec61868c04b75bc")


