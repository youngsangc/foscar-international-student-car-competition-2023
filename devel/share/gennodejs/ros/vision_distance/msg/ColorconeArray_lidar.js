// Auto-generated. Do not edit!

// (in-package vision_distance.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let Colorcone_lidar = require('./Colorcone_lidar.js');

//-----------------------------------------------------------

class ColorconeArray_lidar {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.colorcone = null;
    }
    else {
      if (initObj.hasOwnProperty('colorcone')) {
        this.colorcone = initObj.colorcone
      }
      else {
        this.colorcone = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type ColorconeArray_lidar
    // Serialize message field [colorcone]
    // Serialize the length for message field [colorcone]
    bufferOffset = _serializer.uint32(obj.colorcone.length, buffer, bufferOffset);
    obj.colorcone.forEach((val) => {
      bufferOffset = Colorcone_lidar.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type ColorconeArray_lidar
    let len;
    let data = new ColorconeArray_lidar(null);
    // Deserialize message field [colorcone]
    // Deserialize array length for message field [colorcone]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.colorcone = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.colorcone[i] = Colorcone_lidar.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += 20 * object.colorcone.length;
    return length + 4;
  }

  static datatype() {
    // Returns string type for a message object
    return 'vision_distance/ColorconeArray_lidar';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '9e6e1a7ba6469e9996876e5e3ae62dc4';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    vision_distance/Colorcone_lidar[] colorcone
    
    ================================================================================
    MSG: vision_distance/Colorcone_lidar
    int32 flag
    float64 dist_x
    float64 dist_y
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new ColorconeArray_lidar(null);
    if (msg.colorcone !== undefined) {
      resolved.colorcone = new Array(msg.colorcone.length);
      for (let i = 0; i < resolved.colorcone.length; ++i) {
        resolved.colorcone[i] = Colorcone_lidar.Resolve(msg.colorcone[i]);
      }
    }
    else {
      resolved.colorcone = []
    }

    return resolved;
    }
};

module.exports = ColorconeArray_lidar;
