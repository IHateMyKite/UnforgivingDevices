;/  File: UD_ModTrigger_SkillIncrease
    It triggers on player's skill increase
    
    NameFull: On Skill Increase
    
    Parameters in DataStr:
        [0]     String      Skill name (for skill names see https://ck.uesp.net/wiki/Actor_Value)
                                OneHanded
                                TwoHanded
                                Marksman (Archery)
                                Block
                                Smithing
                                HeavyArmor
                                LightArmor
                                Pickpocket
                                Lockpicking
                                Sneak
                                Alchemy
                                Speechcraft (Speech)
                                Alteration
                                Conjuration
                                Destruction
                                Illusion
                                Restoration
                                Enchanting

        [1]     Int         (optional) Minimum delta to trigger
                            Default value: 0

        [2]     Float       (optional) Base probability to trigger on event (in %)
                            Default value: 100.0%

        [3]     Float       (optional) Probability to trigger that is proportional to the accumulated value (delta)
                            Default value: 0.0%

        [4]     Int         (optional) Repeat
                            Default value: 0 (False)

        [5]     Int         (script) Accumulated value (delta)

    Example:
        Destruction,,,,1    It triggers on every increase of the magic skill of Destruction
        OneHanded,3,50      It triggers once with a 50% chance on OneHanded skill increase starting from the third increase

/;
Scriptname UD_ModTrigger_SkillIncrease extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function SkillIncreased(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asSkill, Int aiValue, String aiDataStr, Form akForm1)
    String loc_skill = GetStringParamString(aiDataStr, 0, "")
    If asSkill != loc_skill
        Return False
    EndIf
    Int loc_min_delta = MultInt(GetStringParamInt(aiDataStr, 1, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 2, 100.0), akModifier.MultProbabilities)
    Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 3, 0.0), akModifier.MultProbabilities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = 1, afMinAccum = loc_min_delta, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 5)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Int loc_min_delta = MultInt(GetStringParamInt(aiDataStr, 1, 0), akModifier.MultInputQuantities)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 2, 100.0), akModifier.MultProbabilities)
    Float loc_prob_accum = MultFloat(GetStringParamFloat(aiDataStr, 3, 0.0), akModifier.MultProbabilities)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Skill name:", GetStringParamString(aiDataStr, 0, ""))
    loc_res += UDmain.UDMTF.TableRowDetails("Min delta:", loc_min_delta)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator weight:", FormatFloat(loc_prob_accum, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(GetStringParamInt(aiDataStr, 4, 0) > 0, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:", FormatFloat(GetStringParamFloat(aiDataStr, 5, 0.0), 0))
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains the delta)", asAlign = "center")
    Return loc_res
EndFunction