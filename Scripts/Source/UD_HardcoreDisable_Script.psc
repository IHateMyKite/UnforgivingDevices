Scriptname UD_HardcoreDisable_Script extends activemagiceffect  

import UnforgivingDevicesMain

Actor _target = none
UDCustomDeviceMain Property UDCDmain auto
MagicEffect _MagickEffect = none

int _MapKeyCode
int _StatsKeyCode
int _TweenMenuKeyCode

bool _MenuKeyPressed = false
bool _MenuOpen = false
int loc_tick = 0
bool loc_GameMenuOpen = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("hardcore disabler started for " + _target +"!",2)
	endif
	_MagickEffect = GetBaseObject()
	
	
	while UI.IsMenuOpen("Dialogue Menu")
		Utility.waitMenuMode(0.01) ;wait for player to end dialogue before applying effect
	endwhile
	
	closeMenu()
	
	_MapKeyCode = Input.GetMappedKey("Quick Map")
	_StatsKeyCode = Input.GetMappedKey("Quick Stats")
	
	Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
	Game.EnableFastTravel(false)
	
	RegisterForKey(_MapKeyCode)
	RegisterForKey(_StatsKeyCode)
			
	registerForSingleUpdate(0.1)
EndEvent

bool loc_precessing = false
Event OnUpdate()
	loc_precessing = true
	if !_target.wornhaskeyword(UDCDmain.libs.zad_DeviousHeavyBondage) || !UDCDmain.UD_HardcoreMode
		_target.DispelSpell(UDCDmain.UDlibs.HardcoreDisableSpell)
	elseif _target.hasMagicEffect(_MagickEffect)
		if _target.hasMagicEffect(_MagickEffect) && !_target.HasMagicEffectWithKeyword(UDCDmain.UDlibs.MinigameDisableEffect_KW)
			if _target == Game.getPlayer()
				if !_MenuKeyPressed; && !MenuIsOpen()
					Game.DisablePlayerControls(abMovement = False,abFighting = false,abCamSwitch = false,abLooking = false, abSneaking = false, abMenu = true, abActivate = false, abJournalTabs = false)
				endif
				if !(loc_tick % 10)
					Game.EnableFastTravel(false)
				endif
			endif
		endif
		
		if !loc_GameMenuOpen
			if UDCDmain.IsMenuOpen()
				loc_GameMenuOpen = true
			endif
		else
			if !UDCDmain.IsMenuOpen()
				loc_GameMenuOpen = false
			endif
		endif
		
		if _target.hasMagicEffect(_MagickEffect)
			if !(loc_tick % 5)
				if !MenuIsOpen()
					CheckMapKey()
					CheckStatsKey()
				endif
			endif
			if !_MenuOpen && _MenuKeyPressed && !(loc_tick % 6)
				_MenuOpen = false
				_MenuKeyPressed = false
				RegisterForKey(_MapKeyCode)
				RegisterForKey(_StatsKeyCode)
			endif
			loc_tick += 1
			registerForSingleUpdate(0.75)
		endif
	endif
	loc_precessing = false
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Minigame disabler OnEffectFinish() for " + _target,2)
	endif
	;wait for onUpdate function to finish if it started
	while loc_precessing
		Utility.waitMenuMode(0.01)
	endwhile

	if _target == Game.getPlayer()
		Game.EnablePlayerControls()
		Game.EnableFastTravel(true)
	endif

EndEvent

Event OnKeyDown(Int KeyCode)
	if UDCDmain.TraceAllowed()
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
	endif
EndEvent


Event OnMenuOpen(String MenuName)
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("UD_HardcoreDisable_Script - OnMenuOpen for " + MenuName,3)
	endif
	If MenuName == "MapMenu"
		_MenuOpen = true
	elseif MenuName == "StatsMenu"
		_MenuOpen = true
	endif
EndEvent

Event OnMenuClose(String MenuName)
	if UDCDmain.TraceAllowed()
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
		if UDCDmain.TraceAllowed()
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
		if UDCDmain.TraceAllowed()
			UDCDmain.Log("UD_HardcoreDisable_Script - Remaping keycode for Quick Map menu",1)
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