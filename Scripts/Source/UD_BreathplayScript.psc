Scriptname UD_BreathplayScript extends Quest  
UDCustomDeviceMain Property UDCDmain auto


Actor focusedActor = none


Function registerActor(Actor akActor)
	focusedActor = akActor
	registerforsingleupdate(1.0)
EndFunction

Function unregisterActor(Actor akActor)
	if focusedActor == akActor
		focusedActor = none
	endif
EndFunction

Event OnUpdate()
	if focusedActor
		
		
		
		registerforsingleupdate(1.0)	
	endif
EndEvent
