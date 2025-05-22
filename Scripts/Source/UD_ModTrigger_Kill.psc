;/  File: UD_ModTrigger_Kill
    Triggers on kill
    
    NameFull: On Kill
    
    Parameters in DataStr:                            
        [0]     Int         (optional) Minimum number of kills to trigger
                            Default value: 0

        [1]     Float       (optional) Base probability to trigger on kill (in %)
                            Default value: 100.0%

        [2]     Float       (optional) Probability to trigger that is proportional to the accumulated value (of consecutive kills)
                            Default value: 0.0%

        [3]     Int         (optional) Repeat
                            Default value: 0 (False)

        [4]     Int         (optional) Killings: 1 - non-criminal, -1 - criminal, 0 - any
                            Defalut value: 0 (any killings)

        [5]     Int         (script) Number of consecutive kills so far

    Example:
        Form1               The faction to which the victim should belong, or a form list with factions

/;
Scriptname UD_ModTrigger_Kill extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function KillMonitor(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1)
    Int loc_min_value = MultInt(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 0) > 0
    Int loc_killings = GetStringParamInt(aiDataStr, 4, 0)

    ; checking crime status
    If loc_killings < 0 && aiCrimeStatus <= 0
        Return False
    ElseIf loc_killings > 0 && aiCrimeStatus > 0
        Return False
    EndIf

    ; checking victims faction
    If (akForm1 as Faction) && (akVictim as Actor)
        If (akVictim as Actor).GetFactionRank(akForm1 as Faction) < 0
            Return False
        EndIf
    ElseIf (akForm1 as FormList) && (akVictim as Actor)
        Int loc_i = (akForm1 as FormList).GetSize()
        Bool loc_in_any_faction = False
        Faction loc_faction = None
        While loc_i > 0
            loc_i -= 1
            loc_faction = (akForm1 as FormList).GetAt(loc_i) as Faction
            If (akVictim as Actor).GetFactionRank(loc_faction) > -1
                loc_in_any_faction = True
            EndIf
        EndWhile
        If !loc_in_any_faction 
            Return False
        EndIf
    EndIf

    If RandomFloat(0.0, 100.0) < 50.0
        PrintNotification(akDevice, ;/ reacted /;" because of your actions. You're horrified to realize you've taken someone's life.")
    EndIf

    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = 1, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 5)
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
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains the number of consecutive kills)", asAlign = "center")
    Return loc_res
EndFunction