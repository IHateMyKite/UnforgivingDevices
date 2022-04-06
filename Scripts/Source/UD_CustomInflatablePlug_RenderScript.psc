Scriptname UD_CustomInflatablePlug_RenderScript extends UD_CustomPlug_RenderScript  

float Property UD_PumpDifficulty = 50.0 auto
float Property UD_DeflateRate = 200.0 auto
int _inflateLevel = 0 ;for npcs

Function InitPost()
	parent.InitPost()
	if UD_ActiveEffectName == "Share"
		UD_ActiveEffectName = "Inflate"
	else
		UD_ActiveEffectName = "Inflate & " + UD_ActiveEffectName
	endif
	UD_DeviceType = "Inflatable Plug"
EndFunction

Function safeCheck()
	if !UD_SpecialMenuInteraction
		UD_SpecialMenuInteraction = UDCDmain.DefaultINFPlugSpecialMsg
	endif
	if !UD_SpecialMenuInteractionWH
		UD_SpecialMenuInteractionWH = UDCDmain.DefaultINFPlugSpecialMsgWH
	endif
	parent.safeCheck()
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
	parent.onDeviceMenuInitPost(aControlFilter)
	int pump_level = getPlugInflateLevel()
	if pump_level < 5
		UDCDmain.currentDeviceMenu_switch3 = True
		if wearerFreeHands(True)
			UDCDmain.currentDeviceMenu_switch5 = True
		endif
	endif
	if pump_level > 0 && pump_level != 5
		UDCDmain.currentDeviceMenu_switch4 = True
	endif
	UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
	parent.onDeviceMenuInitPostWH(aControlFilter)
	int pump_level = getPlugInflateLevel()
	if pump_level < 5
		UDCDmain.currentDeviceMenu_switch3 = True
		if wearerFreeHands(True) || helperFreeHands(True)
			UDCDmain.currentDeviceMenu_switch5 = True
		endif
	endif
	if pump_level > 0 && pump_level != 5
		UDCDmain.currentDeviceMenu_switch4 = True
	endif
	UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
	bool res = parent.proccesSpecialMenu(msgChoice)
	if msgChoice == 1
		if wearerFreeHands(True)
			inflate()
			return false
		else
			return inflateMinigame()
		endif
	elseif msgChoice == 2
		if wearerFreeHands(True)
			inflate(false,5)
			return false
		endif
	elseif msgChoice == 3
		if wearerFreeHands(True) && canDeflate() 
			deflate()
			return false
		else
			return deflateMinigame()
		endif	
	endif
	return res
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	bool res = parent.proccesSpecialMenuWH(akSource,msgChoice)
	if msgChoice == 0
		if wearerFreeHands(True) || helperFreeHands(True)
			inflate()
			return false
		else
			return inflateMinigame()
		endif
	elseif msgChoice == 1
		inflate(false,5)
		return false
	elseif msgChoice == 2
		if (wearerFreeHands(True) || helperFreeHands(True)) && canDeflate() 
			deflate()
			return false
		else
			return deflateMinigame()
		endif	
	endif
	return res
EndFunction

;/
Function DeviceMenuExt(Int msgChoice)
	if msgChoice == 5
		if wearerFreeHands(True)
			inflate()
		else
			inflateMinigame()
		endif
	elseif msgChoice == 6
		if wearerFreeHands(True) && canDeflate() 
			deflate()
		else
			deflateMinigame()
		endif	
	endif
EndFunction

Function DeviceMenuExtWH(Int msgChoice)
	if msgChoice == 5
		if wearerFreeHands(True) || helperFreeHands(True)
			inflate()
		else
			inflateMinigame()
		endif
	elseif msgChoice == 6
		if (wearerFreeHands(True) || helperFreeHands(True)) && canDeflate() 
			deflate()
		else
			deflateMinigame()
		endif	
	endif
EndFunction
/;
string Function addInfoString(string str = "")
	;string res = str
	str += "Inflate level: " + getPlugInflateLevel() + "\n"
	if getPlugInflateLevel() > 0
		str += "Plug pressure: " + Math.Ceiling(100.0 - 100.0*deflateprogress/UD_PumpDifficulty) + " %\n"
	endif
	return parent.addInfoString(str)
EndFunction

float Function getAccesibility()
	float loc_res = parent.getAccesibility()
	if loc_res > 0.0
		if !(getWearer().wornhaskeyword(libs.zad_DeviousBelt) || getWearer().wornhaskeyword(libs.zad_DeviousHarness))
			loc_res *= (1.0 - getPlugInflateLevel()*0.2)
		endif
	endif
	return fRange(loc_res,0.0,1.0)
EndFunction

float inflateprogress = 0.0

bool inflateMinigame_on = false
bool Function inflateMinigame()
	if !minigamePrecheck()
		return false
	endif

	resetMinigameValues()
	
	setMinigameOffensiveVar(False,0.0,0.0,True)
	setMinigameWearerVar(True,UD_base_stat_drain*0.6)
	setMinigameEffectVar(True,True,0.5)
	setMinigameWidgetVar(True,False,0x7c9cfb,0x7c2cfd)
	setMinigameMinStats(0.3)
	float mult = 1.0
	if hasHelper()
		setMinigameHelperVar(True,UD_base_stat_drain*0.75)
		setMinigameEffectHelperVar(True,True,0.75)	
		mult += 0.25
		if HelperFreeHands(True,True)
			mult += 0.15
		endif
	endif
	if minigamePostcheck()
		setMinigameMult(1,mult)
		inflateMinigame_on = True
		minigame()
		inflateMinigame_on = False
		return true
	else
		return false
	endif
EndFunction

float deflateprogress = 0.0

bool deflateMinigame_on = false
bool Function deflateMinigame()
	if !minigamePrecheck()
		return false
	endif

	resetMinigameValues()
	
	setMinigameOffensiveVar(False,0.0,0.0,True)
	setMinigameWearerVar(True,UD_base_stat_drain*0.8)
	setMinigameEffectVar(True,True,0.8)
	setMinigameWidgetVar(True,False,0x7c9cfb,0x7c2cfd)
	setMinigameMinStats(0.6)
	float mult = 1.0
	if hasHelper()
		setMinigameHelperVar(True,UD_base_stat_drain*0.75)
		setMinigameEffectHelperVar(True,True,0.75)	
		mult += 0.15
		if HelperFreeHands(True,True)
			mult += 0.10
		endif		
	endif
	setMinigameMult(1,mult)
	
	if minigamePostcheck()
		deflateMinigame_on = True
		minigame()
		deflateMinigame_on = False
		return true
	else
		return false
	endif
EndFunction

Function inflate(bool silent = false,int iInflateNum = 1)
		int currentVal = getPlugInflateLevel() + iInflateNum
		if !silent
			if hasHelper()
				if WearerIsPlayer()
					debug.notification(getHelperName() + " helped you to inflate yours " + getDeviceName() + "!")
				elseif WearerIsFollower() && HelperIsPlayer()
					debug.notification("You helped to inflate " + getWearerName() + "s " + getDeviceName() + "!")
				elseif WearerIsFollower()
					debug.notification(getHelperName() + " helped to inflate " + getWearerName() + "s " + getDeviceName() + "!")
				endif			
			else
				if WearerIsPlayer()
					debug.notification("You succesfully inflated yours " + getDeviceName())
					
					if currentVal == 0
						libs.notify("Your plug is completely deflated and doesn't stimulate you very much. You could slide it out of you, if you wish. That or you could give the pump a healthy squeeze and make it more fun!", messagebox = true)
					elseif currentVal == 1
						libs.notify("Your plug is a bit inflated but doesn't stimulate you too much - just enough to make you long for more. You could give the pump a healthy squeeze!", messagebox = true)
					elseif currentVal == 2
						libs.notify("Your plug is inflated. Its gentle movements inside you please you without causing you discomfort. You are getting more horny and wonder if you should inflate it even more?", messagebox = true)
					elseif currentVal == 3
						libs.notify("Your fairly inflated plug is impossible to ignore as it moves around inside of you, constantly pleasing you and making you more horny as you already are.", messagebox = true)
					elseif currentVal == 4
						libs.notify("Your plug is almost inflated to capacity. You cannot move at all without shifting it around inside of you, making you squeal in an odd sensation of pleasurable pain.", messagebox = true)
					else
						libs.notify("Your plug is fully inflated and almost bursting inside you. It's causing you more discomfort than anything. But no matter what - you won't be able to remove it from your body anytime soon.", messagebox = true)		
					EndIf	
				elseif WearerIsFollower()
					debug.notification(getWearerName() + "s " + getDeviceName() + " inflated!")
				endif
			endif
		endif
		inflatePlug(iInflateNum)
		inflateprogress = 0.0
EndFunction

Function deflate(bool silent = False)
	if !silent
		if hasHelper()
			if WearerIsPlayer()
				debug.notification(getHelperName() + " helped you to deflate yours " + getDeviceName() + "!")
			elseif WearerIsFollower() && HelperIsPlayer()
				debug.notification("You helped to deflate " + getWearerName() + "s " + getDeviceName() + "!")
			elseif WearerIsFollower()
				debug.notification(getHelperName() + " helped to deflate " + getWearerName() + "s " + getDeviceName() + "!")
			endif			
		else
			if WearerIsPlayer()
				debug.notification("You succesfully deflated yours "+getPlugType()+" plug!")
			elseif WearerIsFollower()
				debug.notification(getWearerName() + "s " + getDeviceName()+ " deflated!")
			endif
		endif
	endif
	deflatePlug(1)
	return
EndFunction

bool Function canDeflate()
	if getPlugInflateLevel() > 0
		if getPlugInflateLevel() < 5
			return True
		endif
	else
		if WearerIsPlayer()
			debug.MessageBox("Plug is already deflated")
		elseif WearerIsFollower()
			debug.notification(getWearerName() + "s "+ getDeviceName() + " is already deflated")
		endif
		return False
	endif
	if WearerIsPlayer()
		debug.MessageBox("Plug is too big to be deflated at the moment!")
	elseif WearerIsFollower()
		debug.notification(getWearerName() + "s "+ getDeviceName() + " is too big to be deflated at the moment!")
	endif
	return False
EndFunction

int Function getPlugInflateLevel()
	if WearerIsPlayer()
		If UD_DeviceKeyword == libs.zad_DeviousPlugAnal
			return  libs.zadInflatablePlugStateAnal.GetValueInt()
		Else
			return libs.zadInflatablePlugStateVaginal.GetValueInt()
		EndIf
	else
		return _inflateLevel
	endif
EndFunction

Function inflatePlug(int increase)
	If UD_DeviceKeyword == libs.zad_DeviousPlugAnal
		libs.InflateAnalPlug(getWearer(), increase)
	Else	
		libs.InflateVaginalPlug(getWearer(), increase)
	EndIf
	
	_inflateLevel += increase
	if _inflateLevel > 5
		_inflateLevel = 5
	endif
	deflateprogress = 0.0
EndFunction

Function deflatePlug(int decrease)
	If UD_DeviceKeyword == libs.zad_DeviousPlugAnal
		libs.DeflateAnalPlug(getWearer(), decrease)
	Else	
		libs.DeflateVaginalPlug(getWearer(), decrease)
	EndIf
	
	_inflateLevel -= 1
	if _inflateLevel < 0
		_inflateLevel = 0
	endif
	deflateprogress = 0.0
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchPlug(self)
EndFunction

Function OnMinigameTick()
	if inflateMinigame_on
		inflateprogress += Utility.randomFloat(8.2,12.0)*UDCDmain.getStruggleDifficultyModifier()*UDmain.UD_baseUpdateTime*getMinigameMult(1)
		if inflateprogress > UD_PumpDifficulty
			stopMinigame()
		endif	
	endif
	
	if deflateMinigame_on
		deflateprogress += Utility.randomFloat(3.5,8.0)*UDCDmain.getStruggleDifficultyModifier()*UDmain.UD_baseUpdateTime*getMinigameMult(1)
		if deflateprogress > UD_PumpDifficulty
			stopMinigame()
		endif	
	endif
	
	parent.OnMinigameTick1()
EndFunction

Function OnMinigameEnd()
	if inflateMinigame_on && inflateprogress >= UD_PumpDifficulty
		inflate()
	endif
	if deflateMinigame_on && deflateprogress >= UD_PumpDifficulty
		deflate()
	endif
EndFunction

Function OnCritFailure()
	if inflateMinigame_on
		inflateprogress -= 10.0
		if inflateprogress < 0.0
			inflateprogress = 0.0
		endif	
	elseif deflateMinigame_on
		deflateprogress -= 20.0
		if deflateprogress < 0.0
			deflateprogress = 0.0
		endif
	endif
	parent.OnCritFailure()
EndFunction

bool Function OnCritDevicePre()
	if inflateMinigame_on
		inflateprogress += Utility.randomFloat(20.2,30.0)*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1)
		if inflateprogress > UD_PumpDifficulty
			stopMinigame()
		endif	
	elseif deflateMinigame_on
		deflateprogress += Utility.randomFloat(15.5,25.0)*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1)
		if deflateprogress > UD_PumpDifficulty
			stopMinigame()
		endif
	else
		return parent.OnCritDevicePre()
	endif
	return True
EndFunction

Function activateDevice()
	resetCooldown()
	bool loc_canInflate = _inflateLevel <= 4
	bool loc_canVibrate = canVibrate() && !isVibrating()
	if loc_canInflate
		if WearerIsPlayer()
			debug.notification("Your "+getPlugType()+" plug suddenly inflate itself!")
		elseif WearerIsFollower()
			debug.notification(getWearerName() + "s "+ getDeviceName() + " suddenly inflate itself!")		
		endif
		inflatePlug(1)
		hours_updated = 0.0
	endif
	if loc_canVibrate
		vibrate()
	endif
EndFunction

float hours_updated = 0.0
Function updateHour(float mult)
	parent.updateHour(mult)
	hours_updated += mult
	
	if Utility.randomInt() < 35 && isSentient() && hours_updated >= 2.5
		UDCDmain.activateDevice(self)
	endif
EndFunction

Function onUpdatePost(float timePassed)
	if getPlugInflateLevel() > 0
		deflateprogress += timePassed*UD_DeflateRate*Utility.randomFloat(0.75,1.25)*UDCDmain.getStruggleDifficultyModifier()
		if deflateprogress > UD_PumpDifficulty
			if WearerIsPlayer()
				debug.notification("You feel that your inflatable "+getPlugType()+" plug lost some of its pressure")
			elseif WearerIsFollower()
				debug.notification(getWearerName() + "s "+ getDeviceName() + " lost some of its pressure")	
			endif
			deflate(True)
		endif
	endif	
EndFunction

Function OnMinigameStart()
	if !inflateMinigame_on
		parent.OnMinigameStart()
	endif
EndFunction

Function updateWidget(bool force = false)
	if inflateMinigame_on
		setWidgetVal(inflateprogress/UD_PumpDifficulty,force)	
	elseif deflateMinigame_on
		setWidgetVal(deflateprogress/UD_PumpDifficulty,force)
	else
		parent.updateWidget(force)
	endif
EndFunction

bool Function canBeActivated()
	if parent.canBeActivated() || (_inflateLevel <= 4 && getRelativeElapsedCooldownTime() >= 0.25)
		return true
	else
		return false
	endif
EndFunction