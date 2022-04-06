Scriptname UD_CustomPanelGag_RenderScript extends UD_CustomGag_RenderScript  

float Property UD_RemovePlugDifficulty = 100.0 auto
;MiscObject Property UD_GagPanelPlug Auto

Function InitPost()
	UD_ActiveEffectName = "Add Plug"
	UD_DeviceType = "Panel Gag"
EndFunction

string Function addInfoString(string str = "")
	;string res = str
	str += "Plugged: "
	if isPlugged()
		str += "YES\n"
		if !wearerFreeHands(True) 
		endif
	else
		str += "NO\n"
	endif
	
	return parent.addInfoString(str)
EndFunction

Function safeCheck()
	if !UD_SpecialMenuInteraction
		UD_SpecialMenuInteraction = UDCDmain.DefaultPanelGagSpecialMsg
	endif
	if !UD_SpecialMenuInteractionWH
		UD_SpecialMenuInteractionWH = UDCDmain.DefaultPanelGagSpecialMsg
	endif
	parent.safeCheck()
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
	parent.onDeviceMenuInitPost(aControlFilter)
	
	if wearerFreeHands() && !isPlugged()
		UDCDmain.currentDeviceMenu_switch1 = True
	endif
	if isPlugged()
		UDCDmain.currentDeviceMenu_switch2 = True
	endif
	UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
	parent.onDeviceMenuInitPostWH(aControlFilter)
	
	if (wearerFreeHands() || helperFreeHands()) && !isPlugged()
		UDCDmain.currentDeviceMenu_switch1 = True
	endif
	if isPlugged()
		UDCDmain.currentDeviceMenu_switch2 = True
	endif
	UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
	bool res = parent.proccesSpecialMenu(msgChoice)
	if msgChoice == 0 ; Insert Plug
		plugGag()
		return false
	ElseIf msgChoice == 1 ; Remove Plug
		if wearerFreeHands(True)
			unplugGag()
			return true
		else
			return removePlugMinigame()
		endif
	EndIf
	return res
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	bool res = parent.proccesSpecialMenuWH(akSource,msgChoice)
	if msgChoice == 0 ; Insert Plug
		plugGag()
		return false
	ElseIf msgChoice == 1 ; Remove Plug
		if wearerFreeHands(True) || helperFreeHands(True)
			unplugGag()
			return true
		else
			return removePlugMinigame()
		endif
	EndIf
	return res
EndFunction

bool removePlugMinigame_on = False
bool Function removePlugMinigame()
	if !minigamePrecheck()
		return false
	endif
	
	resetMinigameValues()
	
	setMinigameOffensiveVar(False,0.0,0.0,True)
	setMinigameWearerVar(True,UD_base_stat_drain*0.8)
	setMinigameEffectVar(True,True,1.0)
	setMinigameWidgetVar(True,False,0xc5f513,0x8df513)
	setMinigameMinStats(0.7)
	
	float mult = 1.0
	if hasHelper()
		setMinigameHelperVar(True,UD_base_stat_drain*0.8)
		setMinigameEffectHelperVar(True,True,1.2)	
		mult += 0.25
		if HelperFreeHands(True,True)
			mult += 0.15
		endif
	endif
	setMinigameMult(1,mult)
	
	if minigamePostCheck()
		removePlugMinigame_on = True
		minigame()
		removePlugMinigame_on = False
		return true
	else
		return false
	endif
EndFunction

float removePlugProgress = 0.0
Function OnMinigameTick()
	if removePlugMinigame_on
		removePlugProgress += Utility.randomFloat(1.5,6.0)*UDCDmain.getStruggleDifficultyModifier()*UDmain.UD_baseUpdateTime*getMinigameMult(1)
		if removePlugProgress > UD_RemovePlugDifficulty
			stopMinigame()
			removePlug()
			removePlugMinigame_on = False
		endif
	endif
	parent.OnMinigameTick()
EndFunction

bool Function OnCritDevicePre()
	if removePlugMinigame_on
		removePlugProgress += Utility.randomFloat(5.0,10.0)*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1)
		if removePlugProgress > UD_RemovePlugDifficulty
			stopMinigame()
			removePlug()
			removePlugMinigame_on = False
		endif
		Return True
	else
		return parent.OnCritDevicePre()
	endif
EndFunction

Function OnCritFailure()
	if removePlugMinigame_on
		removePlugProgress -= 5.0
		if removePlugProgress < 0
			removePlugProgress = 0.0
		endif
	endif
	parent.OnCritFailure()
EndFunction

Function plugGag(bool silent = false)
	libs.PlugPanelgag(getWearer())
	if !silent
		if hasHelper()
			if WearerIsPlayer()
				debug.notification(getHelperName() +" inserted plug in to yours " + getDeviceName() + "!")
			elseif WearerIsFollower() && HelperIsPlayer()
				debug.notification("You inserted the plug in "+getWearerName()+"s "+ getDeviceName())
			elseif WearerIsFollower()
				debug.notification(getHelperName() + " inserted plug in to the "+getWearerName()+"s "+ getDeviceName())
			endif
		else
			if WearerIsPlayer()
				debug.notification("You insert the plug in to the panel gag")
			elseif WearerIsFollower()
				debug.notification(getWearerName()+" inserts the plug in to the "+ getDeviceName())
			endif
		endif
	endif
	resetCooldown()
	removePlugProgress = 0.0
EndFunction

Function unplugGag(bool silent = false)
	libs.UnPlugPanelGag(getWearer())
	if !silent
		if hasHelper()
			if WearerIsPlayer()
				debug.notification("With " + getHelperName() +"s help you managed to remove the plug from the panel gag.")
			elseif WearerIsFollower() && HelperIsPlayer()
				debug.notification("You helped  "+getWearerName()+" to remove the plug from the "+ getDeviceName())
			elseif WearerIsFollower()
				debug.notification(getHelperName() + " helped "+getWearerName()+" to remove the plug from the "+ getDeviceName())
			endif
		else
			if WearerIsPlayer()
				debug.notification("You removed the plug from the "+ getDeviceName() +"!")
			elseif WearerIsFollower()
				debug.notification(getWearerName()+" removed the plug from the "+ getDeviceName())
			endif
		endif
	endif
	resetCooldown()
	;removePlugProgress = 0.0
EndFunction

Function addPlug()
	plugGag(True)
EndFunction

Function removePlug()
	unplugGag()
EndFunction

bool Function isPlugged()
	if getWearer().GetFactionRank(UDCDmain.zadGagPanelFaction)
		return True
	else
		return False
	endif
EndFunction

bool Function canBeActivated()
	return !isPlugged()
EndFunction

Function activateDevice()
	if WearerIsPlayer()
		debug.notification("Your panel gag plugs itself!")
	elseif WearerIsFollower()
		debug.notification(getWearerName() + "s " + getDeviceName()+" plugs itself!")		
	endif
	addPlug()
EndFunction

Function updateWidget(bool force = false)
	if removePlugMinigame_on
		setWidgetVal(removePlugProgress/UD_RemovePlugDifficulty,force)	
	else
		parent.updateWidget(force)
	endif
EndFunction
