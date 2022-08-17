Scriptname UD_CustomDevice_RenderScript extends ObjectReference  
import UnforgivingDevicesMain
;bit maps used to code simple values to reduce memory size of script
;-----_deviceControlBitMap_1-----
;00 = 1b, struggleGame_on
;01 = 1b, lockpickGame_on
;02 = 1b, cuttingGame_on
;03 = 1b, keyGame_on
;04 = 1b, repairLocksMinigame_on
;TODO
int _deviceControlBitMap_1 = 0x00000000 ;BOOL -FULL (mutex2)
int _deviceControlBitMap_2 = 0x00000000 ;FLOAT-FULL (mutex1)
int _deviceControlBitMap_3 = 0x00000000 ;FLOAT-FULL (mutex1)
int _deviceControlBitMap_4 = 0x00000000 ;FLOAT-FULL (mutex1)
int _deviceControlBitMap_5 = 0x00000000 ;INT (mutex1)

;-----_deviceControlBitMap_6----- (mutex1)
;00 - 06 =  7b (0000 0000 0000 0000 0000 0000 0XXX XXXX)(0x007F), UD_StruggleCritChance
;07 - 14 =  8b (0000 0000 0000 0000 0XXX XXXX X000 0000)(0x00FF), UD_LockpickDifficulty
;15 - 19 =  5b (0000 0000 0000 XXXX X000 0000 0000 0000)(0x003F), UD_Locks
;20 - 26 =  7b (0000 0XXX XXXX 0000 0000 0000 0000 0000)(0x007F), UD_CutChance
;27 - 31 =  5b (XXXX X000 0000 0000 0000 0000 0000 0000)(0x001F), UD_base_stat_drain
int _deviceControlBitMap_6 = 0x4000008F 

;-----_deviceControlBitMap_7----- (mutex1)
;00 - 11 = 12b (0000 0000 0000 0000 0000 XXXX XXXX XXXX)(0x0FFF), UD_durability_damage_base
;12 - 21 = 10b (0000 0000 00XX XXXX XXXX 0000 0000 0000)(0x03FF), UD_ResistMagicka
;22 - 24 =  3b (0000 000X XX00 0000 0000 0000 0000 0000)(0x0007), !UNUSED!
;25 - 27 =  3b (0000 XXX0 0000 0000 0000 0000 0000 0000)(0x0007), _struggleGame_Subtype
;28 - 30 =  3b (0XXX 0000 0000 0000 0000 0000 0000 0000)(0x0007), _struggleGame_Subtype_NPC
;31 - 31 =  1b (X000 0000 0000 0000 0000 0000 0000 0000)(0x0001), !UNUSED!
int _deviceControlBitMap_7 = 0x001F4064

;-----_deviceControlBitMap_8----- (mutex1)
;00 - 06 =  7b (0000 0000 0000 0000 0000 0000 0XXX XXXX)(0x007F), UD_RegenMagHelper_Stamina
;07 - 13 =  7b (0000 0000 0000 0000 00XX XXXX X000 0000)(0x007F), UD_RegenMagHelper_Health
;14 - 20 =  7b (0000 0000 000X XXXX XX00 0000 0000 0000)(0x007F), UD_RegenMagHelper_Magicka
;21 - 27 =  7b (0000 XXXX XXX0 0000 0000 0000 0000 0000)(0x007F), _customMinigameCritChance
;28 - 31 =  4b (XXXX 0000 0000 0000 0000 0000 0000 0000)(0x000F), !UNUSED!
int _deviceControlBitMap_8 = 0x00000000

;-----_deviceControlBitMap_9----- (mutex1)
;00 - 06 =  7b (0000 0000 0000 0000 0000 0000 0XXX XXXX)(0x007F), _customMinigameCritDuration
;07 - 18 = 12b (0000 0000 0000 0XXX XXXX XXXX X000 0000)(0x0FFF), _customMinigameCritMult
;19 - 25 =  7b (0000 00XX XXXX X000 0000 0000 0000 0000)(0x007F), _minMinigameStatHP
;26 - 31 =  6b (XXXX XX00 0000 0000 0000 0000 0000 0000)(0x003F), !UNUSED!
int _deviceControlBitMap_9 = 0x00000000

;-----_deviceControlBitMap_10----- (mutex3)
;00 - 06 =  7b (0000 0000 0000 0000 0000 0000 0XXX XXXX)(0x007F), _minMinigameStatMP
;07 - 13 =  7b (0000 0000 0000 0000 00XX XXXX X000 0000)(0x007F), _minMinigameStatSP
;14 - 21 =  8b (0000 0000 00XX XXXX XX00 0000 0000 0000)(0x00FF), _condition_mult_add
;22 - 29 =  8b (00XX XXXX XX00 0000 0000 0000 0000 0000)(0x00FF), _exhaustion_mult
;30 - 31 =  2b (XX00 0000 0000 0000 0000 0000 0000 0000)(0x0003), !UNUSED!
int _deviceControlBitMap_10 = 0x00000000

;-----_deviceControlBitMap_11----- (mutex3)
;00 - 09 = 10b (0000 0000 0000 0000 0000 000X XXXX XXXX)(0x03FF), UD_WeaponHitResist
;10 - 19 = 10b (0000 0000 0000 XXXX XXXX XXXX 0000 0000)(0x03FF), UD_SpellHitResist
;20 - 29 = 10b (00XX XXXX XXXX 0000 0000 0000 0000 0000)(0x03FF), UD_ResistPhysical
;30 - 31 =  2b (XX00 0000 0000 0000 0000 0000 0000 0000)(0x0003), !UNUSED!
int _deviceControlBitMap_11 = 0x1F4FFFFF

;-----_deviceControlBitMap_12----- (mutex3)
;00 - 07 =  8b (0000 0000 0000 0000 0000 0000 XXXX XXXX)(0x00FF), _exhaustion_mult_helper
;08 - 14 =  7b (0000 0000 0000 0000 0XXX XXXX 0000 0000)(0x007F), UD_LockAccessDifficulty
;15 - 24 = 10b (0000 000X XXXX XXXX X000 0000 0000 0000)(0x01FF), UD_StruggleCritMul, defualt value 4x (0x0F)
;25 - 27 =  3b (0000 XXX0 0000 0000 0000 0000 0000 0000)(0x0007), UD_StruggleCritDuration, default value 1s (0x5)
;28 - 31 =  4b (XXXX 0000 0000 0000 0000 0000 0000 0000)(0x000F), !UNUSED!
int _deviceControlBitMap_12 = 0x0A078000

;-----_deviceControlBitMap_13----- (mutex3)
;00 - 11 = 12b (0000 0000 0000 0000 0000 XXXX XXXX XXXX)(0x0FFF), _CuttingProgress
;12 - 23 = 12b (0000 0000 XXXX XXXX XXXX 0000 0000 0000)(0x0FFF), _RepairProgress
;24 - 31 =  8b (XXXX XXXX 0000 0000 X000 0000 0000 0000)(0x00FF), !UNUSED!
int _deviceControlBitMap_13 = 0x00000000

Function Debug_LogBitMaps(String argTitle = "BITMASK")
    libSafeCheck()
    debug.trace("===================== "+getDeviceName() +" / "+ argTitle +" =====================")
    debug.trace("_deviceControlBitMap_1 : "+_deviceControlBitMap_1 +",b: "+IntToBit(_deviceControlBitMap_1 ))
    debug.trace("_deviceControlBitMap_2 : "+_deviceControlBitMap_2 +",b: "+IntToBit(_deviceControlBitMap_2 ))
    debug.trace("_deviceControlBitMap_3 : "+_deviceControlBitMap_3 +",b: "+IntToBit(_deviceControlBitMap_3 ))
    debug.trace("_deviceControlBitMap_4 : "+_deviceControlBitMap_4 +",b: "+IntToBit(_deviceControlBitMap_4 ))
    debug.trace("_deviceControlBitMap_5 : "+_deviceControlBitMap_5 +",b: "+IntToBit(_deviceControlBitMap_5 ))
    debug.trace("_deviceControlBitMap_6 : "+_deviceControlBitMap_6 +",b: "+IntToBit(_deviceControlBitMap_6 ))
    debug.trace("_deviceControlBitMap_7 : "+_deviceControlBitMap_7 +",b: "+IntToBit(_deviceControlBitMap_7 ))
    debug.trace("_deviceControlBitMap_8 : "+_deviceControlBitMap_8 +",b: "+IntToBit(_deviceControlBitMap_8 ))
    debug.trace("_deviceControlBitMap_9 : "+_deviceControlBitMap_9 +",b: "+IntToBit(_deviceControlBitMap_9 ))
    debug.trace("_deviceControlBitMap_10: "+_deviceControlBitMap_10+",b: "+IntToBit(_deviceControlBitMap_10))
    debug.trace("_deviceControlBitMap_11: "+_deviceControlBitMap_11+",b: "+IntToBit(_deviceControlBitMap_11))
    debug.trace("_deviceControlBitMap_12: "+_deviceControlBitMap_12+",b: "+IntToBit(_deviceControlBitMap_12))
    debug.trace("_deviceControlBitMap_13: "+_deviceControlBitMap_13+",b: "+IntToBit(_deviceControlBitMap_13))
EndFunction

;=============================================================
;=============================================================
;=============================================================
;                    PROPERTIES START
;=============================================================
;=============================================================
;=============================================================

;--------------------------------PUBLIC VARS----------------------------
;do not modify
Key Property zad_deviceKey auto hidden

;-------------------------------------------------------
;-------!!!!!!!!!!!!ALWAYS FILL!!!!!!!!!!!!!!!----------
Armor Property DeviceInventory auto
zadlibs Property libs auto
zadlibs_UDPatch Property libsp
    zadlibs_UDPatch Function get()
        return libs as zadlibs_UDPatch
    EndFunction
EndProperty

;FILL FOR FASTER LOCK
Armor Property DeviceRendered auto
Keyword Property UD_DeviceKeyword auto ;keyword of this device for better manipulation

;-------------------------------------------------------
;-------------------------------------------------------

;libs, filled automatically
UnforgivingDevicesMain Property UDmain auto ;main function
UD_libs Property UDlibs Hidden;device/keyword library
    UD_libs Function get()
        return UDmain.UDlibs
    EndFunction
EndProperty 
UDCustomDeviceMain Property UDCDmain Hidden
    UDCustomDeviceMain Function get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_OrgasmManager Property UDOM Hidden
    UD_OrgasmManager Function get()
        return UDmain.UDOM
    EndFunction
EndProperty
UD_AnimationManagerScript Property UDAM Hidden
    UD_AnimationManagerScript Function get()
        return UDmain.UDAM
    EndFunction 
EndProperty

;MAIN VALUES
int _level = 1
Int Property UD_Level
    int Function get()
        return _level
    EndFunction
    Function set(int aiValue)
        _level = iRange(aiValue,-10,1000)
        ;reset vars
        current_device_health = UD_Health
        UD_CurrentLocks = UD_Locks
    EndFunction    
EndProperty

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
        startBitMapMutexCheck3()
        _deviceControlBitMap_11 = codeBit(_deviceControlBitMap_11,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,20)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return (decodeBit(_deviceControlBitMap_11,10,20)/100.0) - 5.0
    EndFunction
EndProperty
float Property UD_WeaponHitResist
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_11 = codeBit(_deviceControlBitMap_11,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,0)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return (decodeBit(_deviceControlBitMap_11,10,0)/100.0) - 5.0
    EndFunction
EndProperty
float Property UD_SpellHitResist
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_11 = codeBit(_deviceControlBitMap_11,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,10)
        endBitMapMutexCheck3()
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
float Property UD_LockAccessDifficulty ;chance of reaching the lock for every 1s of minigame, 100. is unreachable
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_12 = codeBit(_deviceControlBitMap_12,Round(fRange(fVal,0.0,100.0)),7,8)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_12,7,8)
    EndFunction
EndProperty
;float Property UD_StruggleCritMul = 3.0 auto ;how many times of duration is reduced
float Property UD_StruggleCritMul Hidden ;how many times of duration is reduced, step = 0.25, max 255
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_12 = codeBit(_deviceControlBitMap_12,Round(fRange(fVal,0.0,255.0)*4),10,15)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_12,10,15)/4.0
    EndFunction
EndProperty
;float Property UD_StruggleCritDuration = 1.0 auto ;crit time, the lower this value, the more faster player needs to press button
float Property UD_StruggleCritDuration Hidden ;crit time, the lower this value, the more faster player needs to press button, range 0.5-1.2, step 0.1 (7 values)
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_12 = codeBit(_deviceControlBitMap_12,Round((fRange(fVal,0.5,1.2) - 0.5)*10),3,25)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_12,3,25)/10.0 + 0.5
    EndFunction
EndProperty

Message Property UD_MessageDeviceInteraction auto ;messagebox that is shown when player click on device in inventory
Message Property UD_MessageDeviceInteractionWH auto ;messagebox that is shown when player click on device in NPC inventory
Message Property UD_SpecialMenuInteraction auto ;messagebox that is shown when player select Special from device menu
Message Property UD_SpecialMenuInteractionWH auto ;messagebox that is shown when player select Special from device menu when helping/getting help

LeveledItem Property UD_OnDestroyItemList auto ;items received when device is unlocked (only when device have DestroyOnRemove)

Form[]  Property UD_DeviceAbilities         auto ;array of abilities which are added on actor when device is equipped
;array of flags for abilities which are added on actor when device is equipped
;00 - 01    = 02b (0000 0000 0000 0000 0000 0000 0000 00XX)(0x0003), ;Should device ability be added when device is locked ?
;               = 00  -> Ability will be added for all NPCs and Player
;               = 01  -> Ability will be added only for NPC
;               = 10  -> Ability will be added only for Player
;               = 11  -> Ability will be not added on when device is locked
;02 - 31    = 30b (XXXX XXXX XXXX XXXX XXXX XXXX XXXX XX00)(0xFFFFFFFC), ;Unused
Int[]   Property UD_DeviceAbilities_Flags   auto 

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
        int loc_difficutly = decodeBit(_deviceControlBitMap_6,8,7)
        if loc_difficutly < 100
            ;increase difficulty based on device level
            if UDCDMain.UD_PreventMasterLock
                loc_difficutly = iRange(loc_difficutly + Round(UDCDMain.UD_DeviceLvlLockpick*(UD_Level - 1)),1,75) ;increase lockpick difficulty
            else
                loc_difficutly = iRange(loc_difficutly + Round(UDCDMain.UD_DeviceLvlLockpick*(UD_Level - 1)),1,100) ;increase lockpick difficulty
            endif
        endif

        return loc_difficutly
    EndFunction
EndProperty
int Property UD_Locks ;number of locks, range 0-31
    Function set(int iVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_6 = codeBit(_deviceControlBitMap_6,iRange(iVal,0,31),5,15)
        endBitMapMutexCheck()
    EndFunction
    
    int Function get()
        int loc_locks = decodeBit(_deviceControlBitMap_6,5,15)
        if loc_locks > 0 && UDCDMain.UD_DeviceLvlLocks
            loc_locks += (UD_Level - 1)/UDCDMain.UD_DeviceLvlLocks
        endif
        return loc_locks
    EndFunction
EndProperty

;Device cooldown, in minutes. Device will activate itself on after this time (if it can)
;zero or negative value will disable this feature
int    Property UD_Cooldown = 0 auto 
int _currentRndCooldown = 0

string Property UD_ActiveEffectName = "Share" auto ;name of active effect
string Property UD_DeviceType = "Generic" auto ;name of active effect

string[] Property UD_Modifiers auto ;modifiers
string[] Property UD_struggleAnimations auto ;array of all struggle animations
string[] Property UD_struggleAnimationsHobl auto ;array of all struggle animations which player when actor have tied legs

UD_CustomDevice_NPCSlot _WearerSlot
UD_CustomDevice_NPCSlot Property UD_WearerSlot hidden
    UD_CustomDevice_NPCSlot Function get()
        if !Wearer
            return none
        endif
        if !_WearerSlot
            _WearerSlot = UDCDmain.GetNPCSlot(Wearer)
        endif
        return _WearerSlot
    EndFunction
EndProperty

;------------local variables-------------------
Actor Wearer = none ;current device wearer reference
Actor _minigameHelper = none

float device_health = 100.0 ;default max device durability, for now always 100
Float Property UD_Health ;default max health. Is increased with device LVL. Every level increase health by 2.5%
    Float Function get()
        return device_health + (UD_Level - 1)*UDCDmain.UD_DeviceLvlHealth*device_health
    EndFunction
EndProperty

float current_device_health = 0.0 ;current device durability, if this reaches 0, player will escape restrain
float _total_durability_drain = 0.0 ;how much durability was reduced, aka condition
float _durability_damage_mod ;durability dmg after applied difficulty, dont change this! Use updateDifficulty() if you want to update it
float _updateTimePassed = 0.0 ;time passed from last update in days

;variables copied from zadEquipScript. !dont change!
;bool[] cameraState
;---------------------------------------PRIVATE VARS----------------------------------------

int Property UD_CurrentLocks Hidden ;how many locked locks remain, max is 31
    Function set(int iVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_5 = codeBit(_deviceControlBitMap_5,iRange(iVal,0,31),6,0)
        endBitMapMutexCheck()
    EndFunction
    
    int Function get()
        Int loc_val = decodeBit(_deviceControlBitMap_5,6,0)
        if loc_val > UD_Locks
            UD_CurrentLocks = UD_Locks
        endif
        return loc_val
    EndFunction
endproperty
int Property UD_JammedLocks Hidden ;jammed locks, max is 31
    Function set(int iVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_5 = codeBit(_deviceControlBitMap_5,iRange(iVal,0,31),6,6)
        endBitMapMutexCheck()
    EndFunction
    
    int Function get()
        Int loc_val = decodeBit(_deviceControlBitMap_5,6,6)
        if loc_val > UD_Locks
            UD_JammedLocks = UD_Locks
        endif
        return loc_val
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
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,0)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,0))
    EndFunction
endproperty
bool Property lockpickGame_on Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,1)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,1))
    EndFunction
endproperty
bool Property cuttingGame_on Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,2)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,2))
    EndFunction
endproperty
bool Property keyGame_on Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,3)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,3))
    EndFunction
endproperty
bool Property repairLocksMinigame_on Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,4)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,4))
    EndFunction
endproperty
bool Property force_stop_minigame Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,5)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,5))
    EndFunction
endproperty
bool Property pauseMinigame Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,6)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,6))
    EndFunction
endproperty
bool Property _critLoop_On Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,7)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,7))
    EndFunction
EndProperty
bool Property _MinigameMainLoop_ON Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,8)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,8))
    EndFunction
EndProperty
bool Property UD_drain_stats Hidden ;if player will loose stats while struggling
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,9)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,9))
    EndFunction
endproperty
bool Property UD_drain_stats_helper Hidden ;if player will loose stats while struggling
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,10)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,10))
    EndFunction
endproperty
bool Property UD_damage_device Hidden ;if device can be damaged
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,11)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,11))
    EndFunction
endproperty
bool Property UD_applyExhastionEffect Hidden ;applies debuff after mnigame ends
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,12)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,12))
    EndFunction
endproperty
bool Property UD_applyExhastionEffectHelper Hidden ;applies debuff after minigame ends
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,13)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,13))
    EndFunction
endproperty
bool Property UD_minigame_canCrit Hidden ;if crits can appear
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,14)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,14))
    EndFunction
endproperty
bool Property UD_useWidget Hidden ;determinate if widget will be shown
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,15)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,15))
    EndFunction
endproperty
bool Property UD_WidgetAutoColor Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,16)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,16))
    EndFunction
endproperty
bool Property Ready Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,17)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,17))
    EndFunction
endproperty
bool Property zad_DestroyOnRemove Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,18)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,18))
    EndFunction
endproperty
bool Property zad_DestroyKey Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,19)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,19))
    EndFunction
endproperty
bool Property _AVOK Hidden 
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,20)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,20))
    EndFunction
EndProperty
bool Property minigame_on Hidden 
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,21)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,21))
    EndFunction
EndProperty
bool Property _activated Hidden 
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,22)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,22))
    EndFunction
EndProperty
bool Property _removeDeviceCalled Hidden 
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,23)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,23))
    EndFunction
EndProperty
bool Property UD_minigame_critRegen Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,24)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,24))
    EndFunction
EndProperty
bool Property UD_minigame_critRegen_helper Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,25)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,25))
    EndFunction
EndProperty
bool Property _isRemoved hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,26)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,26))
    EndFunction
EndProperty
bool Property _MinigameParProc_2 Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,27)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,27))
    EndFunction
EndProperty
bool Property _MinigameParProc_1 Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,28)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,28))
    EndFunction
EndProperty
bool Property _usingTelekinesis Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,29)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,29))
    EndFunction
EndProperty
bool Property _MinigameParProc_3 Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,30)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,30))
    EndFunction
EndProperty
bool Property UD_AllowWidgetUpdate Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,31)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,31))
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
float Property UD_minigame_stamina_drain_helper Hidden    ;stamina drain for second of struggling
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_2 = codeBit(_deviceControlBitMap_2,Round(fRange(fVal,0.0,200.0)),8,24)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_2,8,24);Math.LogicalAnd(_deviceControlBitMap_2,Math.LeftShift(0xFF,16)) as Float
    EndFunction
endproperty
float Property UD_minigame_magicka_drain_helper Hidden    ;magicka drain for second of struggling
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

float Property _CuttingProgress Hidden ;cutting progress, 0-100, step 0.025
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_13 = codeBit(_deviceControlBitMap_13,Round(fRange(fVal,0.0,100.0)*40),12,0)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_13,12,0)/40.0
    EndFunction
EndProperty
float Property _RepairProgress Hidden ;lock repair progress, 0-100, step 0.025
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_13 = codeBit(_deviceControlBitMap_13,Round(fRange(fVal,0.0,100.0)*40),12,12)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_13,12,12)/40.0
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
        startBitMapMutexCheck3()
        _deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,1.0)*100),7,0)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_10,7,0)/100.0
    EndFunction
EndProperty
float Property _minMinigameStatSP Hidden
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,1.0)*100),7,7)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_10,7,7)/100.0
    EndFunction
EndProperty
float Property _condition_mult_add Hidden ;how much is increased condition dmg (10% increase condition dmg by 10%), step = 0.1, max 25.6
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,25.6)*10),8,14)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_10,8,14)/4.0
    EndFunction
EndProperty
float Property _exhaustion_mult Hidden ;multiplier for duration of debuff, step = 0.25, max 64
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,64.0)*4),8,22)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_10,8,22)/4.0
    EndFunction
EndProperty
float Property _exhaustion_mult_helper Hidden ;multiplier for duration of debuff, step = 0.25, max 64
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_12 = codeBit(_deviceControlBitMap_12,Round(fRange(fVal,0.0,64.0)*4),8,0)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_12,8,0)/4.0
    EndFunction
EndProperty

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

bool _isUnlocked = false
bool Property isUnlocked Hidden
    Function set(bool bVal)
        ;can't be changed externally
    EndFunction
    
    bool Function get()
        return _isUnlocked
    EndFunction
EndProperty

Keyword _DeviceKeyword_Minor = none
Keyword Property UD_DeviceKeyword_Minor  ;minor keyword of this device. Currently only used for HB
    Keyword Function get()
        if _DeviceKeyword_Minor
            return _DeviceKeyword_Minor
        else
            if UD_DeviceKeyword == libs.zad_deviousHeavyBondage
                _DeviceKeyword_Minor = UDCDmain.GetHeavyBondageKeyword(deviceRendered)
                if !_DeviceKeyword_Minor
                    UDmain.Error("UD_DeviceKeyword_Minor - Could not find minor keyword!")
                endif
                return _DeviceKeyword_Minor
            else
                _DeviceKeyword_Minor = UD_DeviceKeyword
                return _DeviceKeyword_Minor
            endif
        endif
    EndFunction
    Function set(Keyword akKeyword)
        if akKeyword
            _DeviceKeyword_Minor = akKeyword
        endif
    EndFunction
EndProperty
;=============================================================
;=============================================================
;=============================================================
;                    PROPERTIES END
;=============================================================
;=============================================================
;=============================================================

;returns current device wearer
Actor Function getWearer()
    return Wearer
EndFunction

;returns current device wearers name
String Function getWearerName()
    return GetActorName(Wearer)
EndFunction

;sets current helper
Function setHelper(Actor akActor)
    _minigameHelper = akActor
EndFunction

;returns current minigame helper
Actor Function getHelper()
    return _minigameHelper
EndFunction

;returns current device helper name (only when Device Menu WH is open or in minigame with helper)
String Function getHelperName()
    if _minigameHelper
        return getActorName(_minigameHelper)
    else
        return "ERROR"
    endif
EndFunction

;returns if wearer/helper is registered in register
bool Function WearerIsRegistered()
    return UDCDmain.isRegistered(Wearer)
EndFunction 
bool Function HelperIsRegistered()
    return UDCDmain.isRegistered(getHelper())
EndFunction 

;returns true if device wearer is player
bool Function WearerIsPlayer()
    return Wearer == UDmain.Player
EndFunction

;returns true if device wearer is current follower
bool Function WearerIsFollower()
    return UDmain.ActorIsFollower(getWearer())
EndFunction

;returns true if player is taking part in minigame (either as wearer or helper)
bool Function PlayerInMinigame()
    return WearerIsPlayer() || HelperIsPlayer()
EndFunction

;returns true if device currently have helper
bool Function hasHelper()
    return _minigameHelper
EndFunction

;returns true if current device helper is player
bool Function HelperIsPlayer()
    if _minigameHelper
        return _minigameHelper == UDmain.Player
    endif
    return false
EndFunction

;returns true if current device helper is player follower
bool Function HelperIsFollower()
    if _minigameHelper
        return UDCDmain.ActorIsFollower(_minigameHelper)
    endif
    return false
EndFunction

;returns true if device is fully initialized (this is done before device is locked)
;only used for benchmark, don't use
bool Function isReady()
    return Ready
EndFunction

Event OnInit()
    current_device_health = UD_Health
EndEvent

;OnContainerChanged is very important event. It is used to determinate if render device have been equipped (OnEquipped only works for player)
;it is also used for retrieving device (this) script
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if (akNewContainer as Actor) && !akOldContainer && !isUnlocked && !Ready
        Actor loc_actor = akNewContainer as Actor
        if !loc_actor.isDead()
            Init(loc_actor)
        endif
    endif
    
    if UDmain        
        if (akOldContainer == UDCDmain.TransfereContainer_ObjRef)
            if UDmain.TraceAllowed()            
                UDCDmain.Log("Device " + getDeviceHeader() + " transfered to transfer container!",2)
            endif
            UDCDmain._transferedDevice = self
        endif
    endif
EndEvent

;returns device header in format -> $DeviceName ($WearerName)
string Function getDeviceHeader()
    if hasHelper()
        return (getDeviceName() + "(W="+getWearerName()+",H="+getHelperName()+")")
    else
        return (getDeviceName() + "("+getWearerName()+")")
    endif
EndFunction

;returns device name
String Function getDeviceName()
    return deviceInventory.getName()
EndFunction

;returns inventory device script, SCRIPT NEED TO BE ALWAYS DELEATED AFTER USING WITH script.delete() !!!
UD_CustomDevice_EquipScript Function getInventoryScript()
    ObjectReference loc_ref = UDCDmain.TransfereContainer_ObjRef.placeatme(deviceInventory,1)
    if loc_ref as UD_CustomDevice_EquipScript
        return (loc_ref as UD_CustomDevice_EquipScript)
    else
        UDmain.Error("getInventoryScript(" + getDeviceHeader() + ") - ID have no UD_CustomDevice_EquipScript script! Ref: " + loc_ref)
        loc_ref.delete()
        return none
    endif
EndFunction

bool Function isDeviceValid()
    if getWearer().getItemCount(deviceInventory) && getWearer().getItemCount(deviceRendered)
        if UDCDmain.CheckRenderDeviceEquipped(getWearer(),deviceRendered)
            return true
        endif
    endif

    return false
EndFunction

;updates some values from invetory script
;    -device key
;    -key break chance
;    -If device is destroyed on remove
;    -jamm lock chance
;    -!!!device rendered!!!
Function updateValuesFromInventoryScript()
    UD_CustomDevice_EquipScript temp = getInventoryScript()
    if temp
        zad_deviceKey = temp.deviceKey
        zad_KeyBreakChance = temp.KeyBreakChance
        zad_DestroyOnRemove = temp.DestroyOnRemove
        zad_DestroyKey = temp.DestroyKey
        zad_JammLockChance = temp.LockJamChance
        UD_DeviceKeyword = temp.zad_deviousDevice
        DeviceRendered = temp.DeviceRendered
        temp.delete()
    endif
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
    string[] loc_params = getModifierAllParam(modifier)
    if !loc_params
        UDCDMain.Error(getDeviceHeader() + " -> getModifierParamNum -> "+ modifier +" have no parameters!")
        return 0
    else
        return getModifierAllParam(modifier).length
    endif
EndFunction

Int Function getModifierIntParam(string modifier,int index = 0,int default_value = 0)
    string[] loc_params = getModifierAllParam(modifier)
    if (index - 1) > loc_params.length    
        UDCDMain.Error(getDeviceHeader() + " -> getModifierIntParam -> Wrong index passed for "+ modifier +"!")
        return default_value
    elseif loc_params.length == 0
        UDCDMain.Error(getDeviceHeader() + " -> getModifierIntParam -> modifier "+modifier+" have no parameters!")
        return default_value
    else
        return loc_params[index] as Int
    endif
EndFunction

Float Function getModifierFloatParam(string modifier,int index = 0,float default_value = 0.0)
    string[] loc_params = getModifierAllParam(modifier)
    if (index - 1) > loc_params.length    
        UDCDMain.Error(getDeviceHeader() + " -> getModifierFloatParam -> Wrong index passed for "+ modifier +"!")
        return default_value
    elseif loc_params.length == 0
        UDCDMain.Error(getDeviceHeader() + " -> getModifierFloatParam -> modifier "+modifier+" have no parameters!")
        return default_value
    else
        return loc_params[index] as Float
    endif
EndFunction

String Function getModifierParam(string modifier,int index = 0,string default_value = "ERROR")
    string[] loc_params = getModifierAllParam(modifier)
    if (index - 1) > loc_params.length    
        UDCDMain.Error(getDeviceHeader() + " -> getModifierParam -> Wrong index passed for "+ modifier +"!")
        return default_value
    elseif loc_params.length == 0
        UDCDMain.Error(getDeviceHeader() + " -> getModifierParam -> modifier "+modifier+" have no parameters!")
        return default_value
    else
        return loc_params[index]
    endif
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
    if UDmain.TraceAllowed()
        UDCDmain.Log("Mutexed and proccesing " + getDeviceHeader(),2)
    endif
EndFunction

Function EndInitMutex()
    if UDmain.TraceAllowed()
        UDCDmain.Log("Mutex ended for " + getDeviceHeader(),2)
    endif
    UDCDmain.UD_EquipMutex = False
EndFunction

;post equip function
Function Init(Actor akActor)
    libSafeCheck()

    if !akActor
        UDCDmain.Error("!Aborting Init called for "+getDeviceName()+" because actor is none!!")
        akActor.removeItem(deviceRendered,1,True)
        return
    endif

    Wearer = akActor
    
    UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(akActor)
    
    if isUnlocked 
        UDCDmain.Error("!Aborting Init("+ getActorName(akActor) +") called for " + DeviceInventory.getName() + " because device is already unlocked!!")
        return 
    endif
    
    if akActor.getItemCount(deviceInventory) == 0
        UDCDmain.Error("!Aborting Init("+ getActorName(akActor) +") called for " + DeviceInventory.getName() + " because no inventory device is present!")
        return
    endif

    ;update now if deviceRendered isn't filled yet, otherwise update on end
    ;deviceRendered should be filled to make the init faster
    if !deviceRendered || !UD_DeviceKeyword
        updateValuesFromInventoryScript()
    endif
        
    if akActor.getItemCount(deviceRendered) > 1
        UDCDmain.Error("!Aborting Init("+ getDeviceHeader() + " because device is already present!")
        akActor.removeItem(deviceRendered,akActor.getItemCount(deviceRendered) - 1,true)
        return
    endif
        
    float loc_time = 0.0
    bool loc_isplayer = (akActor == UDmain.Player)
    while loc_time <= 1.0 && !UDCDmain.CheckRenderDeviceEquipped(akActor, deviceRendered)
        if loc_isplayer
            Utility.waitMenuMode(0.01)
        else
            Utility.wait(0.01)
        endif
        loc_time += 0.05
    endwhile
    
    if loc_time >= 1.0
        UDCDmain.Error("!Aborting Init("+ getActorName(akActor) +") called for " + DeviceInventory.getName() + " because equip failed - timeout")
        return
    endif

    if UDmain.TraceAllowed()
        UDCDmain.Log("Init(called for " + getDeviceHeader(),1)
    endif
    
    ;MUTEX START
    ;mutex check because some mods equips items too fast at once, making it possible to have equipped 2 of the same item
    if loc_slot
        if loc_slot.getDeviceByRender(deviceRendered)
            UDCDmain.Error("!Aborting Init("+ getDeviceHeader() +") because device is already registered!")
            akActor.removeItem(deviceRendered,akActor.getItemCount(deviceRendered) - 1,true)
            return
        endif
        StartInitMutex()
    endif
    
    if UDmain.TraceAllowed()
        UDCDmain.Log("Registering device: " + getDeviceHeader(),1)
    endif
    
    UDCDmain.startScript(self)
    
    if loc_slot
        EndInitMutex()
    endif
        
    ;MUTEX END    
    
    if deviceRendered
        updateValuesFromInventoryScript()
    endif

    if deviceRendered.hasKeyword(UDlibs.PatchedDevice) ;patched device
        if UDmain.TraceAllowed()        
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
    
    if UD_Level < 1
        int loc_level = akActor.GetLevel()
        if UD_Level == -1 ;random value in +- 25% range from wearer level
            UD_Level = Round(Utility.randomFloat(fRange(loc_level*0.75,1.0,100.0),fRange(loc_level*1.25,1.0,100.0)))
        elseif UD_Level == -2 ;random value in + 25% range from wearer level
            UD_Level = Round(Utility.randomFloat(fRange(loc_level,1.0,100.0),fRange(loc_level*1.25,1.0,100.0)))
        elseif UD_Level == -3 ;random value in - 25% range from wearer level
            UD_Level = Round(Utility.randomFloat(fRange(loc_level*0.75,1.0,100.0),fRange(loc_level,1.0,100.0)))
        else ;same level as wearer
            UD_Level = loc_level
        endif
    endif
    
    UD_CurrentLocks = UD_Locks
    current_device_health = UD_Health ;repairs device to max durability on equip
    
    safeCheck()
    
    UDCDmain.CheckHardcoreDisabler(getWearer())
    
    InitPost()

    if UD_Cooldown > 0
        resetCooldown()
    endif
    
    ;Add abilities
    int loc_abilityId = UD_DeviceAbilities.length
    while loc_abilityId
        loc_abilityId -= 1
        Int loc_filter = Math.LogicalAnd(UD_DeviceAbilities_Flags[loc_abilityId],0x00000003)
        if loc_filter == 0x00
            AddAbilityToWearer(loc_abilityId)
        elseif loc_filter == 0x01 && !loc_isplayer
            AddAbilityToWearer(loc_abilityId)
        elseif loc_filter == 0x10 && loc_isplayer
            AddAbilityToWearer(loc_abilityId)
        else
            ;DO NOT ADD
        endif
    endwhile
    
    
    if UDmain.TraceAllowed()
        UDCDmain.Log(DeviceInventory.getName() + " fully locked on " + getWearerName(),1)
    endif
    
    InitPostPost()
    
    Ready = True
    
    if UDCDmain.isRegistered(getWearer())
        Update(1/24/60) ;1 minute update
    endif
EndFunction

Function removeDevice(actor akActor)
    if _removeDeviceCalled
        return
    endif
    _removeDeviceCalled = True
    
    GoToState("UpdatePaused")
    
    if !akActor.isDead()
        if !_isUnlocked
            _isUnlocked = True
            current_device_health = 0.0
            UDCDmain.updateLastOpenedDeviceOnRemove(self)
            StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
            if wearer.isinfaction(UDCDmain.minigamefaction)
                wearer.removefromfaction(UDCDmain.minigamefaction)
                StorageUtil.UnSetFormValue(Wearer, "UD_currentMinigameDevice")
            endif
        endif
    endif
    
    if UDmain.TraceAllowed()
        UDCDmain.Log("removeDevice() called for " + getDeviceHeader(),1)
    endif
    
    OnRemoveDevicePre(akActor)
    
    if UDCDmain.isRegistered(akActor)
        UDCDmain.endScript(self)
    endif
    
    RemoveAllAbilities(akActor)
    
    if deviceRendered.hasKeyword(libs.zad_DeviousBelt) || deviceRendered.hasKeyword(libs.zad_DeviousBra)
        libs.Aroused.SetActorExposureRate(akActor, libs.GetOriginalRate(akActor))
        StorageUtil.UnSetFloatValue(akActor, "zad.StoredExposureRate")
    endif
    
    UDmain.UDMOM.Procces_UpdateModifiers_Remove(self) ;update modifiers
    
    if UD_OnDestroyItemList
        if UDmain.TraceAllowed()
            UDCDmain.Log("Items from LIL " + UD_OnDestroyItemList + " added to actor " + GetWearername(),3)
        endif
        akActor.addItem(UD_OnDestroyItemList)
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
;time passed is in days
Function Update(float timePassed)
    _updateTimePassed += (timePassed*24.0*60.0);*UDCDmain.UD_CooldownMultiplier
    
    UpdateCooldown()
    
    if _updateTimePassed > _currentRndCooldown && UD_Cooldown > 0
        CooldownActivate()
    endif
    
    OnUpdatePre(timePassed)
    
    updateCondition()
    
    OnUpdatePost(timePassed)
EndFunction

Function resetCooldown()
    _updateTimePassed = 0.0
    _currentRndCooldown = CalculateCooldown()
EndFunction

Function UpdateCooldown()

EndFunction

int Function CalculateCooldown(Float fMult = 1.0)
    return iRange(Round(fMult*UD_Cooldown*Utility.randomFloat(0.75,1.25)*UDCDmain.UD_CooldownMultiplier),5,24*60*60*10)
EndFunction

;like Update function, but called only once per hour
;mult -> multiplier which identifies how many hours have passed (1.5 hours -> mult = 1.5)
Function UpdateHour(float mult)
    if OnUpdateHourPre()
        if OnUpdateHourPost()
        endif
    endif
EndFunction

Function libSafeCheck()
    if !UDmain
        Quest UDquest = Game.getFormFromFile(0x00005901,"UnforgivingDevices.esp") as Quest
        UDmain = UDquest as UnforgivingDevicesMain 
    endif
    libs = UDmain.libs
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
    ValidateJammedLocks()
EndFunction

Function patchDevice()
    UDCDmain.UDPatcher.patchGeneric(self)
EndFunction

float Function getRelativeDurability()
    return current_device_health/UD_Health
EndFunction 

float Function getRelativeCuttingProgress()
    return _CuttingProgress/100.0
EndFunction

float Function getRelativeLockRepairProgress()
    return _RepairProgress/getLockDurability()
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
;1 = Novice, 25 = Apprentice, 50 = Adept,75 = Expert,100 = Master,255 = Requires Key, range 1-255
int Function getLockLevel()
    if !UD_LockpickDifficulty
        return 5
    endif
    if UD_LockpickDifficulty == 1
        return 0 ;Novice
    elseif UD_LockpickDifficulty <= 25
        return 1 ;Apprentice
    elseif UD_LockpickDifficulty <= 50
        return 2 ;Adept
    elseif UD_LockpickDifficulty <= 75
        return 3 ;Expert
    elseif UD_LockpickDifficulty <= 100
        return 4 ;master
    else
        return 5
    endif
    
    return 4
EndFunction

;returns lock acces chance
;100 = 100% chance of reaching lock
;0 = 0% chance of reaching lock
int Function getLockAccesChance(bool checkTelekinesis = true)
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
    if checkTelekinesis
        if WearerHaveTelekinesis()
            res -= 15
        endif
    endif
    if hasHelper()
        if checkTelekinesis
            if HelperHaveTelekinesis()
                res -= 15
            endif    
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

Bool Function WearerHaveTelekinesis()
    return Wearer.hasspell(UDlibs.TelekinesisSpell)
EndFunction

Bool Function HelperHaveTelekinesis()
    if !hasHelper()
        return false
    endif
    return getHelper().hasspell(UDlibs.TelekinesisSpell)
EndFunction

int Function GetTelekinesisLockModifier()
    int loc_res = 0
    if WearerHaveTelekinesis()
        loc_res += 15
    endif
    if hasHelper()
        if HelperHaveTelekinesis()
            loc_res += 15
        endif    
    endif
    return loc_res
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

Function showWidget(Bool abUpdate = true, Bool abUpdateColor = true)
    if abUpdate
        updateWidget(true)
    endif
    if abUpdateColor
        updateWidgetColor()
    endif
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
        current_device_health = fRange(current_device_health - value,0.0,UD_Health)
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
    return UD_Health
EndFunction

float Function getCondition()
    return _total_durability_drain
EndFunction

float Function getRelativeCondition()
    return (UD_Health - _total_durability_drain)/UD_Health
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
        while (_total_durability_drain >= UD_Health) && !_isUnlocked && UD_condition < 4
            _total_durability_drain -= UD_Health
            UD_condition += 1
            if WearerIsPlayer()
                UDCDmain.Print("You feel that "+getDeviceName()+" condition have decreased!",2)
            elseif UDCDmain.AllowNPCMessage(GetWearer())
                UDCDmain.Print(GetWearerName() + "s " + getDeviceName() + " condition have decreased!",3)
            endif
        endwhile
    else
        if (_total_durability_drain < 0) && !_isUnlocked
            _total_durability_drain = 0
            if UD_condition > 0 
                UD_condition -= 1
                if WearerIsPlayer()
                    UDCDmain.Print("You feel that "+getDeviceName()+" condition have increased!",1)
                elseif UDCDmain.AllowNPCMessage(GetWearer())
                    UDCDmain.Print(GetWearerName() + "s " + getDeviceName() + " condition have increased!",3)
                endif
            endif
        endif
    endif
    
    if UD_condition >= 4 && !isUnlocked
        if WearerIsPlayer()
            UDCDmain.Print("You managed to destroy "+ getDeviceName() +"!",2)
        elseif WearerIsFollower()
            UDCDmain.Print(GetWearerName() + " managed to destroy " + getDeviceName() + "!",2)
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
        refillCuttingProgress(timePassed*regen)
        onMendPost(mult)
    endif
EndFunction

Function refillDurability(float arg_fValue)
    if current_device_health > 0.0
        current_device_health += arg_fValue
        if (current_device_health > UD_Health)
            _total_durability_drain -= 5*(current_device_health - UD_Health)
            current_device_health = UD_Health
            updateCondition(False)
        endif
    endif
EndFunction

Function refillCuttingProgress(float arg_fValue)
    if current_device_health > 0.0
        _CuttingProgress -= arg_fValue
        if _CuttingProgress < 0.0
            _CuttingProgress = 0.0
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

bool Function canBeStruggled(float afAccesibility = -1.0)
    if afAccesibility < 0.0
        afAccesibility = getAccesibility()
    endif
    
    if UD_durability_damage_base > 0.0 && afAccesibility > 0.0
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

bool Function HaveUnlockableLocks()
    if UD_CurrentLocks > 0
        return true
    endif
    if UD_LockpickDifficulty < 255 || zad_deviceKey
        return true
    endif
    if (UD_CurrentLocks - UD_JammedLocks) > 0
        return true
    endif
    return false
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
    if !hasHelper()
        return false
    endif
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
    else
        return false
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
    if WearerIsPlayer()
        return (UD_drain_stats || UD_RegenMag_Stamina  || UD_RegenMag_Health || UD_RegenMag_Magicka)
    endif
    if HelperIsPlayer()
        return (UD_drain_stats_helper || UD_RegenMagHelper_Stamina  || UD_RegenMagHelper_Health || UD_RegenMagHelper_Magicka)
    endif
    return false
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
    UDCDmain.currentDeviceMenu_allowRepair = UDCDmain.currentDeviceMenu_allowRepair &&    !aControlFilter[7]
    
    UDCDmain.currentDeviceMenu_switch1 = UDCDmain.currentDeviceMenu_switch1  &&    !aControlFilter[8]
    UDCDmain.currentDeviceMenu_switch2 = UDCDmain.currentDeviceMenu_switch2  &&    !aControlFilter[9]
    UDCDmain.currentDeviceMenu_switch3 = UDCDmain.currentDeviceMenu_switch3  &&    !aControlFilter[10]
    UDCDmain.currentDeviceMenu_switch4 = UDCDmain.currentDeviceMenu_switch4  &&    !aControlFilter[11]
    UDCDmain.currentDeviceMenu_switch5 = UDCDmain.currentDeviceMenu_switch5  &&    !aControlFilter[12]
    UDCDmain.currentDeviceMenu_switch6 = UDCDmain.currentDeviceMenu_switch6  &&    !aControlFilter[13]
    
    UDCDmain.currentDeviceMenu_allowCommand = UDCDmain.currentDeviceMenu_allowCommand && !aControlFilter[14]
    UDCDmain.currentDeviceMenu_allowDetails = UDCDmain.currentDeviceMenu_allowDetails && !aControlFilter[15]
    
    UDCDmain.currentDeviceMenu_allowSpecialMenu = UDCDmain.currentDeviceMenu_allowSpecialMenu && !aControlFilter[16]
    UDCDmain.currentDeviceMenu_allowLockMenu = UDCDmain.currentDeviceMenu_allowLockMenu && !aControlFilter[17]
EndFunction

Function deviceMenuInit(bool[] aControl)
    ;updates difficulty
    updateDifficulty()
    setHelper(none)
    UDCDmain.resetCondVar()

    bool     loc_isloose            = isLoose()
    bool     loc_freehands          = WearerFreeHands()
    float     loc_accesibility      = getAccesibility()
    
    ;normal struggle
    if canBeStruggled(loc_accesibility); && (loc_isloose || loc_freehands)
        UDCDmain.currentDeviceMenu_allowstruggling = True
    else
        UDCDmain.currentDeviceMenu_allowUselessStruggling = True
    endif
    
    if (getLockAccesChance() > 0)
        if UD_CurrentLocks != UD_JammedLocks
            ;key unlock
            if zad_deviceKey
                if wearer.getItemCount(zad_deviceKey) > 0
                    UDCDmain.currentDeviceMenu_allowkey = True
                endif
            endif
            
            ;lockpicking
            if UD_LockpickDifficulty < 255 && wearer.getItemCount(UDCDmain.Lockpick) > 0
                UDCDmain.currentDeviceMenu_allowlockpick = True
            endif
        endif
        ;lock repair
        if UD_JammedLocks && loc_accesibility > 0
            UDCDmain.currentDeviceMenu_allowlockrepair = True
        endif
    endif
    ;cutting
    if canBeCutted() && loc_accesibility
        UDCDmain.currentDeviceMenu_allowcutting = True
    endif
    
    if (UDCDmain.currentDeviceMenu_allowkey || UDCDmain.currentDeviceMenu_allowlockpick || UDCDmain.currentDeviceMenu_allowlockrepair)
        UDCDmain.currentDeviceMenu_allowLockMenu = true
    endif
    
    ;sets last opened device
    if WearerIsPlayer()
        UDCDmain.setLastOpenedDevice(self)
    endif
    
    ;override function
    onDeviceMenuInitPost(aControl)
    filterControl(aControl)
    UDCdmain.CheckAndDisableSpecialMenu()
EndFunction

;device menu that pops up when Wearer click on this device in inventory
;CONTROL; !NUM = 17!
;    00 = currentDeviceMenu_allowstruggling
;    01 = currentDeviceMenu_allowUselessStruggling    
;    02 = currentDeviceMenu_allowcutting
;    03 = currentDeviceMenu_allowkey
;    04 = currentDeviceMenu_allowlockpick
;    05 = currentDeviceMenu_allowlockrepair
;    06 = currentDeviceMenu_allowTighten
;    07 = currentDeviceMenu_allowRepair    
;    08 = currentDeviceMenu_switch1
;    09 = currentDeviceMenu_switch2
;    10 = currentDeviceMenu_switch3
;    11 = currentDeviceMenu_switch4
;    12 = currentDeviceMenu_switch5
;    13 = currentDeviceMenu_switch6    
;    14 = currentDeviceMenu_allowCommand
;    15 = currentDeviceMenu_allowDetails
;    16 = special menu
;    17 = lockmenu
Function DeviceMenu(bool[] aControl)
    if UDmain.TraceAllowed()    
        UDmain.Log(getDeviceHeader()+" DeviceMenu() called , aControl = "+aControl,2)
    endif
        
    GoToState("UpdatePaused")
    
    bool _break = False
    while !_break
        deviceMenuInit(aControl)
        Int msgChoice = UD_MessageDeviceInteraction.Show()
        StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
        if msgChoice == 0        ;struggle
            _break = struggleMinigame()
        elseif msgChoice == 1    ;useless struggle
            _break = struggleMinigame(5)
        elseif msgChoice == 2    ;manage locks
            _break = lockMenu(aControl)
        elseif msgChoice == 3    ;cutting
            _break = cuttingMinigame()
        elseif msgChoice == 4     ;special menu
            _break = specialMenu(aControl)
        elseif msgChoice == 5     ;details
            processDetails()        
        else
            _break = True         ;exit
        endif
        DeviceMenuExt(msgChoice)
        if Game.UsingGamepad()
            Utility.waitMenuMode(0.75)
        endif
    endwhile
    
    GoToState("")
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
        int  loc_res  = UD_SpecialMenuInteraction.show()
        bool loc_res2 = proccesSpecialMenu(loc_res)
        return loc_res2
    else
        return False
    endif
EndFunction

Function deviceMenuInitWH(Actor akSource,bool[] aControl)
    ;updates difficulty
    setHelper(akSource)
    updateDifficulty()
    UDCDmain.resetCondVar()
    
    bool    loc_freehands_helper     = WearerFreeHands(true)
    float   loc_accesibility         = getAccesibility()
    int     loc_lockacces            = getLockAccesChance()
    
    
    ;help struggle
    if canBeStruggled(loc_accesibility)
        UDCDmain.currentDeviceMenu_allowstruggling = True
    endif

    if (UD_CurrentLocks != UD_JammedLocks) && (loc_lockacces || loc_freehands_helper)
        ;key unlock
        if zad_deviceKey 
            if (wearer.getItemCount(zad_deviceKey) || akSource.getItemCount(zad_deviceKey)) 
                UDCDmain.currentDeviceMenu_allowkey = True
            endif
        endif
        
        ;lockpicking
        if UD_LockpickDifficulty < 255 
            if (wearer.getItemCount(UDCDmain.Lockpick) || akSource.getItemCount(UDCDmain.Lockpick))
                UDCDmain.currentDeviceMenu_allowlockpick = True
            endif
        endif
    endif

    ;lock repair
    if (loc_accesibility || loc_freehands_helper) && UD_JammedLocks
        UDCDmain.currentDeviceMenu_allowlockrepair = True
    endif

    ;cutting
    if canBeCutted()
        UDCDmain.currentDeviceMenu_allowcutting = True
    endif
        
    if loc_freehands_helper
        UDCDmain.currentDeviceMenu_allowTighten = True
    endif
    
    if loc_freehands_helper
        UDCDmain.currentDeviceMenu_allowRepair = True
    endif
    if (UDCDmain.currentDeviceMenu_allowkey || UDCDmain.currentDeviceMenu_allowlockpick || UDCDmain.currentDeviceMenu_allowlockrepair)
        UDCDmain.currentDeviceMenu_allowLockMenu = true
    endif
    
    if WearerIsFollower() && !WearerIsPlayer()
        UDCDmain.currentDeviceMenu_allowCommand = True
    endif
    
    ;override function
    onDeviceMenuInitPostWH(aControl)
    filterControl(aControl)
    UDCdmain.CheckAndDisableSpecialMenu()
EndFunction

;device menu that pops up when Wearer click on this device in inventory
;CONTROL; !NUM = 18!
;    0 = currentDeviceMenu_allowstruggling
;    1 = currentDeviceMenu_allowUselessStruggling    
;    2 = currentDeviceMenu_allowcutting
;    3 = currentDeviceMenu_allowkey
;    4 = currentDeviceMenu_allowlockpick
;    5 = currentDeviceMenu_allowlockrepair
;    6 = currentDeviceMenu_allowTighten
;    7 = currentDeviceMenu_allowRepair    
;    8 = currentDeviceMenu_switch1
;    9 = currentDeviceMenu_switch2
;    10 = currentDeviceMenu_switch3
;    11 = currentDeviceMenu_switch4
;    12 = currentDeviceMenu_switch5
;    13 = currentDeviceMenu_switch6    
;    14 = currentDeviceMenu_allowCommand
;    15 = currentDeviceMenu_allowDetails
;    16 = special menu
;    17 = lockmenu
Function DeviceMenuWH(Actor akSource,bool[] aControl)
    if UDmain.TraceAllowed()
        UDmain.Log(getDeviceHeader() + " DeviceMenuWH() called, aControl = "+aControl,2)
    endif

    GoToState("UpdatePaused")
    
    bool _break = False
    while !_break
        deviceMenuInitWH(akSource,aControl)
        Int msgChoice = UD_MessageDeviceInteractionWH.Show()
        StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
        StorageUtil.UnSetIntValue(akSource, "UD_ignoreEvent" + deviceInventory)
        if msgChoice == 0        ;help struggle
            _break = struggleMinigameWH(akSource)
        elseif msgChoice == 1    ;lockpick
            _break = lockMenuWH(akSource,aControl)
        elseif msgChoice == 2    ;help cutting
            _break = cuttingMinigameWH(akSource)
        elseif msgChoice == 3     ;special
            _break = specialMenuWH(akSource,aControl)
        elseif msgChoice == 4    ;tighten up
            _break = tightUpDevice(akSource)
        elseif msgChoice == 5    ;repair
            _break = repairDevice(akSource)
        elseif msgChoice == 6    ;command
            aControl = new Bool[30]
            DeviceMenu(aControl)
            _break = True
        elseif msgChoice == 7    ;details
            processDetails()        
        else
            _break = True        ;exit
        endif
        
        DeviceMenuExtWH(msgChoice)
    endwhile
    setHelper(none)
    
    ;if UD_WearerSlot
    ;    UD_WearerSlot.GoToState("")
    ;Endif
    GoToState("")
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
        int  loc_res  = UD_SpecialMenuInteractionWH.show()
        bool loc_res2 = proccesSpecialMenuWH(akSource,loc_res)
        return loc_res2
    else
        return False
    endif
EndFunction

float Function getHelperAgilitySkills()
    if hasHelper()
        return UDCDMain.GetAgilitySkill(getHelper())
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
        return UDCDMain.GetStrengthSkill(getHelper())
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
        return UDCDMain.GetMagickSkill(getHelper())
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
    
    UD_WidgetAutoColor = True
    
    if iType == 0 ;normal
        UD_minigame_stamina_drain = UD_base_stat_drain*0.75 + getMaxActorValue(Wearer,"Stamina",0.035)
        UD_durability_damage_add = 1.25*(_durability_damage_mod*UDCDMain.getActorAgilitySkillsPerc(getWearer()))
        UD_DamageMult *= getModResistPhysical(1.0,0.3)
        _exhaustion_mult = 0.5
        _condition_mult_add = -0.9
        UD_RegenMag_Magicka = 0.4
        UD_RegenMag_Health = 0.4
        _minMinigameStatSP = 0.25
    elseif iType == 1 ;desperate
        UD_minigame_stamina_drain = UD_base_stat_drain*1.1
        UD_minigame_heal_drain = 0.5*UD_base_stat_drain + getMaxActorValue(Wearer,"Health",0.06)
        UD_durability_damage_add = 1.0*(_durability_damage_mod*((1.0 - getRelativeDurability()) + UDCDMain.getActorStrengthSkillsPerc(getWearer())));UDmain.getMaxActorValue(Wearer,"Health",0.02);*getModResistPhysical()
        UD_DamageMult *= getModResistPhysical(1.0,0.1)
        _condition_mult_add = -0.5
        _exhaustion_mult = 1.6
        UD_RegenMag_Magicka = 0.5
        _minMinigameStatSP = 0.2
        _minMinigameStatHP = 0.4
    elseif iType == 2 ;magick
        UD_minigame_stamina_drain = 0.65*UD_base_stat_drain
        UD_minigame_magicka_drain = 0.75*UD_base_stat_drain + getMaxActorValue(Wearer,"Magicka",0.05)
        UD_durability_damage_add = 1.0*(_durability_damage_mod*UDCDMain.getActorMagickSkillsPerc(getWearer()))
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
        
    _struggleGame_Subtype = iType

    bool loc_minigamecheck = minigamePostcheck()
    if loc_minigamecheck
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
    UD_UseWidget = False
    UD_RegenMag_Health = 0.5
    UD_RegenMag_Magicka = 0.5
    _customMinigameCritChance = getLockAccesChance(false)
    _customMinigameCritDuration = 0.8 - getLockLevel()*0.02
    UD_AllowWidgetUpdate = False
    _minMinigameStatSP = 0.8
    
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
    UD_AllowWidgetUpdate = False
    UD_WidgetColor = 0xffbd00
    UD_WidgetColor2 = -1

    _customMinigameCritChance = 5 + (4 - getLockLevel())*5
    _customMinigameCritDuration = 0.8 - getLockLevel()*0.02
    UD_MinigameMult1 = getAccesibility() + UDCDMain.getActorSmithingSkillsPerc(getWearer())*0.5
    if wearerFreeHands()
        UD_MinigameMult1 += 0.5
        _customMinigameCritChance += 15
    elseif wearerFreeHands(True)
        UD_MinigameMult1 += 0.15
        _customMinigameCritChance += 5
    endif
    
    UD_RegenMag_Health = 0.5
    UD_RegenMag_Magicka = 0.5
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
    UD_minigame_stamina_drain = UD_base_stat_drain + getMaxActorValue(Wearer,"Stamina",0.04)
    UD_minigame_heal_drain = UD_base_stat_drain/2+ getMaxActorValue(Wearer,"Health",0.01)
    UD_WidgetAutoColor = True
    UD_AllowWidgetUpdate = False
    UD_RegenMag_Magicka = 0.5
    _minMinigameStatSP = 0.8
    _minMinigameStatHP = 0.5
        
    if minigamePostcheck()
        float loc_BaseMult = UDCDmain.getActorCuttingWeaponMultiplier(getWearer())
        
        UD_MinigameMult1 = loc_BaseMult + UDCDmain.getActorCuttingSkillsPerc(getWearer())
        UD_DamageMult = loc_BaseMult + UDCDmain.getActorCuttingSkillsPerc(getWearer())
        
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
    UD_UseWidget = False
    UD_AllowWidgetUpdate = False
    UD_RegenMag_Health = 0.5
    UD_RegenMag_Magicka = 0.5
    _customMinigameCritChance = getLockAccesChance(false)
    _customMinigameCritDuration = 0.85 - getLockLevel()*0.025
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
        UD_minigame_stamina_drain = UD_base_stat_drain*0.75 + getMaxActorValue(Wearer,"Stamina",0.03)
        UD_minigame_stamina_drain_helper = UD_base_stat_drain*0.5 + getMaxActorValue(_minigameHelper,"Stamina",0.03)
        UD_durability_damage_add = 1.0*_durability_damage_mod*(0.25 + 2.5*(UDCDMain.getActorAgilitySkillsPerc(getWearer()) + getHelperAgilitySkillsPerc()))
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
        UD_minigame_heal_drain = 0.5*UD_base_stat_drain + getMaxActorValue(Wearer,"Health",0.05)
        UD_minigame_heal_drain_helper = 0.5*UD_base_stat_drain + getMaxActorValue(_minigameHelper,"Health",0.05)
        
        UD_durability_damage_add = 1.0*_durability_damage_mod*((1.0 - getRelativeDurability()) + UDCDMain.getActorStrengthSkillsPerc(getWearer()) + getHelperStrengthSkillsPerc())
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
        UD_minigame_magicka_drain = 0.7*UD_base_stat_drain + getMaxActorValue(Wearer,"Magicka",0.05)
        UD_minigame_magicka_drain_helper = UD_base_stat_drain + getMaxActorValue(Wearer,"Magicka",0.05)
        UD_DamageMult = getModResistMagicka(1.0,0.3)*getAccesibility()
        UD_durability_damage_add = 2.0*_durability_damage_mod*(UDCDMain.getActorMagickSkillsPerc(getWearer()) + getHelperMagickSkillsPerc())
        
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
        
        return true
    else
        return false
    endif
    
EndFunction

bool Function lockpickMinigameWH(Actor akHelper)
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
    UD_AllowWidgetUpdate = False
    _customMinigameCritChance = getLockAccesChance(false)
    UD_RegenMag_Magicka = 0.5
    UD_RegenMag_Health = 0.5
    UD_RegenMagHelper_Magicka = 0.75
    UD_RegenMagHelper_Health = 0.75
    _customMinigameCritDuration = 0.9
    _minMinigameStatSP = 0.8
    UD_UseWidget = False
    
    if HelperFreeHands(True)
        _customMinigameCritChance = 100
    elseif HelperFreeHands()
        _customMinigameCritChance = getLockAccesChance(false) + 35
    else
        _customMinigameCritChance = getLockAccesChance(false) + 10
    endif
    
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
    UD_AllowWidgetUpdate = False
    UD_WidgetColor = 0xffbd00
    UD_WidgetColor2 = -1
    _customMinigameCritChance = 10 + (4 - getLockLevel())*5
    UD_MinigameMult1 = getAccesibility() + 0.35*(UDCDMain.getActorSmithingSkillsPerc(getWearer()) + UDCDMain.getActorSmithingSkillsPerc(getHelper()))
    UD_RegenMag_Magicka = 0.5
    UD_RegenMag_Health = 0.5
    UD_RegenMagHelper_Magicka = 0.75
    UD_RegenMagHelper_Health = 0.75
    _customMinigameCritDuration = 0.85 - getLockLevel()*0.015    
    _minMinigameStatSP = 0.8
    
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
    UD_minigame_stamina_drain = UD_base_stat_drain + getMaxActorValue(Wearer,"Stamina",0.04)
    UD_minigame_stamina_drain_helper = UD_base_stat_drain*1.25 + getMaxActorValue(Wearer,"Stamina",0.04)
    UD_minigame_heal_drain = UD_base_stat_drain*0.75 + getMaxActorValue(Wearer,"Health",0.02)    
    UD_AllowWidgetUpdate = False
    UD_WidgetAutoColor = True
    UD_RegenMag_Magicka = 0.5
    UD_RegenMag_Health = 0.5
    UD_RegenMagHelper_Magicka = 0.75
    UD_RegenMagHelper_Health = 0.75
    _minMinigameStatSP = 0.8
    _minMinigameStatHP = 0.5
    if minigamePostcheck()
        float loc_BaseMult = UDCDmain.getActorCuttingWeaponMultiplier(getWearer())
        float loc_BaseMultHelperAdd = UDCDmain.getActorCuttingWeaponMultiplier(getHelper()) - 1.0
        
        UD_DamageMult = loc_BaseMult + loc_BaseMultHelperAdd + UDCDmain.getActorCuttingSkillsPerc(getWearer()) + UDCDmain.getActorCuttingSkillsPerc(getHelper())
        UD_MinigameMult1 = UD_DamageMult;loc_BaseMult + loc_BaseMultHelper + UDCDmain.getActorCuttingSkillsPerc(getWearer()) + UDCDmain.getActorCuttingSkillsPerc(getHelper())
        
        if HelperFreeHands(True)
            UD_MinigameMult1 += 0.8
        elseif HelperFreeHands()
            UD_MinigameMult1 += 0.15
        endif
    
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
    UD_applyExhastionEffect = false
    UD_applyExhastionEffectHelper = false
    UD_minigame_critRegen = false
    UD_minigame_critRegen_helper = false
    UD_RegenMag_Magicka = 0.5
    UD_RegenMag_Health = 0.5
    UD_RegenMagHelper_Magicka = 0.75
    UD_RegenMagHelper_Health = 0.75
    _customMinigameCritChance = getLockAccesChance(false)
    _customMinigameCritDuration = 0.9 - getLockLevel()*0.03    
    _minMinigameStatSP = 0.6
    UD_UseWidget = False
    UD_AllowWidgetUpdate = False
    
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
    UDmain.Print(akSource.getActorBase().getName() + " tighted " + getWearerName() + " " + getDeviceName() + " !",1)
    current_device_health += Utility.randomFloat(5.0,15.0)
    if (current_device_health > UD_Health)
        current_device_health = UD_Health
        updateCondition(False)
    endif
EndFunction

Function repairDevice(Actor akSource)
    UDmain.Print(akSource.getActorBase().getName() + " repaired " + getWearerName() + " " + getDeviceName() + " !",1)
    current_device_health += Utility.randomFloat(15.0,30.0)
    if (current_device_health > UD_Health)
        current_device_health = UD_Health
    endif    
    _total_durability_drain = -1
    updateCondition(False)

    _CuttingProgress -= 30.0
    if _CuttingProgress < 0.0
        _CuttingProgress = 0.0
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
    UD_useWidget = True
    UD_WidgetAutoColor = False
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
    _usingTelekinesis = false
    UD_AllowWidgetUpdate = true
EndFunction

;set minigame offensive variables
Function setMinigameOffensiveVar(bool dmgDevice,float dpsAdd = 0.0,float condMultAdd = 0.0, bool canCrit = false,float dmg_mult = 1.0)
    UD_damage_device = dmgDevice
    UD_durability_damage_add = dpsAdd
    _condition_mult_add = condMultAdd
    UD_minigame_canCrit = canCrit
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
Function setMinigameEffectVar(bool alloworgasm = True,bool allowexhaustion = True,float exhaustion_m = 1.0)
    UD_applyExhastionEffect = allowexhaustion
    _exhaustion_mult = exhaustion_m
EndFunction

;set minigame effect variables
Function setMinigameEffectHelperVar(bool alloworgasm = True,bool allowexhaustion = True,float exhaustion_m = 1.0)
    UD_applyExhastionEffectHelper = allowexhaustion
    _exhaustion_mult_helper = exhaustion_m
EndFunction

;set minigame widget variables
Function setMinigameWidgetVar(bool useWidget = False,bool widgetAutoColor = True,int color = 0x0000FF,int sec_color = -1, bool abWidgetUpdate = True, int flash_col = -1)
    UD_useWidget = useWidget
    UD_WidgetColor = color
    UD_WidgetColor2 = sec_color
    UD_WidgetFlashColor = flash_col
    UD_WidgetAutoColor = widgetAutoColor
    UD_AllowWidgetUpdate = abWidgetUpdate
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
    if PlayerInMinigame()
        UDCDmain.resetCurrentMinigameDevice()
    endif
    force_stop_minigame = True
    pauseMinigame = False
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
    bool loc_hoble = akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirt) && !akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)
    If loc_hoble
        if UD_struggleAnimationsHobl && UD_struggleAnimationsHobl.length > 0
            return UD_struggleAnimationsHobl        ; Use hobbled struggle idles
        elseif UD_struggleAnimations && UD_struggleAnimations.length > 0
            return UD_struggleAnimations        ; Fall back to standard animations if no hobbled variants are available
        else
            return UDAM.GetStruggleAnimationsByKeyword(getWearer(),UD_DeviceKeyword_Minor,loc_hoble)
        endif
    Else
        if UD_struggleAnimations && UD_struggleAnimations.length > 0
            return UD_struggleAnimations        ; Use regular struggle idles
        else
            return UDAM.GetStruggleAnimationsByKeyword(getWearer(),UD_DeviceKeyword_Minor,loc_hoble)
        endif
    Endif
EndFunction

bool Function minigamePostcheck()
    if !checkMinAV(Wearer) ;check wearer AVs
        if WearerIsPlayer() ;message related to player wearer
            UDmain.Print("You are too exhausted. Try later, after you regain your strength.",1)
        else ;message related to NPC wearer
            UDmain.Print(getWearerName()+" is too exhausted!",1)
        endif
        return false
    elseif hasHelper() && !checkMinAV(_minigameHelper)
        if HelperIsPlayer() ;message related to player helper
            UDmain.Print("You are too exhausted and can't help "+getWearerName()+".",1)    
        else ;message related to NPC helper
            UDmain.Print(getHelperName()+" is too exhausted and unable to help you.",1)
        endif
        return false
    endif
    return true
EndFunction

bool Function minigamePrecheck()
    if UDCDmain.actorInMinigame(Wearer)
        if WearerIsPlayer()
            UDCDmain.Print("You are already doing something")
        elseif UDCDmain.AllowNPCMessage(Wearer)
            UDCDmain.Print(getWearerName() + " is already doing something")
        endif
        return false
    endif

    if (UDAM.isAnimating(Wearer))
        if WearerIsPlayer()
            UDCDmain.Print("You are already doing something",1)
        elseif WearerIsFollower()
            UDCDmain.Print(getWearerName() + " is already doing something",1)
        endif
        return false
    endif
    
    if !libs.isValidActor(GetWearer())
        if WearerIsPlayer()
            UDCDmain.Print("You are already doing something",1)
        elseif UDCDmain.AllowNPCMessage(GetWearer())
            UDCDmain.Print(getWearerName() + " is already doing something",1)
        endif
        return false
    endif
    
    if hasHelper()
        if (UDAM.isAnimating(_minigameHelper))
            UDCDmain.Print(getWearerName() + " is already doing something",1)
            return false
        endif
        if UDCDmain.actorInMinigame(_minigameHelper)
            if HelperIsPlayer()
                UDCDmain.Print("You are already doing something")
            elseif HelperIsFollower()
                UDCDmain.Print(getHelperName() + " is already doing something")
            endif
            return false
        endif
        
        if !libs.isValidActor(GetHelper())
            if HelperIsPlayer()
                UDCDmain.Print("You are already doing something",1)
            elseif HelperIsFollower()
                UDCDmain.Print(getHelperName() + " is already doing something",1)
            endif
            return false
        endif
    endif
    
    if _MinigameParProc_1 || _MinigameParProc_2 || _MinigameParProc_3
        if WearerIsPlayer() || WearerIsFollower()
            UDCDmain.Print("Slow down!",1)
        endif
        return false
    endif
    
    return true
EndFunction


;===============================================================
;!!!--------------------MINIGAME LOOP------------------------!!!
;===============================================================

Function minigame()
    if current_device_health <= 0 ;device is already unlocked (somehow)
        UnlockRestrain()
        return
    endif
    
    if UDmain.DebugMod
        showDebugMinigameInfo()
    endif
    
    GoToState("UpdatePaused")
    
    bool loc_WearerIsPlayer = WearerIsPlayer()
    bool loc_HelperIsPlayer = HelperIsPlayer()
    bool loc_PlayerInMinigame = loc_WearerIsPlayer || loc_HelperIsPlayer
    
    if loc_PlayerInMinigame
        closeMenu()
        ;UDmain.UDNPCM.GoToState("SlotUpdateStopped")
    endif
    
    minigame_on = True
    force_stop_minigame = False
    
    Wearer.AddToFaction(UDCDmain.MinigameFaction)
    if hasHelper()
        _minigameHelper.AddToFaction(UDCDmain.MinigameFaction)
    endif
    
    UDCDMain.UDPP.Send_MinigameStarter(Wearer,self)
    
    if UDmain.TraceAllowed()
        UDCDmain.Log("Minigame started for: " + deviceInventory.getName())    
    endif
    
    ;struggle animations array
    String[] struggleArray
    String[] struggleArrayHelper
    String _sStruggleAnim = "none" ;currently selected struggle animation. Used by minigame.
    String _sStruggleAnimHelper = "none" ;currently selected struggle animation. Used by minigame.
    if !wearer.wornhaskeyword(libs.zad_deviousHeavyBondage)
        struggleArray = SelectStruggleArray(Wearer)
    else
        if wearer.wornhaskeyword(UDlibs.InvisibleHBKW)
            struggleArray = UDAM.GetHeavyBondageAnimation_Armbinder(!WearerFreeLegs())
        else
            if isHeavyBondage()
                struggleArray = SelectStruggleArray(Wearer)
            else
                UD_CustomDevice_RenderScript loc_device = UDCDmain.getSlotHeavyBondageDevice(UD_WearerSlot)
                if loc_device
                    ;actor is registered
                    struggleArray = loc_device.SelectStruggleArray(Wearer)
                else
                    ;actor is NOT registered
                    loc_device = UDCDmain.getHeavyBondageDevice(Wearer)
                    if loc_device
                        struggleArray = UDCDmain.getHeavyBondageDevice(Wearer).SelectStruggleArray(Wearer)
                    else
                        ;device is not UD
                        Armor loc_deviceRendered = libs.GetWornRenderedDeviceByKeyword(Wearer,libs.zad_deviousHeavyBondage)
                        if loc_deviceRendered
                            struggleArray = UDAM.GetStruggleAnimations(Wearer,loc_deviceRendered)
                        else
                            UDmain.Error(getDeviceHeader() + "Can't find correct heavy bondage animation to play, skipping animation")
                        endif
                    endif
                endif
            endif
        endif
    endif
    if struggleArray
        _sStruggleAnim = struggleArray[Utility.RandomInt(0,  struggleArray.length - 1)]
    else
        UDmain.Error(getDeviceHeader() + " - selected struggle animation array is none!")
    endif
    
    if _minigameHelper
        if !_minigameHelper.wornhaskeyword(libs.zad_deviousHeavyBondage)
            _sStruggleAnimHelper = "ft_struggle_gloves_1"
        else
            if _minigameHelper.wornhaskeyword(UDlibs.InvisibleHBKW)
                struggleArrayHelper = UDAM.GetHeavyBondageAnimation_Armbinder(!HelperFreeLegs())
            else
                UD_CustomDevice_RenderScript loc_device = UDCDmain.getHeavyBondageDevice(Wearer)
                if loc_device
                    struggleArrayHelper = UDCDmain.getHeavyBondageDevice(_minigameHelper).SelectStruggleArray(_minigameHelper)
                else
                    ;device is not UD
                    Armor loc_deviceRendered = libs.GetWornRenderedDeviceByKeyword(_minigameHelper,libs.zad_deviousHeavyBondage)
                    if loc_deviceRendered
                        struggleArrayHelper = UDAM.GetStruggleAnimations(_minigameHelper,loc_deviceRendered)
                    else
                        UDmain.Error(getDeviceHeader() + "Can't find correct heavy bondage animation to play for helper, skipping animation")
                    endif
                endif
            endif
            if struggleArrayHelper
                _sStruggleAnimHelper = struggleArrayHelper[Utility.RandomInt(0,  struggleArrayHelper.length - 1)]
            else
                UDmain.Error(getDeviceHeader() + " - selected struggleArrayHelper animation array is none!")
            endif    
        endif
    endif
    
    ;starts random struggle animation
    if _sStruggleAnim != "none" && _sStruggleAnim != ""
        UDAM.FastStartThirdPersonAnimation(Wearer, _sStruggleAnim)
    else
        UDmain.Error(getDeviceHeader() + " - Wrong animation name passed in minigame, skipping")
    endif
    
    if hasHelper()
        if _sStruggleAnimHelper != "none" && _sStruggleAnim != ""
            UDAM.FastStartThirdPersonAnimation(_minigameHelper, _sStruggleAnimHelper)
        endif
    endif
    
    _MinigameMainLoop_ON = true    
    UDCDMain.UDPP.Send_MinigameParalel(Wearer,self)        

    float durability_onstart = current_device_health
    
    ;main loop, ends only when character run out off stats or device losts all durability
    int         tick_b                 = 0
    int         tick_s                 = 0
    float       fCurrentUpdateTime     = UDmain.UD_baseUpdateTime
    
    if !loc_PlayerInMinigame
        fCurrentUpdateTime = 1.0
    endif

    pauseMinigame = False
    
    float     loc_dmg              = (_durability_damage_mod + UD_durability_damage_add)*fCurrentUpdateTime*UD_DamageMult
    float     loc_condmult         = 1.0 + _condition_mult_add
    bool      loc_updatewidget     = loc_PlayerInMinigame && UDCDmain.UD_UseWidget && UD_UseWidget && UD_AllowWidgetUpdate
    
    while current_device_health > 0.0 && !force_stop_minigame; && UDCDmain.actorInMinigame(getWearer())
        ;pause minigame, pause minigame need to be changed from other thread or infinite loop happens
        while pauseMinigame
            Utility.wait(0.01)
        endwhile
        
        if !force_stop_minigame
            if !ProccesAV(fCurrentUpdateTime)
                StopMinigame()
            endif
            if hasHelper()
                if !ProccesAVHelper(fCurrentUpdateTime)
                    StopMinigame()
                endif
            endif
        endif
        
        if !force_stop_minigame
            OnMinigameTick(fCurrentUpdateTime)
            ;reduce device durability
            if UD_damage_device
                decreaseDurabilityAndCheckUnlock(loc_dmg,loc_condmult)
            endif
            ;update widget
            if loc_updatewidget
                updateWidget()
            endif
        endif
        
        ;--one second timer--
        if (tick_b*fCurrentUpdateTime >= 1.0) && !force_stop_minigame && !pauseMinigame && current_device_health > 0.0 ;once per second
            if UDCDmain.actorInMinigame(Wearer)
                ;update loc vars
                loc_dmg             = (_durability_damage_mod + UD_durability_damage_add)*fCurrentUpdateTime*UD_DamageMult
                loc_condmult         = 1.0 + _condition_mult_add            
                loc_updatewidget     = loc_PlayerInMinigame && UDCDmain.UD_UseWidget && UD_UseWidget && UD_AllowWidgetUpdate
                
                ;check non struggle minigames
                if !loc_PlayerInMinigame
                    if cuttingGame_on
                        cutDevice(fCurrentUpdateTime*UD_CutChance/5.0)
                    endif
                endif
                
                tick_b = 0
                tick_s += 1
                if !force_stop_minigame
                    OnMinigameTick1()
                    ;--three second timer--
                    if !(tick_s % 3) && tick_s
                        ;start new animation if wearer stops animating
                        if struggleArray && (UDCDmain.UD_AlternateAnimation || !UDAM.isAnimating(Wearer,false)) && !pauseMinigame
                            _sStruggleAnim = struggleArray[Utility.RandomInt(0,  struggleArray.length - 1)]
                            UDAM.FastStartThirdPersonAnimation(Wearer, _sStruggleAnim)
                        endif
                        if _minigameHelper
                            if struggleArrayHelper && (UDCDmain.UD_AlternateAnimation || !UDAM.isAnimating(_minigameHelper,false))  && !pauseMinigame && !force_stop_minigame
                                _sStruggleAnimHelper = struggleArrayHelper[Utility.RandomInt(0,  struggleArrayHelper.length - 1)]
                                UDAM.FastStartThirdPersonAnimation(_minigameHelper, _sStruggleAnimHelper)
                            endif
                        endif
                        OnMinigameTick3()
                    endif
                endif
            else
                StopMinigame()
            endif
        endif
        
        if !force_stop_minigame && !pauseMinigame
            Utility.wait(fCurrentUpdateTime)
            tick_b += 1
        endif
    endwhile
    
    _MinigameMainLoop_ON = false
    
    if loc_PlayerInMinigame
        UDCDmain.MinigameKeysUnRegister()
    endif    
    
    if !UDOM.isOrgasming(Wearer)
        UDAM.FastEndThirdPersonAnimation(Wearer) ;ends struggle animation
    endif
    
    if _minigameHelper
        if !UDOM.isOrgasming(_minigameHelper)
            UDAM.FastEndThirdPersonAnimation(_minigameHelper) ;ends struggle animation
        endif
    endif
    
    ;checks if Wearer succesfully escaped device
    if isUnlocked; && !force_stop_minigame
        if loc_WearerIsPlayer
            UDCDmain.Print("You have succesfully escaped out of " + deviceInventory.GetName() + "!",2)
        elseif UDCDmain.AllowNPCMessage(GetWearer())
            UDCDmain.Print(getWearerName()+" succesfully escaped out of " + deviceInventory.GetName() + "!",2)
        endif
    else
        libs.pant(Wearer)
        if !force_stop_minigame
            if loc_PlayerInMinigame
                if hasHelper()
                    UDCDmain.Print("Both of you are too exhausted to continue struggling",1)
                else
                    UDCDmain.Print("You are too exhausted to continue struggling",1)
                endif
            elseif UDCDmain.AllowNPCMessage(GetWearer())
                UDCDmain.Print(getWearerName()+" is too exhausted to continue struggling",1)
            endif
        endif
    endif
    
    if UDmain.TraceAllowed()    
        UDCDmain.Log("Minigame ended for: "+ deviceInventory.getName(),1)
    endif
    
    ;wait for paralled threads to end
    float loc_time = 0.0
    while (_MinigameParProc_1 || _MinigameParProc_2 || _MinigameParProc_3) && loc_time <= 3.5
        Utility.waitMenuMode(0.1)
        loc_time += 0.1
    endwhile
    if loc_time >= 3.5
        UDCDMain.Error("minigame("+getDeviceHeader()+") - Minigame paralel thread timeout!")
    endif
    
    MinigameVarReset()
    
    OnMinigameEnd()
    
    GoToState("")
    
    if loc_PlayerInMinigame
        ;UDmain.UDNPCM.GoToState("")
    endif
    
    ;debug message
    if UDmain.DebugMod && UD_damage_device && durability_onstart != current_device_health && loc_WearerIsPlayer
        UDmain.Print("[Debug] Durability reduced: "+ formatString(durability_onstart - current_device_health,3) + "\n",1)
    endif
    
EndFunction

Function MinigameVarReset()
    if Wearer
        Wearer.RemoveFromFaction(UDCDmain.MinigameFaction)
    endif
    
    if hasHelper()
        _minigameHelper.RemoveFromFaction(UDCDmain.MinigameFaction)
    endif
    
    if PlayerInMinigame()
        UDCDmain.resetCurrentMinigameDevice()
    endif
    
    minigame_on = False
EndFunction

;https://en.uesp.net/wiki/Skyrim:Leveling
Function advanceSkill(float fMult)
    if !PlayerInMinigame()
        return
    endif
    
    float loc_mult     = 1.0
    
    if WearerIsPlayer()
        loc_mult = 1.0
    else
        loc_mult = 0.75
    endif
    
    if struggleGame_on
        int loc_type = 0
        if HasHelper()
            loc_type = _struggleGame_Subtype_NPC
        else
            loc_type = _struggleGame_Subtype
        endif
        if loc_type == 0
            Game.AdvanceSkill("Pickpocket" ,loc_mult*(0.5*UDCDmain.UD_BaseDeviceSkillIncrease*fMult/8.10)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
        elseif loc_type == 1 
            Game.AdvanceSkill("TwoHanded"  ,loc_mult*(1.0*UDCDmain.UD_BaseDeviceSkillIncrease*fMult/5.95)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
        elseif loc_type == 2
            Game.AdvanceSkill("Destruction",loc_mult*(1.0*UDCDmain.UD_BaseDeviceSkillIncrease*fMult/1.35)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
        endif
    elseif repairLocksMinigame_on
        Game.AdvanceSkill("Smithing" , loc_mult*(0.75*UDCDmain.UD_BaseDeviceSkillIncrease*fMult/1.0)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
    elseif cuttingGame_on
        Game.AdvanceSkill("OneHanded", loc_mult*(1.0*UDCDmain.UD_BaseDeviceSkillIncrease*fMult/5.3)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
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
            if PlayerInMinigame()
                debug.messagebox("You managed to insert the key but it snapped. Its remains also jammed the lock! You will have to find other way to escape.")
            endif
            
            Wearer.RemoveItem(zad_deviceKey)
            UD_JammedLocks += 1
            jammLocks()
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
        if _minigameHelper && UD_minigame_critRegen_helper
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
        
        OnCritDevicePost()
        if PlayerInMinigame() && UDCDmain.UD_UseWidget && UD_UseWidget
            updateWidget()
        endif
        
        libs.Pant(Wearer)
        
        advanceSkill(4.0)
    endif
EndFunction

;function called when player press special button
Function SpecialButtonPressed(float fMult = 1.0)
    if cuttingGame_on
        cutDevice(fMult*UD_CutChance/12.5)
    elseif keyGame_on || lockpickGame_on || repairLocksMinigame_on
        if !_usingTelekinesis
            _usingTelekinesis = true
            UD_minigame_magicka_drain = 0.5*UD_base_stat_drain + Wearer.getBaseAV("Magicka")*0.02
            if HasHelper()
                UD_minigame_magicka_drain_helper = 0.5*UD_base_stat_drain + _minigameHelper.getBaseAV("Magicka")*0.02
            endif
            if repairLocksMinigame_on
                if WearerHaveTelekinesis()
                    UD_MinigameMult1 += 0.25
                endif
                if HelperHaveTelekinesis()
                    UD_MinigameMult1 += 0.25
                endif
            else
                _customMinigameCritChance += GetTelekinesisLockModifier()
            endif
        endif
    endif

    onSpecialButtonPressed(fMult)
    
    if UDCDmain.UD_useWidget && UD_UseWidget
        updateWidget()
    endif
EndFunction

;function called when player release special button
Function SpecialButtonReleased(float fHoldTime)
    if keyGame_on || lockpickGame_on
        if _usingTelekinesis
            _usingTelekinesis = false
            UD_minigame_magicka_drain = 0
            UD_minigame_magicka_drain_helper = 0
            if repairLocksMinigame_on
                if WearerHaveTelekinesis()
                    UD_MinigameMult1 -= 0.25
                endif
                if HelperHaveTelekinesis()
                    UD_MinigameMult1 -= 0.25
                endif
            else
                _customMinigameCritChance -= GetTelekinesisLockModifier()
            endif
        endif
    endif
    onSpecialButtonReleased(fHoldTime)
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
        if UDmain.TraceAllowed()        
            UDCDmain.Log("unlockRestrain()"+getDeviceHeader()+": Device is already unlocked! Aborting ",1)
        endif
        return
    endif
    _isUnlocked = True
    GoToState("UpdatePaused")
    if UDmain.TraceAllowed()    
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
bool Function checkMinAV(Actor akActor)
    Float loc_staminamin  = _minMinigameStatSP
    Float loc_healthmin   = _minMinigameStatHP
    Float loc_magickahmin = _minMinigameStatMP
    if loc_staminamin > 0.0
        if (getCurrentActorValuePerc(akActor,"Stamina") < loc_staminamin)
           return False
        endif
    endif
    if loc_healthmin > 0.0
        if (getCurrentActorValuePerc(akActor,"Health") < loc_healthmin)
            return False
        endif
    endif
    if loc_magickahmin > 0.0
        if (getCurrentActorValuePerc(akActor,"magicka") < loc_magickahmin)
            return False
        endif
    endif
    return True
endFunction

bool Function ProccesAV(float fUpdateTime)
    if UD_drain_stats
        Float loc_staminadrain = UD_minigame_stamina_drain
        Float loc_healthdrain = UD_minigame_heal_drain
        Float loc_magickahdrain = UD_minigame_magicka_drain
        if loc_staminadrain > 0.0
            if Wearer.getAV("Stamina") <= 0
                stopMinigame()
                return false
            else
                Wearer.damageAV("Stamina", loc_staminadrain*fUpdateTime)
            endif
        endif
        if loc_healthdrain > 0.0
            if Wearer.getAV("Health") < loc_healthdrain*fUpdateTime + 1
                stopMinigame()
                return false
            else
                Wearer.damageAV("Health",  loc_healthdrain*fUpdateTime)
            endif
        endif
        if loc_magickahdrain > 0.0
            if Wearer.getAV("magicka") <= 0
                stopMinigame()
                return false
            else
                Wearer.damageAV("Magicka",  loc_magickahdrain*fUpdateTime)
            endif
        endif
    endif
    return true
EndFunction

bool Function ProccesAVHelper(float fUpdateTime)
    if UD_drain_stats_helper && _minigameHelper
        Float loc_staminadrain = UD_minigame_stamina_drain_helper
        Float loc_healthdrain = UD_minigame_heal_drain_helper
        Float loc_magickahdrain = UD_minigame_magicka_drain_helper
        if loc_staminadrain > 0.0
            if _minigameHelper.getAV("Stamina") <= 0
                stopMinigame()
                return false
            else
                _minigameHelper.damageAV("Stamina", loc_staminadrain*fUpdateTime)
            endif
        endif    

        if loc_healthdrain > 0.0
            if _minigameHelper.getAV("Health") < loc_healthdrain*fUpdateTime + 1
                stopMinigame()
                return false
            else
                _minigameHelper.damageAV("Health", loc_healthdrain*fUpdateTime)
            endif
        endif    

        if loc_magickahdrain > 0.0 
            if _minigameHelper.getAV("magicka") <= 0
                stopMinigame()
                return false
            else
                _minigameHelper.damageAV("Magicka",  loc_magickahdrain*fUpdateTime)    
            endif
        endif    
    endif
    return true
EndFunction

;function called when player clicks DETAILS button in device menu
Function processDetails()
    int res = UDCDmain.DetailsMessage.show()    
    if res == 0 
        ShowMessageBox(getInfoString())
    elseif res == 1
        ShowMessageBox(getModifiers())
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
    float loc_accesibility = getAccesibility()
    string temp = ""
    temp += "- " + deviceInventory.GetName() + " -\n"
    temp += "Level: " + UD_Level + "\n"
    temp += "Type: " + UD_DeviceType + "\n"
    temp += ("Device health: " + formatString(current_device_health,1)+"/"+ formatString(UD_Health,1)+ "\n")
    temp += "Condition: " + getConditionString() + " ("+formatString(getRelativeCondition()*100,1)+"%)\n"
    temp += "Accesibility: " + Round(100.0*loc_accesibility) + "%\n"
    
    temp += "Difficutly: "
    if (UD_durability_damage_base >= 2.5)
        temp += "Very Easy\n"
    elseif (UD_durability_damage_base >= 1.5)
        temp += "Easy\n"
    elseif (UD_durability_damage_base >= 0.75)
        temp += "Normal\n"
    elseif (UD_durability_damage_base >= 0.3)
        temp += "Hard\n"
    elseif (UD_durability_damage_base >= 0.05)
        temp += "Very Hard\n"
    elseif UD_durability_damage_base > 0
        temp += "Extreme\n"
    else
        temp += "Impossible\n"
    endif
    
    ;if Details_CanShowHitResist()
        bool loc_showhitres = canBeCutted()
        bool loc_showstrres = canBeStruggled(loc_accesibility)
        if loc_showstrres && !loc_showhitres
            temp += "Resist: "
            temp += "P = " + Round(getModResistPhysical(0.0)*-100.0) + "/XXX %/"
            temp += "M = " + Round(getModResistMagicka(0.0)*-100.0) + " %\n"
        elseif loc_showhitres && !loc_showstrres
            temp += "Resist: "
            temp += "P = XXX/" + Round(UD_WeaponHitResist*100.0) + "%/"
            temp += "M = XXX\n"
        elseif loc_showhitres && loc_showstrres
            temp += "Resist: "
            temp += "P = " + Round(getModResistPhysical(0.0)*-100.0) + "/"+Round(UD_WeaponHitResist*100.0)+" %/"
            temp += "M = " + Round(getModResistMagicka(0.0)*-100.0) + " %\n"
        elseif loc_accesibility == 0
            temp += "Resist: Inescapable\n"
        else
            temp += "Resist: Indestructable\n"
        endif
    ;endif
    if canBeCutted()
        temp += "Cut chance: " + formatString(UD_CutChance,1) + " %\n"
    else
        temp += "Cut chance: Uncuttable\n"
    endif
    temp += "Locks: "
    if UD_Locks == 0
        temp += "None\n"
    else
        if areLocksJammed()
            temp += "!Jammed!"
        else
            int loc_acceschance = getLockAccesChance()
            if loc_acceschance > 50
                temp += "Easy to reach"
            elseif loc_acceschance > 35
                temp += "Reachable"
            elseif loc_acceschance > 15
                temp += "Hard to reach"
            elseif loc_acceschance > 0
                temp += "Very hard to reach"
            else
                temp += "Unreachable"
            endif
        endif
        
        temp += " (" + UD_CurrentLocks + "/" + UD_Locks 
        
        if UD_JammedLocks
            temp += " J=" + UD_JammedLocks + ")\n"
        else
            temp += ")\n"
        endif
        
        temp += "Locks Difficulty: "
        int loc_lockdiff = getLockLevel()
        if loc_lockdiff == 0
            temp += "Novice"
        elseif loc_lockdiff == 1
            temp += "Apprentice"
        elseif loc_lockdiff == 2
            temp += "Adept"
        elseif loc_lockdiff == 3
            temp += "Expert"
        elseif loc_lockdiff == 4
            temp += "Master"
        else
            temp += "Requires key\n"
        endif
        if loc_lockdiff < 5
            temp += " ("+UD_LockpickDifficulty+")\n"
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
        str += ("Regeneration ("+ formatString(getModifierIntParam("Regen")/24.0,1) +"/h)\n")
    endif
    if hasModifier("_HEAL")
        str += "Healer ("+  formatString(getModifierIntParam("_HEAL")/24.0,1) +"/h)\n"
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
    
    if hasModifier("_L_CHEAP")
        str += "Cheap locks (" + getModifierIntParam("_L_CHEAP",0) +" %)\n"
    endif
    
    if UD_OnDestroyItemList
        str += "Contains Items\n"
    endif    
    if hasModifier("LootGold")
        int loc_lootgold_mod = getModifierIntParam("LootGold",2,0)
        int loc_min     = getModifierIntParam("LootGold",0,10) ;base value
        if getModifierParamNum("LootGold") > 1
            int loc_max     = getModifierIntParam("LootGold",1,0) ;base value
            int loc_min2    = loc_min
            int loc_max2    = loc_max
            if loc_max2 < loc_min2
                loc_max2 = loc_min2
            endif
            float loc_lootgold_mod_param = 0.0
            if loc_lootgold_mod == 0
                ;nothink
            elseif loc_lootgold_mod == 1 ;increase % gold based on level per parameter
                loc_lootgold_mod_param  = getModifierFloatParam("LootGold",3,0.05)
                loc_min2                = Round(loc_min*(1.0 + loc_lootgold_mod_param*UD_Level))
                loc_max2                = Round(loc_max*(1.0 + loc_lootgold_mod_param*UD_Level))
            elseif loc_lootgold_mod == 2 ;increase ABS gold based on level per parameter
                loc_lootgold_mod_param  = getModifierFloatParam("LootGold",3,10.0)
                loc_min2                = Round(loc_min + (loc_lootgold_mod_param*UD_Level))
                loc_max2                = Round(loc_max + (loc_lootgold_mod_param*UD_Level))
            else    ;unused
            endif
            
            if loc_min != loc_max
                str += "Contains Gold ("+ loc_min2 +"-"+ loc_max2 +" G)\n"
            else
                str += "Contains Gold ("+ loc_max2 +" G)\n"
            endif
        else
            str += "Contains Gold ("+ loc_min +" G)\n"
        endif
    endif    

    if (isSentient())
        str += "Sentient (" + formatString(getModifierFloatParam("Sentient"),1) +" %)\n"
    Endif
    
    if (isLoose())
        str += "Loose (" + formatString(getModifierFloatParam("Loose")*100,1) +" %)\n"
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
        res += "Base DPS: " + formatString(UD_durability_damage_base,4) + " DPS\n"
        res += "DPS bonus: " + formatString(UD_durability_damage_add,2) + " DPS\n"
        res += "Total DPS: " + (_durability_damage_mod + UD_durability_damage_add)*UD_DamageMult + " DPS\n"
        res += "Total increase: " + formatString((((_durability_damage_mod + UD_durability_damage_add)*UD_DamageMult)/UD_durability_damage_base)*100 - 100.0,2) + " %\n"
    elseif cuttingGame_on
        res += "Cutting modifier: " + Round(UD_MinigameMult1*100.0) + " %\n"
    else
        res += "No DPS\n"
    endif
    res += "Condition dmg increase: " + Round(_condition_mult_add*100) + " %\n"
    res += "Crits: " + UD_minigame_canCrit + "\n"
    if UD_drain_stats
        if UD_minigame_stamina_drain
            res += "Stamina SPS: " + formatString(UD_minigame_stamina_drain,2) + "\n"
        endif
        if UD_minigame_heal_drain
            res += "Health SPS: " + formatString(UD_minigame_heal_drain,2) + "\n"
        endif
        if UD_minigame_magicka_drain
            res += "Magicka SPS: " + formatString(UD_minigame_magicka_drain,2) + "\n"    
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
    ShowMessageBox(res)
EndFunction

Function showRawModifiers()
    int i = 0
    string res = "-RAW MODIFIERS-\n"
    while i < UD_Modifiers.length
        res += UD_Modifiers[i] + "\n"
        i += 1
    endwhile
    ShowMessageBox(res)
EndFunction

Function showDebugInfo()
    ShowMessageBox(getDebugString())
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
        res += "Lock jamm chance: "+ zad_JammLockChance + " (" + Round(checkLimit(zad_JammLockChance*UDCDmain.CalculateKeyModifier(),100.0)) +") %\n"
    endif
    if isNotShareActive(); && canBeActivated()
        res += "Cooldown: "+ _currentRndCooldown +" min\n"
        res += "Elapsed time: "+ formatString(_updateTimePassed,3) +" min ("+ formatString(getRelativeElapsedCooldownTime()*100,1) +" %)\n"
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
            res += "Mend rate: "+ regen +" ("+formatString(regen/24.0,1)+" per hour)\n"
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
    res += "Crit: " + formatString(UD_StruggleCritMul,1) + " x\n"
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

;adds struggle debuff to Wearer and Helper
Function addStruggleExhaustion(Actor akWearer, Actor akHelper)
    if UD_applyExhastionEffect
        UDlibs.StruggleExhaustionSpell.SetNthEffectMagnitude(0, UDCDmain.UD_StruggleExhaustionMagnitude*Utility.randomFloat(0.75,1.25))
        UDlibs.StruggleExhaustionSpell.SetNthEffectDuration(0, Round(UDCDmain.UD_StruggleExhaustionDuration*_exhaustion_mult*Utility.randomFloat(0.75,1.25)))
        UDlibs.StruggleExhaustionSpell.cast(akWearer)
    endif
    if akHelper && UD_applyExhastionEffectHelper
        UDCDmain.ResetHelperCD(akHelper,akWearer,UDCDmain.UD_MinigameHelpXPBase)
        UDlibs.StruggleExhaustionSpell.SetNthEffectMagnitude(0, UDCDmain.UD_StruggleExhaustionMagnitude*Utility.randomFloat(0.75,1.25))
        UDlibs.StruggleExhaustionSpell.SetNthEffectDuration(0, Round(UDCDmain.UD_StruggleExhaustionDuration*_exhaustion_mult_helper*Utility.randomFloat(0.75,1.25)))
        UDlibs.StruggleExhaustionSpell.cast(akHelper)
    endif
EndFunction

;cut device by progress_add
Function cutDevice(float progress_add = 1.0)
    _CuttingProgress += progress_add*UDCDmain.getStruggleDifficultyModifier()*UD_MinigameMult1
    if _CuttingProgress >= 100.0
        ;only show message fo NPC, as player can see progress progress on widget
        if cuttingGame_on
            if !PlayerInMinigame() && UDCDmain.AllowNPCMessage(getWearer())
                UDCDmain.Print(getWearerName() + " managed to cut "+getDeviceName()+" and reduce durability by big amount!",3)
            endif
        else
            if !PlayerInMinigame() && UDCDmain.AllowNPCMessage(getWearer())
                UDCDmain.Print(getWearerName() + "s "+ getDeviceName() +" is cutted!",3)
            endif
        endif
        
        float cond_dmg = 40.0*UDCDmain.getStruggleDifficultyModifier()*(1.0 + _condition_mult_add)
        _total_durability_drain += cond_dmg
        updateCondition()
        decreaseDurabilityAndCheckUnlock(UD_DamageMult*cond_dmg*getModResistPhysical(1.0,0.25)/7.0,0.0)
        _CuttingProgress = 0.0
        if UDmain.TraceAllowed()        
            UDCDmain.Log(getDeviceHeader() + " is cutted for " + cond_dmg + "C ( " + (UD_DamageMult*cond_dmg*getModResistPhysical(1.0,0.25)/7.0) + " D) (Wearer: " + getWearerName() + ")",1)
        endif
        OnDeviceCutted()
    endif
EndFunction

;repair lock by progress_add
Function repairLock(float progress_add = 1.0)
    Float loc_RepairProgress = _RepairProgress
    loc_RepairProgress += progress_add*UDCDmain.getStruggleDifficultyModifier()
    bool loc_repaired = false
    while loc_RepairProgress >= getLockDurability()
        loc_repaired = true
        loc_RepairProgress -= getLockDurability()
        UD_JammedLocks  -= 1
        if UD_JammedLocks == 0
            libs.UnJamLock(Wearer,UD_DeviceKeyword)
            repairLocksMinigame_on = False
            stopMinigame()
            loc_RepairProgress = 0.0
        endif
    endwhile
    _RepairProgress = loc_RepairProgress
    if loc_repaired
        if WearerIsPlayer()
            UDmain.Print("You repaired one or more locks! " + UD_JammedLocks + "/" + UD_CurrentLocks + " locks remaining",1)
        elseif UDCDmain.AllowNPCMessage(GetWearer())
            UDmain.Print(GetWearerName() + " managed to repair one or more of the "+ getDeviceName() +" locks!",2)
        endif
    endif
EndFunction

;starts vannila lockpick minigame if lock is reached
Function lockpickDevice()
    if lockpickGame_on && (UD_CurrentLocks - UD_JammedLocks > 0)
        int result = 0
        if PlayerInMinigame()
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
            float loc_maxtime = 20.0 - (UD_LockpickDifficulty/100.0)*10.0
            bool loc_msgshown = false
            while (!UDCDmain.LockpickMinigameOver) && loc_elapsedTime <= loc_maxtime
                Utility.WaitMenuMode(0.05)
                loc_elapsedTime += 0.05
                
                if !loc_msgshown && loc_elapsedTime > loc_maxtime*0.75 ;only 25% time left, warn player
                    if Utility.randomInt(0,1)
                        UDmain.Print("Your hands are sweating")
                    else
                        UDmain.Print("Your hands starts to trembl")
                    endif
                    loc_msgshown = true
                endif
            endwhile
        
            result = UDCDmain.lockpickMinigameResult     ;first we fetch lockpicking result
            UDCDmain.DeleteLockPickContainer()            ;then we remove the container so IsLocked is not called on None
            
            if loc_elapsedTime >= loc_maxtime
                if UDmain.IsLockpickingMenuOpen()
                    closeLockpickMenu()
                endif
                UDCDmain.Print("You lost the focus and broke the lockpick!")
                result = 2
                getWearer().removeItem(UDCDmain.Lockpick,1)
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
            if Utility.randomInt(1,99) >= getLockLevel()*15
                result = 1
            else
                result = 2
                Wearer.RemoveItem(UDCDmain.Lockpick, 1, True)
            endif
        endif
        if UDmain.TraceAllowed()
            UDmain.Log("Lockpick minigame result for " + getWearerName() + ": " + result,2)
        endif
        if result == 0
                stopMinigame()
                lockpickGame_on = False
        elseif result == 1 ;succes
            if UD_CurrentLocks - UD_JammedLocks > 0
                UD_CurrentLocks -= 1
                if PlayerInMinigame()
                    UDCDmain.Print("You succesfully unlocked one of the locks! " + UD_CurrentLocks + "/" + UD_Locks + " remaining",1)
                elseif UDCDmain.AllowNPCMessage(getWearer())
                    UDCDmain.Print(getWearerName() + " unlocked one of the locks! " + UD_CurrentLocks + "/" + UD_Locks + " remaining",2)
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
                if PlayerInMinigame()
                    UDCDmain.Print("Your lockpick jammed the lock!",1)
                elseif UDCDmain.AllowNPCMessage(getWearer())
                    UDCDmain.Print(getWearerName() + "s "+getDeviceName()+" lock gets jammed!",3)
                endif
                
                UD_JammedLocks += 1
                JammLocks()
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
    if UD_CurrentLocks - UD_JammedLocks > 0
        UD_CurrentLocks -= 1
        if PlayerInMinigame()
            UDCDMain.Print("You managed to unlock one of the locks! " + UD_CurrentLocks + "/" + UD_Locks + " remaining",1)
        elseif UDCDmain.AllowNPCMessage(getWearer())
            UDCDMain.Print(getWearerName() + " managed to unlock one of the locks! " + UD_CurrentLocks + "/" + UD_Locks + " remaining",2)
        endif
        
        if zad_DestroyKey; || libs.Config.GlobalDestroyKey
            Wearer.RemoveItem(zad_deviceKey)
            if !Wearer.getItemCount(zad_deviceKey)
                stopMinigame()
                keyGame_on = False
            endif
        endif
        
        onLockUnlocked(false)
    endif
    
    if UD_CurrentLocks == 0 && UD_JammedLocks == 0
        unlockRestrain()
        stopMinigame()
        keyGame_on = False
        OnDeviceUnlockedWithKey()
    endif
    
    if UD_CurrentLocks == UD_JammedLocks ;no more unjammed locks
        stopMinigame()
        keyGame_on = False
        return
    endif
EndFunction

Function AddJammedLock(int iChance = 5, string strMsg = "", int iNumber = 1)
    if !libs.Config.DisableLockJam
        if Utility.randomInt(1,99) >= iChance
            return
        endif
        UD_JammedLocks += iNumber
        
        if UD_JammedLocks > UD_CurrentLocks
            UD_JammedLocks = UD_CurrentLocks
        endif
        
        JammLocks()
        
        if strMsg != ""
            UDCDmain.Print(strMsg,2)
        endif
        
        OnLockJammed()
    endif
EndFunction

Function JammLocks()
    libs.SendDeviceJamLockEventVerbose(deviceInventory, UD_DeviceKeyword, wearer)
    StorageUtil.SetIntValue(wearer, "zad_Equipped" + libs.LookupDeviceType(UD_DeviceKeyword) + "_LockJammedStatus", 1)
EndFunction

bool Function areLocksJammed()
    return UD_JammedLocks == UD_CurrentLocks
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
        if Round(getModifierFloatParam("Sentient")*mult) > Utility.randomInt(1,99)
            if UDmain.TraceAllowed()            
                UDCDmain.Log("Sentient device activation of : " + getDeviceHeader())
            endif
            UDCDmain.activateDevice(self)
        endif
    endif
EndFunction

;function called when wearer is hit by source weapon
Function weaponHit(Weapon source)
    if UDmain.TraceAllowed()    
        UDCDmain.Log(getDeviceHeader()+ " hit by "+source.getName()+"(" +source+ ") event received, damage: " + source.getBaseDamage(),3)
    endif
    if onWeaponHitPre(source)
        onWeaponHitPost(source)
    endif
EndFunction

;function called when wearer is hit by source spell
Function spellHit(Spell source)
    if UDmain.TraceAllowed()    
        UDCDmain.Log("Device " + DeviceInventory.getName() + " hit by "+source+" event received",3)
    endif
    if onSpellHitPre(source)
        onSpellHitPost(source)
    endif
EndFunction

bool Function CooldownActivate()
    if OnCooldownActivatePre()
        if UDmain.TraceAllowed()        
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

bool Function isNotShareActive()
    return UD_ActiveEffectName != "Share" && UD_ActiveEffectName != "none" && UD_ActiveEffectName != ""
EndFunction

Function ValidateJammedLocks()
    if UD_JammedLocks && UD_CurrentLocks
        if !libs.IsLockJammed(getWearer(), UD_DeviceKeyword)
            UDmain.CLog(getDeviceHeader() + " is unjammed but have jammed locks. Unjamming")
            UD_JammedLocks = 0
        endif
    endif
EndFunction

Function AddAbility(Spell akAbility,Int aiFlag)
    if akAbility && PapyrusUtil.CountForm(UD_DeviceAbilities,akAbility) == 0
        UD_DeviceAbilities = PapyrusUtil.PushForm(UD_DeviceAbilities,akAbility)
        UD_DeviceAbilities_Flags = PapyrusUtil.PushInt(UD_DeviceAbilities_Flags,aiFlag)
    endif
EndFunction

Bool Function AddAbilityToWearer(Int aiIndex)
    if aiIndex < 0 || aiIndex >= UD_DeviceAbilities.length
        return False
    endif
    if !Wearer.HasSpell(UD_DeviceAbilities[aiIndex] as Spell)
        Wearer.AddSpell(UD_DeviceAbilities[aiIndex] as Spell)
    else
        return false
    endif
EndFunction

Int Function RemoveAllAbilities(Actor akActor)
    int loc_abilityId = UD_DeviceAbilities.length
    while loc_abilityId
        loc_abilityId -= 1
        akActor.RemoveSpell(UD_DeviceAbilities[loc_abilityId] as Spell)
    endwhile
EndFunction

;--------------------------------------------------   
;  ______      ________ _____  _____ _____  ______ 
; / __ \ \    / /  ____|  __ \|_   _|  __ \|  ____|
;| |  | \ \  / /| |__  | |__) | | | | |  | | |__   
;| |  | |\ \/ / |  __| |  _  /  | | | |  | |  __|  
;| |__| | \  /  | |____| | \ \ _| |_| |__| | |____ 
; \____/   \/   |______|_|  \_\_____|_____/|______|
;--------------------------------------------------                                                  
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
Function activateDevice()
    if UDmain.TraceAllowed()    
        UDCDmain.Log("Device " + DeviceInventory.getName() + " (W: " + getWearerName() + ") activated",1)
    endif
    resetCooldown()
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
EndFunction

Function OnMinigameOrgasmPost()
EndFunction

Function OnOrgasmPost(bool sexlab = false)
EndFunction

bool Function OnEdgePre()
    return True
EndFunction

Function OnMinigameEdge()
    if UDmain.TraceAllowed()    
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
    if hasHelper()
        ;1 hour cooldown
        ;UDCDMain.ResetHelperCD(GetHelper(),GetWearer(),UDCDmain.UD_MinigameHelpXPBase)
    endif
    
    if isSentient() && getRelativeDurability() > 0.0
        if Utility.randomInt() > 75 && WearerIsPlayer()
            startSentientDialogue(0)
        endif
    endif
EndFunction

;make it lightweight
Function OnMinigameTick(float afUpdateTime)

EndFunction

Function OnMinigameTick1()
    if getStruggleMinigameSubType() == 1
        UD_DamageMult = getAccesibility()*getModResistPhysical(1.0,0.1) + (1.0 - getRelativeDurability())
        ;if isLoose() && !wearerFreeHands()
        ;    UD_DamageMult *= getLooseMod()
        ;endif
    endif
EndFunction

Function OnMinigameTick3()
EndFunction

Function OnCritFailure()
    checkSentient(0.25)
EndFunction

float Function getAccesibility()
    float loc_res = 1.0
    if !isHeavyBondage()
        if (!WearerFreeHands() && !HelperFreeHands())
            if isLoose()
                loc_res = getLooseMod()
            else
                loc_res = 0.0
            endif
        elseif !isMittens()
            if WearerHaveMittens() && (!HasHelper() || HelperHaveMittens())
                loc_res = 0.5
            else
                loc_res = 1.0
            endif
        endif
    endif
    return loc_res
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
;use this only in case of using some kind of long function (like vibrate() function or something similiar, which could delate the initiation of device)
Function InitPostPost()
EndFunction

Function OnRemoveDevicePre(Actor akActor)
EndFunction

Function onRemoveDevicePost(Actor akActor)
EndFunction

Function onLockUnlocked(bool lockpick = false)
EndFunction

Function onSpecialButtonPressed(float fMult)
EndFunction

Function onSpecialButtonReleased(Float fHoldTime)
EndFunction

bool Function onWeaponHitPre(Weapon source)
    return true;UDCDmain.isSharp(source)
EndFunction

Function onWeaponHitPost(Weapon source)
    if !isUnlocked && canBeCutted()
        float loc_damage = 0.0
        if !source.getBaseDamage()
            loc_damage = 5.0
        endif
        decreaseDurabilityAndCheckUnlock(loc_damage*0.25*(1.0 - UD_WeaponHitResist),2.0)
        
        if HaveUnlockableLocks()
            if hasModifier("_L_CHEAP")
                int loc_chance = Round(getModifierIntParam("_L_CHEAP",0)*0.1)
                AddJammedLock(loc_chance)
            endif
        endif
    endif
EndFunction

bool Function onSpellHitPre(Spell source)
    return false ;currently unused
EndFunction

Function onSpellHitPost(Spell source)
    if !isUnlocked; && getModResistMagicka(1.0,0.25) != 1.0
    endif
EndFunction

;adds bonus string to base detail string
string Function addInfoString(string str = "")
    return str
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

bool Function proccesSpecialMenu(int msgChoice)
    return false
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
    return false
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

Float[] Function GetCurrentMinigameExpression()
    if struggleGame_on
        if _struggleGame_Subtype == 1 ;desperate
            return UDmain.UDEM.GetPrebuildExpression_Angry1()
        elseif _struggleGame_Subtype == 2 ;magick
            return UDmain.UDEM.GetPrebuildExpression_Concetrated1()
        elseif _struggleGame_Subtype == 3 ;slow
            return UDmain.UDEM.GetPrebuildExpression_Happy1()
        else
            return UDmain.UDEM.CreateRandomExpression(bExport = false)
        endif
    else
        if Utility.randomInt(0,1)
            return UDmain.UDEM.CreateRandomExpression(bExport = false)
        else
            return UDmain.UDEM.GetPrebuildExpression_Happy1()
        endif
    endif
EndFunction

;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------

State UpdatePaused
    Function Update(float timePassed)
        _updateTimePassed += (timePassed*24.0*60.0);*UDCDmain.UD_CooldownMultiplier
    EndFunction
    
    Function updateMend(float timePassed)
    EndFunction
    
    Function UpdateHour(float mult)
    EndFunction
EndState

;UTILITY functions NEEDED because the functions are used before UDmain are loaded
;mainly used in initiation of properties, which load before UDCDmain (if its not filled)

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

bool _bitmap_mutex2 = false ;DON'T MODIFY
Function startBitMapMutexCheck2()
    while _bitmap_mutex2
        Utility.waitmenumode(0.01)
    endwhile
    _bitmap_mutex2 = true
EndFunction
Function endBitMapMutexCheck2()
    _bitmap_mutex2 = false
EndFunction

bool _bitmap_mutex3 = false ;DON'T MODIFY
Function startBitMapMutexCheck3()
    while _bitmap_mutex3
        Utility.waitmenumode(0.01)
    endwhile
    _bitmap_mutex3 = true
EndFunction
Function endBitMapMutexCheck3()
    _bitmap_mutex3 = false
EndFunction