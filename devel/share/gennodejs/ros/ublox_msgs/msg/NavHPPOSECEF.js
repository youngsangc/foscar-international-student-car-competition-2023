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

class NavHPPOSECEF {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.version = null;
      this.reserved0 = null;
      this.iTOW = null;
      this.ecefX = null;
      this.ecefY = null;
      this.ecefZ = null;
      this.ecefXHp = null;
      this.ecefYHp = null;
      this.ecefZHp = null;
      this.flags = null;
      this.pAcc = null;
    }
    else {
      if (initObj.hasOwnProperty('version')) {
        this.version = initObj.version
      }
      else {
        this.version = 0;
      }
      if (initObj.hasOwnProperty('reserved0')) {
        this.reserved0 = initObj.reserved0
      }
      else {
        this.reserved0 = new Array(3).fill(0);
      }
      if (initObj.hasOwnProperty('iTOW')) {
        this.iTOW = initObj.iTOW
      }
      else {
        this.iTOW = 0;
      }
      if (initObj.hasOwnProperty('ecefX')) {
        this.ecefX = initObj.ecefX
      }
      else {
        this.ecefX = 0;
      }
      if (initObj.hasOwnProperty('ecefY')) {
        this.ecefY = initObj.ecefY
      }
      else {
        this.ecefY = 0;
      }
      if (initObj.hasOwnProperty('ecefZ')) {
        this.ecefZ = initObj.ecefZ
      }
      else {
        this.ecefZ = 0;
      }
      if (initObj.hasOwnProperty('ecefXHp')) {
        this.ecefXHp = initObj.ecefXHp
      }
      else {
        this.ecefXHp = 0;
      }
      if (initObj.hasOwnProperty('ecefYHp')) {
        this.ecefYHp = initObj.ecefYHp
      }
      else {
        this.ecefYHp = 0;
      }
      if (initObj.hasOwnProperty('ecefZHp')) {
        this.ecefZHp = initObj.ecefZHp
      }
      else {
        this.ecefZHp = 0;
      }
      if (initObj.hasOwnProperty('flags')) {
        this.flags = initObj.flags
      }
      else {
        this.flags = 0;
      }
      if (initObj.hasOwnProperty('pAcc')) {
        this.pAcc = initObj.pAcc
      }
      else {
        this.pAcc = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type NavHPPOSECEF
    // Serialize message field [version]
    bufferOffset = _serializer.uint8(obj.version, buffer, bufferOffset);
    // Check that the constant length array field [reserved0] has the right length
    if (obj.reserved0.length !== 3) {
      throw new Error('Unable to serialize array field reserved0 - length must be 3')
    }
    // Serialize message field [reserved0]
    bufferOffset = _arraySerializer.uint8(obj.reserved0, buffer, bufferOffset, 3);
    // Serialize message field [iTOW]
    bufferOffset = _serializer.uint32(obj.iTOW, buffer, bufferOffset);
    // Serialize message field [ecefX]
    bufferOffset = _serializer.int32(obj.ecefX, buffer, bufferOffset);
    // Serialize message field [ecefY]
    bufferOffset = _serializer.int32(obj.ecefY, buffer, bufferOffset);
    // Serialize message field [ecefZ]
    bufferOffset = _serializer.int32(obj.ecefZ, buffer, bufferOffset);
    // Serialize message field [ecefXHp]
    bufferOffset = _serializer.int8(obj.ecefXHp, buffer, bufferOffset);
    // Serialize message field [ecefYHp]
    bufferOffset = _serializer.int8(obj.ecefYHp, buffer, bufferOffset);
    // Serialize message field [ecefZHp]
    bufferOffset = _serializer.int8(obj.ecefZHp, buffer, bufferOffset);
    // Serialize message field [flags]
    bufferOffset = _serializer.uint8(obj.flags, buffer, bufferOffset);
    // Serialize message field [pAcc]
    bufferOffset = _serializer.uint32(obj.pAcc, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type NavHPPOSECEF
    let len;
    let data = new NavHPPOSECEF(null);
    // Deserialize message field [version]
    data.version = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [reserved0]
    data.reserved0 = _arrayDeserializer.uint8(buffer, bufferOffset, 3)
    // Deserialize message field [iTOW]
    data.iTOW = _deserializer.uint32(buffer, bufferOffset);
    // Deserialize message field [ecefX]
    data.ecefX = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [ecefY]
    data.ecefY = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [ecefZ]
    data.ecefZ = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [ecefXHp]
    data.ecefXHp = _deserializer.int8(buffer, bufferOffset);
    // Deserialize message field [ecefYHp]
    data.ecefYHp = _deserializer.int8(buffer, bufferOffset);
    // Deserialize message field [ecefZHp]
    data.ecefZHp = _deserializer.int8(buffer, bufferOffset);
    // Deserialize message field [flags]
    data.flags = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [pAcc]
    data.pAcc = _deserializer.uint32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 28;
  }

  static datatype() {
    // Returns string type for a message object
    return 'ublox_msgs/NavHPPOSECEF';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '41fbf0937e53f84ca89afe3287f85e50';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    # NAV-HPPOSECEF (0x01 0x13)
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
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new NavHPPOSECEF(null);
    if (msg.version !== undefined) {
      resolved.version = msg.version;
    }
    else {
      resolved.version = 0
    }

    if (msg.reserved0 !== undefined) {
      resolved.reserved0 = msg.reserved0;
    }
    else {
      resolved.reserved0 = new Array(3).fill(0)
    }

    if (msg.iTOW !== undefined) {
      resolved.iTOW = msg.iTOW;
    }
    else {
      resolved.iTOW = 0
    }

    if (msg.ecefX !== undefined) {
      resolved.ecefX = msg.ecefX;
    }
    else {
      resolved.ecefX = 0
    }

    if (msg.ecefY !== undefined) {
      resolved.ecefY = msg.ecefY;
    }
    else {
      resolved.ecefY = 0
    }

    if (msg.ecefZ !== undefined) {
      resolved.ecefZ = msg.ecefZ;
    }
    else {
      resolved.ecefZ = 0
    }

    if (msg.ecefXHp !== undefined) {
      resolved.ecefXHp = msg.ecefXHp;
    }
    else {
      resolved.ecefXHp = 0
    }

    if (msg.ecefYHp !== undefined) {
      resolved.ecefYHp = msg.ecefYHp;
    }
    else {
      resolved.ecefYHp = 0
    }

    if (msg.ecefZHp !== undefined) {
      resolved.ecefZHp = msg.ecefZHp;
    }
    else {
      resolved.ecefZHp = 0
    }

    if (msg.flags !== undefined) {
      resolved.flags = msg.flags;
    }
    else {
      resolved.flags = 0
    }

    if (msg.pAcc !== undefined) {
      resolved.pAcc = msg.pAcc;
    }
    else {
      resolved.pAcc = 0
    }

    return resolved;
    }
};

// Constants for message
NavHPPOSECEF.Constants = {
  CLASS_ID: 1,
  MESSAGE_ID: 19,
}

module.exports = NavHPPOSECEF;
