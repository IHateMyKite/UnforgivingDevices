;/  File: UD_ModTrigger_DeviceEvent
    It triggers on device event
    
    NameFull: 
    NameAlias: SME
    
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

Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    Return loc_event == "DL" && (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
EndFunction

Bool Function DeviceUnlocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    Return loc_event == "DU" && (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
EndFunction

Bool Function ConditionLoss(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr)
    If aiCondition == 4
        String loc_event = GetStringParamString(aiDataStr, 0, "")
        Return loc_event == "DB" && (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    Return False
EndFunction
