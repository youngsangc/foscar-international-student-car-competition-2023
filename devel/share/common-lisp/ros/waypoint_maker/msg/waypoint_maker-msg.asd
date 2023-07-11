
(cl:in-package :asdf)

(defsystem "waypoint_maker-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "Boundingbox" :depends-on ("_package_Boundingbox"))
    (:file "_package_Boundingbox" :depends-on ("_package"))
    (:file "DynamicVelocity" :depends-on ("_package_DynamicVelocity"))
    (:file "_package_DynamicVelocity" :depends-on ("_package"))
    (:file "ObjectInfo" :depends-on ("_package_ObjectInfo"))
    (:file "_package_ObjectInfo" :depends-on ("_package"))
    (:file "VescState" :depends-on ("_package_VescState"))
    (:file "_package_VescState" :depends-on ("_package"))
    (:file "VescStateStamped" :depends-on ("_package_VescStateStamped"))
    (:file "_package_VescStateStamped" :depends-on ("_package"))
    (:file "Waypoint" :depends-on ("_package_Waypoint"))
    (:file "_package_Waypoint" :depends-on ("_package"))
  ))