// Auto-generated. Do not edit!

// (in-package vision_distance.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let Colorcone = require('./Colorcone.js');

//-----------------------------------------------------------

class ColorconeArray {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.visions = null;
    }
    else {
      if (initObj.hasOwnProperty('visions')) {
        this.visions = initObj.visions
      }
      else {
        this.visions = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type ColorconeArray
    // Serialize message field [visions]
    // Serialize the length for message field [visions]
    bufferOffset = _serializer.uint32(obj.visions.length, buffer, bufferOffset);
    obj.visions.forEach((val) => {
      bufferOffset = Colorcone.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type ColorconeArray
    let len;
    let data = new ColorconeArray(null);
    // Deserialize message field [visions]
    // Deserialize array length for message field [visions]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.visions = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.visions[i] = Colorcone.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += 20 * object.visions.length;
    return length + 4;
  }

  static datatype() {
    // Returns string type for a message object
    return 'vision_distance/ColorconeArray';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'ac69fdcb59f6be81c060279a9cb29dcb';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    vision_distance/Colorcone[] visions
    
    ================================================================================
    MSG: vision_distance/Colorcone
    int32 flag
    float64 x
    float64 y
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new ColorconeArray(null);
    if (msg.visions !== undefined) {
      resolved.visions = new Array(msg.visions.length);
      for (let i = 0; i < resolved.visions.length; ++i) {
        resolved.visions[i] = Colorcone.Resolve(msg.visions[i]);
      }
    }
    else {
      resolved.visions = []
    }

    return resolved;
    }
};

module.exports = ColorconeArray;
