Scriptname UD_SkillManager_Script Extends Quest

import UnforgivingDevicesMain
import UD_Native

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
    return GetSkill(akActor,"_Agility")
EndFunction

float Function getActorAgilitySkillsPerc(Actor akActor)
    return GetAgilitySkill(akActor)/100.0
EndFunction

Function AdvanceAgilitySkill(Float afValue)
    AdvenceSkill("_Agility", afValue)
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
    return GetSkill(akActor,"_Strength")
EndFunction

float Function getActorStrengthSkillsPerc(Actor akActor)
    return GetStrengthSkill(akActor)/100.0
EndFunction

Function AdvanceStrengthSkill(Float afValue)
    AdvenceSkill("_Strength", afValue)
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
    return GetSkill(akActor,"_Magick")
EndFunction

float Function getActorMagickSkillsPerc(Actor akActor)
    return GetMagickSkill(akActor)/100.0
EndFunction

Function AdvanceMagickSkill(Float afValue)
    AdvenceSkill("_Magick", afValue)
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
    return GetSkill(akActor,"_Cutting")
EndFunction

float Function getActorCuttingSkillsPerc(Actor akActor)
    return GetCuttingSkill(akActor)/100.0
EndFunction

Function AdvanceCuttingSkill(Float afValue)
    AdvenceSkill("_Cutting", afValue)
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
    return GetSkill(akActor,"_Maintenance")
EndFunction

float Function getActorSmithingSkillsPerc(Actor akActor)
    return GetSmithingSkill(akActor)/100.0
EndFunction

Function AdvanceSmithingSkill(Float afValue)
    AdvenceSkill("_Maintenance", afValue)
EndFunction

Int Function GetSkill(Actor akActor, String asSkill)
    String[] loc_skills = UD_Native.GetIniArrayString("Skill.asSkills"+asSkill)
    if loc_skills && loc_skills.length > 0
      Int loc_res = 0
      Int loc_spp = UD_Native.GetIniVariableInt("Skill.aiPerkSkillPoints",10)
      Int loc_i = 0
      while loc_i < loc_skills.length
        loc_res += Round(akActor.GetActorValue(loc_skills[loc_i]))
        loc_res += UD_Native.CalculateSkillFromPerks(akActor,loc_skills[loc_i],loc_spp)
        loc_i += 1
      endwhile
      Bool loc_average = UD_Native.GetIniVariableBool("Skill.asSkillsPower_Average",false)
      if loc_average
        return loc_res/loc_skills.length
      else
        return loc_res
      endif
    else
      return 0
    endif
EndFunction

Function AdvenceSkill(String asSkill, Float afValue)
  float loc_value = afValue*GetSkillMultiplier()
  if loc_value > 0.0
    String[] loc_skills = UD_Native.GetIniArrayString("Skill.asSkills"+asSkill)
    if loc_skills && loc_skills.length > 0
      Bool loc_average  = UD_Native.GetIniVariableBool("Skill.asSkillsGain_Average",false)
      Int loc_i = 0
      while loc_i < loc_skills.length
        float loc_value2 = 0.0
        if loc_average
          loc_value2 = loc_value/loc_skills.length
        else
          loc_value2 = loc_value
        endif
        UD_Native.AdvanceSkillPerc(loc_skills[loc_i],loc_value2)
        loc_i += 1
      endwhile
    endif
  endif
EndFunction

Float Function GetSkillMultiplier()
  return UDCDmain.UD_BaseDeviceSkillIncrease
EndFunction