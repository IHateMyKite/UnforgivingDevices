Scriptname UD_ReduceOrgasmResistence_AME extends activemagiceffect  

import UnforgivingDevicesMain
import UD_Native

UnforgivingDevicesMain Property UDmain auto
Actor _target = none

string _key

float _appliedValue = 0.0
Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    _appliedValue = fRange(GetMagnitude()/100.0,0.01,10.0)
    _key = OrgasmSystem.MakeUniqueKey(_target,"OrgasmResistReduceME")
    OrgasmSystem.AddOrgasmChange(_target,_key,0,0x00000200,0,afOrgasmRateMult = _appliedValue*0.5,afOrgasmResistenceMult = -1*_appliedValue)
    OrgasmSystem.UpdateOrgasmChangeVar(_target,_key,9,5.0,1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    OrgasmSystem.RemoveOrgasmChange(_target,_key)
EndEvent