Scriptname UD_WidgetBase extends SKI_WidgetBase  

;copied and modified script for DD Escape Overhall, because i have no idea wtf is going on

; Widget Configuration
float    _width            = 292.8
float    _height            = 25.2
int        _primaryColor    = 0xE727F5
int        _secondaryColor    = 0xF775FF
int        _flashColor        = 0xFF00BC
string     _fillDirection    = "left"
float    _percent        = 1.0

int _positionX = 2
int Property PositionX
    {Pre set X position of widget. 0 = Left, 1 = Middle, 2 = Right; Default: 2}
    int function get()
        return _positionX
    endFunction

    function set(int a_val)
        if a_val >= 0 && a_val <= 2
            _positionX = a_val
            if (Ready) 
                if _positionX == 0 ;left
                    X = UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefX") +  Width + UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Health._x") + 2 ;magica boyyyyyyyyy
                    FillDirection = "right"
                elseif _positionX == 1 ;middle
                    X = UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefX") + (UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefX") - UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefX"))/2.0 + Width/2.0
                    FillDirection = "center"
                elseif _positionX == 2 ;right
                    X = Math.floor(UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefX") - UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Health._x")) - 2
                    FillDirection = "left"
                endif
            endIf
        endif
    endFunction
EndProperty

int _positionY = 0
int Property PositionY
    {Pre set Y position of widget. 0 = Down, 1 = Less Down, 2 = Up; Default: 0}
    int function get()
        return _positionY
    endFunction

    function set(int a_val)
        if a_val >= 0 && a_val <= 2
            _positionY = a_val
            if (Ready) 
                if _positionY == 0 ;down
                    ;debug.trace("[UD]: Bottom right ref y:" + UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefY"))
                    ;debug.trace("[UD]: Widget y size:" + Height)
                    ;debug.trace("[UD]: old" + (UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefY") - Math.Ceiling(1.05*Height)))
                    ;debug.trace("[UD]: new" + (UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefY") - Math.Ceiling(1.85*Height)))
                    
                    Y = 633
                elseif _positionY == 1 ;less down
                    Y = UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefY") - 3.0*Height
                elseif _positionY == 2 ;top
                    Y = UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefY") + 3.5*Height; - 2.05*Height
                endif
            endIf
        endif
    endFunction
EndProperty

float property Width
    {Width of the meter in pixels at a resolution of 1280x720. Default: 292.8}
    float function get()
        return _width
    endFunction

    function set(float a_val)
        _width = a_val
        if (Ready)
            UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setWidth", _width)
        endIf
    endFunction
endProperty

float property Height
    {Height of the meter in pixels at a resolution of 1280x720. Default: 25.2}
    float function get()
        return _height
    endFunction

    function set(float a_val)
        _height = a_val
        if (Ready)
            UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setHeight", _height)
        endIf
    endFunction
endProperty

int property PrimaryColor
    {Primary color of the meter gradient RRGGBB [0x000000, 0xFFFFFF]. Default: 0xFF0000. Convert to decimal when editing this in the CK}
    int function get()
        return _primaryColor
    endFunction

    function set(int a_val)
        _primaryColor = a_val
        if (Ready)
            UI.InvokeInt(HUD_MENU, WidgetRoot + ".setColor", _primaryColor)
        endIf
    endFunction
endProperty

int property SecondaryColor
    {Secondary color of the meter gradient, -1 = automatic. RRGGBB [0x000000, 0xFFFFFF]. Default: -1. Convert to decimal when editing this in the CK}
    int function get()
        return _secondaryColor
    endFunction

    function set(int a_val)
        SetColors(_primaryColor, a_val, _flashColor)
    endFunction
endProperty

int property FlashColor
    {Color of the meter warning flash, -1 = automatic. RRGGBB [0x000000, 0xFFFFFF]. Default: -1. Convert to decimal when editing this in the CK}
    int function get()
        return _flashColor
    endFunction

    function set(int a_val)
        _flashColor = a_val
        if (Ready)
            UI.InvokeInt(HUD_MENU, WidgetRoot + ".setFlashColor", _flashColor)
        endIf
    endFunction
endProperty

string property FillDirection
    {The position at which the meter fills from, ["left", "center", "right"] . Default: center}
    string function get()
        return _fillDirection
    endFunction

    function set(string a_val)
        _fillDirection = a_val
        if (Ready)
            UI.InvokeString(HUD_MENU, WidgetRoot + ".setFillDirection", _fillDirection)
        endIf
    endFunction
endProperty

float property Percent
    {Percent of the meter [0.0, 1.0]. Default: 0.0}
    float function get()
        return _percent
    endFunction

    function set(float a_val)
        If a_val > 1.0
            a_val = 1.0
        ElseIf a_val < 0
            a_val = 0
        EndIf
        _percent = a_val
        if (Ready)
            UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPercent", _percent)
        endIf
    endFunction
endProperty

event OnWidgetReset()
    parent.OnWidgetReset()

    ;updateSize()
    init()
    PositionX = _positionX
    PositionY = _positionY    
endEvent

Function init()
    float[] numberArgs = new float[6]
    numberArgs[0] = Width
    numberArgs[1] = Height
    numberArgs[2] = _primaryColor as float
    numberArgs[3] = _secondaryColor as float
    numberArgs[4] = _flashColor as float
    numberArgs[5] = _percent
    UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".initNumbers", numberArgs)
    UI.Invoke(HUD_MENU, WidgetRoot + ".initCommit")
EndFunction

Function updateSize()
    Width = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._width")
    Height = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._height")
EndFunction

string function GetWidgetSource()
    return "UD/meter.swf"
endFunction

string function GetWidgetType()
 return "_DE_SKI_MeterWidget"
endFunction

function SetPercent(float a_percent, bool a_force = false)
    If a_percent > 1.0
        a_percent = 1.0
    ElseIf a_percent < 0
        a_percent = 0
    EndIf
    _percent = a_percent
    if (Ready)
        float[] args = new float[2]
        args[0] = a_percent
        args[1] = a_force as float
        UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".setPercent", args)
    endIf
endFunction

function SetColors(int a_primaryColor, int a_secondaryColor = -1, int a_flashColor = -1)
    _primaryColor = a_primaryColor;
    _secondaryColor = a_secondaryColor;
    _flashColor = a_flashColor;

    if (Ready)
        int[] args = new int[3]
        args[0] = a_primaryColor
        args[1] = a_secondaryColor
        args[2] = a_flashColor
        UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setColors", args)
    endIf
endFunction

Function Flash()
    UI.Invoke(HUD_MENU, WidgetRoot + ".StartBlinking")
EndFUnction

Function Show(bool inst = false)
    If !Ready
        return
    EndIf    
    ;UI.InvokeBool(HUD_MENU, WidgetRoot + ".setEnabled", True) 
    ;UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVisible",True)
    
    ;updateSize()
    
    If inst
        self.Alpha = 100
        self.UpdateWidgetAlpha()
    Else
        self.FadeTo(100, 1.0)
    EndIf
EndFunction

Function Hide(bool inst = false)
    If !Ready
        return
    EndIf
    
    ;updateSize()
    
    If inst
        self.Alpha = 0
        self.UpdateWidgetAlpha()
    Else
        self.FadeTo(0, 1.0)
    EndIf
EndFunction
