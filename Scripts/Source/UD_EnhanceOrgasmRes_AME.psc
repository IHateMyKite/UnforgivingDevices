Scriptname UD_EnhanceOrgasmRes_AME extends activemagiceffect

UD_OrgasmManager Property UDOM auto
Actor _target = none
Float _appliedValue = 0.0
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	_appliedValue = UDOM.fRange(GetMagnitude()/100.0,0.00,10.00)
	UDOM.UpdateOrgasmResistMultiplier(_target,_appliedValue)
	UDOM.UpdateOrgasmRateMultiplier(_target,-1*_appliedValue*0.5)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UDOM.RemoveOrgasmResistMultiplier(_target,_appliedValue)
	UDOM.RemoveOrgasmRateMultiplier(_target,-1*_appliedValue*0.5)
EndEvent