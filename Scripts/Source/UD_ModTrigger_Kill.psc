;/  File: UD_ModTrigger_Kill
    Triggers on kill
    
    NameFull: On Kill
    
    Parameters (DataStr):                            
        [0]     Int     (optional) Minimum number of kills to trigger
                        Default value: 0
        
        [1]     Float   (optional) Base probability to trigger on kill (in %)
                        Default value: 100.0%
        
        [2]     Int     (optional) Probability to trigger that is proportional to the accumulated value (of consecutive kills)
                        Default value: 0.0%
                        
        [3]     Int     (optional) Repeat
                        Default value: 0 (False)
                        
        [4]     Float   (script) Number of consecutive kills so far
                        
    Example:
                    
/;
Scriptname UD_ModTrigger_Kill extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ValidateTrigger(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    EventProcessingMask = 0x00008000
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function KillMonitor(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1)
    Int loc_min_value = GetStringParamInt(aiDataStr, 0, 0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_accum = GetStringParamFloat(aiDataStr, 2, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 0) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = 1, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_str = ""
    loc_str += "On kill"
    loc_str += "\n"
    loc_str += "Threshold value: " + GetStringParamInt(aiDataStr, 0, 0)
    loc_str += "\n"
    loc_str += "Base probability: " + FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 2) + "%"
    loc_str += "\n"
    loc_str += "Accumulator weight: " + FormatFloat(GetStringParamFloat(aiDataStr, 2, 0.0), 2) + "%"
    loc_str += "\n"
    If GetStringParamInt(aiDataStr, 3, 0) > 0
        loc_str += "Repeat: True"
    Else
        loc_str += "Repeat: False"
    EndIf
    loc_str += "\n"
    loc_str += "Accumulator: " + GetStringParamInt(aiDataStr, 4, 0)
    loc_str += "\n"
    loc_str += "(Accumulator contains the number of consecutive kills)"
    
    Return loc_str
EndFunction
