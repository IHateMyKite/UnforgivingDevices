Scriptname UD_StaticNPCSlots extends UD_CustomDevices_NPCSlotsManager
{This script should be ussed on quest with alias filled with UD_CustomDevice_NPCSlot. Allow to fill slots with quest NPCs}

;NPC manager, should allways be filled
UD_CustomDevices_NPCSlotsManager Property UDNPCM hidden
    UD_CustomDevices_NPCSlotsManager Function Get()
        return UDCDmain.UDmain.UDNPCM
    EndFUnction
EndProperty

Bool Function IsManager()
    return False
EndFunction

Function AddStaticSlot(UD_StaticNPCSlots akSlots)
EndFunction
Function RemoveStaticSlot(UD_StaticNPCSlots akSlots)
EndFunction
Function ResetStaticSlots()
EndFunction

Function RegisterStaticEvents()
    RegisterForModEvent("UDRegisterStaticSlots","RegisterStaticSlots")
EndFunction

Function UnRegisterStaticEvents()
    UnRegisterForModEvent("UDRegisterStaticSlots")
EndFunction

Function RegisterStaticSlots()
    UDNPCM.AddStaticSlot(self)
EndFunction

Event OnInit()
    RegisterStaticEvents()
    RegisterStaticSlots()
    parent.OnInit()
EndEvent