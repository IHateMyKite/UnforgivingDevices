Scriptname UD_OrgasmExhaustion_AME extends activemagiceffect

UnforgivingDevicesMain Property UDmain auto
UD_OrgasmManager _UDOM
Actor _target = none
float _appliedValue = 0.0
float _appliedValue_ARM = 0.0
bool _ARMApplied = false
Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    _appliedValue = 0.35
    _appliedValue_ARM = -0.1
    _UDOM = UDmain.GetUDOM(_target)
    _UDOM.UpdateOrgasmResistMultiplier(_target,_appliedValue)
    _UDOM.UpdateArousalRateMultiplier(_target,_appliedValue_ARM)
    StorageUtil.AdjustIntValue(_target,"UD_OrgasmExhaustionNum",1)
    if UDmain.ActorIsPlayer(_target)
        UDMain.UDWC.StatusEffect_AdjustMagnitude("effect-orgasm", 20)
    endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Utility.wait(1.0)
    if _appliedValue
        _UDOM.UpdateOrgasmResistMultiplier(_target,-1*_appliedValue)
    endif
    if _appliedValue_ARM
        _UDOM.UpdateArousalRateMultiplier(_target,-1*_appliedValue_ARM)
    endif
    if _appliedValue || _appliedValue_ARM
        StorageUtil.AdjustIntValue(_target,"UD_OrgasmExhaustionNum",-1)
    endif
    if UDmain.ActorIsPlayer(_target)
        UDMain.UDWC.StatusEffect_AdjustMagnitude("effect-orgasm", -20)
    endif
EndEvent
