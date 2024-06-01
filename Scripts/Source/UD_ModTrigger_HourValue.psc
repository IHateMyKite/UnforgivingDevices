;/  File: UD_ModTrigger_HourValue
    It triggers after a certain period of time
    
    NameFull: 
    NameAlias: TOV
    
    Parameters (DataStr):
        [0]     Float   Hours before triggering
        
        [1]     Float   (script) Hours passed since last trigger                                    
        
    Example:
                    
/;
Scriptname UD_ModTrigger_HourValue extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function TimeUpdateHour(String asNameAlias, UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr)
    Float loc_h_needed = GetStringParamFloat(aiDataStr, 0)
    Float loc_h_passed = GetStringParamFloat(aiDataStr, 1, 0.0) + afMult
    if loc_h_passed >= loc_h_needed
        akDevice.editStringModifier(asNameAlias, 1, "0.0")
        Return True
    else
        akDevice.editStringModifier(asNameAlias, 1, FormatFloat(loc_h_passed, 2))
    endif
    Return False
EndFunction
