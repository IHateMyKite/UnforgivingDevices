ScriptName UD_WidgetControl extends Quest

import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto

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
            UpdateGroupPositions()
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
            UpdateGroupPositions()
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
    UDmain.Warning("UD_WidgetControl::Update() UDmain.iWidgetInstalled = " + UDmain.iWidgetInstalled)
    ; iWidget compatibility
    if UDmain.iWidgetInstalled
        GoToState("iWidgetInstalled")
        RefreshCanvasMetrics()
        UD_Widget1.hide(true)
        UD_Widget2.hide(true)
        InitWidgets()
    else
        GoToState("")
    endif
;    GoToState("")
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
Function Toggle_DeviceWidget(bool abVal)
    if abVal
        UD_Widget1.show(true)
    else
        UD_Widget1.hide(true)
    endif
EndFunction
Function Toggle_OrgasmWidget(bool abVal)
    if abVal
        UD_Widget2.show(true)
    else
        UD_Widget2.hide(true)
    endif
EndFunction

Function UpdatePercent_DeviceWidget(Float afVal,Bool abForce = false)
    UD_Widget1.SetPercent(afVal, abForce)
EndFunction
Function UpdatePercent_OrgasmWidget(Float afVal,Bool abForce = false)
    UD_Widget2.SetPercent(afVal, abForce)
EndFunction

Function UpdateColor_DeviceWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
    UD_Widget1.SetColors(aiColor, aiColor2,aiFlashColor)
EndFunction
Function UpdateColor_OrgasmWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
    UD_Widget2.SetColors(aiColor, aiColor2,aiFlashColor)
EndFunction

Function Flash_DeviceWidget()
EndFunction

Function Flash_OrgasmWidget()
EndFunction

;iWidget variables, should not be used ifiWidget is not installed
Int     _Widget_DeviceDurability            = -1
Bool    _Widget_DeviceDurability_Visible    = False
Int     _Widget_DeviceCondition             = -1
Bool    _Widget_DeviceCondition_Visible     = False
Int     _Widget_Orgasm                      = -1
Bool    _Widget_Orgasm_Visible              = False

;GROUP
Int[] _WidgetsID

Function UpdateGroupPositions()
EndFunction
Function UpdateColor_Widget(Int aiId,int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
EndFunction
Int[] Function AddWidget(Int[] aaiGroup, Int aiWidget, Float fVerticalOffset, Float afMultX = 1.0, Float afMultY = 1.0)
EndFunction
Int Function AddWidget2(Float fVerticalOffset)
EndFunction


;Fuck this stupid as shit. It's even harder to make widget position right

iWant_Widgets Property iWidget Hidden
    iWant_Widgets Function Get()
        return (UDmain.iWidgetQuest as iWant_Widgets)
    EndFunction
EndProperty

;Use iWidget instead
State iWidgetInstalled
    Function InitWidgets()

        UpdateGroupPositions()
        UpdatePercent_DeviceWidget(1)
        Toggle_DeviceWidget(True)
        Toggle_OrgasmWidget(True)

        If False
            iWidget.setSize(_Widget_DeviceDurability, HUDMeterHeight as Int, HUDMeterWidth as Int)
            iWidget.setPos(_Widget_DeviceDurability, CalculateGroupXPos(UD_WidgetXPos), (CalculateGroupYPos(UD_WidgetYPos)) As Int)
            iWidget.setVisible(_Widget_DeviceDurability, 0)
            iWidget.setMeterPercent(_Widget_DeviceDurability, 25)

            iWidget.setVisible(_Widget_DeviceDurability, 1)
            iWidget.doMeterFlash(_Widget_DeviceDurability)
            iWidget.setMeterRGB(_Widget_DeviceDurability, 255, 255, 255, 0, 0, 0, 128, 128, 128)
    ;        iWidget.setSize(_Widget_DeviceDurability, HUDMeterHeight as Int, (HUDMeterWidth - 1) as Int)
    ;        iWidget.setPos(_Widget_DeviceDurability, CalculateGroupXPos(UD_WidgetXPos), (CalculateGroupYPos(UD_WidgetYPos)) As Int)   
            iWidget.setMeterPercent(_Widget_DeviceDurability, 50)
         EndIf

        ; TEST PLACEMENT
        If True    
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
            
            If False
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
            EndIf
        EndIf
    EndFunction
    
    ; fVerticalOffset       - offset in meter's heights
    Int[] Function AddWidget(Int[] aaiGroup, Int aiWidget, Float fVerticalOffset, Float afMultX = 1.0, Float afMultY = 1.0)
        iWidget.setSize(aiWidget, HUDMeterHeight as Int, HUDMeterWidth as Int)
        ; on the top position we stack widgets from top to the bottom
        If UD_WidgetYPos == 2
            fVerticalOffset = -fVerticalOffset
        EndIf
        iWidget.setPos(aiWidget, CalculateGroupXPos(UD_WidgetXPos), (CalculateGroupYPos(UD_WidgetYPos) - HUDMeterHeightRef * fVerticalOffset) As Int)
        ; iWidget.setZoom(aiWidget, Round(afMultX * 100), Round(afMultY * 100))
        return PapyrusUtil.PushInt(aaiGroup, aiWidget)
    EndFunction
    
    Int Function AddWidget2(Float fVerticalOffset)
        Int id = iWidget.loadMeter()
        iWidget.setSize(id, HUDMeterHeight as Int, HUDMeterWidth as Int)
        ; on the top position we stack widgets from top to the bottom
        If UD_WidgetYPos == 2
            fVerticalOffset = -fVerticalOffset
        EndIf
        iWidget.setPos(id, CalculateGroupXPos(UD_WidgetXPos), (CalculateGroupYPos(UD_WidgetYPos) - HUDMeterHeightRef * fVerticalOffset) As Int)
        Return id
    EndFunction
    
    Function UpdateGroupPositions()
        ; destroying old instances because they are infected with the setMeterPercent function
        If _Widget_DeviceDurability
            iWidget.destroy(_Widget_DeviceDurability)
        EndIf
        If _Widget_DeviceCondition
            iWidget.destroy(_Widget_DeviceCondition)
        EndIf
        If _Widget_Orgasm
            iWidget.destroy(_Widget_Orgasm)
        EndIf
        
        ; creating new instances
        ; restoring size, position, colors, percents and everything
        _WidgetsID = Utility.CreateIntArray(0)
        Float offset = 0.0
        _Widget_DeviceDurability = AddWidget2(offset)
        _WidgetsID = PapyrusUtil.PushInt(_WidgetsID, _Widget_DeviceDurability)
        iWidget.setVisible(_Widget_DeviceDurability, _Widget_DeviceDurability_Visible As Int)
        ; testing
        iWidget.setMeterPercent(_Widget_DeviceDurability, Utility.RandomInt(0, 100))
        offset += 1.5
        
        _Widget_DeviceCondition = AddWidget2(offset)
        _WidgetsID = PapyrusUtil.PushInt(_WidgetsID, _Widget_DeviceCondition)
        iWidget.setVisible(_Widget_DeviceCondition, _Widget_DeviceCondition_Visible As Int)
        ; testing
        iWidget.setMeterPercent(_Widget_DeviceCondition, Utility.RandomInt(0, 100))
        offset += 1.5
        
        _Widget_Orgasm = AddWidget2(offset)
        _WidgetsID = PapyrusUtil.PushInt(_WidgetsID, _Widget_Orgasm)
        iWidget.setVisible(_Widget_Orgasm, _Widget_Orgasm_Visible As Int)
        ; testing
        iWidget.setMeterPercent(_Widget_Orgasm, Utility.RandomInt(0, 100))
        offset += 1.5
        
;        iWidget.drawShapeLine(_WidgetsID,CalculateGroupXPos(_WidgetXPos),CalculateGroupYPos(_WidgetYPos),0,-1*Math.Ceiling(iWidget.getYsize(_WidgetsID[0])*0.5) - 1)
    EndFunction
    
    ;toggle widget
    Function Toggle_DeviceWidget(bool abVal)
        _Widget_DeviceDurability_Visible = abVal
;        UpdateGroupPositions()
        iWidget.setVisible(_Widget_DeviceDurability, abVal as Int)
    EndFunction
    Function Toggle_OrgasmWidget(bool abVal)
        _Widget_Orgasm_Visible = abVal
;        UpdateGroupPositions()
        iWidget.setVisible(_Widget_Orgasm, abVal as Int)
    EndFunction

    Function UpdatePercent_DeviceWidget(Float afVal,Bool abForce = false)
        iWidget.setMeterPercent(_Widget_DeviceDurability, Round(afVal*100))
    EndFunction
    Function UpdatePercent_OrgasmWidget(Float afVal,Bool abForce = false)
        iWidget.setMeterPercent(_Widget_Orgasm, Round(afVal*100))
    EndFunction

    Function UpdateColor_DeviceWidget(int aiColor,int aiColor2 = 0,int aiFlashColor = 0xFFFFFF)
        UpdateColor_Widget(_Widget_DeviceDurability,aiColor,aiColor2,aiFlashColor)
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
    EndFunction
    
    Function Flash_DeviceWidget()
        iWidget.doMeterFlash(_Widget_DeviceDurability)
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
