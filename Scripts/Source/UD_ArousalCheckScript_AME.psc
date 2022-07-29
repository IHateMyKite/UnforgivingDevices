Scriptname UD_ArousalCheckScript_AME extends activemagiceffect 

import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
EndProperty
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

Actor       akActor         = none
bool        _finished       = false
Bool        loc_isplayer
float       loc_updateTime  = 1.0
Float       loc_arousalRate
Int         loc_arousal ;how much is arousal increased/decreased
MagicEffect _MagickEffect   = none

Event OnEffectStart(Actor akTarget, Actor akCaster)
    _MagickEffect = GetBaseObject()
    akActor = akTarget
    akActor.AddToFaction(UDOM.ArousalCheckLoopFaction)
    if UDmain.TraceAllowed()    
        UDCDmain.Log("UD_ArousalCheckScript_AME("+getActorName(akActor)+") - OnEffectStart()")
    endif
    registerForSingleUpdate(0.1)
EndEvent

Event OnPlayerLoadGame()
    if IsRunning()
        akActor.AddToFaction(UDOM.ArousalCheckLoopFaction)
    endif
    loc_isplayer = UDmain.ActorIsPlayer(akActor)
EndEvent

Event OnUpdate()
    if IsRunning()
        if UDOM.ArousalLoopBreak(akActor,UDOM.UD_ArousalCheckLoop_ver)
            GInfo("UD_ArousalCheckScript_AME("+GetActorName(akActor)+") - ArousalLoopBreak -> dispeling")
            akActor.DispelSpell(UDCDmain.UDlibs.ArousalCheckSpell)
        else
            loc_arousalRate = UDOM.getArousalRateM(akActor)
            loc_arousal     = Math.Ceiling(loc_arousalRate)
            
            if loc_arousal > 0
                akActor.SetFactionRank(UDOM.ArousalCheckLoopFaction,UDOM.UpdateArousal(akActor ,loc_arousal))
            else
                akActor.SetFactionRank(UDOM.ArousalCheckLoopFaction,UDOM.getActorArousal(akActor))
            endif
    
            if IsRunning()
                registerForSingleUpdate(1.0)
            endif
        endif
    endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    _finished = true
    if UDmain.TraceAllowed()    
        UDCDmain.Log("UD_ArousalCheckScript_AME("+getActorName(akActor)+") - OnEffectFinish()",1)
    endif
    akActor.RemoveFromFaction(UDOM.ArousalCheckLoopFaction)
EndEvent

bool Function IsRunning()
    return !_finished
EndFunction
