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

UnforgivingDevicesMain Property UDmain auto

;use iWantWidgets if true
Bool                        Property UD_UseIWantWidget = true auto

;exist
UD_WidgetBase               Property UD_Widget1 auto
UD_WidgetBase               Property UD_Widget2 auto

; new UI settings
Int                         Property    UD_TextFontSize             = 24    Auto    Hidden      ; text font size
Int                         Property    UD_TextLineLength           = 100   Auto    Hidden      ; length of line in text notification (not implemented)
Int                         Property    UD_TextReadSpeed            = 20    Auto    Hidden      ; symbols per second
Bool                        Property    UD_FilterVibNotifications   = True  Auto    Hidden      ; how long notification will be on the screen
Int                         Property    UD_TextAnchor               = 1     Auto    Hidden      ; anchor position of the notification (see W_POSY_**** constants)
Int                         Property    UD_TextPadding              = 0     Auto    Hidden      ; vertical padding relative to anchor
Int                         Property    UD_IconsSize                = 60    Auto    Hidden      ; effect icon size
Int                         Property    UD_IconsAnchor              = 1     Auto    Hidden      ; anchor position of the icons cluster (see W_POSX_**** constants)
Int                         Property    UD_IconsPadding             = 0     Auto    Hidden      ; horizontal padding relative to anchor

Int _WidgetXPos = 2
Int Property UD_WidgetXPos
    Function Set(Int aiVal)
        _WidgetXPos = aiVal
        if GetState() == ""
            UD_Widget1.PositionX = _WidgetXPos
            UD_Widget2.PositionX = _WidgetXPos
        else
            if !UD_AutoAdjustWidget
                InitWidgetsRequest()
            else
                UpdateGroupPositions()
            endif
        endif
    EndFunction
    Int Function Get()
        return _WidgetXPos
    EndFunction
EndProperty

Int _WidgetYPos = 0
Int Property UD_WidgetYPos
    Function Set(Int aiVal)
        _WidgetYPos = aiVal
        if GetState() == ""
            UD_Widget1.PositionY = _WidgetYPos
            UD_Widget2.PositionY = _WidgetYPos
        else
            if !UD_AutoAdjustWidget
                InitWidgetsRequest()
            else
                UpdateGroupPositions()
            endif
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
Bool _InitWidgetsRequested = False

Bool Property Ready = False auto
Event OnInit()
    Ready = True
    RegisterForSingleUpdate(30) ;maintenance update
EndEvent

Event OnUpdate()
    If _InitWidgetsRequested
        _InitWidgetsRequested = False
        InitWidgets()
    EndIf

    RegisterForSingleUpdate(30) ;maintenance update
EndEvent

Function Update()
    ;UDmain.Info("UD_WidgetControl::Update() UDmain.iWidgetInstalled = " + UDmain.iWidgetInstalled + " , UD_UseIWantWidget="+UD_UseIWantWidget)
    ; iWidget compatibility
    if UDmain.UseiWW()
        GoToState("iWidgetInstalled")
        UD_Widget1.hide(true)
        UD_Widget2.hide(true)
        _InitMutex = False
        InitWidgets(abGameLoad = True)
    else
        GoToState("")
        UD_WidgetXPos = UD_WidgetXPos
        UD_WidgetYPos = UD_WidgetYPos
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

Function InitWidgetsRequest()
    _InitWidgetsRequested = True
    RegisterForSingleUpdate(0.5)
EndFunction
Function InitWidgets(Bool abGameLoad = False)
EndFunction
Function InitIcons()
EndFunction
Function InitText()
EndFunction
Function _AddTextLineWidget()
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
EndFunction
Function Flash_DeviceCondWidget()
EndFunction
Function Flash_OrgasmWidget()
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
Int         _Text_AnimStage                 = -1    ; animation stage of notification lines
Float       _Text_Timer                             ; animation timer of notification lines
Float       _Text_Duration                          ; how long to display text on the screen

String[]    _Text_Queue                             ; notificztions in queue

Int[]       _Icons_Id                               ; widget id
String[]    _Icons_Name                             ; DDS file name in '<Data>/interface/exported/widgets/iwant/widgets/library' folder
Int[]       _Icons_Magnitude                        ; 0 .. 100+
Float[]     _Icons_Timer                            ; animation timer
Int[]       _Icons_Stage                            ; animation stage
Int[]       _Icons_Blinking                         ; 0, 1
Int[]       _Icons_Alpha                            ; 0 .. 100
Int[]       _Icon_Visible                           ; 0, 1

Int         _Widget_Icon_Inactive_Color             = 0xFFFFFF      ; Gray          Color of innactive effect
Int         _Widget_Icon_Active0_Color              = 0xFFFF00      ; Yellow        Color of active effect with magnitude 0
Int         _Widget_Icon_Active50_Color             = 0xFF0000      ; Red           Color of active effect with magnitude 50
Int         _Widget_Icon_Active100_Color            = 0xFF00FF      ; Magenta       Color of active effect with magnitude 100

Event OnBeginState()
    RegisterForSingleUpdate(30.0)
EndEvent
    
Function UpdateGroupPositions()
EndFunction
Function UpdateColor_Widget(Int aiId,int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
EndFunction
Int[] Function AddWidget(Int[] aaiGroup, Int aiWidget, Float fVerticalOffset, Int akPerc = 0, Int akCol1 = 0x0, Int akCol2 = 0x0, Int akCol3 = 0xFFFFFFFF)
EndFunction

Function Notification_Push(String asText)
    Debug.Notification(asText)
EndFunction
Function StatusEffect_SetVisible(String asName, Bool abVisible = True)
EndFunction
Function StatusEffect_SetMagnitude(String asName, Int aiMagnitude)
EndFunction
Function StatusEffect_IncMagnitude(String asName, Int aiIncrement, Bool abControlVisibility = True)
EndFunction
Function StatusEffect_SetBlink(String asName, Bool abBlink = True)
EndFunction
Function _SetIconRGB(Int aiWidget, Int aiRGB)
EndFunction
Function TestWidgets()
EndFunction
Function AnimateWidgets()
EndFunction
Function _AnimateNotifications(Float frame)
EndFunction
Function _AnimateIcons(Float frame)
EndFunction
Bool Function _NextNotification()
EndFunction
Int Function _GetIconIndex(String asName)
EndFunction
Int Function _CreateIcon(String asName, Int aiXOffset = -1, Int aiYOffset = -1, Int aiAlpha = -1)
EndFunction
;Fuck this stupid as shit. It's even harder to make widget position right

iWant_Widgets Property iWidget Hidden
    iWant_Widgets Function Get()
        return (UDmain.iWidgetQuest as iWant_Widgets)
    EndFunction
EndProperty

Float Property UD_WidgetVerOffset = 1.25 auto

;By default, auto adjust is turned off
Bool _AutoAdjustWidget = False
Bool Property UD_AutoAdjustWidget Hidden
    Function Set(Bool abVal)
        _AutoAdjustWidget = abVal
        if !_AutoAdjustWidget
            ;Reininit widgets
            InitWidgetsRequest()
        endif
    EndFunction
    Bool Function Get()
        return _AutoAdjustWidget
    EndFunction
EndProperty

Bool _InitMutex = False
;Use iWidget instead
State iWidgetInstalled

    Event OnBeginState()
        _Animation_LastGameTime = Utility.GetCurrentRealTime()
        _InitMutex = False
        RegisterForSingleUpdate(_Animation_Update)
    EndEvent
    
    Event OnUpdate()
        If _InitWidgetsRequested
            _InitWidgetsRequested = False
            InitWidgets()
        EndIf
        AnimateWidgets()
        RegisterForSingleUpdate(_Animation_Update)
    EndEvent

    ; abGameLoad        - flag that it's game load event. And we recreate all widgets regardless of previous IDs
    Function InitWidgets(Bool abGameLoad = False)
        if _InitMutex
            return
        endif
        _InitMutex = true
        RefreshCanvasMetrics()
        If abGameLoad
        ; clearing all IDs
            _Widget_DeviceDurability = -1
            _Widget_DeviceCondition = -1
            _Widget_Orgasm = -1
            _Text_LinesId = PapyrusUtil.IntArray(0)
            Int i = _Icons_Id.Length
            While i > 0
                i -= 1
                _Icons_Id[i] = -1
            EndWhile
        EndIf
        UnregisterForUpdate()
        Utility.Wait(_Animation_Update + 0.5)
        InitIcons()
        InitText()
        ;No autoadjust, reinit the widgets
        if !UD_AutoAdjustWidget
            ; Utility.wait(1.5) ;wait little time, so previous operatious could finish first
            if _Widget_DeviceDurability
                iWidget.destroy(_Widget_DeviceDurability)
            endif
            if _Widget_DeviceCondition
                iWidget.destroy(_Widget_DeviceCondition)
            endif
            if _Widget_Orgasm
                iWidget.destroy(_Widget_Orgasm)
            endif
            
            _WidgetsID = Utility.CreateIntArray(0)
            
            _Widget_DeviceDurability = iWidget.loadMeter()
            _WidgetsID = AddWidget(_WidgetsID, _Widget_DeviceDurability, 0*UD_WidgetVerOffset, _Widget_DeviceDurability_Perc, _Widget_DeviceDurability_Color, _Widget_DeviceDurability_Color2, _Widget_DeviceDurability_Color3)
            
            _Widget_DeviceCondition = iWidget.loadMeter()
            _WidgetsID = AddWidget(_WidgetsID, _Widget_DeviceCondition, 1.0*UD_WidgetVerOffset, _Widget_DeviceCondition_Perc, _Widget_DeviceCondition_Color, _Widget_DeviceCondition_Color2, _Widget_DeviceCondition_Color3)
            
            _Widget_Orgasm = iWidget.loadMeter()
            _WidgetsID = AddWidget(_WidgetsID, _Widget_Orgasm, 2.0*UD_WidgetVerOffset, _Widget_Orgasm_Perc, _Widget_Orgasm_Color, _Widget_Orgasm_Color2, _Widget_Orgasm_Color3)
            
            iWidget.setVisible(_Widget_DeviceDurability, _Widget_DeviceDurability_Visible As Int)
            iWidget.setVisible(_Widget_DeviceCondition, _Widget_DeviceCondition_Visible As Int)
            iWidget.setVisible(_Widget_Orgasm, _Widget_Orgasm_Visible As Int)
            
        endif
        _InitMutex = False
        RegisterForSingleUpdate(_Animation_Update)
    EndFunction
    
    Function InitText()
        If _Text_LinesId.Length == 0
            Int text_id = iWidget.loadText("", size = UD_TextFontSize)
            _Text_LinesId = PapyrusUtil.PushInt(_Text_LinesId, text_id)
        EndIf
        Int i = 0
        While i < _Text_LinesId.Length
            Int text_id = _Text_LinesId[i]
            If UD_TextAnchor >= 0 && UD_TextAnchor < 4
                iWidget.setPos(text_id, CalculateGroupXPos(W_POSX_CENTER), (CalculateGroupYPos(UD_TextAnchor) + UD_TextPadding + 1.5 * UD_TextFontSize * (_Text_LinesId.Length - 1)) as Int)
            Else
                UDMain.Warning("UD_WidgetControl::InitText() Unsupported value UD_TextAnchor = " + UD_TextAnchor)
            EndIf
            iWidget.setVisible(text_id, 0)
            iWidget.setTransparency(text_id, 0)
            i += 1
        EndWhile
        _Text_AnimStage = -1
        _Text_Timer = 0.0
    EndFunction
    
    Function _AddTextLineWidget()
        Int text_id = iWidget.loadText("", size = UD_TextFontSize)
        _Text_LinesId = PapyrusUtil.PushInt(_Text_LinesId, text_id)
        If UD_TextAnchor >= 0 && UD_TextAnchor < 4
            iWidget.setPos(text_id, CalculateGroupXPos(W_POSX_CENTER), (CalculateGroupYPos(UD_TextAnchor) + UD_TextPadding + 1.5 * UD_TextFontSize * (_Text_LinesId.Length - 1)) as Int)
        Else
            UDMain.Warning("UD_WidgetControl::_AddTextLineWidget() Unsupported value UD_TextAnchor = " + UD_TextAnchor)
        EndIf
        iWidget.setVisible(text_id, 0)
        iWidget.setTransparency(text_id, 0)
    EndFunction
    
    Function InitIcons()
        If UD_IconsAnchor == 0
            ; Left icons position
            ;
            ;          ###     ###
            ;          ###     ###
            ;               B
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
            
            Int x = CalculateGroupXPos(W_POSX_LEFT) + UD_IconsPadding + (0.55 * UD_IconsSize) As Int
            Int y = CalculateGroupYPos(W_POSY_CENTER) - UD_IconsSize - (0.55 * UD_IconsSize) As Int
            _CreateIcon("dd-plug-anal", x, y, 50)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("dd-plug-vaginal", x, y, 50)
            y += (UD_IconsSize * 1.1) As Int
            x -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("dd-piercing-clit", x, y, 50)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("dd-piercing-nipples", x, y, 50)

            x = CalculateGroupXPos(W_POSX_LEFT) + UD_IconsPadding
            y = CalculateGroupYPos(W_POSY_CENTER) + UD_IconsSize + (0.55 * UD_IconsSize) As Int
            _CreateIcon("effect-exhaustion", x, y, 75)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("effect-orgasm", x, y, 75)
        ElseIf UD_IconsAnchor == 1
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
            
            Int x = CalculateGroupXPos(W_POSX_CENTER) - 300 - UD_IconsPadding + (0.55 * UD_IconsSize) As Int
            Int y = CalculateGroupYPos(W_POSY_CENTER) + (0.55 * UD_IconsSize) As Int
            _CreateIcon("dd-plug-anal", x, y, 50)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("dd-plug-vaginal", x, y, 50)
            y += (UD_IconsSize * 1.1) As Int
            x -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("dd-piercing-clit", x, y, 50)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("dd-piercing-nipples", x, y, 50)

            x = CalculateGroupXPos(W_POSX_CENTER) + 300 + UD_IconsPadding
            y = CalculateGroupYPos(W_POSY_CENTER) + (0.55 * UD_IconsSize) As Int
            _CreateIcon("effect-exhaustion", x, y, 75)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("effect-orgasm", x, y, 75)
        ElseIf UD_IconsAnchor == 2
            Int x = CalculateGroupXPos(W_POSX_RIGHT) - UD_IconsPadding + (0.55 * UD_IconsSize) As Int
            Int y = CalculateGroupYPos(W_POSY_CENTER) - UD_IconsSize - (0.55 * UD_IconsSize) As Int
            _CreateIcon("dd-plug-anal", x, y, 50)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("dd-plug-vaginal", x, y, 50)
            y += (UD_IconsSize * 1.1) As Int
            x -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("dd-piercing-clit", x, y, 50)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("dd-piercing-nipples", x, y, 50)

            x = CalculateGroupXPos(W_POSX_RIGHT) - UD_IconsPadding
            y = CalculateGroupYPos(W_POSY_CENTER) + UD_IconsSize + (0.55 * UD_IconsSize) As Int
            _CreateIcon("effect-exhaustion", x, y, 75)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateIcon("effect-orgasm", x, y, 75)
        Else
            UDMain.Warning("UD_WidgetControl::InitIcons() Unsupported value UD_IconsAnchor = " + UD_IconsAnchor)
        EndIf
    EndFunction
    
    ; fVerticalOffset       - offset in meter's heights
    Int[] Function AddWidget(Int[] aaiGroup, Int aiWidget, Float fVerticalOffset, Int akPerc = 0, Int akCol1 = 0x0, Int akCol2 = 0x0, Int akCol3 = 0xFFFFFFFF)
        iWidget.setSize(aiWidget, HUDMeterHeight as Int, HUDMeterWidth as Int)
        ; on the top position we stack widgets from top to the bottom
        If UD_WidgetYPos == 2
            fVerticalOffset = -fVerticalOffset
        EndIf
        iWidget.setPos(aiWidget, CalculateGroupXPos(UD_WidgetXPos), (CalculateGroupYPos(UD_WidgetYPos) - HUDMeterHeightRef * fVerticalOffset) As Int)
        iWidget.setMeterPercent(aiWidget,akPerc)
        UpdateColor_Widget(aiWidget, akCol1,akCol2,akCol3)
        Return PapyrusUtil.PushInt(aaiGroup, aiWidget)
    EndFunction

    Function UpdateGroupPositions()
        if _InitMutex
            return
        endif
        if _Widget_DeviceDurability
            iWidget.destroy(_Widget_DeviceDurability)
        endif
        if _Widget_DeviceCondition
            iWidget.destroy(_Widget_DeviceCondition)
        endif
        if _Widget_Orgasm
            iWidget.destroy(_Widget_Orgasm)
        endif

        ; creating new instances
        ; restoring size, position, colors, percents and everything
        _WidgetsID = Utility.CreateIntArray(0)
        Float offset = 0.0
        if _Widget_DeviceDurability_Visible
            _Widget_DeviceDurability = iWidget.loadMeter()
            _WidgetsID = AddWidget(_WidgetsID, _Widget_DeviceDurability, offset, _Widget_DeviceDurability_Perc, _Widget_DeviceDurability_Color, _Widget_DeviceDurability_Color2, _Widget_DeviceDurability_Color3)
            offset += UD_WidgetVerOffset
        endif
        if _Widget_DeviceCondition_Visible
            _Widget_DeviceCondition = iWidget.loadMeter()
            _WidgetsID = AddWidget(_WidgetsID, _Widget_DeviceCondition, offset, _Widget_DeviceCondition_Perc, _Widget_DeviceCondition_Color, _Widget_DeviceCondition_Color2, _Widget_DeviceCondition_Color3)
            offset += UD_WidgetVerOffset
        endif
        if _Widget_Orgasm_Visible
            _Widget_Orgasm = iWidget.loadMeter()
            _WidgetsID = AddWidget(_WidgetsID, _Widget_Orgasm, offset, _Widget_Orgasm_Perc, _Widget_Orgasm_Color, _Widget_Orgasm_Color2, _Widget_Orgasm_Color3)
            offset += UD_WidgetVerOffset
        endif
        
        ;show all widgets at the end, so they can't be seen moving
        iWidget.setVisible(_Widget_DeviceDurability, _Widget_DeviceDurability_Visible As Int)
        iWidget.setVisible(_Widget_DeviceCondition, _Widget_DeviceCondition_Visible As Int)
        iWidget.setVisible(_Widget_Orgasm, _Widget_Orgasm_Visible As Int)
    EndFunction
    
    ;toggle widget
    Function Toggle_DeviceWidget(bool abVal, Bool abUpdateVisPos = True)
        if UD_AutoAdjustWidget
            if _Widget_DeviceDurability_Visible != abVal
                _Widget_DeviceDurability_Visible = abVal
                if abUpdateVisPos
                    UpdateGroupPositions()
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
                    UpdateGroupPositions()
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
                    UpdateGroupPositions()
                endif
            endif
        else
            _Widget_Orgasm_Visible = abVal
            iWidget.setVisible(_Widget_Orgasm, _Widget_Orgasm_Visible As Int)
        endif
    EndFunction

    Function UpdatePercent_DeviceWidget(Float afVal,Bool abForce = false)
        _Widget_DeviceDurability_Perc = Round(afVal*100)
        if !_InitMutex
            iWidget.setMeterPercent(_Widget_DeviceDurability, _Widget_DeviceDurability_Perc)
        endif
    EndFunction
    Function UpdatePercent_DeviceCondWidget(Float afVal,Bool abForce = false)
        _Widget_DeviceCondition_Perc = Round(afVal*100)
        if !_InitMutex
            iWidget.setMeterPercent(_Widget_DeviceCondition, _Widget_DeviceCondition_Perc)
        endif
    EndFunction
    Function UpdatePercent_OrgasmWidget(Float afVal,Bool abForce = false)
        _Widget_Orgasm_Perc = Round(afVal*100)
        if !_InitMutex
            iWidget.setMeterPercent(_Widget_Orgasm, _Widget_Orgasm_Perc)
        endif
    EndFunction

    Function UpdateColor_DeviceWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
        UpdateColor_Widget(_Widget_DeviceDurability,aiColor,aiColor2,aiFlashColor)
    EndFunction
    Function UpdateColor_DeviceCondWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
        UpdateColor_Widget(_Widget_DeviceCondition,aiColor,aiColor2,aiFlashColor)
    EndFunction
    Function UpdateColor_OrgasmWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
        UpdateColor_Widget(_Widget_Orgasm,aiColor,aiColor2,aiFlashColor)
    EndFunction
    
    ;use to convert from hex to this sinfull way of writting colors
    Function UpdateColor_Widget(Int aiId,int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
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
    ; save current values
        Int[] magnitudes = PapyrusUtil.SliceIntArray(_Icons_Magnitude, 0)
        Float[] timers = PapyrusUtil.SliceFloatArray(_Icons_Timer, 0)
        Int[] stages = PapyrusUtil.SliceIntArray(_Icons_Stage, 0)
        Int[] blinks = PapyrusUtil.SliceIntArray(_Icons_Blinking, 0)
        Int[] alphas = PapyrusUtil.SliceIntArray(_Icons_Alpha, 0)
        Int[] visibles = PapyrusUtil.SliceIntArray(_Icon_Visible, 0)

        Notification_Push("TEST 1 TEST 1 TEST 1 TEST 1")
        Notification_Push("TEST 2 TEST 2 TEST 2 TEST 2 TEST 2 TEST 2 TEST 2 TEST 2")

        StatusEffect_SetVisible("dd-plug-anal", True)
        StatusEffect_SetVisible("dd-plug-vaginal", True)
        StatusEffect_SetVisible("dd-piercing-clit", True)
        StatusEffect_SetVisible("dd-piercing-nipples", True)
        StatusEffect_SetVisible("effect-exhaustion", True)
        StatusEffect_SetVisible("effect-orgasm", True)
        
        StatusEffect_SetMagnitude("dd-plug-anal", 0)
        StatusEffect_SetMagnitude("dd-plug-vaginal", 25)
        StatusEffect_SetMagnitude("dd-piercing-clit", 50)
        StatusEffect_SetMagnitude("dd-piercing-nipples", 75)
        StatusEffect_SetMagnitude("effect-exhaustion", 50)
        StatusEffect_SetMagnitude("effect-orgasm", 100)

        StatusEffect_SetBlink("dd-plug-anal", True)
        StatusEffect_SetBlink("dd-plug-vaginal", True)
        StatusEffect_SetBlink("dd-piercing-clit", True)
        StatusEffect_SetBlink("dd-piercing-nipples", True)
        
        Utility.Wait(5.0)

    ; load last values
        _Icons_Magnitude = magnitudes
        _Icons_Timer = timers
        _Icons_Stage = stages
        _Icons_Blinking = blinks
        _Icons_Alpha = alphas
        _Icon_Visible = visibles
        Int i = _Icons_Name.Length
        While i > 0
            i -= 1
            StatusEffect_SetVisible(_Icons_Name[i], _Icon_Visible[i])
            StatusEffect_SetMagnitude(_Icons_Name[i], _Icons_Magnitude[i])
            StatusEffect_SetBlink(_Icons_Name[i], _Icons_Blinking[i])
        EndWhile
    EndFunction
    
    ; quickly push a string into array and leave the function
    Function Notification_Push(String asText)
        If UD_FilterVibNotifications && StringUtil.Find(asText, "vibr") >= 0
        ; TODO: Implement
            Return
        EndIf
        _Text_Queue = PapyrusUtil.PushString(_Text_Queue, asText)
        RegisterForSingleUpdate(_Animation_UpdateInstant)
    EndFunction
    
    Bool Function _NextNotification()
        If _Text_Queue.Length == 0
            Return False
        EndIf
        String str = _Text_Queue[0]
        _Text_Queue = PapyrusUtil.SliceStringArray(_Text_Queue, 1)
        _Text_Duration = (StringUtil.GetLength(str) as Float) / (UD_TextReadSpeed as Float)
    ; TODO: multiline
        iWidget.setText(_Text_LinesId[0], str)
        Return True
    EndFunction
    
    Int Function _GetIconIndex(String asName)
        Int index = _Icons_Name.Find(asName)
        If index == -1
            index = _CreateIcon(asName)
        EndIf
        Return index
    EndFunction
    
    Int Function _CreateIcon(String asName, Int aiX = -1, Int aiY = -1, Int aiAlpha = -1)
        UDMain.Log("UD_WidgetControl::_CreateIcon() asName = " + asName + ", aiX = " + aiX + ", aiY = " + aiY + ", aiAlpha = " + aiAlpha, 3)
        If aiX < 0 || aiY < 0
            UDMain.Warning("UD_WidgetControl::_CreateIcon() icon created without proper positioning")
            aiX = CanvasWidth / 2
            aiY = CanvasHeight / 2
        EndIf
        Int icon_id = -1
        Int index = _Icons_Name.Find(asName)
        If index >= 0
            If _Icons_Id[index] > 0
                icon_id = _Icons_Id[index]
            Else
                icon_id = iWidget.loadLibraryWidget(asName)
                _Icons_Id[index] = icon_id
            EndIf
            If aiAlpha >= 0
                _Icons_Alpha[index] = aiAlpha
            EndIf
        Else
            icon_id = iWidget.loadLibraryWidget(asName)
            _Icons_Name = PapyrusUtil.PushString(_Icons_Name, asName)
            _Icons_Id = PapyrusUtil.PushInt(_Icons_Id, icon_id)
            _Icons_Timer = PapyrusUtil.PushFloat(_Icons_Timer, 0.0)
            _Icons_Magnitude = PapyrusUtil.PushInt(_Icons_Magnitude, 0)
            _Icons_Stage = PapyrusUtil.PushInt(_Icons_Stage, 0)
            _Icons_Blinking = PapyrusUtil.PushInt(_Icons_Blinking, 0)
            _Icon_Visible = PapyrusUtil.PushInt(_Icon_Visible, 0)
            _Icons_Alpha = PapyrusUtil.PushInt(_Icons_Alpha, aiAlpha)
            index = _Icons_Id.Length - 1
        EndIf
        iWidget.setSize(icon_id, UD_IconsSize, UD_IconsSize)
        iWidget.setPos(icon_id, aiX, aiY)
        iWidget.setTransparency(icon_id, aiAlpha)
        iWidget.setVisible(icon_id, _Icon_Visible[index])
        Return index
    EndFunction
    
    Function StatusEffect_SetVisible(String asName, Bool abVisible = True)
        Int index = _GetIconIndex(asName)
        iWidget.setVisible(_Icons_Id[index], abVisible as Int)
        _Icon_Visible[index] = abVisible as Int
        If abVisible
            iWidget.setTransparency(_Icons_Id[index], _Icons_Alpha[index])
        Else
            _Icons_Blinking[index] = 0
        EndIf
    EndFunction
    
    Function StatusEffect_SetMagnitude(String asName, Int aiMagnitude)
        Int index = _GetIconIndex(asName)
        _Icons_Magnitude[index] = aiMagnitude
        _SetIconRGB(_Icons_Id[index], aiMagnitude)
    EndFunction
    
    Function StatusEffect_IncMagnitude(String asName, Int aiIncrement, Bool abControlVisibility = True)
        Int index = _GetIconIndex(asName)
        _Icons_Magnitude[index] = _Icons_Magnitude[index] + aiIncrement
        If _Icons_Magnitude[index] < 0
            _Icons_Magnitude[index] = 0
        EndIf
        If abControlVisibility
            _Icon_Visible[index] = (_Icons_Magnitude[index] > 0) as Int
            iWidget.setVisible(_Icons_Id[index], _Icon_Visible[index])
        EndIf
        _SetIconRGB(_Icons_Id[index], _Icons_Magnitude[index])
    EndFunction
    
    Function StatusEffect_SetBlink(String asName, Bool abBlink = True)
        Int index = _GetIconIndex(asName)
        _Icons_Blinking[index] = abBlink As Int
        RegisterForSingleUpdate(_Animation_UpdateInstant)
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
    
    Function AnimateWidgets()
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
                iWidget.doTransitionByTime(_Text_LinesId[i], 100, 0.2, "alpha")
            EndWhile
            _Text_Timer = 0.0
            _Text_AnimStage = 1
        ElseIf _Text_AnimStage == 1 && _Text_Timer >= _Text_Duration
        ; fade out stage
            Int i = _Text_LinesId.Length
            While i > 0
                i -= 1
                iWidget.doTransitionByTime(_Text_LinesId[i], 0, 1.0, "alpha")
            EndWhile
            _Text_AnimStage = 2
        ElseIf _Text_AnimStage == 2 && _Text_Timer >= _Text_Duration + 1.0
            _Text_AnimStage = -1
            Int i = _Text_LinesId.Length
            While i > 0
                i -= 1
                iWidget.setVisible(_Text_LinesId[i], 0)
                iWidget.setTransparency(_Text_LinesId[i], 0)
            EndWhile
        EndIf
    EndFunction

    Function _AnimateIcons(Float frame)
        Int i = _Icons_Id.Length
        While i > 0
            i -= 1
            Int icon_id = _Icons_Id[i]
            Float timer = _Icons_Timer[i]
            Int magnitude = _Icons_Magnitude[i]
            String name =  _Icons_Name[i]
            Int anim_stage = _Icons_Stage[i]
            Bool blink = _Icons_Blinking[i] > 0
            Bool visible = _Icon_Visible[i] > 0
            timer += frame
            
            If visible && anim_stage == -1
                iWidget.setVisible(icon_id, 1)
                anim_stage = 0
            ElseIf !visible && anim_stage != -1
                iWidget.setVisible(icon_id, 0)
                anim_stage = -1
            EndIf
            If blink
                If ((timer / 0.5) As Int) % 2 == 0
                    iWidget.doTransitionByTime(icon_id, 25, 0.5, "alpha")
                Else
                    iWidget.doTransitionByTime(icon_id, 100, 0.5, "alpha")
                EndIf
                anim_stage = 1
            ElseIf anim_stage == 1
                iWidget.doTransitionByTime(icon_id, _Icons_Alpha[i], 0.1, "alpha")
            EndIf
            _Icons_Timer[i] = timer
            _Icons_Stage[i] = anim_stage
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