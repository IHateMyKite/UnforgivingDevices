Scriptname UD_OrgasmExhaustion_AME extends activemagiceffect

UDCustomDeviceMain Property UDCDmain auto
Actor _target = none
float _appliedValue = 0.0
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	_appliedValue = -1.0*0.5;-1.0*UDCDmain.fRange(GetMagnitude()/100.0,0.01,0.99)
	UDCDmain.UpdateOrgasmRateMultiplier(_target,_appliedValue)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UDCDmain.RemoveOrgasmRateMultiplier(_target,_appliedValue)
EndEvent
