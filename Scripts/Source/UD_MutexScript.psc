Scriptname UD_MutexScript extends ReferenceAlias

import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto

bool 	Property UD_GlobalDeviceMutex_InventoryScript 			= false 		auto hidden
bool 	Property UD_GlobalDeviceMutex_InventoryScript_Failed 	= false 		auto hidden
Armor 	Property UD_GlobalDeviceMutex_Device 					= none 			auto hidden

Function SetMutex(Actor akActor,Armor invDevice)
	(GetOwningQuest() as UD_MutexManagerScript).Mutex(akActor)
	ForceRefTo(akActor)
	;ResetMutex()
	UD_GlobalDeviceMutex_Device = invDevice
	;UDCDmain.CLog("Using " + self)
EndFunction

Function ResetMutex()
	UD_GlobalDeviceMutex_InventoryScript 			= false
	UD_GlobalDeviceMutex_InventoryScript_Failed 	= false
	UD_GlobalDeviceMutex_Device 					= none 
	(GetOwningQuest() as UD_MutexManagerScript).UnMutex(GetActorRef())
	Clear()
	;UDCDmain.CLog("Unusing " + self)
EndFunction

Bool Function FilterActor(Actor akActor)
	return GetActorRef() == akActor
EndFunction

Bool Function FilterDevice(Armor invDevice)
	return UD_GlobalDeviceMutex_Device == invDevice
EndFunction

Bool Function IsUnused()
	return !GetActorRef()
EndFunction

Function EvaluateMutex()
	float loc_time = 0.0
	while loc_time <= 25.0 && (!UD_GlobalDeviceMutex_InventoryScript)
		Utility.wait(0.05)
		loc_time += 0.05
	endwhile
	
	if UD_GlobalDeviceMutex_InventoryScript_Failed
		UDCDmain.Error("EvaluateMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceMutex_Device.getName()+") failed!!!")
	endif
	if loc_time >= 25.0
		UDCDmain.Error("EvaluateMutex("+getActorName(GetActorRef())+","+UD_GlobalDeviceMutex_Device.getName()+") timeout!!!")
	endif
	
	UD_GlobalDeviceMutex_Device = none
EndFunction
