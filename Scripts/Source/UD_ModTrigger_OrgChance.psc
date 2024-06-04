;/  File: UD_ModTrigger_OrgChance
    It triggers with a given chance after each actor's orgasm
    
    NameFull: 
    NameAlias: TOC
    
    Parameters (DataStr):
        [0]     Int     Base probability to trigger
        
        [1]     Int     (optional) The final probability increases with each consecutive orgasm
                        Default value: 0 (False)
                        
        [2]     Int     (script) Number of consecutive orgasms so far

    Example:
                    
/;
Scriptname UD_ModTrigger_OrgChance extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function Orgasm(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    Float loc_prob = GetStringParamFloat(aiDataStr, 0)
    If GetStringParamInt(aiDataStr, 1, 0) > 0
        Int loc_count = GetStringParamInt(aiDataStr, 2, 0) + 1
        If RandomFloat(0.0, 100.0) < loc_prob * loc_count
            akDevice.editStringModifier(akModifier.NameAlias, 2, 0)
            Return True
        Else
            akDevice.editStringModifier(akModifier.NameAlias, 2, loc_count)
            Return False
        EndIf
    Else
        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
EndFunction
