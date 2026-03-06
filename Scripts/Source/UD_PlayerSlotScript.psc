Scriptname UD_PlayerSlotScript  extends UD_CustomDevice_NPCSlot

Function Setup()
    parent.Setup()
    Game.getPlayer().addToFaction(UDCDmain.RegisteredNPCFaction)
    InitOrgasmUpdate()
    UD_Native.RegisterForHMTweenMenu(self)
    RegisterEmptyItemEvent()
EndFunction

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
    if (UD_Native.GetCameraState() != 3) && !UDmain.IsAnyMenuOpen()
        UD_CustomDevice_RenderScript loc_hb = UDCDmain.getHeavyBondageDevice(UDmain.Player)
        if loc_hb
            loc_hb.deviceMenu(new Bool[30])
        endif
    endif
EndEvent
