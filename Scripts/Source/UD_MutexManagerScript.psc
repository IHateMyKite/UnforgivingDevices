scriptname UD_MutexManagerScript extends UD_ModuleBase

;faction which contains all mutexed unregistered npcs
Faction Property UD_MutexFaction auto
Int _usedSlots = 0

; =================
; PRIVATE METHODS
; =================
Function _Mutex(Actor akActor)
    return akActor.AddToFaction(UD_MutexFaction)
EndFunction

Function _UnMutex(Actor akActor)
    return akActor.RemoveFromFaction(UD_MutexFaction)
EndFunction

bool Function _IsMutexed(Actor akActor)
    return akActor.isinFaction(UD_MutexFaction)
EndFunction

bool Function _IsLockMutexed(Actor akActor)
    if !_IsMutexed(akActor)
        return false
    endif
    UD_MutexScript loc_mutex = GetMutexSlot(akActor)
    return loc_mutex.IsLockMutexed()
EndFunction

bool Function _IsUnlockMutexed(Actor akActor)
    if !_IsMutexed(akActor)
        return false
    endif
    UD_MutexScript loc_mutex = GetMutexSlot(akActor)
    return loc_mutex.IsUnlockMutexed()
EndFunction

UD_MutexScript Function _GetFreeSlot()
    int loc_i = GetNumAliases()
    while loc_i
        loc_i -= 1
        UD_MutexScript loc_slot = GetNthAlias(loc_i) as UD_MutexScript
        if loc_slot.IsUnused()
            return loc_slot
        endif
    endwhile
    return none
EndFunction

Function _PauseUntillFree(Actor akActor)
    while !_GetFreeSlot() || _IsMutexed(akActor)
        Utility.waitMenuMode(0.5)
    endwhile
EndFunction

; =================
; PUBLIC METHODS
; =================

UD_MutexScript Function WaitForFreeAndSet_Lock(Actor akActor,Armor invDevice)
    WaitForReady(10.0)
    int loc_i = GetNumAliases()
    while loc_i
        loc_i -= 1
        UD_MutexScript loc_slot = GetNthAlias(loc_i) as UD_MutexScript
        if loc_slot.IsUnused() && !_IsLockMutexed(akActor)
            loc_slot.SetLockMutex(akActor,invDevice)
            return loc_slot
        endif
        if loc_i == 0 ;no free slot found, do it again
            loc_i = GetNumAliases()
        endif
        Utility.waitMenuMode(0.1)
    endwhile
    return none
EndFunction

UD_MutexScript Function WaitForFreeAndSet_UnLock(Actor akActor,Armor invDevice)
    WaitForReady(10.0)
    int loc_i = GetNumAliases()
    while loc_i
        loc_i -= 1
        UD_MutexScript loc_slot = GetNthAlias(loc_i) as UD_MutexScript
        if loc_slot.IsUnused() && !_IsUnlockMutexed(akActor)
            loc_slot.SetUnlockMutex(akActor,invDevice)
            return loc_slot
        endif
        if loc_i == 0
            loc_i = GetNumAliases()
            Utility.waitMenuMode(0.1)
        endif
    endwhile
    return none
EndFunction

UD_MutexScript Function GetMutexSlot(Actor akActor)
    WaitForReady(10.0)
    int loc_i = GetNumAliases()
    while loc_i
        loc_i -= 1
        UD_MutexScript loc_slot = GetNthAlias(loc_i) as UD_MutexScript
        if loc_slot.FilterActor(akActor)
            return loc_slot
        endif
    endwhile
EndFunction

bool Function IsDeviceMutexed(Actor akActor,Armor invDevice)
    WaitForReady(10.0)
    if !akActor.isinFaction(UD_MutexFaction)
        return false
    endif
    return GetMutexSlot(akActor).FilterDevice(invDevice)
EndFunction