;; Auto-generated. Do not edit!


(when (boundp 'ublox_msgs::NavHPPOSECEF)
  (if (not (find-package "UBLOX_MSGS"))
    (make-package "UBLOX_MSGS"))
  (shadow 'NavHPPOSECEF (find-package "UBLOX_MSGS")))
(unless (find-package "UBLOX_MSGS::NAVHPPOSECEF")
  (make-package "UBLOX_MSGS::NAVHPPOSECEF"))

(in-package "ROS")
;;//! \htmlinclude NavHPPOSECEF.msg.html


(intern "*CLASS_ID*" (find-package "UBLOX_MSGS::NAVHPPOSECEF"))
(shadow '*CLASS_ID* (find-package "UBLOX_MSGS::NAVHPPOSECEF"))
(defconstant ublox_msgs::NavHPPOSECEF::*CLASS_ID* 1)
(intern "*MESSAGE_ID*" (find-package "UBLOX_MSGS::NAVHPPOSECEF"))
(shadow '*MESSAGE_ID* (find-package "UBLOX_MSGS::NAVHPPOSECEF"))
(defconstant ublox_msgs::NavHPPOSECEF::*MESSAGE_ID* 19)

(defun ublox_msgs::NavHPPOSECEF-to-symbol (const)
  (cond
        ((= const 1) 'ublox_msgs::NavHPPOSECEF::*CLASS_ID*)
        ((= const 19) 'ublox_msgs::NavHPPOSECEF::*MESSAGE_ID*)
        (t nil)))

(defclass ublox_msgs::NavHPPOSECEF
  :super ros::object
  :slots (_version _reserved0 _iTOW _ecefX _ecefY _ecefZ _ecefXHp _ecefYHp _ecefZHp _flags _pAcc ))

(defmethod ublox_msgs::NavHPPOSECEF
  (:init
   (&key
    ((:version __version) 0)
    ((:reserved0 __reserved0) (make-array 3 :initial-element 0 :element-type :char))
    ((:iTOW __iTOW) 0)
    ((:ecefX __ecefX) 0)
    ((:ecefY __ecefY) 0)
    ((:ecefZ __ecefZ) 0)
    ((:ecefXHp __ecefXHp) 0)
    ((:ecefYHp __ecefYHp) 0)
    ((:ecefZHp __ecefZHp) 0)
    ((:flags __flags) 0)
    ((:pAcc __pAcc) 0)
    )
   (send-super :init)
   (setq _version (round __version))
   (setq _reserved0 __reserved0)
   (setq _iTOW (round __iTOW))
   (setq _ecefX (round __ecefX))
   (setq _ecefY (round __ecefY))
   (setq _ecefZ (round __ecefZ))
   (setq _ecefXHp (round __ecefXHp))
   (setq _ecefYHp (round __ecefYHp))
   (setq _ecefZHp (round __ecefZHp))
   (setq _flags (round __flags))
   (setq _pAcc (round __pAcc))
   self)
  (:version
   (&optional __version)
   (if __version (setq _version __version)) _version)
  (:reserved0
   (&optional __reserved0)
   (if __reserved0 (setq _reserved0 __reserved0)) _reserved0)
  (:iTOW
   (&optional __iTOW)
   (if __iTOW (setq _iTOW __iTOW)) _iTOW)
  (:ecefX
   (&optional __ecefX)
   (if __ecefX (setq _ecefX __ecefX)) _ecefX)
  (:ecefY
   (&optional __ecefY)
   (if __ecefY (setq _ecefY __ecefY)) _ecefY)
  (:ecefZ
   (&optional __ecefZ)
   (if __ecefZ (setq _ecefZ __ecefZ)) _ecefZ)
  (:ecefXHp
   (&optional __ecefXHp)
   (if __ecefXHp (setq _ecefXHp __ecefXHp)) _ecefXHp)
  (:ecefYHp
   (&optional __ecefYHp)
   (if __ecefYHp (setq _ecefYHp __ecefYHp)) _ecefYHp)
  (:ecefZHp
   (&optional __ecefZHp)
   (if __ecefZHp (setq _ecefZHp __ecefZHp)) _ecefZHp)
  (:flags
   (&optional __flags)
   (if __flags (setq _flags __flags)) _flags)
  (:pAcc
   (&optional __pAcc)
   (if __pAcc (setq _pAcc __pAcc)) _pAcc)
  (:serialization-length
   ()
   (+
    ;; uint8 _version
    1
    ;; uint8[3] _reserved0
    (* 1    3)
    ;; uint32 _iTOW
    4
    ;; int32 _ecefX
    4
    ;; int32 _ecefY
    4
    ;; int32 _ecefZ
    4
    ;; int8 _ecefXHp
    1
    ;; int8 _ecefYHp
    1
    ;; int8 _ecefZHp
    1
    ;; uint8 _flags
    1
    ;; uint32 _pAcc
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint8 _version
       (write-byte _version s)
     ;; uint8[3] _reserved0
     (princ _reserved0 s)
     ;; uint32 _iTOW
       (write-long _iTOW s)
     ;; int32 _ecefX
       (write-long _ecefX s)
     ;; int32 _ecefY
       (write-long _ecefY s)
     ;; int32 _ecefZ
       (write-long _ecefZ s)
     ;; int8 _ecefXHp
       (write-byte _ecefXHp s)
     ;; int8 _ecefYHp
       (write-byte _ecefYHp s)
     ;; int8 _ecefZHp
       (write-byte _ecefZHp s)
     ;; uint8 _flags
       (write-byte _flags s)
     ;; uint32 _pAcc
       (write-long _pAcc s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8 _version
     (setq _version (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8[3] _reserved0
   (setq _reserved0 (make-array 3 :element-type :char))
   (replace _reserved0 buf :start2 ptr-) (incf ptr- 3)
   ;; uint32 _iTOW
     (setq _iTOW (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _ecefX
     (setq _ecefX (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _ecefY
     (setq _ecefY (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _ecefZ
     (setq _ecefZ (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int8 _ecefXHp
     (setq _ecefXHp (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _ecefXHp 127) (setq _ecefXHp (- _ecefXHp 256)))
   ;; int8 _ecefYHp
     (setq _ecefYHp (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _ecefYHp 127) (setq _ecefYHp (- _ecefYHp 256)))
   ;; int8 _ecefZHp
     (setq _ecefZHp (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _ecefZHp 127) (setq _ecefZHp (- _ecefZHp 256)))
   ;; uint8 _flags
     (setq _flags (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint32 _pAcc
     (setq _pAcc (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get ublox_msgs::NavHPPOSECEF :md5sum-) "41fbf0937e53f84ca89afe3287f85e50")
(setf (get ublox_msgs::NavHPPOSECEF :datatype-) "ublox_msgs/NavHPPOSECEF")
(setf (get ublox_msgs::NavHPPOSECEF :definition-)
      "# NAV-HPPOSECEF (0x01 0x13)
# High Precision Position Solution in ECEF
#
# See important comments concerning validity of position given in section
# Navigation Output Filters.
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 19

uint8 version
uint8[3] reserved0

uint32 iTOW             # GPS Millisecond Time of Week [ms]

int32 ecefX             # ECEF X coordinate [cm]
int32 ecefY             # ECEF Y coordinate [cm]
int32 ecefZ             # ECEF Z coordinate [cm]

int8 ecefXHp            # ECEF X high precision component [0.1mm]
int8 ecefYHp            # ECEF Y high precision component [0.1mm]
int8 ecefZHp            # ECEF Z high precision component [0.1mm]
uint8 flags

uint32 pAcc             # Position Accuracy Estimate [0.1mm]

")



(provide :ublox_msgs/NavHPPOSECEF "41fbf0937e53f84ca89afe3287f85e50")


