Scriptname UD_CustomDevice_NPCSlot  extends ReferenceAlias

UDCustomDeviceMain Property UDCDmain auto
UD_CustomDevice_RenderScript[] Property UD_equipedCustomDevices auto
int _iUsedSlots = 0
int _iScriptState = 0
bool Property Ready = False auto

bool _DeviceManipMutex = false

Function startDeviceManipulation()
	float loc_time = 0.0
	while _DeviceManipMutex && loc_time <= 60.0
		Utility.waitMenuMode(0.1)
		loc_time += 0.1
	endwhile
	_DeviceManipMutex = true
	
	if loc_time >= 60.0
		UDCDmain.Error("startDeviceManipulation timeout!!!")
	endif
	
EndFunction

Function endDeviceManipulation()
	_DeviceManipMutex = false
EndFunction

Event OnInit()
	UD_equipedCustomDevices = UDCDMain.MakeNewDeviceSlots()
	Ready = True
EndEvent

Event OnPlayerLoadGame()
	;if GetName() == "NPCSlot_Player"
	;	ForceRefIfEmpty(Game.getPlayer())
	;endif
	;UDCDmain.registerAllEvents()
EndEvent

Function SetSlotTo(Actor akActor)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("SetSlotTo("+UDCDmain.getActorName(akActor)+") for " + self)
	endif
	if akActor != Game.GetPlayer()
		ForceRefTo(akActor)
	endif
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("SetSlotTo("+UDCDmain.getActorName(akActor)+") for " + self + ", setScriptState")
	endif
	;setScriptState(StorageUtil.GetIntValue(akActor, "UD_ScriptState", 1),False)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("SetSlotTo("+UDCDmain.getActorName(akActor)+") for " + self + ", addToFaction")
	endif
	akActor.addToFaction(UDCDmain.RegisteredNPCFaction)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("SetSlotTo("+UDCDmain.getActorName(akActor)+") for " + self + ", sendOrgasmCheckLoop")
	endif
	UDCDmain.sendOrgasmCheckLoop(akActor)
	UDCDmain.StartArousalCheckLoop(akActor)
	if akActor != Game.GetPlayer()
		regainDevices()
	endif
EndFunction

Function Init()
	
	;loc_res += "Orgasm capacity: " + getActorOrgasmCapacity(akActor) + "\n"
	;loc_res += "Orgasm resistence: " + getActorOrgasmResist(akActor) + "\n"
EndFunction

bool Function isInPlayerCell()
	if Game.getPlayer().getParentCell() == getActor().getParentCell()
		return true
	else
		return false
	endif
EndFunction

bool Function isScriptRunning()
	if _iUsedSlots > 0
		return True
	else
		return False
	endif
EndFunction

int Function getNumberOfRegisteredDevices()
	return _iUsedSlots
EndFunction

Function unregisterSlot()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("NPC " + getSlotedNPCName() + " unregistered",2)
	endif
	if _iUsedSlots
		unregisterAllDevices()
	endif
	StorageUtil.UnSetIntValue(getActor(), "UD_ManualRegister")
	_iScriptState = 0
	self.Clear()
EndFunction

Function sortSlots()
	startDeviceManipulation()
	int i = 0
	while i < UD_equipedCustomDevices.length - 1
		if UD_equipedCustomDevices[i] == none && UD_equipedCustomDevices[i + 1]
			UD_equipedCustomDevices[i] = UD_equipedCustomDevices[i + 1]
			UD_equipedCustomDevices[i + 1] = none
		endif
		
		;sorted
		if UD_equipedCustomDevices[i] == none && UD_equipedCustomDevices[i + 1] == none
			endDeviceManipulation()
			return
		endif
		
		i+=1
	endwhile
	endDeviceManipulation()
EndFunction

;removes bullshit
Function QuickFix()
	removeCopies()
	removeUnusedDevices()
EndFunction

;fix bunch of problems
Function fix()
	Int loc_res = UDCDmain.UDCD_NPCM.UD_FixMenu_MSG.show()
	if loc_res == 0 ;general fix
		UDCDmain.Print("[UD] Starting general fixes")
		UDCDMain.ResetFetchFunction()
		removeCopies()
		removeUnusedDevices()
		removeLostRenderDevices()
		;resetScriptState()
		UDCDmain.EnableActor(getActor(),true)
		;Game.EnablePlayerControls()
		getActor().removeFromFaction(UDCDmain.MinigameFaction)
		getActor().removeFromFaction(UDCDmain.BlockExpressionFaction)
		UDCDmain.libs.ResetExpression(getActor(), none)
		
		if getActor() == Game.getPlayer()
			Game.EnablePlayerControls()
			Game.SetPlayerAiDriven(False)
		else
			getActor().SetDontMove(False)
		endif
		
		getActor().RemoveFromFaction(UDCDmain.libs.zadAnimatingFaction)
		getActor().RemoveFromFaction(UDCDmain.libs.Sexlab.AnimatingFaction)
		
		UDCDmain.libs.StartBoundEffects(getActor())
		
		_DeviceManipMutex = false
		
		UDCDmain.Print("[UD] General fixes done!")
	elseif loc_res == 1 ;reset orgasm var
		StorageUtil.UnsetFloatValue(getActor(), "UD_OrgasmRate")
		StorageUtil.UnsetFloatValue(getActor(), "UD_OrgasmForcing")
		StorageUtil.UnsetFloatValue(getActor(), "UD_OrgasmResistMultiplier")
		StorageUtil.UnsetFloatValue(getActor(), "UD_OrgasmRateMultiplier")
		StorageUtil.UnsetFloatValue(getActor(), "UD_ArousalRate")
		UDCDmain.Print("[UD] Orgasm variables reseted!")
	else
	
	endif
	
EndFunction

Function removeLostRenderDevices()
	startDeviceManipulation()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("removeLostRenderDevices("+getSlotedNPCName()+")")
	endif
	Actor _currentSlotedActor = getActor()
	int iItem = _currentSlotedActor.GetNumItems()
	Form[] loc_toRemove
	while iItem
		iItem -= 1
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("removeLostRenderDevices("+getSlotedNPCName()+"): Proccesing form " + _currentSlotedActor.GetNthForm(iItem))
		endif
		Armor ArmorDevice = _currentSlotedActor.GetNthForm(iItem) as Armor
		
		if ArmorDevice ;is armor (optimalization)
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log("removeLostRenderDevices("+getSlotedNPCName()+"): Proccesing armor " + ArmorDevice)
			endif
			if ArmorDevice.haskeyword(UDCDmain.UDlibs.UnforgivingDevice) ;is render device
				;get script and check if player have inventory device
				Armor loc_RenDevice = ArmorDevice
				Armor loc_InvDevice = UDCDmain.getStoredInventoryDevice(loc_RenDevice)
				if UDCDmain.TraceAllowed()				
					UDCDmain.Log("removeLostRenderDevices("+getSlotedNPCName()+"): Proccesing device " + loc_InvDevice.getName())
				endif
				bool loc_cond = !_currentSlotedActor.isEquipped(loc_InvDevice)
				if UDCDmain.TraceAllowed()				
					UDCDmain.Log("removeLostRenderDevices("+getSlotedNPCName()+"): " + loc_InvDevice.getName() + ", cond: " + loc_cond)
				endif
				if  loc_cond
					loc_toRemove = PapyrusUtil.PushForm(loc_toRemove, ArmorDevice)
				endif
			endif
		endif
	endwhile
	
	int loc_toRemoveNum = loc_toRemove.length
	
	while loc_toRemoveNum
		loc_toRemoveNum -= 1
		_currentSlotedActor.unequipItem(loc_toRemove[loc_toRemoveNum])
		_currentSlotedActor.removeItem(loc_toRemove[loc_toRemoveNum],1)
		UDCDmain.Print(loc_toRemove[loc_toRemoveNum] + " removed!")
	endwhile
	endDeviceManipulation()
EndFunction

bool Function registerDevice(UD_CustomDevice_RenderScript oref)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Starting slot device register for " + oref.getDeviceHeader() )
	endif
	startDeviceManipulation()
	int size = UD_equipedCustomDevices.length
	int i = 0
	while i < size
		if !UD_equipedCustomDevices[i]
			UD_equipedCustomDevices[i] = oref
			_iUsedSlots+=1
			endDeviceManipulation()
			return true
		endif
		i+=1
	endwhile
	endDeviceManipulation()
	return false
EndFunction

int Function unregisterDevice(UD_CustomDevice_RenderScript oref,int i = 0,bool sort = True)
	startDeviceManipulation()
	int res = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i] == oref
			UD_equipedCustomDevices[i] = none
			_iUsedSlots-=1
			res += 1
		endif
		i+=1
	endwhile
	
	endDeviceManipulation()
	
	;if isScriptRunning() && _iUsedSlots == 0
		;resetScriptState()
	;	return res
	;endif	
	
	if isScriptRunning() && sort
		sortSlots()
	endif
	
	return res
EndFunction

int Function unregisterAllDevices(int i = 0)
	startDeviceManipulation()
	int res = 0
	while UD_equipedCustomDevices[i]
		UD_equipedCustomDevices[i] = none
		_iUsedSlots-=1
		res += 1
		i += 1
	endwhile
	endDeviceManipulation()
	return res
EndFunction

bool Function deviceAlreadyRegistered(Armor deviceInventory)
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].deviceInventory == deviceInventory
			return true
		endif
		i+=1
	endwhile
	return false
EndFunction

bool Function deviceAlreadyRegisteredKw(Keyword kw)
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].UD_DeviceKeyword == kw
			return true
		endif
		i+=1
	endwhile
	return false
EndFunction

bool FUnction deviceAlreadyRegisteredRender(Armor deviceRendered)
	int i = 0
	while UD_equipedCustomDevices[i];UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].deviceRendered == deviceRendered
			return true
		endif
		i+=1
	endwhile
	return false
	
EndFunction

Function removeAllDevices()
	;startDeviceManipulation()
	StorageUtil.SetIntValue(getActor(), "UD_blockSlotUpdate",1)
	while UD_equipedCustomDevices[0]
		UD_equipedCustomDevices[0].unlockRestrain()
	endwhile
	;regainDevices()
	StorageUtil.UnSetIntValue(getActor(), "UD_blockSlotUpdate")
	;endDeviceManipulation()
EndFunction


Function removeUnusedDevices()
	startDeviceManipulation()
	int i = 0
	while UD_equipedCustomDevices[i]
		UD_CustomDevice_RenderScript loc_device = UD_equipedCustomDevices[i]
		bool loc_condInv  =  loc_device.getWearer().getItemCount(loc_device.deviceInventory) == 0
		bool loc_condRend =  loc_device.getWearer().getItemCount(loc_device.deviceRendered)  == 0
		
		if loc_condInv || loc_condRend
			if !loc_condRend && loc_condInv ;remove render device if it for some reason doesn't removed it before
				loc_device.removeDevice(loc_device.getWearer())
				loc_device.getWearer().removeItem(loc_device.deviceRendered)
			endif
			UD_equipedCustomDevices[i] = none
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log(loc_device.getDeviceName() + " is unused, removing from " + getSlotedNPCName(),2)
			endif
			_iUsedSlots -= 1
		endif
		i+=1
	endwhile
	endDeviceManipulation()
	
	sortSlots()
EndFunction

int Function numberOfUnusedDevices()
	int res = 0
	int i = 0
	while UD_equipedCustomDevices[i]
		if !UD_equipedCustomDevices[i].getWearer().IsEquipped(UD_equipedCustomDevices[i].deviceInventory) && isPlayer()
			res += 1
		endif
		i+=1
	endwhile
	return res
EndFunction

;replece slot with new device
Function replaceSlot(UD_CustomDevice_RenderScript oref, Armor inventoryDevice)
	startDeviceManipulation()
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].deviceInventory == inventoryDevice
			UD_equipedCustomDevices[i] = oref
		endif
		i+=1
	endwhile
	endDeviceManipulation()
EndFunction

int Function getCopiesOfDevice(UD_CustomDevice_RenderScript oref)
	int res = 0
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].deviceInventory == oref.deviceInventory
			res += 1
		endif
		i+=1
	endwhile
	
	return res
EndFunction

Function removeCopies()
	;startDeviceManipulation()
	int i = 0
	while UD_equipedCustomDevices[i]
		if i < _iUsedSlots - 1
			unregisterDevice(UD_equipedCustomDevices[i],i + 1)
		endif
		i+=1
	endwhile
	;endDeviceManipulation()
EndFunction

int Function numberOfCopies()
	int res = 0
	int i = 0
	while UD_equipedCustomDevices[i]
		if i < _iUsedSlots - 1
			res += getCopiesOfDevice(UD_equipedCustomDevices[i])
		endif
		i+=1
	endwhile
	return res
EndFunction

int Function debugSize()
	int i = 0
	while UD_equipedCustomDevices[i]
		i+=1
	endwhile
	return i
EndFunction

Function orgasm()
	if UDCDmain.UDmain.UD_OrgasmExhaustion
		UDCDmain.UDmain.addOrgasmExhaustion(getActor())
	endif
	int size = UD_equipedCustomDevices.length
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].isReady()
			UD_equipedCustomDevices[i].orgasm()
		endif
		i+=1
	endwhile
EndFunction

Event OnActivateDevice(string sDeviceName)
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].deviceInventory.getName() == sDeviceName && UD_equipedCustomDevices[i].isReady()
			UD_equipedCustomDevices[i].activateDevice()
			return
		endif
		i+=1
	endwhile
EndEvent

;call devices function orgasm() when player have sexlab orgasm
Event SexlabOrgasmStart(bool HasPlayer)               
	int size = UD_equipedCustomDevices.length
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].isReady()
			UD_equipedCustomDevices[i].orgasm(True)
		endif
		i+=1
	endwhile
EndEvent 

;call devices function edge() when player get edged
Function edge()
	int size = UD_equipedCustomDevices.length
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].isReady()
			UD_equipedCustomDevices[i].edge()
		endif
		i+=1
	endwhile
EndFunction

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if isScriptRunning()
		if akSource
			if akSource as Weapon
				OnWeaponHit(akSource as Weapon)
			elseif akSource as Spell
				OnSpellHit(akSource as Spell)
			endif
		endif
	endif
EndEvent

Function OnWeaponHit(Weapon source)
	int i = 0
	while UD_equipedCustomDevices[i]
		UD_equipedCustomDevices[i].weaponHit(source)
		i+=1
	endwhile
EndFunction

Function OnSpellHit(Spell source)
	int i = 0
	while UD_equipedCustomDevices[i]
		UD_equipedCustomDevices[i].spellHit(source)
		i+=1
	endwhile	
EndFunction

Function showDebugMenu(int slot_id)
	if slot_id >= 0 && slot_id < 20 && slot_id < _iUsedSlots
	UD_CustomDevice_RenderScript selectedDevice = UD_equipedCustomDevices[slot_id]
		while UD_equipedCustomDevices[slot_id] == selectedDevice && UD_equipedCustomDevices[slot_id]
			int res = UDCDmain.DebugMessage.show(UD_equipedCustomDevices[slot_id].getDurability(),UD_equipedCustomDevices[slot_id].getMaxDurability(),100.0 - UD_equipedCustomDevices[slot_id].getCondition())
			if res == 0 ;dmg dur
				UD_equipedCustomDevices[slot_id].decreaseDurabilityAndCheckUnlock(10.0)
				if UD_equipedCustomDevices[slot_id].isUnlocked
					return
				endif
			elseif res == 1 ;repair dur
				UD_equipedCustomDevices[slot_id].decreaseDurabilityAndCheckUnlock(-10.0)
			elseif res == 2 ;repatch
				UD_equipedCustomDevices[slot_id].patchDevice()
				UDCDmain.UDPatcher.safecheckAnimations(UD_equipedCustomDevices[slot_id],True)
				UD_equipedCustomDevices[slot_id].safeCheckAnimations()
				return
			elseif res == 3 ;unlock
				UD_equipedCustomDevices[slot_id].unlockRestrain()
				return
			elseif res == 4 ;unregister
				unregisterDevice(UD_equipedCustomDevices[slot_id])
				return
			elseif res == 5 ;activate
				UD_equipedCustomDevices[slot_id].activateDevice()
				return
			elseif res == 6 ;info
				debug.messagebox(UD_equipedCustomDevices[slot_id].getInfoString())
			elseif res == 7 ;debug info
				debug.messagebox(UD_equipedCustomDevices[slot_id].getDebugString())
			else
				return
			endif
		endwhile
	endif
EndFunction

Function update(float fTimePassed)
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].isReady()
			UD_equipedCustomDevices[i].update(fTimePassed)
		endif
		i+=1
	endwhile
EndFunction

Function updateHour(float fMult)
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].isReady()
			UD_equipedCustomDevices[i].updateHour(fMult)
		endif
		i+=1
	endwhile	
EndFunction

;returns first device which have connected corresponding Inventory Device
UD_CustomDevice_RenderScript Function getDeviceByInventory(Armor deviceInventory)
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].deviceInventory == deviceInventory
			return UD_equipedCustomDevices[i]
		endif
		i+=1
	endwhile
	return none
EndFunction

;returns heavy bondage (hand restrain) device
UD_CustomDevice_RenderScript Function getHeavyBondageDevice()
	int size = UD_equipedCustomDevices.length
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(UDCDmain.libs.zad_deviousheavybondage)
			return UD_equipedCustomDevices[i]
		endif
		i+=1
	endwhile
	
	return none
EndFunction

;returs first device by keywords
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
UD_CustomDevice_RenderScript Function getFirstDeviceByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if !kw2
		kw2 = kw1
	endif
	
	if !kw3
		kw3 = kw1
	endif
	
	int i = 0
	while UD_equipedCustomDevices[i]
		if mod == 0
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				return UD_equipedCustomDevices[i]
			endif
		elseif mod == 1
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				return UD_equipedCustomDevices[i]
			endif
		endif
		i+=1
	endwhile
	return none
EndFunction

;returns last device containing keyword
UD_CustomDevice_RenderScript Function getLastDeviceByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if !kw2
		kw2 = kw1
	endif
	
	if !kw3
		kw3 = kw1
	endif
	
	int i = _iUsedSlots
	while i
		i-=1
		if mod == 0
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				return UD_equipedCustomDevices[i]
			endif
		elseif mod == 1
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				return UD_equipedCustomDevices[i]
			endif
		endif
	endwhile
	return none
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 		(device need one provided keyword)
UD_CustomDevice_RenderScript[] Function getAllDevicesByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if !kw2
		kw2 = kw1
	endif
	
	if !kw3
		kw3 = kw1
	endif
	
	UD_CustomDevice_RenderScript[] res = UDCDMain.MakeNewDeviceSlots()
	int found_devices = 0
	int size = UD_equipedCustomDevices.length
	int i = 0
	while UD_equipedCustomDevices[i]
		if mod == 0
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				res[found_devices] = UD_equipedCustomDevices[i]
				found_devices += 1
			endif
		elseif mod == 1
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				res[found_devices] = UD_equipedCustomDevices[i]
				found_devices += 1
			endif
		endif
		i+=1
	endwhile
	return res
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 		(device need one provided keyword)
UD_CustomDevice_RenderScript[] Function getAllActivableDevicesByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if !kw2
		kw2 = kw1
	endif
	
	if !kw3
		kw3 = kw1
	endif
	
	UD_CustomDevice_RenderScript[] res = UDCDMain.MakeNewDeviceSlots()
	int found_devices = 0
	int size = UD_equipedCustomDevices.length
	int i = 0
	while UD_equipedCustomDevices[i]
		if mod == 0
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				if UD_equipedCustomDevices[i].canBeActivated() && UD_equipedCustomDevices[i].isNotShareActive()
					res[found_devices] = UD_equipedCustomDevices[i]
					found_devices += 1
				endif
			endif
		elseif mod == 1
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				if UD_equipedCustomDevices[i].canBeActivated() && UD_equipedCustomDevices[i].isNotShareActive()
					res[found_devices] = UD_equipedCustomDevices[i]
					found_devices += 1
				endif
			endif
		endif
		i+=1
	endwhile
	return res
EndFunction

;returns number of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
int Function getNumberOfDevicesWithKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if !kw2
		kw2 = kw1
	endif
	
	if !kw3
		kw3 = kw1
	endif

	int found_devices = 0
	int size = UD_equipedCustomDevices.length
	int i = 0
	while UD_equipedCustomDevices[i]
		if mod == 0
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				found_devices += 1
			endif
		elseif mod == 1
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				found_devices += 1
			endif
		endif
		i+=1
	endwhile
	return found_devices
EndFunction

;returns number of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
int Function getNumberOfActivableDevicesWithKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if !kw2
		kw2 = kw1
	endif
	
	if !kw3
		kw3 = kw1
	endif

	int found_devices = 0
	int size = UD_equipedCustomDevices.length
	int i = 0
	while UD_equipedCustomDevices[i]
		if mod == 0
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				if UD_equipedCustomDevices[i].canBeActivated() && UD_equipedCustomDevices[i].isNotShareActive()
					found_devices += 1
				endif
			endif
		elseif mod == 1
			if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
				if UD_equipedCustomDevices[i].canBeActivated() && UD_equipedCustomDevices[i].isNotShareActive()
					found_devices += 1
				endif
			endif
		endif
		i+=1
	endwhile
	return found_devices
EndFunction

;returns number of devices that can be activated
int Function getActiveDevicesNum()
	int found_devices = 0
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].canBeActivated() && UD_equipedCustomDevices[i].isNotShareActive()
			found_devices += 1
		endif
		i+=1
	endwhile
	return found_devices
EndFunction

;returns all device that can be activated
UD_CustomDevice_RenderScript[] Function getActiveDevices()
	UD_CustomDevice_RenderScript[] res = UDCDMain.MakeNewDeviceSlots()
	int found_devices = 0
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].canBeActivated() && UD_equipedCustomDevices[i].isNotShareActive()
			res[found_devices] = UD_equipedCustomDevices[i]
			found_devices += 1
		endif
		i+=1
	endwhile
	return res
EndFunction


Function TurnOffAllVibrators()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("TurnOffAllVibrators() called for " + getSlotedNPCName(),1)
	endif
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
			if (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript).isVibrating()
				if UDCDmain.TraceAllowed()				
					UDCDmain.Log("Stoping " + UD_equipedCustomDevices[i].getDeviceName() + " on " + getSlotedNPCName())
				endif
				(UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript).stopVibrating()
			endif
		endif
		i+=1
	endwhile
EndFunction

;returns number of vibrators
int Function getVibratorNum()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("getVibratorNum() called for " + getSlotedNPCName(),3)
	endif
	int found_devices = 0
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
			;if (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript).CanVibrate()
				found_devices += 1
			;endif
		endif
		i+=1
	endwhile
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("getOffVibratorNum() - return value: " + found_devices,3)
	endif
	return found_devices
EndFunction

;returns number of turned off vibrators (and the ones which can be turned on)
int Function getOffVibratorNum()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("getOffVibratorNum() called for " + getSlotedNPCName(),3)
	endif
	int found_devices = 0
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
			UD_CustomVibratorBase_RenderScript loc_vibrator = (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript)
			if loc_vibrator.CanVibrate() && !loc_vibrator.isVibrating()
				found_devices += 1
			endif
		endif
		i+=1
	endwhile
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("getOffVibratorNum() - return value: " + found_devices,3)
	endif
	return found_devices
EndFunction

;returns all vibrators
UD_CustomDevice_RenderScript[] Function getVibrators()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("getVibrators() called for " + getSlotedNPCName(),3)
	endif
	UD_CustomDevice_RenderScript[] res = UDCDmain.MakeNewDeviceSlots()
	int found_devices = 0
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
			UD_CustomVibratorBase_RenderScript loc_vibrator = (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript)
			;if loc_vibrator.CanVibrate()
				if UDCDmain.TraceAllowed()				
					UDCDmain.Log("getVibrators() - usable vibrator found: " + loc_vibrator.getDeviceName(),3)
				endif
				res[found_devices] = loc_vibrator
				found_devices += 1
			;endif
		endif
		i+=1
	endwhile
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("getVibrators() - return array: " + res,3)
	endif
	return res
EndFunction

;returns all turned off vibrators
UD_CustomDevice_RenderScript[] Function getOffVibrators()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("getOffVibrators() called for " + getSlotedNPCName(),3)
	endif
	UD_CustomDevice_RenderScript[] res = UDCDmain.MakeNewDeviceSlots()
	int found_devices = 0
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log("getOffVibrators() - vibrator found: " + UD_equipedCustomDevices[i].getDeviceName(),3)
			endif
			UD_CustomVibratorBase_RenderScript loc_vibrator = (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript)
			if loc_vibrator.CanVibrate() && !loc_vibrator.isVibrating()
				if UDCDmain.TraceAllowed()				
					UDCDmain.Log("getOffVibrators() - non used vibrator found: " + UD_equipedCustomDevices[i].getDeviceName(),3)
				endif
				res[found_devices] = loc_vibrator
				found_devices += 1
			endif
		endif
		i+=1
	endwhile
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("getOffVibrators() - return array: " + res,3)
	endif
	return res
EndFunction

;???
Function deleteLastUsedSlot()
	startDeviceManipulation()
	int i = 0
	while i <  UD_equipedCustomDevices.length
		if !UD_equipedCustomDevices[i]
			UD_equipedCustomDevices[i - 1].delete()
			UD_equipedCustomDevices[i - 1] = none
			_iUsedSlots-=1
			endDeviceManipulation()
			return
		endif
		i+=1
	endwhile
	endDeviceManipulation()
EndFunction

;returns current device that have minigame on (return none if no minigame is on)
UD_CustomDevice_RenderScript Function getMinigameDevice()
	int size = UD_equipedCustomDevices.length
	int i = 0
	while UD_equipedCustomDevices[i]
		if UD_equipedCustomDevices[i].isMinigameOn()
			return UD_equipedCustomDevices[i]
		endif
		i+=1
	endwhile
	
	return none
EndFunction

bool Function hasFreeHands(bool checkGrasp = false)
	bool res = !getActor().wornhaskeyword(UDCDmain.libs.zad_deviousHeavyBondage) 
		
	if checkGrasp
		if getActor().wornhaskeyword(UDCDmain.libs.zad_DeviousBondageMittens)
			res = false
		endif
	endif
	return res
EndFunction

bool Function isPlayer()
	if (getActorReference()) == Game.getPlayer()
		return true
	else
		return false
	endif
EndFunction

bool Function isUsed()
	if getActorReference()
		return true
	else
		return false
	endif
EndFunction

String Function getSlotedNPCName()
	if isUsed()
		return (getActorReference()).getLeveledActorBase().getName()
	else
		return "Empty"
	endif
EndFunction

Actor Function getActor()
	return self.getActorReference()
EndFunction

int Function removeWrongWearerDevices()
	;startDeviceManipulation()
	int res = 0
	int i = 0
	Actor _currentSlotedActor = getActor()
	while UD_equipedCustomDevices[i]
		if (UD_equipedCustomDevices[i].getWearer() != _currentSlotedActor) || UD_equipedCustomDevices[i].isUnlocked
			res += unregisterDevice(UD_equipedCustomDevices[i],i,False)
		endif
		i+=1
	endwhile
	;endDeviceManipulation()
	if res > 0
		sortSlots()
	endif
	return res
EndFunction

Function resetValues()
	_iScriptState = 1
EndFunction

bool _regainMutex = false
Function regainDevices()
	Actor _currentSlotedActor = getActor()
	if _currentSlotedActor.GetItemCount(UDCDmain.UDlibs.PatchedInventoryDevice) == 0 || _currentSlotedActor.GetItemCount(UDCDmain.UDlibs.UnforgivingDevice) == 0
		return
	endif
	
	while _regainMutex
		Utility.waitMenuMode(0.1)
	endwhile
	_regainMutex = True
	
	;super complex shit
	int removedDevices = removeWrongWearerDevices()
	int iItem = _currentSlotedActor.GetNumItems()
	while iItem
		iItem -= 1
		Armor ArmorDevice = _currentSlotedActor.GetNthForm(iItem) as Armor
		if ArmorDevice
			if ArmorDevice.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
				;render device with custom script -> register
				if !deviceAlreadyRegistered(ArmorDevice)
					UD_CustomDevice_RenderScript script = UDCDmain.FetchDeviceByInventory(_currentSlotedActor,ArmorDevice)
					if _currentSlotedActor.getItemCount(script.DeviceInventory) && _currentSlotedActor.getItemCount(script.DeviceRendered)
						if registerDevice(script)
							UDCDmain.Log("UD_CustomDevice_NPCSlot,"+ self +"/ Device "+ script.getDeviceName() + " succesfully registered!",1)
						endif	
					endif
				endif
			endif
		endif
	endwhile
	_regainMutex = False
EndFunction
