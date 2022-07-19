Scriptname UD_HardcoreDisable_Script extends activemagiceffect  

import UnforgivingDevicesMain

Actor _target = none
UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain
	UnforgivingDevicesMain Function get()
		return UDCDmain.UDmain
	EndFunction
EndProperty
MagicEffect _MagickEffect = none

int _MapKeyCode
int _StatsKeyCode
int _TweenMenuKeyCode = -1

bool _MenuKeyPressed = false
bool _MenuOpen = false
int loc_tick = 0
bool loc_GameMenuOpen = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	if UDmain.TraceAllowed()	
		UDCDmain.Log("hardcore disabler started for " + _target +"!",2)
	endif
	_MagickEffect = GetBaseObject()
	
	
	while UI.IsMenuOpen("Dialogue Menu")
		Utility.waitMenuMode(0.01) ;wait for player to end dialogue before applying effect
	endwhile
	
	closeMenu()
	
	_MapKeyCode = Input.GetMappedKey("Quick Map")
	_StatsKeyCode = Input.GetMappedKey("Quick Stats")
	_TweenMenuKeyCode = Input.GetMappedKey("Tween menu")
	
	Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
	Game.EnableFastTravel(false)
	
	RegisterForKey(_MapKeyCode)
	RegisterForKey(_StatsKeyCode)
	RegisterForKey(_TweenMenuKeyCode)
	
	registerForSingleUpdate(0.1)
EndEvent

Function Update()
	if _TweenMenuKeyCode == -1
		_TweenMenuKeyCode = Input.GetMappedKey("Tween menu")
		RegisterForKey(_TweenMenuKeyCode)
	endif
EndFunction

bool loc_precessing = false
Event OnUpdate()
	loc_precessing = true
	if !_target.wornhaskeyword(UDCDmain.libs.zad_DeviousHeavyBondage) || !UDCDmain.UD_HardcoreMode
		_target.DispelSpell(UDCDmain.UDlibs.HardcoreDisableSpell)
	elseif _target.hasMagicEffect(_MagickEffect)
		if _target.hasMagicEffect(_MagickEffect) && !_target.HasMagicEffectWithKeyword(UDCDmain.UDlibs.MinigameDisableEffect_KW)
			if UDmain.ActorIsPlayer(_target)
				if !_MenuKeyPressed; && !MenuIsOpen()
					Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
				endif
				if !(loc_tick % 10)
					Game.EnableFastTravel(false)
				endif
			endif
		endif
		
		Update()
		
		;/
		if !loc_GameMenuOpen
			if UDmain.IsMenuOpen()
				loc_GameMenuOpen = true
			endif
		else
			if !UDmain.IsMenuOpen()
				loc_GameMenuOpen = false
			endif
		endif
		/;
		
		if _target.hasMagicEffect(_MagickEffect)
			if !(loc_tick % 5)
				if !UDmain.isMenuOpen()
					CheckMapKey()
					CheckStatsKey()
					CheckTweenKey()
				endif
			endif
			if !_MenuOpen && _MenuKeyPressed && !(loc_tick % 6)
				_MenuOpen = false
				_MenuKeyPressed = false
				RegisterForKey(_MapKeyCode)
				RegisterForKey(_StatsKeyCode)
				RegisterForKey(_TweenMenuKeyCode)
			endif
			loc_tick += 1
			registerForSingleUpdate(0.75)
		endif
	endif
	loc_precessing = false
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if UDmain.TraceAllowed()	
		UDCDmain.Log("Minigame disabler OnEffectFinish() for " + _target,2)
	endif
	;wait for onUpdate function to finish if it started
	while loc_precessing
		Utility.waitMenuMode(0.01)
	endwhile

	if UDmain.ActorIsPlayer(akTarget)
		Game.EnablePlayerControls()
		Game.EnableFastTravel(true)
	endif
EndEvent

Event OnKeyDown(Int KeyCode)
	if !UDMain.IsMenuOpen()
		if UDmain.TraceAllowed()
			UDCDmain.Log("UD_HardcoreDisable_Script - OnKeyDown for " + KeyCode,3)
		endif
		If KeyCode == _MapKeyCode
			_MenuKeyPressed = true
			UnRegisterForKey(_MapKeyCode)
			RegisterForMenu("MapMenu")
			Game.EnablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
			Utility.waitMenuMode(0.1)
			Input.TapKey(_MapKeyCode)
		elseif KeyCode == _StatsKeyCode
			_MenuKeyPressed = true
			UnRegisterForKey(_StatsKeyCode)
			RegisterForMenu("StatsMenu")
			Utility.waitMenuMode(0.1)
			Game.EnablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
			Input.TapKey(_StatsKeyCode)
		elseif KeyCode == _TweenMenuKeyCode
			UDCDmain.getHeavyBondageDevice(UDmain.Player).deviceMenu(new Bool[30])
		endif
	endif
EndEvent


Event OnMenuOpen(String MenuName)
	if UDmain.TraceAllowed()
		UDCDmain.Log("UD_HardcoreDisable_Script - OnMenuOpen for " + MenuName,3)
	endif
	If MenuName == "MapMenu"
		_MenuOpen = true
	elseif MenuName == "StatsMenu"
		_MenuOpen = true
	endif
EndEvent

Event OnMenuClose(String MenuName)
	if UDmain.TraceAllowed()
		UDCDmain.Log("UD_HardcoreDisable_Script - OnMenuClose for " + MenuName,3)
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
		if UDmain.TraceAllowed()
			UDCDmain.Log("UD_HardcoreDisable_Script - Remaping keycode for map menu",1)
		endif
	endif
EndFunction

Function CheckStatsKey()
	int StatsMenu = Input.GetMappedKey("Quick Stats")
	if StatsMenu != _StatsKeyCode
		UnRegisterForKey(_StatsKeyCode)
		_StatsKeyCode = StatsMenu
		RegisterForKey(_StatsKeyCode)
		if UDmain.TraceAllowed()
			UDCDmain.Log("UD_HardcoreDisable_Script - Remaping keycode for Quick Map menu",1)
		endif
	endif
EndFunction

Function CheckTweenKey()
	int TweenMenu = Input.GetMappedKey("Tween menu")
	if TweenMenu != _TweenMenuKeyCode
		UnRegisterForKey(_TweenMenuKeyCode)
		_TweenMenuKeyCode = TweenMenu
		RegisterForKey(_TweenMenuKeyCode)
		if UDmain.TraceAllowed()
			UDCDmain.Log("UD_HardcoreDisable_Script - Remaping keycode for Tween menu",1)
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