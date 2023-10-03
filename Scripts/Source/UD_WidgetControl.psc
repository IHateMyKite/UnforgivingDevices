;   File: UD_WidgetControl
;   This module contains functions for manipulating widgets.
;   It has two states: "Default" and "iWidgetInstalled".
;   Many of the functions defined here will work differently, depending on what state the script is in.
;   For example, status icons will not be displayed in the standard interface rendering mode, although their state will be changed and saved from API calls.
ScriptName UD_WidgetControl extends Quest

import UnforgivingDevicesMain

; CONSTANTS
Int W_POSY_BOTTOM = 0
Int W_POSY_BELOWCENTER = 1
Int W_POSY_TOP = 2
Int W_POSY_CENTER = 3
Int W_POSX_LEFT = 0
Int W_POSX_CENTER = 1
Int W_POSX_RIGHT = 2

Int W_ICON_CLUSTER_UNSET    = -1
Int W_ICON_CLUSTER_DEVICES  = 0
Int W_ICON_CLUSTER_EFFECTS  = 1

UnforgivingDevicesMain      Property UDmain             Auto

; vanilla widgets
UD_WidgetBase[]             Property UD_VanillaWidgets  Auto
{Vanilla meter widgets}


;/  Group: Config
===========================================================================================
===========================================================================================
===========================================================================================
/; 

;/  Variable: Ready
    Will be toggled to True once script is ready.
    
    Do not edit, *READ ONLY!*.
/;
Bool                        Property Ready = False      Auto    Hidden               

;/  Variable: iWidget

    iWant_Widgets object. Used to interract with iWantWidgets mod.
    
    Do not edit, *READ ONLY!*.
/;
iWant_Widgets Property iWidget Hidden
{iWidget quest}
    iWant_Widgets Function Get()
        return (UDmain.iWidgetQuest as iWant_Widgets)
    EndFunction
EndProperty


Bool _UD_UseIWantWidget = True
;/  Variable: UD_UseIWantWidget

    If True then UI rendered with iWantWidgets mod.
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Bool                        Property UD_UseIWantWidget          Hidden
    Bool Function Get() 
        Return _UD_UseIWantWidget
    EndFunction
    Function Set(Bool abValue)
        If _UD_UseIWantWidget != abValue
            _UD_UseIWantWidget = abValue
            UDmain.ForceUpdate()
        EndIf
    EndFunction
EndProperty

; overlay settings

;/  Variable: UD_MeterVertPadding

    Vertical spacing between widgets, measured in their heights.
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Float Property UD_MeterVertPadding = 1.50 Auto   Hidden

Bool _UD_EnableDeviceIcons = True
;/  Variable: UD_EnableDeviceIcons

    Enable device icons (renderend in W_ICON_CLUSTER_DEVICES).
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Bool Property UD_EnableDeviceIcons Hidden
    Bool Function Get()
        Return _UD_EnableDeviceIcons
    EndFunction
    Function Set(Bool abValue)
        If _UD_EnableDeviceIcons != abValue
            _UD_EnableDeviceIcons = abValue
            InitWidgetsRequest(abIcons = True)
        EndIf
    EndFunction
EndProperty

Bool _UD_EnableDebuffIcons = True
;/  Variable: UD_EnableDebuffIcons

    Enable (de)buffs icons (renderend in W_ICON_CLUSTER_EFFECTS).
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Bool Property UD_EnableDebuffIcons Hidden
    Bool Function Get()
        Return _UD_EnableDebuffIcons
    EndFunction
    Function Set(Bool abValue)
        If _UD_EnableDebuffIcons != abValue
            _UD_EnableDebuffIcons = abValue
            InitWidgetsRequest(abIcons = True)
        EndIf
    EndFunction
EndProperty

Bool _UD_EnableCNotifications = True
;/  Variable: UD_EnableCNotifications

    Enable customized text notifications.
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Bool Property UD_EnableCNotifications Hidden
    Bool Function Get()
        Return _UD_EnableCNotifications
    EndFunction
    Function Set(Bool abValue)
        If _UD_EnableCNotifications != abValue
            _UD_EnableCNotifications = abValue
            InitWidgetsRequest(abText = True)
        EndIf
    EndFunction
EndProperty

Int _UD_TextFontSize = 24
;/  Variable: UD_TextFontSize

    Notification text font size.
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Int Property UD_TextFontSize Hidden
    Int Function Get()
        Return _UD_TextFontSize
    EndFunction
    Function Set(Int aiValue)
        If _UD_TextFontSize != aiValue
            _UD_TextFontSize = aiValue
            InitWidgetsRequest(abText = True)
        EndIf
    EndFunction
EndProperty

;/  Variable: UD_TextLineLength

    The length of the text notification line (measured in characters).
    
    Do not edit, *READ ONLY!* Configurable on MCM UI Widgets page by user.
/;
Int                         Property    UD_TextLineLength           = 100   Auto    Hidden

;/  Variable: UD_TextReadSpeed

    Display time of text on the screen (measured in the number of characters per second).
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Int                         Property    UD_TextReadSpeed            = 20    Auto    Hidden

;/  Variable: UD_TextOutlineShift

    The specified shift for the stroke of text characters.
    
    Do not edit, *READ ONLY!*.
/;
Int                         Property    UD_TextOutlineShift         = 1     Auto    Hidden

;/  Variable: UD_FilterVibNotifications

    If True, then some redundant notifications from vibrators will be ignored.
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Bool                        Property    UD_FilterVibNotifications   = True  Auto    Hidden

;/  Variable: UD_TextFadeOutTime

    Text fade time.
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Float                       Property    UD_TextFadeTime             = 1.0   Auto    Hidden

Int _UD_TextAnchor = 1
;/  Variable: UD_TextAnchor

    Anchor for the text notification output area (vertical position).
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
    
    Values:
    --- Code
    W_POSY_BOTTOM = 0
    W_POSY_BELOWCENTER = 1
    W_POSY_TOP = 2
    W_POSY_CENTER = 3
    ---
/;
Int Property UD_TextAnchor Hidden
    Int Function Get()
        Return _UD_TextAnchor
    EndFunction
    Function Set(Int aiValue)
        If _UD_TextAnchor != aiValue
            _UD_TextAnchor = aiValue
            InitWidgetsRequest(abText = True)
        EndIf
    EndFunction
EndProperty

Int _UD_TextPadding = 0
;/  Variable: UD_TextAnchor

    Vertical shift of the output area relative to the anchor (see <UD_TextAnchor>).
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Int Property UD_TextPadding Hidden
    Int Function Get()
        Return _UD_TextPadding
    EndFunction
    Function Set(Int aiValue)
        If _UD_TextPadding != aiValue
            _UD_TextPadding = aiValue
            InitWidgetsRequest(abText = True)
        EndIf
    EndFunction
EndProperty

Int _UD_IconsSize = 60

;/  Variable: UD_IconsSize

    Status effect icon size.
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Int Property UD_IconsSize Hidden
    Int Function Get()
        Return _UD_IconsSize
    EndFunction
    Function Set(Int aiValue)
        If _UD_IconsSize != aiValue
            _UD_IconsSize = aiValue
            InitWidgetsRequest(abIcons = True)
        EndIf
    EndFunction
EndProperty

; anchor horizontal position of the icons cluster (see W_POSX_**** constants)
Int _UD_IconsAnchor = 1
;/  Variable: UD_IconsAnchor

    Anchor for the status icon area (horizontal position).
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
    
    --- Code
    W_POSX_LEFT = 0
    W_POSX_CENTER = 1
    W_POSX_RIGHT = 2
    ---
/;
Int Property UD_IconsAnchor Hidden
    Int Function Get()
        Return _UD_IconsAnchor
    EndFunction
    Function Set(Int aiValue)
        If _UD_IconsAnchor != aiValue
            _UD_IconsAnchor = aiValue
            InitWidgetsRequest(abIcons = True)
        EndIf
    EndFunction
EndProperty

Int _UD_IconsPadding = 0
;/  Variable: UD_IconsPadding

    Horizontal shift of the output area relative to the anchor (see <UD_IconsAnchor>).
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
/;
Int Property UD_IconsPadding Hidden
    Int Function Get()
        Return _UD_IconsPadding
    EndFunction
    Function Set(Int aiValue)
        If _UD_IconsPadding != aiValue
            _UD_IconsPadding = aiValue
            InitWidgetsRequest(abIcons = True)
        EndIf
    EndFunction
EndProperty

Int _WidgetXPos = 2
;/  Variable: UD_WidgetXPos

    Anchor for the meters area (horizontal position).
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
    
    Values:
    --- Code
    W_POSX_LEFT = 0
    W_POSX_CENTER = 1
    W_POSX_RIGHT = 2
    ---
/;
Int Property UD_WidgetXPos Hidden
    Function Set(Int aiVal)
        If _WidgetXPos == aiVal
            Return
        EndIf
        _WidgetXPos = aiVal
        Int i = UD_VanillaWidgets.Length
        While i > 0
            i -= 1
            UD_VanillaWidgets[i].PositionX = _WidgetXPos
        EndWhile
        if GetState() == "iWidgetInstalled"
            InitWidgetsRequest(abMeters = True)
        endif
    EndFunction
    Int Function Get()
        return _WidgetXPos
    EndFunction
EndProperty

Int _WidgetYPos = 0
;/  Variable: UD_WidgetYPos

    Anchor for the meters area (vertical position).
    
    Do not edit, *READ ONLY!*. Configurable on MCM UI Widgets page by user.
    
    --- Code
    W_POSY_BOTTOM = 0
    W_POSY_BELOWCENTER = 1
    W_POSY_TOP = 2
    W_POSY_CENTER = 3
    ---
/;
Int Property UD_WidgetYPos Hidden
    Function Set(Int aiVal)
        If _WidgetYPos == aiVal
            Return
        EndIf
        _WidgetYPos = aiVal
        Int i = UD_VanillaWidgets.Length
        While i > 0
            i -= 1
            UD_VanillaWidgets[i].PositionY = _WidgetYPos
        EndWhile
        if GetState() == "iWidgetInstalled"
            InitWidgetsRequest(abMeters = True)
        endif
    EndFunction
    Int Function Get()
        return _WidgetYPos
    EndFunction
EndProperty

;/  Variable: UD_UseDeviceConditionWidget

    Indicates that an additional widget is being used for devices.
    
    Do not edit, *READ ONLY!*.
/;
Bool    Property   UD_UseDeviceConditionWidget  = True  Auto    Hidden

; basic dimensions of the canvas
Int CanvasWidth = 1280
Int CanvasHeight = 720
; correction for wide screens
Float WideScreenFactor = 1.0
; meter's size in canvas pixels (used to calculate positions/offsets)
Float HUDMeterWidthRef = 248.0
Float HUDMeterHeightRef = 15.0
; meter's size in screen pixels (used to set size on screen)
Float HUDMeterWidth
Float HUDMeterHeight
; HUD's paddings
Float HUDPaddingX
Float HUDPaddingY

;some shortcut references, so it doesn't have to be always fetched with _GetMeter/_GetVanillaMeter
;its updated on game reload
UD_WidgetMeter_RefAlias _orgasmMeterIWW
UD_WidgetBase           _orgasmMeterSkyUi
UD_WidgetMeter_RefAlias _deviceMainMeterIWW
UD_WidgetBase           _deviceMainMeterSkyUi
UD_WidgetMeter_RefAlias _deviceSecMeterIWW
UD_WidgetBase           _deviceSecMeterSkyUi

;returns true if the module is the one assigned to UD_Main
Bool Function SingletonCheck()
    Bool loc_res = (self == UDmain.UDWC)
    
    if !loc_res
        GError(self+"::SingletonCheck() - This instance of script should not exist!")
    endif
    return loc_res
EndFunction

Event OnInit()
    RegisterForSingleUpdate(6) ;maintenance update
EndEvent

Event OnUpdate()
    if !SingletonCheck()
        UnregisterForUpdate()
        return
    endif
    If !Ready
        ;wait for UD to get ready first
        if !UDmain.WaitForReady()
            return ;fatal error, do not use the module
        endif
        Ready = True
        ; initialization on new game
        OnUIReload(abGameLoad = False)
    EndIf
    RegisterForSingleUpdate(30) ;maintenance update
EndEvent

Function GameUpdate()
    RegisterForModEvent("UDReloadUI","OnUIReload")
    ; initializations on game load
    OnUIReload(abGameLoad = True)
    ; upgrade version
    UD_MeterVertPadding = 1.50
    Int i = UD_VanillaWidgets.Length
    While i > 0
        i -= 1
        If UD_VanillaWidgets[i].WidgetName == "DeviceWidget"
            UD_VanillaWidgets[i].WidgetName = "device-main"
        ElseIf UD_VanillaWidgets[i].WidgetName == "OrgasmWidget"
            UD_VanillaWidgets[i].WidgetName = "player-orgasm"
        EndIf
    EndWhile
EndFunction

Function _UpdateShortcuts()
    _orgasmMeterIWW         = UDmain.UDWC._GetMeter("player-orgasm")
    _orgasmMeterSkyUi       = UDmain.UDWC._GetVanillaMeter("player-orgasm")
    _deviceMainMeterIWW     = UDmain.UDWC._GetMeter("device-main")
    _deviceMainMeterSkyUi   = UDmain.UDWC._GetVanillaMeter("device-main")
    _deviceSecMeterIWW      = UDmain.UDWC._GetMeter("device-condition")
    _deviceSecMeterSkyUi    = UDmain.UDWC._GetVanillaMeter("device-condition")
EndFunction

;/  Group: Initialization
===========================================================================================
===========================================================================================
===========================================================================================
/; 

bool _ReloadMutex = False
;/  Function: OnUIReload

    In this function, the interface is reloaded:
    - after loading the save;
    - after changing the interface rendering method: standard or using iWW.
    
    To add initialization of your own controls, use mod event UD_AfterUIReload.
    
    Parameters:

        abGameLoad               - True if function called on game reload.
/;
Function OnUIReload(Bool abGameLoad)
    if _ReloadMutex
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::OnUIReload() abGameLoad = " + abGameLoad + ", already reloading, aborting",3)
        endif
        return
    endif
    _ReloadMutex = True
    if UDmain.TraceAllowed()
        UDMain.Log("UD_WidgetControl::OnUIReload() abGameLoad = " + abGameLoad,3)
    endif
    StatusEffect_Register("dd-piercing-nipples", W_ICON_CLUSTER_DEVICES)
    StatusEffect_Register("dd-plug-vaginal", W_ICON_CLUSTER_DEVICES)
    StatusEffect_Register("dd-piercing-clit", W_ICON_CLUSTER_DEVICES)
    StatusEffect_Register("dd-plug-anal", W_ICON_CLUSTER_DEVICES)
    StatusEffect_Register("dd-plug-anal-inflation", W_ICON_CLUSTER_DEVICES)
    StatusEffect_Register("dd-plug-vag-inflation", W_ICON_CLUSTER_DEVICES)
    StatusEffect_Register("effect-exhaustion", W_ICON_CLUSTER_EFFECTS)
    StatusEffect_Register("effect-orgasm", W_ICON_CLUSTER_EFFECTS)
    
    if UDmain.UseiWW()
        GoToState("iWidgetInstalled")
        Int i = UD_VanillaWidgets.Length
        While i > 0
            i -= 1
            UD_VanillaWidgets[i].Hide(True)
        EndWhile
        Meter_Register("device-main", "icon-meter-struggle")
        Meter_Register("player-orgasm", "icon-meter-orgasm")
        Meter_Register("device-condition", "icon-meter-condition")
        InitWidgetsRequest(abGameLoad = abGameLoad, abMeters = True, abIcons = True, abText = True)
    else
        GoToState("")
        ; arranging vanilla widgets
        Int i = 0
        Float loc_posOffset = 0.0
        While i < UD_VanillaWidgets.Length
            UD_VanillaWidgets[i].PositionX = _WidgetXPos
            UD_VanillaWidgets[i].PositionY = _WidgetYPos
            UD_VanillaWidgets[i].PositionYOffset = loc_posOffset
            loc_posOffset += 1.5
            i += 1
        EndWhile
    endif
    
    Meter_SetColor("device-main", 0xFF005E, 0xFF307C, 0)
    Meter_SetColor("device-condition", 0x4df319, 0x62ff00, 0)
    Meter_SetColor("player-orgasm", 0xE727F5, 0xF775FF, 0xFF00BC)
    
    SendModEvent("UD_AfterUIReload", "", UDmain.UseiWW() as Float)
    
    _UpdateShortcuts()
    _ReloadMutex = False
EndFunction

; should be called before placing widgets
Function RefreshCanvasMetrics()
    if UDmain.TraceAllowed()
        UDMain.Log("UD_WidgetControl::RefreshCanvasMetrics()", 3)
    endif

    Float hud_padding = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefY")
    Float hud_left = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefX")
    Float hud_right = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefX")
    
    Float le_corr1 = 0
    Float le_corr2 = 35
    
    ; SE or LE
    ; minor formula corrections for LE version
    If SKSE.GetVersion() == 1
        le_corr1 = 50
    ElseIf SKSE.GetVersion() == 2
        le_corr1 = 0
    EndIf
    ; screen width factor: 16:9 is 1.0, 21:9 is 1.3125, etc.
    WideScreenFactor = ((hud_right - hud_left) + 2 * hud_padding - le_corr1) / (1280 - le_corr1)
    
    CanvasWidth = (1280 * WideScreenFactor) as Int
    CanvasHeight = 720
    HUDMeterWidth = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._width")
    HUDMeterHeight = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._height")
    HUDMeterWidthRef = 248.0
    HUDMeterHeightRef = 15.0
    HUDPaddingX = 48.0 + hud_padding
    HUDPaddingY = hud_padding
EndFunction

; request to init widgets (see OnUpdate function)
Bool _InitMetersRequested = False
Bool _InitIconsRequested = False
Bool _InitTextRequested = False
Bool _InitAfterLoadGame = False

;/  Function: InitWidgetsRequest

    Function for asynchronous interface rebuilding. The interface will be rebuilt in the next OnUpdate function call.
    
    Used if the interface is rendered with iWW.
    
    Parameters:
        abGameLoad        - Indicates that the function is called immediately after loading the game. 
                            It is means that saved widget IDs from iWW are not valid and must be recreated without attempting to delete old instances.
        abMeters          - Request to rebuild meter widgets.
        abIcons           - Request to rebuild icons.
        abText            - Request to rebuild notification lines.
/;
Function InitWidgetsRequest(Bool abGameLoad = False, Bool abMeters = False, Bool abIcons = False, Bool abText = False)
    if UDmain.TraceAllowed()
        UDmain.Log("UD_WidgetControl::InitWidgetsRequest() abGameLoad = " + abGameLoad + " , abMeters = " + abMeters + " , abIcons = " + abIcons + " , abText = " + abText,3)
    endif
    _InitAfterLoadGame      = _InitAfterLoadGame    || abGameLoad
    _InitMetersRequested    = _InitMetersRequested  || abMeters
    _InitIconsRequested     = _InitIconsRequested   || abIcons
    _InitTextRequested      = _InitTextRequested    || abText
    _CheckInitWidgets()
EndFunction

; Rebuild meter widgets
; abGameLoad        - if it called after game load
Bool Function InitMeters(Bool abGameLoad = False)
EndFunction

; Rebuild icons
; abGameLoad        - if it called after game load
Bool Function InitIcons(Bool abGameLoad = False)
EndFunction
; Rebuild text lines
; abGameLoad        - if it called after game load
Bool Function InitText(Bool abGameLoad = False)
EndFunction

; Sets all settings to its default values
Function ResetToDefault()
    UD_UseIWantWidget               = True
    UD_EnableDeviceIcons            = True
    UD_EnableDebuffIcons            = True
    UD_EnableCNotifications         = True
    UD_TextFontSize                 = 24
    UD_TextLineLength               = 100
    UD_TextReadSpeed                = 20
    UD_FilterVibNotifications       = True
    UD_TextAnchor                   = W_POSY_BELOWCENTER
    UD_TextPadding                  = 0
    UD_IconsSize                    = 60
    UD_IconsAnchor                  = W_POSX_CENTER
    UD_IconsPadding                 = 0
    
    UD_WidgetXPos                   = W_POSX_RIGHT
    UD_WidgetYPos                   = W_POSY_BOTTOM
EndFunction

; Array with slots for meter widgets
UD_WidgetMeter_RefAlias[]           Property    MeterSlots            Auto
{Array with slots for meter widgets}

Bool _iWidget_MeterPosFix                   = True  ; enables fix for the meter setPos-setMeterPercent conflict

Float       _Animation_LastGameTime                 ; last time of the animation frame
Float       _Animation_Update               = 0.5   ; animation update period
Float       _Animation_UpdateInstant        = 0.1   ; instant update

Int[]       _Text_LinesId                           ; notification lines widgets IDs
Int[]       _Text_LinesOutlineId                    ; outlines
Int         _Text_AnimStage                 = -1    ; animation stage of notification lines
Float       _Text_Timer                             ; animation timer of notification lines
Float       _Text_Duration                          ; how long to display text on the screen

String[]    _Text_Queue_String                      ; notifications queue: text
Int[]       _Text_Queue_Color                       ; notifications queue: color

; Array with slots for status effect icons
UD_WidgetStatusEffect_RefAlias[]    Property    StatusEffectSlots     Auto
{Array with slots for status effect icons}

Int         _Widget_Icon_Inactive_Color             = 0xFFFFFF      ; Gray          Color of innactive effect
Int         _Widget_Icon_Active0_Color              = 0xFFFF00      ; Yellow        Color of active effect with magnitude 0
Int         _Widget_Icon_Active50_Color             = 0xFF0000      ; Red           Color of active effect with magnitude 50
Int         _Widget_Icon_Active100_Color            = 0xFF00FF      ; Magenta       Color of active effect with magnitude 100

Event OnBeginState()
    RegisterForSingleUpdate(30.0)
EndEvent
    
Function UpdateGroupPositions()
EndFunction

;/
    Widget API
/;

;/  Group: Meter Widgets API
===========================================================================================
===========================================================================================
===========================================================================================
/; 

;/  Function: Meter_Register

    Registers new meter widget. 
    
    Although this method will work even in standard render mode, but to display a new widget, you will need to switch to iWW rendering mode.
    
    Parameters:
        asName            - Meter name.
        asIcon            - Icon's name.
/;
Function Meter_Register(String asName, String asIcon = "")
    ;UDMain.Info("UD_WidgetControl::Meter_Register() asName = " + asName + ", asIcon = " + asIcon)
    UD_WidgetMeter_RefAlias loc_data = _GetMeter(asName)
    If loc_data == None
        Return
    EndIf
    Bool need_init = loc_data.IsNew
    loc_data.IsNew = False
    loc_data.IconName = asIcon
    If need_init
        InitWidgetsRequest(abMeters = True)
    EndIf
EndFunction

;/  Function: Meter_SetVisible

    Changes meter visibility.
    
    Parameters:
        asName            - Meter name.
        abVisible         - If true then meter becomes visible.
/;
Function Meter_SetVisible(String asName, Bool abVisible)
    UD_WidgetBase loc_widget = _GetVanillaMeter(asName)
    If loc_widget == None
        Return
    EndIf
    if abVisible
        loc_widget.show(true)
    else
        loc_widget.hide(true)
    endif
EndFunction

;/  Function: Meter_SetFillPercent

    Changes the filling of the indicator.
    
    Parameters:
        asName            - Meter name.
        afValue           - Value to fill the meter's bar in percents (0.0 ... 100.0).
        abForce           - Instant change of the value (applied only in standard rendering mode).
/;
Function Meter_SetFillPercent(String asName, Float afValue, Bool abForce = false)
    UD_WidgetBase loc_widget = _GetVanillaMeter(asName)
    If loc_widget == None
        Return
    EndIf
    loc_widget.SetPercent(afValue / 100.0, abForce)
EndFunction

;/  Function: Meter_SetColor

    Sets meter's bar color and flash color.
    
    Parameters:
        asName            - Meter name.
        aiColor           - Primary color of the meter.
        aiColor2          - Secondary color of the meter.
        aiFlashColor      - Flash color of the meter.
/;
Function Meter_SetColor(String asName, Int aiColor, Int aiColor2 = 0, Int aiFlashColor = 0xFFFFFF)
    UD_WidgetBase loc_widget = _GetVanillaMeter(asName)
    If loc_widget == None
        Return
    EndIf
    loc_widget.SetColors(aiColor, aiColor2, aiFlashColor)
EndFunction

;/  Function: Meter_Flash

    Causes meter to flash.
    
    Parameters:
        asName            - Meter name.
/;
Function Meter_Flash(String asName)
    UD_WidgetBase loc_widget = _GetVanillaMeter(asName)
    If loc_widget == None
        Return
    EndIf
    loc_widget.Flash()
EndFunction

;/  Function: Meter_SetIcon

    Sets small icon next to the meter widget. Works only in iWW rendering mode.
    
    Parameters:
        asMeterName          - Meter name.
        asIconName           - Icon file name (relative to folder "<Data>\interface\exported\widgets\iwant\widgets\library").
/;
Function Meter_SetIcon(String asMeterName, String asIconName)
    
EndFunction

;/  Function: Meter_SetInterValue
    Changes meter internal value without updating its widget
    
    Parameters:
        asMeter  - meter name/alias (for example device-main)
        afValue  - New meter value
/;
Function Meter_SetInterValue(string asMeter,Float afValue)
    _GetVanillaMeter(asMeter).SetInterPercent(afValue)
EndFunction

;/  Function: Meter_RegisterNative
    Register meter to be used with native library
    
    Use <Meter_UnRegisterNative> to unregister registered meter
    
    Parameters:
        asMeter  - meter name/alias (for example device-main)
        afValue  - inital value that meter will be forced to. Have to be in range from 0.0 to 100.0
        afRate   - inital rate that meter will use to update its value. Rate is in value per second. Can be both positive and negative
        abToggle - if meter be toggled on or off after initiazation
/;
Function Meter_RegisterNative(string asMeter,float afValue,float afRate,bool abToggle = true)
    UD_Native.AddMeterEntrySkyUi(_GetVanillaMeter(asMeter).WidgetRoot,asMeter, afValue, afRate, abToggle)
EndFunction

;/  Function: Meter_UnRegisterNative
    Unregister registered meter from native library
    
    Parameters:
        asMeter  - meter name/alias (for example device-main)
/;
Function Meter_UnregisterNative(string asMeter)
    UD_Native.RemoveMeterEntrySkyUi(_GetVanillaMeter(asMeter).WidgetRoot)
EndFunction

;/  Function: Meter_UnRegisterNative
    Unregister all registered meters from native library
    
    Returns:
        Number of unregistered meters
/;
Int Function Meter_UnregisterAllNative()
    UD_Native.RemoveAllMeterEntries()
EndFunction

;/  Function: Meter_ToggleNative
    Toggle native meter, stopping it from updating its value.
    
    Meter have to be first registered with <Meter_RegisterNative> before this function can be used
    
    Parameters:
        asMeter  - meter name/alias (for example device-main)
        abToggle - *True*=Meter update will enabled OK,*False*=Meter update will be disabled
/;
Function Meter_ToggleNative(string asMeter,bool abToggle)
    UD_Native.ToggleMeterSkyUi(_GetVanillaMeter(asMeter).WidgetRoot,abToggle)
EndFunction

;/  Function: Meter_SetNativeRate
    Set the rate of the registered native meter to new value
    
    Meter have to be first registered with <Meter_RegisterNative> before this function can be used
    
    Parameters:
        asMeter  - meter name/alias (for example device-main)
        afRate   - new rate that meter will use to update its value. Rate is in value per second. Can be both positive and negative
/;
Function Meter_SetNativeRate(string asMeter,float afRate)
    UD_Native.SetMeterRateSkyUi(_GetVanillaMeter(asMeter).WidgetRoot,afRate)
EndFunction

;/  Function: Meter_SetNativeMult
    Set the multiplier of the registered native meter to new value
    
    Meter have to be first registered with <Meter_RegisterNative> before this function can be used
    
    Parameters:
        asMeter  - meter name/alias (for example device-main)
        afMult   - new multiplier for meter rate
/;
Function Meter_SetNativeMult(string asMeter,float afMult)
    UD_Native.SetMeterMultSkyUi(_GetVanillaMeter(asMeter).WidgetRoot,afMult)
EndFunction

;/  Function: Meter_GetNativeValue
    Get the rate of the registered native meter
    
    Meter have to be first registered with <Meter_RegisterNative> before this function can be used
    
    Parameters:
        asMeter  - meter name/alias (for example device-main)
    
    Returns:
        current value of the meter. Is always in range from 0.0 to 100.0!
/;
Float Function Meter_GetNativeValue(string asMeter)
    return UD_Native.GetMeterValueSkyUi(_GetVanillaMeter(asMeter).WidgetRoot)
EndFunction

;/  Function: Meter_SetNativeValue
    Set the value of the registered native meter to new value
    
    Meter have to be first registered with <Meter_RegisterNative> before this function can be used
    
    Parameters:
        asMeter  - meter name/alias (for example device-main)
        afValue  - New meter value
/;
Function Meter_SetNativeValue(string asMeter, Float afValue)
    return UD_Native.SetMeterValueSkyUi(_GetVanillaMeter(asMeter).WidgetRoot,afValue)
EndFunction

;/  Function: Meter_UpdateNativeValue
    Updates value of registered meter
    
    Meter have to be first registered with <Meter_RegisterNative> before this function can be used
    
    Parameters:
        asMeter  - meter name/alias (for example device-main)
        afDiff   - By how much should be value updated
        
    Returns:
        New updated value
/;
Float Function Meter_UpdateNativeValue(string asMeter,Float afDiff)
    return UD_Native.UpdateMeterValueSkyUi(_GetVanillaMeter(asMeter).WidgetRoot,afDiff)
EndFunction

;/  Group: Notifications API
===========================================================================================
===========================================================================================
===========================================================================================
/; 

;/  Function: Notification_Push

    Adds a text notification to the queue.
    
    In the standard rendering mode, this notification will be displayed in the usual form at the top left corner of the screen.
    
    In iWW rendering mode, notifications will be displayed according to the settings of this module.
    
    Parameters:
        asText              - A text notification to be added to the queue.
        aiColor             - color of the text (applies only if iWW is used).
/;
Function Notification_Push(String asText, Int aiColor = 0xFFFFFF)
    Debug.Notification(asText)
EndFunction

;/  Function: Notification_Reset

    Function clears the notification queue. Works only in iWW rendering mode.
/;
Function Notification_Reset()
EndFunction

;/  Group: Status Effect API
===========================================================================================
===========================================================================================
===========================================================================================
/; 

;/  Function: StatusEffect_Register

    Register new status effect (or change existing). Status effect will use icon from "<Data>\interface\exported\widgets\iwant\widgets\library" folder with the same name. 
    If an icon variant is also specified (see <aiVariant> argumet), it will be added to the effect name to get the file name.
    For example. 
        If asName is "effect-exhaustion" and aiVariant equals 2, then file name will be "effect-exhaustion-2.dds".
        If asName is "effect-orgasm" and aiVariant equals 0, then file name will be "effect-orgasm.dds".
    
    Although this method will work even in standard render mode, but to see effect from it, you will need to switch to iWW rendering mode.
    
    Parameters:
        asName        - Effect name (and base part of the icon file name).
        aiVariant     - Icon variant. If equal to -1, then the previous value is kept.
        aiClusterId   - Icon cluster (0 or 1 for device or effect cluster). If equal to -1, then the previous value is kept.
/;
Function StatusEffect_Register(String asName, Int aiClusterId = -1, Int aiVariant = -1)
    ;UDMain.Info("UD_WidgetControl::StatusEffect_Register() asName = " + asName + ", aiClusterId = " + aiClusterId + ", aiVariant = " + aiVariant)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
    If data == None
        Return
    EndIf
    Bool need_init = data.IsNew
    data.IsNew = False
    If (aiClusterId >= 0 && data.Cluster != aiClusterId)
        data.Cluster = aiClusterId
        need_init = True
    EndIf
    If (aiVariant >= 0 && data.Variant != aiVariant)
        data.Variant = aiVariant
        need_init = True
    EndIf
    If need_init
        InitWidgetsRequest(abIcons = True)
    EndIf
EndFunction

;/  Function: StatusEffect_Remove

    Removes status effect registration.
    
    Although this method will work even in standard render mode, but to see effect from it, you will need to switch to iWW rendering mode.
    
    Parameters:
        asName        - Effect name.
/;
Function StatusEffect_Remove(String asName)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName, abFindEmpty = False)
    If data != None
        data.Reset()
    EndIf
EndFunction

;/  Function: StatusEffect_GetVariant

    Returns the currently used variant of the icon.
        
    Parameters:
        asName        - Effect name.
        
    Returns:
        Icon variant or -1 if an effect with specified name was not found.
/;
Int Function StatusEffect_GetVariant(String asName)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName, abFindEmpty = False)
    If data == None
        Return -1
    EndIf
    Return data.Variant
EndFunction

;/  Function: StatusEffect_SetVisible

    Shows or hides status effect icon.
    
    Although this method will work even in standard render mode, but to see effect from it, you will need to switch to iWW rendering mode.
    
    Parameters:
        asName        - Effect name.
        abVisible     - Visibility.
/;
Function StatusEffect_SetVisible(String asName, Bool abVisible = True)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
    If data == None 
        Return
    EndIf
    data.Visible = abVisible
    If !abVisible
        data.Blinking = False
    EndIf
EndFunction

;/  Function: StatusEffect_SetMagnitude

    Sets magnitude of the effect. The color of the icon changes depending on the value.
    
    Although this method will work even in standard render mode, but to see effect from it, you will need to switch to iWW rendering mode.
    
    Parameters:
        asName              - Effect name.
        aiMagnitude         - Magnitude.
/;
Function StatusEffect_SetMagnitude(String asName, Int aiMagnitude)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
    If data == None 
        Return
    EndIf
    data.Magnitude = aiMagnitude
EndFunction

;/  Function: StatusEffect_AdjustMagnitude

    Adjusts magnitude by the given value. The color of the icon changes depending on the value.
    
    Although this method will work even in standard render mode, but to see effect from it, you will need to switch to iWW rendering mode.
    
    Parameters:
        asName                  - Effect name.
        aiAdjustValue           - Adjust value.
        abControlVisibility     - If true and magnitude is 0, then the icon will be hidden. If true and magnitude > 0, then the icon will be shown.
/;
Function StatusEffect_AdjustMagnitude(String asName, Int aiAdjustValue, Bool abControlVisibility = True)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
    If data == None 
        Return
    EndIf
    data.Magnitude += aiAdjustValue
    If data.Magnitude < 0
        data.Magnitude = 0
    EndIf
    If abControlVisibility
        data.Visible = data.Magnitude > 0
    EndIf
EndFunction

;/  Function: StatusEffect_SetBlink

    Sets icon blinking (periodic change of alpha in range 25 .. 100).
    
    Although this method will work even in standard render mode, but to see effect from it, you will need to switch to iWW rendering mode.
    
    Parameters:
        asName                  - Effect name.
        abBlink                 - Blink.
/;
Function StatusEffect_SetBlink(String asName, Bool abBlink = True)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
    If data == None 
        Return
    EndIf
    data.Blinking = abBlink
EndFunction

;/  Function: StatusEffect_ResetValues

    Resets all effects to default state
    
    Although this method will work even in standard render mode, but to see effect from it, you will need to switch to iWW rendering mode.
/;
Function StatusEffect_ResetValues()
    Int i = StatusEffectSlots.Length
    While i > 0
        i -= 1
        StatusEffectSlots[i].SoftReset()
    EndWhile
EndFunction

; Show all enabled (!) widgets with test animations for the short time
Function TestWidgets()
    
    Int len = UD_VanillaWidgets.Length
    Int i = 0
    While i < len
        If UD_VanillaWidgets[i] != None
            UD_VanillaWidgets[i].Show(true)
            UD_VanillaWidgets[i].SetPercent(Utility.RandomFloat(0.0, 1.0), False)
        EndIf
        i += 1
    EndWhile
        
    Utility.Wait(5.0)
    
    len = UD_VanillaWidgets.Length
    i = 0
    While i < len
        If UD_VanillaWidgets[i] != None
            UD_VanillaWidgets[i].Hide(true)
        EndIf
        i += 1
    EndWhile
EndFunction

;/
    End of Widget API
/;

Function _UpdateMeterColor(Int aiId,int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
EndFunction
Int[] Function _AddMeterWidget(Int[] aaiGroup, Int aiWidget, Float fVerticalOffset, Int akPerc = 0, Int akCol1 = 0x0, Int akCol2 = 0x0, Int akCol3 = 0xFFFFFFFF)
EndFunction
Function _SetIconRGB(Int aiWidget, Int aiRGB)
EndFunction
Function _SetTextRGB(Int aiWidget, Int aiColor)
EndFunction
Function _AnimateWidgets()
EndFunction
Function _AnimateNotifications(Float frame)
EndFunction
Function _AnimateIcons(Float frame)
EndFunction
Bool Function _NextNotification()
EndFunction
Function _AddTextLineWidget()
EndFunction

UD_WidgetBase Function _GetVanillaMeter(String asName)
    Int i = UD_VanillaWidgets.Length
    While i > 0
        i -= 1
        If UD_VanillaWidgets[i].WidgetName == asName
            Return UD_VanillaWidgets[i]
        EndIf
    EndWhile
    if UDmain.TraceAllowed()
        UDMain.Log("UD_WidgetControl::_GetVanillaMeter() Can't find vanilla widget with the name " + asName)
    endif
    Return None
EndFunction

Bool _FindEmptySE_Mutex = False

UD_WidgetStatusEffect_RefAlias Function _GetStatusEffect(String asName, Bool abFindEmpty = True)
    Int loc_index = 0
    While loc_index < StatusEffectSlots.Length
        If StatusEffectSlots[loc_index].Name == asName
            Return StatusEffectSlots[loc_index]
        EndIf
        loc_index += 1
    EndWhile
    If abFindEmpty
    ; first empty slot
        If _FindEmptySE_Mutex
            loc_index = 0
            While loc_index < 20 && _FindEmptySE_Mutex
                Utility.Wait(0.05)
                loc_index += 1
            EndWhile
        EndIf
        _FindEmptySE_Mutex = True
        loc_index = 0
        While loc_index < StatusEffectSlots.Length
            If StatusEffectSlots[loc_index].Name == ""
                StatusEffectSlots[loc_index].Reset()
                StatusEffectSlots[loc_index].Name = asName
                _FindEmptySE_Mutex = False
                Return StatusEffectSlots[loc_index]
            EndIf
            loc_index += 1
        EndWhile
        _FindEmptySE_Mutex = False
        UDMain.Warning("UD_WidgetControl::_GetStatusEffect() No more slots for the status effect icons!")
    EndIf
    Return None
EndFunction

Bool _CreateIcon_Mutex = False

Function _CreateIconWidget(UD_WidgetStatusEffect_RefAlias akData, Int aiX, Int aiY, Int aiAlpha, Bool abForceDestory = False)
EndFunction

Function _DestroyIconWidget(UD_WidgetStatusEffect_RefAlias akData)
EndFunction

Bool _FindEmptyME_Mutex = False

UD_WidgetMeter_RefAlias Function _GetMeter(String asName, Bool abFindEmpty = True)
    Int loc_index = 0
    While loc_index < MeterSlots.Length
        If MeterSlots[loc_index].Name == asName
            Return MeterSlots[loc_index]
        EndIf
        loc_index += 1
    EndWhile
    If abFindEmpty
    ; first empty slot
        If _FindEmptyME_Mutex
            loc_index = 0
            While loc_index < 20 && _FindEmptyME_Mutex
                Utility.Wait(0.05)
                loc_index += 1
            EndWhile
        EndIf
        _FindEmptyME_Mutex = True
        loc_index = 0
        While loc_index < MeterSlots.Length
            If MeterSlots[loc_index].Name == ""
                MeterSlots[loc_index].Reset()
                MeterSlots[loc_index].Name = asName
                _FindEmptyME_Mutex = False
                Return MeterSlots[loc_index]
            EndIf
            loc_index += 1
        EndWhile
        _FindEmptyME_Mutex = False
        UDMain.Warning("UD_WidgetControl::_GetMeter() No more slots for the meters!")
    EndIf
    Return None
EndFunction

Bool _CreateMeter_Mutex = False

Function _CreateMeterWidget(UD_WidgetMeter_RefAlias akData, Int aiX, Int aiY, Bool abForceDestory = False)
EndFunction

Function _DestroyMeterWidget(UD_WidgetMeter_RefAlias akData)
EndFunction

Function _CheckInitWidgets()
EndFunction

Bool _InitWidgetMutex = False
Bool _InitMetersMutex = False
Bool _OnUpdateMutex = False
;Use iWidget instead
State iWidgetInstalled

    Event OnBeginState()
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::OnBeginState() State = " + GetState(), 3)
        endif
        _Animation_LastGameTime = Utility.GetCurrentRealTime()
        RegisterForSingleUpdate(_Animation_Update)
    EndEvent
    
    Event OnUpdate()
        if !SingletonCheck()
            UnregisterForUpdate()
            return
        endif
        if UDmain.IsEnabled()
            If _OnUpdateMutex
                Return
            EndIf
            _OnUpdateMutex = True
            _CheckInitWidgets()
            _AnimateWidgets()
            RegisterForSingleUpdate(_Animation_Update)
            _OnUpdateMutex = False
        else
            if UDmain.TraceAllowed()
                UDmain.Log(self+"::OnUpdate - Main mod is updating - skipping",3)
            endif
            RegisterForSingleUpdate(5.0)
        endif
    EndEvent
    
    Function _CheckInitWidgets()
        if _InitWidgetMutex
            return
        endif
        _InitWidgetMutex = True
        If _InitMetersRequested || _InitIconsRequested || _InitTextRequested
            RefreshCanvasMetrics()
            If _InitMetersRequested
                _InitMetersRequested    = !InitMeters(_InitAfterLoadGame)
            EndIf
            If _InitTextRequested
                _InitTextRequested      = !InitText(_InitAfterLoadGame)
            EndIf
            If _InitIconsRequested
                _InitIconsRequested     = !InitIcons(_InitAfterLoadGame)
            EndIf
            _InitAfterLoadGame = False
        EndIf
        _InitWidgetMutex = False
    EndFunction
    
    Event OnEndState()
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::OnEndState() State = " + GetState(), 3)
        endif
        Int i = MeterSlots.Length
        While i > 0
            i -= 1
            If MeterSlots[i].Name != ""
                _DestroyMeterWidget(MeterSlots[i])
            EndIf
        EndWhile
        i = StatusEffectSlots.Length
        While i > 0
            i -= 1
            If StatusEffectSlots[i].Name != ""
                _DestroyIconWidget(StatusEffectSlots[i])
            EndIf
        EndWhile
    EndEvent
        
    Bool Function InitMeters(Bool abGameLoad = False)
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::InitMeters() abGameLoad = " + abGameLoad, 3)
        endif
        _InitMetersMutex = True
        Utility.Wait(0.2)                   ; waiting for the end of all UpdatePercent_***Widget calls
        If abGameLoad
        ; clearing all IDs without destroying
            Int i = MeterSlots.Length
            While i > 0
                i -= 1
                MeterSlots[i].Id = -1
            EndWhile
        EndIf
        
        UD_WidgetMeter_RefAlias data
        Int len = MeterSlots.Length
        Int i = 0
        Int loc_VertOffset = 0
        While i < len
            data = MeterSlots[i]
            If data.Name != ""
                data.PosX = CalculateGroupXPos(UD_WidgetXPos)
                data.PosY = (CalculateGroupYPos(UD_WidgetYPos) - loc_VertOffset) As Int
                _CreateMeterWidget(data, data.PosX, data.PosY)
                If UD_WidgetYPos == W_POSY_TOP
                    loc_VertOffset -= (UD_MeterVertPadding * HUDMeterHeightRef) as Int
                Else
                    loc_VertOffset += (UD_MeterVertPadding * HUDMeterHeightRef) as Int
                EndIf
            EndIf
            i += 1
        EndWhile
        
        _InitMetersMutex = False
        Return True
    EndFunction
    
    Bool Function InitText(Bool abGameLoad = False)
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::InitText() abGameLoad = " + abGameLoad, 3)
        endif
        If abGameLoad
        ; clearing IDs on game load since all widgets are already destroyed
            _Text_LinesId = PapyrusUtil.IntArray(0)
            _Text_LinesOutlineId = PapyrusUtil.IntArray(0)
        EndIf
        If _Text_LinesId.Length == 0
            _AddTextLineWidget()
        EndIf
        Int i = 0
        While i < _Text_LinesId.Length
            Int text_id = _Text_LinesId[i]
            Int outline_id = _Text_LinesOutlineId[i]
            If UD_TextAnchor >= 0 && UD_TextAnchor < 4
                iWidget.setPos(text_id, CalculateGroupXPos(W_POSX_CENTER), (CalculateGroupYPos(UD_TextAnchor) + UD_TextPadding + 1.5 * UD_TextFontSize * i) as Int)
                iWidget.setPos(outline_id, CalculateGroupXPos(W_POSX_CENTER) + UD_TextOutlineShift, (CalculateGroupYPos(UD_TextAnchor) + UD_TextPadding + 1.5 * UD_TextFontSize * i) as Int + UD_TextOutlineShift)
            Else
                UDMain.Warning("UD_WidgetControl::InitText() Unsupported value UD_TextAnchor = " + UD_TextAnchor)
            EndIf
            iWidget.setVisible(text_id, 0)
            iWidget.setTransparency(text_id, 0)
            i += 1
        EndWhile
        _Text_AnimStage = -1
        _Text_Timer = 0.0
        _Text_Duration = 0.0
        
        Return True
    EndFunction
    
    Function _AddTextLineWidget()
        Int outline_id = iWidget.loadText("", size = UD_TextFontSize)
        Int text_id = iWidget.loadText("", size = UD_TextFontSize)
        _Text_LinesId = PapyrusUtil.PushInt(_Text_LinesId, text_id)
        _Text_LinesOutlineId = PapyrusUtil.PushInt(_Text_LinesOutlineId, outline_id)
        If UD_TextAnchor >= 0 && UD_TextAnchor < 4
            iWidget.setPos(text_id, CalculateGroupXPos(W_POSX_CENTER), (CalculateGroupYPos(UD_TextAnchor) + UD_TextPadding + 1.5 * UD_TextFontSize * (_Text_LinesId.Length - 1)) as Int)
            iWidget.setPos(outline_id, CalculateGroupXPos(W_POSX_CENTER) + UD_TextOutlineShift, (CalculateGroupYPos(UD_TextAnchor) + UD_TextPadding + 1.5 * UD_TextFontSize * (_Text_LinesId.Length - 1)) as Int + UD_TextOutlineShift)
        Else
            UDMain.Warning("UD_WidgetControl::_AddTextLineWidget() Unsupported value UD_TextAnchor = " + UD_TextAnchor)
        EndIf
        iWidget.setVisible(text_id, 0)
        iWidget.setTransparency(text_id, 0)
    EndFunction
    
    Bool Function InitIcons(Bool abGameLoad = False)
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::InitIcons() abGameLoad = " + abGameLoad,3)
        endif
        If abGameLoad
        ; clearing IDs on game load since all widgets are already destroyed
            Int i = StatusEffectSlots.Length
            While i > 0
                i -= 1
                StatusEffectSlots[i].Id = -1
                StatusEffectSlots[i].AuxId = -1
            EndWhile
        EndIf
        UD_WidgetStatusEffect_RefAlias data
        ; counting icons in clusters
        Int cluster0_count = 0
        Int cluster1_count = 0
        Int len = StatusEffectSlots.Length
        Int i = 0
        While i < len
            data = StatusEffectSlots[i]
            If data.Name != ""
                If data.Cluster == W_ICON_CLUSTER_DEVICES
                    cluster0_count += 1
                ElseIf data.Cluster == W_ICON_CLUSTER_EFFECTS
                    cluster1_count += 1
                EndIf
            EndIf
            i += 1
        EndWhile
         
        Int index0 = 0
        Int index1 = 0
        If UD_IconsAnchor == W_POSX_LEFT
            ; Left icons position
            ;
            ;          ###     ###
            ;          ###     ###
            ;               
            ;          ###     ###
            ;          ###     ###
            ;
            ;     X         A
            ;
            ;              ###
            ;              ###
            ;
            ;              ###
            ;              ###
            ;
            ; X = Left-Center Anchor
            ; A = Anchor + Hor. Padding
            
            i = 0
            While i < len
                data = StatusEffectSlots[i]
                If data.Name != ""
                    If data.Cluster == W_ICON_CLUSTER_DEVICES                                       ; device cluster
                        data.PosX = CalculateGroupXPos(W_POSX_LEFT) + UD_IconsPadding + (UD_IconsSize * (-0.55 + 1.1 * (index0 % 2))) As Int
                        data.PosY = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (-1.1 * (cluster0_count / 2) + 1.1 * (index0 / 2))) As Int
                        data.Enabled = UD_EnableDeviceIcons
                        index0 += 1
                    ElseIf data.Cluster == W_ICON_CLUSTER_EFFECTS                                   ; effect cluster
                        data.PosX = CalculateGroupXPos(W_POSX_LEFT) + UD_IconsPadding + (UD_IconsSize * (-0.55 + 1.1 * (index1 % 2))) As Int
                        data.PosY = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (1.1 + 1.1 * (index1 / 2))) As Int
                        data.Enabled = UD_EnableDebuffIcons
                        index1 += 1
                    EndIf
                    _CreateIconWidget(data, data.PosX, data.PosY, 75)
                EndIf
                i += 1
            EndWhile
        ElseIf UD_IconsAnchor == W_POSX_CENTER
            ; Center icons position
            ;
            ;          ###     ###                          ###
            ;          ###     ###                          ###
            ;               A               X                B
            ;          ###     ###                          ###
            ;          ###     ###                          ###
            ;
            ; X = Crosshair
            ; A = Anchor - 300 - Hor. Padding
            ; B = Anchor + 300 + Hor. Padding
            
            i = 0
            While i < len
                data = StatusEffectSlots[i]
                If data.Name != ""
                    If data.Cluster == W_ICON_CLUSTER_DEVICES                                       ; device cluster
                        data.PosX = CalculateGroupXPos(W_POSX_CENTER) - 300 - UD_IconsPadding + (UD_IconsSize * (-0.55 + 1.1 * (index0 % 2))) As Int
                        data.PosY = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (-0.55 * (Math.Ceiling((cluster0_count as Float) / 2.0) - 1) + 1.1 * (index0 / 2))) As Int
                        data.Enabled = UD_EnableDeviceIcons
                        index0 += 1
                    ElseIf data.Cluster == W_ICON_CLUSTER_EFFECTS                                   ; effect cluster
                        data.PosX = CalculateGroupXPos(W_POSX_CENTER) + 300 + UD_IconsPadding + (UD_IconsSize * (-0.55 + 1.1 * (index1 % 2))) As Int
                        data.PosY = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (-0.55 * (Math.Ceiling((cluster1_count as Float) / 2.0) - 1) + 1.1 * (index1 / 2))) As Int
                        data.Enabled = UD_EnableDebuffIcons
                        index1 += 1
                    EndIf
                    _CreateIconWidget(data, data.PosX, data.PosY, 75)
                EndIf
                i += 1
            EndWhile
        ElseIf UD_IconsAnchor == W_POSX_RIGHT
            ; mirrored version of the left layout
            i = 0
            While i < len
                data = StatusEffectSlots[i]
                If data.Name != ""
                    If data.Cluster == W_ICON_CLUSTER_DEVICES                                       ; device cluster
                        data.PosX = CalculateGroupXPos(W_POSX_RIGHT) - UD_IconsPadding - (UD_IconsSize * (-0.55 + 1.1 * (index0 % 2))) As Int
                        data.PosY = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (-1.1 * (cluster0_count / 2) + 1.1 * (index0 / 2))) As Int
                        data.Enabled = UD_EnableDeviceIcons
                        index0 += 1
                    ElseIf data.Cluster == W_ICON_CLUSTER_EFFECTS                                   ; effect cluster
                        data.PosX = CalculateGroupXPos(W_POSX_RIGHT) - UD_IconsPadding - (UD_IconsSize * (-0.55 + 1.1 * (index1 % 2))) As Int
                        data.PosY = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (1.1 + 1.1 * (index1 / 2))) As Int
                        data.Enabled = UD_EnableDebuffIcons
                        index1 += 1
                    EndIf
                    _CreateIconWidget(data, data.PosX, data.PosY, 75)
                EndIf
                i += 1
            EndWhile
        Else
            UDMain.Warning("UD_WidgetControl::InitIcons() Unsupported value UD_IconsAnchor = " + UD_IconsAnchor)
        EndIf
        Return True
    EndFunction

    Function _CreateMeterWidget(UD_WidgetMeter_RefAlias akData, Int aiX, Int aiY, Bool abForceDestory = False)
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::_CreateMeterWidget() akData = " + akData + ", aiX = " + aiX + ", aiY = " + aiY + ", abForceDestory = " + abForceDestory, 3)
        endif
        If akData == None || akData.Name == ""
            Return
        EndIf
        If _CreateMeter_Mutex
            Int i = 0
            While i < 20 && _CreateMeter_Mutex
                Utility.Wait(0.05)
                i += 1
            EndWhile
        EndIf
        _CreateMeter_Mutex = True

        If akData.Id > 0 && (_iWidget_MeterPosFix || abForceDestory)
            iWidget.destroy(akData.Id)
            akData.Id = -1
        EndIf
        If akData.Id < 0
            akData.Id = iWidget.loadMeter()
            ; iWidget.setSize(akData.Id, HUDMeterHeight as Int, HUDMeterWidth as Int)
            iWidget.setZoom(akData.Id, 67, 67)
        EndIf
        iWidget.setPos(akData.Id, aiX, aiY)
        iWidget.setMeterPercent(akData.Id, akData.FillPercent)
        iWidget.setVisible(akData.Id, akData.Visible as Int)
        _UpdateMeterColor(akData.Id, akData.PrimaryColor, akData.SecondaryColor, akData.FlashColor)
        
        If akData.IconId > 0
            iWidget.destroy(akData.IconId)
            akData.IconId = -1
        EndIf
        
        If akData.IconName != ""
            akData.IconId = iWidget.loadLibraryWidget(akData.IconName)
            iWidget.setSize(akData.IconId, HUDMeterHeightRef as Int, HUDMeterHeightRef as Int)
            iWidget.setPos(akData.IconId, (akData.PosX - HUDMeterWidthRef / 2 - HUDMeterHeightRef * 1.5 - 10) as Int, akData.PosY)
            iWidget.setTransparency(akData.IconId, 75)
            iWidget.setVisible(akData.IconId, akData.Visible as Int)
            _SetIconRGB(akData.IconId, 0)
        EndIf
        _CreateMeter_Mutex = False
    EndFunction

    Function _DestroyMeterWidget(UD_WidgetMeter_RefAlias akData)
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::_DestroyMeterWidget() akData = " + akData, 3)
        endif
        If akData.IconId > 0
            iWidget.destroy(akData.IconId)
            akData.IconId = -1
        EndIf
        If akData.Id > 0
            iWidget.destroy(akData.Id)
            akData.Id = -1
        EndIf
    EndFunction
        
    ;use to convert from hex to this sinfull way of writting colors
    Function _UpdateMeterColor(Int aiId, int aiColor, int aiColor2 = 0, int aiFlashColor = 0xFFFFFF)
        Int loc_lightR  = Math.LogicalAnd(Math.RightShift(aiColor,16),0xFF)
        Int loc_lightG  = Math.LogicalAnd(Math.RightShift(aiColor,8),0xFF)
        Int loc_lightB  = Math.LogicalAnd(Math.RightShift(aiColor,0),0xFF)
        Int loc_darkR   = Math.LogicalAnd(Math.RightShift(aiColor2,16),0xFF)
        Int loc_darkG   = Math.LogicalAnd(Math.RightShift(aiColor2,8),0xFF)
        Int loc_darkB   = Math.LogicalAnd(Math.RightShift(aiColor2,0),0xFF)
        Int loc_flashR  = Math.LogicalAnd(Math.RightShift(aiFlashColor,16),0xFF)
        Int loc_flashG  = Math.LogicalAnd(Math.RightShift(aiFlashColor,8),0xFF)
        Int loc_flashB  = Math.LogicalAnd(Math.RightShift(aiFlashColor,0),0xFF)
        
        iWidget.setMeterRGB(aiId,loc_lightR,loc_lightG,loc_lightB,loc_darkR,loc_darkG,loc_darkB,loc_flashR,loc_flashG,loc_flashB)

    EndFunction
    
    Function Meter_SetVisible(String asName, Bool abVisible)
        UD_WidgetMeter_RefAlias loc_data = _GetMeter(asName, False)
        If loc_data == None
            Return
        EndIf
        loc_data.Visible = abVisible
        If _InitMetersMutex
            Return
        EndIf
        iWidget.setVisible(loc_data.Id, loc_data.Visible as Int)
        iWidget.setVisible(loc_data.IconId, loc_data.Visible as Int)
    EndFunction

    Function Meter_SetFillPercent(String asName, Float afValue, Bool abForce = false)
        UD_WidgetMeter_RefAlias loc_data = _GetMeter(asName, False)
        If loc_data == None
            Return
        EndIf
        loc_data.FillPercent = afValue as Int
        If _InitMetersMutex
            Return
        EndIf
        iWidget.setMeterPercent(loc_data.Id, loc_data.FillPercent)
    EndFunction

    Function Meter_SetColor(String asName, Int aiColor, Int aiColor2 = 0, Int aiFlashColor = 0xFFFFFF)
        UD_WidgetMeter_RefAlias loc_data = _GetMeter(asName, False)
        If loc_data == None
            Return
        EndIf
        If aiColor >= 0
            loc_data.PrimaryColor = aiColor
        EndIf
        If aiColor2 >= 0
            loc_data.SecondaryColor = aiColor2
        EndIf
        If aiFlashColor >= 0
            loc_data.FlashColor = aiFlashColor
        EndIf
        If _InitMetersMutex
            Return
        EndIf
        _UpdateMeterColor(loc_data.Id, loc_data.PrimaryColor, loc_data.SecondaryColor, loc_data.FlashColor)
    EndFunction

    Function Meter_Flash(String asName)
        UD_WidgetMeter_RefAlias loc_data = _GetMeter(asName, False)
        If loc_data == None
            Return
        EndIf
        If _InitMetersMutex
            Return
        EndIf
        iWidget.doMeterFlash(loc_data.Id)
    EndFunction
    
    Function Meter_SetIcon(String asMeterName, String asIconName)
        UD_WidgetMeter_RefAlias loc_data = _GetMeter(asMeterName, False)
        If loc_data == None
            Return
        EndIf
        If _InitMetersMutex
            if UDmain.TraceAllowed()
                UDMain.Log("UD_WidgetControl::Meter_SetIcon() _InitMetersMutex = " + _InitMetersMutex, 3)
            endif
            Return
        EndIf
        If loc_data.IconName == asIconName
            Return
        EndIf
        If loc_data.IconId > 0
            iWidget.destroy(loc_data.IconId)
            loc_data.IconId = -1
        EndIf
        loc_data.IconName = asIconName
        loc_data.IconId = iWidget.loadLibraryWidget(loc_data.IconName)
        iWidget.setSize(loc_data.IconId, HUDMeterHeightRef as Int, HUDMeterHeightRef as Int)
        iWidget.setPos(loc_data.IconId, (loc_data.PosX - HUDMeterWidthRef / 2 - HUDMeterHeightRef * 1.5 - 10) as Int, loc_data.PosY)
        iWidget.setTransparency(loc_data.IconId, 75)
        iWidget.setVisible(loc_data.IconId, loc_data.Visible as Int)
        _SetIconRGB(loc_data.IconId, 0)
    EndFunction
   
    Function Meter_SetInterValue(string asMeter,Float afValue)
        _GetMeter(asMeter).FillPercent = Round(afValue)
    EndFunction
    
    Function Meter_RegisterNative(string asMeter,float afValue,float afRate,bool abToggle = true)
        UD_Native.AddMeterEntryIWW(iWidget.WidgetRoot,_GetMeter(asMeter).id,asMeter, afValue, afRate, abToggle)
    EndFunction
    
    Function Meter_UnregisterNative(string asMeter)
        UD_Native.RemoveMeterEntryIWW(_GetMeter(asMeter).id)
    EndFunction
    
    Function Meter_ToggleNative(string asMeter,bool abToggle)
        UD_Native.ToggleMeterSkyUi(_GetMeter(asMeter).id,abToggle)
    EndFunction
    
    Function Meter_SetNativeRate(string asMeter,float afRate)
        UD_Native.SetMeterRateIWW(_GetMeter(asMeter).id,afRate)
    EndFunction
    
    Function Meter_SetNativeMult(string asMeter,float afMult)
        UD_Native.SetMeterMultIWW(_GetMeter(asMeter).id,afMult)
    EndFunction
    
    Float Function Meter_GetNativeValue(string asMeter)
        return UD_Native.GetMeterValueIWW(_GetMeter(asMeter).id)
    EndFunction

    Function Meter_SetNativeValue(string asMeter, Float afValue)
        UD_Native.SetMeterValueIWW(_GetMeter(asMeter).id,afValue)
    EndFunction

    Float Function Meter_UpdateNativeValue(string asMeter,Float afDiff)
        return UD_Native.UpdateMeterValueIWW(_GetMeter(asMeter).id,afDiff)
    EndFunction
   
    ; quickly push a string into array and leave the function
    Function Notification_Push(String asText, Int aiColor = 0xFFFFFF)
        If asText == ""
            Return
        EndIf
        
        ;check if IWW text is enabled or if menu is open (IWW doesn't work when menu is open)
        If !UD_EnableCNotifications || UDmain.IsAnyMenuOpen()
            Debug.Notification(asText)
            Return
        EndIf
        _Text_Queue_String = PapyrusUtil.PushString(_Text_Queue_String, asText)
        _Text_Queue_Color = PapyrusUtil.PushInt(_Text_Queue_Color, aiColor)
        RegisterForSingleUpdate(_Animation_UpdateInstant)
    EndFunction
    
    ; Clear notification queue
    Function Notification_Reset()
        _Text_Queue_String = PapyrusUtil.StringArray(0)
        _Text_Queue_Color = PapyrusUtil.IntArray(0)
    EndFunction

    Bool Function _NextNotification()
        If _Text_Queue_String.Length == 0
            Return False
        EndIf
        String str = _Text_Queue_String[0]
        Int color = _Text_Queue_Color[0]
        _Text_Queue_String = PapyrusUtil.SliceStringArray(_Text_Queue_String, 1)
        _Text_Queue_Color = PapyrusUtil.SliceIntArray(_Text_Queue_Color, 1)
        _Text_Duration = (StringUtil.GetLength(str) as Float) / (UD_TextReadSpeed as Float)
        str = str + " " 
        Int i = 0 
        Int len = StringUtil.GetLength(str)
        Int prev_space = -1
        Int line_start = 0
        Int text_line_index = 0
        While i < len
            If StringUtil.GetNthChar(str, i) == " "
                If UD_TextLineLength < (i - line_start)
                    If prev_space <= line_start         ; very long word 
                        prev_space = i
                    EndIf
                    If _Text_LinesId.Length <= text_line_index
                        _AddTextLineWidget()
                    EndIf
                    iWidget.setText(_Text_LinesId[text_line_index], StringUtil.Substring(str, line_start, prev_space - line_start))
                    _SetTextRGB(_Text_LinesId[text_line_index], color)
                    iWidget.setText(_Text_LinesOutlineId[text_line_index], StringUtil.Substring(str, line_start, prev_space - line_start))
                    _SetTextRGB(_Text_LinesOutlineId[text_line_index], 0)
                    text_line_index += 1
                    line_start = prev_space + 1
                EndIf
                prev_space = i
            EndIf
            i += 1
        EndWhile
        If line_start < prev_space
            If _Text_LinesId.Length <= text_line_index
                _AddTextLineWidget()
            EndIf
            iWidget.setText(_Text_LinesId[text_line_index], StringUtil.Substring(str, line_start, prev_space - line_start))
            _SetTextRGB(_Text_LinesId[text_line_index], color)
            iWidget.setText(_Text_LinesOutlineId[text_line_index], StringUtil.Substring(str, line_start, prev_space - line_start))
            _SetTextRGB(_Text_LinesOutlineId[text_line_index], 0)
            text_line_index += 1
        EndIf
        i = text_line_index
        While i < _Text_LinesId.Length
            iWidget.setText(_Text_LinesId[i], "")
            iWidget.setText(_Text_LinesOutlineId[i], "")
            i += 1
        EndWhile
        Return True
    EndFunction
    
    Function _CreateIconWidget(UD_WidgetStatusEffect_RefAlias akData, Int aiX, Int aiY, Int aiAlpha, Bool abForceDestory = False)
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::_CreateIconWidget() akData = " + akData + ", aiX = " + aiX + ", aiY = " + aiY + ", aiAlpha = " + aiAlpha,3)
        endif
        If akData == None || akData.Name == ""
            Return
        EndIf
        If _CreateIcon_Mutex
            Int i = 0
            While i < 20 && _CreateIcon_Mutex
                Utility.Wait(0.05)
                i += 1
            EndWhile
        EndIf
        _CreateIcon_Mutex = True

        If akData.Id > 0 && ((akData.Variant != akData.VariantLoaded) || abForceDestory)
            iWidget.destroy(akData.Id)
            akData.Id = -1
            if UDmain.TraceAllowed()
                UDMain.Log("UD_WidgetControl::_CreateIconWidget() destroy id = " + akData.Id,3)
            endif
        EndIf
        If akData.Id < 0
            akData.Id = iWidget.loadLibraryWidget(akData.FileName)
            akData.VariantLoaded = akData.Variant
            if UDmain.TraceAllowed()
                UDMain.Log("UD_WidgetControl::_CreateIconWidget() loadLibraryWidget id = " + akData.Id,3)
            endif
        EndIf
        If akData.AuxId > 0 && abForceDestory
            iWidget.destroy(akData.AuxId)
            akData.AuxId = -1
        EndIf
        If akData.AuxId < 0
            akData.AuxId = iWidget.loadLibraryWidget("background")
        EndIf
        akData.Alpha = aiAlpha
        akData.Stage = -1
        akData.Timer = 0
        
        iWidget.setSize(akData.Id, UD_IconsSize, UD_IconsSize)
        iWidget.setPos(akData.Id, aiX, aiY)
        iWidget.setTransparency(akData.Id, akData.Alpha)
        iWidget.setVisible(akData.Id, (akData.Visible && akData.Enabled) as Int)
        _SetIconRGB(akData.Id, akData.Magnitude)

        iWidget.setSize(akData.AuxId, UD_IconsSize, UD_IconsSize)
        iWidget.setPos(akData.AuxId, aiX, aiY)
        iWidget.setTransparency(akData.AuxId, 20)
        iWidget.setVisible(akData.AuxId, (akData.Visible && akData.Enabled) as Int)
        _SetTextRGB(akData.AuxId, 0)
        _CreateIcon_Mutex = False
    EndFunction
    
    Function _DestroyIconWidget(UD_WidgetStatusEffect_RefAlias akData)
        if UDmain.TraceAllowed()
            UDMain.Log("UD_WidgetControl::_DestroyIconWidget() akData = " + akData, 3)
        endif
        If akData.AuxId > 0
            iWidget.destroy(akData.AuxId)
            akData.AuxId = -1
        EndIf
        If akData.Id > 0
            iWidget.destroy(akData.Id)
            akData.Id = -1
        EndIf
    EndFunction
    
    Function StatusEffect_SetVisible(String asName, Bool abVisible = True)
        UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
        If data == None 
            Return
        EndIf
        data.Visible = abVisible
        iWidget.setVisible(data.Id, (data.Visible && data.Enabled) as Int)
        iWidget.setVisible(data.AuxId, (data.Visible && data.Enabled) as Int)
        If abVisible
            iWidget.setTransparency(data.Id, data.Alpha)
        Else
            data.Blinking = False
        EndIf
    EndFunction
    
    Function StatusEffect_SetMagnitude(String asName, Int aiMagnitude)
        UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
        If data == None 
            Return
        EndIf
        data.Magnitude = aiMagnitude
        _SetIconRGB(data.Id, data.Magnitude)
    EndFunction
    
    Function StatusEffect_AdjustMagnitude(String asName, Int aiAdjustValue, Bool abControlVisibility = True)
        UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
        If data == None 
            Return
        EndIf
        data.Magnitude += aiAdjustValue
        If data.Magnitude < 0
            data.Magnitude = 0
        EndIf
        If abControlVisibility
            data.Visible = data.Magnitude > 0
            iWidget.setVisible(data.Id, (data.Visible && data.Enabled) as Int)
            iWidget.setVisible(data.AuxId, (data.Visible && data.Enabled) as Int)
        EndIf
        _SetIconRGB(data.Id, data.Magnitude)
    EndFunction
    
    Function StatusEffect_SetBlink(String asName, Bool abBlink = True)
        UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
        If data == None 
            Return
        EndIf
        data.Blinking = abBlink
        If abBlink
            RegisterForSingleUpdate(_Animation_UpdateInstant)
        Else
            iWidget.setTransparency(data.Id, data.Alpha)
        EndIf
    EndFunction
    
    Function _SetIconRGB(Int aiWidget, Int aiMagnitude)
        Int R
        Int G
        Int B
        If aiMagnitude <= 0
            R  = Math.LogicalAnd(Math.RightShift(_Widget_Icon_Inactive_Color,16),0xFF)
            G  = Math.LogicalAnd(Math.RightShift(_Widget_Icon_Inactive_Color,8),0xFF)
            B  = Math.LogicalAnd(Math.RightShift(_Widget_Icon_Inactive_Color,0),0xFF)
        ElseIf aiMagnitude <= 50
            R  = (Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active0_Color,16),0xFF) * (50 - aiMagnitude) + Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active50_Color,16),0xFF) * aiMagnitude) / 50
            G  = (Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active0_Color,8),0xFF) * (50 - aiMagnitude) + Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active50_Color,8),0xFF) * aiMagnitude) / 50
            B  = (Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active0_Color,0),0xFF) * (50 - aiMagnitude) + Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active50_Color,0),0xFF) * aiMagnitude) / 50
        Else
            Int m = aiMagnitude
            If m > 100
                m = 100
            EndIf
            R  = (Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active100_Color,16),0xFF) * (m - 50) + Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active50_Color,16),0xFF) * (100 - m)) / 50
            G  = (Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active100_Color,8),0xFF) * (m - 50) + Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active50_Color,8),0xFF) * (100 - m)) / 50
            B  = (Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active100_Color,0),0xFF) * (m - 50) + Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active50_Color,0),0xFF) * (100 - m)) / 50
        EndIf
        iWidget.setRGB(aiWidget, R, G, B)
    EndFunction

    Function _SetTextRGB(Int aiWidget, Int aiColor)
        Int R = Math.LogicalAnd(Math.RightShift(aiColor,16),0xFF)
        Int G = Math.LogicalAnd(Math.RightShift(aiColor,8),0xFF)
        Int B = Math.LogicalAnd(Math.RightShift(aiColor,0),0xFF)
        iWidget.setRGB(aiWidget, R, G, B)
    EndFunction
    
    Function _AnimateWidgets()
        Float real_time = Utility.GetCurrentRealTime()
        Float frame = real_time - _Animation_LastGameTime
        _Animation_LastGameTime = real_time
        If frame > 1.0
        ; probably menu time
            frame = 0.5
        EndIf
        ; Notifications
        _AnimateNotifications(frame)
        ; Icons
        _AnimateIcons(frame)
    EndFunction
    
    Function _AnimateNotifications(Float frame)
        _Text_Timer += frame
        If _Text_AnimStage == -1
            If _NextNotification()
                _Text_AnimStage = 0
                _Text_Timer = 0.0
            EndIf
        EndIf
        If _Text_AnimStage == 0 && _Text_Timer >= 0.0
        ; visible stage
            Int i = _Text_LinesId.Length
            While i > 0
                i -= 1
                iWidget.setVisible(_Text_LinesId[i], 1)
                iWidget.setVisible(_Text_LinesOutlineId[i], 1)
                iWidget.doTransitionByTime(_Text_LinesId[i], 100, 0.2, "alpha")
                iWidget.doTransitionByTime(_Text_LinesOutlineId[i], 100, 0.2, "alpha")
            EndWhile
            _Text_Timer = 0.0
            _Text_AnimStage = 1
        ElseIf _Text_AnimStage == 1 && _Text_Timer >= _Text_Duration
        ; fade out stage
            Int i = _Text_LinesId.Length
            While i > 0
                i -= 1
                iWidget.doTransitionByTime(_Text_LinesId[i], 0, UD_TextFadeTime, "alpha")
                iWidget.doTransitionByTime(_Text_LinesOutlineId[i], 0, UD_TextFadeTime, "alpha")
            EndWhile
            _Text_AnimStage = 2
        ElseIf _Text_AnimStage == 2 && _Text_Timer >= _Text_Duration + UD_TextFadeTime
            _Text_AnimStage = -1
            Int i = _Text_LinesId.Length
            While i > 0
                i -= 1
                iWidget.setVisible(_Text_LinesId[i], 0)
                iWidget.setVisible(_Text_LinesOutlineId[i], 0)
                iWidget.setTransparency(_Text_LinesId[i], 0)
                iWidget.setTransparency(_Text_LinesOutlineId[i], 0)
            EndWhile
        EndIf
    EndFunction

    Function _AnimateIcons(Float frame)
        Int i = 0
        While i < StatusEffectSlots.Length
            UD_WidgetStatusEffect_RefAlias data = StatusEffectSlots[i]
            If data.Id > 0
                data.Timer += frame
                If data.Visible && data.Enabled && data.Stage == -1
                    iWidget.setVisible(data.Id, 1)
                    iWidget.setTransparency(data.Id, data.Alpha)
                    iWidget.setVisible(data.AuxId, 1)
                    data.Stage = 0
                ElseIf !(data.Visible && data.Enabled) && data.Stage != -1
                    iWidget.setVisible(data.Id, 0)
                    iWidget.setVisible(data.AuxId, 0)
                    data.Stage = -1
                EndIf
                If data.Blinking
                    If ((data.Timer / 0.5) As Int) % 2 == 0
                        iWidget.doTransitionByTime(data.Id, 25, 0.5, "alpha")
                    Else
                        iWidget.doTransitionByTime(data.Id, 100, 0.5, "alpha")
                    EndIf
                    data.Stage = 1
                ElseIf data.Stage == 1
                    iWidget.doTransitionByTime(data.Id, data.Alpha, 0.1, "alpha")
                EndIf
            EndIf
            i += 1
        EndWhile
    EndFunction

    Function TestWidgets()
        UD_WidgetStatusEffect_RefAlias loc_dataIcon
        UD_WidgetMeter_RefAlias loc_dataMeter
        Int len = StatusEffectSlots.Length
        Int i = 0
        While i < len
            loc_dataIcon = StatusEffectSlots[i]
            If loc_dataIcon.Name != ""
                loc_dataIcon.StartTest()
                StatusEffect_SetMagnitude(loc_dataIcon.Name, Utility.RandomInt(1, 100))
                StatusEffect_SetVisible(loc_dataIcon.Name, True)
                StatusEffect_SetBlink(loc_dataIcon.Name, True)
            EndIf
            i += 1
        EndWhile
        
        len = MeterSlots.Length
        i = 0
        While i < len
            loc_dataMeter = MeterSlots[i]
            If loc_dataMeter.Name != ""
                loc_dataMeter.StartTest()
                Meter_SetVisible(loc_dataMeter.Name, True)
                Meter_SetFillPercent(loc_dataMeter.Name, Utility.RandomInt(1, 100))
            EndIf
            i += 1
        EndWhile
        
        Notification_Push("TEST 0 TEST 0", 0xFF0000)
        Notification_Push("TEST 1 TEST 1", 0x00FF00)
        Notification_Push("TEST 2 TEST 2", 0x0000FF)
        
        Utility.Wait(5.0)

    ; load last values
        len = StatusEffectSlots.Length
        i = 0
        While i < len
            loc_dataIcon = StatusEffectSlots[i]
            If loc_dataIcon.Name != ""
                loc_dataIcon.EndTest()
                StatusEffect_SetMagnitude(loc_dataIcon.Name, loc_dataIcon.Magnitude)
                StatusEffect_SetVisible(loc_dataIcon.Name, loc_dataIcon.Visible)
                StatusEffect_SetBlink(loc_dataIcon.Name, loc_dataIcon.Blinking)
            EndIf
            i += 1
        EndWhile
        
        len = MeterSlots.Length
        i = 0
        While i < len
            loc_dataMeter = MeterSlots[i]
            If loc_dataMeter.Name != ""
                loc_dataMeter.EndTest()
                Meter_SetVisible(loc_dataMeter.Name, loc_dataMeter.Visible)
                Meter_SetFillPercent(loc_dataMeter.Name, loc_dataMeter.FillPercent)
            EndIf
            i += 1
        EndWhile
        
    EndFunction
    
EndState        ; iWidgetInstalled

Int Function CalculateGroupXPos(int aiVal)
    if aiVal == 0           ; left
        return (HUDPaddingX + HUDMeterWidthRef / 2) As Int
    elseif aiVal == 1       ; center
        return (CanvasWidth * 5 / 10) As Int
    elseif aiVal == 2       ; right
        return (CanvasWidth - HUDPaddingX - HUDMeterWidthRef / 2) As Int
    endif
endFunction

Int Function CalculateGroupYPos(int aiVal)
    if aiVal == 0           ; down
        ; added offset to not overlap existing HUD indicators
        return (CanvasHeight - HUDPaddingY - HUDMeterHeightRef / 2 - 1.5 * HUDMeterHeightRef) As Int
    elseif aiVal == 1       ; less down
        return (CanvasHeight * 3 / 4 - HUDPaddingY / 2 + HUDMeterHeightRef / 2) As Int
    elseif aiVal == 2       ; top
        ; added offset to not overlap existing HUD indicators
        return (HUDPaddingY + HUDMeterHeightRef / 2 + 1.5 * HUDMeterHeightRef) As Int
    elseif aiVal == 3       ; middle
        ; added offset to not overlap existing HUD indicators
        return (CanvasHeight / 2 - HUDPaddingY / 2 + HUDMeterHeightRef / 2) As Int
    endif
endFunction

Function TestFun()
    ; TEST PLACEMENT
    ; Canvas corners
    Int t = iWidget.loadText("X")
    iWidget.setPos(t, 0, 0)
    iWidget.setRGB(t, 255, 0, 0)
    iWidget.setVisible(t)
    t = iWidget.loadText("X")
    iWidget.setPos(t, CanvasWidth, 0)
    iWidget.setRGB(t, 255, 0, 0)
    iWidget.setVisible(t)
    t = iWidget.loadText("X")
    iWidget.setPos(t, CanvasWidth, CanvasHeight)
    iWidget.setRGB(t, 255, 0, 0)
    iWidget.setVisible(t)
    t = iWidget.loadText("X")
    iWidget.setPos(t, 0, CanvasHeight)
    iWidget.setRGB(t, 255, 0, 0)
    iWidget.setVisible(t)
    
    ; HUD corners
    t = iWidget.loadText("X")
    iWidget.setPos(t, HUDPaddingX as Int, HUDPaddingY as Int)
    iWidget.setRGB(t, 0, 0, 255)
    iWidget.setVisible(t)
    t = iWidget.loadText("X")
    iWidget.setPos(t, (CanvasWidth - HUDPaddingX) as Int, (CanvasHeight - HUDPaddingY) as Int)
    iWidget.setRGB(t, 0, 0, 255)
    iWidget.setVisible(t)
    t = iWidget.loadText("X")
    iWidget.setPos(t, (CanvasWidth - HUDPaddingX) as Int, HUDPaddingY as Int)
    iWidget.setRGB(t, 0, 0, 255)
    iWidget.setVisible(t)
    t = iWidget.loadText("X")
    iWidget.setPos(t, HUDPaddingX as Int, (CanvasHeight - HUDPaddingY) as Int)
    iWidget.setRGB(t, 0, 0, 255)
    iWidget.setVisible(t)
    
    ; Anchor points
    Int i = 0
    While i <= 2
        Int j = 0
        While j <= 2
            t = iWidget.loadText("X")
            iWidget.setPos(t, CalculateGroupXPos(i), CalculateGroupYPos(j))
            iWidget.setRGB(t, 0, 255, 0)
            iWidget.setVisible(t)
            j += 1
        EndWhile
        i += 1
    EndWhile
    
    ; Meters on bottom position
    ; Widget on the left above magica meter
    Int m = iWidget.loadMeter()
    iWidget.setSize(m, HUDMeterHeight as Int, HUDMeterWidth as Int)
    iWidget.setPos(m, CalculateGroupXPos(0), (CalculateGroupYPos(0) - HUDMeterHeightRef * 1.5) As Int)
    iWidget.setVisible(m, 1)
    
    ; Widget at the center above health meter
    m = iWidget.loadMeter()
    iWidget.setSize(m, HUDMeterHeight as Int, HUDMeterWidth as Int)
    iWidget.setPos(m, CalculateGroupXPos(1), (CalculateGroupYPos(0) - HUDMeterHeightRef * 1.5) As Int)
    iWidget.setVisible(m, 1)

    ; widget on the right above HUD stamina meter
    m = iWidget.loadMeter()
    iWidget.setSize(m, HUDMeterHeight as Int, HUDMeterWidth as Int)
    iWidget.setPos(m, CalculateGroupXPos(2), (CalculateGroupYPos(0) - HUDMeterHeightRef * 1.5) As Int)
    iWidget.setVisible(m, 1)

    ; widget on the right above the last one
    m = iWidget.loadMeter()
    iWidget.setSize(m, HUDMeterHeight as Int, HUDMeterWidth as Int)
    iWidget.setPos(m, CalculateGroupXPos(2), (CalculateGroupYPos(0) - HUDMeterHeightRef * 3.0) As Int)
    iWidget.setVisible(m, 1)
EndFunction

Function TestFun2()

    Utility.Wait(2.0)
    
    Int m = iWidget.loadMeter()
    iWidget.setSize(m, HUDMeterHeight as Int, HUDMeterWidth as Int)
    ; iWidget.setZoom(m, (50 / WideScreenFactor) as Int, 50)
    iWidget.setPos(m, 720, 400)
    iWidget.setVisible(m, 1)
    
    iWidget.setMeterPercent(m, 75)
    
    Utility.Wait(2.0)
    
    iWidget.setPos(m, 720, 500)
    
    Utility.Wait(2.0)
    
    iWidget.setSize(m, HUDMeterHeight as Int, HUDMeterWidth as Int)
    
    Utility.Wait(2.0)
    
    iWidget.setPos(m, 720, 600)

EndFunction
