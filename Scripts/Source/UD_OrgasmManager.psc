Scriptname UD_OrgasmManager extends Quest conditional

import UnforgivingDevicesMain

UDCustomDeviceMain 					Property UDCDmain 	auto
UnforgivingDevicesMain 				Property UDmain 	auto
UD_libs 							Property UDlibs 	auto
zadlibs 							Property libs 		auto
UD_ExpressionManager 				Property UDEM 		auto
UD_CustomDevices_NPCSlotsManager 	Property UDCD_NPCM auto

float 	Property UD_OrgasmResistence 		= 3.5 	auto ;orgasm rate required for actor to be able to orgasm, lower the value, the faster will orgasm rate increase stop
int 	Property UD_OrgasmArousalThreshold 	= 95 	auto ;arousal required for actor to be able to orgasm
bool 	Property UD_UseOrgasmWidget 		= True 	auto
float 	Property UD_OrgasmUpdateTime 		= 0.2 	auto
int 	Property UD_OrgasmAnimation 		= 1 	auto
int 	Property UD_OrgasmDuration 			= 20 	auto
bool 	Property UD_HornyAnimation 			= true 	auto
int 	Property UD_HornyAnimationDuration 	= 5 	auto

Actor Property UD_StopActorOrgasmCheckLoop 	= none auto
Actor Property UD_StopActorArousalCheckLoop = none auto

Faction Property OrgasmFaction 				auto
Faction Property OrgasmCheckLoopFaction 	auto
Faction Property ArousalCheckLoopFaction 	auto
Faction Property OrgasmResistFaction 		auto

;used for validating loop on update
;current loop version, changing this to different number will reset the loops with lower versions
Int Property UD_OrgasmCheckLoop_ver 	=  3 	autoreadonly
int Property UD_ArousalCheckLoop_ver 	=  3 	autoreadonly

bool 	_crit 					= false
bool 	_specialButtonOn 		= false
string 	_crit_meter				= "Error"


;DOCUMANTATION - StorageUtil interfaces
;/
	Orgasm rate 			- Key="UD_OrgasmRate"				, Type=Float	, def_value=	  0.0
	Orgasm forcing 			- Key="UD_OrgasmForcing"			, Type=Float	, def_value=	  0.0
	Orgasm Rate Multiplier 	- Key="UD_OrgasmRateMultiplier"		, Type=Float	, def_value=	  1.0
	Orgasm progress 		- Key="UD_OrgasmProgress"			, Type=Float	, def_value=	  0.0
	Orgasm capacity 		- Key="UD_OrgasmCapacity"			, Type=Float	, def_value=	100.0
	Orgasm resistance 		- Key="UD_OrgasmResist"				, Type=Float	, def_value=	MCM setting (def. 3.5)
	Orgasm resistance mult.	- Key="UD_OrgasmResistMultiplier"	, Type=Float	, def_value=	  1.0
/;


bool Property Ready auto conditional
Event OnInit()
	RegisterModEvents()
	Ready = true
EndEvent

Function RegisterModEvents()
	RegisterForModEvent("UD_OrgasmCheckLoop","OrgasmCheckLoop")
	RegisterForModEvent("UD_ArousalCheckLoop","ArousalCheckLoop")
	RegisterForModEvent("UD_Orgasm","Orgasm")
	RegisterForModEvent("UD_CritUpdateLoopStart_OrgasmResist","CritLoopOrgasmResist")
	RegisterForModEvent("DeviceActorOrgasm", "OnOrgasm")
	RegisterForModEvent("DeviceEdgedActor", "OnEdge")
	RegisterForModEvent("HookOrgasmStart", "OnSexlabOrgasmStart")
	RegisterForModEvent("SexLabOrgasmSeparate", "OnSexlabSepOrgasmStart")
EndFunction

;used for update, transfers loop from UD_CustomDeviceMain in to this script
;this is only valid for player, all NPCS need to be reregistered
Function Update()
	UnregisterForAllModEvents()
	RegisterModEvents()
EndFunction

Function CheckOrgasmCheck(Actor akActor)
	if !akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW)
		GInfo("Starting again Orgasm check loop for " + getActorName(akActor))
		StartOrgasmCheckLoop(akActor)
	endif
	if !akActor.hasSpell(UDlibs.OrgasmCheckAbilitySpell) && akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW)
		GInfo("Updating Orgasm check loop for " + getActorName(akActor))
		akActor.DispelSpell(UDlibs.OrgasmCheckSpell)
		StartOrgasmCheckLoop(akActor)
	endif
EndFunction

Function CheckArousalCheck(Actor akActor)
	if !akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW)
		GInfo("Starting again Arousal check loop for " + getActorName(akActor))
		StartArousalCheckLoop(akActor)
	endif
	if !akActor.hasSpell(UDlibs.ArousalCheckAbilitySpell) && akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW)
		GInfo("Updating Arousal check loop for " + getActorName(akActor))
		akActor.DispelSpell(UDlibs.ArousalCheckSpell)
		StartArousalCheckLoop(akActor)
	endif
EndFunction

Int Function UpdateArousal(Actor akActor ,float arousal)
	libs.UpdateExposure(akActor, arousal, true)
	return GetActorArousal(akActor)
EndFunction

Int Function getArousal(Actor akActor)
	if akActor.isInFaction(ArousalCheckLoopFaction)
		return akActor.GetFactionRank(ArousalCheckLoopFaction)
	else
		return getActorArousal(akActor)
	endif
EndFunction

bool _ArousalRateManip_Mutex = false
Float Function UpdateArousalRate(Actor akActor ,float fArousalRate)
	while _ArousalRateManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_ArousalRateManip_Mutex = true
	float loc_newArousalRate = StorageUtil.getFloatValue(akActor, "UD_ArousalRate",0.0) + fArousalRate
	StorageUtil.setFloatValue(akActor, "UD_ArousalRate",loc_newArousalRate)
	_ArousalRateManip_Mutex = false
	return loc_newArousalRate
EndFunction

Float Function getArousalRate(Actor akActor)
	return StorageUtil.getFloatValue(akActor, "UD_ArousalRate",0.0)
EndFunction

Float Function getArousalRateM(Actor akActor)
	return getArousalRate(akActor)*getArousalRateMultiplier(akActor)
EndFunction

bool _ArousalRateMultManip_Mutex = false
Float Function UpdateArousalRateMultiplier(Actor akActor ,float fArousalRateM)
	while _ArousalRateMultManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_ArousalRateMultManip_Mutex = true
	float loc_newArousalRateM = StorageUtil.getFloatValue(akActor, "UD_ArousalRateM",1.0) + fArousalRateM
	StorageUtil.setFloatValue(akActor, "UD_ArousalRateM",loc_newArousalRateM)
	_ArousalRateMultManip_Mutex = false
	return loc_newArousalRateM
EndFunction

Float Function getArousalRateMultiplier(Actor akActor)
	return fRange(StorageUtil.getFloatValue(akActor, "UD_ArousalRateM",1.0),0.0,100.0)
EndFunction

Function StartArousalCheckLoop(Actor akActor)
	if !akActor
		Error("None passed to StartArousalCheckLoop!!!")
	endif
	
	if TraceAllowed()	
		Log("StartArousalCheckLoop("+getActorName(akActor)+") called")
	endif
	
	if akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW)
		return
	endif
	
	akActor.AddSpell(UDlibs.ArousalCheckAbilitySpell,false)
	;UDlibs.ArousalCheckSpell.cast(akActor)
EndFunction

bool Function ArousalLoopBreak(Actor akActor,Int iVersion)
	bool loc_cond = false
	loc_cond = loc_cond || !UDCDMain.isRegistered(akActor)
	;loc_cond = loc_cond || (UD_StopActorArousalCheckLoop == akActor)
	;loc_cond = loc_cond || akActor.isDead()
	;loc_cond = loc_cond || (iVersion < UD_ArousalCheckLoop_ver)
	return loc_cond
EndFunction

int Function getActorArousal(Actor akActor)
	return libs.Aroused.GetActorExposure(akActor)
EndFunction
;=======================================
;		  		ORGASM RATE
;=======================================
bool _OrgasmRateManip_Mutex = false
float Function UpdateOrgasmRate(Actor akActor ,float orgasmRate,float orgasmForcing)
	while _OrgasmRateManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmRateManip_Mutex = true
	float loc_newOrgasmRate = StorageUtil.getFloatValue(akActor, "UD_OrgasmRate",0.0) + orgasmRate
	StorageUtil.setFloatValue(akActor, "UD_OrgasmRate",loc_newOrgasmRate)
	StorageUtil.setFloatValue(akActor, "UD_OrgasmForcing",StorageUtil.getFloatValue(akActor, "UD_OrgasmForcing",0.0) + orgasmForcing)	
	_OrgasmRateManip_Mutex = false
	return orgasmRate
EndFunction
Function removeOrgasmRate(Actor akActor ,float orgasmRate,float orgasmForcing)
	while _OrgasmRateManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmRateManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmRate",StorageUtil.getFloatValue(akActor, "UD_OrgasmRate",0.0) - orgasmRate)
	StorageUtil.setFloatValue(akActor, "UD_OrgasmForcing",StorageUtil.getFloatValue(akActor, "UD_OrgasmForcing",0.0) - orgasmForcing)
	_OrgasmRateManip_Mutex = false
EndFunction
float Function getActorOrgasmRate(Actor akActor)
	return fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmRate",0.0),0.0,1000.0)
EndFunction
float Function getActorAfterMultOrgasmRate(Actor akActor)
	return getActorOrgasmRate(akActor)*getActorOrgasmRateMultiplier(akActor)
EndFunction
float Function getActorAfterMultAntiOrgasmRate(Actor akActor)
	return CulculateAntiOrgasmRateMultiplier(getArousal(akActor))*getActorOrgasmResistMultiplier(akActor)*(getActorOrgasmResist(akActor))
EndFunction


float Function getActorOrgasmForcing(Actor akActor)
	return fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmForcing",0.0),0.0,1.0)
EndFunction

;=======================================
;		  ORGASM RATE MULTIPLIER
;=======================================
bool _OrgasmRateMultManip_Mutex = false
Function UpdateOrgasmRateMultiplier(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmRateMultManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmRateMultManip_Mutex = true
	float loc_newOrgasmRateMult = StorageUtil.getFloatValue(akActor, "UD_OrgasmRateMultiplier",1.0) + orgasmRateMultiplier
	StorageUtil.setFloatValue(akActor, "UD_OrgasmRateMultiplier",loc_newOrgasmRateMult)
	_OrgasmRateMultManip_Mutex = false
EndFunction

Function removeOrgasmRateMultiplier(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmRateMultManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmRateMultManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmRateMultiplier",StorageUtil.getFloatValue(akActor, "UD_OrgasmRateMultiplier",1.0) - orgasmRateMultiplier)
	_OrgasmRateMultManip_Mutex = false
EndFunction
float Function getActorOrgasmRateMultiplier(Actor akActor) ;!!UNSED!!
	return fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmRateMultiplier",1.0),0.0,10.0)
EndFunction

;=======================================
;	   	   ORGASM RESISTENCE
;=======================================
bool _OrgasmResistManip_Mutex = false
Function UpdateOrgasmResist(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmResistManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmResistManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmResist",fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmResist",UD_OrgasmResistence) + orgasmRateMultiplier,0.0,100.0))
	_OrgasmResistManip_Mutex = false
EndFunction
Function setActorOrgasmResist(Actor akActor,float fValue)
	while _OrgasmResistManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmResistManip_Mutex = true
	StorageUtil.SetFloatValue(akActor, "UD_OrgasmResist",fRange(fValue,0.0,100.0))
	_OrgasmResistManip_Mutex = false
EndFunction
float Function getActorOrgasmResist(Actor akActor)
	return fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmResist",UD_OrgasmResistence),0.0,1000.0)
EndFunction
float Function getActorOrgasmResistM(Actor akActor)
	return getActorOrgasmResist(akActor)*getActorOrgasmResistMultiplier(akActor)
EndFunction
;=======================================
;	   ORGASM RESISTENCE MULTIPLIER
;=======================================
bool _OrgasmResistMultManip_Mutex = false
Function UpdateOrgasmResistMultiplier(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmResistMultManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmResistMultManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmResistMultiplier",StorageUtil.getFloatValue(akActor, "UD_OrgasmResistMultiplier",1.0) + orgasmRateMultiplier)
	_OrgasmResistMultManip_Mutex = false
EndFunction
Function removeOrgasmResistMultiplier(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmResistMultManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmResistMultManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmResistMultiplier",StorageUtil.getFloatValue(akActor, "UD_OrgasmResistMultiplier",1.0) - orgasmRateMultiplier)
	_OrgasmResistMultManip_Mutex = false
EndFunction
float Function getActorOrgasmResistMultiplier(Actor akActor)
	return fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmResistMultiplier",1.0),0,10.0)
EndFunction

;=======================================
;		 	 ORGASM PROGRESS
;=======================================
bool _OrgasmProgressManip_Mutex
Function SetActorOrgasmProgress(Actor akActor,Float fValue)
	while _OrgasmProgressManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmProgressManip_Mutex = true
	StorageUtil.SetFloatValue(akActor, "UD_OrgasmProgress",fRange(fValue,0.0,getActorOrgasmCapacity(akActor)))
	_OrgasmProgressManip_Mutex = false
EndFunction
Function UpdateActorOrgasmProgress(Actor akActor,Float fValue,bool bUpdateWidget = false)
	while _OrgasmProgressManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmProgressManip_Mutex = true
	float loc_newValue = fRange(StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0) + fValue,0.0,getActorOrgasmCapacity(akActor))
	StorageUtil.SetFloatValue(akActor, "UD_OrgasmProgress",loc_newValue)
	if bUpdateWidget && UD_UseOrgasmWidget
		UDCDmain.widget2.SetPercent(loc_newValue/getActorOrgasmCapacity(akActor))
	endif
	_OrgasmProgressManip_Mutex = false
EndFunction
Function ResetActorOrgasmProgress(Actor akActor)
	StorageUtil.UnSetFloatValue(akActor, "UD_OrgasmProgress")
EndFunction
float Function getActorOrgasmProgress(Actor akActor)
	return StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0)
EndFunction
float Function getOrgasmProgressPerc(Actor akActor)
	return StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0)/getActorOrgasmCapacity(akActor)
EndFunction


;=======================================
;ORGASM CAPACITY
;=======================================

float Function getActorOrgasmCapacity(Actor akActor)
	return StorageUtil.GetFloatValue(akActor, "UD_OrgasmCapacity",100.0)
EndFunction

bool _OrgasmCapacity_Mutex
Function UpdatetActorOrgasmCapacity(Actor akActor,float fValue)
	while _OrgasmCapacity_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmCapacity_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmCapacity",fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmCapacity",100.0) + fValue,10.0,500.0))
	_OrgasmCapacity_Mutex = false
EndFunction

Function SetActorOrgasmCapacity(Actor akActor,float fValue)
	while _OrgasmCapacity_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmCapacity_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmCapacity",fRange(fValue,10.0,500.0))
	_OrgasmCapacity_Mutex = false
EndFunction

;=======================================
;ORGASM UTILITY CALCULATIONS
;=======================================

;return true if actor can orgasm at 100 arousal
bool Function ActorCanOrgasm(Actor akActor)
	return (getActorOrgasmRate(akActor)*getActorOrgasmRateMultiplier(akActor) > CulculateAntiOrgasmRateMultiplier(100)*UD_OrgasmResistence*getActorOrgasmResistMultiplier(akActor))
EndFunction

;return true if actor can orgasm at 50 arousal, because its not linear, orgasm rate would need to be gigantic 
bool Function ActorCanOrgasmHalf(Actor akActor)
	return (getActorOrgasmRate(akActor)*getActorOrgasmRateMultiplier(akActor) > CulculateAntiOrgasmRateMultiplier(50)*UD_OrgasmResistence*getActorOrgasmResistMultiplier(akActor))
EndFunction

bool Function ActorHaveExpressionApplied(Actor akActor)
	return StorageUtil.GetIntValue(akActor,"zad_expressionApplied",0)
EndFunction

float Function CulculateAntiOrgasmRateMultiplier(int iArousal)
	return fRange((Math.pow(10,fRange(100.0/iRange(iArousal,1,100),1.0,2.0) - 1.0)),1.0,100.0)
EndFunction

;///////////////////////////////////////
;=======================================
;ORGASM MAIN LOOP
;=======================================
;//////////////////////////////////////;

Function StartOrgasmCheckLoop(Actor akActor)
	if TraceAllowed()	
		Log("StartOrgasmCheckLoop("+getActorName(akActor)+") called")
	endif
	if !akActor
		Error("None passed to sendOrgasmCheckLoop!!!")
	endif
	if akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW)
		return
	endif
	
	;UDlibs.OrgasmCheckSpell.cast(akActor)
	akActor.AddSpell(UDlibs.OrgasmCheckAbilitySpell,false)
EndFunction

bool Function OrgasmLoopBreak(Actor akActor, int iVersion)
	bool loc_cond = false
	;loc_cond = loc_cond || (UD_StopActorOrgasmCheckLoop == akActor)
	loc_cond = loc_cond || !UDCDmain.isRegistered(akActor)
	;loc_cond = loc_cond || akActor.isDead()
	;loc_cond = loc_cond || (iVersion < UD_OrgasmCheckLoop_ver) || UD_OrgasmCheckLoop_ver < 0
	return loc_cond
EndFunction

;=======================================
;=======================================
;ORGASM
;=======================================

Function startOrgasm(Actor akActor,int duration,int iArousalDecrease = 75,int iForce = 0, bool blocking = true)
	if TraceAllowed()	
		Log("startOrgasm() for " + getActorName(akActor) + ", duration = " + duration + ",blocking = " + blocking,1)
	endif
	int loc_orgasms = 0
	if blocking
		loc_orgasms = getOrgasmingCount(akActor)
	endif
	int handle = ModEvent.Create("UD_Orgasm")
	if (handle)
		ModEvent.PushForm(handle, akActor)
		ModEvent.PushInt(handle, duration)
		ModEvent.PushInt(handle, iArousalDecrease)
		ModEvent.PushInt(handle, iForce)
        ModEvent.Send(handle)
		
		;check for orgasm start
		if blocking
			float loc_time = 0.0
			while (getOrgasmingCount(akActor) == loc_orgasms) && loc_time <= 3.0
				Utility.waitMenuMode(0.05)
				loc_time += 0.05
			endwhile
			
			if loc_time >= 3.0
				Error("startOrgasm("+getActorName(akActor)+") timeout!")
			endif
		endif
    endIf	
EndFunction

;will rework later
Function Orgasm(Form fActor,int duration,int iArousalDecrease,int iForce)
	Actor akActor = fActor as Actor
	ActorOrgasm(akActor,duration,iArousalDecrease,iForce,true)
EndFunction

;call devices function orgasm() when player have DD orgasm
Event OnOrgasm(string eventName, string strArg, float numArg, Form sender)
	UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByActorName(strArg)
	if slot
		slot.orgasm()
	endif
EndEvent

;call devices function orgasm() when player have sexlab orgasm
Event OnSexlabOrgasmStart(int tid, bool HasPlayer)   
	if HasPlayer
		UDCD_NPCM.getPlayerSlot().orgasm()
	endif
EndEvent 

Function OnSexlabSepOrgasmStart(Form kActor, Int iThread)
	Actor akActor = kActor as Actor
	UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByActor(akActor)
	if slot
		slot.orgasm()
	endif
EndFunction

bool Function isOrgasming(Actor akActor)
	return akActor.isInFaction(OrgasmFaction)
EndFunction

Int Function getOrgasmingCount(Actor akActor)
	if isOrgasming(akActor)
		return akActor.GetFactionRank(OrgasmFaction)
	else
		return 0
	endif
EndFunction

Function addOrgasmToActor(Actor akActor)
	if !isOrgasming(akActor)
		akActor.addToFaction(OrgasmFaction)
		akActor.SetFactionRank(OrgasmFaction,0)
	endif
	
	akActor.ModFactionRank(OrgasmFaction,1)
EndFunction

int Function removeOrgasmFromActor(Actor akActor)
	if !isOrgasming(akActor)
		return 0
	endif
	
	akActor.ModFactionRank(OrgasmFaction,-1)
	int loc_count = getOrgasmingCount(akActor)
	if loc_count == 0
		akActor.removeFromFaction(OrgasmFaction)
	endif
	return loc_count
EndFunction

Function ActorOrgasm(actor akActor,int iDuration, int iDecreaseArousalBy = 75,int iForce = 0, bool bForceAnimation = false)
	addOrgasmToActor(akActor)
	
	;call stopMinigame so it get stoped before all other shit gets processed
	bool loc_actorinminigame = UDCDmain.actorInMinigame(akActor) 
	if loc_actorinminigame
		UDCDMain.getMinigameDevice(akActor).stopMinigame()
	endif
	
	Int loc_orgasms = getOrgasmingCount(akActor)
	
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("ActorOrgasmPatched called for " + GetActorName(akActor),1)
	endif
	
	UDmain.UDPP.Send_Orgasm(akActor,iDuration,iDecreaseArousalBy,iForce,bForceAnimation,bWairForReceive = false)
	
	bool loc_isplayer = UDmain.ActorIsPlayer(akActor)
	bool loc_isfollower = false
	if !loc_isplayer
		loc_isfollower = ActorIsFollower(akActor)
	endif
	bool loc_is3Dloaded = akActor.Is3DLoaded() || loc_isplayer
	bool loc_close = UDmain.ActorInCloseRange(akActor)
	bool loc_cond = loc_is3Dloaded && loc_close

	;wait for minigame to end
	;while UDCDmain.ActorInMinigame(akActor) 
	;	Utility.waitMenuMode(0.01)
	;endwhile
	if loc_actorinminigame
		PlayOrgasmAnimation(akActor,iDuration)
	elseif ((akActor.IsInCombat() || akActor.IsSneaking()) && (loc_isplayer || loc_isfollower)) || !loc_cond
		if UDmain.ActorIsPlayer(akActor)
			UDCDmain.Print("You managed to not loss control over your body from orgasm!",2)
		endif
		akActor.damageAv("Stamina",50.0)
		akActor.damageAv("Magicka",50.0)
		Utility.wait(iDuration)
	elseif akActor.GetCurrentScene()
		Utility.wait(iDuration)
	elseif akActor.IsInFaction(libsp.Sexlab.AnimatingFaction)
		if UDCDmain.TraceAllowed()	
			UDCDmain.Log("ActorOrgasmPatched - sexlab animation detected - not playing animation for " + GetActorName(akActor),2)
		endif
		Utility.wait(iDuration)
	else
		PlayOrgasmAnimation(akActor,iDuration)
	endif
	
	if RemoveOrgasmFromActor(akActor) == 0
		if loc_cond
			UDEM.ResetExpressionRaw(akActor,80)
		endif
	endif
EndFunction

Function PlayOrgasmAnimation(Actor akActor,int aiDuration)
	if !aiDuration
		return
	endif
	if StorageUtil.GetIntValue(akActor,"UD_OrgasmDuration",0)
		Int loc_duration = Round(aiDuration*0.5)
		StorageUtil.AdjustIntValue(akActor,"UD_OrgasmDuration",loc_duration) ;incfrease current orgasm animation by 50%
		Utility.wait(loc_duration)
		return
	else
		StorageUtil.SetIntValue(akActor,"UD_OrgasmDuration",aiDuration)
	endif
	
	libsp.SetAnimating(akActor, true)
	string loc_anim = libsp.AnimSwitchKeyword(akActor, "Orgasm")
	;libsp.PlayThirdPersonAnimationBlocking(akActor,loc_anim, iDuration, true)
	;libsp.StartThirdPersonAnimation(akActor,loc_anim, iDuration)
	
	Form loc_shield = UDCDmain.GetShield(akActor)
	if loc_shield
		akActor.unequipItem(loc_shield,true,true)
	endif
	
	UDCDmain.DisableActor(akActor)
	
	Debug.SendAnimationEvent(akActor, loc_anim)	
	int loc_elapsedtime = 0
	while loc_elapsedtime < aiDuration
		if loc_elapsedtime && !(loc_elapsedtime % 2)
			UDCDmain.UpdateDisabledActor(akActor)
		else
			aiDuration = StorageUtil.GetIntValue(akActor,"UD_OrgasmDuration",aiDuration)
		endif
		Utility.wait(1.0)
		loc_elapsedtime += 1
	endwhile
	Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
	
	StorageUtil.UnsetIntValue(akActor,"UD_OrgasmDuration")
	
	UDCDmain.EnableActor(akActor)
	
	if loc_shield
		akActor.equipItem(loc_shield,false,true)
	endif
	
	libsp.SetAnimating(akActor, false)
EndFunction

;///////////////////////////////////////
;=======================================
;ORGASM RESIST MINIGAME
;=======================================
;//////////////////////////////////////;

;=======================================
;ORGASM _crit FUNCTIONS
;=======================================

bool _PlayerOrgasmResist_MinigameOn = false
Function sendOrgasmResistCritUpdateLoop(Int iChance,Float fDifficulty)
	int handle = ModEvent.Create("UD_CritUpdateLoopStart_OrgasmResist")
	if (handle)
		ModEvent.PushInt(handle,iChance)
		ModEvent.PushFloat(handle,fDifficulty)
        ModEvent.Send(handle)
    endif
EndFunction

Function CritLoopOrgasmResist(Int iChance,Float fDifficulty)
	string loc_meter = "none"
	bool loc_sendCrit = false
	while _PlayerOrgasmResist_MinigameOn
		if Utility.randomInt(1,100) <= iChance
			if !UDCDmain.UD_AutoCrit
				if Utility.randomInt(0,1)
					loc_meter = "S"
				else
					loc_meter = "M"
				endif
				loc_sendCrit = true
			else ;auto crits
				if Utility.randomInt() <= UDCDmain.UD_AutoCritChance
					OnCritSuccesOrgasmResist()
				else
					OnCritFailureOrgasmResist()
				endif
				return	
			endif
		endif	
		if loc_sendCrit
			_crit = True
			_crit_meter = loc_meter
			if (loc_meter == "S")
				if UDCDmain.UD_CritEffect == 2 || UDCDmain.UD_CritEffect == 1
					UDlibs.GreenCrit.RemoteCast(UDmain.Player,UDmain.Player,UDmain.Player)
					Utility.wait(0.3)
				endif
				if UDCDmain.UD_CritEffect == 2 || UDCDmain.UD_CritEffect == 0
					UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartStaminaBlinking")
				endif
			elseif (loc_meter == "M")
				if UDCDmain.UD_CritEffect == 2 || UDCDmain.UD_CritEffect == 1
					UDlibs.BlueCrit.RemoteCast(UDmain.Player,UDmain.Player,UDmain.Player)
					Utility.wait(0.3)
				endif
				if UDCDmain.UD_CritEffect == 2 || UDCDmain.UD_CritEffect == 0
					UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartMagickaBlinking")
				endif
			elseif (loc_meter == "R")
				if UDCDmain.UD_CritEffect == 2 || UDCDmain.UD_CritEffect == 1
					UDlibs.RedCrit.RemoteCast(UDmain.Player,UDmain.Player,UDmain.Player)
					Utility.wait(0.3)
				endif
			endif
			
			Utility.wait(fDifficulty)
			_crit = False
			loc_meter = "none"
			_crit_meter = "none"
			loc_sendCrit = false
		endif
		Utility.wait(1.0)
	endwhile
EndFunction

Function OnCritSuccesOrgasmResist()
	if TraceAllowed()	
		Log("OnCritSuccesOrgasmResist() callled!")
	endif
	UDmain.Player.restoreAV("Stamina", 15)
	UpdateActorOrgasmProgress(UDmain.Player,-10,true)
EndFunction

Function OnCritFailureOrgasmResist()
	if TraceAllowed()	
		Log("OnCritFailureOrgasmResist() callled!")
	endif
	;UDmain.Player.damageAV("Stamina", 25)
	UpdateActorOrgasmProgress(UDmain.Player,getActorOrgasmRate(UDmain.Player)*2,true)
EndFunction


Event MinigameKeysRegister()
	if TraceAllowed()	
		Log("UD_OrgasmManager MinigameKeysRegister called",1)
	endif
	RegisterForKey(UDCDMain.Stamina_meter_Keycode)
	RegisterForKey(UDCDMain.SpecialKey_Keycode)
	RegisterForKey(UDCDMain.Magicka_meter_Keycode)
	RegisterForKey(UDCDMain.ActionKey_Keycode)
	_specialButtonOn = false
EndEvent

Event MinigameKeysUnregister()
	if TraceAllowed()	
		Log("UD_OrgasmManager MinigameKeysUnregister called",1)
	endif
	UnregisterForKey(UDCDMain.Stamina_meter_Keycode)
	UnregisterForKey(UDCDMain.SpecialKey_Keycode)
	UnregisterForKey(UDCDMain.Magicka_meter_Keycode)
	UnregisterForKey(UDCDMain.ActionKey_Keycode)
	_specialButtonOn = false
EndEvent

Event OnKeyDown(Int KeyCode)
	if !UDmain.IsMenuOpen() ;only if player is not in menu
		bool loc_crit = _crit ;help variable to reduce lag
		if _PlayerOrgasmResist_MinigameOn
			if KeyCode == UDCDmain.SpecialKey_Keycode
				_specialButtonOn = true
				return
			endif
			if (loc_crit) && !UDCDmain.UD_AutoCrit
				if _crit_meter == "S" && KeyCode == UDCDmain.Stamina_meter_Keycode
					_crit = False
					loc_crit = False
					OnCritSuccesOrgasmResist()
					return
				elseif _crit_meter == "M" && KeyCode == UDCDmain.Magicka_meter_Keycode
					_crit = False
					loc_crit = False
					OnCritSuccesOrgasmResist()
					return
				elseif KeyCode == UDCDmain.Magicka_meter_Keycode || KeyCode == UDCDmain.Stamina_meter_Keycode
					_crit = False
					loc_crit = False
					OnCritFailureOrgasmResist()
				elseif KeyCode == UDCDmain.ActionKey_Keycode
					UDmain.Player.removeFromFaction(OrgasmResistFaction)
					_crit = false
					return 
				endif
			endif
			if KeyCode == UDCDmain.ActionKey_Keycode
				UDmain.Player.removeFromFaction(OrgasmResistFaction)
				_crit = false
				return
			elseif (KeyCode == UDCDmain.Stamina_meter_Keycode || KeyCode == UDCDmain.Magicka_meter_Keycode) && !UDCDmain.UD_AutoCrit
				_crit = False
				loc_crit = False
				OnCritFailureOrgasmResist()
				return
			endif
		endif
	endif
EndEvent

Event OnKeyUp(Int KeyCode, Float HoldTime)
    if KeyCode == UDCDmain.SpecialKey_Keycode
		if _PlayerOrgasmResist_MinigameOn
			_specialButtonOn = false
		endif
		return
	endif
EndEvent

;=======================================
;ORGASM RESIST LOOP
;=======================================
Function FocusOrgasmResistMinigame(Actor akActor)
	if !akActor.isInFaction(OrgasmCheckLoopFaction)
		Error("Can't start FocusOrgasmResistMinigame without orgasm check loop!")
	endif
	if getCurrentActorValuePerc(akActor,"Stamina") < 0.75; || UDmain.getCurrentActorValuePerc(akActor,"Magicka") < 0.65
		if UDmain.ActorIsPlayer(akActor)
			Print("You are too exhausted!")
		endif
		return
	endif
	if UDCDMain.actorInMinigame(akActor) || libs.isAnimating(akActor)
		if akActor == UDmain.Player
			Print("You are already bussy!")
		endif
		return
	endif
	
	if !(getActorAfterMultOrgasmRate(akActor) > 0)
		if UDmain.ActorIsPlayer(akActor)
		endif
		return
	endif
	akActor.AddToFaction(UDCDmain.MinigameFaction)
	akActor.AddToFaction(OrgasmResistFaction)
	
	float loc_staminaRate 	= akActor.getBaseAV("StaminaRate")
	akActor.setAV("StaminaRate", 0.0)
	
	UDCDMain.DisableActor(akActor,true)
	bool[] loc_cameraState = libs.StartThirdPersonAnimation(akActor, libs.AnimSwitchKeyword(akActor, "Horny01"), permitRestrictive=true)
	Game.EnablePlayerControls(abMovement = true)
	UDCDMain.sendHUDUpdateEvent(true,true,true,true)
	
	MinigameKeysRegister()
	UDCDMain.toggleWidget2(true)
	if UDmain.ActorIsPlayer(akActor)
		_PlayerOrgasmResist_MinigameOn = true
		sendOrgasmResistCritUpdateLoop(15,0.8)
	endif
	
	float loc_baseDrain = 5.0
	if akActor.wornhaskeyword(libs.zad_deviousheavybondage)
		loc_baseDrain += 2.5
	endif
	float loc_currentOrgasmRate = getActorOrgasmRate(akActor)
	bool loc_cycleON = true
	int loc_tick = 0
	float loc_StaminaRateMult = 1.0
	float loc_orgasmResistence = getActorOrgasmResist(akActor)
	int loc_HightSpiritMode_Duration = -2*Round(1/UDmain.UD_baseUpdateTime)
	int loc_HightSpiritMode_Type = 1
	while loc_cycleON
		if !akActor.isInFaction(OrgasmResistFaction);StorageUtil.GetIntValue(akActor,"UD_OrgasmResistMinigame_EndFlag",0)
			loc_cycleON = false
		endif
		
		if loc_cycleON
			if akActor.getAV("Stamina") <= 0 ;|| akActor.getAV("magicka") <= 0
				loc_cycleON = false
			endif
		endif
		
		if loc_cycleON
			if _specialButtonOn
				if loc_HightSpiritMode_Duration > 0
					if loc_HightSpiritMode_Type == 1
						loc_StaminaRateMult = 0.25
					elseif loc_HightSpiritMode_Type == 2
						loc_StaminaRateMult = 0.75
						UpdateActorOrgasmProgress(akActor,-8.0*(UDmain.UD_baseUpdateTime),true)
					elseif loc_HightSpiritMode_Type == 3
						loc_StaminaRateMult = 0.75
						libs.UpdateExposure(akActor,-2*iRange(Math.Floor(5*UDmain.UD_baseUpdateTime),1,10))
					endif
				else
					loc_StaminaRateMult = 2.0
				endif
			else
				loc_StaminaRateMult = 1.0
			endif
		endif
		
		if loc_tick*UDmain.UD_baseUpdateTime >= 1.0 && loc_cycleON
			loc_currentOrgasmRate 	= getActorOrgasmRate(akActor)
			loc_orgasmResistence	= getActorOrgasmResist(akActor)
			if loc_HightSpiritMode_Duration == 0
				if Utility.randomInt() <= 40 
					loc_HightSpiritMode_Type = Utility.randomInt(1,3)
					if loc_HightSpiritMode_Type == 1 ;RED
						UDCDMain.widget2.SetColors(0xff0000, 0xff00d8,0xFF00BC)
					elseif loc_HightSpiritMode_Type == 2 ;GREEN
						UDCDMain.widget2.SetColors(0x00ff68, 0x00ff68,0xFF00BC)
					elseif loc_HightSpiritMode_Type == 3 ;BLUE
						UDCDMain.widget2.SetColors(0x2e40d8, 0x2e40d8,0xFF00BC)
					endif
					loc_HightSpiritMode_Duration += Utility.randomInt(3,6)*Round(1/UDmain.UD_baseUpdateTime)
				endif
			endif
			loc_tick = 0
			UDCDmain.sendHUDUpdateEvent(true,true,true,true)
		endif
		
		if loc_cycleON
			akActor.damageAV("Stamina", loc_StaminaRateMult*loc_baseDrain*fRange((loc_currentOrgasmRate/loc_orgasmResistence),0.5,3.5)*UDmain.UD_baseUpdateTime)
		endif
		
		if loc_HightSpiritMode_Duration > 0 && loc_cycleON
			loc_HightSpiritMode_Duration -= 1
			if loc_HightSpiritMode_Duration == 0
				UDCDMain.widget2.SetColors(0xE727F5, 0xF775FF,0xFF00BC)
				loc_HightSpiritMode_Duration -= Utility.randomInt(3,4)*Round(1/UDmain.UD_baseUpdateTime)
			endif
		elseif loc_HightSpiritMode_Duration < 0
			loc_HightSpiritMode_Duration += 1
		endif
		
		if loc_cycleON
			Utility.wait(UDmain.UD_baseUpdateTime)
			loc_tick += 1
		endif
	endwhile
	
	akActor.setAV("StaminaRate", loc_staminaRate)
	if UDmain.ActorIsPlayer(akActor)
		_PlayerOrgasmResist_MinigameOn = false
	endif
	
	libs.EndThirdPersonAnimation(akActor, loc_cameraState, permitRestrictive=true)
	akActor.RemoveFromFaction(UDCDmain.MinigameFaction)
	UDCDMain.EnableActor(akActor,true)
	MinigameKeysUnregister()
	UDCDMain.widget2.SetColors(0xE727F5, 0xF775FF,0xFF00BC)
	akActor.RemoveFromFaction(OrgasmResistFaction)
	
	UDlibs.StruggleExhaustionSpell.SetNthEffectMagnitude(0, 40)
	UDlibs.StruggleExhaustionSpell.SetNthEffectDuration(0, 15)
	Utility.wait(0.5)
	UDlibs.StruggleExhaustionSpell.cast(akActor)
EndFunction

;UNUSED
;call devices function edge() when player get edged
Function OnEdge(string eventName, string strArg, float numArg, Form sender)
	if strArg != UDmain.Player.getActorBase().getName()
		int random = Utility.randomInt(1,3)
		if random == 1
			debug.notification(strArg + " gets denied just before reaching the orgasm!")
		elseif random == 2
			debug.notification(strArg + " screams as they are edged just before climax!")
		elseif random == 3
			debug.notification(strArg + " is edged!")
		endif
	endif
	UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByActorName(strArg)
	if slot
		slot.edge()
	endif
EndFunction

int Function GetOrgasmExhaustion(Actor akActor)
	return StorageUtil.getIntValue(akActor,"UD_OrgasmExhaustionNum")
EndFunction

bool Function ActorIsFollower(Actor akActor)
	return UDmain.ActorIsFollower(akActor)
EndFunction
Function Log(String msg, int level = 1)
	UDmain.Log(msg,level)
EndFunction
Function Error(String msg)
	UDmain.Error(msg)
EndFunction
Function Print(String strMsg, int iLevel = 1,bool bLog = false)
	UDmain.Print(strMsg,iLevel,bLog)
EndFunction
Bool Function TraceAllowed()
	return UDmain.TraceAllowed()
EndFunction
zadlibs_UDPatch Property libsp
	zadlibs_UDPatch function Get()
		return UDCDmain.libsp
	endfunction
endproperty