Scriptname UD_ReduceOrgasmResistence_AME extends activemagiceffect  

UDCustomDeviceMain Property UDCDmain auto
Actor _target = none

float _appliedValue = 0.0
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	_appliedValue = UDCDmain.fRange(GetMagnitude()/100.0,0.01,0.99)
	UDCDmain.UpdateOrgasmResistMultiplier(_target,-1.0*_appliedValue)
	UDCDmain.UpdateOrgasmRateMultiplier(_target,_appliedValue*0.5)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("UD_ReduceOrgasmResistence_AME applied to " + UDCDmain.getActorName(_target) + ", duration: " + getDuration() + ",mag: " + getMagnitude())
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UDCDmain.RemoveOrgasmResistMultiplier(_target,-1.0*_appliedValue)
	UDCDmain.RemoveOrgasmRateMultiplier(_target,_appliedValue*0.5)
EndEvent