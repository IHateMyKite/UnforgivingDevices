Scriptname UD_OrgasmExhaustion_AME extends activemagiceffect

UD_OrgasmManager Property UDOM auto
Actor _target = none
float _appliedValue = 0.0
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	_appliedValue = -1.0*0.5
	UDOM.UpdateOrgasmRateMultiplier(_target,_appliedValue)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UDOM.RemoveOrgasmRateMultiplier(_target,_appliedValue)
EndEvent
