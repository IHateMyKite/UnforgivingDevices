Scriptname UD_MinigameDisable_Script extends activemagiceffect  

Actor _target = none
UDCustomDeviceMain Property UDCDmain auto
UD_CustomDevices_NPCSlotsManager Property UDCD_NPCM auto
bool _finished = false
MagicEffect _MagickEffect = none
Event OnEffectStart(Actor akTarget, Actor akCaster)
	;This pings skyrim to make it notice player's speed has changed!
	;akTarget.DamageAv("CarryWeight", 0.02)
	;akTarget.RestoreAv("CarryWeight", 0.02)
	_target = akTarget
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Minigame disabler started for " + _target +"!",3)
	endif
	_MagickEffect = GetBaseObject()
	registerForSingleUpdate(0.1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	_finished = true
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Minigame disabler OnEffectFinish() for " + _target,1)
	endif
	;This pings skyrim to make it notice player's speed has changed!
	;akTarget.DamageAv("CarryWeight", 0.02)
	;akTarget.RestoreAv("CarryWeight", 0.02)
	
	if _target == Game.getPlayer()
		Game.EnablePlayerControls(abMovement = False)
		Game.SetPlayerAiDriven(False)
	else
		_target.SetDontMove(False)
	endif
EndEvent

Event OnUpdate()
	if _target.hasMagicEffect(_MagickEffect)
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("Minigame disabler updated for " + _target,1)
		endif
		if _target.hasMagicEffect(_MagickEffect)
			if _target == Game.getPlayer()
				Game.EnablePlayerControls(abMovement = False)
				Game.DisablePlayerControls(abMovement = False)
				Game.SetPlayerAiDriven(True)
			else
				_target.SetDontMove(True)	
			endif
		endif
		if _target.hasMagicEffect(_MagickEffect)
			registerForSingleUpdate(2.0)
		endif
	endif
EndEvent
