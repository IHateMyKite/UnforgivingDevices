Scriptname UD_CustomDevices_NPCSlotsManager extends Quest  

UDCustomDeviceMain Property UDCDmain auto
Quest Property UDCD_NPCF auto ;finder
zadlibs Property libs auto
Bool Property Ready = False auto

Message Property UD_FixMenu_MSG auto

Int Property UD_Slots = 10 auto

Event OnInit()
	UD_Slots = GetNumAliases()
	int index = UD_Slots
	while index
		index -= 1
		while !(GetNthAlias(index) as UD_CustomDevice_NPCSlot).ready
			Utility.waitMenuMode(0.1)
		endwhile
		if UDCDmain.TraceAllowed()		
			UDCDMain.Log("NPCslot["+ index +"] ready!")
		endif
	endwhile
	
	

	
	;initPlayerSlot()
	;/
	
	while !UDCDmain.EventsReady 
		Utility.waitMenuMode(0.1)
	endwhile
	
	RegisterForModEvent("UD_InitPlayerSlot","InitPlayerSlot")
	
	int handle = ModEvent.Create("UD_InitPlayerSlot")
	if (handle)
        ModEvent.Send(handle)
    endif

	UnRegisterForModEvent("UD_InitPlayerSlot")
	/;
	
	registerForSingleUpdate(10.0)
	Ready = True
EndEvent


Bool _PlayerSlotReady = false
Float Property UD_SlotUpdatTime = 4.0 auto
Event OnUpdate()
	if !_PlayerSlotReady
		_PlayerSlotReady = True
		initPlayerSlot()
	endif
	
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("UD_CustomDevices_NPCSlotsManager: !!!Updating!!!",3)
	endif
	if UDCDmain.UDmain.AllowNPCSupport
		scanSlots()
	else
		;getPlayerSlot().regainDevices()
	endif
	;CheckSlots()
	RegisterForSingleUpdate(UD_SlotUpdatTime)
EndEvent

;bool _updating = false
bool Function scanSlots(bool debugMsg = False)
	;if !_updating
	;	_updating = True
		;getPlayerSlot().regainDevices()
		UDCD_NPCF.Stop()
		UDCD_NPCF.Start()
		;removeDeadNPCs()
		;resetNPCFSlots()
		updateSlotedActors(debugMsg)
		return true
	;	_updating = False
	;	return true
	;else
	;	return false
	;endif
EndFunction

Function CheckSlots()
	int index = UD_Slots - 1 ;all aliases, excluding player
	while index
		index -= 1
		UD_CustomDevice_NPCSlot loc_slot = (UDCD_NPCF.GetNthAlias(index) as UD_CustomDevice_NPCSlot)
		if loc_slot
			if loc_slot.isUsed()
				loc_slot.QuickFix()
			endif
		endif
	endwhile
EndFunction

Function resetNPCFSlots()
	int index = UD_Slots - 1 ;all aliases, excluding player
	while index
		index -= 1
		ReferenceAlias loc_refAl = (UDCD_NPCF.GetNthAlias(index) as ReferenceAlias)
		if loc_refAl.getActorReference()
			Actor loc_akActor = loc_refAl.getActorReference()
			if !isInPlayerCell(loc_akActor) && !StorageUtil.GetIntValue(loc_akActor, "UD_GlobalUpdate" , 0)
				loc_refAl.clear()
			endif
		endif
	endwhile
EndFunction

bool Function isInPlayerCell(Actor akActor)
	if Game.getPlayer().getParentCell() == akActor.getParentCell()
		return true
	else
		return false
	endif
EndFunction

Function initPlayerSlot()
	getPlayerSlot().ForceRefTo(Game.GetPlayer())
	UDCDmain.CheckOrgasmCheck(Game.GetPlayer())
	UDCDmain.CheckArousalCheck(Game.getPlayer())
	if UDCDmain.TraceAllowed()	
		UDCDMain.Log("PlayerSlot ready!")
	endif
EndFunction

Function removeDeadNPCs()
	int index = UD_Slots - 1 ;all aliases, excluding player
	while index
		index -= 1
		ReferenceAlias loc_refal = (GetNthAlias(index) as ReferenceAlias)
		if loc_refal.getActorReference()
			if loc_refal.getActorReference().isDead()
				(loc_refal as UD_CustomDevice_NPCSlot).unregisterSlot()
			endif
		endif
	endwhile
EndFunction

Function updateSlotedActors(bool debugMsg = False)
	int index = UDCD_NPCF.GetNumAliases() - 1;all slots excluding player
	int mover = 0
	while index
		index -= 1
		Actor currentSelectedActor = (UDCD_NPCF.GetNthAlias(index + mover) as ReferenceAlias).getActorReference()
		if currentSelectedActor
			if !StorageUtil.GetIntValue(currentSelectedActor, "UD_blockSlotUpdate", 0)
				UD_CustomDevice_NPCSlot slot = GetNthAlias(index) as UD_CustomDevice_NPCSlot
				Actor currentSlotActor = slot.getActor()
				if StorageUtil.GetIntValue(currentSlotActor, "UD_ManualRegister", 0)
					mover -= 1
				else
					if currentSlotActor
						if currentSelectedActor != currentSlotActor						
							currentSlotActor.RemoveFromFaction(UDCDmain.RegisteredNPCFaction)
							slot.unregisterSlot()
							
							slot.SetSlotTo(currentSelectedActor)		
							if debugMsg || UDCDmain.UDmain.DebugMod
								debug.notification("[UD]: NPC /" + slot.getSlotedNPCName() + "/ registered!")
							endif
						endif
					else
						slot.unregisterSlot()
						slot.SetSlotTo(currentSelectedActor)
						
						if debugMsg || UDCDmain.UDmain.DebugMod
							debug.notification("[UD]: NPC /" + slot.getSlotedNPCName() + "/ registered!")
						endif
					endif
					
					if slot.isUsed()
						slot.regainDevices()
					endif
				endif
			endif
		else
			UD_CustomDevice_NPCSlot slot = GetNthAlias(index) as UD_CustomDevice_NPCSlot
			if slot.isUsed() && !StorageUtil.GetIntValue(slot.getActor(), "UD_ManualRegister", 0)
				slot.unregisterSlot()
			endif
		endif
	endwhile
EndFunction

bool Function RegisterNPC(Actor akActor,bool debugMsg = false)
	int mover = 0
	Actor currentSelectedActor = akActor
	if !currentSelectedActor
		return false
	endif
	
	if isRegistered(akActor)
		return false
	endif
	
	int index = 0;UDCD_NPCF.UD_Slots - 1 ;all slots excluding player
	while index < UD_Slots - 1
		if !StorageUtil.GetIntValue(currentSelectedActor, "UD_blockSlotUpdate", 0)
			UD_CustomDevice_NPCSlot slot = GetNthAlias(index) as UD_CustomDevice_NPCSlot
			Actor currentSlotActor = slot.getActor()
			if !currentSlotActor
				slot.unregisterSlot()
				slot.SetSlotTo(currentSelectedActor)
				StorageUtil.SetIntValue(currentSelectedActor, "UD_ManualRegister", 1)
				if debugMsg || UDCDmain.UDmain.DebugMod
					debug.notification("[UD]: NPC slot ["+ index +"] => " + slot.getSlotedNPCName() + " registered!")
				endif
				return true
			endif
		endif
		index += 1
	endwhile
	return false
EndFunction

Function regainDeviceSlots(Form akActor, int slotID,String sSlotedActorName)
	getNPCSlotByIndex(slotID).regainDevices()
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByActor(Actor akActor)
	if akActor == Game.getPlayer()
		return getPlayerSlot()
	endif
	int index = UD_Slots
	while index
		index -= 1
		if (GetNthAlias(index) as ReferenceAlias).GetActorReference() == akActor
			return GetNthAlias(index) as UD_CustomDevice_NPCSlot
		endif
	endwhile
	return none
EndFunction

int Function getPlayerIndex()
	return UD_Slots - 1
EndFunction

int Function getNumSlots()
	return UD_Slots
EndFunction

bool Function isRegistered(Actor akActor)
	;if akActor == Game.getPlayer()
	;	return True
	;endif
	return akActor.isInFaction(UDCDmain.RegisteredNPCFaction)
	;/
	int index = UD_Slots
	;debug.trace("Alias num: " + index)
	while index
		index -= 1
		;debug.trace("Comparing: " + (GetNthAlias(index) as ReferenceAlias).GetActorReference() + " == " + akActor)
		if (GetNthAlias(index) as ReferenceAlias).GetActorReference() == akActor
			return True
		endif
	endwhile
	return False
	/;
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByName(string sName)
	return GetAliasByName(sName) as UD_CustomDevice_NPCSlot
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByActorName(string sName)
	if sName == Game.getPlayer().getLeveledActorBase().getName()
		return getPlayerSlot()
	endif
	int index = UD_Slots
	while index
		index -= 1
		UD_CustomDevice_NPCSlot slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
		if slot.isUsed()
			if slot.getSlotedNPCName() == sName
				return slot
			endif
		endif
	endwhile
	return none
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByIndex(int iIndex)
	return GetNthAlias(iIndex) as UD_CustomDevice_NPCSlot
EndFunction

UD_CustomDevice_NPCSlot Function getPlayerSlot()
	return GetNthAlias(UD_Slots - 1) as UD_CustomDevice_NPCSlot
EndFunction

Function update(float fTimePassed)
	int index = UD_Slots
	while index
		index -= 1
		if (GetNthAlias(index) as UD_CustomDevice_NPCSlot).isScriptRunning() && (GetNthAlias(index) as UD_CustomDevice_NPCSlot).isUsed()
			(GetNthAlias(index) as UD_CustomDevice_NPCSlot).update(fTimePassed)
		endif
	endwhile
EndFunction

Function updateHour(float fMult)
	int index = UD_Slots
	while index
		index -= 1
		if (GetNthAlias(index) as UD_CustomDevice_NPCSlot).isScriptRunning() && (GetNthAlias(index) as UD_CustomDevice_NPCSlot).isUsed()
			(GetNthAlias(index) as UD_CustomDevice_NPCSlot).updateHour(fMult)
		endif
	endwhile
EndFunction

bool Function NPCAlreadyRegistred(Actor akActor)
	return akActor.isInFaction(UDCDmain.RegisteredNPCFaction)
EndFunction

int Function numberOfFreeSlots()
	int res = 0
	int index = UD_Slots
	while index
		index -= 1
		if !((GetNthAlias(index) as UD_CustomDevice_NPCSlot).GetActorReference()) && !(GetNthAlias(index) as UD_CustomDevice_NPCSlot).isPlayer()
			res += 1
		endif
	endwhile
	return res
EndFunction

;bool Function registerNPC(Actor akActor)
;	return True
;EndFunction

bool Function unregisterNPC(Actor akActor,bool bDebugMsg = false)
	if !isRegistered(akActor)
		return false
	endif
	int index = UD_Slots - 1
	while index
		index -= 1
		UD_CustomDevice_NPCSlot slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
		Actor loc_slotedNPC = slot.getActor()
		if loc_slotedNPC == akActor
			(GetNthAlias(index) as UD_CustomDevice_NPCSlot).unregisterSlot()
			StorageUtil.UnSetIntValue(loc_slotedNPC, "UD_blockSlotUpdate")
			akActor.RemoveFromFaction(UDCDmain.RegisteredNPCFaction)
				if bDebugMsg || UDCDmain.UDmain.DebugMod
					debug.notification("[UD]: NPC slot ["+ index +"] = " + UDCDmain.getActorName(loc_slotedNPC) + " =>  unregistered!")
				endif
			return True
		endif
	endwhile
	return False
EndFunction

