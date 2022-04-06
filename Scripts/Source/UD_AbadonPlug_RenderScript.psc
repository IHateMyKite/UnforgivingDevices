Scriptname UD_AbadonPlug_RenderScript extends UD_CustomPlug_RenderScript  

Quest Property AbadonQuest auto
UD_AbadonQuest_script AbadonQuestScript


;const values
float diffuptimehours = 4.0 ;hours
float difficultygain = 0.0
float diff_gain_orgasm = 3.0
float diff_gain_edge = 1.0

;variables
float abadonPlugDiff = 0.0

float last_time_little_finisher_time = 1.0

;mutex checks
bool finisherOn = false

float total_strenght = 0.0
int orgasm_cout = 0

;Actor Property Player auto
bool max_diff_finisher = False

float nextDeviceManifest = 0.0
float plug_hunger = 0.0

float Function relativeStrength()
	return abadonPlugDiff/AbadonQuestScript.max_difficulty
EndFunction

Function InitPost()
	parent.InitPost()
	nextDeviceManifest = Utility.GetCurrentGameTime() + 3.0/24.0 ;1 hour from equip
	AbadonQuestScript = AbadonQuest as UD_AbadonQuest_script
	UD_ActiveEffectName = "Plug-Abadon"
	UD_DeviceType = "Abadon Plug"
	
	updateVibrationParam()
	
	if AbadonQuestScript.final_finisher_set
		AbadonQuestScript.AbadonEquipSuit(getWearer(),AbadonQuestScript.final_finisher_pref)
		if WearerIsPlayer()
			UDCDmain.Print("Abadon plug has locked you in various bondage items to prevent you from removing it")
		endif
	endif
	if ((AbadonQuest).GetCurrentStageID() == 0) && WearerIsPlayer()
		(AbadonQuest).setStage(20)
		(AbadonQuest).SetObjectiveDisplayed(30)
	endif
EndFunction

Function onRemoveDevicePost(Actor akActor)
	if (AbadonQuest.GetCurrentStageID() > 0) && !AbadonQuest.isCompleted() && getWearer() == AbadonQuestScript.UD_AbadonVictim
		if (AbadonQuest.GetCurrentStageID() == 20)
			AbadonQuest.SetObjectiveCompleted(30)
		elseif (AbadonQuest.GetCurrentStageID() == 30)
			AbadonQuest.SetObjectiveCompleted(40)
		endif
		AbadonQuest.completeQuest()
	endif
	if AbadonQuestScript.final_finisher_set
		AbadonQuestScript.AbadonEquipSuit(getWearer(),AbadonQuestScript.final_finisher_pref)
	endif
EndFunction

Function forceOutPlugMinigame()
	forceOutAbadonPlugMinigame()
EndFunction

Function forceOutPlugMinigameWH(Actor akHelper)
	forceOutAbadonPlugMinigameWH(akHelper)
EndFunction

bool _forceOutAbadonPlugMinigame_on = false
Function forceOutAbadonPlugMinigame()
	resetMinigameValues()
	
	setMinigameOffensiveVar(False,0.0,0.0,True)
	setMinigameWearerVar(True,UD_base_stat_drain)
	setMinigameEffectVar(True,True,1.25)
	setMinigameWidgetVar(True)
	setMinigameMinStats(0.8)
	
	_forceOutAbadonPlugMinigame_on = True
	minigame()
	_forceOutAbadonPlugMinigame_on = False
EndFunction

Function forceOutAbadonPlugMinigameWH(Actor akHelper)
	resetMinigameValues()
	
	setHelper(akHelper)
	setMinigameOffensiveVar(False,0.0,0.0,True)
	setMinigameDmgMult(1.5)
	setMinigameWearerVar(True,UD_base_stat_drain)
	setMinigameHelperVar(True,UD_base_stat_drain*0.25)
	setMinigameEffectVar(True,True,1.25)
	setMinigameEffectHelperVar(False,False)
	setMinigameWidgetVar(True)
	setMinigameMinStats(0.8)
	
	_forceOutAbadonPlugMinigame_on = True
	minigame()
	_forceOutAbadonPlugMinigame_on = False
	
	setHelper(none)
EndFunction


Float Function getButtonPressDamage()
	int loc_difficulty = AbadonQuestScript.overaldifficulty
	if loc_difficulty == 0
		return 0.4
	elseif loc_difficulty == 1
		return 0.25
	elseif loc_difficulty == 2
		return 0.05
	endif
EndFunction

Function onSpecialButtonPressed()
	if _forceOutAbadonPlugMinigame_on
		decreaseDurabilityAndCheckUnlock(getButtonPressDamage()*getAccesibility(),0.0)
	else
		parent.onSpecialButtonPressed()
	endif
EndFunction

Function addStrength(float val)
	if val > 0.0
		abadonPlugDiff += val
		total_strenght += val
		if abadonPlugDiff > AbadonQuestScript.max_difficulty
			abadonPlugDiff = AbadonQuestScript.max_difficulty
		endif
	endif
EndFunction

float Function getTotalStrenght()
	return total_strenght
EndFunction

float Function getRelativeHunger()
	return (1.0 - plug_hunger/100.0)
EndFunction

Function Vibrate(float mult = 1.0)
	if !isVibrating()
		updateVibrationParam()
		parent.vibrate(mult)
		plug_hunger += 5
		if plug_hunger > 100.0
			plug_hunger = 100.0
		endif
		if plug_hunger < 0
			plug_hunger = 0.0
		endif
	endif
EndFunction

Function OnMinigameEnd()
	BeltCheck()
	parent.OnMinigameEnd()
EndFunction

Function randomEquipHandRestrain()
	if (!getWearer().WornhasKeyword(libs.zad_DeviousHeavyBondage))
		Armor device = none
		bool res = False
		
		bool loc_haveSuit = WearerHaveSuit()
		Formlist loc_formlist = none
		
		if relativeStrength() < 0.4
			loc_formlist = UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageWeak
		elseif relativeStrength() < 0.8
			loc_formlist = UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondage
		else
			loc_formlist = UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageHard
		endif
		
		if loc_haveSuit
			Keyword[] loc_filter = new keyword[1]
			loc_filter[0] = libs.zad_deviousStraitjacket
			device = UDmain.UDRRM.getRandomFormFromFormlistFilter(loc_formlist,loc_filter,2) as Armor
		else
			device = UDmain.UDRRM.getRandomFormFromFormlist(loc_formlist) as Armor
		endif
		
		UDCDMain.LockDeviceParalel(getWearer(),device)
		nextDeviceManifest = Utility.GetCurrentGameTime() + 3.5/24.0
		Armor loc_renderDevice = UDCDmain.GetRenderDevice(device)
		if WearerIsPlayer()
			if loc_renderDevice.hasKeyword(libs.zad_DeviousArmbinder)
				UDCDmain.showMessageBox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke forces your hands helplessly behind your back and manifests into armbinder.")
			elseif loc_renderDevice.hasKeyword(libs.zad_DeviousStraitjacket)
				debug.messagebox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke forces your hands forcefully together and manifests into straitjacket.")
			elseif loc_renderDevice.hasKeyword(libs.zad_DeviousArmbinderElbow)
				debug.messagebox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke forces your hands painfully behind your back and manifests into elbowbinder.")
			elseif loc_renderDevice.hasKeyword(libs.zad_DeviousYoke)
				debug.messagebox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke forces your hands away from your body and locks them in to cold, steel yoke.")
			endif
		else
			UDCDmain.Print(getDeviceName() + " locks restrain on " + getWearerName())
		endif
	endif
EndFunction

bool Function equipRandomRestrain()
	Armor device = UDmain.UDRRM.getRandomSuitableRestrain(getWearer(),0xFBFB)
	if !device
		return False
	endif
	if WearerIsPlayer()
		debug.messagebox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke manifests in to " + device.getName() + "!")
	elseif WearerIsFollower()
		UDCDmain.Print(getWearerName() + "s Abadon plug manifested " + device.getName())
	endif
	nextDeviceManifest = Utility.GetCurrentGameTime() + 3.5/24.0
	UDCDmain.LockDeviceParalel(GetWearer(), device ,True)
	return True
EndFunction

float Function handRestrainChance()
	return (AbadonQuestScript.handrestrain_chance + AbadonQuestScript.handrestrain_chance*relativeStrength())*(0.5*(AbadonQuestScript.overaldifficulty + 1)) ;0.5 - at diff 0 (easy) , 1.5 at diff 2 (hard)
	;return 100
EndFunction

bool msg1 = false
bool msg2 = false
bool msg3 = false
Function abadonorgasm(float mult = 1.0)
	addStrength(diff_gain_orgasm*mult*(0.5*(1 + AbadonQuestScript.overaldifficulty)))
	orgasm_cout += 1
	plug_hunger += 7.5*mult ;reduce plug hunger
	if plug_hunger > 100
		plug_hunger = 100.0
	endif
	if (AbadonQuestScript.dmg_heal)
		float hp_dmg = (AbadonQuestScript.overaldifficulty+1)*5 + Math.floor(orgasm_cout/5.0)*(AbadonQuestScript.overaldifficulty+1)
		if (getWearer().getAV("Health") > (1.0 + hp_dmg) || AbadonQuestScript.hardcore )
			getWearer().DamageAV("Health", hp_dmg)
		endif
	endif
	if (AbadonQuestScript.dmg_magica)
		getWearer().DamageAV("Magicka", (AbadonQuestScript.overaldifficulty+1)*5 + relativeStrength()*20)
	endif
	if (AbadonQuestScript.dmg_stamina)
		getWearer().DamageAV("Stamina", (AbadonQuestScript.overaldifficulty+1)*5 + relativeStrength()*20)
	endif
	
	if nextDeviceManifest < Utility.GetCurrentGameTime()
		if Utility.randomInt() <=  Math.floor(handRestrainChance())
			equipRandomRestrain()
		endif
	endif
	
	if orgasm_cout % 2 && getRelativeDurability() < 1.0
		if WearerIsPlayer()
			UDCDmain.Print("You feel that your orgasm is making Abadon Plug to regain it strength!")
		endif
		mendDevice(1.0,1.0/24.0,True)
	endif
	
	
	if finisherOn
		finisher_current_orgasms += 1
		if WearerIsPlayer()
			if(finisher_current_orgasms > 3 && !msg1)
				UDCDmain.Print("Plugs within you are making you orgasm nonstop!")
				msg1 = true
			elseif (finisher_current_orgasms > 6 && !msg2)
				UDCDmain.Print("Constants orgasms barely let you catch a breath!")
				msg2 = true
			elseif (finisher_current_orgasms > 10 && !msg3)
				UDCDmain.Print("You feel your mind breaking with every new orgasm")
				msg3 = true
			endif
		endif
		if finisher_current_orgasms >= finisher_goal_orgasms
			stopVibrating()
			finisherOn = false
		endif
	endif
EndFunction

Function OnOrgasmPost(bool sexlab = false)
	parent.OnOrgasmPost(sexlab)
	if sexlab
		abadonorgasm(1.1)
		plug_hunger += 10*(3 - AbadonQuestScript.overaldifficulty)
		if plug_hunger > 100
			plug_hunger = 100.0
		endif
		decreaseDurabilityAndCheckUnlock(15.0)
		if Utility.randomInt() > 60
			if WearerIsPlayer()
				UDCDmain.Print("You feel black goo dropping from your pussy!")
			endif
			getWearer().addItem(UDlibs.BlackGoo,3)
		endif
	else
		abadonorgasm()
	endif
EndFunction

Function OnEdgePost()
	parent.OnEdgePost()
	addStrength(diff_gain_edge*(0.5*(1 + AbadonQuestScript.overaldifficulty)))
	plug_hunger -= 3.0 ;decrease plugs hunger
	if (plug_hunger < 0.0)
		plug_hunger = 0.0
	endif 
	if (AbadonQuestScript.dmg_heal)
		float hp_dmg = (AbadonQuestScript.overaldifficulty+1)*2.5 + Math.floor(orgasm_cout/5.0)*(AbadonQuestScript.overaldifficulty+1)
		if (getWearer().getAV("Health") > (1.0 + hp_dmg) || AbadonQuestScript.hardcore )
			getWearer().DamageAV("Health", hp_dmg)
		else
			getWearer().ForceActorValue("Health", 5.0)
		endif
	endif
	if (AbadonQuestScript.dmg_magica)
		getWearer().DamageAV("Magicka", (AbadonQuestScript.overaldifficulty+1)*2.5 + relativeStrength()*15)
	endif
	if (AbadonQuestScript.dmg_stamina)
		getWearer().DamageAV("Stamina", (AbadonQuestScript.overaldifficulty+1)*2.5 + relativeStrength()*15)
	endif
EndFunction

int Function getOrgasmCout()
	return orgasm_cout
EndFunction

Function onUpdatePre(float timePassed)
	setModifierIntParam("LootGold",10 +  Math.floor(20.0*getTotalStrenght()*(0.5*(1 + AbadonQuestScript.overaldifficulty))))
EndFunction

;float _littleFinisherUpdateTimePassed = 0.0
Function onUpdatePost(float timePassed)
	updateVibrationParam()
	addStrength(UDCDmain.getArousal(GetWearer())*0.001*(1 + AbadonQuestScript.overaldifficulty)*(24.0*timePassed))
	plug_hunger -= 0.25*timePassed*24*60
	;_littleFinisherUpdateTimePassed += timePassed
	if (plug_hunger < 0.0)
		plug_hunger = 0.0
	endif
	
	;max finisher
	if !finisherOn
		if (abadonPlugDiff >= AbadonQuestScript.max_difficulty && !max_diff_finisher)
			max_diff_finisher = True
			if WearerIsPlayer()
				UDCDmain.Print("Abadon plug have reached its full strenght!")
				
				AbadonQuestScript.SetStage(30)
				AbadonQuestScript.SetObjectiveFailed(30)
				AbadonQuestScript.SetObjectiveDisplayed(40)
				string tmp = "Despite your best effort to remove the plug in time, you ultimately faild. Abadon plug have finaly reached it full strength. It manifested and locked extremly sturdy straitjacket suit on your body that barely alow you to move your arms."
				tmp += "You immidiatly tried to struggle free, but that only maked plugs inside you start vibrating furiously. You pant in pleasure as first of many orgasm that is awayting you starts to build up."
				tmp += "With realization of how bad situation you get yourself in to, you let last scream just before gag manifested over your mouth. Tears run down your cheeks as you uselessly try to resist comming orgasm."
				debug.messagebox(tmp)
			else
				UDCDmain.Print(getWearerName() + " " + getDeviceName() + " have reached its full potential!")
			endif
			UDmain.ItemManager.equipAbadonFinisherSuit(getWearer())
			finisher(getWearer(),AbadonQuestScript.max_orgasm_little_finisher)
		;elseif relativeStrength() > 0.5
		;if _littleFinisherUpdateTimePassed > 3.0
		;		
		;endif
		endif
	endif
	parent.OnUpdatePost(timePassed)
EndFunction

Function updateVibrationParam()
	if !isVibrating()
		if plug_hunger < 30
			UD_Shocking = False
			UD_VibStrength = iRange(UDmain.Round(35 + relativeStrength()*65),35,100)
			UD_VibDuration = iRange(Math.ceiling(30.0 + 80.0*relativeStrength() + 30.0*getRelativeHunger()),30,120)
			UD_EdgingMode  = 0
		elseif plug_hunger < 50
			UD_Shocking = True
			UD_VibStrength = iRange(UDmain.Round(10 + relativeStrength()*50),10,60)
			UD_VibDuration = iRange(Math.ceiling(15.0 + 30.0*relativeStrength() + 15.0*getRelativeHunger()),45,90)
			UD_EdgingMode  = 2
		else
			UD_VibStrength = iRange(UDmain.Round(relativeStrength()*40),0,40)
			UD_Shocking = True
			UD_EdgingMode  = 1
			UD_VibDuration = 60
		endif
		UD_Cooldown = 30 + UDmain.Round(relativeStrength()*100)
	endif
EndFunction

int finisher_current_orgasms = 0
int finisher_goal_orgasms = 0
Function finisher(actor akActor,int orgasms = 5)
	if(!finisherOn);mutex check
		finisherOn = True
		
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log(getWearerName() + " finisher() called for " + orgasms + " orgasms")
		endif
		
		if !max_diff_finisher
			randomEquipHandRestrain()
		endif
		
		;NEW
		msg1 = False
		msg2 = False
		msg3 = False
		finisher_goal_orgasms = orgasms
		finisher_current_orgasms = 0
		
		libs.SexlabMoan(akActor,100)
		
		stopVibratingAndWait()
		
		forceStrength(100)
		forceDuration(-1)
		forceEdgingMode(0)
		UDCDmain.startVibFunction(self)
	EndIf
EndFunction

string Function addInfoString(string str = "")
	str = parent.addInfoString(str)
	str += "(AP) Strenght: " + UDmain.formatString(abadonPlugDiff,1) + " (~"+Math.floor(relativeStrength()*100.0)+" %)" + "\n"
	str += "(AP) Hunger: "+ Math.floor(100.0 - plug_hunger) + " %\n"
	return str
EndFunction

;/
float last_time_masturbate = 0.0
Function masturbate()
	if (Utility.GetCurrentGameTime() - last_time_masturbate) > (AbadonQuestScript.masturbate_cd/24.0)
		Actor[] Positions = new Actor[1]
		Positions[0] = getWearer()
		libs.SexLab.StartSex(Positions, libs.SexLab.GetAnimationsByTag(1, "Solo", "F", true),none,CenterOn = none, AllowBed = true, Hook = "UD") ;it just works
		last_time_masturbate = Utility.GetCurrentGameTime()
	else
		debug.messagebox("You are too weak from last time.\nYou can masturbate again in "+ UDmain.formatString((AbadonQuestScript.masturbate_cd/24.0 - (Utility.GetCurrentGameTime() - last_time_masturbate))*24,1) + " hours")
	endif
EndFunction
/;

float Function getCritDamage()
	int loc_difficulty = AbadonQuestScript.overaldifficulty
	if loc_difficulty == 0
		return 35.0
	elseif loc_difficulty == 1
		return 25.0
	elseif loc_difficulty == 2
		return 15.0
	endif
EndFunction

Function OnCritFailure()
	parent.OnCritFailure()
	float loc_arousal = 10 + UDCDmain.getArousal(GetWearer())
	UDCDmain.UpdateArousalRate(getWearer(),loc_arousal)
	Utility.wait(3.5)
	UDCDmain.UpdateArousalRate(getWearer(),-1*loc_arousal)
	;UDCDmain.sendArousalSetEvent(getWearer(),10 + UDCDmain.getArousal(GetWearer()))
EndFunction

Function OnCritDevicePost()
	if _forceOutAbadonPlugMinigame_on
		decreaseDurabilityAndCheckUnlock(getCritDamage()*getAccesibility(),0.0)
		stopMinigame()
		if !isUnlocked
			BeltCheck()
			if !getWearer().wornhaskeyword(libs.zad_deviousHeavyBondage)
				;if Utility.randomInt() < iRange(Round(relativeStrength()*100),25 + AbadonQuestScript.overaldifficulty*12,75) ;50% - 100% chance of getting tied
					randomEquipHandRestrain()
				;endif
			endif
		endif
	else
		parent.OnCritDevicePost()
	endif
EndFunction

bool belt_used = false
Function OnMinigameTick1()
	BeltCheck()
EndFunction

Function updateWidget(bool force = false)
	if _forceOutAbadonPlugMinigame_on
		setWidgetVal(getRelativeDurability(),force)	
	else
		parent.updateWidget(force)
	endif
EndFunction

Function activateDevice()
	resetCooldown()
	if nextDeviceManifest < Utility.GetCurrentGameTime()
		if equipRandomRestrain()
			if WearerIsPlayer()
				debug.messagebox("Abadon plug suddenly manifests bondage device and locks it on your body!")
			elseif WearerIsFollower()
				UDCDmain.Print(getWearerName() + "s "+ getDeviceName() +" suddenly manifests bondage device!")
			endif
		endif
	else
		parent.activateDevice() ;start vib
	endif
EndFunction

Function updateHour(float mult)

EndFunction

Function BeltCheck()
	if !belt_used && (getDurability() < getMaxDurability()*0.5) && !wearerHaveBelt()
		belt_used = True
		stopMinigame()
		if WearerIsPlayer()
			UDCDmain.Print("Plug have locked you in chastity belt!")
		endif
		libs.lockdevice(getWearer(),UDlibs.AbadonBelt)
	endif
EndFunction

;OVERRIDES because of engine bug which calls one function multiple times
bool Function proccesSpecialMenu(int msgChoice)
	return parent.proccesSpecialMenu(msgChoice)
EndFunction
bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	return parent.proccesSpecialMenuWH(akSource,msgChoice)
EndFunction