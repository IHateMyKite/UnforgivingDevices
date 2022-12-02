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
    ;iWidget compatibility
    ;if UDmain.iWidgetInstalled
    ;    GoToState("iWidgetInstalled")
    ;    UD_Widget1.hide(true)
    ;    UD_Widget2.hide(true)
    ;    InitWidgets()
    ;else
    ;    GoToState("")
    ;endif
    GoToState("")
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
Int[] Function AddWidget(Int[] aaiGroup,Int aiWidget,Float afMultX = 1.0,Float afMultY = 1.0)
EndFunction


;Fuck this stupid as shit. It's even harder to make widget position right
;/
iWant_Widgets Property iWidget Hidden
    iWant_Widgets Function Get()
        return (UDmain.iWidgetQuest as iWant_Widgets)
    EndFunction
EndProperty

;Use iWidget instead
State iWidgetInstalled
    Function InitWidgets()
        _Widget_DeviceDurability = iWidget.loadMeter()
        _Widget_DeviceCondition  = iWidget.loadMeter()
        _Widget_Orgasm = iWidget.loadMeter()
        UpdateGroupPositions()
    EndFunction
    Int[] Function AddWidget(Int[] aaiGroup,Int aiWidget, Float afMultX = 1.0,Float afMultY = 1.0)
        iWidget.setZoom(aiWidget, Round(afMultX*100), Round(afMultY*100))
        return PapyrusUtil.PushInt(aaiGroup,aiWidget)
    EndFunction
    
    Function UpdateGroupPositions()
        _WidgetsID = Utility.CreateIntArray(0)
        
        if _Widget_DeviceDurability
            _WidgetsID = AddWidget(_WidgetsID, _Widget_DeviceDurability,0.5,0.5)
        endif
        if _Widget_DeviceCondition_Visible
            _WidgetsID = AddWidget(_WidgetsID, _Widget_DeviceCondition,0.5,0.5)
        endif
        if _Widget_Orgasm_Visible
            _WidgetsID = AddWidget(_WidgetsID, _Widget_Orgasm,0.5,0.5)
        endif
        
        iWidget.drawShapeLine(_WidgetsID,CalculateGroupXPos(_WidgetXPos),CalculateGroupYPos(_WidgetYPos),0,-1*Math.Ceiling(iWidget.getYsize(_WidgetsID[0])*0.5) - 1)
    EndFunction
    
    ;toggle widget
    Function Toggle_DeviceWidget(bool abVal)
        _Widget_DeviceDurability_Visible = abVal
        UpdateGroupPositions()
        iWidget.setVisible(_Widget_DeviceDurability, abVal as Int)
    EndFunction
    Function Toggle_OrgasmWidget(bool abVal)
        _Widget_Orgasm_Visible = abVal
        UpdateGroupPositions()
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
    Int loc_size = iWidget.getXsize(_Widget_DeviceDurability)
    if aival == 0
        return 2*1280/10 - loc_size/2
    elseif aival == 1
        return 5*1280/10 - loc_size/2
    else
        return 8*1280/10 - loc_size/2
    endif
endFunction

Int Function CalculateGroupYPos(int aival)
    if aival == 0 ;down
        return 8*720/10
    elseif aival == 1 ;less down
        return 5*720/10
    elseif aival == 2 ;top
        return 2*720/10
    endif
endFunction
/;