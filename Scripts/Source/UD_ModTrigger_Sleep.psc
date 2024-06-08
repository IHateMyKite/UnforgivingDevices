;/  File: UD_ModTrigger_Sleep
    It triggers with a given chance after player sleeps
    
    NameFull: 
    
    Parameters in DataStr:
        [0]     Int     (optional) Minimum sleep duration to trigger (in hours)
                        Default value: 0 hours
        
        [1]     Float   (optional) Base probability to trigger (in %)
                        Default value: 100.0%
        
        [2]     Int     (optional) Probability to trigger is proportional to the sleep duration
                        Default value: 0.0%
                        
        [3]     Int     (optional) Normal = 1, interrupted = 2 or any = 0
                        Default value: 0 (Any)
                        
        [4]     Int     (optional) Repeat
                        Default value: 0 (False)

    Example:
        

/;
Scriptname UD_ModTrigger_Sleep extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function Sleep(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr)
    Int loc_ending = GetStringParamInt(aiDataStr, 3, 0)
    If (loc_ending == 2 && !abInterrupted) || (loc_ending == 1 && abInterrupted)
        Return False
    EndIf
    Int loc_min_dur = GetStringParamInt(aiDataStr, 0, 0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_value = GetStringParamFloat(aiDataStr, 2, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0
    Return TriggerOnValueAbs(akDevice, akModifier.NameAlias, aiDataStr, afValueAbs = afDuration, afMinValue = loc_min_dur, afProbBase = loc_prob_base, afProbAccum = loc_prob_value, abRepeat = loc_repeat)
EndFunction
