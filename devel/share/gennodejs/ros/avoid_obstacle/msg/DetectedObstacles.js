// Auto-generated. Do not edit!

// (in-package avoid_obstacle.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let PointObstacles = require('./PointObstacles.js');

//-----------------------------------------------------------

class DetectedObstacles {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.obstacles = null;
    }
    else {
      if (initObj.hasOwnProperty('obstacles')) {
        this.obstacles = initObj.obstacles
      }
      else {
        this.obstacles = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type DetectedObstacles
    // Serialize message field [obstacles]
    // Serialize the length for message field [obstacles]
    bufferOffset = _serializer.uint32(obj.obstacles.length, buffer, bufferOffset);
    obj.obstacles.forEach((val) => {
      bufferOffset = PointObstacles.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type DetectedObstacles
    let len;
    let data = new DetectedObstacles(null);
    // Deserialize message field [obstacles]
    // Deserialize array length for message field [obstacles]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.obstacles = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.obstacles[i] = PointObstacles.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += 32 * object.obstacles.length;
    return length + 4;
  }

  static datatype() {
    // Returns string type for a message object
    return 'avoid_obstacle/DetectedObstacles';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'fa7a17ca5db5a73d6a4b2807ae3490ab';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    avoid_obstacle/PointObstacles[] obstacles
    
    ================================================================================
    MSG: avoid_obstacle/PointObstacles
    float64 x                       # Central point X [m]
    float64 y                       # Central point Y [m]
    float64 radius                  # Radius with added margin [m]
    float64 true_radius             # True measured radius [m]
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new DetectedObstacles(null);
    if (msg.obstacles !== undefined) {
      resolved.obstacles = new Array(msg.obstacles.length);
      for (let i = 0; i < resolved.obstacles.length; ++i) {
        resolved.obstacles[i] = PointObstacles.Resolve(msg.obstacles[i]);
      }
    }
    else {
      resolved.obstacles = []
    }

    return resolved;
    }
};

module.exports = DetectedObstacles;
