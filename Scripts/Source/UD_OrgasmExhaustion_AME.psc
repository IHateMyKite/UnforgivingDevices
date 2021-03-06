Scriptname UD_OrgasmExhaustion_AME extends activemagiceffect

UD_OrgasmManager Property UDOM auto
Actor _target = none
float _appliedValue = 0.0
float _appliedValue_ARM = 0.0
bool _ARMApplied = false
Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    _appliedValue = 0.35
    _appliedValue_ARM = -0.1
    UDOM.UpdateOrgasmResistMultiplier(_target,_appliedValue)
    UDOM.UpdateArousalRateMultiplier(_target,_appliedValue_ARM)
    StorageUtil.AdjustIntValue(_target,"UD_OrgasmExhaustionNum",1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if _appliedValue
        UDOM.removeOrgasmResistMultiplier(_target,_appliedValue)
    endif
    if _appliedValue_ARM
        UDOM.UpdateArousalRateMultiplier(_target,-1*_appliedValue_ARM)
    endif
    if _appliedValue || _appliedValue_ARM
        if StorageUtil.GetIntValue(_target,"UD_OrgasmExhaustionNum",0) > 0
            StorageUtil.AdjustIntValue(_target,"UD_OrgasmExhaustionNum",-1)
        endif
    endif
EndEvent
