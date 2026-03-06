Scriptname UD_MCM_Page_NPC extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_NPCInteligence Property UDAI
    UD_NPCInteligence Function Get()
        return UDmain.UDAI
    EndFunction
EndProperty

function PageInit()
endfunction

Function PageUpdate()
EndFunction

int UD_NPCSupport_T
Int UD_AIEnable_T
Int UD_AIUpdateTime_S
Int UD_AICooldown_S
Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_H_NPCSINTELIGENCE")
    addEmptyOption()
    
    UD_AIEnable_T = addToggleOption("$UD_AIENABLE", UDAI.Enabled)
    addEmptyOption()
    
    UD_AIUpdateTime_S   = addSliderOption("$UD_ORGASMUPDATETIME",UDAI.UD_UpdateTime, "${0} s",      FlagSwitch(UDAI.Enabled))
    UD_AICooldown_S     = addSliderOption("$UD_MINIGAMEHELPCD",UDAI.UD_AICooldown, "${0} min",    FlagSwitchOr(UD_LockMenu_flag,FlagSwitch(UDAI.Enabled)))
    
    AddHeaderOption("$UD_H_AUTOSCAN")
    addEmptyOption()
    
    UD_NPCSupport_T         = addToggleOption("$UD_NPCSUPPORT",UDmain.AllowNPCSupport)
EndFunction

Function PageOptionSelect(Int aiOption)
    if(aiOption == UD_AIEnable_T)
        UDAI.Enabled = !UDAI.Enabled
        SetToggleOptionValue(UD_AIEnable_T, UDAI.Enabled)
        forcePageReset()
    elseif aiOption == UD_NPCSupport_T
        UDmain.AllowNPCSupport = !UDmain.AllowNPCSupport
        SetToggleOptionValue(UD_NPCSupport_T, UDmain.AllowNPCSupport)
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    if (aiOption == UD_AIUpdateTime_S)
        SetSliderDialogStartValue(UDAI.UD_UpdateTime)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(1.0, 30.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_AICooldown_S
        SetSliderDialogStartValue(UDAI.UD_AICooldown)
        SetSliderDialogDefaultValue(30.0)
        SetSliderDialogRange(5.0, 120.0)
        SetSliderDialogInterval(5.0)
    endIf
EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)
    if (aiOption == UD_AIUpdateTime_S)
        UDAI.UD_UpdateTime = Round(afValue)
        SetSliderOptionValue(UD_AIUpdateTime_S, UDAI.UD_UpdateTime, "{0} s")
    elseif aiOption == UD_AICooldown_S
        UDAI.UD_AICooldown = Round(afValue)
        SetSliderOptionValue(UD_AICooldown_S, UDAI.UD_AICooldown, "{0} min")
    endIf
EndFunction

Function PageOptionMenuOpen(int aiOption)

EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)

EndFunction

Function PageDefault(int aiOption)
    if aiOption == UD_AIEnable_T
        UDAI.Enabled = True
        SetToggleOptionValue(UD_AIEnable_T, UDAI.Enabled)
    elseif aiOption == UD_AIUpdateTime_S
        UDAI.UD_UpdateTime = 10
        SetSliderOptionValue(UD_AIUpdateTime_S, UDAI.UD_UpdateTime)
    elseif aiOption == UD_AICooldown_S
        UDAI.UD_AICooldown = 30
        SetSliderOptionValue(UD_AICooldown_S, UDAI.UD_AICooldown)
    elseif (aiOption == UD_NPCSupport_T)
        UDmain.AllowNPCSupport = false
        SetToggleOptionValue(UD_NPCSupport_T, UDmain.AllowNPCSupport)
    Endif
EndFunction

Function PageInfo(int aiOption)
    if (aiOption == UD_NPCSupport_T)
        SetInfoText("$UD_NPCSUPPORT_INFO")
    elseif aiOption == UD_AIEnable_T
        SetInfoText("$UD_AIENABLE_INFO")
    elseif aiOption == UD_AIUpdateTime_S
        SetInfoText("$UD_AIUPDATETIME_INFO")
    elseif aiOption == UD_AICooldown_S
        SetInfoText("$UD_AICOOLDOWN_INFO") 
    Endif
EndFunction
