Scriptname UD_CustomHeavyBondage_RenderScript extends UD_CustomDevice_RenderScript  

Function InitPost()
	UD_DeviceType = "Hand restrain"
	;GetWearer().StopCombat()
	if !WearerIsPlayer()
		;GetWearer().AddSpell(UDlibs.PreventCombatSpell,false)
	endif
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchHeavyBondage(self)
EndFunction

Function onRemoveDevicePost(Actor akActor)
	GetWearer().RemoveSpell(UDlibs.PreventCombatSpell)
	parent.onRemoveDevicePost(akActor)
EndFunction
