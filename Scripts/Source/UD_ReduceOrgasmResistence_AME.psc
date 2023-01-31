Scriptname UD_ReduceOrgasmResistence_AME extends activemagiceffect  

import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto
UD_OrgasmManager _UDOM
Actor _target = none

float _appliedValue = 0.0
Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    _appliedValue = fRange(GetMagnitude()/100.0,0.01,10.0)
    _UDOM = UDmain.GetUDOM(_target)
    _UDOM.UpdateOrgasmResistMultiplier(_target,-1*_appliedValue)
    _UDOM.UpdateOrgasmRateMultiplier(_target,_appliedValue*0.5)
    _UDOM.UpdateArousalRate(_target,5.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    _UDOM.UpdateOrgasmResistMultiplier(_target,_appliedValue)
    _UDOM.UpdateOrgasmRateMultiplier(_target,-1*_appliedValue*0.5)
    _UDOM.UpdateArousalRate(_target,-5.0)
EndEvent