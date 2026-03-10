Scriptname UD_SkillManager_Script Extends UD_ModuleBase

import UnforgivingDevicesMain
import UD_Native

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

float Function GetSkill(Actor akActor, String asSkillAlias)
    WaitForReady(10.0)
    return _GetSkill(akActor,asSkillAlias)
EndFunction
float Function getSkillsPerc(Actor akActor, String asSkillAlias)
    WaitForReady(10.0)
    return _GetSkillPerc(akActor,asSkillAlias)
EndFunction
Function AdvanceSkill(Float afValue, String asSkillAlias)
    WaitForReady(10.0)
    _AdvenceSkill(asSkillAlias, afValue)
EndFunction

Alias[] Function GetAllSkills()
    WaitForReady(10.0)
    
    Alias[] loc_res
    Quest[] loc_storages = UD_Native.GetModulesByScript("ud_skillstorage")
    Int loc_i  = 0
    while loc_i < loc_storages.length
        UD_SkillStorage loc_storage = loc_storages[loc_i] as UD_SkillStorage
        Alias[] loc_skills = loc_storage.GetAllSkills()
        loc_res = PapyrusUtil.MergeAliasArray(loc_res,loc_skills)
        loc_i += 1
    endwhile
    return loc_res
EndFunction

UD_Skill Function _GetSkillByAlias(String asAlias)
    Quest[] loc_storages = UD_Native.GetModulesByScript("ud_skillstorage")
    Int loc_i = 0
    while loc_i < loc_storages.length
        UD_SkillStorage loc_storage = loc_storages[loc_i] as UD_SkillStorage
        if loc_storage
            UD_Skill tmp_res = loc_storage.GetSkillByAlias(asAlias)
            if tmp_res
                return tmp_res
            endif
        endif
        loc_i += 1
    endwhile
    return none
EndFunction

Int Function _GetSkill(Actor akActor, String asSkillAlias)
    if akActor
        UD_Skill loc_skill = _GetSkillByAlias(asSkillAlias)
        if loc_skill
            return loc_skill.GetSkill(akActor)
        endif
    endif
    return 0
EndFunction
Float Function _GetSkillPerc(Actor akActor, String asSkillAlias)
    if akActor
        UD_Skill loc_skill = _GetSkillByAlias(asSkillAlias)
        if loc_skill
            return loc_skill.GetSkillPerc(akActor)
        endif
    endif
    return 0
EndFunction


Function _AdvenceSkill(String asSkillAlias, Float afValue)
    UD_Skill loc_skill = _GetSkillByAlias(asSkillAlias)
    if loc_skill
        return loc_skill.AdvenceSkill(afValue)
    endif
EndFunction

Function OnSaveJSON(String strFile)
    Alias[] loc_skills = GetAllSkills()
    if loc_skills
        Int loc_i = 0
        while loc_i < loc_skills.length
            UD_Skill loc_skill = loc_skills[loc_i] as UD_Skill
            if loc_skill
                loc_skill.SaveJSON(strFile)
            endif
            loc_i += 1
        endwhile
    endif
EndFunction
Function OnLoadJSON(String strFile)
    Alias[] loc_skills = GetAllSkills()
    if loc_skills
        Int loc_i = 0
        while loc_i < loc_skills.length
            UD_Skill loc_skill = loc_skills[loc_i] as UD_Skill
            if loc_skill
                loc_skill.LoadJSON(strFile)
            endif
            loc_i += 1
        endwhile
    endif
EndFunction