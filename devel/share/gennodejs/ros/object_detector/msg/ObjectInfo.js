// Auto-generated. Do not edit!

// (in-package object_detector.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class ObjectInfo {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.objectCounts = null;
      this.centerX = null;
      this.centerY = null;
      this.centerZ = null;
      this.lengthX = null;
      this.lengthY = null;
      this.lengthZ = null;
    }
    else {
      if (initObj.hasOwnProperty('objectCounts')) {
        this.objectCounts = initObj.objectCounts
      }
      else {
        this.objectCounts = 0;
      }
      if (initObj.hasOwnProperty('centerX')) {
        this.centerX = initObj.centerX
      }
      else {
        this.centerX = new Array(100).fill(0);
      }
      if (initObj.hasOwnProperty('centerY')) {
        this.centerY = initObj.centerY
      }
      else {
        this.centerY = new Array(100).fill(0);
      }
      if (initObj.hasOwnProperty('centerZ')) {
        this.centerZ = initObj.centerZ
      }
      else {
        this.centerZ = new Array(100).fill(0);
      }
      if (initObj.hasOwnProperty('lengthX')) {
        this.lengthX = initObj.lengthX
      }
      else {
        this.lengthX = new Array(100).fill(0);
      }
      if (initObj.hasOwnProperty('lengthY')) {
        this.lengthY = initObj.lengthY
      }
      else {
        this.lengthY = new Array(100).fill(0);
      }
      if (initObj.hasOwnProperty('lengthZ')) {
        this.lengthZ = initObj.lengthZ
      }
      else {
        this.lengthZ = new Array(100).fill(0);
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type ObjectInfo
    // Serialize message field [objectCounts]
    bufferOffset = _serializer.int32(obj.objectCounts, buffer, bufferOffset);
    // Check that the constant length array field [centerX] has the right length
    if (obj.centerX.length !== 100) {
      throw new Error('Unable to serialize array field centerX - length must be 100')
    }
    // Serialize message field [centerX]
    bufferOffset = _arraySerializer.float64(obj.centerX, buffer, bufferOffset, 100);
    // Check that the constant length array field [centerY] has the right length
    if (obj.centerY.length !== 100) {
      throw new Error('Unable to serialize array field centerY - length must be 100')
    }
    // Serialize message field [centerY]
    bufferOffset = _arraySerializer.float64(obj.centerY, buffer, bufferOffset, 100);
    // Check that the constant length array field [centerZ] has the right length
    if (obj.centerZ.length !== 100) {
      throw new Error('Unable to serialize array field centerZ - length must be 100')
    }
    // Serialize message field [centerZ]
    bufferOffset = _arraySerializer.float64(obj.centerZ, buffer, bufferOffset, 100);
    // Check that the constant length array field [lengthX] has the right length
    if (obj.lengthX.length !== 100) {
      throw new Error('Unable to serialize array field lengthX - length must be 100')
    }
    // Serialize message field [lengthX]
    bufferOffset = _arraySerializer.float64(obj.lengthX, buffer, bufferOffset, 100);
    // Check that the constant length array field [lengthY] has the right length
    if (obj.lengthY.length !== 100) {
      throw new Error('Unable to serialize array field lengthY - length must be 100')
    }
    // Serialize message field [lengthY]
    bufferOffset = _arraySerializer.float64(obj.lengthY, buffer, bufferOffset, 100);
    // Check that the constant length array field [lengthZ] has the right length
    if (obj.lengthZ.length !== 100) {
      throw new Error('Unable to serialize array field lengthZ - length must be 100')
    }
    // Serialize message field [lengthZ]
    bufferOffset = _arraySerializer.float64(obj.lengthZ, buffer, bufferOffset, 100);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type ObjectInfo
    let len;
    let data = new ObjectInfo(null);
    // Deserialize message field [objectCounts]
    data.objectCounts = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [centerX]
    data.centerX = _arrayDeserializer.float64(buffer, bufferOffset, 100)
    // Deserialize message field [centerY]
    data.centerY = _arrayDeserializer.float64(buffer, bufferOffset, 100)
    // Deserialize message field [centerZ]
    data.centerZ = _arrayDeserializer.float64(buffer, bufferOffset, 100)
    // Deserialize message field [lengthX]
    data.lengthX = _arrayDeserializer.float64(buffer, bufferOffset, 100)
    // Deserialize message field [lengthY]
    data.lengthY = _arrayDeserializer.float64(buffer, bufferOffset, 100)
    // Deserialize message field [lengthZ]
    data.lengthZ = _arrayDeserializer.float64(buffer, bufferOffset, 100)
    return data;
  }

  static getMessageSize(object) {
    return 4804;
  }

  static datatype() {
    // Returns string type for a message object
    return 'object_detector/ObjectInfo';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'fcb703df87d24291d755127aee75bb7e';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    int32 objectCounts
    float64[100] centerX
    float64[100] centerY
    float64[100] centerZ
    float64[100] lengthX
    float64[100] lengthY
    float64[100] lengthZ
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new ObjectInfo(null);
    if (msg.objectCounts !== undefined) {
      resolved.objectCounts = msg.objectCounts;
    }
    else {
      resolved.objectCounts = 0
    }

    if (msg.centerX !== undefined) {
      resolved.centerX = msg.centerX;
    }
    else {
      resolved.centerX = new Array(100).fill(0)
    }

    if (msg.centerY !== undefined) {
      resolved.centerY = msg.centerY;
    }
    else {
      resolved.centerY = new Array(100).fill(0)
    }

    if (msg.centerZ !== undefined) {
      resolved.centerZ = msg.centerZ;
    }
    else {
      resolved.centerZ = new Array(100).fill(0)
    }

    if (msg.lengthX !== undefined) {
      resolved.lengthX = msg.lengthX;
    }
    else {
      resolved.lengthX = new Array(100).fill(0)
    }

    if (msg.lengthY !== undefined) {
      resolved.lengthY = msg.lengthY;
    }
    else {
      resolved.lengthY = new Array(100).fill(0)
    }

    if (msg.lengthZ !== undefined) {
      resolved.lengthZ = msg.lengthZ;
    }
    else {
      resolved.lengthZ = new Array(100).fill(0)
    }

    return resolved;
    }
};

module.exports = ObjectInfo;
