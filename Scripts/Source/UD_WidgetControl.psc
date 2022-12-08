ScriptName UD_WidgetControl extends Quest

import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto

;use iWantWidgets if true
Bool                        Property UD_UseIWantWidget = true auto

;exist
UD_WidgetBase               Property UD_Widget1 auto
UD_WidgetBase               Property UD_Widget2 auto


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

Function UpdateGroupPositions()
EndFunction
Function UpdateColor_Widget(Int aiId,int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
EndFunction
Int[] Function AddWidget(Int[] aaiGroup, Int aiWidget, Float fVerticalOffset, Int akPerc = 0, Int akCol1 = 0x0, Int akCol2 = 0x0, Int akCol3 = 0xFFFFFFFF)
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
        if !abVal
            ;Reininit widgets
            InitWidgets()
        endif
        _AutoAdjustWidget = abVal
    EndFunction
    Bool Function Get()
        return _AutoAdjustWidget
    EndFunction
EndProperty


;Use iWidget instead
State iWidgetInstalled
    Function InitWidgets()
        RefreshCanvasMetrics()
        ;No autoadjust, reinit the widgets
        if !UD_AutoAdjustWidget
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
        iWidget.setMeterPercent(_Widget_DeviceDurability, _Widget_DeviceDurability_Perc)
    EndFunction
    Function UpdatePercent_DeviceCondWidget(Float afVal,Bool abForce = false)
        _Widget_DeviceCondition_Perc = Round(afVal*100)
        iWidget.setMeterPercent(_Widget_DeviceCondition, _Widget_DeviceCondition_Perc)
    EndFunction
    Function UpdatePercent_OrgasmWidget(Float afVal,Bool abForce = false)
        _Widget_Orgasm_Perc = Round(afVal*100)
        iWidget.setMeterPercent(_Widget_Orgasm, _Widget_Orgasm_Perc)
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