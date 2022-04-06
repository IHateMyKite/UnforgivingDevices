Scriptname UD_CustomLegCuffs_RenderScript extends UD_CustomDynamicHeavyBondage_RS

Function InitPost()
	parent.InitPost()
	UD_DeviceType = "Leg cuffs"
	UD_ActiveEffectName = "Tie up - Legs"
EndFunction

string Function addInfoString(string str = "")
	return parent.addInfoString(str)
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
	return parent.proccesSpecialMenu(msgChoice)
EndFunction

bool Function canBeActivated()
	return WearerFreeLegs() && getRelativeElapsedCooldownTime() >= 0.4
EndFunction

Function OnTiedUp()
	UDCDmain.AddInvisibleHobble(GetWearer())
EndFunction

Function OnUntied()
	UDCDmain.RemoveInvisibleHobble(GetWearer())
EndFunction