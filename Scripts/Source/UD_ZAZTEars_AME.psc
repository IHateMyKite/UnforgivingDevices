Scriptname UD_ZAZTears_AME extends activemagiceffect

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
EndProperty

Actor _target
int loc_type = 3
Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    if UDmain.TraceAllowed()    
        UDmain.Log("UD_ZAZTears_AME started for " + GetActorName(_target),2)
    endif
    loc_type = iRange(Round(GetMagnitude()),1,5)
    if loc_type == 5
        loc_type = Utility.randomInt(2,4)
    endif
    if UDmain.SlaveTatsInstalled
        SlaveTats.simple_add_tattoo(_target, "Tears", "Tears " + loc_type, 0, true, true)
    endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if UDmain.TraceAllowed()    
        UDmain.Log("UD_ZAZTears_AME OnEffectFinish() for " + GetActorName(_target),1)
    endif
    if UDmain.SlaveTatsInstalled
        SlaveTats.simple_remove_tattoo(_target, "Tears", "Tears " + loc_type, true, true)
    endif
EndEvent

