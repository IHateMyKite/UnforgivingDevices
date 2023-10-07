Scriptname UD_MutexScript extends ReferenceAlias

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain auto

UnforgivingDevicesMain Property UDmain hidden
    UnforgivingDevicesMain Function Get()
        return UDCDmain.UDmain
    EndFunction
EndProperty
;LOCK
bool    Property UD_GlobalDeviceMutex_InventoryScript                   = false     auto hidden
bool    Property UD_GlobalDeviceMutex_InventoryScript_Failed            = false     auto hidden
Armor   Property UD_GlobalDeviceMutex_Device                            = none      auto hidden
;UNLOCK     
bool    Property UD_GlobalDeviceUnlockMutex_InventoryScript             = false     auto hidden
bool    Property UD_GlobalDeviceUnlockMutex_InventoryScript_Failed      = false     auto hidden
Armor   Property UD_GlobalDeviceUnlockMutex_Device                      = none      auto hidden

Keyword Property UD_UnlockToken                                         = none      auto hidden

Actor Function GetActor()
    return GetReference() as Actor
EndFunction

Function SetMutex(Actor akActor,Armor invDevice)
    (GetOwningQuest() as UD_MutexManagerScript).Mutex(akActor)
    ForceRefTo(akActor)
EndFunction

Function SetLockMutex(Actor akActor,Armor invDevice)
    SetMutex(akActor,invDevice)
    UD_GlobalDeviceMutex_Device = invDevice
EndFunction

Function SetUnlockMutex(Actor akActor,Armor invDevice)
    SetMutex(akActor,invDevice)
    UD_GlobalDeviceUnlockMutex_Device = invDevice
EndFunction

Function ResetLockMutex()
    UD_GlobalDeviceMutex_InventoryScript             = false
    UD_GlobalDeviceMutex_InventoryScript_Failed     = false
    UD_GlobalDeviceMutex_Device                     = none
    (GetOwningQuest() as UD_MutexManagerScript).UnMutex(GetActorRef())
    Clear()
EndFunction

Function ResetUnlockMutex()
    UD_GlobalDeviceUnlockMutex_InventoryScript             = false
    UD_GlobalDeviceUnlockMutex_InventoryScript_Failed     = false
    UD_GlobalDeviceUnlockMutex_Device                     = none 
    UD_UnlockToken                                        = none
    (GetOwningQuest() as UD_MutexManagerScript).UnMutex(GetActorRef())
    Clear()
EndFunction

Bool Function FilterActor(Actor akActor)
    return GetActorRef() == akActor
EndFunction

Bool Function FilterDevice(Armor invDevice)
    return UD_GlobalDeviceMutex_Device == invDevice || UD_GlobalDeviceUnlockMutex_Device == invDevice
EndFunction

Bool Function IsUnused()
    return !GetActorRef()
EndFunction

Bool Function IsLockMutexed()
    return UD_GlobalDeviceMutex_Device
EndFunction

Bool Function IsUnLockMutexed()
    return UD_GlobalDeviceUnlockMutex_Device
EndFunction

Function EvaluateLockMutex()
    float loc_time = 0.0
    while loc_time <= UDmain.UDGV.UD_MutexTimeout && (!UD_GlobalDeviceMutex_InventoryScript)
        Utility.waitMenuMode(0.1)
        loc_time += 0.1
    endwhile
    
    if loc_time >= UDmain.UDGV.UD_MutexTimeout && UDmain.IsAnyMenuOpen()
        Utility.wait(0.01)
        loc_time = 0.0
        while loc_time <= UDmain.UDGV.UD_MutexTimeout && (!UD_GlobalDeviceMutex_InventoryScript)
            Utility.waitMenuMode(0.1)
            loc_time += 0.1
        endwhile
    endif
    
    if UD_GlobalDeviceMutex_InventoryScript_Failed
        UDmain.Error("EvaluateLockMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceMutex_Device.getName()+") failed!!!")
    endif
    if loc_time >= UDmain.UDGV.UD_MutexTimeout
        UDmain.Error("EvaluateLockMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceMutex_Device.getName()+") timeout!!!")
    endif
    
    UD_GlobalDeviceMutex_Device = none
EndFunction

Function EvaluateUnlockMutex()
    float loc_time = 0.0
    while loc_time <= UDmain.UDGV.UD_MutexTimeout && (!UD_GlobalDeviceUnlockMutex_InventoryScript)
        Utility.waitMenuMode(0.1)
        loc_time += 0.1
    endwhile
    
    if loc_time >= UDmain.UDGV.UD_MutexTimeout && UDmain.IsAnyMenuOpen()
        Utility.wait(0.01)
        loc_time = 0.0
        while loc_time <= UDmain.UDGV.UD_MutexTimeout && (!UD_GlobalDeviceUnlockMutex_InventoryScript)
            Utility.waitMenuMode(0.1)
            loc_time += 0.1
        endwhile
    endif
    
    if UD_GlobalDeviceUnlockMutex_InventoryScript_Failed
        UDmain.Error("EvaluateUnlockMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceUnlockMutex_Device.getName()+") failed!!!")
    endif
    if loc_time >= UDmain.UDGV.UD_MutexTimeout
        UDmain.Error("EvaluateUnlockMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceUnlockMutex_Device.getName()+") timeout!!!")
    endif
    
    UD_GlobalDeviceUnlockMutex_Device = none
EndFunction