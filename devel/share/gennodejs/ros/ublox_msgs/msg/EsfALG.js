// Auto-generated. Do not edit!

// (in-package ublox_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class EsfALG {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.iTOW = null;
      this.version = null;
      this.flags = null;
      this.errors = null;
      this.reserved0 = null;
      this.yaw = null;
      this.pitch = null;
      this.roll = null;
    }
    else {
      if (initObj.hasOwnProperty('iTOW')) {
        this.iTOW = initObj.iTOW
      }
      else {
        this.iTOW = 0;
      }
      if (initObj.hasOwnProperty('version')) {
        this.version = initObj.version
      }
      else {
        this.version = 0;
      }
      if (initObj.hasOwnProperty('flags')) {
        this.flags = initObj.flags
      }
      else {
        this.flags = 0;
      }
      if (initObj.hasOwnProperty('errors')) {
        this.errors = initObj.errors
      }
      else {
        this.errors = 0;
      }
      if (initObj.hasOwnProperty('reserved0')) {
        this.reserved0 = initObj.reserved0
      }
      else {
        this.reserved0 = 0;
      }
      if (initObj.hasOwnProperty('yaw')) {
        this.yaw = initObj.yaw
      }
      else {
        this.yaw = 0;
      }
      if (initObj.hasOwnProperty('pitch')) {
        this.pitch = initObj.pitch
      }
      else {
        this.pitch = 0;
      }
      if (initObj.hasOwnProperty('roll')) {
        this.roll = initObj.roll
      }
      else {
        this.roll = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type EsfALG
    // Serialize message field [iTOW]
    bufferOffset = _serializer.uint32(obj.iTOW, buffer, bufferOffset);
    // Serialize message field [version]
    bufferOffset = _serializer.uint8(obj.version, buffer, bufferOffset);
    // Serialize message field [flags]
    bufferOffset = _serializer.uint8(obj.flags, buffer, bufferOffset);
    // Serialize message field [errors]
    bufferOffset = _serializer.uint8(obj.errors, buffer, bufferOffset);
    // Serialize message field [reserved0]
    bufferOffset = _serializer.uint8(obj.reserved0, buffer, bufferOffset);
    // Serialize message field [yaw]
    bufferOffset = _serializer.uint32(obj.yaw, buffer, bufferOffset);
    // Serialize message field [pitch]
    bufferOffset = _serializer.int16(obj.pitch, buffer, bufferOffset);
    // Serialize message field [roll]
    bufferOffset = _serializer.int16(obj.roll, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type EsfALG
    let len;
    let data = new EsfALG(null);
    // Deserialize message field [iTOW]
    data.iTOW = _deserializer.uint32(buffer, bufferOffset);
    // Deserialize message field [version]
    data.version = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [flags]
    data.flags = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [errors]
    data.errors = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [reserved0]
    data.reserved0 = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [yaw]
    data.yaw = _deserializer.uint32(buffer, bufferOffset);
    // Deserialize message field [pitch]
    data.pitch = _deserializer.int16(buffer, bufferOffset);
    // Deserialize message field [roll]
    data.roll = _deserializer.int16(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 16;
  }

  static datatype() {
    // Returns string type for a message object
    return 'ublox_msgs/EsfALG';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '9a16c82ca78b0658bd506bfde3a1b262';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    # ESF-ALG (0x10 0x14)
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
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new EsfALG(null);
    if (msg.iTOW !== undefined) {
      resolved.iTOW = msg.iTOW;
    }
    else {
      resolved.iTOW = 0
    }

    if (msg.version !== undefined) {
      resolved.version = msg.version;
    }
    else {
      resolved.version = 0
    }

    if (msg.flags !== undefined) {
      resolved.flags = msg.flags;
    }
    else {
      resolved.flags = 0
    }

    if (msg.errors !== undefined) {
      resolved.errors = msg.errors;
    }
    else {
      resolved.errors = 0
    }

    if (msg.reserved0 !== undefined) {
      resolved.reserved0 = msg.reserved0;
    }
    else {
      resolved.reserved0 = 0
    }

    if (msg.yaw !== undefined) {
      resolved.yaw = msg.yaw;
    }
    else {
      resolved.yaw = 0
    }

    if (msg.pitch !== undefined) {
      resolved.pitch = msg.pitch;
    }
    else {
      resolved.pitch = 0
    }

    if (msg.roll !== undefined) {
      resolved.roll = msg.roll;
    }
    else {
      resolved.roll = 0
    }

    return resolved;
    }
};

// Constants for message
EsfALG.Constants = {
  CLASS_ID: 16,
  MESSAGE_ID: 20,
  FLAGS_AUTO_MNT_ALG_ON: 0,
  FLAGS_STATUS: 14,
  FLAGS_STATUS_USER_FIXED_ANGLES_USED: 0,
  FLAGS_STATUS_ROLL_PITCH_ANGLES_ALIGNEMENT_ONGOING: 1,
  FLAGS_STATUS_ROLL_PITCH_YAW_ANGLES_ALIGNEMENT_ONGOING: 2,
  FLAGS_STATUS_COARSE_ALIGNMENT_USED: 3,
  FLAGS_STATUS_FINE_ALIGNEMENT_USED: 4,
  ERROR_TILT_ARG_ERROR: 1,
  ERROR_YAW_ARG_ERROR: 2,
  ERROR_ANGLE_ERROR: 3,
}

module.exports = EsfALG;
