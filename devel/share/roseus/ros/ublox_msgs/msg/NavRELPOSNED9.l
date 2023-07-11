;; Auto-generated. Do not edit!


(when (boundp 'ublox_msgs::NavRELPOSNED9)
  (if (not (find-package "UBLOX_MSGS"))
    (make-package "UBLOX_MSGS"))
  (shadow 'NavRELPOSNED9 (find-package "UBLOX_MSGS")))
(unless (find-package "UBLOX_MSGS::NAVRELPOSNED9")
  (make-package "UBLOX_MSGS::NAVRELPOSNED9"))

(in-package "ROS")
;;//! \htmlinclude NavRELPOSNED9.msg.html


(intern "*CLASS_ID*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*CLASS_ID* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*CLASS_ID* 1)
(intern "*MESSAGE_ID*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*MESSAGE_ID* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*MESSAGE_ID* 60)
(intern "*FLAGS_GNSS_FIX_OK*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_GNSS_FIX_OK* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_GNSS_FIX_OK* 1)
(intern "*FLAGS_DIFF_SOLN*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_DIFF_SOLN* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_DIFF_SOLN* 2)
(intern "*FLAGS_REL_POS_VALID*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_REL_POS_VALID* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_REL_POS_VALID* 4)
(intern "*FLAGS_CARR_SOLN_MASK*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_CARR_SOLN_MASK* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_CARR_SOLN_MASK* 24)
(intern "*FLAGS_CARR_SOLN_NONE*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_CARR_SOLN_NONE* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_CARR_SOLN_NONE* 0)
(intern "*FLAGS_CARR_SOLN_FLOAT*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_CARR_SOLN_FLOAT* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_CARR_SOLN_FLOAT* 8)
(intern "*FLAGS_CARR_SOLN_FIXED*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_CARR_SOLN_FIXED* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_CARR_SOLN_FIXED* 16)
(intern "*FLAGS_IS_MOVING*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_IS_MOVING* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_IS_MOVING* 32)
(intern "*FLAGS_REF_POS_MISS*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_REF_POS_MISS* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_REF_POS_MISS* 64)
(intern "*FLAGS_REF_OBS_MISS*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_REF_OBS_MISS* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_REF_OBS_MISS* 128)
(intern "*FLAGS_REL_POS_HEAD_VALID*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_REL_POS_HEAD_VALID* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_REL_POS_HEAD_VALID* 256)
(intern "*FLAGS_REL_POS_NORM*" (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(shadow '*FLAGS_REL_POS_NORM* (find-package "UBLOX_MSGS::NAVRELPOSNED9"))
(defconstant ublox_msgs::NavRELPOSNED9::*FLAGS_REL_POS_NORM* 512)

(defun ublox_msgs::NavRELPOSNED9-to-symbol (const)
  (cond
        ((= const 1) 'ublox_msgs::NavRELPOSNED9::*CLASS_ID*)
        ((= const 60) 'ublox_msgs::NavRELPOSNED9::*MESSAGE_ID*)
        ((= const 1) 'ublox_msgs::NavRELPOSNED9::*FLAGS_GNSS_FIX_OK*)
        ((= const 2) 'ublox_msgs::NavRELPOSNED9::*FLAGS_DIFF_SOLN*)
        ((= const 4) 'ublox_msgs::NavRELPOSNED9::*FLAGS_REL_POS_VALID*)
        ((= const 24) 'ublox_msgs::NavRELPOSNED9::*FLAGS_CARR_SOLN_MASK*)
        ((= const 0) 'ublox_msgs::NavRELPOSNED9::*FLAGS_CARR_SOLN_NONE*)
        ((= const 8) 'ublox_msgs::NavRELPOSNED9::*FLAGS_CARR_SOLN_FLOAT*)
        ((= const 16) 'ublox_msgs::NavRELPOSNED9::*FLAGS_CARR_SOLN_FIXED*)
        ((= const 32) 'ublox_msgs::NavRELPOSNED9::*FLAGS_IS_MOVING*)
        ((= const 64) 'ublox_msgs::NavRELPOSNED9::*FLAGS_REF_POS_MISS*)
        ((= const 128) 'ublox_msgs::NavRELPOSNED9::*FLAGS_REF_OBS_MISS*)
        ((= const 256) 'ublox_msgs::NavRELPOSNED9::*FLAGS_REL_POS_HEAD_VALID*)
        ((= const 512) 'ublox_msgs::NavRELPOSNED9::*FLAGS_REL_POS_NORM*)
        (t nil)))

(defclass ublox_msgs::NavRELPOSNED9
  :super ros::object
  :slots (_version _reserved1 _refStationId _iTOW _relPosN _relPosE _relPosD _relPosLength _relPosHeading _reserved2 _relPosHPN _relPosHPE _relPosHPD _relPosHPLength _accN _accE _accD _accLength _accHeading _reserved3 _flags ))

(defmethod ublox_msgs::NavRELPOSNED9
  (:init
   (&key
    ((:version __version) 0)
    ((:reserved1 __reserved1) 0)
    ((:refStationId __refStationId) 0)
    ((:iTOW __iTOW) 0)
    ((:relPosN __relPosN) 0)
    ((:relPosE __relPosE) 0)
    ((:relPosD __relPosD) 0)
    ((:relPosLength __relPosLength) 0)
    ((:relPosHeading __relPosHeading) 0)
    ((:reserved2 __reserved2) (make-array 4 :initial-element 0 :element-type :char))
    ((:relPosHPN __relPosHPN) 0)
    ((:relPosHPE __relPosHPE) 0)
    ((:relPosHPD __relPosHPD) 0)
    ((:relPosHPLength __relPosHPLength) 0)
    ((:accN __accN) 0)
    ((:accE __accE) 0)
    ((:accD __accD) 0)
    ((:accLength __accLength) 0)
    ((:accHeading __accHeading) 0)
    ((:reserved3 __reserved3) (make-array 4 :initial-element 0 :element-type :char))
    ((:flags __flags) 0)
    )
   (send-super :init)
   (setq _version (round __version))
   (setq _reserved1 (round __reserved1))
   (setq _refStationId (round __refStationId))
   (setq _iTOW (round __iTOW))
   (setq _relPosN (round __relPosN))
   (setq _relPosE (round __relPosE))
   (setq _relPosD (round __relPosD))
   (setq _relPosLength (round __relPosLength))
   (setq _relPosHeading (round __relPosHeading))
   (setq _reserved2 __reserved2)
   (setq _relPosHPN (round __relPosHPN))
   (setq _relPosHPE (round __relPosHPE))
   (setq _relPosHPD (round __relPosHPD))
   (setq _relPosHPLength (round __relPosHPLength))
   (setq _accN (round __accN))
   (setq _accE (round __accE))
   (setq _accD (round __accD))
   (setq _accLength (round __accLength))
   (setq _accHeading (round __accHeading))
   (setq _reserved3 __reserved3)
   (setq _flags (round __flags))
   self)
  (:version
   (&optional __version)
   (if __version (setq _version __version)) _version)
  (:reserved1
   (&optional __reserved1)
   (if __reserved1 (setq _reserved1 __reserved1)) _reserved1)
  (:refStationId
   (&optional __refStationId)
   (if __refStationId (setq _refStationId __refStationId)) _refStationId)
  (:iTOW
   (&optional __iTOW)
   (if __iTOW (setq _iTOW __iTOW)) _iTOW)
  (:relPosN
   (&optional __relPosN)
   (if __relPosN (setq _relPosN __relPosN)) _relPosN)
  (:relPosE
   (&optional __relPosE)
   (if __relPosE (setq _relPosE __relPosE)) _relPosE)
  (:relPosD
   (&optional __relPosD)
   (if __relPosD (setq _relPosD __relPosD)) _relPosD)
  (:relPosLength
   (&optional __relPosLength)
   (if __relPosLength (setq _relPosLength __relPosLength)) _relPosLength)
  (:relPosHeading
   (&optional __relPosHeading)
   (if __relPosHeading (setq _relPosHeading __relPosHeading)) _relPosHeading)
  (:reserved2
   (&optional __reserved2)
   (if __reserved2 (setq _reserved2 __reserved2)) _reserved2)
  (:relPosHPN
   (&optional __relPosHPN)
   (if __relPosHPN (setq _relPosHPN __relPosHPN)) _relPosHPN)
  (:relPosHPE
   (&optional __relPosHPE)
   (if __relPosHPE (setq _relPosHPE __relPosHPE)) _relPosHPE)
  (:relPosHPD
   (&optional __relPosHPD)
   (if __relPosHPD (setq _relPosHPD __relPosHPD)) _relPosHPD)
  (:relPosHPLength
   (&optional __relPosHPLength)
   (if __relPosHPLength (setq _relPosHPLength __relPosHPLength)) _relPosHPLength)
  (:accN
   (&optional __accN)
   (if __accN (setq _accN __accN)) _accN)
  (:accE
   (&optional __accE)
   (if __accE (setq _accE __accE)) _accE)
  (:accD
   (&optional __accD)
   (if __accD (setq _accD __accD)) _accD)
  (:accLength
   (&optional __accLength)
   (if __accLength (setq _accLength __accLength)) _accLength)
  (:accHeading
   (&optional __accHeading)
   (if __accHeading (setq _accHeading __accHeading)) _accHeading)
  (:reserved3
   (&optional __reserved3)
   (if __reserved3 (setq _reserved3 __reserved3)) _reserved3)
  (:flags
   (&optional __flags)
   (if __flags (setq _flags __flags)) _flags)
  (:serialization-length
   ()
   (+
    ;; uint8 _version
    1
    ;; uint8 _reserved1
    1
    ;; uint16 _refStationId
    2
    ;; uint32 _iTOW
    4
    ;; int32 _relPosN
    4
    ;; int32 _relPosE
    4
    ;; int32 _relPosD
    4
    ;; int32 _relPosLength
    4
    ;; int32 _relPosHeading
    4
    ;; uint8[4] _reserved2
    (* 1    4)
    ;; int8 _relPosHPN
    1
    ;; int8 _relPosHPE
    1
    ;; int8 _relPosHPD
    1
    ;; int8 _relPosHPLength
    1
    ;; uint32 _accN
    4
    ;; uint32 _accE
    4
    ;; uint32 _accD
    4
    ;; uint32 _accLength
    4
    ;; uint32 _accHeading
    4
    ;; uint8[4] _reserved3
    (* 1    4)
    ;; uint32 _flags
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint8 _version
       (write-byte _version s)
     ;; uint8 _reserved1
       (write-byte _reserved1 s)
     ;; uint16 _refStationId
       (write-word _refStationId s)
     ;; uint32 _iTOW
       (write-long _iTOW s)
     ;; int32 _relPosN
       (write-long _relPosN s)
     ;; int32 _relPosE
       (write-long _relPosE s)
     ;; int32 _relPosD
       (write-long _relPosD s)
     ;; int32 _relPosLength
       (write-long _relPosLength s)
     ;; int32 _relPosHeading
       (write-long _relPosHeading s)
     ;; uint8[4] _reserved2
     (princ _reserved2 s)
     ;; int8 _relPosHPN
       (write-byte _relPosHPN s)
     ;; int8 _relPosHPE
       (write-byte _relPosHPE s)
     ;; int8 _relPosHPD
       (write-byte _relPosHPD s)
     ;; int8 _relPosHPLength
       (write-byte _relPosHPLength s)
     ;; uint32 _accN
       (write-long _accN s)
     ;; uint32 _accE
       (write-long _accE s)
     ;; uint32 _accD
       (write-long _accD s)
     ;; uint32 _accLength
       (write-long _accLength s)
     ;; uint32 _accHeading
       (write-long _accHeading s)
     ;; uint8[4] _reserved3
     (princ _reserved3 s)
     ;; uint32 _flags
       (write-long _flags s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8 _version
     (setq _version (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _reserved1
     (setq _reserved1 (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint16 _refStationId
     (setq _refStationId (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; uint32 _iTOW
     (setq _iTOW (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _relPosN
     (setq _relPosN (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _relPosE
     (setq _relPosE (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _relPosD
     (setq _relPosD (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _relPosLength
     (setq _relPosLength (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; int32 _relPosHeading
     (setq _relPosHeading (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint8[4] _reserved2
   (setq _reserved2 (make-array 4 :element-type :char))
   (replace _reserved2 buf :start2 ptr-) (incf ptr- 4)
   ;; int8 _relPosHPN
     (setq _relPosHPN (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _relPosHPN 127) (setq _relPosHPN (- _relPosHPN 256)))
   ;; int8 _relPosHPE
     (setq _relPosHPE (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _relPosHPE 127) (setq _relPosHPE (- _relPosHPE 256)))
   ;; int8 _relPosHPD
     (setq _relPosHPD (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _relPosHPD 127) (setq _relPosHPD (- _relPosHPD 256)))
   ;; int8 _relPosHPLength
     (setq _relPosHPLength (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _relPosHPLength 127) (setq _relPosHPLength (- _relPosHPLength 256)))
   ;; uint32 _accN
     (setq _accN (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint32 _accE
     (setq _accE (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint32 _accD
     (setq _accD (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint32 _accLength
     (setq _accLength (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint32 _accHeading
     (setq _accHeading (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint8[4] _reserved3
   (setq _reserved3 (make-array 4 :element-type :char))
   (replace _reserved3 buf :start2 ptr-) (incf ptr- 4)
   ;; uint32 _flags
     (setq _flags (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get ublox_msgs::NavRELPOSNED9 :md5sum-) "5acd7899c1f1094e1680da583d0ff1f9")
(setf (get ublox_msgs::NavRELPOSNED9 :datatype-) "ublox_msgs/NavRELPOSNED9")
(setf (get ublox_msgs::NavRELPOSNED9 :definition-)
      "# NAV-RELPOSNED (0x01 0x3C)
# Relative Positioning Information in NED frame
#
# The NED frame is defined as the local topological system at the reference
# station. The relative position vector components in this message, along with
# their associated accuracies, are given in that local topological system
# This message contains the relative position vector from the Reference Station
# to the Rover, including accuracy figures, in the local topological system
# defined at the reference station
#
# Supported on:
#  - u-blox 9 from protocol version 27.11 (only with High Precision GNSS products)
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 60

uint8 version                     # Message version (0x00 for this version)
uint8 reserved1                   # Reserved
uint16 refStationId               # Reference Station ID. Must be in the range
                                  # 0..4095
uint32 iTOW                       # GPS time of week of the navigation epoch
                                  # [ms]

int32 relPosN                     # North component of relative position vector
                                  # [cm]
int32 relPosE                     # East component of relative position vector
                                  # [cm]
int32 relPosD                     # Down component of relative position vector
                                  # [cm]
int32 relPosLength                # Length of the relative position vector
                                  # [cm]
int32 relPosHeading               # Heading of the relative position vector
                                  # [1e-5 deg]
uint8[4] reserved2                # Reserved
int8 relPosHPN                    # High-precision North component of relative
                                  # position vector. [0.1 mm]
                                  # Must be in the range -99 to +99.
                                  # The full North component of the relative
                                  # position vector, in units of cm, is given by
                                  # relPosN + (relPosHPN * 1e-2)
int8 relPosHPE                    # High-precision East component of relative
                                  # position vector. [0.1 mm]
                                  # Must be in the range -99 to +99.
                                  # The full East component of the relative
                                  # position vector, in units of cm, is given by
                                  # relPosE + (relPosHPE * 1e-2)
int8 relPosHPD                    # High-precision Down component of relative
                                  # position vector. [0.1 mm]
                                  # Must be in the range -99 to +99.
                                  # The full Down component of the relative
                                  # position vector, in units of cm, is given by
                                  # relPosD + (relPosHPD * 1e-2)
int8 relPosHPLength               # High-precision component of the length of
                                  # the relative position vector.
                                  # Must be in the range -99 to +99.
                                  # The full length of the relative position
                                  # vector, in units of cm, is given by
                                  # relPosLength + (relPosHPLength * 1e-2)

uint32 accN                       # Accuracy of relative position North
                                  # component [0.1 mm]
uint32 accE                       # Accuracy of relative position East component
                                  # [0.1 mm]
uint32 accD                       # Accuracy of relative position Down component
                                  # [0.1 mm]
uint32 accLength                  # Accuracy of length of the relative position
                                  # vector [0.1 mm]
uint32 accHeading                 # Accuracy of heading of the relative position
                                  # vector [1e-5 deg]

uint8[4] reserved3                # Reserved

uint32 flags
uint32 FLAGS_GNSS_FIX_OK = 1      # A valid fix (i.e within DOP & accuracy
                                  # masks)
uint32 FLAGS_DIFF_SOLN = 2        # Set if differential corrections were applied
uint32 FLAGS_REL_POS_VALID = 4    # Set if relative position components and
                                  # accuracies are valid
uint32 FLAGS_CARR_SOLN_MASK = 24  # Carrier phase range solution status:
uint32 FLAGS_CARR_SOLN_NONE = 0     # No carrier phase range solution
uint32 FLAGS_CARR_SOLN_FLOAT = 8    # Float solution. No fixed integer carrier
                                    # phase measurements have been used to
                                    # calculate the solution
uint32 FLAGS_CARR_SOLN_FIXED = 16   # Fixed solution. One or more fixed
                                    # integer carrier phase range measurements
                                    # have been used to calculate the solution
uint32 FLAGS_IS_MOVING = 32       # if the receiver is operating in moving
                                  # baseline mode (not supported in protocol
                                  # versions less than 20.3)
uint32 FLAGS_REF_POS_MISS = 64    # Set if extrapolated reference position was
                                  # used to compute moving baseline solution
                                  # this epoch (not supported in protocol
                                  # versions less than 20.3)
uint32 FLAGS_REF_OBS_MISS = 128   # Set if extrapolated reference observations
                                  # were used to compute moving baseline
                                  # solution this epoch (not supported in
                                  # protocol versions less than 20.3)
uint32 FLAGS_REL_POS_HEAD_VALID = 256   # Set if extrapolated reference observations
                                        # were used to compute moving baseline
                                        # solution this epoch (not supported in
                                        # protocol versions less than 20.3)
uint32 FLAGS_REL_POS_NORM = 512   # Set if extrapolated reference observations
                                  # were used to compute moving baseline
                                  # solution this epoch (not supported in
                                  # protocol versions less than 20.3)
")



(provide :ublox_msgs/NavRELPOSNED9 "5acd7899c1f1094e1680da583d0ff1f9")


