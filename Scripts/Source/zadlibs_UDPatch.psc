Scriptname zadlibs_UDPatch extends zadlibs  

import MfgConsoleFunc
import sslBaseExpression

UDCustomDeviceMain Property UDCDmain auto
bool Property UD_GlobalDeviceMutex_InventoryScript = false auto
bool Property UD_GlobalDeviceMutex_InventoryScript_Failed = false auto
bool Property UD_GlobalDeviceMutex_RenderScript = false auto
Armor Property UD_GlobalDeviceMutex_Device = none auto
Actor Property UD_GlobalDeviceMutex_Actor = none auto

bool Property UD_GlobalDeviceMutex_Unlock_InventoryScript = false auto
bool Property UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed = false auto
;bool Property UD_GlobalDeviceMutex_Unlock_RenderScript = false auto
Armor Property UD_GlobalDeviceMutex_Unlock_Device = none auto
Actor Property UD_GlobalDeviceMutex_Unlock_Actor = none auto

;modified function from libs, function will end only after the device is fully equipped
bool LOCKDEVICE_MUTEX = False


bool Property UD_StartThirdPersonAnimation_Switch = true auto

Function LockDevice_Paralel(actor akActor, armor deviceInventory, bool force = false)
	UDCDmain.LockDeviceParalel(akActor,deviceInventory,force)
EndFunction

Bool Function LockDevice(actor akActor, armor deviceInventory, bool force = false)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("LockDevice called")
	endif
	if UDCDmain.UDmain.UD_zadlibs_ParalelProccesing
		LockDevice_Paralel(akActor, deviceInventory, force)
		return true
	else
		return LockDevicePatched(akActor, deviceInventory, force)
	endif
EndFunction

bool Function isMutexed(Actor akActor,Armor invDevice)
	return UD_GlobalDeviceMutex_Actor == akActor && UD_GlobalDeviceMutex_Device == invDevice
EndFunction

Bool Function LockDevicePatched(actor akActor, armor deviceInventory, bool force = false)
	while LOCKDEVICE_MUTEX
		Utility.waitMenuMode(0.15)
	endwhile
	
	LOCKDEVICE_MUTEX = True
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("LockDevicePatched("+UDCDMain.getActorName(akActor)+","+deviceInventory.getName()+") called, proccesing!")
	endif
	
	bool loc_res = false
	if deviceInventory.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
		;Debug.StartStackProfiling()
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("LockDevicePatched("+UDCDMain.getActorName(akActor)+","+deviceInventory.getName()+") (patched) called, device is UD -> using mutex")
		endif
		UD_GlobalDeviceMutex_inventoryScript = false
		UD_GlobalDeviceMutex_RenderScript = false
		UD_GlobalDeviceMutex_InventoryScript_Failed = false
		zad_AlwaysSilent.addForm(akActor)
		
		;if StorageUtil.GetIntValue(akActor,"UD_LockDeviceType"+deviceInventory,-1) == -1
		;	StorageUtil.SetIntValue(akActor,"UD_LockDeviceType"+deviceInventory,0)
		;endif
		
		UD_GlobalDeviceMutex_Device = deviceInventory
		UD_GlobalDeviceMutex_Actor = akActor
		loc_res = parent.LockDevice(akActor,deviceInventory,force)
		float loc_time = 0.0
		while loc_time <= 5.0 && (!UD_GlobalDeviceMutex_InventoryScript || !UD_GlobalDeviceMutex_RenderScript) && !UD_GlobalDeviceMutex_InventoryScript_Failed
			Utility.waitMenuMode(0.05)
			loc_time += 0.05
		endwhile
		
		if loc_time >= 5.0
			UDCDmain.Error("LockDevicePatched("+UDCDmain.getActorName(akActor)+","+deviceInventory.getName()+") timeout!!!")
		endif
		
		UD_GlobalDeviceMutex_Device = none
		UD_GlobalDeviceMutex_Actor = none
		zad_AlwaysSilent.RemoveAddedForm(akActor)
		
		
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("LockDevicePatched("+UDCDMain.getActorName(akActor)+","+deviceInventory.getName()+") (patched) called, operation completed")
		endif

	else
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("LockDevicePatched("+UDCDMain.getActorName(akActor)+","+deviceInventory.getName()+") (patched) called, device is NOT UD -> skipping mutex")
		endif
		
		loc_res = parent.LockDevice(akActor,deviceInventory,force)
		Utility.waitMenuMode(1.5) ;wait little time, so DCL work properly
	endif
	if UDCDmain.TraceAllowed()		
		UDCDmain.Log("LockDevicePatched("+UDCDMain.getActorName(akActor)+","+deviceInventory.getName()+") (patched) ended")
	endif
	LOCKDEVICE_MUTEX = False
	return loc_res
EndFunction

;modified version of UnlockDevice from zadlibs. This version makes use of registered devices from UD, making unequip procces for NPC safer and faster
bool UNLOCK_MUTEX = False
Bool Function UnlockDevice(actor akActor, armor deviceInventory, armor deviceRendered = none, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = false)
	while UNLOCK_MUTEX
		Utility.waitMenuMode(0.05)
	endwhile
	
	UNLOCK_MUTEX = True
	
	bool loc_res = False
	if UDCDmain.TraceAllowed()
		debug.trace("zad (patched): UnlockDevice("+akActor+","+deviceInventory+","+deviceRendered+","+zad_DeviousDevice+","+destroyDevice+","+genericonly+")")
	endif
	if deviceInventory.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
		;UD_CustomDevice_NPCSlot slot = UDCDmain.UDCD_NPCM.getNPCSlotByActor(akActor)
		;if slot.deviceAlreadyRegistered(deviceInventory)
			Log("UnlockDevice(patched) called for " + akActor.GetLeveledActorBase().GetName() + ": "+ deviceInventory.GetName() + ")")
			If (genericonly && deviceInventory.HasKeyWord(zad_BlockGeneric)) || deviceInventory.HasKeyWord(zad_QuestItem)
				Log("UnlockDevice(Patched) aborted because " + deviceInventory.GetName() + " is not a generic item.")
				loc_res = false
			else				
				;UD_CustomDevice_RenderScript script = slot.getDeviceByInventory(deviceInventory)
				Armor loc_renDevice = none
				if deviceRendered
					loc_renDevice = deviceRendered
				else
					loc_renDevice = UDCDmain.getStoredRenderDevice(deviceInventory)
					if loc_renDevice
						loc_renDevice = GetRenderedDevice(deviceInventory)
					endif
				endif
				
				UD_GlobalDeviceMutex_Unlock_InventoryScript = false
				UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed = false
				UD_GlobalDeviceMutex_Unlock_Device = deviceInventory
				UD_GlobalDeviceMutex_Unlock_Actor = akActor
				if akActor.getItemCount(loc_renDevice)
					StorageUtil.SetIntValue(akActor, "zad_RemovalToken" + deviceInventory, 1)
					StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0x110)
					akActor.removeItem(deviceInventory,1,True,UDCDmain.EventContainer_ObjRef)	
					UDCDmain.EventContainer_ObjRef.removeItem(deviceInventory,1,True,akActor)				
				EndIf    

				float loc_time = 0.0
				while  loc_time <= 3.0 && (!UD_GlobalDeviceMutex_Unlock_InventoryScript) && !UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed
					Utility.waitMenuMode(0.05)
					loc_time += 0.05
				endwhile
				
				if loc_time >= 3.0
					UDCDmain.Error("unlockDevice("+UDCDmain.getActorName(akActor)+","+deviceInventory.getName()+") timeout!!!")
				endif
				
				UD_GlobalDeviceMutex_Unlock_InventoryScript = false
				UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed = false
				UD_GlobalDeviceMutex_Unlock_Device = none
				UD_GlobalDeviceMutex_Unlock_Actor = none

				
				if destroyDevice
					akActor.RemoveItem(deviceInventory, 1, true)
				EndIf	
				
				loc_res = true	
			endif			
		;else
		;	loc_res = parent.UnlockDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, destroyDevice, genericonly) ;device not supported
		;endif
	else
		loc_res = parent.UnlockDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, destroyDevice, genericonly) ;actor not registered
	endif
	if UDCDmain.TraceAllowed()		
		UDCDmain.Log("UnlockDevice("+deviceInventory.getName()+") (patched) finished: "+loc_res)
	endif
	UNLOCK_MUTEX = False
	return loc_res
EndFunction

;modified version of RemoveQuestDevice from zadlibs. This version makes use of registered devices from UD,making unequip procces for NPC safer and faster
Function RemoveQuestDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, keyword RemovalToken, bool destroyDevice=false, bool skipMutex=false)
	while UNLOCK_MUTEX
		Utility.waitMenuMode(0.05)
	endwhile
	
	UNLOCK_MUTEX = True
	
	if deviceInventory.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
		;UD_CustomDevice_NPCSlot slot = UDCDmain.UDCD_NPCM.getNPCSlotByActor(akActor)
		;if slot.deviceAlreadyRegistered(deviceInventory)
			Log("RemoveQuestDevice(patched) called for " + deviceInventory.GetName())
			bool end = false
			if !akActor.IsEquipped(deviceInventory) && !akActor.IsEquipped(deviceRendered) && !end
				Warn("RemoveQuestDevice(patched) called for " + deviceInventory +", but this device is not currently worn.")
				end = True
			EndIf	
			If !deviceInventory.HasKeyword(zad_QuestItem) &&  !deviceRendered.HasKeyword(zad_QuestItem) && !end
				Log("RemoveQuestDevice(patched) aborted for " + deviceInventory.GetName() + " because it's not a quest item.")
				end = True
			EndIf
			If (!RemovalToken || zadStandardKeywords.HasForm(RemovalToken) || !(deviceInventory.HasKeyword(RemovalToken) || deviceRendered.HasKeyword(RemovalToken))) && !end
				Log("RemoveQuestDevice(patched) called for " + deviceInventory.GetName() + " with invalid removal token. Aborted.")
				end = True
			EndIf	
			if !end 			
				questItemRemovalAuthorizationToken = RemovalToken	
				StorageUtil.SetIntValue(akActor, "zad_RemovalToken" + deviceInventory, 1)
				StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0x110)
				UD_GlobalDeviceMutex_Unlock_InventoryScript = false
				UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed = false
				UD_GlobalDeviceMutex_Unlock_Device = deviceInventory
				UD_GlobalDeviceMutex_Unlock_Actor = akActor
				
				akActor.removeItem(deviceInventory,1,True,UDCDmain.EventContainer_ObjRef)	
				UDCDmain.EventContainer_ObjRef.removeItem(deviceInventory,1,True,akActor)	
				
				float loc_time = 0.0
				while  loc_time <= 3.0 && (!UD_GlobalDeviceMutex_Unlock_InventoryScript) && !UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed
					Utility.waitMenuMode(0.05)
					loc_time += 0.05
				endwhile
				
				if loc_time >= 3.0
					UDCDmain.Error("RemoveQuestDevice("+UDCDmain.getActorName(akActor)+","+deviceInventory.getName()+") timeout!!!")
				endif
				
				UD_GlobalDeviceMutex_Unlock_InventoryScript = false
				UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed = false
				UD_GlobalDeviceMutex_Unlock_Device = none
				UD_GlobalDeviceMutex_Unlock_Actor = none
				
				if destroyDevice
					akActor.RemoveItem(deviceInventory, 1, true)
				EndIf
			endif			
		;else
		;	parent.RemoveQuestDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, RemovalToken, destroyDevice, skipMutex) ;device not supported
		;endif
	else
		parent.RemoveQuestDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, RemovalToken, destroyDevice, skipMutex) ;actor not registered
	endif
	
	UNLOCK_MUTEX = False
EndFunction


;updated version to make it work for straightjackets
Armor Function GetWornRenderedDeviceByKeyword(Actor akActor, Keyword kw)
	Int slotID = GetSlotMaskForDeviceType(kw)
	if slotID == -1
		return None
	EndIf
	
	if (kw == zad_deviousHeavyBondage) && akActor.wornHasKeyword(zad_DeviousStraitJacket)
		slotID = Armor.GetMaskForSlot(32)
	endif
	Armor renderDevice = akActor.GetWornForm(slotID) As Armor 
	if renderDevice && renderDevice.HasKeyWord(zad_Lockable)
		return renderDevice
	EndIf
	return none
EndFunction

Armor Function GetWornDevice(Actor akActor, Keyword kw)
	if UDCDmain.TraceAllowed()
		debug.trace("zad (patched): GetWornDevice("+akActor+","+kw+")")
	endif
	if UDCDmain.UDCD_NPCM.isRegistered(akActor)
		UD_CustomDevice_NPCSlot slot = UDCDmain.UDCD_NPCM.getNPCSlotByActor(akActor)
		if slot.deviceAlreadyRegisteredKw(kw)
			return slot.getFirstDeviceByKeyword(kw).deviceInventory
		endif
	endif
	
	Armor retval = none
	Int iFormIndex = akActor.GetNumItems()
	bool breakFlag = false
	While iFormIndex > 0 && !breakFlag
		iFormIndex -= 1
		Form kForm = akActor.GetNthForm(iFormIndex)
		If kForm.HasKeyword(zad_InventoryDevice) && (akActor.IsEquipped(kForm) || akActor != playerRef)
			ObjectReference tmpORef = akActor.placeAtMe(kForm, abInitiallyDisabled = true)
			zadEquipScript tmpZRef = tmpORef as zadEquipScript
			if tmpZRef != none && tmpZRef.zad_DeviousDevice == kw && akActor.GetItemCount(tmpZRef.deviceRendered) > 0
				retval = kForm as Armor
				breakFlag = true
			Endif
			tmpORef.delete()
		EndIf
	EndWhile
	return retval
EndFunction

;copied and modified libs InflateAnalPlug function to make it show correct msg for npcs
Function InflateAnalPlug(actor akActor, int amount = 1)	
	If !akActor.WornHasKeyword(zad_kw_InflatablePlugAnal)
		; nothing to do
		return
	EndIf	
	int currentVal = 0
	If akActor == PlayerRef
		currentVal = zadInflatablePlugStateAnal.GetValueInt()
		; only increase the value up to 5, but make it count as an inflation event even if it's maximum inflated
		if currentVal < 5			
			currentVal += amount
			if currentVal > 5
				currentVal = 5
			EndIf
			log("Setting anal plug inflation to " + (currentVal))
			zadInflatablePlugStateAnal.SetValueInt(currentVal)
		EndIf	
		LastInflationAdjustmentAnal = Utility.GetCurrentGameTime()
	EndiF
	
	UDCDmain.UpdateArousal(akActor,20)
	UDCDmain.UpdateOrgasmRate(akActor,20.0*currentVal,0.5)
	;UDCDmain.UpdateActorOrgasmProgress(akActor,15.0*currentVal,bUpdateWidget = true)
	;SendInflationEvent(akActor, False, True, currentval)
	
	Utility.wait(2.0)
	UDCDmain.removeOrgasmRate(akActor,20.0*currentVal,0.5)
EndFunction

;copied and modified libs InflateAnalPlug function to make it show correct msg for npcs
Function InflateVaginalPlug(actor akActor, int amount = 1)	
	If !akActor.WornHasKeyword(zad_kw_InflatablePlugVaginal)
		; nothing to do
		return
	EndIf
	int currentVal = 0
	If akActor == PlayerRef
		currentVal = zadInflatablePlugStateVaginal.GetValueInt()
		; only increase the value up to 5, but make it count as an inflation event even if it's maximum inflated
		if currentVal < 5						
			currentVal += amount
			if currentVal > 5
				currentVal = 5
			EndIf
			log("Setting vaginal plug inflation to " + (currentVal))
			zadInflatablePlugStateVaginal.SetValueInt(currentVal)
		EndIf	
		LastInflationAdjustmentVaginal = Utility.GetCurrentGameTime()
	EndIf
	
	UDCDmain.UpdateArousal(akActor,30)
	UDCDmain.UpdateOrgasmRate(akActor,20.0*currentVal,0.5)
	;UDCDmain.UpdateActorOrgasmProgress(akActor,15.0*currentVal,bUpdateWidget = true)
	SendInflationEvent(akActor, True, True, currentval)
	
	Utility.wait(2.0)
	UDCDmain.removeOrgasmRate(akActor,20.0*currentVal,0.5)
EndFunction

String Function AnimSwitchKeyword(actor akActor, string idleName)
	if UDCDmain.UD_OrgasmAnimation != 0
		If idleName == "Orgasm"
			;hobbled animations
			if akActor.WornHasKeyword(zad_DeviousHobbleSkirt)
				if akActor.WornHasKeyword(zad_DeviousArmbinder)
					int random = Utility.randomInt(1,5)
					if random == 1
						return "ft_orgasm_hobbled_armbinder_1"
					elseif random == 2
						return "ft_horny_armbinder_1"
					elseif random == 3
						return "ft_horny_armbinder_2"
					elseif random == 4
						return "ft_horny_armbinder_3"
					elseif random == 5
						return "ft_horny_armbinder_7"
					endif
				ElseIf akActor.WornHasKeyword(zad_DeviousYoke)
					int random = Utility.randomInt(1,3)
					if random == 1
						return "ft_orgasm_hobbled_yoke_1"
					elseif random == 2
						return "ft_horny_yoke_1"
					elseif random == 3
						return "ft_horny_yoke_7"
					endif
				ElseIf akActor.WornHasKeyword(zad_DeviousArmbinderElbow)
					int random = Utility.randomInt(1,5)
					if random == 1
						return "ft_orgasm_hobbled_elbowbinder_1"
					elseif random == 2
						return "ft_horny_elbowbinder_1"
					elseif random == 3
						return "ft_horny_elbowbinder_2"
					elseif random == 4
						return "ft_horny_elbowbinder_3"
					elseif random == 5
						return "ft_horny_elbowbinder_7"
					endif
				ElseIf akActor.WornHasKeyword(zad_DeviousYokeBB)
					return "ft_orgasm_hobbled_bbyoke_1"
				ElseIf akActor.WornHasKeyword(zad_DeviousCuffsFront)
					return "ft_orgasm_hobbled_frontcuffs_1"
				ElseIf akActor.WornHasKeyword(zad_DeviousElbowTie)				
					return "DDElbowTie_orgasm"				
				Elseif akActor.WornHasKeyword(zad_DeviousHeavyBondage)	
					int random = Utility.randomInt(1,5)
					if random == 1
						return "ft_orgasm_hobbled_elbowbinder_1"
					elseif random == 2
						return "ft_horny_elbowbinder_1"
					elseif random == 3
						return "ft_horny_elbowbinder_2"
					elseif random == 4
						return "ft_horny_elbowbinder_3"
					elseif random == 5
						return "ft_horny_elbowbinder_7"
					endif
				else
					int random = Utility.randomInt(1,3)
					if random == 1
						return "DDZazHornyA"
					elseif random == 2
						return "DDZazHornyB"
					elseif random == 3
						return "DDZazHornyC"
					endif
				EndIf
			else ;no hobble
				if akActor.WornHasKeyword(zad_DeviousArmbinder)
					int random = Utility.randomInt(1,8)
					if UDCDmain.UDmain.ZaZAnimationPackInstalled
						random = Utility.randomInt(1,11)
					endif
					
					if random < 8
						return ("ft_horny_armbinder_" + random)
					elseif random == 8
						return "ft_orgasm_armbinder_1"
					elseif random > 8
						return ("ZapArmbHorny0" + (random - 8))
					endif
				ElseIf akActor.WornHasKeyword(zad_DeviousYoke)
					int random = Utility.randomInt(1,8)
					if UDCDmain.UDmain.ZaZAnimationPackInstalled
						random = Utility.randomInt(1,11)
					endif
					if random < 8
						return ("ft_horny_yoke_" + random)
					elseif random == 8
						return "ft_orgasm_yoke_1"
					elseif random > 8
						return ("ZapYokeHorny0" + (random - 8))
					endif
				ElseIf akActor.WornHasKeyword(zad_DeviousArmbinderElbow)
					int random = Utility.randomInt(1,8)
					if random == 1
						return "ft_horny_elbowbinder_1"
					elseif random == 2
						return "ft_horny_elbowbinder_2"
					elseif random == 3
						return "ft_horny_elbowbinder_3"
					elseif random == 4
						return "ft_horny_elbowbinder_4"
					elseif random == 5
						return "ft_horny_elbowbinder_5"
					elseif random == 6
						return "ft_horny_elbowbinder_6"
					elseif random == 7
						return "ft_horny_elbowbinder_7"
					elseif random == 8
						return "ft_orgasm_elbowbinder_1"
					endif
				ElseIf akActor.WornHasKeyword(zad_DeviousYokeBB)
					return "ft_orgasm_bbyoke_1"
				ElseIf akActor.WornHasKeyword(zad_DeviousCuffsFront)
					return "ft_orgasm_frontcuffs_1"
				ElseIf akActor.WornHasKeyword(zad_DeviousElbowTie)				
					return "DDElbowTie_orgasm"				
				Elseif akActor.WornHasKeyword(zad_DeviousHeavyBondage)	
					int random = Utility.randomInt(1,8)
					if UDCDmain.UDmain.ZaZAnimationPackInstalled
						random = Utility.randomInt(1,11)
					endif
					if random < 7
						return ("ft_horny_elbowbinder_" + random)
					elseif random == 8
						return "ft_orgasm_elbowbinder_1"
					elseif random > 8
						return ("ZapArmbHorny0" + (random - 8))
					endif
				else
					int random = Utility.randomInt(1,3)
					if random == 1
						return "DDZazHornyA"
					elseif random == 2
						return "DDZazHornyB"
					elseif random == 3
						return "DDZazHornyC"
					endif
				EndIf
			EndIf
		else
			return parent.AnimSwitchKeyword(akActor, idleName )
		endif
	else
		return parent.AnimSwitchKeyword(akActor, idleName )
	endif
EndFunction

; Stop vibration event on actor.
Function StopVibrating(actor akActor)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("zad StopVibrating(): " + akActor)
	endif
	if akActor.WornHasKeyword(UDCDmain.UDlibs.UnforgivingDevice) && UDCDmain.isRegistered(akActor)
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("zad StopVibrating() - using patched version: " + akActor)
		endif
		UDCDmain.StopAllVibrators(akActor)
		akActor.SetFactionRank(zadVibratorFaction, 0)
		akActor.RemoveFromFaction(zadVibratorFaction)
	else
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("zad StopVibrating() - using default version: " + akActor)
		endif
		parent.StopVibrating(akActor)
	endif
EndFunction

int Function VibrateEffect(actor akActor, int vibStrength, int duration, bool teaseOnly=false, bool silent = false)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("zad VibrateEffect(): " + akActor + ", " + vibStrength + ", " + duration)
	endif
	if akActor.WornHasKeyword(UDCDmain.UDlibs.UnforgivingDevice) && UDCDmain.isRegistered(akActor)
		int loc_vibNum = UDCDmain.getOffVibratorNum(akActor)
		if loc_vibNum > 0
			UD_CustomDevice_RenderScript[] loc_usableVibrators = UDCDmain.getOffVibrators(akActor)
			UD_CustomVibratorBase_RenderScript loc_selectedVib = loc_usableVibrators[Utility.randomInt(0,loc_vibNum - 1)] as UD_CustomVibratorBase_RenderScript
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log("zad VibrateEffect() - selected vib:" + loc_selectedVib)
			endif

			loc_selectedVib.forceStrength(vibStrength*20)
			loc_selectedVib.forceDuration(duration)
			loc_selectedVib.forceEdgingMode(teaseOnly as Int)
			loc_selectedVib.vibrate()
			return 0
		else
			return parent.VibrateEffect(akActor, vibStrength, duration, teaseOnly, silent)
		endif
	else
		return parent.VibrateEffect(akActor, vibStrength, duration, teaseOnly, silent)
	endif
EndFunction

Function ShockActor(actor akActor)
	if akActor == playerRef
		NotifyPlayer("The plugs within you let out a powerful electrical shock!")
	Else
		NotifyNPC(akActor.GetLeveledActorBase().GetName()+" squirms uncomfortably as electricity runs through her.")
	EndIf
	ShockEffect.RemoteCast(akActor, akActor, akActor)
	Aroused.UpdateActorExposure(akActor, Utility.randomInt(-25,-50))
EndFunction

Function ShockActorPatched(actor akActor,int iArousalUpdate = 25,float fHealth = 0.0, bool bCanKill = false)
	if UDCDmain.ActorIsPlayer(akActor)
		NotifyPlayer("You squirms uncomfortably as electricity runs through your body!")
	Else
		NotifyNPC(akActor.GetLeveledActorBase().GetName()+" squirms uncomfortably as electricity runs through her.")
	EndIf
	ShockEffect.RemoteCast(akActor, akActor, akActor)
	
	float loc_health = UDCDmain.fRange(fHealth,0.0,1000.0)
	
	if loc_health
		if akActor.getAV("Health") > loc_health || bCanKill
			akActor.damageAV("Health", loc_health)
		endif
	endif
	if iArousalUpdate
		int loc_arousalUpdate = UDCDmain.iRange(Utility.randomInt(UDCDmain.Round(0.75*iArousalUpdate),UDCDmain.Round(0.5*iArousalUpdate)),-100,100)
		Aroused.UpdateActorExposure(akActor, loc_arousalUpdate)
	endif
EndFunction

;copied with added trace check and block check
bool[] Function StartThirdPersonAnimation(actor akActor, string animation, bool permitRestrictive=false)
	if UD_StartThirdPersonAnimation_Switch
		if akActor.isInFaction(UDCDmain.BlockAnimationFaction)
			return new bool[2]
		endif
		if UDCDmain.TraceAllowed()
			Log("StartThirdPersonAnimation("+akActor.GetLeveledActorBase().GetName()+","+animation+")")
		endif
		
		if IsAnimating(akActor)
			if UDCDmain.TraceAllowed()
				Log("Actor already in animating faction.")
			endif
			return new bool[2]
		EndIf	
		;[UD EDIT]: Removed permitRestrictive as its no longer usefull
		if !IsValidActor(akActor); || (akActor.WornHasKeyword(zad_DeviousArmBinder) && !permitRestrictive)
			if UDCDmain.TraceAllowed()		
				Log("Actor is not loaded (Or is otherwise invalid). Aborting.")
			endif
			return new bool[2]
		EndIf	
		
		bool[] ret = new bool[2]
		if akActor.IsWeaponDrawn()
			akActor.SheatheWeapon()
			; Wait for users with flourish sheathe animations.
			int timeout=0
			while akActor.IsWeaponDrawn() && timeout <= 35 ;  Wait 3.5 seconds at most before giving up and proceeding.
				Utility.Wait(0.1)
				timeout += 1
			EndWhile
			ret[1] = true
		EndIf	
		;[UD EDIT]: Removed camera check as I think it's useless
		if akActor == Game.getPlayer()
			DisableControls()
		Else
			akActor.SetDontMove(true)
		EndIf	
		SetAnimating(akActor, true)	
		Debug.SendAnimationEvent(akActor, animation)	
		return ret
	else
		return parent.StartThirdPersonAnimation(akActor, animation, true)
	endif
EndFunction

;copied with added trace check and block check
Function EndThirdPersonAnimation(actor akActor, bool[] cameraState, bool permitRestrictive=false)
	if UD_StartThirdPersonAnimation_Switch
		if akActor.isInFaction(UDCDmain.BlockAnimationFaction)
			return
		endif
		if UDCDmain.TraceAllowed()	
			Log("EndThirdPersonAnimation("+akActor.GetLeveledActorBase().GetName()+","+cameraState+")")
		endif
		SetAnimating(akActor, false)
		if (!akActor.Is3DLoaded() ||  akActor.IsDead() || akActor.IsDisabled())
			if UDCDmain.TraceAllowed()	
				Log("Actor is not loaded (Or is otherwise invalid). Aborting.")
			endif
			return
		EndIf
		Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
		if akActor == Game.GetPlayer()
			UpdateControls()
		Else
			akActor.SetDontMove(false)
		EndIf
	else
		parent.EndThirdPersonAnimation(akActor, cameraState, true)
	endif
EndFunction

Function SwitchAndPlayAnimation(actor akActor, string animation, int iDuration,bool permitRestrictive=false)
	if akActor.isInFaction(UDCDmain.BlockAnimationFaction)
		return
	endif
	;StorageUtil.SetStringValue(akActor,"zad_animation",animation)
	parent.EndThirdPersonAnimation(akActor, new bool[2], true)
	PlayThirdPersonAnimationBlocking(akActor, animation,iDuration, true)
EndFunction

Function PlayThirdPersonAnimation(actor akActor, string animation, int duration, bool permitRestrictive=false)
	if akActor.isInFaction(UDCDmain.BlockAnimationFaction)
		return
	endif
	;StorageUtil.SetStringValue(akActor,"zad_animation",animation)
	parent.PlayThirdPersonAnimation(akActor, animation, duration, permitRestrictive=false)
EndFunction

bool Function PlayThirdPersonAnimationBlocking(actor akActor, string animation, int duration, bool permitRestrictive=false)
	if akActor.isInFaction(UDCDmain.BlockAnimationFaction);StorageUtil.GetIntValue(akActor,"zad_BlockAnimationManip",0)
		return false
	endif
	akActor.AddToFaction(UDCDmain.BlockAnimationFaction)
	
	if isAnimating(akActor)
		parent.EndThirdPersonAnimation(akActor, new bool[2], true)
	endif
	
	bool[] loc_cameraState = parent.StartThirdPersonAnimation(akActor, animation,permitRestrictive)
	Utility.wait(duration)
	parent.EndThirdPersonAnimation(akActor,loc_cameraState,permitRestrictive)
	
	akActor.RemoveFromFaction(UDCDmain.BlockAnimationFaction)
	return true
EndFunction

Function ActorOrgasm(actor akActor, int setArousalTo=-1, int vsID=-1)
	int loc_newArousal = 100 - setArousalTo
	if setArousalTo == -1
		loc_newArousal = 75
	endif
	ActorOrgasmPatched(akActor,20,loc_newArousal)
EndFunction

Function ActorOrgasmPatched(actor akActor,int iDuration, int iDecreaseArousalBy = 75, bool bForceAnimation = false)
	;StorageUtil.SetIntValue(akActor,"zad_orgasms", StorageUtil.GetIntValue(akActor,"zad_orgasms",0) + 1)
	UDCDmain.addOrgasmToActor(akActor)
	
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("ActorOrgasmPatched called for " + UDCDmain.GetActorName(akActor),1)
	endif
	
	SendModEvent("DeviceActorOrgasm", akActor.GetLeveledActorBase().GetName())
	
	if !UDCDmain.isRegistered(akActor)
		if UDCDmain.UDmain.UD_OrgasmExhaustion
			UDCDmain.UDmain.addOrgasmExhaustion(akActor)
		endif	
	endif
	
	int sID = OrgasmSound.Play(akActor)
	Sound.SetInstanceVolume(sid, Config.VolumeOrgasm)
	UpdateExposure(akActor,-1*iDecreaseArousalBy)
	Aroused.UpdateActorOrgasmDate(akActor)
	
	float loc_forcing = StorageUtil.getFloatValue(akActor, "UD_OrgasmForcing",0.0)
	if UDCDmain.ActorIsPlayer(akActor)
		if loc_forcing <= 0.25
			UDCDmain.Print("You have brought yourself to orgasm",2)
		elseif loc_forcing < 0.75
			UDCDmain.Print("You are cumming!",2)
		else
			UDCDmain.Print("You are forced to orgasm!",2)
		endif
	elseif UDCDmain.ActorIsFollower(akActor)
		if loc_forcing <= 0.25
			UDCDmain.Print(UDCDmain.getActorName(akActor) + " have brought themself to orgasm",3)
		elseif loc_forcing < 0.75
			UDCDmain.Print(UDCDmain.getActorName(akActor) + " is cumming!",3)
		else
			UDCDmain.Print(UDCDmain.getActorName(akActor) + " is forced to orgasm!",3)
		endif
	endif
	
	sslBaseExpression expression = UDCDmain.UDEM.getExpression("UDOrgasm")
	ApplyExpressionPatched(akActor, expression, 100,false,80)
	
	if UDCDmain.actorInMinigame(akActor)
		UDCDmain.enableActor(akActor)
		UDCDMain.getMinigameDevice(akActor).stopMinigameAndWait()
	endif
	
	if akActor.IsInCombat()  || akActor.IsSneaking()
		if UDCDmain.ActorIsPlayer(akActor)
			UDCDmain.Print("You managed to not loss control over your body from orgasm!",2)
		endif
		akActor.damageAv("Stamina",50.0)
		akActor.damageAv("Magicka",50.0)
		if UDCDmain.actorInMinigame(akActor)
			EndThirdPersonAnimation(akActor, new Bool[2],true)
		endif
		Utility.wait(iDuration)
	else
		if !IsAnimating(akActor) || bForceAnimation
			PlayThirdPersonAnimationBlocking(akActor,AnimSwitchKeyword(akActor, "Orgasm"), iDuration, true)
		else
			if UDCDmain.actorInMinigame(akActor)
				EndThirdPersonAnimation(akActor, new Bool[2],true)
			endif
			Utility.wait(iDuration)
		EndIf
	endif
	ResetExpressionPatched(akActor, expression,80)
	UDCDmain.RemoveOrgasmFromActor(akActor)
EndFunction

bool _UpdateExposure_Mutex = false
Function UpdateExposure(actor akRef, float val, bool skipMultiplier=false)
	If (akRef == None)
		Error("UpdateExposure passed none reference.")
		return
	EndIf
	
	while _UpdateExposure_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_UpdateExposure_Mutex = true
	float lastRank = Aroused.GetActorExposure(akRef)
	if skipMultiplier
		; This function is very slow, and sometimes hangs for multiple seconds (Seen 10+). Directly access internals as a work-around.
		; Aroused.SetActorExposure(akRef, (lastRank + val + 1) as Int)
		float newVal = lastRank + val
		if newVal > 100
			newVal = 100
		EndIf
		;StorageUtil.SetFloatValue(akRef, "SLAroused.ActorExposure", newVal)
		;StorageUtil.SetFloatValue(akRef, "SLAroused.ActorExposureDate", Utility.GetCurrentGameTime())
		Aroused.SetActorExposure(akRef, Math.Floor(newVal + 1))
	Else
		float rate = Aroused.GetActorExposureRate(akRef)
		int newRank = (lastRank + (val as float) * rate) as int	
		Aroused.SetActorExposure(akRef, newRank)
	EndIf
	_UpdateExposure_Mutex = false
EndFunction


;check expression blocking with priority
;mode 1 = sets blocking if priority is met
;mode 2 = resets blocking if priority is met
bool Function CheckExpressionBlock(Actor akActor,int iPriority, int iMode = 0)
	if !akActor.isInFaction(UDCDmain.BlockExpressionFaction)
		if iMode == 1
			akActor.AddToFaction(UDCDmain.BlockExpressionFaction)
			akActor.SetFactionRank(UDCDmain.BlockExpressionFaction,iPriority)
		endif
		return true
	endif

	if iPriority >= akActor.GetFactionRank(UDCDmain.BlockExpressionFaction)
		if iMode == 1 ;set blocking priority
			akActor.SetFactionRank(UDCDmain.BlockExpressionFaction,iPriority)
		elseif iMode == 2 ;reset blocking priority
			akActor.SetFactionRank(UDCDmain.BlockExpressionFaction,0)
		endif
		return true
	else
		return false
	endif
	
EndFunction

bool _ExpressionManip_Mutex = false
bool Function ApplyExpressionPatched(Actor akActor, sslBaseExpression expression, int strength, bool openMouth=false,int iPriority = 0)
	if !IsValidActor(akActor)
		if UDCDmain.TraceAllowed()		
			Log("ApplyExpressionPatched(): Actor is not loaded (Or is otherwise invalid). Aborting.")
		endif
		return false
	EndIf
	if !expression
		if UDCDmain.TraceAllowed()		
			Log("ApplyExpressionPatched(): Expression is none.")
		endif
		return false
	EndIf
	
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("(Patched) Expression " + expression + " applied for " + UDCDmain.getActorName(akActor) +", strength: " + strength + ",mouth?: " + openMouth)
	endif
	
	while _ExpressionManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_ExpressionManip_Mutex = true
	
	if !CheckExpressionBlock(akActor,iPriority,1)
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("(Patched) Expression " + expression + " is blocked for " + UDCDmain.getActorName(akActor) +", strength: " + strength + ",mouth?: " + openMouth)
		endif
		_ExpressionManip_Mutex = false
		return false
	endif
	
	UDCDmain.SendSetExpressionEvent(akActor, expression, strength, openMouth)
	;SetExpression(akActor, expression, strength, openMouth)
	;/
	;StorageUtil.SetIntValue(akActor,"zad_expressionApplied",1)
	int gender = (akActor.GetBaseObject() as ActorBase).GetSex()
	bool hasGag = akActor.WornHasKeyword(zad_DeviousGag)
	
	float[] loc_expression = expression.GenderPhase(expression.CalcPhase(Strength, Gender), Gender)
	float[] loc_appliedExpression = GetCurrentMFG(akActor) 

	if hasGag
		loc_expression = ApplyGagEffectToPreset(akActor,loc_expression)
	elseif openMouth
		loc_expression[expression.Phoneme + 0] = 0.75
	endif
	
	if loc_expression != loc_appliedExpression
		ApplyPresetFloats_NOMC(akActor, loc_expression)
	endif
	/;
	_ExpressionManip_Mutex = false
	return true
EndFunction

Function SetExpression(Actor akActor, sslBaseExpression expression, int strength, bool openMouth=false)
	;StorageUtil.SetIntValue(akActor,"zad_expressionApplied",1)
	int gender = (akActor.GetBaseObject() as ActorBase).GetSex()
	bool hasGag = akActor.WornHasKeyword(zad_DeviousGag)
	
	float[] loc_expression = expression.GenderPhase(expression.CalcPhase(Strength, Gender), Gender)
	float[] loc_appliedExpression = GetCurrentMFG(akActor) 

	if hasGag
		loc_expression = ApplyGagEffectToPreset(akActor,loc_expression)
	elseif openMouth
		loc_expression[expression.Phoneme + 0] = 0.75
	endif
	
	if loc_expression != loc_appliedExpression
		ApplyPresetFloats_NOMC(akActor, loc_expression)
	endif
EndFunction

Function ResetExpressionPatched(actor akActor, sslBaseExpression expression,int iPriority = 0)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Expression " + expression + " reset for " + UDCDmain.getActorName(akActor))
	endif
	
	while _ExpressionManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	
	_ExpressionManip_Mutex = true
	if !CheckExpressionBlock(akActor,iPriority,0)
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("(Patched) Expression " + expression + " is blocked for " + UDCDmain.getActorName(akActor))
		endif
		_ExpressionManip_Mutex = false
		return
	endif
	if !akActor.WornHasKeyword(zad_DeviousGag)
		;MfgConsoleFunc.ResetPhonemeModifier(akActor) ;reset all
		MfgConsoleFunc.SetPhonemeModifier(akActor, -1, 0, 0)
		akActor.ClearExpressionOverride()
	else
		;reset only expression without phonems
		float[] loc_appliedExpression = GetCurrentMFG(akActor)
		int loc_i = 16
		while loc_i < 30
			loc_appliedExpression[loc_i] = 0
			loc_i += 1
		endWhile
		ApplyPresetFloats_NOMC(akActor, loc_appliedExpression)
		akActor.ClearExpressionOverride()
	endif
	akActor.SetFactionRank(UDCDmain.BlockExpressionFaction,0)
	
	_ExpressionManip_Mutex = false
EndFunction

Function ApplyExpression(Actor akActor, sslBaseExpression expression, int strength, bool openMouth=false)
	ApplyExpressionPatched(akActor, expression, strength, openMouth,0)
	;parent.ApplyExpression(akActor,expression,strength,openMouth)
EndFunction

Function ResetExpression(actor akActor, sslBaseExpression expression)
	ResetExpressionPatched(akActor, expression,0)
EndFunction

Function ApplyGagEffect(actor akActor)	
	while _ExpressionManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_ExpressionManip_Mutex = true
	float[] loc_appliedExpression = GetCurrentMFG(akActor)
	float[] loc_expression = ApplyGagEffectToPreset(akActor,loc_appliedExpression)

	if loc_expression != loc_appliedExpression
		ApplyPresetFloats_NOMC(akActor, loc_expression)
	endif
	_ExpressionManip_Mutex = false
EndFunction

Function RemoveGagEffect(actor akActor)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("RemoveGagEffect called",2)
	endif
	while _ExpressionManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_ExpressionManip_Mutex = true
	If akActor.WornHasKeyword(zad_GagCustomExpression)
		SendGagEffectEvent(akActor, false)
		_ExpressionManip_Mutex = false
		Return
	EndIf
	;reset only expression without phonems
	float[] loc_appliedExpression = GetCurrentMFG(akActor)
	int loc_i = 0
	while loc_i < 16
		loc_appliedExpression[loc_i] = 0.0
		loc_i += 1
	endWhile
	ApplyPresetFloats_NOMC(akActor, loc_appliedExpression)
	_ExpressionManip_Mutex = false
EndFunction

float[] Function ApplyGagEffectToPreset(Actor akActor,Float[] preset)
	float[] loc_preset = Utility.CreateFloatArray(preset.length)
	
	int i = preset.length
	while i
		i -= 1
		loc_preset[i] = preset[i]
	endwhile
	
	int loc_i = 16
	while loc_i
		loc_i -= 1
		loc_preset[loc_i] = 0.0
	endWhile
	
	; apply this affect to actual gags only, not hoods that also share this keyword.
	If akActor.WornHasKeyword(zad_GagCustomExpression)
		SendGagEffectEvent(akActor, false)
	elseIf akActor.WornHasKeyword(zad_GagNoOpenMouth)
		;close mouth, reset phonems
		return loc_preset
	elseIf akActor.WornHasKeyword(zad_DeviousGagLarge)
		loc_preset[0] = 1.0
		loc_preset[1] = 1.0
		loc_preset[11] = 0.30

		loc_preset[16 + 4] = 1.00
		loc_preset[16 + 5] = 1.00
		loc_preset[16 + 6] = 1.00
		loc_preset[16 + 7] = 1.00	
	else
		if !akActor.wornhaskeyword(zad_DeviousGagPanel)
			loc_preset[0 + 0] = (UDCDmain.UD_GagPhonemModifier as float)/100.0
		else
			loc_preset[0 + 0] = 0 ;panel is clipping when this value is > 0
		endif
		loc_preset[0 + 1] = 1.0
		loc_preset[0 + 11] = 0.70		
	EndIf
	return loc_preset
EndFunction

;COPIED FROM sslBaseExpression because it will otherwise not work for SE because of MouthOpen check 
function ApplyPresetFloats_NOMC(Actor ActorRef, float[] Preset) global 
	int i
	; Set Phoneme
	int p
	while p <= 15
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, (Preset[i] * 100.0) as int)
		i += 1
		p += 1
	endWhile
	; Set Modifers
	int m
	while m <= 13
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 1, m, (Preset[i] * 100.0) as int)
		i += 1
		m += 1
	endWhile
	; Set expression
	ActorRef.SetExpressionOverride(Preset[30] as int, (Preset[31] * 100.0) as int)
endFunction


Event StartBoundEffects(Actor akTarget)
	UDCDmain.SendStartBoundEffectEvent(akTarget)
	;parent.StartBoundEffects(akTarget)
EndEvent

Event StartBoundEffectsPatched(Actor akTarget)
	parent.StartBoundEffects(akTarget)
EndEvent

Armor Function GetRenderedDevice(armor device)

	if device.haskeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
		Armor loc_res = StorageUtil.GetFormValue(device, "UD_RenderDevice", none) as Armor
		if loc_res
			if UDCDmain.TraceAllowed()		
				UDCDmain.Log("GetRenderedDevice(patched)("+device.getName()+")called, returning " + loc_res)
			endif
			return loc_res
		endif
	endif
	return parent.GetRenderedDevice(device)
EndFunction