;/  File: UD_ModTrigger_PsWarrior
    It triggers from warrior play style
    
    NameFull: Warrior Playstyle
    
    Parameters in DataStr:
        [0]     Float       (optional) Probability to trigger on weapon use
                            Default value: 0.0%

        [1]     Float       (optional) Probability to trigger on warrior skill increase (TwoHanded, Block, Smithing, HeavyArmor)
                            Default value: 0.0%

        [2]     Float       (optional) Probability to trigger on melee hit taken
                            Default value: 0.0%

    Example:

/;
Scriptname UD_ModTrigger_PsWarrior extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Int aiEquipSlot, Form akSource, String aiDataStr, Form akForm1)
    If aiActorAction == 0
    ; weapon swing
    ; TODO PR195: check weapon type to exclude daggers and staffs
        Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 0, 0.0), akModifier.MultProbabilities)
        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
    Return False
EndFunction

Bool Function WeaponHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1)
    If akWeapon && akWeapon.GetWeaponType() <= 6
    ; melee or unarmed
        Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
    Return False
EndFunction

Bool Function SkillIncreased(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asSkill, Int aiValue, String aiDataStr, Form akForm1)
    If asSkill == "TwoHanded" || asSkill == "Block" || asSkill == "Smithing" || asSkill == "HeavyArmor"
        Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 1, 0.0), akModifier.MultProbabilities)
        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Float loc_prob1 = MultFloat(GetStringParamFloat(aiDataStr, 0, 0.0), akModifier.MultProbabilities)
    Float loc_prob2 = MultFloat(GetStringParamFloat(aiDataStr, 1, 0.0), akModifier.MultProbabilities)
    Float loc_prob3 = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on weapon swing:", FormatFloat(loc_prob1, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on skill increase:", FormatFloat(loc_prob2, 1) + "%")
    loc_res += UDmain.UDMTF.Paragraph("(TwoHanded, Block, Smithing, HeavyArmor)", asAlign = "center")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on melee hit taken:", FormatFloat(loc_prob3, 1) + "%")
    Return loc_res
EndFunction