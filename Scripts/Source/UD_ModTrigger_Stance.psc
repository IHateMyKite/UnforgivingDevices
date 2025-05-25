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
    String loc_stance = GetStringParamString(aiDataStr, 0, "")
    Bool loc_reset = GetStringParamInt(aiDataStr, 3, 1) > 0
    Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0

    If !BaseTriggerIsActive(aiDataStr, 5)
        Return False
    EndIf

    If IsInStance(loc_actor, loc_stance)
        Float loc_min_value = MultFloat(GetStringParamFloat(aiDataStr, 1, 0.0), akModifier.MultInputQuantities)
        Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
        Float loc_accum = GetStringParamFloat(aiDataStr, 5, 0.0)

        If loc_accum < 0.1 
        ; leading edge, make a note and skip the rest
            If UDmain.TraceAllowed()
                UDmain.Log("UD_ModTrigger_Stance::TimeUpdateSeconds() akModifier = " + akModifier + ", akDevice = " + akDevice + ", afRealSecondsSinceLastCall = " + FormatFloat(afRealSecondsSinceLastCall, 1) + ". Beginning of counting.", 3)
            EndIf
        EndIf

        If BaseTriggerIsActive(aiDataStr, 5) && RandomFloat(0.0, 100.0) < 15.0
            PrintNotification(akDevice, ;/ reacted /;"probably because of the way you move.")
        EndIf

        Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afRealSecondsSinceLastCall, afMinAccum = loc_min_value, afProbBase = 0.0, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 5)
    ElseIf loc_reset
    ; reseting accumulator
        If UDmain.TraceAllowed()
            UDmain.Log("UD_ModTrigger_Stance::TimeUpdateSeconds() akModifier = " + akModifier + ", akDevice = " + akDevice + ", afRealSecondsSinceLastCall = " + FormatFloat(afRealSecondsSinceLastCall, 1) + ". Reseting accumulator.", 3)
        EndIf
        Float loc_accum = GetStringParamFloat(aiDataStr, 5, 0.0)
        If loc_accum > 0.0
            akDevice.editStringModifier(akModifier.NameAlias, 5, "0.0")
        EndIf
    EndIf

    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Float loc_min_value = MultFloat(GetStringParamFloat(aiDataStr, 1, 0.0), akModifier.MultInputQuantities)
    Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    Bool loc_reset = GetStringParamInt(aiDataStr, 3, 1) > 0
    Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0
    Float loc_accum = GetStringParamFloat(aiDataStr, 5, 0.0)

    String loc_res = ""
    String loc_frag = GetStringParamString(aiDataStr, 0, "")
    If UDmain.UDMTF.HasHtmlMarkup()
        loc_frag = GetStanceString(loc_frag, "<br/> \t\t")
    Else
        loc_frag = GetStanceString(loc_frag, ", ")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Stance(s):", loc_frag)
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold duration:", FormatFloat(loc_min_value, 1) + " s")
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator weight:", FormatFloat(loc_prob_accum, 2) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Reset on new stance:", InlineIfStr(loc_reset, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(loc_repeat, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:", FormatFloat(loc_accum, 1) + " s")
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains total duration)", asAlign = "center")

    Return loc_res
EndFunction

;/  Group: Protected Methods
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function IsInStance(Actor akActor, String asStance)
    If asStance == ""
        Return False
    EndIf
    Bool loc_any_stance_given = False
    If StringUtil.Find(asStance, "RN") >= 0 
        If akActor.IsRunning() == False
            Return False
        EndIf
        loc_any_stance_given = True
    EndIf
    If StringUtil.Find(asStance, "SP") >= 0 
        If akActor.IsSprinting() == False
            Return False
        EndIf
        loc_any_stance_given = True
    EndIf
    If StringUtil.Find(asStance, "SN") >= 0 
        If akActor.IsSneaking() == False
            Return False
        EndIf
        loc_any_stance_given = True
    EndIf
    If StringUtil.Find(asStance, "TP") >= 0 
        If akActor.IsTrespassing() == False
            Return False
        EndIf
        loc_any_stance_given = True
    EndIf
    If StringUtil.Find(asStance, "WD") >= 0 
        If akActor.IsWeaponDrawn() == False
            Return False
        EndIf
        loc_any_stance_given = True
    EndIf
    Return loc_any_stance_given
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