;/  File: UD_ModTrigger_HourChance
    It triggers every hour with a given probability
    
    NameFull: 
    NameAlias: THC
    
    Parameters (DataStr):
        [0]     Float   (optional) Base probability to trigger
        
        [1]     Int     (optional) The final probability increases with each hour
                        Default value: 0 (False)
                        
        [2]     Float   (script) Hours passed

    Example:
                    
/;
Scriptname UD_ModTrigger_HourChance extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function TimeUpdateHour(String asNameAlias, UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr)
    Float loc_prob = GetStringParamFloat(aiDataStr, 0)
    If GetStringParamInt(aiDataStr, 1, 0) > 0
        Float loc_hours = GetStringParamFloat(aiDataStr, 2, 0.0) + afMult
        If RandomFloat(0.0, 100.0) < loc_prob * loc_hours
            akDevice.editStringModifier(asNameAlias, 2, "0.0")
            Return True
        Else
            akDevice.editStringModifier(asNameAlias, 2, FormatFloat(loc_hours, 2))
            Return False
        EndIf
    Else
        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
EndFunction
