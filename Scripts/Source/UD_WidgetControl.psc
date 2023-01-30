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

UnforgivingDevicesMain Property UDmain auto

;use iWantWidgets if true
Bool _UD_UseIWantWidget = True
Bool                        Property UD_UseIWantWidget  Hidden
    Bool Function Get() 
        Return _UD_UseIWantWidget
    EndFunction
    Function Set(Bool abValue)
        If _UD_UseIWantWidget != abValue
            _UD_UseIWantWidget = abValue
            SwitchStates(abGameLoad = False)
        EndIf
    EndFunction
EndProperty

;exist
UD_WidgetBase               Property UD_Widget1 auto
UD_WidgetBase               Property UD_Widget2 auto

iWant_Widgets Property iWidget Hidden
    iWant_Widgets Function Get()
        return (UDmain.iWidgetQuest as iWant_Widgets)
    EndFunction
EndProperty

;By default, auto adjust is turned off
Bool _AutoAdjustWidget = False
Bool Property UD_AutoAdjustWidget Hidden
    Function Set(Bool abVal)
        _AutoAdjustWidget = abVal
        if !_AutoAdjustWidget
            ;Reininit widgets
            InitWidgetsRequest(abMeters = True)
        endif
    EndFunction
    Bool Function Get()
        return _AutoAdjustWidget
    EndFunction
EndProperty

; overlay settings

Float Property UD_MeterVertPadding = 1.25 Auto   Hidden

; enable device icons
Bool _UD_EnableDeviceIcons = True
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

; enable effect icons
Bool _UD_EnableEffectIcons = True
Bool Property UD_EnableEffectIcons Hidden
    Bool Function Get()
        Return _UD_EnableEffectIcons
    EndFunction
    Function Set(Bool abValue)
        If _UD_EnableEffectIcons != abValue
            _UD_EnableEffectIcons = abValue
            InitWidgetsRequest(abIcons = True)
        EndIf
    EndFunction
EndProperty

; enable customized notifications
Bool _UD_EnableCNotifications = True
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

; text font size
Int _UD_TextFontSize = 24
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

Int                         Property    UD_TextLineLength           = 100   Auto    Hidden      ; length of line in text notification (not implemented)
Int                         Property    UD_TextReadSpeed            = 20    Auto    Hidden      ; how long notification will be on the screen (symbols per second)
Int                         Property    UD_TextOutlineShift         = 1     Auto    Hidden      ; text outline shift
Bool                        Property    UD_FilterVibNotifications   = True  Auto    Hidden      ; remove redundant notifications from vibrators

; anchor position of the notification (see W_POSY_**** constants)
Int _UD_TextAnchor = 1
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

; vertical padding relative to anchor
Int _UD_TextPadding = 0
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

; effect icon size
Int _UD_IconsSize = 60
Int Property UD_IconsSize Hidden
    Int Function Get()
        Return _UD_IconsSize
    EndFunction
    Function Set(Int aiValue)
        If _UD_IconsSize != aiValue
            _UD_IconsSize = aiValue
            InitWidgetsRequest(abText = True)
        EndIf
    EndFunction
EndProperty

; anchor position of the icons cluster (see W_POSX_**** constants)
Int _UD_IconsAnchor = 1
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

; horizontal padding relative to anchor
Int _UD_IconsPadding = 0
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
Int Property UD_WidgetXPos Hidden
    Function Set(Int aiVal)
        If _WidgetXPos == aiVal
            Return
        EndIf
        _WidgetXPos = aiVal
        UD_Widget1.PositionX = _WidgetXPos
        UD_Widget2.PositionX = _WidgetXPos
        if GetState() == "iWidgetInstalled"
            InitWidgetsRequest(abMeters = True)
        endif
    EndFunction
    Int Function Get()
        return _WidgetXPos
    EndFunction
EndProperty

Int _WidgetYPos = 0
Int Property UD_WidgetYPos Hidden
    Function Set(Int aiVal)
        If _WidgetYPos == aiVal
            Return
        EndIf
        _WidgetYPos = aiVal
        UD_Widget1.PositionY = _WidgetYPos
        UD_Widget2.PositionY = _WidgetYPos
        if GetState() == "iWidgetInstalled"
            InitWidgetsRequest(abMeters = True)
        endif
    EndFunction
    Int Function Get()
        return _WidgetYPos
    EndFunction
EndProperty

Int CanvasWidth = 1280
Int CanvasHeight = 720

; meter's size in canvas pixels (used to calculate positions/offsets)
Float HUDMeterWidthRef = 248.0
Float HUDMeterHeightRef = 15.0
; meter's size in screen pixels (used to set size on screen)
Float HUDMeterWidth
Float HUDMeterHeight
; HUD's paddings
Float HUDPaddingX
Float HUDPaddingY
; request to init widgets (see OnUpdate function)
Bool _InitMetersRequested = False
Bool _InitIconsRequested = False
Bool _InitTextRequested = False
Bool _InitAfterLoadGame = False

Bool Property Ready = False auto

Event OnInit()
    RegisterForSingleUpdate(10) ;maintenance update
EndEvent

Event OnUpdate()
    if UDmain.IsEnabled()
        If _OnUpdateMutex
            Return
        EndIf
        _OnUpdateMutex = True
        If _InitMetersRequested || _InitIconsRequested || _InitTextRequested
            InitWidgetsCheck(_InitAfterLoadGame)
            _InitAfterLoadGame = False
        EndIf
        _OnUpdateMutex = False
    endif
    RegisterForSingleUpdate(30) ;maintenance update
    If !Ready
        Ready = True
        StatusEffect_SetPosition("dd-piercing-nipples", W_ICON_CLUSTER_DEVICES)
        StatusEffect_SetPosition("dd-plug-vaginal", W_ICON_CLUSTER_DEVICES)
        StatusEffect_SetPosition("dd-piercing-clit", W_ICON_CLUSTER_DEVICES)
        StatusEffect_SetPosition("dd-plug-anal", W_ICON_CLUSTER_DEVICES)
        StatusEffect_SetPosition("effect-exhaustion", W_ICON_CLUSTER_EFFECTS, 2)
        StatusEffect_SetPosition("effect-orgasm", W_ICON_CLUSTER_EFFECTS, 2)
        SwitchStates(abGameLoad = False)
        InitWidgetsRequest(abGameLoad = False, abMeters = True, abIcons = True, abText = True)
    EndIf
EndEvent

Function Update()
    StatusEffect_SetPosition("dd-piercing-nipples", W_ICON_CLUSTER_DEVICES)
    StatusEffect_SetPosition("dd-plug-vaginal", W_ICON_CLUSTER_DEVICES)
    StatusEffect_SetPosition("dd-piercing-clit", W_ICON_CLUSTER_DEVICES)
    StatusEffect_SetPosition("dd-plug-anal", W_ICON_CLUSTER_DEVICES)
    StatusEffect_SetPosition("effect-exhaustion", W_ICON_CLUSTER_EFFECTS)
    StatusEffect_SetPosition("effect-orgasm", W_ICON_CLUSTER_EFFECTS)
    SwitchStates(abGameLoad = True)
EndFunction

Function SwitchStates(Bool abGameLoad)
    if UDmain.UseiWW()
        GoToState("iWidgetInstalled")
        UD_Widget1.hide(true)
        UD_Widget2.hide(true)
        InitWidgetsRequest(abGameLoad = abGameLoad, abMeters = True, abIcons = True, abText = True)
    else
        GoToState("")
    endif
EndFunction

; should be called before placing widgets
Function RefreshCanvasMetrics()
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
    Float width_mult = ((hud_right - hud_left) + 2 * hud_padding - le_corr1) / (1280 - le_corr1)
    
    CanvasWidth = (1280 * width_mult) as Int
    CanvasHeight = 720
    HUDMeterWidth = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._width")
    HUDMeterHeight = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._height")
    HUDMeterWidthRef = 248.0 ; / width_mult
    HUDPaddingX = 48.0 + hud_padding
    HUDPaddingY = hud_padding
EndFunction

Function InitWidgetsRequest(Bool abGameLoad = False, Bool abMeters = False, Bool abIcons = False, Bool abText = False)
    UDmain.Log("UD_WidgetControl::InitWidgetsRequest() abGameLoad = " + abGameLoad + " , abMeters = " + abMeters + " , abIcons = " + abIcons + " , abText = " + abText, 3)
    _InitAfterLoadGame = _InitAfterLoadGame || abGameLoad
    _InitMetersRequested = _InitMetersRequested || abMeters
    _InitIconsRequested = _InitIconsRequested || abIcons
    _InitTextRequested = _InitTextRequested || abText
    RegisterForSingleUpdate(0.5)
EndFunction
Function InitWidgetsCheck(Bool abGameLoad = False)
EndFunction
Bool Function InitMeters(Bool abGameLoad = False)
EndFunction
Bool Function InitIcons(Bool abGameLoad = False)
EndFunction
Bool Function InitText(Bool abGameLoad = False)
EndFunction
Function ResetToDefault()
    UD_AutoAdjustWidget             = False
    UD_UseIWantWidget               = True
    UD_EnableDeviceIcons            = True
    UD_EnableEffectIcons            = True
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

;toggle widget
Function Toggle_DeviceWidget(bool abVal, Bool abUpdateVisPos = True)
    if abVal
        UD_Widget1.show(true)
    else
        UD_Widget1.hide(true)
    endif
EndFunction
Function Toggle_DeviceCondWidget(bool abVal, Bool abUpdateVisPos = True)
EndFunction
Function Toggle_OrgasmWidget(bool abVal, Bool abUpdateVisPos = True)
    if abVal
        UD_Widget2.show(true)
    else
        UD_Widget2.hide(true)
    endif
EndFunction

Function UpdatePercent_DeviceWidget(Float afVal,Bool abForce = false)
    UD_Widget1.SetPercent(afVal, abForce)
EndFunction
Function UpdatePercent_DeviceCondWidget(Float afVal,Bool abForce = false)
EndFunction
Function UpdatePercent_OrgasmWidget(Float afVal,Bool abForce = false)
    UD_Widget2.SetPercent(afVal, abForce)
EndFunction

Function UpdateColor_DeviceWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
    UD_Widget1.SetColors(aiColor, aiColor2,aiFlashColor)
EndFunction
Function UpdateColor_DeviceCondWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
EndFunction
Function UpdateColor_OrgasmWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
    UD_Widget2.SetColors(aiColor, aiColor2,aiFlashColor)
EndFunction

Function Flash_DeviceWidget()
    UD_Widget1.Flash()
EndFunction
Function Flash_DeviceCondWidget()
EndFunction
Function Flash_OrgasmWidget()
    UD_Widget2.Flash()
EndFunction

;iWidget variables, should not be used ifiWidget is not installed
Int     _Widget_DeviceDurability            = -1
Bool    _Widget_DeviceDurability_Visible    = False
Int     _Widget_DeviceDurability_Perc       = 0
Int     _Widget_DeviceDurability_Color      = 0xFF005E
Int     _Widget_DeviceDurability_Color2     = 0xFF307C
Int     _Widget_DeviceDurability_Color3     = 0

Int     _Widget_DeviceCondition             = -1
Bool    _Widget_DeviceCondition_Visible     = False
Int     _Widget_DeviceCondition_Perc        = 0
Int     _Widget_DeviceCondition_Color       = 0x4df319
Int     _Widget_DeviceCondition_Color2      = 0x62ff00
Int     _Widget_DeviceCondition_Color3      = 0

Int     _Widget_Orgasm                      = -1
Bool    _Widget_Orgasm_Visible              = False
Int     _Widget_Orgasm_Perc                 = 0
Int     _Widget_Orgasm_Color                = 0xE727F5
Int     _Widget_Orgasm_Color2               = 0xF775FF
Int     _Widget_Orgasm_Color3               = 0xFF00BC

;GROUP
Int[] _WidgetsID

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

UD_WidgetStatusEffect_RefAlias[]    Property    StatusEffectSlots     Auto

Int         _Widget_Icon_Inactive_Color             = 0xFFFFFF      ; Gray          Color of innactive effect
Int         _Widget_Icon_Active0_Color              = 0xFFFF00      ; Yellow        Color of active effect with magnitude 0
Int         _Widget_Icon_Active50_Color             = 0xFF0000      ; Red           Color of active effect with magnitude 50
Int         _Widget_Icon_Active100_Color            = 0xFF00FF      ; Magenta       Color of active effect with magnitude 100

Event OnBeginState()
    RegisterForSingleUpdate(30.0)
    StatusEffect_AllUpdate()
EndEvent
    
Function UpdateGroupPositions()
EndFunction

;/
    Widget API
/;
;/
Function Meter_SetVisible(String asName, Bool abVisible, Bool abUpdateVisPos = True)
    If asName == "device-durability"
        Toggle_DeviceWidget(abVisible, abUpdateVisPos)
    ElseIf asName == "device-condition"
        Toggle_DeviceCondWidget(abVisible, abUpdateVisPos)
    ElseIf asName == "player-orgasm"
        Toggle_OrgasmWidget(abVisible, abUpdateVisPos)
    EndIf
EndFunction
Function Meter_SetPercent(String asName, Int afValue, Bool abForce = false)
    If asName == "device-durability"
        UpdatePercent_DeviceWidget(afValue, abForce)
    ElseIf asName == "device-condition"
        UpdatePercent_DeviceCondWidget(afValue, abForce)
    ElseIf asName == "player-orgasm"
        UpdatePercent_OrgasmWidget(afValue, abForce)
    EndIf
EndFunction
Function Meter_SetColor(String asName, Int aiColor, Int aiColor2 = 0, Int aiFlashColor = 0xFFFFFF)
    If asName == "device-durability"
        UpdateColor_DeviceWidget(aiColor, aiColor2, aiFlashColor)
    ElseIf asName == "device-condition"
        UpdateColor_DeviceCondWidget(aiColor, aiColor2, aiFlashColor)
    ElseIf asName == "player-orgasm"
        UpdateColor_OrgasmWidget(aiColor, aiColor2, aiFlashColor)
    EndIf
EndFunction
Function Meter_Flash(String asName)
    If asName == "device-durability"
        Flash_DeviceWidget()
    ElseIf asName == "device-condition"
        Flash_DeviceCondWidget()
    ElseIf asName == "player-orgasm"
        Flash_OrgasmWidget()
    EndIf
EndFunction
/;

; Print notification on screen
; asText                - notification text
Function Notification_Push(String asText, Int aiColor = 0xFFFFFF)
    Debug.Notification(asText)
EndFunction

; Register new status effect icon (or change existing)
; asName        - effect name (and base part of file name)
; aiVariant     - icon variant. If equal to -1, then the previous value is kept
; aiClusterId   - icon cluster (0 or 1 for device or effect cluster). If equal to -1, then the previous value is kept
Function StatusEffect_SetPosition(String asName, Int aiClusterId = -1, Int aiVariant = -1)
    UDMain.Info("UD_WidgetControl::StatusEffect_SetPosition() asName = " + asName + ", aiClusterId = " + aiClusterId + ", aiVariant = " + aiVariant)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
    If data == None
        Return
    EndIf
    Bool need_init = False
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

Function StatusEffect_Remove(String asName)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName, abFindEmpty = False)
    If data != None
        data.Reset()
    EndIf
EndFunction

; Gets current icon variant of the given effect
; asName        - effect name
; return        - icon variant
Int Function StatusEffect_GetVariant(String asName)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName, abFindEmpty = False)
    If data == None
        Return -1
    EndIf
    Return data.Variant
EndFunction

; Show/hide status effect icon.
; asName            - effect name (icon name)
; abVisible         - desired visibility state
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

; Set magnitude of the effect.
; The color of the icon changes depending on the final value.
; asName            - effect name (icon name)
; aiMagnitude       - magnitude
Function StatusEffect_SetMagnitude(String asName, Int aiMagnitude)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
    If data == None 
        Return
    EndIf
    data.Magnitude = aiMagnitude
EndFunction

; Adjust magnitude by the given value.
; The color of the icon changes depending on the final value.
; asName                - effect name (icon name)
; aiAdjustValue         - adjust value
; abControlVisibility   - if true, the icon will be hidden or shown depending on the final value
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

; Set icon blinking (periodic change of alpha in range 25 .. 100).
; asName                - effect name (icon name)
; abBlink               - blinking status
Function StatusEffect_SetBlink(String asName, Bool abBlink = True)
    UD_WidgetStatusEffect_RefAlias data = _GetStatusEffect(asName)
    If data == None 
        Return
    EndIf
    data.Blinking = abBlink
EndFunction

; Update all icons after switching between states
Function StatusEffect_AllUpdate()
;    If iWidget == None 
;        Return
;    EndIf
;    Int i = _Icons_Id.Length
;    While i > 0
;        i -= 1
;        If _Icons_Id[i] > 0
;            iWidget.setVisible(_Icons_Id[i], 0)
;            iWidget.setVisible(_Icons_Id[i], 0)
;        EndIf
;    EndWhile
;    i = _Text_LinesId.Length
;    While i > 0
;        i -= 1
;        If _Icons_Id[i] > 0
;            iWidget.setVisible(_Text_LinesId[i], 0)
;            iWidget.setVisible(_Text_LinesOutlineId[i], 0)
;        EndIf
;    EndWhile
;    i = _WidgetsID.Length
;    While i > 0
;        i -= 1
;        If _Icons_Id[i] > 0
;            iWidget.setVisible(_WidgetsID[i], 0)
;        EndIf
;    EndWhile
EndFunction

; Show all enabled (!) widgets with test animations for the short time
Function TestWidgets()
EndFunction

;/
    End of Widget API
/;

Function _UpdateMeterColor(Int aiId,int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
EndFunction
Int[] Function _AddWidget(Int[] aaiGroup, Int aiWidget, Float fVerticalOffset, Int akPerc = 0, Int akCol1 = 0x0, Int akCol2 = 0x0, Int akCol3 = 0xFFFFFFFF)
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

Bool _FindEmpty_Mutex = False

UD_WidgetStatusEffect_RefAlias Function _GetStatusEffect(String asName, Bool abFindEmpty = True)
    Int i = 0
    While i < StatusEffectSlots.Length
        If StatusEffectSlots[i].Name == asName
            Return StatusEffectSlots[i]
        EndIf
        i += 1
    EndWhile
    If abFindEmpty
    ; first empty slot
        If _FindEmpty_Mutex
            Int j = 0
            While j < 20 && _FindEmpty_Mutex
                Utility.Wait(0.05)
                j += 1
            EndWhile
        EndIf
        _FindEmpty_Mutex = True
        Int k = 0
        While k < StatusEffectSlots.Length
            If StatusEffectSlots[k].Name == ""
                StatusEffectSlots[k].Reset()
                StatusEffectSlots[k].Name = asName
                _FindEmpty_Mutex = False
                Return StatusEffectSlots[k]
            EndIf
            k += 1
        EndWhile
        _FindEmpty_Mutex = False
        UDMain.Info("UD_WidgetControl::_GetStatusEffect() No more slots for the status effect icons!")
    EndIf
    Return None
EndFunction

Bool _CreateIcon_Mutex = False

Function _CreateIconWidget(UD_WidgetStatusEffect_RefAlias akData, Int aiX, Int aiY, Int aiAlpha, Bool abForceDestory = False)
EndFunction

Bool _InitMetersMutex = False
Bool _OnUpdateMutex = False
;Use iWidget instead
State iWidgetInstalled

    Event OnBeginState()
        _Animation_LastGameTime = Utility.GetCurrentRealTime()
        RegisterForSingleUpdate(_Animation_Update)
        StatusEffect_AllUpdate()
    EndEvent
    
    Event OnUpdate()
        if UDmain.IsEnabled()
            If _OnUpdateMutex
                Return
            EndIf
            _OnUpdateMutex = True
            If _InitMetersRequested || _InitIconsRequested || _InitTextRequested
                InitWidgetsCheck(_InitAfterLoadGame)
                _InitAfterLoadGame = False
            EndIf
            _AnimateWidgets()
            RegisterForSingleUpdate(_Animation_Update)
            _OnUpdateMutex = False
        else
            RegisterForSingleUpdate(5.0)
        endif
    EndEvent

    ; abGameLoad        - flag that it's game load event. And we recreate all widgets regardless of previous IDs
    Function InitWidgetsCheck(Bool abGameLoad = False)
        UnregisterForUpdate()
;        Utility.Wait(_Animation_Update + 0.5)
        
        RefreshCanvasMetrics()
        If _InitMetersRequested
            _InitMetersRequested = !InitMeters(abGameLoad)
        EndIf
        If _InitTextRequested
            _InitTextRequested = !InitText(abGameLoad)
        EndIf
        If _InitIconsRequested
            _InitIconsRequested = !InitIcons(abGameLoad)
        EndIf

        RegisterForSingleUpdate(_Animation_Update)
    EndFunction
    
    Bool Function InitMeters(Bool abGameLoad = False)
        _InitMetersMutex = True
        If abGameLoad
        ; clearing all IDs without destroying
            _Widget_DeviceDurability = -1
            _Widget_DeviceCondition = -1
            _Widget_Orgasm = -1
        EndIf
        if _Widget_DeviceDurability > 0
            iWidget.destroy(_Widget_DeviceDurability)
        endif
        if _Widget_DeviceCondition > 0
            iWidget.destroy(_Widget_DeviceCondition)
        endif
        if _Widget_Orgasm > 0
            iWidget.destroy(_Widget_Orgasm)
        endif
        
        _WidgetsID = Utility.CreateIntArray(0)
        
        _Widget_DeviceDurability = iWidget.loadMeter()
        If _Widget_DeviceDurability == 0
            Return False
        EndIf
        _WidgetsID = _AddWidget(_WidgetsID, _Widget_DeviceDurability, 0*UD_MeterVertPadding, _Widget_DeviceDurability_Perc, _Widget_DeviceDurability_Color, _Widget_DeviceDurability_Color2, _Widget_DeviceDurability_Color3)
        
        _Widget_DeviceCondition = iWidget.loadMeter()
        If _Widget_DeviceCondition == 0
            Return False
        EndIf
        _WidgetsID = _AddWidget(_WidgetsID, _Widget_DeviceCondition, 1.0*UD_MeterVertPadding, _Widget_DeviceCondition_Perc, _Widget_DeviceCondition_Color, _Widget_DeviceCondition_Color2, _Widget_DeviceCondition_Color3)
        
        _Widget_Orgasm = iWidget.loadMeter()
        If _Widget_Orgasm == 0
            Return False
        EndIf
        _WidgetsID = _AddWidget(_WidgetsID, _Widget_Orgasm, 2.0*UD_MeterVertPadding, _Widget_Orgasm_Perc, _Widget_Orgasm_Color, _Widget_Orgasm_Color2, _Widget_Orgasm_Color3)

        iWidget.setVisible(_Widget_DeviceDurability, _Widget_DeviceDurability_Visible As Int)
        iWidget.setVisible(_Widget_DeviceCondition, _Widget_DeviceCondition_Visible As Int)
        iWidget.setVisible(_Widget_Orgasm, _Widget_Orgasm_Visible As Int)
        
        _InitMetersMutex = False
        Return True
    EndFunction
    
    Bool Function InitText(Bool abGameLoad = False)
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
                iWidget.setPos(text_id, CalculateGroupXPos(W_POSX_CENTER), (CalculateGroupYPos(UD_TextAnchor) + UD_TextPadding + 1.5 * UD_TextFontSize * (_Text_LinesId.Length - 1)) as Int)
                iWidget.setPos(outline_id, CalculateGroupXPos(W_POSX_CENTER) + UD_TextOutlineShift, (CalculateGroupYPos(UD_TextAnchor) + UD_TextPadding + 1.5 * UD_TextFontSize * (_Text_LinesId.Length - 1)) as Int + UD_TextOutlineShift)
            Else
                UDMain.Warning("UD_WidgetControl::InitText() Unsupported value UD_TextAnchor = " + UD_TextAnchor)
            EndIf
            iWidget.setVisible(text_id, 0)
            iWidget.setTransparency(text_id, 0)
            i += 1
        EndWhile
        _Text_AnimStage = -1
        _Text_Timer = 0.0

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
        
        Int x = 0
        Int y = 0            
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
                        x = CalculateGroupXPos(W_POSX_LEFT) + UD_IconsPadding + (UD_IconsSize * (-0.55 + 1.1 * (index0 % 2))) As Int
                        y = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (-1.1 * (cluster0_count / 2) + 1.1 * (index0 / 2))) As Int
                        data.Enabled = UD_EnableDeviceIcons
                        index0 += 1
                    ElseIf data.Cluster == W_ICON_CLUSTER_EFFECTS                                   ; effect cluster
                        x = CalculateGroupXPos(W_POSX_LEFT) + UD_IconsPadding + (UD_IconsSize * (-0.55 + 1.1 * (index1 % 2))) As Int
                        y = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (1.1 + 1.1 * (index1 / 2))) As Int
                        data.Enabled = UD_EnableEffectIcons
                        index1 += 1
                    EndIf
                    _CreateIconWidget(data, x, y, 75)
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
                        x = CalculateGroupXPos(W_POSX_CENTER) - 300 - UD_IconsPadding + (UD_IconsSize * (-0.55 + 1.1 * (index0 % 2))) As Int
                        y = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (-0.55 * (Math.Ceiling((cluster0_count as Float) / 2.0) - 1) + 1.1 * (index0 / 2))) As Int
                        data.Enabled = UD_EnableDeviceIcons
                        index0 += 1
                    ElseIf data.Cluster == W_ICON_CLUSTER_EFFECTS                                   ; effect cluster
                        x = CalculateGroupXPos(W_POSX_CENTER) + 300 + UD_IconsPadding + (UD_IconsSize * (-0.55 + 1.1 * (index1 % 2))) As Int
                        y = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (-0.55 * (Math.Ceiling((cluster1_count as Float) / 2.0) - 1) + 1.1 * (index1 / 2))) As Int
                        data.Enabled = UD_EnableEffectIcons
                        index1 += 1
                    EndIf
                    _CreateIconWidget(data, x, y, 75)
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
                        x = CalculateGroupXPos(W_POSX_RIGHT) - UD_IconsPadding - (UD_IconsSize * (-0.55 + 1.1 * (index0 % 2))) As Int
                        y = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (-1.1 * (cluster0_count / 2) + 1.1 * (index0 / 2))) As Int
                        data.Enabled = UD_EnableDeviceIcons
                        index0 += 1
                    ElseIf data.Cluster == W_ICON_CLUSTER_EFFECTS                                   ; effect cluster
                        x = CalculateGroupXPos(W_POSX_RIGHT) - UD_IconsPadding - (UD_IconsSize * (-0.55 + 1.1 * (index1 % 2))) As Int
                        y = CalculateGroupYPos(W_POSY_CENTER) + (UD_IconsSize * (1.1 + 1.1 * (index1 / 2))) As Int
                        data.Enabled = UD_EnableEffectIcons
                        index1 += 1
                    EndIf
                    _CreateIconWidget(data, x, y, 75)
                EndIf
                i += 1
            EndWhile
        Else
            UDMain.Warning("UD_WidgetControl::InitIcons() Unsupported value UD_IconsAnchor = " + UD_IconsAnchor)
        EndIf
        Return True
    EndFunction
    
    ; fVerticalOffset       - offset in meter's heights
    Int[] Function _AddWidget(Int[] aaiGroup, Int aiWidget, Float fVerticalOffset, Int akPerc = 0, Int akCol1 = 0x0, Int akCol2 = 0x0, Int akCol3 = 0xFFFFFFFF)
        UDMain.Log("UD_WidgetControl::_AddWidget() aiWidget = " + aiWidget, 3)
        iWidget.setSize(aiWidget, HUDMeterHeight as Int, HUDMeterWidth as Int)
        ; on the top position we stack widgets from top to the bottom
        If UD_WidgetYPos == 2
            fVerticalOffset = -fVerticalOffset
        EndIf
        iWidget.setPos(aiWidget, CalculateGroupXPos(UD_WidgetXPos), (CalculateGroupYPos(UD_WidgetYPos) - HUDMeterHeightRef * fVerticalOffset) As Int)
        iWidget.setMeterPercent(aiWidget,akPerc)
        _UpdateMeterColor(aiWidget, akCol1,akCol2,akCol3)
        Return PapyrusUtil.PushInt(aaiGroup, aiWidget)
    EndFunction
    
    ;toggle widget
    Function Toggle_DeviceWidget(bool abVal, Bool abUpdateVisPos = True)
        if UD_AutoAdjustWidget
            if _Widget_DeviceDurability_Visible != abVal
                _Widget_DeviceDurability_Visible = abVal
                if abUpdateVisPos
                    InitWidgetsRequest(abMeters = True)
                endif
            endif
        else
            _Widget_DeviceDurability_Visible = abVal
            iWidget.setVisible(_Widget_DeviceDurability, _Widget_DeviceDurability_Visible As Int)
        endif
    EndFunction
    Function Toggle_DeviceCondWidget(bool abVal, Bool abUpdateVisPos = True)
        if UD_AutoAdjustWidget
            if _Widget_DeviceCondition_Visible != abVal
                _Widget_DeviceCondition_Visible = abVal
                if abUpdateVisPos
                    InitWidgetsRequest(abMeters = True)
                endif
            endif
        else
            _Widget_DeviceCondition_Visible = abVal
            iWidget.setVisible(_Widget_DeviceCondition, _Widget_DeviceCondition_Visible As Int)
        endif
    EndFunction
    Function Toggle_OrgasmWidget(bool abVal, Bool abUpdateVisPos = True)
        if UD_AutoAdjustWidget
            if _Widget_Orgasm_Visible != abVal
                _Widget_Orgasm_Visible = abVal
                if abUpdateVisPos
                    InitWidgetsRequest(abMeters = True)
                endif
            endif
        else
            _Widget_Orgasm_Visible = abVal
            iWidget.setVisible(_Widget_Orgasm, _Widget_Orgasm_Visible As Int)
        endif
    EndFunction

    Function UpdatePercent_DeviceWidget(Float afVal,Bool abForce = false)
        _Widget_DeviceDurability_Perc = Round(afVal*100)
        if !_InitMetersMutex
            iWidget.setMeterPercent(_Widget_DeviceDurability, _Widget_DeviceDurability_Perc)
        endif
    EndFunction
    Function UpdatePercent_DeviceCondWidget(Float afVal,Bool abForce = false)
        _Widget_DeviceCondition_Perc = Round(afVal*100)
        if !_InitMetersMutex
            iWidget.setMeterPercent(_Widget_DeviceCondition, _Widget_DeviceCondition_Perc)
        endif
    EndFunction
    Function UpdatePercent_OrgasmWidget(Float afVal,Bool abForce = false)
        _Widget_Orgasm_Perc = Round(afVal*100)
        if !_InitMetersMutex
            iWidget.setMeterPercent(_Widget_Orgasm, _Widget_Orgasm_Perc)
        endif
    EndFunction

    Function UpdateColor_DeviceWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
        _UpdateMeterColor(_Widget_DeviceDurability,aiColor,aiColor2,aiFlashColor)
    EndFunction
    Function UpdateColor_DeviceCondWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
        _UpdateMeterColor(_Widget_DeviceCondition,aiColor,aiColor2,aiFlashColor)
    EndFunction
    Function UpdateColor_OrgasmWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
        _UpdateMeterColor(_Widget_Orgasm,aiColor,aiColor2,aiFlashColor)
    EndFunction
    
    ;use to convert from hex to this sinfull way of writting colors
    Function _UpdateMeterColor(Int aiId,int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
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
        
        if aiId == _Widget_DeviceDurability
            _Widget_DeviceDurability_Color  = aiColor
            _Widget_DeviceDurability_Color2 = aiColor2
            _Widget_DeviceDurability_Color3 = aiFlashColor
        elseif aiId == _Widget_DeviceCondition
            _Widget_DeviceCondition_Color   = aiColor
            _Widget_DeviceCondition_Color2  = aiColor2
            _Widget_DeviceCondition_Color3  = aiFlashColor
        elseif aiId == _Widget_Orgasm
            _Widget_Orgasm_Color            = aiColor
            _Widget_Orgasm_Color2           = aiColor2
            _Widget_Orgasm_Color3           = aiFlashColor
        endif
    EndFunction
    
    Function Flash_DeviceWidget()
        iWidget.doMeterFlash(_Widget_DeviceDurability)
    EndFunction
    Function Flash_DeviceCondWidget()
        iWidget.doMeterFlash(_Widget_DeviceCondition)
    EndFunction
    Function Flash_OrgasmWidget()
        iWidget.doMeterFlash(_Widget_Orgasm)
    EndFunction
    
    Function TestWidgets()
        UD_WidgetStatusEffect_RefAlias data
        Int len = StatusEffectSlots.Length
        Int i = 0
        While i < len
            data = StatusEffectSlots[i]
            If data.Name != ""
                data.StartTest()
                StatusEffect_SetMagnitude(data.Name, Utility.RandomInt(1, 100))
                StatusEffect_SetVisible(data.Name, True)
                StatusEffect_SetBlink(data.Name, True)
            EndIf
            i += 1
        EndWhile
        
        Notification_Push("TEST 0 TEST 0", 0xFF0000)
        Notification_Push("TEST 1 TEST 1", 0x00FF00)
        Notification_Push("TEST 2 TEST 2", 0x0000FF)
        
        Utility.Wait(5.0)

    ; load last values
        i = 0
        While i < len
            data = StatusEffectSlots[i]
            If data.Name != ""
                data.EndTest()
                StatusEffect_SetMagnitude(data.Name, data.Magnitude)
                StatusEffect_SetVisible(data.Name, data.Visible)
                StatusEffect_SetBlink(data.Name, data.Blinking)
            EndIf
            i += 1
        EndWhile
    EndFunction
    
    ; quickly push a string into array and leave the function
    Function Notification_Push(String asText, Int aiColor = 0xFFFFFF)
        If asText == ""
            Return
        EndIf
        If !UD_EnableCNotifications
            Debug.Notification(asText)
            Return
        EndIf
        _Text_Queue_String = PapyrusUtil.PushString(_Text_Queue_String, asText)
        _Text_Queue_Color = PapyrusUtil.PushInt(_Text_Queue_Color, aiColor)
        RegisterForSingleUpdate(_Animation_UpdateInstant)
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
        UDMain.Log("UD_WidgetControl::_CreateIconWidget() akData = " + akData + ", aiX = " + aiX + ", aiY = " + aiY + ", aiAlpha = " + aiAlpha, 3)
        If akData == None || akData.Name == ""
            Return
        EndIf
        If _CreateIcon_Mutex
            Int i = 0
            While i < 100 && _CreateIcon_Mutex
                Utility.Wait(0.05)
                i += 1
            EndWhile
        EndIf
        _CreateIcon_Mutex = True

        If (akData.Id > 0 && (akData.Variant != akData.VariantLoaded)) || abForceDestory
            iWidget.destroy(akData.Id)
            akData.Id = -1
        EndIf
        If akData.Id < 0
            akData.Id = iWidget.loadLibraryWidget(akData.FileName)
            akData.VariantLoaded = akData.Variant
        EndIf
        If akData.AuxId > 0 && abForceDestory
            iWidget.destroy(akData.AuxId)
            akData.AuxId = -1
        EndIf
        If akData.AuxId < 0
            akData.AuxId = iWidget.loadLibraryWidget("background")
        EndIf
        akData.Alpha = aiAlpha
        
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
    
    ; Update all icons after switching between states
    Function StatusEffect_AllUpdate()
;        Int i = _Icons_Name.Length
;        While i > 0
;            i -= 1
;            StatusEffect_SetVisible(_Icons_Name[i], _Icons_Visible[i])
;            StatusEffect_SetMagnitude(_Icons_Name[i], _Icons_Magnitude[i])
;            StatusEffect_SetBlink(_Icons_Name[i], _Icons_Blinking[i])
;        EndWhile
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
                iWidget.doTransitionByTime(_Text_LinesId[i], 0, 1.0, "alpha")
                iWidget.doTransitionByTime(_Text_LinesOutlineId[i], 0, 1.0, "alpha")
            EndWhile
            _Text_AnimStage = 2
        ElseIf _Text_AnimStage == 2 && _Text_Timer >= _Text_Duration + 1.0
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
