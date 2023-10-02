// Auto-generated. Do not edit!

// (in-package waypoint_maker.msg)


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
      this.total = null;
      this.x = null;
      this.y = null;
      this.r = null;
    }
    else {
      if (initObj.hasOwnProperty('total')) {
        this.total = initObj.total
      }
      else {
        this.total = 0;
      }
      if (initObj.hasOwnProperty('x')) {
        this.x = initObj.x
      }
      else {
        this.x = new Array(30).fill(0);
      }
      if (initObj.hasOwnProperty('y')) {
        this.y = initObj.y
      }
      else {
        this.y = new Array(30).fill(0);
      }
      if (initObj.hasOwnProperty('r')) {
        this.r = initObj.r
      }
      else {
        this.r = new Array(30).fill(0);
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type ObjectInfo
    // Serialize message field [total]
    bufferOffset = _serializer.uint16(obj.total, buffer, bufferOffset);
    // Check that the constant length array field [x] has the right length
    if (obj.x.length !== 30) {
      throw new Error('Unable to serialize array field x - length must be 30')
    }
    // Serialize message field [x]
    bufferOffset = _arraySerializer.float64(obj.x, buffer, bufferOffset, 30);
    // Check that the constant length array field [y] has the right length
    if (obj.y.length !== 30) {
      throw new Error('Unable to serialize array field y - length must be 30')
    }
    // Serialize message field [y]
    bufferOffset = _arraySerializer.float64(obj.y, buffer, bufferOffset, 30);
    // Check that the constant length array field [r] has the right length
    if (obj.r.length !== 30) {
      throw new Error('Unable to serialize array field r - length must be 30')
    }
    // Serialize message field [r]
    bufferOffset = _arraySerializer.float64(obj.r, buffer, bufferOffset, 30);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type ObjectInfo
    let len;
    let data = new ObjectInfo(null);
    // Deserialize message field [total]
    data.total = _deserializer.uint16(buffer, bufferOffset);
    // Deserialize message field [x]
    data.x = _arrayDeserializer.float64(buffer, bufferOffset, 30)
    // Deserialize message field [y]
    data.y = _arrayDeserializer.float64(buffer, bufferOffset, 30)
    // Deserialize message field [r]
    data.r = _arrayDeserializer.float64(buffer, bufferOffset, 30)
    return data;
  }

  static getMessageSize(object) {
    return 722;
  }

  static datatype() {
    // Returns string type for a message object
    return 'waypoint_maker/ObjectInfo';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '93078c6225133f2d27cf0a8b110ab31c';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    uint16 total
    float64[30] x
    float64[30] y
    float64[30] r
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new ObjectInfo(null);
    if (msg.total !== undefined) {
      resolved.total = msg.total;
    }
    else {
      resolved.total = 0
    }

    if (msg.x !== undefined) {
      resolved.x = msg.x;
    }
    else {
      resolved.x = new Array(30).fill(0)
    }

    if (msg.y !== undefined) {
      resolved.y = msg.y;
    }
    else {
      resolved.y = new Array(30).fill(0)
    }

    if (msg.r !== undefined) {
      resolved.r = msg.r;
    }
    else {
      resolved.r = new Array(30).fill(0)
    }

    return resolved;
    }
};

module.exports = ObjectInfo;
