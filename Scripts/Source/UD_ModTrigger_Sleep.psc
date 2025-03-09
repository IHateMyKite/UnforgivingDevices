;/  File: UD_ModTrigger_Sleep
    It triggers with a given chance after sleep
    
    NameFull: On Sleep
    
    Parameters in DataStr:
        [0]     Int         (optional) Minimum sleep duration to trigger (in hours)
                            Default value: 0 hours

        [1]     Float       (optional) Base probability to trigger (in %)
                            Default value: 100.0%

        [2]     Float       (optional) Probability to trigger is proportional to the sleep duration
                            Default value: 0.0%

        [3]     Int         (optional) Normal = 1, interrupted = 2 or any = 0
                            Default value: 0 (Any)

        [4]     Int         (optional) Repeat
                            Default value: 0 (False)

    Example:

/;
Scriptname UD_ModTrigger_Sleep extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function Sleep(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr, Form akForm1)
    Int loc_ending = GetStringParamInt(aiDataStr, 3, 0)
    If (loc_ending == 2 && !abInterrupted) || (loc_ending == 1 && abInterrupted)
        Return False
    EndIf
    Int loc_min_dur = MultInt(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0
    Return TriggerOnValueAbs(akDevice, akModifier.NameAlias, aiDataStr, afValueAbs = afDuration, afMinValue = loc_min_dur, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Int loc_min_dur = MultInt(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    String loc_res = ""
    Int loc_cond = GetStringParamInt(aiDataStr, 4, 0)
    String loc_frag = ""
    If loc_cond == 0
        loc_frag = "Any"
    ElseIf loc_cond == 1
        loc_frag = "Normal"
    ElseIf loc_cond == 2
        loc_frag = "Interrupted"
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:", loc_min_dur + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator weight:", FormatFloat(loc_prob_accum, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Sleep condition:", loc_frag)
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(GetStringParamInt(aiDataStr, 4, 0) > 0, "True", "False"))
    Return loc_res
EndFunction