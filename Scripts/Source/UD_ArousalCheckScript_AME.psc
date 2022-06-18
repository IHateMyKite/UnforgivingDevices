Scriptname UD_ArousalCheckScript_AME extends activemagiceffect 


UDCustomDeviceMain Property UDCDmain auto
zadlibs Property libs auto
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

Actor akActor = none
bool _finished = false
MagicEffect _MagickEffect = none

float loc_updateTime = 1.0

Event OnEffectStart(Actor akTarget, Actor akCaster)
	_MagickEffect = GetBaseObject()
	akActor = akTarget
	
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("ArousalCheckLoop("+UDCDmain.getActorName(akActor)+") started")
	endif
	
	registerForSingleUpdate(0.1)
EndEvent


Float loc_arousalRate
Int loc_arousal ;how much is arousal increased/decreased
Event OnUpdate()
	if IsRunning()
		if UDOM.ArousalLoopBreak(akActor,UDOM.UD_ArousalCheckLoop_ver)
			akActor.DispelSpell(UDCDmain.UDlibs.ArousalCheckSpell)
		else
			loc_arousalRate = UDOM.getArousalRate(akActor)
			loc_arousal = UDCDmain.Round(loc_arousalRate*loc_updateTime)
						
			if akActor.HasMagicEffectWithKeyword(UDCDmain.UDlibs.OrgasmExhaustionEffect_KW)
				loc_arousal = UDCDmain.Round(loc_arousal * 0.5)
			endif
			
			if loc_arousal > 0
				akActor.SetFactionRank(UDOM.ArousalCheckLoopFaction,UDOM.UpdateArousal(akActor ,loc_arousal))
			else
				akActor.SetFactionRank(UDOM.ArousalCheckLoopFaction,UDOM.getActorArousal(akActor))
			endif
	
			if IsRunning()
				registerForSingleUpdate(loc_updateTime)
			endif
		endif
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	_finished = true
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("UD_OrchamsCheckScript_AME - OnEffectFinish() for " + akActor,1)
	endif
	akActor.RemoveFromFaction(UDOM.ArousalCheckLoopFaction)
EndEvent

bool Function IsRunning()
	return akActor.hasMagicEffect(_MagickEffect)
EndFunction
