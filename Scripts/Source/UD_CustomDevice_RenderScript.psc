Scriptname UD_CustomDevice_RenderScript extends ObjectReference  
import UnforgivingDevicesMain
import UD_NPCInteligence
;bit maps used to code simple values to reduce memory size of script

; === _deviceControlBitMap_1 ===
;00 = 1b, _StruggleGameON
;01 = 1b, _LockpickGameON
;02 = 1b, _CuttingGameON
;03 = 1b, _KeyGameON
;04 = 1b, _RepairLocksMinigameON
;05 = 1b, UNUSED
;06 = 1b, UNUSED
;07 = 1b, _critLoop_On
;08 = 1b, UNUSED
;09 = 1b, UD_drain_stats
;10 = 1b, UD_drain_stats_helper
;11 = 1b, UD_damage_device
;12 = 1b, UD_applyExhastionEffect
;13 = 1b, UD_applyExhastionEffectHelper
;14 = 1b, UD_minigame_canCrit
;15 = 1b, UD_useWidget
;16 = 1b, UD_WidgetAutoColor
;17 = 1b, Ready
;18 = 1b, zad_DestroyOnRemove
;19 = 1b, zad_DestroyKey
;20 = 1b, UNUSED
;21 = 1b, _MinigameON
;22 = 1b, _MinigameParProc_4
;23 = 1b, _removeDeviceCalled
;24 = 1b, UD_minigame_critRegen
;25 = 1b, UD_minigame_critRegen_helper
;26 = 1b, _isRemoved
;27 = 1b, _MinigameParProc_2
;28 = 1b, _MinigameParProc_1
;29 = 1b, _usingTelekinesis
;30 = 1b, _MinigameParProc_3
;31 = 1b, UD_AllowWidgetUpdate
int _deviceControlBitMap_1 = 0x00000000 ;BOOL -FULL (mutex2)

; === _deviceControlBitMap_2 ===
int _deviceControlBitMap_2 = 0x00000000 ;FLOAT-FULL (mutex1)

; === _deviceControlBitMap_3 ===
int _deviceControlBitMap_3 = 0x00000000 ;FLOAT-FULL (mutex1)

; === _deviceControlBitMap_4 ===
int _deviceControlBitMap_4 = 0x00000000 ;FLOAT-FULL (mutex1)

; === _deviceControlBitMap_5 ===
int _deviceControlBitMap_5 = 0x00000000 ;INT (mutex1)

; === _deviceControlBitMap_6 === (mutex1)
;00 - 06 =  7b (0000 0000 0000 0000 0000 0000 0XXX XXXX)(0x007F), UD_StruggleCritChance
;07 - 14 =  8b (0000 0000 0000 0000 0XXX XXXX X000 0000)(0x00FF), UNUSED
;15 - 19 =  5b (0000 0000 0000 XXXX X000 0000 0000 0000)(0x003F), UD_Locks
;20 - 26 =  7b (0000 0XXX XXXX 0000 0000 0000 0000 0000)(0x007F), UD_CutChance
;27 - 31 =  5b (XXXX X000 0000 0000 0000 0000 0000 0000)(0x001F), UD_base_stat_drain
int _deviceControlBitMap_6 = 0x4000008F 

; === _deviceControlBitMap_7 === (mutex1)
;00 - 11 = 12b (0000 0000 0000 0000 0000 XXXX XXXX XXXX)(0x0FFF), UD_durability_damage_base
;12 - 21 = 10b (0000 0000 00XX XXXX XXXX 0000 0000 0000)(0x03FF), UD_ResistMagicka
;22 - 24 =  3b (0000 000X XX00 0000 0000 0000 0000 0000)(0x0007), !UNUSED!
;25 - 27 =  3b (0000 XXX0 0000 0000 0000 0000 0000 0000)(0x0007), _struggleGame_Subtype
;28 - 30 =  3b (0XXX 0000 0000 0000 0000 0000 0000 0000)(0x0007), _struggleGame_Subtype_NPC
;31 - 31 =  1b (X000 0000 0000 0000 0000 0000 0000 0000)(0x0001), !UNUSED!
int _deviceControlBitMap_7 = 0x001F4064

; === _deviceControlBitMap_8 === (mutex1)
;00 - 06 =  7b (0000 0000 0000 0000 0000 0000 0XXX XXXX)(0x007F), UD_RegenMagHelper_Stamina
;07 - 13 =  7b (0000 0000 0000 0000 00XX XXXX X000 0000)(0x007F), UD_RegenMagHelper_Health
;14 - 20 =  7b (0000 0000 000X XXXX XX00 0000 0000 0000)(0x007F), UD_RegenMagHelper_Magicka
;21 - 27 =  7b (0000 XXXX XXX0 0000 0000 0000 0000 0000)(0x007F), _customMinigameCritChance
;28 - 31 =  4b (XXXX 0000 0000 0000 0000 0000 0000 0000)(0x000F), !UNUSED!
int _deviceControlBitMap_8 = 0x00000000

; === _deviceControlBitMap_9 === (mutex1)
;00 - 06 =  7b (0000 0000 0000 0000 0000 0000 0XXX XXXX)(0x007F), _customMinigameCritDuration
;07 - 18 = 12b (0000 0000 0000 0XXX XXXX XXXX X000 0000)(0x0FFF), _customMinigameCritMult
;19 - 25 =  7b (0000 00XX XXXX X000 0000 0000 0000 0000)(0x007F), _minMinigameStatHP
;26 - 31 =  6b (XXXX XX00 0000 0000 0000 0000 0000 0000)(0x003F), !UNUSED!
int _deviceControlBitMap_9 = 0x00000000

; === _deviceControlBitMap_10 === (mutex3)
;00 - 06 =  7b (0000 0000 0000 0000 0000 0000 0XXX XXXX)(0x007F), _minMinigameStatMP
;07 - 13 =  7b (0000 0000 0000 0000 00XX XXXX X000 0000)(0x007F), _minMinigameStatSP
;14 - 21 =  8b (0000 0000 00XX XXXX XX00 0000 0000 0000)(0x00FF), _condition_mult_add
;22 - 29 =  8b (00XX XXXX XX00 0000 0000 0000 0000 0000)(0x00FF), _exhaustion_mult
;30 - 31 =  2b (XX00 0000 0000 0000 0000 0000 0000 0000)(0x0003), !UNUSED!
int _deviceControlBitMap_10 = 0x00000000

; === _deviceControlBitMap_11 === (mutex3)
;00 - 09 = 10b (0000 0000 0000 0000 0000 000X XXXX XXXX)(0x03FF), UD_WeaponHitResist
;10 - 19 = 10b (0000 0000 0000 XXXX XXXX XXXX 0000 0000)(0x03FF), UD_SpellHitResist
;20 - 29 = 10b (00XX XXXX XXXX 0000 0000 0000 0000 0000)(0x03FF), UD_ResistPhysical
;30 - 31 =  2b (XX00 0000 0000 0000 0000 0000 0000 0000)(0x0003), !UNUSED!
int _deviceControlBitMap_11 = 0x1F4FFFFF

; === _deviceControlBitMap_12 === (mutex3)
;00 - 07 =  8b (0000 0000 0000 0000 0000 0000 XXXX XXXX)(0x00FF), _exhaustion_mult_helper
;15 - 24 = 10b (0000 000X XXXX XXXX X000 0000 0000 0000)(0x03FF), UD_StruggleCritMul, defualt value 4x (0x0F)
;25 - 27 =  3b (0000 XXX0 0000 0000 0000 0000 0000 0000)(0x0007), UD_StruggleCritDuration, default value 1s (0x5)
;X  -  X =  Xb (XXXX 0000 0000 0000 0XXX XXXX 0000 0000)(0x000F), !UNUSED!
int _deviceControlBitMap_12 = 0x0A078000

; === _deviceControlBitMap_13 === (mutex3)
;00 - 11 = 12b (0000 0000 0000 0000 0000 XXXX XXXX XXXX)(0x0000 0FFF), _CuttingProgress
;12 - 31 =  8b (XXXX XXXX XXXX XXXX XXXX 0000 0000 0000)(0xFFFF F000), !UNUSED!
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

;--------------------------------PUBLIC PROPERTIES----------------------------
;-------------------------------------------------------
;-------!!!!!!!!!!!!ALWAYS FILL!!!!!!!!!!!!!!!----------
Armor       Property DeviceInventory                auto    ;device inventory
zadlibs     Property libs                           auto
;---------------------OPTIONAL--------------------------
Key         Property zad_deviceKey                  auto
Keyword     Property UD_DeviceKeyword_Minor                 ;minor keyword of this device. Currently only used for HB
    Keyword Function get()
        if _DeviceKeyword_Minor
            return _DeviceKeyword_Minor
        else
            if UD_DeviceKeyword == libs.zad_deviousHeavyBondage
                _DeviceKeyword_Minor = UDCDmain.GetHeavyBondageKeyword(deviceRendered)
                if !_DeviceKeyword_Minor
                    UDmain.Error("UD_DeviceKeyword_Minor - Could not find minor keyword!")
                endif
            elseif UD_DeviceKeyword == libs.zad_deviousHobbleSkirt
                if DeviceRendered.HasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)
                    _DeviceKeyword_Minor = libs.zad_DeviousHobbleSkirtRelaxed
                else
                    _DeviceKeyword_Minor = libs.zad_deviousHobbleSkirt
                endif
            else
                _DeviceKeyword_Minor = UD_DeviceKeyword
            endif
            return _DeviceKeyword_Minor
        endif
    EndFunction
    Function set(Keyword akKeyword)
        if akKeyword
            _DeviceKeyword_Minor = akKeyword
        endif
    EndFunction
EndProperty

;MAIN VALUES
Int         Property UD_Level                                               ;Device level
    int Function get()
        return _level
    EndFunction
    Function set(int aiValue)
        _level = iRange(aiValue,-10,1000)
        ;reset vars
        current_device_health = UD_Health
    EndFunction
EndProperty
float       Property UD_durability_damage_base                              ;durability dmg per second of struggling, range 0.00 - 40.00, precision 0.01 (4000 values)
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_7 = codeBit(_deviceControlBitMap_7,Round(fRange(fVal,0.0,40.0)*100),12,0)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_7,12,0)/100.0
    EndFunction
EndProperty
float       Property UD_base_stat_drain                                     ;stamina drain for second of struggling, range 1 - 31, decimal point not used
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_6 = codeBit(_deviceControlBitMap_6,Round(fRange(fVal,1.0,31.0)),5,27)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_6,5,27)
    EndFunction
EndProperty
float       Property UD_ResistMagicka                                       ;magicka resistence. Needs to be applied to minigame to work!
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_7 = codeBit(_deviceControlBitMap_7,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,12)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return (decodeBit(_deviceControlBitMap_7,10,12)/100.0) - 5.0
    EndFunction
EndProperty
float       Property UD_ResistPhysical                                      ;physical resistence. Needs to be applied to minigame to work!
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_11 = codeBit(_deviceControlBitMap_11,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,20)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return (decodeBit(_deviceControlBitMap_11,10,20)/100.0) - 5.0
    EndFunction
EndProperty
float       Property UD_WeaponHitResist                                     ;physical resistence to physical attack
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_11 = codeBit(_deviceControlBitMap_11,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,0)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return (decodeBit(_deviceControlBitMap_11,10,0)/100.0) - 5.0
    EndFunction
EndProperty
float       Property UD_SpellHitResist                                      ;!!!UNUSED!!!
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_11 = codeBit(_deviceControlBitMap_11,Round(fRange(5.0 + fVal,0.0,10.0)*100),10,10)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return (decodeBit(_deviceControlBitMap_11,10,10)/100.0) - 5.0
    EndFunction
EndProperty
float       Property UD_CutChance                                           ;chance of cutting device every 1s of minigame, 0.0 is uncuttable
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_6 = codeBit(_deviceControlBitMap_6,Round(fRange(fVal,0.0,100.0)),7,20)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_6,7,20)
    EndFunction
EndProperty
float       Property UD_StruggleCritMul                                     ;crit multiplier applied on crit, step = 0.25, max 255, default 3.75x
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_12 = codeBit(_deviceControlBitMap_12,Round(fRange(fVal,0.0,255.0)*4),10,15)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_12,10,15)/4.0
    EndFunction
EndProperty
float       Property UD_StruggleCritDuration                                ;crit time, the lower this value, the more faster player needs to press button, range 0.5-1.2, step 0.1 (7 values)
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_12 = codeBit(_deviceControlBitMap_12,Round((fRange(fVal,0.5,1.2) - 0.5)*10),3,25)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_12,3,25)/10.0 + 0.5
    EndFunction
EndProperty
int         Property UD_StruggleCritChance                                  ;chance of random crit happening once per second of struggling, range 0-100
    Function set(int iVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_6 = codeBit(_deviceControlBitMap_6,iRange(iVal,0,100),7,0)
        endBitMapMutexCheck()
    EndFunction
    
    int Function get()
        return decodeBit(_deviceControlBitMap_6,7,0)
    EndFunction
EndProperty

int         Property UD_Cooldown                    = 0             auto    ;Device cooldown, in minutes. Device will activate itself on after this time (if it can), zero or negative value will disable this feature
Float       Property UD_DefaultHealth               = 100.0         auto    ;default max device durability on first level, for now always 100
string[]    Property UD_Modifiers                                   auto    ;modifiers
Message     Property UD_MessageDeviceInteraction                    auto    ;messagebox that is shown when player click on device in inventory
Message     Property UD_MessageDeviceInteractionWH                  auto    ;messagebox that is shown when player click on device in NPC inventory
Message     Property UD_SpecialMenuInteraction                      auto    ;messagebox that is shown when player select Special from device menu
Message     Property UD_SpecialMenuInteractionWH                    auto    ;messagebox that is shown when player select Special from device menu when helping/getting help
LeveledItem Property UD_OnDestroyItemList                           auto    ;items received when device is unlocked (only when device have DestroyOnRemove)
Form[]      Property UD_DeviceAbilities                             auto    ;array of abilities which are added on actor when device is equipped

;array of flags for abilities which are added on actor when device is equipped
;00 - 01    = 02b (0000 0000 0000 0000 0000 0000 0000 00XX)(0x0003), ;Should device ability be added when device is locked ?
;               = 00  -> Ability will be added for all NPCs and Player
;               = 01  -> Ability will be added only for NPC
;               = 10  -> Ability will be added only for Player
;               = 11  -> Ability will be not added on when device is locked
;02 - 31    = 30b (XXXX XXXX XXXX XXXX XXXX XXXX XXXX XX00)(0xFFFFFFFC), ;Unused
Int[]       Property UD_DeviceAbilities_Flags                       auto

;Array of bit mapped locks.
; 0 -  3 =  4b (0000 0000 0000 0000 0000 0000 0000 XXXX)(0x0000000F), State of lock
;                                                                       000X = 1 when lock is unlocked, 0 when locked
;                                                                       00X0 = 1 when lock is jammed, 0 when not
;                                                                       0X00 = 1 when lock is using time lock
;                                                                       X000 = 1 when locks time lock will auto unlock lock, or 0 to just allow user to manipulate the device after the time passes 
;                                                                              (so if the time is 2 hours, the user will not be able to manipulate the lock for 2 hours. If this is 1, it will unlock itself after this time. If its 0, it will just allow wearer to manipulate the lock)
; 4 -  7 =  4b (0000 0000 0000 0000 0000 0000 XXXX 0000)(0x000000F0), Numbe of locks shields (how many times needs to lock to be unlocked before being "removed")
; 8 - 14 =  7b (0000 0000 0000 0000 0XXX XXXX 0000 0000)(0x00007F00), Lock accessibility (in %, should be from 0 to 100)
;15 - 22 =  8b (0000 0000 0XXX XXXX X000 0000 0000 0000)(0x007F8000), Locks difficulty (from 0 to 255)
;23 - 29 =  7b (00XX XXXX X000 0000 0000 0000 0000 0000)(0x3F800000), Lock time in hours. Every hour, this value gets reduced by 1. When reduced to 0, will unlock the lock
;30 - 31 =  2b (XX00 0000 0000 0000 0000 0000 0000 0000)(0xC0000000), Unused, can be used by creators for special use
Int[]       Property UD_LockList                                    auto

;Name of the locks. Needs to correspond to the same locks in the UD_LockList. IF not used, the name will be generated from difficulty and accessiblity
String[]    Property UD_LockNameList                                auto

; === READ ONLY VARIABLES ===
bool        Property IsUnlocked                                     Hidden
    Function set(bool bVal)
        ;can't be changed externally
    EndFunction
    bool Function get()
        return _IsUnlocked
    EndFunction
EndProperty
Float       Property UD_Health                                      Hidden ;default max health. Is increased with device LVL. Every level increase health by 2.5%
    Float Function get()
        return UD_DefaultHealth + (UD_Level - 1)*UDCDmain.UD_DeviceLvlHealth*UD_DefaultHealth
    EndFunction
EndProperty
int         Property UD_Locks                                       Hidden ;number of locks
    int Function get()
        return GetLockNumber()
    EndFunction
EndProperty
int         Property UD_JammedLocks                                 Hidden ;jammed locks, max is 31
    int Function get()
        return GetJammedLocks()
    EndFunction
endproperty

;------------LOCAL VARIABLES-------------------
;libs, filled automatically
UnforgivingDevicesMain  _udmain                                          ;Local variable for UDmain. Filled only once
Quest                   _udquest                                         ;kept for possible future optimization
UDCustomDeviceMain      _udcdmain                                        ;Local variable for UDCDmain. Filled only once
Keyword                 _DeviceKeyword_Minor        = none
Actor                   Wearer                      = none               ;current device wearer reference
Actor                   _minigameHelper             = none               ;current device helper. Is filled the moment the device menu is open
bool                    _IsUnlocked                 = false
int                     _level                      = 1                  ;local variable for device level
int                     _currentRndCooldown         = 0                  ;currently used cooldown time
float                   current_device_health       = 0.0                ;current device durability, if this reaches 0, player will escape restrain
float                   _total_durability_drain     = 0.0                ;how much durability was reduced, aka condition
float                   _durability_damage_mod      = 0.0                ;durability dmg after applied difficulty, dont change this! Use updateDifficulty() if you want to update it
float                   _updateTimePassed           = 0.0                ;time passed from last update in days
Float[]                 _LockRepairProgress
Int                     _MinigameSelectedLockID     = -1

; Local Minigame variables
float                   UD_DamageMult               = 1.0                ;multiplies the effectiveness of minigame
float                   UD_MinigameMult1            = 1.0                ;additional multiplier for other minigames effectiveness
float                   UD_MinigameMult2            = 1.0                ;additional multiplier for other minigames effectiveness
float                   UD_MinigameMult3            = 1.0                ;additional multiplier for other minigames effectiveness
float                   UD_durability_damage_add    = 0.0                ;adds flat value to durability dmg. Is added beffor UD_DamageMult is applied
; int                     UD_WidgetColor              = 0x0000FF           ;minigame widget color
; int                     UD_WidgetColor2             = -1                 ;minigame widget color 2
; int                     UD_WidgetFlashColor         = -1                 ;minigame widget flash color

;Local animation variables
; TODO: keep the cache alive as long as the actor constraints don't change
String[]                _StruggleAnimationDefPairArray
String[]                _StruggleAnimationDefActorArray
String[]                _StruggleAnimationDefHelperArray
Int                     _StruggleAnimationDefPairLastIndex      = -1
Int                     _StruggleAnimationDefActorLastIndex     = -1
Int                     _StruggleAnimationDefHelperLastIndex    = -1
Int                     _PlayerLastConstraints                  = 0
Int                     _HelperLastConstraints                  = 0
Int[]                   _ActorsConstraints

;---------------------------------------PRIVATE PROPERTIES----------------------------------------
UnforgivingDevicesMain      Property UDmain     hidden ;main libs
    UnforgivingDevicesMain Function get()
        if !_udmain
            _udquest = Game.getFormFromFile(0x00005901,"UnforgivingDevices.esp") as Quest
            _udmain = _udquest as UnforgivingDevicesMain
        endif
        return _udmain
    EndFunction
    Function set(UnforgivingDevicesMain akForm)
        _udmain = akForm
    EndFunction
EndProperty
UD_libs                     Property UDlibs     Hidden ;device/keyword library
    UD_libs Function get()
        return UDmain.UDlibs
    EndFunction
EndProperty
UDCustomDeviceMain          Property UDCDmain   Hidden ;Custom device libs
    UDCustomDeviceMain Function get()
        if !_udcdmain
            _udcdmain = UDmain.UDCDmain
        endif
        return _udcdmain
    EndFunction
EndProperty
UD_OrgasmManager            Property UDOM       Hidden ;Orgasm libs
    UD_OrgasmManager Function get()
        return UDMain.GetUDOM(Wearer)
    EndFunction
EndProperty
UD_AnimationManagerScript   Property UDAM       Hidden ;animation libs
    UD_AnimationManagerScript Function get()
        return UDmain.UDAM
    EndFunction 
EndProperty

String[] Property UD_DeviceStruggleKeywords                     auto Hidden ;keywords (as string array) used to filter struggle animations
Armor    Property DeviceRendered                                auto hidden ;Is taken from ID
Keyword  Property UD_DeviceKeyword                              auto hidden ;keyword of this device for better manipulation. Is taken from ID
string   Property UD_ActiveEffectName           = "Share"       auto hidden ;name of active effect
string   Property UD_DeviceType                 = "Generic"     auto hidden ;name of the device type
bool     Property _StopMinigame                 = False         auto hidden ;control variable for stopping minigame. Made as not bitcoded value to reduce proccessing lag
bool     Property _PauseMinigame                = False         auto hidden ;control variable for pausing minigame. Made as not bitcoded value to reduce proccessing lag
bool     Property _MinigameMainLoopON           = False         auto hidden


zadlibs_UDPatch         Property libsp              hidden
    zadlibs_UDPatch Function get()
        return libs as zadlibs_UDPatch
    EndFunction
EndProperty
UD_CustomDevice_NPCSlot Property UD_WearerSlot      hidden
    UD_CustomDevice_NPCSlot Function get()
        if !Wearer
            return none
        endif
        return UDCDmain.GetNPCSlot(Wearer) ;needs to be updated everytime because the device can have linked old slot which can now store other actor or be empty
    EndFunction
EndProperty

bool    Property zad_DestroyKey                     Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,19)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,19))
    EndFunction
endproperty
float   Property zad_JammLockChance                 hidden ;chance of jamming lock
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_3 = codeBit(_deviceControlBitMap_3,Round(fRange(fVal,0.0,100.0)),8,16)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_3,8,16)
    EndFunction
endproperty
float   Property zad_KeyBreakChance                 hidden ;chance of breaking the key
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_3 = codeBit(_deviceControlBitMap_3,Round(fRange(fVal,0.0,100.0)),8,24)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_3,8,24)
    EndFunction
endproperty
int     Property UD_CurrentLocks                    Hidden ;how many locked locks remain, max is 31
    int Function get()
        return GetLockedLocks()
    EndFunction
endproperty
int     Property UD_condition                       Hidden ;0 - new , 4 - broke
    Function set(int iVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_5 = codeBit(_deviceControlBitMap_5,iRange(iVal,0,4),3,12)
        endBitMapMutexCheck()
    EndFunction
    
    int Function get()
        return decodeBit(_deviceControlBitMap_5,3,12)
    EndFunction
endproperty
bool    Property _isRemoved                         hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,26)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,26))
    EndFunction
EndProperty
bool    Property _StruggleGameON                    Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,0)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,0))
    EndFunction
endproperty
bool    Property _LockpickGameON                    Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,1)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,1))
    EndFunction
endproperty
bool    Property _CuttingGameON                     Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,2)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,2))
    EndFunction
endproperty
bool    Property _KeyGameON                         Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,3)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,3))
    EndFunction
endproperty
bool    Property _RepairLocksMinigameON             Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,4)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,4))
    EndFunction
endproperty
bool    Property _critLoop_On                       Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,7)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,7))
    EndFunction
EndProperty
bool    Property UD_drain_stats                     Hidden ;if player will loose stats while struggling
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,9)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,9))
    EndFunction
endproperty
bool    Property UD_drain_stats_helper              Hidden ;if player will loose stats while struggling
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,10)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,10))
    EndFunction
endproperty
bool    Property UD_damage_device                   Hidden ;if device can be damaged
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,11)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,11))
    EndFunction
endproperty
bool    Property UD_applyExhastionEffect            Hidden ;applies debuff after mnigame ends
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,12)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,12))
    EndFunction
endproperty
bool    Property UD_applyExhastionEffectHelper      Hidden ;applies debuff after minigame ends
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,13)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,13))
    EndFunction
endproperty
bool    Property UD_minigame_canCrit                Hidden ;if crits can appear
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,14)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,14))
    EndFunction
endproperty
bool    Property UD_useWidget                       Hidden ;determinate if widget will be shown
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,15)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,15))
    EndFunction
endproperty
bool    Property UD_WidgetAutoColor                 Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,16)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,16))
    EndFunction
endproperty
bool    Property Ready                              Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,17)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,17))
    EndFunction
endproperty
bool    Property zad_DestroyOnRemove                Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,18)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,18))
    EndFunction
endproperty
bool    Property _MinigameON                        Hidden 
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,21)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,21))
    EndFunction
EndProperty
bool    Property _MinigameParProc_4                 Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,22)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,22))
    EndFunction
EndProperty
bool    Property _removeDeviceCalled                Hidden 
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,23)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,23))
    EndFunction
EndProperty
bool    Property UD_minigame_critRegen              Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,24)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,24))
    EndFunction
EndProperty
bool    Property UD_minigame_critRegen_helper       Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,25)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,25))
    EndFunction
EndProperty
bool    Property _MinigameParProc_2                 Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,27)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,27))
    EndFunction
EndProperty
bool    Property _MinigameParProc_1                 Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,28)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,28))
    EndFunction
EndProperty
bool    Property _MinigameParProc_3                 Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,30)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,30))
    EndFunction
EndProperty
bool    Property _usingTelekinesis                  Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,29)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,29))
    EndFunction
EndProperty
bool    Property UD_AllowWidgetUpdate               Hidden
    Function set(bool bVal)
        startBitMapMutexCheck2()
        _deviceControlBitMap_1 = codeBit(_deviceControlBitMap_1,bVal as Int,1,31)
        endBitMapMutexCheck2()
    EndFunction
    
    bool Function get()
        return Math.LogicalAnd(_deviceControlBitMap_1,Math.LeftShift(0x01,31))
    EndFunction
EndProperty
float   Property UD_minigame_stamina_drain          Hidden ;stamina drain for second of struggling
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_2 = codeBit(_deviceControlBitMap_2,Round(fRange(fVal,0.0,200.0)),8,0)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_2,8,0)
    EndFunction
endproperty
float   Property UD_minigame_magicka_drain          Hidden ;magicka drain for second of struggling
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_2 = codeBit(_deviceControlBitMap_2,Round(fRange(fVal,0.0,200.0)),8,8)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_2,8,8)
    EndFunction
endproperty
float   Property UD_minigame_heal_drain             Hidden ;health drain for second of struggling
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_2 = codeBit(_deviceControlBitMap_2,Round(fRange(fVal,0.0,200.0)),8,16)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_2,8,16);Math.LogicalAnd(_deviceControlBitMap_2,Math.LeftShift(0xFF,16)) as Float
    EndFunction
endproperty
float   Property UD_minigame_stamina_drain_helper   Hidden ;stamina drain for second of struggling
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_2 = codeBit(_deviceControlBitMap_2,Round(fRange(fVal,0.0,200.0)),8,24)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_2,8,24);Math.LogicalAnd(_deviceControlBitMap_2,Math.LeftShift(0xFF,16)) as Float
    EndFunction
endproperty
float   Property UD_minigame_magicka_drain_helper   Hidden ;magicka drain for second of struggling
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_3 = codeBit(_deviceControlBitMap_3,Round(fRange(fVal,0.0,200.0)),8,0)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_3,8,0)
    EndFunction
endproperty
float   Property UD_minigame_heal_drain_helper      Hidden ;health drain for second of struggling
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_3 = codeBit(_deviceControlBitMap_3,Round(fRange(fVal,0.0,200.0)),8,8)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_3,8,8)
    EndFunction
endproperty
float   Property UD_RegenMag_Stamina                Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_4 = codeBit(_deviceControlBitMap_4,Round(fRange(fVal,0.0,1.0)*100),7,0)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_4,7,0)/100.0
    EndFunction
endproperty
float   Property UD_RegenMag_Health                 Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_4 = codeBit(_deviceControlBitMap_4,Round(fRange(fVal,0.0,1.0)*100),7,7)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_4,7,7)/100.0
    EndFunction
endproperty
float   Property UD_RegenMag_Magicka                Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_4 = codeBit(_deviceControlBitMap_4,Round(fRange(fVal,0.0,1.0)*100),7,14)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_4,7,14)/100.0
    EndFunction
endproperty
float   Property UD_RegenMagHelper_Stamina          Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_8 = codeBit(_deviceControlBitMap_8,Round(fRange(fVal,0.0,1.0)*100),7,0)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_8,7,0)/100.0
    EndFunction
EndProperty
float   Property UD_RegenMagHelper_Health           Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_8 = codeBit(_deviceControlBitMap_8,Round(fRange(fVal,0.0,1.0)*100),7,7)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_8,7,7)/100.0
    EndFunction
EndProperty
float   Property UD_RegenMagHelper_Magicka          Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_8 = codeBit(_deviceControlBitMap_8,Round(fRange(fVal,0.0,1.0)*100),7,14)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_8,7,14)/100.0
    EndFunction
EndProperty
int     Property _customMinigameCritChance          Hidden
    Function set(int iVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_8 = codeBit(_deviceControlBitMap_8,iRange(iVal,0,100),7,21)
        endBitMapMutexCheck()
    EndFunction
    
    int Function get()
        return decodeBit(_deviceControlBitMap_8,7,21)
    EndFunction
EndProperty
float   Property _customMinigameCritDuration        Hidden
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_9 = codeBit(_deviceControlBitMap_9,Round(fRange(fVal,0.4,2.0)*100),7,0)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_9,7,0)/100.0
    EndFunction
EndProperty
float   Property _customMinigameCritMult            Hidden
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_9 = codeBit(_deviceControlBitMap_9,Round(fRange(fVal,0.25,1000.0)*4),12,7)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_9,12,7)/4.0
    EndFunction
EndProperty
float   Property _CuttingProgress                   Hidden ;cutting progress, 0-100, step 0.025
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_13 = codeBit(_deviceControlBitMap_13,Round(fRange(fVal,0.0,100.0)*40),12,0)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_13,12,0)/40.0
    EndFunction
EndProperty
float   Property _minMinigameStatHP                 Hidden
    Function set(float fVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_9 = codeBit(_deviceControlBitMap_9,Round(fRange(fVal,0.0,1.0)*100),7,19)
        endBitMapMutexCheck()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_9,7,19)/100.0
    EndFunction
EndProperty
float   Property _minMinigameStatMP                 Hidden
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,1.0)*100),7,0)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_10,7,0)/100.0
    EndFunction
EndProperty
float   Property _minMinigameStatSP                 Hidden
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,1.0)*100),7,7)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_10,7,7)/100.0
    EndFunction
EndProperty
float   Property _condition_mult_add                Hidden ;how much is increased condition dmg (10% increase condition dmg by 10%), step = 0.1, max 25.6
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,25.6)*10),8,14)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_10,8,14)/4.0
    EndFunction
EndProperty
float   Property _exhaustion_mult                   Hidden ;multiplier for duration of debuff, step = 0.25, max 64
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_10 = codeBit(_deviceControlBitMap_10,Round(fRange(fVal,0.0,64.0)*4),8,22)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_10,8,22)/4.0
    EndFunction
EndProperty
float   Property _exhaustion_mult_helper            Hidden ;multiplier for duration of debuff, step = 0.25, max 64
    Function set(float fVal)
        startBitMapMutexCheck3()
        _deviceControlBitMap_12 = codeBit(_deviceControlBitMap_12,Round(fRange(fVal,0.0,64.0)*4),8,0)
        endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return decodeBit(_deviceControlBitMap_12,8,0)/4.0
    EndFunction
EndProperty
int     Property _struggleGame_Subtype              Hidden
    Function set(int iVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_7 = codeBit(_deviceControlBitMap_7,iRange(iVal,0,7),3,25)
        endBitMapMutexCheck()
    EndFunction
    
    int Function get()
        return decodeBit(_deviceControlBitMap_7,3,25)
    EndFunction
EndProperty
int     Property _struggleGame_Subtype_NPC          Hidden
    Function set(int iVal)
        startBitMapMutexCheck()
        _deviceControlBitMap_7 = codeBit(_deviceControlBitMap_7,iRange(iVal,0,7),3,28)
        endBitMapMutexCheck()
    EndFunction
    
    int Function get()
        return decodeBit(_deviceControlBitMap_7,3,28)
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
    return (WearerIsPlayer() || HelperIsPlayer()) && _MinigameON
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
    if (akNewContainer as Actor) && !akOldContainer && !IsUnlocked && !Ready
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
        if !zad_deviceKey
            zad_deviceKey = temp.deviceKey
        endif
        zad_KeyBreakChance = temp.KeyBreakChance
        zad_DestroyOnRemove = temp.DestroyOnRemove
        zad_DestroyKey = temp.DestroyKey
        zad_JammLockChance = temp.LockJamChance
        UD_DeviceKeyword = temp.zad_deviousDevice
        DeviceRendered = temp.DeviceRendered
        If UD_DeviceKeyword == libs.zad_DeviousSuit
            If deviceRendered.HasKeyword(libs.zad_DeviousHobbleSkirt)
                UD_DeviceKeyword = libs.zad_DeviousHobbleSkirt
            EndIf
        EndIf
        UD_DeviceStruggleKeywords = UDCDMain.GetDeviceStruggleKeywords(DeviceRendered)
        temp.delete()
    endif
    if zad_DestroyOnRemove && !hasModifier("DOR")
        addModifier("DOR")
    endif
EndFunction

Bool Function _ParalelProcessRunning()
    return Math.LogicalAnd(_deviceControlBitMap_1,0x58400000)
EndFunction

;==============================================================================================
;==============================================================================================
;==============================================================================================
;                                 MODIFIER MANIP FUNCTIONS                                     
;==============================================================================================
;==============================================================================================
;==============================================================================================

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

;==============================================================================================
;==============================================================================================
;==============================================================================================
;                                   LOCK MANIP FUNCTIONS                                       
;==============================================================================================
;==============================================================================================
;==============================================================================================
; === API ===
;============
;====GETTERS====
; Bool      HaveLocks()                                 = return true if device have locks
; Bool      HaveLockedLocks()                           = return true if any of the locks is not unlocked
; Bool      HaveLockpickableLocks()                      = returns true if device have at least one lock which can be lockpicked
; Int       GetLockedLocks()                            = return number of currently locked locks or 0 if there is error
; Int       GetJammedLocks()                            = return number of currently jammed locks or 0 if there is error
; String[]  GetLockList()                               = return string array of lock names. This is what is shown to player when selecting lock, or return none in case of error
; Int       UserSelectLock()                            = open the list of locks for user. Returns index of selected lock, or -1 in case that user either backed out or there was error
; Bool      IsValidLock(Int aiLock)                     = return true if passed lock is in valid format
; Int       GetLockNumber()                             = returns number of locks on the device or 0 if device have no locks
; Int       GetNthLock(Int aiLockIndex)                 = This function returns the Nth lock, or error value if no locks are on device
; String    GetNthLockName(Int aiLockIndex)             = returns Nth locks name
; Bool      IsNthLockUnlocked(Int aiLockIndex)          = returns true if the Nth lock is unlocked, or false if no Nth lock exist or is invalid
; Bool      IsNthLockJammed(Int aiLockIndex)            = returns true if the Nth lock is jammed, or false if no Nth lock exist or is invalid
; Bool      IsNthLockTimeLocked(Int aiLockIndex)        = returns true if the Nth lock is time locked, or false if no Nth lock exist or is invalid
; Bool      IsNthLockAutoTimeLocked(Int aiLockIndex)    = returns true if the Nth lock is time locked with auto unlock, or false if no Nth lock exist or is invalid
; Int       GetNthLockShields(Int aiLockIndex)          = returns number of shields of the Nth lock, or 0 if no Nth lock exist or is invalid
; Int       GetNthLockAccessibility(Int aiLockIndex)    = returns accessibility of the Nth lock in %, or 0 if no Nth lock exist or is invalid
; Int       GetNthLockDifficulty(Int aiLockIndex)       = returns difficutly of the Nth lock, or 0 if no Nth lock exist or is invalid. Difficulty is in range from 0 to 255 (classic skyrim lockpick difficulty distribution)
; Int       GetNthLockTimeLock(Int aiLockIndex)         = returns number of remaining hours from time lock of the Nth lock, or 0 if no Nth lock exist or is invalid
; Float     GetNthLockRepairProgress(Int aiLockIndex)   = returns Nth locks repair progress in absolute value
;====SETTERS====
; Bool      UnlockNthLock(Int aiLockIndex, Bool abUnlock = True)    = sets lock unlock status. If the operation was succesfull, returns true; argument abUnlock can be set to either true or false, depending if lock should be unlocked, or locked
; Int       UnlockAllLocks(Bool abUnlock = True)                    = Lock/unlock all locks, returns number of locks affected
; Bool      JammNthLock(Int aiLockIndex, Bool abJamm = True)        = sets lock jammed status. If the operation was succesfull, returns true; argument abJamm can be set to either true or false, depending if lock should be jammed, or unjammed
; Int       JammAllLocks(Bool abJamm = True)                        = Jamm/unjamm all locks, returns number of locks affected
; Bool      JammRandomLock()                                        = TODO
; Int       DecreaseLockShield(Int aiLockIndex, Int aiShieldDecrease = 1, Bool abAutoUnlock = False)    = decrease locks shiled by aiShieldDecrease, returns remaining number of shields
; Bool      UpdateLockAccessibility(Int aiLockIndex, Int aiAccessibilityDelta)  = Update the lock accessibility by aiAccessibilityDelta. If the operation was succesfull, returns true
; Bool      UpdateLockDifficulty(Int aiLockIndex, Int aiDifficultyDelta, Bool abNoKeyDiff = True)    = Update the lock difficulty by aiDifficultyDelta. If the operation was succesfull, returns true; if abNoKeyDiff is True, lock difficulty can't be "Key required" after the update (capped difficulty at 100 = master lock)
; Int       UpdateLockTimeLock(Int aiLockIndex, Int aiTimeLockDelta)    = Update the lock time lock by aiTimeLockDelta. Returns new time lock value, or 0 in case of error
; Bool      UpdateAllLocksTimeLock(Int aiTimeLockDelta)                 = Update all locked locks timelock by aiTimeLockDelta, returns true if at least one lock was updated, or false if there was either error or no locked lock
; Float     UpdateNthLockRepairProgress(Int aiLockIndex, Float afValue) = Updates Nth locks repair progress by afValue and returns new value
;====UTILITY====
; Int       CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)   = creates lock from passed arguments ;if abAdd is True, the lock will also be automatically added to the list of locks
; Int       AddLock(Int aiLock, String asName = "", Bool abNoCreate = False)    = Adds lock to lock list, if abNoCreate is true, the lock will not be added if no locks already exist on device (aka, only if device had locks before), Return index of the added lock. In case of error, returns -1

Function _ValidateLocks()
    if HaveLocks()
        ;generate generic lock names if names are not present
        if !UD_LockNameList
            UD_LockNameList = Utility.CreateStringArray(GetLockNumber())
            Int loc_LockNum = UD_LockNameList.length
            Int loc_i       = 0
            while loc_i < loc_LockNum
                UD_LockNameList[loc_i] = "Lock " + (loc_i + 1)
                loc_i += 1
            endwhile
        endif
        ;generate array for repair minigame
        if !_LockRepairProgress
            _LockRepairProgress = Utility.CreateFloatArray(GetLockNumber())
        endif
    endif
EndFunction

;return true if device have locks
Bool Function HaveLocks()
    return UD_LockList
EndFunction

;return true if any of the locks is not unlocked
Bool Function HaveLockedLocks()
    if UD_LockList
        Int loc_LockNum = GetLockNumber()
        while loc_LockNum
            loc_LockNum -= 1
            if !IsNthLockUnlocked(loc_LockNum)
                return true
            endif
        endwhile
        return false
    else
        return false
    endif
EndFunction

;returns true if device have at least one lock which can be lockpicked
;This function doesn't check accessibility or if wearer have lockpicks, so additional checks are needed
Bool Function HaveLockpickableLocks()
    if HaveLocks()
        Int loc_LockNum = GetLockNumber()
        while loc_LockNum
            loc_LockNum -= 1
            ;lock is not unlocked and have max master difficulty
            if !IsNthLockUnlocked(loc_LockNum) && iInRange(GetNthLockDifficulty(loc_LockNum),1,100) 
                return true
            endif
        endwhile
        return false
    else
        return false
    endif
EndFunction

;return true if at least one lock can be accessed
Bool Function HaveAccesibleLock()
    if HaveLocks()
        Int loc_LockNum = GetLockNumber()
        while loc_LockNum
            loc_LockNum -= 1
            if GetLockAccesChance(loc_LockNum) > 0
                return true
            endif
        endwhile
        return false
    else
        return false
    endif
EndFunction

;return number of currently locked locks or 0 if there is error
Int Function GetLockedLocks()
    if HaveLocks()
        Int loc_LockNum = GetLockNumber()
        Int loc_res = 0
        while loc_LockNum
            loc_LockNum -= 1
            if !IsNthLockUnlocked(loc_LockNum)
                loc_res += 1
            endif
        endwhile
        return loc_res
    else
        return 0
    endif
EndFunction

;return number of currently jammed locks or 0 if there is error
Int Function GetJammedLocks()
    if HaveLocks()
        Int loc_LockNum = GetLockNumber()
        Int loc_res = 0
        while loc_LockNum
            loc_LockNum -= 1
            if IsNthLockJammed(loc_LockNum)
                loc_res += 1
            endif
        endwhile
        return loc_res
    else
        return 0
    endif
EndFunction

;return string array of lock names. This is what is shown to player when selecting lock
;return none in case of error
String[] Function GetLockList()
    if UD_LockList
        if UD_LockNameList
            return UD_LockNameList
        else
            UD_LockNameList = Utility.CreateStringArray(UD_LockList.length)
            Int loc_LockNum = GetLockNumber()
            Int loc_i       = 0
            while loc_i < loc_LockNum
                UD_LockNameList[loc_i] = "Lock " + (loc_i + 1)
                loc_i += 1
            endwhile
            return UD_LockNameList
        endif
    else
        return none
    endif
EndFunction

;open the list of locks for user. Returns index of selected lock, or -1 in case that user either backed out or there was error
Int Function UserSelectLock()
    String[] loc_Locks = GetLockList()
    String[] loc_ResList
    int loc_i = 0
    while loc_i < loc_Locks.length
        loc_ResList = PapyrusUtil.PushString(loc_ResList,loc_Locks[loc_i])
        if IsNthLockUnlocked(loc_i)
            loc_ResList[loc_ResList.length - 1] = loc_ResList[loc_ResList.length - 1] + " [UNLOCKED]"
        elseif IsNthLockJammed(loc_i)
            loc_ResList[loc_ResList.length - 1] = loc_ResList[loc_ResList.length - 1] + " [JAMMED]"
        elseif IsNthLockTimeLocked(loc_i) && GetNthLockTimeLock(loc_i)
            loc_ResList[loc_ResList.length - 1] = loc_ResList[loc_ResList.length - 1] + " [TIMELOCK="+GetNthLockTimeLock(loc_i)+"h]"
        else
            loc_ResList[loc_ResList.length - 1] = loc_ResList[loc_ResList.length - 1] + " [LOCKED] | S="+GetNthLockShields(loc_i)
        endif
        loc_i += 1
    endwhile
    loc_ResList = PapyrusUtil.PushString(loc_ResList,"==BACK==")
    if loc_ResList
        Int loc_res = UDmain.GetUserListInput(loc_ResList)
        if loc_res == (loc_ResList.length - 1)
            return -1 ;user selected ==BACK==
        endif
        return loc_res
    else
        return -1
    endif
EndFunction

Function _SetMinigameLock(Int aiLockID)
    _MinigameSelectedLockID = aiLockID
EndFunction
Int Function _GetMinigameLockID()
    return _MinigameSelectedLockID
EndFunction

;return true if passed lock is in valid format
Bool Function IsValidLock(Int aiLock)
    return aiLock
EndFunction

;returns number of locks on the device or 0 if device have no locks
Int Function GetLockNumber()
    if UD_LockList
        return UD_LockList.length
    else
        return 0
    endif
EndFunction

;This function returns the Nth lock, or error value if no locks are on device
Int Function GetNthLock(Int aiLockIndex)
    if UD_LockList && iInRange(aiLockIndex,0,UD_LockList.length - 1)
        return UD_LockList[aiLockIndex]
    else
        return 0x00000000 ;return 0, as error value
    endif
EndFunction

;returns Nth locks name
String Function GetNthLockName(Int aiLockIndex)
    return UD_LockNameList[aiLockIndex]
EndFunction

;returns true if the Nth lock is unlocked, or false if no Nth lock exist or is invalid
Bool Function IsNthLockUnlocked(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return decodeBit(loc_Lock,1,0)
    else
        return False ;return false as error value
    endif
EndFunction

;returns true if the Nth lock is unlocked, or false if no Nth lock exist or is invalid
Bool Function IsNthLockLockpicable(Int aiLockIndex)
    if iInRange(GetNthLockDifficulty(aiLockIndex),1,100)
        return True ;lock can be lockpicked
    else
        return False ;lock can't be lockpicked
    endif
EndFunction

;returns true if the Nth lock is jammed, or false if no Nth lock exist or is invalid
Bool Function IsNthLockJammed(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return decodeBit(loc_Lock,1,1)
    else
        return False ;return false as error value
    endif
EndFunction

;returns true if the Nth lock is time locked, or false if no Nth lock exist or is invalid
Bool Function IsNthLockTimeLocked(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return decodeBit(loc_Lock,1,2)
    else
        return False ;return false as error value
    endif
EndFunction

;returns true if the Nth lock is time locked with auto unlock, or false if no Nth lock exist or is invalid
Bool Function IsNthLockAutoTimeLocked(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return decodeBit(loc_Lock,1,3)
    else
        return False ;return false as error value
    endif
EndFunction

;returns number of shields of the Nth lock, or 0 if no Nth lock exist or is invalid
Int Function GetNthLockShields(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return decodeBit(loc_Lock,4,4)
    else
        return 0 ;return 0 as error value
    endif
EndFunction

;returns accessibility of the Nth lock in %, or 0 if no Nth lock exist or is invalid
Int Function GetNthLockAccessibility(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return iRange(decodeBit(loc_Lock,7,8),0,100)
    else
        return 0 ;return 0 as error value
    endif
EndFunction

;returns difficutly of the Nth lock, or 0 if no Nth lock exist or is invalid
Int Function GetNthLockDifficulty(Int aiLockIndex, Bool abUseLevel = True)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        Int loc_difficutly = decodeBit(loc_Lock,8,15)
        if abUseLevel && loc_difficutly < 100
            ;increase difficulty based on device level
            if UDCDMain.UD_PreventMasterLock
                loc_difficutly = iRange(loc_difficutly + Round(UDCDMain.UD_DeviceLvlLockpick*(UD_Level - 1)),1,75) ;increase lockpick difficulty
            else
                loc_difficutly = iRange(loc_difficutly + Round(UDCDMain.UD_DeviceLvlLockpick*(UD_Level - 1)),1,100) ;increase lockpick difficulty
            endif
        endif
        return loc_difficutly
    else
        return 0 ;return 0 as error value
    endif
EndFunction

;returns number of remaining hours from time lock of the Nth lock, or 0 if no Nth lock exist or is invalid
Int Function GetNthLockTimeLock(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return decodeBit(loc_Lock,7,23)
    else
        return 0 ;return 0 as error value
    endif
EndFunction

;returns Nth locks repair progress in absolute value
Float Function GetNthLockRepairProgress(Int aiLockIndex)
    return _LockRepairProgress[aiLockIndex]
EndFunction

;sets lock unlock status. If the operation was succesfull, returns true
;argument abUnlock can be set to either true or false, depending if lock should be unlocked, or locked
Bool Function UnlockNthLock(Int aiLockIndex, Bool abUnlock = True)
    _StartLockManipMutex()
    Bool loc_res  = False ;return False as error value
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock)
        loc_Lock = codeBit(loc_Lock, abUnlock as Int,1,0)
        UD_LockList[aiLockIndex] = loc_Lock
        loc_res = true
    endif
    _EndLockManipMutex()
    return loc_res
EndFunction

;Lock/unlock all locks, returns number of locks affected
Int Function UnlockAllLocks(Bool abUnlock = True)
    if !HaveLocks() || !GetLockNumber()
        return 0 ;device have no locks, return 0 as error value
    endif
    _StartLockManipMutex()
    Int     loc_res     = 0 ;return False as error value
    Int     loc_LockNum = GetLockNumber()
    while loc_LockNum
        loc_LockNum -= 1
        Int  loc_Lock = GetNthLock(loc_LockNum)
        if IsValidLock(loc_Lock)
            if (abUnlock && !IsNthLockUnlocked(loc_LockNum)) ;unlock lock
                loc_Lock = codeBit(loc_Lock,1,1, 0)
                UD_LockList[loc_LockNum] = loc_Lock
                loc_res += 1
            elseif (!abUnlock && IsNthLockUnlocked(loc_LockNum)) ;lock lock
                loc_Lock = codeBit(loc_Lock,0,1, 0)
                UD_LockList[loc_LockNum] = loc_Lock
                loc_res += 1
            endif
        endif
    endwhile
    _EndLockManipMutex()
    return loc_res
EndFunction

;sets lock jammed status. If the operation was succesfull, returns true
;argument abJamm can be set to either true or false, depending if lock should be jammed, or unjammed
Bool Function JammNthLock(Int aiLockIndex, Bool abJamm = True)
    _StartLockManipMutex()
    Bool loc_res  = False ;return False as error value
    Int  loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock)
        loc_Lock = codeBit(loc_Lock, abJamm as Int,1,1)
        UD_LockList[aiLockIndex] = loc_Lock
        loc_res = true
    endif
    _EndLockManipMutex()
    return loc_res
EndFunction

;Jamm/unjamm all locks, returns number of locks affected
Int Function JammAllLocks(Bool abJamm = True)
    if !HaveLocks() || !GetLockNumber()
        return 0 ;device have no locks, return 0 as error value
    endif
    _StartLockManipMutex()
    Int     loc_res     = 0 ;return False as error value
    Int     loc_LockNum = GetLockNumber()
    while loc_LockNum
        loc_LockNum -= 1
        Int  loc_Lock = GetNthLock(loc_LockNum)
        if IsValidLock(loc_Lock)
            if (abJamm && !IsNthLockJammed(loc_LockNum)) ;jamm lock
                loc_Lock = codeBit(loc_Lock,1,1, 1)
                UD_LockList[loc_LockNum] = loc_Lock
                loc_res += 1
            elseif (!abJamm && IsNthLockJammed(loc_LockNum)) ;unjamm lock
                loc_Lock = codeBit(loc_Lock,0,1, 1)
                UD_LockList[loc_LockNum] = loc_Lock
                loc_res += 1
            endif
        endif
    endwhile
    _EndLockManipMutex()
    return loc_res
EndFunction

;Jamm/unjamm all locks, returns number of locks affected
Bool Function JammRandomLock()
    if !HaveLocks() || !GetLockNumber()
        return 0 ;device have no locks, return 0 as error value
    endif
    _StartLockManipMutex()
    Bool    loc_res     = False ;return False as error value
    Int     loc_LockNum = GetLockNumber()
    
    Int[]   loc_correctLocks
    
    while loc_LockNum
        loc_LockNum -= 1
        Int  loc_Lock = GetNthLock(loc_LockNum)
        if IsValidLock(loc_Lock) && !IsNthLockUnlocked(loc_LockNum) && !IsNthLockJammed(loc_LockNum) 
            loc_correctLocks = PapyrusUtil.PushInt(loc_correctLocks,loc_LockNum)
        endif
    endwhile
    
    if loc_correctLocks
        Int loc_randomLock = loc_correctLocks[Utility.RandomInt(0, loc_correctLocks.length - 1)]
        Int  loc_Lock = GetNthLock(loc_randomLock)
        UD_LockList[loc_randomLock] = codeBit(loc_Lock,1,1, 1)
        loc_res = True
    endif
    
    _EndLockManipMutex()
    return loc_res
EndFunction

;decrease locks shiled by aiShieldDecrease, returns remaining number of shields
Int Function DecreaseLockShield(Int aiLockIndex, Int aiShieldDecrease = 1, Bool abAutoUnlock = False)
    _StartLockManipMutex()
    Int loc_res  = 0 ;return 0 as error value
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock)
        Int loc_ShieldNumber = iUnsig(decodeBit(loc_Lock,4,4) - aiShieldDecrease)
        loc_Lock = codeBit(loc_Lock, loc_ShieldNumber,4,4)
        UD_LockList[aiLockIndex] = loc_Lock
        if loc_ShieldNumber
            loc_res = loc_ShieldNumber ;lock still have shields after the operation
        else
            if abAutoUnlock
                UnlockNthLock(aiLockIndex)
            endif
            loc_res = 0 ;no more shields after update
        endif
    endif
    _EndLockManipMutex()
    return loc_res
EndFunction

;Update the lock accessibility by aiAccessibilityDelta. If the operation was succesfull, returns true
Bool Function UpdateLockAccessibility(Int aiLockIndex, Int aiAccessibilityDelta)
    _StartLockManipMutex()
    Bool loc_res = False ;return False as error value
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock)
        Int loc_Accessibility = iRange(decodeBit(loc_Lock,7,8) + aiAccessibilityDelta,0,100)
        loc_Lock = codeBit(loc_Lock, loc_Accessibility,7,8)
        UD_LockList[aiLockIndex] = loc_Lock
        loc_res = true ;operation was succesfull
    endif
    _EndLockManipMutex()
    return loc_res
EndFunction

;Update the lock difficulty by aiDifficultyDelta. If the operation was succesfull, returns true
; if abNoKeyDiff is True, lock difficulty can't be "Key required" after the update (capped difficulty at 100 = master lock)
Bool Function UpdateLockDifficulty(Int aiLockIndex, Int aiDifficultyDelta, Bool abNoKeyDiff = True)
    _StartLockManipMutex()
    Bool loc_res = False ;return False as error value
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock)
        Int loc_Difficulty = iRange(decodeBit(loc_Lock,8,15) + aiDifficultyDelta,0,255)
        if abNoKeyDiff
            loc_Difficulty = iRange(loc_Difficulty,0,100)
        endif
        loc_Lock = codeBit(loc_Lock, loc_Difficulty,8,15)
        UD_LockList[aiLockIndex] = loc_Lock
        loc_res = true
    endif
    _EndLockManipMutex()
    return loc_res
EndFunction

;Update the lock time lock by aiTimeLockDelta. Returns new time lock value, or 0 in case of error
;Automatically unlock the lock if the timelock reach 0, and the autoUnlock bat was set to 1
Int Function UpdateLockTimeLock(Int aiLockIndex, Int aiTimeLockDelta)
    _StartLockManipMutex()
    Int loc_res = 0 ;return 0 as error value
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock)
        Int loc_TimeLock = iRange(decodeBit(loc_Lock,7,23) + aiTimeLockDelta,0,122)
        loc_Lock = codeBit(loc_Lock, loc_TimeLock,7,23)
        UD_LockList[aiLockIndex] = loc_Lock
        loc_res = loc_TimeLock
        if !loc_res && IsNthLockAutoTimeLocked(aiLockIndex)
            ;auto unlock the lock
            loc_Lock = codeBit(loc_Lock,1,1, 0)
            UD_LockList[aiLockIndex] = loc_Lock
        endif
    endif
    _EndLockManipMutex()
    return loc_res
EndFunction

;Update all locked locks timelock by aiTimeLockDelta, returns true if at least one lock was updated, or false if there was either error or no locked lock
Bool Function UpdateAllLocksTimeLock(Int aiTimeLockDelta, Bool abCheckUnlock = True)
    if !HaveLocks() || !GetLockNumber()
        return False ;device have no locks, return 0 as error value
    endif
    Int     loc_res             = 0 ;return False as error value
    Int     loc_LockNum         = GetLockNumber()
    Bool    loc_lockUnlocked    = False
    while loc_LockNum
        loc_LockNum -= 1
        Int  loc_Lock = GetNthLock(loc_LockNum)
        if IsValidLock(loc_Lock)
            if (!IsNthLockUnlocked(loc_LockNum) && IsNthLockTimeLocked(loc_LockNum)) ;check that lock is not unlocked and is time locked
                UpdateLockTimeLock(loc_LockNum, aiTimeLockDelta) ;increase/decreate timelock
                loc_res += 1
            endif
        endif
    endwhile
    ;check if lock was unlocked, if yes, check if all locks are now unlocked. If yes, unlock device
    if abCheckUnlock && !HaveLockedLocks()
        if WearerIsPlayer()
            UDmain.Print(getDeviceName() + " gets auto unlocked because of timed locks!")
        endif
        unlockRestrain() ;unlock restrain
    endif
    return loc_res
EndFunction

;Updates Nth locks repair progress by afValue and returns new value
Float Function UpdateNthLockRepairProgress(Int aiLockIndex, Float afValue)
    _LockRepairProgress[aiLockIndex] = fRange(_LockRepairProgress[aiLockIndex] + afValue,0.0,100.0)
    return _LockRepairProgress[aiLockIndex]
EndFunction

;creates lock from passed arguments
;if abAdd is True, the lock will also be automatically added to the list of locks
Int Function CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)
    Int loc_res = 0x00000000
    loc_res = codeBit(loc_res, aiShields,4,4)
    loc_res = codeBit(loc_res, aiAccess,7,8)
    loc_res = codeBit(loc_res, aiDifficulty,8,15)
    
    ;add timelock
    if aiTimelock
        loc_res = codeBit(loc_res, 1, 1, 2)
        loc_res = codeBit(loc_res, aiTimelock, 7, 23)
    endif
    
    if abAdd
        _StartLockManipMutex()
        UD_LockList = PapyrusUtil.PushInt(UD_LockList,loc_res)
        UD_LockNameList = PapyrusUtil.PushString(UD_LockNameList,asName)
        _LockRepairProgress = PapyrusUtil.PushFloat(_LockRepairProgress,0.0)
        _EndLockManipMutex()
    endif
    return loc_res
EndFunction

;Adds lock to lock list, if abNoCreate is true, the lock will not be added if no locks already exist on device (aka, only if device had locks before)
;Return index of the added lock. In case of error, returns -1
Int Function AddLock(Int aiLock, String asName, Bool abNoCreate = False)
    if !UD_LockList && abNoCreate
        return - 1;no creating locks on device is allowed, returns -1 as error value
    endif
    _StartLockManipMutex()
    UD_LockList = PapyrusUtil.PushInt(UD_LockList,aiLock)
    if (UD_LockNameList || !UD_LockList)
        UD_LockNameList = PapyrusUtil.PushString(UD_LockNameList,asName)
    endif
    _EndLockManipMutex()
    return UD_LockList.length - 1
EndFunction

;Selects best lock for minigame of type aiType
;aiType = 0 => Lockpick minigame
;aiType = 1 => KeyUnlock minigame
;aiType = 2 => Repair minigame
Int Function SelectBestMinigameLock(Int aiType)
    if HaveLocks()
        if aiType == 1 ;keyunlock minigame
            Int loc_bestLock    = -1
            Int loc_LockNum     = GetLockNumber()
            Int loc_i           = 0
            while loc_i < loc_LockNum
                if !IsNthLockUnlocked(loc_i) && !IsNthLockJammed(loc_i)
                    if loc_bestLock == -1
                        loc_bestLock = loc_i
                    else
                        Int loc_acc        = GetNthLockAccessibility(loc_i)
                        Int loc_accBest    = GetNthLockAccessibility(loc_bestLock)
                        if loc_acc > loc_accBest ;selected lock have bigger accessibility
                            loc_bestLock = loc_i
                        endif
                    endif
                endif
                loc_i += 1
            endwhile
            return loc_bestLock
        elseif aiType == 0 || aiType == 2 ;lockpick or repair minigame
            Int loc_bestLock    = -1
            Int loc_LockNum     = GetLockNumber()
            Int loc_i           = 0
            while loc_i < loc_LockNum
                if !IsNthLockUnlocked(loc_i) && ((aiType == 0 && !IsNthLockJammed(loc_i) && IsNthLockLockpicable(loc_i)) || (aiType == 2 && IsNthLockJammed(loc_i)))
                    if loc_bestLock == -1
                        loc_bestLock = loc_i
                    else
                        ;local values
                        Int loc_diff        = GetNthLockDifficulty(loc_i)
                        Int loc_diffBest    = GetNthLockDifficulty(loc_bestLock)
                        Int loc_acc         = GetNthLockAccessibility(loc_i)
                        Int loc_accBest     = GetNthLockAccessibility(loc_bestLock)
                        
                        ;difference
                        Int loc_dDiff       = (loc_diffBest - loc_diff) ;+ = good, - = bad
                        Int loc_dAcc        = (loc_acc - loc_accBest)   ;+ = good, - = bad
                        
                        Int loc_ControlValue = 0
                        ;calculate control value
                        if aiType == 0
                            loc_ControlValue = loc_dDiff + loc_dAcc
                        elseif aiType == 1
                            loc_ControlValue = loc_dAcc
                        endif
                        
                        if loc_ControlValue > 0 ;selected lock is in total better
                            loc_bestLock    = loc_i
                        endif
                    endif
                endif
                loc_i += 1
            endwhile
            return loc_bestLock
        endif
    endif
    return -1 ;error value
EndFunction

Bool _LockManipMutex = False
Function _StartLockManipMutex()
    while _LockManipMutex
        Utility.waitMenuMode(0.05)
    endwhile
    _LockManipMutex = True
EndFunction
Function _EndLockManipMutex()
    _LockManipMutex = False
EndFunction

;==============================================================================================
;==============================================================================================

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
    
    ;Utility.wait(0.05) ;wait for menus to be closed
    
    UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(akActor)
    
    if IsUnlocked 
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
    
    bool loc_isplayer = (akActor == UDmain.Player)
    if loc_slot ;ignore additional check if actor is not registered
        float loc_time = 0.0
        while loc_time <= 2.0 && !UDCDmain.CheckRenderDeviceEquipped(akActor, deviceRendered)
            ;if loc_isplayer
            ;    Utility.wait(0.05)
            ;else
                Utility.waitMenuMode(0.05)
            ;endif
            loc_time += 0.05
        endwhile
        
        if loc_time >= 1.0
            UDCDmain.Error("!Aborting Init("+ getActorName(akActor) +") called for " + DeviceInventory.getName() + " because equip failed - timeout")
            return
        endif
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
    
    GoToState("UpdatePaused")
    
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
    
    _ValidateLocks() ;validate locks
    
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
    
    current_device_health = UD_Health ;repairs device to max durability on equip
    
    safeCheck()
    
    OnInitLevelUpdate()
    
    UDCDmain.CheckHardcoreDisabler(getWearer())
    
    InitPost()

    if UD_Cooldown > 0
        resetCooldown(1.0)
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
    
    Ready = True
    
    if UDCDmain.isRegistered(getWearer())
        Update(1/24/60) ;1 minute update
    endif
    
    GoToState("")
    
    InitPostPost() ;called after everything else. Can add some followup interaction immidiatly after device is equipped (activate device, start vib, etc...)
EndFunction

;This function is called after the devices level is set and patched. Should be used for some level related adjustments
Function OnInitLevelUpdate()
    ;increase all locks shields by the delta calculated from level
    if HaveLocks() && UDCDMain.UD_DeviceLvlLocks
        Int loc_shieldDelta = (UD_Level - 1)/UDCDMain.UD_DeviceLvlLocks
        Int[] loc_shields = UDCDMain.DistributeLockShields(GetLockNumber(),loc_shieldDelta)
        Int loc_i = GetLockNumber()
        while loc_i
            loc_i -= 1
            DecreaseLockShield(loc_i,-1*loc_shields[loc_i]) ;increase all locks shields by loc_shields[loc_i]
        endwhile
    endif
EndFunction

Function removeDevice(actor akActor)
    if _removeDeviceCalled
        return
    endif
    _removeDeviceCalled = True
    
    GoToState("UpdatePaused")
    
    ;remove ID
    if zad_DestroyOnRemove || hasModifier("DOR")
        akActor.RemoveItem(deviceInventory, 1, true)
    EndIf
    
    if !akActor.isDead()
        if !IsUnlocked
            IsUnlocked = True
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
        UDmain.Log("removeDevice() called for " + getDeviceHeader(),1)
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
            UDmain.Log("Items from LIL " + UD_OnDestroyItemList + " added to actor " + GetWearername(),3)
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
;timepassed is in days
Function Update(float timePassed)
    _updateTimePassed += (timePassed*24.0*60.0)
    
    UpdateCooldown()
    
    if _updateTimePassed > _currentRndCooldown && UD_Cooldown > 0
        CooldownActivate()
    endif
    
    OnUpdatePre(timePassed)
    
    updateCondition()
    
    OnUpdatePost(timePassed)
EndFunction

Function resetCooldown(Float afMult)
    _updateTimePassed = 0.0
    _currentRndCooldown = Round(CalculateCooldown()*afMult)
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
    UpdateAllLocksTimeLock(-1*Round(mult),True) ;update timed locks
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

float Function _getLockMinigameModifier()
    Int loc_Locks = GetLockNumber()
    if loc_Locks
        Int loc_Lockedlocks = GetLockedLocks()
        return 3.0*(1.0 - (loc_Lockedlocks as float)/(loc_Locks)) ;addition modifier range from 0% to 300%, depending on the number of locks unlocked
    else
        return 0.0
    endif
EndFunction

Function updateDifficulty()
    _durability_damage_mod = UD_durability_damage_base*UDCDmain.getStruggleDifficultyModifier()*(1.0 + _getLockMinigameModifier())
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

float Function _GetRelativeLockRepairProgress(Int aiLockIndex)
    return GetNthLockRepairProgress(aiLockIndex)/getLockDurability()
EndFunction

float Function getLockDurability()
    return 100.0
EndFunction

Float Function getRelativeLocks()
    if UD_Locks
        return (UD_CurrentLocks as Float)/UD_Locks
    else
        return 1.0
    endif
EndFunction

;returns comprehesive lock level
;1 = Novice
;2 = Apprentice
;3 = Adept
;4 = Expert
;5 = Master
;6 = Requires Key
;1 = Novice, 25 = Apprentice, 50 = Adept,75 = Expert,100 = Master,255 = Requires Key, range 1-255
int Function getLockpickLevel(Int aiLockIndex, Int aiDiff = 0)
    Int loc_difficulty = 1
    if aiDiff > 0
        loc_difficulty = aiDiff
    else
        loc_difficulty = GetNthLockDifficulty(aiLockIndex)
    endif
    if !loc_difficulty
        return 5
    endif
    if loc_difficulty == 1
        return 0 ;Novice
    elseif loc_difficulty <= 25
        return 1 ;Apprentice
    elseif loc_difficulty <= 50
        return 2 ;Adept
    elseif loc_difficulty <= 75
        return 3 ;Expert
    elseif loc_difficulty <= 100
        return 4 ;master
    else
        return 5 ;require key
    endif
EndFunction

String Function _getLockpickLevelString(Int aiLevel)
    if aiLevel == 0
        return "Novice"
    elseif aiLevel == 1
        return "Apprentice"
    elseif aiLevel == 2
        return "Adept"
    elseif aiLevel == 3
        return "Expert"
    elseif aiLevel == 4
        return "Master"
    else
        return "Requires key\n"
    endif
EndFunction
String Function _GetLockAccessibilityString(Int aiAcc)
    if aiAcc > 50
        return "Easy to reach"
    elseif aiAcc > 35
        return "Reachable"
    elseif aiAcc > 15
        return "Hard to reach"
    elseif aiAcc > 0
        return "Very hard to reach"
    else
        return "Unreachable"
    endif
EndFunction

;returns lock acces chance
;100 = 100% chance of reaching lock
;0 = 0% chance of reaching lock
int Function getLockAccesChance(Int aiLockID, bool checkTelekinesis = true)
    if hasHelper() && HelperFreeHands(True)
        return 100
    endif
    
    int loc_res
    Int loc_acc = GetNthLockAccessibility(aiLockID)
    loc_res         = loc_acc
    if loc_res > 0
        if Wearer.wornHasKeyword(libs.zad_DeviousBlindfold)
            loc_res -= 40
        endif
        loc_res = iRange(loc_res,15,100)
    endif

    If !WearerFreeHands(True)
        loc_res = 0
    Endif
    
    if checkTelekinesis
        if WearerHaveTelekinesis()
            loc_res += 15
        endif
    endif

    if hasHelper()
        if checkTelekinesis
            if HelperHaveTelekinesis()
                loc_res += 15
            endif
        endif
        if HelperFreeHands()
            loc_res += 25 ;helper still provide some basic boost, even if they wear mittens
        else
            loc_res += 10 ;helper still provide some basic boost, even if they are tied
        endif
    endif
    
    
    loc_res = iRange(loc_res,0,100)
    
    return loc_res
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

Function setWidgetVal(float val, bool force = false)
    UDmain.UDWC.Meter_SetFillPercent("device-main", val * 100.0, force)
EndFunction

Function setMainWidgetAppearance(Int aiColor1, Int aiColor2 = -1, Int aiFlashColor = -1, String asIconName = "")
    UDmain.UDWC.Meter_SetColor("device-main", aiColor1, aiColor2, aiFlashColor)
    If asIconName != ""
        UDMain.UDWC.Meter_SetIcon("device-main", asIconName)
    EndIf
EndFunction

Function setConditionWidgetAppearance(Int aiColor1, Int aiColor2 = -1, Int aiFlashColor = -1)
    UDmain.UDWC.Meter_SetColor("device-condition", aiColor1, aiColor2, aiFlashColor)
;    UDMain.UDWC.Meter_SetIcon("device-condition", "icon-meter-condition")
EndFunction

Function showWidget(Bool abUpdate = true, Bool abUpdateColor = true)
    if abUpdate
        updateWidget(true)
    endif
    if abUpdateColor
        updateWidgetColor()
    endif
    UDmain.UDWC.Meter_SetVisible("device-main", True)
    If UDmain.UDWC.UD_UseDeviceConditionWidget
        UDmain.UDWC.Meter_SetVisible("device-condition", True)
    EndIf
EndFunction

Function hideWidget()
    UDmain.UDWC.Meter_SetVisible("device-main", False)
    UDmain.UDWC.Meter_SetVisible("device-condition", False)
EndFunction

Function decreaseDurabilityAndCheckUnlock(float value,float cond_mult = 1.0,Bool abCheckCondition = True)
    if current_device_health > 0.0
        current_device_health = fRange(current_device_health - value,0.0,UD_Health)
        _total_durability_drain += value*cond_mult
        if abCheckCondition && current_device_health > 0 && cond_mult != 0.0
            updateCondition()
        endif
    endif
    updateWidgetColor()
    if current_device_health <= 0.0 && !IsUnlocked
        unlockRestrain()
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
    Float loc_health = UD_Health
    if decrease
        while (_total_durability_drain >= loc_health) && !IsUnlocked && UD_condition < 4
            _total_durability_drain -= loc_health
            UD_condition += 1
            if WearerIsPlayer()
                UDCDmain.Print("You feel that "+getDeviceName()+" condition have decreased!",2)
            elseif UDCDmain.AllowNPCMessage(GetWearer(), true)
                UDCDmain.Print(GetWearerName() + "s " + getDeviceName() + " condition have decreased!",3)
            endif
        endwhile
    else
        if (_total_durability_drain < 0) && !IsUnlocked
            _total_durability_drain = 0
            if UD_condition > 0 
                UD_condition -= 1
                if WearerIsPlayer()
                    UDCDmain.Print("You feel that "+getDeviceName()+" condition have increased!",1)
                elseif UDCDmain.AllowNPCMessage(GetWearer(), true)
                    UDCDmain.Print(GetWearerName() + "s " + getDeviceName() + " condition have increased!",3)
                endif
            endif
        endif
    endif
    
    if UD_condition >= 4 && !IsUnlocked
        if WearerIsPlayer()
            UDCDmain.Print("You managed to destroy "+ getDeviceName() +"!",2)
        elseif WearerIsFollower()
            UDCDmain.Print(GetWearerName() + " managed to destroy " + getDeviceName() + "!",2)
        endif
        unlockRestrain(True)
    else
        if UDmain.UDWC.UD_UseDeviceConditionWidget && PlayerInMinigame() && UDCDmain.UD_UseWidget && UD_UseWidget; && UD_AllowWidgetUpdate
            UDmain.UDWC.Meter_SetFillPercent("device-condition", getRelativeCondition() * 100.0)
        endif
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
            _total_durability_drain -= 0.5*(arg_fValue)
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

;Returns true if device can be struggled from or unlocked
bool Function isEscapable()
    if UD_durability_damage_base > 0.0 || (UD_LockList && UD_LockList.length && HaveLockpickableLocks())
        return True
    else
        return false
    endif
EndFunction

;returns true if device can be cutted
bool Function canBeCutted()
    if UD_CutChance > 0.0
        return True
    else
        return false
    endif
EndFunction

;returns true if device have any locks that can be lockpicked or unlocked with key
bool Function HaveUnlockableLocks()
    if HaveLocks()
        Int loc_currentlocks = UD_CurrentLocks
        ;check if device have not unlocked/jammed locks
        if loc_currentlocks && (loc_currentlocks - UD_JammedLocks) > 0
            return true
        endif
    endif
    return false
EndFunction

;returns true if device can be repaired by helper
bool Function canBeRepaired(Actor akSource)
    if !akSource
        return false
    endif
    bool loc_res = true
    loc_res = loc_res && (getRelativeDurability() < 1.0 || getRelativeCondition() < 1.0 || getRelativeLocks() < 1.0)
    loc_res = loc_res && (akSource.getItemCount(UDlibs.SteelIngot) >= 2)
    return loc_res
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
    if !_minigameHelper
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

    bool        loc_isloose             = isLoose()
    bool        loc_freehands           = WearerFreeHands()
    float       loc_accesibility        = getAccesibility()
    
    ;normal struggle
    if StruggleMinigameAllowed(loc_accesibility); && (loc_isloose || loc_freehands)
        UDCDmain.currentDeviceMenu_allowstruggling = True
    else
        UDCDmain.currentDeviceMenu_allowUselessStruggling = True
    endif
    
    if HaveLocks() && HaveAccesibleLock() ;check if device have locks, and if they can be currently accessed
        Int loc_lockMinigames = LockMinigameAllowed(loc_accesibility)
        if Math.LogicalAnd(loc_lockMinigames,0x1)
            UDCDmain.currentDeviceMenu_allowlockpick = True
        endif
        if Math.LogicalAnd(loc_lockMinigames,0x2)
            UDCDmain.currentDeviceMenu_allowkey = True
        endif
        if Math.LogicalAnd(loc_lockMinigames,0x4)
            UDCDmain.currentDeviceMenu_allowlockrepair = True
        endif
    endif
    
    ;cutting
    if CuttingMinigameAllowed(loc_accesibility)
        UDCDmain.currentDeviceMenu_allowcutting = True
    endif
    
    ;Check if Lock menu button should be present in menu
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

;Checks for SOLO struggle minigames
Bool Function StruggleMinigameAllowed(Float afAccesibility)
    return canBeStruggled(afAccesibility)
EndFunction
Bool Function CuttingMinigameAllowed(Float afAccesibility)
    return canBeCutted() && afAccesibility
EndFunction
;returns Nth lock control variable which contain information about minigames which are allowed for passed lock
; 0b = lockpick minigame
; 1b = key unlock minigame
; 2b = lcok repair minigame
Int  Function NthLockMinigamesAllowed(Int aiLockID, Float afAccesibility)
    if IsNthLockUnlocked(aiLockID)
        return 0x0 ;lock is unlocked, no minigame slould be allowed
    endif
    
    if IsNthLockTimeLocked(aiLockID) && GetNthLockTimeLock(aiLockID)
        return 0x0 ;lock is time locked, no minigame is allowed!
    endif
    
    if !GetHelper() ;no helper, check if wearer can reach the lock themself
        Int loc_Accessibility = GetNthLockAccessibility(aiLockID)
        if !loc_Accessibility
            return 0x0 ;lock is inaccessible by wearer, help of other person is needed
        endif
    endif
    Int loc_res = 0
    if (afAccesibility > 0) ;check if device can be accessed by wearer
        Bool loc_Jammed = IsNthLockJammed(aiLockID)
        if !loc_Jammed
            ;key unlock
            if zad_deviceKey && (wearer.getItemCount(zad_deviceKey) || (_minigameHelper && _minigameHelper.getItemCount(zad_deviceKey)))
                loc_res += 2
            endif
            Int loc_Difficulty = GetNthLockDifficulty(aiLockID)
            ;lockpicking
            if loc_Difficulty < 255 && (wearer.getItemCount(UDCDmain.Lockpick) || (_minigameHelper && _minigameHelper.getItemCount(UDCDmain.Lockpick))) 
                loc_res += 1
            endif
        else
            loc_res += 4
        endif
    endif
    return loc_res
EndFunction

;returns combinated lock minigame control variable which contain information about minigames which are allowed for all current locks (OR)
; 0b = at least 1 lock can be lockpicked
; 1b = at least 1 lock can be unlocked with key
; 2b = at least 1 lock can be repaired
Int Function LockMinigameAllowed(Float afAccesibility)
    Int loc_LockNum = GetLockNumber()
    int loc_res = 0x0
    while loc_LockNum
        loc_LockNum -= 1
        Int loc_lockres = NthLockMinigamesAllowed(loc_LockNum,afAccesibility)
        loc_res = Math.LogicalOr(loc_res,loc_lockres)
    endwhile
    return loc_res
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
    
    bool    loc_freehands_wearer     = WearerFreeHands(true,False)
    bool    loc_freehands_helper     = HelperFreeHands(true)
    float   loc_accesibility         = getAccesibility()
    ;int     loc_lockacces            = getLockAccesChance()
    
    ;help struggle
    if canBeStruggled(loc_accesibility)
        UDCDmain.currentDeviceMenu_allowstruggling = True
    endif

    if HaveAccesibleLock()
        Int loc_lockMinigame = LockMinigameAllowed(loc_accesibility)
        ;key unlock
        if Math.LogicalAnd(loc_lockMinigame,0x2)
            UDCDmain.currentDeviceMenu_allowkey = True
        endif
        
        ;lockpicking
        if Math.LogicalAnd(loc_lockMinigame,0x1)
            if (wearer.getItemCount(UDCDmain.Lockpick) || akSource.getItemCount(UDCDmain.Lockpick))
                UDCDmain.currentDeviceMenu_allowlockpick = True
            endif
        endif

        ;lock repair
        if Math.LogicalAnd(loc_lockMinigame,0x4)
            UDCDmain.currentDeviceMenu_allowlockrepair = True
        endif
    endif
    
    ;cutting
    if canBeCutted()
        UDCDmain.currentDeviceMenu_allowcutting = True
    endif
        
    if !loc_freehands_wearer && loc_freehands_helper
        UDCDmain.currentDeviceMenu_allowTighten = True
    endif
    
    if !loc_freehands_wearer && loc_freehands_helper && canBeRepaired(akSource)
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
            tightUpDevice(akSource)
            _break = true
        elseif msgChoice == 5    ;repair
            repairDevice(akSource)
            _break = true
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

;==============================================================================================
;==============================================================================================
;==============================================================================================
;                   |-------------------------------------------------------|                  
;                   | __  __ _____ _   _ _____ _____          __  __ ______ |                  
;                   ||  \/  |_   _| \ | |_   _/ ____|   /\   |  \/  |  ____||                  
;                   || \  / | | | |  \| | | || |  __   /  \  | \  / | |__   |                  
;                   || |\/| | | | | . ` | | || | |_ | / /\ \ | |\/| |  __|  |                  
;                   || |  | |_| |_| |\  |_| || |__| |/ ____ \| |  | | |____ |                  
;                   ||_|  |_|_____|_| \_|_____\_____/_/    \_\_|  |_|______||                  
;                   |-------------------------------------------------------|                  
;==============================================================================================
;==============================================================================================
;==============================================================================================

bool Function struggleMinigame(int iType = -1, Bool abSilent = False)
    if iType == -1
        iType = UDCDmain.StruggleMessage.show()
    endif

    if iType == 4
        return false
    endif
    
    if !minigamePrecheck(abSilent)
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar((iType != 5), True, False, 0xffbd00, -1, -1, "icon-meter-struggle")
    
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
        UD_durability_damage_add = 1.0*(_durability_damage_mod*((5.0 - 5.0*getRelativeDurability()) + UDCDMain.getActorStrengthSkillsPerc(getWearer())));UDmain.getMaxActorValue(Wearer,"Health",0.02);*getModResistPhysical()
        UD_DamageMult *= getModResistPhysical(1.0,0.2)
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
        UD_RegenMag_Stamina = 0.25
        UD_RegenMag_Health = 0.25
        UD_RegenMag_Magicka = 0.25
    else 
        return false
    endif
        
    _struggleGame_Subtype = iType

    bool loc_minigamecheck = minigamePostcheck(abSilent)
    if loc_minigamecheck
        _StruggleGameON = True
        minigame()
        _StruggleGameON = False
        return true
    else
        return false
    endif
EndFunction

bool Function lockpickMinigame(Bool abSilent = False)
    if !minigamePrecheck(abSilent)
        return false
    endif    
    
    Int loc_SelectedLock = 0
    if WearerIsPlayer()
        loc_SelectedLock = UserSelectLock()
    else
        loc_SelectedLock = SelectBestMinigameLock(0)
    endif
    if loc_SelectedLock < 0
        return false
    endif
    
    Bool loc_cond = True
    loc_cond = loc_cond && !IsNthLockUnlocked(loc_SelectedLock)
    loc_cond = loc_cond && !IsNthLockJammed(loc_SelectedLock)
    loc_cond = loc_cond && (!IsNthLockTimeLocked(loc_SelectedLock) || !GetNthLockTimeLock(loc_SelectedLock))
    
    ;lock can't be used in lockpick minigame, return
    if !loc_cond
        if WearerIsPlayer() || HelperIsPlayer()
            UDmain.Print("You can't lockpick "+UD_LockNameList[loc_SelectedLock]+"!")
        endif
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar(False, False, False)
    
    _MinigameSelectedLockID = loc_SelectedLock
    UD_minigame_stamina_drain = UD_base_stat_drain
    UD_damage_device = False
    UD_minigame_canCrit = False
    UD_minigame_critRegen = false
    UD_RegenMag_Health = 0.5
    UD_RegenMag_Magicka = 0.5
    _customMinigameCritChance = getLockAccesChance(_MinigameSelectedLockID, false)
    _customMinigameCritDuration = 0.8 - getLockpickLevel(_MinigameSelectedLockID)*0.02
    _minMinigameStatSP = 0.8
    
    if minigamePostcheck(abSilent)
        _LockpickGameON = True
        minigame()
        _LockpickGameON = False
        return true
    else
        return false
    endif
EndFunction

bool Function repairLocksMinigame(Bool abSilent = False)
    if !minigamePrecheck(abSilent)
        return false
    endif
    
    Int loc_SelectedLock = 0
    if WearerIsPlayer()
        loc_SelectedLock = UserSelectLock()
    else
        loc_SelectedLock = SelectBestMinigameLock(2)
    endif
    if loc_SelectedLock < 0
        return false
    endif
    
    Bool loc_cond = True
    loc_cond = loc_cond && !IsNthLockUnlocked(loc_SelectedLock)
    loc_cond = loc_cond && IsNthLockJammed(loc_SelectedLock)
    loc_cond = loc_cond && (!IsNthLockTimeLocked(loc_SelectedLock) || !GetNthLockTimeLock(loc_SelectedLock))
    
    ;lock can't be used in lockpick minigame, return
    if !loc_cond
        if WearerIsPlayer() || HelperIsPlayer()
            UDmain.Print("You can't repair "+UD_LockNameList[loc_SelectedLock]+"!")
        endif
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar(True, True, False, 0xffbd00, -1, -1, "icon-meter-repair")
    
    _MinigameSelectedLockID = loc_SelectedLock
    UD_minigame_stamina_drain = UD_base_stat_drain*1.25
    UD_damage_device = False
    UD_minigame_canCrit = False

    _customMinigameCritChance = 5 + (4 - getLockpickLevel(_MinigameSelectedLockID))*5
    _customMinigameCritDuration = 0.8 - getLockpickLevel(_MinigameSelectedLockID)*0.02
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
    
    if minigamePostcheck(abSilent)
        _RepairLocksMinigameON = True
        minigame()
        _RepairLocksMinigameON = False
        return true
    else
        return false
    endif
EndFunction

bool Function cuttingMinigame(Bool abSilent = False)
    if !minigamePrecheck(abSilent)
        return false
    endif

    resetMinigameValues()
    setMinigameWidgetVar(True, True, False, 0xffbd00, -1, -1, "icon-meter-cut")
    
    UD_damage_device = False
    UD_minigame_stamina_drain = UD_base_stat_drain + getMaxActorValue(Wearer,"Stamina",0.04)
    UD_minigame_heal_drain = UD_base_stat_drain/2+ getMaxActorValue(Wearer,"Health",0.01)
    UD_RegenMag_Magicka = 0.5
    _minMinigameStatSP = 0.8
    _minMinigameStatHP = 0.5
        
    if minigamePostcheck(abSilent)
        float loc_BaseMult = UDCDmain.getActorCuttingWeaponMultiplier(getWearer())
        
        UD_MinigameMult1 = loc_BaseMult + UDCDmain.getActorCuttingSkillsPerc(getWearer())
        UD_DamageMult = loc_BaseMult + UDCDmain.getActorCuttingSkillsPerc(getWearer())
        
        _CuttingGameON = True
        minigame()
        _CuttingGameON = False
        return true
    else
        return false
    endif
EndFunction

bool Function keyMinigame(Bool abSilent = False)
    if !minigamePrecheck(abSilent)
        return false
    endif

    Int loc_SelectedLock = 0
    if WearerIsPlayer()
        loc_SelectedLock = UserSelectLock()
    else
        loc_SelectedLock = SelectBestMinigameLock(1)
    endif
    
    if loc_SelectedLock < 0
        return false
    endif

    Bool loc_cond = True
    loc_cond = loc_cond && !IsNthLockUnlocked(loc_SelectedLock)
    loc_cond = loc_cond && !IsNthLockJammed(loc_SelectedLock)
    loc_cond = loc_cond && (!IsNthLockTimeLocked(loc_SelectedLock) || !GetNthLockTimeLock(loc_SelectedLock))
    
    ;lock can't be used in lockpick minigame, return
    if !loc_cond
        if WearerIsPlayer() || HelperIsPlayer()
            UDmain.Print("You can't unlock "+UD_LockNameList[loc_SelectedLock]+"!")
        endif
        return false
    endif

    resetMinigameValues()
    setMinigameWidgetVar(False, False, False)

    _MinigameSelectedLockID = loc_SelectedLock
    UD_damage_device = False
    UD_minigame_stamina_drain = UD_base_stat_drain
    UD_minigame_canCrit = False
    UD_applyExhastionEffect = False
    UD_minigame_critRegen = false
    UD_RegenMag_Health = 0.5
    UD_RegenMag_Magicka = 0.5
    _customMinigameCritChance = getLockAccesChance(_MinigameSelectedLockID, false)
    _customMinigameCritDuration = 0.85 - getLockpickLevel(_MinigameSelectedLockID)*0.025
    _minMinigameStatSP = 0.6
    
    
    if minigamePostcheck(abSilent)
        _KeyGameON = True
        minigame()
        _KeyGameON = False
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
        setHelper(none)
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar(True, True, False, 0xffbd00, -1, -1, "icon-meter-struggle")
    
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
        
        UD_durability_damage_add = 1.0*_durability_damage_mod*((5.0 - 5.0*getRelativeDurability()) + UDCDMain.getActorStrengthSkillsPerc(getWearer()) + getHelperStrengthSkillsPerc())
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
        _StruggleGameON = True
        minigame()
        _StruggleGameON = False
        
        return true
    else
        return false
    endif
    
EndFunction

bool Function lockpickMinigameWH(Actor akHelper)
    if !minigamePrecheck()
        return false
    endif
    
    Int loc_SelectedLock = 0
    if WearerIsPlayer() || HelperIsPlayer()
        loc_SelectedLock = UserSelectLock()
    else
        loc_SelectedLock = SelectBestMinigameLock(0)
    endif
    if loc_SelectedLock < 0
        return false
    endif
    
    Bool loc_cond = True
    loc_cond = loc_cond && !IsNthLockUnlocked(loc_SelectedLock)
    loc_cond = loc_cond && !IsNthLockJammed(loc_SelectedLock)
    loc_cond = loc_cond && (!IsNthLockTimeLocked(loc_SelectedLock) || !GetNthLockTimeLock(loc_SelectedLock))
    
    ;lock can't be used in lockpick minigame, return
    if !loc_cond
        if WearerIsPlayer() || HelperIsPlayer()
            UDmain.Print("You can't lockpick "+UD_LockNameList[loc_SelectedLock]+"!")
        endif
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar(False, False, False)
    
    _MinigameSelectedLockID = loc_SelectedLock
    
    UD_minigame_stamina_drain = UD_base_stat_drain
    UD_minigame_stamina_drain_helper = UD_base_stat_drain*0.8
    UD_damage_device = False
    UD_minigame_canCrit = False
    UD_minigame_critRegen = false
    UD_minigame_critRegen_helper = false
    UD_RegenMag_Magicka = 0.5
    UD_RegenMag_Health = 0.5
    UD_RegenMagHelper_Magicka = 0.75
    UD_RegenMagHelper_Health = 0.75
    _customMinigameCritDuration = 0.9
    _customMinigameCritChance = getLockAccesChance(_MinigameSelectedLockID, false)
    _minMinigameStatSP = 0.8
    
    
    if minigamePostcheck()
        _LockpickGameON = True
        minigame()
        _LockpickGameON = False
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
    
    Int loc_SelectedLock = 0
    if WearerIsPlayer() || HelperIsPlayer()
        loc_SelectedLock = UserSelectLock()
    else
        loc_SelectedLock = SelectBestMinigameLock(2)
    endif
    if loc_SelectedLock < 0
        return false
    endif
    
    Bool loc_cond = True
    loc_cond = loc_cond && !IsNthLockUnlocked(loc_SelectedLock)
    loc_cond = loc_cond && IsNthLockJammed(loc_SelectedLock)
    loc_cond = loc_cond && (!IsNthLockTimeLocked(loc_SelectedLock) || !GetNthLockTimeLock(loc_SelectedLock))
    
    ;lock can't be used in lockpick minigame, return
    if !loc_cond
        if WearerIsPlayer() || HelperIsPlayer()
            UDmain.Print("You can't repair "+UD_LockNameList[loc_SelectedLock]+"!")
        endif
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar(True, True, False, 0xffbd00, -1, -1, "icon-meter-repair")
    
    _MinigameSelectedLockID = loc_SelectedLock
    
    UD_minigame_stamina_drain = UD_base_stat_drain*1.25 
    UD_minigame_stamina_drain_helper = UD_base_stat_drain
    UD_damage_device = False
    UD_minigame_canCrit = False
    
    _customMinigameCritChance = 10 + (4 - getLockpickLevel(_MinigameSelectedLockID))*5
    UD_MinigameMult1 = getAccesibility() + 0.35*(UDCDMain.getActorSmithingSkillsPerc(getWearer()) + UDCDMain.getActorSmithingSkillsPerc(getHelper()))
    UD_RegenMag_Magicka = 0.5
    UD_RegenMag_Health = 0.5
    UD_RegenMagHelper_Magicka = 0.75
    UD_RegenMagHelper_Health = 0.75
    _customMinigameCritDuration = 0.85 - getLockpickLevel(_MinigameSelectedLockID)*0.015
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
        _RepairLocksMinigameON = True
        minigame()
        _RepairLocksMinigameON = False
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
    setMinigameWidgetVar(True, True, False, 0xffbd00, -1, -1, "icon-meter-cut")
    
    UD_damage_device = False
    UD_minigame_stamina_drain = UD_base_stat_drain + getMaxActorValue(Wearer,"Stamina",0.04)
    UD_minigame_stamina_drain_helper = UD_base_stat_drain*1.25 + getMaxActorValue(Wearer,"Stamina",0.04)
    UD_minigame_heal_drain = UD_base_stat_drain*0.75 + getMaxActorValue(Wearer,"Health",0.02)    
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
    
        _CuttingGameON = True
        minigame()
        _CuttingGameON = False
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
    
    Int loc_SelectedLock = 0
    if WearerIsPlayer() || HelperIsPlayer()
        loc_SelectedLock = UserSelectLock()
    else
        loc_SelectedLock = SelectBestMinigameLock(1)
    endif
    if loc_SelectedLock < 0
        return false
    endif
    
    Bool loc_cond = True
    loc_cond = loc_cond && !IsNthLockUnlocked(loc_SelectedLock)
    loc_cond = loc_cond && !IsNthLockJammed(loc_SelectedLock)
    loc_cond = loc_cond && (!IsNthLockTimeLocked(loc_SelectedLock) || !GetNthLockTimeLock(loc_SelectedLock))
    
    ;lock can't be used in lockpick minigame, return
    if !loc_cond
        if WearerIsPlayer() || HelperIsPlayer()
            UDmain.Print("You can't unlock "+UD_LockNameList[loc_SelectedLock]+"!")
        endif
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar(False, False, False)
    
    _MinigameSelectedLockID = loc_SelectedLock
    
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
    _customMinigameCritChance = getLockAccesChance(_MinigameSelectedLockID, false)
    _customMinigameCritDuration = 0.9 - getLockpickLevel(_MinigameSelectedLockID)*0.03
    _minMinigameStatSP = 0.6
    
    if minigamePostcheck()
        _KeyGameON = True
        minigame()
        _KeyGameON = False
        setHelper(none)
        return true
    else
        return false
    endif
EndFunction

Function tightUpDevice(Actor akSource)
    if WearerIsPlayer()
        UDmain.Print(GetActorName(akSource) + " tighted your " + getDeviceName() + " !",1)
    elseif HelperIsPlayer()
        UDmain.Print("You tighted " + getWearerName() + "s " + getDeviceName() + " !",1)
    elseif !PlayerInMinigame()
        UDmain.Print(GetActorName(akSource) + " tighted " + getWearerName() + "s " + getDeviceName() + " !",1)
    endif
    current_device_health += Utility.randomFloat(5.0,15.0)
    if (current_device_health > UD_Health)
        current_device_health = UD_Health
        updateCondition(False)
    endif
EndFunction

Function repairDevice(Actor akSource)
    if WearerIsPlayer()
        UDmain.Print(GetActorName(akSource) + " repaired your " + getDeviceName() + " !",1)
    elseif HelperIsPlayer()
        UDmain.Print("You repaired " + getWearerName() + "s " + getDeviceName() + " !",1)
    elseif !PlayerInMinigame()
        UDmain.Print(GetActorName(akSource) + " repaired " + getWearerName() + "s " + getDeviceName() + " !",1)
    endif
    
    ;repair durability
    current_device_health += Utility.randomFloat(45.0,75.0)
    if (current_device_health > UD_Health)
        current_device_health = UD_Health
    endif
    
    ;repair condition
    _total_durability_drain -= 75
    if _total_durability_drain < 0.0
        _total_durability_drain = 0.0
    endif

    updateCondition(False)

    _CuttingProgress -= 30.0
    if _CuttingProgress < 0.0
        _CuttingProgress = 0.0
    endif
    
    if UD_CurrentLocks < UD_Locks
        ;UD_CurrentLocks += 1 ;lock one of the locks
        UnlockAllLocks(False) ;lock all locks
    endif
    
    akSource.removeItem(UDlibs.SteelIngot,2) ;remove 2 ingots
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
    _MinigameSelectedLockID = -1
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
Function setMinigameWidgetVar(Bool abUseWidget = False, Bool abWidgetAutoColor = True, Bool abWidgetUpdate = True, Int aiColor1 = -1, Int aiColor2 = -1, Int aiFlashColor = -1, String asIconName = "")
    UD_useWidget = abUseWidget
    UD_WidgetAutoColor = abWidgetAutoColor
    UD_AllowWidgetUpdate = abWidgetUpdate
    
    setMainWidgetAppearance(aiColor1, aiColor2, aiFlashColor, asIconName)
EndFunction

;returns current type of minigame played
; 0 = no minigame is playing
; 1 = struggle
; 2 = cutting
; 3 = lockpick
; 4 = key unlocking
; 5 = lock repair
int Function getMinigameType()
    if !_MinigameON
        return 0
    endif
    if _StruggleGameON
        return 1
    elseif _CuttingGameON
        return 2
    elseif _LockpickGameON
        return 3
    elseif _KeyGameON
        return 4
    elseif _RepairLocksMinigameON
        return 5
    endif
EndFunction

Function UnsetMinigameDevice()
    if PlayerInMinigame()
        UDCDmain.resetCurrentMinigameDevice()
    else
        StorageUtil.UnSetFormValue(Wearer, "UD_currentMinigameDevice")
        if _minigameHelper
            StorageUtil.UnSetFormValue(_minigameHelper, "UD_currentMinigameDevice")
        endif
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

;Stops minigame
;setting argument abWaitForStop to true will block the functionu ntill minigame ends
Function StopMinigame(Bool abWaitForStop = False)
    UnsetMinigameDevice()
    _StopMinigame = True
    _PauseMinigame = False
    while abWaitForStop && IsMinigameOn()
        Utility.waitMenuMode(0.01)
    endwhile
EndFunction

;pauses minigame. This stops main loop from processing (decreasing stats, crits, etc..). Minigame can be still stoped while in this state with StopMinigame()
Function PauseMinigame()
    if _MinigameON
        _PauseMinigame = True
    endif
EndFunction

;Unpauses minigame
Function UnPauseMinigame()
    if _MinigameON
        _PauseMinigame = False
    endif
EndFunction

;returns true if device is in minigame
bool Function IsMinigameOn()
    return _MinigameON
EndFunction

;returns true if minigame main loop is running
bool Function IsMinigameLoopRunning()
    return _MinigameMainLoopON
EndFunction

;returns true if devices minigame is currently paused
bool Function IsPaused()
    return _PauseMinigame
EndFunction

bool Function minigamePostcheck(Bool abSilent = False)
    If UDmain.TraceAllowed()
        UDmain.Log("minigamePostcheck called for " + getDeviceHeader() + " abSilent="+abSilent)
    endif

    if !checkMinAV(Wearer) ;check wearer AVs
        if !abSilent
            if WearerIsPlayer() ;message related to player wearer
                UDmain.Print("You are too exhausted. Try later, after you regain your strength.",1)
            elseif UDCDmain.AllowNPCMessage(Wearer) ;message related to NPC wearer
                UDmain.Print(getWearerName()+" is too exhausted!",1)
            endif
        endif
        return false
    elseif hasHelper() && !checkMinAV(_minigameHelper)
        if !abSilent
            if HelperIsPlayer() ;message related to player helper
                UDmain.Print("You are too exhausted and can't help "+getWearerName()+".",1)
            elseif UDCDmain.AllowNPCMessage(_minigameHelper) ;message related to NPC helper
                UDmain.Print(getHelperName()+" is too exhausted and unable to help you.",1)
            endif
        endif
        return false
    endif
    return true
EndFunction

bool Function minigamePrecheck(Bool abSilent = False)
    If UDmain.TraceAllowed()
        UDmain.Log("minigamePrecheck called for " + getDeviceHeader() + " abSilent="+abSilent)
    endif

    if _MinigameON || UDCDmain.actorInMinigame(Wearer)
        if !abSilent
            GWarning("Can't start minigame for " + getDeviceHeader() + " because wearer is already in minigame!")
            if WearerIsPlayer()
                UDCDmain.Print("You are already doing something")
            elseif UDCDmain.AllowNPCMessage(Wearer)
                UDCDmain.Print(getWearerName() + " is already doing something")
            endif
        endif
        return false
    endif

    if (UDAM.isAnimating(Wearer))
        if !abSilent
            GWarning("Can't start minigame for " + getDeviceHeader() + " because wearer is already in animating!")
            if WearerIsPlayer()
                UDCDmain.Print("You are already doing something",1)
            elseif UDCDmain.AllowNPCMessage(Wearer)
                UDCDmain.Print(getWearerName() + " is already doing something",1)
            endif
        endif
        return false
    endif
    
    ;Allow minigames on unloaded actors
    if (Wearer.IsDead() || Wearer.IsDisabled() || Wearer.GetCurrentScene())
        if !abSilent
            GWarning("Can't start minigame for " + getDeviceHeader() + " because wearer is invalid! Dead="+Wearer.IsDead() + ",Disabled="+Wearer.IsDisabled()+",Scene+"+Wearer.GetCurrentScene())
            if WearerIsPlayer()
                UDCDmain.Print("You are already doing something",1)
            elseif UDCDmain.AllowNPCMessage(Wearer)
                UDCDmain.Print(getWearerName() + " is already doing something",1)
            endif
        endif
        return false
    endif
    
    if hasHelper()
        if (UDAM.isAnimating(_minigameHelper))
            if !abSilent
                GWarning("Can't start minigame for " + getDeviceHeader() + " because helper is already in minigame!")
                if HelperIsPlayer()
                    UDCDmain.Print("You are already doing something")
                elseif UDCDmain.AllowNPCMessage(_minigameHelper)
                    UDCDmain.Print(getHelperName() + " is already doing something",1)
                endif
            endif
            return false
        endif
        if UDCDmain.actorInMinigame(_minigameHelper)
            if !abSilent
                GWarning("Can't start minigame for " + getDeviceHeader() + " because helper is already in minigame!")
                if HelperIsPlayer()
                    UDCDmain.Print("You are already doing something")
                elseif UDCDmain.AllowNPCMessage(_minigameHelper)
                    UDCDmain.Print(getHelperName() + " is already doing something")
                endif
            endif
            return false
        endif
        
        if !libs.isValidActor(_minigameHelper)
            if !abSilent
                GWarning("Can't start minigame for " + getDeviceHeader() + " because helper is invalid!")
                if HelperIsPlayer()
                    UDCDmain.Print("You are already doing something",1)
                elseif UDCDmain.AllowNPCMessage(_minigameHelper)
                    UDCDmain.Print(getHelperName() + " is already doing something",1)
                endif
            endif
            return false
        endif
    endif
    
    if _ParalelProcessRunning()
        if !abSilent
            if WearerIsPlayer() || WearerIsFollower()
                UDCDmain.Print("Slow down!",1)
            endif
        endif
        GError("Paralel process still activated on " + getDeviceHeader() + " skipping minigame!!")
        return false
    endif
    
    return true
EndFunction

;==============================================================================================
;==============================================================================================
;==============================================================================================
;------------------------------------MINIGAME LOOP START---------------------------------------
;==============================================================================================
;==============================================================================================
;==============================================================================================

Function minigame()
    if current_device_health <= 0 ;device is already unlocked (somehow)
        UnlockRestrain()
        return
    endif
    
    if UDmain.DebugMod && PlayerInMinigame()
        showDebugMinigameInfo()
    endif
    
    _MinigameON = True
    GoToState("UpdatePaused")
    
    Bool loc_Profiling = UDmain.UDGV.UDG_MinigameProfiling.Value
    if loc_Profiling
        Debug.StartStackProfiling()
    endif
    
    bool                    loc_WearerIsPlayer                  = WearerIsPlayer()
    bool                    loc_HelperIsPlayer                  = HelperIsPlayer()
    bool                    loc_PlayerInMinigame                = loc_WearerIsPlayer || loc_HelperIsPlayer
    Bool                    loc_is3DLoaded                      = loc_PlayerInMinigame || Wearer.Is3DLoaded()
    UD_CustomDevice_NPCSlot loc_WearerSlot                      = UD_WearerSlot
    
    if loc_PlayerInMinigame
        closeMenu()
    endif
    
    _StopMinigame = False
    
    Wearer.AddToFaction(UDCDmain.MinigameFaction)
    if _minigameHelper
        _minigameHelper.AddToFaction(UDCDmain.MinigameFaction)
    endif
    
    
    if loc_is3DLoaded
        if loc_WearerSlot
            loc_WearerSlot.Send_MinigameStarter(self)
        else
            UDCDMain.UDPP.Send_MinigameStarter(Wearer,self)
        endif
    else
        MinigameStarter()
    endif
    
    
    if UDmain.TraceAllowed()
        UDCDmain.Log("Minigame started for: " + deviceInventory.getName())    
    endif
    
    Int[] hasStruggleAnimation                                  ; number of found struggle animations
    Bool   loc_StartedAnimation = False
    if loc_is3DLoaded ;only play animation if actor is loaded
        hasStruggleAnimation = _PickAndPlayStruggleAnimation()
        If hasStruggleAnimation[0] == 0
            ; clear cache and try again (cache misses are possible after changing json files)
            UDmain.Warning("UD_CustomDevice_RenderScript::minigame("+GetDeviceHeader()+") _PickAndPlayStruggleAnimation failed. Clear cache and try again")
            hasStruggleAnimation = _PickAndPlayStruggleAnimation(bClearCache = True)
            If hasStruggleAnimation[0] > 0
                loc_StartedAnimation = true
            endif
        else
            loc_StartedAnimation = true
        endif
    endif
    
    _MinigameMainLoopON = true
    
    if loc_WearerSlot
        loc_WearerSlot.Send_MinigameParalel(self)
    else
        UDCDMain.UDPP.Send_MinigameParalel(Wearer,self)
    endif
    
    float durability_onstart = current_device_health
    
    ;main loop, ends only when character run out off stats or device losts all durability
    int         tick_b                 = 0
    int         tick_s                 = 0
    float       fCurrentUpdateTime     = UDmain.UD_baseUpdateTime
    BOOL        loc_UseInterAVCheck    = True
    
    if loc_WearerSlot && loc_PlayerInMinigame
        loc_UseInterAVCheck = False
        loc_WearerSlot.StartMinigameAVCheckLoop(self)
    else
        loc_UseInterAVCheck = True
    endif
    
    if !loc_is3DLoaded
        fCurrentUpdateTime = 1.0
    elseif !loc_PlayerInMinigame
        fCurrentUpdateTime = 0.25
    endif

    _PauseMinigame = False
    
    float     loc_dmg              = (_durability_damage_mod + UD_durability_damage_add)*fCurrentUpdateTime*UD_DamageMult
    float     loc_condmult         = 1.0 + _condition_mult_add
    bool      loc_updatewidget     = loc_PlayerInMinigame && UDCDmain.UD_UseWidget && UD_UseWidget && UD_AllowWidgetUpdate
    Bool      loc_DamageDevice     = UD_damage_device
    
    while current_device_health > 0.0 && !_StopMinigame
        ;pause minigame, pause minigame need to be changed from other thread or infinite loop happens
        while _PauseMinigame && !_StopMinigame
            Utility.wait(0.1)
        endwhile
        
        if loc_UseInterAVCheck && !_StopMinigame
            if !loc_PlayerInMinigame && Wearer.IsInCombat()
                ;stop minigame if NPC is in combat
                StopMinigame()
            else
                if !ProccesAV(fCurrentUpdateTime)
                    StopMinigame()
                endif
                if hasHelper()
                    if !ProccesAVHelper(fCurrentUpdateTime)
                        StopMinigame()
                    endif
                endif
            endif
        endif
        
        if !_StopMinigame
            OnMinigameTick(fCurrentUpdateTime)
            ;reduce device durability
            if loc_DamageDevice
                decreaseDurabilityAndCheckUnlock(loc_dmg,loc_condmult)
            endif
            ;update widget
            if loc_is3DLoaded && loc_updatewidget
                updateWidget()
            endif
        endif
        
        ;--one second timer--
        if (tick_b*fCurrentUpdateTime >= 1.0) && !_StopMinigame && !_PauseMinigame && current_device_health > 0.0 ;once per second
            ;update loc vars
            loc_dmg              = (_durability_damage_mod + UD_durability_damage_add)*fCurrentUpdateTime*UD_DamageMult
            loc_condmult         = 1.0 + _condition_mult_add
            loc_DamageDevice     = UD_damage_device
            
            if loc_is3DLoaded
                loc_updatewidget     = loc_PlayerInMinigame && UDCDmain.UD_UseWidget && UD_UseWidget && UD_AllowWidgetUpdate
            endif
            
            ;check non struggle minigames
            if !loc_PlayerInMinigame
                if _CuttingGameON
                    cutDevice(fCurrentUpdateTime*UD_CutChance/5.0)
                endif
            endif
            
            tick_b = 0
            tick_s += 1
            if !_StopMinigame
                loc_is3DLoaded  = loc_PlayerInMinigame || Wearer.Is3DLoaded()
                OnMinigameTick1()
                
                if loc_is3DLoaded
                    ;update disable if it gets somehow removed every 1 s
                    UDCDMain.UpdateMinigameDisable(Wearer,loc_WearerIsPlayer as Int)
                    if _minigameHelper
                        UDCDMain.UpdateMinigameDisable(_minigameHelper,loc_HelperIsPlayer as Int)
                    endif
                endif
                
                ;--three second timer--
                ; Call child function
                if !(tick_s % 3) && tick_s
                    OnMinigameTick3()
                endif
                
                ;only check animations if actor is loaded
                if loc_is3DLoaded
                    ;--three second timer--
                    if !(tick_s % 3) && tick_s
                        ;start new animation if wearer stops animating
                        if ((hasStruggleAnimation[0] && !UDAM.isAnimating(Wearer, false)) || (_minigameHelper && hasStruggleAnimation[1] && !UDAM.isAnimating(_minigameHelper, false))) && !_PauseMinigame && !_StopMinigame
                            _PickAndPlayStruggleAnimation(bContinueAnimation = True)
                        endif
                    endif
                    ;-- alternate animation timer--
                    if UDAM.UD_AlternateAnimation && !(tick_s % UDAM.UD_AlternateAnimationPeriod) && tick_s
                        if hasStruggleAnimation[0] > 1 && !_PauseMinigame && !_StopMinigame
                        ; no need to switch to new animation if there was only one found
                            _PickAndPlayStruggleAnimation(bContinueAnimation = True)
                        endif
                    endif
                endif
            endif
        endif
        
        if !_StopMinigame && !_PauseMinigame
            Utility.wait(fCurrentUpdateTime)
            tick_b += 1
        endif
    endwhile
    
    _MinigameMainLoopON = false
    
    if loc_PlayerInMinigame
        UDCDmain.MinigameKeysUnRegister()
    endif
    
    if loc_StartedAnimation
        _StopMinigameAnimation()
    endif
    
    ;checks if Wearer succesfully escaped device
    if IsUnlocked
        if loc_WearerIsPlayer
            UDCDmain.Print("You have succesfully escaped out of " + deviceInventory.GetName() + "!",2)
        elseif UDCDmain.AllowNPCMessage(Wearer, true)
            UDCDmain.Print(getWearerName()+" succesfully escaped out of " + deviceInventory.GetName() + "!",2)
        endif
        if !loc_WearerIsPlayer
            UpdateMotivation(Wearer,50) ;increase NPC motivation on failed escape
        endif
    else
        if loc_is3DLoaded
            libs.pant(Wearer)
        endif
        if loc_PlayerInMinigame
            if _minigameHelper
                UDCDmain.Print("One of you is too exhausted to continue struggling",1)
            else
                UDCDmain.Print("You are too exhausted to continue struggling",1)
            endif
        elseif UDCDmain.AllowNPCMessage(GetWearer(), true)
            UDCDmain.Print(getWearerName()+" is too exhausted to continue struggling",1)
        endif
        if !loc_WearerIsPlayer
            UpdateMotivation(Wearer,-5) ;decrease NPC motivation on failed escape
        endif
        advanceSkill(10.0)
    endif

    ;remove disalbe from helper (can be done earlier as no devices were changed)
    if _minigameHelper && !UDOM.GetOrgasmInMinigame(_minigameHelper)
        UDCDMain.EndMinigameDisable(_minigameHelper, loc_HelperIsPlayer as Int)
    endif

    ;Wait for device to get fully removed
    while IsUnlocked && !_isRemoved
        Utility.waitMenuMode(0.1)
    endwhile

    ;remove disable from wearer
    If !UDOM.GetOrgasmInMinigame(Wearer)
        UDCDMain.EndMinigameDisable(Wearer,loc_WearerIsPlayer as Int)
    EndIf

    if UDmain.TraceAllowed()
        UDCDmain.Log(getDeviceHeader() + "::minigame() - Minigame ended",1)
    endif
    
    ;wait for paralled threads to end
    float loc_time          = 0.0
    Float loc_timeout       = 3.5
    Float loc_timeoutUpT    = 0.1
    if !loc_is3DLoaded
        loc_timeout     = 10.0
        loc_timeoutUpT  = 1.0
    endif
    
    while _ParalelProcessRunning() && loc_time <= loc_timeout
        Utility.wait(loc_timeoutUpT)
        loc_time += loc_timeoutUpT
    endwhile
    if loc_time >= loc_timeout
        UDCDMain.Error(getDeviceHeader() + "::minigame() - Minigame paralel thread timeout! _deviceControlBitMap_1 = " + IntToBit(_deviceControlBitMap_1))
    endif
    
    MinigameVarReset()
    
    OnMinigameEnd()
    
    GoToState("")
    
    if loc_Profiling
        Debug.StopStackProfiling()
    endif
    
    ;debug message
    if UDmain.DebugMod && UD_damage_device && durability_onstart != current_device_health && loc_WearerIsPlayer
        UDmain.Print("[Debug] Durability reduced: "+ formatString(durability_onstart - current_device_health,3) + "\n",1)
    endif
EndFunction

;==============================================================================================
;==============================================================================================
;==============================================================================================
;------------------------------------MINIGAME LOOP END-----------------------------------------
;==============================================================================================
;==============================================================================================
;==============================================================================================

Function _StopMinigameAnimation()
    Int loc_toggle  = 0x0
    if !UDOM.GetOrgasmInMinigame(Wearer)
        ;wearer is not orgasming, stop animation
        loc_toggle += 0x1
    endif
    if _minigameHelper && !UDOM.GetOrgasmInMinigame(_minigameHelper)
        ;helper is not orgasming, stop animation
        loc_toggle += 0x2
    endif
    if loc_toggle
        UDAM.StopAnimation(Wearer, _minigameHelper, abEnableActors = False, aiToggle = loc_toggle)
    endif
EndFunction

Function MinigameStarter()
    bool    loc_canShowHUD      = canShowHUD()
    bool    loc_haveplayer      = PlayerInMinigame()
    bool    loc_updatewidget    = UD_UseWidget && UDCDmain.UD_UseWidget && loc_haveplayer
    bool    loc_is3DLoaded      = loc_haveplayer || UDmain.ActorInCloseRange(wearer)
    
    
    UDCDMain.StartMinigameDisable(Wearer)
    if _minigameHelper
        UDCDMain.StartMinigameDisable(_minigameHelper)
    endif
    
    if loc_haveplayer
        UDCDmain.setCurrentMinigameDevice(self)
        UDCDmain.MinigameKeysRegister()
    else
        StorageUtil.SetFormValue(Wearer, "UD_currentMinigameDevice", deviceRendered)
    endif
    
    _MinigameParProc_1 = false
    
    ;shows bars
    if loc_updatewidget
        showWidget()
    endif
    if loc_canShowHUD
        showHUDbars()
    endif
    
    OnMinigameStart()
    
    if loc_is3DLoaded
        libsp.pant(Wearer)
    endif
EndFunction

Function _CheckAndUpdateAnimationCache(Bool bClearCache = False)
    ; since GetActorConstraintsInt is time-heavy saving its result here for this call
    If _minigameHelper
        _ActorsConstraints = New Int[2]
        _ActorsConstraints[0] = UDAM.GetActorConstraintsInt(Wearer)
        _ActorsConstraints[1] = UDAM.GetActorConstraintsInt(_minigameHelper)
    Else
        _ActorsConstraints = New Int[1]
        _ActorsConstraints[0] = UDAM.GetActorConstraintsInt(Wearer)
    EndIf

    If bClearCache || _ActorsConstraints[0] != _PlayerLastConstraints
        _PlayerLastConstraints = _ActorsConstraints[0]
        _StruggleAnimationDefPairArray = PapyrusUtil.StringArray(0)
        _StruggleAnimationDefActorArray = PapyrusUtil.StringArray(0)
        _StruggleAnimationDefPairLastIndex = -1
        _StruggleAnimationDefActorLastIndex = -1
    EndIf
    If _minigameHelper
        If bClearCache || _ActorsConstraints[1] != _HelperLastConstraints
            _HelperLastConstraints = _ActorsConstraints[1]
            _StruggleAnimationDefPairArray = PapyrusUtil.StringArray(0)
            _StruggleAnimationDefHelperArray = PapyrusUtil.StringArray(0)
            _StruggleAnimationDefPairLastIndex = -1
            _StruggleAnimationDefHelperLastIndex = -1
        EndIf
    EndIf
EndFunction

Int[] Function _PickAndPlayStruggleAnimation(Bool bClearCache = False, Bool bContinueAnimation = False)
    Int[] result = new Int[2]           ; number of found struggle animations for each actor
    String _animationDef = ""
    
    If !bClearCache && !bContinueAnimation
        _CheckAndUpdateAnimationCache(bClearCache)
    EndIf

    ; filling struggle keywords list
    String[] keywordsList
    If UDAM.UD_UseSingleStruggleKeyword
        keywordsList = new String[1]
        keywordsList[0] = "." + UD_DeviceKeyword_Minor.GetString()
    Else
        keywordsList = UD_DeviceStruggleKeywords
    EndIf
    
    If _minigameHelper
        If _StruggleAnimationDefPairArray.Length == 0
            _StruggleAnimationDefPairArray = UDAM.GetStruggleAnimationsByKeywordsList(keywordsList, Wearer, _minigameHelper, True)
        EndIf
        If _StruggleAnimationDefPairArray.Length == 0
            ; if actor has heavy bondage then try to get paired animation for it
            Keyword heavyBondage = UDAM.GetHeavyBondageKeyword(_ActorsConstraints[0])
            If heavyBondage != None
                _StruggleAnimationDefPairArray = UDAM.GetStruggleAnimationsByKeyword("." + heavyBondage.GetString(), Wearer, _minigameHelper, True)
            EndIf            
        EndIf
        If _StruggleAnimationDefPairArray.Length > 0
        ; using paired animation
            Int anim_index = Utility.RandomInt(0, _StruggleAnimationDefPairArray.Length - 1)
            If !bContinueAnimation || anim_index != _StruggleAnimationDefPairLastIndex
            ; start new animation
                _StruggleAnimationDefPairLastIndex = anim_index
                _animationDef = _StruggleAnimationDefPairArray[anim_index]
                If UDAM.PlayAnimationByDef(_animationDef, ActorArray2(Wearer, _minigameHelper), _ActorsConstraints, bContinueAnimation, abDisableActors = False)
                    result[0] = _StruggleAnimationDefPairArray.Length
                    result[1] = _StruggleAnimationDefPairArray.Length
                EndIf
            Else
            ; keep animation that is currently played
                result[0] = _StruggleAnimationDefPairArray.Length
                result[1] = _StruggleAnimationDefPairArray.Length
            EndIf
        Else
        ; using solo animation for actors
            If _StruggleAnimationDefActorArray.Length == 0
                _StruggleAnimationDefActorArray = _GetSoloStruggleAnimation(keywordsList, Wearer, _ActorsConstraints[0])
            EndIf
            If _StruggleAnimationDefHelperArray.Length == 0
                String[] helperKeywordsList = New String[1]
                helperKeywordsList[0] = ".spectator"
                _StruggleAnimationDefHelperArray = _GetSoloStruggleAnimation(helperKeywordsList, _minigameHelper, _ActorsConstraints[1])
            EndIf
            
            UDAM.SetActorHeading(Wearer, _minigameHelper)
            UDAM.SetActorHeading(_minigameHelper, Wearer)
            
            If _StruggleAnimationDefActorArray.Length > 0
                Int anim_index = Utility.RandomInt(0, _StruggleAnimationDefActorArray.Length - 1)
                If !bContinueAnimation || anim_index != _StruggleAnimationDefActorLastIndex
                    ; start new animation
                    _StruggleAnimationDefActorLastIndex = anim_index
                    _animationDef = _StruggleAnimationDefActorArray[anim_index]
                    If UDAM.PlayAnimationByDef(_animationDef, ActorArray1(Wearer), IntArray1(_ActorsConstraints[0]), bContinueAnimation, abDisableActors = False)
                        result[0] = _StruggleAnimationDefActorArray.Length
                    EndIf
                Else
                    ; keep animation that is currently played
                    result[0] = _StruggleAnimationDefActorArray.Length
                EndIf
            EndIf

            If _StruggleAnimationDefHelperArray.Length > 0
                Int anim_index = Utility.RandomInt(0, _StruggleAnimationDefHelperArray.Length - 1)
                If !bContinueAnimation || anim_index != _StruggleAnimationDefHelperLastIndex
                    ; start new animation
                    _StruggleAnimationDefHelperLastIndex = anim_index
                    _animationDef = _StruggleAnimationDefHelperArray[anim_index]
                    If UDAM.PlayAnimationByDef(_animationDef, ActorArray1(_minigameHelper), IntArray1(_ActorsConstraints[1]), bContinueAnimation, abDisableActors = False)
                        result[1] = _StruggleAnimationDefHelperArray.Length
                    EndIf
                Else
                    ; keep animation that is currently played
                    result[1] = _StruggleAnimationDefHelperArray.Length
                EndIf
            EndIf
        EndIf
    Else
        If _StruggleAnimationDefActorArray.Length == 0
            _StruggleAnimationDefActorArray = _GetSoloStruggleAnimation(keywordsList, Wearer, _ActorsConstraints[0])
        EndIf
        If _StruggleAnimationDefActorArray.Length > 0
            _animationDef = _StruggleAnimationDefActorArray[Utility.RandomInt(0, _StruggleAnimationDefActorArray.Length - 1)]
            If UDAM.PlayAnimationByDef(_animationDef, ActorArray1(Wearer), _ActorsConstraints, bContinueAnimation, abDisableActors = False)
                result[0] = _StruggleAnimationDefActorArray.Length
            EndIf
        EndIf
    EndIf
    Return result
EndFunction

String[] Function _GetSoloStruggleAnimation(String[] asKeywords, Actor akActor, Int aiConstraints)
    String[] result
    result = UDAM.GetStruggleAnimationsByKeywordsList(asKeywords, akActor, None, True)
    If result.Length == 0
        ; if actor has heavy bondage then try to get solo animation for it
        Keyword heavyBondage = UDAM.GetHeavyBondageKeyword(aiConstraints)
        If heavyBondage != None
            result = UDAM.GetStruggleAnimationsByKeyword("." + heavyBondage.GetString(), akActor, None, True)
        EndIf
    EndIf
    If result.Length == 0
        result = UDAM.GetStruggleAnimationsByKeyword(".zad_DeviousGloves", akActor, None, True)
    EndIf
    If result.Length == 0
        ; horny animation is our last hope!
        result = UDAM.GetStruggleAnimationsByKeyword(".horny", akActor, None, True)
    EndIf
    Return result
EndFunction

Actor[] Function ActorArray1(Actor actor1)
    Actor[] arr = new Actor[1]
    arr[0] = actor1
    Return arr
EndFunction

Actor[] Function ActorArray2(Actor actor1, Actor actor2)
    Actor[] arr = new Actor[2]
    arr[0] = actor1
    arr[1] = actor2
    Return arr
EndFunction

Int[] Function IntArray1(Int i1)
    Int[] arr = new Int[1]
    arr[0] = i1
    Return arr
EndFunction

Function MinigameVarReset()
    if Wearer
        Wearer.RemoveFromFaction(UDCDmain.MinigameFaction)
    endif
    
    if _minigameHelper
        _minigameHelper.RemoveFromFaction(UDCDmain.MinigameFaction)
    endif
    
    UnsetMinigameDevice()
    
    _MinigameON = False
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
    
    if _StruggleGameON
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
    elseif _RepairLocksMinigameON
        Game.AdvanceSkill("Smithing" , loc_mult*(0.75*UDCDmain.UD_BaseDeviceSkillIncrease*fMult/1.0)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
    elseif _CuttingGameON
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
    
    if _KeyGameON
        if !libs.Config.DisableLockJam && UDCDMain.KeyIsGeneric(zad_deviceKey) && (Utility.randomInt() <= zad_KeyBreakChance*UDCDmain.CalculateKeyModifier())
            if PlayerInMinigame()
                debug.messagebox("You managed to insert the key but it snapped. Its remains also jammed the lock! You will have to find other way to escape.")
            endif
            
            Wearer.RemoveItem(zad_deviceKey)
            
            JammNthLock(_MinigameSelectedLockID)
            ;UD_JammedLocks += 1
            
            SetJammStatus()
            stopMinigame()
            _KeyGameON = False
            OnLockJammed()
            return
        endif
    endif

    OnCritFailure()
EndFunction

;function called when player correctly press crit button
Function critDevice()
    if OnCritDevicePre() && !IsUnlocked && _MinigameON
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
    
        if UD_damage_device && _StruggleGameON
            if getStruggleMinigameSubType() == 2 
                decreaseDurabilityAndCheckUnlock(UD_StruggleCritMul*(_durability_damage_mod + UD_durability_damage_add)*getModResistMagicka(1.0,0.25)*UD_DamageMult)
            else
                decreaseDurabilityAndCheckUnlock(UD_StruggleCritMul*(_durability_damage_mod + UD_durability_damage_add)*getModResistPhysical(1.0,0.25)*UD_DamageMult)
            endif
        elseif _LockpickGameON
            lockpickDevice()
        elseif _KeyGameON
            keyUnlockDevice()
        elseif _CuttingGameON
            cutDevice(UD_StruggleCritMul*UD_CutChance/3.0)
        elseif _RepairLocksMinigameON
            repairLock(15.0*UD_MinigameMult1)
        endif
        
        OnCritDevicePost()
        Bool loc_playerInMinigame = PlayerInMinigame()
        if Wearer && (loc_playerInMinigame || Wearer.Is3DLoaded())
            if loc_playerInMinigame && UDCDmain.UD_UseWidget && UD_UseWidget
                updateWidget()
            endif
            if loc_playerInMinigame || UDmain.ActorInCloseRange(wearer)
                libs.Pant(Wearer)
            endif
        endif
        
        advanceSkill(4.0)
    endif
EndFunction

;function called when player press special button
Function SpecialButtonPressed(float fMult = 1.0)
    if _CuttingGameON
        cutDevice(fMult*UD_CutChance/12.5)
    elseif _KeyGameON || _LockpickGameON || _RepairLocksMinigameON
        if !_usingTelekinesis
            _usingTelekinesis = true
            UD_minigame_magicka_drain = 0.5*UD_base_stat_drain + Wearer.getBaseAV("Magicka")*0.02
            if HasHelper()
                UD_minigame_magicka_drain_helper = 0.5*UD_base_stat_drain + _minigameHelper.getBaseAV("Magicka")*0.02
            endif
            if _RepairLocksMinigameON
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
    if _KeyGameON || _LockpickGameON
        if _usingTelekinesis
            _usingTelekinesis = false
            UD_minigame_magicka_drain = 0
            UD_minigame_magicka_drain_helper = 0
            if _RepairLocksMinigameON
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
        if _MinigameON
            OnMinigameOrgasm(sexlab)
            OnMinigameOrgasmPost()
        endif
        OnOrgasmPost(sexlab)
    endif
EndFunction

;function called when wearer is edged
Function edge()
    if OnEdgePre()
        if _MinigameON
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
    if IsUnlocked
        if UDmain.TraceAllowed()        
            UDCDmain.Log("unlockRestrain()"+getDeviceHeader()+": Device is already unlocked! Aborting ",1)
        endif
        return
    endif
    IsUnlocked = True
    GoToState("UpdatePaused")
    
    if _MinigameON
        stopMinigame()
    endif
    
    if UDmain.TraceAllowed()
        UDCDmain.Log("unlockRestrain() called for " + self,1)
    endif

    current_device_health = 0.0
    if WearerIsPlayer()
        UDCDmain.updateLastOpenedDeviceOnRemove(self)
    endif

    StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
    ;if wearer.isinfaction(UDCDmain.minigamefaction)
    ;    wearer.removefromfaction(UDCDmain.minigamefaction)
    ;endif
    
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
    UDCDmain.currentDeviceMenu_switch1 = HaveLocks()
    int res = UDCDmain.DetailsMessage.show()
    if res == 0 
        ShowBaseDetails()
    elseif res == 1
        ShowLockDetails()
    elseif res == 2
        ShowModifiers()
    elseif res == 3
        UDCDmain.showActorDetails(GetWearer())
    elseif res == 4
        showDebugInfo()
    else
        return
    endif
EndFunction

;show base device details
Function ShowBaseDetails()
    updateDifficulty()
    float loc_accesibility = getAccesibility()
    string loc_res = ""
    loc_res += "- " + deviceInventory.GetName() + " -\n"
    loc_res += "Level: " + UD_Level + "\n"
    loc_res += "Type: " + UD_DeviceType + "\n"
    loc_res += ("Device health: " + formatString(current_device_health,1)+"/"+ formatString(UD_Health,1)+ "\n")
    loc_res += "Condition: " + getConditionString() + " ("+formatString(getRelativeCondition()*100,1)+"%)\n"
    loc_res += "Accesibility: " + Round(100.0*loc_accesibility) + "%\n"
    
    loc_res += "Difficutly: "
    if (UD_durability_damage_base >= 2.5)
        loc_res += "Very Easy\n"
    elseif (UD_durability_damage_base >= 1.5)
        loc_res += "Easy\n"
    elseif (UD_durability_damage_base >= 0.75)
        loc_res += "Normal\n"
    elseif (UD_durability_damage_base >= 0.3)
        loc_res += "Hard\n"
    elseif (UD_durability_damage_base >= 0.05)
        loc_res += "Very Hard\n"
    elseif UD_durability_damage_base > 0
        loc_res += "Extreme\n"
    else
        loc_res += "Impossible\n"
    endif
    
    bool loc_showhitres = canBeCutted()
    bool loc_showstrres = canBeStruggled(loc_accesibility)
    if loc_showstrres && !loc_showhitres
        loc_res += "Resist: "
        loc_res += "P = " + Round(getModResistPhysical(0.0)*-100.0) + "/XXX %/"
        loc_res += "M = " + Round(getModResistMagicka(0.0)*-100.0) + " %\n"
    elseif loc_showhitres && !loc_showstrres
        loc_res += "Resist: "
        loc_res += "P = XXX/" + Round(UD_WeaponHitResist*100.0) + "%/"
        loc_res += "M = XXX\n"
    elseif loc_showhitres && loc_showstrres
        loc_res += "Resist: "
        loc_res += "P = " + Round(getModResistPhysical(0.0)*-100.0) + "/"+Round(UD_WeaponHitResist*100.0)+" %/"
        loc_res += "M = " + Round(getModResistMagicka(0.0)*-100.0) + " %\n"
    elseif loc_accesibility == 0
        loc_res += "Resist: Inescapable\n"
    else
        loc_res += "Resist: Indestructable\n"
    endif
    
    if HaveLocks()
        loc_res += "Number of locks: " + GetLockedLocks() + "/" + GetLockNumber() + "\n"
        loc_res += "Lock multiplier: " + Round((1.0 + _getLockMinigameModifier())*100.0) + " %\n"
    else
        loc_res += "Device have no locks\n"
    endif
    
    loc_res += "Key: "
    if zad_deviceKey
        loc_res += zad_deviceKey.GetName() + "\n"
    else
        loc_res += "None\n"
    endif
    
    if UDmain.UDGV.UDG_ShowCritVars.Value
        loc_res += "Crit chance: "+UD_StruggleCritChance+" %\n"
        loc_res += "Crit duration: "+formatString(UD_StruggleCritDuration,1)+" s\n"
        loc_res += "Crit mult: "+formatString(UD_StruggleCritMul*100,1)+" %\n"
    endif
    
    if canBeCutted()
        loc_res += "Cut chance: " + formatString(UD_CutChance,1) + " %\n"
    else
        loc_res += "Cut chance: Uncuttable\n"
    endif

    if isNotShareActive()
        loc_res += "Active effect: " + UD_ActiveEffectName + "\n"
        loc_res += "Can be activated: " + canBeActivated() + "\n"
        if UD_Cooldown > 0
            loc_res += "Cooldown: " + Round(UD_Cooldown*0.75*UDCDmain.UD_CooldownMultiplier) + " - " + Round(UD_Cooldown*1.25*UDCDmain.UD_CooldownMultiplier) +" min\n"
        else
            loc_res += "Cooldown: NONE\n"
        endif
    endif
    loc_res += addInfoString()
    UDmain.ShowMessageBox(loc_res)
EndFunction

bool Function Details_CanShowResist()
    return true
EndFunction 

bool Function Details_CanShowHitResist()
    return true
EndFunction 

;shows details about modifiers
Function ShowModifiers()
    string loc_res = "-Modifiers-\n"
    if !canBeStruggled() 
        loc_res += "!Impossible to struggle from!\n"
    endif
    
    if (haveRegen())
        loc_res += ("Regeneration ("+ formatString(getModifierIntParam("Regen")/24.0,1) +"/h)\n")
    endif
    if hasModifier("_HEAL")
        loc_res += "Healer ("+  formatString(getModifierIntParam("_HEAL")/24.0,1) +"/h)\n"
    endif
    if hasModifier("DOR")
        loc_res += "Destroy on unlock\n"
    endif
    
    if hasModifier("MAH")
        loc_res += "Random manifest (" + getModifierIntParam("MAH",0) +" %)\n"
    endif
    
    if hasModifier("MAO")
        loc_res += "Orgasm manifest (" + getModifierIntParam("MAO",0) +" %)\n"
    endif
    
    if hasModifier("_L_CHEAP")
        loc_res += "Cheap locks (" + getModifierIntParam("_L_CHEAP",0) +" %)\n"
    endif
    
    if UD_OnDestroyItemList
        loc_res += "Contains Items\n"
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
            
            if loc_min2 != loc_max2
                loc_res += "Contains Gold ("+ loc_min2 +"-"+ loc_max2 +" G)\n"
            else
                loc_res += "Contains Gold ("+ loc_max2 +" G)\n"
            endif
        else
            loc_res += "Contains Gold ("+ loc_min +" G)\n"
        endif
    endif    

    if (isSentient())
        loc_res += "Sentient (" + formatString(getModifierFloatParam("Sentient"),1) +" %)\n"
    Endif
    
    if (isLoose())
        loc_res += "Loose (" + formatString(getModifierFloatParam("Loose")*100,1) +" %)\n"
    Endif
    
    if deviceRendered.hasKeyword(UDlibs.PatchedDevice)
        loc_res += "Patched device ("+Round(UDCDmain.UDPatcher.GetPatchDifficulty(self)*100.0)+" %)\n"
    endif
    UDmain.ShowMessageBox(loc_res)
EndFunction

Function showDebugMinigameInfo()
    string res = ""
    res += "Wearer: " + getWearerName() + "\n"
    if hasHelper()
        res += "Helper: " + getHelperName() + "\n"
    endif
    
    if _StruggleGameON
        res += "Struggle type: " + _struggleGame_Subtype + "\n"
    endif
    res += "Damage modifier: " + Round(UD_DamageMult*100.0) + " %\n"
    if UD_damage_device
        res += "Base DPS: " + formatString(UD_durability_damage_base,4) + " DPS\n"
        res += "DPS bonus: " + formatString(UD_durability_damage_add,2) + " DPS\n"
        res += "Total DPS: " + (_durability_damage_mod + UD_durability_damage_add)*UD_DamageMult + " DPS\n"
        res += "Total increase: " + formatString((((_durability_damage_mod + UD_durability_damage_add)*UD_DamageMult)/UD_durability_damage_base)*100 - 100.0,2) + " %\n"
    elseif _CuttingGameON
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
    UDmain.ShowMessageBox(res)
EndFunction

Function ShowLockDetails()
    while True
        Int loc_lockId = UserSelectLock()
        
        if loc_lockId < 0 || loc_lockId == GetLockNumber()
            return
        endif
        
        string loc_res = ""
        loc_res += "Name: "+ GetNthLockName(loc_lockId)+ "\n"
        loc_res += "Status: "
        
        Bool loc_ShowDiff   = True
        Bool loc_ShowAcc    = True
        Bool loc_ShowShield = True
        if IsNthLockUnlocked(loc_lockId)
            loc_res += "UNLOCKED\n"
            loc_ShowDiff   = False
            loc_ShowAcc    = False
            loc_ShowShield = False
        elseif IsNthLockJammed(loc_lockId)
            loc_res += "JAMMED\n"
        elseif IsNthLockTimeLocked(loc_lockId) && GetNthLockTimeLock(loc_lockId)
            loc_res += "TIME LOCKED\n"
            loc_res += "Timelock: "+ GetNthLockTimeLock(loc_lockId) + " hours\n"
        else
            loc_res += "LOCKED\n"
        endif
        
        if loc_ShowShield
            Int loc_shields = GetNthLockShields(loc_lockId)
            if loc_shields
                loc_res += "Shields: " + loc_shields + "\n"
            else
                loc_res += "Shields: NONE\n"
            endif
        endif
        if loc_ShowAcc
            Int loc_acc  = GetNthLockAccessibility(loc_lockId)
            Int loc_cacc = GetLockAccesChance(loc_lockId)
            
            loc_res += "Base Access: "+_GetLockAccessibilityString(loc_acc) + " ("+ loc_acc +"%)\n"
            loc_res += "Current Access: "+_GetLockAccessibilityString(loc_cacc)+ " ("+ loc_cacc +"%)\n"
        endif
        if loc_ShowDiff
            Int loc_diff = GetNthLockDifficulty(loc_lockId)
            loc_res += "Difficulty: "+ _GetLockpickLevelString(GetLockpickLevel(-1,loc_diff)) + " ("+loc_diff+ ")\n"
        endif
        UDmain.ShowMessageBox(loc_res)
        ;Utility.wait(0.05)
    endwhile
EndFunction

Function showRawModifiers()
    int i = 0
    string res = "-RAW MODIFIERS-\n"
    while i < UD_Modifiers.length
        res += UD_Modifiers[i] + "\n"
        i += 1
    endwhile
    UDmain.ShowMessageBox(res)
EndFunction

Function showDebugInfo()
    UDmain.ShowMessageBox(getDebugString())
    showRawModifiers()
EndFunction

;returns debug string
string Function getDebugString()
    updateDifficulty()
    string res = ""
    res += "- " + deviceInventory.GetName() + " -\n"
    if (zad_JammLockChance > 0)
        res += "Lock jam chance: "+ zad_JammLockChance + " (" + Round(checkLimit(zad_JammLockChance*UDCDmain.CalculateKeyModifier(),100.0)) +") %\n"
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
    if UDmain.TraceAllowed()
        UDmain.Log("UD_CustomDevice_RenderScript::addStruggleExhaustion("+getDeviceHeader()+") called")
    endif
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
        if _CuttingGameON
            if !PlayerInMinigame() && UDCDmain.AllowNPCMessage(getWearer(), True)
                UDCDmain.Print(getWearerName() + " managed to cut "+getDeviceName()+" and reduce durability by big amount!",3)
            endif
        else
            if !PlayerInMinigame() && UDCDmain.AllowNPCMessage(getWearer(), True)
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
    Float loc_RepairProgress = UpdateNthLockRepairProgress(_MinigameSelectedLockID,progress_add*UDCDmain.getStruggleDifficultyModifier())
    if loc_RepairProgress >= getLockDurability()
        loc_RepairProgress = UpdateNthLockRepairProgress(_MinigameSelectedLockID,-1*getLockDurability()) ;reset value
        JammNthLock(_MinigameSelectedLockID, False)
        if !GetJammedLocks()
            libs.UnJamLock(Wearer,UD_DeviceKeyword)
        endif
        stopMinigame()
        if WearerIsPlayer()
            UDmain.Print("You repaired " +GetDeviceName()+"s "+UD_LockNameList[_MinigameSelectedLockID]+"! ",1)
        elseif UDCDmain.AllowNPCMessage(Wearer, True)
            UDmain.Print(GetWearerName() + " managed to repair " +GetDeviceName()+"s "+UD_LockNameList[_MinigameSelectedLockID],2)
        endif
    endif
EndFunction

;starts vannila lockpick minigame if lock is reached
Function lockpickDevice()
    if _LockpickGameON && (UD_CurrentLocks - UD_JammedLocks > 0)
        int result = 0
        if PlayerInMinigame()
            PauseMinigame() ;pause minigame untill lockpick minigame starts
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
            Int loc_difficulty = GetNthLockDifficulty(_MinigameSelectedLockID)
            UDCDmain.ReadyLockPickContainer(loc_difficulty,Wearer)
            UDCDmain.startLockpickMinigame()
            
            float loc_elapsedTime = 0.0
            float loc_maxtime = 20.0 - (loc_difficulty/100.0)*10.0
            bool loc_msgshown = false
            while (!UDCDmain.LockpickMinigameOver) && loc_elapsedTime <= loc_maxtime
                Utility.WaitMenuMode(0.05)
                loc_elapsedTime += 0.05
                
                if !loc_msgshown && loc_elapsedTime > loc_maxtime*0.75 ;only 25% time left, warn player
                    if Utility.randomInt(0,1)
                        UDmain.Print("Your hands are sweating")
                    else
                        UDmain.Print("Your hands starting to tremble")
                    endif
                    loc_msgshown = true
                endif
            endwhile
        
            result = UDCDmain.lockpickMinigameResult     ;first we fetch lockpicking result
            UDCDmain.DeleteLockPickContainer()           ;then we remove the container so IsLocked is not called on None
            
            if loc_elapsedTime >= loc_maxtime
                if UDmain.IsLockpickingMenuOpen()
                    closeLockpickMenu()
                endif
                UDCDmain.Print("You lost focus and broke the lockpick!")
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
            UnPauseMinigame()
        else
            if Utility.randomInt(1,99) >= getLockpickLevel(_MinigameSelectedLockID)*15
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
                _LockpickGameON = False
        elseif result == 1 ;succes
            Int loc_shields = GetNthLockShields(_MinigameSelectedLockID)
            if loc_shields > 0 ;lock have shields, needs to unlock them first
                loc_shields = DecreaseLockShield(_MinigameSelectedLockID,1)
                if loc_shields
                    if PlayerInMinigame()
                        UDCDmain.Print("You succesfully unlocked one of the locks shields! Shields: [" + loc_shields + "]",1)
                    elseif UDCDmain.AllowNPCMessage(Wearer, True)
                        UDCDmain.Print(getWearerName() + " unlocked one of the locks shields! Shields: [" + loc_shields + "]",2)
                    endif
                else
                    if PlayerInMinigame()
                        UDCDmain.Print("You succesfully unlocked all of the shields!",1)
                    elseif UDCDmain.AllowNPCMessage(Wearer, True)
                        UDCDmain.Print(getWearerName() + " unlocked all of the shields!",2)
                    endif
                endif
            else ;no more shields on device, unlock the lock
                UnlockNthLock(_MinigameSelectedLockID)
                if PlayerInMinigame()
                    UDCDmain.Print("You succesfully unlocked the "+UD_LockNameList[_MinigameSelectedLockID]+"!",1)
                elseif UDCDmain.AllowNPCMessage(Wearer, True)
                    UDCDmain.Print(getWearerName() + " unlocked one of the "+UD_LockNameList[_MinigameSelectedLockID]+"!",2)
                endif
                onLockUnlocked(True)
                stopMinigame() ;stop minigame, as player needs to select next lock manually
            endif
            if UD_CurrentLocks == 0 && UD_JammedLocks == 0 ;device gets unlocked
                if PlayerInMinigame()
                    UDCDmain.Print("You succesfully unlocked the last lock and removed the "+GetDeviceName()+"!",1)
                elseif UDCDmain.AllowNPCMessage(Wearer, True)
                    UDCDmain.Print(getWearerName() + " unlocked last lock and removed the "+GetDeviceName()+"!",2)
                endif
                unlockRestrain()
                stopMinigame()
                _LockpickGameON = False
                OnDeviceLockpicked()
            elseif UD_CurrentLocks == UD_JammedLocks ;device have no more free locks
                stopMinigame()
                _LockpickGameON = False
                SetJammStatus()
            endif
        elseif result == 2 ;failure
            if Utility.randomInt() <= zad_JammLockChance*UDCDmain.CalculateKeyModifier() && !libs.Config.DisableLockJam
                if PlayerInMinigame()
                    UDCDmain.Print("Your lockpick jammed the lock!",1)
                elseif UDCDmain.AllowNPCMessage(Wearer, True)
                    UDCDmain.Print(getWearerName() + "s "+getDeviceName()+" lock gets jammed!",3)
                endif
                
                JammNthLock(_MinigameSelectedLockID)
                SetJammStatus()
                stopMinigame()
                _LockpickGameON = False
                OnLockJammed()
            else
                int loc_lockpicks = getWearer().GetItemCount(libs.Lockpick)
                if hasHelper()
                    loc_lockpicks += getHelper().GetItemCount(libs.Lockpick)
                endif
                if loc_lockpicks == 0
                    stopMinigame()
                    _LockpickGameON = False
                endif
            endif
        endif
    endif
EndFunction

;unlock one of the locks if lock is reached
Function keyUnlockDevice()
    UnlockNthLock(_MinigameSelectedLockID)
    
    stopMinigame()
    
    if PlayerInMinigame()
        UDCDMain.Print("You managed to unlock "+GetDeviceName()+"s "+GetNthLockName(_MinigameSelectedLockID)+"!",1)
    elseif UDCDmain.AllowNPCMessage(Wearer, True)
        UDCDMain.Print(getWearerName() + " managed to unlock "+GetDeviceName()+"s "+GetNthLockName(_MinigameSelectedLockID)+"!",2)
    endif
    
    if zad_DestroyKey
        if _minigameHelper && _minigameHelper.GetItemCount(zad_deviceKey)
            _minigameHelper.RemoveItem(zad_deviceKey,1) ;first remove helper key
        else
            Wearer.RemoveItem(zad_deviceKey,1) ;then remove wearer key
        endif
    elseif UDCDMain.KeyIsGeneric(zad_deviceKey) && UDCDmain.UD_KeyDurability > 0
        if _minigameHelper && _minigameHelper.GetItemCount(zad_deviceKey)
            UDCDMain.ReduceKeyDurability(_minigameHelper, zad_DeviceKey)
        else
            Int loc_dur = UDCDMain.ReduceKeyDurability(Wearer, zad_DeviceKey)
            if !loc_dur
                if PlayerInMinigame()
                    UDCDMain.Print("Key "+ zad_DeviceKey.GetName() +" gets destroyed",1)
                elseif UDCDmain.AllowNPCMessage(Wearer, True)
                    UDCDMain.Print(getWearerName() + "'s key "+ zad_DeviceKey.GetName() +" gets destroyed",1)
                endif
            else
                if PlayerInMinigame()
                    UDCDMain.Print("Remaining durability of key " + zad_DeviceKey.GetName() + " = [" + loc_dur+"]",2)
                endif
            endif
        endif
    endif
    
    if UD_CurrentLocks == 0
        unlockRestrain()
        OnDeviceUnlockedWithKey()
    else
        onLockUnlocked(false)
    endif
EndFunction

Function AddJammedLock(int iChance = 5, string strMsg = "", int iNumber = 1)
    if !libs.Config.DisableLockJam
        if Utility.randomInt(1,99) >= iChance
            return
        endif
        
        while iNumber && JammRandomLock()
            iNumber -= 1
        endwhile
        
        ;UD_JammedLocks += iNumber
        
        ;if UD_JammedLocks > UD_CurrentLocks
        ;    UD_JammedLocks = UD_CurrentLocks
        ;endif
        
        SetJammStatus()
        
        if strMsg != ""
            UDCDmain.Print(strMsg,2)
        endif
        
        OnLockJammed()
    endif
EndFunction

Function SetJammStatus()
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
    if onWeaponHitPre(source)
        onWeaponHitPost(source)
    endif
EndFunction

;function called when wearer is hit by source spell
Function spellHit(Spell source)
    if onSpellHitPre(source)
        onSpellHitPost(source)
    endif
EndFunction

bool Function CooldownActivate()
    if OnCooldownActivatePre()
        if UDmain.TraceAllowed()        
            UDCDmain.Log(getDeviceHeader() + " cooldown activate",1)
        endif
        OnCooldownActivatePost()
        resetCooldown(1.0)
        return true
    else
        return false
    endif
EndFunction

bool Function isNotShareActive()
    return UD_ActiveEffectName != "Share" && UD_ActiveEffectName != "none" && UD_ActiveEffectName != ""
EndFunction

Function ValidateJammedLocks()
    if GetJammedLocks() && UD_CurrentLocks
        if !libs.IsLockJammed(getWearer(), UD_DeviceKeyword)
            UDmain.CLog(getDeviceHeader() + " is unjammed but have jammed locks. Unjamming")
            JammAllLocks(False)
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

Function RemoveAllAbilities(Actor akActor)
    int loc_abilityId = UD_DeviceAbilities.length
    while loc_abilityId
        loc_abilityId -= 1
        akActor.RemoveSpell(UD_DeviceAbilities[loc_abilityId] as Spell)
    endwhile
EndFunction

;Priority for AI
Int Function GetAiPriority()
    return 25 ;generic value
EndFunction

;choose the best minigame and start it. Returns false if minigame was not started
Bool Function EvaluateNPCAI()
    Int     loc_minigameStarted     = 0
    Float   loc_durabilityBefore    = current_device_health
    Int     loc_LocksBefore         = UD_CurrentLocks

    updateDifficulty()

    ;50% chance to first check locks, then struggle
    if Utility.randomInt(0,1)
        float   loc_accesibility    = 1.0
        if !loc_minigameStarted
            loc_accesibility        = getAccesibility()
        endif
        Int loc_lockMinigames
        if !loc_minigameStarted
            loc_lockMinigames       = LockMinigameAllowed(loc_accesibility)
        endif
        ;first try to unlock the device with key
        if !loc_minigameStarted && Math.LogicalAnd(loc_lockMinigames,0x2)
            if keyMinigame(True)
                loc_minigameStarted = 3
            endif
        endif
        ;try to repair the locks then
        if !loc_minigameStarted && Math.LogicalAnd(loc_lockMinigames,0x4)
            if repairLocksMinigame(True)
                loc_minigameStarted = 4
            endif
        endif
        ;then try to use lockpicks
        if !loc_minigameStarted && Math.LogicalAnd(loc_lockMinigames,0x1)
            if lockpickMinigame(True)
                loc_minigameStarted = 2
            endif
        endif
        ;then try to struggle
        if !loc_minigameStarted && StruggleMinigameAllowed(loc_accesibility)
            Int loc_minigame = Utility.randomInt(0,2)
            if struggleMinigame(loc_minigame, True) ;start random struggle minigame
                loc_minigameStarted = 1
            endif
        endif
        ;lastly try cutting
        if !loc_minigameStarted && CuttingMinigameAllowed(loc_accesibility)
            if cuttingMinigame(True)
                loc_minigameStarted = 5
            endif
        endif
    else
        float   loc_accesibility    = 1.0
        if !loc_minigameStarted
            loc_accesibility        = getAccesibility()
        endif
        ;then try to struggle
        if !loc_minigameStarted && StruggleMinigameAllowed(loc_accesibility)
            Int loc_minigame = Utility.randomInt(0,2)
            if struggleMinigame(loc_minigame, True) ;start random struggle minigame
                loc_minigameStarted = 1
            endif
        endif
        ;lastly try cutting
        if !loc_minigameStarted && CuttingMinigameAllowed(loc_accesibility)
            if cuttingMinigame(True)
                loc_minigameStarted = 5
            endif
        endif
        Int loc_lockMinigames
        if !loc_minigameStarted
            loc_lockMinigames       = LockMinigameAllowed(loc_accesibility)
        endif
        ;first try to unlock the device with key
        if !loc_minigameStarted && Math.LogicalAnd(loc_lockMinigames,0x2)
            if keyMinigame(True)
                loc_minigameStarted = 3
            endif
        endif
        ;try to repair the locks then
        if !loc_minigameStarted && Math.LogicalAnd(loc_lockMinigames,0x4)
            if repairLocksMinigame(True)
                loc_minigameStarted = 4
            endif
        endif
        ;then try to use lockpicks
        if !loc_minigameStarted && Math.LogicalAnd(loc_lockMinigames,0x1)
            if lockpickMinigame(True)
                loc_minigameStarted = 2
            endif
        endif
    endif
    
    if loc_minigameStarted && UDmain.UDGV.UDG_AIMinigameInfo.Value
        GInfo(GetDeviceHeader()+"::EvaluateNPCAI() - Stats after minigame ["+loc_minigameStarted+"] = durability reduced="+ (loc_durabilityBefore - current_device_health) + " , Locks unlocked="+ (loc_LocksBefore - UD_CurrentLocks))
    endif
    
    return loc_minigameStarted
EndFunction

Float Function ValidateAccessibility(Float afValue)
    if UDCDmain.UD_HardcoreAccess && afValue < 0.9
        return 0.0
    endif
    return fRange(afValue,0.0,1.0)
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
    resetCooldown(1.0)
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
    OnMinigameOrgasmPost()
EndFunction

Function OnMinigameOrgasmPost()
EndFunction

Function OnOrgasmPost(bool sexlab = false)
EndFunction

bool Function OnEdgePre()
    return True
EndFunction

Function OnMinigameEdge()
    OnMinigameEdgePost()
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
        ;UD_DamageMult = getAccesibility()*getModResistPhysical(1.0,0.1) + (1.0 - getRelativeDurability())
        UD_durability_damage_add = (5.0 - 5.0*getRelativeDurability()) + UDCDMain.getActorStrengthSkillsPerc(getWearer()) + getHelperStrengthSkillsPerc()
        UD_durability_damage_add *= _durability_damage_mod
    endif
EndFunction

Function OnMinigameTick3()
EndFunction

Function OnCritFailure()
    checkSentient(0.25)
EndFunction

float Function getAccesibility()
    float loc_res = 1.0
    if (!WearerFreeHands() && !HelperFreeHands())
        if isLoose()
            loc_res = getLooseMod()
        else
            loc_res = 0.0
        endif
    elseif !isMittens()
        if WearerHaveMittens() && (!_minigameHelper || HelperHaveMittens())
            loc_res = 0.5
        else
            loc_res = 1.0
        endif
    endif
    return ValidateAccessibility(loc_res)
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
    return true
EndFunction

Function onWeaponHitPost(Weapon source)
    ;check if weapon is wooded (whips and canes have also this keyword)
    if source.haskeyword(UDlibs.WoodedWeapon)
        ;weapon is wooden, no damage should be deald
        return
    endif
    if !IsUnlocked && canBeCutted()
        float loc_damage = source.getBaseDamage()
        if !loc_damage
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
    if !IsUnlocked; && getModResistMagicka(1.0,0.25) != 1.0
    endif
EndFunction

;adds bonus string to base detail string
string Function addInfoString(string str = "")
    return str
EndFunction

Function updateWidget(bool force = false)
    if _StruggleGameON
        setWidgetVal(getRelativeDurability(),force)
    elseif _CuttingGameON
        setWidgetVal(getRelativeCuttingProgress(),force)
    elseif _RepairLocksMinigameON
        setWidgetVal(_GetRelativeLockRepairProgress(_MinigameSelectedLockID),force)
    endif
    
    ;update condition widget
    If UDmain.UDWC.UD_UseDeviceConditionWidget
        UDmain.UDWC.Meter_SetFillPercent("device-condition", getRelativeCondition() * 100.0)
    endif
EndFunction

Function updateWidgetColor()
    if UD_WidgetAutoColor && !UDmain.UseiWW()
        if UD_Condition == 0
            setMainWidgetAppearance(0x4df319, 0x62ff00)
        elseif UD_Condition == 1
            setMainWidgetAppearance(0xafba24, 0x4da319)
        elseif UD_Condition == 2
            setMainWidgetAppearance(0xe37418, 0xafba24)
        elseif UD_Condition == 3
            setMainWidgetAppearance(0xdc1515, 0xe37418)
        else
            setMainWidgetAppearance(0x5a1515, 0xdc1515)
        endif
    elseif UD_WidgetAutoColor
        setMainWidgetAppearance(0xFF307C, 0xFF005E)
    endif

    If UDmain.UDWC.UD_UseDeviceConditionWidget
        if UD_Condition == 0
            setConditionWidgetAppearance(0x4df319, 0x62ff00)
        elseif UD_Condition == 1
            setConditionWidgetAppearance(0xafba24, 0x4da319)
        elseif UD_Condition == 2
            setConditionWidgetAppearance(0xe37418, 0xafba24)
        elseif UD_Condition == 3
            setConditionWidgetAppearance(0xdc1515, 0xe37418)
        else
            setConditionWidgetAppearance(0x5a1515, 0xdc1515)
        endif
    endif
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
    if _StruggleGameON
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

;internal functions, as calling them from UDmain can cause suspension
int Function codeBit(int iCodedMap,int iValue,int iSize,int iIndex)
    if iIndex + iSize > 32 || iSize < 1 || iIndex < 0
        return 0xFFFFFFFF ;returns error value
    endif
    ;sets not shifted bit mask loc_clear_mask
    int loc_clear_mask = (Math.LeftShift(0x1,iSize) - 1)                        ;mask used to clear bits which will be set
    iValue = Math.LeftShift(Math.LogicalAnd(iValue,loc_clear_mask),iIndex)      ;clear value from bigger bits
    loc_clear_mask = Math.LogicalNot(Math.LeftShift(loc_clear_mask,iIndex))     ;shift and negate
    iCodedMap = Math.LogicalAnd(iCodedMap,loc_clear_mask)                       ;clear maps bits with mask
    return Math.LogicalOr(iCodedMap,iValue)                                     ;sets bits
endfunction

int Function decodeBit(int iCodedMap,int iSize,int iIndex)
    if iIndex + iSize > 32
        return 0xFFFFFFFF ;returns error value
    endif
    ;sets not shifted bit mask
    iCodedMap = Math.RightShift(iCodedMap,iIndex)                           ;shift to right, so value is correct
    iCodedMap = Math.LogicalAnd(iCodedMap,(Math.LeftShift(0x1,iSize) - 1))  ;clear maps bits with mask
    return iCodedMap
EndFunction