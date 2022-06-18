scriptname UD_MutexManagerScript extends Quest

UDCustomDeviceMain Property UDCDmain auto
zadlibs_UDPatch Property libsp auto 


;faction which contains all mutexed unregistered npcs
Faction Property UD_MutexFaction auto
Int _usedSlots = 0


bool Property Ready = false auto hidden

Function OnInit()
	Ready = true
	UDCDMain.CLog("UD_MutexManagerScript ready")
EndFunction

Function Update()

EndFunction

Function Mutex(Actor akActor)
	return akActor.AddToFaction(UD_MutexFaction)
EndFunction

Function UnMutex(Actor akActor)
	return akActor.RemoveFromFaction(UD_MutexFaction)
EndFunction

bool Function IsMutexed(Actor akActor)
	return akActor.isinFaction(UD_MutexFaction)
EndFunction

bool Function IsDeviceMutexed(Actor akActor,Armor invDevice)
	if !akActor.isinFaction(UD_MutexFaction)
		return false
	endif
	return GetMutexSlot(akActor).FilterDevice(invDevice)
EndFunction

UD_MutexScript Function GetMutexSlot(Actor akActor)
	int loc_i = GetNumAliases()
	while loc_i
		loc_i -= 1
		UD_MutexScript loc_slot = GetNthAlias(loc_i) as UD_MutexScript
		if loc_slot.FilterActor(akActor)
			return loc_slot
		endif
	endwhile
EndFunction

UD_MutexScript Function GetFreeSlot()
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

Function PauseUntillFree(Actor akActor)
	while !GetFreeSlot() || IsMutexed(akActor)
		Utility.waitMenuMode(0.5)
	endwhile
EndFunction

UD_MutexScript Function WaitForFreeAndSet(Actor akActor,Armor invDevice)
	int loc_i = GetNumAliases()
	while loc_i
		loc_i -= 1
		UD_MutexScript loc_slot = GetNthAlias(loc_i) as UD_MutexScript
		if loc_slot.IsUnused() && !IsMutexed(akActor)
			loc_slot.SetMutex(akActor,invDevice)
			return loc_slot
		endif
		if loc_i == 0
			loc_i = GetNumAliases()
			Utility.waitMenuMode(0.1)
		endif
	endwhile
	return none
EndFunction