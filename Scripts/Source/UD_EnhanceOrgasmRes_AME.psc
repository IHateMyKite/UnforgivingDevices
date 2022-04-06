Scriptname UD_EnhanceOrgasmRes_AME extends activemagiceffect

UDCustomDeviceMain Property UDCDmain auto
Actor _target = none
Float _appliedValue = 0.0
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	_appliedValue = UDCDmain.fRange(GetMagnitude()/100.0,0.00,10.00)
	UDCDmain.UpdateOrgasmResistMultiplier(_target,_appliedValue)
	UDCDmain.UpdateOrgasmRateMultiplier(_target,_appliedValue*0.5)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UDCDmain.RemoveOrgasmResistMultiplier(_target,_appliedValue)
	UDCDmain.RemoveOrgasmRateMultiplier(_target,_appliedValue*0.5)
EndEvent