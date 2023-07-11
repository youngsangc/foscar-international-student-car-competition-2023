;; Auto-generated. Do not edit!


(when (boundp 'vision_distance::ColorconeArray_lidar)
  (if (not (find-package "VISION_DISTANCE"))
    (make-package "VISION_DISTANCE"))
  (shadow 'ColorconeArray_lidar (find-package "VISION_DISTANCE")))
(unless (find-package "VISION_DISTANCE::COLORCONEARRAY_LIDAR")
  (make-package "VISION_DISTANCE::COLORCONEARRAY_LIDAR"))

(in-package "ROS")
;;//! \htmlinclude ColorconeArray_lidar.msg.html


(defclass vision_distance::ColorconeArray_lidar
  :super ros::object
  :slots (_colorcone ))

(defmethod vision_distance::ColorconeArray_lidar
  (:init
   (&key
    ((:colorcone __colorcone) ())
    )
   (send-super :init)
   (setq _colorcone __colorcone)
   self)
  (:colorcone
   (&rest __colorcone)
   (if (keywordp (car __colorcone))
       (send* _colorcone __colorcone)
     (progn
       (if __colorcone (setq _colorcone (car __colorcone)))
       _colorcone)))
  (:serialization-length
   ()
   (+
    ;; vision_distance/Colorcone_lidar[] _colorcone
    (apply #'+ (send-all _colorcone :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; vision_distance/Colorcone_lidar[] _colorcone
     (write-long (length _colorcone) s)
     (dolist (elem _colorcone)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; vision_distance/Colorcone_lidar[] _colorcone
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _colorcone (let (r) (dotimes (i n) (push (instance vision_distance::Colorcone_lidar :init) r)) r))
     (dolist (elem- _colorcone)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get vision_distance::ColorconeArray_lidar :md5sum-) "9e6e1a7ba6469e9996876e5e3ae62dc4")
(setf (get vision_distance::ColorconeArray_lidar :datatype-) "vision_distance/ColorconeArray_lidar")
(setf (get vision_distance::ColorconeArray_lidar :definition-)
      "vision_distance/Colorcone_lidar[] colorcone

================================================================================
MSG: vision_distance/Colorcone_lidar
int32 flag
float64 dist_x
float64 dist_y
")



(provide :vision_distance/ColorconeArray_lidar "9e6e1a7ba6469e9996876e5e3ae62dc4")


