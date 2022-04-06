Scriptname UD_CustomHeavyBondage_RenderScript extends UD_CustomDevice_RenderScript  

Function InitPost()
	UD_DeviceType = "Hand restrain"
	;libs.StartBoundEffects(getWearer())	
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchHeavyBondage(self)
EndFunction
