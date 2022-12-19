ScriptName UD_WidgetControl extends Quest

import UnforgivingDevicesMain

; CONSTANTS
Int W_POSY_TOP = 0
Int W_POSY_MIDDLE = 3
Int W_POSY_LOWER = 1
Int W_POSY_BOTTOM = 2
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
Int                         Property    UD_IconsSize            = 60    Auto    Hidden
Int                         Property    UD_DDIconsAnchorX       = 1     Auto    Hidden      ; W_POSX_CENTER
Int                         Property    UD_DDIconsAnchorY       = 3     Auto    Hidden      ; W_POSY_MIDDLE
Int                         Property    UD_DDIconsOffsetX       = -300  Auto    Hidden
Int                         Property    UD_DDIconsOffsetY       = 0     Auto    Hidden
Int                         Property    UD_BuffIconsAnchorX     = 1     Auto    Hidden      ; W_POSX_CENTER
Int                         Property    UD_BuffIconsAnchorY     = 3     Auto    Hidden      ; W_POSY_MIDDLE
Int                         Property    UD_BuffIconsOffsetX     = 300   Auto    Hidden
Int                         Property    UD_BuffIconsOffsetY     = 0     Auto    Hidden

Int _WidgetXPos = 2
Int Property UD_WidgetXPos
    Function Set(Int aiVal)
        _WidgetXPos = aiVal
        if GetState() == ""
            UD_Widget1.PositionX = _WidgetXPos
            UD_Widget2.PositionX = _WidgetXPos
        else
            if !UD_AutoAdjustWidget
                InitWidgets()
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
                InitWidgets()
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

Bool Property Ready = False auto
Event OnInit()
    Ready = True
    RegisterForSingleUpdate(30) ;maintenance update
EndEvent

Event OnUpdate()
    ;UNUSED
    RegisterForSingleUpdate(30) ;maintenance update
EndEvent

;Disabled. Might return to it in far away future
Function Update()
    UDmain.Info("UD_WidgetControl::Update() UDmain.iWidgetInstalled = " + UDmain.iWidgetInstalled + " , UD_UseIWantWidget="+UD_UseIWantWidget)
    ; iWidget compatibility
    if UDmain.UseiWW()
        GoToState("iWidgetInstalled")
        UD_Widget1.hide(true)
        UD_Widget2.hide(true)
        InitWidgets()
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

Function InitWidgets()
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

Float _Animation_LastGameTime
Float _Notifications_QueueStart
Int[] _Notifications_Id
Int[] _Notifications_AnimStage
Float[] _Notifications_Timer
Float[] _Notifications_Duration
String[] _Notification_NewText

Int[] _Icons_Id                 ; widget id
String[] _Icons_Name            ; DDS file name in '<Data>/interface/exported/widgets/iwant/widgets/library' folder
Int[] _Icons_Magnitude             ; 0 .. 100
Float[] _Icons_Timer            ; animation timer
Int[] _Icons_Stage              ; animation stage

Int     _Widget_Icon_Inactive_Color             = 0xFFFFFF
Int     _Widget_Icon_Active0_Color              = 0xFFFF00
Int     _Widget_Icon_Active50_Color             = 0xFF0000
Int     _Widget_Icon_Active100_Color            = 0xFF00FF

Event OnBeginState()
    RegisterForSingleUpdate(30.0)
EndEvent
    
Function UpdateGroupPositions()
EndFunction
Function UpdateColor_Widget(Int aiId,int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
EndFunction
Int[] Function AddWidget(Int[] aaiGroup, Int aiWidget, Float fVerticalOffset, Int akPerc = 0, Int akCol1 = 0x0, Int akCol2 = 0x0, Int akCol3 = 0xFFFFFFFF)
EndFunction

Function ShowNotification(String asText)
    Debug.Notification(asText)
EndFunction

Function AnimateWidgets()
EndFunction
Function _ProcessNewNotifications()
EndFunction
Int Function _CreateNewIcon(String asName, Int aiXOffset = -1, Int aiYOffset = -1, Int aiAlpha = 100)
EndFunction
Function ToggleStatusEffect(String asName, Bool abShow = True, Int aiStrength = 0)
EndFunction
Function IncrementStatusEffect(String asName, Int aiIncrement = 20, Bool abHideIfZero = True)
EndFunction
Function _SetIconRGB(Int aiWidget, Int aiRGB)
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
            InitWidgets()
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
        RegisterForSingleUpdate(0.5)
    EndEvent
    
    Event OnUpdate()
        AnimateWidgets()
        RegisterForSingleUpdate(0.5)
    EndEvent

    Function InitWidgets()
        UDMain.Log("UD_WidgetControl::InitWidgets()")
        RefreshCanvasMetrics()
        ;No autoadjust, reinit the widgets
        if !UD_AutoAdjustWidget
            if _InitMutex
                return
            endif
            _InitMutex = true
            Utility.wait(1.5) ;wait little time, so previous operatious could finish first
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
            
            ;          XXX     XXX                          XXX
            ;          XXX     XXX                          XXX
            ;               a               X                b
            ;          XXX     XXX                          XXX
            ;          XXX     XXX                          XXX
            ;
            ; a - DD Icons Anchor + Offset          b - Buff Icons Anchor + Offset
            
            Int x = CalculateGroupXPos(UD_DDIconsAnchorX) + UD_DDIconsOffsetX + (0.55 * UD_IconsSize) As Int
            Int y = CalculateGroupYPos(UD_DDIconsAnchorY) + UD_DDIconsOffsetY + (0.55 * UD_IconsSize) As Int
            _CreateNewIcon("dd-plug-anal", x, y, 50)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateNewIcon("dd-plug-vaginal", x, y, 50)
            y += (UD_IconsSize * 1.1) As Int
            x -= (UD_IconsSize * 1.1) As Int
            _CreateNewIcon("dd-piercing-clit", x, y, 50)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateNewIcon("dd-piercing-nipples", x, y, 50)

            x = CalculateGroupXPos(UD_BuffIconsAnchorX) + UD_BuffIconsOffsetX
            y = CalculateGroupYPos(UD_BuffIconsAnchorY) + UD_BuffIconsOffsetY + (0.55 * UD_IconsSize) As Int
            _CreateNewIcon("effect-exhaustion", x, y, 100)
            y -= (UD_IconsSize * 1.1) As Int
            _CreateNewIcon("effect-orgasm", x, y, 100)
            
            _InitMutex = false
        endif
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
    
    ; quickly push a string into array and leave the function
    Function ShowNotification(String asText)
        _Notification_NewText = PapyrusUtil.PushString(_Notification_NewText, asText)
        RegisterForSingleUpdate(0.1)
    EndFunction
    
    ; create new notifications in a single thread (hopefully)
    ; TODO: multiline text
    Function _ProcessNewNotifications()
        Int len = _Notification_NewText.Length
        Int i = 0
        While i < len
            Int text_id = iWidget.loadText(_Notification_NewText[i], size = 24)
            Int anim_stage = 0              ; invisible
            Float timer = 0.0               ; lifetime timer
            iWidget.setPos(text_id, CalculateGroupXPos(W_POSX_CENTER), CalculateGroupYPos(W_POSY_LOWER))
            If _Notifications_QueueStart >= 0.0
                _Notifications_QueueStart = 0.0
                anim_stage = 1              ; visible
                iWidget.setVisible(text_id, 1)
            Else
                timer = _Notifications_QueueStart
            EndIf
            Float time_to_read = (StringUtil.GetLength(_Notification_NewText[i]) as Float) / 25.0
            ; next notifications will wait some time before appearing
            _Notifications_QueueStart -= time_to_read + 1.0
            _Notifications_Id = PapyrusUtil.PushInt(_Notifications_Id, text_id)
            _Notifications_Timer = PapyrusUtil.PushFloat(_Notifications_Timer, timer)
            _Notifications_AnimStage = PapyrusUtil.PushInt(_Notifications_AnimStage, anim_stage)
            _Notifications_Duration = PapyrusUtil.PushFloat(_Notifications_Duration, time_to_read)
            i += 1
        EndWhile
        _Notification_NewText = PapyrusUtil.SliceStringArray(_Notification_NewText, len, -1)
    EndFunction
    
    Int Function _CreateNewIcon(String asName, Int aiX = -1, Int aiY = -1, Int aiAlpha = 100)
        UDMain.Log("UD_WidgetControl::_CreateNewIcon() asName = " + asName + ", aiX = " + aiX + ", aiY = " + aiY)
        If aiX < 0 || aiY < 0
            UDMain.Warning("UD_WidgetControl::_CreateNewIcon() icon created without proper positioning")
            aiX = CanvasWidth / 2
            aiY = CanvasHeight / 2
        EndIf
        Int icon_id = iWidget.loadLibraryWidget(asName)
        iWidget.setSize(icon_id, UD_IconsSize, UD_IconsSize)
    ; TODO: Set proper places for each icon (effect)
        iWidget.setPos(icon_id, aiX, aiY)
        iWidget.setTransparency(icon_id, aiAlpha)
        _Icons_Name = PapyrusUtil.PushString(_Icons_Name, asName)
        _Icons_Id = PapyrusUtil.PushInt(_Icons_Id, icon_id)
        _Icons_Timer = PapyrusUtil.PushFloat(_Icons_Timer, 0.0)
        _Icons_Magnitude = PapyrusUtil.PushInt(_Icons_Magnitude, 0)
        _Icons_Stage = PapyrusUtil.PushInt(_Icons_Stage, 0)
        
        Return _Icons_Id.Length - 1
    EndFunction
    
    Function ToggleStatusEffect(String asName, Bool abShow = True, Int aiMagnitude = 0)
        UDMain.Log("UD_WidgetControl::ToggleStatusEffect() asName = " + asName + ", abShow = " + abShow + ", aiMagnitude = " + aiMagnitude)
        Int index = _Icons_Name.Find(asName)
        If index == -1
            index = _CreateNewIcon(asName)
        EndIf
        iWidget.setVisible(_Icons_Id[index], abShow as Int)
        _Icons_Magnitude[index] = aiMagnitude
        _SetIconRGB(_Icons_Id[index], aiMagnitude)
    EndFunction

    Function IncrementStatusEffect(String asName, Int aiIncrement = 20, Bool abHideIfZero = True)
        UDMain.Log("UD_WidgetControl::IncrementStatusEffect() asName = " + asName + ", aiIncrement = " + aiIncrement + ", abHideIfZero = " + abHideIfZero)
        Int index = _Icons_Name.Find(asName)
        If index == -1
            index = _CreateNewIcon(asName)
        EndIf
        _Icons_Magnitude[index] = _Icons_Magnitude[index] + aiIncrement
        If _Icons_Magnitude[index] < 0
            _Icons_Magnitude[index] = 0
        EndIf
        If abHideIfZero && _Icons_Magnitude[index] <= 0
            iWidget.setVisible(_Icons_Id[index], 0)
        Else
            iWidget.setVisible(_Icons_Id[index], 1)
        EndIf
        _SetIconRGB(_Icons_Id[index], _Icons_Magnitude[index])
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
            G  = (Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active100_Color,8),0xFF) * (m - 50) + Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active50_Color,8),0xFF)) * (100 - m) / 50
            B  = (Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active100_Color,0),0xFF) * (m - 50) + Math.LogicalAnd(Math.RightShift(_Widget_Icon_Active50_Color,0),0xFF)) * (100 - m) / 50
        EndIf
        iWidget.setRGB(aiWidget, R, G, B)
    EndFunction
    
    Function AnimateWidgets()
        Float real_time = Utility.GetCurrentRealTime()
        Float frame = real_time - _Animation_LastGameTime
        _Animation_LastGameTime = real_time
        ; Notifications
        _ProcessNewNotifications()
        _Notifications_QueueStart += frame
        Int i = _Notifications_Id.Length
        Bool ready_to_purge = True
        While i > 0
            i -= 1
            Int text_id = _Notifications_Id[i]
            If text_id > -1
                ready_to_purge = False
                Float timer = _Notifications_Timer[i]
                Int anim_stage = _Notifications_AnimStage[i]
                Float time_to_read = _Notifications_Duration[i]
                timer += frame
                If anim_stage == 0 && timer >= 0.0
                ; visible stage
                    iWidget.setVisible(text_id, 1)
                    anim_stage = 1
                ElseIf anim_stage == 1 && timer >= time_to_read
                ; fade out stage
                    anim_stage = 2
                    iWidget.doTransitionByTime(text_id, 0, 1.0, "alpha")
                ElseIf anim_stage == 2 && timer >= time_to_read + 2.0
                ; ending stage
                    iWidget.destroy(text_id)
                    text_id = -1
                    anim_stage = -1
                EndIf
                _Notifications_Id[i] = text_id
                _Notifications_Timer[i] = timer
                _Notifications_AnimStage[i] = anim_stage
            EndIf
        EndWhile
        If _Notifications_Id.Length > 0 && ready_to_purge
        ; TODO: remove first elements when they become invisible
            _Notifications_Id = PapyrusUtil.ResizeIntArray(_Notifications_Id, 0)
            _Notifications_Timer = PapyrusUtil.ResizeFloatArray(_Notifications_Timer, 0)
            _Notifications_Duration = PapyrusUtil.ResizeFloatArray(_Notifications_Duration, 0)
            _Notifications_AnimStage = PapyrusUtil.ResizeIntArray(_Notifications_AnimStage, 0)
        EndIf
        ; Icons
        i = _Icons_Id.Length
        While i > 0
            i -= 1
            Int icon_id = _Icons_Id[i]
            Float timer = _Icons_Timer[i]
            Int magnitude = _Icons_Magnitude[i]
            String name =  _Icons_Name[i]
            Int anim_stage = _Icons_Stage[i]
            timer += frame
            
            If StringUtil.Substring(name, 0, 3) == "dd-"
                If magnitude > 0
                    If ((timer / 0.5) As Int) % 2 == 0
                        iWidget.doTransitionByTime(icon_id, 25, 0.5, "alpha")
                    Else
                        iWidget.doTransitionByTime(icon_id, 100, 0.5, "alpha")
                    EndIf
                    anim_stage = 1
                ElseIf anim_stage == 1
                    anim_stage = 0
                    iWidget.doTransitionByTime(icon_id, 50, 0.1, "alpha")
                EndIf
            EndIf
            _Icons_Timer[i] = timer
            _Icons_Stage[i] = anim_stage
        EndWhile
    EndFunction    
EndState

Int Function CalculateGroupXPos(int aival)
    if aival == 0           ; left
        return (HUDPaddingX + HUDMeterWidthRef / 2) As Int
    elseif aival == 1       ; center
        return (CanvasWidth * 5 / 10) As Int
    elseif aival == 2       ; right
        return (CanvasWidth - HUDPaddingX - HUDMeterWidthRef / 2) As Int
    endif
endFunction

Int Function CalculateGroupYPos(int aival)
    if aival == 0           ; down
        ; added offset to not overlap existing HUD indicators
        return (CanvasHeight - HUDPaddingY - HUDMeterHeightRef / 2 - 1.5 * HUDMeterHeightRef) As Int
    elseif aival == 1       ; less down
        return (CanvasHeight * 3 / 4 - HUDPaddingY / 2 + HUDMeterHeightRef / 2) As Int
    elseif aival == 2       ; top
        ; added offset to not overlap existing HUD indicators
        return (HUDPaddingY + HUDMeterHeightRef / 2 + 1.5 * HUDMeterHeightRef) As Int
    elseif aival == 3       ; middle
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