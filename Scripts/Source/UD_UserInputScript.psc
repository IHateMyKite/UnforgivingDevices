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

UD_CustomDevice_RenderScript    Property lastOpenedDevice     = none    auto hidden
Int                             Property UD_GamepadKey        = 0x112   auto
Bool                            Property UD_EasyGamepadMode   = false   auto

bool _specialButtonOn = false
bool _gamepadButtonOn = false

Event keyUnregister(string eventName = "none", string strArg = "", float numArg = 0.0, Form sender = none)
    if UDmain.TraceAllowed()    
        UDmain.Log("UD_UserInputScript::keyUnregister called",1)
    endif
    UnregisterForAllKeys()
EndEvent

Event MinigameKeysRegister()
    if UDmain.TraceAllowed()    
        UDmain.Log("UD_UserInputScript::MinigameKeysRegister called",1)
    endif
    RegisterForKey(UDCDMain.Stamina_meter_Keycode)
    RegisterForKey(UDCDMain.SpecialKey_Keycode)
    RegisterForKey(UDCDMain.Magicka_meter_Keycode)
    _specialButtonOn = false
EndEvent

Event MinigameKeysUnregister()
    if UDmain.TraceAllowed()    
        UDmain.Log("UD_UserInputScript::MinigameKeysUnregister called",1)
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
    _gamepadButtonOn = false
EndEvent

Function RegisterGlobalKeys()
    if UDmain.TraceAllowed()    
        UDmain.Log("UD_UserInputScript::RegisterGlobalKeys")
    endif
    RegisterForKey(UDCDMain.StruggleKey_Keycode)
    RegisterForKey(UDCDMain.PlayerMenu_KeyCode)
    RegisterForKey(UDCDMain.ActionKey_Keycode)
    RegisterForKey(UDCDMain.NPCMenu_Keycode)
    RegisterForKey(UD_GamepadKey)
EndFunction

Function UnregisterGlobalKeys()
    if UDmain.TraceAllowed()    
        UDmain.Log("UD_UserInputScript::UnregisterGlobalKeys")
    endif
    UnRegisterForKey(UDCDMain.StruggleKey_Keycode)
    UnRegisterForKey(UDCDMain.PlayerMenu_KeyCode)
    UnRegisterForKey(UDCDMain.ActionKey_Keycode)
    UnRegisterForKey(UDCDMain.NPCMenu_Keycode)
    UnRegisterForKey(UD_GamepadKey)
EndFunction

bool Function KeyIsUsedGlobaly(int keyCode)
    bool loc_res = false
    loc_res = loc_res || (keyCode == UDCDMain.StruggleKey_Keycode)
    loc_res = loc_res || (keyCode == UDCDMain.PlayerMenu_KeyCode)
    loc_res = loc_res || (keyCode == UDCDMain.NPCMenu_Keycode)
    loc_res = loc_res || (keyCode == UDCDMain.ActionKey_Keycode)
    loc_res = loc_res || (keyCode == UD_GamepadKey)
    return loc_res
EndFunction

State Minigame
    Event OnKeyDown(Int KeyCode)
        if (UD_Native.GetCameraState() == 3)
            return
        endif
        ;help variables to reduce lag
        bool     _crit                    = UDCDmain.crit 
        string   _selected_crit_meter     = UDCDmain.selected_crit_meter
        if (KeyCode == UDCDMain.Stamina_meter_Keycode || KeyCode == UDCDMain.Magicka_meter_Keycode)
            if _crit
                UDCDmain.crit = false ;remove crit to prevent multiple crits at once
            endif
        endif
        bool loc_menuopen = UDmain.IsAnyMenuOpen()
        if !loc_menuopen ;only if player is not in menu
            if KeyCode == UDCDMain.SpecialKey_Keycode
                _specialButtonOn = true
                UDCDmain.CurrentPlayerMinigameDevice.SpecialButtonPressed(1.0)
                return
            endif
            if (_crit) && !UDCDMain.UD_AutoCrit
                if _selected_crit_meter == "S" && KeyCode == UDCDMain.Stamina_meter_Keycode
                    UDCDmain.crit = False
                    _crit = False
                    UDCDmain.CurrentPlayerMinigameDevice.critDevice()
                    return
                elseif _selected_crit_meter == "M" && KeyCode == UDCDMain.Magicka_meter_Keycode
                    UDCDmain.crit = False
                    _crit = False
                    UDCDmain.CurrentPlayerMinigameDevice.critDevice()
                    return
                elseif (KeyCode == UDCDMain.Magicka_meter_Keycode) || (KeyCode == UDCDMain.Stamina_meter_Keycode)
                    UDCDmain.crit = False
                    _crit = False
                    UDCDmain.CurrentPlayerMinigameDevice.critFailure()
                    return
                endif
            endif
            if KeyCode == UDCDMain.ActionKey_Keycode
                UDCDmain.crit = False
                if UDCDmain.CurrentPlayerMinigameDevice
                    UDCDmain.CurrentPlayerMinigameDevice.stopMinigame()
                endif
                return
            elseif !UDCDMain.UD_AutoCrit && (KeyCode == UDCDMain.Stamina_meter_Keycode || KeyCode == UDCDMain.Magicka_meter_Keycode)
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
    if UDmain.IsEnabled() && (UD_Native.GetCameraState() != 3)
        ;check if any menu is open, or if message box is open
        bool loc_menuopen = UDmain.IsAnyMenuOpen()
        if !loc_menuopen ;only if player is not in menu
            if UD_EasyGamepadMode && Game.UsingGamepad()
                if KeyCode == UD_GamepadKey
                    ;show menu
                    ShowGamePadMenu()
                endif
            else
                if KeyCode == UDCDMain.PlayerMenu_KeyCode
                    UDCDMain.PlayerMenu()
                endif
            endif
        endif
    endif
EndEvent

Event OnKeyUp(Int KeyCode, Float HoldTime)
    if UDmain.IsEnabled() && (UD_Native.GetCameraState() != 3)
        if !UDmain.IsAnyMenuOpen() && !(UD_EasyGamepadMode && Game.UsingGamepad())
            if KeyCode == UDCDMain.StruggleKey_Keycode
                if HoldTime < 0.2
                    OpenLastDeviceMenu()
                else
                    OpenDeviceMenu()
                endif
            elseif KeyCode == UDCDmain.NPCMenu_Keycode
                OpenNPCMenu(HoldTime > 0.2)
            endif
        endif
    endif
EndEvent

State UIDisabled
    Event OnKeyDown(Int KeyCode)
    EndEvent
    Event OnKeyUp(Int KeyCode, Float HoldTime)
    EndEvent
EndState

Function OpenLastDeviceMenu()
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
EndFunction

Function OpenDeviceMenu()
    UD_CustomDevice_RenderScript loc_device = UDCD_NPCM.getPlayerSlot().GetUserSelectedDevice()
    if loc_device
        loc_device.deviceMenu(new Bool[30])
    endif
EndFunction

Function OpenNPCMenu(Bool abOpenDeviceList)
    ObjectReference loc_ref = Game.GetCurrentCrosshairRef()
    if loc_ref as Actor
        Actor loc_actor = loc_ref as Actor
        if !loc_actor.isDead() && UDmain.ActorIsValidForUD(loc_actor)
            if !abOpenDeviceList
                UDCDmain.NPCMenu(loc_actor)
            else
                bool loc_actorisregistered = UDCDmain.isRegistered(loc_actor)
                if loc_actorisregistered
                    bool loc_actorisfollower = UDmain.ActorIsFollower(loc_actor)
                    bool loc_actorishelpless = (!UDmain.ActorFreeHands(loc_actor) || loc_actor.getAV("paralysis") ;/|| loc_actor.GetSleepState() == 3/;) && UDmain.ActorFreeHands(UDmain.Player)
                    if loc_actorisfollower || loc_actorishelpless
                        UDCDmain.HelpNPC(loc_actor,UDmain.Player,loc_actorisfollower)
                    endif
                endif
            endif
        endif
    endif
EndFunction

Function ShowGamePadMenu()
    string[] loc_options = new String[6]
    loc_options[0] = "Last Device menu"
    loc_options[1] = "Device list"
    loc_options[2] = "Player menu"
    loc_options[3] = "NPC menu"
    loc_options[4] = "NPC Device List"
    loc_options[5] = "Exit"
    int loc_result = UDmain.GetUserListInput(loc_options)
    if loc_result == 0
        OpenLastDeviceMenu()
    elseif loc_result == 1
        OpenDeviceMenu()
    elseif loc_result == 2
        UDCDMain.PlayerMenu()
    elseif loc_result == 3
        OpenNPCMenu(false)
    elseif loc_result == 4
        OpenNPCMenu(true)
    else
        return
    endif
EndFunction