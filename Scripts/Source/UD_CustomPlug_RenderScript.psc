Scriptname UD_CustomPlug_RenderScript extends UD_CustomVibratorBase_RenderScript  

;float Property UD_PlugAccesibility = 1.0 auto ;do not change

Function InitPost()
	parent.InitPost()
	UD_DeviceType = "Plug"
EndFunction

Function safeCheck()
	if !UD_MessageDeviceInteraction
		UD_MessageDeviceInteraction = UDCDmain.DefaultInteractionPlugMessage
	endif
	if !UD_MessageDeviceInteractionWH
		UD_MessageDeviceInteractionWH = UDCDmain.DefaultInteractionPlugMessageWH
	endif
	parent.safeCheck()
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchPlug(self)
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
	parent.onDeviceMenuInitPost(aControlFilter)
	;UDCDmain.currentDeviceMenu_allowcutting = false
	if canBeStruggled()
		UDCDmain.currentDeviceMenu_allowstruggling = True
	else
		UDCDMain.disableStruggleCondVar(false)
	endif
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
	parent.onDeviceMenuInitPostWH(aControlFilter)
	;UDCDmain.currentDeviceMenu_allowcutting = false
	if canBeStruggled()
		UDCDmain.currentDeviceMenu_allowstruggling = True
	else
		UDCDMain.disableStruggleCondVar(false)
	endif
EndFunction

bool Function struggleMinigame(int type = -1)
	if isSentient() || !WearerFreeHands(True)
		forceOutPlugMinigame()
	else
		unlockRestrain()
		if WearerIsPlayer()
			debug.notification("You succefully forced out " + deviceInventory.getName())
		elseif WearerIsFollower()
			debug.notification(getWearerName() + "s "+ getDeviceName() +" got removed!")
		endif
	endif
	return true
EndFunction

bool Function struggleMinigameWH(Actor akSource)
	if isSentient() || !WearerFreeHands(True)
		forceOutPlugMinigameWH(akSource)
	else
		unlockRestrain()
		if WearerIsPlayer()
			debug.notification("With help of "+ getHelperName() +", you succefully forced out " + deviceInventory.getName() + " !")
		elseif WearerIsFollower()
			debug.notification(getWearerName() + "s "+ getDeviceName() +" got removed!")
		endif
	endif
	return true
EndFunction

string Function addInfoString(string str = "")
	return parent.addInfoString(str)
EndFunction

float Function getAccesibility()
	float loc_res = 1.0;parent.getAccesibility()
	
	if getWearer().wornhaskeyword(libs.zad_DeviousHeavyBondage)
		loc_res *= 0.25
	elseif getWearer().wornhaskeyword(libs.zad_DeviousBondageMittens)
		loc_res *= 0.5
	endif
	
	if getWearer().wornhaskeyword(libs.zad_DeviousHobbleSkirt)
		loc_res *= 0.7
	elseif getWearer().wornhaskeyword(libs.zad_DeviousHobbleSkirtRelaxed)
		loc_res *= 0.8
	elseif getWearer().wornhaskeyword(libs.zad_DeviousSuit)
		loc_res *= 0.9
	endif
	
	if UDCDmain.ActorBelted(getWearer()) > 0 ;belted
		if UDCDmain.ActorBelted(getWearer()) == 1 ;all holes belted
			loc_res = 0.0
		elseif (UDCDmain.ActorBelted(getWearer()) == 2 && getPlugType() == 0) ;anal hole not belted but plug is vaginal
			loc_res = 0.0
		endif
	endif
	
	return fRange(loc_res,0.0,1.0)
EndFunction

Function updateDifficulty()
	parent.updateDifficulty()
EndFunction


;returns plug type
;0 -> Vaginal plug
;1 -> Anal plug
;2 -> Multi plug (Vaginal + Anal)
int Function getPlugType()
	if deviceRendered.haskeyword(libs.zad_DeviousPlugAnal) && deviceRendered.haskeyword(libs.zad_DeviousPlugVaginal)
		return 2
	endif
	If UD_DeviceKeyword == libs.zad_DeviousPlugAnal
		return 1
	Else	
		return 0
	EndIf
EndFunction

int Function getArousalRate()
	return parent.getArousalRate() + 10
EndFunction

bool forceOutPlugMinigame_on = false
Function forceOutPlugMinigame()
	resetMinigameValues()
	
	setMinigameOffensiveVar(False,0.0,0.0,True)
	setMinigameWearerVar(True,UD_base_stat_drain)
	setMinigameEffectVar(True,True,1.25)
	setMinigameWidgetVar(True)
	setMinigameMinStats(0.8)
	setMinigameDmgMult(getAccesibility())
	
	forceOutPlugMinigame_on = True
	minigame()
	forceOutPlugMinigame_on = False
EndFunction

Function forceOutPlugMinigameWH(Actor akHelper)
	resetMinigameValues()
	
	setHelper(akHelper)
	setMinigameOffensiveVar(False,0.0,0.0,True)
	setMinigameDmgMult(getAccesibility()*2.0)
	setMinigameWearerVar(True,UD_base_stat_drain)
	setMinigameHelperVar(True,UD_base_stat_drain*0.25)
	setMinigameEffectVar(True,True,1.25)
	setMinigameEffectHelperVar(False,False)
	setMinigameWidgetVar(True)
	setMinigameMinStats(0.8)
	
	forceOutPlugMinigame_on = True
	minigame()
	forceOutPlugMinigame_on = False
	
	setHelper(none)
EndFunction

Function updateWidget(bool force = false)
	if forceOutPlugMinigame_on
		setWidgetVal(getRelativeDurability(),force)	
	else
		parent.updateWidget(force)
	endif
EndFunction

Function onSpecialButtonPressed()
	if forceOutPlugMinigame_on
		decreaseDurabilityAndCheckUnlock(getDurabilityDmgMod()*0.3,0.0)
	else
		parent.onSpecialButtonPressed()
	endif
EndFunction

;/
bool Function OnCritDevicePre()
	if forceOutPlugMinigame_on
		decreaseDurabilityAndCheck(getDurabilityDmgMod()*UD_PlugAccesibility*UD_StruggleCritMul,0.0)
		return True
	else
		return parent.OnCritDevicePre()
	endif
EndFunction
/;

Function OnCritDevicePost()
	if forceOutPlugMinigame_on
		decreaseDurabilityAndCheckUnlock(getDurabilityDmgMod()*UD_StruggleCritMul,0.0)
	else
		parent.OnCritDevicePost()
	endif
EndFunction

bool Function Details_CanShowResist()
	return false
EndFunction 

bool Function Details_CanShowHitResist()
	return false
EndFunction 

;OVERRIDES because of engine bug which calls one function multiple times
bool Function proccesSpecialMenu(int msgChoice)
	return parent.proccesSpecialMenu(msgChoice)
EndFunction
bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	return parent.proccesSpecialMenuWH(akSource,msgChoice)
EndFunction