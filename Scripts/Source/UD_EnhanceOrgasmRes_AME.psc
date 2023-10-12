Scriptname UD_EnhanceOrgasmRes_AME extends activemagiceffect

import UnforgivingDevicesMain
import UD_Native

UnforgivingDevicesMain Property UDmain auto

UD_OrgasmManager    _UDOM
Actor               _target         =   none
Float               _appliedValue   =   0.0

string _key

Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    _UDOM = UDmain.GetUDOM(_target)
    _appliedValue = fRange(GetMagnitude()/100.0,0.00,10.00)
    _key = self
    OrgasmSystem.AddOrgasmChange(_target,_key,0,0xFFFFFFFF,0,afOrgasmRateMult = -1*_appliedValue*0.5,afOrgasmResistenceMult = _appliedValue)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    OrgasmSystem.RemoveOrgasmChange(_target,_key)
EndEvent