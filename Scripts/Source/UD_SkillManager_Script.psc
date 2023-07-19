Scriptname UD_SkillManager_Script Extends Quest

import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto
UDCustomDeviceMain Property UDCDmain hidden
    UDCustomDeviceMain Function get()
        return UDmain.UDCDmain
    EndFunction
EndProperty


;///////////////////////////////////////
;=======================================
;            SKILL FUNCTIONS
;=======================================
;//////////////////////////////////////;
;-Used to return absolute and relative skill values which are used by some minigames

float Function GetAgilitySkill(Actor akActor)
    UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(akActor)
    if loc_slot
        return loc_slot.AgilitySkill
    else
        return getActorAgilitySkills(akActor)
    endif
EndFunction

float Function getActorAgilitySkills(Actor akActor)
    float loc_result = 0.0
    loc_result += akActor.GetActorValue("Pickpocket")
    loc_result += GetPerkSkill(akActor,UDCDMain.UD_AgilityPerks,10)
    return loc_result
EndFunction

float Function getActorAgilitySkillsPerc(Actor akActor)
    return GetAgilitySkill(akActor)/100.0
EndFunction

float Function GetStrengthSkill(Actor akActor)
    UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(akActor)
    if loc_slot
        return loc_slot.StrengthSkill
    else
        return getActorStrengthSkills(akActor)
    endif
EndFunction

float Function getActorStrengthSkills(Actor akActor)
    float loc_result = 0.0
    loc_result += akActor.GetActorValue("TwoHanded")
    loc_result += GetPerkSkill(akActor,UDCDMain.UD_StrengthPerks,10)
    return loc_result
EndFunction

float Function getActorStrengthSkillsPerc(Actor akActor)
    return GetStrengthSkill(akActor)/100.0
EndFunction

float Function GetMagickSkill(Actor akActor)
    UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(akActor)
    if loc_slot
        return loc_slot.MagickSkill
    else
        return getActorMagickSkills(akActor)
    endif
EndFunction

float Function getActorMagickSkills(Actor akActor)
    float loc_result = 0.0
    loc_result += akActor.GetActorValue("Destruction")
    loc_result += GetPerkSkill(akActor,UDCDMain.UD_MagickPerks,10)
    return loc_result
EndFunction

float Function getActorMagickSkillsPerc(Actor akActor)
    return GetMagickSkill(akActor)/100.0
EndFunction

float Function GetCuttingSkill(Actor akActor)
    UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(akActor)
    if loc_slot
        return loc_slot.CuttingSkill
    else
        return getActorCuttingSkills(akActor)
    endif
EndFunction

float Function getActorCuttingSkills(Actor akActor)
    float loc_result = 0.0
    loc_result += akActor.GetActorValue("OneHanded")
    return loc_result
EndFunction

float Function getActorCuttingSkillsPerc(Actor akActor)
    return GetCuttingSkill(akActor)/100.0
EndFunction

float Function GetSmithingSkill(Actor akActor)
    UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(akActor)
    if loc_slot
        return loc_slot.SmithingSkill
    else
        return getActorSmithingSkills(akActor)
    endif
EndFunction

float Function getActorSmithingSkills(Actor akActor)
    float loc_result = 0.0
    loc_result += akActor.GetActorValue("Smithing")
    
    return loc_result
EndFunction

float Function getActorSmithingSkillsPerc(Actor akActor)
    return GetSmithingSkill(akActor)/100.0
EndFunction

int Function GetPerkSkill(Actor akActor, Formlist akPerkList, int aiSkillPerPerk = 10)
    if !akActor
        UDmain.Error("GetPerkSkill - actor is none")
        return 0
    endif
    if !akPerkList
        UDmain.Error("GetPerkSkill("+getActorName(akActor)+") - akPerkList is none")
        return 0
    endif
    if UDmain.UD_UseNativeFunctions
        Int loc_res = UD_Native.CalculateSkillFromPerks(akActor,akPerkList,aiSkillPerPerk)
        return loc_res
    else
        int loc_size = akPerkList.getSize()
        int loc_res = 0
        while loc_size
            loc_size -= 1
            Perk loc_perk = akPerkList.GetAt(loc_size) as Perk
            if akActor.hasperk(loc_perk)
                loc_res += aiSkillPerPerk
            endif
        endwhile
        return loc_res
    endif
EndFunction
