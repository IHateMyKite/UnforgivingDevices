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
    _key = self
    OrgasmSystem.AddOrgasmChange(_target,_key,0,0xFFFFFFFF,0,afOrgasmResistenceMult = 0.35)
    _UDOM.UpdateArousalRateMultiplier(_target,_appliedValue_ARM)
    StorageUtil.AdjustIntValue(_target,"UD_OrgasmExhaustionNum",1)
    if UD_Native.IsPlayer(_target)
        UDMain.UDWC.StatusEffect_AdjustMagnitude("effect-orgasm", 20)
    endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Utility.wait(1.0)
    OrgasmSystem.RemoveOrgasmChange(_target,_key)
    _UDOM.UpdateArousalRateMultiplier(_target,-1*_appliedValue_ARM)
    StorageUtil.AdjustIntValue(_target,"UD_OrgasmExhaustionNum",-1)
    if UD_Native.IsPlayer(_target)
        UDMain.UDWC.StatusEffect_AdjustMagnitude("effect-orgasm", -20)
    endif
EndEvent
