Scriptname UD_CustomDynamicHeavyBondage_RS extends UD_CustomDevice_RenderScript

bool _tied = false
float Property UD_UntieDifficulty = 100.0 auto
float _untieProgress = 0.0


Function InitPost()
	UD_DeviceType = "Dynamic Heavy Bondage"
	UD_ActiveEffectName = "Tie up"
EndFunction

string Function addInfoString(string str = "")
	str = parent.addInfoString(str)
	str += "Tied up?: " + _tied + "\n"
	if _tied
		str += "Untie progress: " + UDmain.FormatString(getRelativeUntieProgress()*100.0,1) + " %\n"
	endif
	return str
EndFunction

Function safeCheck()
	if !UD_SpecialMenuInteraction
		UD_SpecialMenuInteraction = UDCDmain.DefaultDynamicHBSpecialMsg
	endif
	if !UD_SpecialMenuInteractionWH
		UD_SpecialMenuInteractionWH = UDCDmain.DefaultDynamicHBSpecialMsg
	endif
	parent.safeCheck()
EndFunction

float Function getRelativeUntieProgress()
	return _untieProgress/UD_UntieDifficulty
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
	parent.onDeviceMenuInitPost(aControlFilter)
	
	if _tied; && !WearerFreeHands()
		UDCDmain.currentDeviceMenu_switch1 = True
	endif
	if !_tied && WearerFreeHands()
		UDCDmain.currentDeviceMenu_switch2 = True
	endif
	UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
	parent.onDeviceMenuInitPostWH(aControlFilter)
	
	if _tied
		UDCDmain.currentDeviceMenu_switch1 = True
	endif
	if !_tied && (WearerFreeHands() || HelperFreeHands())
		UDCDmain.currentDeviceMenu_switch2 = True
	endif
	UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
	bool res = parent.proccesSpecialMenu(msgChoice)
	if msgChoice == 0 ; untie
		return UntieMinigame()
	ElseIf msgChoice == 1 ; tie up
		tieUp()
		return true
	EndIf
	return res
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	bool res = parent.proccesSpecialMenuWH(akSource,msgChoice)
	if msgChoice == 0 ; untie
		return UntieMinigame()
	ElseIf msgChoice == 1 ; tie up
		tieUp()
		return true
	EndIf
	return res
EndFunction

bool _untieMinigameOn = false
bool Function UntieMinigame()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("UntieMinigame called for " + getDeviceName() + " on " + getWearerName())
	endif
	resetMinigameValues()
	
	setMinigameOffensiveVar(False,0.0,0.0)
	setMinigameCustomCrit(15,0.75)
	setMinigameWearerVar(True,UD_base_stat_drain)
	setMinigameEffectVar(True,True,0.5)
	setMinigameWidgetVar(True,False,0xFFA200,0xFFA200)
	setMinigameMinStats(0.3)
	
	float mult = 1.0
	
	if WearerFreeHands()
		mult += 0.25
	endif
	
	if hasHelper()
		setMinigameHelperVar(True,UD_base_stat_drain*0.8)
		setMinigameEffectHelperVar(True,True,1.2)	
		mult += 0.25
	endif
	setMinigameMult(1,mult)
	
	if minigamePreCheck()
		_untieMinigameOn = True
		minigame()
		_untieMinigameOn = False
		return true
	else
		return false
	endif
EndFunction

Function OnMinigameTick()
	if _untieMinigameOn
		_untieProgress = fRange(_untieProgress + 1.0*UDCDmain.getStruggleDifficultyModifier()*UDmain.UD_baseUpdateTime*getMinigameMult(1),0.0,UD_UntieDifficulty)
		if _untieProgress >= UD_UntieDifficulty
			stopMinigame()
			untie()
			_untieMinigameOn = False
		endif
	endif
	parent.OnMinigameTick()
EndFunction

bool Function OnCritDevicePre()
	if _untieMinigameOn
		_untieProgress = fRange(_untieProgress + 8.0*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1),0.0,UD_UntieDifficulty)
		if _untieProgress >= UD_UntieDifficulty
			stopMinigame()
			untie()
			_untieMinigameOn = False
		endif
		Return True
	else
		return parent.OnCritDevicePre()
	endif
EndFunction

Function OnCritFailure()
	if _untieMinigameOn
		_untieProgress =  fRange(_untieProgress - UD_UntieDifficulty*0.15,0.0,UD_UntieDifficulty)
	endif
	parent.OnCritFailure()
EndFunction

Function updateWidget(bool force = false)
	if _untieMinigameOn
		setWidgetVal(_untieProgress/UD_UntieDifficulty,force)	
	else
		parent.updateWidget(force)
	endif
EndFunction

;requires override
bool Function canBeActivated()
	return false
EndFunction

Function activateDevice()
	if WearerIsPlayer()
		UDCDmain.Print(getDeviceName() + " is tying you up!")
	elseif WearerIsFollower()
		UDCDmain.Print(getWearerName() + "s " + getDeviceName() + " is tying them!")	
	endif
	TieUp()
EndFunction

Bool Function IsTiedUp()
	return _tied
EndFunction

Function TieUp()
	if !_tied
		_tied = true
		resetCooldown()
		OnTiedUp()
	endif
EndFunction

Function Untie()
	if _tied
		_untieProgress = 0.0
		_tied = false
		resetCooldown()
		OnUntied()
	endif
EndFunction

Function OnTiedUp()
EndFunction

Function OnUntied()
EndFunction

Function removeDevice(actor akActor)
	Untie()
	parent.removeDevice(getWearer())
EndFunction


