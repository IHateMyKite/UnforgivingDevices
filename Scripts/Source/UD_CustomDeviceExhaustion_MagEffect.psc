Scriptname UD_CustomDeviceExhaustion_MagEffect extends activemagiceffect  

Actor _target = none
MagicEffect _MagickEffect = none
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget 
	_MagickEffect = GetBaseObject()
	if _target == Game.getPlayer()
		registerForSingleUpdate(0.1)
		;Game.SetInChargen(false, true, false)
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if _target == Game.getPlayer()
		Game.SetInChargen(false, false, false)
	endif
EndEvent

Event OnUpdate()
	if _target.hasMagicEffect(_MagickEffect)
		if _target == Game.getPlayer()
			Game.SetInChargen(false, true, false)
		endif
		registerForSingleUpdate(3.0)
	endif
EndEvent
