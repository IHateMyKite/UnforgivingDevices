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

String  Property MODULE_NAME hidden
    String Function get()
        return self.GetName()
    EndFunction
EndProperty
String  Property MODULE_ALIAS = "NOAL"    auto  ; alias
String  Property MODULE_DESC  = ""        auto  ; description
Int     Property MODULE_PRIO  = 1         auto  ; priority
Quest[] Property MODULE_DEP               auto  ; dependency

; private variables
Bool _SetupCalled   = False
Bool _SetupDone     = False
Bool _ReloadCalled  = False
Bool _ReloadDone    = False

Bool _Initiated       = False
Bool _SetupAfterInit  = False ; Flag to prevent multiple setups after start/reset
Event OnInit()
    _Initiated = True
    _SetupAfterInit = True
    ;UnforgivingDevicesMain.GInfo("Initiating module: " + MODULE_NAME + " (" + MODULE_ALIAS + ") : [" + MODULE_PRIO + "] : {"+self+"}")
EndEvent

; =================
; PRIVATE METHODS
; =================
Function _Setup()
    Utility.waitMenuMode(0.016)
    if _SetupAfterInit
        _SetupCalled = True
        _SetupAfterInit = False
        ;UnforgivingDevicesMain.GInfo("Setting up module: " + MODULE_NAME + " (" + MODULE_ALIAS + ") : [" + MODULE_PRIO + "] : {"+self+"}")
        OnSetup()
        _GameReload()
        _SetupDone = True
    endif
EndFunction

Function _GameReload()
    _ReloadCalled = True
    ;UnforgivingDevicesMain.GInfo("Reloading module: " + MODULE_NAME + " (" + MODULE_ALIAS + ") : [" + MODULE_PRIO + "] : {"+self+"}")
    OnGameReload()
    _ReloadDone = True
EndFunction

; =================
; PUBLIC METHODS
; =================

Bool Function IsReady()
    return _SetupDone && (_ReloadDone || !_ReloadCalled)
EndFunction

Bool Function ResetModule()
    UD_Native.ResetModule(self)
EndFunction

Function WaitForReady(Float afTimeout)
    Float _time = 0.0
    While !IsReady() && _time < afTimeout
      _time += 0.25
      Utility.Wait(0.25)
    EndWhile
    if _time >= afTimeout
      UDMain.Error("Timeout of waiting for module " + MODULE_NAME + " to be readdy!")
    endif
EndFUnction

; =================
; Overrides
; =================

Function OnSetup()
    ;OVERRIDE
EndFunction

Function OnGameReload()
    ;OVERRIDE
EndFunction