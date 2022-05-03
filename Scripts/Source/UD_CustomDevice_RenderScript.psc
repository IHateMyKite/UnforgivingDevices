Scriptname UD_CustomDevice_RenderScript extends ObjectReference  

;bit maps used to code simple values to reduce memory size of script
;-----_deviceControlBitMap_1-----
;00 = 1b, struggleGame_on
;01 = 1b, lockpickGame_on
;02 = 1b, cuttingGame_on
;03 = 1b, keyGame_on
;04 = 1b, repairLocksMinigame_on
int _deviceControlBitMap_1 = 0x00000000 ;BOOL
int _deviceControlBitMap_2 = 0x00000000 ;FLOAT-FULL
int _deviceControlBitMap_3 = 0x00000000 ;FLOAT-FULL
int _deviceControlBitMap_4 = 0x00000000 ;FLOAT-FULL
int _deviceControlBitMap_5 = 0x00000000 ;INT

;-----_deviceControlBitMap_6-----
;00 - 06 = UD_StruggleCritChance
;07 - 14 = UD_LockpickDifficulty
;15 - 19 = UD_Locks
;20 - 26 = UD_CutChance
;27 - 31 = UD_base_stat_drain
int _deviceControlBitMap_6 = 0x4000008F 

;-----_deviceControlBitMap_7-----
;00 - 11 = 12b, UD_durability_damage_base
;12 - 21 = 10b, UD_ResistMagicka
;22 - 24 = 3b, !UNUSED!
;25 - 27 = 3b, _struggleGame_Subtype
;28 - 30 = 3b, _struggleGame_Subtype_NPC
int _deviceControlBitMap_7 = 0x001F4064

;-----_deviceControlBitMap_8-----
;00 - 06 = 7b, UD_RegenMagHelper_Stamina
;07 - 13 = 7b, UD_RegenMagHelper_Health
;14 - 20 = 7b, UD_RegenMagHelper_Magicka
;21 - 27 = 7b, _customMinigameCritChance
;28 - 31 = 4b, !UNUSED!
int _deviceControlBitMap_8 = 0x00000000

;-----_deviceControlBitMap_9-----
;00 - 06 = 7b, _customMinigameCritDuration
;07 - 18 = 12b, _customMinigameCritMult
;19 - 25 = 7b, _minMinigameStatHP
;26 - 31 = 6b, !UNUSED!
int _deviceControlBitMap_9 = 0x00000000

;-----_deviceControlBitMap_10-----
;00 - 06 = 7b, _minMinigameStatMP
;07 - 13 = 7b, _minMinigameStatSP
;14 - 21 = 8b, _condition_mult_add
;22 - 29 = 8b, _exhaustion_mult
;30 - 31 = 2b, !UNUSED!
int _deviceControlBitMap_10 = 0x00000000


;-----_deviceControlBitMap_11-----
;00 - 9 = 6b, UD_WeaponHitResist
;10 - 19 = 6b, UD_SpellHitResist
;20 - 29 = 6b, UD_ResistPhysical
;30 - 31 = 2b, !UNUSED!
int _deviceControlBitMap_11 = 0x1F4FFFFF


;--------------------------------PUBLIC VARS----------------------------
;do not modify
Key Property zad_deviceKey auto
Armor Property DeviceRendered auto

;-------------------------------------------------------
;-------!!!!!!!!!!!!ALWAYS FILL!!!!!!!!!!!!!!!----------
Armor Property DeviceInventory auto
zadlibs Property libs auto
Keyword Property UD_DeviceKeyword auto ;keyword of this device for better manipulation
;-------------------------------------------------------
;-------------------------------------------------------

;libs, filled automatically
UnforgivingDevicesMain Property UDmain auto;main function
UD_libs Property UDlibs ;device/keyword library
	UD_libs Function get()
		return UDmain.UDlibs
	EndFunction
EndProperty 
UDCustomDeviceMain Property UDCDmain 
	UDCustomDeviceMain Function get()
		return UDmain.UDCDmain
	EndFunction
EndProperty

;MAIN VALUES
float property UD_durability_damage_base ;durability dmg per second of struggling, range 0.00 - 40.00, precision 0.01 (4000 values)
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_7 = codeBit(_deviceControlBitMap_7,Round(fRange(fVal,0.0,40.0)*100),12,0)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_7,12,0)/100.0
	EndFunction
EndProperty

float Property UD_base_stat_drain ;stamina drain for second of struggling, range 1 - 31, decimal point not used
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_6 = codeBit(_deviceControlBitMap_6,Round(fRange(fVal,1.0,31.0)),5,27)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_6,5,27)
	EndFunction
EndProperty
float Property UD_ResistMagicka ;magicka resistence. Needs to be applied to minigame to work!
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_7 = codeBit(_deviceControlBitMap_7,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,12)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return (decodeBit(_deviceControlBitMap_7,10,12)/100.0) - 5.0
	EndFunction
EndProperty
float Property UD_ResistPhysical ;physical resistence. Needs to be applied to minigame to work!
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_11 = codeBit(_deviceControlBitMap_11,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,20)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return (decodeBit(_deviceControlBitMap_11,10,20)/100.0) - 5.0
	EndFunction
EndProperty
float Property UD_WeaponHitResist
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_11 = codeBit(_deviceControlBitMap_11,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,0)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return (decodeBit(_deviceControlBitMap_11,10,0)/100.0) - 5.0
	EndFunction
EndProperty
float Property UD_SpellHitResist
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_11 = codeBit(_deviceControlBitMap_11,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,10)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return (decodeBit(_deviceControlBitMap_11,10,10)/100.0) - 5.0
	EndFunction
EndProperty
float Property UD_CutChance ;chance of cutting device every 1s of minigame, 0.0 is uncuttable
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_6 = codeBit(_deviceControlBitMap_6,Round(fRange(fVal,0.0,100.0)),7,20)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_6,7,20)
	EndFunction
EndProperty
float Property UD_LockAccessDifficulty auto ;chance of reaching the lock for every 1s of minigame, 100. is unreachable
float Property UD_StruggleCritMul = 3.0 auto ;how many times of duration is reduced
float Property UD_StruggleCritDuration = 1.0 auto ;crit time, the lover the more faster player needs to press button

Message Property UD_MessageDeviceInteraction auto ;messagebox that is shown when player click on device in inventory
Message Property UD_MessageDeviceInteractionWH auto ;messagebox that is shown when player click on device in NPC inventory
Message Property UD_SpecialMenuInteraction auto
Message Property UD_SpecialMenuInteractionWH auto

LeveledItem Property UD_OnDestroyItemList auto ;items received when device is unlocked

int Property UD_StruggleCritChance ;chance of random crit happening once per second of struggling, range 0-100
	Function set(int iVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_6 = codeBit(_deviceControlBitMap_6,iRange(iVal,0,100),7,0)
		endBitMapMutexCheck()
	EndFunction
	
	int Function get()
		return decodeBit(_deviceControlBitMap_6,7,0)
	EndFunction
EndProperty
int Property UD_LockpickDifficulty ;1 = Novice, 25 = Apprentice, 50 = Adept,75 = Expert,100 = Master,255 = Requires Key, range 1-255
	Function set(int iVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_6 = codeBit(_deviceControlBitMap_6,iRange(iVal,1,255),8,7)
		endBitMapMutexCheck()
	EndFunction
	
	int Function get()
		return decodeBit(_deviceControlBitMap_6,8,7)
	EndFunction
EndProperty
int Property UD_Locks ;number of locks, range 0-31
	Function set(int iVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_6 = codeBit(_deviceControlBitMap_6,iRange(iVal,0,31),5,15)
		endBitMapMutexCheck()
	EndFunction
	
	int Function get()
		return decodeBit(_deviceControlBitMap_6,5,15)
	EndFunction
EndProperty
;Device cooldown, in minutes. Device will activate itself on after this time (if it can)
;zero or negative value will disable this feature
int	Property UD_Cooldown = 0 auto 
int _currentRndCooldown = 0

string Property UD_ActiveEffectName = "Share" auto ;name of active effect
string Property UD_DeviceType = "Generic" auto ;name of active effect

string[] Property UD_Modifiers auto ;modifiers
string[] Property UD_struggleAnimations auto
string[] Property UD_struggleAnimationsHobl auto

;------------local variables-------------------
Actor Wearer = none ;current device wearer reference
float device_health = 100.0 ;default max device durability, for now always 100
float current_device_health = 0.0 ;current device durability, if this reaches 0, player will escape restrain
float _total_durability_drain = 0.0 ;how much durability was reduced, aka condition
float _durability_damage_mod ;durability dmg after applied difficulty, dont change this! Use updateDifficulty() if you want to update it
float _updateTimePassed = 0.0
;---------------------------------------PRIVATE VARS----------------------------------------

int Property UD_CurrentLocks Hidden ;how many locked locks remain, max is 31
	Function set(int iVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_5 = codeBit(_deviceControlBitMap_5,iRange(iVal,0,31),6,0)
		endBitMapMutexCheck()
	EndFunction
	
	int Function get()
		return decodeBit(_deviceControlBitMap_5,6,0)
	EndFunction
endproperty
int Property UD_JammedLocks Hidden ;jammed locks, max is 31
	Function set(int iVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_5 = codeBit(_deviceControlBitMap_5,iRange(iVal,0,31),6,6)
		endBitMapMutexCheck()
	EndFunction
	
	int Function get()
		return decodeBit(_deviceControlBitMap_5,6,6)
	EndFunction
endproperty
int Property UD_condition Hidden ;0 - new , 4 - broke
	Function set(int iVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_5 = codeBit(_deviceControlBitMap_5,iRange(iVal,0,4),3,12)
		endBitMapMutexCheck()
	EndFunction
	
	int Function get()
		return decodeBit(_deviceControlBitMap_5,3,12)
	EndFunction
endproperty


;minigame control variables
bool Property struggleGame_on Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,0)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,0))
	EndFunction
endproperty
bool Property lockpickGame_on Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,1)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,1))
	EndFunction
endproperty
bool Property cuttingGame_on Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,2)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,2))
	EndFunction
endproperty
bool Property keyGame_on Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,3)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,3))
	EndFunction
endproperty
bool Property repairLocksMinigame_on Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,4)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,4))
	EndFunction
endproperty
bool Property force_stop_minigame Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,5)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,5))
	EndFunction
endproperty
bool Property pauseMinigame Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,6)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,6))
	EndFunction
endproperty
bool Property UD_drain_stats Hidden ;if player will loose stats while struggling
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,9)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,9))
	EndFunction
endproperty
bool Property UD_drain_stats_helper Hidden ;if player will loose stats while struggling
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,10)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,10))
	EndFunction
endproperty
bool Property UD_damage_device Hidden ;if device can be damaged
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,11)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,11))
	EndFunction
endproperty
bool Property UD_applyExhastionEffect Hidden ;applies debuff after mnigame ends
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,12)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,12))
	EndFunction
endproperty
bool Property UD_applyExhastionEffectHelper Hidden ;applies debuff after minigame ends
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,13)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,13))
	EndFunction
endproperty
bool Property UD_minigame_canCrit Hidden ;if crits can appear
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,14)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,14))
	EndFunction
endproperty
bool Property UD_useWidget Hidden ;determinate if widget will be shown
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,15)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,15))
	EndFunction
endproperty
bool Property UD_WidgetAutoColor Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,16)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,16))
	EndFunction
endproperty
bool Property Ready
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,17)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,17))
	EndFunction
endproperty
bool Property zad_DestroyOnRemove Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,18)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,18))
	EndFunction
endproperty
bool Property zad_DestroyKey Hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,19)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,19))
	EndFunction
endproperty
bool Property _AVOK Hidden 
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,20)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,20))
	EndFunction
EndProperty
bool Property minigame_on Hidden 
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,21)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,21))
	EndFunction
EndProperty
bool Property _activated Hidden 
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,22)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,22))
	EndFunction
EndProperty
bool Property _removeDeviceCalled Hidden 
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,23)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,23))
	EndFunction
EndProperty
bool Property UD_minigame_critRegen 
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,24)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,24))
	EndFunction
EndProperty
bool Property UD_minigame_critRegen_helper 
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,25)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,25))
	EndFunction
EndProperty

float Property UD_minigame_stamina_drain Hidden ;stamina drain for second of struggling
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_2 = codeBit(_deviceControlBitMap_2,Round(fRange(fVal,0.0,200.0)),8,0)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_2,8,0)
	EndFunction
endproperty
float Property UD_minigame_magicka_drain Hidden ;magicka drain for second of struggling
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_2 = codeBit(_deviceControlBitMap_2,Round(fRange(fVal,0.0,200.0)),8,8)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_2,8,8)
	EndFunction
endproperty
float Property UD_minigame_heal_drain Hidden ;health drain for second of struggling
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_2 = codeBit(_deviceControlBitMap_2,Round(fRange(fVal,0.0,200.0)),8,16)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_2,8,16);Math.LogicalAnd(_deviceControlBitMap_2,Math.LeftShift(0xFF,16)) as Float
	EndFunction
endproperty
float Property UD_minigame_stamina_drain_helper Hidden	;stamina drain for second of struggling
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_2 = codeBit(_deviceControlBitMap_2,Round(fRange(fVal,0.0,200.0)),8,24)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_2,8,24);Math.LogicalAnd(_deviceControlBitMap_2,Math.LeftShift(0xFF,16)) as Float
	EndFunction
endproperty
float Property UD_minigame_magicka_drain_helper Hidden	;magicka drain for second of struggling
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_3 = codeBit(_deviceControlBitMap_3,Round(fRange(fVal,0.0,200.0)),8,0)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_3,8,0)
	EndFunction
endproperty
float Property UD_minigame_heal_drain_helper Hidden ;health drain for second of struggling
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_3 = codeBit(_deviceControlBitMap_3,Round(fRange(fVal,0.0,200.0)),8,8)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_3,8,8)
	EndFunction
endproperty

;stats regeneration when struggling, 0.0 means that wearer will not regen stats, 1.0 will make stats regen like normaly 
float Property UD_RegenMag_Stamina Hidden ;health drain for second of struggling
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_4 = codeBit(_deviceControlBitMap_4,Round(fRange(fVal,0.0,1.0)*100),7,0)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_4,7,0)/100.0
	EndFunction
endproperty
float Property UD_RegenMag_Health Hidden ;health drain for second of struggling
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_4 = codeBit(_deviceControlBitMap_4,Round(fRange(fVal,0.0,1.0)*100),7,7)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_4,7,7)/100.0
	EndFunction
endproperty
float Property UD_RegenMag_Magicka Hidden ;health drain for second of struggling
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_4 = codeBit(_deviceControlBitMap_4,Round(fRange(fVal,0.0,1.0)*100),7,14)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_4,7,14)/100.0
	EndFunction
endproperty

;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
float Property UD_RegenMagHelper_Stamina Hidden
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_8 = codeBit(_deviceControlBitMap_8,Round(fRange(fVal,0.0,1.0)*100),7,0)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_8,7,0)/100.0
	EndFunction
EndProperty
float Property UD_RegenMagHelper_Health Hidden
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_8 = codeBit(_deviceControlBitMap_8,Round(fRange(fVal,0.0,1.0)*100),7,7)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_8,7,7)/100.0
	EndFunction
EndProperty
float Property UD_RegenMagHelper_Magicka Hidden
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_8 = codeBit(_deviceControlBitMap_8,Round(fRange(fVal,0.0,1.0)*100),7,14)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_8,7,14)/100.0
	EndFunction
EndProperty




;custom crits
int Property _customMinigameCritChance Hidden
	Function set(int iVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_8 = codeBit(_deviceControlBitMap_8,iRange(iVal,0,100),7,21)
		endBitMapMutexCheck()
	EndFunction
	
	int Function get()
		return decodeBit(_deviceControlBitMap_8,7,21)
	EndFunction
EndProperty

float Property _customMinigameCritDuration Hidden
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_9 = codeBit(_deviceControlBitMap_9,Round(fRange(fVal,0.4,2.0)*100),7,0)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_9,7,0)/100.0
	EndFunction
EndProperty
float Property _customMinigameCritMult Hidden
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_9 = codeBit(_deviceControlBitMap_9,Round(fRange(fVal,0.25,1000.0)*4),12,7)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_9,12,7)/4.0
	EndFunction
EndProperty

;multiplies the durability dmg of minigame
float UD_DamageMult = 1.0 

;additional multiplier for other minigames
float UD_MinigameMult1 = 1.0 
float UD_MinigameMult2 = 1.0
float UD_MinigameMult3 = 1.0

float UD_durability_damage_add = 0.0 ;adds flat value to durability dmg. Is added beffor UD_DamageMult is applied

;widget vars
int UD_WidgetColor = 0x0000FF
int UD_WidgetColor2 = -1
int UD_WidgetFlashColor = -1

float UD_CuttingProgress = 0.0
float UD_RepairProgress = 0.0

;required stats to start minigame
float Property _minMinigameStatHP Hidden
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_9 = codeBit(_deviceControlBitMap_9,Round(fRange(fVal,0.0,1.0)*100),7,19)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_9,7,19)/100.0
	EndFunction
EndProperty
float Property _minMinigameStatMP Hidden
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,1.0)*100),7,0)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_10,7,0)/100.0
	EndFunction
EndProperty
float Property _minMinigameStatSP Hidden
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,1.0)*100),7,7)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_10,7,7)/100.0
	EndFunction
EndProperty
float Property _condition_mult_add Hidden ;how much is increased condition dmg (10% increase condition dmg by 10%), step = 0.1, max 25.6
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,25.6)*10),8,14)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_10,8,14)/4.0
	EndFunction
EndProperty
float Property _exhaustion_mult Hidden ;multiplier for duration of debuff, step = 0.25, max 64
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,64.0)*4),8,22)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_10,8,22)/4.0
	EndFunction
EndProperty

float _exhaustion_mult_helper = 1.0 ;multiplier for duration of debuff


Actor _minigameHelper = none

;variables copied from zadEquipScript. !dont change!
bool[] cameraState
String _sStruggleAnim ;currently selected struggle array. Used by minigame. DONT CHANGE
String _sStruggleAnimHelper ;currently selected struggle array. Used by minigame. DONT CHANGE

int Property _struggleGame_Subtype Hidden
	Function set(int iVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_7 = codeBit(_deviceControlBitMap_7,iRange(iVal,0,7),3,25)
		endBitMapMutexCheck()
	EndFunction
	
	int Function get()
		return decodeBit(_deviceControlBitMap_7,3,25)
	EndFunction
EndProperty
int Property _struggleGame_Subtype_NPC Hidden
	Function set(int iVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_7 = codeBit(_deviceControlBitMap_7,iRange(iVal,0,7),3,28)
		endBitMapMutexCheck()
	EndFunction
	
	int Function get()
		return decodeBit(_deviceControlBitMap_7,3,28)
	EndFunction
EndProperty

float Property zad_JammLockChance hidden;chance of jamming lock
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_3 = codeBit(_deviceControlBitMap_3,Round(fRange(fVal,0.0,100.0)),8,16)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_3,8,16)
	EndFunction
endproperty
float Property zad_KeyBreakChance hidden;chance of breaking the key
	Function set(float fVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_3 = codeBit(_deviceControlBitMap_3,Round(fRange(fVal,0.0,100.0)),8,24)
		endBitMapMutexCheck()
	EndFunction
	
	float Function get()
		return decodeBit(_deviceControlBitMap_3,8,24)
	EndFunction
endproperty

bool Property _isRemoved hidden
	Function set(bool bVal)
		startBitMapMutexCheck()
		_deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,26)
		endBitMapMutexCheck()
	EndFunction
	
	bool Function get()
		return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,26))
	EndFunction
EndProperty

bool _isUnlocked = false
bool Property isUnlocked
	Function set(bool bVal)
		;can't be changed externally
	EndFunction
	
	bool Function get()
		return _isUnlocked
	EndFunction
EndProperty

;chekcs if animation are set and if not, sets them
Function safeCheckAnimations()
	UDCDmain.UDPatcher.safecheckAnimations(self)
EndFunction

;returns current device wearer
Actor Function getWearer()
	return Wearer
EndFunction

;returns current device wearers name
String Function getWearerName()
	return Wearer.getActorBase().getName()
EndFunction

Function setHelper(Actor akActor)
	_minigameHelper = akActor
EndFunction

;returns current minigame helper
Actor Function getHelper()
	return _minigameHelper
EndFunction

String Function getHelperName()
	if _minigameHelper
		return UDCDmain.getActorName(_minigameHelper)
	else
		return "ERROR"
	endif
EndFunction

bool Function WearerIsRegistered()
	return UDCDmain.isRegistered(getWearer())
EndFunction 

bool Function HelperIsRegistered()
	return UDCDmain.isRegistered(getHelper())
EndFunction 

bool Function WearerIsPlayer()
	If UDCDmain.ActorIsPlayer(getWearer())
		return true
	EndIf
	return false
EndFunction

bool Function WearerIsFollower()
	If UDCDmain.ActorIsFollower(getWearer())
		return true
	EndIf
	return false
EndFunction

bool Function PlayerInMinigame()
	return WearerIsPlayer() || HelperIsPlayer()
EndFunction

bool Function hasHelper()
	if _minigameHelper
		return True
	endif
	return False
EndFunction

bool Function HelperIsPlayer()
	If UDCDmain.ActorIsPlayer(getHelper())
		return true
	EndIf
	return false
EndFunction

bool Function HelperIsFollower()
	If UDCDmain.ActorIsFollower(getHelper())
		return true
	EndIf
	return false
EndFunction

bool Function isReady()
	return Ready
EndFunction

Event onInit()
	current_device_health = device_health
EndEvent

;pc frier 3000
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	if (akNewContainer as Actor) && !akOldContainer && !isUnlocked
		Init(akNewContainer as Actor)
	endif
	
	if UDmain		
		if (akOldContainer == UDCDmain.TransfereContainer_ObjRef)
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log("Device " + getDeviceHeader() + " transfered to transfer container!")
			endif
			UDCDmain._transferedDevice = self
		endif
	endif
EndEvent

string Function getDeviceHeader()
	return (getDeviceName() + "("+getWearerName()+")")
EndFunction
String Function getDeviceName()
	return deviceInventory.getName()
EndFunction

UD_CustomDevice_EquipScript Function getInventoryScript()
	return (UDCDmain.TransfereContainer_ObjRef.placeatme(deviceInventory,1) as UD_CustomDevice_EquipScript)
EndFunction

Function updateValuesFromInventoryScript()
	UD_CustomDevice_EquipScript temp = getInventoryScript()
	
	zad_deviceKey = temp.deviceKey
	zad_KeyBreakChance = temp.KeyBreakChance
	zad_DestroyOnRemove = temp.DestroyOnRemove
	zad_DestroyKey = temp.DestroyKey
	zad_JammLockChance = temp.LockJamChance

	DeviceRendered = temp.DeviceRendered
	temp.delete()
	
	if zad_DestroyOnRemove && !hasModifier("DOR")
		addModifier("DOR")
	endif
	
EndFunction

bool Function addModifier(string modifier,string param = "")
	if !hasModifier(modifier)
		if param != ""
			UD_Modifiers = PapyrusUtil.PushString(UD_Modifiers, modifier + ";" + param)
		else
			UD_Modifiers = PapyrusUtil.PushString(UD_Modifiers, modifier)
		endif
		return true
	else
		return false
	endif
EndFunction

bool Function removeModifier(string modifier)
	if hasModifier(modifier)
		UD_Modifiers = PapyrusUtil.RemoveString(UD_Modifiers, getModifier(modifier))
		return true
	else
		return false
	endif
EndFunction

bool Function hasModifier(string modifier)
	int iIndex = UD_Modifiers.length
	while iIndex
		iIndex -= 1
		if StringUtil.find(UD_Modifiers[iIndex],";") != -1
			if StringUtil.Substring(UD_Modifiers[iIndex], 0, StringUtil.find(UD_Modifiers[iIndex],";")) == modifier
				return true
			endif
		else	
			if UD_Modifiers[iIndex] == modifier
				return True
			endif
		endif
	endwhile
	return false
EndFunction

String Function GetModifierHeader(String rawModifier)
	if StringUtil.find(rawModifier,";") != -1
		return StringUtil.Substring(rawModifier, 0, StringUtil.find(rawModifier,";"))
	else	
		return rawModifier
	endif
EndFunction

String[] Function getModifierAllParam(string modifier)
	int iIndex = getModifierIndex(modifier)
	if iIndex != -1
		String[] sRes = StringUtil.split(UD_Modifiers[iIndex],";")
		if sRes.length > 1
			return StringUtil.split(sRes[1],",")
		else
			return none
		endif
	else
		return none
	endif
EndFunction

string Function getModifier(string modifier)
	if hasModifier(modifier)
		return UD_Modifiers[getModifierIndex(modifier)]
	else
		return "ERROR"
	endif
EndFunction

int Function getModifierIndex(string modifier)
	int iIndex = UD_Modifiers.length
	while iIndex
		iIndex -= 1
		if StringUtil.find(UD_Modifiers[iIndex],modifier) != -1
			return iIndex
		endif
	endwhile
	return -1
EndFunction

bool Function editStringModifier(string modifier,int index, string newValue)
	String[] param = getModifierAllParam(modifier)
	if param
		param[index] = newValue
		UD_Modifiers[getModifierIndex(modifier)] = modifier + ";" + PapyrusUtil.StringJoin(param,",")
		return true
	else
		return false
	endif
EndFunction

bool Function modifierHaveParams(string modifier)
	if StringUtil.find(getModifier(modifier),";") != -1
		return true
	else
		return false
	endif
EndFunction

int Function getModifierParamNum(string modifier)
	return getModifierAllParam(modifier).length
EndFunction

Int Function getModifierIntParam(string modifier,int index = 0)
	return getModifierAllParam(modifier)[index] as Int
EndFunction

Float Function getModifierFloatParam(string modifier,int index = 0)
	return getModifierAllParam(modifier)[index] as Float
EndFunction

String Function getModifierParam(string modifier,int index = 0)
	return getModifierAllParam(modifier)[index]
EndFunction

Function setModifierIntParam(string modifier,int value,int index = 0)
	editStringModifier(modifier,index,value)
EndFunction

Function setModifierFloatParam(string modifier,float value,int index = 0)
	editStringModifier(modifier,index,value)
EndFunction

Function setModifierParam(string modifier, string value,int index = 0)
	editStringModifier(modifier,index,value)
EndFunction

float Function getDurabilityDmgMod()
	return _durability_damage_mod
EndFunction


Function StartInitMutex()
	While UDCDmain.UD_EquipMutex
		Utility.WaitMenuMode(0.1)
	EndWhile
	UDCDmain.UD_EquipMutex = True
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("Mutexed and proccesing " + getDeviceHeader(),2)
	endif
EndFunction

Function EndInitMutex()
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("Mutex ended for " + getDeviceHeader(),2)
	endif
	UDCDmain.UD_EquipMutex = False
EndFunction

;post equip function
Function Init(Actor akActor)
	if !akActor
		if UDCDmain.TraceAllowed()
			UDCDmain.Log("!Aborting Init called for "+getDeviceName()+" because actor is none!!")
		endif
	endif

	libSafeCheck()
	Wearer = akActor
	
	if isUnlocked 
		UDCDmain.Log("!Aborting Init("+ UDCDmain.getActorName(akActor) +") called for " + DeviceInventory.getName() + " because device is already unlocked!!")
		if (libs as zadlibs_UDPatch).isMutexed(akActor,deviceInventory)
			(libs as zadlibs_UDPatch).UD_GlobalDeviceMutex_RenderScript = true
		endif
		return 
	endif
	
	if akActor.getItemCount(deviceInventory) == 0
		UDCDmain.Log("!Aborting Init("+ UDCDmain.getActorName(akActor) +") called for " + DeviceInventory.getName() + " because no inventory device is present!")
		if (libs as zadlibs_UDPatch).isMutexed(akActor,deviceInventory)
			(libs as zadlibs_UDPatch).UD_GlobalDeviceMutex_RenderScript = true
		endif
		return
	endif
	
	updateValuesFromInventoryScript()
	
	if !akActor.isEquipped(deviceInventory);StorageUtil.GetIntValue(akActor,"zad_Equipped" + deviceInventory,0)
		UDCDmain.Log("!Aborting Init("+ UDCDmain.getActorName(akActor) +") called for " + DeviceInventory.getName() + " because inventory device is unequipped!!")
		if (libs as zadlibs_UDPatch).isMutexed(akActor,deviceInventory)
			(libs as zadlibs_UDPatch).UD_GlobalDeviceMutex_RenderScript = true
		endif
		akActor.removeItem(deviceRendered,1)
		return 
	endif
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("Init(called for " + getDeviceHeader(),1)
	endif
	if UDCDmain.TraceAllowed()
		UDCDmain.Log(getDeviceHeader() + " equiped? RD=" + getWearer().IsEquipped(deviceRendered)+",ID="+getWearer().IsEquipped(deviceInventory))
	endif
	
	;MUTEX START
	;mutex check because some mods equips items too fast at once, making it possible to have equipped 2 of the same item
	if UDCDmain.isRegistered(getWearer())
		StartInitMutex()
	endif
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("Registering device: " + getDeviceHeader(),1)
	endif
	UDCDmain.startScript(self)
	
	if (libs as zadlibs_UDPatch).isMutexed(akActor,deviceInventory)
		(libs as zadlibs_UDPatch).UD_GlobalDeviceMutex_RenderScript = true
	endif
	
	if UDCDmain.isRegistered(getWearer())
		EndInitMutex()
	endif
	;MUTEX END	
	if deviceRendered.hasKeyword(UDlibs.PatchedDevice) ;patched device
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("Patching device " + deviceInventory.getName(),2)
		endif
		patchDevice()
	else
		if UD_WeaponHitResist == 5.23
			UD_WeaponHitResist = UD_ResistPhysical
		endif
		if UD_SpellHitResist == 5.23
			UD_SpellHitResist = UD_ResistMagicka
		endif
	endif
	
	
	if deviceRendered.hasKeyword(libs.zad_DeviousBelt) || deviceRendered.hasKeyword(libs.zad_DeviousBra)
		libs.Aroused.SetActorExposureRate(akActor, libs.GetModifiedRate(akActor))	
	endif
	
	UD_CurrentLocks = UD_Locks
	current_device_health = device_health ;repairs device to max durability on equip
	
	safeCheck()
	
	UDCDmain.CheckHardcoreDisabler(getWearer())
	
	InitPost()

	if UD_Cooldown > 0
		_currentRndCooldown = Round(UD_Cooldown*Utility.randomFloat(0.75,1.25)*UDCDmain.UD_CooldownMultiplier)
	endif
	
	Ready = True
	if UDCDmain.TraceAllowed()
		UDCDmain.Log(DeviceInventory.getName() + " fully locked on " + getWearerName(),1)
	endif
	InitPostPost()
EndFunction

Function removeDevice(actor akActor)
	if _removeDeviceCalled
		return
	endif
	
	_removeDeviceCalled = True
	
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("removeDevice() called for " + getDeviceHeader(),1)
	endif
	
	OnRemovePre()
	
	if UDCDmain.UDCD_NPCM.isRegistered(akActor)
		UDCDmain.endScript(self)
	endif
	
	if !akActor.isDead()
		if !_isUnlocked
			current_device_health = 0.0
			_isUnlocked = True
			UDCDmain.updateLastOpenedDeviceOnRemove(self)
			StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
			if wearer.isinfaction(UDCDmain.minigamefaction)
				wearer.removefromfaction(UDCDmain.minigamefaction)
				StorageUtil.UnSetFormValue(Wearer, "UD_currentMinigameDevice")
			endif
		endif
	endif
	if deviceRendered.hasKeyword(libs.zad_DeviousBelt) || deviceRendered.hasKeyword(libs.zad_DeviousBra)
		libs.Aroused.SetActorExposureRate(akActor, libs.GetOriginalRate(akActor))
		StorageUtil.UnSetFloatValue(akActor, "zad.StoredExposureRate")
	endif
	
	if zad_DestroyOnRemove || !akActor.isDead()
		if hasModifier("LootGold")
			if UDCDmain.TraceAllowed()
			UDCDmain.Log("Gold added: " + getModifierIntParam("LootGold"),1)
			endif
			int goldNumMin = getModifierIntParam("LootGold")
			if getModifierParamNum("LootGold") > 1
				int goldNumMax = getModifierIntParam("LootGold",1)
				if goldNumMax < goldNumMin
					goldNumMax = goldNumMin
				endif
				int randomNum = Utility.randomInt(goldNumMin,goldNumMax)
				if randomNum > 0
					akActor.addItem(UDlibs.Gold,randomNum)	
				endif				
			else
				akActor.addItem(UDlibs.Gold,goldNumMin)
			endif
		endif
		
		if hasModifier("DOR")
			if UD_OnDestroyItemList; && hasModifier("LootList")
				if UDCDmain.TraceAllowed()
					UDCDmain.Log("Items from LIL " + UD_OnDestroyItemList + " added to actor " + akActor,3)
				endif
				akActor.addItem(UD_OnDestroyItemList)
			endif
		endif
	endif
	StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
	
	onRemoveDevicePost(akActor)
	
	_isRemoved = True
EndFunction

;elapsed time for cooldown in minutes
float Function getElapsedCooldownTime()
	return _updateTimePassed
EndFunction

;0.0 - 1.0 for _currentRndCooldown
float Function getRelativeElapsedCooldownTime()
	if UD_Cooldown > 0
		return _updateTimePassed/_currentRndCooldown
	else
		return 1.0
	endif
EndFunction

;called on every device update
;update time is set in MCM
;this only works if actor is registered
Function Update(float timePassed)
	_updateTimePassed += (timePassed*24.0*60.0);*UDCDmain.UD_CooldownMultiplier
	
	if _updateTimePassed > _currentRndCooldown && UD_Cooldown > 0
		CooldownActivate()
	endif
	
	OnUpdatePre(timePassed)
	updateMend(timePassed)
	updateCondition()
	OnUpdatePost(timePassed)
EndFunction

Function resetCooldown()
	_updateTimePassed = 0.0
	_currentRndCooldown = iRange(Round(UD_Cooldown*Utility.randomFloat(0.75,1.25)*UDCDmain.UD_CooldownMultiplier),0,24*60*60*10)
EndFunction

;like Update function, but called only once per hour
;mult -> multiplier which identifies how many hours have passed (1.5 hours -> mult = 1.5)
Function UpdateHour(float mult)
	if OnUpdateHourPre()
		if OnUpdateHourPost()
			if libs.isValidActor(GetWearer()) && hasModifier("MAH")
				int loc_chance = UDCDmain.Round(getModifierIntParam("MAH",0)*(UDCDmain.UDPatcher.UD_MAHMod/100.0))
				int loc_number = getModifierIntParam("MAH",1)
				Form[] loc_array
				if Utility.randomInt() < loc_chance
					while loc_number
						loc_number -= 1
						Armor loc_device = UDmain.UDRRM.LockRandomRestrain(getWearer())
						if loc_device
							loc_array = PapyrusUtil.PushForm(loc_array,loc_device)
						else
							loc_number = 0 ;end, because no more devices can be locked
						endif
					endwhile
				endif
				if loc_array
					if loc_array.length > 0
						if WearerIsPlayer()
							string loc_str = getDeviceName() + " suddenly starts to emit black smoke, which envelop your body and forms its shape in to bondage restraint!\n"
							loc_str += "Devices locked: \n"
							
							int i = 0
							while i < loc_array.length
								loc_str += (loc_array[i] as Armor).getName() + "\n"
								i+= 1
							endwhile
							
							UDCDmain.ShowMessageBox(loc_str)
						elseif WearerIsFollower()
							UDCDmain.Print(getWearerName() + "s "+ getDeviceName() +" suddenly locks them in bondage restraint!",1)
						endif
					endif
				endif
			endif
		endif
	endif
EndFunction

Function libSafeCheck()
	if !UDmain
		Quest UDquest = Game.getFormFromFile(0x00005901,"UnforgivingDevices.esp") as Quest
		UDmain = UDquest as UnforgivingDevicesMain 
	endif
EndFunction

;check if all properties are set
;main purpose of this is so patching devices is not such pain in the ass
Function safeCheck()
	if !UD_MessageDeviceInteraction
		UD_MessageDeviceInteraction = UDCDmain.DefaultInteractionDeviceMessage
	endif
	if !UD_MessageDeviceInteractionWH
		UD_MessageDeviceInteractionWH = UDCDmain.DefaultInteractionDeviceMessageWH
	endif
EndFunction

float Function getLockStrength()
	if UD_Locks > 0
		return (UD_CurrentLocks as float)/(UD_Locks)
	else
		return 1.0
	endif
EndFunction

Function updateDifficulty()
	_durability_damage_mod = UD_durability_damage_base*UDCDmain.getStruggleDifficultyModifier()*(2.0 - getLockStrength())
	if UD_CurrentLocks == UD_JammedLocks && !libs.IsLockJammed(Wearer,UD_DeviceKeyword)
		UD_JammedLocks = 0
	endif
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchGeneric(self)
EndFunction

float Function getRelativeDurability()
	return current_device_health/device_health
EndFunction 

float Function getRelativeCuttingProgress()
	return UD_CuttingProgress/100.0
EndFunction

float Function getRelativeLockRepairProgress()
	return UD_RepairProgress/getLockDurability()
EndFunction

float Function getLockDurability()
	return 100.0
EndFunction

;returns comprehesive lock level
;1 = Novice
;2 = Apprentice
;3 = Adept
;4 = Expert
;5 = Master
;6 = Requires Key
int Function getLockLevel()
	if !UD_LockpickDifficulty
		return 4
	endif
	if UD_LockpickDifficulty >= 1 && UD_LockpickDifficulty < 50
		return 0
	elseif UD_LockpickDifficulty >= 50 && UD_LockpickDifficulty < 75
		return 1
	elseif UD_LockpickDifficulty >= 75 && UD_LockpickDifficulty < 100
		return 2
	elseif UD_LockpickDifficulty >= 100 && UD_LockpickDifficulty < 255
		return 3
	elseif UD_LockpickDifficulty >= 255
		return 4
	endif
	
	return 4
EndFunction

;returns lock acces chance
int Function getLockAccesChance(bool useTelekinesis = true)
	int res = Round(UD_LockAccessDifficulty)
	if res < 100
		if Wearer.wornHasKeyword(libs.zad_DeviousBlindfold)
			res += 25
		endif
		if res >= 100 
			res = 100 - (100 - Round(UD_LockAccessDifficulty))/2
		endif
	endif

	If !WearerFreeHands(True)
		res = 100
	Endif

	if wearer.hasspell(UDlibs.TelekinesisSpell) && useTelekinesis
		res -= 10
	endif
	if hasHelper()
		if _minigameHelper.hasspell(UDlibs.TelekinesisSpell) && useTelekinesis
			res -= 10
		endif	
		
		if HelperFreeHands(True)
			res = 0
		elseif HelperFreeHands()
			res -= 25
		endif
	endif
	
	if res < 0
		res = 0
	endif
	
	return 100 - res
EndFunction

Function setWidgetVal(float val,bool force = false)
	UDCDmain.widget1.SetPercent(val, force)
EndFunction

Function setWidgetColor(int val,int val2 = -1,int flash_col = -1)
	UD_WidgetColor = val
	UD_WidgetColor2 = val2
	UD_WidgetFlashColor = flash_col
	UDCDmain.widget1.SetColors(UD_WidgetColor, UD_WidgetColor2,flash_col)
EndFunction

Function updateWidget(bool force = false)
	if struggleGame_on
		setWidgetVal(getRelativeDurability(),force)
	elseif cuttingGame_on
		setWidgetVal(getRelativeCuttingProgress(),force)
	elseif repairLocksMinigame_on
		setWidgetVal(getRelativeLockRepairProgress(),force)
	endif
EndFunction

Function updateWidgetColor()
	if UD_WidgetAutoColor
		if UD_Condition == 0
			UD_WidgetColor2 = 0x61ff00
			UD_WidgetColor = 0x4da319
		elseif UD_Condition == 1
			UD_WidgetColor2 = 0x4da319
			UD_WidgetColor = 0xafba24
		elseif UD_Condition == 2
			UD_WidgetColor2 = 0xafba24
			UD_WidgetColor = 0xe37418
		elseif UD_Condition == 3
			UD_WidgetColor2 = 0xe37418
			UD_WidgetColor = 0xdc1515
		else
			UD_WidgetColor2 = 0xdc1515
			UD_WidgetColor = 0x5a1515
		endif
	endif
	
	UDCDmain.widget1.SetColors(UD_WidgetColor, UD_WidgetColor2,UD_WidgetFlashColor)
EndFunction

Function showWidget()
	updateWidget(true)
	updateWidgetColor()
	UDCDmain.toggleWidget(true)
EndFunction

Function hideWidget()
	UDCDmain.toggleWidget(False)
EndFunction

Function decreaseDurability(float value,float cond_mult = 1.0)
	if current_device_health > 0.0
		current_device_health -= value
		_total_durability_drain += value*cond_mult
		if current_device_health > 0
			updateCondition()
		endif
	endif
EndFunction

Function decreaseDurabilityAndCheckUnlock(float value,float cond_mult = 1.0)
	if current_device_health > 0.0
		current_device_health = fRange(current_device_health - value,0.0,device_health)
		_total_durability_drain += value*cond_mult
		if current_device_health > 0
			updateCondition()
		endif
	endif
	
	if current_device_health <= 0.0 && !_isUnlocked
		unlockRestrain()
		advanceSkill(10.0)
	endif
EndFunction

float Function getDurability()
	return current_device_health
EndFunction

float Function getMaxDurability()
	return device_health
EndFunction

float Function getCondition()
	return _total_durability_drain
EndFunction

float Function getRelativeCondition()
	return (100.0 - _total_durability_drain)/100.0
EndFunction

bool Function isSentient()
	return hasModifier("Sentient")
EndFunction

bool Function haveRegen()
	return hasModifier("Regen")
EndFunction

bool Function isLoose()
	return hasModifier("Loose")
EndFunction

float Function getLooseMod()
	return getModifierFloatParam("Loose")
EndFunction

Function setDurability(float durability)
	current_device_health = durability
EndFunction

;/
Function decreaseDurabilitySlow(float value)
	current_device_health -= value
	if current_device_health <= 0
		unlockRestrain()
	endif
	if current_device_health >= device_health
		current_device_health = device_health
	endif
EndFunction
/;

Function decreaseConditionSlow(float value)
	_total_durability_drain += value
	updateCondition(value >= 0)
EndFunction

Function updateMend(float timePassed)
	if getRelativeDurability() < 1.0 && hasModifier("Regen")
		mendDevice(1.0,timePassed)
	endif
	if hasModifier("_HEAL")
		if WearerIsRegistered()
			UD_CustomDevice_RenderScript[] loc_devices = UDCDmain.getNPCDevices(getWearer())
			int loc_i = 0
			while loc_devices[loc_i]
				loc_devices[loc_i].refillDurability(timePassed*getModifierIntParam("_HEAL")*UDCDmain.getStruggleDifficultyModifier())
				loc_i+=1
			endwhile
		endif
	endif
EndFunction

Function updateCondition(bool decrease = True)
	if decrease
		while (_total_durability_drain >= 100) && !_isUnlocked && UD_condition < 4
			_total_durability_drain -= 100
			UD_condition += 1
			if WearerIsPlayer()
				debug.notification("You feel that "+getDeviceName()+" condition have decreased!")
			elseif WearerIsFollower()
				debug.notification(GetWearerName() + "s " + getDeviceName() + " condition have decreased!")
			endif
		endwhile
	else
		if (_total_durability_drain < 0) && !_isUnlocked
			_total_durability_drain = 0
			if UD_condition > 0 
				UD_condition -= 1
				if WearerIsPlayer()
					debug.notification("You feel that "+getDeviceName()+" condition have increased!")
				elseif WearerIsFollower()
					debug.notification(GetWearerName() + "s " + getDeviceName() + " condition have increased!")
				endif
			endif
		endif
	endif
	
	if UD_condition >= 4 && !isUnlocked
		if WearerIsPlayer()
			debug.notification("You managed to destroy "+ getDeviceName() +"!")
		elseif WearerIsFollower()
			debug.notification(GetWearerName() + " managed to destroy " + getDeviceName() + "!")
		endif
		unlockRestrain(True)
	endif
EndFunction

string Function getConditionString()
	if (UD_condition == 0)
		return "Excellent"
	elseif (UD_condition == 1)
		return "Good"
	elseif (UD_condition == 2)
		return "Normal"
	elseif (UD_condition == 3)
		return "Bad"
	else
		return "Destroyed"
	endif
EndFunction

;mends device
Function mendDevice(float mult = 1.0,float timePassed,bool silent = false)
	if onMendPre(mult) && current_device_health > 0.0
		int regen = getModifierIntParam("Regen")
		refillDurability(timePassed*regen*(1 - 0.1*UD_condition)*mult*UDCDmain.getStruggleDifficultyModifier())
		;current_device_health += timePassed*regen*(1 - 0.1*UD_condition)*mult*UDCDmain.getStruggleDifficultyModifier()
		;if (current_device_health > device_health)
		;	_total_durability_drain -= 5*(current_device_health - device_health)
		;	current_device_health = device_health
		;	updateCondition(False)
		;endif
		refillCuttingProgress(timePassed*regen)
		;UD_CuttingProgress -= timePassed*regen
		;if UD_CuttingProgress < 0.0
		;	UD_CuttingProgress = 0.0
		;endif
		onMendPost(mult)
	endif
EndFunction

Function refillDurability(float arg_fValue)
	if current_device_health > 0.0
		current_device_health += arg_fValue
		if (current_device_health > device_health)
			_total_durability_drain -= 5*(current_device_health - device_health)
			current_device_health = device_health
			updateCondition(False)
		endif
	endif
EndFunction

Function refillCuttingProgress(float arg_fValue)
	if current_device_health > 0.0
		UD_CuttingProgress -= arg_fValue
		if UD_CuttingProgress < 0.0
			UD_CuttingProgress = 0.0
		endif
	endif
EndFunction
bool Function isPlug()
	bool res = false
	res = res || (UD_DeviceKeyword == libs.zad_deviousPlugVaginal)
	res = res || (UD_DeviceKeyword == libs.zad_deviousPlugAnal)
	res = res || (UD_DeviceKeyword == libs.zad_deviousPlug)
	res = res || (UD_DeviceKeyword == libs.zad_kw_InflatablePlugAnal)
	res = res || (UD_DeviceKeyword == libs.zad_kw_InflatablePlugVaginal)
	return res
EndFunction

bool Function isPiercing(bool ignoreVag = false,bool ignoreNipple = false)
	bool res = false
	res = res || (UD_DeviceKeyword == libs.zad_deviousPiercingsNipple && !ignoreNipple) 
	res = res || (UD_DeviceKeyword == libs.zad_DeviousPiercingsVaginal && !ignoreVag)
	return res
EndFunction

bool Function isMittens()
	bool res = false
	res = res || deviceRendered.hasKeyword(libs.zad_DeviousBondageMittens)
	return res
EndFunction

bool Function isHeavyBondage()
	bool res = false
	res = res || deviceRendered.hasKeyword(libs.zad_deviousHeavyBondage)
	;res = res || (UD_DeviceKeyword == libs.zad_DeviousPiercingsVaginal && !ignoreVag)
	return res
EndFunction

bool Function wearerHaveBelt()
	bool res = false
	res = res || wearer.wornhaskeyword(libs.zad_deviousBelt) 
	res = res || wearer.wornhaskeyword(libs.zad_deviousHarness)
	return res
EndFunction

bool Function wearerHaveBra()
	bool res = false
	res = res || wearer.wornhaskeyword(libs.zad_deviousBra) 
	return res
EndFunction

bool Function wearerHaveSuit(bool bCheckStraitjacket = false)
	bool res = false
	res = res || wearer.wornhaskeyword(libs.zad_deviousSuit) 
	res = res && !(wearer.wornhaskeyword(libs.zad_deviousStraitjacket) && bCheckStraitjacket)
	return res
EndFunction

bool Function canBeStruggled()
	if UD_durability_damage_base > 0.0 && getAccesibility() > 0.0
		return True
	else
		return false
	endif
EndFunction

bool Function isEscapable()
	if UD_durability_damage_base > 0.0 || (UD_Locks > 0 && UD_LockpickDifficulty < 255)
		return True
	else
		return false
	endif
EndFunction

bool Function canBeCutted()
	if UD_CutChance > 0.0
		return True
	else
		return false
	endif
EndFunction

bool Function wearerFreeHands(bool checkGrasp = false,bool ignoreHeavyBondageTarget = true,bool ignoreHeavyBondage = false)
	bool res = !Wearer.wornhaskeyword(libs.zad_deviousHeavyBondage) || ignoreHeavyBondage
	if ignoreHeavyBondageTarget 
		if deviceRendered.hasKeyword(libs.zad_deviousHeavyBondage)
			res = true
		endif
	endif
		
	if checkGrasp
		if wearer.wornhaskeyword(libs.zad_DeviousBondageMittens)
			res = false
		endif
	endif
	return res
EndFunction

bool Function helperFreeHands(bool checkGrasp = false,bool ignoreHeavyBondage = false)
	bool res = !_minigameHelper.wornhaskeyword(libs.zad_deviousHeavyBondage) || ignoreHeavyBondage 
		
	if checkGrasp
		if _minigameHelper.wornhaskeyword(libs.zad_DeviousBondageMittens)
			res = false
		endif
	endif
	return res
EndFunction

bool Function WearerHaveMittens()
	return wearer.wornhaskeyword(libs.zad_DeviousBondageMittens)
EndFunction

bool Function HelperHaveMittens()
	if hasHelper()
		return _minigameHelper.wornhaskeyword(libs.zad_DeviousBondageMittens)
	endif
EndFunction
bool Function wearerFreeLegs()
	bool res = !Wearer.wornhaskeyword(libs.zad_deviousHobbleSkirt)
	return res
EndFunction

bool Function helperFreeLegs()
	bool res = !getHelper().wornhaskeyword(libs.zad_deviousHobbleSkirt)
	return res
EndFunction



bool Function canShowHUD()
	bool res = False
	if WearerIsPlayer()
		res = (UD_drain_stats || UD_RegenMag_Stamina  || UD_RegenMag_Health || UD_RegenMag_Magicka)
	endif
	if HelperIsPlayer()
		res = (UD_drain_stats_helper || UD_RegenMagHelper_Stamina  || UD_RegenMagHelper_Health || UD_RegenMagHelper_Magicka)
	endif
	return res
EndFunction

float Function getModResistPhysical(float base = 1.0,float cond_mod = 0.0)
	return (base - UD_ResistPhysical + (0.1 + cond_mod)*UD_Condition)
EndFunction

float Function getModResistMagicka(float base = 1.0,float cond_mod = 0.0)
	return (base - UD_ResistMagicka + (0.1 + cond_mod)*UD_Condition)
EndFunction

;--------------------------------------------------------
; _____             _            __  __                  
;|  __ \           (_)          |  \/  |                 
;| |  | | _____   ___  ___ ___  | \  / | ___ _ __  _   _ 
;| |  | |/ _ \ \ / / |/ __/ _ \ | |\/| |/ _ \ '_ \| | | |
;| |__| |  __/\ V /| | (_|  __/ | |  | |  __/ | | | |_| |
;|_____/ \___| \_/ |_|\___\___| |_|  |_|\___|_| |_|\__,_|
;--------------------------------------------------------                                                      

Function filterControl(bool[] aControlFilter)
	UDCDmain.currentDeviceMenu_allowstruggling = UDCDmain.currentDeviceMenu_allowstruggling && !aControlFilter[0]
	UDCDmain.currentDeviceMenu_allowUselessStruggling = UDCDmain.currentDeviceMenu_allowUselessStruggling && !aControlFilter[1]
	UDCDmain.currentDeviceMenu_allowcutting = UDCDmain.currentDeviceMenu_allowcutting && !aControlFilter[2]
	UDCDmain.currentDeviceMenu_allowkey = UDCDmain.currentDeviceMenu_allowkey && !aControlFilter[3]
	UDCDmain.currentDeviceMenu_allowlockpick = UDCDmain.currentDeviceMenu_allowlockpick && !aControlFilter[4]
	UDCDmain.currentDeviceMenu_allowlockrepair = UDCDmain.currentDeviceMenu_allowlockrepair && !aControlFilter[5]
	UDCDmain.currentDeviceMenu_allowTighten = UDCDmain.currentDeviceMenu_allowTighten && !aControlFilter[6]
	UDCDmain.currentDeviceMenu_allowRepair = UDCDmain.currentDeviceMenu_allowTighten &&	!aControlFilter[7]
	
	UDCDmain.currentDeviceMenu_switch1 = UDCDmain.currentDeviceMenu_switch1  &&	!aControlFilter[8]
	UDCDmain.currentDeviceMenu_switch2 = UDCDmain.currentDeviceMenu_switch2  &&	!aControlFilter[9]
	UDCDmain.currentDeviceMenu_switch3 = UDCDmain.currentDeviceMenu_switch3  &&	!aControlFilter[10]
	UDCDmain.currentDeviceMenu_switch4 = UDCDmain.currentDeviceMenu_switch4  &&	!aControlFilter[11]
	UDCDmain.currentDeviceMenu_switch5 = UDCDmain.currentDeviceMenu_switch5  &&	!aControlFilter[12]
	UDCDmain.currentDeviceMenu_switch6 = UDCDmain.currentDeviceMenu_switch6  &&	!aControlFilter[13]
	
	UDCDmain.currentDeviceMenu_allowCommand = UDCDmain.currentDeviceMenu_allowCommand && !aControlFilter[14]
	UDCDmain.currentDeviceMenu_allowDetails = UDCDmain.currentDeviceMenu_allowDetails && !aControlFilter[15]
	
	UDCDmain.currentDeviceMenu_allowSpecialMenu = UDCDmain.currentDeviceMenu_allowSpecialMenu && !aControlFilter[16]
	UDCDmain.currentDeviceMenu_allowLockMenu = UDCDmain.currentDeviceMenu_allowLockMenu && !aControlFilter[17]
	
EndFunction

Function deviceMenuInit(bool[] aControl = none)
	;updates difficulty
	updateDifficulty()
	setHelper(none)
	UDCDmain.resetCondVar()

	if !aControl
		aControl = new Bool[18]
	endif

	;normal struggle
	if canBeStruggled() && (isLoose() || WearerFreeHands())
		UDCDmain.currentDeviceMenu_allowstruggling = True
	else
		UDCDmain.currentDeviceMenu_allowUselessStruggling = True
	endif
	
	;key unlock
	if zad_deviceKey && UD_CurrentLocks != UD_JammedLocks
		if wearer.getItemCount(zad_deviceKey) > 0 && (getLockAccesChance() > 0)
			UDCDmain.currentDeviceMenu_allowkey = True
		endif
	endif
	
	;lockpicking
	if UD_CurrentLocks != UD_JammedLocks
		if UD_LockpickDifficulty < 255 && wearer.getItemCount(UDCDmain.Lockpick) > 0 && getLockAccesChance() > 0
			UDCDmain.currentDeviceMenu_allowlockpick = True
		endif
	endif
	
	;lock repair
	if getLockAccesChance() > 0 && UD_JammedLocks > 0
		UDCDmain.currentDeviceMenu_allowlockrepair = True
	endif
	
	if (!UDCDmain.currentDeviceMenu_allowkey && !UDCDmain.currentDeviceMenu_allowlockpick && !UDCDmain.currentDeviceMenu_allowlockrepair)
		aControl[17] = True
	endif
	
	;cutting
	if canBeCutted() && (isLoose() || WearerFreeHands()) ;&& UD_durability_damage_base > 0.0
		UDCDmain.currentDeviceMenu_allowcutting = True
	endif
	
	if UD_Locks > 0 && (zad_deviceKey || UD_LockpickDifficulty < 255)
		UDCDmain.currentDeviceMenu_allowLockMenu = True
	endif
	
	filterControl(aControl)
	
	;sets last opened device
	if WearerIsPlayer()
		UDCDmain.setLastOpenedDevice(self)
	endif
	;override function
	onDeviceMenuInitPost(aControl)
	UDCdmain.CheckAndDisableSpecialMenu()
EndFunction


;device menu that pops up when Wearer click on this device in inventory
;CONTROL; !NUM = 17!
;	0 = currentDeviceMenu_allowstruggling
;	1 = currentDeviceMenu_allowUselessStruggling	
;	2 = currentDeviceMenu_allowcutting
;	3 = currentDeviceMenu_allowkey
;	4 = currentDeviceMenu_allowlockpick
;	5 = currentDeviceMenu_allowlockrepair
;	6 = currentDeviceMenu_allowTighten
;	7 = currentDeviceMenu_allowRepair	
;	8 = currentDeviceMenu_switch1
;	9 = currentDeviceMenu_switch2
;	10 = currentDeviceMenu_switch3
;	11 = currentDeviceMenu_switch4
;	12 = currentDeviceMenu_switch5
;	13 = currentDeviceMenu_switch6	
;	14 = currentDeviceMenu_allowCommand
;	15 = currentDeviceMenu_allowDetails
;	16 = special menu
;	17 = lockmenu
Function DeviceMenu(bool[] aControl)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("DeviceMenu() called for: " + deviceRendered,2)
	endif
	bool _break = False
	while !_break
		deviceMenuInit(aControl)
		Int msgChoice = UD_MessageDeviceInteraction.Show()
		StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
		if msgChoice == 0		;struggle
			_break = struggleMinigame()
		elseif msgChoice == 1	;useless struggle
			_break = struggleMinigame(5)
		elseif msgChoice == 2	;manage locks
			_break = lockMenu(aControl)
		elseif msgChoice == 3	;cutting
			_break = cuttingMinigame()
		elseif msgChoice == 4 	;special menu
			_break = specialMenu(aControl)
		elseif msgChoice == 5 	;details
			processDetails()		
		else
			_break = True		;exit
		endif
		DeviceMenuExt(msgChoice)
		if Game.UsingGamepad()
			Utility.waitMenuMode(0.75)
		endif
	endwhile
EndFunction

bool Function lockMenu(bool[] aControl)
	Int msgChoice = UDCDmain.DefaultLockMenuMessage.Show()
	if msgChoice == 0
		return keyMinigame()
	elseif msgChoice == 1
		return lockpickMinigame()
	elseif msgChoice == 2
		return repairLocksMinigame()
	else
		return False
	endif
EndFunction

bool Function specialMenu(bool[] aControl)
	if UD_SpecialMenuInteraction
		return proccesSpecialMenu(UD_SpecialMenuInteraction.show())
	else
		return False
	endif
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
	return false
EndFunction

Function deviceMenuInitWH(Actor akSource,bool[] aControl)
	;updates difficulty
	setHelper(akSource)
	
	updateDifficulty()
	UDCDmain.resetCondVar()

	;help struggle
	if canBeStruggled()
		UDCDmain.currentDeviceMenu_allowstruggling = True
	endif
	
	;key unlock
	if zad_deviceKey && UD_CurrentLocks != UD_JammedLocks
		if (wearer.getItemCount(zad_deviceKey) > 0 || akSource.getItemCount(zad_deviceKey) > 0) && (getLockAccesChance() > 0 || HelperFreeHands(True))
			UDCDmain.currentDeviceMenu_allowkey = True
		endif
	endif
	
	;lockpicking
	if UD_CurrentLocks != UD_JammedLocks
		if UD_LockpickDifficulty < 255 && (wearer.getItemCount(UDCDmain.Lockpick) > 0 || akSource.getItemCount(UDCDmain.Lockpick) > 0) && (getLockAccesChance() > 0 ||HelperFreeHands(True))
			UDCDmain.currentDeviceMenu_allowlockpick = True
		endif
	endif
	
	;lock repair
	if (getLockAccesChance() > 0 || HelperFreeHands(True)) && UD_JammedLocks > 0
		UDCDmain.currentDeviceMenu_allowlockrepair = True
	endif

	if (!UDCDmain.currentDeviceMenu_allowkey && !UDCDmain.currentDeviceMenu_allowlockpick && !UDCDmain.currentDeviceMenu_allowlockrepair)
		aControl[17] = True
	endif
	
	;cutting
	if canBeCutted(); && wearerFreeHands() ;&& UD_durability_damage_base > 0.0
		UDCDmain.currentDeviceMenu_allowcutting = True
	endif
		
	if HelperFreeHands(True)
		UDCDmain.currentDeviceMenu_allowTighten = True
	endif
	
	if HelperFreeHands(True)
		UDCDmain.currentDeviceMenu_allowRepair = True
	endif
	
	if UD_Locks > 0 && (zad_deviceKey || UD_LockpickDifficulty < 255)
		UDCDmain.currentDeviceMenu_allowLockMenu = True
	endif
	
	if WearerIsFollower() && !WearerIsPlayer()
		UDCDmain.currentDeviceMenu_allowCommand = True
	else
		;UDCDmain.currentDeviceMenu_allowcutting = False
		;UDCDmain.currentDeviceMenu_allowlockpick = False
		;UDCDmain.currentDeviceMenu_allowkey = False
		;UDCDmain.currentDeviceMenu_allowstruggling = False
	endif
	
	filterControl(aControl)
	
	;override function
	onDeviceMenuInitPostWH(aControl)
	UDCdmain.CheckAndDisableSpecialMenu()
EndFunction

;device menu that pops up when Wearer click on this device in inventory
;CONTROL; !NUM = 18!
;	0 = currentDeviceMenu_allowstruggling
;	1 = currentDeviceMenu_allowUselessStruggling	
;	2 = currentDeviceMenu_allowcutting
;	3 = currentDeviceMenu_allowkey
;	4 = currentDeviceMenu_allowlockpick
;	5 = currentDeviceMenu_allowlockrepair
;	6 = currentDeviceMenu_allowTighten
;	7 = currentDeviceMenu_allowRepair	
;	8 = currentDeviceMenu_switch1
;	9 = currentDeviceMenu_switch2
;	10 = currentDeviceMenu_switch3
;	11 = currentDeviceMenu_switch4
;	12 = currentDeviceMenu_switch5
;	13 = currentDeviceMenu_switch6	
;	14 = currentDeviceMenu_allowCommand
;	15 = currentDeviceMenu_allowDetails
;	16 = special menu
;	17 = lockmenu
Function DeviceMenuWH(Actor akSource,bool[] aControl)
	UDCDmain.UDmain.Log("[UD]: DeviceMenuWH() called for: " + deviceRendered,2)
	
	bool _break = False
	while !_break
		deviceMenuInitWH(akSource,aControl)
		Int msgChoice = UD_MessageDeviceInteractionWH.Show()
		StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
		StorageUtil.UnSetIntValue(akSource, "UD_ignoreEvent" + deviceInventory)
		if msgChoice == 0		;help struggle
			_break = struggleMinigameWH(akSource)
		elseif msgChoice == 1	;lockpick
			_break = lockMenuWH(akSource,aControl)
		elseif msgChoice == 2	;help cutting
			_break = cuttingMinigameWH(akSource)
		elseif msgChoice == 3 	;special
			_break = specialMenuWH(akSource,aControl)
		elseif msgChoice == 4	;tighten up
			_break = tightUpDevice(akSource)
		elseif msgChoice == 5	;repair
			_break = repairDevice(akSource)
		elseif msgChoice == 6	;command
			aControl = new Bool[30]
			aControl[15] = True
			DeviceMenu(aControl)
			_break = True
		elseif msgChoice == 7 	;details
			processDetails()		
		else
			_break = True		;exit
		endif
		
		DeviceMenuExtWH(msgChoice)
	endwhile
EndFunction

bool Function lockMenuWH(Actor akSource,bool[] aControl)
	Int msgChoice =  UDCDmain.DefaultLockMenuMessageWH.Show()
	if msgChoice == 0
		return keyMinigameWH(akSource)
	elseif msgChoice == 1
		return lockpickMinigameWH(akSource)
	elseif msgChoice == 2
		return repairLocksMinigameWH(akSource)
	else
		return False
	endif
EndFunction

bool Function specialMenuWH(Actor akSource,bool[] aControl)
	if UD_SpecialMenuInteractionWH
		return proccesSpecialMenuWH(akSource,UD_SpecialMenuInteractionWH.show())
	else
		return False
	endif
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	return false
EndFunction

float Function getWearerAgilitySkills()
	return UDCDMain.getActorAgilitySkills(getWearer())
EndFunction

float Function getWearerAgilitySkillsPerc()
	return UDCDMain.getActorAgilitySkillsPerc(getWearer())
EndFunction

float Function getWearerStrengthSkills()
	return UDCDMain.getActorStrengthSkills(getWearer())
EndFunction

float Function getWearerStrengthSkillsPerc()
	return UDCDMain.getActorStrengthSkillsPerc(getWearer())
EndFunction

float Function getWearerMagickSkills()
	return UDCDMain.getActorMagickSkills(getWearer())
EndFunction

float Function getWearerMagickSkillsPerc()
	return UDCDMain.getActorMagickSkillsPerc(getWearer())
EndFunction

float Function getHelperAgilitySkills()
	if hasHelper()
		return UDCDMain.getActorAgilitySkills(getHelper())
	else
		return 0.0
	endif
EndFunction

float Function getHelperAgilitySkillsPerc()
	if hasHelper()
		return UDCDMain.getActorAgilitySkillsPerc(getHelper())
	else
		return 0.0
	endif
EndFunction

float Function getHelperStrengthSkills()
	if hasHelper()
		return UDCDMain.getActorStrengthSkills(getHelper())
	else
		return 0.0
	endif
EndFunction

float Function getHelperStrengthSkillsPerc()
	if hasHelper()
		return UDCDMain.getActorStrengthSkillsPerc(getHelper())
	else
		return 0.0
	endif
EndFunction

float Function getHelperMagickSkills()
	if hasHelper()
		return UDCDMain.getActorMagickSkills(getHelper())
	else
		return 0.0
	endif
EndFunction

float Function getHelperMagickSkillsPerc()
	if hasHelper()
		return UDCDMain.getActorMagickSkillsPerc(getHelper())
	else
		return 0.0
	endif
EndFunction
;-------------------------------------------------------
; __  __ _____ _   _ _____ _____          __  __ ______ 
;|  \/  |_   _| \ | |_   _/ ____|   /\   |  \/  |  ____|
;| \  / | | | |  \| | | || |  __   /  \  | \  / | |__   
;| |\/| | | | | . ` | | || | |_ | / /\ \ | |\/| |  __|  
;| |  | |_| |_| |\  |_| || |__| |/ ____ \| |  | | |____ 
;|_|  |_|_____|_| \_|_____\_____/_/    \_\_|  |_|______|
;-------------------------------------------------------


bool Function struggleMinigame(int iType = -1)
	if iType == -1
		iType = UDCDmain.StruggleMessage.show()
	endif

	if iType == 4
		return false
	endif
	
	if !minigamePrecheck()
		return false
	endif
	
	resetMinigameValues()

	UD_useWidget = True
	UD_WidgetAutoColor = True
	
	if iType == 0 ;normal
		UD_durability_damage_add = 0.0
		UD_minigame_stamina_drain = UD_base_stat_drain*0.75
		UD_durability_damage_add = 1.25*(_durability_damage_mod*getWearerAgilitySkillsPerc())
		UD_DamageMult *= getModResistPhysical(1.0,0.3)
		_exhaustion_mult = 0.5
		_condition_mult_add = -0.9
		UD_RegenMag_Magicka = 0.4
		UD_RegenMag_Health = 0.4
		_minMinigameStatSP = 0.25
	elseif iType == 1 ;desperate
		UD_minigame_stamina_drain = UD_base_stat_drain*1.1
		UD_minigame_heal_drain = 0.5*UD_base_stat_drain + UDmain.getMaxActorValue(Wearer,"Health",0.06)
		UD_durability_damage_add = 1.0*(_durability_damage_mod*((1.0 - getRelativeDurability()) + getWearerStrengthSkillsPerc()));UDmain.getMaxActorValue(Wearer,"Health",0.02);*getModResistPhysical()
		UD_DamageMult *= getModResistPhysical(1.0,0.1)
		_condition_mult_add = -0.5
		_exhaustion_mult = 1.6
		UD_RegenMag_Magicka = 0.5
		_minMinigameStatSP = 0.2
		_minMinigameStatHP = 0.4
	elseif iType == 2 ;magick
		UD_minigame_stamina_drain = 0.65*UD_base_stat_drain
		UD_minigame_magicka_drain = 0.75*UD_base_stat_drain + UDmain.getMaxActorValue(Wearer,"Magicka",0.05)
		UD_durability_damage_add = 1.0*(_durability_damage_mod*getWearerMagickSkillsPerc())
		UD_DamageMult *= getModResistMagicka(1.0,0.3)
		_condition_mult_add = 1.5
		_exhaustion_mult = 1.2
		UD_RegenMag_Health = 0.8
		_minMinigameStatSP = 0.4
		_minMinigameStatMP = 0.7
	elseif iType == 3 ;slow
		UD_durability_damage_add = 0.0
		UD_applyExhastionEffect = False
		UD_minigame_canCrit = False
		UD_DamageMult *= 0.08*getModResistPhysical()
		_condition_mult_add = -1.0
		UD_RegenMag_Stamina = 0.7
		UD_RegenMag_Health = 0.8
		UD_RegenMag_Magicka = 0.7
	elseif iType == 5 ;useless struggle
		UD_damage_device = False
		UD_drain_stats = False
		UD_applyExhastionEffect = False
		UD_minigame_canCrit = False
		UD_useWidget = False
		UD_RegenMag_Stamina = 0.25
		UD_RegenMag_Health = 0.25
		UD_RegenMag_Magicka = 0.25
	else 
		return false
	endif
	
	;if !isMittens() && wearerFreeHands()
	;	if Wearer.wornhaskeyword(libs.zad_DeviousBondageMittens)
	;		UD_DamageMult *= 0.5
	;	endif
	;endif
	;if isLoose() && !wearerFreeHands()
	;	UD_DamageMult *= getLooseMod()
	;endif
	
	_struggleGame_Subtype = iType
	
	if minigamePostcheck()
		struggleGame_on = True
		minigame()
		struggleGame_on = False
		return true
	else
		return false
	endif
EndFunction

bool Function lockpickMinigame()
	if !minigamePrecheck()
		return false
	endif	
	
	resetMinigameValues()
	
	UD_minigame_stamina_drain = UD_base_stat_drain
	UD_damage_device = False
	UD_minigame_canCrit = False
	UD_minigame_critRegen = false
	if wearer.hasspell(UDlibs.TelekinesisSpell)
		UD_minigame_magicka_drain = UD_base_stat_drain + Wearer.getBaseAV("Magicka")*0.1
	endif
	
	_customMinigameCritChance = getLockAccesChance()
	_customMinigameCritDuration = 0.75 - getLockLevel()*0.025
	
	_minMinigameStatSP = 0.8
	;UDCDmain.setLockPickContainer(UD_LockpickDifficulty,Wearer)
	
	if minigamePostcheck()
		lockpickGame_on = True
		minigame()
		lockpickGame_on = False
		return true
	else
		return false
	endif
EndFunction

bool Function repairLocksMinigame()
	if !minigamePrecheck()
		return false
	endif
	
	resetMinigameValues()
	
	UD_minigame_stamina_drain = UD_base_stat_drain*1.25
	UD_damage_device = False
	UD_minigame_canCrit = False
	;UD_NeedLockReach = True
	UD_useWidget = True
	UD_WidgetColor = 0xffbd00
	UD_WidgetColor2 = -1

	_customMinigameCritChance = 5 + (4 - getLockLevel())*5
	_customMinigameCritDuration = 0.75 - getLockLevel()*0.025
	UD_MinigameMult1 = getAccesibility()
	if wearerFreeHands()
		UD_MinigameMult1 += 0.5
		_customMinigameCritChance += 15
	elseif wearerFreeHands(True)
		UD_MinigameMult1 += 0.15
		_customMinigameCritChance += 5
	endif
	
	if wearer.hasspell(UDlibs.TelekinesisSpell)
		UD_minigame_magicka_drain = UD_base_stat_drain + Wearer.getBaseAV("Magicka")*0.1
		UD_MinigameMult1 += 0.25
	endif
	
	_minMinigameStatSP = 0.8
	
	if minigamePostcheck()
		repairLocksMinigame_on = True
		minigame()
		repairLocksMinigame_on = False
		return true
	else
		return false
	endif
EndFunction

bool Function cuttingMinigame()
	if !minigamePrecheck()
		return false
	endif

	resetMinigameValues()
	
	UD_damage_device = False
	UD_minigame_stamina_drain = UD_base_stat_drain
	UD_minigame_heal_drain = UD_base_stat_drain/2	
	UD_UseWidget = True
	UD_WidgetAutoColor = True
	
	float loc_BaseMult = UDCDmain.getActorCuttingWeaponMultiplier(getWearer())
	
	UD_MinigameMult1 = loc_BaseMult + UDCDmain.getActorCuttingSkillsPerc(getWearer())
	UD_DamageMult = loc_BaseMult + UDCDmain.getActorCuttingSkillsPerc(getWearer())
	
	_minMinigameStatSP = 0.8
	_minMinigameStatHP = 0.5
	
	;if isLoose() && !wearerFreeHands()
		;UD_DamageMult *= getLooseMod()
	;	UD_MinigameMult1 *= getLooseMod()
	;endif
	
	if minigamePostcheck()
		cuttingGame_on = True
		minigame()
		cuttingGame_on = False
		return true
	else
		return false
	endif
EndFunction

bool Function keyMinigame()
	if !minigamePrecheck()
		return false
	endif

	resetMinigameValues()

	UD_damage_device = False
	UD_minigame_stamina_drain = UD_base_stat_drain
	UD_minigame_canCrit = False
	UD_applyExhastionEffect = False
	UD_minigame_critRegen = false
	
	_customMinigameCritChance = getLockAccesChance()
	_customMinigameCritDuration = 0.85 - getLockLevel()*0.05
	_minMinigameStatSP = 0.6
	
	if minigamePostcheck()
		keyGame_on = True
		minigame()
		keyGame_on = False
		return true
	else
		return false
	endif
EndFunction

;With Help minigames
bool Function struggleMinigameWH(Actor akHelper)
	int type = -1
	if type == -1
		type = UDCDmain.StruggleMessageNPC.show()
	endif

	if type == 4
		return false
	endif
	
	setHelper(akHelper)
	
	if !minigamePrecheck()
		return false
	endif
	
	resetMinigameValues()
	UD_useWidget = True
	UD_WidgetAutoColor = True
	
	if type == 0 ;normal
		UD_durability_damage_add = 0.0
		UD_minigame_stamina_drain = UD_base_stat_drain*0.75
		UD_minigame_stamina_drain_helper = UD_base_stat_drain*0.5
		UD_durability_damage_add = 1.0*_durability_damage_mod*(0.25 + 2.5*(getWearerAgilitySkillsPerc() + getHelperAgilitySkillsPerc()))
		UD_DamageMult = getModResistPhysical(1.0,0.35)*getAccesibility()
		
		if HelperFreeHands(True)
			UD_DamageMult += 0.4
		elseif HelperFreeHands()
			UD_DamageMult += 0.15
		endif
		UD_RegenMag_Magicka = 0.25
		UD_RegenMag_Health = 0.25
		UD_RegenMagHelper_Magicka = 0.5
		UD_RegenMagHelper_Health = 0.5
		_condition_mult_add = -0.7
		_minMinigameStatSP = 0.6
	elseif type == 1 ;desperate
		UD_minigame_stamina_drain = UD_base_stat_drain
		UD_minigame_stamina_drain_helper = UD_base_stat_drain*0.95
		UD_minigame_heal_drain = 0.5*UD_base_stat_drain + UDmain.getMaxActorValue(Wearer,"Health",0.05)
		UD_minigame_heal_drain_helper = 0.5*UD_base_stat_drain + UDmain.getMaxActorValue(_minigameHelper,"Health",0.05)
		
		UD_durability_damage_add = 1.0*_durability_damage_mod*((1.0 - getRelativeDurability()) + getWearerStrengthSkillsPerc() + getHelperStrengthSkillsPerc())
		UD_DamageMult = getModResistPhysical(1.0,0.15)*getAccesibility()
				
		if HelperFreeHands(True)
			UD_DamageMult += 0.5
		elseif HelperFreeHands()
			UD_DamageMult += 0.1
		endif
		UD_RegenMag_Magicka = 0.25
		UD_RegenMagHelper_Magicka = 0.5
		_condition_mult_add = -0.25
		_exhaustion_mult = 2.0
		_exhaustion_mult_helper = 1.2
		_minMinigameStatSP = 0.15
		_minMinigameStatHP = 0.3
	elseif type == 2 ;magick
		UD_minigame_stamina_drain = 0.5*UD_base_stat_drain
		UD_minigame_stamina_drain_helper = 0.4*UD_base_stat_drain
		UD_minigame_magicka_drain = 0.7*UD_base_stat_drain + UDmain.getMaxActorValue(Wearer,"Magicka",0.05)
		UD_minigame_magicka_drain_helper = UD_base_stat_drain + UDmain.getMaxActorValue(Wearer,"Magicka",0.05)
		UD_DamageMult = getModResistMagicka(1.0,0.3)*getAccesibility()
		UD_durability_damage_add = 2.0*_durability_damage_mod*(getWearerMagickSkillsPerc() + getHelperMagickSkillsPerc())
		
		if HelperFreeHands(True)
			UD_DamageMult += 0.5
		elseif HelperFreeHands()
			UD_DamageMult += 0.1
		endif
		
		UD_RegenMag_Health = 0.75
		UD_RegenMagHelper_Health = 1.0
		_condition_mult_add = 2.0
		_exhaustion_mult = 1.5
		_exhaustion_mult_helper = 0.75
		_minMinigameStatSP = 0.25
		_minMinigameStatMP = 0.6		
	elseif type == 3 ;slow
		UD_durability_damage_add = 0.0
		UD_applyExhastionEffect = False
		UD_applyExhastionEffectHelper = False
		UD_minigame_canCrit = False
		UD_DamageMult = 0.1*getModResistPhysical()*getAccesibility()
		
		if HelperFreeHands(True)
			UD_DamageMult += 0.05
		elseif HelperFreeHands()
			UD_DamageMult += 0.01
		endif
		
		_condition_mult_add = -1.0
		UD_RegenMag_Stamina = 0.9
		UD_RegenMag_Health = 0.9
		UD_RegenMag_Magicka = 0.9
		
		UD_RegenMagHelper_Stamina = 0.9
		UD_RegenMagHelper_Health = 0.9
		UD_RegenMagHelper_Magicka = 0.9
	else 
		return false
	endif
	
	_struggleGame_Subtype_NPC = type
	
	if minigamePostcheck()
		struggleGame_on = True
		minigame()
		struggleGame_on = False
		setHelper(none)
		return true
	else
		return false
	endif
	
EndFunction

bool Function lockpickMinigameWH(Actor akHelper)
	setHelper(akHelper)
	
	if !minigamePrecheck()
		return false
	endif
	
	resetMinigameValues()
	
	UD_minigame_stamina_drain = UD_base_stat_drain
	UD_minigame_stamina_drain_helper = UD_base_stat_drain*0.8
	UD_damage_device = False
	UD_minigame_canCrit = False
	UD_minigame_critRegen = false
	UD_minigame_critRegen_helper = false
	
	
	if wearer.hasspell(UDlibs.TelekinesisSpell)
		UD_minigame_magicka_drain = UD_base_stat_drain + Wearer.getBaseAV("Magicka")*0.1
	endif
	if _minigameHelper.hasspell(UDlibs.TelekinesisSpell)
		UD_minigame_magicka_drain_helper = UD_base_stat_drain + _minigameHelper.getBaseAV("Magicka")*0.1
	endif	
	
	_customMinigameCritChance = getLockAccesChance()
	if HelperFreeHands(True)
		_customMinigameCritChance = 100
	elseif HelperFreeHands()
		_customMinigameCritChance = getLockAccesChance() + 35
	else
		_customMinigameCritChance = getLockAccesChance() + 10
	endif
	
	_customMinigameCritDuration = 0.9
	_minMinigameStatSP = 0.8
	if minigamePostcheck()
		lockpickGame_on = True
		minigame()
		lockpickGame_on = False
		setHelper(none)
		return true
	else
		return false
	endif
EndFunction

bool Function repairLocksMinigameWH(Actor akHelper)
	setHelper(akHelper)
	
	if !minigamePrecheck()
		return false
	endif
	
	resetMinigameValues()
	
	UD_minigame_stamina_drain = UD_base_stat_drain*1.25
	UD_minigame_stamina_drain_helper = UD_base_stat_drain
	UD_damage_device = False
	UD_minigame_canCrit = False
	
	UD_useWidget = True
	UD_WidgetColor = 0xffbd00
	UD_WidgetColor2 = -1
	_customMinigameCritChance = 10 + (4 - getLockLevel())*5
	
	if wearerFreeHands()
		UD_MinigameMult1 += 0.25
	elseif wearerFreeHands(True)
		UD_MinigameMult1 += 0.1
	endif
	
	if HelperFreeHands()
		UD_MinigameMult1 += 0.5
		_customMinigameCritChance += 15
	elseif HelperFreeHands(True)
		UD_MinigameMult1 += 0.15
		_customMinigameCritChance += 5
	endif
	
	if wearer.hasspell(UDlibs.TelekinesisSpell)
		UD_minigame_magicka_drain = UD_base_stat_drain + Wearer.getBaseAV("Magicka")*0.1
		UD_MinigameMult1 += 0.25
	endif
	
	if _minigameHelper.hasspell(UDlibs.TelekinesisSpell)
		UD_minigame_magicka_drain_helper = UD_base_stat_drain + _minigameHelper.getBaseAV("Magicka")*0.1
		UD_MinigameMult1 += 0.25
	endif
	
	
	_customMinigameCritDuration = 0.75 - getLockLevel()*0.01	
	_minMinigameStatSP = 0.8
	if minigamePostcheck()
		repairLocksMinigame_on = True
		minigame()
		repairLocksMinigame_on = False
		setHelper(none)
		return true
	else
		return false
	endif
EndFunction

bool Function cuttingMinigameWH(Actor akHelper)
	setHelper(akHelper)
	
	if !minigamePrecheck()
		return false
	endif
	
	resetMinigameValues()
	
	UD_damage_device = False
	UD_minigame_stamina_drain = UD_base_stat_drain
	UD_minigame_stamina_drain_helper = UD_base_stat_drain*1.25
	UD_minigame_heal_drain = UD_base_stat_drain*0.75	
	
	float loc_BaseMult = UDCDmain.getActorCuttingWeaponMultiplier(getWearer())
	float loc_BaseMultHelperAdd = UDCDmain.getActorCuttingWeaponMultiplier(getHelper()) - 1.0
	
	UD_DamageMult = loc_BaseMult + loc_BaseMultHelperAdd + UDCDmain.getActorCuttingSkillsPerc(getWearer()) + UDCDmain.getActorCuttingSkillsPerc(getHelper())
	UD_MinigameMult1 = UD_DamageMult;loc_BaseMult + loc_BaseMultHelper + UDCDmain.getActorCuttingSkillsPerc(getWearer()) + UDCDmain.getActorCuttingSkillsPerc(getHelper())
	
	if HelperFreeHands(True)
		UD_MinigameMult1 += 0.8
	elseif HelperFreeHands()
		UD_MinigameMult1 += 0.15
	endif
	
	UD_UseWidget = True
	UD_WidgetAutoColor = True
	
	_minMinigameStatSP = 0.8
	_minMinigameStatHP = 0.5
	if minigamePostcheck()
		cuttingGame_on = True
		minigame()
		cuttingGame_on = False
		setHelper(none)
		return true
	else
		return false
	endif
EndFunction

bool Function keyMinigameWH(Actor akHelper)
	setHelper(akHelper)
	
	if !minigamePrecheck()
		return false
	endif
	
	resetMinigameValues()
	
	UD_damage_device = False
	UD_minigame_stamina_drain = UD_base_stat_drain
	UD_minigame_stamina_drain_helper = UD_base_stat_drain
	UD_minigame_canCrit = False
	UD_applyExhastionEffect = True
	UD_applyExhastionEffectHelper = True
	UD_minigame_critRegen = false
	UD_minigame_critRegen_helper = false
	
	_customMinigameCritChance = getLockAccesChance()
	_customMinigameCritDuration = 0.9 - getLockLevel()*0.03	
	_minMinigameStatSP = 0.6
	
	if minigamePostcheck()
		keyGame_on = True
		minigame()
		keyGame_on = False
		setHelper(none)
		return true
	else
		return false
	endif
EndFunction

Function tightUpDevice(Actor akSource)
	debug.notification(akSource.getActorBase().getName() + " tighted " + getWearerName() + " " + getDeviceName() + " !")
	current_device_health += Utility.randomFloat(5.0,15.0)
	if (current_device_health > device_health)
		current_device_health = device_health
		updateCondition(False)
	endif
EndFunction

Function repairDevice(Actor akSource)
	debug.notification(akSource.getActorBase().getName() + " repaired " + getWearerName() + " " + getDeviceName() + " !")
	current_device_health += Utility.randomFloat(15.0,30.0)
	if (current_device_health > device_health)
		current_device_health = device_health
		
	endif	
	_total_durability_drain = -1
	updateCondition(False)

	UD_CuttingProgress -= 30.0
	if UD_CuttingProgress < 0.0
		UD_CuttingProgress = 0.0
	endif
EndFunction

;reset minigames variables
Function resetMinigameValues()
	_struggleGame_Subtype = -1
	UD_durability_damage_add = 0
	UD_minigame_stamina_drain = 0
	UD_minigame_stamina_drain_helper = 0
	UD_minigame_heal_drain = 0
	UD_minigame_heal_drain_helper = 0
	UD_minigame_magicka_drain = 0
	UD_minigame_magicka_drain_helper = 0
	_condition_mult_add = 0.0
	UD_damage_device = True
	UD_drain_stats = True
	UD_drain_stats_helper = True
	_exhaustion_mult = 1.0
	_exhaustion_mult_helper = 1.0
	UD_applyExhastionEffect = True
	UD_applyExhastionEffectHelper = True
	UD_minigame_canCrit = True
	UD_RegenMag_Stamina = 0.0
	UD_RegenMag_Health = 0.0
	UD_RegenMag_Magicka = 0.0
	UD_RegenMagHelper_Stamina = 0.0
	UD_RegenMagHelper_Health = 0.0
	UD_RegenMagHelper_Magicka = 0.0
	UD_DamageMult = getAccesibility()
	UD_useWidget = False
	UD_WidgetAutoColor = False
	;UD_NeedLockReach = False
	UD_MinigameMult1 = 1.0
	UD_MinigameMult2 = 1.0
	UD_MinigameMult3 = 1.0
	_minMinigameStatSP = 0.0
	_minMinigameStatMP = 0.0
	_minMinigameStatHP = 0.0
	_customMinigameCritChance = 0
	_customMinigameCritDuration = 0.75
	_customMinigameCritMult = 1.0
	UD_minigame_critRegen = true
	UD_minigame_critRegen_helper = true
EndFunction

;set minigame offensive variables
Function setMinigameOffensiveVar(bool dmgDevice,float dpsAdd = 0.0,float condMultAdd = 0.0, bool canCrit = false,float dmg_mult = 1.0)
	UD_durability_damage_add = dpsAdd
	_condition_mult_add = condMultAdd
	UD_minigame_canCrit = canCrit
	UD_damage_device = dmgDevice
	UD_DamageMult = dmg_mult
EndFunction

Function setMinigameDefaultCritVar(bool bDefaultCrit = true,bool bCritReg = true,bool bCritRegHelper = true)
	UD_minigame_canCrit = bDefaultCrit
	UD_minigame_critRegen = bCritReg
	UD_minigame_critRegen_helper = bCritRegHelper
EndFunction

Function setMinigameCustomCrit(int iCrit_c,float fCrit_d = 0.75,float fCrit_m = 1.0)
	UD_minigame_canCrit = False
	_customMinigameCritChance = iCrit_c
	_customMinigameCritDuration = fCrit_d
	_customMinigameCritMult = fCrit_m
EndFunction

;set minigame min stats 0.0-1.0
Function setMinigameMinStats(float fSp,float fHp = 0.0,float fMp = 0.0)
	_minMinigameStatSP = fSp
	_minMinigameStatHP = fHp
	_minMinigameStatMP = fMp
EndFunction

;set minigame lockpick variables
Function setMinigameLockVar(bool needReach,float repairMult = 1.0)
	;UD_NeedLockReach = needReach
	UD_MinigameMult1 = repairMult
EndFunction

;set minigame dmg multiplier
Function setMinigameDmgMult(float val)
	UD_DamageMult = val
EndFunction

;set minigame dmg multiplier
Function setMinigameMult(int iMultIndx,float fMult)
	if iMultIndx == 0 
		UD_DamageMult = fMult
	elseif iMultIndx == 1
		UD_MinigameMult1 = fMult
	elseif iMultIndx == 2
		UD_MinigameMult2 = fMult
	elseif iMultIndx == 3
		UD_MinigameMult3 = fMult
	endif	
EndFunction

;set minigame wearer variables
Function setMinigameWearerVar(bool drainPlayer,float staminaDrain = 10.0,float healthDrain = 0.0,float magickaDrain = 0.0)
	UD_drain_stats = drainPlayer
	UD_minigame_stamina_drain = staminaDrain
	UD_minigame_heal_drain = healthDrain
	UD_minigame_magicka_drain = magickaDrain
EndFunction

Function setMinigameHelperVar(bool drainHelper,float staminaDrain = 10.0,float healthDrain = 0.0,float magickaDrain = 0.0)
	UD_drain_stats_helper = drainHelper
	UD_minigame_stamina_drain_helper = staminaDrain
	UD_minigame_heal_drain_helper = healthDrain
	UD_minigame_magicka_drain_helper = magickaDrain
EndFunction

;set minigame effect variables
Function setMinigameEffectVar(bool alloworgasm = True,bool allowexhastion = True,float exhastion_m = 1.0)
	UD_applyExhastionEffect = allowexhastion
	_exhaustion_mult = exhastion_m
EndFunction

;set minigame effect variables
Function setMinigameEffectHelperVar(bool alloworgasm = True,bool allowexhastion = True,float exhastion_m = 1.0)
	UD_applyExhastionEffectHelper = allowexhastion
	_exhaustion_mult_helper = exhastion_m
EndFunction

;set minigame widget variables
Function setMinigameWidgetVar(bool useWidget = False,bool widgetAutoColor = True,int color = 0x0000FF,int sec_color = -1,int flash_col = -1)
	UD_useWidget = useWidget
	UD_WidgetColor = color
	UD_WidgetColor2 = sec_color
	UD_WidgetFlashColor = flash_col
	UD_WidgetAutoColor = widgetAutoColor
EndFunction

;returns current type of minigame played
; 0 = no minigame is playing
; 1 = struggle
; 2 = cutting
; 3 = lockpick
; 4 = key unlocking
; 5 = lock repair
int Function getMinigameType()
	if !miniGame_on
		return 0
	endif
	if struggleGame_on
		return 1
	elseif cuttingGame_on
		return 2
	elseif lockpickGame_on
		return 3
	elseif keyGame_on
		return 4
	elseif repairLocksMinigame_on
		return 5
	endif
EndFunction

;returns current subtype of struggle minigame played
;-1 = no struggle minigame
; 0 = normal
; 1 = desperate
; 2 = magick
; 3 = slow
; 5 = useless struggle
int Function getStruggleMinigameSubType()
	return _struggleGame_Subtype
EndFunction

;returns current minigame multiplier for iMultIndx
; iMultIndx = 0 -> UD_DamageMult
; iMultIndx = 1 -> UD_MinigameMult1
; iMultIndx = 2 -> UD_MinigameMult2
; iMultIndx = 3 -> UD_MinigameMult3
float Function getMinigameMult(int iMultIndx)
	if iMultIndx == 0 
		return UD_DamageMult
	elseif iMultIndx == 1
		return UD_MinigameMult1
	elseif iMultIndx == 2
		return UD_MinigameMult2
	elseif iMultIndx == 3
		return UD_MinigameMult3
	endif
EndFunction

;stops minigame
Function stopMinigame()
	if UDCDmain.ActorInMinigame(getWearer())
		force_stop_minigame = True
		pauseMinigame = False
	endif
EndFunction

Function ForcePauseMinigame()
	if minigame_on
		pauseMinigame = True
	endif
EndFunction

bool Function isMinigameOn()
	return miniGame_on
EndFunction

bool Function isPaused()
	if pauseMinigame
		return true
	endif
	return false
EndFunction

;stops minigame and waits for it to end, don't call this from inside the minigame loop (like in ticksUpdates)
Function stopMinigameAndWait()
	stopMinigame()
	while UDCDmain.ActorInMinigame(Wearer)
		Utility.waitMenuMode(0.01)
	endwhile
EndFunction

;selects struggle array, taken from zadEquipScript
String[] Function SelectStruggleArray(Actor akActor)
	If akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirt) && !akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)
		if UD_struggleAnimationsHobl && UD_struggleAnimationsHobl.length > 0
			return UD_struggleAnimationsHobl		; Use hobbled struggle idles
		elseif UD_struggleAnimations && UD_struggleAnimations.length > 0
			return UD_struggleAnimations		; Fall back to standard animations if no hobbled variants are available
		else
			return UDCDmain.GetStruggleAnimations(getWearer(),deviceRendered)
		endif
	Else
		if UD_struggleAnimations && UD_struggleAnimations.length > 0
			return UD_struggleAnimations		; Use regular struggle idles
		else
			return UDCDmain.GetStruggleAnimations(getWearer(),deviceRendered)
		endif
	Endif
EndFunction

bool Function minigamePostcheck()
	if !checkMinAV() ;check wearer AVs
		if WearerIsPlayer() ;message related to player wearer
			debug.notification("You are too exhausted. Try later, after you regain your strength.")
		else ;message related to NPC wearer
			debug.notification(getWearerName()+" is too exhausted!")
		endif
		return false
	elseif hasHelper() && !checkMinAVHelper()
		if HelperIsPlayer() ;message related to player helper
			debug.notification("You are too exhausted and can't help "+getWearerName()+".")	
		else ;message related to NPC helper
			debug.notification(getHelperName()+" is too exhausted and unable to help you.")
		endif
		return false
	endif
	
	return true
EndFunction

bool Function minigamePrecheck()
	if UDCDmain.actorInMinigame(getWearer())
		if WearerIsPlayer()
			debug.notification("You are already doing something")
		elseif WearerIsFollower()
			debug.notification(getWearerName() + " is already doing something")
		endif
		return false
	endif

	if hasHelper()
		if UDCDmain.actorInMinigame(getHelper())
			if HelperIsPlayer()
				debug.notification("You are already doing something")
			elseif HelperIsFollower()
				debug.notification(getHelperName() + " is already doing something")
			endif
			return false
		endif
	endif

	if (libs.isAnimating(Wearer))
		if WearerIsPlayer()
			UDCDmain.Print("You are already doing something",1)
		elseif WearerIsFollower()
			UDCDmain.Print(getWearerName() + " is already doing something",1)
		endif
		return false
	endif
	
	if hasHelper()
		if (libs.isAnimating(_minigameHelper))
			UDCDmain.Print(getWearerName() + " is already doing something",1)
			return false
		endif
	endif
	
	if !libs.isValidActor(GetWearer())
		if WearerIsPlayer()
			UDCDmain.Print("You are already doing something",1)
		elseif WearerIsFollower()
			UDCDmain.Print(getWearerName() + " is already doing something",1)
		endif
		return false
	endif
	
	if hasHelper()
		if !libs.isValidActor(GetHelper())
			if HelperIsPlayer()
				UDCDmain.Print("You are already doing something",1)
			elseif HelperIsFollower()
				UDCDmain.Print(getHelperName() + " is already doing something",1)
			endif
			return false
		endif
	endif
	
	if _AVCheckLoop_On || _CritLoop_On
		if WearerIsPlayer() || WearerIsFollower()
			UDCDmain.Print("Slow down!",1)
		endif
		return false
	endif
	
	;UDCDmain.Log("minigamePrecheck time " + (Utility.GetCurrentRealTime() - loc_startTime))
	return true
EndFunction

;!!!--------------------MINIGAME LOOP------------------------!!!
Function minigame()
	if UDmain.DebugMod
		showDebugMinigameInfo()
	endif
	
	if WearerIsPlayer() || HelperIsPlayer()
		UDCDmain.UDmain.closeMenu()
	endif
	
	minigame_on = True
	force_stop_minigame = False
	
	UDCDMain.UDPP.Send_MinigameStarter(getWearer(),self)
	
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("Minigame started for: " + deviceInventory.getName())	
	endif
	
	;apply expression
	;sslBaseExpression loc_expression = UDCDmain.UDEM.getExpression("UDStruggleMinigame_Angry")
	;(libs as zadlibs_UDPatch).ApplyExpressionPatched(getWearer(), loc_expression, 100,false,15)
	
	;struggle animations array
	String[] struggleArray
	if !wearer.wornhaskeyword(libs.zad_deviousHeavyBondage);wearerFreeHands()
		struggleArray = SelectStruggleArray(Wearer)
		_sStruggleAnim = struggleArray[Utility.RandomInt(0,  struggleArray.length - 1)]
	else
		if wearer.wornhaskeyword(UDlibs.InvisibleHBKW)
			struggleArray = UDCDmain.GetHeavyBondageAnimation_Armbinder(!WearerFreeLegs())
		else
			struggleArray = UDCDmain.getHeavyBondageDevice(Wearer).SelectStruggleArray(Wearer)
		endif
		_sStruggleAnim = struggleArray[Utility.RandomInt(0,  struggleArray.length - 1)]
	endif
	
	if hasHelper()
		if !_minigameHelper.wornhaskeyword(libs.zad_deviousHeavyBondage)
			_sStruggleAnimHelper = "ft_struggle_gloves_1"
		else
			String[] struggleArrayHelper
			if _minigameHelper.wornhaskeyword(UDlibs.InvisibleHBKW)
				struggleArrayHelper = UDCDmain.GetHeavyBondageAnimation_Armbinder(!WearerFreeLegs())
			else
				struggleArrayHelper  = UDCDmain.getHeavyBondageDevice(_minigameHelper).SelectStruggleArray(_minigameHelper)
			endif
			_sStruggleAnimHelper = struggleArrayHelper[Utility.RandomInt(0,  struggleArrayHelper.length - 1)]			
		endif
	endif
	
	;starts random struggle animation
	if _sStruggleAnim != "none"
		cameraState = libs.StartThirdPersonAnimation(Wearer, _sStruggleAnim,true)
	endif
	
	if hasHelper()
		if _sStruggleAnimHelper != "none"
			libs.StartThirdPersonAnimation(_minigameHelper, _sStruggleAnimHelper,true)
		endif
	endif
	
	if PlayerInMinigame()
		Game.EnablePlayerControls(abMovement = true)
	endif
	
	Wearer.AddToFaction(UDCDmain.MinigameFaction)
	
	if hasHelper()
		_minigameHelper.AddToFaction(UDCDmain.MinigameFaction)
	endif
			
	UDCDMain.UDPP.Send_Minigameparalel(getWearer(),self)		
	;disable regen of all stats
	;/
	float staminaRate = Wearer.getBaseAV("StaminaRate")
	float HealRate = Wearer.getBaseAV("HealRate")
	float magickaRate = Wearer.getBaseAV("MagickaRate")
	float staminaRateHelper = 0.0
	float HealRateHelper = 0.0
	float magickaRateHelper = 0.0
	
	Wearer.setAV("StaminaRate", staminaRate*UD_RegenMag_Stamina)
	Wearer.setAV("HealRate", HealRate*UD_RegenMag_Health)
	Wearer.setAV("MagickaRate", magickaRate*UD_RegenMag_Magicka)

	if hasHelper()
		staminaRateHelper = _minigameHelper.getBaseAV("StaminaRate")
		HealRateHelper = _minigameHelper.getBaseAV("HealRate")
		magickaRateHelper = _minigameHelper.getBaseAV("MagickaRate")

		_minigameHelper.setAV("StaminaRate", staminaRateHelper*UD_RegenMagHelper_Stamina)
		_minigameHelper.setAV("HealRate", HealRateHelper*UD_RegenMagHelper_Health)
		_minigameHelper.setAV("MagickaRate", magickaRateHelper*UD_RegenMagHelper_Magicka)			
	endif
	/;
	;UDCDmain.FinishRecordTime("AV",true) ;<=============================================================

	;shows bars
	;/
	if canShowHUD()
		showHUDbars()
	endif 
	/;
	
	if UD_useWidget && UDCDmain.UD_UseWidget && PlayerInMinigame()
		showWidget()
	endif

	float durability_onstart = current_device_health
	
	libs.pant(wearer)
	
	;main loop, ends only when character run out off stats or device losts all durability
	int tick_b = 0
	int tick_s = 0
	
	float fCurrentUpdateTime = UDmain.UD_baseUpdateTime
	if !PlayerInMinigame()
		fCurrentUpdateTime = 1.0
	endif

	;drain Wearer and Helper stats
	pauseMinigame = True

	;UDCDmain.FinishRecordTime("Debug",true) ;<=============================================================

	if PlayerInMinigame()
		UDCDmain.MinigameKeysRegister()
	endif
	
	;/
	if UD_minigame_canCrit || _customMinigameCritChance
		UDCDmain.sendMinigameCritUpdateLoop(Wearer)
	endif
	/;
	
	;/
	float loc_currentOrgasmRate = getStruggleOrgasmRate()
	float loc_currentArousalRate= getArousalRate()
	UDCDmain.UpdateOrgasmRate(getWearer(), loc_currentOrgasmRate,0.25)
	UDCDmain.UpdateArousalRate(getWearer(),loc_currentArousalRate)
	/;

	;UDCDmain.FinishRecordTime("Loops+Orgasm",true) ;<=============================================================

	OnMinigameStart()
	
	pauseMinigame = False
	
	while current_device_health > 0.0 && !force_stop_minigame && UDCDmain.actorInMinigame(getWearer())
		;pause minigame, pause minigame need to be changed from other thread or infinite loop happens
		while pauseMinigame
			Utility.wait(0.01)
		endwhile
		
		if !UDCDmain.actorInMinigame(getWearer())
			force_stop_minigame = true
		endif
		
		if !ProccesAV(fCurrentUpdateTime)
			StopMinigame()
		endif
		
		if !force_stop_minigame && hasHelper()
			if !ProccesAVHelper(fCurrentUpdateTime)
				StopMinigame()
			endif
		endif
		
		if !force_stop_minigame
			OnMinigameTick()
		endif
		
		if !force_stop_minigame
			;reduce device durability
			if UD_damage_device
				decreaseDurabilityAndCheckUnlock((_durability_damage_mod + UD_durability_damage_add)*fCurrentUpdateTime*UD_DamageMult,1.0 + _condition_mult_add)
			endif
		endif
		
		;update widget
		if UDCDmain.UD_UseWidget && UD_UseWidget && (WearerIsPlayer() || HelperIsPlayer())
			updateWidget()
		endif
		
		;--one second timer--
		if (tick_b*fCurrentUpdateTime > 1.0) && !force_stop_minigame && current_device_health > 0.0;once per second	
			if canShowHUD()
				showHUDbars(False)
			endif 		
			;update widget color
			if UD_UseWidget && UDCDmain.UD_UseWidget && (WearerIsPlayer() || HelperIsPlayer())
				updateWidgetColor()
			endif
			
			;start new animation if wearer stops animating
			if !libs.isAnimating(Wearer) && !force_stop_minigame && !pauseMinigame 
				_sStruggleAnim = struggleArray[Utility.RandomInt(0,  struggleArray.length - 1)]
				cameraState = libs.StartThirdPersonAnimation(Wearer, _sStruggleAnim)
			endif
			
			;check non struggle minigames
			if !WearerIsPlayer()
				if cuttingGame_on
					cutDevice(fCurrentUpdateTime*UD_CutChance/5.0)
				endif
			endif
			
			tick_b = 0
			tick_s += 1
			if !force_stop_minigame
				OnMinigameTick1()
				if !(tick_s % 3) ;once per 3 second
					advanceSkill(3.0)
					OnMinigameTick3()
				endif
			endif
			
		endif
		
		if !force_stop_minigame && !pauseMinigame
			Utility.wait(fCurrentUpdateTime)
		endif
		tick_b += 1
	endwhile
	
	if PlayerInMinigame()
		UDCDmain.MinigameKeysUnRegister()
	endif	
	
	hideHUDbars() ;hides HUD (not realy?)
	
	if WearerIsPlayer() || HelperIsPlayer()
		hideWidget()
	endif

	;returns wearer regen
	;/
	Wearer.setAV("StaminaRate", staminaRate)
	Wearer.setAV("HealRate", healRate)
	Wearer.setAV("MagickaRate", magickaRate)
	if hasHelper()
		_minigameHelper.setAV("StaminaRate", staminaRateHelper)
		_minigameHelper.setAV("HealRate", HealRateHelper)
		_minigameHelper.setAV("MagickaRate", magickaRateHelper)			
	endif	
	
	UDCDmain.RemoveOrgasmRate(getWearer(), loc_currentOrgasmRate,0.25)		
	UDCDmain.UpdateArousalRate(getWearer(),-1*loc_currentArousalRate)	
	/;
	
	;checks if Wearer succesfully escaped device
	if isUnlocked; && !force_stop_minigame
		if struggleGame_on
			if WearerIsPlayer()
				debug.notification("You have succesfully struggled out of " + deviceInventory.GetName() + "!")
			else
				debug.notification(getWearerName()+" succesfully struggled out of " + deviceInventory.GetName() + "!")
			endif
		endif
		;unlockRestrain()
		;advanceSkill(10.0)
	else
		libs.pant(Wearer)
		if !force_stop_minigame
			if WearerIsPlayer() || HelperIsPlayer()
				if hasHelper()
					debug.notification("Both of you are too exhausted to continue struggling")
				else
					debug.notification("You are too exhausted to continue struggling")
				endif
			elseif WearerIsFollower()
				debug.notification(getWearerName()+" is too exhausted to continue struggling")
			endif
		endif
	endif
	
	MinigameVarReset()

	;adds struggle debuff if player doesn't struggle slowly
	;addStruggleExhaustion()
	
	;debug message
	if UDmain.DebugMod && UD_damage_device && durability_onstart != current_device_health && WearerIsPlayer()
		debug.notification("[Debug] Durability reduced: "+ UDmain.formatString(durability_onstart - current_device_health,3) + "\n")
	endif
	

	libs.EndThirdPersonAnimation(Wearer, cameraState, true) ;ends struggle animation
	
	if hasHelper()
		libs.EndThirdPersonAnimation(_minigameHelper, cameraState, true) ;ends struggle animation
	endif
	
	;(libs as zadlibs_UDPatch).ResetExpressionPatched(getWearer(), loc_expression,15)
	
	UDCDmain.EnableActor(Wearer,true)
	if hasHelper()
		UDCDmain.EnableActor(_minigameHelper,true)
	endif

	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Minigame ended for: "+ deviceInventory.getName(),1)
	endif
	
	OnMinigameEnd()
EndFunction

Function MinigameVarReset()
	minigame_on = False
		
	if Wearer
		if WearerIsPlayer()
			UDCDmain.resetCurrentMinigameDevice()
		endif
		Wearer.RemoveFromFaction(UDCDmain.MinigameFaction)
		StorageUtil.UnSetFormValue(Wearer, "UD_currentMinigameDevice")
	endif
	
	if hasHelper()
		_minigameHelper.RemoveFromFaction(UDCDmain.MinigameFaction)
	endif
EndFunction

Function advanceSkill(float fMult)
	if WearerIsPlayer()
		if struggleGame_on
			if _struggleGame_Subtype == 0
				Game.AdvanceSkill("Pickpocket", 	(0.5*UDCDmain.UD_BaseDeviceSkillIncrease*fMult/8.1)/UDCDmain.getArousalSkillMult(getWearer()));getWearer().GetActorValue("PickpocketMod"))
			elseif _struggleGame_Subtype == 1 
				Game.AdvanceSkill("TwoHanded", 		(1*UDCDmain.UD_BaseDeviceSkillIncrease*fMult/5.35)/UDCDmain.getArousalSkillMult(getWearer()));getWearer().GetActorValue("TwoHandedMod"))
			elseif _struggleGame_Subtype == 2
				Game.AdvanceSkill("Destruction", 	(1*UDCDmain.UD_BaseDeviceSkillIncrease*fMult/1.35)/UDCDmain.getArousalSkillMult(getWearer()));getWearer().GetActorValue("DestructionMod"))
			endif
		endif
	endif
EndFunction

Function drainStats(float fMod)
	if UD_drain_stats
		Wearer.damageAV("Stamina", UD_minigame_stamina_drain*fMod)
		Wearer.damageAV("Health",  UD_minigame_heal_drain*fMod)
		Wearer.damageAV("Magicka",  UD_minigame_magicka_drain*fMod)
	endif
	if hasHelper() && UD_drain_stats_helper
		_minigameHelper.damageAV("Stamina", UD_minigame_stamina_drain_helper*fMod)
		_minigameHelper.damageAV("Health",  UD_minigame_heal_drain_helper*fMod)
		_minigameHelper.damageAV("Magicka",  UD_minigame_magicka_drain_helper*fMod)			
	endif
EndFunction

bool _critLoop_On = false
Function startCritLoop()
	Utility.waitMenuMode(1.0)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("startCritLoop() called for " + getDeviceHeader(),1)
	endif
	_critLoop_On = true
	while minigame_on && !force_stop_minigame;UDCDmain.ActorInMinigame(getWearer());_AVOK && current_device_health > 0.0 && !force_stop_minigame
		while pauseMinigame
			Utility.wait(0.01)
		endwhile
		
		if force_stop_minigame
			_critLoop_On = false
			return
		endif
		
		if UD_minigame_canCrit
			string critType = "random"
			if !WearerIsPlayer() && !HelperIsPlayer()
				critType = "NPC"
			elseif UDCDmain.UD_AutoCrit
				critType = "Auto"
			endif
			UDCDmain.StruggleCritCheck(self,UD_StruggleCritChance,critType,UD_StruggleCritDuration)
		elseif _customMinigameCritChance
			string critType = "random"
			if !WearerIsPlayer() && !HelperIsPlayer()
				critType = "NPC"
			elseif UDCDmain.UD_AutoCrit
				critType = "Auto"
			endif
			UDCDmain.StruggleCritCheck(self,_customMinigameCritChance,critType,_customMinigameCritDuration)			
		endif
		Utility.wait(1.0)
	EndWhile
	_critLoop_On = false
EndFunction

;function called when player fails crit (pressed wrong button)
Function critFailure()
	if (UD_minigame_stamina_drain > 0.0)
		Wearer.damageAV("Stamina", 2*UD_minigame_stamina_drain)
	endif
	if (UD_minigame_stamina_drain_helper > 0.0) && _minigameHelper
		_minigameHelper.damageAV("Stamina", 2*UD_minigame_stamina_drain_helper)
	endif
	if (UD_minigame_heal_drain > 0.0)
		if Wearer.getAV("Health") > (2*UD_minigame_heal_drain + 5.0)
			Wearer.damageAV("Health",  2*UD_minigame_heal_drain)
		else
			Wearer.damageAV("Health", fRange(Wearer.getAV("Health") - 5.0,0.0,1000.0))
		endif
	endif
	if (UD_minigame_heal_drain_helper > 0.0) && _minigameHelper
		if _minigameHelper.getAV("Health") > (2*UD_minigame_heal_drain_helper + 5.0)
			_minigameHelper.damageAV("Health",  2*UD_minigame_heal_drain_helper)
		else
			_minigameHelper.damageAV("Health", _minigameHelper.getAV("Health") - 5.0)
		endif
	endif	
	if (UD_minigame_magicka_drain > 0.0)
		Wearer.damageAV("Magicka", 2*UD_minigame_magicka_drain)
	endif
	if (UD_minigame_magicka_drain_helper > 0.0) && _minigameHelper
		_minigameHelper.damageAV("Magicka", 2*UD_minigame_magicka_drain_helper)
	endif	
	
	if keyGame_on
		if Utility.randomInt() <= zad_KeyBreakChance*UDCDmain.CalculateKeyModifier() && !libs.Config.DisableLockJam
			if WearerIsPlayer()
				debug.messagebox("You managed to insert the key but it snapped. Its remains also jammed the lock! You will have to find other way to escape.")
			endif
			
			Wearer.RemoveItem(zad_deviceKey)
			UD_JammedLocks += 1
			if UD_JammedLocks == UD_CurrentLocks
				jammLocks()
			endif
			stopMinigame()
			keyGame_on = False
			OnLockJammed()	
			return
		endif
	endif

	OnCritFailure()
EndFunction

;function called when player correctly press crit button
Function critDevice()
	if OnCritDevicePre() && !isUnlocked && minigame_on
		libs.Pant(Wearer)
		
		advanceSkill(4.0)
		if UD_damage_device && struggleGame_on
			if getStruggleMinigameSubType() == 2 
				decreaseDurabilityAndCheckUnlock(UD_StruggleCritMul*(_durability_damage_mod + UD_durability_damage_add)*getModResistMagicka(1.0,0.25)*UD_DamageMult)
			else
				decreaseDurabilityAndCheckUnlock(UD_StruggleCritMul*(_durability_damage_mod + UD_durability_damage_add)*getModResistPhysical(1.0,0.25)*UD_DamageMult)
			endif
		elseif lockpickGame_on
			lockpickDevice()
		elseif keyGame_on
			keyUnlockDevice()
		elseif cuttingGame_on
			cutDevice(UD_StruggleCritMul*UD_CutChance/3.0)
		elseif repairLocksMinigame_on
			repairLock(15.0*UD_MinigameMult1)
		endif
		
		if UD_minigame_critRegen
			if (UD_minigame_stamina_drain > 0.0)
				Wearer.restoreAV("Stamina", UD_minigame_stamina_drain*1.25)
			endif
			if (UD_minigame_heal_drain > 0.0)
				Wearer.restoreAV("Health",  UD_minigame_heal_drain*1.25)
			endif
			if (UD_minigame_magicka_drain > 0.0)
				Wearer.restoreAV("Magicka", UD_minigame_magicka_drain*1.25)
			endif
		endif
		if UD_minigame_critRegen_helper && _minigameHelper
			if (UD_minigame_stamina_drain_helper > 0.0)
				_minigameHelper.restoreAV("Stamina", UD_minigame_stamina_drain_helper*1.25)
			endif
			if (UD_minigame_heal_drain_helper > 0.0)
				_minigameHelper.restoreAV("Health",  UD_minigame_heal_drain_helper*1.25)
			endif
			if (UD_minigame_magicka_drain_helper > 0.0)
				_minigameHelper.restoreAV("Magicka", UD_minigame_magicka_drain_helper*1.25)
			endif
		endif
		OnCritDevicePost()
	endif
EndFunction

;function called when player press special button
;bool SpecialButtonMutex = False
Function SpecialButtonPressed()
	onSpecialButtonPressed()
	if cuttingGame_on
		cutDevice(UD_CutChance/12.5)
	;elseif repairLocksMinigame_on
	;	repairLock(Utility.randomFloat(0.2,0.8)*UD_MinigameMult1)
	endif
	if UD_useWidget && UDCDmain.UD_useWidget
		updateWidget()
	endif
EndFunction

;function called when wearer orgasms, 
; sexlab - True if orgasms is created by sexlab, False if created by DD
Function orgasm(bool sexlab = false)
	if OnOrgasmPre(sexlab)
		if miniGame_on
			OnMinigameOrgasm(sexlab)
			OnMinigameOrgasmPost()
		endif
		OnOrgasmPost(sexlab)
	endif
EndFunction

;function called when wearer is edged
Function edge()
	if OnEdgePre()
		if miniGame_on
			OnMinigameEdge()
		endif
		OnEdgePost()
	endif
EndFunction

Function ShockWearer(int iArousalUpdate = 50,float fHealth = 0.0, bool bCanKill = false)
	(libs as zadlibs_UDPatch).ShockActorPatched(getWearer(),iArousalUpdate,fHealth, bCanKill)
EndFunction

Function ShockHelper(int iArousalUpdate = 50,float fHealth = 0.0, bool bCanKill = false)
	if hasHelper()
		(libs as zadlibs_UDPatch).ShockActorPatched(getHelper(),iArousalUpdate,fHealth, bCanKill)
	endif
EndFunction

;unlocks restrain, ALWAYS call this if you want to unlock restrain from this script
Function unlockRestrain(bool forceDestroy = false,bool waitForRemove = True)
	if _isUnlocked
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log("unlockRestrain(): Device " + getDeviceHeader() + "is already unlocked! Aborting ",1)
		endif
		return
	endif
	_isUnlocked = True

	
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("unlockRestrain() called for " + self,1)
	endif
	
	if miniGame_on
		stopMinigame()
	endif
	
	current_device_health = 0.0
	if WearerIsPlayer()
		UDCDmain.updateLastOpenedDeviceOnRemove(self)
	endif
	;StorageUtil.SetIntValue(Wearer, "UD_removed" + deviceInventory,1)
	StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
	if wearer.isinfaction(UDCDmain.minigamefaction)
		wearer.removefromfaction(UDCDmain.minigamefaction)
		StorageUtil.UnSetFormValue(Wearer, "UD_currentMinigameDevice")
	endif
	
	if (deviceInventory.hasKeyword(libs.zad_QuestItem) || deviceRendered.hasKeyword(libs.zad_QuestItem))
		int questKw = UDCdmain.UD_QuestKeywords.getSize()
		while questKw
			questKw -= 1
			if deviceInventory.hasKeyword(UDCdmain.UD_QuestKeywords.getAt(questKw) as Keyword) || deviceRendered.hasKeyword(UDCdmain.UD_QuestKeywords.getAt(questKw) as Keyword)
				libs.RemoveQuestDevice(Wearer, deviceInventory, deviceRendered, UD_DeviceKeyword, UDCdmain.UD_QuestKeywords.getAt(questKw) as Keyword ,zad_DestroyOnRemove || hasModifier("DOR") || forceDestroy)
				return
			endif
		endwhile
	else
		libs.UnlockDevice(Wearer, deviceInventory, deviceRendered, UD_DeviceKeyword, zad_DestroyOnRemove || hasModifier("DOR") || forceDestroy)
	endif
	
	
	if waitForRemove
		float loc_time = 0.0
		while !_isRemoved && loc_time <= 4.0
			Utility.waitMenuMode(0.1)
			loc_time += 0.1
		endwhile
		
		if loc_time >= 4.0
			UDCDmain.Error(getDeviceHeader() + " UnlockRestrain/waitForRemove timeout!!!")
		endif
	endif
	
EndFunction

;biggest pain in the ass. 
Function showHUDbars(bool flashCall = True)
	bool actorOK = (WearerIsPlayer() || HelperIsPlayer()) 
	bool stamina = actorOK && (UD_minigame_stamina_drain == 0.0 && UD_minigame_stamina_drain_helper == 0.0)
	bool health = actorOK && (UD_minigame_heal_drain == 0.0 && UD_minigame_heal_drain_helper == 0.0)
	bool magicka = actorOK && (UD_minigame_magicka_drain == 0.0 && UD_minigame_magicka_drain_helper == 0.0)
	UDCDmain.sendHUDUpdateEvent(flashCall,stamina,health,magicka)
EndFunction

;does shit
Function hideHUDbars()
EndFunction

;checks if Wearer have stats to start struggling
bool Function checkMinAV(;/bool check_stamina = True,bool check_health = False,bool check_magicka = False/;)
	bool stamina = True
	if (UDmain.getCurrentActorValuePerc(Wearer,"Stamina") < _minMinigameStatSP)
		stamina = False
	endif	
	bool health = True
	if (UDmain.getCurrentActorValuePerc(Wearer,"Health") < _minMinigameStatHP)
		health = False
	endif
	bool magicka = True
	if (UDmain.getCurrentActorValuePerc(Wearer,"magicka") < _minMinigameStatMP)
		magicka = False
	endif
	return (stamina && health && magicka)
endFunction

bool Function checkMinAVHelper()
	bool stamina = True
	if (UDmain.getCurrentActorValuePerc(_minigameHelper,"Stamina") < _minMinigameStatSP)
		stamina = False
	endif	
	bool health = True
	if (UDmain.getCurrentActorValuePerc(_minigameHelper,"Health") < _minMinigameStatHP)
		health = False
	endif
	bool magicka = True
	if (UDmain.getCurrentActorValuePerc(_minigameHelper,"magicka") < _minMinigameStatMP)
		magicka = False
	endif
	return (stamina && health && magicka)
EndFunction

bool _AVCheckLoop_On = false
;loop that parallely checks wearer and healper stats and reduce them
Function checkAVLoop(Float fUpdateTime)
	_AVCheckLoop_On = true
	while minigame_on && !force_stop_minigame;UDCDmain.ActorInMinigame(getWearer())
		while pauseMinigame
			Utility.wait(0.01)
		endwhile
		if !ProccesAV(fUpdateTime)
			_AVCheckLoop_On = false
			return
		endif
		if !force_stop_minigame && !pauseMinigame
			Utility.wait(fUpdateTime)
		endif
	endwhile
	_AVCheckLoop_On = false
endFunction

bool Function ProccesAV(float fUpdateTime)
	if UD_drain_stats &&  !pauseMinigame
		if !force_stop_minigame && !pauseMinigame && UD_minigame_stamina_drain > 0.0
			if Wearer.getAV("Stamina") <= 0
				stopMinigame()
				return false
			else
				Wearer.damageAV("Stamina", UD_minigame_stamina_drain*fUpdateTime)
			endif
		endif
		if !force_stop_minigame && !pauseMinigame && UD_minigame_heal_drain > 0.0
			if Wearer.getAV("Health") < UD_minigame_heal_drain*fUpdateTime + 1
				stopMinigame()
				return false
			else
				Wearer.damageAV("Health",  UD_minigame_heal_drain*fUpdateTime)
			endif
		endif
		if !force_stop_minigame && !pauseMinigame && UD_minigame_magicka_drain > 0.0
			if Wearer.getAV("magicka") <= 0
				stopMinigame()
				return false
			else
				Wearer.damageAV("Magicka",  UD_minigame_magicka_drain*fUpdateTime)
			endif
		endif
	endif
	return true
EndFunction

Function checkAVLoopHelper(Float fUpdateTime)
	while current_device_health > 0 && !force_stop_minigame
		while pauseMinigame
			Utility.wait(0.01)
		endwhile
				
		if !ProccesAVHelper(fUpdateTime)
			return
		endif
		
		if !force_stop_minigame && !pauseMinigame && _AVOK
			Utility.wait(fUpdateTime)
		endif
	endwhile
endFunction

bool Function ProccesAVHelper(float fUpdateTime)
	if UD_drain_stats_helper &&  !pauseMinigame && hasHelper()
		if !force_stop_minigame && UD_minigame_stamina_drain_helper > 0.0
			if _minigameHelper.getAV("Stamina") <= 0
				stopMinigame()
				return false
			else
				_minigameHelper.damageAV("Stamina", UD_minigame_stamina_drain_helper*fUpdateTime)
			endif
		endif	

		if !force_stop_minigame && !pauseMinigame && UD_minigame_heal_drain_helper > 0.0
			if _minigameHelper.getAV("Health") < UD_minigame_heal_drain_helper*fUpdateTime + 1
				stopMinigame()
				return false
			else
				_minigameHelper.damageAV("Health", UD_minigame_heal_drain_helper*fUpdateTime)
			endif
		endif	

		if !force_stop_minigame && !pauseMinigame && UD_minigame_magicka_drain_helper > 0.0 
			if _minigameHelper.getAV("magicka") <= 0
				stopMinigame()
				return false
			else
				_minigameHelper.damageAV("Magicka",  UD_minigame_magicka_drain_helper*fUpdateTime)	
			endif
		endif	
	endif
	return true
EndFunction

;returns current arousal rate for currently struggled device
int Function getArousalRate()
	int res = 0
	if (Wearer.wornhaskeyword(libs.zad_DeviousPlugVaginal))
		if (Wearer.wornhaskeyword(libs.zad_kw_InflatablePlugVaginal))
			res  += 1*(1 + libs.zadInflatablePlugStateVaginal.GetValueInt())
		else
			res  += 1
		endif	
	endif
	if (Wearer.wornhaskeyword(libs.zad_DeviousPlugAnal))
		if (Wearer.wornhaskeyword(libs.zad_kw_InflatablePlugAnal))
			res += 1*(1 + libs.zadInflatablePlugStateAnal.GetValueInt())
		else
			res += 1
		endif
	endif
	return res
EndFunction

float Function getStruggleOrgasmRate()
	float res = 0
	if (Wearer.wornhaskeyword(libs.zad_DeviousPlugVaginal))
		res += 1.0
	endif
	if Wearer.wornhaskeyword(libs.zad_DeviousPlugAnal)
		res += 0.5
	endif
	if (Wearer.wornhaskeyword(libs.zad_kw_InflatablePlugVaginal))
		res += 0.75*libs.zadInflatablePlugStateVaginal.GetValueInt()
	endif
	if (Wearer.wornhaskeyword(libs.zad_kw_InflatablePlugAnal))
		res += 0.75*libs.zadInflatablePlugStateAnal.GetValueInt()
	endif
	if (res > 0 && Wearer.wornhaskeyword(libs.zad_DeviousBlindfold))
		res += 0.5
	endif
	return res
EndFunction

;function called when player clicks DETAILS button in device menu
Function processDetails()
	int res = UDCDmain.DetailsMessage.show()	
	if res == 0 
		UDCDmain.ShowMessageBox(getInfoString())
	elseif res == 1
		UDCDmain.ShowMessageBox(getModifiers())
	elseif res == 2
		;debug.messagebox(getWearerDetails())
		UDCDmain.showActorDetails(GetWearer())
	elseif res == 3
		showDebugInfo()
	else
	
	endif
EndFunction

;returns info string of device stats
string Function getInfoString()
	updateDifficulty()
	string temp = ""
	temp += "- " + deviceInventory.GetName() + " -\n"
	temp += "Type: " + UD_DeviceType + "\n"
	temp += ("Device health: " + UDmain.formatString(current_device_health,1)+"/"+ Round(device_health) + "\n")
	temp += "Condition: " + getConditionString() + " ("+UDmain.formatString(getRelativeCondition()*100,1)+"%)\n"
	temp += "Accesibility: " + Round(100.0*getAccesibility()) + "%\n"
	
	temp += "Difficutly: "
	if (UD_durability_damage_base >= 5.0)
		temp += "Very Easy\n"
	elseif (UD_durability_damage_base >= 2.5)
		temp += "Easy\n"
	elseif (UD_durability_damage_base >= 1.25)
		temp += "Normal\n"
	elseif (UD_durability_damage_base >= 0.5)
		temp += "Hard\n"
	elseif (UD_durability_damage_base >= 0.1)
		temp += "Very Hard\n"
	elseif (UD_durability_damage_base > 0.0)
		temp += "Extreme\n"
	else
		temp += "Impossible\n"
	endif
	
	if canBeStruggled()	
		if Details_CanShowResist()
			temp += "Struggle Resist: "
			temp += "P = " + Round(getModResistPhysical(0.0)*-100.0) + "%/"
			temp += "M = " + Round(getModResistMagicka(0.0)*-100.0) + "%\n"
		endif
	endif
	if Details_CanShowHitResist()
		if UD_WeaponHitResist != UD_ResistPhysical || UD_SpellHitResist != UD_ResistMagicka
			temp += "Hit Resist: "
			temp += "P = " + Round(UD_WeaponHitResist*100.0) + "%/"
			temp += "M = " + Round(UD_SpellHitResist*100.0) + "%\n"
		endif
	endif
	if canBeCutted()
		temp += "Cut chance: " + UDmain.formatString(UD_CutChance,1) + " %\n"
	endif
	temp += "Locks: "
	if UD_Locks == 0
		temp += "None\n"
	else
		if areLocksJammed()
			temp += "!Jammed!"
		elseif getLockAccesChance() >= 100 || Wearer.wornhaskeyword(libs.zad_DeviousBondageMittens)
			temp += "Unreachable"
		else
			if getLockAccesChance() > 50
				temp += "Easy to reach"
			elseif getLockAccesChance() > 35
				temp += "Reachable"
			elseif getLockAccesChance() > 15
				temp += "Hard to reach"
			else
				temp += "Very hard to reach"
			endif
		endif
		
		temp += " (" + UD_CurrentLocks + "/" + UD_Locks 
		
		if UD_JammedLocks
			temp += " J=" + UD_JammedLocks + ")\n"
		else
			temp += ")\n"
		endif
		
		temp += "Locks Difficulty: "
		if UD_LockpickDifficulty == 1
			temp += "Novice\n"
		elseif UD_LockpickDifficulty == 25
			temp += "Apprentice\n"
		elseif UD_LockpickDifficulty == 50
			temp += "Adept\n"
		elseif UD_LockpickDifficulty == 75
			temp += "Expert\n"
		elseif UD_LockpickDifficulty == 100
			temp += "Master\n"
		else
			temp += "Requires key\n"
		endif
		
		temp += "Key: "
		if zad_deviceKey
			temp += zad_deviceKey.GetName() + "\n"
		else
			temp += "None\n"
		endif
			
	endif
	
	if isNotShareActive()
		temp += "Active effect: " + UD_ActiveEffectName + "\n"
		temp += "Can be activated: " + canBeActivated() + "\n"
		if UD_Cooldown > 0
			temp += "Cooldown: " + Round(UD_Cooldown*0.75*UDCDmain.UD_CooldownMultiplier) + " - " + Round(UD_Cooldown*1.25*UDCDmain.UD_CooldownMultiplier) +" min\n"
		else
			temp += "Cooldown: NONE\n"
		endif
	endif
	temp += addInfoString()
	
	return temp
EndFunction

bool Function Details_CanShowResist()
	return true
EndFunction 

bool Function Details_CanShowHitResist()
	return true
EndFunction 

;returns modifier string
string Function getModifiers(string str = "")
	str += "-Modifiers-\n"
	if !canBeStruggled() 
		str += "!Impossible to struggle from!\n"
	endif
	
	if (haveRegen())
		str += ("Regeneration ("+ UDmain.formatString(getModifierIntParam("Regen")/24.0,1) +"/h)\n")
	endif
	if hasModifier("_HEAL")
		str += "Healer ("+  UDmain.formatString(getModifierIntParam("_HEAL")/24.0,1) +"/h)\n"
	endif
	if hasModifier("DOR")
		str += "Destroy on unlock\n"
	endif
	
	if hasModifier("MAH")
		str += "Random manifest (" + getModifierIntParam("MAH",0) +" %)\n"
	endif
	
	if hasModifier("MAO")
		str += "Orgasm manifest (" + getModifierIntParam("MAO",0) +" %)\n"
	endif
	
	if UD_OnDestroyItemList
		str += "Contains Items\n"
	endif	
	if hasModifier("LootGold")
		if getModifierParamNum("LootGold") > 1
			str += "Contains Gold ("+ getModifierIntParam("LootGold",0) +"-"+ getModifierIntParam("LootGold",1) +" G)\n"
		else
			str += "Contains Gold ("+ getModifierIntParam("LootGold") +" G)\n"
		endif
	endif	

	if (isSentient())
		str += "Sentient (" + UDmain.formatString(getModifierFloatParam("Sentient"),1) +" %)\n"
	Endif
	
	if (isLoose())
		str += "Loose (" + UDmain.formatString(getModifierFloatParam("Loose")*100,1) +" %)\n"
	Endif
	
	if deviceRendered.hasKeyword(UDlibs.PatchedDevice)
		str += "Patched device\n"
	endif	
	return str
EndFunction

Function showDebugMinigameInfo()
	string res = ""
	res += "Wearer: " + getWearerName() + "\n"
	if hasHelper()
		res += "Helper: " + getHelperName() + "\n"
	endif
	
	if struggleGame_on
		res += "Struggle type: " + _struggleGame_Subtype + "\n"
	endif
	res += "Damage modifier: " + Round(UD_DamageMult*100.0) + " %\n"
	if UD_damage_device
		res += "Base DPS: " + UDmain.formatString(UD_durability_damage_base,4) + " DPS\n"
		res += "DPS bonus: " + UDmain.formatString(UD_durability_damage_add,2) + " DPS\n"
		res += "Total DPS: " + (_durability_damage_mod + UD_durability_damage_add)*UD_DamageMult + " DPS\n"
		res += "Total increase: " + UDmain.formatString((((_durability_damage_mod + UD_durability_damage_add)*UD_DamageMult)/UD_durability_damage_base)*100 - 100.0,2) + " %\n"
	elseif cuttingGame_on
		res += "Cutting modifier: " + Round(UD_MinigameMult1*100.0) + " %\n"
	else
		res += "No DPS\n"
	endif
	res += "Condition dmg increase: " + Round(_condition_mult_add*100) + " %\n"
	res += "Crits: " + UD_minigame_canCrit + "\n"
	if UD_drain_stats
		if UD_minigame_stamina_drain
			res += "Stamina SPS: " + UDmain.formatString(UD_minigame_stamina_drain,2) + "\n"
		endif
		if UD_minigame_heal_drain
			res += "Health SPS: " + UDmain.formatString(UD_minigame_heal_drain,2) + "\n"
		endif
		if UD_minigame_magicka_drain
			res += "Magicka SPS: " + UDmain.formatString(UD_minigame_magicka_drain,2) + "\n"	
		endif
	else
		res += "Wearer doesn't loose stats\n"
	endif
	res += "Required stats: S = " + Round(_minMinigameStatSP*100) + " %;H = " + Round(_minMinigameStatHP*100) + " %;M = " + Round(_minMinigameStatMP*100) + " %\n"
	
	if UD_RegenMag_Stamina || UD_RegenMag_Health || UD_RegenMag_Magicka
		res += "Wearer regen: S = " + Round(UD_RegenMag_Stamina*100) + " %;H = " + Round(UD_RegenMag_Health*100) + " %;M = " + Round(UD_RegenMag_Magicka*100) + " %\n"
	endif
	
	if UD_RegenMagHelper_Stamina || UD_RegenMagHelper_Health || UD_RegenMagHelper_Magicka
		res += "Wearer regen: S = " + Round(UD_RegenMagHelper_Stamina*100) + " %;H = " + Round(UD_RegenMagHelper_Health*100) + " %;M = " + Round(UD_RegenMagHelper_Magicka*100) + " %\n"
	endif
	if UD_applyExhastionEffect
		res += "Exhastion mult: " + Round(_exhaustion_mult*100) + " %\n"
	else
		res += "No exhastion\n"
	endif
	UDCDmain.ShowMessageBox(res)
EndFunction

Function showRawModifiers()
	int i = 0
	string res = "-RAW MODIFIERS-\n"
	while i < UD_Modifiers.length
		res += UD_Modifiers[i] + "\n"
		i += 1
	endwhile
	UDCDmain.ShowMessageBox(res)
EndFunction

Function showDebugInfo()
	UDCDmain.ShowMessageBox(getDebugString())
	showRawModifiers()
EndFunction

;returns debug string
string Function getDebugString()
	updateDifficulty()
	string res = ""
	res += "- " + deviceInventory.GetName() + " -\n"
	if UD_Locks 
		res += "Lock acces: "+ (Round(UD_LockAccessDifficulty)) + "/" + (100 - Round(getLockAccesChance())) + " %\n"
	endif
	if (zad_JammLockChance > 0)
		res += "Lock jamm chance: "+ zad_JammLockChance + " (" + Round(UDmain.checkLimit(zad_JammLockChance*UDCDmain.CalculateKeyModifier(),100.0)) +") %\n"
	endif
	if isNotShareActive(); && canBeActivated()
		res += "Cooldown: "+ _currentRndCooldown +" min\n"
		res += "Elapsed time: "+ UDmain.formatString(_updateTimePassed,3) +" min ("+ UDmain.formatString(getRelativeElapsedCooldownTime()*100,1) +" %)\n"
		res += "Can be activated: " + canBeActivated() + "\n"
	endif
	res += getCritInfo()
	return res
EndFunction

string Function getMendingInfo()
	if (hasModifier("Regen"))
		int regen = getModifierIntParam("Regen")
		float mult = UDCDmain.getMendDifficultyModifier()
		string res
			res += "Mend rate: "+ regen +" ("+UDmain.formatString(regen/24.0,1)+" per hour)\n"
		return res
	endif
	return ""
EndFunction

string Function getCritInfo()
	string res = ""
	res += "Crit chance: "
	if (UD_StruggleCritChance > 0)
		res += UD_StruggleCritChance + " %\n"
	else
		res += "never\n"
		return res
	endif
	res += "Crit: " + UDmain.formatString(UD_StruggleCritMul,1) + " x\n"
	res += "Crit difficulty: "
	if UD_StruggleCritDuration >= 1
		res += "Easy\n"
	elseif UD_StruggleCritDuration >= 0.5
		res += "Normal\n"
	else
		res += "Hard\n"
	endif
	return res
endFunction

;adds struggle debuff to Wearer
Function addStruggleExhaustion()
	UDlibs.StruggleExhaustionSpell.SetNthEffectMagnitude(0, UDCDmain.UD_StruggleExhaustionMagnitude*Utility.randomFloat(0.75,1.25))
	UDlibs.StruggleExhaustionSpell.SetNthEffectDuration(0, Round(UDCDmain.UD_StruggleExhaustionDuration*_exhaustion_mult*Utility.randomFloat(0.75,1.25)))
	if Wearer && UD_applyExhastionEffect
		UDlibs.StruggleExhaustionSpell.cast(Wearer)
	endif
	if _minigameHelper && UD_applyExhastionEffectHelper
		UDlibs.StruggleExhaustionSpell.SetNthEffectDuration(0, Round(UDCDmain.UD_StruggleExhaustionDuration*_exhaustion_mult_helper*Utility.randomFloat(0.75,1.25)))
		UDlibs.StruggleExhaustionSpell.cast(_minigameHelper)
	endif
EndFunction

;cut device by progress_add
Function cutDevice(float progress_add = 1.0)
	UD_CuttingProgress += progress_add*UDCDmain.getStruggleDifficultyModifier()*UD_MinigameMult1
	if UD_CuttingProgress >= 100.0
		if cuttingGame_on
			if WearerIsPlayer()
				debug.notification("You managed to cut "+ getDeviceName() +" and reduce durability by big amount!")
			elseif WearerIsFollower()
				debug.notification(getWearerName() + " managed to cut "+getDeviceName()+" and reduce durability by big amount!")
			endif
		else
			if WearerIsPlayer()
				debug.notification("Your "+getDeviceName()+" is cutted!")
			elseif WearerIsFollower()
				debug.notification(getWearerName() + "s "+ getDeviceName() +" is cutted!")
			endif
		endif
		float cond_dmg = 50.0*UDCDmain.getStruggleDifficultyModifier()*(1.0 + _condition_mult_add)
		_total_durability_drain += cond_dmg
		updateCondition()
		decreaseDurabilityAndCheckUnlock(UD_DamageMult*cond_dmg*getModResistPhysical(1.0,0.25)/7.0,0.0)
		UD_CuttingProgress = 0.0
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log(getDeviceHeader() + " is cutted for " + cond_dmg + "C ( " + (UD_DamageMult*cond_dmg*getModResistPhysical(1.0,0.25)/7.0) + " D) (Wearer: " + getWearerName() + ")",1)
		endif
		OnDeviceCutted()
	endif
EndFunction

;repair lock by progress_add
Function repairLock(float progress_add = 1.0)
	UD_RepairProgress += progress_add*UDCDmain.getStruggleDifficultyModifier()
	if UD_RepairProgress >= getLockDurability()
		if WearerIsPlayer()
			debug.notification("You managed to repair one of the locks!")
		endif
		if UD_JammedLocks == UD_CurrentLocks
			libs.UnJamLock(Wearer,UD_DeviceKeyword)
		endif
		UD_JammedLocks -= 1
		updateCondition()
		updateDifficulty()
		UD_RepairProgress = 0.0
		stopMinigame()
		repairLocksMinigame_on = False
	endif
EndFunction

;starts vannila lockpick minigame if lock is reached
Function lockpickDevice()
	if lockpickGame_on && (UD_CurrentLocks - UD_JammedLocks > 0)
		int result = 0
		if WearerIsPlayer() || HelperIsPlayer()
			int helperGivedLockpicks = 0
			if hasHelper()
				;always transfere lockpicks to player
				if WearerIsPlayer()
					helperGivedLockpicks = getHelper().getItemCount(UDCDmain.Lockpick)
					getHelper().removeItem(UDCDmain.Lockpick,helperGivedLockpicks,True,getWearer())
				else
					helperGivedLockpicks = getWearer().getItemCount(UDCDmain.Lockpick)
					getWearer().removeItem(UDCDmain.Lockpick,helperGivedLockpicks,True,getHelper())
				endif
			endif
			UDCDmain.ReadyLockPickContainer(UD_LockpickDifficulty,Wearer)
			UDCDmain.startLockpickMinigame()
			
			float loc_elapsedTime = 0.0
			while (!UDCDmain.LockpickMinigameOver) && loc_elapsedTime < 25.0
				Utility.WaitMenuMode(0.1)
				loc_elapsedTime += 0.1
			endwhile
		
			result = UDCDmain.lockpickMinigameResult 	;first we fetch lockpicking result
			UDCDmain.DeleteLockPickContainer()			;then we remove the container so IsLocked is not called on None
			
			if loc_elapsedTime >= 25.0
				UDCDmain.Print("You lost the focus and broke the lockpick!")
				result = 2
				getWearer().removeItem(UDCDmain.Lockpick,1)
				if UI.isMenuOpen("Lockpicking Menu")
					UDCDmain.UDmain.closeLockpickMenu()
				endif
			endif
			
			if hasHelper()
				if WearerIsPlayer()
					int lockpicks = getWearer().getItemCount(UDCDmain.Lockpick)
					if lockpicks >= helperGivedLockpicks
						getWearer().removeItem(UDCDmain.Lockpick,helperGivedLockpicks,True,getHelper())
					else
						getWearer().removeItem(UDCDmain.Lockpick,lockpicks,True,getHelper())
					endif
				else
					int lockpicks = getHelper().getItemCount(UDCDmain.Lockpick)
					if lockpicks >= helperGivedLockpicks
						getHelper().removeItem(UDCDmain.Lockpick,helperGivedLockpicks,True,getWearer())
					else
						getHelper().removeItem(UDCDmain.Lockpick,lockpicks,True,getWearer())
					endif
				endif
			endif
		else
			if Utility.randomInt(1,100) >= getLockLevel()*25
				result = 1
			else
				result = 2
				Wearer.RemoveItem(UDCDmain.Lockpick, 1, True)
			endif
		endif
		if UDCDmain.TraceAllowed()
			UDCDmain.UDmain.Log("Lockpick minigame result for " + getWearerName() + ": " + result,2)
		endif
		if result == 0
				stopMinigame()
				lockpickGame_on = False
		elseif result == 1 ;succes
			if UD_CurrentLocks - UD_JammedLocks > 0
				UD_CurrentLocks -= 1
				if WearerIsPlayer()
					debug.notification("You succesfully unlocked one of the locks!")
				elseif WearerIsFollower()
					debug.notification(getWearerName() + " unlocked one of the locks!")
				endif
				onLockUnlocked(True)
			endif
			if UD_CurrentLocks == 0 && UD_JammedLocks == 0 ;device gets unlocked
				;current_device_health = 0
				unlockRestrain()
				stopMinigame()
				lockpickGame_on = False
				OnDeviceLockpicked()
			elseif UD_CurrentLocks == UD_JammedLocks ;device have no more free locks
				stopMinigame()
				lockpickGame_on = False	
				jammLocks()					
			endif
		elseif result == 2 ;failure
			if Utility.randomInt() <= zad_JammLockChance*UDCDmain.CalculateKeyModifier() && !libs.Config.DisableLockJam
				if WearerIsPlayer()
					debug.notification("Your lockpick jammed the lock!")
				elseif WearerIsFollower()
					debug.notification(getWearerName() + "s lock gets jammed!")
				endif
				
				UD_JammedLocks += 1
				if UD_JammedLocks == UD_CurrentLocks
					jammLocks()
				endif
				stopMinigame()
				lockpickGame_on = False
				OnLockJammed()
			else
				int loc_lockpicks = getWearer().GetItemCount(libs.Lockpick)
				if hasHelper()
					loc_lockpicks += getHelper().GetItemCount(libs.Lockpick)
				endif
				if loc_lockpicks == 0
					stopMinigame()
					lockpickGame_on = False
				endif
			endif
		endif
	endif
EndFunction

;unlock one of the locks if lock is reached
Function keyUnlockDevice()
	if UD_CurrentLocks > 0 
		if WearerIsPlayer()
			debug.notification("You managed to unlock one of the locks!")
		elseif WearerIsFollower()
			debug.notification(getWearerName() + " managed to unlock one of the locks!")
		endif
		
		UD_CurrentLocks -= 1
		if zad_DestroyKey; || libs.Config.GlobalDestroyKey
			if !Wearer.getItemCount(zad_deviceKey)
				_minigameHelper.RemoveItem(zad_deviceKey)
			else
				Wearer.RemoveItem(zad_deviceKey)
			endif
		endif
		stopMinigame()
		keyGame_on = False
		onLockUnlocked(false)
	endif
	
	if UD_CurrentLocks == 0 && UD_JammedLocks == 0
		unlockRestrain()
		stopMinigame()
		keyGame_on = False
		OnDeviceUnlockedWithKey()
	endif
EndFunction

Function jammLocks()
	libs.SendDeviceJamLockEventVerbose(deviceInventory, UD_DeviceKeyword, wearer)
	StorageUtil.SetIntValue(wearer, "zad_Equipped" + libs.LookupDeviceType(UD_DeviceKeyword) + "_LockJammedStatus", 1)
EndFunction

bool Function areLocksJammed()
	return StorageUtil.GetIntValue(Wearer, "zad_Equipped" + libs.LookupDeviceType(UD_DeviceKeyword) + "_LockJammedStatus")
EndFunction

;starts sentient dialogue
Function startSentientDialogue(int type = 1)
	UDCDmain.sendSentientDialogueEvent(UD_DeviceType,type)
EndFunction

;check sentient event and activets it
function checkSentient(float mult = 1.0)
	if isSentient()
		if Utility.randomInt() > 75 && WearerIsPlayer()
			startSentientDialogue(1)
		endif
		if Round(getModifierFloatParam("Sentient")*mult) > Utility.randomInt(1,100)
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log("Sentient device activation of : " + getDeviceHeader())
			endif
			UDCDmain.activateDevice(self)
		endif
	endif
EndFunction

;function called when wearer is hit by source weapon
Function weaponHit(Weapon source)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Device " + DeviceInventory.getName() + " hit by "+source+" event received",3)
	endif
	if onWeaponHitPre(source)
		onWeaponHitPost(source)
	endif
EndFunction

;function called when wearer is hit by source spell
Function spellHit(Spell source)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Device " + DeviceInventory.getName() + " hit by "+source+" event received",3)
	endif
	if onSpellHitPre(source)
		onSpellHitPost(source)
	endif
EndFunction

bool Function CooldownActivate()
	if OnCooldownActivatePre()
		if UDCDmain.TraceAllowed()		
			UDCDmain.Log(getDeviceHeader() + " cooldown activate",1)
		endif
		;resetCooldown()
		OnCooldownActivatePost()
		resetCooldown()
		return true
	else
		return false
	endif
EndFunction

;--------------------------------------------------   
;  ______      ________ _____  _____ _____  ______ 
; / __ \ \    / /  ____|  __ \|_   _|  __ \|  ____|
;| |  | \ \  / /| |__  | |__) | | | | |  | | |__   
;| |  | |\ \/ / |  __| |  _  /  | | | |  | |  __|  
;| |__| | \  /  | |____| | \ \ _| |_| |__| | |____ 
; \____/   \/   |______|_|  \_\_____|_____/|______|
;--------------------------------------------------                                                  
                                                   
Function activateDevice()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Device " + DeviceInventory.getName() + " (W: " + getWearerName() + ") activated",1)
	endif
	resetCooldown()
EndFunction

bool Function isNotShareActive()
	return UD_ActiveEffectName != "Share" && UD_ActiveEffectName != "none" && UD_ActiveEffectName != ""
EndFunction

bool Function canBeActivated()
	return true
EndFunction

bool Function OnMendPre(float mult)
	return True
EndFunction

Function OnMendPost(float mult)

EndFunction

bool Function OnCritDevicePre()
	return True
EndFunction

Function OnCritDevicePost()
EndFunction

bool Function OnOrgasmPre(bool sexlab = false)
	return True
EndFunction

Function OnMinigameOrgasm(bool sexlab = false)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Orgasm in struggle loop detected",3)
	endif
EndFunction

Function OnMinigameOrgasmPost()
EndFunction

Function OnOrgasmPost(bool sexlab = false)
	if libs.isValidActor(GetWearer())
		if libs.isValidActor(GetWearer()) && hasModifier("MAO")
			int loc_chance = UDCDmain.Round(getModifierIntParam("MAO",0)*(UDCDmain.UDPatcher.UD_MAOMod/100.0))
			int loc_number = getModifierIntParam("MAO",1)
			Form[] loc_array
			if Utility.randomInt() < loc_chance
				while loc_number
					while UDCDmain.InSelabAnimation(getWearer()) || UDCDmain.InZadAnimation(getWearer())
						Utility.wait(1.0)
					endwhile
					loc_number -= 1
					Armor loc_device = UDmain.UDRRM.LockRandomRestrain(getWearer())
					if loc_device
						loc_array = PapyrusUtil.PushForm(loc_array,loc_device)
					else
						loc_number = 0 ;end, because no more devices can be locked
					endif
				endwhile
			endif
			if loc_array
				if loc_array.length > 0
					if WearerIsPlayer()
						string loc_str = getDeviceName() + " suddenly starts to emit black smoke, which envelop your body and forms its shape in to bondage restraint!\n"
						loc_str += "Devices locked: \n"
						
						int i = 0
						while i < loc_array.length
							loc_str += (loc_array[i] as Armor).getName() + "\n"
							i+= 1
						endwhile
						
						UDCDmain.ShowMessageBox(loc_str)
					elseif WearerIsFollower()
						UDCDmain.Print(getWearerName() + "s "+ getDeviceName() +" suddenly locks them in bondage restraint!",1)
					endif
				endif
			endif
		endif	
	endif
EndFunction

bool Function OnEdgePre()
	return True
EndFunction

Function OnMinigameEdge()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Edge in struggle loop detected",2)
	endif
	
	;libs.SexlabMoan(wearer,100)
	pauseMinigame = True
	;UDCDmain.setScriptState(Wearer,3)
	
	if hasHelper()
		;UDCDmain.resetScriptState(_minigameHelper)
		if HelperIsPlayer()
			UDCDmain.setCurrentMinigameDevice(none)
		endif
	endif
	
	;UDCDmain.resetScriptState(Wearer)
	OnMinigameEdgePost()
	stopMinigame()
EndFunction

Function OnMinigameEdgePost()
EndFunction

Function OnEdgePost()
EndFunction

Function OnMinigameStart()
	;starts vibrations if device have UD_Sentient keyword
	checkSentient(1.0)
EndFunction

Function OnMinigameEnd()
	if isSentient() && getRelativeDurability() > 0.0
		if Utility.randomInt() > 75 && WearerIsPlayer()
			startSentientDialogue(0)
		endif
	endif
EndFunction

;make it lightweight
Function OnMinigameTick()

EndFunction

Function OnMinigameTick1()
	if getStruggleMinigameSubType() == 1
		UD_DamageMult = getAccesibility()*getModResistPhysical(1.0,0.1) + (1.0 - getRelativeDurability())
		;if isLoose() && !wearerFreeHands()
		;	UD_DamageMult *= getLooseMod()
		;endif
	endif
EndFunction

Function OnMinigameTick3()
EndFunction

Function OnCritFailure()
	checkSentient(0.25)
EndFunction

float Function getAccesibility()
	if !isHeavyBondage() && !WearerFreeHands()
		if isLoose()
			return getLooseMod()
		else
			return 0.0
		endif
	endif
	
	if WearerHaveMittens() && !isMittens() && !isHeavyBondage()
		return 0.5
	endif
	return 1.0
EndFunction

Function OnDeviceCutted()
EndFunction

Function OnDeviceLockpicked()
EndFunction

Function OnLockReached()
EndFunction

Function OnLockJammed()
EndFunction

Function OnDeviceUnlockedWithKey()
EndFunction

Function OnUpdatePre(float timePassed)
EndFunction

Function OnUpdatePost(float timePassed)
EndFunction

bool Function OnCooldownActivatePre()
	return isNotShareActive() && canBeActivated()
EndFunction

Function OnCooldownActivatePost()
	UDCDmain.activateDevice(self)
EndFunction

Function DeviceMenuExt(int msgChoice)
EndFunction

Function DeviceMenuExtWH(int msgChoice)
EndFunction

;return value defines if UpdateHour should be used
bool Function OnUpdateHourPre()
	return true
EndFunction

;return value defines if other modfiers should be checked after this function is called
bool Function OnUpdateHourPost()
	return true
EndFunction

Function onDeviceMenuInitPost(bool[] aControl)
	
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControl)

EndFunction

Function InitPost()
EndFunction

;this function shoul be called last, don't call this for parents
;use this only in case of using some kind of long function (line vibrate() function or something similiar, which could delate the initiation of device)
Function InitPostPost()
EndFunction

Function OnRemovePre()
EndFunction

Function onRemoveDevicePost(Actor akActor)
EndFunction

Function onLockUnlocked(bool lockpick = false)
EndFunction

Function onSpecialButtonPressed()
EndFunction

bool Function onWeaponHitPre(Weapon source)
	return true;UDCDmain.isSharp(source)
EndFunction

Function onWeaponHitPost(Weapon source)
	if !isUnlocked && isEscapable()
		decreaseDurabilityAndCheckUnlock(source.getBaseDamage()*0.08*(1.0 - UD_WeaponHitResist),2.0)
	endif
EndFunction

bool Function onSpellHitPre(Spell source)
	return True
EndFunction

Function onSpellHitPost(Spell source)
	if !isUnlocked; && getModResistMagicka(1.0,0.25) != 1.0
		;/
		;decreaseDurabilityAndCheckUnlock(source.getBaseDamage()*0.1*getModResistMagicka(1.0,0.25),1.0)
		
		int loc_mageffects = source.GetNumEffects()
		while loc_mageffects
			loc_mageffects -= 1
			;debug.notification("Magick hit for "+ loc_mageffect.GetAssociatedSkill() +"!")
			MagicEffect loc_mageffect = source.GetNthEffectMagicEffect(loc_mageffects)
			if loc_mageffect.GetAssociatedSkill() == "Destruction"
				float loc_mag = source.GetNthEffectMagnitude(loc_mageffects)
				debug.notification("Magick hit for "+ loc_mag +"!")
				decreaseDurabilityAndCheckUnlock(loc_mag*0.25*(1.0 - UD_SpellHitResist),2.0)
			endif
		endwhile
		/;
	endif
EndFunction

;adds bonus string to base detail string
string Function addInfoString(string str = "")
	return str
EndFunction

;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------

;UTILITY functions NEEDED because the functions are used before UDmain are loaded
;mainly used in initiation of properties, which load before UDCDmain (if its not filled)

int Function codeBit(int iCodedMap,int iValue,int iSize,int iIndex)
	if iIndex + iSize > 32
		return 0xFFFFFFFF ;returns error value
	endif
	int loc_clear_mask = 0x00000001 ;mask used to clear bits which will be set
	
	;sets not shifted bit mask loc_clear_mask
	int loc_help_bit = 0x02
	while iSize > 1
		iSize -= 1
		loc_clear_mask = Math.LogicalOr(loc_clear_mask,loc_help_bit)
		loc_help_bit = Math.LeftShift(loc_help_bit,1)
	endwhile
	iValue = Math.LogicalAnd(loc_clear_mask,iValue)
	loc_clear_mask = Math.LogicalXor(Math.LeftShift(loc_clear_mask,iIndex),0xFFFFFFFF) ;shift and negate
	int loc_clear_map = Math.LogicalAnd(iCodedMap,loc_clear_mask) ;clear maps bits with mask
	return Math.LogicalOr(loc_clear_map,Math.LeftShift(iValue,iIndex)) ;sets bits
endfunction
int Function decodeBit(int iCodedMap,int iSize,int iIndex)
	if iIndex + iSize > 32
		return 0xFFFFFFFF ;returns error value
	endif
	
	;sets not shifted bit mask
	int loc_clear_mask = 0x00000001 ;mask used to clear all not wanted bits
	
	;sets not shifted bit mask loc_clear_mask
	int loc_help_bit = 0x02
	while iSize > 1
		iSize -= 1
		loc_clear_mask = Math.LogicalOr(loc_clear_mask,loc_help_bit)
		loc_help_bit = Math.LeftShift(loc_help_bit,1)
	endwhile	
	
	loc_clear_mask = Math.LeftShift(loc_clear_mask,iIndex) ;shift to index position
	
	int loc_res = 0x00000000 ;return value, default is int
	loc_res = Math.LogicalAnd(iCodedMap,loc_clear_mask) ;clear maps bits with mask
	loc_res = Math.RightShift(loc_res,iIndex) ;shift to right, so value is correct
	return loc_res
EndFunction
int Function Round(float value)
	return Math.floor(value + 0.5)
EndFunction

bool _bitmap_mutex = false ;DON'T MODIFY
Function startBitMapMutexCheck()
	while _bitmap_mutex
		Utility.waitmenumode(0.01)
	endwhile
	_bitmap_mutex = true
EndFunction
Function endBitMapMutexCheck()
	_bitmap_mutex = false
EndFunction
float Function fRange(float fValue,float fMin,float fMax)
	if fValue > fMax
		return fMax
	endif
	if fValue < fMin
		return fMin
	endif
	return fValue
EndFunction
int Function iRange(int iValue,int iMin,int iMax)
	if iValue > iMax
		return iMax
	endif
	if iValue < iMin
		return iMin
	endif
	return iValue
EndFunction