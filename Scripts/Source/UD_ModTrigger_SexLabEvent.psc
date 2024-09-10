;/  File: UD_ModTrigger_SexLabEvent
    It triggers on sex event
    
    NameFull: On Sex Event
    
    Parameters (DataStr):
        [0]     String  

        [1]     Float   Base probability to trigger on event (in %)
                        Default value: 100.0%
                        
    Example:
        
/;
Scriptname UD_ModTrigger_SexLabEvent extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ValidateTrigger(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    EventProcessingMask = 0x80000000
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function SexLabEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Bool[] aabTypes, Actor[] aakActors, String aiDataStr, Form akForm1)
    Return False
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    String loc_str = ""
    Bool loc_comma = False
    loc_str += "On sex event"
    loc_str += "\n"
    loc_str += "Base probability: " + FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 2) + "%"
    
    Return loc_str
EndFunction
