;/  File: UD_ModTrigger_DeviceEvent
    It triggers on device event
    
    NameFull: On Device Event
    
    Parameters (DataStr):
        [0]     String  Device event to trigger (one or several separated by space)
                            DL - DeviceLocked
                            DU - DeviceUnlocked
                            DB - DeviceBroken
                            
        [1]     Float   Base probability to trigger on event (in %)
                        Default value: 100.0%
                              
    Example:
                    
/;
Scriptname UD_ModTrigger_DeviceEvent extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Int Function GetEventProcessingMask()
    Return 0x00000000
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    Return loc_event == "DL" && (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
EndFunction

Bool Function DeviceUnlocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    Return loc_event == "DU" && (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
EndFunction

Bool Function ConditionLoss(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1)
    If aiCondition == 4
        String loc_event = GetStringParamString(aiDataStr, 0, "")
        Return loc_event == "DB" && (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    String loc_frag = GetStringParamString(aiDataStr, 0, "")
    If UDmain.UDMTF.HasHtmlMarkup()
        loc_frag = GetDeviceEventString(loc_frag, "<br/> \t")
    Else
        loc_frag = GetDeviceEventString(loc_frag, ", ")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Event(s):", loc_frag)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 1) + "%")
    Return loc_res
EndFunction

;/  Group: Protected Methods
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetDeviceEventString(String asAbbr, String asSep = ", ")
    String loc_str = ""
    Bool loc_comma = False
    If StringUtil.Find(asAbbr, "DL") >= 0 || StringUtil.Find(asAbbr, "DeviceLocked") >= 0
        loc_str += "Device Lock"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "DU") >= 0 || StringUtil.Find(asAbbr, "DeviceUnlocked") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Device Unlock"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "DB") >= 0 || StringUtil.Find(asAbbr, "DeviceBroken") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Device Broke"
        loc_comma = True
    EndIf
    Return loc_str
EndFunction