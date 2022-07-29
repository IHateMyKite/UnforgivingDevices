Scriptname UD_UserInputScript extends Quest

Import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto
UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
zadlibs Property libs
    zadlibs Function get()
        return UDmain.libs
    EndFunction
EndProperty
UD_CustomDevices_NPCSlotsManager Property UDCD_NPCM
    UD_CustomDevices_NPCSlotsManager Function get()
        return UDmain.UDNPCM
    EndFunction
EndProperty

UD_CustomDevice_RenderScript Property lastOpenedDevice     = none auto hidden
bool _specialButtonOn

Event keyUnregister(string eventName = "none", string strArg = "", float numArg = 0.0, Form sender = none)
    if UDmain.TraceAllowed()    
        UDmain.Log("UDCustomHeavyBondageMain OnKeyUnregister called",1)
    endif
    UnregisterForAllKeys()
EndEvent

Event MinigameKeysRegister()
    if UDmain.TraceAllowed()    
        UDmain.Log("UDCustomDevicemain MinigameKeysRegister called",1)
    endif
    RegisterForKey(UDCDMain.Stamina_meter_Keycode)
    RegisterForKey(UDCDMain.SpecialKey_Keycode)
    RegisterForKey(UDCDMain.Magicka_meter_Keycode)
    _specialButtonOn = false
EndEvent

Event MinigameKeysUnregister()
    if UDmain.TraceAllowed()    
        UDmain.Log("UDCustomDevicemain MinigameKeysUnregister called",1)
    endif
    if !KeyIsUsedGlobaly(UDCDMain.Stamina_meter_Keycode)
        UnregisterForKey(UDCDMain.Stamina_meter_Keycode)
    endif
    if !KeyIsUsedGlobaly(UDCDMain.SpecialKey_Keycode)
        UnregisterForKey(UDCDMain.SpecialKey_Keycode)
    endif
    if !KeyIsUsedGlobaly(UDCDMain.Magicka_meter_Keycode)
        UnregisterForKey(UDCDMain.Magicka_meter_Keycode)
    endif
    _specialButtonOn = false
EndEvent

Function RegisterGlobalKeys()
    if UDmain.TraceAllowed()    
        UDmain.Log("RegisterGlobalKeys")
    endif
    RegisterForKey(UDCDMain.StruggleKey_Keycode)
    RegisterForKey(UDCDMain.PlayerMenu_KeyCode)
    RegisterForKey(UDCDMain.ActionKey_Keycode)
    RegisterForKey(UDCDMain.NPCMenu_Keycode)
EndFunction

Function UnregisterGlobalKeys()
    if UDmain.TraceAllowed()    
        UDmain.Log("UnregisterGlobalKeys")
    endif
    UnRegisterForKey(UDCDMain.StruggleKey_Keycode)
    UnRegisterForKey(UDCDMain.PlayerMenu_KeyCode)
    UnRegisterForKey(UDCDMain.ActionKey_Keycode)
    UnRegisterForKey(UDCDMain.NPCMenu_Keycode)
EndFunction

bool Function KeyIsUsedGlobaly(int keyCode)
    bool loc_res = false
    loc_res = loc_res || (keyCode == UDCDMain.StruggleKey_Keycode)
    loc_res = loc_res || (keyCode == UDCDMain.PlayerMenu_KeyCode)
    loc_res = loc_res || (keyCode == UDCDMain.NPCMenu_Keycode)
    loc_res = loc_res || (keyCode == UDCDMain.ActionKey_Keycode)
    return loc_res
EndFunction

State Minigame
    Event OnKeyDown(Int KeyCode)
        ;help variables to reduce lag
        bool     _crit                    = UDCDmain.crit 
        string   _selected_crit_meter     = UDCDmain.selected_crit_meter
        
        if _crit
            UDCDmain.crit = false
        else
            _selected_crit_meter     = UDCDmain.selected_crit_meter
        endif

        bool loc_menuopen = UDmain.IsMenuOpen()
        if !loc_menuopen ;only if player is not in menu
            if UDmain.TraceAllowed()        
                UDmain.Log("OnKeyDown(), Keycode: " + KeyCode,3)
            endif
            if (_crit) && !UDCDMain.UD_AutoCrit
                if _selected_crit_meter == "S" && KeyCode == UDCDMain.Stamina_meter_Keycode
                    UDCDmain.crit = False
                    _crit = False
                    if UDmain.TraceAllowed()                    
                        UDmain.Log("Crit detected for Stamina bar! Keycode: " + KeyCode)
                    endif
                    UDCDmain.CurrentPlayerMinigameDevice.critDevice()
                    return
                elseif _selected_crit_meter == "M" && KeyCode == UDCDMain.Magicka_meter_Keycode
                    UDCDmain.crit = False
                    _crit = False
                    if UDmain.TraceAllowed()                    
                        UDmain.Log("Crit detected for Magicka bar! Keycode: " + KeyCode)
                    endif
                    UDCDmain.CurrentPlayerMinigameDevice.critDevice()
                    return
                elseif KeyCode == UDCDMain.Magicka_meter_Keycode || KeyCode == UDCDMain.Stamina_meter_Keycode
                    UDCDmain.crit = False
                    _crit = False
                    if UDmain.TraceAllowed()                    
                        UDmain.Log("Crit failure detected! Keycode: " + KeyCode)
                    endif
                    UDCDmain.CurrentPlayerMinigameDevice.critFailure()
                    return
                elseif KeyCode == UDCDMain.ActionKey_Keycode
                    if UDmain.TraceAllowed()                    
                        UDmain.Log("ActionKey_Keycode pressed! Keycode: " + KeyCode)
                    endif
                    UDCDmain.CurrentPlayerMinigameDevice.stopMinigame()
                    UDCDmain.crit = false
                    return 
                endif
            endif
            if KeyCode == UDCDMain.SpecialKey_Keycode
                _specialButtonOn = true
                UDCDmain.CurrentPlayerMinigameDevice.SpecialButtonPressed(1.0)
                return
            endif
            if KeyCode == UDCDMain.ActionKey_Keycode
                if UDCDmain.CurrentPlayerMinigameDevice
                    UDCDmain.CurrentPlayerMinigameDevice.stopMinigame()
                endif
                return
            elseif (KeyCode == UDCDMain.Stamina_meter_Keycode || KeyCode == UDCDMain.Magicka_meter_Keycode) && !UDCDMain.UD_AutoCrit
                UDCDmain.crit = False
                _crit = False
                UDCDmain.CurrentPlayerMinigameDevice.critFailure()
                return
            endif
        endif
    EndEvent

    Event OnKeyUp(Int KeyCode, Float HoldTime)
        if KeyCode == UDCDMain.SpecialKey_Keycode
            _specialButtonOn = false
            if UDCDmain.CurrentPlayerMinigameDevice
                UDCDmain.CurrentPlayerMinigameDevice.SpecialButtonReleased(HoldTime)
            endif
            return
        endif
    EndEvent
EndState

Event OnKeyDown(Int KeyCode)
    bool loc_menuopen = UDmain.IsMenuOpen()
    if !loc_menuopen ;only if player is not in menu
        if KeyCode == UDCDMain.PlayerMenu_KeyCode
            UDCDMain.PlayerMenu()
        endif
    endif
EndEvent

Event OnKeyUp(Int KeyCode, Float HoldTime)
    if !UDmain.IsMenuOpen()
        if KeyCode == UDCDMain.StruggleKey_Keycode
            if HoldTime < 0.2
                if lastOpenedDevice
                    lastOpenedDevice.deviceMenu(new Bool[30])
                elseif libs.playerRef.wornhaskeyword(libs.zad_deviousheavybondage)
                    if !lastOpenedDevice
                        lastOpenedDevice = UDCDMain.getHeavyBondageDevice(UDmain.Player)
                    endif
                    if lastOpenedDevice
                        lastOpenedDevice.deviceMenu(new Bool[30])
                    else
                        UDmain.Error("Can't set lastOpenedDevice")
                    endif
                endif
            else
                UD_CustomDevice_RenderScript loc_device = UDCD_NPCM.getPlayerSlot().GetUserSelectedDevice()
                if loc_device
                    loc_device.deviceMenu(new Bool[30])
                endif
            endif
        elseif KeyCode == UDCDmain.NPCMenu_Keycode
            ObjectReference loc_ref = Game.GetCurrentCrosshairRef()
            if loc_ref as Actor
                Actor loc_actor = loc_ref as Actor
                if !loc_actor.isDead() && UDmain.ActorIsValidForUD(loc_actor)
                    if HoldTime <= 0.2
                        UDCDmain.NPCMenu(loc_actor)
                    else
                        bool loc_actorisregistered = UDCDmain.isRegistered(loc_actor)
                        if loc_actorisregistered
                            bool loc_actorisfollower = UDmain.ActorIsFollower(loc_actor)
                            bool loc_actorishelpless = (!UDCDmain.actorFreeHands(loc_actor) || loc_actor.getAV("paralysis") ;/|| loc_actor.GetSleepState() == 3/;) && UDCDmain.actorFreeHands(UDmain.Player)
                            if loc_actorisfollower || loc_actorishelpless
                                UDCDmain.HelpNPC(loc_actor,UDmain.Player,loc_actorisfollower)
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
EndEvent