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

class NavHPPOSLLH {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.version = null;
      this.reserved1 = null;
      this.invalid_llh = null;
      this.iTOW = null;
      this.lon = null;
      this.lat = null;
      this.height = null;
      this.hMSL = null;
      this.lonHp = null;
      this.latHp = null;
      this.heightHp = null;
      this.hMSLHp = null;
      this.hAcc = null;
      this.vAcc = null;
    }
    else {
      if (initObj.hasOwnProperty('version')) {
        this.version = initObj.version
      }
      else {
        this.version = 0;
      }
      if (initObj.hasOwnProperty('reserved1')) {
        this.reserved1 = initObj.reserved1
      }
      else {
        this.reserved1 = new Array(2).fill(0);
      }
      if (initObj.hasOwnProperty('invalid_llh')) {
        this.invalid_llh = initObj.invalid_llh
      }
      else {
        this.invalid_llh = 0;
      }
      if (initObj.hasOwnProperty('iTOW')) {
        this.iTOW = initObj.iTOW
      }
      else {
        this.iTOW = 0;
      }
      if (initObj.hasOwnProperty('lon')) {
        this.lon = initObj.lon
      }
      else {
        this.lon = 0;
      }
      if (initObj.hasOwnProperty('lat')) {
        this.lat = initObj.lat
      }
      else {
        this.lat = 0;
      }
      if (initObj.hasOwnProperty('height')) {
        this.height = initObj.height
      }
      else {
        this.height = 0;
      }
      if (initObj.hasOwnProperty('hMSL')) {
        this.hMSL = initObj.hMSL
      }
      else {
        this.hMSL = 0;
      }
      if (initObj.hasOwnProperty('lonHp')) {
        this.lonHp = initObj.lonHp
      }
      else {
        this.lonHp = 0;
      }
      if (initObj.hasOwnProperty('latHp')) {
        this.latHp = initObj.latHp
      }
      else {
        this.latHp = 0;
      }
      if (initObj.hasOwnProperty('heightHp')) {
        this.heightHp = initObj.heightHp
      }
      else {
        this.heightHp = 0;
      }
      if (initObj.hasOwnProperty('hMSLHp')) {
        this.hMSLHp = initObj.hMSLHp
      }
      else {
        this.hMSLHp = 0;
      }
      if (initObj.hasOwnProperty('hAcc')) {
        this.hAcc = initObj.hAcc
      }
      else {
        this.hAcc = 0;
      }
      if (initObj.hasOwnProperty('vAcc')) {
        this.vAcc = initObj.vAcc
      }
      else {
        this.vAcc = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type NavHPPOSLLH
    // Serialize message field [version]
    bufferOffset = _serializer.uint8(obj.version, buffer, bufferOffset);
    // Check that the constant length array field [reserved1] has the right length
    if (obj.reserved1.length !== 2) {
      throw new Error('Unable to serialize array field reserved1 - length must be 2')
    }
    // Serialize message field [reserved1]
    bufferOffset = _arraySerializer.uint8(obj.reserved1, buffer, bufferOffset, 2);
    // Serialize message field [invalid_llh]
    bufferOffset = _serializer.int8(obj.invalid_llh, buffer, bufferOffset);
    // Serialize message field [iTOW]
    bufferOffset = _serializer.uint32(obj.iTOW, buffer, bufferOffset);
    // Serialize message field [lon]
    bufferOffset = _serializer.int32(obj.lon, buffer, bufferOffset);
    // Serialize message field [lat]
    bufferOffset = _serializer.int32(obj.lat, buffer, bufferOffset);
    // Serialize message field [height]
    bufferOffset = _serializer.int32(obj.height, buffer, bufferOffset);
    // Serialize message field [hMSL]
    bufferOffset = _serializer.int32(obj.hMSL, buffer, bufferOffset);
    // Serialize message field [lonHp]
    bufferOffset = _serializer.int8(obj.lonHp, buffer, bufferOffset);
    // Serialize message field [latHp]
    bufferOffset = _serializer.int8(obj.latHp, buffer, bufferOffset);
    // Serialize message field [heightHp]
    bufferOffset = _serializer.int8(obj.heightHp, buffer, bufferOffset);
    // Serialize message field [hMSLHp]
    bufferOffset = _serializer.int8(obj.hMSLHp, buffer, bufferOffset);
    // Serialize message field [hAcc]
    bufferOffset = _serializer.uint32(obj.hAcc, buffer, bufferOffset);
    // Serialize message field [vAcc]
    bufferOffset = _serializer.uint32(obj.vAcc, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type NavHPPOSLLH
    let len;
    let data = new NavHPPOSLLH(null);
    // Deserialize message field [version]
    data.version = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [reserved1]
    data.reserved1 = _arrayDeserializer.uint8(buffer, bufferOffset, 2)
    // Deserialize message field [invalid_llh]
    data.invalid_llh = _deserializer.int8(buffer, bufferOffset);
    // Deserialize message field [iTOW]
    data.iTOW = _deserializer.uint32(buffer, bufferOffset);
    // Deserialize message field [lon]
    data.lon = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [lat]
    data.lat = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [height]
    data.height = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [hMSL]
    data.hMSL = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [lonHp]
    data.lonHp = _deserializer.int8(buffer, bufferOffset);
    // Deserialize message field [latHp]
    data.latHp = _deserializer.int8(buffer, bufferOffset);
    // Deserialize message field [heightHp]
    data.heightHp = _deserializer.int8(buffer, bufferOffset);
    // Deserialize message field [hMSLHp]
    data.hMSLHp = _deserializer.int8(buffer, bufferOffset);
    // Deserialize message field [hAcc]
    data.hAcc = _deserializer.uint32(buffer, bufferOffset);
    // Deserialize message field [vAcc]
    data.vAcc = _deserializer.uint32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 36;
  }

  static datatype() {
    // Returns string type for a message object
    return 'ublox_msgs/NavHPPOSLLH';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '9da6664837183254bd840fe05c8c1e4b';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    # NAV-HPPOSLLH (0x01 0x14)
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
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new NavHPPOSLLH(null);
    if (msg.version !== undefined) {
      resolved.version = msg.version;
    }
    else {
      resolved.version = 0
    }

    if (msg.reserved1 !== undefined) {
      resolved.reserved1 = msg.reserved1;
    }
    else {
      resolved.reserved1 = new Array(2).fill(0)
    }

    if (msg.invalid_llh !== undefined) {
      resolved.invalid_llh = msg.invalid_llh;
    }
    else {
      resolved.invalid_llh = 0
    }

    if (msg.iTOW !== undefined) {
      resolved.iTOW = msg.iTOW;
    }
    else {
      resolved.iTOW = 0
    }

    if (msg.lon !== undefined) {
      resolved.lon = msg.lon;
    }
    else {
      resolved.lon = 0
    }

    if (msg.lat !== undefined) {
      resolved.lat = msg.lat;
    }
    else {
      resolved.lat = 0
    }

    if (msg.height !== undefined) {
      resolved.height = msg.height;
    }
    else {
      resolved.height = 0
    }

    if (msg.hMSL !== undefined) {
      resolved.hMSL = msg.hMSL;
    }
    else {
      resolved.hMSL = 0
    }

    if (msg.lonHp !== undefined) {
      resolved.lonHp = msg.lonHp;
    }
    else {
      resolved.lonHp = 0
    }

    if (msg.latHp !== undefined) {
      resolved.latHp = msg.latHp;
    }
    else {
      resolved.latHp = 0
    }

    if (msg.heightHp !== undefined) {
      resolved.heightHp = msg.heightHp;
    }
    else {
      resolved.heightHp = 0
    }

    if (msg.hMSLHp !== undefined) {
      resolved.hMSLHp = msg.hMSLHp;
    }
    else {
      resolved.hMSLHp = 0
    }

    if (msg.hAcc !== undefined) {
      resolved.hAcc = msg.hAcc;
    }
    else {
      resolved.hAcc = 0
    }

    if (msg.vAcc !== undefined) {
      resolved.vAcc = msg.vAcc;
    }
    else {
      resolved.vAcc = 0
    }

    return resolved;
    }
};

// Constants for message
NavHPPOSLLH.Constants = {
  CLASS_ID: 1,
  MESSAGE_ID: 20,
}

module.exports = NavHPPOSLLH;
