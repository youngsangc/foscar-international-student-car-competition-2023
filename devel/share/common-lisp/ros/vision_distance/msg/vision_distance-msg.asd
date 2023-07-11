
(cl:in-package :asdf)

(defsystem "vision_distance-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "Colorcone" :depends-on ("_package_Colorcone"))
    (:file "_package_Colorcone" :depends-on ("_package"))
    (:file "ColorconeArray" :depends-on ("_package_ColorconeArray"))
    (:file "_package_ColorconeArray" :depends-on ("_package"))
    (:file "ColorconeArray_lidar" :depends-on ("_package_ColorconeArray_lidar"))
    (:file "_package_ColorconeArray_lidar" :depends-on ("_package"))
    (:file "Colorcone_lidar" :depends-on ("_package_Colorcone_lidar"))
    (:file "_package_Colorcone_lidar" :depends-on ("_package"))
    (:file "Delivery" :depends-on ("_package_Delivery"))
    (:file "_package_Delivery" :depends-on ("_package"))
    (:file "DeliveryArray" :depends-on ("_package_DeliveryArray"))
    (:file "_package_DeliveryArray" :depends-on ("_package"))
  ))