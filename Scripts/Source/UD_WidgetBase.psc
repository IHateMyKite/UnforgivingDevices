Scriptname UD_WidgetBase extends SKI_WidgetBase  

;copied and modified script for DD Escape Overhall, because i have no idea wtf is going on

; Widget Configuration
float           _width                  = 292.8
float           _height                 = 25.2
int             _primaryColor           = 0xE727F5
int             _secondaryColor         = 0xF775FF
int             _flashColor             = 0xFF00BC
string          _fillDirection          = "left"
float           _percent                = 1.0

Float HUDMeterWidthRef = 248.0
Float HUDMeterHeightRef = 15.0

int _positionX = 2
int Property PositionX
    {Pre set X position of widget. 0 = Left, 1 = Middle, 2 = Right; Default: 2}
    int function get()
        return _positionX
    endFunction

    function set(int a_val)
        if a_val >= 0 && a_val <= 2
            _positionX = a_val

            ; These formulas are mostly empirical and do not provide 100% accuracy.
            ; Tested on resolutions: 1920*1080, 2560*1440, 2560*1080, 3440*1440, (4000*1440, 4000*1080)
            ; Wide screen resolutions tested with mods:
            ; - Complete Widescreen Fix for Vanilla and SkyUI 2.2 and 5.2 SE (https://www.nexusmods.com/skyrimspecialedition/mods/1778)
            ; - Ultrawidescreen Fixes for Skyrim LE (https://www.nexusmods.com/skyrim/mods/90214)

            Float magica_x = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Magica._x")
            Float health_x = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Health._x")
            Float stamina_x = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._x")
            Float meter_width = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._width")
            Float hud_width = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance._width")
            Float hud_padding = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefY")
            Float hud_left = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefX")
            Float hud_right = UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefX")
            
            Float le_corr1 = 0
            Float le_corr2 = 35
            
            ; SE or LE
            ; minor formula corrections for LE version
            If SKSE.GetVersion() == 1
                le_corr1 = 50
                le_corr2 = 19.5
            ElseIf SKSE.GetVersion() == 2
                le_corr1 = 0
                le_corr2 = 35
            EndIf
            ; screen width factor: 16:9 is 1.0, 21:9 is 1.3125, etc.
            Float width_mult = ((hud_right - hud_left) + 2 * hud_padding - le_corr1) / (1280 - le_corr1)

;   |           |
;   |           |             |<- width ->|
;   |           |             <===========>
;   └-----------└----------------------------
;   <- offset -> <- padding ->

; all coordinates refer to 1280*720 regardless of screen aspect ratio

            Float offset
            Float padding
            Float ref_meter_width
            
            offset = 271.0 / width_mult
            padding = (48.0 + le_corr2) / width_mult + (hud_padding - le_corr2)
            ref_meter_width = HUDMeterWidthRef / width_mult
            
            if (Ready) 
                if _positionX == 0 ;left
                    X = offset + padding
                    FillDirection = "right"
                elseif _positionX == 1 ;middle
                    X = offset + 1280.0 / 2.0 - ref_meter_width / 2.0
                    FillDirection = "center"
                elseif _positionX == 2 ;right
                    X = offset + 1280.0 - ref_meter_width - padding
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
                if _positionY == 0      ; near the bottom 
                    Y = UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefY") - HUDMeterHeightRef * (0.5 + PositionYOffset)
                elseif _positionY == 1  ; 3/4 to the bottom
                    Y = (3 * UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.BottomRightRefY") + UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefY")) / 4 - HUDMeterHeightRef * (0.5 + PositionYOffset)
                elseif _positionY == 2  ; on the top
                    Y = UI.getFloat("HUD Menu", "_root.HUDMovieBaseInstance.TopLeftRefY") + HUDMeterHeightRef * (0.5 + PositionYOffset);
                endif
            endIf
        endif
    endFunction
EndProperty

Float Property PositionYOffset Auto
{Additional offset measured in widget's heights (not screen height but HUDMeterHeightRef!). 
Value 0.0 means that widget will be placed exactly on the anchor points, i.e. will 'replace' existing HUD meter on bottom position.
Value 1.0 means that widget will be placed just above (below) anchor point, i.e. will 'touch' existing HUD meter on bottom position}

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

; override this so I don't have to recalculate widget position for different values
; HAnchor property becomes useless
function UpdateWidgetHAnchor()
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setHAnchor", "right")
endFunction

; override this so I don't have to recalculate widget position for different values
; VAnchor property becomes useless
function UpdateWidgetVAnchor()
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setVAnchor", "center")
endFunction