Scriptname UD_CustomBlindfold_RenderScript extends UD_CustomDevice_RenderScript  

Function InitPost()
	UD_DeviceType = "Blindfold"
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchBlindfold(self)
EndFunction

float Function getAccesibility()
	float loc_res = parent.getAccesibility()
	
	if getWearer().wornhaskeyword(libs.zad_DeviousHood) && !deviceRendered.haskeyword(libs.zad_DeviousHood)
		loc_res *= 0.35
	endif
	
	return fRange(loc_res,0.0,1.0)
EndFunction