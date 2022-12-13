Scriptname UD_HardcoreDisable_Script extends activemagiceffect  

import UnforgivingDevicesMain

Actor _target = none
UDCustomDeviceMain      Property UDCDmain auto

UnforgivingDevicesMain  Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
EndProperty

MagicEffect _MagickEffect = none

int _MapKeyCode         = -1
int _StatsKeyCode       = -1
int _TweenMenuKeyCode   = -1
int _MagicKeyCode       = -1

bool    _MenuKeyPressed = false
bool    _MenuOpen = false
int     loc_tick = 0
bool    loc_GameMenuOpen = false

Bool loc_finished = false
Bool loc_isPlayer = false
Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget  
    
    while UI.IsMenuOpen("Dialogue Menu")
        Utility.waitMenuMode(1.0) ;wait for player to end dialogue before applying effect
    endwhile
    
    closeMenu()
    
    _MapKeyCode         = Input.GetMappedKey("Quick Map")
    _StatsKeyCode       = Input.GetMappedKey("Quick Stats")
    _TweenMenuKeyCode   = Input.GetMappedKey("Tween menu")
    _MagicKeyCode       = Input.GetMappedKey("Quick Magic")
    
    Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
    Game.EnableFastTravel(false)
    
    RegisterForKey(_MapKeyCode)
    RegisterForKey(_StatsKeyCode)
    RegisterForKey(_TweenMenuKeyCode)
    RegisterForKey(_MagicKeyCode)
    
    registerForSingleUpdate(0.1)
EndEvent

Function Update()
    if _TweenMenuKeyCode == -1
        _TweenMenuKeyCode = Input.GetMappedKey("Tween menu")
        RegisterForKey(_TweenMenuKeyCode)
    elseif _MagicKeyCode == -1
        _MagicKeyCode = Input.GetMappedKey("Quick Magic")
        RegisterForKey(_MagicKeyCode)
    endif
EndFunction

bool loc_precessing = false
Event OnUpdate()
    loc_precessing = true
    if !_target.wornhaskeyword(UDCDmain.libs.zad_DeviousHeavyBondage) || !UDCDmain.UD_HardcoreMode
        _target.RemoveSpell(UDCDmain.UDlibs.HardcoreDisableSpell)
    elseif !loc_finished
        if !UDCDmain.PlayerInMinigame()
            if !_MenuKeyPressed
                Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
            endif
            if !(loc_tick % 10)
                Game.EnableFastTravel(false)
            endif
        endif
        
        Update()

        if !loc_finished
            if !(loc_tick % 5)
                if !UDmain.isMenuOpen()
                    CheckMapKey()
                    CheckStatsKey()
                    CheckTweenKey()
                    CheckMagicKey()
                endif
            endif
            if !_MenuOpen && _MenuKeyPressed && !(loc_tick % 6)
                _MenuOpen = false
                _MenuKeyPressed = false
                RegisterForKey(_MapKeyCode)
                RegisterForKey(_StatsKeyCode)
                RegisterForKey(_TweenMenuKeyCode)
                RegisterForKey(_MagicKeyCode)
            endif
            loc_tick += 1
            registerForSingleUpdate(1.0)
        endif
    endif
    loc_precessing = false
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    loc_finished = true
    ;wait for onUpdate function to finish if it started
    while loc_precessing
        Utility.waitMenuMode(1.0)
    endwhile

    if _target.wornhaskeyword(UDCDmain.libs.zad_DeviousHeavyBondage) && UDCDmain.UD_HardcoreMode
        if _target.hasSpell(UDCDmain.UDlibs.HardcoreDisableSpell)
            _target.RemoveSpell(UDCDmain.UDlibs.HardcoreDisableSpell)
        endif
        _target.AddSpell(UDCDmain.UDlibs.HardcoreDisableSpell,False)
        UDmain.Error("Hardcore disabler is still present on player, readding !")
    else
        Utility.waitMenuMode(0.75) ;wait a little time
        UDmain.libsp.ProcessPlayerControls(abCheckMinigame = true)
        Game.EnableFastTravel(true)
    endif
EndEvent

Event OnKeyDown(Int KeyCode)
    if !UDMain.IsMenuOpen()
        if UDCDmain.PlayerInMinigame()
            return
        endif
        if UDmain.TraceAllowed()
            UDCDmain.Log("UD_HardcoreDisable_Script - OnKeyDown for " + KeyCode,3)
        endif
        If KeyCode == _MapKeyCode
            OpenMenu(_MapKeyCode, "MapMenu")
        elseif KeyCode == _StatsKeyCode
            OpenMenu(_StatsKeyCode, "StatsMenu")
        elseif KeyCode == _MagicKeyCode
            OpenMenu(_MagicKeyCode, "MagicMenu")
        elseif KeyCode == _TweenMenuKeyCode && !Game.UsingGamepad()
            UDCDmain.getHeavyBondageDevice(UDmain.Player).deviceMenu(new Bool[30])
        endif
    endif
EndEvent

Function OpenMenu(Int aiKey, string asMenu)
    _MenuKeyPressed = true
    UnRegisterForKey(aiKey)
    RegisterForMenu(asMenu)
    Utility.waitMenuMode(0.1)
    Game.EnablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
    Input.TapKey(aiKey)
EndFunction

Event OnMenuOpen(String MenuName)
    if UDmain.TraceAllowed()
        UDCDmain.Log("UD_HardcoreDisable_Script - OnMenuOpen for " + MenuName,3)
    endif
    If MenuName == "MapMenu"
        _MenuOpen = true
    elseif MenuName == "StatsMenu"
        _MenuOpen = true
    elseif MenuName == "MagicMenu"
        _MenuOpen = true
    endif
EndEvent

Event OnMenuClose(String MenuName)
    if UDmain.TraceAllowed()
        UDCDmain.Log("UD_HardcoreDisable_Script - OnMenuClose for " + MenuName,3)
    endif
    If MenuName == "MapMenu"
        CloseOpenedMenu(_MapKeyCode, "MapMenu")
    elseif MenuName == "StatsMenu"
        CloseOpenedMenu(_StatsKeyCode, "StatsMenu")
    elseif MenuName == "MagicMenu"
        CloseOpenedMenu(_MagicKeyCode, "MagicMenu")
    endif
    
EndEvent

Function CloseOpenedMenu(Int aiKey, String asMenu)
    Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
    RegisterForKey(aiKey)
    UnRegisterForMenu(asMenu)
    _MenuKeyPressed = false
    _MenuOpen = false
EndFunction

Function CheckMapKey()
    int MapKeyCode = Input.GetMappedKey("Quick Map")
    if MapKeyCode != _MapKeyCode
        UnRegisterForKey(_MapKeyCode)
        _MapKeyCode = MapKeyCode
        RegisterForKey(_MapKeyCode)
        UDmain.Info("UD_HardcoreDisable_Script - Remaping keycode for map menu")
    endif
EndFunction

Function CheckStatsKey()
    int StatsMenu = Input.GetMappedKey("Quick Stats")
    if StatsMenu != _StatsKeyCode
        UnRegisterForKey(_StatsKeyCode)
        _StatsKeyCode = StatsMenu
        RegisterForKey(_StatsKeyCode)
        UDmain.Info("UD_HardcoreDisable_Script - Remaping keycode for Quick Map menu")
    endif
EndFunction

Function CheckMagicKey()
    int MagicMenu = Input.GetMappedKey("Quick Magic")
    if MagicMenu != _MagicKeyCode
        UnRegisterForKey(_MagicKeyCode)
        _MagicKeyCode = MagicMenu
        RegisterForKey(_MagicKeyCode)
        UDmain.Info("UD_HardcoreDisable_Script - Remaping keycode for Quick Magic menu")
    endif
EndFunction

Function CheckTweenKey()
    int TweenMenu = Input.GetMappedKey("Tween menu")
    if TweenMenu != _TweenMenuKeyCode
        UnRegisterForKey(_TweenMenuKeyCode)
        _TweenMenuKeyCode = TweenMenu
        RegisterForKey(_TweenMenuKeyCode)
        UDmain.Info("UD_HardcoreDisable_Script - Remaping keycode for Tween menu")
    endif
EndFunction