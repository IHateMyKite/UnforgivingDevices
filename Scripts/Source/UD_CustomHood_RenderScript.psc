Scriptname UD_CustomHood_RenderScript extends UD_CustomDevice_RenderScript  

import ConsoleUtil
;int Property UD_BreathplayDifficulty = 0 auto

Function patchDevice()
	UDCDmain.UDPatcher.patchHood(self)
EndFunction

Function InitPost()
	UD_DeviceType = "Hood"
EndFunction

float Function getAccesibility()
	float loc_res = parent.getAccesibility()
	
	if getWearer().wornhaskeyword(libs.zad_DeviousCollar)
		loc_res *= 0.75
	endif
	
	return fRange(loc_res,0.0,1.0)
EndFunction

;/
Function OnRemoveDevice(actor akActor)
	parent.OnRemoveDevice(getWearer())
EndFunction
/;