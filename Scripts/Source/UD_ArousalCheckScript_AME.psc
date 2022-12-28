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

UD_PlayerSlotScript Property UD_PlayerSlot
    UD_PlayerSlotScript Function Get()
        return UDCDmain.UD_PlayerSlot
    EndFunction
EndProperty

Event OnEffectStart(Actor akTarget, Actor akCaster)
    akActor = akTarget
    loc_isplayer = UDmain.ActorIsPlayer(akActor)
    if !loc_isplayer
        return
    endif
    UD_PlayerSlot.InitArousalUpdate()
    if UDmain.TraceAllowed()
        UDCDmain.Log("UD_ArousalCheckScript_AME("+getActorName(akActor)+") - OnEffectStart()")
    endif
    registerForSingleUpdate(0.1)
EndEvent

Event OnUpdate()
    if loc_isplayer && IsRunning()
        UD_PlayerSlot.UpdateArousal(1)
        registerForSingleUpdate(1.0)
    endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    _finished = true
    if UDmain.TraceAllowed()
        UDCDmain.Log("UD_ArousalCheckScript_AME("+getActorName(akActor)+") - OnEffectFinish()",1)
    endif
    if loc_isplayer
        UD_PlayerSlot.CleanArousalUpdate()
    endif
EndEvent

bool Function IsRunning()
    return !_finished
EndFunction
