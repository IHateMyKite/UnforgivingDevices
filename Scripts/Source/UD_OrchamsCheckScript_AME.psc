Scriptname UD_OrchamsCheckScript_AME extends activemagiceffect 

;/
UDCustomDeviceMain Property UDCDmain auto
zadlibs Property libs auto

Actor akActor = none
bool _finished = false
MagicEffect _MagickEffect = none

;local variables
float loc_currentUpdateTime 		= 1.0
bool loc_widgetShown 				= false
bool loc_forceStop 					= false
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
bool loc_expressionApplied 			= false
float loc_orgasmCapacity			= 100.0
float loc_orgasmResistence			= 2.5	
bool loc_enoughArousal 				= false
float loc_orgasmProgress 			= 0.0
float loc_orgasmProgress2			= 0.0
int loc_hornyAnimTimer 				= 0
bool[] loc_cameraState
int loc_msID 						= -1
sslBaseExpression expression

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akActor = akTarget
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("UD_OrchamsCheckScript_AME started for " + UDCDmain.GetActorName(akActor) +"!",2)
	endif
	_MagickEffect = GetBaseObject()
	akActor.AddToFaction(UDCDmain.OrgasmCheckLoopFaction)
	expression = UDCDmain.UDEM.getExpression("UDAroused");libs.SexLab.GetExpressionByName("UDAroused");

	if UDCDmain.ActorIsPlayer(akActor)
		loc_currentUpdateTime = UDCDmain.UD_OrgasmUpdateTime
	endif
	
	;init local variables
	loc_widgetShown 				= false
	loc_forceStop 					= false
	loc_orgasmRate 					= 0.0
	loc_orgasmRate2 				= 0.0
	loc_orgasmRateAnti 				= 0.0
	loc_orgasmResistMultiplier		= UDCDmain.getActorOrgasmResistMultiplier(akActor)
	loc_orgasmRateMultiplier		= UDCDmain.getActorOrgasmRateMultiplier(akActor)
	loc_arousal 					= UDCDmain.getArousal(akActor)
	loc_tick 						= 1
	loc_tickS						= 0
	loc_expressionUpdateTimer 		= 0
	loc_orgasmResisting 			= akActor.isInFaction(UDCDmain.OrgasmResistFaction)
	loc_expressionApplied 			= false;ActorHaveExpressionApplied(akActor)
	loc_orgasmCapacity				= UDCDmain.getActorOrgasmCapacity(akActor)
	loc_orgasmResistence			= UDCDmain.getActorOrgasmResist(akActor)
	loc_enoughArousal 				= false
	loc_orgasmProgress 				= 0.0
	loc_orgasmProgress2				= 0.0
	loc_hornyAnimTimer 				= 0
	loc_msID 						= -1
	
	registerForSingleUpdate(0.1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	_finished = true
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("UD_OrchamsCheckScript_AME - OnEffectFinish() for " + akActor,1)
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
	(libs as zadlibs_UDPatch).ResetExpressionPatched(akActor, expression)
	
	StorageUtil.UnsetFloatValue(akActor, "UD_OrgasmProgress")

	;end mutex
	akActor.RemoveFromFaction(UDCDmain.OrgasmCheckLoopFaction)
	if UDCDmain.UD_StopActorOrgasmCheckLoop == akActor
		UDCDmain.UD_StopActorOrgasmCheckLoop = none
	endif
EndEvent

Event OnUpdate()
	if IsRunning()
		if !UDCDmain.isRegistered(akActor) && !akActor.isDead()
			akActor.DispelSpell(UDCDmain.UDlibs.OrgasmCheckSpell)
		else
			loc_orgasmProgress2 = loc_orgasmProgress
			
			loc_orgasmResisting = akActor.isInFaction(UDCDmain.OrgasmResistFaction);StorageUtil.GetIntValue(akActor,"UD_OrgasmResisting",0)
			if loc_orgasmResisting
				loc_orgasmProgress = UDCDmain.getActorOrgasmProgress(akActor)
			else
				loc_orgasmProgress += loc_orgasmRate*loc_orgasmRateMultiplier*loc_currentUpdateTime
			endif
			
			loc_orgasmRateAnti = UDCDmain.CulculateAntiOrgasmRateMultiplier(loc_arousal)*loc_orgasmResistMultiplier*(loc_orgasmProgress*(loc_orgasmResistence/100.0))*loc_currentUpdateTime  ;edging, orgasm rate needs to be bigger then UD_OrgasmResistence, else actor will not reach orgasm
			
			if !loc_orgasmResisting
				if loc_orgasmRate*loc_orgasmRateMultiplier > 0.0
					loc_orgasmProgress -= loc_orgasmRateAnti
				else
					loc_orgasmProgress -= 3*loc_orgasmRateAnti
				endif
			endif
			
			if loc_widgetShown && !loc_orgasmResisting
				UDCDmain.widget2.SetPercent(loc_orgasmProgress/loc_orgasmCapacity)
			endif

			;check orgasm
			if loc_orgasmProgress > 0.99*loc_orgasmCapacity
				if UDCDmain.TraceAllowed()			
					UDCDmain.Log("Starting orgasm for " + UDCDmain.getActorName(akActor))
				endif
				if loc_orgasmResisting
					akActor.RemoveFromFaction(UDCDmain.OrgasmResistFaction)
					;StorageUtil.SetIntValue(akActor,"UD_OrgasmResistMinigame_EndFlag",1)
				endif
				
				if loc_widgetShown
					loc_widgetShown = false
					UDCDmain.toggleWidget2(false)
					UDCDmain.widget2.SetPercent(0.0,true)
				endif
				
				loc_hornyAnimTimer = -30 ;cooldown
				
				UDCDmain.startOrgasm(akActor,UDCDmain.UD_OrgasmDuration,true)
				loc_orgasmProgress = 0.0
				UDCDmain.SetActorOrgasmProgress(akActor,loc_orgasmProgress)
			endif
			
			if loc_tick * loc_currentUpdateTime >= 1.0
				loc_orgasmRate2 = loc_orgasmRate
				if UDCDmain.ActorIsPlayer(akActor)
					loc_currentUpdateTime = UDCDmain.UD_OrgasmUpdateTime
				endif
				loc_tick = 0
				loc_tickS += 1
				
				if (loc_tickS % 2)
					loc_orgasmCapacity			= UDCDmain.getActorOrgasmCapacity(akActor)
				else
					loc_orgasmResistence 		= UDCDmain.getActorOrgasmResist(akActor)
				endif
				
				if !loc_orgasmResisting
					loc_arousal 				= UDCDmain.getArousal(akActor)
					loc_orgasmRate 				= UDCDmain.getActorOrgasmRate(akActor)
					loc_orgasmRateMultiplier	= UDCDmain.getActorOrgasmRateMultiplier(akActor)
					loc_orgasmResistMultiplier 	= UDCDmain.getActorOrgasmResistMultiplier(akActor)
					UDCDmain.SetActorOrgasmProgress(akActor,loc_orgasmProgress)
				endif

				;expression
				if loc_orgasmRate >= loc_orgasmResistence*0.75 && (!loc_expressionApplied || loc_expressionUpdateTimer > 3) 
					;init expression
					(libs as zadlibs_UDPatch).ApplyExpressionPatched(akActor, expression, UDCDmain.iRange(UDCDmain.Round(loc_orgasmProgress),25,100),false,10)
					loc_expressionApplied = true
					loc_expressionUpdateTimer = 0
				elseif loc_orgasmRate < loc_orgasmResistence*0.75 && loc_expressionApplied
					;init expression
					loc_expressionApplied = false
					(libs as zadlibs_UDPatch).ResetExpressionPatched(akActor, expression,10)
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
				if !UDCDmain.actorInMinigame(akActor)
					if (loc_orgasmRate > 0.5*loc_orgasmResistMultiplier*loc_orgasmResistence) && !loc_orgasmResisting && !akActor.IsInCombat() ;orgasm progress is increasing
						if (loc_hornyAnimTimer == 0) && !libs.IsAnimating(akActor) && UDCDmain.UD_HornyAnimation ;start horny animation for UD_HornyAnimationDuration
							if Utility.RandomInt() <= (Math.ceiling(100/UDCDmain.fRange(loc_orgasmProgress,15.0,100.0))) 
								; Select animation
								loc_cameraState = libs.StartThirdPersonAnimation(akActor, libs.AnimSwitchKeyword(akActor, "Horny01"), permitRestrictive=true)
								loc_hornyAnimTimer += UDCDmain.UD_HornyAnimationDuration
								if !loc_expressionApplied
									(libs as zadlibs_UDPatch).ApplyExpressionPatched(akActor, expression, UDCDmain.iRange(UDCDmain.Round(loc_orgasmProgress),75,100),false,10)
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
				
				if UDCDmain.UD_UseOrgasmWidget && UDCDmain.ActorIsPlayer(akActor)
					if (loc_widgetShown && loc_orgasmProgress < 2.5) ;|| (loc_widgetShown)
						UDCDmain.toggleWidget2(false)
						loc_widgetShown = false
					elseif !loc_widgetShown && loc_orgasmProgress >= 2.5
						UDCDmain.widget2.SetPercent(loc_orgasmProgress/loc_orgasmCapacity,true)
						UDCDmain.toggleWidget2(true)
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
				if loc_widgetShown
					registerForSingleUpdate(loc_currentUpdateTime)
				else
					registerForSingleUpdate(1.0)
				endif
			endif
		endif
	endif
EndEvent

bool Function IsRunning()
	return akActor.hasMagicEffect(_MagickEffect)
EndFunction
/;