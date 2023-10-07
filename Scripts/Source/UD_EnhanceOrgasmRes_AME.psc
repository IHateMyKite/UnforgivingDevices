Scriptname UD_EnhanceOrgasmRes_AME extends activemagiceffect

import UnforgivingDevicesMain
import UD_Native

UnforgivingDevicesMain Property UDmain auto

UD_OrgasmManager    _UDOM
Actor               _target         =   none
Float               _appliedValue   =   0.0

Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    _UDOM = UDmain.GetUDOM(_target)
    _appliedValue = fRange(GetMagnitude()/100.0,0.00,10.00)
    _UDOM.UpdateOrgasmResistMultiplier(_target,_appliedValue)
    _UDOM.UpdateOrgasmRateMultiplier(_target,-1*_appliedValue*0.5)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    _UDOM.UpdateOrgasmResistMultiplier(_target,-1*_appliedValue)
    _UDOM.UpdateOrgasmRateMultiplier(_target,_appliedValue*0.5)
EndEvent