Scriptname UD_CustomDeviceExhaustion_MagEffect extends activemagiceffect  

UnforgivingDevicesMain Property UDmain auto
UD_ExpressionManager Property UDEM
	UD_ExpressionManager Function get()
		return UDmain.UDEM
	EndFunction
EndProperty
Actor _target = none
MagicEffect _MagickEffect = none
float[] _expression
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget 
	_MagickEffect = GetBaseObject()
	_expression = UDEM.GetPrebuildExpression_Tired1()
	UDEM.ApplyExpressionRaw(_target, _expression, 30,false,30)
	if _target == Game.getPlayer()
		registerForSingleUpdate(0.1)
		;Game.SetInChargen(false, true, false)
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if _target == Game.getPlayer()
		Game.SetInChargen(false, false, false)
	endif
	UDEM.ResetExpressionRaw(_target,30)
EndEvent

Event OnUpdate()
	if _target.hasMagicEffect(_MagickEffect)
		if _target == Game.getPlayer()
			Game.SetInChargen(false, true, false)
		endif
		UDEM.ApplyExpressionRaw(_target, _expression, 30,false,30)
		registerForSingleUpdate(3.0)
	endif
EndEvent
