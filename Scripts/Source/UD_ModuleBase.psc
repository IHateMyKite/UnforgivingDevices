; WIP: UNUSED

;   File: UD_ModuleBase
;   This is base scripts of all quest modules with exception of UnforgivingDevicesMain and MCM script
Scriptname UD_ModuleBase extends Quest

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty

Bool _Setup     = False
Bool _Updating  = False
Bool _Disabled  = False

Event OnInit()
    ;unused!
EndEvent

Function Setup()
    OnSetup()
    _Setup = true
EndFunction

Function OnSetup()
    ;OVERRIDE
EndFunction

Function GameUpdate()
    _Updating = True
    OnGameUpdate()
    _Updating = False
EndFunction

Function OnGameUpdate()
    ;OVERRIDE
EndFunction

Function Disable()
    _Disabled = true
EndFunction
Function Enable()
    _Disabled = false
EndFunction

Bool Function IsDisabled()
    return _Disabled
EndFunction
Bool Function IsReady()
    return _Updating && _Setup
EndFunction