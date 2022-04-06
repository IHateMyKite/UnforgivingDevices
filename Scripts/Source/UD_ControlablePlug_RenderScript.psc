Scriptname UD_ControlablePlug_RenderScript extends UD_CustomPlug_RenderScript  

float Property UD_DischargeRate = 1.0 auto

bool turned_on = false
int selected_strenght = 0
int current_strenght = 0
int selected_mod = 0

Function InitPost()
	parent.InitPost()
	UD_ActiveEffectName = "Long Vib"
	UD_DeviceType = "Controllable Plug"
EndFunction

Function safeCheck()
	if !UD_SpecialMenuInteraction
		UD_SpecialMenuInteraction = UDCDmain.DefaultCTRPlugSpecialMsg
	endif
	if !UD_SpecialMenuInteractionWH
		UD_SpecialMenuInteractionWH = UDCDmain.DefaultCTRPlugSpecialMsgWH
	endif
	parent.safeCheck()
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
	parent.onDeviceMenuInitPost(aControlFilter)
	if wearerFreeHands(True) && !isVibrating()
		UDCDmain.currentDeviceMenu_switch3 = True
	endif
	if isVibrating()
		UDCDmain.currentDeviceMenu_switch4 = True
	endif
	UDCDmain.currentDeviceMenu_switch1 = False
	UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
	parent.onDeviceMenuInitPostWH(aControlFilter)
	if (wearerFreeHands(True) || helperFreeHands(True)) && !isVibrating()
		UDCDmain.currentDeviceMenu_switch3 = True
	endif
	if isVibrating()
		UDCDmain.currentDeviceMenu_switch4 = True
	endif
	UDCDmain.currentDeviceMenu_switch1 = False
	UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
	bool res = parent.proccesSpecialMenu(msgChoice)
	if msgChoice == 1
		turnOnPlug(UDCDmain.ControlablePlugVibMessage.show() + 1,UDCDmain.ControlablePlugModMessage.show())
		res = True
	elseif msgChoice == 2
		if wearerFreeHands(True,False) || !WearerIsPlayer()
			turnOffPlug()
			res = True
		else
			turnOffPlugMinigame()
			res = True
		endif
	endif
	return res
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	bool res = parent.proccesSpecialMenuWH(akSource,msgChoice)
	if msgChoice == 1
		turnOnPlug(UDCDmain.ControlablePlugVibMessage.show() + 1,UDCDmain.ControlablePlugModMessage.show())
		return false
	elseif msgChoice == 2
		if wearerFreeHands(True,False) || HelperFreeHands(True,False)
			turnOffPlug()
			return false
		else
			return turnOffPlugMinigame()
		endif
	endif
	return res
EndFunction

Function turnOnPlug(int strenght, int mod)
	;if !turned_on
	;turned_on = True
	selected_mod = mod
	
	if isVibrating()
		stopVibratingAndWait()
	endif
	
	selected_strenght = strenght
	if selected_strenght == 6
		forceStrength(Utility.randomInt(1,100))
	else
		forceStrength(selected_strenght*Utility.randomInt(18,20))
	endif
	forceEdgingMode(selected_mod)
	UDCDmain.startVibFunction(self,true)
	;endif
EndFunction

Function turnOffPlug()
	;turned_on = False
	stopVibratingAndWait()
	resetCooldown()
EndFunction

Function removeDevice(actor akActor)
	;turned_on = False
	parent.removeDevice(getWearer())
EndFunction

bool turnOffPlugMinigame_on = false
bool Function turnOffPlugMinigame()
	if !minigamePrecheck()
		return false
	endif
	resetMinigameValues()
	
	setMinigameOffensiveVar(False,0.0,0.0)
	setMinigameCustomCrit(40,0.75)
	setMinigameWearerVar(True,UD_base_stat_drain)
	setMinigameEffectVar(True,True,0.5)
	setMinigameWidgetVar(True,False,0xe21db5)
	setMinigameMinStats(0.3)
	float mult = 1.0
	
	if hasHelper()
		setMinigameHelperVar(True,UD_base_stat_drain)
		setMinigameEffectHelperVar(True,True,0.75)
		mult += 0.15
		if HelperFreeHands(True,True)
			mult += 0.15
		endif
	endif
	;setMinigameMult(1,mult*UD_DischargeRate)
	
	if minigamePostCheck()
		turnOffPlugMinigame_on = True
		minigame()
		turnOffPlugMinigame_on = False
		return true
	else
		return false
	endif
EndFunction

Function OnCritFailure()
	if turnOffPlugMinigame_on		
		addVibDuration(45)
	endif
	parent.OnCritFailure()
EndFunction

bool Function OnCritDevicePre()
	if turnOffPlugMinigame_on
		int loc_duration = UDmain.Round(30*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1))
		if getWearer().getItemCount(UDCDmain.UDlibs.EmptySoulgem_Common)
			getWearer().removeItem(UDCDmain.UDlibs.EmptySoulgem_Common,1)
			getWearer().addItem(UDCDmain.UDlibs.FilledSoulgem_Common,1,true)
			loc_duration = Math.floor(loc_duration*5.0)
		elseif getWearer().getItemCount(UDCDmain.UDlibs.EmptySoulgem_Lesser)
			getWearer().removeItem(UDCDmain.UDlibs.EmptySoulgem_Lesser,1)
			getWearer().addItem(UDCDmain.UDlibs.FilledSoulgem_Lesser,1,true)
			loc_duration = Math.floor(loc_duration*3.5)
		elseif getWearer().getItemCount(UDCDmain.UDlibs.EmptySoulgem_Petty)
			getWearer().removeItem(UDCDmain.UDlibs.EmptySoulgem_Petty,1)
			getWearer().addItem(UDCDmain.UDlibs.FilledSoulgem_Petty,1,true)
			loc_duration = Math.floor(loc_duration*2.0)
		endif
		removeVibDuration(loc_duration)
		
		if isVibrating()
			if Utility.randomInt() < 25 ;25% chance
				removeVibStrength(UDCDmain.Round(10*UD_DischargeRate))
				debug.notification("You notice that the " + getDeviceName() + " vibrates weaker then before")
			endif
		endif
		return True
	else
		return parent.OnCritDevicePre()
	endif
EndFunction

string Function addInfoString(string str = "")
	return parent.addInfoString(str)
EndFunction

float minutes_updated = 0.0
Function OnUpdatePost(float timePassed)
	minutes_updated += timePassed*(24*60)
	if isVibrating() && selected_strenght == 6
		if minutes_updated >= 15.0
			int loc_newStrength = Utility.randomInt(25,100)
			if WearerIsPlayer()
				debug.notification("Your " + getDeviceName() + " changes its vibration strength!")
			elseif WearerIsFollower()
				debug.notification(getWearerName() + "s " + getDeviceName() + " changes its vibration strength!")
			endif
			forceStrength(loc_newStrength)
			minutes_updated = 0.0
		endif
	endif
	parent.OnUpdatePost(timePassed)
EndFunction

Function updateHour(float mult)
	parent.updateHour(mult)
EndFunction

int Function getArousalRate()
	return parent.getArousalRate() + 5
EndFunction

bool Function canVibrate()
	return true
EndFunction

Function activateDevice()
	resetCooldown()
	if !isVibrating()
		if WearerIsPlayer()
			debug.notification("Your "+ getDeviceName() +" suddenly turn itself on!")
		elseif WearerIsFollower()
			debug.notification(getWearerName() + "s "+ getDeviceName() +" suddenly turn itself on!")
		endif
		turnOnPlug(3,0)
	elseif isVibrating()
		if getCurrentVibStrenth() < 100
			if WearerIsPlayer()
				debug.notification("Your controlable "+getPlugType()+" plug suddenly starts to vibrate stronger!")
			elseif WearerIsFollower()			
				debug.notification(getWearerName() + "s "+getDeviceName()+" suddenly starts to vibrate stronger!")
			endif
			addVibStrength(10)
		endif
		if Utility.randomInt() < 50
			addVibDuration(300)
			if WearerIsPlayer()
				debug.notification("Your controlable "+getPlugType()+" plug regain some of its charge!")
			elseif WearerIsFollower()			
				debug.notification(getWearerName() + "s "+getDeviceName()+" regain some of its charge!")
			endif
		endif
	endif
EndFunction

Function updateWidget(bool force = false)
	if turnOffPlugMinigame_on
		setWidgetVal(getRemainingVibrationDurationPer(),force)	
	else
		parent.updateWidget(force)
	endif
EndFunction

Function updateWidgetColor()
	if turnOffPlugMinigame_on
		if getRemainingVibrationDurationPer() > 0.8
			setWidgetColor(0xdd66c2)
		elseif getRemainingVibrationDurationPer() > 0.5
			setWidgetColor(0xde84ca)
		elseif getRemainingVibrationDurationPer() > 0.25
			setWidgetColor(0xdfa3d2)	
		else
			setWidgetColor(0xdec5d8)	
		endif
	else
		parent.updateWidgetColor()
	endif
EndFunction

Function OnVibrationEnd()
	if turnOffPlugMinigame_on
		StopMinigame()
	else
		parent.OnVibrationEnd()
	endif
EndFunction