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

        [5]     Float       (script) Hours passed since last check. Used to set the initial period offset, and to spread the execution of hour triggers to different moments.

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
Bool Function TimeUpdateSeconds(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, Float afRealSecondsSinceLastCall, String aiDataStr, Form akForm1)
    Float loc_min_value = MultFloat(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_acc = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 1) > 0

    If !BaseTriggerIsActive(aiDataStr, 4)
        Return False
    EndIf

    Float loc_last_check = GetStringParamFloat(aiDataStr, 5, 0.0)

    If loc_last_check + afGameHoursSinceLastCall > 1.00
        akDevice.editStringModifier(akModifier.NameAlias, 5, "0.0")
    Else
        akDevice.editStringModifier(akModifier.NameAlias, 5, FormatFloat(loc_last_check + afGameHoursSinceLastCall, 3))
        Return False
    EndIf

    If RandomFloat(0.0, 100.0) < 35.0
        PrintNotification(akDevice, "You feel that your " + akDevice.UD_DeviceType + " pulsing faintly and slowly, as if responding to the passage of time.", aiEffectId = 0)
    EndIf

    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afGameHoursSinceLastCall, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_acc, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

Bool Function TimeUpdateHour(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, String aiDataStr, Form akForm1)
    Return False
;/    
    Float loc_min_value = MultFloat(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_acc = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 1) > 0

    If BaseTriggerIsActive(aiDataStr, 4) && RandomFloat(0.0, 100.0) < 50.0
        PrintNotification(akDevice, "You feel that your " + akDevice.UD_DeviceType + " pulsing faintly and slowly, as if responding to the passage of time.", aiEffectId = 0)
    EndIf

    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afGameHoursSinceLastCall, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_acc, abRepeat = loc_repeat, aiAccumParamIndex = 4)
/;
EndFunction

Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Float loc_offset = RandomFloat(-0.45, 0.45)
    akDevice.editStringModifier(akModifier.NameAlias, 5, FormatFloat(loc_offset, 3))
    If UDmain.TraceAllowed()
        UDmain.Log(Self + "::DeviceLocked() loc_offset = " + FormatFloat(loc_offset, 3), 3)
    EndIf
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Float loc_min_value = MultFloat(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_acc = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:", FormatFloat(loc_min_value, 2) + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Value weight:", FormatFloat(loc_prob_acc, 1) + "% per hour")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(GetStringParamInt(aiDataStr, 3, 1) > 0, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:", FormatFloat(GetStringParamFloat(aiDataStr, 4, 0.0), 2) + " hours")
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains hours passed since the last trigger)", asAlign = "center")
    Return loc_res
EndFunction