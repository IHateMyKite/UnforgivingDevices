Scriptname zadlibs_UDPatch extends zadlibs  

import MfgConsoleFunc
import sslBaseExpression
import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto

UD_MutexManagerScript Property UDMM
	UD_MutexManagerScript Function get()
		return UDCDMain.UDmain.UDMM
	EndFunction
EndProperty

bool Property UD_GlobalDeviceMutex_Unlock_InventoryScript = false auto
bool Property UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed = false auto
;bool Property UD_GlobalDeviceMutex_Unlock_RenderScript = false auto
Armor Property UD_GlobalDeviceMutex_Unlock_Device = none auto
Actor Property UD_GlobalDeviceMutex_Unlock_Actor = none auto

bool Property UD_StartThirdPersonAnimation_Switch = true auto
;modified function from libs, function will end only after the device is fully equipped
bool LOCKDEVICE_MUTEX = False

bool _installing = false
Function OnInit()
	_installing = true
	while !UDCDMain.Ready
		Utility.waitMenuMode(5.0)
	endwhile
	_installing = false
EndFunction

Function ResetMutex()
	LOCKDEVICE_MUTEX = false
	UNLOCK_MUTEX = false
EndFunction

Function StartLockMutex()
	while LOCKDEVICE_MUTEX
		Utility.waitMenuMode(0.05)
	endwhile
	LOCKDEVICE_MUTEX = True
EndFunction
Function EndLockMutex()
	LOCKDEVICE_MUTEX = False
EndFunction
Function ResetLockMutex(Actor akActor,Armor deviceInventory)
	;UDCDMain.MutexActor(akActor)
EndFunction

Function LockDevice_Paralel(actor akActor, armor deviceInventory, bool force = false)
	UDCDmain.LockDeviceParalel(akActor,deviceInventory,force)
EndFunction

Bool Function LockDevice(actor akActor, armor deviceInventory, bool force = false)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("LockDevice("+MakeDeviceHeader(akActor,deviceInventory)+")",3)
	endif
	if UDCDmain.UDmain.UD_zadlibs_ParalelProccesing
		LockDevice_Paralel(akActor, deviceInventory, force)
		return true
	else
		return LockDevicePatched(akActor, deviceInventory, force)
	endif
EndFunction

bool Function isMutexed(Actor akActor,Armor invDevice)
	return UDMM.IsDeviceMutexed(akActor,invDevice)
EndFunction

bool Property DD_UseMutex = true auto

Bool Function LockDevicePatched(actor akActor, armor deviceInventory, bool force = false)
	if !deviceInventory
		UDCDMain.Error("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - none passed as deviceInventory")
		return false
	endif
	if !akActor
		UDCDMain.Error("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - none passed as akActor")
		return false
	endif
	
	if !UDCDmain.UDmain.ActorIsValidForUD(akActor)		
		if UDCDmain.TraceAllowed()
			UDCDmain.Log("LockDevicePatched - " + akActor + " is not valid actor!",1)
		endif
		return false
	endif
	
	;bool loc_usemutex = UDCDmain.isRegistered(akActor) ;only allow for registered npcs for now
	UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(akActor)
	UD_MutexScript loc_mutex = none
	
	if loc_slot
		loc_slot.StartLockMutex()
	else
		loc_mutex = UDMM.WaitForFreeAndSet_Lock(akActor,deviceInventory)
	endif
	bool loc_res = false
	if deviceInventory.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
		if UDCDmain.TraceAllowed()
			if loc_slot
				UDCDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - NPC slot: " + loc_slot,1)
			elseif loc_mutex	
				UDCDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - mutex: " + loc_mutex,1)
			else
				UDCDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - no mutex",1)
			endif
		endif
		
		if loc_slot
			loc_slot.ResetMutex_Lock(deviceInventory)
		elseif loc_mutex
			;ResetLockMutex(akActor,deviceInventory)
		endif

		zad_AlwaysSilent.addForm(akActor)
		loc_res = parent.LockDevice(akActor,deviceInventory,force)
		
		if loc_slot
			loc_slot.ProccesLockMutex()
		elseif loc_mutex
			loc_mutex.EvaluateLockMutex()
		endif

		zad_AlwaysSilent.RemoveAddedForm(akActor)
		
		if UDCDmain.TraceAllowed()	
			if loc_slot
				UDCDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation completed - NPC slot: " + loc_slot,1)
			elseif loc_mutex	
				UDCDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation completed - mutex: " + loc_mutex,1)
			else
				UDCDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation completed - no mutex",1)
			endif
		endif
		
	else
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("LockDevicePatched("+getActorName(akActor)+","+deviceInventory.getName()+") (patched) called, device is NOT UD -> skipping mutex")
		endif
		
		loc_res = parent.LockDevice(akActor,deviceInventory,force)
		;Utility.waitMenuMode(1.5) ;wait little time, so DCL work properly
		
		if DD_UseMutex
			Armor deviceRendered = GetRenderedDevice(deviceInventory)
			float loc_time = 0.0
			while loc_time <= 1.5 && !UDCDmain.CheckRenderDeviceEquipped(akActor, deviceRendered)
				Utility.waitMenuMode(0.01)
				loc_time += 0.01
			endwhile
			if loc_time >= 1.5
				;render device lock failed, abort
				UDCDMain.Error("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") DD mutex failed. Render device is not equipped - timeout")
			endif
		endif
		
	endif
	
	if UDCDmain.TraceAllowed()		
		UDCDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - ended",3)
	endif

	if loc_slot
		loc_slot.EndLockMutex()
	elseif loc_mutex
		loc_mutex.ResetLockMutex()
	endif

	return loc_res
EndFunction

;modified version of UnlockDevice from zadlibs. This version makes use of registered devices from UD, making unequip procces for NPC safer and faster
bool UNLOCK_MUTEX = False
Function CheckUnlockMutex()
	while UNLOCK_MUTEX
		Utility.waitMenuMode(0.05)
	endwhile
	UNLOCK_MUTEX = True
EndFunction
Function RemoveUnlockMutex()
	UNLOCK_MUTEX = False
EndFunction
Bool Function UnlockDevice(actor akActor, armor deviceInventory, armor deviceRendered = none, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = false)
	if !akActor
		UDCDmain.Error("UnlockDevice called for none actor!")
		return false
	endif
	if !deviceInventory
		UDCDmain.Error("None passed to UnlockDevice as deviceInventory. Aborting!")
		return false
	endif
	
	UD_CustomDevice_NPCSlot loc_slot 	= none ;NPC slot for registered NPC
	UD_MutexScript 			loc_mutex 	= none ;mutex used for non registered NPC
	
	bool 					loc_res 	= False ;return value
	
	;start mutex if actor is not dead
	bool loc_actordead = akActor.isDead()
	if !loc_actordead
		loc_slot = UDCDmain.getNPCSlot(akActor)
		if loc_slot
			loc_slot.StartUnlockMutex()
		else
			loc_mutex = UDMM.WaitForFreeAndSet_Unlock(akActor,deviceInventory)
		endif
	endif
	
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("UnlockDevice(UDP)("+akActor+","+deviceInventory+","+deviceRendered+","+zad_DeviousDevice+","+destroyDevice+","+genericonly+")",1)
	endif
	
	if deviceInventory.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
		if UDCDmain.TraceAllowed()
			UDCDmain.Log("UnlockDevice(UDP) called for " + MakeDeviceHeader(akActor,deviceInventory),2)
		endif
		If (genericonly && deviceInventory.HasKeyWord(zad_BlockGeneric)) || deviceInventory.HasKeyWord(zad_QuestItem)
			UDCDmain.Error("UnlockDevice(UDP) aborted because " + MakeDeviceHeader(akActor,deviceInventory) + " is not a generic item.")
			loc_res = false
		else				
			Armor loc_renDevice = none
			
			;get render device, this is important as function will not work without RD
			if deviceRendered
				loc_renDevice = deviceRendered
			else
				loc_renDevice = UDCDmain.getStoredRenderDevice(deviceInventory)
				if loc_renDevice
					loc_renDevice = GetRenderedDevice(deviceInventory)
				endif
			endif
			
			;check if actor actually have render device. Without RD, unlock function will not work
			if akActor.getItemCount(loc_renDevice)
				if loc_slot
					loc_slot.ResetMutex_UnLock(deviceInventory) ;init slot mutex
				elseif loc_mutex
					;is already set by WaitForFreeAndSet_Unlock
				endif
				
				if UDCDmain.TraceAllowed()	
					if loc_slot
						UDCDmain.Log("UnlockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - NPC slot: " + loc_slot,1)
					elseif loc_mutex	
						UDCDmain.Log("UnlockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - mutex: " + loc_mutex,1)
					else
						UDCDmain.Log("UnlockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - no mutex",1)
					endif
				endif
				
				;ignore ID events to prevent unwanted behavier
				StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0x110)
				
				;send and receive device from event container, so inside unlock function can be called
				akActor.removeItem(deviceInventory,1,True,UDCDmain.EventContainer_ObjRef)	
				UDCDmain.EventContainer_ObjRef.removeItem(deviceInventory,1,True,akActor)				  

				;procces mutex untill device is unlocked
				if loc_slot
					loc_slot.ProccesUnLockMutex()
				elseif loc_mutex
					loc_mutex.EvaluateUnLockMutex()
				endif
				
				;remove inventiory device if its detroy on remove
				if destroyDevice
					akActor.RemoveItem(deviceInventory, 1, true)
				EndIf
				
				loc_res = true 		;succes
			else
				loc_res = false	 	;failure
			endif
		endif			
	else
		;use default DD unlock function
		loc_res = parent.UnlockDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, destroyDevice, genericonly) ;actor not registered
	endif
	if UDCDmain.TraceAllowed()		
		UDCDmain.Log("UnlockDevice("+deviceInventory.getName()+") (patched) finished: "+loc_res,1)
	endif
	
	;end mutex
	if loc_slot
		loc_slot.EndUnLockMutex()
	elseif loc_mutex
		loc_mutex.ResetUnLockMutex()
	endif
	return loc_res
EndFunction

;modified version of RemoveQuestDevice from zadlibs. This version makes use of registered devices from UD,making unequip procces for NPC safer and faster
Function RemoveQuestDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, keyword RemovalToken, bool destroyDevice=false, bool skipMutex=false)
	bool loc_actordead = akActor.isDead()
	if !loc_actordead
		CheckUnlockMutex()
	endif
	if deviceInventory.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
		if UDCDMain.TraceAllowed()
			UDCDMain.Log("RemoveQuestDevice(patched)("+getActorName(akActor)+") called for " + deviceInventory.GetName(),1)
		endif
		bool end = false
		if !akActor.IsEquipped(deviceInventory) && !akActor.IsEquipped(deviceRendered) && !end
			UDCDmain.Error("RemoveQuestDevice(patched)("+getActorName(akActor)+") called for " + deviceInventory +", but this device is not currently worn.")
			end = True
		EndIf	
		If !deviceInventory.HasKeyword(zad_QuestItem) &&  !deviceRendered.HasKeyword(zad_QuestItem) && !end
			UDCDmain.Error("RemoveQuestDevice(patched)("+getActorName(akActor)+") aborted for " + deviceInventory.GetName() + " because it's not a quest item.")
			end = True
		EndIf
		If (!RemovalToken || zadStandardKeywords.HasForm(RemovalToken) || !(deviceInventory.HasKeyword(RemovalToken) || deviceRendered.HasKeyword(RemovalToken))) && !end
			UDCDmain.Error("RemoveQuestDevice(patched)("+getActorName(akActor)+") called for " + deviceInventory.GetName() + " with invalid removal token. Aborted.")
			end = True
		EndIf	
		if !end 			
			questItemRemovalAuthorizationToken = RemovalToken	
			StorageUtil.SetIntValue(akActor, "zad_RemovalToken" + deviceInventory, 1)
			StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0x110)
			bool loc_registered = true;UDCDmain.IsRegistered(akActor)
			if !loc_actordead && loc_registered
				UD_GlobalDeviceMutex_Unlock_InventoryScript = false
				UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed = false
				UD_GlobalDeviceMutex_Unlock_Device = deviceInventory
				UD_GlobalDeviceMutex_Unlock_Actor = akActor
			endif
			
			akActor.removeItem(deviceInventory,1,True,UDCDmain.EventContainer_ObjRef)	
			UDCDmain.EventContainer_ObjRef.removeItem(deviceInventory,1,True,akActor)	
			
			if !loc_actordead && loc_registered
				float loc_time = 0.0
				while  loc_time <= 15.0 && !UD_GlobalDeviceMutex_Unlock_InventoryScript && !UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed
					Utility.waitMenuMode(0.05)
					loc_time += 0.05
				endwhile
				
				if loc_time >= 15.0
					UDCDmain.Error("RemoveQuestDevice("+getActorName(akActor)+","+deviceInventory.getName()+") timeout!!!")
				endif
				
				UD_GlobalDeviceMutex_Unlock_InventoryScript = false
				UD_GlobalDeviceMutex_Unlock_InventoryScript_Failed = false
				UD_GlobalDeviceMutex_Unlock_Device = none
				UD_GlobalDeviceMutex_Unlock_Actor = none
			endif
			if destroyDevice
				akActor.RemoveItem(deviceInventory, 1, true)
			EndIf
		endif			
	else
		parent.RemoveQuestDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, RemovalToken, destroyDevice, skipMutex) ;actor not registered
	endif
	if !loc_actordead
		RemoveUnlockMutex()
	endif
EndFunction

;updated with additional safety
Bool Function UnlockDeviceByKeyword(actor akActor, keyword zad_DeviousDevice, bool destroyDevice = false)
	if !akActor
		UDCDmain.Error("UnlockDeviceByKeyword - Actor is none")
		return false
	endif
	
	if !zad_DeviousDevice
		UDCDmain.Error("UnlockDeviceByKeyword("+GetActorName(akActor)+") - keyword is none")
		return false
	endif
	
	if !akActor.wornHasKeyword(zad_DeviousDevice)
		if UDCDmain.TraceAllowed()
			UDCDmain.Log("UnlockDeviceByKeyword("+GetActorName(akActor)+")(UDP) - actor have mo keyword equipped= " + zad_DeviousDevice)
		endif
		return false
	endif
	
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("UnlockDeviceByKeyword("+GetActorName(akActor)+")(UDP) called for " + zad_DeviousDevice)
	endif	
	
	Armor idevice = GetWornDevice(akActor, zad_DeviousDevice)
	
	if !idevice
		UDCDmain.Error("UnlockDeviceByKeyword("+GetActorName(akActor)+","+zad_DeviousDevice+") - returned idevice is none")
		return false
	endif
	
	if UnlockDevice(akActor, idevice, zad_DeviousDevice = zad_DeviousDevice, destroyDevice = destroyDevice, genericonly = true)
		return true
	EndIf
	return false
EndFunction

;updated version to make it work for straightjackets
Armor Function GetWornRenderedDeviceByKeyword(Actor akActor, Keyword kw)
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("GetWornRenderedDeviceByKeyword("+akActor+","+kw+")",3)
	endif
	Int slotID = GetSlotMaskForDeviceType(kw)
	if slotID == -1
		return None
	EndIf

	if (kw == zad_deviousHeavyBondage) && akActor.wornHasKeyword(zad_DeviousStraitJacket)
		slotID = Armor.GetMaskForSlot(32)
	endif
	
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("GetWornRenderedDeviceByKeyword("+akActor+","+kw+") - GetSlotMaskForDeviceType = " + slotID,3)
	endif
	
	Armor renderDevice = akActor.GetWornForm(slotID) As Armor
	
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("GetWornRenderedDeviceByKeyword("+akActor+","+kw+") - renderDevice = " + renderDevice,3)
	endif
	
	if renderDevice && renderDevice.HasKeyWord(zad_Lockable)
		return renderDevice
	EndIf
	return none
EndFunction

Armor Function GetWornDevice(Actor akActor, Keyword kw)
	if !akActor
		UDCDmain.Error("GetWornDevice - Actor is none")
		return none
	endif
	if !kw
		UDCDmain.Error("GetWornDevice("+GetActorName(akActor)+") - keyword is none")
		return none
	endif
	if !akActor.wornHasKeyword(kw)
		if UDCDmain.TraceAllowed()
			UDCDmain.Log("GetWornDevice("+GetActorName(akActor)+")(UDP) - actor have no keyword equipped= " + kw)
		endif
		return none
	endif
	if UDCDmain.TraceAllowed()
		UDCDMain.Log("GetWornDevice("+GetActorName(akActor)+","+kw+")(UDP)",3)
	endif
	if UDCDmain.UDCD_NPCM.isRegistered(akActor)
		UD_CustomDevice_NPCSlot slot = UDCDmain.UDCD_NPCM.getNPCSlotByActor(akActor)
		if slot.deviceAlreadyRegisteredKw(kw)
			return slot.getFirstDeviceByKeyword(kw).deviceInventory
		endif
	endif
	
	return parent.GetWornDevice(akActor,kw)
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
			if UDCDmain.TraceAllowed()
				UDCDMain.Log("Setting anal plug inflation to " + (currentVal),1)
			endif
			zadInflatablePlugStateAnal.SetValueInt(currentVal)
		EndIf	
		LastInflationAdjustmentAnal = Utility.GetCurrentGameTime()
	EndiF
	
	UDCDmain.UDOM.UpdateArousal(akActor,20)
	UDCDmain.UDOM.UpdateOrgasmRate(akActor,20.0*currentVal,0.5)
	;UDCDmain.UpdateActorOrgasmProgress(akActor,15.0*currentVal,bUpdateWidget = true)
	;SendInflationEvent(akActor, False, True, currentval)
	
	Utility.wait(2.0)
	UDCDmain.UDOM.removeOrgasmRate(akActor,20.0*currentVal,0.5)
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
			if UDCDmain.TraceAllowed()
				UDCDMain.Log("Setting vaginal plug inflation to " + (currentVal),1)
			endif
			zadInflatablePlugStateVaginal.SetValueInt(currentVal)
		EndIf	
		LastInflationAdjustmentVaginal = Utility.GetCurrentGameTime()
	EndIf
	
	UDCDmain.UDOM.UpdateArousal(akActor,30)
	UDCDmain.UDOM.UpdateOrgasmRate(akActor,20.0*currentVal,0.5)
	;UDCDmain.UpdateActorOrgasmProgress(akActor,15.0*currentVal,bUpdateWidget = true)
	SendInflationEvent(akActor, True, True, currentval)
	
	Utility.wait(2.0)
	UDCDmain.UDOM.removeOrgasmRate(akActor,20.0*currentVal,0.5)
EndFunction

String Function AnimSwitchKeyword(actor akActor, string idleName)
	if UDCDmain.UDOM.UD_OrgasmAnimation != 0
		If idleName == "Orgasm"
			;hobbled animations
			if akActor.WornHasKeyword(zad_DeviousHobbleSkirt)
				if !akActor.WornHasKeyword(zad_DeviousHeavyBondage)	
					int random = Utility.randomInt(1,3)
					if random == 1
						return "DDZazHornyA"
					elseif random == 2
						return "DDZazHornyB"
					elseif random == 3
						return "DDZazHornyC"
					endif
				endif
				
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
				elseif akActor.WornHasKeyword(zad_DeviousPetSuit)
					return "none"					
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
				EndIf
			else ;no hobble
				if !akActor.WornHasKeyword(zad_DeviousHeavyBondage)	
					int random = Utility.randomInt(1,3)
					if random == 1
						return "DDZazHornyA"
					elseif random == 2
						return "DDZazHornyB"
					elseif random == 3
						return "DDZazHornyC"
					endif
				endif
				
				if akActor.WornHasKeyword(zad_DeviousArmbinder)
					int random = 0
					if UDCDmain.UDmain.ZaZAnimationPackInstalled
						random = Utility.randomInt(1,11)
					else
						random = Utility.randomInt(1,8)
					endif
					
					if random < 8
						return ("ft_horny_armbinder_" + random)
					elseif random == 8
						return "ft_orgasm_armbinder_1"
					elseif random > 8
						return ("ZapArmbHorny0" + (random - 8))
					endif
				ElseIf akActor.WornHasKeyword(zad_DeviousYoke)
					int random = 0
					if UDCDmain.UDmain.ZaZAnimationPackInstalled
						random = Utility.randomInt(1,11)
					else
						random = Utility.randomInt(1,8)
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
				elseif akActor.WornHasKeyword(zad_DeviousPetSuit)
					return "none"						
				Elseif akActor.WornHasKeyword(zad_DeviousHeavyBondage)	
					int random = 0
					if UDCDmain.UDmain.ZaZAnimationPackInstalled
						random = Utility.randomInt(1,11)
					else
						random = Utility.randomInt(1,8)
					endif
					if random < 7
						return ("ft_horny_elbowbinder_" + random)
					elseif random == 8
						return "ft_orgasm_elbowbinder_1"
					elseif random > 8
						return ("ZapArmbHorny0" + (random - 8))
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
	if akActor.WornHasKeyword(UDCDmain.UDlibs.UnforgivingDevice) && UDCDmain.isRegistered(akActor)
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("StopVibrating("+GetActorName(akActor)+") - using patched version: " + akActor)
		endif
		UDCDmain.StopAllVibrators(akActor)
		akActor.SetFactionRank(zadVibratorFaction, 0)
		akActor.RemoveFromFaction(zadVibratorFaction)
	else
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("StopVibrating("+GetActorName(akActor)+") - using default version: " + akActor)
		endif
		parent.StopVibrating(akActor)
	endif
EndFunction

int Function VibrateEffect(actor akActor, int vibStrength, int duration, bool teaseOnly=false, bool silent = false)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("VibrateEffect(): " + akActor + ", " + vibStrength + ", " + duration)
	endif
	if akActor.WornHasKeyword(UDCDmain.UDlibs.UnforgivingDevice) && UDCDmain.isRegistered(akActor)
		int loc_vibNum = UDCDmain.getOffVibratorNum(akActor)
		if loc_vibNum > 0
			UD_CustomDevice_RenderScript[] loc_usableVibrators = UDCDmain.getOffVibrators(akActor)
			UD_CustomVibratorBase_RenderScript loc_selectedVib = loc_usableVibrators[Utility.randomInt(0,loc_vibNum - 1)] as UD_CustomVibratorBase_RenderScript
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log("VibrateEffect("+GetActorName(akActor)+") - selected vib:" + loc_selectedVib,1)
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

Function ShockActorPatched(actor akActor,int iArousalUpdate = 25,float fHealth = 0.0, bool bCanKill = false)
	bool loc_loaded = akActor.Is3DLoaded()
	if ActorIsPlayer(akActor)
		NotifyPlayer("You squirms uncomfortably as electricity runs through your body!")
	Elseif UDCDmain.ActorIsFollower(akActor) && loc_loaded
		NotifyNPC(akActor.GetLeveledActorBase().GetName()+" squirms uncomfortably as electricity runs through her.")
	EndIf
	ShockEffect.RemoteCast(akActor, akActor, akActor)
	
	if loc_loaded
		if Utility.randomInt(1,99) < 40
			UDCDmain.ApplyTearsEffect(akActor)
		endif
	endif
	float loc_health = fRange(fHealth,0.0,1000.0)
	
	if loc_health
		if akActor.getAV("Health") > loc_health || bCanKill
			akActor.damageAV("Health", loc_health)
		endif
	endif
	if iArousalUpdate
		int loc_arousalUpdate = iRange(Utility.randomInt(Round(0.75*iArousalUpdate),Round(0.5*iArousalUpdate)),-100,100)
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
		
		;[UD EDIT]: Removed permitRestrictive as its no longer usefull
		if !IsValidActor(akActor); || (akActor.WornHasKeyword(zad_DeviousArmBinder) && !permitRestrictive)
			if UDCDmain.TraceAllowed()		
				Log("Actor is not loaded (Or is otherwise invalid). Aborting.")
			endif
			return new bool[2]
		EndIf
		
		if IsAnimating(akActor)
			if UDCDmain.TraceAllowed()
				Log("Actor already in animating faction.")
			endif
			return new bool[2]
		EndIf

		if animation == "none"
			UDCDmain.Error("StartThirdPersonAnimation - Called animation is None, aborting")
			return new bool[2]
		endif
		
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
		Form loc_shield = UDCDmain.GetShield(akActor)
		if loc_shield
			akActor.unequipItem(loc_shield,true,true)
			StorageUtil.SetFormValue(akActor,"UD_UnequippedShield",loc_shield)
		endif
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
			UDCDMain.Log("EndThirdPersonAnimation("+GetActorName(akActor)+","+cameraState+")",1)
		endif
		SetAnimating(akActor, false)
		if (!akActor.Is3DLoaded() ||  akActor.IsDead() || akActor.IsDisabled())
			UDCDMain.Error("EndThirdPersonAnimation("+GetActorName(akActor)+") - Actor is not loaded (Or is otherwise invalid). Aborting.")
			return
		EndIf
		Form loc_shield = StorageUtil.GetFormValue(akActor,"UD_UnequippedShield",none)
		if loc_shield
			StorageUtil.UnsetFormValue(akActor,"UD_UnequippedShield")
			akActor.equipItem(loc_shield,false,true)
		endif
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
	;UDCDmain.StartRecordTime()
	if akActor.isInFaction(UDCDmain.BlockAnimationFaction)
		return false
	endif
	
	if isAnimating(akActor)
		EndThirdPersonAnimation(akActor, new bool[2], true)
	endif
	
	bool[] loc_cameraState = StartThirdPersonAnimation(akActor, animation,permitRestrictive)
	akActor.AddToFaction(UDCDmain.BlockAnimationFaction)
	
	Utility.wait(duration)

	akActor.RemoveFromFaction(UDCDmain.BlockAnimationFaction)
	EndThirdPersonAnimation(akActor,loc_cameraState,permitRestrictive)
	
	return true
EndFunction

Function ActorOrgasm(actor akActor, int setArousalTo=-1, int vsID=-1)
	int loc_newArousal = 100 - setArousalTo
	if setArousalTo == -1
		loc_newArousal = 75
	endif
	;ActorOrgasmPatched(akActor,20,loc_newArousal)
	UDCDmain.UDOM.ActorOrgasm(akActor,20,loc_newArousal)
EndFunction

Function UpdateExposure(actor akRef, float val, bool skipMultiplier=false)
	If (akRef == None)
		Error("UpdateExposure passed none reference.")
		return
	EndIf
	
	int lastRank = Aroused.GetActorExposure(akRef)
	if skipMultiplier
		; This function is very slow, and sometimes hangs for multiple seconds (Seen 10+). Directly access internals as a work-around.
		int newVal = lastRank + Round(val) 
		if newVal > 100
			newVal = 100
		EndIf
		Aroused.SetActorExposure(akRef, newVal)
	Else
		int newRank = Round(lastRank + val * Aroused.GetActorExposureRate(akRef))	
		Aroused.SetActorExposure(akRef, newRank)
	EndIf
EndFunction

Function ApplyExpression(Actor akActor, sslBaseExpression expression, int strength, bool openMouth=false)
	if akActor.Is3DLoaded() || akActor == Game.getPlayer()
		UDCDmain.UDEM.ApplyExpression(akActor, expression, strength, openMouth,0)
	endif
EndFunction

Function ResetExpression(actor akActor, sslBaseExpression expression)
	UDCDmain.UDEM.ResetExpression(akActor, expression,0)
EndFunction

Function ApplyGagEffect(actor akActor)	
	UDCDmain.UDEM.ApplyGagEffect(akActor)
EndFunction

Function RemoveGagEffect(actor akActor)
	UDCDmain.UDEM.RemoveGagEffect(akActor)
EndFunction

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
				UDCDmain.Log("GetRenderedDevice(patched)("+device.getName()+")called, returning " + loc_res,2)
			endif
			return loc_res
		endif
	endif
	return parent.GetRenderedDevice(device)
EndFunction

Function UpdateControls()
	if _installing
		return
	endif
	if UDCDmain.TraceAllowed()
		UDCDMain.Log("UpdateControls(UDP)()",3)
	endif
	
	; Centralized control management function.
	bool movement = true
	bool fighting = true
	bool sneaking = true
	bool menu = true
	;check hardcore mode
	
	if Game.getPlayer().HasMagicEffectWithKeyword(UDCDmain.UDlibs.HardcoreDisable_KW)
		menu = false
	else
		menu = true
	endif
	
	bool activate = true
	int cameraState = Game.GetCameraState()
	if playerRef.WornHasKeyword(zad_DeviousBlindfold) && (config.BlindfoldMode == 1 || config.BlindfoldMode == 0) && (cameraState == 8 || cameraState == 9)
		movement = false
		sneaking = false
	EndIf
	
	if UDCDmain.ActorInMinigame(Game.getPlayer())
		movement = true
		menu = false
	endif
	
	if IsBound(playerRef)
		If playerRef.WornHasKeyword(zad_BoundCombatDisableKick)
			fighting = false			
		Else
			fighting = config.UseBoundCombat			
		Endif	
	EndIf
	if playerRef.WornHasKeyword(zad_DeviousPetSuit)
		sneaking = false
	EndIf	
	if playerRef.WornHasKeyword(zad_DeviousPonyGear)
		sneaking = false
	EndIf	
	Game.DisablePlayerControls(abMovement = !movement, abFighting = !fighting, abSneaking = !sneaking, abMenu = !menu, abActivate = !activate)	
	Game.EnablePlayerControls(abMovement = movement, abFighting = fighting, abSneaking = sneaking, abMenu = menu, abActivate = activate)	
EndFunction

function stripweapons(actor a, bool unequiponly = true)		
	int i = 2
	Spell spl
	Weapon weap
	Armor sh
	While i > 0
		i -= 1
		if i == 0
			Utility.WaitMenuMode(1.0) ;edited so devices lock also when in menu, to save time
		EndIf
		spl = a.getEquippedSpell(1)
		if spl
			a.unequipSpell(spl, 1)
		endIf
		weap = a.GetEquippedWeapon(true)
		if weap
			a.unequipItem(weap, false, true)
		endIf
		sh = a.GetEquippedShield()
		if sh
			a.unequipItem(sh, false, true)
		endIf
		spl = a.getEquippedSpell(0)
		if spl
			a.unequipSpell(spl, 0)
		endIf
		weap = a.GetEquippedWeapon(false)
		if weap
			a.unequipItem(weap, false, true)
		endIf
	EndWhile
endfunction

Function RepopulateNpcs()
	if repopulateMutex ; Avoid this getting hit too quickly while comparing times
		Log("RepopulateNpcs() is already processing.")
		return
	EndIf
	repopulateMutex=true
	Log("RepopulateNpcs()")
	if Utility.GetCurrentRealTime() - lastRepopulateTime <= 5
		Log("Aborting repopulation of NPC slots: Hit throttle.")
		repopulateMutex=false
		return
	EndIf
	lastRepopulateTime = Utility.GetCurrentRealTime()
	if zadNPCQuest.IsProcessing
		Log("Waiting, since NPC Events is currently processing.")
		int timeout = 0
		while zadNPCQuest.IsProcessing && timeout <= 24
			Utility.WaitMenuMode(5) ;edited so devices lock also when in menu, to save time
			timeout += 1
		EndWhile
		if timeout >= 24
			Warn("RepopulateNpcs() spinlock timed out!!")
			zadNPCQuest.IsProcessing = false
		EndIf
	EndIf
	if !zadNPCSlots.IsStopping() && !zadNPCSlots.IsStarting()
		if zadNPCSlots.IsRunning()
			zadNPCSlots.Stop()
		EndIf
		If config.NumNpcs>0
			; Feels like a race condition / timing issue?
			; Perhaps if I call a short wait (Thus suspending execution, giving the quest a chance to fully stop?), it won't occur.
			Utility.WaitMenuMode(2.0) ;edited so devices lock also when in menu, to save time
			zadNPCSlots.Start()
		Else
			Log("Not repopulating NPC slots: Feature is disabled.")
		EndIf
	Else
		Warn("Not repopulating NPC slots: Quest is changing state.")
	EndIf
	repopulateMutex=false
EndFunction
