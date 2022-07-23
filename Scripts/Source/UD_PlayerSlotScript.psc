Scriptname UD_PlayerSlotScript  extends UD_CustomDevice_NPCSlot

Event OnInit()
    if UDmain.TraceAllowed()    
        UDCDmain.Log("Initiating Player Slot!!!")
    endif
    parent.OnInit()
    Game.getPlayer().addToFaction(UDCDmain.RegisteredNPCFaction)
    if UDmain.TraceAllowed()    
        UDCDMain.Log("PlayerSlot ready!")
    endif
EndEvent

Function update(float fTimePassed)
    if UDCDmain.UD_HardcoreMode
        UDCDmain.CheckHardcoreDisabler(Game.GetPlayer())
    endif
    parent.update(fTimePassed)
EndFunction