Scriptname UD_AbadonWeapon_AME extends ActiveMagicEffect

Import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto

Function OnEffectStart(Actor akTarget, Actor akCaster)
	Actor loc_actor = akTarget
	if !UDmain.ActorIsValidForUD(loc_actor)
		return ;non valid actor, return
	endif
	
	if loc_actor.wornhaskeyword(UDmain.libs.zad_DeviousHeavyBondage)
		return ;actor is already tied
	endif
	int loc_chance = iRange(Round(GetMagnitude()),0,100)
	if Utility.randomInt(1,99) < loc_chance
		if UDmain.TraceAllowed()
			UDmain.Log(GetActorName(akTarget) + " hit by abadon weapon. Locking device")
		endif
		UDmain.UDRRM.LockRandomRestrain(loc_actor,false,0x00000080) ;lock hand restrain
		;UDmain.UDRRM.LockAnyRandomRestrain(loc_actor,iNumber = 1)
	endif
EndFunction