;; Auto-generated. Do not edit!


(when (boundp 'ublox_msgs::NavHPPOSLLH)
  (if (not (find-package "UBLOX_MSGS"))
    (make-package "UBLOX_MSGS"))
  (shadow 'NavHPPOSLLH (find-package "UBLOX_MSGS")))
(unless (find-package "UBLOX_MSGS::NAVHPPOSLLH")
  (make-package "UBLOX_MSGS::NAVHPPOSLLH"))

(in-package "ROS")
;;//! \htmlinclude NavHPPOSLLH.msg.html


(intern "*CLASS_ID*" (find-package "UBLOX_MSGS::NAVHPPOSLLH"))
(shadow '*CLASS_ID* (find-package "UBLOX_MSGS::NAVHPPOSLLH"))
(defconstant ublox_msgs::NavHPPOSLLH::*CLASS_ID* 1)
(intern "*MESSAGE_ID*" (find-package "UBLOX_MSGS::NAVHPPOSLLH"))
(shadow '*MESSAGE_ID* (find-package "UBLOX_MSGS::NAVHPPOSLLH"))
(defconstant ublox_msgs::NavHPPOSLLH::*MESSAGE_ID* 20)

(defun ublox_msgs::NavHPPOSLLH-to-symbol (const)
  (cond
        ((= const 1) 'ublox_msgs::NavHPPOSLLH::*CLASS_ID*)
        ((= const 20) 'ublox_msgs::NavHPPOSLLH::*MESSAGE_ID*)
        (t nil)))

(defclass ublox_msgs::NavHPPOSLLH
  :super ros::object
  :slots (_version _reserved1 _invalid_llh _iTOW _lon _lat _height _hMSL _lonHp _latHp _heightHp _hMSLHp _hAcc _vAcc ))

(defmethod ublox_msgs::NavHPPOSLLH
  (:init
   (&key
    ((:version __version) 0)
    ((:reserved1 __reserved1) (make-array 2 :initial-element 0 :element-type :char))
    ((:invalid_llh __invalid_llh) 0)
    ((:iTOW __iTOW) 0)
    ((:lon __lon) 0)
    ((:lat __lat) 0)
    ((:height __height) 0)
    ((:hMSL __hMSL) 0)
    ((:lonHp __lonHp) 0)
    ((:latHp __latHp) 0)
    ((:heightHp __heightHp) 0)
    ((:hMSLHp __hMSLHp) 0)
    ((:hAcc __hAcc) 0)
    ((:vAcc __vAcc) 0)
    )
   (send-super :init)
   (setq _version (round __version))
   (setq _reserved1 __reserved1)
   (setq _invalid_llh (round __invalid_llh))
   (setq _iTOW (round __iTOW))
   (setq _lon (round __lon))
   (setq _lat (round __lat))
   (setq _height (round __height))
   (setq _hMSL (round __hMSL))
   (setq _lonHp (round __lonHp))
   (setq _latHp (round __latHp))
   (setq _heightHp (round __heightHp))
   (setq _hMSLHp (round __hMSLHp))
   (setq _hAcc (round __hAcc))
   (setq _vAcc (round __vAcc))
   self)
  (:version
   (&optional __version)
   (if __version (setq _version __version)) _version)
  (:reserved1
   (&optional __reserved1)
   (if __reserved1 (setq _reserved1 __reserved1)) _reserved1)
  (:invalid_llh
   (&optional __invalid_llh)
   (if __invalid_llh (setq _invalid_llh __invalid_llh)) _invalid_llh)
  (:iTOW
   (&optional __iTOW)
   (if __iTOW (setq _iTOW __iTOW)) _iTOW)
  (:lon
   (&optional __lon)
   (if __lon (setq _lon __lon)) _lon)
  (:lat
   (&optional __lat)
   (if __lat (setq _lat __lat)) _lat)
  (:height
   (&optional __height)
   (if __height (setq _height __height)) _height)
  (:hMSL
   (&optional __hMSL)
   (if __hMSL (setq _hMSL __hMSL)) _hMSL)
  (:lonHp
   (&optional __lonHp)
   (if __lonHp (setq _lonHp __lonHp)) _lonHp)
  (:latHp
   (&optional __latHp)
   (if __latHp (setq _latHp __latHp)) _latHp)
  (:heightHp
   (&optional __heightHp)
   (if __heightHp (setq _heightHp __heightHp)) _heightHp)
  (:hMSLHp
   (&optional __hMSLHp)
   (if __hMSLHp (setq _hMSLHp __hMSLHp)) _hMSLHp)
  (:hAcc
   (&optional __hAcc)
   (if __hAcc (setq _hAcc __hAcc)) _hAcc)
  (:vAcc
   (&optional __vAcc)
   (if __vAcc (setq _vAcc __vAcc)) _vAcc)
  (:serialization-length
   ()
   (+
    ;; uint8 _version
    1
    ;; uint8[2] _reserved1
    (* 1    2)
    ;; int8 _invalid_llh
    1
    ;; uint32 _iTOW
    4
    ;; int32 _lon
    4
    ;; int32 _lat
    4
    ;; int32 _height
    4
    ;; int32 _hMSL
    4
    ;; int8 _lonHp
    1
    ;; int8 _latHp
    1
    ;; int8 _heightHp
    1
    ;; int8 _hMSLHp
    1
    ;; uint32 _hAcc
    4
    ;; uint32 _vAcc
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint8 _version
       (write-byte _version s)
     ;; uint8[2] _reserved1
     (princ _reserved1 s)
     ;; int8 _invalid_llh
       (write-byte _invalid_llh s)
     ;; uint32 _iTOW
       (write-long _iTOW s)
     ;; int32 _lon
       (write-long _lon s)
     ;; int32 _lat
       (write-long _lat s)
     ;; int32 _height
       (write-long _height s)
     ;; int32 _hMSL
       (write-long _hMSL s)
     ;; int8 _lonHp
       (write-byte _lonHp s)
     ;; int8 _latHp
       (write-byte _latHp s)
     ;; int8 _heightHp
       (write-byte _heightHp s)
     ;; int8 _hMSLHp
       (write-byte _hMSLHp s)
     ;; uint32 _hAcc
       (write-long _hAcc s)
     ;; uint32 _vAcc
       (write-long _vAcc s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8 _version
     (setq _version (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8[2] _reserved1
   (setq _reserved1 (make-array 2 :element-type :char))
   (replace _reserved1 buf :start2 ptr-) (incf ptr- 2)
   ;; int8 _invalid_llh
     (setq _invalid_llh (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _invalid_llh 127) (setq _invalid_llh (- _invalid_llh 256)))
   ;; uint32 _iTOW
     (setq _iTOW (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _lon
     (setq _lon (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _lat
     (setq _lat (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _height
     (setq _height (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _hMSL
     (setq _hMSL (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int8 _lonHp
     (setq _lonHp (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _lonHp 127) (setq _lonHp (- _lonHp 256)))
   ;; int8 _latHp
     (setq _latHp (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _latHp 127) (setq _latHp (- _latHp 256)))
   ;; int8 _heightHp
     (setq _heightHp (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _heightHp 127) (setq _heightHp (- _heightHp 256)))
   ;; int8 _hMSLHp
     (setq _hMSLHp (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _hMSLHp 127) (setq _hMSLHp (- _hMSLHp 256)))
   ;; uint32 _hAcc
     (setq _hAcc (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint32 _vAcc
     (setq _vAcc (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get ublox_msgs::NavHPPOSLLH :md5sum-) "9da6664837183254bd840fe05c8c1e4b")
(setf (get ublox_msgs::NavHPPOSLLH :datatype-) "ublox_msgs/NavHPPOSLLH")
(setf (get ublox_msgs::NavHPPOSLLH :definition-)
      "# NAV-HPPOSLLH (0x01 0x14)
# High Precision Geodetic Position Solution
#
# See important comments concerning validity of position given in section
# Navigation Output Filters.
# This message outputs the Geodetic position in the currently selected
# Ellipsoid. The default is the WGS84 Ellipsoid, but can be changed with the
# message CFG-DAT.
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 20

uint8 version
uint8[2] reserved1
int8 invalid_llh

uint32 iTOW             # GPS Millisecond Time of Week [ms]

int32 lon               # Longitude [deg / 1e-7]
int32 lat               # Latitude [deg / 1e-7]
int32 height            # Height above Ellipsoid [mm]
int32 hMSL              # Height above mean sea level [mm]
int8 lonHp              # Longitude [deg / 1e-9, range -99 to +99]
int8 latHp              # Latitude [deg / 1e-9, range -99 to +99]
int8 heightHp          # Height above Ellipsoid [mm / 0.1, range -9 to +9]
int8 hMSLHp            # Height above mean sea level [mm / 0.1, range -9 to +9]
uint32 hAcc             # Horizontal Accuracy Estimate [mm / 0.1]
uint32 vAcc             # Vertical Accuracy Estimate [mm / 0.1]

")



(provide :ublox_msgs/NavHPPOSLLH "9da6664837183254bd840fe05c8c1e4b")


