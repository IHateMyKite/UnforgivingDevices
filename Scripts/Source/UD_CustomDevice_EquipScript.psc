Scriptname UD_CustomDevice_EquipScript extends zadequipscript  

import MfgConsoleFunc
import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain auto
zadlibs_UDPatch Property libsp
    zadlibs_UDPatch Function get()
        return UDCDmain.libsp
    EndFunction
endproperty
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
endproperty
UD_MutexManagerScript Property UDMM
    UD_MutexManagerScript Function get()
        return UDmain.UDMM
    EndFunction
endproperty


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
        
        zad_DeviceMsg =    UDCDmain.DefaultEquipDeviceMessage
    endif
    Actor giver = akOldContainer as Actor
    Actor target = akNewContainer as Actor
        
    Int loc_ignoreEventTarget = StorageUtil.GetIntValue(target, "UD_ignoreEvent" + deviceInventory, 0)
    if  Math.LogicalAnd(loc_ignoreEventTarget,0x001)
        if Math.LogicalAnd(loc_ignoreEventTarget,0x004)
            ;prevents removal
            akNewContainer.removeItem(deviceInventory,1,True,akOldContainer)
        endif
        if Math.LogicalAnd(loc_ignoreEventTarget,0x002)
            StorageUtil.SetIntValue(target, "UD_ignoreEvent" + deviceInventory,Math.LogicalAnd(loc_ignoreEventTarget,0xFF0))
        endif
        if UDmain.TraceAllowed()
            UDmain.Log("UD_ignoreEvent actived on " + self + " for " + target)
        endif
        return
    endif
    
    Int loc_ignoreEventGiver = StorageUtil.GetIntValue(giver, "UD_ignoreEvent" + deviceInventory, 0)
    if Math.LogicalAnd(loc_ignoreEventGiver,0x001)
        if Math.LogicalAnd(loc_ignoreEventGiver,0x004)
            ;prevents removal
            akOldContainer.removeItem(deviceInventory,1,True,akNewContainer)
        endif
        if Math.LogicalAnd(loc_ignoreEventGiver,0x002)
            StorageUtil.SetIntValue(giver, "UD_ignoreEvent" + deviceInventory,Math.LogicalAnd(loc_ignoreEventGiver,0xFF0))
        endif
        if UDmain.TraceAllowed()
            UDmain.Log("UD_ignoreEvent actived on " + self + " for " + giver)
        endif
        return
    endif
    
    if UDCDmain
        if target && giver
            if UDmain.TraceAllowed()            
                UDmain.Log(" Device " + deviceInventory.getName() + " moved from " + giver.getActorBase().getName() + " to " + target.getActorBase().getName(),3)
            endif
        endif
        
        if target && akOldContainer == UDCDmain.EventContainer_ObjRef
            deviceReturned = True
            return
        endif
        
        if akNewContainer == UDCDmain.EventContainer_ObjRef && giver
            if UDmain.TraceAllowed()
                UDmain.Log(" Device " + deviceInventory.getName() + " send to Event Container! Waiting for device to return to inventory!",3)
            endif
            while !deviceReturned
                Utility.WaitMenuMode(0.01)
            endwhile
            deviceReturned = False
            if UDmain.TraceAllowed()
                UDmain.Log(" Device regained! Starting unlock operations!",1)
            endif
            unlockDevice(giver)
            return
        endif
        
        if UDmain.IsContainerMenuOpen()
            if target && giver
                if !target.isDead() && !giver.isDead()
                    if giver.getItemCount(deviceRendered) && giver.getItemCount(deviceInventory) == 0
                        if UDmain.TraceAllowed()                        
                            UDmain.Log("Opening device menu for " + deviceInventory.getName() + " on "+ giver.getActorBase().getName() +" , helper:  " + target.getActorBase().getName(),1)
                        endif
                        StorageUtil.SetIntValue(giver, "UD_ignoreEvent" + deviceInventory, 0x111)
                        StorageUtil.SetIntValue(target, "UD_ignoreEvent" + deviceInventory, 0x333)
                        target.removeItem(deviceInventory,1,True,giver)
                        giver.EquipItem(deviceInventory, false, true)
                        openWHMenu(giver,target)
                        StorageUtil.UnSetIntValue(giver, "UD_ignoreEvent" + deviceInventory)
                        StorageUtil.UnSetIntValue(target, "UD_ignoreEvent" + deviceInventory)
                        return
                    elseif !IsPlayer(target) && !target.getItemCount(deviceRendered) && target.getItemCount(deviceInventory)
                        if UDmain.TraceAllowed()                        
                            UDmain.Log("OnContainerChanged - Locking device " + deviceInventory.getName() + " to "+ target.getActorBase().getName(),1)
                        endif
                        if UDmain.ActorIsValidForUD(target)
                            if IsPlayer(giver)
                                if !EquipDeviceMenu(target)
                                    UDmain.Print("You equip and lock " + getDeviceName() + " on " + GetActorName(target))
                                else
                                    return
                                endif
                            endif
                            LockDevice(target,False) ;no mutex needed, lets assume user can't lock npc in devices faster then they need to be locked on
                        else
                            UDmain.Error("OnContainerChanged - " + target + " is not valid actor!")
                        endif
                        return
                    else
                        ;only tranfere device, nothink else
                        return
                    endif
                else
                    if giver.getItemCount(deviceRendered); && DestroyOnRemove
                        if UDmain.TraceAllowed()
                            UDmain.Log("Removing device from dead actor " + deviceInventory.getName() + " on "+ giver.getActorBase().getName(),1)
                        endif
                        UD_Native.SendRemoveRenderDeviceEvent(giver,deviceRendered)
                        if DestroyOnRemove
                            target.removeItem(deviceInventory,1,True)
                        endif
                        giver.removeItem(deviceRendered,1,True)
                    else
                        if UDmain.TraceAllowed()                        
                            UDmain.Log("Removing ID device" + deviceInventory.getName() + " on "+ giver.getActorBase().getName(),1)
                        endif
                        ;do nothing, no need to make thinks complicated
                        if DestroyOnRemove
                            target.removeItem(deviceInventory,1,True)
                        endif
                        return
                    endif
                endif
            endif
        endif
    endif
    
    if giver
        ;ID removed even when render device is still present, put ID back to actor
        if giver.getItemCount(deviceRendered) && !giver.getItemCount(deviceInventory)
            UDmain.Warning("Remove attempt detected for " + self + " - Prevented")
            akNewContainer.removeItem(deviceInventory,1,True,giver)
            StorageUtil.SetIntValue(giver, "UD_ignoreEvent" + deviceInventory, 0x030)
            giver.EquipItem(deviceInventory,False,True)
        endif
    endif
    parent.OnContainerChanged(akNewContainer,akOldContainer)
EndEvent

Function openWHMenu(Actor akTarget,Actor akSource)
    if UDmain.IsEnabled()
        if UDmain.TraceAllowed()
            UDmain.Log(" NPC menu opened for " + deviceInventory.getName() + " (" + akTarget.getActorBase().getName() + ") by " + akSource.getActorBase().getName(),1)
        endif
        UDCDMain.ShowHelpDeviceMenu(getUDScript(akTarget),akSource,UDmain.ActorIsFollower(akTarget))
    endif
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
    if UDmain.TraceAllowed()    
        UDmain.Log("OnRemoveDevice called for " + deviceInventory.getName() + " on " + akActor.getLeveledActorBase().getName(),3)
    endif
        
    if !akActor.isDead()
        if deviceRendered.hasKeyword(libs.zad_DeviousHeavyBondage)
            UDCDmain.UpdateInvisibleArmbinder(akActor)
        endif
        if deviceRendered.hasKeyword(libs.zad_DeviousHobbleSkirt)
            UDCDmain.UpdateInvisibleHobble(akActor)
        endif
    endif
    
    if deviceRendered.hasKeyword(libs.zad_DeviousGag)
        libs.RemoveGagEffect(akActor)
        if  deviceRendered.hasKeyword(libs.zad_DeviousGagPanel)
            if akActor.GetFactionRank(UDCDmain.zadGagPanelFaction) == 0
                akActor.RemoveItem(zad_GagPanelPlug, 1)
            EndIf
            akActor.SetFactionRank(UDCDmain.zadGagPanelFaction, 0)
            akActor.RemoveFromFaction(UDCDmain.zadGagPanelFaction)
        endif
    endif
EndFunction

;this is only called if game is unpaused (in case of NPC) or if actor is player (work all time)
;if NPC, game needs to ba unpaused first. Bause of that adding bunch of devices at once on the NPC will make them blocked untill player exit container menu
Event OnEquipped(Actor akActor) 
    ;Debug.StartStackProfiling()
    if UDmain.TraceAllowed()    
        UDmain.Log("OnEquipped("+MakeDeviceHeader(akActor,deviceInventory)+") - called",3)
    endif
    Int loc_ignoreEvent = StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0)
    if Math.LogicalAnd(loc_ignoreEvent,0x010)
        if UDmain.TraceAllowed()        
            UDmain.Log("OnEquipped("+MakeDeviceHeader(akActor,deviceInventory)+") -  aborted because of filter",3)
        endif
        if Math.LogicalAnd(loc_ignoreEvent,0x030)
            StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,Math.LogicalAnd(loc_ignoreEvent,0xF0F))
        endif
        return
    endif
    
    if !UDCDmain
        UDCDmain = Game.getFormFromFile(0x0015E73C,"UnforgivingDevices.esp") as UDCustomDeviceMain
    endif
    
    if !zad_DeviceMsg
        zad_DeviceMsg = UDCDmain.DefaultEquipDeviceMessage
    endif
    
    LockDevice(akActor)
EndEvent

Event OnUnequipped(Actor akActor)
    if UDmain.TraceAllowed()    
        UDmain.Log("OnUnequipped("+MakeDeviceHeader(akActor,deviceInventory)+") - called",3)
    endif

    if UDmain.IsContainerMenuOpen() && IsPlayer(akActor)
        if UDmain.TraceAllowed()        
            UDmain.Log("OnUnequipped("+MakeDeviceHeader(akActor,deviceInventory)+") - aborted because of opened menu",3)
        endif
        return
    endif

    if Math.LogicalAnd(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x100)
        if UDmain.TraceAllowed()        
            UDmain.Log("OnUnequipped("+MakeDeviceHeader(akActor,deviceInventory)+") - aborted because of filter",3)
        endif
        if Math.LogicalAnd(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x300)
            StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,Math.LogicalAnd(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x0FF))
        endif
        return
    endif

    parent.OnUnequipped(akActor)
EndEvent

;device menu that pops up when Wearer click on this device in inventory
Function DeviceMenu(Int msgChoice = 0)
    if UDmain.IsEnabled()
        if UDmain.TraceAllowed()    
            UDmain.Log("DeviceMenu("+MakeDeviceHeader(UDmain.Player,deviceInventory)+")",1)
        endif
        UD_CustomDevice_RenderScript device = UDCDmain.getDeviceByInventory(UDmain.Player,deviceInventory)
        if device
            UDCDmain.getDeviceByInventory(UDmain.Player,deviceInventory).DeviceMenu(new Bool[30])
        else
            UDCDmain.getDeviceScriptByRender(UDmain.Player,deviceRendered).DeviceMenu(new Bool[30])
        endif
    endif
EndFunction

Function OnEquippedPre(actor akActor, bool silent=false)
    ;StorageUtil.setIntValue(akActor,"zad_Equipped" + deviceInventory,1)
    ;StorageUtil.setIntValue(akActor,"zad_Equipped" + deviceRendered,1)
    StorageUtil.setFormValue(deviceInventory    ,"UD_RenderDevice"        ,deviceRendered)
    StorageUtil.setFormValue(deviceRendered        ,"UD_InventoryDevice"    ,deviceInventory)
    
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
                    msg = "Barely in control of your own body you thrust the plug almost forcefully into the appropriate opening."
                endif
            else
                msg = akActor.GetLeveledActorBase().GetName() + " shudders as you push the plugs into her."
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
            libs.NotifyActor("You step into the harness, securing it tightly against your body.", akActor, true)
        Else
            libs.NotifyActor(GetMessageName(akActor) +" steps into the harness, securing it tightly against her body.", akActor, true)
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
    if UDmain.TraceAllowed()
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
    ;    return EquipFilterStraitjacket(akActor,silent)
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
            libs.NotifyActor("The belt " + GetActorName(akActor) + " is wearing prevents plug from being inserted.", akActor, true)
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
            if UDmain.TraceAllowed()
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
            if UDmain.TraceAllowed()
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
            if UDmain.TraceAllowed()
                libs.Log("Avoiding FTM duplication bug (Straitjacket).")
            endif
            return 0
        EndIf
        if akActor.WornHasKeyword(libs.zad_deviousSuit)
            if akActor == libs.PlayerRef && !silent
                libs.NotifyActor("You can't equip straitjacket while wearing bondage suit!", akActor, true)
            ElseIf  !silent
                libs.NotifyActor(akActor.GetLeveledActorBase().GetName() + " is already wearing a suit so straitjacket can't be equipped!", akActor, true)
            EndIf
            
            return 2
        Endif
    Endif
    return 0
EndFunction

string Function GetDeviceName()
    return deviceInventory.getName()
EndFunction

;COPIED FROM zadequipscript
;reason is to make it possible to edit some values which were not editable before
Event LockDevice(Actor akActor, Bool abUseMutex = True)
    if UDmain.TraceAllowed()
        UDmain.Log("LockDevice("+MakeDeviceHeader(akActor,deviceInventory)+") called")
    endif
    
    UD_CustomDevice_NPCSlot loc_slot        = none
    UD_MutexScript          loc_mutex       = none
    bool                    _actorselfbound = false
    bool                    loc_isplayer    = IsPlayer(akActor)
    
    if abUseMutex
        loc_slot = UDCDmain.getNPCSlot(akActor)
        if loc_slot
            if !loc_slot.isLockMutexed(deviceInventory)
                _actorselfbound = true
                loc_slot.StartLockMutex()
                loc_slot.ResetMutex_Lock(deviceInventory)
            endif
        else
            Utility.waitMenuMode(RandomFloat(0.05,0.15)) ;make thread to wait random time, because in some cases bunch of devices can be equipped at once (like when they are par of outfit)
            if !UDMM.IsDeviceMutexed(akActor,deviceInventory)
                _actorselfbound = true
                if UDmain.TraceAllowed()
                    UDmain.Log("LockDevice("+MakeDeviceHeader(akActor,deviceInventory) + ") : Not using mutex on " + akActor)
                endif
                ;loc_mutex = UDMM.WaitForFreeAndSet_Lock(akActor,deviceInventory)
                ;unregistered npcs will be not mutexed, no reason for that
            else
                loc_mutex = UDMM.GetMutexSlot(akActor)
                if UDmain.TraceAllowed()        
                    UDmain.Log("LockDevice("+MakeDeviceHeader(akActor,deviceInventory) + ") : Found mutex for NPC - " + loc_mutex)
                endif
            endif
        endif
    endif
    
    Int prelock_fail = 0
    int loc_rdnum = akActor.GetItemCount(deviceRendered)
    if loc_rdnum > 0    
        if UDmain.UD_WarningAllowed
            UDmain.Warning("LockDevice("+MakeDeviceHeader(akActor,deviceInventory) + ") - item "+ deviceRendered +" is already in inventory. Aborting")
        endif
        prelock_fail = 1
    EndIf
    
    if !prelock_fail
        if loc_rdnum == 0 && akActor.WornHasKeyword(zad_DeviousDevice) && CheckConflict(akActor)
            ;if UDmain.UD_WarningAllowed
            ;    UDmain.Warning("LockDevice("+MakeDeviceHeader(akActor,deviceInventory) + ") - Wearing conflicting device type:" + zad_DeviousDevice)
            ;endif
            StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,Math.LogicalOr(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x300))
            akActor.UnequipItem(deviceInventory, false, true)
            prelock_fail = 2
        EndIf
    endif
    
    bool silently = ShouldEquipSilently(akActor)
    
    ; check for device conflicts
    if !prelock_fail
        If !silently && (IsEquipDeviceConflict(akActor) || IsEquipRequiredDeviceConflict(akActor))
            ;if UDmain.UD_WarningAllowed
            ;    UDmain.Warning("LockDevice("+MakeDeviceHeader(akActor,deviceInventory) + ") - Wearing conflicting device, aborting")
            ;endif
            StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,Math.LogicalOr(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x300))
            akActor.UnequipItem(deviceInventory, false, true)
            prelock_fail = 3
        EndIf
    endif    
    
    If !silently && !prelock_fail
        if IsPlayer(akActor);loc_lockDeviceType == 1
            if EquipDeviceMenu(akActor)
                StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,Math.LogicalOr(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x300))
                akActor.UnequipItem(deviceInventory, false, true)
                prelock_fail = 4
            endif
        ;elseif loc_lockDeviceType == 2
            ;NPC menu, TODO
        endif
    EndIf    
    
    ;filter
    int filter = OnEquippedFilter(akActor, silent=silently)
    if !prelock_fail
        if filter >= 1
            if filter == 2
                StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,Math.LogicalOr(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x300))
                akActor.UnequipItem(deviceInventory, false, true)
            EndIf
            ;if UDmain.UD_WarningAllowed
            ;    UDmain.Warning("LockDevice("+MakeDeviceHeader(akActor,deviceInventory) + ") - Equip Filter activated : " + filter)
            ;endif
            prelock_fail = 5
        EndIf
    endif
    
    ;check if render device have render device keyword! If not, the device was not patched correctly!
    if !DeviceRendered.hasKeyword(UDmain.UDlibs.UnforgivingDevice)
        prelock_fail = 6
        UDmain.Error(MakeDeviceHeader(akActor,deviceInventory) + " can't be locked because its patched incorrectly!!!! Check patch order and try to lock the device again!")
    endif
    
    if prelock_fail
        if abUseMutex
            if loc_slot
                if loc_slot.isLockMutexed(deviceInventory)
                    loc_slot.UD_GlobalDeviceMutex_InventoryScript_Failed = prelock_fail
                    loc_slot.UD_GlobalDeviceMutex_InventoryScript = true
                endif
            elseif loc_mutex
                loc_mutex.UD_GlobalDeviceMutex_InventoryScript_Failed = prelock_fail
                loc_mutex.UD_GlobalDeviceMutex_InventoryScript = true
            endif
            
            if _actorselfbound
                if loc_slot
                    if loc_slot.isLockMutexed(deviceInventory)
                        loc_slot.EndLockMutex()
                    endif
                elseif loc_mutex
                    loc_mutex.ResetLockMutex()
                endif
                _actorselfbound = false
            endif
        endif
        if DestroyOnRemove && !akActor.GetItemCount(deviceRendered)
            akActor.RemoveItem(deviceInventory,1,true)
        endif
        
        return
    endif
    
    _locked = true
    
    Bool loc_haveHBkwd = deviceRendered.HasKeyword(libs.zad_DeviousHeavyBondage)
    Bool loc_haveHSkwd = deviceRendered.hasKeyword(libs.zad_DeviousHobbleSkirt)
    
    ;in case device is hobble skirt, unequip the invisible hobble, so it doesn't cause issue
    ;will be reequipúped after device is unlocked
    if loc_haveHSkwd
        UDCDmain.UnequipInvisibleHobble(akActor)
    endif
    
    ;in case device is heavy bondage, unequip the invisible hobble, so it doesn't cause issue
    ;will be reequipúped after device is unlocked
    if loc_haveHBkwd
        UDCDmain.UnequipInvisibleArmbinder(akActor)
    endif
    
    akActor.EquipItem(DeviceRendered, true, true)
    
    if abUseMutex
        int loc_timeoutticks = Round(UDmain.UDGV.UD_LockTimeoutID/0.05)
        ;check if device was equipped succesfully
        bool loc_rdok = _CheckRD(akActor,loc_timeoutticks)
        
        ;in case that the equip failed and menu is open, wait for menu to close first, and then try again
        if !loc_isplayer && !loc_rdok && UDmain.IsAnyMenuOpenRT() && UDmain
            Utility.wait(0.01) ;wait for menu to close
            loc_rdok = _CheckRD(akActor,loc_timeoutticks)
        endif
        if !loc_rdok
            Armor loc_conflictDevice = UDCDmain.GetConflictDevice(akActor,deviceRendered)
            if !loc_conflictDevice.haskeyword(libs.zad_Lockable)
                akActor.unequipItem(loc_conflictDevice)
                Utility.waitmenumode(0.25)
                akActor.equipitem(deviceRendered, true, true)
                loc_rdok = _CheckRD(akActor,loc_timeoutticks/2)
            endif
            if !loc_rdok
                ;render device lock failed, abort
                _locked = false
                StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,Math.LogicalOr(StorageUtil.GetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0),0x300))
                akActor.UnequipItem(deviceInventory, false, true)
                if DestroyOnRemove
                    akActor.RemoveItem(deviceInventory,1,true)
                endif
                akActor.removeItem(DeviceRendered,1,true)
                
                UDmain.Error("LockDevice("+getDeviceName()+","+GetActorName(akActor)+") failed. Render device is not equipped - conflict with " + loc_conflictDevice)
                if IsPlayer(akActor)
                    UDmain.Print(getDeviceName() + " can't be equipped because of device conflict")
                elseif UDCDmain.UDmain.ActorInCloseRange(akActor)
                    UDmain.Print(MakeDeviceHeader(akActor,deviceInventory) + " can't be equipped because of device conflict")
                endif
            endif
        endif
        if loc_slot
            if loc_slot.isLockMutexed(deviceInventory)
                if !_locked
                    loc_slot.UD_GlobalDeviceMutex_InventoryScript_Failed = 7
                endif
                loc_slot.UD_GlobalDeviceMutex_InventoryScript = true
            endif
        elseif loc_mutex
            if !_locked
                loc_mutex.UD_GlobalDeviceMutex_InventoryScript_Failed = 7
            endif
            loc_mutex.UD_GlobalDeviceMutex_InventoryScript = true
        endif
    endif
    if _actorselfbound
        if loc_slot
            if loc_slot.isLockMutexed(deviceInventory)
                loc_slot.EndLockMutex()
            endif
        elseif loc_mutex
            loc_mutex.ResetLockMutex()
        endif
        _actorselfbound = false
    endif
    
    if !_locked
        return
    endif
    
    ;close menu if actor equipped hand restrain and hardcore mode is om
    if (IsPlayer(akActor) && UDmain.IsInventoryMenuOpen() && loc_haveHBkwd && UDCDmain.UD_HardcoreMode)
        CloseMenu()
    endif
    
    OnEquippedPre(akActor, silent=silently)
    
    if akActor == libs.PlayerRef ; Store equipped devices for faster generic calls.
        StoreEquippedDevice(akActor)
        StorageUtil.SetIntValue(akActor, "zad_Equipped" + libs.LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus", 0)
    EndIf
    
    libs.SendDeviceEquippedEvent(deviceName, akActor)
    libs.SendDeviceEquippedEventVerbose(deviceInventory, zad_DeviousDevice, akActor)
    
    if IsPlayer(akActor) && !akActor.IsOnMount() && UDmain.IsMenuOpen()
        ; make it visible for the player in case the menu is open
        akActor.QueueNiNodeUpdate()
    elseif !IsPlayer(akActor) && !akActor.IsOnMount() && loc_haveHBkwd
        ; prevent a bug with straitjackets and elbowbinders not hiding NPC hands when equipping these items.
        akActor.UpdateWeight(0)
    EndIf    
    if !IsPlayer(akActor) && (loc_haveHBkwd || loc_haveHSkwd)
        libs.RepopulateNpcs()
    EndIf
    
    OnEquippedPost(akActor)
    
    ResetLockShield()
    If TimedUnlock
        SetLockTimer()
    EndIf
    if CanApplyBoundEffect(akActor,loc_haveHBkwd,loc_haveHSkwd)
        libs.StartBoundEffects(akActor)
    endif
EndEvent

;1 tick = 0.05 s ; 20 ticks = 1 s
Bool Function _CheckRD(Actor akActor, Int aiTicks)
    int loc_ticks = 0
    while loc_ticks <= aiTicks && !UDCDmain.CheckRenderDeviceEquipped(akActor, deviceRendered)
        Utility.waitMenuMode(0.05)
        loc_ticks += 1
    endwhile
    return loc_ticks < aiTicks
EndFunction

Function unlockDevice(Actor akActor)
    bool loc_failure = false
    StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory,0x111)
    Int loc_RDNum = akActor.getItemCount(deviceRendered)
    if !loc_RDNum
        loc_failure = true
        if IsPlayer(akActor)
            akActor.unequipItem(deviceInventory, 1, true)
        endif
    endif
    
    UD_CustomDevice_NPCSlot loc_slot    = none
    UD_MutexScript          loc_mutex   = none 
    
    if !loc_failure
        loc_slot = UDCDmain.getNPCSlot(akActor)
        if !loc_slot
            loc_mutex = UDMM.GetMutexSlot(akActor)
        endif
    endif
    
    if !loc_failure
        ;process quest device
        If DeviceRendered.HasKeyword(Libs.Zad_QuestItem) || DeviceInventory.HasKeyword(Libs.Zad_QuestItem)    
            Keyword loc_unlocktoken = none
            if loc_slot
                loc_unlocktoken = loc_slot.UD_UnlockToken
            elseif loc_mutex
                loc_unlocktoken = loc_mutex.UD_UnlockToken 
            endif
            bool loc_cond = false
            loc_cond = loc_cond || loc_unlocktoken == None
            loc_cond = loc_cond || libs.zadStandardKeywords.HasForm(loc_unlocktoken)
            loc_cond = loc_cond || (!DeviceRendered.HasKeyword(loc_unlocktoken) && !DeviceInventory.HasKeyword(loc_unlocktoken))
            if loc_cond
                UDmain.Error(MakeDeviceHeader(akActor,deviceInventory) + "::unlockDevice() - Caught and prevented unauthorized removal attempt of quest device!")
                loc_failure = true
            else
                UDmain.Info(MakeDeviceHeader(akActor,deviceInventory) + "::unlockDevice() - Correct token received -> unlocking quest device")
            endif
        endif
    endif
    
    if !loc_failure
        akActor.unequipItem(deviceInventory, 1, true)
        UD_Native.SendRemoveRenderDeviceEvent(akActor,deviceRendered)
        ;UD_CustomDevice_RenderScript loc_device = getUDScript(akActor)
        akActor.RemoveItem(deviceRendered, loc_RDNum, true)
        ;if loc_device
        ;    loc_device.removeDevice(akActor)
        ;else
        ;    UDmain.Error(MakeDeviceHeader(akActor,deviceInventory) + "::unlockDevice() - Could not get RD script! Unlock operation on " + self)
        ;endif
    endif

    if loc_slot
        loc_slot.UD_GlobalDeviceUnlockMutex_InventoryScript_Failed      = loc_failure
        loc_slot.UD_GlobalDeviceUnlockMutex_InventoryScript             = True
    else
        if !loc_mutex
            loc_mutex = UDMM.GetMutexSlot(akActor)
        endif
        if loc_mutex
            loc_mutex.UD_GlobalDeviceUnlockMutex_InventoryScript_Failed     = loc_failure
            loc_mutex.UD_GlobalDeviceUnlockMutex_InventoryScript            = True
        endif
    endif
    
    if !loc_failure
        OnRemoveDevice(akActor)
        
        UnsetStoredDevice(akActor)
        
        libs.SendDeviceRemovalEvent(libs.LookupDeviceType(zad_DeviousDevice), akActor)
        libs.SendDeviceRemovedEventVerbose(deviceInventory, zad_DeviousDevice, akActor)
        
        If CanApplyBoundEffect(akActor) 
            libs.StopBoundEffects(akActor)
        EndIf
    endif
    
    StorageUtil.UnSetIntValue(akActor, "UD_ignoreEvent" + deviceInventory)
EndFunction

bool Function CanApplyBoundEffect(Actor akActor,bool abHaveHB = False, bool abHaveHS = False) 
    bool loc_res = false
    loc_res = loc_res || abHaveHB || deviceRendered.haskeyword(libs.zad_DeviousHeavyBondage)
    loc_res = loc_res || abHaveHS || deviceRendered.haskeyword(libs.zad_DeviousHobbleSkirt)
    loc_res = loc_res || deviceRendered.haskeyword(libs.zad_DeviousPonyGear)
    return loc_res
EndFunction

bool Function CheckConflict(Actor akActor)
    if akActor.wornhaskeyword(libs.zad_DeviousHeavyBondage) && (zad_DeviousDevice == libs.zad_DeviousHeavyBondage)
        Bool loc_res = False
        ;check invisible armbinder
        if UDCDMain.HaveInvisibleArmbinderEquiped(akActor)
            UDCDmain.UnequipInvisibleArmbinder(akActor)
            if !akActor.wornhaskeyword(libs.zad_DeviousHeavyBondage)
                ;actor already have invisible armbinder and heavy bondage equipped
                loc_res = false
            else
                ;actor already have heavy bondage and IA
                loc_res = true
            endif
            UDCDmain.EquipInvisibleArmbinder(akActor)
        endif
        return loc_res
    endif
    
    if akActor.wornhaskeyword(libs.zad_DeviousHobbleSkirt) && deviceRendered.hasKeyword(libs.zad_DeviousHobbleSkirt)
        Bool loc_res = False
        ;check invisible hobble
        if UDCDMain.HaveInvisibleHobbleEquiped(akActor)
            UDCDmain.UnequipInvisibleHobble(akActor)
            if !akActor.wornhaskeyword(libs.zad_DeviousHobbleSkirt)
                ;actor already have invisible hobble and hobble skirt equipped
                loc_res = false
            else
                ;actor already have hobble skirt and IH
                loc_res = true
            endif
            UDCDmain.EquipInvisibleHobble(akActor)
        endif
        return loc_res
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
    string loc_res = ""
    
    loc_res += UDMain.UDMTF.Header(getDeviceName(), UDMain.UDMTF.FontSize + 4)
    loc_res += UDMain.UDMTF.FontBegin(aiFontSize = UDMain.UDMTF.FontSize, asColor = UDMain.UDMTF.TextColorDefault)
    loc_res += UDMain.UDMTF.TableBegin(aiLeftMargin = 40, aiColumn1Width = 150)
    loc_res += UDMain.UDMTF.HeaderSplit()

    loc_res += UDMain.UDMTF.TableRowDetails("Type:", libs.LookupDeviceType(zad_DeviousDevice))
    loc_res += UDMain.UDMTF.LineGap()
    
    if deviceInventory.hasKeyword(UDmain.UDlibs.PatchedInventoryDevice) && deviceRendered.hasKeyword(UDmain.UDlibs.PatchedDevice)
        loc_res += UDMain.UDMTF.Paragraph("-- Patched device --", asAlign = "center")
        loc_res += UDMain.UDMTF.LineGap()
        loc_res += UDMain.UDMTF.TableRowDetails("Struggle escape chance:", Round(BaseEscapeChance) + "%")
        loc_res += UDMain.UDMTF.TableRowDetails("Cut escape chance:", Round(CutDeviceEscapeChance) + "%")
        loc_res += UDMain.UDMTF.TableRowDetails("Lockpick escape chance:", Round(LockPickEscapeChance) + "%")
        loc_res += UDMain.UDMTF.TableRowDetails("Lock Access difficulty:", Round(LockAccessDifficulty) + "%")
        loc_res += UDMain.UDMTF.TableRowDetails("Key:", deviceKey.getName())
    endif
    
    loc_res += UDMain.UDMTF.FooterSplit()
    loc_res += UDMain.UDMTF.TableEnd()
    loc_res += UDMain.UDMTF.FontEnd()
    
    UDmain.ShowMessageBox(loc_res, UDMain.UDMTF.HasHtmlMarkup(), False)
EndFunction

bool Function ShouldEquipSilently(actor akActor)
    return parent.ShouldEquipSilently(akActor) || (!UDmain.ActorIsFollower(akActor) && !IsPlayer(akActor))
EndFunction