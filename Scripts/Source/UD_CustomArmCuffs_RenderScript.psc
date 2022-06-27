Scriptname UD_CustomArmCuffs_RenderScript extends UD_CustomDynamicHeavyBondage_RS

Function InitPost()
	parent.InitPost()
	UD_DeviceType = "Arm cuffs"
	UD_ActiveEffectName = "Tie up - Arms"
EndFunction

string Function addInfoString(string str = "")
	return parent.addInfoString(str)
EndFunction

bool Function canBeActivated()
	return WearerFreeHands() && getRelativeElapsedCooldownTime() >= 0.5
EndFunction

Function OnTiedUp()
	UDCDmain.AddInvisibleArmbinder(GetWearer())
EndFunction

Function OnUntied()
	UDCDmain.RemoveInvisibleArmbinder(GetWearer())
EndFunction

float Function getAccesibility()
	if IsTiedUp()
		return 1.0
	else
		return parent.getAccesibility()
	endif
EndFunction

bool Function OnCooldownActivatePre()
	if isSentient()
		return parent.OnCooldownActivatePre()
	else
		return false
	endif
EndFunction

;OVERRIDES because of engine bug which calls one function multiple times
bool Function proccesSpecialMenu(int msgChoice)
	return parent.proccesSpecialMenu(msgChoice)
EndFunction
bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	return parent.proccesSpecialMenuWH(akSource,msgChoice)
EndFunction