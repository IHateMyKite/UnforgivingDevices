Scriptname zadBoundCombatScript_UDPatch Extends zadBoundCombatScript Hidden

import UnforgivingDevicesMain
import UD_Native
Function Update()
EndFunction

Function SheatWeapons(Actor akActor)
    akActor.SheatheWeapon()
    while (akActor.IsWeaponDrawn())
        Utility.wait(0.1)
    endwhile
EndFunction

Function EvaluateAA(actor akActor)
    ;GInfo("EvaluateAA::UD_Native.DisableWeapons("+GetActorName(akActor)+",true)")
    UD_Native.DisableWeapons(akActor,true)
    SheatWeapons(akActor)
    parent.EvaluateAA(akActor)
    ;GInfo("EvaluateAA::UD_Native.DisableWeapons("+GetActorName(akActor)+",false)")
    UD_Native.DisableWeapons(akActor,false)
EndFunction

Function ClearAA(actor akActor)
    ;GInfo("ClearAA::UD_Native.DisableWeapons("+GetActorName(akActor)+",true)")
    UD_Native.DisableWeapons(akActor,true)
    SheatWeapons(akActor)
    parent.ClearAA(akActor)
    ;GInfo("ClearAA::UD_Native.DisableWeapons("+GetActorName(akActor)+",false)")
    UD_Native.DisableWeapons(akActor,false)
EndFunction