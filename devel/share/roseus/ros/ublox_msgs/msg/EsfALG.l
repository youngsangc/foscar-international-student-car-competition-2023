;; Auto-generated. Do not edit!


(when (boundp 'ublox_msgs::EsfALG)
  (if (not (find-package "UBLOX_MSGS"))
    (make-package "UBLOX_MSGS"))
  (shadow 'EsfALG (find-package "UBLOX_MSGS")))
(unless (find-package "UBLOX_MSGS::ESFALG")
  (make-package "UBLOX_MSGS::ESFALG"))

(in-package "ROS")
;;//! \htmlinclude EsfALG.msg.html


(intern "*CLASS_ID*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*CLASS_ID* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*CLASS_ID* 16)
(intern "*MESSAGE_ID*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*MESSAGE_ID* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*MESSAGE_ID* 20)
(intern "*FLAGS_AUTO_MNT_ALG_ON*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*FLAGS_AUTO_MNT_ALG_ON* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*FLAGS_AUTO_MNT_ALG_ON* 0)
(intern "*FLAGS_STATUS*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*FLAGS_STATUS* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*FLAGS_STATUS* 14)
(intern "*FLAGS_STATUS_USER_FIXED_ANGLES_USED*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*FLAGS_STATUS_USER_FIXED_ANGLES_USED* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*FLAGS_STATUS_USER_FIXED_ANGLES_USED* 0)
(intern "*FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING* 1)
(intern "*FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING* 2)
(intern "*FLAGS_STATUS_COARSE_ALIGNMENT_USED*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*FLAGS_STATUS_COARSE_ALIGNMENT_USED* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*FLAGS_STATUS_COARSE_ALIGNMENT_USED* 3)
(intern "*FLAGS_STATUS_FINE_ALIGNEMENT_USED*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*FLAGS_STATUS_FINE_ALIGNEMENT_USED* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*FLAGS_STATUS_FINE_ALIGNEMENT_USED* 4)
(intern "*ERROR_TILT_ARG_ERROR*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*ERROR_TILT_ARG_ERROR* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*ERROR_TILT_ARG_ERROR* 1)
(intern "*ERROR_YAW_ARG_ERROR*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*ERROR_YAW_ARG_ERROR* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*ERROR_YAW_ARG_ERROR* 2)
(intern "*ERROR_ANGLE_ERROR*" (find-package "UBLOX_MSGS::ESFALG"))
(shadow '*ERROR_ANGLE_ERROR* (find-package "UBLOX_MSGS::ESFALG"))
(defconstant ublox_msgs::EsfALG::*ERROR_ANGLE_ERROR* 3)

(defun ublox_msgs::EsfALG-to-symbol (const)
  (cond
        ((= const 16) 'ublox_msgs::EsfALG::*CLASS_ID*)
        ((= const 20) 'ublox_msgs::EsfALG::*MESSAGE_ID*)
        ((= const 0) 'ublox_msgs::EsfALG::*FLAGS_AUTO_MNT_ALG_ON*)
        ((= const 14) 'ublox_msgs::EsfALG::*FLAGS_STATUS*)
        ((= const 0) 'ublox_msgs::EsfALG::*FLAGS_STATUS_USER_FIXED_ANGLES_USED*)
        ((= const 1) 'ublox_msgs::EsfALG::*FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING*)
        ((= const 2) 'ublox_msgs::EsfALG::*FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING*)
        ((= const 3) 'ublox_msgs::EsfALG::*FLAGS_STATUS_COARSE_ALIGNMENT_USED*)
        ((= const 4) 'ublox_msgs::EsfALG::*FLAGS_STATUS_FINE_ALIGNEMENT_USED*)
        ((= const 1) 'ublox_msgs::EsfALG::*ERROR_TILT_ARG_ERROR*)
        ((= const 2) 'ublox_msgs::EsfALG::*ERROR_YAW_ARG_ERROR*)
        ((= const 3) 'ublox_msgs::EsfALG::*ERROR_ANGLE_ERROR*)
        (t nil)))

(defclass ublox_msgs::EsfALG
  :super ros::object
  :slots (_iTOW _version _flags _errors _reserved0 _yaw _pitch _roll ))

(defmethod ublox_msgs::EsfALG
  (:init
   (&key
    ((:iTOW __iTOW) 0)
    ((:version __version) 0)
    ((:flags __flags) 0)
    ((:errors __errors) 0)
    ((:reserved0 __reserved0) 0)
    ((:yaw __yaw) 0)
    ((:pitch __pitch) 0)
    ((:roll __roll) 0)
    )
   (send-super :init)
   (setq _iTOW (round __iTOW))
   (setq _version (round __version))
   (setq _flags (round __flags))
   (setq _errors (round __errors))
   (setq _reserved0 (round __reserved0))
   (setq _yaw (round __yaw))
   (setq _pitch (round __pitch))
   (setq _roll (round __roll))
   self)
  (:iTOW
   (&optional __iTOW)
   (if __iTOW (setq _iTOW __iTOW)) _iTOW)
  (:version
   (&optional __version)
   (if __version (setq _version __version)) _version)
  (:flags
   (&optional __flags)
   (if __flags (setq _flags __flags)) _flags)
  (:errors
   (&optional __errors)
   (if __errors (setq _errors __errors)) _errors)
  (:reserved0
   (&optional __reserved0)
   (if __reserved0 (setq _reserved0 __reserved0)) _reserved0)
  (:yaw
   (&optional __yaw)
   (if __yaw (setq _yaw __yaw)) _yaw)
  (:pitch
   (&optional __pitch)
   (if __pitch (setq _pitch __pitch)) _pitch)
  (:roll
   (&optional __roll)
   (if __roll (setq _roll __roll)) _roll)
  (:serialization-length
   ()
   (+
    ;; uint32 _iTOW
    4
    ;; uint8 _version
    1
    ;; uint8 _flags
    1
    ;; uint8 _errors
    1
    ;; uint8 _reserved0
    1
    ;; uint32 _yaw
    4
    ;; int16 _pitch
    2
    ;; int16 _roll
    2
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint32 _iTOW
       (write-long _iTOW s)
     ;; uint8 _version
       (write-byte _version s)
     ;; uint8 _flags
       (write-byte _flags s)
     ;; uint8 _errors
       (write-byte _errors s)
     ;; uint8 _reserved0
       (write-byte _reserved0 s)
     ;; uint32 _yaw
       (write-long _yaw s)
     ;; int16 _pitch
       (write-word _pitch s)
     ;; int16 _roll
       (write-word _roll s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint32 _iTOW
     (setq _iTOW (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint8 _version
     (setq _version (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _flags
     (setq _flags (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _errors
     (setq _errors (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _reserved0
     (setq _reserved0 (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint32 _yaw
     (setq _yaw (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int16 _pitch
     (setq _pitch (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; int16 _roll
     (setq _roll (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;;
   self)
  )

(setf (get ublox_msgs::EsfALG :md5sum-) "9a16c82ca78b0658bd506bfde3a1b262")
(setf (get ublox_msgs::EsfALG :datatype-) "ublox_msgs/EsfALG")
(setf (get ublox_msgs::EsfALG :definition-)
      "# ESF-ALG (0x10 0x14)
# IMU alignment information
#
# This message outputs the IMU alignment angles which define the rotation from the installation-frame to the
# IMU-frame. In addition, it indicates the automatic IMU-mount alignment status.
#

uint8 CLASS_ID = 16
uint8 MESSAGE_ID = 20

uint8 FLAGS_AUTO_MNT_ALG_ON = 0
uint32 FLAGS_STATUS = 14

uint8 FLAGS_STATUS_USER_FIXED_ANGLES_USED = 0
uint8 FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING = 1
uint8 FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING = 2
uint8 FLAGS_STATUS_COARSE_ALIGNMENT_USED = 3
uint8 FLAGS_STATUS_FINE_ALIGNEMENT_USED = 4

uint8 ERROR_TILT_ARG_ERROR = 1
uint8 ERROR_YAW_ARG_ERROR = 2
uint8 ERROR_ANGLE_ERROR = 3

uint32 iTOW
uint8 version
uint8 flags
uint8 errors
uint8 reserved0
uint32 yaw # IMU-mount yaw angle [0, 360]
int16 pitch # IMU-mount pitch angle [-90, 90]
int16 roll # IMU-mount roll angle [-180, 180]

")



(provide :ublox_msgs/EsfALG "9a16c82ca78b0658bd506bfde3a1b262")


