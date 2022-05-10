Scriptname UD_CustomGag_RenderScript extends UD_CustomDevice_RenderScript  

Function InitPost()
	UD_DeviceType = "Gag"
EndFunction

Function onRemoveDevicePost(Actor akActor)
	parent.onRemoveDevicePost(akActor)
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchGag(self)
EndFunction

float Function getAccesibility()
	float loc_res = parent.getAccesibility()
	
	if getWearer().wornhaskeyword(libs.zad_DeviousHood) && !deviceRendered.haskeyword(libs.zad_DeviousHood)
		loc_res *= 0.35
	endif
	
	return fRange(loc_res,0.0,1.0)
EndFunction

bool Function OnUpdateHourPost()
	if Utility.randomInt(1,99) < 35
		UDCDmain.ApplyDroolEffect(GetWearer())
		if WearerIsPlayer()
			UDCDmain.Print("Gag is making you drool uncontrollably",3)
		endif
	endif
	return parent.OnUpdateHourPost()
EndFunction



