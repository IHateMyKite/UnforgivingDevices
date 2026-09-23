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
EndFunction

Function PageOptionSelect(Int option)
EndFunction

Function PageOptionSliderOpen(Int option)
EndFunction
Function PageOptionSliderAccept(Int option, Float value)
EndFunction

Function PageOptionMenuOpen(int option)
EndFunction
Function PageOptionMenuAccept(int option, int index)
EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int option)
EndFunction
