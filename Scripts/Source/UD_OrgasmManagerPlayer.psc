Scriptname UD_OrgasmManagerPlayer extends UD_OrgasmManager conditional

import UnforgivingDevicesMain
import UD_Native

bool    _crit               = false
bool    _specialButtonOn    = false
string  _crit_meter         = "UDmain.Error"

Function RegisterModEvents()
    _OrgasmEventName = "UD_OrgasmPlayer"
    _UpdateBaseOrgasmValEventName = "UD_UpdateBaseOrgasmValPlayer"
    RegisterForModEvent("UD_CritUpdateLoopStart_OrgasmResist","CritLoopOrgasmResist")
    RegisterForModEvent(_UpdateBaseOrgasmValEventName, "Receive_UpdateBaseOrgasmVals")
    RegisterForModEvent(_OrgasmEventName,"Orgasm")
EndFunction

;///////////////////////////////////////
;=======================================
;ORGASM RESIST MINIGAME
;=======================================
;//////////////////////////////////////;

;=======================================
;ORGASM _crit FUNCTIONS
;=======================================

bool _PlayerOrgasmResist_MinigameOn = false
Function sendOrgasmResistCritUpdateLoop(Int aiChance,Float afDifficulty)
EndFunction

Function CritLoopOrgasmResist(Int aiChance,Float afDifficulty)
EndFunction

Function OnCritSuccesOrgasmResist()
EndFunction

Event MinigameKeysRegister()
EndEvent

Event MinigameKeysUnregister()
EndEvent

Event OnKeyDown(Int KeyCode)
EndEvent

Event OnKeyUp(Int KeyCode, Float HoldTime)
EndEvent

String[] _HornyAnimDefs
Int _ActorConstraints = -1

;=======================================
;ORGASM RESIST LOOP
;=======================================
Function FocusOrgasmResistMinigame(Actor akActor)
EndFunction