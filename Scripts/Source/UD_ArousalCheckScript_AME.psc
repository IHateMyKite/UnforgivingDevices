Scriptname UD_ArousalCheckScript_AME extends activemagiceffect 

UDCustomDeviceMain Property UDCDmain auto
zadlibs Property libs auto

Actor akActor = none
bool _finished = false
MagicEffect _MagickEffect = none

float loc_updateTime = 3.0

Event OnEffectStart(Actor akTarget, Actor akCaster)
	_MagickEffect = GetBaseObject()
	akActor = akTarget
	
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("ArousalCheckLoop("+UDCDmain.getActorName(akActor)+") started")
	endif
	
	registerForSingleUpdate(0.1)
EndEvent


Float loc_arousalRate
Int loc_arousal
Event OnUpdate()
	if IsRunning()
		if !UDCDmain.isRegistered(akActor) && !akActor.isDead()
			akActor.DispelSpell(UDCDmain.UDlibs.ArousalCheckSpell)
		else
			loc_arousalRate = UDCDmain.getArousalRate(akActor)
			loc_arousal = UDCDmain.Round(loc_arousalRate*loc_updateTime)
			
			if UDCDmain.TraceAllowed()	
				UDCDmain.Log("ArousalCheckLoop("+UDCDmain.getActorName(akActor)+") increasing arousal by: "+loc_arousal,3)
			endif
			
			if akActor.HasMagicEffectWithKeyword(UDCDmain.UDlibs.OrgasmExhaustionEffect_KW)
				loc_arousal = UDCDmain.Round(loc_arousal * 0.5)
			endif
			
			if loc_arousal > 0
				akActor.SetFactionRank(UDCDmain.ArousalCheckLoopFaction,UDCDmain.UpdateArousal(akActor ,loc_arousal))
			else
				akActor.SetFactionRank(UDCDmain.ArousalCheckLoopFaction,UDCDmain.getActorArousal(akActor))
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
	akActor.RemoveFromFaction(UDCDmain.ArousalCheckLoopFaction)
EndEvent

bool Function IsRunning()
	return akActor.hasMagicEffect(_MagickEffect)
EndFunction