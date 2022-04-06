Scriptname UDAbadonPlugAppetizerMagEffectScript extends activemagiceffect  
UDCustomDeviceMain Property UDCDmain  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	UD_AbadonPlug_RenderScript plug = UDCDmain.getFirstDeviceByKeyword(akTarget,UDCDmain.UDlibs.AbadonPlugkw) as UD_AbadonPlug_RenderScript
	if plug
		plug.vibrate(5,90*Math.floor((GetMagnitude()/100.0)),False,50.0)
	endif
EndEvent

