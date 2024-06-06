;/  File: UD_ModTrigger_Condition
    It triggers with a given chance when the durability of the device is reduced
    
    NameFull: 
    
    Parameters (DataStr):
        [0]     Int     (optional) When the durability of a device falls below given threshold, it evolves
                            0 - "Excellent"
                            1 - "Good"
                            2 - "Normal"
                            3 - "Bad"
                            4 - "Destroyed"
                        Default value: 0 (Always)

        [1]     Float   (optional) Base probability to trigger on call (in %)
                        Default value: 100.0% (Always)
                        
        [2]     Float   (optional) Weight of the absolute value (device condition) in total probability (in %)
                        Default value: 0.0%
        
        [3]     Int     (optional) Repeat
                        Default value: 0 (False)

    Example:
        1           - triggers once the condition becomes "good" or worse
        0,50,0,1    - can trigger with a 50% probability each time the device deteriorates
        2,0,10,0    - can trigger once on "normal" or worse condition with increased probability on every step down
                        normal  -> 2*10 = 20% probability
                        bad     -> 3*10 = 30% probability

/;
Scriptname UD_ModTrigger_Condition extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ConditionLoss(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr)
    If aiCondition > 3
    ; ignoring "destroyed" state. Use UD_ModTrigger_SimpleEvent + DeviceBroken instead.
        Return False
    EndIf
    Int loc_min_condition = GetStringParamInt(aiDataStr, 0, 0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_value = GetStringParamFloat(aiDataStr, 2, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 0) > 0
    Return TriggerOnValueAbs(akDevice, akModifier.NameAlias, aiDataStr, afValueAbs = aiCondition, afMinValue = loc_min_condition, afProbBase = loc_prob_base, afProbAccum = loc_prob_value, abRepeat = loc_repeat)
EndFunction
