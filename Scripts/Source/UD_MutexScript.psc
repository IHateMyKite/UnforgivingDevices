Scriptname UD_MutexScript extends ReferenceAlias

import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto
;LOCK
bool 	Property UD_GlobalDeviceMutex_InventoryScript 				= false 		auto hidden
bool 	Property UD_GlobalDeviceMutex_InventoryScript_Failed 		= false 		auto hidden
Armor 	Property UD_GlobalDeviceMutex_Device 						= none 			auto hidden
;UNLOCK
bool 	Property UD_GlobalDeviceUnlockMutex_InventoryScript 		= false 		auto hidden
bool 	Property UD_GlobalDeviceUnlockMutex_InventoryScript_Failed 	= false 		auto hidden
Armor 	Property UD_GlobalDeviceUnlockMutex_Device 					= none 			auto hidden

Keyword Property UD_UnlockToken										= none 			auto hidden	

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
	UD_GlobalDeviceMutex_InventoryScript 			= false
	UD_GlobalDeviceMutex_InventoryScript_Failed 	= false
	UD_GlobalDeviceMutex_Device 					= none
	(GetOwningQuest() as UD_MutexManagerScript).UnMutex(GetActorRef())
	Clear()
EndFunction

Function ResetUnlockMutex()
	UD_GlobalDeviceUnlockMutex_InventoryScript 			= false
	UD_GlobalDeviceUnlockMutex_InventoryScript_Failed 	= false
	UD_GlobalDeviceUnlockMutex_Device 					= none 
	UD_UnlockToken										= none
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
	while loc_time <= UDCDmain.UD_LockUnlockMutexTimeOutTime && (!UD_GlobalDeviceMutex_InventoryScript)
		Utility.wait(0.05)
		loc_time += 0.05
	endwhile
	
	if UD_GlobalDeviceMutex_InventoryScript_Failed
		UDCDmain.Error("EvaluateLockMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceMutex_Device.getName()+") failed!!!")
	endif
	if loc_time >= UDCDmain.UD_LockUnlockMutexTimeOutTime
		UDCDmain.Error("EvaluateLockMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceMutex_Device.getName()+") timeout!!!")
	endif
	
	UD_GlobalDeviceMutex_Device = none
EndFunction

Function EvaluateUnlockMutex()
	float loc_time = 0.0
	while loc_time <= UDCDmain.UD_LockUnlockMutexTimeOutTime && (!UD_GlobalDeviceUnlockMutex_InventoryScript)
		Utility.wait(0.05)
		loc_time += 0.05
	endwhile
	
	if UD_GlobalDeviceUnlockMutex_InventoryScript_Failed
		UDCDmain.Error("EvaluateUnlockMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceUnlockMutex_Device.getName()+") failed!!!")
	endif
	if loc_time >= UDCDmain.UD_LockUnlockMutexTimeOutTime
		UDCDmain.Error("EvaluateUnlockMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceUnlockMutex_Device.getName()+") timeout!!!")
	endif
	
	UD_GlobalDeviceUnlockMutex_Device = none
EndFunction