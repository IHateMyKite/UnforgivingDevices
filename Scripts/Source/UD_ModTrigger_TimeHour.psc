;/  File: UD_ModTrigger_TimeHour
    It triggers every hour with a given probability
    
    NameFull: Hourly Trigger
    
    Parameters (DataStr):
        [0]     Float   (optional) Hours must pass before trigger
                        Default value: 0.0
        
        [1]     Float   (optional) Base probability to trigger
                        Default value: 100.0%
        
        [2]     Float   (optional) The final probability increases with each passed hour by X %
                        Default value: 0.0%
                        
        [3]     Int     (optional) Repeat
                        Default value: 1 (True)
                        
        [4]     Float   (script) Hours passed since last trigger

    Example:
                    
/;
Scriptname UD_ModTrigger_TimeHour extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Int Function GetEventProcessingMask()
    Return 0x00000002
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function TimeUpdateHour(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1)
    Float loc_min_time = GetStringParamFloat(aiDataStr, 0, 0.0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_accum = GetStringParamFloat(aiDataStr, 2, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 1) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afMult, afMinAccum = loc_min_time, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_str = ""
    loc_str += "On elapsed time (hours)"
    loc_str += "\n"
    loc_str += "Threshold value: " + FormatFloat(GetStringParamFloat(aiDataStr, 0, 0.0), 2) + " hours"
    loc_str += "\n"
    loc_str += "Base probability: " + FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 2) + "%"
    loc_str += "\n"
    loc_str += "Value weight: " + FormatFloat(GetStringParamFloat(aiDataStr, 2, 0.0), 2) + "% per hour"
    loc_str += "\n"
    loc_str += "Repeat: " + InlineIfStr(GetStringParamInt(aiDataStr, 3, 0) > 0, "True", "False")
    loc_str += "\n"
    loc_str += "Accumulator: " + FormatFloat(GetStringParamFloat(aiDataStr, 4, 0.0), 2) + " hours"
    loc_str += "\n"
    loc_str += "(Accumulator contains hours passed since the last trigger)"
    
    Return loc_str
EndFunction
