Scriptname UD_PlayerSlotScript  extends UD_CustomDevice_NPCSlot

Event OnInit()
    parent.OnInit()
    Game.getPlayer().addToFaction(UDCDmain.RegisteredNPCFaction)
    InitOrgasmUpdate()
EndEvent

Function GameUpdate()
    UD_Native.RegisterForHMTweenMenu(self)
    ;RegisterForModEvent("UD_HMTweenMenu","OpenTweenMenu")
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

Event UDEvent_OnHMTweenMenuOpen()
    if !UDmain.IsAnyMenuOpen()
        UD_CustomDevice_RenderScript loc_hb = UDCDmain.getHeavyBondageDevice(UDmain.Player)
        if loc_hb
            loc_hb.deviceMenu(new Bool[30])
        endif
    endif
EndEvent