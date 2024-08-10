Scriptname UD_PreventCombat_AME extends ActiveMagicEffect  

import UnforgivingDevicesMain
UDCustomDeviceMain Property UDCDmain auto

Int _aggression = 0
bool _finished = false
zadlibs_UDpatch Property libsp
    zadlibs_UDpatch Function get()
        return UDCDmain.libsp
    EndFunction
EndProperty

UD_Libs Property UDlibs
    UD_Libs Function get()
        return UDCDmain.UDlibs
    EndFunction
EndProperty

Actor _target = none
Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    Evaluate()
    registerforsingleupdate(1.0)
EndEvent

Event OnUpdate()
    if !_finished
        Evaluate()
        registerforsingleupdate(2.0)
    endif
EndEvent

Function Evaluate()
    ;_target.setAV("aggression",0)
    ;_target.stopCombat()
    Actor akActor = _target
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    ;reset prevent combat
    ;actor will be calmed untill their hands are free
    _finished = true
    ;if _target.wornhaskeyword(libsp.zad_deviousheavybondage)
    ;    _target.removespell(UDlibs.PreventCombatSpell)
    ;    _target.addspell(UDlibs.PreventCombatSpell)
    ;endif
EndEvent

;removed, as it was buggy
;/
Form[] _weapons
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    bool loc_cond = true
    loc_cond = loc_cond && !akBaseObject.haskeyword(libsp.zad_Lockable)
    loc_cond = loc_cond && !akBaseObject.haskeyword(libsp.zad_inventoryDevice)
    loc_cond = loc_cond && !akBaseObject.haskeyword(libsp.zad_DeviousPlug)
    loc_cond = loc_cond && !akBaseObject.HasKeyWordString("SexLabNoStrip")
    if loc_cond
        _target.unequipItem(akBaseObject)
    endif
EndEvent
/;