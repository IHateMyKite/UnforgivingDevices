Scriptname UD_Skill Extends ReferenceAlias

import UnforgivingDevicesMain
import UD_Native

UD_SkillManager_Script _udsm
UD_SkillManager_Script Property UDSM hidden
    UD_SkillManager_Script Function get()
        if !_udsm
            _udsm = (GetModuleByAlias("SKILLM") as UD_SkillManager_Script)
        endif
        return _udsm
    EndFunction
EndProperty

UDCustomDeviceMain Property UDCDmain hidden
    UDCustomDeviceMain Function get()
        return UDSM.UDCDmain
    EndFunction
EndProperty

String   Property SkillAlias = "NOAL" Auto
String   Property SkillName  = "" Auto

String[] Property Skills Auto

Bool     Property SkillAvarage  = False Auto
Int      Property SkillPerPerk  = 10 Auto ; how much will every perk increase skill
Float    Property SkillMult     = 1.0 Auto
Float    Property SkillGainMult = 1.0 Auto
Int      Property SkillToPerc   = 100 Auto

Int Function GetSkill(Actor akActor)
    if Skills && Skills.length > 0
        Int loc_res = 0
        Int loc_spp = SkillPerPerk
        Int loc_i = 0
        while loc_i < Skills.length
            loc_res += Round(akActor.GetActorValue(Skills[loc_i]))
            loc_res += UD_Native.CalculateSkillFromPerks(akActor,Skills[loc_i],loc_spp)
            loc_i += 1
        endwhile
        Bool loc_average = SkillAvarage
        if loc_average
            loc_res = loc_res/Skills.length
        endif
        return Round(loc_res*SkillMult)
    else
      return 0
    endif
EndFunction

Float Function GetSkillPerc(Actor akActor)
    Float loc_skill = GetSkill(akActor) as Float
    return loc_skill/SkillToPerc
EndFunction

Function AdvenceSkill(Float afValue)
    float loc_value = afValue*(UDCDmain.UD_BaseDeviceSkillIncrease)*SkillGainMult
    if loc_value > 0.0
        if Skills && Skills.length > 0
            Bool loc_average  = SkillAvarage
            Int loc_i = 0
            while loc_i < Skills.length
                float loc_value2 = 0.0
                if loc_average
                    loc_value2 = loc_value/Skills.length
                else
                    loc_value2 = loc_value
                endif
                UD_Native.AdvanceSkillPerc(Skills[loc_i],loc_value2)
                loc_i += 1
            endwhile
        endif
    endif
EndFunction


Function SaveJSON(String asFile)
    String loc_path = "Skill_" + SkillAlias + "_"
    JsonUtil.SetIntValue(asFile,    loc_path + "SkillAvarage", SkillAvarage as Int)
    JsonUtil.SetIntValue(asFile,    loc_path + "SkillPerPerk", SkillPerPerk)
    JsonUtil.SetFloatValue(asFile,  loc_path + "SkillMult", SkillMult)
    JsonUtil.SetFloatValue(asFile,  loc_path + "SkillGainMult", SkillGainMult)
    JsonUtil.SetStringValue(asFile, loc_path + "Skills", PapyrusUtil.StringJoin(Skills, ","))
EndFunction
Function LoadJSON(String asFile)
    String loc_path = "Skill_" + SkillAlias + "_"
    SkillAvarage    = JsonUtil.GetIntValue(asFile,      loc_path + "SkillAvarage", SkillAvarage as Int)
    SkillPerPerk    = JsonUtil.GetIntValue(asFile,      loc_path + "SkillPerPerk", SkillPerPerk)
    SkillMult       = JsonUtil.GetFloatValue(asFile,    loc_path + "SkillMult", SkillMult)
    SkillGainMult   = JsonUtil.GetFloatValue(asFile,    loc_path + "SkillGainMult", SkillGainMult)
    
    String loc_skillstr = JsonUtil.GetStringValue(asFile, loc_path + "Skills", PapyrusUtil.StringJoin(Skills, ","))
    String[] loc_skills = PapyrusUtil.StringSplit(loc_skillstr, ",")
    Skills = loc_skills
EndFunction
