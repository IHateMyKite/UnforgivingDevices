Scriptname UD_MCM_Page_Skill extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_UserInputScript Property UDUI
    UD_UserInputScript Function Get()
        return UDmain.UDUI
    EndFunction
EndProperty
UD_Config         Property UDCONF hidden
    UD_Config Function Get()
        return UDmain.UDCONF
    EndFunction
EndProperty
UD_SwimmingScript Property UDSS hidden
    UD_SwimmingScript Function Get()
        return MCM.UDSS
    EndFunction
EndProperty

String[] UD_MinigameLockpickSkillAdjust_ML
Function PageUpdate()
    UD_MinigameLockpickSkillAdjust_ML = new String[5]
    UD_MinigameLockpickSkillAdjust_ML[0] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT100"
    UD_MinigameLockpickSkillAdjust_ML[1] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT90"
    UD_MinigameLockpickSkillAdjust_ML[2] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT75"
    UD_MinigameLockpickSkillAdjust_ML[3] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT50"
    UD_MinigameLockpickSkillAdjust_ML[4] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT00"
EndFunction

Int UD_SkillEfficiency_S
Int UD_MinigameLockpickSkillAdjust_M
int UD_BaseDeviceSkillIncrease_S
int UD_ExperienceGain_S
int UD_ExperienceExp_S
Function PageReset(Bool abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)

    ;SKILL
    AddHeaderOption("$UD_H_SKILLSETTING")
    addEmptyOption()
    
    UD_BaseDeviceSkillIncrease_S = addSliderOption("$UD_BASEDEVICESKILLINCREASE",UDCDmain.UD_BaseDeviceSkillIncrease, "{1} x",FlagSwitch(!abLockMenu))
    UD_SkillEfficiency_S = addSliderOption("$UD_SKILLEFFICIENCY",UDCDmain.UD_SkillEfficiency, "{0} %",FlagSwitch(!abLockMenu))
    
    UD_MinigameLockpickSkillAdjust_M    = AddMenuOption("$UD_MINIGAMELOCKPICKSKILLADJUST", UD_MinigameLockpickSkillAdjust_ML[UDCDmain.UD_MinigameLockpickSkillAdjust],FlagSwitch(!abLockMenu))
    addEmptyOption()
    
    ;SKILL
    AddHeaderOption("Experience")
    addEmptyOption()
    
    UD_ExperienceGain_S = addSliderOption("Experience base gain",UDCDmain.UD_ExperienceGainBase, "{0}",FlagSwitchAnd(FlagSwitch(UDmain.ExperienceInstalled),FlagSwitch(!abLockMenu)))
    UD_ExperienceExp_S  = addSliderOption("Experience exponent",UDCDmain.UD_ExperienceGainExp, "{1}",FlagSwitchAnd(FlagSwitch(UDmain.ExperienceInstalled),FlagSwitch(!abLockMenu)))
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    if (aiOption == UD_BaseDeviceSkillIncrease_S)
        SetSliderDialogStartValue(UDCDmain.UD_BaseDeviceSkillIncrease)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(0.1)
    elseif aiOption == UD_SkillEfficiency_S
        SetSliderDialogStartValue(UDCDmain.UD_SkillEfficiency)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 10.0)
        SetSliderDialogInterval(1.0)
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
    endif
EndFunction

Function PageOptionSliderAccept(Int aiOption, Float afValue)
    if (aiOption == UD_BaseDeviceSkillIncrease_S)
        UDCDmain.UD_BaseDeviceSkillIncrease = afValue
        SetSliderOptionValue(UD_BaseDeviceSkillIncrease_S, UDCDmain.UD_BaseDeviceSkillIncrease, "{1} x")
    elseif aiOption == UD_SkillEfficiency_S
        UDCDmain.UD_SkillEfficiency = round(afValue)
        SetSliderOptionValue(UD_SkillEfficiency_S, UDCDmain.UD_SkillEfficiency, "{0} %")
    elseif aiOption == UD_ExperienceGain_S
        UDCDmain.UD_ExperienceGainBase = round(afValue)
        SetSliderOptionValue(UD_ExperienceGain_S, UDCDmain.UD_ExperienceGainBase, "{0}")
    elseif aiOption == UD_ExperienceExp_S
        UDCDmain.UD_ExperienceGainExp = afValue
        SetSliderOptionValue(UD_ExperienceExp_S, UDCDmain.UD_ExperienceGainExp, "{1}")
    endif
EndFunction

Function PageOptionMenuOpen(int aiOption)
    if (aiOption == UD_MinigameLockpickSkillAdjust_M)
        SetMenuDialogOptions(UD_MinigameLockpickSkillAdjust_ML)
        SetMenuDialogStartIndex(UDCDmain.UD_MinigameLockpickSkillAdjust)
        SetMenuDialogDefaultIndex(2)
    endif
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
    if (aiOption == UD_MinigameLockpickSkillAdjust_M)
        UDCDmain.UD_MinigameLockpickSkillAdjust = aiIndex
        SetMenuOptionValue(UD_MinigameLockpickSkillAdjust_M, UD_MinigameLockpickSkillAdjust_ML[UDCDmain.UD_MinigameLockpickSkillAdjust])
        forcePageReset()
    endIf
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
    elseif aiOption == UD_SkillEfficiency_S
        SetInfoText("$UD_SKILLEFFICIENCY_INFO")
    elseif (aiOption == UD_MinigameLockpickSkillAdjust_M)
        SetInfoText("$UD_MINIGAMELOCKPICKSKILLADJUST_INFO")
    endif
EndFunction