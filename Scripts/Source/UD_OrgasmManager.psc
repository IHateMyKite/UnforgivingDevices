Scriptname UD_OrgasmManager extends Quest conditional

UDCustomDeviceMain 		Property UDCDmain 	auto
UnforgivingDevicesMain 	Property UDmain 	auto
UD_libs 				Property UDlibs 	auto
zadlibs 				Property libs 		auto
UD_ExpressionManager 	Property UDEM 		auto

float 	Property UD_OrgasmResistence 		= 3.5 	auto ;orgasm rate required for actor to be able to orgasm, lower the value, the faster will orgasm rate increase stop
int 	Property UD_OrgasmArousalThreshold 	= 95 	auto ;arousal required for actor to be able to orgasm
bool 	Property UD_UseOrgasmWidget 		= True 	auto
float 	Property UD_OrgasmUpdateTime 		= 0.2 	auto
int 	Property UD_OrgasmAnimation 		= 1 	auto
int 	Property UD_OrgasmDuration 			= 20 	auto
bool 	Property UD_HornyAnimation 			= true 	auto
int 	Property UD_HornyAnimationDuration 	= 5 	auto

Actor Property UD_StopActorOrgasmCheckLoop = none auto
Actor Property UD_StopActorArousalCheckLoop = none auto

Faction Property OrgasmFaction 				auto
Faction Property OrgasmCheckLoopFaction 	auto
Faction Property ArousalCheckLoopFaction 	auto
Faction Property OrgasmResistFaction 		auto

;used for validating loop on update
;current loop version, changing this to different number will reset the loops with lower versions
Int Property UD_OrgasmCheckLoop_ver = 1 autoreadonly
int Property UD_ArousalCheckLoop_ver = 1 autoreadonly

bool 	_crit 					= false
bool 	_specialButtonOn 		= false
string 	_crit_meter				= "Error"
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
Function ValidateLoops()
	;if _OrgasmCheckLoop_ver && _ArousalCheckLoop_ver
		;if _OrgasmCheckLoop_ver < _OrgasmCheckLoop_ver_current || _ArousalCheckLoop_ver < _ArousalCheckLoop_ver_current
		;	UDCDmain.Print("[UD] Outdated OL or AL found. Updating! This might take a while...")
		;	UDCDmain.UDCD_NPCM.ResetOrgasmManagerLoops()
		;endif
	;endif
EndFunction

Function ResetOL(Actor akActor)
	while UD_StopActorOrgasmCheckLoop ;wait untill other operation finish
		Utility.waitMenuMode(0.01) 
	endwhile
	UD_StopActorOrgasmCheckLoop = akActor
	while UD_StopActorOrgasmCheckLoop ;wait for the loop to end
		Utility.waitMenuMode(0.01)
	endwhile
	StartOrgasmCheckLoop(akActor) ;start new OL
	UDCDMain.Print("[UD] OL reseted for " + GetActorName(akActor))
EndFunction
Function ResetAL(Actor akActor)
	while UD_StopActorArousalCheckLoop ;wait untill other operation finish
		Utility.waitMenuMode(0.01) 
	endwhile
	UD_StopActorArousalCheckLoop = akActor
	while UD_StopActorArousalCheckLoop ;wait for the loop to end
		Utility.waitMenuMode(0.01)
	endwhile
	StartArousalCheckLoop(akActor) ;start new AL
	UDCDMain.Print("[UD] AL reseted for " + GetActorName(akActor))
EndFunction

Function CheckOrgasmCheck(Actor akActor)
	if !akActor.isInFaction(OrgasmCheckLoopFaction)
		StartOrgasmCheckLoop(akActor)
	endif
EndFunction

Function CheckArousalCheck(Actor akActor)
	if !akActor.isInFaction(ArousalCheckLoopFaction)
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

Function StartArousalCheckLoop(Actor akActor)
	if !akActor
		Error("None passed to StartArousalCheckLoop!!!")
	endif
	
	if TraceAllowed()	
		Log("StartArousalCheckLoop("+getActorName(akActor)+") called")
	endif
	if akActor.isInFaction(ArousalCheckLoopFaction)
		return
	endif
	akActor.AddToFaction(ArousalCheckLoopFaction)
	
	int handle = ModEvent.Create("UD_ArousalCheckLoop")
	if (handle)
		if TraceAllowed()		
			Log("StartArousalCheckLoop("+getActorName(akActor)+"), sending event")
		endif
        ModEvent.PushForm(handle,akActor)
        ModEvent.Send(handle)
    endif
EndFunction

bool Function ArousalLoopBreak(Actor akActor,Int iVersion)
	bool loc_cond = false
	loc_cond = loc_cond || !UDCDMain.isRegistered(akActor)
	loc_cond = loc_cond || (UD_StopActorArousalCheckLoop == akActor)
	loc_cond = loc_cond || akActor.isDead()
	loc_cond = loc_cond || (iVersion < UD_ArousalCheckLoop_ver)
	return loc_cond
EndFunction

;int _ArousalCheckLoop_ver = 0

Function ArousalCheckLoop(Form fActor)
	Actor akActor = fActor as Actor
	if TraceAllowed()	
		Log("ArousalCheckLoop("+getActorName(akActor)+") started")
	endif
	Int loc_ArousalCheckLoop_ver = UD_ArousalCheckLoop_ver
	float loc_updateTime = 3.0
	while !ArousalLoopBreak(akActor,loc_ArousalCheckLoop_ver)
		Float loc_arousalRate = getArousalRate(akActor)

		Int loc_arousal = Round(loc_arousalRate*loc_updateTime)
		if akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmExhaustionEffect_KW)
			loc_arousal = Round(loc_arousal * 0.5)
		endif
		if loc_arousal > 0
			akActor.SetFactionRank(ArousalCheckLoopFaction,UpdateArousal(akActor ,loc_arousal))
		else
			akActor.SetFactionRank(ArousalCheckLoopFaction,getActorArousal(akActor))
		endif
		Utility.wait(loc_updateTime)
	endwhile
	akActor.RemoveFromFaction(ArousalCheckLoopFaction)

	if TraceAllowed()	
		Log("ArousalCheckLoop("+getActorName(akActor)+") ended")
	endif
	
	if UD_StopActorArousalCheckLoop == akActor
		UD_StopActorArousalCheckLoop = none
	endif
	
	if (loc_ArousalCheckLoop_ver < UD_ArousalCheckLoop_ver)
		UDCDmain.Print("Outdated AL found on " + GetActorName(akActor) + ". Reseting!")
		StartArousalCheckLoop(akActor)
	endif
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
	return UDmain.fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmRate",0.0),0.0,1000.0)
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
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmRateMultManip_Mutex = true
	float loc_newOrgasmRateMult = StorageUtil.getFloatValue(akActor, "UD_OrgasmRateMultiplier",1.0) + orgasmRateMultiplier
	StorageUtil.setFloatValue(akActor, "UD_OrgasmRateMultiplier",loc_newOrgasmRateMult)
	_OrgasmRateMultManip_Mutex = false
EndFunction

Function removeOrgasmRateMultiplier(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmRateMultManip_Mutex
		Utility.waitMenuMode(0.1)
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
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmResistManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmResist",fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmResist",UD_OrgasmResistence) + orgasmRateMultiplier,0.0,100.0))
	_OrgasmResistManip_Mutex = false
EndFunction
Function setActorOrgasmResist(Actor akActor,float fValue)
	while _OrgasmResistManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmResistManip_Mutex = true
	StorageUtil.SetFloatValue(akActor, "UD_OrgasmResist",fRange(fValue,0.0,100.0))
	_OrgasmResistManip_Mutex = false
EndFunction
float Function getActorOrgasmResist(Actor akActor)
	return fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmResist",UD_OrgasmResistence),0.0,1000.0)
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
		Log("sendOrgasmCheckLoop("+getActorName(akActor)+") called")
	endif
	if !akActor
		Error("None passed to sendOrgasmCheckLoop!!!")
	endif
	if akActor.isInFaction(OrgasmCheckLoopFaction)
		return
	endif
	
	int handle = ModEvent.Create("UD_OrgasmCheckLoop")
	if (handle)
		if TraceAllowed()		
			Log("sendOrgasmCheckLoop("+getActorName(akActor)+"), sending event")
		endif
        ModEvent.PushForm(handle,akActor)
        ModEvent.Send(handle)
    endif
	
	while !akActor.isInFaction(OrgasmCheckLoopFaction)
		Utility.waitMenuMode(0.01)
	endwhile
EndFunction

bool Function OrgasmLoopBreak(Actor akActor, int iVersion)
	bool loc_cond = false
	loc_cond = loc_cond || (UD_StopActorOrgasmCheckLoop == akActor)
	loc_cond = loc_cond || !UDCDmain.isRegistered(akActor)
	loc_cond = loc_cond || akActor.isDead()
	loc_cond = loc_cond || (iVersion < UD_OrgasmCheckLoop_ver)
	return loc_cond
EndFunction



Function OrgasmCheckLoop(Form fActor)
	Actor akActor = fActor as Actor
	akActor.AddToFaction(OrgasmCheckLoopFaction)
	
	int loc_OrgasmCheckLoop_ver 		= UD_OrgasmCheckLoop_ver
	if TraceAllowed()	
		Log("OrgasmCheckLoop(ver. "+loc_OrgasmCheckLoop_ver+") started for " + getActorName(akActor),1)
	endif
	
	float loc_orgasmProgress = 0.0
	float loc_orgasmProgress2= 0.0
	int loc_hornyAnimTimer = 0
	bool[] loc_cameraState
	int loc_msID = -1
	
	sslBaseExpression expression = UDEM.getExpression("UDAroused");libs.SexLab.GetExpressionByName("UDAroused");

	float loc_currentUpdateTime = 1.5
	if ActorIsPlayer(akActor)
		loc_currentUpdateTime = UD_OrgasmUpdateTime
	endif
	
	UDCDMain.widget2.SetPercent(0.0)
	UDCDMain.toggleWidget2(false)
	
	;local variables
	bool loc_widgetShown 				= false
	bool loc_forceStop 					= false
	float loc_orgasmRate 				= 0.0
	float loc_orgasmRate2 				= 0.0
	float loc_orgasmRateAnti 			= 0.0
	float loc_orgasmResistMultiplier	= getActorOrgasmResistMultiplier(akActor)
	float loc_orgasmRateMultiplier		= getActorOrgasmRateMultiplier(akActor)
	int loc_arousal 					= getArousal(akActor)
	int loc_tick 						= 1
	int loc_tickS						= 0
	int loc_expressionUpdateTimer 		= 0
	bool loc_orgasmResisting 			= akActor.isInFaction(OrgasmResistFaction)
	bool loc_expressionApplied 			= false;ActorHaveExpressionApplied(akActor)
	float loc_orgasmCapacity			= getActorOrgasmCapacity(akActor)
	float loc_orgasmResistence			= getActorOrgasmResist(akActor)
	
	bool loc_enoughArousal = false
	while !OrgasmLoopBreak(akActor,loc_OrgasmCheckLoop_ver) 
		loc_orgasmProgress2 = loc_orgasmProgress
		
		loc_orgasmResisting = akActor.isInFaction(OrgasmResistFaction);StorageUtil.GetIntValue(akActor,"UD_OrgasmResisting",0)
		if loc_orgasmResisting
			loc_orgasmProgress = getActorOrgasmProgress(akActor)
		else
			loc_orgasmProgress += loc_orgasmRate*loc_orgasmRateMultiplier*loc_currentUpdateTime
		endif
		
		loc_orgasmRateAnti = CulculateAntiOrgasmRateMultiplier(loc_arousal)*loc_orgasmResistMultiplier*(loc_orgasmProgress*(loc_orgasmResistence/100.0))*loc_currentUpdateTime  ;edging, orgasm rate needs to be bigger then UD_OrgasmResistence, else actor will not reach orgasm
		
		if !loc_orgasmResisting
			if loc_orgasmRate*loc_orgasmRateMultiplier > 0.0
				loc_orgasmProgress -= loc_orgasmRateAnti
			else
				loc_orgasmProgress -= 3*loc_orgasmRateAnti
			endif
		endif
		
		if loc_widgetShown && !loc_orgasmResisting
			UDCDMain.widget2.SetPercent(loc_orgasmProgress/loc_orgasmCapacity)
		endif

		;check orgasm
		if loc_orgasmProgress > 0.99*loc_orgasmCapacity
			if TraceAllowed()			
				Log("Starting orgasm for " + getActorName(akActor))
			endif
			if loc_orgasmResisting
				akActor.RemoveFromFaction(OrgasmResistFaction)
				;StorageUtil.SetIntValue(akActor,"UD_OrgasmResistMinigame_EndFlag",1)
			endif
			
			if loc_widgetShown
				loc_widgetShown = false
				UDCDMain.toggleWidget2(false)
				UDCDmain.widget2.SetPercent(0.0,true)
			endif
			
			loc_hornyAnimTimer = -30 ;cooldown
			
			startOrgasm(akActor,UD_OrgasmDuration,true)
			loc_orgasmProgress = 0.0
			SetActorOrgasmProgress(akActor,loc_orgasmProgress)
		endif
		
		if loc_tick * loc_currentUpdateTime >= 1.0
			loc_orgasmRate2 = loc_orgasmRate
			if ActorIsPlayer(akActor)
				loc_currentUpdateTime = UD_OrgasmUpdateTime
			endif
			loc_tick = 0
			loc_tickS += 1
			
			if (loc_tickS % 2)
				loc_orgasmCapacity			= getActorOrgasmCapacity(akActor)
			else
				loc_orgasmResistence 		= getActorOrgasmResist(akActor)
			endif
			
			if !loc_orgasmResisting
				loc_arousal 				= getArousal(akActor)
				loc_orgasmRate 				= getActorOrgasmRate(akActor)
				loc_orgasmRateMultiplier	= getActorOrgasmRateMultiplier(akActor)
				loc_orgasmResistMultiplier 	= getActorOrgasmResistMultiplier(akActor)
				SetActorOrgasmProgress(akActor,loc_orgasmProgress)
			endif

			;expression
			if loc_orgasmRate >= loc_orgasmResistence*0.75 && (!loc_expressionApplied || loc_expressionUpdateTimer > 3) 
				;init expression
				loc_expressionApplied = (libs as zadlibs_UDPatch).ApplyExpressionPatched(akActor, expression, iRange(UDmain.Round(loc_orgasmProgress),25,100),false,10)
				if loc_expressionApplied
					loc_expressionUpdateTimer = 0
				endif
			elseif loc_orgasmRate < loc_orgasmResistence*0.75 && loc_expressionApplied
				loc_expressionApplied = !(libs as zadlibs_UDPatch).ResetExpressionPatched(akActor, expression,10)
			endif
			
			;can play horny animation ?
			if (loc_orgasmRate > 0.5*loc_orgasmResistMultiplier*loc_orgasmResistence) 
				if loc_enoughArousal
					;start moaning sound again
					if loc_msID == -1
						loc_msID = libs.MoanSound.Play(akActor)
						Sound.SetInstanceVolume(loc_msID, libs.GetMoanVolume(akActor))
					endif
				endif
			else
				;disable moaning sound when orgasm rate is too low
				if loc_msID != -1
					Sound.StopInstance(loc_msID)
					loc_msID = -1
				endif
			endif
			if !UDCDMain.actorInMinigame(akActor)
				if (loc_orgasmRate > 0.5*loc_orgasmResistMultiplier*loc_orgasmResistence) && !loc_orgasmResisting && !akActor.IsInCombat() ;orgasm progress is increasing
					if (loc_hornyAnimTimer == 0) && !libs.IsAnimating(akActor) && UD_HornyAnimation ;start horny animation for UD_HornyAnimationDuration
						if Utility.RandomInt() <= (Math.ceiling(100/fRange(loc_orgasmProgress,15.0,100.0))) 
							; Select animation
							loc_cameraState = libs.StartThirdPersonAnimation(akActor, libs.AnimSwitchKeyword(akActor, "Horny01"), permitRestrictive=true)
							loc_hornyAnimTimer += UD_HornyAnimationDuration
							if !loc_expressionApplied
								(libs as zadlibs_UDPatch).ApplyExpressionPatched(akActor, expression, iRange(UDmain.Round(loc_orgasmProgress),75,100),false,10)
								loc_expressionApplied = true
								loc_expressionUpdateTimer = 0
							endif
						endif
					EndIf
				endif
				
				if !loc_orgasmResisting
					if loc_hornyAnimTimer > 0 ;reduce horny animation timer 
						loc_hornyAnimTimer -= 1
						if (loc_hornyAnimTimer == 0)
							libs.EndThirdPersonAnimation(akActor, loc_cameraState, permitRestrictive=true)
							loc_hornyAnimTimer = -20 ;cooldown
						EndIf
					elseif loc_hornyAnimTimer < 0 ;cooldown
						loc_hornyAnimTimer += 1
					endif
				endif
			endif
			
			if UD_UseOrgasmWidget && ActorIsPlayer(akActor)
				if (loc_widgetShown && loc_orgasmProgress < 2.5) ;|| (loc_widgetShown)
					UDCDMain.toggleWidget2(false)
					loc_widgetShown = false
				elseif !loc_widgetShown && loc_orgasmProgress >= 2.5
					UDCDMain.widget2.SetPercent(loc_orgasmProgress/loc_orgasmCapacity,true)
					UDCDMain.toggleWidget2(true)
					loc_widgetShown = true
				endif
			endif
			
			if loc_orgasmProgress < 0.0
				loc_orgasmProgress = 0.0
			endif
			
			loc_expressionUpdateTimer += 1
		endif
		if loc_widgetShown
			Utility.wait(loc_currentUpdateTime)
		else
			Utility.wait(1.0)
		endif
		
		loc_tick += 1
	endwhile
	
	;stop moan sound
	if loc_msID != -1
		Sound.StopInstance(loc_msID)
	endif
	
	;end animation if it still exist
	if  loc_hornyAnimTimer > 0
		libs.EndThirdPersonAnimation(akActor, loc_cameraState, permitRestrictive=true)
		loc_hornyAnimTimer = 0
	EndIf
	
	;hide widget
	if loc_widgetShown
		UDCDMain.toggleWidget2(false)
	endif
	
	;reset expression
	(libs as zadlibs_UDPatch).ResetExpressionPatched(akActor, expression)
	
	StorageUtil.UnsetFloatValue(akActor, "UD_OrgasmProgress")

	;end mutex
	akActor.RemoveFromFaction(OrgasmCheckLoopFaction)
	if UD_StopActorOrgasmCheckLoop == akActor
		UD_StopActorOrgasmCheckLoop = none
	endif
	
	if loc_OrgasmCheckLoop_ver < UD_OrgasmCheckLoop_ver
		UDCDmain.Print("Old OL version found on " + GetActorName(akActor) + ". Reseting!")
		StartOrgasmCheckLoop(akActor)
	endif
EndFunction

;=======================================
;START ORGASM EVENT
;=======================================

Function startOrgasm(Actor akActor,int duration,bool blocking = true)
	if TraceAllowed()	
		Log("startOrgasm() for " + getActorName(akActor) + ", duration = " + duration + ",blocking = " + blocking)
	endif
	int loc_orgasms = 0
	if blocking
		loc_orgasms = getOrgasmingCount(akActor)
	endif
	int handle = ModEvent.Create("UD_Orgasm")
	if (handle)
		ModEvent.PushForm(handle, akActor)
		ModEvent.PushInt(handle, duration)
        ModEvent.Send(handle)
		
		;check for orgasm start
		if blocking
			float loc_time = 0.0
			while (getOrgasmingCount(akActor) == loc_orgasms) && loc_time < 3.0
				Utility.waitMenuMode(0.05)
				loc_time += 0.05
			endwhile
			
			if loc_time >= 3.0
				Error("startOrgasm("+getActorName(akActor)+") timeout!")
			endif
		endif
    endIf	
EndFunction

;=======================================
;ORGASM
;=======================================

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

Function removeOrgasmFromActor(Actor akActor)
	if !isOrgasming(akActor)
		return
	endif
	
	akActor.ModFactionRank(OrgasmFaction,-1)
	
	if getOrgasmingCount(akActor) == 0
		akActor.removeFromFaction(OrgasmFaction)
	endif
EndFunction

;will rework later
Function Orgasm(Form fActor,int duration)
	Actor akActor = fActor as Actor
	(libs as zadlibs_UDPatch).ActorOrgasmPatched(akActor,20,75,true)
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
					UDlibs.GreenCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
					Utility.wait(0.3)
				endif
				if UDCDmain.UD_CritEffect == 2 || UDCDmain.UD_CritEffect == 0
					UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartStaminaBlinking")
				endif
			elseif (loc_meter == "M")
				if UDCDmain.UD_CritEffect == 2 || UDCDmain.UD_CritEffect == 1
					UDlibs.BlueCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
					Utility.wait(0.3)
				endif
				if UDCDmain.UD_CritEffect == 2 || UDCDmain.UD_CritEffect == 0
					UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartMagickaBlinking")
				endif
			elseif (loc_meter == "R")
				if UDCDmain.UD_CritEffect == 2 || UDCDmain.UD_CritEffect == 1
					UDlibs.RedCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
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
	Game.getPlayer().restoreAV("Stamina", 15)
	UpdateActorOrgasmProgress(Game.getPlayer(),-10,true)
EndFunction

Function OnCritFailureOrgasmResist()
	if TraceAllowed()	
		Log("OnCritFailureOrgasmResist() callled!")
	endif
	;Game.getPlayer().damageAV("Stamina", 25)
	UpdateActorOrgasmProgress(Game.getPlayer(),getActorOrgasmRate(Game.getPlayer())*2,true)
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
	if !Utility.IsInMenuMode() ;only if player is not in menu
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
					Game.GetPlayer().removeFromFaction(OrgasmResistFaction)
					_crit = false
					return 
				endif
			endif
			if KeyCode == UDCDmain.ActionKey_Keycode
				Game.GetPlayer().removeFromFaction(OrgasmResistFaction)
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
	if UDmain.getCurrentActorValuePerc(akActor,"Stamina") < 0.75; || UDmain.getCurrentActorValuePerc(akActor,"Magicka") < 0.65
		if ActorIsPlayer(akActor)
			Print("You are too exhausted!")
		endif
		return
	endif
	if UDCDMain.actorInMinigame(akActor) || libs.isAnimating(akActor)
		if akActor == Game.getPlayer()
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
	
	if ActorIsPlayer(akActor)
		_PlayerOrgasmResist_MinigameOn = true
		sendOrgasmResistCritUpdateLoop(15,0.8)
	endif
	
	float loc_baseDrain = 5.0
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
	if ActorIsPlayer(akActor)
		_PlayerOrgasmResist_MinigameOn = false
	endif
	
	UDlibs.StruggleExhaustionSpell.SetNthEffectMagnitude(0, 40)
	UDlibs.StruggleExhaustionSpell.SetNthEffectDuration(0, 15)
	Utility.wait(0.5)
	UDlibs.StruggleExhaustionSpell.cast(akActor)
	
	libs.EndThirdPersonAnimation(akActor, loc_cameraState, permitRestrictive=true)
	akActor.RemoveFromFaction(UDCDmain.MinigameFaction)
	UDCDMain.EnableActor(akActor,true)
	MinigameKeysUnregister()
	UDCDMain.widget2.SetColors(0xE727F5, 0xF775FF,0xFF00BC)
	akActor.RemoveFromFaction(OrgasmResistFaction)
EndFunction

;wrappers
float Function fRange(float fValue,float fMin,float fMax) ;interface for UDmain
	return UDmain.fRange(fValue,fMin,fMax)
EndFunction
int Function iRange(int iValue,int iMin,int iMax) ;interface for UDmain
	return UDmain.iRange(iValue,iMin,iMax)
EndFunction
int Function Round(float fValue)
	return UDmain.Round(fValue)
EndFunction
bool Function ActorIsPlayer(Actor akActor)
	return UDmain.ActorIsPlayer(akActor)
EndFunction
bool Function ActorIsFollower(Actor akActor)
	return UDmain.ActorIsFollower(akActor)
EndFunction
string Function getActorName(Actor akActor)
	return UDmain.getActorName(akActor)
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