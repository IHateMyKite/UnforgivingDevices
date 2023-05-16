Scriptname UD_CustomDeviceExhaustion_MagEffect extends activemagiceffect  

UnforgivingDevicesMain Property UDmain auto
UD_ExpressionManager Property UDEM
    UD_ExpressionManager Function get()
        return UDmain.UDEM
    EndFunction
EndProperty
Actor _target = none
MagicEffect _MagickEffect = none
float[] _expression
Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget 
    _MagickEffect = GetBaseObject()
    _expression = UDEM.GetPrebuildExpression_Tired1()
    UDEM.ApplyExpressionRaw(_target, _expression, 30,false,5)
    StorageUtil.AdjustIntValue(_target,"UD_DeviceExhaustionNum",1)
    if UDmain.ActorIsPlayer(_target)
        registerForSingleUpdate(0.1)
        UDMain.UDWC.StatusEffect_AdjustMagnitude("effect-exhaustion", 20)
        ;Game.SetInChargen(false, true, false)
    endif
EndEvent

bool _finish = false
Event OnEffectFinish(Actor akTarget, Actor akCaster)
    _finish = true
    StorageUtil.AdjustIntValue(_target,"UD_DeviceExhaustionNum",-1)
    if UDmain.ActorIsPlayer(_target)
        Game.SetInChargen(false, false, false)
        UDMain.UDWC.StatusEffect_AdjustMagnitude("effect-exhaustion", -20)
    endif
    if !_target.hasMagicEffect(_MagickEffect)
        UDEM.ResetExpressionRaw(_target,10)
    endif
EndEvent

Event OnUpdate()
    if !_finish
        Game.SetInChargen(false, true, false)
        UDEM.ApplyExpressionRaw(_target, _expression, 30,false,5)
        registerForSingleUpdate(3.0)
    endif
EndEvent
