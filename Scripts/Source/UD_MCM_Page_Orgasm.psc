Scriptname UD_MCM_Page_Orgasm extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_Config Property UDCONF hidden
    UD_Config Function Get()
        return UDmain.UDCONF
    EndFunction
EndProperty

int UD_OrgasmUpdateTime_S
int UD_UseOrgasmWidget_T
int UD_HornyAnimation_T
int UD_Horny_f
int UD_HornyAnimationDuration_S
int UD_OrgasmResistence_S
int UD_VibrationMultiplier_S
int UD_ArousalMultiplier_S
int UD_OrgasmArousalReduce_S
int UD_OrgasmArousalReduceDuration_S
int UD_OrgasmExhaustionStruggleMax_S
int UD_OrgasmExhaustion_flag
int UD_OrgasmExhaustion_T

function PageInit()
    UD_Horny_f = OPTION_FLAG_NONE
endfunction

Function PageUpdate()

EndFunction

Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_GENERAL")
    addEmptyOption()
        
    UD_OrgasmUpdateTime_S   = addSliderOption("$UD_ORGASMUPDATETIME",UDCONF.UD_OrgasmUpdateTime, "${1} s")

    UD_OrgasmExhaustion_T   = addToggleOption("$UD_ORGASMEXHAUSTION",UDmain.UD_OrgasmExhaustion,UD_LockMenu_flag)
    addEmptyOption()
    UD_OrgasmExhaustionStruggleMax_S = addSliderOption("$UD_ORGASMEXHAUSTIONSTRUGGLEMAX", UDCONF.UD_OrgasmExhaustionStruggleMax, "${0} orgasms",UD_LockMenu_flag)
    
    UD_UseOrgasmWidget_T    = addToggleOption("$UD_USEORGASMWIDGET", UDCONF.UD_UseOrgasmWidget)
    UD_OrgasmResistence_S   = addSliderOption("$UD_ORGASMRESISTENCE",UDCONF.UD_OrgasmResistence, "{1} Op/s",UD_LockMenu_flag)

    UD_HornyAnimation_T     = addToggleOption("$UD_HORNYANIMATION", UDCONF.UD_HornyAnimation)
    UD_HornyAnimationDuration_S     = addSliderOption("$UD_HORNYANIMATIONDURATION",UDCONF.UD_HornyAnimationDuration, "${0} s",UD_Horny_f)
    
    AddHeaderOption("$UD_H_POSTORGASM")
    addEmptyOption()
    UD_OrgasmArousalReduce_S    = addSliderOption("$UD_ORGASMAROUSALREDUCE",UDCONF.UD_OrgasmArousalReduce, "${0} /s")
    UD_OrgasmArousalReduceDuration_S = addSliderOption("$UD_ORGASMAROUSALREDUCEDURATION",UDCONF.UD_OrgasmArousalReduceDuration, "${0} s")
    
    AddHeaderOption("$UD_H_VIBRATIONSETTING")
    addEmptyOption()    
    UD_VibrationMultiplier_S    = addSliderOption("$UD_VIBRATIONMULTIPLIER",UDCDmain.UD_VibrationMultiplier, "{3}",UD_LockMenu_flag)
    UD_ArousalMultiplier_S      = addSliderOption("$UD_AROUSALMULTIPLIER",UDCDmain.UD_ArousalMultiplier, "{3}",UD_LockMenu_flag)
EndFunction

Function PageOptionSelect(Int aiOption)
    if(aiOption == UD_UseOrgasmWidget_T)
        UDCONF.UD_UseOrgasmWidget = !UDCONF.UD_UseOrgasmWidget
        SetToggleOptionValue(UD_UseOrgasmWidget_T, UDCONF.UD_UseOrgasmWidget)
        forcePageReset()
    elseif (aiOption == UD_OrgasmExhaustion_T)
        UDmain.UD_OrgasmExhaustion = !UDmain.UD_OrgasmExhaustion
        if (UDmain.UD_OrgasmExhaustion)
            UD_OrgasmExhaustion_flag = OPTION_FLAG_NONE
        else
            UD_OrgasmExhaustion_flag = OPTION_FLAG_DISABLED
        endif
        SetToggleOptionValue(UD_OrgasmExhaustion_T, UDmain.UD_OrgasmExhaustion)
        forcePageReset()
    elseif(aiOption == UD_HornyAnimation_T)
        UDCONF.UD_HornyAnimation = !UDCONF.UD_HornyAnimation
        SetToggleOptionValue(UD_HornyAnimation_T, UDCONF.UD_HornyAnimation)
        if UDCONF.UD_HornyAnimation
            UD_Horny_f = OPTION_FLAG_NONE
        else
            UD_Horny_f = OPTION_FLAG_DISABLED
        endif
        forcePageReset()
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    if (aiOption == UD_OrgasmUpdateTime_S)
        SetSliderDialogStartValue(UDCONF.UD_OrgasmUpdateTime)
        SetSliderDialogDefaultValue(0.5)
        SetSliderDialogRange(0.1, 2.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_HornyAnimationDuration_S)
        SetSliderDialogStartValue(Round(UDCONF.UD_HornyAnimationDuration))
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(2.0,20.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_OrgasmResistence_S
        SetSliderDialogStartValue(UDCONF.UD_OrgasmResistence)
        SetSliderDialogDefaultValue(0.5)
        SetSliderDialogRange(0.1,10.0)
        SetSliderDialogInterval(0.1)
    elseif aiOption == UD_OrgasmExhaustionStruggleMax_S
        SetSliderDialogStartValue(UDCONF.UD_OrgasmExhaustionStruggleMax)
        SetSliderDialogDefaultValue(6)
        SetSliderDialogRange(0,10)
        SetSliderDialogInterval(1)
    elseif aiOption == UD_VibrationMultiplier_S
        SetSliderDialogStartValue(UDCDmain.UD_VibrationMultiplier)
        SetSliderDialogDefaultValue(0.1)
        SetSliderDialogRange(0.01,0.5)
        SetSliderDialogInterval(0.01)
    elseif aiOption == UD_ArousalMultiplier_S
        SetSliderDialogStartValue(UDCDmain.UD_ArousalMultiplier)
        SetSliderDialogDefaultValue(0.05)
        SetSliderDialogRange(0.01,0.5)
        SetSliderDialogInterval(0.01)
    elseif aiOption == UD_OrgasmArousalReduce_S
        SetSliderDialogStartValue(UDCONF.UD_OrgasmArousalReduce)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(1.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_OrgasmArousalReduceDuration_S
        SetSliderDialogStartValue(UDCONF.UD_OrgasmArousalReduceDuration)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(1.0, 30.0)
        SetSliderDialogInterval(1.0)
    endIf
EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)
    if (aiOption == UD_OrgasmUpdateTime_S)
        UDCONF.UD_OrgasmUpdateTime = afValue
        SetSliderOptionValue(UD_OrgasmUpdateTime_S, UDCONF.UD_OrgasmUpdateTime, "{1} s")
    elseif (aiOption == UD_HornyAnimationDuration_S)
        UDCONF.UD_HornyAnimationDuration = Round(afValue)
        SetSliderOptionValue(UD_HornyAnimationDuration_S, UDCONF.UD_HornyAnimationDuration, "{0} s")
    elseif aiOption == UD_OrgasmResistence_S
        UDCONF.UD_OrgasmResistence = afValue
        SetSliderOptionValue(UD_OrgasmResistence_S, UDCONF.UD_OrgasmResistence, "{1} Op/s")
    elseif aiOption == UD_OrgasmExhaustionStruggleMax_S
        UDCONF.UD_OrgasmExhaustionStruggleMax = Round(afValue)
        SetSliderOptionValue(UD_OrgasmExhaustionStruggleMax_S, UDCONF.UD_OrgasmExhaustionStruggleMax, "{0} orgasms")
    elseif aiOption == UD_VibrationMultiplier_S
        UDCDmain.UD_VibrationMultiplier = afValue
        SetSliderOptionValue(UD_VibrationMultiplier_S, UDCDmain.UD_VibrationMultiplier, "{3}")
    elseif aiOption == UD_ArousalMultiplier_S
        UDCDmain.UD_ArousalMultiplier = afValue
        SetSliderOptionValue(UD_ArousalMultiplier_S, UDCDmain.UD_ArousalMultiplier, "{3}")
    elseif aiOption == UD_OrgasmArousalReduce_S
        UDCONF.UD_OrgasmArousalReduce = Round(afValue)
        SetSliderOptionValue(UD_OrgasmArousalReduce_S, UDCONF.UD_OrgasmArousalReduce, "{0} /s")
    elseif aiOption == UD_OrgasmArousalReduceDuration_S
        UDCONF.UD_OrgasmArousalReduceDuration = Round(afValue)
        SetSliderOptionValue(UD_OrgasmArousalReduceDuration_S, UDCONF.UD_OrgasmArousalReduceDuration, "{0} s")
    endIf
EndFunction

Function PageOptionMenuOpen(int aiOption)

EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)

EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int aiOption)
    if     aiOption == UD_OrgasmUpdateTime_S
        SetInfoText("$UD_ORGASMUPDATETIME_INFO")
    elseif aiOption == UD_UseOrgasmWidget_T
        SetInfoText("$UD_USEORGASMWIDGET_INFO")
    elseif aiOption == UD_OrgasmResistence_S
        SetInfoText("$UD_ORGASMRESISTENCE_INFO")
    elseif aiOption == UD_OrgasmExhaustionStruggleMax_S
        SetInfoText("$UD_ORGASMEXHAUSTIONSTRUGGLEMAX_INFO")
    elseif aiOption == UD_HornyAnimation_T
        SetInfoText("$UD_HORNYANIMATION_INFO")
    elseif aiOption == UD_HornyAnimationDuration_S
        SetInfoText("$UD_HORNYANIMATIONDURATION_INFO")
    elseif aiOption == UD_VibrationMultiplier_S
        SetInfoText("$UD_VIBRATIONMULTIPLIER_INFO")
    elseif aiOption == UD_ArousalMultiplier_S
        SetInfoText("$UD_AROUSALMULTIPLIER_INFO")
    elseif aiOption == UD_OrgasmArousalReduce_S
        SetInfoText("$UD_ORGASMAROUSALREDUCE_INFO")
    elseif aiOption == UD_OrgasmArousalReduceDuration_S
        SetInfoText("$UD_ORGASMAROUSALREDUCEDURATION_INFO")
    elseif(aiOption == UD_OrgasmExhaustion_T)
        SetInfoText("$UD_ORGASMEXHAUSTION_INFO")
    Endif
EndFunction
