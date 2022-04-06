Scriptname UD_CustomGag_RenderScript extends UD_CustomDevice_RenderScript  

Function InitPost()
	UD_DeviceType = "Gag"
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchGag(self)
EndFunction

float Function getAccesibility()
	float loc_res = parent.getAccesibility()
	
	if getWearer().wornhaskeyword(libs.zad_DeviousHood)
		loc_res *= 0.35
	endif
	
	return fRange(loc_res,0.0,1.0)
EndFunction

