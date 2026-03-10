Scriptname UD_MCM_Page_Skill extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_SkillManager_Script Property UDSM
    UD_SkillManager_Script Function Get()
        return UDmain.UDSKILL
    EndFunction
EndProperty

String[] UD_ValidSkills
String[] UD_MinigameLockpickSkillAdjust_ML
Function PageUpdate()
    UD_MinigameLockpickSkillAdjust_ML = new String[5]
    UD_MinigameLockpickSkillAdjust_ML[0] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT100"
    UD_MinigameLockpickSkillAdjust_ML[1] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT90"
    UD_MinigameLockpickSkillAdjust_ML[2] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT75"
    UD_MinigameLockpickSkillAdjust_ML[3] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT50"
    UD_MinigameLockpickSkillAdjust_ML[4] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT00"
    
    UD_ValidSkills = new String[18]
    UD_ValidSkills[ 0] = "onehanded"
    UD_ValidSkills[ 1] = "twohanded"
    UD_ValidSkills[ 2] = "marksman"
    UD_ValidSkills[ 3] = "block"
    UD_ValidSkills[ 4] = "smithing"
    UD_ValidSkills[ 5] = "heavyarmor"
    UD_ValidSkills[ 6] = "lightarmor"
    UD_ValidSkills[ 7] = "pickpocket"
    UD_ValidSkills[ 8] = "lockpicking"
    UD_ValidSkills[ 9] = "sneak"
    UD_ValidSkills[10] = "alchemy"
    UD_ValidSkills[11] = "speechcraft"
    UD_ValidSkills[12] = "alteration"
    UD_ValidSkills[13] = "conjuration"
    UD_ValidSkills[14] = "destruction"
    UD_ValidSkills[15] = "illusion"
    UD_ValidSkills[16] = "restoration"
    UD_ValidSkills[17] = "enchanting"
EndFunction

Int UD_MinigameLockpickSkillAdjust_M
int UD_BaseDeviceSkillIncrease_S
int UD_ExperienceGain_S
int UD_ExperienceExp_S

Int         UD_SkillList_M
String[]    UD_SkillList_List
Int         UD_SkillList_Id = 0
Int[]       UD_SkillSkillsList_T
Int         UD_SkillAdd_T

Int         UD_SkillAvarage_T
Int         UD_SkillPerPerk_S
Int         UD_SkillMult_S
Int         UD_SkillGainMult_S

Int         UD_SkillList_T

Function PageReset(Bool abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)

    UD_SkillList_T = AddTextOption("Skill list","--INFO--")
    addEmptyOption()
    
    ;SKILL
    AddHeaderOption("$UD_H_SKILLSETTING")
    addEmptyOption()
    
    UD_BaseDeviceSkillIncrease_S = addSliderOption("$UD_BASEDEVICESKILLINCREASE",UDCDmain.UD_BaseDeviceSkillIncrease, "{1} x",FlagSwitch(!abLockMenu))
    UD_MinigameLockpickSkillAdjust_M    = AddMenuOption("$UD_MINIGAMELOCKPICKSKILLADJUST", UD_MinigameLockpickSkillAdjust_ML[UDCDmain.UD_MinigameLockpickSkillAdjust],FlagSwitch(!abLockMenu))
    
    ; SKILL TABLE
    AddHeaderOption("Skills setting")
    addEmptyOption()
    
    Alias[] loc_skills = UDSM.GetAllSkills()
    UD_SkillList_List = Utility.CreateStringArray(0)
    if loc_skills
        Int loc_i = 0
        while loc_i < loc_skills.length
            UD_Skill tmp_skill = loc_skills[loc_i] as UD_Skill
            if tmp_skill
                UD_SkillList_List = PapyrusUtil.PushString(UD_SkillList_List,tmp_skill.SkillName)
            endif
            loc_i += 1
        endwhile
    endif
    
    UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
    
    UD_SkillList_M = AddMenuOption("===Select Skill===", UD_SkillList_List[UD_SkillList_Id])
    AddTextOption("Calculated value",loc_skill.GetSkill(Game.GetPlayer()),FlagSwitch(false))
    
    Int loc_i = 0
    UD_SkillSkillsList_T = Utility.CreateIntArray(0)
    while loc_i < (loc_skill.Skills.length + 1) || loc_i < 4
        if loc_i < loc_skill.Skills.length
            Int loc_input = AddInputOption(loc_skill.Skills[loc_i],"-EDIT-",FlagSwitch(!abLockMenu))
            UD_SkillSkillsList_T = PapyrusUtil.PushInt(UD_SkillSkillsList_T,loc_input)
        elseif loc_i == loc_skill.Skills.length
            UD_SkillAdd_T = AddInputOption("----------", "-ADD-",FlagSwitch(!abLockMenu))
        else
            addEmptyOption()
        endif
        
        
        if loc_i == 0
            UD_SkillAvarage_T   = AddToggleOption("Avarage skill", loc_skill.SkillAvarage,FlagSwitch(!abLockMenu))
        elseif loc_i == 1
            UD_SkillPerPerk_S   = AddSliderOption("Skill Per Perk", loc_skill.SkillPerPerk,"{0}",FlagSwitch(!abLockMenu))
        elseif loc_i == 2
            UD_SkillMult_S      = AddSliderOption("Skill Mult", loc_skill.SkillMult,"{1}",FlagSwitch(!abLockMenu))
        elseif loc_i == 3
            UD_SkillGainMult_S  = AddSliderOption("Skill Gain Mult", loc_skill.SkillGainMult,"{1}",FlagSwitch(!abLockMenu))
        else
            addEmptyOption()
        endif
        
        loc_i += 1
    endwhile
    
    ;EXPERIENCE
    AddHeaderOption("Experience")
    addEmptyOption()
    
    UD_ExperienceGain_S = addSliderOption("Experience base gain",UDCDmain.UD_ExperienceGainBase, "{0}",FlagSwitchAnd(FlagSwitch(UDmain.ExperienceInstalled),FlagSwitch(!abLockMenu)))
    UD_ExperienceExp_S  = addSliderOption("Experience exponent",UDCDmain.UD_ExperienceGainExp, "{1}",FlagSwitchAnd(FlagSwitch(UDmain.ExperienceInstalled),FlagSwitch(!abLockMenu)))
EndFunction

Function PageOptionSelect(Int aiOption)
    if (aiOption == UD_SkillAvarage_T)
        Alias[] loc_skills = UDSM.GetAllSkills()
        UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
        loc_skill.SkillAvarage = !loc_skill.SkillAvarage
        forcePageReset()
    elseif (aiOption == UD_SkillList_T)
        String loc_msg = PapyrusUtil.StringJoin(UD_ValidSkills,"\n")
        ShowMessage(loc_msg)
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    if (aiOption == UD_BaseDeviceSkillIncrease_S)
        SetSliderDialogStartValue(UDCDmain.UD_BaseDeviceSkillIncrease)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(0.1)
    elseif aiOption == UD_ExperienceGain_S
        SetSliderDialogStartValue(UDCDmain.UD_ExperienceGainBase)
        SetSliderDialogDefaultValue(15.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_ExperienceExp_S
        SetSliderDialogStartValue(UDCDmain.UD_ExperienceGainExp)
        SetSliderDialogDefaultValue(0.8)
        SetSliderDialogRange(0.0, 5.0)
        SetSliderDialogInterval(0.1)
    elseif aiOption == UD_SkillPerPerk_S
        Alias[] loc_skills = UDSM.GetAllSkills()
        UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
        SetSliderDialogStartValue(loc_skill.SkillPerPerk)
        SetSliderDialogDefaultValue(10)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_SkillMult_S
        Alias[] loc_skills = UDSM.GetAllSkills()
        UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
        SetSliderDialogStartValue(loc_skill.SkillMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 10.0)
        SetSliderDialogInterval(0.1)
    elseif aiOption == UD_SkillGainMult_S
        Alias[] loc_skills = UDSM.GetAllSkills()
        UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
        SetSliderDialogStartValue(loc_skill.SkillGainMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 10.0)
        SetSliderDialogInterval(0.1)
    endif
EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)
    if (aiOption == UD_BaseDeviceSkillIncrease_S)
        UDCDmain.UD_BaseDeviceSkillIncrease = afValue
        SetSliderOptionValue(UD_BaseDeviceSkillIncrease_S, UDCDmain.UD_BaseDeviceSkillIncrease, "{1} x")
    elseif aiOption == UD_ExperienceGain_S
        UDCDmain.UD_ExperienceGainBase = round(afValue)
        SetSliderOptionValue(UD_ExperienceGain_S, UDCDmain.UD_ExperienceGainBase, "{0}")
    elseif aiOption == UD_ExperienceExp_S
        UDCDmain.UD_ExperienceGainExp = afValue
        SetSliderOptionValue(UD_ExperienceExp_S, UDCDmain.UD_ExperienceGainExp, "{1}")
    elseif aiOption == UD_SkillPerPerk_S
        Alias[] loc_skills = UDSM.GetAllSkills()
        UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
        loc_skill.SkillPerPerk = Round(afValue)
        SetSliderOptionValue(UD_SkillPerPerk_S, loc_skill.SkillPerPerk, "{0}")
        forcePageReset()
    elseif aiOption == UD_SkillMult_S
        Alias[] loc_skills = UDSM.GetAllSkills()
        UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
        loc_skill.SkillMult = afValue
        SetSliderOptionValue(UD_SkillMult_S, loc_skill.SkillMult, "{1}")
        forcePageReset()
    elseif aiOption == UD_SkillGainMult_S
        Alias[] loc_skills = UDSM.GetAllSkills()
        UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
        loc_skill.SkillGainMult = afValue
        SetSliderOptionValue(UD_SkillGainMult_S, loc_skill.SkillGainMult, "{1}")
    endif
EndFunction

Function PageOptionMenuOpen(int aiOption)
    if (aiOption == UD_MinigameLockpickSkillAdjust_M)
        SetMenuDialogOptions(UD_MinigameLockpickSkillAdjust_ML)
        SetMenuDialogStartIndex(UDCDmain.UD_MinigameLockpickSkillAdjust)
        SetMenuDialogDefaultIndex(2)
    elseif (aiOption == UD_SkillList_M)
        SetMenuDialogOptions(UD_SkillList_List)
        SetMenuDialogStartIndex(UD_SkillList_Id)
        SetMenuDialogDefaultIndex(0)
    endif
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
    if (aiOption == UD_MinigameLockpickSkillAdjust_M)
        UDCDmain.UD_MinigameLockpickSkillAdjust = aiIndex
        SetMenuOptionValue(UD_MinigameLockpickSkillAdjust_M, UD_MinigameLockpickSkillAdjust_ML[UDCDmain.UD_MinigameLockpickSkillAdjust])
        forcePageReset()
    elseif (aiOption == UD_SkillList_M)
        UD_SkillList_Id = aiIndex
        forcePageReset()
    endIf
EndFunction

Function PageOptionInputOpen(int aiOption)
    if aiOption == UD_SkillAdd_T
        SetInputDialogStartText("")
    else
        Int loc_i = 0
        while loc_i < UD_SkillSkillsList_T.length
            if aiOption == UD_SkillSkillsList_T[loc_i]
                Alias[] loc_skills = UDSM.GetAllSkills()
                UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
                SetInputDialogStartText(loc_skill.Skills[loc_i])
            endif
            loc_i += 1
        endwhile
    endif
EndFunction
Function PageOptionInputAccept(Int option, String value)
    if option == UD_SkillAdd_T
        if value
            Alias[] loc_skills = UDSM.GetAllSkills()
            UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
            loc_skill.Skills = PapyrusUtil.PushString(loc_skill.Skills,value)
            forcePageReset()
        endif
    else
        Int loc_i = 0
        while loc_i < UD_SkillSkillsList_T.length
            if option == UD_SkillSkillsList_T[loc_i]
                Alias[] loc_skills = UDSM.GetAllSkills()
                UD_Skill loc_skill = loc_skills[UD_SkillList_Id] as UD_Skill
                if value
                    if UD_ValidSkills && UD_ValidSkills.find(value) != -1
                        loc_skill.Skills[loc_i] = value
                    else
                        UDMain.Error("Skill [" + value + "] does not exist. Please fill in valid skill")
                    endif
                else
                    if loc_i != loc_skill.Skills.length - 1 && loc_i != 0
                      String[] loc_part1 = PapyrusUtil.SliceStringArray(loc_skill.Skills,0,loc_i - 1)
                      String[] loc_part2 = PapyrusUtil.SliceStringArray(loc_skill.Skills,loc_i + 1,-1)
                      loc_skill.Skills = PapyrusUtil.MergeStringArray(loc_part1,loc_part2,true)
                    elseif loc_i != 0
                      loc_skill.Skills = PapyrusUtil.SliceStringArray(loc_skill.Skills,0,loc_i - 1)
                    elseif loc_skill.Skills.length > 1
                      loc_skill.Skills = PapyrusUtil.SliceStringArray(loc_skill.Skills,1,-1)
                    else
                      loc_skill.Skills = Utility.CreateStringArray(0)
                    endif
                endif
                forcePageReset()
            endif
            loc_i += 1
        endwhile
    endif
EndFunction

Function PageDefault(int aiOption)
    if (aiOption == UD_MinigameLockpickSkillAdjust_M)
        UDCDmain.UD_MinigameLockpickSkillAdjust = 2
        SetMenuOptionValue(UD_MinigameLockpickSkillAdjust_M, UD_MinigameLockpickSkillAdjust_ML[UDCDmain.UD_MinigameLockpickSkillAdjust])
        forcePageReset()
    endif
EndFunction

Function PageInfo(int aiOption)
    if aiOption == UD_BaseDeviceSkillIncrease_S
        SetInfoText("$UD_BASEDEVICESKILLINCREASE_INFO")
    elseif (aiOption == UD_MinigameLockpickSkillAdjust_M)
        SetInfoText("$UD_MINIGAMELOCKPICKSKILLADJUST_INFO")
    elseif aiOption == UD_SkillAvarage_T
        SetInfoText("If final skill point value should be avaraged by the number of skills")
    elseif aiOption == UD_SkillPerPerk_S
        SetInfoText("How much will skill points increase by every perk unlocked for relevant skills")
    elseif aiOption == UD_SkillMult_S
        SetInfoText("Multiplier of calculated skill points. Can be used to make skill stronger/weaker")
    elseif aiOption == UD_SkillGainMult_S
        SetInfoText("Multiplier of skill gain. Can be used to make change how fast is skill increased")
    endif
EndFunction