;/  File: UD_ModTrigger_TimeHour
    It triggers every hour with a given probability
    
    NameFull: Hourly Trigger
    
    Parameters in DataStr:
        [0]     Float       (optional) Hours must pass before trigger
                            Default value: 0.0

        [1]     Float       (optional) Base probability to trigger
                            Default value: 100.0%

        [2]     Float       (optional) The final probability increases with each passed hour by X %
                            Default value: 0.0%

        [3]     Int         (optional) Repeat
                            Default value: 1 (True)

        [4]     Float       (script) Hours passed since last trigger

    Example:
                    
/;
Scriptname UD_ModTrigger_TimeHour extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function TimeUpdateHour(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afHoursSinceLastCall, String aiDataStr, Form akForm1)
    Float loc_min_time = GetStringParamFloat(aiDataStr, 0, 0.0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_accum = GetStringParamFloat(aiDataStr, 2, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 1) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afHoursSinceLastCall, afMinAccum = loc_min_time, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:", FormatFloat(GetStringParamFloat(aiDataStr, 0, 0.0), 2) + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Value weight:", FormatFloat(GetStringParamFloat(aiDataStr, 2, 0.0), 1) + "% per hour")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(GetStringParamInt(aiDataStr, 3, 1) > 0, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:", FormatFloat(GetStringParamFloat(aiDataStr, 4, 0.0), 2) + " hours")
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains hours passed since the last trigger)", asAlign = "center")
    Return loc_res
EndFunction