
"use strict";

let MgaGAL = require('./MgaGAL.js');
let AidALM = require('./AidALM.js');
let CfgRATE = require('./CfgRATE.js');
let NavCLOCK = require('./NavCLOCK.js');
let NavPOSECEF = require('./NavPOSECEF.js');
let NavPVT = require('./NavPVT.js');
let CfgINF_Block = require('./CfgINF_Block.js');
let MonVER_Extension = require('./MonVER_Extension.js');
let MonGNSS = require('./MonGNSS.js');
let UpdSOS_Ack = require('./UpdSOS_Ack.js');
let NavVELNED = require('./NavVELNED.js');
let CfgNMEA7 = require('./CfgNMEA7.js');
let RxmSVSI_SV = require('./RxmSVSI_SV.js');
let NavDGPS = require('./NavDGPS.js');
let NavHPPOSLLH = require('./NavHPPOSLLH.js');
let NavDGPS_SV = require('./NavDGPS_SV.js');
let NavATT = require('./NavATT.js');
let CfgINF = require('./CfgINF.js');
let Inf = require('./Inf.js');
let NavSBAS = require('./NavSBAS.js');
let RxmEPH = require('./RxmEPH.js');
let CfgTMODE3 = require('./CfgTMODE3.js');
let MonVER = require('./MonVER.js');
let CfgGNSS_Block = require('./CfgGNSS_Block.js');
let CfgANT = require('./CfgANT.js');
let RxmRAWX_Meas = require('./RxmRAWX_Meas.js');
let RxmRAWX = require('./RxmRAWX.js');
let RxmRAW_SV = require('./RxmRAW_SV.js');
let NavTIMEGPS = require('./NavTIMEGPS.js');
let NavSVINFO = require('./NavSVINFO.js');
let MonHW = require('./MonHW.js');
let NavTIMEUTC = require('./NavTIMEUTC.js');
let EsfRAW = require('./EsfRAW.js');
let NavHPPOSECEF = require('./NavHPPOSECEF.js');
let AidEPH = require('./AidEPH.js');
let EsfSTATUS = require('./EsfSTATUS.js');
let TimTM2 = require('./TimTM2.js');
let CfgDGNSS = require('./CfgDGNSS.js');
let RxmSFRB = require('./RxmSFRB.js');
let NavSTATUS = require('./NavSTATUS.js');
let CfgNAV5 = require('./CfgNAV5.js');
let HnrPVT = require('./HnrPVT.js');
let RxmSVSI = require('./RxmSVSI.js');
let EsfINS = require('./EsfINS.js');
let CfgUSB = require('./CfgUSB.js');
let RxmALM = require('./RxmALM.js');
let RxmSFRBX = require('./RxmSFRBX.js');
let EsfRAW_Block = require('./EsfRAW_Block.js');
let EsfMEAS = require('./EsfMEAS.js');
let CfgNMEA = require('./CfgNMEA.js');
let Ack = require('./Ack.js');
let CfgCFG = require('./CfgCFG.js');
let RxmRTCM = require('./RxmRTCM.js');
let NavSAT_SV = require('./NavSAT_SV.js');
let CfgHNR = require('./CfgHNR.js');
let CfgMSG = require('./CfgMSG.js');
let NavDOP = require('./NavDOP.js');
let CfgDAT = require('./CfgDAT.js');
let CfgNAVX5 = require('./CfgNAVX5.js');
let UpdSOS = require('./UpdSOS.js');
let CfgGNSS = require('./CfgGNSS.js');
let NavSAT = require('./NavSAT.js');
let CfgNMEA6 = require('./CfgNMEA6.js');
let NavRELPOSNED = require('./NavRELPOSNED.js');
let EsfALG = require('./EsfALG.js');
let CfgPRT = require('./CfgPRT.js');
let AidHUI = require('./AidHUI.js');
let EsfSTATUS_Sens = require('./EsfSTATUS_Sens.js');
let CfgSBAS = require('./CfgSBAS.js');
let CfgRST = require('./CfgRST.js');
let NavVELECEF = require('./NavVELECEF.js');
let NavRELPOSNED9 = require('./NavRELPOSNED9.js');
let NavSOL = require('./NavSOL.js');
let NavSBAS_SV = require('./NavSBAS_SV.js');
let NavPOSLLH = require('./NavPOSLLH.js');
let NavSVINFO_SV = require('./NavSVINFO_SV.js');
let RxmRAW = require('./RxmRAW.js');
let NavPVT7 = require('./NavPVT7.js');
let NavSVIN = require('./NavSVIN.js');
let MonHW6 = require('./MonHW6.js');

module.exports = {
  MgaGAL: MgaGAL,
  AidALM: AidALM,
  CfgRATE: CfgRATE,
  NavCLOCK: NavCLOCK,
  NavPOSECEF: NavPOSECEF,
  NavPVT: NavPVT,
  CfgINF_Block: CfgINF_Block,
  MonVER_Extension: MonVER_Extension,
  MonGNSS: MonGNSS,
  UpdSOS_Ack: UpdSOS_Ack,
  NavVELNED: NavVELNED,
  CfgNMEA7: CfgNMEA7,
  RxmSVSI_SV: RxmSVSI_SV,
  NavDGPS: NavDGPS,
  NavHPPOSLLH: NavHPPOSLLH,
  NavDGPS_SV: NavDGPS_SV,
  NavATT: NavATT,
  CfgINF: CfgINF,
  Inf: Inf,
  NavSBAS: NavSBAS,
  RxmEPH: RxmEPH,
  CfgTMODE3: CfgTMODE3,
  MonVER: MonVER,
  CfgGNSS_Block: CfgGNSS_Block,
  CfgANT: CfgANT,
  RxmRAWX_Meas: RxmRAWX_Meas,
  RxmRAWX: RxmRAWX,
  RxmRAW_SV: RxmRAW_SV,
  NavTIMEGPS: NavTIMEGPS,
  NavSVINFO: NavSVINFO,
  MonHW: MonHW,
  NavTIMEUTC: NavTIMEUTC,
  EsfRAW: EsfRAW,
  NavHPPOSECEF: NavHPPOSECEF,
  AidEPH: AidEPH,
  EsfSTATUS: EsfSTATUS,
  TimTM2: TimTM2,
  CfgDGNSS: CfgDGNSS,
  RxmSFRB: RxmSFRB,
  NavSTATUS: NavSTATUS,
  CfgNAV5: CfgNAV5,
  HnrPVT: HnrPVT,
  RxmSVSI: RxmSVSI,
  EsfINS: EsfINS,
  CfgUSB: CfgUSB,
  RxmALM: RxmALM,
  RxmSFRBX: RxmSFRBX,
  EsfRAW_Block: EsfRAW_Block,
  EsfMEAS: EsfMEAS,
  CfgNMEA: CfgNMEA,
  Ack: Ack,
  CfgCFG: CfgCFG,
  RxmRTCM: RxmRTCM,
  NavSAT_SV: NavSAT_SV,
  CfgHNR: CfgHNR,
  CfgMSG: CfgMSG,
  NavDOP: NavDOP,
  CfgDAT: CfgDAT,
  CfgNAVX5: CfgNAVX5,
  UpdSOS: UpdSOS,
  CfgGNSS: CfgGNSS,
  NavSAT: NavSAT,
  CfgNMEA6: CfgNMEA6,
  NavRELPOSNED: NavRELPOSNED,
  EsfALG: EsfALG,
  CfgPRT: CfgPRT,
  AidHUI: AidHUI,
  EsfSTATUS_Sens: EsfSTATUS_Sens,
  CfgSBAS: CfgSBAS,
  CfgRST: CfgRST,
  NavVELECEF: NavVELECEF,
  NavRELPOSNED9: NavRELPOSNED9,
  NavSOL: NavSOL,
  NavSBAS_SV: NavSBAS_SV,
  NavPOSLLH: NavPOSLLH,
  NavSVINFO_SV: NavSVINFO_SV,
  RxmRAW: RxmRAW,
  NavPVT7: NavPVT7,
  NavSVIN: NavSVIN,
  MonHW6: MonHW6,
};
