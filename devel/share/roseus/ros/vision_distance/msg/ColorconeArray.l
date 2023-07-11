;; Auto-generated. Do not edit!


(when (boundp 'vision_distance::ColorconeArray)
  (if (not (find-package "VISION_DISTANCE"))
    (make-package "VISION_DISTANCE"))
  (shadow 'ColorconeArray (find-package "VISION_DISTANCE")))
(unless (find-package "VISION_DISTANCE::COLORCONEARRAY")
  (make-package "VISION_DISTANCE::COLORCONEARRAY"))

(in-package "ROS")
;;//! \htmlinclude ColorconeArray.msg.html


(defclass vision_distance::ColorconeArray
  :super ros::object
  :slots (_visions ))

(defmethod vision_distance::ColorconeArray
  (:init
   (&key
    ((:visions __visions) ())
    )
   (send-super :init)
   (setq _visions __visions)
   self)
  (:visions
   (&rest __visions)
   (if (keywordp (car __visions))
       (send* _visions __visions)
     (progn
       (if __visions (setq _visions (car __visions)))
       _visions)))
  (:serialization-length
   ()
   (+
    ;; vision_distance/Colorcone[] _visions
    (apply #'+ (send-all _visions :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; vision_distance/Colorcone[] _visions
     (write-long (length _visions) s)
     (dolist (elem _visions)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; vision_distance/Colorcone[] _visions
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _visions (let (r) (dotimes (i n) (push (instance vision_distance::Colorcone :init) r)) r))
     (dolist (elem- _visions)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get vision_distance::ColorconeArray :md5sum-) "ac69fdcb59f6be81c060279a9cb29dcb")
(setf (get vision_distance::ColorconeArray :datatype-) "vision_distance/ColorconeArray")
(setf (get vision_distance::ColorconeArray :definition-)
      "vision_distance/Colorcone[] visions

================================================================================
MSG: vision_distance/Colorcone
int32 flag
float64 x
float64 y

")



(provide :vision_distance/ColorconeArray "ac69fdcb59f6be81c060279a9cb29dcb")


