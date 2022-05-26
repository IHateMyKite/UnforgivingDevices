Scriptname UD_CustomVibratorBase_RenderScript extends UD_CustomDevice_RenderScript  

;Properties
int 	property 	UD_VibDuration 		= 60 	auto ;duration of vibrations. -1 will make the vibrator vib forever (or until stopVibrating() is called)
float 	property 	UD_ArousalMult 		= 1.0	auto ;arousal multiplier, multiplies arousal which is adde while vib is on
float 	property 	UD_OrgasmMult 		= 1.0 	auto ;orgasm multiplier, multiples orgasm rate which is applied
int 	Property 	UD_VibStrength 		= -1 	auto ;Vib strength, if == -1, value will be set using keywords
int 	Property 	UD_EdgingMode 		= -1 	auto ;Edging mode = 0 - normal, 1 - Edging only, 2 - Edging random	
float 	Property 	UD_EdgingThreshold	= 0.75 	auto ;used only in edgeMode == 1,2
bool	Property	UD_Shocking			= False	auto ;change if plug should also shock actor when vibrate is called. If it can't vibrate, shock will still happen
int		Property	UD_Chaos			= 0		auto ;plug will randomly change its strength and duration on every turn

;local variables
int 	_currentVibRemainingDuration = 0
int 	_forceStrength 		= 	-1
int 	_currentVibStrength =	 0
int 	_forceDuration 		= 	 0
int 	_currentEdgingMode 	= 	-1
int 	_forceEdgingMode 	= 	-1
float 	_appliedOrgasmRate 	= 	0.0
float 	_appliedArousalRate	=	0.0
float 	_appliedForcing 	= 	0.0
int 	_vsID				= 	-1			;current sound ID used to play vib sounds
bool 	_paused 			= 	false		;on if vibrator is paused

Function InitPost()
	parent.InitPost()
	UD_DeviceType = "Vibrator"
	UD_ActiveEffectName = ""
	if deviceRendered.haskeyword(libs.zad_EffectChaosPlug)
		UD_Chaos = 25
		UD_ActiveEffectName += "Chaos"
	endif
	
	if (deviceRendered.haskeyword(libs.zad_EffectShocking))
		UD_Shocking = True
		UD_ActiveEffectName += "Shocking"
	endif
	
	if UD_VibStrength == -1
		if (deviceRendered.haskeyword(libs.zad_EffectVibratingVeryStrong))
			UD_VibStrength = 85
		elseif (deviceRendered.haskeyword(libs.zad_EffectVibratingStrong))
			UD_VibStrength = 65
		elseif (deviceRendered.haskeyword(libs.zad_EffectVibrating))
			UD_VibStrength = 40
		elseif deviceRendered.haskeyword(libs.zad_EffectVibratingWeak)
			UD_VibStrength = 25
		elseif deviceRendered.haskeyword(libs.zad_EffectVibratingVeryWeak)
			UD_VibStrength = 10
		else
			UD_VibStrength = 0
		endif
	endif
	
	if UD_VibStrength >= 50
		UD_ActiveEffectName += "Strong Vib"
	elseif UD_VibStrength >= 25
		UD_ActiveEffectName += "Vib"
	elseif UD_VibStrength > 0
		UD_ActiveEffectName += "Weak Vib"
	endif
	
	if UD_ActiveEffectName == ""
		UD_ActiveEffectName = "Share"
	endif
	
	if UD_EdgingMode < 0
		if deviceRendered.HasKeyword(libs.zad_EffectEdgeOnly)
			UD_EdgingMode = 1
		elseif deviceRendered.HasKeyword(libs.zad_EffectEdgeRandom)
			UD_EdgingMode = 2
		else
			UD_EdgingMode = 0
		endif
	endif

EndFunction

Function safeCheck()
	if !UD_SpecialMenuInteraction
		UD_SpecialMenuInteraction = UDCDmain.DefaultVibratorSpecialMsg
	endif
	if !UD_SpecialMenuInteractionWH
		UD_SpecialMenuInteractionWH = UDCDmain.DefaultVibratorSpecialMsg
	endif
	parent.safeCheck()
EndFunction

Function InitPostPost()
	;infinite vib duration, start immidiatly
	if UD_VibDuration == -1 
		vibrate()
	endif
EndFunction

string Function getEdgingModeString(int iMode)
	if iMode == 0
		return "Normal"
	elseif iMode == 1
		return "Edging"
	elseif iMode == 2
		return "Random Edging"
	else
		return "ERROR"
	endif
EndFunction

string Function getVibDetails(string str = "")
	str += "{-" + getDeviceName() + "-}\n"
	str += "--BASE VALUES--\n"
	if UD_Chaos
		str += "Vib strength: Chaos ( "+UD_Chaos+" %)\n"
	else
		str += "Vib strength: " + UD_VibStrength + "\n"
	endif
	
	str += "Vib duration: " + UD_VibDuration + "\n"
	str += "Vib mode: " + getEdgingModeString(UD_EdgingMode) + "\n"
	str += "Shocking: " + UD_Shocking + "\n"
	str += "Status --> "
	if isVibrating() && !isPaused()
		str += "ON\n"
		str += "Current vib strength: " + getCurrentVibStrenth() + "\n"

		if _currentVibRemainingDuration > 0
			str += "Rem. duration: " + _currentVibRemainingDuration + " s\n"
		else
			str += "Rem. duration: " + "INF" + " s\n"
		endif
		str += "Arousal rate: " + UDmain.FormatString(getVibArousalRate(),2) + " A/s\n"
		str += "Orgasm rate: " + UDmain.FormatString(_appliedOrgasmRate,2) + " Op/s\n"
		str += "Current vib mode: "
		if _currentEdgingMode == 0
			str += "Normal\n"
		elseif _currentEdgingMode == 1
			str += "Edge\n"
		elseif _currentEdgingMode == 2
			str += "Random\n"
		endif
	elseif isPaused()
		str += "PAUSED\n"
	else
		str += "OFF\n"
	endif
	return str
EndFunction

;function called when player clicks DETAILS button in device menu
Function processDetails()
	UDCDmain.currentDeviceMenu_switch1 = isVibrating() || canVibrate()
	int res = UDCDmain.VibDetailsMessage.show()	
	if res == 0 
		UDCDmain.ShowMessageBox(getInfoString())
	elseif res == 1
		UDCDmain.ShowMessageBox(getVibDetails())
	elseif res == 2
		UDCDmain.ShowMessageBox(getModifiers())
	elseif res == 3
		UDCDmain.showActorDetails(GetWearer())
	elseif res == 4
		showDebugInfo()
	else
		return
	endif
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
	parent.onDeviceMenuInitPost(aControlFilter)
	;UDCDmain.currentDeviceMenu_allowcutting = false
	if canVibrate() && WearerFreeHands() && WearerIsPlayer()
		UDCDmain.currentDeviceMenu_switch1 = True
		UDCDmain.currentDeviceMenu_allowSpecialMenu = True
	endif
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
	parent.onDeviceMenuInitPostWH(aControlFilter)
	;UDCDmain.currentDeviceMenu_allowcutting = false
	if canVibrate() && (WearerFreeHands() || HelperFreeHands()) && (WearerIsPlayer() || HelperIsPlayer())
		UDCDmain.currentDeviceMenu_switch1 = True
		UDCDmain.currentDeviceMenu_allowSpecialMenu = True
	endif
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
	bool res = parent.proccesSpecialMenu(msgChoice)
	if msgChoice == 0
		Int loc_res = UDCDmain.ShowSoulgemMessage(GetWearer())
		if loc_res >= 0
			if UDCDmain.ChangeSoulgemState(GetWearer(),loc_res)
				if !isVibrating()
					ForceModDuration(0.75 + (loc_res)*0.25)
					ForceModStrength(0.75 + (loc_res)*0.25)
					UDCDmain.startVibFunction(self,true)
				else
					addVibDuration((1 + loc_res)*20)
					addVibStrength((1 + loc_res)*6)
				endif
				return res
			endif
		endif
	endif
	return res
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	bool res = parent.proccesSpecialMenuWH(akSource,msgChoice)
	if msgChoice == 0
		Int loc_res = UDCDmain.ShowSoulgemMessage(Game.getPlayer())
		if loc_res >= 0
			if UDCDmain.ChangeSoulgemState(Game.getPlayer(),loc_res)
				if !isVibrating()
					ForceModDuration(0.75 + (loc_res)*0.25)
					ForceModStrength(0.75 + (loc_res)*0.25)
					UDCDmain.startVibFunction(self,true)
				else
					addVibDuration((1 + loc_res)*20)
					addVibStrength((1 + loc_res)*6)
				endif
				return res
			endif
		endif
	endif
	return res
EndFunction


Function activateDevice()
	resetCooldown()
	vibrate()
EndFunction

Function StopVibSound()
	if getWearer().is3DLoaded()
		Sound.StopInstance(_vsID)
	endif
	_vsID = -1
EndFunction

Function StartVibSound()
	if getWearer().is3DLoaded()
		if _vsID == -1
			_vsID = getVibrationSound().Play(getWearer())
			if WearerIsPlayer()
				Sound.SetInstanceVolume(_vsID, libs.Config.VolumeVibrator)
			else
				Sound.SetInstanceVolume(_vsID, libs.Config.VolumeVibrator * 0.5)
			endif
		endif
	endif
EndFunction

Function UpdateVibSound()
	StopVibSound()
	StartVibSound()
EndFunction

int Function getCurrentVibStrenth()
	return _currentVibStrength
EndFunction

int Function getCurrentZadVibStrenth()
	return Math.Ceiling(_currentVibStrength*0.05)
EndFunction

int Function getDefaultZadVibStrenth()
	return UDmain.Round(UD_VibStrength*0.05)
EndFunction

int Function getDefaultZadVibStrenthKey()
	return UDmain.Round(UD_VibStrength*0.05)
EndFunction

bool Function canVibrate()
	return (UD_VibStrength > 0) || UD_Chaos; || ((UD_Shocking ) && (UD_VibStrength > 0))
EndFunction

bool Function isVibrating()
	return _currentVibRemainingDuration != 0 && _currentVibStrength
EndFunction

int Function getRemainingVibrationDuration()
	return _currentVibRemainingDuration
EndFunction

float Function getRemainingVibrationDurationPer()
	if _forceDuration != 0
		return _currentVibRemainingDuration/(_forceDuration as float)
	else
		return _currentVibRemainingDuration/(UD_VibDuration as float)
	endif
EndFunction

bool Function isPaused()
	return _paused
EndFunction

Function stopVibrating()
	_currentVibRemainingDuration = 0
EndFunction

Function stopVibratingAndWait()
	if _currentVibRemainingDuration != 0
		_currentVibRemainingDuration = 0
		while _currentVibStrength
			Utility.wait(0.1)
		endwhile
	endif
EndFunction

Function ForceStrength(int iStrenth)
	_forceStrength = iStrenth
	if isVibrating()
		_currentVibStrength = _forceStrength
		if !isPaused()
			UpdateVibSound()
			UpdateOrgasmRate(getVibOrgasmRate(),_appliedForcing)
		endif
	endif
EndFunction

Function ForceModStrength(float fModifier)
	_forceStrength = UDCDmain.Round(UD_VibStrength*fModifier)
	if isVibrating()
		_currentVibStrength = _forceStrength
		if !isPaused()
			UpdateVibSound()
			UpdateOrgasmRate(getVibOrgasmRate(),_appliedForcing)
		endif
	endif
EndFunction

Function ForceDuration(int iDuration)
	if iDuration != 0
		_forceDuration = iDuration
		if isVibrating()
			_currentVibRemainingDuration = _forceDuration
		endif
	endif
EndFunction

Function ForceModDuration(float fModifier)
	if fModifier >= 0.1
		_forceDuration = UDCDmain.Round(UD_VibDuration*fModifier)
		if isVibrating()
			_currentVibRemainingDuration = _forceDuration
		endif
	endif
EndFunction

Function addVibDuration(int iValue = 1)
	if isVibrating()
		_currentVibRemainingDuration += iValue
	endif
EndFunction

Function removeVibDuration(int iValue = 1)
	if isVibrating()
		_currentVibRemainingDuration -= iValue
		if _currentVibRemainingDuration < 0
			_currentVibRemainingDuration = 0
		endif
	endif
EndFUnction

Function addVibStrength(int iValue = 1)
	if isVibrating()
		_currentVibStrength += iValue
		if _currentVibStrength > 100
			_currentVibStrength = 100
		endif
		if !isPaused()
			UpdateOrgasmRate(getVibOrgasmRate(),_appliedForcing)
			UpdateVibSound()
		endif
	endif
EndFunction

Function removeVibStrength(int iValue = 1)
	if isVibrating()
		_currentVibStrength -= iValue
		if _currentVibStrength < 0
			_currentVibStrength = 0
		endif
		if !isPaused() && isVibrating()
			UpdateOrgasmRate(getVibOrgasmRate(),_appliedForcing)
			UpdateVibSound()
		endif
	endif
EndFUnction

Function forceEdgingMode(int iMode)
	_forceEdgingMode = iMode
	_currentEdgingMode = _forceEdgingMode
EndFunction

float Function getVibArousalRate(float mult = 1.0)
	;if getWearer().HasMagicEffectWithKeyword(UDCDmain.UDlibs.OrgasmExhaustionEffect_KW)
	;	return _currentVibStrength * mult * UDCDmain.UD_ArousalMultiplier* 0.75 * UD_ArousalMult
	;else
		return _currentVibStrength * UDCDmain.UD_ArousalMultiplier * UD_ArousalMult
	;endif
EndFunction

Function pauseVibFor(int iTime)
	if iTime < 5
		iTime = 5
	endif
	_paused = true
	removeOrgasmRate()
	removeArousalRate()
	
	StopVibSound()
	
	int loc_elapsedTime = 0
	while (loc_elapsedTime < iTime) && isVibrating()
		Utility.wait(1.0)
		loc_elapsedTime += 1
	endwhile

	if isVibrating()
		setOrgasmRate(getVibOrgasmRate(),1.0)
		setArousalRate(getVibArousalRate())
		StartVibSound()
	endif
	_paused = false
EndFunction

float Function getVibOrgasmRate(float mult = 1.0)
	return _currentVibStrength * mult * UDCDmain.UD_VibrationMultiplier * UD_OrgasmMult
EndFunction

Function UpdateOrgasmRate(float fOrgasmRate,float fOrgasmForcing)
	if isVibrating()
		removeOrgasmRate()
		if isVibrating()
			setOrgasmRate(fOrgasmRate,fOrgasmForcing)
		endif
	endif
EndFunction

Function setOrgasmRate(float fOrgasmRate,float fOrgasmForcing)
	if (fOrgasmRate != _appliedOrgasmRate || fOrgasmForcing != _appliedForcing) && isVibrating()
		_appliedOrgasmRate = fOrgasmRate
		_appliedForcing = fOrgasmForcing
		UDCDmain.UDOM.UpdateOrgasmRate(getWearer(),_appliedOrgasmRate,_appliedForcing)
	endif
EndFunction

Function removeOrgasmRate()
	if _appliedOrgasmRate != 0 || _appliedForcing != 0
		float loc_appliedOrgasmRate = _appliedOrgasmRate
		_appliedOrgasmRate = 0.0
		
		float loc_appliedForcing    = _appliedForcing
		_appliedForcing = 0.0
		
		UDCDmain.UDOM.removeOrgasmRate(getWearer(),loc_appliedOrgasmRate,loc_appliedForcing)
	endif
EndFunction

Function UpdateArousalRate(float fArousalRate)
	removeArousalRate()
	setArousalRate(fArousalRate)
EndFunction

Function setArousalRate(float fArousalRate)
	if fArousalRate != _appliedArousalRate 
		_appliedArousalRate = fArousalRate
		UDCDmain.UDOM.UpdateArousalRate(getWearer() ,fArousalRate)
	endif
EndFunction

Function removeArousalRate()
	if _appliedArousalRate != 0
		float loc_appliedArousalRate = _appliedArousalRate
		_appliedArousalRate = 0
		UDCDmain.UDOM.UpdateArousalRate(getWearer() ,-1*loc_appliedArousalRate)
	endif
EndFunction

Sound Function getVibrationSound()
	if _currentVibStrength >= 75
		return libs.VibrateVeryStrongSound
	elseIf _currentVibStrength >= 50
		return libs.VibrateStrongSound
	elseIf _currentVibStrength >= 30
		return libs.VibrateStandardSound
	elseIf _currentVibStrength >= 15
		return libs.VibrateWeakSound
	else
		return libs.VibrateVeryWeakSound
	EndIf
EndFunction

;custom function made to improve on DD function VibrateEffect and better implement it in to my mod
Function vibrate(float fDurationMult = 1.0)
	if isVibrating()
		return
	endif
	resetCooldown()
	
	OnVibrationStart()	
	
	
	if UD_Chaos ;chaos plug, ignore forced strength
		_currentVibStrength = Utility.randomInt(15,100)
	elseif _forceStrength < 0
		_currentVibStrength = UD_VibStrength ;auto set variables from properties
	else ;use forced strength
		_currentVibStrength = _forceStrength
	endif
	
	if _forceDuration == 0
		_currentVibRemainingDuration = UDmain.Round(UD_VibDuration*fDurationMult)
	else
		_currentVibRemainingDuration = _forceDuration
	endif
	
	if _forceEdgingMode < 0
		_currentEdgingMode = UD_EdgingMode
	else
		_currentEdgingMode = _forceEdgingMode
	endif
	
	if UD_Shocking
		ShockWearer(Utility.randomInt(50,90),25)
	endif
	
	if !isVibrating() ;not vib, error and return
		return
	endif
	
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Vibrate called for " + getDeviceName() + " on " + getWearerName() + ", duration: " + _currentVibRemainingDuration + ", strength: " + _currentVibStrength + ", edging: " + _currentEdgingMode)
	endif
	
	UDCDmain.SendModEvent("DeviceVibrateEffectStart", getWearerName(), getCurrentZadVibStrenth())
	
	if WearerIsPlayer()
		UDCDmain.Print(getDeviceName() + " starts vibrating "+ UDmain.getPlugsVibrationStrengthString(getCurrentZadVibStrenth()) +"!",3)
	elseif WearerIsFollower()
		UDCDmain.Print(getWearerName() + "s " + getDeviceName() + " starts vibrating "+ UDmain.getPlugsVibrationStrengthString(getCurrentZadVibStrenth()) +"!",3)
	endif

	; Initialize Sounds
	StartVibSound()
	
	setOrgasmRate(getVibOrgasmRate(),1.0)
	setArousalRate(getVibArousalRate())

	; Main Loop
	While (_currentVibRemainingDuration != 0)
		;vibrate sound
		if isVibrating() && !_paused
			if (_currentVibRemainingDuration % 2) == 0 ; Make noise
				getWearer().CreateDetectionEvent(getWearer(), 50 + UDmain.Round(UD_VibStrength/2.0))
			EndIf
		endif
		
		if UD_Chaos && isVibrating() && !_paused
			if Utility.randomInt() < UD_Chaos
				ForceStrength(Utility.randomInt(15,95))
			endif
		endif
		
		;if isVibrating() && !_paused
			;libs.UpdateExposure(getWearer(), Round(getVibArousalRate()), skipMultiplier=true)
		;endif
		
		if isVibrating() && !_paused
			ProccesVibEdge()
		endif
		
		if isVibrating() && !_paused
			_currentVibRemainingDuration -= 1 ;reduce timer
			Utility.Wait(1.0)
		endif
		resetCooldown()
		while _paused
			Utility.wait(0.5)
		endwhile
	EndWhile
	
	removeOrgasmRate()
	removeArousalRate()
	
	StopVibSound()
		
	if !_paused
		if WearerIsPlayer()
			UDCDmain.Print(getDeviceName() + " stops vibrating.",3)
		elseif WearerIsFollower()
			UDCDmain.Print(getWearerName() + "s " + getDeviceName() + " stops vibrating.",3)
		endif
	endif
	UDCDmain.SendModEvent("DeviceVibrateEffectStop", getWearerName(), getCurrentZadVibStrenth())
	;libs.UpdateArousalTimeRate(getWearer(), _currentVibStrength)
	;libs.Aroused.GetActorArousal(getWearer())
	
	_currentVibRemainingDuration = 0
	_forceDuration = 0
	_forceStrength = -1
	_forceEdgingMode = -1
	_currentVibStrength = 0
	OnVibrationEnd()
EndFunction

Function ProccesVibEdge()
;/
	if _currentEdgingMode == 1
		if UDCDmain.getActorOrgasmProgress(getWearer()) > UD_EdgingThreshold
			if WearerIsPlayer()
				debug.notification(getDeviceName() + " suddenly stops vibrating!")
			endif
			if UD_Shocking
				ShockWearer(50,10)
			endif
			while UDCDmain.getActorOrgasmProgress(getWearer()) > UD_EdgingThreshold*0.95
				pauseVibFor(10.0)
				Utility.wait(0.25)
			endwhile
			if WearerIsPlayer()
				debug.notification(getDeviceName() + " has come back to life, arousing you once again")
			endif
		endif
	elseif _currentEdgingMode == 2
		if Utility.randomInt() > 95
			if WearerIsPlayer()
				debug.notification(getDeviceName() + " suddenly stops vibrating!")
			endif
			if UD_Shocking
				ShockWearer(25,10)
			endif
			pauseVibFor(Utility.randomFloat(25.0,35.0))
			if WearerIsPlayer()
				debug.notification(getDeviceName() + " has come back to life, arousing you once again")
			endif
		endif
	endif
/;
	if isVibrating() && !_paused
		if _currentEdgingMode == 1
			if UDCDmain.UDOM.getOrgasmProgressPerc(getWearer()) > UD_EdgingThreshold
				if WearerIsPlayer()
					UDCDmain.Print(getDeviceName() + " suddenly stops vibrating!",3)
				endif
				while UDCDmain.UDOM.getOrgasmProgressPerc(getWearer()) > UD_EdgingThreshold*0.95
					pauseVibFor(10)
					Utility.wait(0.25)
				endwhile
				if WearerIsPlayer() && isVibrating()
					UDCDmain.Print(getDeviceName() + " has come back to life, arousing you once again",3)
				endif
			endif
		elseif _currentEdgingMode == 2
			if UDCDmain.UDOM.getOrgasmProgressPerc(getWearer()) > UD_EdgingThreshold
				if Utility.randomInt() < iRange(_currentVibStrength,40,80)
					if WearerIsPlayer()
						UDCDmain.Print(getDeviceName() + " suddenly stops vibrating!",3)
					endif
					pauseVibFor(Utility.randomInt(30,60))
					if WearerIsPlayer() && isVibrating()
						UDCDmain.Print(getDeviceName() + " has come back to life, arousing you once again",3)
					endif
				endif
			endif
		endif
	endif
EndFunction

Function onRemoveDevicePre(Actor akActor)
	stopVibrating()
	parent.onRemoveDevicePre(akActor)
EndFunction

;vibrator can't be currently vibrating, needs to be able to vibrate AND at least 25% of the cooldown have to pass 
bool Function canBeActivated()
	if !isVibrating() && (canVibrate() || UD_Shocking )&& getRelativeElapsedCooldownTime() >= 0.25
		return true
	else
		return false
	endif
EndFunction

;OVERRIDE

Function OnVibrationStart()

EndFunction

Function OnVibrationEnd()

EndFunction

