Scriptname UD_SkillStorage Extends UD_ModuleBase

import UnforgivingDevicesMain
import UD_Native

UD_Skill Function GetSkillByAlias(String asAlias)
    WaitForReady(10.0)
    Int loc_num = GetNumAliases()
    Int loc_i = 0
    UD_Skill loc_res = none
    while loc_i < loc_num
        UD_Skill loc_skill = GetNthAlias(loc_i) as UD_Skill
        if loc_skill && loc_skill.SkillAlias == asAlias
            loc_res = loc_skill
        endif
        loc_i += 1
    endwhile
    return loc_res
EndFunction

Alias[] Function GetAllSkills()
    WaitForReady(10.0)
    
    Alias[] loc_res
    Int loc_num = GetNumAliases()
    Int loc_i = 0
    while loc_i < loc_num
        UD_Skill loc_skill = GetNthAlias(loc_i) as UD_Skill
        if loc_skill
            loc_res = PapyrusUtil.PushAlias(loc_res,loc_skill)
        endif
        loc_i += 1
    endwhile
    return loc_res
EndFunction