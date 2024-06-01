;/  File: UD_ModTrigger_HourValue
    It triggers after a certain period of time
    
    NameFull: 
    NameAlias: TOV
    
    Parameters (DataStr):
        [0]     Float   Hours before triggering
        
        [1]     Int     (optional) Repeat
                        Default value: 1 (True)
        
        [2]     Float   (script) Hours passed since last trigger
        
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
    Float loc_current = GetStringParamFloat(aiDataStr, 2, 0.0)
    If loc_current < 0.0
        Return False
    EndIf
    loc_current += afMult
    Float loc_needed = GetStringParamFloat(aiDataStr, 0)
    If loc_current >= loc_needed
        If GetStringParamInt(aiDataStr, 1, 0) > 0
            akDevice.editStringModifier(asNameAlias, 2, FormatFloat(0, 2))
        Else
            akDevice.editStringModifier(asNameAlias, 2, FormatFloat(-1, 2))
        EndIf
        Return True
    Else 
        akDevice.editStringModifier(asNameAlias, 2, FormatFloat(loc_current, 2))
        Return False
    EndIf
EndFunction
