Scriptname UD_PlayerSlotScript  extends UD_CustomDevice_NPCSlot

Event OnInit()
    parent.OnInit()
    Game.getPlayer().addToFaction(UDCDmain.RegisteredNPCFaction)
    InitOrgasmUpdate()
EndEvent

Function update(float fTimePassed)
    if UDCDmain.UD_HardcoreMode
        UDCDmain.CheckHardcoreDisabler(UDmain.Player)
    endif
    parent.update(fTimePassed)
EndFunction

bool Function isPlayer()
    return True
EndFunction

Function AddOrgasmExhaustion()
    UDOM.addOrgasmExhaustion(getActor())
EndFunction

Function _UpdateOrgasmExhaustion(Int aiUpdateTime)
EndFunction