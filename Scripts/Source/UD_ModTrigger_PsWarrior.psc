;/  File: UD_ModTrigger_PsWarrior
    It triggers from warrior play style
    
    NameFull: On Combat Event
    
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

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr)
    If aiActorAction == 0
    ; weapon swing
    ; TODO: check weapon type to exclude daggers and staffs
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 0, 0.0))
    EndIf
    Return False
EndFunction

Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr)
    If asStatName == "Skill Increases" && (aiStatValue == 7 || aiStatValue == 9 || aiStatValue == 10 || aiStatValue == 11)
        ; TwoHanded, Block, Smithing, HeavyArmor
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 0.0))
    EndIf
    Return False
EndFunction

Bool Function WeaponHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr)
    If akWeapon && akWeapon.GetWeaponType() <= 6
    ; melee or unarmed
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 2, 0.0))
    EndIf
    Return False
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    String loc_str = ""
    loc_str += "Warrior playstyle"
    loc_str += "\n"
    loc_str += "Prob. on weapon swing: " + FormatFloat(GetStringParamFloat(aiDataStr, 0, 0.0), 2) + "%"
    loc_str += "\n"
    loc_str += "Prob. on skill increase: " + FormatFloat(GetStringParamFloat(aiDataStr, 1, 0.0), 2) + "%"
    loc_str += "\n"
    loc_str += "(TwoHanded, Block, Smithing, HeavyArmor)"
    loc_str += "\n"
    loc_str += "Prob. on melee hit taken: " + FormatFloat(GetStringParamFloat(aiDataStr, 2, 0.0), 2) + "%"
    
    Return loc_str
EndFunction
