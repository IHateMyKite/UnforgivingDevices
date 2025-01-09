;/  File: UD_ModTrigger_PsWarrior
    It triggers from warrior play style
    
    NameFull: Warrior Playstyle
    
    Parameters:
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
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 0, 0.0))
    EndIf
    Return False
EndFunction

Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1)
    If asStatName == "Skill Increases" && (aiStatValue == 7 || aiStatValue == 9 || aiStatValue == 10 || aiStatValue == 11)
        ; TwoHanded, Block, Smithing, HeavyArmor
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 0.0))
    EndIf
    Return False
EndFunction

Bool Function WeaponHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1)
    If akWeapon && akWeapon.GetWeaponType() <= 6
    ; melee or unarmed
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 2, 0.0))
    EndIf
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on weapon swing:", FormatFloat(GetStringParamFloat(aiDataStr, 0, 0.0), 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on skill increase:", FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 1) + "%")
    loc_res += UDmain.UDMTF.Paragraph("(TwoHanded, Block, Smithing, HeavyArmor)", asAlign = "center")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on melee hit taken:", FormatFloat(GetStringParamFloat(aiDataStr, 2, 100.0), 1) + "%")
    Return loc_res
EndFunction