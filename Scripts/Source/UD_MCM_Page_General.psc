Scriptname UD_MCM_Page_General extends UD_MCM_Page

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

int UD_StruggleKey_K
int UD_hightPerformance_T
int lockmenu_T
int UD_debugmod_T
int UD_LoggingLevel_S
int UD_NPCSupport_T
int UD_PlayerMenu_K
int UD_NPCMenu_K
int UD_HearingRange_S
int UD_WarningAllowed_T
Int UD_PrintLevel_S
Int UD_LockDebugMCM_T
Int UD_GamepadKey_K
int UD_EasyGamepadMode_T
int UD_UseNativeFunctions_T
Function PageReset(Bool abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)

    AddHeaderOption("$UD_H_KEYMAPPING")
    addEmptyOption()
    
    UD_StruggleKey_K        = AddKeyMapOption("$UD_STRUGGLEKEY", UDCDmain.StruggleKey_Keycode,FlagSwitch(!UDUI.UD_EasyGamepadMode || !Game.UsingGamepad()))
    addEmptyOption()
    
    UD_PlayerMenu_K         = AddKeyMapOption("$UD_PLAYERMENU", UDCDmain.PlayerMenu_KeyCode,FlagSwitch(!UDUI.UD_EasyGamepadMode || !Game.UsingGamepad()))
    UD_NPCMenu_K            = AddKeyMapOption("$UD_NPCMENU", UDCDmain.NPCMenu_Keycode,FlagSwitch(!UDUI.UD_EasyGamepadMode || !Game.UsingGamepad()))
    
    UD_EasyGamepadMode_T    = addToggleOption("$UD_EASYGAMEPADMODE",UDUI.UD_EasyGamepadMode,FlagSwitch(Game.UsingGamepad() || UDUI.UD_EasyGamepadMode))
    UD_GamepadKey_K         = AddKeyMapOption("$UD_GAMEPADKEY", UDmain.UDUI.UD_GamepadKey,FlagSwitch(UDUI.UD_EasyGamepadMode))
    
    AddHeaderOption("$UD_H_GENERALSETTINGS")
    addEmptyOption()
    
    UD_hightPerformance_T   = addToggleOption("$UD_HIGHPERFORMANCE",UDmain.UD_hightPerformance)
    UD_UseNativeFunctions_T = addToggleOption("$UD_NATIVESWITCH",True,FlagSwitch(False)) ;disabled on LE
    
    UD_HearingRange_S       = addSliderOption("$UD_HEARINGRANGE",UDmain.UD_HearingRange,"{0}")
    UD_PrintLevel_S         = addSliderOption("$UD_PRINTLEVEL",UDmain.UD_PrintLevel, "{0}")

    lockmenu_T              = addToggleOption("$UD_LOCKMENU",UDmain.lockMCM,FlagSwitch(!abLockMenu))
    UD_LockDebugMCM_T       = addToggleOption("$UD_LOCKDEBUGMCM",UDmain.UD_LockDebugMCM,FlagSwitchAnd(FlagSwitch(!abLockMenu),FlagSwitch(!UDmain.UD_LockDebugMCM)))

    AddHeaderOption("$UD_H_DEBUG")
    addEmptyOption()
    UD_debugmod_T           = addToggleOption("$UD_DEBUGMOD",UDmain.DebugMod)
    UD_LoggingLevel_S       = addSliderOption("$UD_LOGGINGLEVEL",UDmain.LogLevel, "{0}")
    
    UD_WarningAllowed_T     = addToggleOption("$UD_WARNINGALLOWED",UDmain.UD_WarningAllowed)
    addEmptyOption()
EndFunction

Function PageOptionSelect(Int aiOption)
    if(aiOption == lockmenu_T)
        UDmain.lockMCM = !UDmain.lockMCM
        SetToggleOptionValue(lockmenu_T, UDmain.lockMCM)
    elseif (aiOption == UD_hightPerformance_T)
        UDmain.UD_hightPerformance = !UDmain.UD_hightPerformance
        SetToggleOptionValue(UD_hightPerformance_T, UDmain.UD_hightPerformance)
    elseif (aiOption == UD_debugmod_T)
        UDmain.debugmod = !UDmain.debugmod
        SetToggleOptionValue(UD_debugmod_T, UDmain.debugmod)
    elseif aiOption == UD_WarningAllowed_T
        UDmain.UD_WarningAllowed = !UDmain.UD_WarningAllowed
        SetToggleOptionValue(UD_WarningAllowed_T, UDmain.UD_WarningAllowed)  
    elseif aiOption == UD_LockDebugMCM_T
        UDmain.UD_LockDebugMCM = !UDmain.UD_LockDebugMCM
        SetToggleOptionValue(UD_LockDebugMCM_T, UDmain.UD_LockDebugMCM)
    elseif aiOption == UD_EasyGamepadMode_T
        UDUI.UD_EasyGamepadMode = !UDUI.UD_EasyGamepadMode
        SetToggleOptionValue(UD_EasyGamepadMode_T, UDUI.UD_EasyGamepadMode)
        forcePageReset()
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    if (aiOption == UD_LoggingLevel_S)
        SetSliderDialogStartValue(UDmain.LogLevel)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 3.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_PrintLevel_S
        SetSliderDialogStartValue(UDmain.UD_PrintLevel)
        SetSliderDialogDefaultValue(3.0)
        SetSliderDialogRange(0.0, 3.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_HearingRange_S
        SetSliderDialogStartValue(UDmain.UD_HearingRange)
        SetSliderDialogDefaultValue(UDmain.UD_HearingRange)
        SetSliderDialogRange(1000.0, 50000.0)
        SetSliderDialogInterval(500.0)
    endIf
EndFunction

Function PageOptionSliderAccept(Int aiOption, Float afValue)
    if (aiOption == UD_LoggingLevel_S)
        UDmain.LogLevel = Round(afValue)
        SetSliderOptionValue(UD_LoggingLevel_S, UDmain.LogLevel, "{0}")
    elseif aiOption == UD_PrintLevel_S
        UDmain.UD_PrintLevel = Round(afValue)
        SetSliderOptionValue(UD_PrintLevel_S, UDmain.UD_PrintLevel, "{0}")
    elseif aiOption == UD_HearingRange_S
        UDmain.UD_HearingRange =  Round(afValue)
        SetSliderOptionValue(UD_HearingRange_S, UDmain.UD_HearingRange, "{0}")
    endIf
EndFunction

Function PageOptionKeyMapChange(Int aiOption, Int aiKeyCode, String asConflictControl, String asConflictName)
    if (aiOption == UD_StruggleKey_K)
        if MCM.checkGeneralKeyConflict(aiKeyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.StruggleKey_Keycode)
            UDCDmain.StruggleKey_Keycode = aiKeyCode
            SetKeyMapOptionValue(UD_StruggleKey_K, UDCDmain.StruggleKey_Keycode)
            UDmain.UDUI.RegisterForKey(UDCDmain.StruggleKey_Keycode)
        endif
    elseif aiOption == UD_PlayerMenu_K
        if MCM.checkGeneralKeyConflict(aiKeyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.PlayerMenu_KeyCode)
            UDCDmain.PlayerMenu_KeyCode = aiKeyCode
            SetKeyMapOptionValue(UD_PlayerMenu_K, UDCDmain.PlayerMenu_KeyCode)
            UDmain.UDUI.RegisterForKey(UDCDmain.PlayerMenu_KeyCode)
        endif
    elseif aiOption == UD_NPCMenu_K
        if MCM.checkGeneralKeyConflict(aiKeyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.NPCMenu_Keycode)
            UDCDmain.NPCMenu_Keycode = aiKeyCode
            SetKeyMapOptionValue(UD_NPCMenu_K, UDCDmain.NPCMenu_Keycode)
            UDmain.UDUI.RegisterForKey(UDCDmain.NPCMenu_Keycode)
        endif
    elseif (aiOption == UD_GamepadKey_K)
        if MCM.checkGeneralKeyConflict(aiKeyCode)
            UDmain.UDUI.UnRegisterForKey(UDmain.UDUI.UD_GamepadKey)
            UDmain.UDUI.UD_GamepadKey = aiKeyCode
            UDmain.UDUI.RegisterForKey(UDmain.UDUI.UD_GamepadKey)
            SetKeyMapOptionValue(UD_GamepadKey_K, UDmain.UDUI.UD_GamepadKey)
        endif
    endIf
EndFunction

Function PageDefault(int aiOption)
    if(aiOption == lockmenu_T)
        UDmain.lockMCM = false
        SetToggleOptionValue(lockmenu_T, UDmain.lockMCM)
    elseif(aiOption == UD_StruggleKey_K)
        if !Game.UsingGamepad()
            UDCDMain.StruggleKey_Keycode = 52
        else
            UDCDMain.StruggleKey_Keycode = 275
        endif
        SetKeyMapOptionValue(UD_StruggleKey_K, UDCDMain.StruggleKey_Keycode)
    elseif(aiOption == UD_hightPerformance_T)
        UDmain.UD_hightPerformance = true
        SetToggleOptionValue(UD_hightPerformance_T, UDmain.UD_hightPerformance)
    elseif(aiOption == UD_debugmod_T)
        UDmain.DebugMod = false
        SetToggleOptionValue(UD_debugmod_T, UDmain.DebugMod)
    elseif aiOption == UD_HearingRange_S
        UDmain.UD_HearingRange = 4000
        SetSliderOptionValue(UD_HearingRange_S, UDmain.UD_HearingRange)
    elseif aiOption == UD_WarningAllowed_T
        UDmain.UD_WarningAllowed = false
        SetToggleOptionValue(UD_WarningAllowed_T, UDmain.UD_WarningAllowed)
    elseif aiOption == UD_PrintLevel_S
        UDmain.UD_PrintLevel = 3
        SetSliderOptionValue(UD_PrintLevel_S, UDmain.UD_PrintLevel)
    elseif(aiOption == UD_PlayerMenu_K)
        if !Game.UsingGamepad()
            UDCDMain.PlayerMenu_KeyCode = 40
        else
            UDCDMain.PlayerMenu_KeyCode = 268
        endif
        SetKeyMapOptionValue(UD_PlayerMenu_K, UDCDMain.PlayerMenu_KeyCode)
    elseif(aiOption == UD_NPCMenu_K)
        if !Game.UsingGamepad()
            UDCDMain.NPCMenu_Keycode = 39
        else
            UDCDMain.NPCMenu_Keycode = 269
        endif
        SetKeyMapOptionValue(UD_NPCMenu_K, UDCDMain.NPCMenu_Keycode)
    elseif(aiOption == UD_LoggingLevel_S)
        UDmain.LogLevel = 0
        SetSliderOptionValue(UD_LoggingLevel_S, UDmain.LogLevel)
    elseif aiOption == UD_LockDebugMCM_T
        UDmain.UD_LockDebugMCM = false
        SetToggleOptionValue(UD_LockDebugMCM_T, UDmain.UD_LockDebugMCM)
    elseif aiOption == UD_EasyGamepadMode_T
        UDUI.UD_EasyGamepadMode = false
        SetToggleOptionValue(UD_EasyGamepadMode_T, UDUI.UD_EasyGamepadMode)
    Endif
EndFunction

Function PageInfo(int aiOption)
    if(aiOption == lockmenu_T)
        SetInfoText("$UD_LOCKMENU_INFO")
    elseif(aiOption == UD_StruggleKey_K)
        SetInfoText("$UD_STRUGGLEKEY_INFO")
    elseif(aiOption == UD_hightPerformance_T)
        SetInfoText("$UD_HIGHPERFORMANCE_INFO")
    elseif(aiOption == UD_debugmod_T)
        SetInfoText("$UD_DEBUGMOD_INFO")
    elseif aiOption == UD_HearingRange_S
        SetInfoText("$UD_HEARINGRANGE_INFO")
    elseif aiOption == UD_WarningAllowed_T
        SetInfoText("$UD_WARNINGALLOWED_INFO")
    elseif aiOption == UD_PrintLevel_S
        SetInfoText("$UD_PRINTLEVEL_INFO")
    elseif(aiOption == UD_PlayerMenu_K)
        SetInfoText("$UD_PLAYERMENU_INFO")
    elseif(aiOption == UD_NPCMenu_K)
        SetInfoText("$UD_NPCMENU_INFO")
    elseif(aiOption == UD_LoggingLevel_S)
        SetInfoText("$UD_LOGGINGLEVEL_INFO")
    elseif aiOption == UD_LockDebugMCM_T
        SetInfoText("$UD_LOCKDEBUGMCM_INFO")
    elseif aiOption == UD_EasyGamepadMode_T
        SetInfoText("$UD_EASYGAMEPADMODE_INFO")
    elseif aiOption == UD_UseNativeFunctions_T
        SetInfoText("$UD_NATIVESWITCH_INFO")
    Endif
EndFunction