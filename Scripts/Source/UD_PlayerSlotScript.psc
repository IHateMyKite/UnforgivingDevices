Scriptname UD_PlayerSlotScript  extends UD_CustomDevice_NPCSlot

Event OnInit()
    parent.OnInit()
    Game.getPlayer().addToFaction(UDCDmain.RegisteredNPCFaction)
    InitOrgasmUpdate()
EndEvent

Function GameUpdate()
    RegisterForModEvent("UD_HMTweenMenu","OpenTweenMenu")
    parent.GameUpdate()
EndFunction

bool Function isPlayer()
    return True
EndFunction

Function AddOrgasmExhaustion()
    UDOM.addOrgasmExhaustion(getActor())
EndFunction

Function _UpdateOrgasmExhaustion(Int aiUpdateTime)
EndFunction

Actor Function GetActor()
    return UDmain.Player
EndFunction

Event OpenTweenMenu(String asEventName, String asUnused, Float afUnused, Form akUnused)
    UDCDmain.getHeavyBondageDevice(UDmain.Player).deviceMenu(new Bool[30])
EndEvent