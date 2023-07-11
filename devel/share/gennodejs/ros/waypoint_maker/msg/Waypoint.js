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

class Waypoint {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.cnt = null;
      this.x_arr = null;
      this.y_arr = null;
    }
    else {
      if (initObj.hasOwnProperty('cnt')) {
        this.cnt = initObj.cnt
      }
      else {
        this.cnt = 0;
      }
      if (initObj.hasOwnProperty('x_arr')) {
        this.x_arr = initObj.x_arr
      }
      else {
        this.x_arr = new Array(200).fill(0);
      }
      if (initObj.hasOwnProperty('y_arr')) {
        this.y_arr = initObj.y_arr
      }
      else {
        this.y_arr = new Array(200).fill(0);
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type Waypoint
    // Serialize message field [cnt]
    bufferOffset = _serializer.int32(obj.cnt, buffer, bufferOffset);
    // Check that the constant length array field [x_arr] has the right length
    if (obj.x_arr.length !== 200) {
      throw new Error('Unable to serialize array field x_arr - length must be 200')
    }
    // Serialize message field [x_arr]
    bufferOffset = _arraySerializer.float32(obj.x_arr, buffer, bufferOffset, 200);
    // Check that the constant length array field [y_arr] has the right length
    if (obj.y_arr.length !== 200) {
      throw new Error('Unable to serialize array field y_arr - length must be 200')
    }
    // Serialize message field [y_arr]
    bufferOffset = _arraySerializer.float32(obj.y_arr, buffer, bufferOffset, 200);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type Waypoint
    let len;
    let data = new Waypoint(null);
    // Deserialize message field [cnt]
    data.cnt = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [x_arr]
    data.x_arr = _arrayDeserializer.float32(buffer, bufferOffset, 200)
    // Deserialize message field [y_arr]
    data.y_arr = _arrayDeserializer.float32(buffer, bufferOffset, 200)
    return data;
  }

  static getMessageSize(object) {
    return 1604;
  }

  static datatype() {
    // Returns string type for a message object
    return 'waypoint_maker/Waypoint';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'ef3b913564c2c1d5123a607b0c2cca14';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    int32 cnt
    float32[200] x_arr
    float32[200] y_arr
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new Waypoint(null);
    if (msg.cnt !== undefined) {
      resolved.cnt = msg.cnt;
    }
    else {
      resolved.cnt = 0
    }

    if (msg.x_arr !== undefined) {
      resolved.x_arr = msg.x_arr;
    }
    else {
      resolved.x_arr = new Array(200).fill(0)
    }

    if (msg.y_arr !== undefined) {
      resolved.y_arr = msg.y_arr;
    }
    else {
      resolved.y_arr = new Array(200).fill(0)
    }

    return resolved;
    }
};

module.exports = Waypoint;
