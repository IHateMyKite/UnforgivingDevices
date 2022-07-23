Scriptname UD_SwimmingPenaltyScript extends activemagiceffect  
UD_SwimmingScript Property SwimmingScript auto

Actor target = none


;copied from DD
Event OnEffectStart(Actor akTarget, Actor akCaster)
;This pings skyrim to make it notice player's speed has changed!
    akTarget.DamageAv("CarryWeight", 0.02)
    akTarget.RestoreAv("CarryWeight", 0.02)
    target = akTarget
    registerForSingleUpdate(0.1)
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
;This pings skyrim to make it notice player's speed has changed!
    akTarget.DamageAv("CarryWeight", 0.02)
    akTarget.RestoreAv("CarryWeight", 0.02)
    SwimmingScript.SpellActivated = False
EndEvent

Event OnUpdate()
    if target.isSwimming()
        if !SwimmingScript.startedSwimming
            SwimmingScript.startedSwimming = True
            debug.notification("You are having hard time swimming with your hands tied!")
        endif
        target.damageAV("Stamina",SwimmingScript.fastUpdateTime * 10.0*(1 + (SwimmingScript.UD_hardcore_swimming_difficulty - 1)*0.50))
        
        if target.getAV("Stamina") <= 1.0 && !SwimmingScript.drowning
            SwimmingScript.drowning = True
            debug.notification("You are drowning!")
        endif
        
        if (target.getAV("WaterBreathing") == 0) && SwimmingScript.drowning
            target.damageAV("Health",SwimmingScript.fastUpdateTime * 10.0*(1 + (SwimmingScript.UD_hardcore_swimming_difficulty - 1)*0.50))
        endif
        registerForSingleUpdate(SwimmingScript.fastUpdateTime)
    else
        dispel()
        SwimmingScript.startedSwimming = False
        SwimmingScript.drowning = False
    endif
EndEvent
