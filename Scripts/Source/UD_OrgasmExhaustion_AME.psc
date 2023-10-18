Scriptname UD_OrgasmExhaustion_AME extends activemagiceffect

UnforgivingDevicesMain Property UDmain auto
UD_OrgasmManager _UDOM
Actor _target = none
float _appliedValue_ARM = 0.0
bool _ARMApplied = false

string _key

Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    _appliedValue_ARM = -0.1
    _UDOM = UDmain.GetUDOM(_target)
    _key = OrgasmSystem.MakeUniqueKey(_target,"OrgasmExhaustionME")
    OrgasmSystem.AddOrgasmChange(_target,_key,0,0xFFFFFFFF,afOrgasmRateMult = -0.1, afOrgasmResistenceMult = 0.35)
    OrgasmSystem.UpdateOrgasmChangeVar(_target,_key,10,_appliedValue_ARM,1)
    
    StorageUtil.AdjustIntValue(_target,"UD_OrgasmExhaustionNum",1)
    if UD_Native.IsPlayer(_target)
        UDMain.UDWC.StatusEffect_AdjustMagnitude("effect-orgasm", 20)
    endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    OrgasmSystem.RemoveOrgasmChange(_target,_key)
    Utility.wait(1.0)
    StorageUtil.AdjustIntValue(_target,"UD_OrgasmExhaustionNum",-1)
    if UD_Native.IsPlayer(_target)
        UDMain.UDWC.StatusEffect_AdjustMagnitude("effect-orgasm", -20)
    endif
EndEvent
