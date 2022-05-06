Scriptname UDAbadonPlugAppetizerMagEffectScript extends activemagiceffect  
UDCustomDeviceMain Property UDCDmain  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	UD_AbadonPlug_RenderScript plug = UDCDmain.getFirstDeviceByKeyword(akTarget,UDCDmain.UDlibs.AbadonPlugkw) as UD_AbadonPlug_RenderScript
	if plug
		plug.ForceModDuration(4.0)
		plug.ForceModStrength(1.5)
		plug.vibrate()
	endif
EndEvent

