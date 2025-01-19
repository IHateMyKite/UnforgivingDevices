;/  File: UD_ModTrigger_Stance
    It triggers with a given chance while actor uses specific stance or movement style
    
    NameFull: On Stance
    
    Parameters in DataStr:
        [0]     String      Stance (one or combination):
                                RN or Running
                                SP or Sprinting
                                SN or Sneaking
                                TP or Trespassing
                                WD or WeaponDrawn

        [1]     Float       (optional) Minimum duration in seconds
                            Default value: 0.0 sec

        [2]     Float       (optional) Probability to trigger per second of the stance duration
                            Default value: 0.0%

        [3]     Int         (optional) Reset duration on new stance. If false then duration is accumulated for all periods of taking the stance
                            Default value: 1 (True)

        [4]     Int         (optional) Repeat
                            Default value: 0 (False)

        [5]     Float       (script) Accumulated duration (in seconds)

    Example:

/;
Scriptname UD_ModTrigger_Stance extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function TimeUpdateSeconds(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, Float afRealSecondsSinceLastCall, String aiDataStr, Form akForm1)
    Actor loc_actor =  akDevice.GetWearer()
    String loc_stance = GetStringParamString(aiDataStr, 1, "")
    Bool loc_reset = GetStringParamInt(aiDataStr, 3, 0) > 0

    If IsInStance(loc_actor, loc_stance)
        Int loc_min_value = MultInt(GetStringParamInt(aiDataStr, 1, 0), akModifier.MultInputQuantities)
        Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
        Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0
        Float loc_accum = GetStringParamFloat(aiDataStr, 5, 0.0)

        Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afRealSecondsSinceLastCall, afMinAccum = loc_min_value, afProbBase = 0.0, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 5)
    ElseIf loc_reset
    ; reseting accumulator
        akDevice.editStringModifier(akModifier.NameAlias, 5, FormatFloat(0, 2))
    EndIf

    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Int loc_min_value = MultInt(GetStringParamInt(aiDataStr, 1, 0), akModifier.MultInputQuantities)
    Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    Bool loc_reset = GetStringParamInt(aiDataStr, 3, 0) > 0
    Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0
    Float loc_accum = GetStringParamFloat(aiDataStr, 5, 0.0)

    String loc_res = ""
    String loc_frag = ""
    If UDmain.UDMTF.HasHtmlMarkup()
        loc_frag = GetStanceString(loc_frag, "<br/> \t\t")
    Else
        loc_frag = GetStanceString(loc_frag, ", ")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Stance(s):", loc_frag)
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold duration:", loc_min_value + " s")
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator weight:", FormatFloat(loc_prob_accum, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Reset on new stance:", InlineIfStr(loc_reset, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(loc_repeat, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:", GetStringParamInt(aiDataStr, 5, 0) + " s")
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains total duration)", asAlign = "center")

    Return loc_res
EndFunction

;/  Group: Protected Methods
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function IsInStance(Actor akActor, String asStance)
    If StringUtil.Find(asStance, "RN") >= 0 && akActor.IsRunning() == False
        Return False
    EndIf
    If StringUtil.Find(asStance, "SP") >= 0 && akActor.IsSprinting() == False
        Return False
    EndIf
    If StringUtil.Find(asStance, "SN") >= 0 && akActor.IsSneaking() == False
        Return False
    EndIf
    If StringUtil.Find(asStance, "TP") >= 0 && akActor.IsTrespassing() == False
        Return False
    EndIf
    If StringUtil.Find(asStance, "WD") >= 0 && akActor.IsWeaponDrawn() == False
        Return False
    EndIf
    Return True
EndFunction

String Function GetStanceString(String asAbbr, String asSep = ", ")
    String loc_str = ""
    Bool loc_comma = False
    If StringUtil.Find(asAbbr, "RN") >= 0
        loc_str += "Running"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "SP") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Sprinting"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "SN") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Sneaking"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "TP") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Trespassing"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "WD") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Weapon Drawn"
        loc_comma = True
    EndIf
    Return loc_str
EndFunction