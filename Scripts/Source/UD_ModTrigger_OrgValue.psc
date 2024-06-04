;/  File: UD_ModTrigger_OrgValue
    It triggers after a certain number of orgasms
    
    NameFull: 
    NameAlias: TOV
    
    Parameters (DataStr):
        [0]     Int     Number of orgasms to trigger
        
        [1]     Int     (optional) Repeat
                        Default value: 0 (False)
        
        [2]     Int     (script) Number of consecutive orgasms so far
                        If it is negative then trigger will never occur
        
    Example:
                    
/;
Scriptname UD_ModTrigger_OrgValue extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function Orgasm(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    Int loc_current = GetStringParamInt(aiDataStr, 2, 0)
    If loc_current < 0
        Return False
    EndIf
    loc_current += 1
    Int loc_needed = GetStringParamInt(aiDataStr, 0)
    If loc_current >= loc_needed
        If GetStringParamInt(aiDataStr, 1, 0) > 0
            akDevice.editStringModifier(akModifier.NameAlias, 2, 0)
        Else
            akDevice.editStringModifier(akModifier.NameAlias, 2, -1)
        EndIf
        Return True
    Else 
        akDevice.editStringModifier(akModifier.NameAlias, 2, loc_current)
        Return False
    EndIf
EndFunction
