;/  File: UD_ModTrigger_DurChance
    It triggers with a given chance when the durability of the device is reduced
    
    NameFull: 
    NameAlias: TDC
    
    Parameters (DataStr):
        [0]     Float   Base probability to trigger
        
        [1]     Int     (optional) Final probability is proportional to the current durability
                        Default value: 0 (False)

    Example:
                    
/;
Scriptname UD_ModTrigger_DurChance extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ConditionLoss(String asNameAlias, UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr)
    Float loc_prob = GetStringParamFloat(aiDataStr, 0)
    Bool loc_proportional = GetStringParamInt(aiDataStr, 1, 0) > 0
    If loc_proportional
        Return (RandomFloat(0.0, 100.0) < loc_prob * aiCondition)
    Else
        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
    Return False
EndFunction
