;/  File: UD_ModTrigger_Orgasm
    It triggers with a given chance after actor's orgasm
    
    NameFull: On Orgasm
    
    Parameters in DataStr:
        [0]     Int         (optional) Minimum number of orgasms to trigger
                            Default value: 0

        [1]     Float       (optional) Base probability to trigger (in %)
                            Default value: 100.0%

        [2]     Float       (optional) Probability to trigger that is proportional to the accumulated value (of consecutive orgasms)
                            Default value: 0.0%

        [3]     Int         (optional) Repeat
                            Default value: 0 (False)

        [4]     Int         (script) Number of consecutive orgasms so far

    Example:
        
/;
Scriptname UD_ModTrigger_Orgasm extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function Orgasm(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Int loc_min_value = MultInt(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 0) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = 1, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Int loc_min_value = MultInt(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:", loc_min_value)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator weight:", FormatFloat(loc_prob_accum, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(GetStringParamInt(aiDataStr, 3, 0) > 0, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:", FormatFloat(GetStringParamFloat(aiDataStr, 4, 0.0), 0))
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains the number of consecutive orgasms)", asAlign = "center")
    Return loc_res
EndFunction