Scriptname UD_MCM_Page_Widget extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_WidgetControl Property UDWC Hidden
    UD_WidgetControl Function Get()
        return UDMain.UDWC
    EndFunction
EndProperty
UD_MenuTextFormatter  Property UDMTF hidden
    UD_MenuTextFormatter Function Get()
        return UDmain.UDMTF
    EndFunction
EndProperty
UD_MenuMsgManager  Property UDMMM hidden
    UD_MenuMsgManager Function Get()
        return UDmain.UDMMM
    EndFunction
EndProperty

int UD_UseIWantWidget_T
; device widgets
int UD_UseWidget_T
int UD_WidgetPosX_M
int UD_WidgetPosY_M
string[] widgetXList
string[] widgetYList
; overlay settings
Int UD_TextFontSize_S
Int UD_TextReadSpeed_S
Int UD_TextLineLength_S
Int UD_FilterVibNotifications_T
Int UD_EnableCNotifications_S
Int UD_EnableDeviceIcons_T
Int UD_EnableDebuffIcons_T
Int UD_IconsSize_S
Int UD_IconsAnchor_M
String[] UD_IconsAnchorList
Int UD_IconsPadding_S
Int UD_TextAnchor_M
String[] UD_TextAnchorList
Int UD_TextPadding_S
Int UD_WidgetTest_T
Int UD_WidgetReset_T
Int UD_IconVariant_EffExhaustion_M
String[] UD_IconVariant_EffExhaustionList
Int UD_IconVariant_EffOrgasm_M
String[] UD_IconVariant_EffOrgasmList
Int UD_MenuTextFormatter_M
Int UD_MenuMsgManager_M
Int UD_DeviceListEx_T
Int UD_DeviceListGroups_T
Int UD_DeviceListLastOnTop_T

function PageInit()
endfunction

Function PageUpdate()
    widgetXList = new String[3]
    widgetXList[0] = "$Left"
    widgetXList[1] = "$Middle"
    widgetXList[2] = "$Right"
    
    widgetYList = new String[3]
    widgetYList[0] = "$Down"
    widgetYList[1] = "$Less Down"
    widgetYList[2] = "$Up"
    
    UD_IconsAnchorList = new String[3]
    UD_IconsAnchorList[0] = "$Left"
    UD_IconsAnchorList[1] = "$CENTER"
    UD_IconsAnchorList[2] = "$Right"
    
    UD_TextAnchorList = new String[4]
    UD_TextAnchorList[0] = "$BOTTOM"
    UD_TextAnchorList[1] = "$BELOW CENTER"
    UD_TextAnchorList[2] = "$TOP"
    UD_TextAnchorList[3] = "$CENTER"
    
    UD_IconVariant_EffExhaustionList = new String[3]
    UD_IconVariant_EffExhaustionList[0] = "$Variant 1"
    UD_IconVariant_EffExhaustionList[1] = "$Variant 2"
    UD_IconVariant_EffExhaustionList[2] = "$Variant 3"
    UD_IconVariant_EffOrgasmList = new String[3]
    UD_IconVariant_EffOrgasmList[0] = "$Variant 1"
    UD_IconVariant_EffOrgasmList[1] = "$Variant 2"
    UD_IconVariant_EffOrgasmList[2] = "$Variant 3"
EndFunction

Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    SetCursorFillMode(TOP_TO_BOTTOM)

    ; LEFT COLUMN
    AddHeaderOption("$UD_H_WIDGETS")
    AddTextOption("iWantWidgets", InstallSwitch(UDmain.iWidgetInstalled), FlagSwitch(UDmain.iWidgetInstalled))
    UD_UseIWantWidget_T = AddToggleOption("$UD_USEIWANTWIDGET", UDWC.UD_UseIWantWidget, FlagSwitch(UDmain.iWidgetInstalled))
    ; device widgets
    AddHeaderOption("$UD_H_DEVICEWIDGETS")
    UD_UseWidget_T = addToggleOption("$UD_USEWIDGET", UDCDmain.UD_UseWidget)
    UD_WidgetPosX_M = AddMenuOption("$UD_WIDGETPOSX", widgetXList[UDWC.UD_WidgetXPos], FlagSwitch(UDCDmain.UD_UseWidget))
    UD_WidgetPosY_M = AddMenuOption("$UD_WIDGETPOSY", widgetYList[UDWC.UD_WidgetYPos], FlagSwitch(UDCDmain.UD_UseWidget))
    ; Device List
    AddHeaderOption("$UD_H_UIDEVICELIST")
    UD_DeviceListEx_T = AddToggleOption("$UD_UIDEVICELIST_EX", UDCDMain.UD_DeviceListEx, FlagSwitch(True))
    UD_DeviceListGroups_T = AddToggleOption("$UD_UIDEVICELIST_GROUPS", UDCDMain.UD_DeviceListGroups, FlagSwitch(True))
    UD_DeviceListLastOnTop_T = AddToggleOption("$UD_UIDEVICELIST_LASTONTOP", UDCDMain.UD_DeviceListLastOnTop, FlagSwitch(True))
    ; Menus
    AddHeaderOption("$UD_H_MENUS")
    UD_MenuTextFormatter_M = AddMenuOption("$UD_MENUTEXTFORMATTER", UDMTF.GetMode(), FlagSwitch(True))
    UD_MenuMsgManager_M = AddMenuOption("$UD_MENUMSGMANAGER", UDMMM.GetMode(), FlagSwitch(True))

    ; RIGHT COLUMN
    SetCursorPosition(1)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_H_OVERLAYSETTINGS")
    UD_EnableCNotifications_S = AddToggleOption("$UD_ENABLECNOTIFICATIONS", UDWC.UD_EnableCNotifications, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    UD_TextFontSize_S = addSliderOption("$UD_TEXTFONTSIZE", UDWC.UD_TextFontSize, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_TextLineLength_S = addSliderOption("$UD_TEXTLINELENGTH", UDWC.UD_TextLineLength, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_TextReadSpeed_S = addSliderOption("$UD_TEXTREADSPEED", UDWC.UD_TextReadSpeed, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_FilterVibNotifications_T = AddToggleOption("$UD_FILTERVIBNOTIFICATIONS", UDWC.UD_FilterVibNotifications, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    If UDWC.UD_TextAnchor < 0 || UDWC.UD_TextAnchor > 3
        UDMain.Warning("UD_MCM_script::resetUIWidgetPage() Unexpected value! UDWC.UD_TextAnchor = " + UDWC.UD_TextAnchor)
        UDWC.UD_TextAnchor = 1
    EndIf
    UD_TextAnchor_M = addMenuOption("$UD_TEXTANCHOR", UD_TextAnchorList[UDWC.UD_TextAnchor], a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_TextPadding_S = addSliderOption("$UD_TEXTPADDING", UDWC.UD_TextPadding, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_EnableDeviceIcons_T = AddToggleOption("$UD_ENABLEDEVICEICONS", UDWC.UD_EnableDeviceIcons, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    UD_EnableDebuffIcons_T = AddToggleOption("$UD_ENABLEDEBUFFICONS", UDWC.UD_EnableDebuffIcons, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    UD_IconsSize_S = addSliderOption("$UD_ICONSSIZE", UDWC.UD_IconsSize, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && (UDWC.UD_EnableDeviceIcons || UDWC.UD_EnableDebuffIcons)))
    If UDWC.UD_IconsAnchor < 0 || UDWC.UD_IconsAnchor > 2
        UDMain.Warning("UD_MCM_script::resetUIWidgetPage() Unexpected value! UDWC.UD_IconsAnchor = " + UDWC.UD_IconsAnchor)
        UDWC.UD_IconsAnchor = 1
    EndIf
    UD_IconsAnchor_M = addMenuOption("$UD_ICONSANCHOR", UD_IconsAnchorList[UDWC.UD_IconsAnchor], a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && (UDWC.UD_EnableDeviceIcons || UDWC.UD_EnableDebuffIcons)))
    UD_IconsPadding_S = addSliderOption("$UD_ICONSPADDING", UDWC.UD_IconsPadding, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && (UDWC.UD_EnableDeviceIcons || UDWC.UD_EnableDebuffIcons)))
    
    Int variant_index = UDWC.StatusEffect_GetVariant("effect-exhaustion")
    String variant_str = ""
    Bool variant_err = False
    If variant_index < 0 || variant_index >= UD_IconVariant_EffExhaustionList.Length
        variant_str = "ERROR"
        variant_err = True
    Else
        variant_err = False
        variant_str = UD_IconVariant_EffExhaustionList[variant_index]
    EndIf
    UD_IconVariant_EffExhaustion_M = addMenuOption("$UD_ICONVARIANTEFFEXHAUSTION", variant_str, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableDebuffIcons && !variant_err))
    variant_index = UDWC.StatusEffect_GetVariant("effect-orgasm")
    If variant_index < 0 || variant_index >= UD_IconVariant_EffOrgasmList.Length
        variant_str = "ERROR"
        variant_err = True
    Else
        variant_err = False
        variant_str = UD_IconVariant_EffOrgasmList[variant_index]
    EndIf
    UD_IconVariant_EffOrgasm_M = addMenuOption("$UD_ICONVARIANT_EFFORGASM", variant_str, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableDebuffIcons && !variant_err))
    
    UD_WidgetTest_T = AddTextOption("$UD_WIDGETTEST", "$-CLICK-")
    UD_WidgetReset_T = AddTextOption("$UD_WIDGETRESET", "$-CLICK-")
EndFunction

Function PageOptionSelect(Int option)
    if(option == UD_UseIWantWidget_T)
        UDWC.UD_UseIWantWidget = !UDWC.UD_UseIWantWidget
        SetToggleOptionValue(UD_UseIWantWidget_T, UDWC.UD_UseIWantWidget)
        ShowMessage("$To avoid possible errors when switching between different UI modes, please save your game and then load from that save.", False, "OK")
        forcePageReset()
    elseif(option == UD_UseWidget_T)
        UDCDmain.UD_UseWidget = !UDCDmain.UD_UseWidget
        SetToggleOptionValue(UD_UseWidget_T, UDCDmain.UD_UseWidget)
        forcePageReset()
    ElseIf option == UD_FilterVibNotifications_T
        UDWC.UD_FilterVibNotifications = !UDWC.UD_FilterVibNotifications
        SetToggleOptionValue(UD_FilterVibNotifications_T, UDWC.UD_FilterVibNotifications)
    ElseIf option == UD_DeviceListEx_T
        UDCDMain.UD_DeviceListEx = !UDCDMain.UD_DeviceListEx
        SetToggleOptionValue(UD_DeviceListEx_T, UDCDMain.UD_DeviceListEx)
    ElseIf option == UD_DeviceListGroups_T
        UDCDMain.UD_DeviceListGroups = !UDCDMain.UD_DeviceListGroups
        SetToggleOptionValue(UD_DeviceListGroups_T, UDCDMain.UD_DeviceListGroups)
    ElseIf option == UD_DeviceListLastOnTop_T
        UDCDMain.UD_DeviceListLastOnTop = !UDCDMain.UD_DeviceListLastOnTop
        SetToggleOptionValue(UD_DeviceListLastOnTop_T, UDCDMain.UD_DeviceListLastOnTop)
    ElseIf option == UD_EnableCNotifications_S
        UDWC.UD_EnableCNotifications = !UDWC.UD_EnableCNotifications
        SetToggleOptionValue(UD_EnableCNotifications_S, UDWC.UD_EnableCNotifications)
        forcePageReset()
    ElseIf option == UD_EnableDeviceIcons_T
        UDWC.UD_EnableDeviceIcons = !UDWC.UD_EnableDeviceIcons
        SetToggleOptionValue(UD_EnableDeviceIcons_T, UDWC.UD_EnableDeviceIcons)
        forcePageReset()
    ElseIf option == UD_EnableDebuffIcons_T
        UDWC.UD_EnableDebuffIcons = !UDWC.UD_EnableDebuffIcons
        SetToggleOptionValue(UD_EnableDebuffIcons_T, UDWC.UD_EnableDebuffIcons)
        forcePageReset()
    ElseIf option == UD_WidgetTest_T
        closeMCM()
        Utility.Wait(0.5)
        UDWC.TestWidgets()
    ElseIf option == UD_WidgetReset_T
        closeMCM()
        UDmain.Print("UI reset start - wait!")
        UDWC.Notification_Reset()
        UDWC.StatusEffect_ResetValues()
        UDWC.InitWidgetsRequest(abMeters = True, abIcons = True, abText = True)
        ;UnforgivingDevicesMain.ResetQuest(UDWC)
        MCM.OnGameReload()
        UDWC.WaitForReady(10.0)
        UDmain.UDWC.Meter_RegisterNative("player-orgasm",0,0.0,0.0, true)
        UDmain.UDWC.Meter_LinkActorOrgasm(Game.GetPlayer(),"player-orgasm")
        UDmain.Print("UI reset done!")
    endif
EndFunction

Function PageOptionSliderOpen(Int option)
    If option == UD_TextFontSize_S
        SetSliderDialogStartValue(UDWC.UD_TextFontSize)
        SetSliderDialogDefaultValue(24.0)
        SetSliderDialogRange(16.0, 36.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_TextLineLength_S
        SetSliderDialogStartValue(UDWC.UD_TextLineLength)
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(50.0, 200.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_TextReadSpeed_S
        SetSliderDialogStartValue(UDWC.UD_TextReadSpeed)
        SetSliderDialogDefaultValue(20.0)
        SetSliderDialogRange(10.0, 50.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_IconsSize_S
        SetSliderDialogStartValue(UDWC.UD_IconsSize)
        SetSliderDialogDefaultValue(60.0)
        SetSliderDialogRange(40.0, 80.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_IconsPadding_S
        SetSliderDialogStartValue(UDWC.UD_IconsPadding)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(-200, 500.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_TextPadding_S
        SetSliderDialogStartValue(UDWC.UD_TextPadding)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(0.0, 300.0)
        SetSliderDialogInterval(1.0)
    EndIf
EndFunction
Function PageOptionSliderAccept(Int option, Float value)
    If option == UD_TextFontSize_S
        UDWC.UD_TextFontSize = value as Int
        SetSliderOptionValue(UD_TextFontSize_S, value)
    ElseIf option == UD_TextLineLength_S
        UDWC.UD_TextLineLength = value as Int
        SetSliderOptionValue(UD_TextLineLength_S, value)
    ElseIf option == UD_TextReadSpeed_S
        UDWC.UD_TextReadSpeed = value as Int
        SetSliderOptionValue(UD_TextReadSpeed_S, value)
    ElseIf option == UD_IconsSize_S
        UDWC.UD_IconsSize = value as Int
        SetSliderOptionValue(UD_IconsSize_S, value)
    ElseIf option == UD_IconsPadding_S
        UDWC.UD_IconsPadding = value as Int
        SetSliderOptionValue(UD_IconsPadding_S, value)
    ElseIf option == UD_TextPadding_S
        UDWC.UD_TextPadding = value as Int
        SetSliderOptionValue(UD_TextPadding_S, value)
    EndIf
EndFunction

Function PageOptionMenuOpen(int option)
    if (option == UD_IconsAnchor_M)
        SetMenuDialogOptions(UD_IconsAnchorList)
        SetMenuDialogStartIndex(UDWC.UD_IconsAnchor)
        SetMenuDialogDefaultIndex(1)
    ElseIf (option == UD_TextAnchor_M)
        SetMenuDialogOptions(UD_TextAnchorList)
        SetMenuDialogStartIndex(UDWC.UD_TextAnchor)
        SetMenuDialogDefaultIndex(1)
    ElseIf (option == UD_IconVariant_EffExhaustion_M)
        SetMenuDialogOptions(UD_IconVariant_EffExhaustionList)
        Int variant = UDWC.StatusEffect_GetVariant("effect-exhaustion")
        If variant < 0 || variant >= UD_IconVariant_EffExhaustionList.Length
            variant = 0
        EndIf
        SetMenuDialogStartIndex(variant)
        SetMenuDialogDefaultIndex(2)
    ElseIf (option == UD_IconVariant_EffOrgasm_M)
        SetMenuDialogOptions(UD_IconVariant_EffOrgasmList)
        Int variant = UDWC.StatusEffect_GetVariant("effect-orgasm")
        If variant < 0 || variant >= UD_IconVariant_EffOrgasmList.Length
            variant = 0
        EndIf
        SetMenuDialogStartIndex(variant)
        SetMenuDialogDefaultIndex(2)
    elseif (option == UD_WidgetPosX_M)
        SetMenuDialogOptions(widgetXList)
        SetMenuDialogStartIndex(UDWC.UD_WidgetXPos)
        SetMenuDialogDefaultIndex(1)
    elseif (option == UD_WidgetPosY_M)
        SetMenuDialogOptions(widgetYList)
        SetMenuDialogStartIndex(UDWC.UD_WidgetYPos)
        SetMenuDialogDefaultIndex(1)
    elseif (option == UD_MenuTextFormatter_M)
        String[] loc_modes = UDMTF.GetModes()
        SetMenuDialogOptions(loc_modes)
        SetMenuDialogStartIndex(UDMTF.GetModeIndex())
        SetMenuDialogDefaultIndex(1)
    elseif (option == UD_MenuMsgManager_M)
        String[] loc_modes = UDMMM.GetModes()
        SetMenuDialogOptions(loc_modes)
        SetMenuDialogStartIndex(UDMMM.GetModeIndex())
        SetMenuDialogDefaultIndex(1)
    endif
EndFunction
Function PageOptionMenuAccept(int option, int index)
    if option == UD_IconsAnchor_M && index >= 0 && index < 3
        SetMenuOptionValue(UD_IconsAnchor_M, UD_IconsAnchorList[index])
        UDWC.UD_IconsAnchor = index
    ElseIf option == UD_TextAnchor_M && index >= 0 && index < 4
        SetMenuOptionValue(UD_TextAnchor_M, UD_TextAnchorList[index])
        UDWC.UD_TextAnchor = index
    ElseIf (option == UD_IconVariant_EffExhaustion_M)
        SetMenuOptionValue(UD_IconVariant_EffExhaustion_M, UD_IconVariant_EffExhaustionList[index])
        UDWC.StatusEffect_Register("effect-exhaustion", -1, index)
    ElseIf (option == UD_IconVariant_EffOrgasm_M)
        SetMenuOptionValue(UD_IconVariant_EffOrgasm_M, UD_IconVariant_EffOrgasmList[index])
        UDWC.StatusEffect_Register("effect-orgasm", -1, index)
    elseif (option == UD_WidgetPosX_M)
        SetMenuOptionValue(UD_WidgetPosX_M, widgetXList[index])
        UDWC.UD_WidgetXPos = index
;        ShowMessage("$UD_WIDGETS_RESET_MSG", false, "$Close")
;        closeMCM()
    elseif (option == UD_WidgetPosY_M)
        SetMenuOptionValue(UD_WidgetPosY_M, widgetYList[index])
        UDWC.UD_WidgetYPos = index
;        ShowMessage("$UD_WIDGETS_RESET_MSG", false, "$Close")
;        closeMCM()
    elseif (option == UD_MenuTextFormatter_M)
        String[] loc_modes = UDMTF.GetModes()
        UDMTF.SetMode(loc_modes[index])
        SetMenuOptionValue(UD_MenuTextFormatter_M, loc_modes[index])
;        forcePageReset()
    elseif (option == UD_MenuMsgManager_M)
        String[] loc_modes = UDMMM.GetModes()
        UDMMM.SetMode(loc_modes[index])
        SetMenuOptionValue(UD_MenuMsgManager_M, loc_modes[index])
;        forcePageReset()
    endif
EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int option)
    if option == UD_UseIWantWidget_T
        SetInfoText("$UD_USEIWANTWIDGET_INFO")
    elseif option == UD_UseWidget_T
        SetInfoText("$UD_USEWIDGET_INFO")
    elseif option == UD_WidgetPosX_M
        SetInfoText("$UD_CWIDGETPOSX_INFO")
    elseif option == UD_WidgetPosY_M
        SetInfoText("$UD_WIDGETPOSY_INFO")
    elseif option == UD_MenuTextFormatter_M
        SetInfoText("$UD_MENUTEXTFORMATTER_INFO")
    elseif option == UD_MenuMsgManager_M
        SetInfoText("$UD_MENUMSGMANAGER_INFO")
    ElseIf option == UD_TextFontSize_S
        SetInfoText("$UD_TEXTFONTSIZE_INFO")
    ElseIf option == UD_TextLineLength_S
        SetInfoText("$UD_TEXTLINELENGTH_INFO")
    ElseIf option == UD_TextReadSpeed_S
        SetInfoText("$UD_TEXTREADSPEED_INFO")
    ElseIf option == UD_FilterVibNotifications_T
        SetInfoText("$UD_FILTERVIBNOTIFICATIONS_INFO")
    ElseIf option == UD_DeviceListEx_T
        SetInfoText("$UD_UIDEVICELIST_EX_INFO")
    ElseIf option == UD_DeviceListGroups_T
        SetInfoText("$UD_UIDEVICELIST_GROUPS_INFO")
    ElseIf option == UD_DeviceListLastOnTop_T
        SetInfoText("$UD_UIDEVICELIST_LASTONTOP_INFO")
    ElseIf option == UD_EnableCNotifications_S
        SetInfoText("$UD_ENABLECNOTIFICATIONS_INFO")
    ElseIf option == UD_EnableDeviceIcons_T
        SetInfoText("$UD_ENABLEDEVICEICONS_INFO")
    ElseIf option == UD_EnableDebuffIcons_T
        SetInfoText("$UD_ENABLEDEBUFFICONS_INFO")
    ElseIf option == UD_IconsSize_S
        SetInfoText("$UD_ICONSSIZE_INFO")
    ElseIf option == UD_IconsAnchor_M
        SetInfoText("$UD_ICONSANCHOR_INFO")
    ElseIf option == UD_IconsPadding_S
        SetInfoText("$UD_ICONSPADDING_INFO")
    ElseIf option == UD_TextAnchor_M
        SetInfoText("$UD_TEXTANCHOR_INFO")
    ElseIf option == UD_TextPadding_S
        SetInfoText("$UD_TEXTANCHOR_INFO")
    ElseIf option == UD_WidgetTest_T
        SetInfoText("$UD_WIDGETTEST_INFO")
    ElseIf option == UD_WidgetReset_T
        SetInfoText("$UD_WIDGETRESET_INFO")
    endif
EndFunction
