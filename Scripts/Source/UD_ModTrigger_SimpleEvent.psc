;/  File: UD_ModTrigger_SimpleEvent
    Trigger on simple event
    
    NameFull: 
    NameAlias: TSE
    
    Parameters (DataStr):
        [0]     String  Simple event to trigger
                            DL, DeviceLocked
                            DU, DeviceUnlocked
                            DB, DeviceBroken

    Example:
                    
/;
Scriptname UD_ModTrigger_SimpleEvent extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function DeviceLocked(String asNameAlias, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    Return (loc_event == "DL" || loc_event == "DeviceLocked")
EndFunction

Bool Function DeviceUnlocked(String asNameAlias, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    Return (loc_event == "DU" || loc_event == "DeviceUnlocked")
EndFunction

Bool Function DeviceBroken(String asNameAlias, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    Return (loc_event == "DB" || loc_event == "DeviceBroken")
EndFunction
