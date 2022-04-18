Scriptname UD_HardcoreDisable_Script extends activemagiceffect  

Actor _target = none
UDCustomDeviceMain Property UDCDmain auto
MagicEffect _MagickEffect = none

int _MapKeyCode
int _StatsKeyCode
int _TweenMenuKeyCode
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("hardcore disabler started for " + _target +"!",3)
	endif
	_MagickEffect = GetBaseObject()
	UDCDmain.UDmain.closeMenu()
	
	_MapKeyCode = Input.GetMappedKey("Quick Map")
	_StatsKeyCode = Input.GetMappedKey("Quick Stats")
	_TweenMenuKeyCode = Input.GetMappedKey("Tween Menu")
	
	Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
	Game.EnableFastTravel(false)
	
	RegisterForKey(_MapKeyCode)
	RegisterForKey(_StatsKeyCode)
	RegisterForKey(_TweenMenuKeyCode)
	registerForSingleUpdate(0.1)
EndEvent

int loc_tick = 0
Event OnUpdate()
	if !_target.wornhaskeyword(UDCDmain.libs.zad_DeviousHeavyBondage) || !UDCDmain.UD_HardcoreMode
		_target.DispelSpell(UDCDmain.UDlibs.HardcoreDisableSpell)
	elseif _target.hasMagicEffect(_MagickEffect)
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("UD_HardcoreDisable_Script - Hardcore disabler updated for " + _target,1)
		endif
		
		if _target.hasMagicEffect(_MagickEffect) && !_target.HasMagicEffectWithKeyword(UDCDmain.UDlibs.MinigameDisableEffect_KW)
			if _target == Game.getPlayer()
				if !_MenuKeyPressed; && !MenuIsOpen()
					Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
				endif
				if !(loc_tick % 8)
					Game.EnableFastTravel(false)
				endif
			endif
		endif
		
		if _target.hasMagicEffect(_MagickEffect)
			if !(loc_tick % 40)
				if !MenuIsOpen()
					CheckMapKey()
					CheckStatsKey()
					CheckTweenMenuKey()
				endif
			endif
			if !_MenuOpen && _MenuKeyPressed && !(loc_tick % 10)
				_MenuOpen = false
				_MenuKeyPressed = false
				RegisterForKey(_MapKeyCode)
				RegisterForKey(_StatsKeyCode)
			endif
			loc_tick += 1
			registerForSingleUpdate(0.25)
		endif
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Minigame disabler OnEffectFinish() for " + _target,1)
	endif
	UnRegisterForKey(_MapKeyCode)
	UnRegisterForKey(_StatsKeyCode)
	UnRegisterForKey(_TweenMenuKeyCode)
	if !_target.HasMagicEffectWithKeyword(UDCDmain.UDlibs.MinigameDisableEffect_KW)
		if _target == Game.getPlayer()
			Game.EnablePlayerControls()
			Game.EnableFastTravel(true)
		endif
	endif
EndEvent

Event OnKeyDown(Int KeyCode)
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("UD_HardcoreDisable_Script - OnKeyDown for " + KeyCode)
	endif
	If KeyCode == _MapKeyCode
		_MenuKeyPressed = true
		UnRegisterForKey(_MapKeyCode)
		UnRegisterForKey(_TweenMenuKeyCode)
		RegisterForMenu("MapMenu")
		Game.EnablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
		Utility.waitMenuMode(0.1)
		Input.TapKey(_MapKeyCode)
	elseif KeyCode == _StatsKeyCode
		_MenuKeyPressed = true
		UnRegisterForKey(_StatsKeyCode)
		UnRegisterForKey(_TweenMenuKeyCode)
		RegisterForMenu("StatsMenu")
		Utility.waitMenuMode(0.1)
		Game.EnablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
		Input.TapKey(_StatsKeyCode)
	elseif KeyCode == _TweenMenuKeyCode
		UnRegisterForKey(_TweenMenuKeyCode)
		UD_CustomDevice_RenderScript loc_device = UDCDmain.UDCD_NPCM.getPlayerSlot().GetUserSelectedDevice()
		if loc_device
			loc_device.deviceMenu(new Bool[30])
		endif
		RegisterForKey(_TweenMenuKeyCode)
	endif
EndEvent

bool _MenuKeyPressed = false
bool _MenuOpen = false
Event OnMenuOpen(String MenuName)
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("UD_HardcoreDisable_Script - OnMenuOpen for " + MenuName)
	endif
	If MenuName == "MapMenu"
		_MenuOpen = true
	elseif MenuName == "StatsMenu"
		_MenuOpen = true
	endif
EndEvent

Event OnMenuClose(String MenuName)
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("UD_HardcoreDisable_Script - OnMenuClose for " + MenuName)
	endif
	If MenuName == "MapMenu"
		Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
		RegisterForKey(_MapKeyCode)
		RegisterForKey(_TweenMenuKeyCode)
		UnRegisterForMenu("MapMenu")
		_MenuKeyPressed = false
		_MenuOpen = false
	elseif MenuName == "StatsMenu"
		Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
		RegisterForKey(_StatsKeyCode)
		RegisterForKey(_TweenMenuKeyCode)
		UnRegisterForMenu("StatsMenu")
		_MenuKeyPressed = false
		_MenuOpen = false
	endif
	
EndEvent

Function CheckMapKey()
	int MapKeyCode = Input.GetMappedKey("Quick Map")
	if MapKeyCode != _MapKeyCode
		UnRegisterForKey(_MapKeyCode)
		_MapKeyCode = MapKeyCode
		RegisterForKey(_MapKeyCode)
		if UDCDmain.TraceAllowed()
			UDCDmain.Log("UD_HardcoreDisable_Script - Remaping keycode for map menu")
		endif
	endif
EndFunction

Function CheckStatsKey()
	int StatsMenu = Input.GetMappedKey("Quick Stats")
	if StatsMenu != _StatsKeyCode
		UnRegisterForKey(_StatsKeyCode)
		_StatsKeyCode = StatsMenu
		RegisterForKey(_StatsKeyCode)
		if UDCDmain.TraceAllowed()
			UDCDmain.Log("UD_HardcoreDisable_Script - Remaping keycode for Quick Map menu")
		endif
	endif
EndFunction

Function CheckTweenMenuKey()
	int TweenMenu = Input.GetMappedKey("Tween Menu")
	if TweenMenu != _TweenMenuKeyCode
		UnRegisterForKey(_TweenMenuKeyCode)
		_TweenMenuKeyCode = TweenMenu
		RegisterForKey(_TweenMenuKeyCode)
		if UDCDmain.TraceAllowed()
			UDCDmain.Log("UD_HardcoreDisable_Script - Remaping keycode for Tween Menu")
		endif
	endif
EndFunction

bool Function MenuIsOpen()
	if UI.IsMenuOpen("MapMenu")
		return true
	endif
	if UI.IsMenuOpen("StatsMenu")
		return true
	endif
	return false
EndFunction