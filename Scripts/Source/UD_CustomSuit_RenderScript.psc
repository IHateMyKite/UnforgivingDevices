Scriptname UD_CustomSuit_RenderScript extends UD_CustomDevice_RenderScript  

Function InitPost()
	UD_DeviceType = "Suit"
EndFunction

float Function getAccesibility()
	float loc_res = parent.getAccesibility()
	
	if getWearer().wornhaskeyword(libs.zad_DeviousArmCuffs)
		loc_res *= 0.75
	endif
	if getWearer().wornhaskeyword(libs.zad_DeviousLegCuffs)
		loc_res *= 0.75
	endif
	if getWearer().wornhaskeyword(libs.zad_DeviousCollar)
		loc_res *= 0.75
	endif
	return fRange(loc_res,0.0,1.0)
EndFunction