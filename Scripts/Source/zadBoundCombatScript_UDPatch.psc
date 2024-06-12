Scriptname zadBoundCombatScript_UDPatch Extends zadBoundCombatScript Hidden

import UnforgivingDevicesMain
Function Update()
EndFunction

Function EvaluateAA(actor akActor)
    DisableWeapons(akActor)
    parent.EvaluateAA(akActor)
    EnableWeapons(akActor)
EndFunction

Function ClearAA(actor akActor)
    DisableWeapons(akActor)
    parent.ClearAA(akActor)
    EnableWeapons(akActor)
EndFunction