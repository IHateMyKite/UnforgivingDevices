Scriptname UD_OrchamsCheckScript_AME extends activemagiceffect 

import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto
UD_OrgasmManager Property UDOM 
	UD_OrgasmManager Function get()
		return UDCDmain.UDOM
	EndFunction
EndProperty
UD_ExpressionManager Property UDEM 
	UD_ExpressionManager Function get()
		return UDCDmain.UDEM
	EndFunction
EndProperty
UnforgivingDevicesMain Property UDmain 
	UnforgivingDevicesMain Function get()
		return UDCDmain.UDmain
	EndFunction
EndProperty
zadlibs Property libs auto

Actor akActor = none
bool _finished = false
MagicEffect _MagickEffect = none

;local variables
float loc_currentUpdateTime 		= 1.0
bool loc_widgetShown 				= false
bool loc_forceStop 					= false
bool loc_actorinminigame			= false
float loc_forcing					= 0.0
float loc_orgasmRate 				= 0.0
float loc_orgasmRate2 				= 0.0
float loc_orgasmRateAnti 			= 0.0
float loc_orgasmResistMultiplier	= 1.0
float loc_orgasmRateMultiplier		= 1.0
int loc_arousal 					= 0
int loc_tick 						= 1
int loc_tickS						= 0
int loc_expressionUpdateTimer 		= 0
bool loc_orgasmResisting 			= false
bool loc_orgasmResisting2 			= false
bool loc_expressionApplied 			= false
float loc_orgasmCapacity			= 100.0
float loc_orgasmResistence			= 2.5	
float loc_orgasmProgress 			= 0.0
float loc_orgasmProgress2			= 0.0
float loc_orgasmProgress_p			= 0.0
int	loc_orgasms						= 0
int loc_hornyAnimTimer 				= 0
bool[] loc_cameraState
int loc_msID 						= -1
sslBaseExpression expression
float[] loc_expression

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akActor = akTarget
	akActor.AddToFaction(UDOM.OrgasmCheckLoopFaction)
	if UDCDmain.TraceAllowed() && UDmain.ActorIsPlayer(akActor)
		UDCDmain.Log("UD_OrchamsCheckScript_AME("+GetActorName(akActor)+") - OnEffectStart()",2)
	endif
	_MagickEffect = GetBaseObject()
	loc_expression = UDEM.GetPrebuildExpression_Horny1()
	if UDmain.ActorIsPlayer(akActor)
		loc_currentUpdateTime = UDOM.UD_OrgasmUpdateTime
	else
		loc_currentUpdateTime = 1.0
	endif
	
	;init local variables
	loc_widgetShown 				= false
	loc_forceStop 					= false
	loc_orgasmRate 					= 0.0
	loc_orgasmRate2 				= 0.0
	loc_orgasmRateAnti 				= 0.0
	loc_orgasmResistMultiplier		= UDOM.getActorOrgasmResistMultiplier(akActor)
	loc_orgasmRateMultiplier		= UDOM.getActorOrgasmRateMultiplier(akActor)
	loc_arousal 					= UDOM.getArousal(akActor)
	loc_forcing 					= UDOM.getActorOrgasmForcing(akActor)
	loc_tick 						= 1
	loc_tickS						= 0
	loc_expressionUpdateTimer 		= 0
	loc_orgasmResisting 			= akActor.isInFaction(UDOM.OrgasmResistFaction)
	loc_orgasmResisting2			= false
	loc_expressionApplied 			= false;ActorHaveExpressionApplied(akActor)
	loc_orgasmCapacity				= UDOM.getActorOrgasmCapacity(akActor)
	loc_orgasmResistence			= UDOM.getActorOrgasmResist(akActor)
	loc_orgasmProgress 				= StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0)
	loc_orgasmProgress2				= 0.0
	loc_orgasmProgress_p			= loc_orgasmProgress/loc_orgasmCapacity
	loc_hornyAnimTimer 				= 0
	loc_msID 						= -1
	loc_orgasms						= 0
	loc_actorinminigame				= UDCDMain.actorInMinigame(akActor)
	registerForSingleUpdate(0.1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	_finished = true
	if UDCDmain.TraceAllowed() && UDmain.ActorIsPlayer(akActor)
		UDCDmain.Log("UD_OrchamsCheckScript_AME("+GetActorName(akActor)+") - OnEffectFinish()",1)
	endif
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
		UDCDmain.toggleWidget2(false)
	endif
	
	;reset expression
	UDEM.ResetExpressionRaw(akActor, 10)
	
	;StorageUtil.UnsetFloatValue(akActor, "UD_OrgasmProgress")

	;end mutex
	akActor.RemoveFromFaction(UDOM.OrgasmCheckLoopFaction)
EndEvent

Function Update()
	if !loc_expression
		loc_expression = UDEM.GetPrebuildExpression_Horny1()
	endif
EndFunction

Event OnUpdate()
	if IsRunning()
		if UDOM.OrgasmLoopBreak(akActor, UDOM.UD_OrgasmCheckLoop_ver) ;!UDCDmain.isRegistered(akActor) && !akActor.isDead()
			GInfo("UD_OrchamsCheckScript_AME("+GetActorName(akActor)+") - OrgasmLoopBreak -> dispeling")
			akActor.DispelSpell(UDCDmain.UDlibs.OrgasmCheckSpell)
		else
			Update()
			loc_orgasmProgress2 = loc_orgasmProgress
			
			loc_orgasmResisting = akActor.isInFaction(UDOM.OrgasmResistFaction);StorageUtil.GetIntValue(akActor,"UD_OrgasmResisting",0)
			if loc_orgasmResisting
				loc_orgasmResisting2 = true
				loc_orgasmProgress = UDOM.getActorOrgasmProgress(akActor)
			else
				if loc_orgasmResisting2
					loc_orgasmResisting2 = false
					loc_arousal 				= UDOM.getArousal(akActor)
					loc_orgasmRate 				= UDOM.getActorOrgasmRate(akActor)
					loc_orgasmRateMultiplier	= UDOM.getActorOrgasmRateMultiplier(akActor)
					loc_orgasmResistMultiplier 	= UDOM.getActorOrgasmResistMultiplier(akActor)
					loc_orgasms					= UDOM.getOrgasmingCount(akActor)
					loc_actorinminigame			= UDCDMain.actorInMinigame(akActor)
					UDOM.SetActorOrgasmProgress(akActor,loc_orgasmProgress)
				endif
				loc_orgasmProgress += loc_orgasmRate*loc_orgasmRateMultiplier*loc_currentUpdateTime
			endif
			
			loc_orgasmRateAnti = UDOM.CulculateAntiOrgasmRateMultiplier(loc_arousal)*loc_orgasmResistMultiplier*(loc_orgasmProgress*(loc_orgasmResistence/100.0))*loc_currentUpdateTime  ;edging, orgasm rate needs to be bigger then UD_OrgasmResistence, else actor will not reach orgasm
			
			if !loc_orgasmResisting
				if loc_orgasmRate*loc_orgasmRateMultiplier > 0.0
					loc_orgasmProgress -= loc_orgasmRateAnti
				else
					loc_orgasmProgress -= 3*loc_orgasmRateAnti
				endif
			endif
			
			loc_orgasmProgress_p = fRange(loc_orgasmProgress/loc_orgasmCapacity,0.0,1.0) ;update relative orgasm progress
			
			if loc_widgetShown && !loc_orgasmResisting
				UDCDMain.widget2.SetPercent(loc_orgasmProgress_p)
			endif

			;check orgasm
			if loc_orgasmProgress_p > 0.99
				if UDCDmain.TraceAllowed()			
					UDCDmain.Log("Starting orgasm for " + getActorName(akActor))
				endif
				if loc_orgasmResisting
					akActor.RemoveFromFaction(UDOM.OrgasmResistFaction)
					;StorageUtil.SetIntValue(akActor,"UD_OrgasmResistMinigame_EndFlag",1)
				endif
				
				if loc_widgetShown
					loc_widgetShown = false
					UDCDMain.toggleWidget2(false)
					UDCDmain.widget2.SetPercent(0.0,true)
				endif
				
				loc_hornyAnimTimer = -30 ;cooldown
				
				Int loc_force = 0
				if loc_forcing < 0.5
					loc_force = 0
				elseif loc_forcing < 1.0
					loc_force = 1
				else
					loc_force = 2
				endif
				UDOM.startOrgasm(akActor,UDOM.UD_OrgasmDuration,75,loc_force,true)
				loc_orgasmProgress = 0.0
				UDOM.SetActorOrgasmProgress(akActor,loc_orgasmProgress)
			endif
			
			if loc_tick * loc_currentUpdateTime >= 1.0
				loc_orgasmRate2 = loc_orgasmRate
				if UDmain.ActorIsPlayer(akActor)
					loc_currentUpdateTime = UDOM.UD_OrgasmUpdateTime
				endif
				
				loc_tick = 0
				loc_tickS += 1
				
				int loc_switch = (loc_tickS % 3)
				if loc_switch == 0
					loc_orgasmCapacity			= UDOM.getActorOrgasmCapacity(akActor)
				elseif loc_switch == 1
					loc_orgasmResistence 		= UDOM.getActorOrgasmResist(akActor)
				else
					loc_forcing 				= UDOM.getActorOrgasmForcing(akActor)
				endif
				
				if !loc_orgasmResisting
					loc_arousal 				= UDOM.getArousal(akActor)
					loc_orgasmRate 				= UDOM.getActorOrgasmRate(akActor)
					loc_orgasmRateMultiplier	= UDOM.getActorOrgasmRateMultiplier(akActor)
					loc_orgasmResistMultiplier 	= UDOM.getActorOrgasmResistMultiplier(akActor)
					loc_orgasms					= UDOM.getOrgasmingCount(akActor)
					loc_actorinminigame			= UDCDMain.actorInMinigame(akActor)
					UDOM.SetActorOrgasmProgress(akActor,loc_orgasmProgress)
				endif

				;expression
				if loc_orgasmRate >= loc_orgasmResistence*0.75 && (!loc_expressionApplied || loc_expressionUpdateTimer > 3) 
					;init expression
					UDEM.ApplyExpressionRaw(akActor, loc_expression, iRange(Round(loc_orgasmProgress),75,100),false,10)
					loc_expressionApplied = true
					loc_expressionUpdateTimer = 0
				elseif loc_orgasmRate < loc_orgasmResistence*0.75 && loc_expressionApplied
					UDEM.ResetExpressionRaw(akActor,10)
					loc_expressionApplied = false
				endif
				
				;can play horny animation ?
				if (loc_orgasmRate > 0.5*loc_orgasmResistMultiplier*loc_orgasmResistence) 
					;start moaning sound again. Not play when actor orgasms
					if loc_msID == -1 && !loc_orgasms && !loc_actorinminigame
						loc_msID = libs.MoanSound.Play(akActor)
						Sound.SetInstanceVolume(loc_msID, fRange(loc_orgasmProgress_p*2.0,0.75,1.0)*libs.GetMoanVolume(akActor,loc_arousal))
					endif
				else
					;disable moaning sound when orgasm rate is too low
					if loc_msID != -1
						Sound.StopInstance(loc_msID)
						loc_msID = -1
					endif
				endif
				if !loc_actorinminigame
					if (loc_orgasmRate > 0.5*loc_orgasmResistMultiplier*loc_orgasmResistence) && !loc_orgasmResisting && !akActor.IsInCombat() ;orgasm progress is increasing
						if (loc_hornyAnimTimer == 0) && !libs.IsAnimating(akActor) && UDOM.UD_HornyAnimation ;start horny animation for UD_HornyAnimationDuration
							if Utility.RandomInt() <= (Math.ceiling(100/fRange(loc_orgasmProgress,15.0,100.0))) 
								; Select animation
								loc_cameraState = libs.StartThirdPersonAnimation(akActor, libs.AnimSwitchKeyword(akActor, "Horny01"), permitRestrictive=true)
								loc_hornyAnimTimer += UDOM.UD_HornyAnimationDuration
								if !loc_expressionApplied
									UDEM.ApplyExpressionRaw(akActor, loc_expression, iRange(Round(loc_orgasmProgress),75,100),false,10)
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
				
				if UDOM.UD_UseOrgasmWidget && UDmain.ActorIsPlayer(akActor)
					if (loc_widgetShown && loc_orgasmProgress < 2.5) ;|| (loc_widgetShown)
						UDCDMain.toggleWidget2(false)
						loc_widgetShown = false
					elseif !loc_widgetShown && loc_orgasmProgress >= 2.5
						UDCDMain.widget2.SetPercent(loc_orgasmProgress_p,true)
						UDCDMain.toggleWidget2(true)
						loc_widgetShown = true
					endif
				endif
				
				if loc_orgasmProgress < 0.0
					loc_orgasmProgress = 0.0
				endif
				
				loc_expressionUpdateTimer += 1
			endif
			
			loc_tick += 1
			
			if IsRunning()
				if UDmain.ActorIsPlayer(akActor)
					loc_currentUpdateTime = UDOM.UD_OrgasmUpdateTime
				else
					loc_currentUpdateTime = 1.0
				endif
				registerForSingleUpdate(loc_currentUpdateTime)
			endif
		endif
	endif
EndEvent

bool Function IsRunning()
	return akActor.hasMagicEffect(_MagickEffect)
EndFunction


;wrappers
bool Function ActorIsFollower()
	return UDCDmain.ActorIsFollower(akActor)
EndFunction
Function Log(String msg, int level = 1)
	UDCDmain.Log(msg,level)
EndFunction
Function Error(String msg)
	UDCDmain.Error(msg)
EndFunction
Function Print(String strMsg, int iLevel = 1,bool bLog = false)
	UDCDmain.Print(strMsg,iLevel,bLog)
EndFunction
Bool Function TraceAllowed()
	return UDCDmain.TraceAllowed()
EndFunction
zadlibs_UDPatch Property libsp
	zadlibs_UDPatch function Get()
		return UDCDmain.libsp
	endfunction
endproperty