Scriptname UD_CustomDevice_EquipScript extends zadequipscript  
import MfgConsoleFunc

UDCustomDeviceMain Property UDCDmain auto

;properties from original scripts to not cause issues with patching
;zadGagScript
Message Property callForHelpMsg Auto
Message Property zad_GagPreEquipMsg Auto
Message Property zad_GagEquipMsg Auto
Message Property zad_GagRemovedMsg Auto
Message Property zad_GagPickLockFailMsg Auto
Message Property zad_GagPickLockSuccessMsg Auto
Message Property zad_GagArmsTiedMsg Auto
Message Property zad_GagBruteForceArmsTiedMsg Auto
Message Property zad_GagBruteForceMsg Auto
;zadGagPanelScript
Faction Property zadGagPanelFaction Auto
MiscObject Property zad_GagPanelPlug Auto
;zadPlugScript
Keyword Property zad_DeviousBelt Auto
;zadPlugPumpsScript
Message Property squeezeMsg Auto
;zadBeltScript
SexLabFramework property SexLab auto
Keyword Property zad_DeviousPlug Auto ; This stuff is deprecated and is no longer used by anything in this script. It's left in here not to make custom scripts inheriting these property cough errors into the log.
;who knows
Keyword Property zad_DeviousCollar Auto
Keyword Property zad_DeviousCuffsLegs Auto
Keyword Property zad_DeviousCuffsArms Auto
Keyword Property zad_DeviousHood  auto
Keyword Property zad_BraNoBlockPiercings auto
Keyword Property zad_DeviousPiercingsNipple  auto


bool deviceReturned = false

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	if akNewContainer as Actor
		if !UDCDmain
			UDCDmain = Game.getFormFromFile(0x0015E73C,"UnforgivingDevices.esp") as UDCustomDeviceMain
		endif
		
		zad_DeviceMsg =	UDCDmain.DefaultEquipDeviceMessage
	endif
	Actor giver = akOldContainer as Actor
	Actor target = akNewContainer as Actor
		
	if  Math.LogicalAnd(StorageUtil.GetIntValue(target, "UD_ignoreEvent" + deviceInventory, 0),0x001)
		if Math.LogicalAnd(StorageUtil.GetIntValue(target, "UD_ignoreEvent" + deviceInventory, 0),0x004)
			;prevents removal
			akNewContainer.removeItem(deviceInventory,1,True,akOldContainer)
		endif
		if Math.LogicalAnd(StorageUtil.GetIntValue(target, "UD_ignoreEvent" + deviceInventory, 0),0x002)
			StorageUtil.SetIntValue(target, "UD_ignoreEvent" + deviceInventory,Math.LogicalAnd(StorageUtil.GetIntValue(target, "UD_ignoreEvent" + deviceInventory, 0),0xFF0))
		endif			
		return
	endif
	
	if Math.LogicalAnd(StorageUtil.GetIntValue(giver, "UD_ignoreEvent" + deviceInventory, 0),0x001)
		if Math.LogicalAnd(StorageUtil.GetIntValue(giver, "UD_ignoreEvent" + deviceInventory, 0),0x004)
			;prevents removal
			akOldContainer.removeItem(deviceInventory,1,True,akNewContainer)
		endif
		if Math.LogicalAnd(StorageUtil.GetIntValue(giver, "UD_ignoreEvent" + deviceInventory, 0),0x002)
			StorageUtil.SetIntValue(giver, "UD_ignoreEvent" + deviceInventory,Math.LogicalAnd(StorageUtil.GetIntValue(giver, "UD_ignoreEvent" + deviceInventory, 0),0xFF0))
		endif
		return
	endif
	if UDCDmain
		if target && giver
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log(" Device " + deviceInventory.getName() + " moved from " + giver.getActorBase().getName() + " to " + target.getActorBase().getName(),3)
			endif
		endif
		
		if target && akOldContainer == UDCDmain.EventContainer_ObjRef
			deviceReturned = True
			return
		endif
		
		if akNewContainer == UDCDmain.EventContainer_ObjRef && giver
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log(" Device " + deviceInventory.getName() + " send to Event Container! Waiting for device to return to inventory!",3)
			endif
			while !deviceReturned
				Utility.WaitMenuMode(0.05)
			endwhile
			deviceReturned = False
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log(" Device regained! Starting unlock operatios!",1)
			endif
			StorageUtil.SetIntValue(giver, "UD_ignoreEvent" + deviceInventory, 0x311)
			giver.UnequipItemEx(deviceInventory, 0, false)
			Utility.waitMenuMode(0.1)
			parent.OnUnequipped(giver)
			StorageUtil.UnSetIntValue(giver, "UD_ignoreEvent" + deviceInventory)
			return
		endif
		
		if UI.IsMenuOpen("ContainerMenu")	
			if target && giver
				if !target.isDead() && !giver.isDead()
					if giver.getItemCount(deviceRendered)
						if UDCDmain.TraceAllowed()						
							UDCDmain.Log(" Opening device menu for " + deviceInventory.getName() + " on "+ giver.getActorBase().getName() +" , helper:  " + target.getActorBase().getName(),1)
						endif
						StorageUtil.SetIntValue(giver, "UD_ignoreEvent" + deviceInventory, 0x111)
						StorageUtil.SetIntValue(target, "UD_ignoreEvent" + deviceInventory, 0x333)
						target.removeItem(deviceInventory,1,True,giver)
						giver.EquipItem(deviceInventory, false, true)
						openWHMenu(giver,target)
						StorageUtil.UnSetIntValue(giver, "UD_ignoreEvent" + deviceInventory)
						StorageUtil.UnSetIntValue(target, "UD_ignoreEvent" + deviceInventory)
						return
					elseif target != Game.getPlayer() && !target.getItemCount(deviceRendered)
						libs.LockDevice(target, deviceInventory, force = false)
						return
					else
						return
					endif
				else
					if giver.getItemCount(deviceRendered) && DestroyOnRemove
						if UDCDmain.TraceAllowed()						
							UDCDmain.Log("Removing DestroyOnRemove device" + deviceInventory.getName() + " on "+ giver.getActorBase().getName(),1)
						endif
						UD_CustomDevice_RenderScript device = getUDScript(giver)
						if device
							if UDCDmain.TraceAllowed()						
								UDCDmain.Log("Removing device from dead actor :" + deviceInventory.getName() + " on "+ giver.getActorBase().getName() +" to:  " + target.getActorBase().getName(),1)
							endif
							device.removeDevice(giver)
							if DestroyOnRemove
								target.removeItem(deviceInventory,1,True)
								giver.removeItem(deviceRendered,1,True)
							endif
							return
						endif
					endif
				endif
			endif
		endif
	endif

	parent.OnContainerChanged(akNewContainer,akOldContainer)
EndEvent

Function openWHMenu(Actor akTarget,Actor akSource)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log(" NPC menu opened for " + deviceInventory.getName() + " (" + akTarget.getActorBase().getName() + ") by " + akSource.getActorBase().getName(),1)
	endif
	UDCDMain.OpenHelpDeviceMenu(getUDScript(akTarget),akSource,UDCDmain.ActorIsFollower(akSource))
EndFunction

UD_CustomDevice_RenderScript Function getUDScript(Actor akActor)
	if UDCDmain.UDCD_NPCM.isRegistered(akActor)
		UD_CustomDevice_RenderScript device = UDCDmain.getDeviceByInventory(akActor,deviceInventory)
		if device
			return UDCDmain.getDeviceByInventory(akActor,deviceInventory)
		else
			return UDCDmain.getDeviceScriptByRender(akActor,deviceRendered)
		endif
	else
		return UDCDmain.getDeviceScriptByRender(akActor,deviceRendered)
	endif
EndFunction

bool _locked = false
Function OnEquippedPost(actor akActor)
	parent.OnEquippedPost(akActor)
EndFunction

Function OnRemoveDevice(actor akActor)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("OnRemoveDevice called for " + deviceInventory.getName() + " on " + akActor.getLeveledActorBase().getName(),3)
	endif
	UD_CustomDevice_RenderScript device
	if UDCDmain.UDCD_NPCM.isRegistered(akActor)
		device = UDCDmain.getFirstDeviceByKeyword(akActor,zad_DeviousDevice)
	else
		device = UDCDmain.getDeviceScriptByRender(akActor,deviceRendered)
	endif
	
	if device
		device.removeDevice(akActor)
	endif
	
	if !akActor.isDead()
		UDCDmain.UpdateInvisibleArmbinder(akActor)
		UDCDmain.UpdateInvisibleHobble(akActor)
	endif	
	if deviceRendered.hasKeyword(libs.zad_DeviousGag)
		libs.RemoveGagEffect(akActor)
		if !libs.IsAnimating(akActor)
			akActor.ClearExpressionOverride()
			ResetPhonemeModifier(akActor)
		EndIf
	endif
	if  deviceRendered.hasKeyword(libs.zad_DeviousGagPanel)
		if akActor.GetFactionRank(UDCDmain.zadGagPanelFaction) == 0
			akActor.RemoveItem(zad_GagPanelPlug, 1)
		EndIf
		akActor.SetFactionRank(UDCDmain.zadGagPanelFaction, 0)
		akActor.RemoveFromFaction(UDCDmain.zadGagPanelFaction)
	endif
	
	
	zadlibs_UDPatch libs_p = (libs as zadlibs_UDPatch)
	if akActor == libs_p.UD_GlobalDeviceMutex_Unlock_Actor && libs_p.UD_GlobalDeviceMutex_Unlock_Device == deviceInventory
		libs_p.UD_GlobalDeviceMutex_Unlock_InventoryScript = true
	endif
EndFunction

Event OnEquipped(Actor akActor)	
	;Debug.StartStackProfiling()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("OnEquipped("+UDCDmain.MakeDeviceHeader(akActor,deviceInventory)+") - called",3)
	endif
	if Math.LogicalAnd(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x010)
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("OnEquipped("+UDCDmain.MakeDeviceHeader(akActor,deviceInventory)+") -  aborted because of filter",3)
		endif
		if Math.LogicalAnd(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x030)
			StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,Math.LogicalAnd(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0xF0F))
		endif
		if (libs as zadlibs_UDPatch).isMutexed(akActor,deviceInventory)
			(libs as zadlibs_UDPatch).UD_GlobalDeviceMutex_InventoryScript_Failed = true
		endif
		return
	endif
	
	if !UDCDmain
		UDCDmain = Game.getFormFromFile(0x0015E73C,"UnforgivingDevices.esp") as UDCustomDeviceMain
	endif
	
	if !zad_DeviceMsg
		zad_DeviceMsg =	UDCDmain.DefaultEquipDeviceMessage
	endif

	LockDevice(akActor)
	
	if (libs as zadlibs_UDPatch).isMutexed(akActor,deviceInventory)
		if !_locked
			(libs as zadlibs_UDPatch).UD_GlobalDeviceMutex_InventoryScript_Failed = true
		else
			(libs as zadlibs_UDPatch).UD_GlobalDeviceMutex_InventoryScript = true
		endif
	endif
EndEvent

Event OnUnequipped(Actor akActor)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log(" OnUnequipped("+UDCDmain.MakeDeviceHeader(akActor,deviceInventory)+") - called",3)
	endif

	if UI.IsMenuOpen("ContainerMenu") && akActor == Game.getPlayer()
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("OnUnequipped("+UDCDmain.MakeDeviceHeader(akActor,deviceInventory)+") - aborted because of opened menu",3)
		endif
		return
	endif

	if Math.LogicalAnd(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x100)
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("OnUnequipped("+UDCDmain.MakeDeviceHeader(akActor,deviceInventory)+") - aborted because of filter",3)
		endif
		if Math.LogicalAnd(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x300)
			StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,Math.LogicalAnd(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x0FF))
		endif
		return
	endif

	parent.OnUnequipped(akActor)
EndEvent

Int Function GetLockDeviceType(Actor akActor)
	return StorageUtil.GetIntValue(akActor,"UD_LockDeviceType"+deviceInventory,-1)
EndFunction

;device menu that pops up when Wearer click on this device in inventory
Function DeviceMenu(Int msgChoice = 0)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("DeviceMenu("+UDCDmain.MakeDeviceHeader(Game.getPlayer(),deviceInventory)+")",1)
	endif
	
	if !deviceRendered.haskeyword(UDCDmain.UDlibs.UnforgivingDevice)
		parent.deviceMenu() ;not patched device
		return
	endif
	UD_CustomDevice_RenderScript device = UDCDmain.getDeviceByInventory(Game.getPlayer(),deviceInventory)
	if device
		UDCDmain.getDeviceByInventory(Game.getPlayer(),deviceInventory).DeviceMenu(new Bool[30])
	else
		UDCDmain.getDeviceScriptByRender(Game.getPlayer(),deviceRendered).DeviceMenu(new Bool[30])
	endif
EndFunction

Function OnEquippedPre(actor akActor, bool silent=false)
	;StorageUtil.setIntValue(akActor,"zad_Equipped" + deviceInventory,1)
	;StorageUtil.setIntValue(akActor,"zad_Equipped" + deviceRendered,1)
	StorageUtil.setFormValue(deviceInventory	,"UD_RenderDevice"		,deviceRendered)
	StorageUtil.setFormValue(deviceRendered		,"UD_InventoryDevice"	,deviceInventory)
	_locked = true
	if zad_DeviousDevice == libs.zad_DeviousPlug || zad_DeviousDevice == libs.zad_DeviousPlugAnal || zad_DeviousDevice == libs.zad_DeviousPlugVaginal
		EquipPrePlug(akActor,silent)
	elseif zad_DeviousDevice == libs.zad_DeviousHarness
		EquipPreHarness(akActor,silent)
	elseif zad_DeviousDevice == libs.zad_DeviousPiercingsVaginal
		EquipFilterPiercingV(akActor,silent)
	elseif zad_DeviousDevice == libs.zad_DeviousPiercingsNipple
		EquipPrePiercingN(akActor,silent)
	elseif zad_DeviousDevice == libs.zad_DeviousGag
		EquipPreGag(akActor,silent)
	endif
	
	if deviceRendered.haskeyword(libs.zad_deviousgagpanel)
		EquipPrePanelGag(akActor,silent)
	endif
	Parent.OnEquippedPre(akActor, silent)	
EndFunction

Function EquipPrePlug(actor akActor, bool silent=false)
		; Check to see if old (slot 54) plug is being used.
		int slotMask = deviceRendered.GetSlotMask()
		if (Math.LogicalAnd(slotMask, 0x01000000)) ; Slot 54
			libs.Warn("Legacy (Slot 54) plug detected. Updating slotmask...")
			slotMask = ((slotMask - 0x01000000) + 0x08000000)
			deviceRendered.SetSlotMask(slotMask)
		EndIf
		string msg = ""
		int loc_arousal = libs.Aroused.GetActorExposure(akActor)
		If !deviceKey
			if akActor == libs.PlayerRef
				if loc_arousal < libs.ArousalThreshold("Desire")
					msg = "Your hole is now filled, as is your desire for pleasure."
				elseif loc_arousal < libs.ArousalThreshold("Horny")
					msg = "You slowly insert the plug inside your opening, your lust growing with every inch it slides in."
				elseif loc_arousal < libs.ArousalThreshold("Desperate")
					msg = "You insert the plug inside your opening and take great delight in the resulting feelings of pleasure."
				else
					msg = "Barely in control of control your own body you thrust the plug almost forcefully into the appropriate opening."
				endif
			else
				msg = akActor.GetLeveledActorBase().GetName() + " shudders as you push the plugs in to her."
			EndIf
		Else
			if akActor == libs.PlayerRef
				if loc_arousal < libs.ArousalThreshold("Desire")
					msg = "As you gently slide the plug in, you hear a sharp click and suddenly feel very full."
				elseif loc_arousal < libs.ArousalThreshold("Horny")
					msg = "You slowly push the plug into your hole and let out a quiet gasp when it expands, locking itself securely in place."
				elseif loc_arousal < libs.ArousalThreshold("Desperate")
					msg = "You insert the plug inside your sensitive opening and it clicks, suddenly growing in volume and filling you with delight."
				else
					msg = "You impatiently thrust the plug deep into yourself and its rapid expansion makes your legs clench together instinctively."
				endif
			else
				msg = akActor.GetLeveledActorBase().GetName() + " shudders as you push the plug into her and lock it."
			EndIf
		EndIf
		if !silent
			libs.NotifyActor(msg, akActor, true)
		EndIf
EndFunction

Function EquipPreHarness(actor akActor, bool silent=false)
	if !silent
		if akActor == libs.PlayerRef
			libs.NotifyActor("You step in to the harness, securing it tightly against your body.", akActor, true)
		Else
			libs.NotifyActor(GetMessageName(akActor) +" steps in to the harness, securing it tightly against her body.", akActor, true)
		EndIf
	EndIf
EndFunction

Function EquipPrePiercingV(actor akActor, bool silent=false)
	if !akActor.HasPerk(libs.PiercedClit)
		akActor.AddSpell(libs.PiercedClitSpell, true)
	Endif
	if !silent
		libs.NotifyActor("You carefully slip the piercing into "+GetMessageName(akActor)+" clitoris. A quiet 'Click' is heard as the band clicks together, now seemingly seamless. ", akActor, true)
	EndIf
EndFunction

Function EquipPrePiercingN(actor akActor, bool silent=false)
	if !akActor.HasPerk(libs.PiercedNipples)
		akActor.AddSpell(libs.PiercedNipplesSpell, true)
	Endif
	if !silent
		libs.NotifyActor("You carefully slip the piercings into "+GetMessageName(akActor)+" nipples. A quiet 'Click' is heard as the band clicks together, now seemingly seamless. ", akActor, true)
	EndIf
EndFunction

Function EquipPreGag(actor akActor, bool silent=false)
	if !silent
		if akActor == libs.PlayerRef
			;zad_GagEquipMsg.Show()
		Else
			libs.NotifyActor("You slip the gag into "+GetMessageName(akActor)+" mouth, and lock it securely in place behind "+GetMessageName(akActor)+" head.", akActor, true)
		EndIf
	EndIf
EndFunction

Function EquipPrePanelGag(actor akActor, bool silent=false)
	if UDCDmain.TraceAllowed()
		libs.Log("Panel Gag: Setting faction rank.")
	endif
	akActor.AddToFaction(UDCDmain.zadGagPanelFaction)
	akActor.SetFactionRank(UDCDmain.zadGagPanelFaction, 1)
EndFunction

int Function OnEquippedFilter(actor akActor, bool silent=false)
	if zad_DeviousDevice == libs.zad_DeviousPlugAnal || zad_DeviousDevice == libs.zad_DeviousPlugVaginal || zad_DeviousDevice == libs.zad_DeviousPlug
		return EquipFilterPlug(akActor,silent)
	elseif zad_DeviousDevice == libs.zad_DeviousCorset
		return EquipFilterCorset(akActor,silent)
	elseif zad_DeviousDevice == libs.zad_DeviousHarness
		return EquipFilterHarness(akActor,silent)
	elseif zad_DeviousDevice == libs.zad_DeviousPiercingsVaginal
		return EquipFilterPiercingV(akActor,silent)
	elseif zad_DeviousDevice == libs.zad_DeviousPiercingsNipple
		return EquipFilterPiercingN(akActor,silent)
	;elseif zad_DeviousDevice == libs.zad_DeviousHeavyBondage && deviceRendered.haskeyword(libs.zad_DeviousStraitJacket)
	;	return EquipFilterStraitjacket(akActor,silent)
	else
		return 0
	endif
EndFunction

int Function EquipFilterPlug(actor akActor, bool silent=false)
	; FTM optimization
	if silent && akActor != libs.PlayerRef
		return 0
	EndIf	
	
	if akActor.WornHasKeyword(libs.zad_DeviousBelt)
		if deviceRendered.HasKeyword(libs.zad_DeviousPlugAnal) && akActor.WornHasKeyword(libs.zad_permitAnal)
			; open belts allow putting in anal plugs.
			return 0
		EndIf
		if akActor == libs.PlayerRef && !silent
			libs.NotifyActor("Try as you might, the belt you are wearing prevents you from inserting this plug.", akActor, true)
		ElseIf  !silent
			libs.NotifyActor("The belt " + akActor.GetLeveledActorBase().GetName() + " is wearing prevents from having this plug inserted.", akActor, true)
		EndIf
		if !silent
			return 2
		Else
			return 0
		EndIf
	Endif
	return 0
EndFunction

int Function EquipFilterCorset(actor akActor, bool silent=false)
	if !akActor
		return 3
	endif
	if !akActor.IsEquipped(deviceRendered)
		if akActor.WornHasKeyword(libs.zad_DeviousHarness) && deviceRendered.HasKeyword(libs.zad_DeviousCorset)
			if !silent
				MultipleItemFailMessage("Harness")
			endif
			return 2
		Endif
		if akActor.WornHasKeyword(libs.zad_DeviousCorset) && deviceRendered.HasKeyword(libs.zad_DeviousCorset)
			if !silent
				MultipleItemFailMessage("Corset")
			endif
			return 2
		Endif
		if akActor.WornHasKeyword(libs.zad_DeviousBelt) && deviceRendered.HasKeyword(libs.zad_DeviousBelt)
			if !silent
				MultipleItemFailMessage("Belt")
			endif
			return 2
		Endif
	Endif
	return 0
EndFunction

int Function EquipFilterHarness(actor akActor, bool silent=false)
	if akActor == none
		akActor == libs.PlayerRef
	EndIf
	if !akActor.IsEquipped(deviceRendered)
		if akActor != libs.PlayerRef && ShouldEquipSilently(akActor)
			if UDCDmain.TraceAllowed()
				libs.Log("Avoiding FTM duplication bug (Harness).")
			endif
			return 0
		EndIf
		if akActor.WornHasKeyword(libs.zad_DeviousCorset)
			if !silent
				MultipleItemFailMessage("Corset")
			endif
			return 2
		Endif
		; make sure collar harnesses don't do on if the target is already wearing one.
		if akActor.WornHasKeyword(libs.zad_DeviousCollar) && deviceRendered.HasKeyword(libs.zad_DeviousCollar)
			if !silent
				MultipleItemFailMessage("Collar")
			endif
			return 2
		Endif
		; make sure belt harnesses don't do on if the target is already wearing one.
		if akActor.WornHasKeyword(libs.zad_DeviousBelt) && deviceRendered.HasKeyword(libs.zad_DeviousBelt)
			if !silent
				MultipleItemFailMessage("Belt")
			endif
			return 2
		Endif
	Endif
	return 0
EndFunction

int Function EquipFilterPiercingV(actor akActor, bool silent=false)
	if akActor == none
		akActor == libs.PlayerRef
	EndIf
	if !akActor.IsEquipped(deviceRendered)
		if akActor!=libs.PlayerRef && ShouldEquipSilently(akActor)
			if UDCDmain.TraceAllowed()
				libs.Log("Avoiding FTM duplication bug (Vaginal Piercings).")
			endif
			return 0
		EndIf
		if akActor.WornHasKeyword(libs.zad_DeviousHarness)
			if akActor == libs.PlayerRef && !silent
				libs.NotifyActor("The harness you are wearing prevents you from inserting this piercing.", akActor, true)
			ElseIf  !silent
				libs.NotifyActor("The harness " + akActor.GetLeveledActorBase().GetName() + " is wearing prevents you from inserting this piercing.", akActor, true)
			EndIf
			if !silent
				return 2
			Else
				return 0
			EndIf
		Endif
		if akActor.WornHasKeyword(libs.zad_DeviousBelt)
			if akActor == libs.PlayerRef && !silent
				libs.NotifyActor("The belt you are wearing prevents you from inserting this piercing.", akActor, true)
			ElseIf  !silent
				libs.NotifyActor("The belt " + akActor.GetLeveledActorBase().GetName() + " is wearing prevents you from inserting this piercing.", akActor, true)
			EndIf
			if !silent
				return 2
			Else
				return 0
			EndIf
		Endif

	Endif
	return 0
EndFunction

int Function EquipFilterPiercingN(actor akActor, bool silent=false)
	if akActor == none
		akActor == libs.PlayerRef
	EndIf
	if !akActor.IsEquipped(deviceRendered)
		if akActor!=libs.PlayerRef && ShouldEquipSilently(akActor)
			libs.Log("Avoiding FTM duplication bug (Nipple Piercings).")
			return 0
		EndIf
		if akActor.WornHasKeyword(libs.zad_DeviousBra)
			if akActor == libs.PlayerRef && !silent
				libs.NotifyActor("The bra you are wearing prevents you from inserting these piercings.", akActor, true)
			ElseIf  !silent
				libs.NotifyActor("The bra " + akActor.GetLeveledActorBase().GetName() + " is wearing prevents you from inserting these piercings.", akActor, true)
			EndIf
			if !silent
				return 2
			Else
				return 0
			EndIf
		Endif
	Endif
	return 0
EndFunction

int Function EquipFilterStraitjacket(actor akActor, bool silent=false)
	if akActor == none
		akActor == libs.PlayerRef
	EndIf
	if !akActor.IsEquipped(deviceRendered)
		if akActor != libs.PlayerRef && ShouldEquipSilently(akActor)
			if UDCDmain.TraceAllowed()
				libs.Log("Avoiding FTM duplication bug (Straitjakcet).")
			endif
			return 0
		EndIf
		if akActor.WornHasKeyword(libs.zad_deviousSuit)
			if akActor == libs.PlayerRef && !silent
				libs.NotifyActor("You can't equip straitjacket while wearing bondage suit!", akActor, true)
			ElseIf  !silent
				libs.NotifyActor(akActor.GetLeveledActorBase().GetName() + " can't equip straitjacket because they are already wearing suit!", akActor, true)
			EndIf
			
			return 2
		Endif
	Endif
	return 0
EndFunction

string Function getDeviceName()
	return deviceInventory.getName()
EndFunction

;COPIED FROM zadequipscript
;reason is to make it possible to edit some values which were not editable before
Event LockDevice(Actor akActor)	
	if UDCDMain.TraceAllowed()
		libs.Log("OnEquipped("+akActor.GetLeveledActorBase().GetName()+": "+deviceInventory.GetName()+")")		
	endif
	if akActor == libs.PlayerRef
		if UDCDmain.TraceAllowed()		
			libs.log("Checking for active unequip operation for " + zad_DeviousDevice)
		endif
		int counter = 10 ; half second intervals, so 5 secs max
		while (StorageUtil.GetIntValue(akActor, "zad_RemovalOperation" + zad_DeviousDevice) == 1) && counter > 0
			libs.log("Device Swap detected. Waiting for removal operation to complete.")
			; this looks to be a device swap, let's wait a bit
			counter -= 1
			Utility.WaitMenuMode(0.5)
		EndWhile
		if UDCDmain.TraceAllowed()		
			libs.log("No active unequip operation running for " + zad_DeviousDevice + ". Proceeding")
		endif
	EndIf
	
	if akActor.GetItemCount(deviceRendered) > 0
		if UDCDmain.TraceAllowed()		
			libs.Log("OnEquipped aborted - item is already worn.")		
		endif
		; no need to process if the item is already worn
		return
	EndIf
	
	if akActor.GetItemCount(deviceRendered) == 0 && akActor.WornHasKeyword(zad_DeviousDevice) && CheckConflict(akActor)
		if UDCDmain.TraceAllowed()		
			libs.Log("Wearing conflicting device type:" + zad_DeviousDevice)		
		endif
		akActor.UnequipItem(deviceInventory, false, true)		
		return
	EndIf	
	
	;int loc_lockDeviceType = GetLockDeviceType(akActor)
	;StorageUtil.UnsetIntValue(akActor,"UD_LockDeviceType"+deviceInventory)
	
	bool silently = ShouldEquipSilently(akActor)
	
	; check for device conflicts
	If !silently && (IsEquipDeviceConflict(akActor) || IsEquipRequiredDeviceConflict(akActor))			
		akActor.UnequipItem(deviceInventory, false, true)		
		return
    EndIf	
	
	If !silently; && loc_lockDeviceType > 0; && !akActor.WornHasKeyword(zad_DeviousDevice) && akActor.GetItemCount(deviceRendered) == 0
		if akActor == Game.getPlayer();loc_lockDeviceType == 1
			if EquipDeviceMenu(akActor)
				akActor.UnequipItem(deviceInventory, false, true)
				return
			endif
		;elseif loc_lockDeviceType == 2
			;NPC menu, TODO
		endif
	EndIf	
	
	;filter
	int filter = OnEquippedFilter(akActor, silent=silently)
	if filter >= 1
		if filter == 2
			akActor.UnequipItem(deviceInventory, false, true)
		EndIf		
		return
	EndIf
	
	if akActor == libs.PlayerRef ; Store equipped devices for faster generic calls.
		StoreEquippedDevice(akActor)
		StorageUtil.SetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus", 0)
		StorageUtil.UnSetIntValue(akActor, "zad_UntightenToken" + deviceInventory)
		StorageUtil.UnSetIntValue(akActor, "zad_TightenToken" + deviceInventory)
	EndIf
	
	OnEquippedPre(akActor, silent=silently)
	
	libs.SendDeviceEquippedEvent(deviceName, akActor)
	libs.SendDeviceEquippedEventVerbose(deviceInventory, zad_DeviousDevice, akActor)
	
	if !akActor.IsEquipped(DeviceInventory)
		akActor.EquipItem(DeviceInventory, false, true)	
	EndIf	
	
	akActor.EquipItem(DeviceRendered, true, true)
	
	if akActor == libs.PlayerRef && !akActor.IsOnMount() && UI.IsMenuOpen("InventoryMenu")
		; make it visible for the player in case the menu is open
		akActor.QueueNiNodeUpdate()
	elseif akActor != libs.PlayerRef && !akActor.IsOnMount() && deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage)
		; prevent a bug with straitjackets and elbowbinders not hiding NPC hands when equipping these items.		
		akActor.UpdateWeight(0)		
	EndIf	
	if akActor != libs.PlayerRef && (deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage) || deviceRendered.HasKeyword(libs.zad_DeviousHobbleSkirt))
		libs.RepopulateNpcs()
	EndIf	
	
	OnEquippedPost(akActor)
	
	ResetLockShield()
	If TimedUnlock
		SetLockTimer()
	EndIf
	
	if akActor != libs.PlayerRef && akActor.GetActorBase().IsUnique() && (deviceRendered.HasKeyword(libs.zad_DeviousSuit) || deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage))
		; We change the outfit only for unique actors because SetOutfit() seems to operate on the ActorBASE and not the actor, so changing a non-unique actors's gear would change it for ALL instances of this actor.
        Outfit originalOutfit = akActor.GetActorBase().GetOutfit()
        If originalOutfit && originalOutfit != libs.zadEmptyOutfit
            StorageUtil.SetFormValue(akActor.GetActorBase(), "zad_OriginalOutfit", originalOutfit)
        EndIf
		akActor.SetOutfit(libs.zadEmptyOutfit, false)
	endIf
	
	if CanApplyBoundEffect(akActor) 
		libs.StartBoundEffects(akActor)	
	endif
EndEvent


bool Function CanApplyBoundEffect(Actor akActor) 
	bool loc_res = false
	loc_res = loc_res || deviceRendered.haskeyword(libs.zad_DeviousHeavyBondage)
	loc_res = loc_res || deviceRendered.haskeyword(libs.zad_DeviousHobbleSkirt)
	loc_res = loc_res || deviceRendered.haskeyword(libs.zad_DeviousPonyGear)
	return loc_res
EndFunction


bool Function CheckConflict(Actor akActor)
	if akActor.wornhaskeyword(libs.zad_DeviousHeavyBondage) && (zad_DeviousDevice == libs.zad_DeviousHeavyBondage)
		;check invisible armbinder
		if UDCDMain.HaveInvisibleArmbinderEquiped(akActor)
			UDCDmain.UnequipInvisibleArmbinder(akActor)
			if !akActor.wornhaskeyword(libs.zad_DeviousHeavyBondage)
				;actor already have invisible armbinder and heavy bondage equipped
				return false
			else
				;actor already have heavy bondage and IA
				return true
			endif
		endif
	endif
	
	if akActor.wornhaskeyword(libs.zad_DeviousHobbleSkirt) && (zad_DeviousDevice == libs.zad_DeviousHobbleSkirt)
		;check invisible hobble
		if UDCDMain.HaveInvisibleHobbleEquiped(akActor)
			UDCDmain.UnequipInvisibleHobble(akActor)
			if !akActor.wornhaskeyword(libs.zad_DeviousHobbleSkirt)
				;actor already have invisible hobble and hobble skirt equipped
				return false
			else
				;actor already have hobble skirt and IH
				return true
			endif
		endif
	endif
	return true
EndFunction

bool Function EquipDeviceMenu(Actor akActor)
	Int msgChoice = zad_DeviceMsg.Show() ; display menu
	if msgChoice == 0 ;equip
		StorageUtil.SetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_ManipulatedStatus", 0)
		If !DisableLockManipulation && libs.Config.UseItemManipulation && ( deviceRendered.HasKeyword(libs.zad_Lockable) || deviceInventory.HasKeyword(libs.zad_Lockable) ) && !deviceInventory.HasKeyword(libs.zad_QuestItem) && !deviceRendered.HasKeyword(libs.zad_QuestItem) && !deviceInventory.HasKeyword(libs.zad_BlockGeneric) && !deviceRendered.HasKeyword(libs.zad_BlockGeneric) 
			Int Choice = 0
			If zad_DD_OnPutOnDevice
				Choice = zad_DD_OnPutOnDevice.Show()
			Else
				Choice = libs.zad_DD_OnPutOnDevice.Show()
			EndIf
			If Choice == 1
				StorageUtil.SetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_ManipulatedStatus", 1)					
			EndIf
		EndIf
		return false
	elseif msgChoice == 1 ;details
		ShowDetails(akActor)
		return true
	else
		return true
	endif
	return false
EndFunction

Function ShowDetails(Actor akActor)
	string loc_msg = ""
	loc_msg += "-" + getDeviceName() + "-\n"
	loc_msg += "Type: " + libs.LookupDeviceType(zad_DeviousDevice) + "\n"
	UDCDmain.ShowMessageBox(loc_msg)
EndFunction