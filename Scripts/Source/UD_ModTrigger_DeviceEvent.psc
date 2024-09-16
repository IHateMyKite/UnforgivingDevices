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

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    String loc_str = ""
    Bool loc_comma = False
    loc_str += "On device event ("
    If StringUtil.Find(loc_event, "DL") >= 0 || StringUtil.Find(loc_event, "DeviceLocked") >= 0
        loc_str += "Device Lock"
        loc_comma = True
    EndIf
    If StringUtil.Find(loc_event, "DU") >= 0 || StringUtil.Find(loc_event, "DeviceUnlocked") >= 0
        If loc_comma 
            loc_str += ", "
        EndIf
        loc_str += "Device Unlock"
        loc_comma = True
    EndIf
    If StringUtil.Find(loc_event, "DB") >= 0 || StringUtil.Find(loc_event, "DeviceBroken") >= 0
        If loc_comma 
            loc_str += ", "
        EndIf
        loc_str += "Device Broke"
        loc_comma = True
    EndIf
    loc_str += ")\n"
    loc_str += "Base probability: " + FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 2) + "%"
    
    Return loc_str
EndFunction
