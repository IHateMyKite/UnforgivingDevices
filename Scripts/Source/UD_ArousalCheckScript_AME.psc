Scriptname UD_ArousalCheckScript_AME extends activemagiceffect 

import UnforgivingDevicesMain

UDCustomDeviceMain      Property UDCDmain auto
UnforgivingDevicesMain  Property UDmain     auto
UD_OrgasmManager        Property UDOM       auto
UD_ExpressionManager    Property UDEM       auto
zadlibs                 Property libs       auto

Actor       akActor         = none
bool        _finished       = false
Bool        loc_isplayer    = false
float       loc_updateTime  = 1.0
Float       loc_arousalRate = 0.0
Int         loc_arousal     = 0      ;how much is arousal increased/decreased
bool        loc_Is3DLoaded  = False
MagicEffect _MagickEffect   = none

Event OnEffectStart(Actor akTarget, Actor akCaster)
    _MagickEffect = GetBaseObject()
    akActor = akTarget
    akActor.AddToFaction(UDOM.ArousalCheckLoopFaction)
    loc_Is3DLoaded = loc_isplayer || akActor.Is3DLoaded()
    if UDmain.TraceAllowed()
        UDCDmain.Log("UD_ArousalCheckScript_AME("+getActorName(akActor)+") - OnEffectStart()")
    endif
    registerForSingleUpdate(0.1)
EndEvent

Event OnPlayerLoadGame()
    Utility.wait(1.0)
    if IsRunning()
        akActor.AddToFaction(UDOM.ArousalCheckLoopFaction)
    endif
    if !UDOM
        UDOM    = UDCDmain.UDOM
    endif
    if !UDEM
        UDEM    = UDCDmain.UDEM
    endif
    if !UDmain
        UDmain  = UDCDmain.UDmain
    endif
    loc_isplayer = UDmain.ActorIsPlayer(akActor)
EndEvent

Event OnUpdate()
    if IsRunning()
        if UDOM.ArousalLoopBreak(akActor,UDOM.UD_ArousalCheckLoop_ver)
            GInfo("UD_ArousalCheckScript_AME("+GetActorName(akActor)+") - ArousalLoopBreak -> dispeling")
            akActor.RemoveSpell(UDCDmain.UDlibs.ArousalCheckSpell)
            ;akActor.DispelSpell(UDCDmain.UDlibs.ArousalCheckSpell)
        else
            loc_Is3DLoaded = loc_isplayer || akActor.Is3DLoaded()
            loc_arousalRate = UDOM.getArousalRateM(akActor)
            loc_arousal     = Round(loc_arousalRate)
            
            if loc_arousal != 0
                akActor.SetFactionRank(UDOM.ArousalCheckLoopFaction,UDOM.UpdateArousal(akActor ,loc_arousal))
            else
                akActor.SetFactionRank(UDOM.ArousalCheckLoopFaction,UDOM.getActorArousal(akActor))
            endif
    
            if IsRunning()
                if loc_Is3DLoaded
                    registerForSingleUpdate(1.0) ;update once per 1 seconds
                else
                    registerForSingleUpdate(2.0) ;update once per 2 seconds
                endif
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
