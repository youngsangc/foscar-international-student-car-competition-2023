// Auto-generated. Do not edit!

// (in-package avoid_obstacle.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class TrueObstacles {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.detected = null;
    }
    else {
      if (initObj.hasOwnProperty('detected')) {
        this.detected = initObj.detected
      }
      else {
        this.detected = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type TrueObstacles
    // Serialize message field [detected]
    bufferOffset = _serializer.int32(obj.detected, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type TrueObstacles
    let len;
    let data = new TrueObstacles(null);
    // Deserialize message field [detected]
    data.detected = _deserializer.int32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 4;
  }

  static datatype() {
    // Returns string type for a message object
    return 'avoid_obstacle/TrueObstacles';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'b915f91311c8f5d6b235ceb818d53f80';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    int32 detected
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new TrueObstacles(null);
    if (msg.detected !== undefined) {
      resolved.detected = msg.detected;
    }
    else {
      resolved.detected = 0
    }

    return resolved;
    }
};

module.exports = TrueObstacles;
