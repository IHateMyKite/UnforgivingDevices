Scriptname UD_CustomDeviceExhaustion_MagEffect extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if akTarget == Game.getPlayer()
		registerForSingleUpdate(0.1)
		;Game.SetInChargen(false, true, false)
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if akTarget == Game.getPlayer()
		Game.SetInChargen(false, false, false)
	endif
EndEvent

Event OnUpdate()
	Game.SetInChargen(false, true, false)
	registerForSingleUpdate(1.0)
EndEvent
