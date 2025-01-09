;/  File: UD_ModTrigger_SpellCast
    It triggers when actor casts a spell

    NameFull: On Spell Cast

    Parameters in DataStr:
        [0]     Int         (optional) Minimum accumulated cost to trigger
                            Default value: 0

        [1]     Float       (optional) Base probability to trigger (in %)
                            Default value: 100.0%

        [2]     Float       (optional) Probability to trigger is proportional to the spell cost
                            Default value: 0.0%

        [3]     Float       (optional) Probability to trigger that is proportional to the accumulated value (total mana spent)
                            Default value: 0.0%

        [4]     Int         (optional) Repeat
                            Default value: 0 (False)

        [5]     Float       (script) Total mana spent so far

    Example:
        200,,,,,,           It will trigger once on the first cast after the wearer has spent a total of 200 mana.
        0,50,,,1,,          It will trigger with a 50% probability on each spell cast.
        0,10,1.0,0.1,1,,    It will trigger at each cast with a probability calculated by the formula: 10% + <spell mana cost> * 1.0% + <mana spent since the last trigger> * 0.1%.

/;
Scriptname UD_ModTrigger_SpellCast extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function SpellCast(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1)
    Int loc_cost = iRange(akSpell.GetMagickaCost(), 5, 100)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_SpellCast::SpellCast() akModifier = " + akModifier + ", akDevice = " + akDevice + ", akSpell = " + akSpell + ", aiDataStr = " + aiDataStr + ", loc_cost = " + loc_cost, 3)
    EndIf
    
    ; TODO PR195: better cost calculation
    
    Int loc_min_cost = GetStringParamInt(aiDataStr, 0, 0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_delta = GetStringParamFloat(aiDataStr, 2, 0.0)
    Float loc_prob_acc = GetStringParamFloat(aiDataStr, 3, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = loc_cost, afMinAccum = loc_min_cost, afProbBase = loc_prob_base, afProbDelta = loc_prob_delta, afProbAccum = loc_prob_acc, abRepeat = loc_repeat, aiAccumParamIndex = 5)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:", GetStringParamInt(aiDataStr, 0, 0) + " mana")
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Value weight:", FormatFloat(GetStringParamFloat(aiDataStr, 2, 0.0), 2) + "% of mana cost")
    loc_res += UDmain.UDMTF.TableRowDetails("Accum weight:", FormatFloat(GetStringParamFloat(aiDataStr, 3, 0.0), 2) + "% total mana spent")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(GetStringParamInt(aiDataStr, 4, 0) > 0, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:", FormatFloat(GetStringParamFloat(aiDataStr, 5, 0), 0) + " mana")
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains the total mana spent so far)", asAlign = "center")
    Return loc_res
EndFunction