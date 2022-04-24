Scriptname UD_ZAZTears_AME extends activemagiceffect  

UDCustomDeviceMain Property UDCDmain auto
Actor _target
int loc_type = 3
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("UD_ZAZTears_AME started for " + UDCDmain.GetActorName(_target) +"!",2)
	endif
	loc_type = UDCDmain.iRange(UDCDmain.Round(GetMagnitude()),1,5)
	if loc_type == 5
		loc_type = Utility.randomInt(2,4)
	endif
	if UDCDmain.UDmain.SlaveTatsInstalled
		SlaveTats.simple_add_tattoo(_target, "Tears", "Tears " + loc_type, 0, true, true)
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("UD_ZAZTears_AME OnEffectFinish() for " + UDCDmain.GetActorName(_target),1)
	endif
	if UDCDmain.UDmain.SlaveTatsInstalled
		SlaveTats.simple_remove_tattoo(_target, "Tears", "Tears " + loc_type, true, true)
	endif
EndEvent

