Scriptname UD_OrchamsCheckScript_AME extends activemagiceffect

import UnforgivingDevicesMain

UDCustomDeviceMain      Property UDCDmain   auto
UD_OrgasmManager        Property UDOM       auto
UD_ExpressionManager    Property UDEM       auto
UnforgivingDevicesMain  Property UDmain     auto
zadlibs                 Property libs       auto

UD_PlayerSlotScript _PlayerSlot
UD_PlayerSlotScript Property UD_PlayerSlot
    UD_PlayerSlotScript Function Get()
        if !_PlayerSlot
            _PlayerSlot = UDCDmain.UD_PlayerSlot
        endif
        return _PlayerSlot
    EndFunction
EndProperty

Actor       akActor         = none
bool        _finished       = false
bool        _processing     = false

;local variables
bool    loc_isplayer = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
    akActor = akTarget
    loc_isplayer = UDmain.ActorIsPlayer(akActor)
    if !loc_isplayer
        return
    endif
    if UDmain.TraceAllowed() ;only for player, because it works different for NPCs
        UDmain.Log("UD_OrchamsCheckScript_AME("+GetActorName(akActor)+") - OnEffectStart()",2)
    endif
    UD_PlayerSlot.InitOrgasmUpdate()
    registerForSingleUpdate(0.1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    _finished = true
    if UDmain.TraceAllowed() && loc_isplayer
        UDmain.Log("UD_OrchamsCheckScript_AME("+GetActorName(akActor)+") - OnEffectFinish()",1)
    endif
    if loc_isplayer
        UD_PlayerSlot.CleanOrgasmUpdate()
    endif
EndEvent

;function called on game reload (only works for player)
Function Update()
    loc_isplayer = UDmain.ActorIsPlayer(akActor)
EndFunction

Event OnUpdate()
    if loc_isplayer && IsRunning()
        UD_PlayerSlot.UpdateOrgasm(UDOM.UD_OrgasmUpdateTime)
        RegisterForSingleUpdate(UDOM.UD_OrgasmUpdateTime)
    endif
EndEvent

bool Function IsRunning()
    return !_finished
EndFunction

Event OnPlayerLoadGame()
    Update()
EndEvent