Scriptname UD_ReduceOrgasmResistence_AME extends activemagiceffect  

import UnforgivingDevicesMain

UD_OrgasmManager Property UDOM auto
Actor _target = none

float _appliedValue = 0.0
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	_appliedValue = fRange(GetMagnitude()/100.0,0.01,10.0)
	UDOM.UpdateOrgasmResistMultiplier(_target,-1.0*_appliedValue)
	UDOM.UpdateOrgasmRateMultiplier(_target,_appliedValue*0.5)
	UDOM.UpdateArousalRate(_target,5.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UDOM.RemoveOrgasmResistMultiplier(_target,-1.0*_appliedValue)
	UDOM.RemoveOrgasmRateMultiplier(_target,_appliedValue*0.5)
	UDOM.UpdateArousalRate(_target,-5.0)
EndEvent