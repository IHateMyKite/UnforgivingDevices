Scriptname UD_PlayerSlotScript  extends UD_CustomDevice_NPCSlot

Event OnInit()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Initiating Player Slot!!!")
	endif
	parent.OnInit()
	;UDCDmain.RegisterForModEvent("UD_OrgasmCheckLoop","OrgasmCheckLoop")
	;UDCDmain.RegisterForModEvent("UD_ArousalCheckLoop","ArousalCheckLoop")
	;setScriptState(StorageUtil.GetIntValue(Game.getPlayer(), "UD_ScriptState", 1),False)
	Game.getPlayer().addToFaction(UDCDmain.RegisteredNPCFaction)
	;UDCDmain.sendOrgasmCheckLoop(Game.getPlayer())
	;UDCDmain.StartArousalCheckLoop(Game.getPlayer())
	if UDCDmain.TraceAllowed()	
		UDCDMain.Log("PlayerSlot ready!")
	endif
EndEvent