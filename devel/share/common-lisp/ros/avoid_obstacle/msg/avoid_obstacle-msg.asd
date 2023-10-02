
(cl:in-package :asdf)

(defsystem "avoid_obstacle-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "DetectedObstacles" :depends-on ("_package_DetectedObstacles"))
    (:file "_package_DetectedObstacles" :depends-on ("_package"))
    (:file "PointObstacles" :depends-on ("_package_PointObstacles"))
    (:file "_package_PointObstacles" :depends-on ("_package"))
    (:file "TrueObstacles" :depends-on ("_package_TrueObstacles"))
    (:file "_package_TrueObstacles" :depends-on ("_package"))
  ))