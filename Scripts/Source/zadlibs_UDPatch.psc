Scriptname zadlibs_UDPatch extends zadlibs

import MfgConsoleFunc
import sslBaseExpression
import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDMain.UDmain
    EndFunction
EndProperty
UD_MutexManagerScript Property UDMM
    UD_MutexManagerScript Function get()
        return UDmain.UDMM
    EndFunction
EndProperty
UD_Libs Property UDlibs
    UD_Libs Function get()
        return UDmain.UDlibs
    EndFunction
EndProperty
UD_OrgasmManager Property UDOM
    UD_OrgasmManager Function get()
        return UDmain.UDOM
    EndFunction
EndProperty

bool Property UD_StartThirdPersonAnimation_Switch = true auto

Function LockDevice_Paralel(actor akActor, armor deviceInventory, bool force = false)
    UDCDmain.LockDeviceParalel(akActor,deviceInventory,force)
EndFunction

Bool Function LockDevice(actor akActor, armor deviceInventory, bool force = false)
    if UDmain.TraceAllowed()    
        UDmain.Log("LockDevice("+MakeDeviceHeader(akActor,deviceInventory)+")",3)
    endif
    return LockDevicePatched(akActor, deviceInventory, force)
EndFunction

bool Function isMutexed(Actor akActor,Armor invDevice)
    return UDMM.IsDeviceMutexed(akActor,invDevice)
EndFunction

bool Property DD_LockDeviceBlocking = true auto
UD_CustomDevice_NPCSlot _lastLockSlot  = none
UD_MutexScript          _lastLockMutex = none
Bool Function LockDevicePatched(actor akActor, armor deviceInventory, bool force = false)
    if !deviceInventory
        UDmain.Warning("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - none passed as deviceInventory")
        return false
    endif
    if !akActor
        UDmain.Warning("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - none passed as akActor")
        return false
    endif
    if !deviceInventory.haskeyword(zad_inventoryDevice)
        UDmain.Warning("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - passed armor is not devious device. Aborting!")
        return false
    endif
    if !UDmain.ActorIsValidForUD(akActor)
        UDmain.Warning("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") is not valid actor or dead! Aborting")
        return false
    endif
    
    if !IsPlayer(akActor)
        StorageUtil.AdjustIntValue(akActor,"UDLockOperations",1) ;increase number of lock operations for NPC. Is used by NPC manager before NPC is register with auto scan
    endif
    
    bool loc_res = false
    if deviceInventory.hasKeyword(UDlibs.PatchedInventoryDevice)
        UDmain.UDNPCM.GotoState("UpdatePaused")
        
        UD_CustomDevice_NPCSlot loc_slot = none
        loc_slot = UDCDmain.getNPCSlot(akActor)
        UD_MutexScript          loc_mutex = none
        
        if loc_slot
            loc_slot.StartLockMutex()
        else
            loc_mutex = UDMM.WaitForFreeAndSet_Lock(akActor,deviceInventory)
        endif
        
        ;_lastLockSlot  = loc_slot
        ;_lastLockMutex = loc_mutex
        
        if UDmain.TraceAllowed()
            if loc_slot
                UDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - NPC slot: " + loc_slot,1)
            elseif loc_mutex
                UDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - mutex: " + loc_mutex,1)
            else
                UDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - no mutex",1)
            endif
        endif
        
        if loc_slot
            loc_slot.ResetMutex_Lock(deviceInventory)
        elseif loc_mutex
            ;ResetLockMutex(akActor,deviceInventory)
        endif

        zad_AlwaysSilent.addForm(akActor)
        
        ;taken from zadlibs, only removed Log function call
        If force
            Keyword kw = GetDeviceKeyword(deviceInventory)
            if kw
                loc_res = SwapDevicesPatched(akActor, deviceInventory, zad_DeviousDevice = kw,abUseLockFunction = false) ;don't use lock function, as that would block whole system
            else
                loc_res = false
            endif
        else
            if !akActor.GetItemCount(deviceInventory)
                akActor.AddItem(deviceInventory, 1, true)
            EndIf

            akActor.EquipItemEx(deviceInventory, 0, false, true)
            loc_res = true
        endif
        
        if loc_slot
            loc_slot.ProccesLockMutex()
        elseif loc_mutex
            loc_mutex.EvaluateLockMutex()
        endif
        
        zad_AlwaysSilent.RemoveAddedForm(akActor)
        
        if UDmain.TraceAllowed()
            if loc_slot
                UDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation completed - NPC slot: " + loc_slot,1)
            elseif loc_mutex
                UDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation completed - mutex: " + loc_mutex,1)
            else
                UDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation completed - no mutex",1)
            endif
        endif
        
        if loc_slot
            loc_slot.EndLockMutex()
        elseif loc_mutex
            loc_mutex.ResetLockMutex()
        endif
    else
        if UDmain.TraceAllowed()
            UDmain.Log("LockDevicePatched("+getActorName(akActor)+","+deviceInventory.getName()+") (patched) called, device is NOT UD -> skipping mutex")
        endif
        
        loc_res = parent.LockDevice(akActor,deviceInventory,force)
        
        ;make function blocking
        ;pretty much added just so DCL can work properly when equipping more device at once
        if DD_LockDeviceBlocking
            Armor deviceRendered = GetRenderedDevice(deviceInventory)
            float loc_time = 0.0
            while loc_time <= 1.5 && !UDCDmain.CheckRenderDeviceEquipped(akActor, deviceRendered)
                Utility.waitMenuMode(0.1)
                loc_time += 0.1
            endwhile
            if loc_time >= 1.5
                ;render device lock failed, abort
                UDmain.Error("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") DD mutex failed. Render device is not equipped - timeout")
            endif
        endif
    endif
    
    if UDmain.TraceAllowed()
        UDmain.Log("LockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - ended",3)
    endif
    
    UDmain.UDNPCM.GotoState("")
    if !IsPlayer(akActor)
        StorageUtil.AdjustIntValue(akActor,"UDLockOperations",-1) ;decrease number of lock operations for NPC. Is used by NPC manager before NPC is register with auto scan
    endif
    return loc_res
EndFunction

Bool Function SwapDevices(actor akActor, armor deviceInventory, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = true)
    return SwapDevicesPatched(akActor, deviceInventory, zad_DeviousDevice, destroyDevice, genericonly)
EndFunction

Bool Function SwapDevicesPatched(actor akActor, armor deviceInventory, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = true,bool abUseLockFunction = true)
    Keyword loc_keyword
    if !zad_DeviousDevice
        loc_keyword = GetDeviceKeyword(deviceInventory)
    else
        loc_keyword = zad_DeviousDevice
    EndIf
    Armor WornDevice = GetWornRenderedDeviceByKeyword(akActor, loc_keyword)
    if WornDevice
        Armor idevice = GetWornDevice(akActor, loc_keyword)
        if !UnlockDevice(akActor, idevice, WornDevice, zad_DeviousDevice = loc_keyword, destroyDevice = destroyDevice, genericonly = genericonly)
            GError("UnlockDevice() failed for "+ deviceInventory.getName() +". Aborting.")
            return false
        EndIf
    Else
        log("No confilicting device worn. Proceeding.")
    EndIf
    if abUseLockFunction
        LockDevicePatched(akActor,deviceInventory)
    else
        if akActor.GetItemCount(deviceInventory) <= 0
            akActor.AddItem(deviceInventory, 1, true)
        EndIf
        akActor.EquipItemEx(deviceInventory, 0, false, true)
    endif

    return true
EndFunction

Bool Function UnlockDevice(actor akActor, armor deviceInventory, armor deviceRendered = none, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = false)
    if !akActor
        UDmain.Warning("UnlockDevice called for none actor!")
        return false
    endif
    if !deviceInventory
        UDmain.Warning("None passed to UnlockDevice as deviceInventory. Aborting!")
        return false
    endif
    if !deviceInventory.haskeyword(zad_inventoryDevice)
        UDmain.Warning("UnlockDevice("+MakeDeviceHeader(akActor,deviceInventory)+") - passed deviceInventory is not devious device. Aborting!")
        return false
    endif
    if deviceRendered
        if !deviceRendered.haskeyword(zad_lockable) && !deviceRendered.haskeyword(zad_DeviousPlug)
            UDmain.Warning("UnlockDevice("+MakeDeviceHeader(akActor,deviceInventory)+") - passed deviceRendered("+deviceRendered+") is not devious device.")
            deviceRendered = none
        endif
    endif
    
    if !IsPlayer(akActor)
        StorageUtil.AdjustIntValue(akActor,"UDLockOperations",1) ;increase number of lock operations for NPC. Is used by NPC manager before NPC is register with auto scan
    endif
    
    bool loc_res     = False ;return value
    
    if UDmain.TraceAllowed()
        UDmain.Log("UnlockDevice("+akActor+","+deviceInventory+","+deviceRendered+","+zad_DeviousDevice+","+destroyDevice+","+genericonly+")",1)
    endif
    
    if deviceInventory.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
        UDmain.UDNPCM.GotoState("UpdatePaused")
        UD_CustomDevice_NPCSlot loc_slot    = none ;NPC slot for registered NPC
        UD_MutexScript          loc_mutex   = none ;mutex used for non registered NPC
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
        
        if UDmain.TraceAllowed()
            UDmain.Log("UnlockDevice("+MakeDeviceHeader(akActor,deviceInventory)+") called",2)
        endif
        If (genericonly && deviceInventory.HasKeyWord(zad_BlockGeneric)) || deviceInventory.HasKeyWord(zad_QuestItem)
            UDmain.Error("UnlockDevice("+MakeDeviceHeader(akActor,deviceInventory)+") aborted because device is not a generic item.")
            loc_res = false
        else
            Armor loc_renDevice = none
            
            ;get render device, this is important as function will not work without RD
            if deviceRendered
                loc_renDevice = deviceRendered
            else
                loc_renDevice = GetRenderedDevice(deviceInventory)
            endif
            
            ;check if actor actually have render device. Without RD, unlock function will not work
            if akActor.getItemCount(loc_renDevice)
                if loc_slot
                    loc_slot.ResetMutex_UnLock(deviceInventory) ;init slot mutex
                elseif loc_mutex
                    ;is already set by WaitForFreeAndSet_Unlock
                endif
                
                if UDmain.TraceAllowed()
                    if loc_slot
                        UDmain.Log("UnlockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - NPC slot: " + loc_slot,1)
                    elseif loc_mutex
                        UDmain.Log("UnlockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - mutex: " + loc_mutex,1)
                    else
                        UDmain.Log("UnlockDevicePatched("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - no mutex",1)
                    endif
                endif
                
                ;ignore ID events to prevent unwanted behavier
                StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0x110)
                
                Int loc_idcount = akActor.getItemCount(deviceInventory)
                
                ;send and receive device from event container, so inside unlock function can be called
                akActor.removeItem(deviceInventory,loc_idcount,True,UDCDmain.EventContainer_ObjRef)
                UDCDmain.EventContainer_ObjRef.removeItem(deviceInventory,loc_idcount,True,akActor)

                ;procces mutex untill device is unlocked
                if loc_slot
                    loc_slot.ProccesUnLockMutex()
                elseif loc_mutex
                    loc_mutex.EvaluateUnLockMutex()
                endif
                
                ;remove inventory device if its detroy on remove
                if destroyDevice
                    akActor.RemoveItem(deviceInventory, 1, true)
                EndIf
                
                loc_res = true          ;succes
            else
                loc_res = false         ;failure
            endif
        endif
        
        ;end mutex
        if loc_slot
            loc_slot.EndUnLockMutex()
        elseif loc_mutex
            loc_mutex.ResetUnLockMutex()
        endif
    else
        ;use default DD unlock function
        loc_res = parent.UnlockDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, destroyDevice, genericonly) ;actor not registered
    endif
    if UDmain.TraceAllowed()        
        UDmain.Log("UnlockDevice("+deviceInventory.getName()+") (patched) finished: "+loc_res,1)
    endif
    UDmain.UDNPCM.GotoState("")
    if !IsPlayer(akActor)
        StorageUtil.AdjustIntValue(akActor,"UDLockOperations",-1) ;decrease number of lock operations for NPC. Is used by NPC manager before NPC is register with auto scan
    endif
    return loc_res
EndFunction

;modified version of RemoveQuestDevice from zadlibs. This version makes use of registered devices from UD,making unequip procces for NPC safer and faster
Function RemoveQuestDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, keyword RemovalToken, bool destroyDevice=false, bool skipMutex=false)
    If !deviceInventory.HasKeyword(zad_QuestItem) && !deviceRendered.HasKeyword(zad_QuestItem)
        UDmain.Warning("RemoveQuestDevice("+getActorName(akActor)+") aborted for " + deviceInventory.GetName() + " because it's not a quest item.")
        return
    EndIf
    If (!RemovalToken || zadStandardKeywords.HasForm(RemovalToken) || !(deviceInventory.HasKeyword(RemovalToken) || deviceRendered.HasKeyword(RemovalToken)))
        UDmain.Warning("RemoveQuestDevice("+getActorName(akActor)+") called for " + deviceInventory.GetName() + " with invalid removal token. Aborted.")
        return
    EndIf    
    if !deviceInventory.haskeyword(zad_inventoryDevice)
        UDmain.Warning("UnlockDevice("+MakeDeviceHeader(akActor,deviceInventory)+") - passed deviceInventory is not devious device. Aborting!")
        return
    endif
    if deviceRendered
        if !deviceRendered.haskeyword(zad_lockable) && !deviceRendered.haskeyword(zad_DeviousPlug)
            UDmain.Warning("UnlockDevice("+MakeDeviceHeader(akActor,deviceInventory)+") - passed deviceRendered("+deviceRendered+") is not devious device. Aborting!")
            deviceRendered = none
        endif
    endif
    
    if UDmain.TraceAllowed()
        UDmain.Log("RemoveQuestDevice("+getActorName(akActor)+") called for " + deviceInventory.GetName(),1)
    endif
    
    UD_CustomDevice_NPCSlot     loc_slot        = none ;NPC slot for registered NPC
    UD_MutexScript              loc_mutex       = none ;mutex used for non registered NPC
    
    if !IsPlayer(akActor)
        StorageUtil.AdjustIntValue(akActor,"UDLockOperations",1) ;increase number of lock operations for NPC. Is used by NPC manager before NPC is register with auto scan
    endif
    
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
    
    if deviceInventory.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)    
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
    
        if akActor.getItemCount(loc_renDevice)
            ;questItemRemovalAuthorizationToken = RemovalToken
            
            if loc_slot
                loc_slot.ResetMutex_UnLock(deviceInventory) ;init slot mutex
                loc_slot.UD_UnlockToken     = RemovalToken
            elseif loc_mutex
                loc_mutex.UD_UnlockToken     = RemovalToken
                ;is already set by WaitForFreeAndSet_Unlock
            endif
            
            if UDmain.TraceAllowed()    
                if loc_slot
                    UDmain.Log("RemoveQuestDevice("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - NPC slot: " + loc_slot,1)
                elseif loc_mutex    
                    UDmain.Log("RemoveQuestDevice("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - mutex: " + loc_mutex,1)
                else
                    UDmain.Log("RemoveQuestDevice("+MakeDeviceHeader(akActor,deviceInventory)+") - operation started - no mutex",1)
                endif
            endif
            
            StorageUtil.SetIntValue(akActor, "UD_ignoreEvent" + deviceInventory, 0x110)
            
            akActor.removeItem(deviceInventory,1,True,UDCDmain.EventContainer_ObjRef)    
            UDCDmain.EventContainer_ObjRef.removeItem(deviceInventory,1,True,akActor)    
            
            ;procces mutex untill device is unlocked
            if loc_slot
                loc_slot.ProccesUnLockMutex()
            elseif loc_mutex
                loc_mutex.EvaluateUnLockMutex()
            endif
            
            if destroyDevice
                akActor.RemoveItem(deviceInventory, 1, true)
            EndIf
        else

        endif
    else
        parent.RemoveQuestDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, RemovalToken, destroyDevice, skipMutex) ;actor not registered
    endif
    ;end mutex
    if loc_slot
        loc_slot.EndUnLockMutex()
    elseif loc_mutex
        loc_mutex.ResetUnLockMutex()
    endif
    if !IsPlayer(akActor)
        StorageUtil.AdjustIntValue(akActor,"UDLockOperations",-1) ;decrease number of lock operations for NPC. Is used by NPC manager before NPC is register with auto scan
    endif
EndFunction

;updated with additional safety
Bool Function UnlockDeviceByKeyword(actor akActor, keyword zad_DeviousDevice, bool destroyDevice = false)
    if !akActor
        UDmain.Error("UnlockDeviceByKeyword - Actor is none")
        return false
    endif
    
    if !zad_DeviousDevice
        UDmain.Error("UnlockDeviceByKeyword("+GetActorName(akActor)+") - keyword is none")
        return false
    endif
    
    if !akActor.wornHasKeyword(zad_DeviousDevice)
        if UDmain.TraceAllowed()
            UDmain.Log("UnlockDeviceByKeyword("+GetActorName(akActor)+")(UDP) - actor have mo keyword equipped= " + zad_DeviousDevice)
        endif
        return false
    endif
    
    if UDmain.TraceAllowed()
        UDmain.Log("UnlockDeviceByKeyword("+GetActorName(akActor)+")(UDP) called for " + zad_DeviousDevice)
    endif    
    
    Armor idevice = GetWornDevice(akActor, zad_DeviousDevice)
    
    if !idevice
        UDmain.Error("UnlockDeviceByKeyword("+GetActorName(akActor)+","+zad_DeviousDevice+") - returned idevice is none")
        return false
    endif
    
    if UnlockDevice(akActor, idevice, zad_DeviousDevice = zad_DeviousDevice, destroyDevice = destroyDevice, genericonly = true)
        return true
    EndIf
    return false
EndFunction

;updated version to make it work for straightjackets
Armor Function GetWornRenderedDeviceByKeyword(Actor akActor, Keyword kw)
    if UDmain.TraceAllowed()
        UDmain.Log("GetWornRenderedDeviceByKeyword("+akActor+","+kw+")",3)
    endif
    Int slotID = GetSlotMaskForDeviceType(kw)
    if slotID == -1
        return None
    EndIf

    if (kw == zad_deviousHeavyBondage) && akActor.wornHasKeyword(zad_DeviousStraitJacket)
        slotID = Armor.GetMaskForSlot(32)
    endif
    
    if UDmain.TraceAllowed()
        UDmain.Log("GetWornRenderedDeviceByKeyword("+akActor+","+kw+") - GetSlotMaskForDeviceType = " + slotID,3)
    endif
    
    Armor renderDevice = akActor.GetWornForm(slotID) As Armor
    
    if UDmain.TraceAllowed()
        UDmain.Log("GetWornRenderedDeviceByKeyword("+akActor+","+kw+") - renderDevice = " + renderDevice,3)
    endif
    
    if renderDevice && (renderDevice.HasKeyWord(zad_Lockable) || renderDevice.HasKeyWord(zad_DeviousPlug))
        return renderDevice
    EndIf
    return none
EndFunction

;copied and modified libs InflateAnalPlug function to make it show correct msg for npcs
Function InflateAnalPlug(actor akActor, int amount = 1)    
    If !akActor.WornHasKeyword(zad_kw_InflatablePlugAnal)
        ; nothing to do
        return
    EndIf
    
    UD_CustomInflatablePlug_RenderScript loc_plug = UDCDmain.getFirstDeviceByKeyword(akActor,zad_kw_InflatablePlugAnal) as UD_CustomInflatablePlug_RenderScript
    if (loc_plug)
        loc_plug.inflatePlug(amount)
    else
        int currentVal = 0
        If akActor == PlayerRef
            currentVal = iRange(zadInflatablePlugStateAnal.GetValueInt() + amount,0,5)
            ; only increase the value up to 5, but make it count as an inflation event even if it's maximum inflated
            if UDmain.TraceAllowed()
                UDmain.Log("Setting vaginal plug inflation to " + (currentVal),1)
            endif
            zadInflatablePlugStateAnal.SetValueInt(currentVal)
            LastInflationAdjustmentAnal = Utility.GetCurrentGameTime()
        endif
        SendInflationEvent(akActor, False, True, currentval)
    endif
EndFunction

;copied and modified libs InflateAnalPlug function to make it show correct msg for npcs
Function InflateVaginalPlug(actor akActor, int amount = 1)
    If !akActor.WornHasKeyword(zad_kw_InflatablePlugVaginal)
        ; nothing to do
        return
    EndIf
    
    UD_CustomInflatablePlug_RenderScript loc_plug = UDCDmain.getFirstDeviceByKeyword(akActor,zad_kw_InflatablePlugVaginal) as UD_CustomInflatablePlug_RenderScript
    if (loc_plug)
        loc_plug.inflatePlug(amount)
    else
        int currentVal = 0
        If akActor == PlayerRef
            currentVal = iRange(zadInflatablePlugStateVaginal.GetValueInt() + amount,0,5)
            ; only increase the value up to 5, but make it count as an inflation event even if it's maximum inflated
            if UDmain.TraceAllowed()
                UDmain.Log("Setting vaginal plug inflation to " + (currentVal),1)
            endif
            zadInflatablePlugStateVaginal.SetValueInt(currentVal)
            LastInflationAdjustmentVaginal = Utility.GetCurrentGameTime()
        endif
        SendInflationEvent(akActor, True, True, currentval)
    endif
EndFunction

Function DeflateVaginalPlug(actor akActor, int amount = 1)
    If !akActor.WornHasKeyword(zad_kw_InflatablePlugVaginal)
        ; nothing to do
        return
    EndIf
    
    UD_CustomInflatablePlug_RenderScript loc_plug = UDCDmain.getFirstDeviceByKeyword(akActor,zad_kw_InflatablePlugVaginal) as UD_CustomInflatablePlug_RenderScript
    if (loc_plug)
        loc_plug.deflatePlug(amount)
    else
        int currentVal = 0
        If akActor == PlayerRef
            currentVal = iRange(zadInflatablePlugStateVaginal.GetValueInt() - amount,0,5)
            ; only increase the value up to 5, but make it count as an inflation event even if it's maximum inflated
            if UDmain.TraceAllowed()
                UDmain.Log("Setting vaginal plug inflation to " + (currentVal),1)
            endif
            zadInflatablePlugStateVaginal.SetValueInt(currentVal)
            LastInflationAdjustmentVaginal = Utility.GetCurrentGameTime()
        endif
        SendInflationEvent(akActor, True, False, currentval)
    endif
EndFunction

Function DeflateAnalPlug(actor akActor, int amount = 1)
    If !akActor.WornHasKeyword(zad_kw_InflatablePlugAnal)
        ; nothing to do
        return
    EndIf
    
    UD_CustomInflatablePlug_RenderScript loc_plug = UDCDmain.getFirstDeviceByKeyword(akActor,zad_kw_InflatablePlugAnal) as UD_CustomInflatablePlug_RenderScript
    if (loc_plug)
        loc_plug.deflatePlug(amount)
    else
        int currentVal = 0
        If akActor == PlayerRef
            currentVal = iRange(zadInflatablePlugStateAnal.GetValueInt() - amount,0,5)
            ; only increase the value up to 5, but make it count as an inflation event even if it's maximum inflated
            if UDmain.TraceAllowed()
                UDmain.Log("Setting vaginal plug inflation to " + (currentVal),1)
            endif
            zadInflatablePlugStateAnal.SetValueInt(currentVal)
            LastInflationAdjustmentAnal = Utility.GetCurrentGameTime()
        endif
        SendInflationEvent(akActor, False, False, currentval)
    endif
EndFunction

String Function AnimSwitchKeyword(actor akActor, string idleName)
    String[] anims
    If idleName == "Horny01" || idleName == "Horny02" || idleName == "Horny03"
        anims = UDmain.UDAM.GetHornyAnimEvents(akActor, False)
    ElseIf idleName == "Orgasm"
        anims = UDmain.UDAM.GetOrgasmAnimEvents(akActor, False)
    ElseIf idleName == "Edged"
        anims = UDmain.UDAM.GetEdgedAnimEvents(akActor, False)
    EndIf
    
    If anims.Length > 0
        Return anims[RandomInt(0, anims.Length - 1)]
    Else
        return parent.AnimSwitchKeyword(akActor, idleName)
    EndIf
EndFunction

; Stop vibration event on actor.
Function StopVibrating(actor akActor)
    if akActor.WornHasKeyword(UDlibs.UnforgivingDevice) && UDCDmain.isRegistered(akActor)
        if UDmain.TraceAllowed()
            UDmain.Log("StopVibrating("+GetActorName(akActor)+") - using patched version: " + akActor)
        endif
        UDCDmain.StopAllVibrators(akActor)
        akActor.SetFactionRank(zadVibratorFaction, 0)
        akActor.RemoveFromFaction(zadVibratorFaction)
    else
        if UDmain.TraceAllowed()
            UDmain.Log("StopVibrating("+GetActorName(akActor)+") - using default version: " + akActor)
        endif
        parent.StopVibrating(akActor)
    endif
EndFunction

int Function VibrateEffect(actor akActor, int vibStrength, int duration, bool teaseOnly=false, bool silent = false)
    if UDmain.TraceAllowed()    
        UDmain.Log("VibrateEffect(): " + akActor + ", " + vibStrength + ", " + duration)
    endif
    ;prevent too short vibs. Can cause issue with orgasm system
    if duration >= 0 && duration < 3
        duration = 3
    endif
    
    if akActor.WornHasKeyword(UDlibs.UnforgivingDevice) && UDCDmain.isRegistered(akActor)
        int loc_vibNum = UDCDmain.getActivableVibratorNum(akActor)
        if loc_vibNum > 0
            UD_CustomDevice_RenderScript[] loc_usableVibrators = UDCDmain.getActivableVibrators(akActor)
            UD_CustomVibratorBase_RenderScript loc_selectedVib = loc_usableVibrators[RandomInt(0,loc_vibNum - 1)] as UD_CustomVibratorBase_RenderScript
            if UDmain.TraceAllowed()            
                UDmain.Log("VibrateEffect("+GetActorName(akActor)+") - selected vib:" + loc_selectedVib,1)
            endif
            if !loc_selectedVib.IsVibrating()
                loc_selectedVib.forceStrength(vibStrength*20)
                loc_selectedVib.forceDuration(duration)
                loc_selectedVib.forceEdgingMode(teaseOnly as Int)
                loc_selectedVib.vibrate()
            else
                loc_selectedVib.addVibDuration(duration)
            endif
            return 0
        else
            return parent.VibrateEffect(akActor, vibStrength, duration, teaseOnly, silent)
        endif
    else
        return parent.VibrateEffect(akActor, vibStrength, duration, teaseOnly, silent)
    endif
EndFunction

Function ShockActorPatched(actor akActor,int aiArousalUpdate = 25,float afHealth = 0.0, bool abCanKill = false)
    bool loc_loaded = akActor.Is3DLoaded()
    if IsPlayer(akActor)
        NotifyPlayer("You squirms uncomfortably as electricity runs through your body!")
    Elseif UDmain.ActorIsFollower(akActor) && loc_loaded
        NotifyNPC(akActor.GetLeveledActorBase().GetName()+" squirms uncomfortably as electricity runs through her.")
    EndIf
    ShockEffect.RemoteCast(akActor, akActor, akActor)
    
    if loc_loaded
        if RandomInt(1,99) < 40
            UDCDmain.ApplyTearsEffect(akActor)
        endif
    endif
    float loc_health = fRange(afHealth,0.0,1000.0)
    
    if loc_health
        if abCanKill || (akActor.getAV("Health") > loc_health)
            akActor.damageAV("Health", loc_health)
        endif
    endif
    if aiArousalUpdate
        String loc_key = OrgasmSystem.MakeUniqueKEy(akActor,"ShockEffect")
        OrgasmSystem.AddOrgasmChange(akActor,loc_key,0x80024,0x200,-2.0)
        OrgasmSystem.UpdateOrgasmChangeVar(akActor,loc_key,9,-1.0*(aiArousalUpdate/8.0),1)
        ;int loc_arousalUpdate = iRange(RandomInt(Round(0.75*aiArousalUpdate),Round(0.5*aiArousalUpdate)),-100,100)
        ;Aroused.UpdateActorExposure(akActor, loc_arousalUpdate)
    endif
EndFunction

;copied with added trace check and block check
bool[] Function StartThirdPersonAnimation(actor akActor, string animation, bool permitRestrictive=false)
    if UD_StartThirdPersonAnimation_Switch
        UDMain.UDAM.StartSoloAnimation(akActor, animation)
        return new Bool[2]
    else
        return parent.StartThirdPersonAnimation(akActor, animation, permitRestrictive)
    endif
EndFunction

;copied with added trace check and block check
Function EndThirdPersonAnimation(actor akActor, bool[] cameraState, bool permitRestrictive=false)
    if UD_StartThirdPersonAnimation_Switch
        UDMain.UDAM.StopAnimation(akActor)
    else
        parent.EndThirdPersonAnimation(akActor, cameraState, true)
    endif
EndFunction

Function PlayThirdPersonAnimation(actor akActor, string animation, int duration, bool permitRestrictive=false)
    parent.PlayThirdPersonAnimation(akActor, animation, duration, permitRestrictive=false)
EndFunction

Function ActorOrgasm(actor akActor, int setArousalTo=-1, int vsID=-1)
    ;int loc_newArousal = 100 - setArousalTo
    ;if setArousalTo == -1
    ;    loc_newArousal = 75
    ;endif
    ;ActorOrgasmPatched(akActor,20,loc_newArousal)
    UDmain.UDNPCM.RegisterNPC(akActor,true) ;orgasm system will not work if actor is not registered, so register the actor first, and hope there is free slot ;)
    OrgasmSystem.ForceOrgasm(akActor)
    ;UDmain.GetUDOM(akActor).ActorOrgasm(akActor,OrgasmSystem.GetOrgasmingCount(akActor))
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
        newVal = iRange(newVal,0,100)
        Aroused.SetActorExposure(akRef, newVal)
    Else
        int newRank = Round(lastRank + val * Aroused.GetActorExposureRate(akRef))
        Aroused.SetActorExposure(akRef, newRank)
    EndIf
EndFunction

Function UpdateControls()
    ProcessPlayerControls(true) ;only update when player is not in minigame
EndFunction

Function ProcessPlayerControls(bool abCheckMinigame = true)
EndFunction

function stripweapons(actor akActor, bool abUnequiponly = true)
    int i = 10
    
    Form loc_lefthand   = none
    Form loc_righthand  = none
    
    While i > 0
        i -= 1
        loc_lefthand = akActor.GetEquippedObject(0)
        if loc_lefthand
            akActor.unequipItem(loc_lefthand, false, true)
        endif
        if loc_lefthand as Spell
            akActor.UnequipSpell(loc_lefthand as Spell,0)
        endif
        
        loc_righthand = akActor.GetEquippedObject(1)
        if loc_righthand
            akActor.unequipItem(loc_righthand, false, true)
        endif
        if loc_righthand as Spell
            akActor.UnequipSpell(loc_righthand as Spell,0)
        endif
        if loc_lefthand || loc_righthand || akActor.IsWeaponDrawn()
            akActor.SheatheWeapon()
            Utility.Wait(0.1)
        else
            return
        endif
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

Bool Function JamLock(actor akActor, keyword zad_DeviousDevice)
    If akActor != playerRef || !akActor.WornHasKeyword(zad_DeviousDevice)
        return False
    Endif
    
    Armor loc_renderdevice = GetWornRenderedDeviceByKeyword(akActor,zad_DeviousDevice)
    if loc_renderdevice
        if loc_renderdevice.HasKeyword(UDlibs.UnforgivingDevice)
            UD_CustomDevice_RenderScript loc_device = UDCDmain.getDeviceByRender(akActor, loc_renderdevice)
            loc_device.JammAllLocks(True)
            ;loc_device.UD_JammedLocks = loc_device.UD_CurrentLocks
        endif
        StorageUtil.SetIntValue(akActor, "zad_Equipped" + LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus", 1)
        return True
    else
        UDmain.Error("JamLock("+GetActorName(akActor)+","+zad_DeviousDevice+") - Error getting device!")
        return false
    endif
EndFunction

Bool Function UnJamLock(actor akActor, keyword zad_DeviousDevice)
    If akActor != playerRef || !akActor.WornHasKeyword(zad_DeviousDevice)
        return False
    Endif
    
    Armor loc_renderdevice = GetWornRenderedDeviceByKeyword(akActor,zad_DeviousDevice)
    if loc_renderdevice
        if loc_renderdevice.HasKeyword(UDlibs.UnforgivingDevice)
            UD_CustomDevice_RenderScript loc_device = UDCDmain.getDeviceByRender(akActor, loc_renderdevice)
            loc_device.JammAllLocks(False)
            ;loc_device.UD_JammedLocks = 0
        endif
        StorageUtil.SetIntValue(akActor, "zad_Equipped" + LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus", 0)
        return True
    else
        UDmain.Error("UnJamLock("+GetActorName(akActor)+","+zad_DeviousDevice+") - Error getting device!")
        return false
    endif
EndFunction

Function Notify(string out, bool messageBox=false)
    If !messageBox
        UDMain.UDWC.Notification_Push(out)
    Else
        Parent.Notify(out, messageBox)
    EndIf
EndFunction

String Function BuildVibrationString(actor akActor, int vibStrength, bool vPlug, bool aPlug, bool vPiercings, bool nPiercings)
    If UDMain.UDWC.UD_FilterVibNotifications
        Return ""
    Else
        Parent.BuildVibrationString(akActor, vibStrength, vPlug, aPlug, vPiercings, nPiercings)
    EndIf
EndFunction

String Function BuildPostVibrationString(actor akActor, int vibStrength, bool vPlug, bool aPlug, bool vPiercings, bool nPiercings)
    If UDMain.UDWC.UD_FilterVibNotifications
        Return ""
    Else
        Parent.BuildVibrationString(akActor, vibStrength, vPlug, aPlug, vPiercings, nPiercings)
    EndIf
EndFunction
