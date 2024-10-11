;   File: UD_CustomDevice_RenderScript
;   This is the core script of all unforgiving devices. In case you want to ceate new device, you have to use this script or make new one which extends this script
Scriptname UD_CustomDevice_RenderScript extends ObjectReference  

import UnforgivingDevicesMain
import UD_NPCInteligence
import UD_Native

;bit maps used to code simple values to reduce memory size of script

; === _deviceControlBitMap_1 ===
;00 = 1b, _StruggleGameON
;01 = 1b, _LockpickGameON
;02 = 1b, _CuttingGameON
;03 = 1b, _KeyGameON
;04 = 1b, _RepairLocksMinigameON
;05 = 1b, UD_useWidgetSec
;06 = 1b, UD_WidgetAutoColorSec
;07 = 1b, _critLoop_On
;08 = 1b, UD_AllowWidgetUpdateSec
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
;15 - 24 = 10b (0000 000X XXXX XXXX X000 0000 0000 0000)(0x03FF), UD_StruggleCritMul, default value 4x (0x0F)
;25 - 27 =  3b (0000 XXX0 0000 0000 0000 0000 0000 0000)(0x0007), UD_StruggleCritDuration, default value 1s (0x5)
;X  -  X =  Xb (XXXX 0000 0000 0000 0XXX XXXX 0000 0000)(0x000F), !UNUSED!
int _deviceControlBitMap_12 = 0x0A078000

; === _deviceControlBitMap_13 === (mutex3)
;00 - 11 = 12b (0000 0000 0000 0000 0000 XXXX XXXX XXXX)(0x0000 0FFF), _CuttingProgress
;12 - 15 =  4b (XXXX XXXX XXXX XXXX XXXX 0000 0000 0000)(0x0000 F000), !UNUSED!
;16 - 23 =  8b (XXXX XXXX XXXX XXXX XXXX 0000 0000 0000)(0x00FF 0000), UD_WidgetFormula
;24 - 31 =  8b (XXXX XXXX XXXX XXXX XXXX 0000 0000 0000)(0xFF00 0000), UD_WidgetFormulaSec
int _deviceControlBitMap_13 = 0x00000000

Function Debug_LogBitMaps(String argTitle = "BITMASK")
    _libSafeCheck()
    UDmain.Info("===================== "+getDeviceName() +" / "+ argTitle +" =====================")
    UDmain.Info("_deviceControlBitMap_1 : "+_deviceControlBitMap_1 +",b: "+IntToBit(_deviceControlBitMap_1 ))
    UDmain.Info("_deviceControlBitMap_2 : "+_deviceControlBitMap_2 +",b: "+IntToBit(_deviceControlBitMap_2 ))
    UDmain.Info("_deviceControlBitMap_3 : "+_deviceControlBitMap_3 +",b: "+IntToBit(_deviceControlBitMap_3 ))
    UDmain.Info("_deviceControlBitMap_4 : "+_deviceControlBitMap_4 +",b: "+IntToBit(_deviceControlBitMap_4 ))
    UDmain.Info("_deviceControlBitMap_5 : "+_deviceControlBitMap_5 +",b: "+IntToBit(_deviceControlBitMap_5 ))
    UDmain.Info("_deviceControlBitMap_6 : "+_deviceControlBitMap_6 +",b: "+IntToBit(_deviceControlBitMap_6 ))
    UDmain.Info("_deviceControlBitMap_7 : "+_deviceControlBitMap_7 +",b: "+IntToBit(_deviceControlBitMap_7 ))
    UDmain.Info("_deviceControlBitMap_8 : "+_deviceControlBitMap_8 +",b: "+IntToBit(_deviceControlBitMap_8 ))
    UDmain.Info("_deviceControlBitMap_9 : "+_deviceControlBitMap_9 +",b: "+IntToBit(_deviceControlBitMap_9 ))
    UDmain.Info("_deviceControlBitMap_10: "+_deviceControlBitMap_10+",b: "+IntToBit(_deviceControlBitMap_10))
    UDmain.Info("_deviceControlBitMap_11: "+_deviceControlBitMap_11+",b: "+IntToBit(_deviceControlBitMap_11))
    UDmain.Info("_deviceControlBitMap_12: "+_deviceControlBitMap_12+",b: "+IntToBit(_deviceControlBitMap_12))
    UDmain.Info("_deviceControlBitMap_13: "+_deviceControlBitMap_13+",b: "+IntToBit(_deviceControlBitMap_13))
EndFunction

;=============================================================
;=============================================================
;=============================================================
;                    PROPERTIES START
;=============================================================
;=============================================================
;=============================================================

;--------------------------------PUBLIC PROPERTIES----------------------------

;/  Group: Required Values
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: DeviceInventory
    *This property have to be always filled with relevant inventory device!!*
/;
Armor       Property DeviceInventory                auto

;/  Variable: libs
    *Reference to zadlibs, should be always filled!!*
/;
zadlibs             _libs
zadlibs     Property libs hidden
    zadlibs Function Get()
        if !_libs
            _libs = GetZadLibs()
        endif
        return _libs
    EndFunction
EndProperty


;/  Group: Optional Values
===========================================================================================
===========================================================================================
===========================================================================================
/;

Key         Property zad_deviceKey                  auto

;/  Variable: UD_DeviceKeyword
    Main keyword of device. In case this is not filled, it will be taken from Inventory Device
/;
Keyword  Property UD_DeviceKeyword                              auto hidden ;keyword of this device for better manipulation. Is taken from ID

;/  Variable: DeviceRendered
    Link to device the script is currently on. In case this is not filled, it will be taken from Inventory Device
/;
Armor    _DeviceRendered
Armor    Property DeviceRendered                                hidden ;Is taken from ID
    Armor Function Get()
        if !_DeviceRendered
            _DeviceRendered = zadNativeFunctions.GetRenderDevice(deviceInventory)
        endif
        return _DeviceRendered
    EndFunction
    
    Function Set(Armor akDevice)
        _DeviceRendered = akDevice
    EndFunction
EndProperty


String[] Property UD_DeviceStruggleKeywords                     auto Hidden ;keywords (as string array) used to filter struggle animations

;/  Variable: UD_ActiveEffectName
    Name of active effect. By default set to "Share"
    
    Do not change this if you use existing script
    
    Only change this if creating new script type with new active effect
/;
string   Property UD_ActiveEffectName           = "Share"       auto hidden ;name of active effect

;/  Variable: UD_DeviceType
    Name of the device type. Only used in details, so user can distinguish various device types
/;
string   Property UD_DeviceType                 = "Generic"     auto hidden ;name of the device type

;/  Variable: UD_DeviceKeyword_Minor
    Minor device keyword. Only used by animations
    
    In most cases, there is no need to change this, as the framework will take the keyword automatically based on main keyword
/;
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
            elseif UD_DeviceKeyword == libs.zad_deviousSuit
                ;check hobble skirt
                if DeviceRendered.HasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)
                    _DeviceKeyword_Minor = libs.zad_DeviousHobbleSkirtRelaxed
                elseif DeviceRendered.HasKeyword(libs.zad_DeviousHobbleSkirt)
                    _DeviceKeyword_Minor = libs.zad_deviousHobbleSkirt
                else
                    _DeviceKeyword_Minor = UD_DeviceKeyword
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

;/  Group: Customization
===========================================================================================
===========================================================================================
===========================================================================================
/;

;MAIN VALUES

;/  Variable: UD_Level
    Level of device. By default set to 1.
    
    Special values:
    
    --- Code
    |====================================================================|
    |   UD_Level    |           Meaning                                  |
    |====================================================================|
    |    -1     =     will be set to wearer level with +-25% difference  |
    |    -2     =     will be set to wearer level with  +25% difference  |
    |    -3     =     will be set to wearer level with  -25% difference  |
    |====================================================================|
    ---
    
/;
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


;/  Variable: UD_durability_damage_base
    Base durability damage per second of device
    
    This is not exact value of what will be used in minigame, but instead just base value which is then moded using other minigame values
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =       1.00
        Min. Value     =       0.00
        Max. Value     =      40.00
        Precision      =       0.01
    ---
/;
float       Property UD_durability_damage_base                              ;durability dmg per second of struggling, range 0.00 - 40.00, precision 0.01 (4000 values)
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_7",Round(fRange(fVal,0.0,40.0)*100),12,0)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_7,12,0)/100.0
    EndFunction
EndProperty

;/  Variable: UD_base_stat_drain
    How many points of stats (health, stamina, magicka) are reduced per second of minigame. This is only base values, which is later moded with minigame values
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =       8.00
        Min. Value     =       1.00
        Max. Value     =      31.00
        Precision      =       1.00
    ---
/;
float       Property UD_base_stat_drain                                     ;stamina drain for second of struggling, range 1 - 31, decimal point not used
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_6",Round(fRange(fVal,1.0,31.0)),5,27)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_6,5,27)
    EndFunction
EndProperty

;/  Variable: UD_ResistPhysical
    Physical resistence of device. Reduces effectiveness of normal and despair minigame Value bigger then 100% will cause device to be healed
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =       0.00
        Min. Value     =      -5.00
        Max. Value     =       5.23
        Precision      =       0.01
    ---
    
    See: <UD_ResistMagicka>, <UD_WeaponHitResist>
/;
float       Property UD_ResistPhysical                                      ;physical resistence. Needs to be applied to minigame to work!
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_11",Round(fRange(5.0 + fVal,0.0,10.0)*100),10,20)
    EndFunction
    
    float Function get()
        return (UD_Native.DecodeBit(_deviceControlBitMap_11,10,20)/100.0) - 5.0
    EndFunction
EndProperty

;/  Variable: UD_ResistMagicka
    Magic resistence of device. Reduces effectiveness of magic minigame. Value bigger then 100% will cause device to be healed
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =       0.00
        Min. Value     =      -5.00
        Max. Value     =       5.23
        Precision      =       0.01
    ---
    
    See: <UD_ResistPhysical>
/;
float       Property UD_ResistMagicka                                       ;magicka resistence. Needs to be applied to minigame to work!
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_7",Round(fRange(5.0 + fVal,0.0,10.0)*100),10,12)
    EndFunction
    
    float Function get()
        return (UD_Native.DecodeBit(_deviceControlBitMap_7,10,12)/100.0) - 5.0
    EndFunction
EndProperty

;/  Variable: UD_WeaponHitResist
    Physical resistence of device when hit with weapon attack. If set to 5.23, it will be set on init to <UD_ResistPhysical>. Value bigger then 100% will cause device to be healed
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =       0.00
        Min. Value     =      -5.00
        Max. Value     =       5.23
        Precision      =       0.01
    ---
    
    See: <UD_ResistPhysical>, <UD_ResistMagicka>
/;
float       Property UD_WeaponHitResist                                     ;physical resistence to physical attack
    Function set(float fVal)
        ;;startBitMapMutexCheck3()
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_11",Round(fRange(5.0 + fVal,0.0,10.0)*100),10,0)
        ;;endBitMapMutexCheck3()
    EndFunction
    
    float Function get()
        return (UD_Native.DecodeBit(_deviceControlBitMap_11,10,0)/100.0) - 5.0
    EndFunction
EndProperty

float       Property UD_SpellHitResist                                      ;!!!UNUSED!!!
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_11",Round(fRange(5.0 + fVal,0.0,10.0)*100),10,10)
    EndFunction
    
    float Function get()
        return (UD_Native.DecodeBit(_deviceControlBitMap_11,10,10)/100.0) - 5.0
    EndFunction
EndProperty

;/  Variable: UD_CutChance
    Have nothing to do with chance. Determinate how much cutting progress is added on every key press
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =       0.00
        Min. Value     =       0.00
        Max. Value     =     100.00
        Precision      =       1.00
    ---
/;
float       Property UD_CutChance                                           ;chance of cutting device every 1s of minigame, 0.0 is uncuttable
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_6",Round(fRange(fVal,0.0,100.0)),7,20)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_6,7,20)
    EndFunction
EndProperty

;/  Variable: UD_StruggleCritMul
    Crit multiplier. Determinate how much are crits effective.
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =       3.75
        Min. Value     =       0.00
        Max. Value     =     255.00
        Precision      =       0.25
    ---
/;
float       Property UD_StruggleCritMul                                     ;crit multiplier applied on crit, step = 0.25, max 255, default 3.75x
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_12",Round(fRange(fVal,0.0,255.0)*4),10,15)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_12,10,15)/4.0
    EndFunction
EndProperty

;/  Variable: UD_StruggleCritDuration
    Duration of crit
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =       1.0
        Min. Value     =       0.5
        Max. Value     =       1.2
        Precision      =       0.1
    ---
/;
float       Property UD_StruggleCritDuration                                ;crit time, the lower this value, the more faster player needs to press button, range 0.5-1.2, step 0.1 (7 values)
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_12",Round((fRange(fVal,0.5,1.2) - 0.5)*10),3,25)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_12,3,25)/10.0 + 0.5
    EndFunction
EndProperty

;/  Variable: UD_StruggleCritChance
    Chance for crit to happen every second
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =        15
        Min. Value     =         0
        Max. Value     =       100
    ---
/;
int         Property UD_StruggleCritChance                                  ;chance of random crit happening once per second of struggling, range 0-100
    Function set(int iVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_6",iRange(iVal,0,100),7,0)
    EndFunction
    
    int Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_6,7,0)
    EndFunction
EndProperty

;/  Variable: UD_Cooldown
    Device cooldown, in minutes. Device will activate itself on after this time (if it can)
    
    Zero or negative value will disable this feature (device cant activate itself)
/;
int         Property UD_Cooldown                    = 0             auto

;/  Variable: UD_DefaultHealth
    Device durability on first level. It is used as base, which will be increased with device level.
/;
Float       Property UD_DefaultHealth               = 100.0         auto

;/  Variable: UD_ModifiersRef
    Arrays of modifier data. Check modifier wiki page for more info <https://github.com/IHateMyKite/UnforgivingDevices/wiki/Modifiers> (outdated)
/;
Alias[]     Property UD_ModifiersRef          auto
String[]    Property UD_ModifiersDataStr      auto
Form[]      Property UD_ModifiersDataForm1    auto
Form[]      Property UD_ModifiersDataForm2    auto
Form[]      Property UD_ModifiersDataForm3    auto

;/  Variable: UD_MessageDeviceInteraction
    Message that is show when opening device menu. If not set, it will be set automatically by UD.
/;
Message     Property UD_MessageDeviceInteraction                    auto

;/  Variable: UD_MessageDeviceInteractionWH
    Message that is show when opening device menu with helper. If not set, it will be set automatically by UD.
/;
Message     Property UD_MessageDeviceInteractionWH                  auto

;/  Variable: UD_SpecialMenuInteraction
    Message that is show when opening special menu. Is by default empty, and unused on base script. Have to be used by extending script
/;
Message     Property UD_SpecialMenuInteraction                      auto

;/  Variable: UD_SpecialMenuInteractionWH
    Message that is show when opening special menu with helper. Is by default empty, and unused on base script. Have to be used by extending script
/;
Message     Property UD_SpecialMenuInteractionWH                    auto

;/  Variable: UD_DeviceAbilities
    Array of abilities which will be added to wearer when device is equipped. Works as alternative to using enchantments.
    
    Check <UD_DeviceAbilities_Flags> for flags
/;
Form[]      Property UD_DeviceAbilities                             auto    ;array of abilities which are added on actor when device is equipped

;/  Variable: UD_DeviceAbilities_Flags
    Flags for previous property. Every ability should have also flag (so both arrays have same length)
    
    *Length of this array have to be identical to <UD_DeviceAbilities>*
    
    Current Values:
    --- Code
        ;Should device ability be added when device is locked ?
        00 - 01    = 02b (0000 0000 0000 0000 0000 0000 0000 00XX)(0x0003)
                       = 0x00  -> Ability will be added for all NPCs and Player
                       = 0x01  -> Ability will be added only for NPC
                       = 0x10  -> Ability will be added only for Player
                       = 0x11  -> Ability will be not added on when device is locked
        ;Unused
        02 - 31    = 30b (XXXX XXXX XXXX XXXX XXXX XXXX XXXX XX00)(0xFFFFFFFC)
    ---
    
    See: <UD_DeviceAbilities>
/;
Int[]       Property UD_DeviceAbilities_Flags                       auto

;/  Variable: UD_LockList
    Array of bit mapped locks.
    
    *Length of this array have to be identical to <UD_LockNameList>*
    
    Current Values:
    --- Code
         0 -  3 =  4b (0000 0000 0000 0000 0000 0000 0000 XXXX)(0x0000000F), State of lock
                                                                               000X = 1 when lock is unlocked, 0 when locked
                                                                               00X0 = 1 when lock is jammed, 0 when not
                                                                               0X00 = 1 when lock is using time lock
                                                                               X000 = 1 when locks time lock will auto unlock lock, or 0 to just allow user to manipulate the device after the time passes 
                                                                                      (so if the time is 2 hours, the user will not be able to manipulate the lock for 2 hours. If this is 1, it will unlock itself after this time. If its 0, it will just allow wearer to manipulate the lock)
         4 -  7 =  4b (0000 0000 0000 0000 0000 0000 XXXX 0000)(0x000000F0), Number of lock shields (how many times needs to lock to be unlocked before being "removed")
         8 - 14 =  7b (0000 0000 0000 0000 0XXX XXXX 0000 0000)(0x00007F00), Lock accessibility (in %, should be from 0 to 100)
        15 - 22 =  8b (0000 0000 0XXX XXXX X000 0000 0000 0000)(0x007F8000), Locks difficulty (from 0 to 255)
        23 - 29 =  7b (00XX XXXX X000 0000 0000 0000 0000 0000)(0x3F800000), Lock time in hours. Every hour, this value gets reduced by 1. When reduced to 0, will unlock the lock
        30 - 31 =  2b (XX00 0000 0000 0000 0000 0000 0000 0000)(0xC0000000), Unused, can be used by creators for special use
    ---
    
    Use lock creation tool in case you want to make your job easier: <https://ihatemykite.github.io/LockBitcoder.html>
    
    See: <UD_LockNameList>
/;
Int[]       Property UD_LockList                                    auto

;/  Variable: UD_LockNameList
    Name of the locks. If not used, the name will be generated from difficulty and accessiblity
    
    *Length of this array have to be identical to <UD_LockList>*
    
    See: <UD_LockList>
/;
String[]    Property UD_LockNameList                                auto


;/  Group: Read Only
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: IsUnlocked
    Is true if device is unlocked
/;
bool        Property IsUnlocked                                     Hidden
    Function set(bool bVal)
        ;can't be changed externally
    EndFunction
    bool Function get()
        return _IsUnlocked
    EndFunction
EndProperty

;/  Variable: UD_Health
    Default max health with current device level
/;
Float       Property UD_Health                                      Hidden 
    Float Function get()
        if !UD_HealthScalingDisabled
            return UD_DefaultHealth + (UD_Level - 1)*UDCDmain.UD_DeviceLvlHealth*UD_DefaultHealth
        else
            return UD_DefaultHealth
        endif
    EndFunction
EndProperty

;/  Variable: UD_Locks
    Number of locks
/;
int         Property UD_Locks                                       Hidden
    int Function get()
        return GetLockNumber()
    EndFunction
EndProperty

;/  Variable: UD_JammedLocks
    Number of jammed locks
/;
int         Property UD_JammedLocks                                 Hidden
    int Function get()
        return GetJammedLocks()
    EndFunction
endproperty

;------------LOCAL VARIABLES-------------------
;libs, filled automatically
UnforgivingDevicesMain  _udmain                                          ;Local variable for UDmain. Filled only once
Quest                   _udquest                                         ;kept for possible future optimization
UDCustomDeviceMain      _udcdmain                                        ;Local variable for UDCDmain. Filled only once
UD_MenuTextFormatter    _UDMTF
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
Float                   _RealTimeLocked = 0.0
Float                   _GameTimeLocked = 0.0
Int                     _initState = 0
Float                   _LastHourUpdateTime
Float                   _LastHourUpdateTimeMod
Int                     _VMHandle1      = 0x00000000
Int                     _VMHandle2      = 0x00000000

Int Property            VMHandle1 hidden
    Int Function Get()
        return _VMHandle1
    EndFunction
EndProperty
Int Property            VMHandle2 hidden
    Int Function Get()
        return _VMHandle2
    EndFunction
EndProperty

;---------------------------------------PRIVATE PROPERTIES----------------------------------------
UnforgivingDevicesMain      Property UDmain     hidden ;main libs
    UnforgivingDevicesMain Function get()
        if !_udmain
            _udmain = GetUdmain()
        endif
        return _udmain
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
UD_MenuTextFormatter        Property UDMTF      Hidden  ; Menu Text Formatter
    UD_MenuTextFormatter Function Get()
        If !_UDMTF
            _UDMTF = UDmain.UDMTF
        EndIf
        Return _UDMTF
    EndFunction
EndProperty

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
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,19)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,19)
    EndFunction
endproperty
float   Property zad_JammLockChance                 hidden ;chance of jamming lock
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_3",Round(fRange(fVal,0.0,100.0)),8,16)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_3,8,16)
    EndFunction
endproperty
float   Property zad_KeyBreakChance                 hidden ;chance of breaking the key
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_3",Round(fRange(fVal,0.0,100.0)),8,24)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_3,8,24)
    EndFunction
endproperty
int     Property UD_CurrentLocks                    Hidden ;how many locked locks remain, max is 31
    int Function get()
        return GetLockedLocks()
    EndFunction
endproperty
int     Property UD_condition                       Hidden ;0 - new , 4 - broke
    Function set(int iVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_5",iRange(iVal,0,4),3,12)
    EndFunction
    
    int Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_5,3,12)
    EndFunction
endproperty
bool    Property _isRemoved                         hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,26)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,26)
    EndFunction
EndProperty
bool    Property _StruggleGameON                    Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,0)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,0)
    EndFunction
endproperty
bool    Property _LockpickGameON                    Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,1)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,1)
    EndFunction
endproperty
bool    Property _CuttingGameON                     Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,2)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,2)
    EndFunction
endproperty
bool    Property _KeyGameON                         Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,3)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,3)
    EndFunction
endproperty
bool    Property _RepairLocksMinigameON             Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,4)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,4)
    EndFunction
endproperty
bool    Property _critLoop_On                       Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,7)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,7)
    EndFunction
EndProperty
bool    Property UD_drain_stats                     Hidden ;if player will loose stats while struggling
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,9)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,9)
    EndFunction
endproperty
bool    Property UD_drain_stats_helper              Hidden ;if player will loose stats while struggling
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,10)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,10)
    EndFunction
endproperty
bool    Property UD_damage_device                   Hidden ;if device can be damaged
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,11)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,11)
    EndFunction
endproperty
bool    Property UD_applyExhastionEffect            Hidden ;applies debuff after mnigame ends
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,12)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,12)
    EndFunction
endproperty
bool    Property UD_applyExhastionEffectHelper      Hidden ;applies debuff after minigame ends
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,13)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,13)
    EndFunction
endproperty
bool    Property UD_minigame_canCrit                Hidden ;if crits can appear
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,14)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,14)
    EndFunction
endproperty
bool    Property UD_useWidget                       Hidden ;determinate if widget will be shown
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,15)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,15)
    EndFunction
endproperty
bool    Property UD_WidgetAutoColor                 Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,16)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,16)
    EndFunction
endproperty
bool    Property Ready                              Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,17)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,17)
    EndFunction
endproperty
bool    Property zad_DestroyOnRemove                Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,18)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,18)
    EndFunction
endproperty
bool    Property _MinigameON                        Hidden 
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,21)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,21)
    EndFunction
EndProperty
bool    Property _MinigameParProc_4                 Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,22)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,22)
    EndFunction
EndProperty
bool    Property _removeDeviceCalled                Hidden 
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,23)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,23)
    EndFunction
EndProperty
bool    Property UD_minigame_critRegen              Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,24)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,24)
    EndFunction
EndProperty
bool    Property UD_minigame_critRegen_helper       Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,25)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,25)
    EndFunction
EndProperty
bool    Property _MinigameParProc_2                 Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,27)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,27)
    EndFunction
EndProperty
bool    Property _MinigameParProc_1                 Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,28)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,28)
    EndFunction
EndProperty
bool    Property _MinigameParProc_3                 Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,30)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,30)
    EndFunction
EndProperty
bool    Property _usingTelekinesis                  Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,29)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,29)
    EndFunction
EndProperty
bool    Property UD_AllowWidgetUpdate               Hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,31)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,31)
    EndFunction
EndProperty
Bool Property UD_useWidgetSec hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,5)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,5)
    EndFunction
EndProperty
Bool Property UD_WidgetAutoColorSec hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,6)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,6)
    EndFunction
EndProperty
Bool Property UD_AllowWidgetUpdateSec hidden
    Function set(bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,8)
    EndFunction
    
    bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,8)
    EndFunction
EndProperty

float   Property UD_minigame_stamina_drain          Hidden ;stamina drain for second of struggling
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_2",Round(fRange(fVal,0.0,200.0)),8,0)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_2,8,0)
    EndFunction
endproperty
float   Property UD_minigame_magicka_drain          Hidden ;magicka drain for second of struggling
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_2",Round(fRange(fVal,0.0,200.0)),8,8)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_2,8,8)
    EndFunction
endproperty
float   Property UD_minigame_heal_drain             Hidden ;health drain for second of struggling
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_2",Round(fRange(fVal,0.0,200.0)),8,16)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_2,8,16)
    EndFunction
endproperty
float   Property UD_minigame_stamina_drain_helper   Hidden ;stamina drain for second of struggling
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_2",Round(fRange(fVal,0.0,200.0)),8,24)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_2,8,24)
    EndFunction
endproperty
float   Property UD_minigame_magicka_drain_helper   Hidden ;magicka drain for second of struggling
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_3",Round(fRange(fVal,0.0,200.0)),8,0)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_3,8,0)
    EndFunction
endproperty
float   Property UD_minigame_heal_drain_helper      Hidden ;health drain for second of struggling
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_3",Round(fRange(fVal,0.0,200.0)),8,8)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_3,8,8)
    EndFunction
endproperty
float   Property UD_RegenMag_Stamina                Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_4",Round(fRange(fVal,0.0,1.0)*100),7,0)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_4,7,0)/100.0
    EndFunction
endproperty
float   Property UD_RegenMag_Health                 Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_4",Round(fRange(fVal,0.0,1.0)*100),7,7)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_4,7,7)/100.0
    EndFunction
endproperty
float   Property UD_RegenMag_Magicka                Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_4",Round(fRange(fVal,0.0,1.0)*100),7,14)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_4,7,14)/100.0
    EndFunction
endproperty
float   Property UD_RegenMagHelper_Stamina          Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_8",Round(fRange(fVal,0.0,1.0)*100),7,0)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_8,7,0)/100.0
    EndFunction
EndProperty
float   Property UD_RegenMagHelper_Health           Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_8",Round(fRange(fVal,0.0,1.0)*100),7,7)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_8,7,7)/100.0
    EndFunction
EndProperty
float   Property UD_RegenMagHelper_Magicka          Hidden ;stats regeneration when struggling, 0.0 means that helper will not regen stats, 1.0 will make stats regen like normaly, range 0.01,1.0 with step 0.01. Lesser then 0.01 -> 0.0
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_8",Round(fRange(fVal,0.0,1.0)*100),7,14)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_8,7,14)/100.0
    EndFunction
EndProperty
int     Property _customMinigameCritChance          Hidden
    Function set(int iVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_8",iRange(iVal,0,100),7,21)
    EndFunction
    
    int Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_8,7,21)
    EndFunction
EndProperty
float   Property _customMinigameCritDuration        Hidden
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_9",Round(fRange(fVal,0.4,2.0)*100),7,0)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_9,7,0)/100.0
    EndFunction
EndProperty
float   Property _customMinigameCritMult            Hidden
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_9",Round(fRange(fVal,0.25,1000.0)*4),12,7)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_9,12,7)/4.0
    EndFunction
EndProperty
float   Property _CuttingProgress                   Hidden ;cutting progress, 0-100, step 0.025
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_13",Round(fRange(fVal,0.0,100.0)*40),12,0)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_13,12,0)/40.0
    EndFunction
EndProperty
float   Property _minMinigameStatHP                 Hidden
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_9",Round(fRange(fVal,0.0,1.0)*100),7,19)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_9,7,19)/100.0
    EndFunction
EndProperty
float   Property _minMinigameStatMP                 Hidden
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_10",Round(fRange(fVal,0.0,1.0)*100),7,0)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_10,7,0)/100.0
    EndFunction
EndProperty
float   Property _minMinigameStatSP                 Hidden
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_10",Round(fRange(fVal,0.0,1.0)*100),7,7)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_10,7,7)/100.0
    EndFunction
EndProperty
float   Property _condition_mult_add                Hidden ;how much is increased condition dmg (10% increase condition dmg by 10%), step = 0.1, max 25.6
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_10",Round(fRange(fVal,0.0,25.6)*10),8,14)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_10,8,14)/4.0
    EndFunction
EndProperty
float   Property _exhaustion_mult                   Hidden ;multiplier for duration of debuff, step = 0.25, max 64
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_10",Round(fRange(fVal,0.0,64.0)*4),8,22)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_10,8,22)/4.0
    EndFunction
EndProperty
float   Property _exhaustion_mult_helper            Hidden ;multiplier for duration of debuff, step = 0.25, max 64
    Function set(float fVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_12",Round(fRange(fVal,0.0,64.0)*4),8,0)
    EndFunction
    
    float Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_12,8,0)/4.0
    EndFunction
EndProperty
int     Property _struggleGame_Subtype              Hidden
    Function set(int iVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_7",iRange(iVal,0,7),3,25)
    EndFunction
    
    int Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_7,3,25)
    EndFunction
EndProperty
int     Property _struggleGame_Subtype_NPC          Hidden
    Function set(int iVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_7",iRange(iVal,0,7),3,28)
    EndFunction
    
    int Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_7,3,28)
    EndFunction
EndProperty

;/  Variable: UD_WidgetFormula
    Formula used by native widget
    0 = Linear
    1 = Linear repeating (saw)
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =         0
        Min. Value     =         0
        Max. Value     =       255
    ---
/;
int         Property _WidgetFormula hidden  ;chance of random crit happening once per second of struggling, range 0-100
    Function set(int iVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_13",iRange(iVal,0,255),8,16)
    EndFunction
    
    int Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_13,8,16)
    EndFunction
EndProperty

;/  Variable: UD_WidgetFormulaSec
    Formula used by second native widget
    0 = Linear
    1 = Linear repeating (saw)
    
    *This value is bitcoded, and thus have limited range and precision!*
    
    --- Code
        Default value  =         0
        Min. Value     =         0
        Max. Value     =       255
    ---
/;
int         Property _WidgetFormulaSec hidden  ;chance of random crit happening once per second of struggling, range 0-100
    Function set(int iVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_13",iRange(iVal,0,255),8,24)
    EndFunction
    
    int Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_13,8,24)
    EndFunction
EndProperty

Bool    Property UD_HealthScalingDisabled Hidden
    Function set(Bool bVal)
        SetBitMapData(_VMHandle1,_VMHandle2,DeviceRendered,"_deviceControlBitMap_1",bVal as Int,1,20)
        ResetHealth()
    EndFunction
    
    Bool Function get()
        return UD_Native.DecodeBit(_deviceControlBitMap_1,1,20)
    EndFunction
EndProperty

;=============================================================
;=============================================================
;=============================================================
;                    PROPERTIES END
;=============================================================
;=============================================================
;=============================================================

;/  Group: Generic methods
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: isReady
    Returns:

        True if device is fully initialized (this is done before device is locked)
/;
bool Function isReady()
    return Ready
EndFunction

;/  Function: getWearer
    Returns:

        current device wearer
/;
Actor Function getWearer()
    return Wearer
EndFunction

;/  Function: getWearerName
    Returns:

        current device wearer name
/;
String Function getWearerName()
    return GetActorName(Wearer)
EndFunction

;/  Function: setHelper
    Parameters:

        akActor  - actor to set as helper. Use none to reset helper

    Returns:

        set current device helper
/;
Function setHelper(Actor akActor)
    _minigameHelper = akActor
EndFunction

;/  Function: getHelper
    Returns:

        current device helper. Returns none if no helper is set
/;
Actor Function getHelper()
    return _minigameHelper
EndFunction

;returns current device helper name (only when Device Menu WH is open or in minigame with helper)

;/  Function: getHelperName
    Returns:

        current device helper name. Returns "ERROR" if no helper is set
/;
String Function getHelperName()
    if _minigameHelper
        return getActorName(_minigameHelper)
    else
        return "ERROR"
    endif
EndFunction

;returns if wearer/helper is registered in register

;/  Function: WearerIsRegistered
    Returns:

        True if wearer is registered
/;
bool Function WearerIsRegistered()
    return UDCDmain.isRegistered(Wearer)
EndFunction 

;/  Function: HelperIsRegistered
    Returns:

        True if helper is registered. Returns false if helper is not set
/;
bool Function HelperIsRegistered()
    return UDCDmain.isRegistered(getHelper())
EndFunction 

;/  Function: WearerIsPlayer
    Returns:

        True if wearer is player
/;
bool Function WearerIsPlayer()
    return Wearer == UDmain.Player
EndFunction

;/  Function: WearerIsPlayer
    Returns:

        True if helper is player. Returns false if helper is not set
/;
bool Function HelperIsPlayer()
    if _minigameHelper
        return _minigameHelper == UDmain.Player
    endif
    return false
EndFunction

;/  Function: WearerIsFollower
    Returns:

        True if wearer is follower
/;
bool Function WearerIsFollower()
    return UDmain.ActorIsFollower(getWearer())
EndFunction

;/  Function: HelperIsFollower
    Returns:

        True if helper is follower. Returns false if helper is not set
/;
bool Function HelperIsFollower()
    if _minigameHelper
        return UDmain.ActorIsFollower(_minigameHelper)
    endif
    return false
EndFunction

;/  Function: PlayerInMinigame
    Returns:

        true if player is taking part in minigame (either as wearer or helper)
/;
bool Function PlayerInMinigame()
    return (WearerIsPlayer() || HelperIsPlayer()) && _MinigameON
EndFunction

;/  Function: PlayerIsPresent
    Returns:

        true if player is either wearer or helper
/;
bool Function PlayerIsPresent()
    return (WearerIsPlayer() || HelperIsPlayer())
EndFunction

;/  Function: haveHelper
    Returns:

        true if devie have set helper
/;
bool Function haveHelper()
    return _minigameHelper
EndFunction

;/  Function: getDeviceHeader
    Returns:

        device header in format -> $DeviceName ($WearerName)
/;
string Function getDeviceHeader()
    if haveHelper()
        return (getDeviceName() + "(W="+getWearerName()+",H="+getHelperName()+")")
    else
        return (getDeviceName() + "("+getWearerName()+")")
    endif
EndFunction

;/  Function: getDeviceName
    Returns:

        device name
/;
String Function getDeviceName()
    return DeviceInventory.GetName()
EndFunction


Event OnInit()
    ResetHealth()
EndEvent

Function ResetHealth()
    current_device_health = UD_Health
EndFunction

Int Function IsInit()
    return _initState
EndFunction

Function ResetInit()
    _initState = 0
EndFunction

;OnContainerChanged is very important event. It is used to determinate if render device have been equipped (OnEquipped only works for player)
;it is also used for retrieving device (this) script
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if (akNewContainer as Actor) && !akOldContainer && !_initState && !IsUnlocked && !Ready
        _initState = 1
        Actor loc_actor = akNewContainer as Actor
        if !loc_actor.isDead()
            if loc_actor.GetItemCount(DeviceRendered) <= 1
                _Init(loc_actor)
            else
                UDmain.Error("More then one "+GetDeviceName()+" detected on " + GetActorName(loc_actor) + " - removing")
                loc_actor.RemoveItem(DeviceRendered,1)
            endif
        endif
    endif
    
    if UDmain
        if (akOldContainer == UDCDmain.TransfereContainer_ObjRef)
            if UDmain.TraceAllowed()
                UDmain.Log("Device " + getDeviceHeader() + " transfered to transfer container!",2)
            endif
            UDCDmain._transferedDevice = self
        endif
    endif
EndEvent

;1 tick = 0.1 s ; 20 ticks = 2 s
Bool Function _CheckRD(Actor akActor, Int aiTicks)
    int loc_ticks = 0
    while loc_ticks <= aiTicks && !UDCDmain.CheckRenderDeviceEquipped(akActor, deviceRendered)
        Utility.waitMenuMode(0.1)
        loc_ticks += 1
    endwhile
    return loc_ticks < aiTicks
EndFunction

;post equip function
Function _Init(Actor akActor)
    Wearer      = akActor
    _initState  = 2 ;_Init called
    _libSafeCheck()

    if !akActor
        UDmain.Error("!Aborting Init called for "+getDeviceName()+" because actor is none!!")
        akActor.removeItem(deviceRendered,1,True)
        return
    endif

    UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(akActor)
    
    if IsUnlocked 
        UDmain.Error("!Aborting Init("+ getActorName(akActor) +") called for " + getDeviceName() + " because device is already unlocked!!")
        return 
    endif
    
    if akActor.getItemCount(deviceInventory) == 0
        UDmain.Error("!Aborting Init("+ getActorName(akActor) +") called for " + getDeviceName() + " because no inventory device is present!")
        return
    endif

    ;update now if deviceRendered isn't filled yet, otherwise update on end
    ;deviceRendered should be filled to make the init faster
    if !deviceRendered || !UD_DeviceKeyword
        updateValuesFromInventoryScript()
    endif

    ;add DOR modifier
    ;if zad_DestroyOnRemove && !hasModifier("DOR")
        ;addModifier("DOR") - TODO
    ;endif
    
    if akActor.getItemCount(deviceRendered) > 1
        UDmain.Error("!Aborting Init("+ getDeviceHeader() + " because device is already present!")
        akActor.removeItem(deviceRendered,akActor.getItemCount(deviceRendered) - 1,true)
        return
    endif
    
    bool loc_isplayer = (akActor == UDmain.Player)
    if loc_slot ;ignore additional check if actor is not registered
        int loc_timeoutticks = Round(UDmain.UDGV.UD_LockTimeoutRD/0.1)
        
        bool loc_rdok = _CheckRD(akActor,loc_timeoutticks)
        
        ;in case that the equip failed and menu is open, wait for menu to close first, and then try again
        if !loc_isplayer && !loc_rdok && UDmain.IsAnyMenuOpenRT()
            Utility.wait(0.01) ;wait for menu to close
            loc_rdok = _CheckRD(akActor,loc_timeoutticks)
        endif
        
        if !loc_rdok
            UDmain.Error("!Aborting Init("+ getActorName(akActor) +") called for " + getDeviceName() + " because equip failed - timeout. Conflicting Device = " + UDCDmain.GetConflictDevice(akActor, DeviceRendered))
            return
        endif
    endif
    if UDmain.TraceAllowed()
        UDmain.Log("Init(called for " + getDeviceHeader(),1)
    endif
    
    _initState  = 3 ;precheck done
    
    ;MUTEX START
    ;mutex check because some mods equips items too fast at once, making it possible to have equipped 2 of the same item
    if loc_slot
        ;if loc_slot.getDeviceByRender(deviceRendered)
        ;    UDmain.Error("!Aborting Init("+ getDeviceHeader() +") because device is already registered!")
        ;    akActor.removeItem(deviceRendered,akActor.getItemCount(deviceRendered) - 1,true)
        ;    return
        ;endif
        _StartInitMutex()
    endif
    
    if UDmain.TraceAllowed()
        UDmain.Log("Registering device: " + getDeviceHeader(),1)
    endif
    
    GoToState("UpdatePaused")
    
    UDCDmain.startScript(self)
    
    if loc_slot
        _EndInitMutex()
    endif

    ;MUTEX END
    
    _initState = 4 ;registered
    
    if deviceRendered
        updateValuesFromInventoryScript()
    endif

    if UD_Level < 1
        int loc_level = akActor.GetLevel()
        if UD_Level == -1 ;random value in +- 25% range from wearer level
            UD_Level = Round(RandomFloat(fRange(loc_level*0.75,1.0,100.0),fRange(loc_level*1.25,1.0,100.0)))
        elseif UD_Level == -2 ;random value in + 25% range from wearer level
            UD_Level = Round(RandomFloat(fRange(loc_level,1.0,100.0),fRange(loc_level*1.25,1.0,100.0)))
        elseif UD_Level == -3 ;random value in - 25% range from wearer level
            UD_Level = Round(RandomFloat(fRange(loc_level*0.75,1.0,100.0),fRange(loc_level,1.0,100.0)))
        else ;same level as wearer
            UD_Level = loc_level
        endif
    endif

    if deviceRendered.hasKeyword(UDlibs.PatchedDevice) ;patched device
        if UDmain.TraceAllowed()
            UDmain.Log("Patching device " + getDeviceName(),2)
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
    
    ResetHealth() ;repairs device to max durability on equip
    
    safeCheck()
    
    _OnInitLevelUpdate()
    
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
        UDmain.Log(getDeviceName() + " fully locked on " + getWearerName(),1)
    endif
    
    _ResetTimers()
    
    Ready = True
    
    if UDCDmain.isRegistered(getWearer())
        Update(1/24/60) ;1 minute update
        UDmain.UDMOM.Procces_UpdateModifiers_Added(self) ;call DeviceLocked on modifiers
    endif
    
    GoToState("")
    
    UD_Events.SendEvent_DeviceLocked(self)
    
    _initState = 5 ;Fully ready, but InitPostPost is not called
    
    InitPostPost() ;called after everything else. Can add some followup interaction immidiatly after device is equipped (activate device, start vib, etc...)
    
    _initState = 6 ;Fully ready
EndFunction

Function _StartInitMutex()
    While UDCDmain.UD_EquipMutex
        Utility.WaitMenuMode(0.1)
    EndWhile
    UDCDmain.UD_EquipMutex = True
    if UDmain.TraceAllowed()
        UDmain.Log("Mutexed and proccesing " + getDeviceHeader(),2)
    endif
EndFunction

Function _EndInitMutex()
    if UDmain.TraceAllowed()
        UDmain.Log("Mutex ended for " + getDeviceHeader(),2)
    endif
    UDCDmain.UD_EquipMutex = False
EndFunction

;This function is called after the devices level is set and patched. Should be used for some level related adjustments
Function _OnInitLevelUpdate()
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

Function _libSafeCheck()
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
    if !zad_deviceKey
        zad_deviceKey = zadNativeFunctions.GetPropertyForm(deviceInventory,"deviceKey") as Key;temp.deviceKey
    endif
    zad_KeyBreakChance = zadNativeFunctions.GetPropertyFloat(deviceInventory,"KeyBreakChance");temp.KeyBreakChance
    zad_DestroyOnRemove = zadNativeFunctions.GetPropertyBool(deviceInventory,"DestroyOnRemove");temp.DestroyOnRemove
    zad_DestroyKey = zadNativeFunctions.GetPropertyBool(deviceInventory,"DestroyKey");temp.DestroyKey
    zad_JammLockChance = zadNativeFunctions.GetPropertyFloat(deviceInventory,"LockJamChance");temp.LockJamChance
    UD_DeviceKeyword = zadNativeFunctions.GetPropertyForm(deviceInventory,"zad_deviousDevice") as Keyword;temp.zad_deviousDevice
EndFunction

Bool Function _ParalelProcessRunning()
    return Math.LogicalAnd(_deviceControlBitMap_1,0x58400000)
EndFunction

;/  Function: isPlug
    Returns:

        True if device is plug
/;
bool Function isPlug()
    bool res = false
    res = res || (UD_DeviceKeyword == libs.zad_deviousPlugVaginal)
    res = res || (UD_DeviceKeyword == libs.zad_deviousPlugAnal)
    res = res || (UD_DeviceKeyword == libs.zad_deviousPlug)
    res = res || (UD_DeviceKeyword == libs.zad_kw_InflatablePlugAnal)
    res = res || (UD_DeviceKeyword == libs.zad_kw_InflatablePlugVaginal)
    return res
EndFunction

;/  Function: isPiercing
    Returns:

        True if device is piercing
/;
bool Function isPiercing(bool ignoreVag = false,bool ignoreNipple = false)
    bool res = false
    res = res || (UD_DeviceKeyword == libs.zad_deviousPiercingsNipple && !ignoreNipple) 
    res = res || (UD_DeviceKeyword == libs.zad_DeviousPiercingsVaginal && !ignoreVag)
    return res
EndFunction

;/  Function: isMittens
    Returns:

        True if device is mittens
/;
bool Function isMittens()
    bool res = false
    res = res || deviceRendered.hasKeyword(libs.zad_DeviousBondageMittens)
    return res
EndFunction

;/  Function: isHeavyBondage
    Returns:

        True if device is heavy bondage (hand restraint)
/;
bool Function isHeavyBondage()
    bool res = false
    res = res || deviceRendered.hasKeyword(libs.zad_deviousHeavyBondage)
    return res
EndFunction

;/  Function: wearerHaveBelt
    Returns:

        True if wearer is belted
/;
bool Function wearerHaveBelt()
    bool res = false
    res = res || wearer.wornhaskeyword(libs.zad_deviousBelt) 
    res = res || wearer.wornhaskeyword(libs.zad_deviousHarness)
    return res
EndFunction

;/  Function: wearerHaveBra
    Returns:

        True if wearer have chastity bra equipped
/;
bool Function wearerHaveBra()
    bool res = false
    res = res || wearer.wornhaskeyword(libs.zad_deviousBra) 
    return res
EndFunction

;/  Function: wearerHaveSuit
    Parameters:

        abCheckStraitjacket  - if straitjacket should be also excluded as suit (so if wearer have straitjacket this functions returns false)

    Returns:

        True if wearer have suit equipped
/;
bool Function wearerHaveSuit(bool abCheckStraitjacket = false)
    bool res = false
    res = res || wearer.wornhaskeyword(libs.zad_deviousSuit) 
    res = res && !(abCheckStraitjacket && wearer.wornhaskeyword(libs.zad_deviousStraitjacket))
    return res
EndFunction

;/  Function: canBeStruggled
    Parameters:

        afAccesibility  - External accessibility. Use this if you already have value of accessibility, so the framework don't have to calculate it again. Will calculate the accessibility if this is less then 0.0

    Returns:

        True if can be struggled from. This means that device is accessible and durability dmg is bigger then 0
/;
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

;/  Function: isEscapable
    Returns:

        True if device can be escaped with any minigame. Accessibility is not checked.
/;
bool Function isEscapable()
    if UD_durability_damage_base > 0.0 || (UD_LockList && UD_LockList.length && HaveLockpickableLocks())
        return True
    else
        return false
    endif
EndFunction

;/  Function: canBeCutted
    Returns:

        True if device can cutted (cutting minigame allowed)
/;
bool Function canBeCutted()
    if UD_CutChance > 0.0
        return True
    else
        return false
    endif
EndFunction

;/  Function: HaveUnlockableLocks
    Returns:

        True if device have any locks that can be lockpicked or unlocked with key
/;
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

;/  Function: canBeRepaired
    Parameters:

        akSource  - Actor that want to repair the device

    Returns:

        True if device can be repaired by helper
/;
bool Function canBeRepaired(Actor akSource)
    if !akSource
        return false
    endif
    bool loc_res = true
    loc_res = loc_res && (getRelativeDurability() < 1.0 || getRelativeCondition() < 1.0 || getRelativeLocks() < 1.0)
    loc_res = loc_res && (akSource.getItemCount(UDlibs.SteelIngot) >= 2)
    return loc_res
EndFunction

;/  Function: wearerFreeHands
    Parameters:

        abCheckGrasp                -  If mittens should count as device that prevent wearer from using hands
        abIgnoreHeavyBondageSelf    -  If device that is this method called on is heavy bondage, it will count as free hands
        abIgnoreHeavyBondage        -  If wearer have heavy bondage device equipped, it will still count as free hands

    Returns:

        True if wearer have free hands
/;
bool Function wearerFreeHands(bool abCheckGrasp = false,bool abIgnoreHeavyBondageSelf = true,bool abIgnoreHeavyBondage = false)
    bool loc_res = abIgnoreHeavyBondage || !Wearer.wornhaskeyword(libs.zad_deviousHeavyBondage)
    if abIgnoreHeavyBondageSelf && !loc_res
        if deviceRendered.hasKeyword(libs.zad_deviousHeavyBondage)
            loc_res = true
        endif
    endif
        
    if abCheckGrasp && loc_res
        if wearer.wornhaskeyword(libs.zad_DeviousBondageMittens)
            loc_res = false
        endif
    endif
    return loc_res
EndFunction

;/  Function: helperFreeHands
    Parameters:

        abCheckGrasp                -  If mittens should count as device that prevent helper from using hands
        abIgnoreHeavyBondage        -  If helper have heavy bondage device equipped, it will still count as free hands

    Returns:

        True if helper have free hands
/;
bool Function helperFreeHands(bool abCheckGrasp = false,bool abIgnoreHeavyBondage = false)
    if !_minigameHelper
        return false
    endif
    bool loc_res = abIgnoreHeavyBondage || !_minigameHelper.wornhaskeyword(libs.zad_deviousHeavyBondage)
        
    if abCheckGrasp && loc_res
        if _minigameHelper.wornhaskeyword(libs.zad_DeviousBondageMittens)
            loc_res = false
        endif
    endif
    return loc_res
EndFunction

;/  Function: WearerHaveMittens
    Returns:

        True if wearer have mittens
/;
bool Function WearerHaveMittens()
    return Wearer.wornhaskeyword(libs.zad_DeviousBondageMittens)
EndFunction

;/  Function: HelperHaveMittens
    Returns:

        True if helper have mittens
/;
bool Function HelperHaveMittens()
    return _minigameHelper && _minigameHelper.wornhaskeyword(libs.zad_DeviousBondageMittens)
EndFunction

;/  Function: wearerFreeLegs
    Returns:

        True if wearer have free legs (no hobble skirt)
/;
bool Function wearerFreeLegs()
    return !Wearer.wornhaskeyword(libs.zad_deviousHobbleSkirt)
EndFunction

;/  Function: helperFreeLegs
    Returns:

        True if helper have free legs (no hobble skirt)
/;
bool Function helperFreeLegs()
    return _minigamehelper && !_minigamehelper.wornhaskeyword(libs.zad_deviousHobbleSkirt)
EndFunction

;/  Function: ShockWearer
    Shocks wearer, which shortly apply shader and sound effect. Also changes arousal, and can reduce health

    Parameters:

        aiArousalUpdate     -  By how much will be wearer arousal increased. Can be negative to reduce wearer arousal
        afHealth            -  By how much will be wearer health reduced. Can be only positive.
        abCanKill           -  If this effect can kill player in case that effect will reduce more health then wearer have
/;
Function ShockWearer(int aiArousalUpdate = 50,float afHealth = 0.0, bool abCanKill = false)
    (libs as zadlibs_UDPatch).ShockActorPatched(getWearer(),aiArousalUpdate,afHealth, abCanKill)
EndFunction

;/  Function: ShockHelper
    Shocks wearer, which shortly apply shader and sound effect. Also changes arousal, and can reduce health

    Parameters:

        aiArousalUpdate     -  By how much will be helper arousal increased. Can be negative to reduce helper arousal
        afHealth            -  By how much will be helper health reduced. Can be only positive.
        abCanKill           -  If this effect can kill player in case that effect will reduce more health then helper have
/;
Function ShockHelper(int aiArousalUpdate = 50,float afHealth = 0.0, bool abCanKill = false)
    if haveHelper()
        (libs as zadlibs_UDPatch).ShockActorPatched(getHelper(),aiArousalUpdate,afHealth, abCanKill)
    endif
EndFunction

;unlocks restrain, ALWAYS call this if you want to unlock restrain from this script

;/  Function: unlockRestrain
    Unlocks the restrain on which is this function called

    Parameters:

        abForceDestroy  -  If device should be destroyed. This option ignores all other device setting and modifiers
        abWaitForRemove -  unused
/;
Function unlockRestrain(bool abForceDestroy = false,bool abWaitForRemove = True)
    if IsUnlocked
        if UDmain.TraceAllowed()
            UDmain.Log("unlockRestrain("+getDeviceHeader()+") - Device is already unlocked! Aborting ",1)
        endif
        return
    endif
    _IsUnlocked = True
    GoToState("UpdatePaused")
    
    if _MinigameON
        stopMinigame()
    endif
    
    if UDmain.TraceAllowed()
        UDmain.Log("unlockRestrain() called for " + self,1)
    endif

    current_device_health = 0.0
    if WearerIsPlayer()
        UDCDmain.updateLastOpenedDeviceOnRemove(self)
    endif

    StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
    
    StorageUtil.UnSetIntValue(Wearer, "zad_Equipped" + libs.LookupDeviceType(UD_DeviceKeyword) + "_ManipulatedStatus")
    
    if (deviceInventory.hasKeyword(libs.zad_QuestItem) || deviceRendered.hasKeyword(libs.zad_QuestItem))
        int questKw = UDCdmain.UD_QuestKeywords.getSize()
        while questKw
            questKw -= 1
            if deviceInventory.hasKeyword(UDCdmain.UD_QuestKeywords.getAt(questKw) as Keyword) || deviceRendered.hasKeyword(UDCdmain.UD_QuestKeywords.getAt(questKw) as Keyword)
                libs.RemoveQuestDevice(Wearer, deviceInventory, deviceRendered, UD_DeviceKeyword, UDCdmain.UD_QuestKeywords.getAt(questKw) as Keyword ,zad_DestroyOnRemove || hasModifier("DOR") || abForceDestroy)
                return
            endif
        endwhile
    else
        libs.UnlockDevice(Wearer, deviceInventory, deviceRendered, UD_DeviceKeyword, zad_DestroyOnRemove || hasModifier("DOR") || abForceDestroy)
    endif
EndFunction

;check sentient event and activets it
function checkSentient(float afMult = 1.0)
    if isSentient()
        if RandomInt() > 75 && WearerIsPlayer()
            startSentientDialogue(1)
        endif
        if Round(UD_Native.GetStringParamFloat(GetModifierParam("SEN"))*afMult) > RandomInt(1,99)
            if UDmain.TraceAllowed()
                UDmain.Log("Sentient device activation of : " + getDeviceHeader())
            endif
            UDCDmain.activateDevice(self)
        endif
    endif
EndFunction

;function called when wearer is hit by source weapon
Function weaponHit(Weapon akSource)
    if onWeaponHitPre(akSource)
        onWeaponHitPost(akSource)
    endif
EndFunction

;function called when wearer is hit by source spell
Function spellHit(Spell akSource)
    if onSpellHitPre(akSource)
        onSpellHitPost(akSource)
    endif
EndFunction

bool Function CooldownActivate()
    if OnCooldownActivatePre()
        if UDmain.TraceAllowed()
            UDmain.Log(getDeviceHeader() + " cooldown activate",1)
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

;choose the best minigame and start it. Returns false if minigame was not started
Bool Function EvaluateNPCAI()
    Int     loc_minigameStarted     = 0
    Float   loc_durabilityBefore    = current_device_health
    Int     loc_LocksBefore         = UD_CurrentLocks

    SetHelper(none)

    updateDifficulty()

    ;50% chance to first check locks, then struggle
    if RandomInt(0,1)
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
            Int loc_minigame = RandomInt(0,2)
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
            Int loc_minigame = RandomInt(0,2)
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

;in hours
Float Function GetRealTimeLockedTime()
    return Game.GetRealHoursPassed() - _RealTimeLocked
EndFunction

Function ResetRealTimeLockedTime()
    _RealTimeLocked = Game.GetRealHoursPassed()
EndFunction

;in days
Float Function GetGameTimeLockedTime()
    return Utility.GetCurrentGameTime() - _GameTimeLocked
EndFunction

Function ResetGameTimeLockedTime()
    _GameTimeLocked = Utility.GetCurrentGameTime()
EndFunction

Function _ResetTimers()
    ResetRealTimeLockedTime()
    ResetGameTimeLockedTime()
    _LastHourUpdateTime     = Utility.GetCurrentGameTime()
    _LastHourUpdateTimeMod  = Utility.GetCurrentGameTime()
EndFunction

Float Function ResetLastHourUpdate()
    Float loc_time = Utility.GetCurrentGameTime()
    Float loc_hours = (loc_time - _LastHourUpdateTime)*24.0
    _LastHourUpdateTime = loc_time
    return loc_hours
EndFunction

Float Function ResetLastHourUpdateMod()
    Float loc_time = Utility.GetCurrentGameTime()
    Float loc_hours = (loc_time - _LastHourUpdateTimeMod)*24.0
    _LastHourUpdateTimeMod = loc_time
    return loc_hours
EndFunction

;==============================================================================================
;==============================================================================================
;==============================================================================================
;                                 MODIFIER MANIP FUNCTIONS                                     
;==============================================================================================
;==============================================================================================
;==============================================================================================

;/  Group: Modifiers
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: GetNthModifier
    Parameters:

        aiIndex  - Index of modifier

    Returns:

        Nth modifier
/;
UD_Modifier Function GetNthModifier(Int aiIndex)
    return UD_ModifiersRef[aiIndex] as UD_Modifier
EndFunction

;/  Function: addModifier
    Parameters:

        akModifier  - Name of modifier to add
        asParam     - Comma separated list of parameters
        akForm1     - Modifier form 1
        akForm2     - Modifier form 2
        akForm3     - Modifier form 3

    Returns:

        true if modifiers was succesfully added
        
    Example:
    
    ---Code
        ; Add new modifier called LootGold
        ; Modifiers parameters are 100 , 0 and 8
        ; TODO
    ---
/;
bool Function addModifier(UD_Modifier akModifier,string asParam = "", Form akForm1 = none, Form akForm2 = none, Form akForm3 = none)
    if !hasModifier(akModifier)
        UD_ModifiersRef         = PapyrusUtil.PushAlias (UD_ModifiersRef        ,akModifier)
        UD_ModifiersDataStr     = PapyrusUtil.PushString(UD_ModifiersDataStr    ,asParam)
        UD_ModifiersDataForm1   = PapyrusUtil.PushForm  (UD_ModifiersDataForm1  ,akForm1)
        UD_ModifiersDataForm2   = PapyrusUtil.PushForm  (UD_ModifiersDataForm2  ,akForm2)
        UD_ModifiersDataForm3   = PapyrusUtil.PushForm  (UD_ModifiersDataForm3  ,akForm3)
        return true
    else
        return false
    endif
EndFunction

;/  Function: removeModifier
    Parameters:

        akModifier  - Name of modifier to remove

    Returns:

        true if modifiers was succesfully removed
/;
bool Function removeModifier(UD_Modifier akModifier)
    if hasModifierRef(akModifier)
        int loc_i               = 0
        int loc_size            = UD_ModifiersRef.length
        int loc_removed_indx    = UD_ModifiersRef.find(akModifier)
        
        Alias[]     loc_tmp_modifiers
        String[]    loc_tmp_modifiers_str
        Form[]      loc_tmp_modifiers_f1
        Form[]      loc_tmp_modifiers_f2
        Form[]      loc_tmp_modifiers_f3
        
        while loc_i < loc_size
            if (loc_i != loc_removed_indx)
                loc_tmp_modifiers       = PapyrusUtil.PushAlias (loc_tmp_modifiers      ,UD_ModifiersRef        [loc_i])
                loc_tmp_modifiers_str   = PapyrusUtil.PushString(loc_tmp_modifiers_str  ,UD_ModifiersDataStr    [loc_i])
                loc_tmp_modifiers_f1    = PapyrusUtil.PushForm  (loc_tmp_modifiers_f1   ,UD_ModifiersDataForm1  [loc_i])
                loc_tmp_modifiers_f2    = PapyrusUtil.PushForm  (loc_tmp_modifiers_f2   ,UD_ModifiersDataForm2  [loc_i])
                loc_tmp_modifiers_f3    = PapyrusUtil.PushForm  (loc_tmp_modifiers_f3   ,UD_ModifiersDataForm3  [loc_i])
            endif
            loc_i += 1
        endwhile
        
        UD_ModifiersRef         = loc_tmp_modifiers
        UD_ModifiersDataStr     = loc_tmp_modifiers_str
        UD_ModifiersDataForm1   = loc_tmp_modifiers_f1
        UD_ModifiersDataForm2   = loc_tmp_modifiers_f2
        UD_ModifiersDataForm3   = loc_tmp_modifiers_f3
        return true
    else
        return false
    endif
EndFunction

;/  Function: hasModifier
    Parameters:

        asModifier  - Alias of modifier to check

    Returns:

        true if modifiers is present on the device
/;
bool Function hasModifier(String asModifier)
    return UD_Native.GetModifierIndex(VMHandle1,VMHandle2,deviceRendered,asModifier) != -1
EndFunction

;/  Function: hasModifierRef
    Parameters:

        akModifier  - Modifier alias

    Returns:

        true if modifiers is present on the device
/;
bool Function hasModifierRef(UD_Modifier akModifier)
    return (UD_ModifiersRef.find(akModifier) >= 0)
EndFunction

;/  Function: getModifierAllParam
    Parameters:

        asModifier  - Alias of modifier

    Returns:

        Array of all parameters or none in case of error
/;
String[] Function getModifierAllParam(string asModifier)
    return UD_Native.GetModifierStringParamAll(VMHandle1,VMHandle2,deviceRendered,asModifier)
EndFunction

;/  Function: getModifierParam
    Parameters:

        asModifier  - Alias of modifier

    Returns:

        Parameter string
/;
String Function getModifierParam(string asModifier)
    return UD_Native.GetModifierStringParam(VMHandle1,VMHandle2,deviceRendered,asModifier)
EndFunction

;/  Function: editStringModifier
    Change one parameter value

    Parameters:

        asModifier  - Name of modifier
        aiIndex     - Index of parameter to change
        asNewValue  - New value of parameter

    Returns:

        True if operation was succesfull
/;
bool Function editStringModifier(string asModifier,int aiIndex, string asNewValue)
    return UD_Native.EditModifierStringParam(VMHandle1,VMHandle2,deviceRendered,asModifier,aiIndex,asNewValue)
EndFunction

;/  Function: setModifierIntParam
    Change one int parameter value. Is wrapper of <editStringModifier> method

    Parameters:

        asModifier  - Name of modifier
        aiValue     - New value of parameter
        aiIndex     - Index of parameter to change
        
    Returns:

        True if operation was succesfull
/;
Bool Function setModifierIntParam(string asModifier,int aiValue,int aiIndex = 0)
    return editStringModifier(asModifier,aiIndex,aiValue)
EndFunction

;/  Function: setModifierFloatParam
    Change one Float parameter value. Is wrapper of <editStringModifier> method

    Parameters:

        asModifier  - Name of modifier
        afValue     - New value of parameter
        aiIndex     - Index of parameter to change
        
    Returns:

        True if operation was succesfull
/;
Bool Function setModifierFloatParam(string asModifier,Float afValue,int aiIndex = 0)
    return editStringModifier(asModifier,aiIndex,afValue)
EndFunction

;/  Function: setModifierParam
    Change one string parameter value. Is wrapper of <editStringModifier> method

    Parameters:

        asModifier  - Name of modifier
        asValue     - New value of parameter
        aiIndex     - Index of parameter to change
        
    Returns:

        True if operation was succesfull
/;
Bool Function setModifierParam(string asModifier, string asValue,int aiIndex = 0)
    return editStringModifier(asModifier,aiIndex,asValue)
EndFunction

;/  Function: isSentient
    Returns:

        True if device have "SEN" modifier
/;
bool Function isSentient()
    return hasModifier("SNT")
EndFunction

;/  Function: haveRegen
    Returns:

        True if device have "REG" modifier
/;
bool Function haveRegen()
    return hasModifier("REG")
EndFunction

;/  Function: isLoose
    Returns:

        True if device have "LOS" modifier
/;
bool Function isLoose()
    return hasModifier("LOS")
EndFunction

;/  Function: getLooseMod
    Returns:

        Modifier for "LOS" modifier
/;
float Function getLooseMod()
    return UD_Native.GetStringParamFloat(getModifierParam("LOS"),0,0.5)
EndFunction

;==============================================================================================
;==============================================================================================
;==============================================================================================
;                                   LOCK MANIP FUNCTIONS                                       
;==============================================================================================
;==============================================================================================
;==============================================================================================


;/  Group: Lock Methods
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/ About: Lock API
---Code
====GETTERS====
 Bool      HaveLocks()                                 = return true if device have locks
 Bool      HaveLockedLocks()                           = return true if any of the locks is not unlocked
 Bool      HaveLockpickableLocks()                      = returns true if device have at least one lock which can be lockpicked
 Int       GetLockedLocks()                            = return number of currently locked locks or 0 if there is error
 Int       GetJammedLocks()                            = return number of currently jammed locks or 0 if there is error
 String[]  GetLockList()                               = return string array of lock names. This is what is shown to player when selecting lock, or return none in case of error
 Int       UserSelectLock()                            = open the list of locks for user. Returns index of selected lock, or -1 in case that user either backed out or there was error
 Bool      IsValidLock(Int aiLock)                     = return true if passed lock is in valid format
 Int       GetLockNumber()                             = returns number of locks on the device or 0 if device have no locks
 Int       GetNthLock(Int aiLockIndex)                 = This function returns the Nth lock, or error value if no locks are on device
 String    GetNthLockName(Int aiLockIndex)             = returns Nth locks name
 Bool      IsNthLockUnlocked(Int aiLockIndex)          = returns true if the Nth lock is unlocked, or false if no Nth lock exist or is invalid
 Bool      IsNthLockJammed(Int aiLockIndex)            = returns true if the Nth lock is jammed, or false if no Nth lock exist or is invalid
 Bool      IsNthLockTimeLocked(Int aiLockIndex)        = returns true if the Nth lock is time locked, or false if no Nth lock exist or is invalid
 Bool      IsNthLockAutoTimeLocked(Int aiLockIndex)    = returns true if the Nth lock is time locked with auto unlock, or false if no Nth lock exist or is invalid
 Int       GetNthLockShields(Int aiLockIndex)          = returns number of shields of the Nth lock, or 0 if no Nth lock exist or is invalid
 Int       GetNthLockAccessibility(Int aiLockIndex)    = returns accessibility of the Nth lock in %, or 0 if no Nth lock exist or is invalid
 Int       GetNthLockDifficulty(Int aiLockIndex)       = returns difficulty of the Nth lock, or 0 if no Nth lock exist or is invalid. Difficulty is in range from 0 to 255 (classic skyrim lockpick difficulty distribution)
 Int       GetNthLockTimeLock(Int aiLockIndex)         = returns number of remaining hours from time lock of the Nth lock, or 0 if no Nth lock exist or is invalid
 Float     GetNthLockRepairProgress(Int aiLockIndex)   = returns Nth locks repair progress in absolute value
====SETTERS====
 Bool      UnlockNthLock(Int aiLockIndex, Bool abUnlock = True)    = sets lock unlock status. If the operation was succesfull, returns true; argument abUnlock can be set to either true or false, depending if lock should be unlocked, or locked
 Int       UnlockAllLocks(Bool abUnlock = True)                    = Lock/unlock all locks, returns number of locks affected
 Bool      JammNthLock(Int aiLockIndex, Bool abJamm = True)        = sets lock jammed status. If the operation was succesfull, returns true; argument abJamm can be set to either true or false, depending if lock should be jammed, or unjammed
 Int       JammAllLocks(Bool abJamm = True)                        = Jamm/unjamm all locks, returns number of locks affected
 Bool      JammRandomLock()                                        = TODO
 Int       DecreaseLockShield(Int aiLockIndex, Int aiShieldDecrease = 1, Bool abAutoUnlock = False)    = decrease locks shiled by aiShieldDecrease, returns remaining number of shields
 Bool      UpdateLockAccessibility(Int aiLockIndex, Int aiAccessibilityDelta)  = Update the lock accessibility by aiAccessibilityDelta. If the operation was succesfull, returns true
 Bool      UpdateLockDifficulty(Int aiLockIndex, Int aiDifficultyDelta, Bool abNoKeyDiff = True)    = Update the lock difficulty by aiDifficultyDelta. If the operation was succesfull, returns true; if abNoKeyDiff is True, lock difficulty can't be "Key required" after the update (capped difficulty at 100 = master lock)
 Int       UpdateLockTimeLock(Int aiLockIndex, Int aiTimeLockDelta)    = Update the lock time lock by aiTimeLockDelta. Returns new time lock value, or 0 in case of error
 Bool      UpdateAllLocksTimeLock(Int aiTimeLockDelta)                 = Update all locked locks timelock by aiTimeLockDelta, returns true if at least one lock was updated, or false if there was either error or no locked lock
 Float     UpdateNthLockRepairProgress(Int aiLockIndex, Float afValue) = Updates Nth locks repair progress by afValue and returns new value
====UTILITY====
 Int       CreateLock(Int aiDifficulty, Int aiAccess, Int aiShields, String asName, Int aiTimelock = 0, Bool abAdd = False)   = creates lock from passed arguments ;if abAdd is True, the lock will also be automatically added to the list of locks
 Int       AddLock(Int aiLock, String asName = "", Bool abNoCreate = False)    = Adds lock to lock list, if abNoCreate is true, the lock will not be added if no locks already exist on device (aka, only if device had locks before), Return index of the added lock. In case of error, returns -1
---
/;

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
        if WearerHaveTelekinesis() || HelperHaveTelekinesis()
            return true
        endif
    
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
        return UD_Native.DecodeBit(loc_Lock,1,0)
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
        return UD_Native.DecodeBit(loc_Lock,1,1)
    else
        return False ;return false as error value
    endif
EndFunction

;returns true if the Nth lock is time locked, or false if no Nth lock exist or is invalid
Bool Function IsNthLockTimeLocked(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return UD_Native.DecodeBit(loc_Lock,1,2)
    else
        return False ;return false as error value
    endif
EndFunction

;returns true if the Nth lock is time locked with auto unlock, or false if no Nth lock exist or is invalid
Bool Function IsNthLockAutoTimeLocked(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return UD_Native.DecodeBit(loc_Lock,1,3)
    else
        return False ;return false as error value
    endif
EndFunction

;returns number of shields of the Nth lock, or 0 if no Nth lock exist or is invalid
Int Function GetNthLockShields(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return UD_Native.DecodeBit(loc_Lock,4,4)
    else
        return 0 ;return 0 as error value
    endif
EndFunction

;returns accessibility of the Nth lock in %, or 0 if no Nth lock exist or is invalid
Int Function GetNthLockAccessibility(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return iRange(UD_Native.DecodeBit(loc_Lock,7,8),0,100)
    else
        return 0 ;return 0 as error value
    endif
EndFunction

;returns difficulty of the Nth lock, or 0 if no Nth lock exist or is invalid
Int Function GetNthLockDifficulty(Int aiLockIndex, Bool abUseLevel = True)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        Int loc_difficulty = UD_Native.DecodeBit(loc_Lock,8,15)
        if abUseLevel && loc_difficulty < 100
            ;increase difficulty based on device level
            if UDCDMain.UD_PreventMasterLock
                loc_difficulty = iRange(loc_difficulty + Round(UDCDMain.UD_DeviceLvlLockpick*(UD_Level - 1)),1,75) ;increase lockpick difficulty
            else
                loc_difficulty = iRange(loc_difficulty + Round(UDCDMain.UD_DeviceLvlLockpick*(UD_Level - 1)),1,100) ;increase lockpick difficulty
            endif
        endif
        return loc_difficulty
    else
        return 0 ;return 0 as error value
    endif
EndFunction

;returns number of remaining hours from time lock of the Nth lock, or 0 if no Nth lock exist or is invalid
Int Function GetNthLockTimeLock(Int aiLockIndex)
    Int loc_Lock = GetNthLock(aiLockIndex)
    if IsValidLock(loc_Lock) 
        return UD_Native.DecodeBit(loc_Lock,7,23)
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
        loc_Lock = CodeBit(loc_Lock, abUnlock as Int,1,0)
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
                loc_Lock = CodeBit(loc_Lock,1,1, 0)
                UD_LockList[loc_LockNum] = loc_Lock
                loc_res += 1
            elseif (!abUnlock && IsNthLockUnlocked(loc_LockNum)) ;lock lock
                loc_Lock = CodeBit(loc_Lock,0,1, 0)
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
        loc_Lock = CodeBit(loc_Lock, abJamm as Int,1,1)
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
                loc_Lock = CodeBit(loc_Lock,1,1, 1)
                UD_LockList[loc_LockNum] = loc_Lock
                loc_res += 1
            elseif (!abJamm && IsNthLockJammed(loc_LockNum)) ;unjamm lock
                loc_Lock = CodeBit(loc_Lock,0,1, 1)
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
        Int loc_randomLock = loc_correctLocks[RandomInt(0, loc_correctLocks.length - 1)]
        Int  loc_Lock = GetNthLock(loc_randomLock)
        UD_LockList[loc_randomLock] = CodeBit(loc_Lock,1,1, 1)
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
        Int loc_ShieldNumber = iUnsig(UD_Native.DecodeBit(loc_Lock,4,4) - aiShieldDecrease)
        loc_Lock = CodeBit(loc_Lock, loc_ShieldNumber,4,4)
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
        Int loc_Accessibility = iRange(UD_Native.DecodeBit(loc_Lock,7,8) + aiAccessibilityDelta,0,100)
        loc_Lock = CodeBit(loc_Lock, loc_Accessibility,7,8)
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
        Int loc_Difficulty = iRange(UD_Native.DecodeBit(loc_Lock,8,15) + aiDifficultyDelta,0,255)
        if abNoKeyDiff
            loc_Difficulty = iRange(loc_Difficulty,0,100)
        endif
        loc_Lock = CodeBit(loc_Lock, loc_Difficulty,8,15)
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
        Int loc_TimeLock = iRange(UD_Native.DecodeBit(loc_Lock,7,23) + aiTimeLockDelta,0,122)
        loc_Lock = CodeBit(loc_Lock, loc_TimeLock,7,23)
        UD_LockList[aiLockIndex] = loc_Lock
        loc_res = loc_TimeLock
        if !loc_res && IsNthLockAutoTimeLocked(aiLockIndex)
            ;auto unlock the lock
            loc_Lock = CodeBit(loc_Lock,1,1, 0)
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
    loc_res = CodeBit(loc_res, aiShields,4,4)
    loc_res = CodeBit(loc_res, aiAccess,7,8)
    loc_res = CodeBit(loc_res, aiDifficulty,8,15)
    
    ;add timelock
    if aiTimelock
        loc_res = CodeBit(loc_res, 1, 1, 2)
        loc_res = CodeBit(loc_res, aiTimelock, 7, 23)
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

;/  Function: AddJammedLock
    Jams set amount of random locks

    Parameters:

        aiChance    - Chance of lock to be jammed
        asMsg       - Message that will be printed (for example: "Some of the dirt got in to the locks, and jammed them!")
        aiNumber    - Number of locks that will get jammed
/;
Function AddJammedLock(int aiChance = 5, string asMsg = "", int aiNumber = 1)
    if !libs.Config.DisableLockJam
        if RandomInt(1,99) >= aiChance
            return
        endif
        
        while aiNumber && JammRandomLock()
            aiNumber -= 1
        endwhile
        
        _SetJammStatus()
        
        if asMsg != ""
            UDmain.Print(asMsg,2)
        endif
        
        OnLockJammed()
    endif
EndFunction

Function _SetJammStatus()
    libs.SendDeviceJamLockEventVerbose(deviceInventory, UD_DeviceKeyword, wearer)
    StorageUtil.SetIntValue(wearer, "zad_Equipped" + libs.LookupDeviceType(UD_DeviceKeyword) + "_LockJammedStatus", 1)
EndFunction

;/  Function: areLocksJammed
    Returns:
        True if all locks are jammed
/;
bool Function areLocksJammed()
    return UD_JammedLocks == UD_CurrentLocks
EndFunction


;==============================================================================================
;==============================================================================================


;/  Group: Device Menu
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  About: Control Array
    Control array is used for filtering menu options. The value is inverted. So if you want to disable one of the options, you have to change nth value to True
    
    All array values are set to False by default, so if you create the array, you can only disable options that you don't want, while ignoring other options
    
    *Always needs to have size 18!!*
    
    Values:
    
    --- Code
    |===========================================================================================|
    |  Index    |  Conditional value (on script UDCustomDeviceMain)     |       Option          |
    |===========================================================================================|
    |    00     =    currentDeviceMenu_allowstruggling                  =   Struggle            |
    |    01     =    currentDeviceMenu_allowUselessStruggling           =   Struggle uselessly  |
    |    02     =    currentDeviceMenu_allowcutting                     =   Cut                 |
    |    03     =    currentDeviceMenu_allowkey                         =   Unlock              |
    |    04     =    currentDeviceMenu_allowlockpick                    =   Lockpick            |
    |    05     =    currentDeviceMenu_allowlockrepair                  =   Repair              |
    |    06     =    currentDeviceMenu_allowTighten                     =   Tighten             |
    |    07     =    currentDeviceMenu_allowRepair                      =   Repair              |
    |    08     =    currentDeviceMenu_switch1                          =   Custom 1            |
    |    09     =    currentDeviceMenu_switch2                          =   Custom 2            |
    |    10     =    currentDeviceMenu_switch3                          =   Custom 3            |
    |    11     =    currentDeviceMenu_switch4                          =   Custom 4            |
    |    12     =    currentDeviceMenu_switch5                          =   Custom 5            |
    |    13     =    currentDeviceMenu_switch6                          =   Custom 6            |
    |    14     =    currentDeviceMenu_allowCommand                     =   Command             |
    |    15     =    currentDeviceMenu_allowDetails                     =   Details             |
    |    16     =    currentDeviceMenu_allowSpecialMenu                 =   Special             |
    |    17     =    currentDeviceMenu_allowLockMenu                    =   Locks               |
    |===========================================================================================|
    ---
/;

;/  Function: CreateControlArrayFalse
    Returns:

        New Control array with all elements set to False
/;
Bool[] Function CreateControlArrayFalse() Global
    return new Bool[18]
EndFunction

;/  Function: CreateControlArrayTrue
    Returns:

        New Control array with all elements set to True
/;
Bool[] Function CreateControlArrayTrue() Global
    return Utility.CreateBoolArray(18,True)
EndFunction


Function _filterControl(bool[] aControlFilter, Bool abReadOnly = False)
    if (!abReadOnly)
        UDCDmain.currentDeviceMenu_allowstruggling          = UDCDmain.currentDeviceMenu_allowstruggling        &&  !aControlFilter[00]
        UDCDmain.currentDeviceMenu_allowUselessStruggling   = UDCDmain.currentDeviceMenu_allowUselessStruggling &&  !aControlFilter[01]
        UDCDmain.currentDeviceMenu_allowcutting             = UDCDmain.currentDeviceMenu_allowcutting           &&  !aControlFilter[02]
        UDCDmain.currentDeviceMenu_allowkey                 = UDCDmain.currentDeviceMenu_allowkey               &&  !aControlFilter[03]
        UDCDmain.currentDeviceMenu_allowlockpick            = UDCDmain.currentDeviceMenu_allowlockpick          &&  !aControlFilter[04]
        UDCDmain.currentDeviceMenu_allowlockrepair          = UDCDmain.currentDeviceMenu_allowlockrepair        &&  !aControlFilter[05]
        UDCDmain.currentDeviceMenu_allowTighten             = UDCDmain.currentDeviceMenu_allowTighten           &&  !aControlFilter[06]
        UDCDmain.currentDeviceMenu_allowRepair              = UDCDmain.currentDeviceMenu_allowRepair            &&  !aControlFilter[07]
        UDCDmain.currentDeviceMenu_switch1                  = UDCDmain.currentDeviceMenu_switch1                &&  !aControlFilter[08]
        UDCDmain.currentDeviceMenu_switch2                  = UDCDmain.currentDeviceMenu_switch2                &&  !aControlFilter[09]
        UDCDmain.currentDeviceMenu_switch3                  = UDCDmain.currentDeviceMenu_switch3                &&  !aControlFilter[10]
        UDCDmain.currentDeviceMenu_switch4                  = UDCDmain.currentDeviceMenu_switch4                &&  !aControlFilter[11]
        UDCDmain.currentDeviceMenu_switch5                  = UDCDmain.currentDeviceMenu_switch5                &&  !aControlFilter[12]
        UDCDmain.currentDeviceMenu_switch6                  = UDCDmain.currentDeviceMenu_switch6                &&  !aControlFilter[13]
        UDCDmain.currentDeviceMenu_allowCommand             = UDCDmain.currentDeviceMenu_allowCommand           &&  !aControlFilter[14]
        UDCDmain.currentDeviceMenu_allowDetails             = UDCDmain.currentDeviceMenu_allowDetails           &&  !aControlFilter[15]
        UDCDmain.currentDeviceMenu_allowSpecialMenu         = UDCDmain.currentDeviceMenu_allowSpecialMenu       &&  !aControlFilter[16]
        UDCDmain.currentDeviceMenu_allowLockMenu            = UDCDmain.currentDeviceMenu_allowLockMenu          &&  !aControlFilter[17]
    else
        UDCDmain.currentDeviceMenu_allowDetails             = UDCDmain.currentDeviceMenu_allowDetails           &&  !aControlFilter[15]
    endif
EndFunction

Function _deviceMenuInit(bool[] aaControl)
    ;updates difficulty
    updateDifficulty()
    setHelper(none)
    UDCDmain.resetCondVar()

    Bool loc_canstrugglemods = Udmain.UDMOM.GetModifierState_MinigameAllowed(self)
    if loc_canstrugglemods
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
    endif
    
    if StorageUtil.GetIntValue(GetWearer(), "zad_Equipped" + libs.LookupDeviceType(UD_DeviceKeyword) + "_ManipulatedStatus", 0)
        UDCDmain.currentDeviceMenu_allowEscape = true
    endif
    
    if loc_canstrugglemods
        ;override function
        onDeviceMenuInitPost(aaControl)
    endif
    
    ;sets last opened device
    if WearerIsPlayer()
        UDCDmain.setLastOpenedDevice(self)
    endif
    
    _filterControl(aaControl)
    UDCdmain.CheckAndDisableSpecialMenu()
EndFunction

;/  Function: DeviceMenu
    Opens device menu.

    Parameters:

        aaControl   - <Control Array>
        
    Example:
    
    --- Code
    import UD_CustomDevice_RenderScript
    
    ...
    Bool[] loc_ca = CreateControlArrayFalse()
    loc_ca[01] = True ;Disable useless struggle option
    loc_ca[15] = True ;Disable details option
    someDevice.DeviceMenu(loc_ca)
    ...
    ---
/;
Function DeviceMenu(bool[] aaControl)
    if UDmain.TraceAllowed()
        UDmain.Log(getDeviceHeader()+" DeviceMenu() called , aaControl = "+aaControl,2)
    endif
    
    GoToState("UpdatePaused")
    
    bool _break = False
    while !_break
        setHelper(none)
        _deviceMenuInit(aaControl)
        String loc_str = _GetDeviceMainMenuText()
        Int msgChoice = UDMain.UDMMM.ShowMessageBoxMenu(UD_MessageDeviceInteraction, UDMain.UDMMM.NoValues, loc_str, UDMain.UDMMM.NoButtons, UDMTF.HasHtmlMarkup())
        StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
        if msgChoice == 0        ;struggle
            _break = struggleMinigame()
        elseif msgChoice == 1    ;useless struggle
            _break = struggleMinigame(5)
        elseif msgChoice == 2    ;manage locks
            _break = _lockMenu()
        elseif msgChoice == 3    ;cutting
            _break = cuttingMinigame()
        elseif msgChoice == 4     ;special menu
            _break = _specialMenu()
        elseif msgChoice == 5     ;escape
            UnlockRestrain()
            _break = true
        elseif msgChoice == 6     ;details
            processDetails()        
        else
            _break = True         ;exit
        endif
        DeviceMenuExt(msgChoice)
    endwhile
    GoToState("")
EndFunction

bool Function _lockMenu()
    Int msgChoice = UDMain.UDMMM.ShowMessageBoxMenu(UDCDmain.DefaultLockMenuMessage, UDMain.UDMMM.NoValues, "", UDMain.UDMMM.NoButtons)
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

bool Function _specialMenu()
    if UD_SpecialMenuInteraction
        int  loc_res  = UDMain.UDMMM.ShowMessageBoxMenu(UD_SpecialMenuInteraction, UDMain.UDMMM.NoValues, "", UDMain.UDMMM.NoButtons)
        bool loc_res2 = proccesSpecialMenu(loc_res)
        return loc_res2
    else
        return False
    endif
EndFunction

Function _deviceMenuInitWH(Actor akSource,bool[] aaControl)
    ;updates difficulty
    setHelper(akSource)
    
    UDCDmain.resetCondVar()
    
    if (akSource)
        updateDifficulty()
        bool    loc_freehands_wearer     = WearerFreeHands(true,False)
        bool    loc_freehands_helper     = HelperFreeHands(true)
        bool    loc_canstrugglemods      = Udmain.UDMOM.GetModifierState_MinigameAllowed(self)
        if loc_canstrugglemods
            float   loc_accesibility         = getAccesibility()
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
            
            if (UDCDmain.currentDeviceMenu_allowkey || UDCDmain.currentDeviceMenu_allowlockpick || UDCDmain.currentDeviceMenu_allowlockrepair)
                UDCDmain.currentDeviceMenu_allowLockMenu = true
            endif
        endif
        
        if StorageUtil.GetIntValue(GetWearer(), "zad_Equipped" + libs.LookupDeviceType(UD_DeviceKeyword) + "_ManipulatedStatus", 0)
            UDCDmain.currentDeviceMenu_allowEscape = true
        endif
            
        if loc_canstrugglemods
            ;override function
            onDeviceMenuInitPostWH(aaControl)
        endif
        
        if !loc_freehands_wearer && loc_freehands_helper
            UDCDmain.currentDeviceMenu_allowTighten = True
        endif
        
        if !loc_freehands_wearer && loc_freehands_helper && canBeRepaired(akSource)
            UDCDmain.currentDeviceMenu_allowRepair = True
        endif
        
        if WearerIsFollower() && !WearerIsPlayer()
            UDCDmain.currentDeviceMenu_allowCommand = True
        endif
    endif
    
    _filterControl(aaControl,akSource == none)
    UDCdmain.CheckAndDisableSpecialMenu()
EndFunction

;/  Function: DeviceMenuWH
    Opens device menu with passed actor as helper

    Parameters:

        akSource    - Actor who will be set to helper once the menu opens
        aaControl   - <Control Array>
        
    Example:
    
    --- Code
    import UD_CustomDevice_RenderScript
    
    ...
    Bool[] loc_ca = CreateControlArrayTrue()
    loc_ca[00] = False ;Enable struggle option
    
    ;open device menu where player can only select struggle option
    someDevice.DeviceMenuWH(SomeFriendlyNPCloc_ca)
    ...
    ---
/;
Function DeviceMenuWH(Actor akSource,bool[] aaControl)
    if UDmain.TraceAllowed()
        UDmain.Log(getDeviceHeader() + " DeviceMenuWH() called, aaControl = "+aaControl,2)
    endif
    
    GoToState("UpdatePaused")
    
    bool _break = False
    while !_break
        StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
        StorageUtil.UnSetIntValue(akSource, "UD_ignoreEvent" + deviceInventory)

        if _MinigameOn
            UDmain.Print("You can't access this device when wearer is struggling")
            akSource = none
        endif

        _deviceMenuInitWH(akSource, aaControl)
        String loc_str = _GetDeviceMainMenuText()
        Int msgChoice = UDMain.UDMMM.ShowMessageBoxMenu(UD_MessageDeviceInteractionWH, UDMain.UDMMM.NoValues, loc_str, UDMain.UDMMM.NoButtons)
        if msgChoice == 0        ;help struggle
            _break = struggleMinigameWH(akSource)
        elseif msgChoice == 1    ;lockpick
            _break = _lockMenuWH(akSource)
        elseif msgChoice == 2    ;help cutting
            _break = cuttingMinigameWH(akSource)
        elseif msgChoice == 3     ;special
            _break = _specialMenuWH(akSource)
        elseif msgChoice == 4    ;tighten up
            tightUpDevice(akSource)
            _break = false
        elseif msgChoice == 5    ;repair
            repairDevice(akSource)
            _break = true
        elseif msgChoice == 6    ;command
            aaControl = CreateControlArrayFalse()
            DeviceMenu(aaControl)
            _break = True
        elseif msgChoice == 7     ;escape
            UnlockRestrain()
            _break = true
        elseif msgChoice == 8    ;details
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

bool Function _lockMenuWH(Actor akSource)
    Int msgChoice =  UDMain.UDMMM.ShowMessageBoxMenu(UDCDmain.DefaultLockMenuMessageWH, UDMain.UDMMM.NoValues, "", UDMain.UDMMM.NoButtons)
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

bool Function _specialMenuWH(Actor akSource)
    if UD_SpecialMenuInteractionWH
        int  loc_res  = UDMain.UDMMM.ShowMessageBoxMenu(UD_SpecialMenuInteractionWH, UDMain.UDMMM.NoValues, "", UDMain.UDMMM.NoButtons)
        bool loc_res2 = proccesSpecialMenuWH(akSource,loc_res)
        return loc_res2
    else
        return False
    endif
EndFunction


;/  Group: Minigame
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: getDurabilityDmgMod
    This value might not be correct. It is only updated when device menu is opened and minigame starts

    Returns:

        Device durability dmg after after difficulty is applied
/;
float Function getDurabilityDmgMod()
    return _durability_damage_mod
EndFunction

;/  Function: updateDifficulty
    Update device difficulty. Updates return value of <getDurabilityDmgMod>. Validate jammed locks
/;
Function updateDifficulty()
    _durability_damage_mod = UD_durability_damage_base*UDCDmain.getStruggleDifficultyModifier()*(1.0 + _getLockMinigameModifier())
    ValidateJammedLocks()
EndFunction

;/  Function: getElapsedCooldownTime
    Returns:

        elapsed time for cooldown in minutes
/;
float Function getElapsedCooldownTime()
    return _updateTimePassed
EndFunction

;/  Function: getRelativeElapsedCooldownTime
    Returns:

       Relative elapsed cooldown untill next activation
/;
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
    
    _updateCondition()
    
    OnUpdatePost(timePassed)
EndFunction

;/  Function: resetCooldown
    Reset cooldown
    Parameters:

        afMult  - Multiplier for next cooldown. Setting this to 2.0 for example will increase cooldown after reset to 2x
/;
Function resetCooldown(Float afMult)
    _updateTimePassed = 0.0
    _currentRndCooldown = Round(CalculateCooldown()*afMult)
EndFunction

Function UpdateCooldown()
EndFunction

;/  Function: CalculateCooldown
    Calculate cooldown based on MCM setting and passed multiplier. This method contains RNG and calling it multiple times will get you different results
    Parameters:

        afMult  - Multiplier for cooldown. Setting this to 2.0 for example will increase cooldown 2x
        
    Returns:

       Calculated cooldown
/;
int Function CalculateCooldown(Float afMult = 1.0)
    return iRange(Round(afMult*UD_Cooldown*RandomFloat(0.75,1.25)*UDCDmain.UD_CooldownMultiplier),5,24*60*60*10)
EndFunction

;like Update function, but called only once per hour
;mult -> multiplier which identifies how many hours have passed (1.5 hours -> mult = 1.5)
Function UpdateHour()
    Float loc_mult = ResetLastHourUpdate()
    if OnUpdateHourPre()
        if OnUpdateHourPost()
        endif
    endif
    UpdateAllLocksTimeLock(-1*Math.Ceiling(loc_mult),True) ;update timed locks
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

;/  Function: getRelativeDurability
    Returns:

       Relative health of device from 0.0 to 1.0. When at max value -> 1.0
/;
float Function getRelativeDurability()
    return current_device_health/UD_Health
EndFunction 

;/  Function: getRelativeCuttingProgress
    Returns:

       Relative cutting progress from 0.0 to 1.0
/;
float Function getRelativeCuttingProgress()
    return _CuttingProgress/100.0
EndFunction

float Function _GetRelativeLockRepairProgress(Int aiLockIndex)
    return GetNthLockRepairProgress(aiLockIndex)/_getLockDurability()
EndFunction

float Function _getLockDurability()
    return 100.0
EndFunction

;/  Function: getRelativeLocks
    Returns:

       Relative number of still lcoked locks. Returns 1.0 if all locks are locked
/;
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
int Function _getLockpickLevel(Int aiLockIndex, Int aiDiff = 0)
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
    if haveHelper() && HelperFreeHands(True)
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

    if haveHelper()
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

;/  Function: WearerHaveTelekinesis
    Returns:

       True if wearer have learned telekinesis spell
/;
Bool Function WearerHaveTelekinesis()
    return Wearer.hasspell(UDlibs.TelekinesisSpell)
EndFunction

;/  Function: WearerHaveTelekinesis
    Returns:

       True if helper have learned telekinesis spell
/;
Bool Function HelperHaveTelekinesis()
    if !haveHelper()
        return false
    endif
    return getHelper().hasspell(UDlibs.TelekinesisSpell)
EndFunction

int Function _GetTelekinesisLockModifier()
    int loc_res = 0
    if WearerHaveTelekinesis()
        loc_res += 15
    endif
    if haveHelper()
        if HelperHaveTelekinesis()
            loc_res += 15
        endif    
    endif
    return loc_res
EndFunction

;/  Function: setWidgetVal
    Change value of main device widget
    
    Parameters:

        afVal  - New widget meter value
        abForce - If value should be forced (no change animation)
/;
Function setWidgetVal(float afVal, bool abForce = false)
    UDmain.UDWC.Meter_SetFillPercent("device-main", afVal * 100.0, abForce)
EndFunction

;/  Function: setSecWidgetVal
    Change value of secundary device widget (condition)
    
    Parameters:

        afVal  - New widget meter value
        abForce - If value should be forced (no change animation)
/;
Function setSecWidgetVal(float afVal, bool abForce = false)
    UDmain.UDWC.Meter_SetFillPercent("device-condition", afVal * 100.0, abForce)
EndFunction

;/  Function: setMainWidgetAppearance
    Update apparance of main device widget (durability, rapir progress, etc...)
    
    Parameters:

        aiColor1        - Main color
        aiColor2        - Secondary color
        aiFlashColor    - Flash color
        asIconName      - Icon
/;
Function setMainWidgetAppearance(Int aiColor1, Int aiColor2 = -1, Int aiFlashColor = -1, String asIconName = "")
    if PlayerIsPresent()
        UDmain.UDWC.Meter_SetColor("device-main", aiColor1, aiColor2, aiFlashColor)
        If asIconName != ""
            UDMain.UDWC.Meter_SetIcon("device-main", asIconName)
        EndIf
    endif
EndFunction

;/  Function: setSecWidgetAppearance
    Update apparance of secondary device widget (condition)
    
    Parameters:

        aiColor1        - Main color
        aiColor2        - Secondary color
        aiFlashColor    - Flash color
/;
Function setSecWidgetAppearance(Int aiColor1, Int aiColor2 = -1, Int aiFlashColor = -1, String asIconName = "")
    if PlayerIsPresent()
        UDmain.UDWC.Meter_SetColor("device-condition", aiColor1, aiColor2, aiFlashColor)
        If asIconName != ""
            UDMain.UDWC.Meter_SetIcon("device-condition", asIconName)
        EndIf
    ;    UDMain.UDWC.Meter_SetIcon("device-condition", "icon-meter-condition")
    endif
EndFunction

;/  Function: showWidget
    Toggle on main widget, and secondary widget if the flag is set
    
    Parameters:

        abUpdate        - If widget value should be updated first
        abUpdateColor   - If widget color should be updated first
/;
Function showWidget(Bool abUpdate = true, Bool abUpdateColor = true)
    bool loc_useWidget      = UD_useWidget
    bool loc_useWidgetSec   = UD_useWidgetSec
    if loc_useWidget || loc_useWidgetSec
        if abUpdate
            updateWidget(true)
        endif
        if abUpdateColor
            updateWidgetColor()
        endif
    endif
    if loc_useWidget
        UDmain.UDWC.Meter_SetVisible("device-main", True)
    endif
    If loc_useWidgetSec
        UDmain.UDWC.Meter_SetVisible("device-condition", True)
    EndIf
EndFunction

;/  Function: hideWidget
    Hide both widgets
/;
Function hideWidget()
    UDmain.UDWC.Meter_SetVisible("device-main", False)
    UDmain.UDWC.Meter_SetVisible("device-condition", False)
EndFunction

;/  Function: decreaseDurabilityAndCheckUnlock
    Decrease device durability and unlock device if durability reaches 0. Also reduced condition based on dealth durability damage
    
    Parameters:

        afValue             - By how much will be durability reduced. This is final value and no modofiers will be applied
        afCondMult          - Condition damange multiplier
        abCheckCondition    - If condition level should be updated
/;
Function decreaseDurabilityAndCheckUnlock(float afValue,float afCondMult = 1.0,Bool abCheckCondition = True)
    if current_device_health > 0.0
        if PlayerInMinigame() && UD_damage_device
            ;update and fetch value from native meter
            current_device_health = UDmain.UDWC.Meter_UpdateNativeValue("device-main",-1.0*afValue)*UD_Health/100.0
        else
            current_device_health = current_device_health - afValue
        endif
        _DecreaseCondition(afValue,afCondMult,abCheckCondition)
    endif
    
    _CheckUnlock()
EndFunction

Function _DecreaseCondition(Float afCondition, Float afMult, bool abCheckCondition)
    if PlayerInMinigame() && UD_damage_device
        ;update fetch value from native meter
        _total_durability_drain = UDmain.UDWC.Meter_UpdateNativeValue("device-condition",-1.0*afCondition*afMult)*UD_Health/100.0
    else
        _total_durability_drain += afCondition*afMult
    endif
    if abCheckCondition && current_device_health > 0 && afMult != 0.0
        _updateCondition()
    endif
EndFunction

Function _CheckUnlock()
    if current_device_health <= 0.0 && !IsUnlocked
        unlockRestrain()
    endif
EndFunction

;/  Function: getDurability
    Returns:

       Current device durability/health
/;
float Function getDurability()
    return current_device_health
EndFunction

;/  Function: getMaxDurability
    Returns:

       Maximum device durability/health
       
    See: <UD_Health>
/;
float Function getMaxDurability()
    return UD_Health
EndFunction

;/  Function: getCondition
    Returns:

        Get absolute condition of device. Always in range from 0.0 to max device health
/;
float Function getCondition()
    return _total_durability_drain
EndFunction

;/  Function: getRelativeCondition
    Returns:

        Get relative condition of device. Always in range from 0.0 to 1.0
/;
float Function getRelativeCondition()
    return (UD_Health - _total_durability_drain)/UD_Health
EndFunction

;/  Function: setDurability
    Sets current durability (health) of device to passed value
    
    Avoid using this function while device is in minigame

    Parameters:

        afDurability    - New Durability value
/;
Function setDurability(float afDurability)
    current_device_health = afDurability
EndFunction

;/  Function: refillDurability
    Refill (repair) durability (health) of device by passed value

    If the device will be repaired by more that is its maximum limit, it will cause condition to be repaired

    Parameters:

        afValue    - By how much
/;
Function refillDurability(float afValue)
    if current_device_health > 0.0 && afValue > 0
        current_device_health += afValue
        if (current_device_health > UD_Health)
            _total_durability_drain -= 0.5*(afValue)
            current_device_health = UD_Health
            _updateCondition(False)
        endif
    endif
EndFunction

;/  Function: refillCuttingProgress
    Refill (repair) cutting progress of device by passed value

    Parameters:

        afValue    - By how much
/;
Function refillCuttingProgress(float afValue)
    if current_device_health > 0.0 && afValue > 0
        _CuttingProgress -= afValue
        if _CuttingProgress < 0.0
            _CuttingProgress = 0.0
        endif
    endif
EndFunction

Function _updateCondition(bool decrease = True)
    Float loc_health = UD_Health
    if decrease
        while (_total_durability_drain >= loc_health) && !IsUnlocked && UD_condition < 4
            if PlayerInMinigame() && UD_damage_device
                UDmain.UDWC.Meter_SetNativeValue("device-condition",100)
                _total_durability_drain = 0
            else
                _total_durability_drain -= loc_health
            endif
            UD_condition += 1
            if WearerIsPlayer()
                UDmain.Print("You feel that "+getDeviceName()+" condition have decreased!",2)
            elseif UDCDmain.AllowNPCMessage(GetWearer(), true)
                UDmain.Print(GetWearerName() + "s " + getDeviceName() + " condition have decreased!",3)
            endif
        endwhile
    else
        if (_total_durability_drain < 0) && !IsUnlocked
            _total_durability_drain = 0
            if UD_condition > 0 
                UD_condition -= 1
                if WearerIsPlayer()
                    UDmain.Print("You feel that "+getDeviceName()+" condition have increased!",1)
                elseif UDCDmain.AllowNPCMessage(GetWearer(), true)
                    UDmain.Print(GetWearerName() + "s " + getDeviceName() + " condition have increased!",3)
                endif
            endif
        endif
    endif
    
    if UD_condition >= 4 && !IsUnlocked
        if WearerIsPlayer()
            UDmain.Print("You managed to destroy "+ getDeviceName() +"!",2)
        elseif WearerIsFollower()
            UDmain.Print(GetWearerName() + " managed to destroy " + getDeviceName() + "!",2)
        endif
        unlockRestrain(True)
    endif
EndFunction

;/  Function: getConditionString

    Returns:

        String alias of current device condition level
        --- Code
        |===============================|
        |   Level  |        Alias       |
        |===============================|
        |    0     =     Excellent      |
        |    1     =     Good           |
        |    2     =     Normal         |
        |    3     =     Bad            |
        |===============================|
        ---
/;
string Function getConditionString()
    String loc_str = ""
    Int loc_percent = 0
    if (UD_condition == 0)
        loc_str = "Excellent"
        loc_percent = 100
    elseif (UD_condition == 1)
        loc_str = "Good"
        loc_percent = 75
    elseif (UD_condition == 2)
        loc_str = "Normal"
        loc_percent = 50
    elseif (UD_condition == 3)
        loc_str = "Bad"
        loc_percent = 25
    else
        loc_str = "Destroyed"
        loc_percent = 0
    endif
    Return UDMTF.TextDecoration(loc_str, asColor = UDMTF.PercentToRainbow(loc_percent))
EndFunction

String Function getHealthString()
    Float loc_dur = getRelativeDurability()
    String loc_str = ""
    if (loc_dur >= 0.9)
        loc_str = "Perfect"
    elseif (loc_dur >= 0.75)
        loc_str = "Excellent"
    elseif (loc_dur >= 0.60)
        loc_str = "Good"
    elseif (loc_dur >= 0.40)
        loc_str = "Average"
    elseif (loc_dur >= 0.25)
        loc_str = "Poor"
    elseif (loc_dur >= 0.1)
        loc_str = "Very low"
    else
        loc_str = "Abysmal"
    endif
    Return UDMTF.TextDecoration(loc_str, asColor = UDMTF.PercentToRainbow(Round(loc_dur * 100)))
EndFunction

String Function getBaseDamageString()
    if (UD_durability_damage_base >= 2.5)
        Return UDMTF.TextDecoration("Very easy", asColor = UDMTF.PercentToRainbow(100))
    elseif (UD_durability_damage_base >= 1.5)
        Return UDMTF.TextDecoration("Easy", asColor = UDMTF.PercentToRainbow(83))
    elseif (UD_durability_damage_base >= 0.75)
        Return UDMTF.TextDecoration("Moderately difficult", asColor = UDMTF.PercentToRainbow(67))
    elseif (UD_durability_damage_base >= 0.3)
        Return UDMTF.TextDecoration("Hard", asColor = UDMTF.PercentToRainbow(50))
    elseif (UD_durability_damage_base >= 0.05)
        Return UDMTF.TextDecoration("Very hard", asColor = UDMTF.PercentToRainbow(33))
    elseif UD_durability_damage_base > 0
        Return UDMTF.TextDecoration("Extremely hard", asColor = UDMTF.PercentToRainbow(17))
    else
        Return UDMTF.TextDecoration("Impossible", asColor = UDMTF.PercentToRainbow(0))
    endif
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

;/  Function: getModResistPhysical
    Parameters:

        afBase      - Base of resistence (for example 1.0=100%)
        afCondMod   - Condition modifier. Change value by (10% + afCondMod) per condition level
        
    Returns:

        Physical damage multiplier
/;
float Function getModResistPhysical(float afBase = 1.0,float afCondMod = 0.0)
    return (afBase - UD_ResistPhysical + (0.1 + afCondMod)*UD_Condition)
EndFunction

;/  Function: getModResistMagicka
    Parameters:

        afBase      - Base of resistence (for example 1.0=100%)
        afCondMod   - Condition modifier. Change value by (10% + afCondMod) per condition level
        
    Returns:

        Magic damage multiplier
/;
float Function getModResistMagicka(float afBase = 1.0,float afCondMod = 0.0)
    return (afBase - UD_ResistMagicka + (0.1 + afCondMod)*UD_Condition)
EndFunction

;/  Function: getHelperAgilitySkills
    Returns:

        Absolute value of agility skill of helper or 0.0 if device have not helper
/;
float Function getHelperAgilitySkills()
    if haveHelper()
        return UDMain.UDSKILL.GetAgilitySkill(getHelper())
    else
        return 0.0
    endif
EndFunction

;/  Function: getHelperAgilitySkillsPerc
    Returns:

        Relative agility skill of helper or 0.0 if device have not helper. As it is hard to pinpoint maximum value, virtual value 100 is choosen. Because of that, it is possible that this value can be more then 1.0.
/;
float Function getHelperAgilitySkillsPerc()
    if haveHelper()
        return UDMain.UDSKILL.getActorAgilitySkillsPerc(getHelper())
    else
        return 0.0
    endif
EndFunction

;/  Function: getHelperStrengthSkills
    Returns:

        Absolute value of strength skill of helper or 0.0 if device have not helper
/;
float Function getHelperStrengthSkills()
    if haveHelper()
        return UDMain.UDSKILL.GetStrengthSkill(getHelper())
    else
        return 0.0
    endif
EndFunction

;/  Function: getHelperStrengthSkillsPerc
    Returns:

        Relative strength skill of helper or 0.0 if device have not helper. As it is hard to pinpoint maximum value, virtual value 100 is choosen. Because of that, it is possible that this value can be more then 1.0.
/;
float Function getHelperStrengthSkillsPerc()
    if haveHelper()
        return UDMain.UDSKILL.getActorStrengthSkillsPerc(getHelper())
    else
        return 0.0
    endif
EndFunction

;/  Function: getHelperMagickSkills
    Returns:

        Absolute value of magic skill of helper or 0.0 if device have not helper
/;
float Function getHelperMagickSkills()
    if haveHelper()
        return UDMain.UDSKILL.GetMagickSkill(getHelper())
    else
        return 0.0
    endif
EndFunction

;/  Function: getHelperMagickSkillsPerc
    Returns:

        Relative magic skill of helper or 0.0 if device have not helper. As it is hard to pinpoint maximum value, virtual value 100 is choosen. Because of that, it is possible that this value can be more then 1.0.
/;
float Function getHelperMagickSkillsPerc()
    if haveHelper()
        return UDMain.UDSKILL.getActorMagickSkillsPerc(getHelper())
    else
        return 0.0
    endif
EndFunction

;/  Function: StruggleMinigameAllowed
    Parameters:

        afAccesibility  - External accessibility. Use this if you already have value of accessibility, so the framework don't have to calculate it again. Will calculate the accessibility if this is less then 0.0

        
    Returns:

        True if struggle minigame is allowed. Doesn't check actor stats
/;
Bool Function StruggleMinigameAllowed(Float afAccesibility)
    return canBeStruggled(afAccesibility)
EndFunction

;/  Function: CuttingMinigameAllowed
    Parameters:

        afAccesibility  - External accessibility. Use this if you already have value of accessibility, so the framework don't have to calculate it again. Will calculate the accessibility if this is less then 0.0

        
    Returns:

        True if cutting minigame is allowed. Doesn't check actor stats
/;
Bool Function CuttingMinigameAllowed(Float afAccesibility)
    return canBeCutted() && afAccesibility
EndFunction

;/  Function: NthLockMinigamesAllowed
    Parameters:

        aiLockID        - ID of lock to check
        afAccesibility  - External accessibility. Use this if you already have value of accessibility, so the framework don't have to calculate it again. Will calculate the accessibility if this is less then 0.0
        
    Returns:

        Bit coded value.
        ---Code
            0x00000001 = lockpick minigame allowed
            0x00000002 = key unlock minigame allowed
            0x00000004 = locok repair minigame allowed
        ---
        
        
    Example:
        ---Code
            ;check second lock. Accessibility is 50%
            Int loc_res = NthLockMinigamesAllowed(1,0.5)
            
            ;do something if the lock can be unlocked or repaired
            if Math.LogicalAnd(loc_res,0x00000006)
                ;something
            endif
        ---
    
/;
Int  Function NthLockMinigamesAllowed(Int aiLockID, Float afAccesibility)
    if IsNthLockUnlocked(aiLockID)
        return 0x0 ;lock is unlocked, no minigame slould be allowed
    endif
    
    if IsNthLockTimeLocked(aiLockID) && GetNthLockTimeLock(aiLockID)
        return 0x0 ;lock is time locked, no minigame is allowed!
    endif
    
    bool loc_telekinesis = WearerHaveTelekinesis() || HelperHaveTelekinesis()
    
    if !loc_telekinesis && !GetHelper() ;no helper, check if wearer can reach the lock themself
        Int loc_Accessibility = GetNthLockAccessibility(aiLockID)
        if !loc_Accessibility
            return 0x0 ;lock is inaccessible by wearer, help of other person is needed
        endif
    endif
    Int loc_res = 0
    if (afAccesibility > 0) || loc_telekinesis ;check if device can be accessed by wearer
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

;/  Function: LockMinigameAllowed
    Parameters:

        afAccesibility  - External accessibility. Use this if you already have value of accessibility, so the framework don't have to calculate it again. Will calculate the accessibility if this is less then 0.0
        
    Returns:

        Bit coded value.
        ---Code
            0x00000001 = At least one lock have lockpick minigame allowed
            0x00000002 = At least one lock have key unlock minigame allowed
            0x00000004 = At least one lock have locok repair minigame allowed
        ---
        
        
    Example:
        ---Code
            ;check all locks, calculate accessibility
            Int loc_res = LockMinigameAllowed(1)
            
            ;do something if the any of the locks can be unlocked
            if Math.LogicalAnd(loc_res, 0x00000002)
                ;something
            endif
        ---
    
/;
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

;/  Function: struggleMinigame
    Starts struggle minigame. This function include all checks and is safew to be called at all times.


        ---Code
            |==========================================|
            |  aiType  |          Minigame             |
            |==========================================|
            |    0     |  Normal struggle minigame     |
            |    1     |  Desperate struggle minigame  |
            |    2     |  Magic struggle minigame      |
            |    3     |  Slow struggle minigame       |
            |    4     |  Don't start minigame         |
            |    5     |  Useless struggle minigame    |
            |==========================================|
        ---

    Parameters:

        aiType      - Type of minigame. If -1, function will open message box in which player can select which minigame struggleMinigame be started
        abSilent    - If messages should be printed

    Returns:

        True if struggle minigame started and ended
/;
bool Function struggleMinigame(int aiType = -1, Bool abSilent = False)
    if aiType == -1
        String los_msg = _GetDeviceStruggleMenuText()
        aiType = UDMain.UDMMM.ShowMessageBoxMenu(UDCDmain.StruggleMessage, UDMain.UDMMM.NoValues, los_msg, UDMain.UDMMM.NoButtons)
    endif

    if aiType == 4
        return false
    endif
    
    if !minigamePrecheck(abSilent)
        return false
    endif
    
    resetMinigameValues()
    
    setMinigameWidgetVar((aiType != 5), False, False, 0xFF0000, 0x00FF00, -1, "icon-meter-struggle")
    setSecWidgetVar((aiType < 3), True, False, -1, -1, -1, "icon-meter-condition")
    
    if aiType == 0 ;normal
        UD_minigame_stamina_drain = UD_base_stat_drain*0.75 + getMaxActorValue(Wearer,"Stamina",0.035)
        UD_durability_damage_add = 1.25*(_durability_damage_mod*UDMain.UDSKILL.getActorAgilitySkillsPerc(getWearer()))
        UD_DamageMult *= getModResistPhysical(1.0,0.3)
        _exhaustion_mult = 0.5
        _condition_mult_add = -0.9
        UD_RegenMag_Magicka = 0.4
        UD_RegenMag_Health = 0.4
        _minMinigameStatSP = 0.25
    elseif aiType == 1 ;desperate
        UD_minigame_stamina_drain = UD_base_stat_drain*1.1
        UD_minigame_heal_drain = 0.5*UD_base_stat_drain + getMaxActorValue(Wearer,"Health",0.06)
        UD_durability_damage_add = 1.0*(_durability_damage_mod*((5.0 - 5.0*getRelativeDurability()) + UDMain.UDSKILL.getActorStrengthSkillsPerc(getWearer())));UDmain.getMaxActorValue(Wearer,"Health",0.02);*getModResistPhysical()
        UD_DamageMult *= getModResistPhysical(1.0,0.2)
        _condition_mult_add = -0.5
        _exhaustion_mult = 1.6
        UD_RegenMag_Magicka = 0.5
        _minMinigameStatSP = 0.2
        _minMinigameStatHP = 0.4
    elseif aiType == 2 ;magick
        UD_minigame_stamina_drain = 0.65*UD_base_stat_drain
        UD_minigame_magicka_drain = 0.75*UD_base_stat_drain + getMaxActorValue(Wearer,"Magicka",0.05)
        UD_durability_damage_add = 1.0*(_durability_damage_mod*UDMain.UDSKILL.getActorMagickSkillsPerc(getWearer()))
        UD_DamageMult *= getModResistMagicka(1.0,0.3)
        _condition_mult_add = 1.5
        _exhaustion_mult = 1.2
        UD_RegenMag_Health = 0.8
        _minMinigameStatSP = 0.4
        _minMinigameStatMP = 0.7
    elseif aiType == 3 ;slow
        UD_durability_damage_add = 0.0
        UD_applyExhastionEffect = False
        UD_minigame_canCrit = False
        UD_DamageMult *= 0.08*getModResistPhysical()
        UD_RegenMag_Stamina = 0.7
        UD_RegenMag_Health = 0.8
        UD_RegenMag_Magicka = 0.7
    elseif aiType == 5 ;useless struggle
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
        
    _struggleGame_Subtype = aiType

    bool loc_minigamecheck = minigamePostcheck(abSilent)
    if loc_minigamecheck
        _StruggleGameON = True
        UD_Events.SendEvent_DeviceMinigameBegin(self,"Struggle_"+aiType)
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"Struggle_"+aiType)
        _StruggleGameON = False
        return true
    else
        return false
    endif
EndFunction

;/  Function: lockpickMinigame
    Starts lockpick minigame. This function include all checks and is safew to be called at all times.

    Parameters:

        abSilent    - If messages should be printed

    Returns:

        True if lockpick minigame started and ended
/;
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
        if PlayerIsPresent()
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
    _customMinigameCritDuration = 0.8 - _getLockpickLevel(_MinigameSelectedLockID)*0.02
    _minMinigameStatSP = 0.8
    
    if minigamePostcheck(abSilent)
        _LockpickGameON = True
        UD_Events.SendEvent_DeviceMinigameBegin(self,"Lockpick")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"Lockpick")
        _LockpickGameON = False
        return true
    else
        return false
    endif
EndFunction

;/  Function: repairLocksMinigame
    Starts lock repair minigame. This function include all checks and is safew to be called at all times.

    Parameters:

        abSilent    - If messages should be printed

    Returns:

        True if lock repair minigame started and ended
/;
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
        if PlayerIsPresent()
            UDmain.Print("You can't repair "+UD_LockNameList[loc_SelectedLock]+"!")
        endif
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar(True, False, False, 0xffbd00, 0xffbd00, -1, "icon-meter-repair")
    
    _MinigameSelectedLockID = loc_SelectedLock
    UD_minigame_stamina_drain = UD_base_stat_drain*1.25
    UD_damage_device = False
    UD_minigame_canCrit = False

    _customMinigameCritChance = 5 + (4 - _getLockpickLevel(_MinigameSelectedLockID))*5
    _customMinigameCritDuration = 0.8 - _getLockpickLevel(_MinigameSelectedLockID)*0.02
    UD_MinigameMult1 = getAccesibility() + UDmain.UDSKILL.getActorSmithingSkillsPerc(getWearer())*0.5
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
        UD_Events.SendEvent_DeviceMinigameBegin(self,"RepairLock")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"RepairLock")
        _RepairLocksMinigameON = False
        return true
    else
        return false
    endif
EndFunction

;/  Function: cuttingMinigame
    Starts cutting minigame. This function include all checks and is safew to be called at all times.

    Parameters:

        abSilent    - If messages should be printed

    Returns:

        True if cutting minigame started and ended
/;
bool Function cuttingMinigame(Bool abSilent = False)
    if !minigamePrecheck(abSilent)
        return false
    endif

    resetMinigameValues()
    setMinigameWidgetVar(True, False, False, 0x4496C6, 0xffbd00, 0x4496C6, "icon-meter-cut")
    setSecWidgetVar(True, True, False, -1, -1, -1, "icon-meter-struggle")
    
    UD_damage_device = False
    UD_minigame_stamina_drain = UD_base_stat_drain + getMaxActorValue(Wearer,"Stamina",0.04)
    UD_minigame_heal_drain = UD_base_stat_drain/2+ getMaxActorValue(Wearer,"Health",0.01)
    UD_RegenMag_Magicka = 0.5
    _minMinigameStatSP = 0.8
    _minMinigameStatHP = 0.5
        
    if minigamePostcheck(abSilent)
        float loc_BaseMult = UDCDmain.getActorCuttingWeaponMultiplier(getWearer())
        
        UD_MinigameMult1 = loc_BaseMult + UDmain.UDSKILL.getActorCuttingSkillsPerc(getWearer())
        UD_DamageMult = loc_BaseMult + UDmain.UDSKILL.getActorCuttingSkillsPerc(getWearer())
        
        ;register native meters
        if WearerIsPlayer()
            UDmain.UDWC.Meter_RegisterNative("device-main",1,0,fRange(200.0 - 5.0*UD_CutChance,125.0,200.0),true)
                
            UD_Native.RegisterDeviceCallback(_VMHandle1,_VMHandle2,DeviceRendered,UDCDMain.SpecialKey_Keycode,"_CuttingMG_SKPress")
            
            string loc_param = UDmain.UDWC.GetMeterIdentifier("device-main")
            UD_Native.AddDeviceCallbackArgument(UDCDMain.SpecialKey_Keycode,0,loc_param, none)
        endif
        
        _CuttingGameON = True
        UD_Events.SendEvent_DeviceMinigameBegin(self,"Cutting")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"Cutting")
        _CuttingGameON = False
        return true
    else
        return false
    endif
EndFunction

;/  Function: keyMinigame
    Starts unlock minigame. This function include all checks and is safew to be called at all times.

    Parameters:

        abSilent    - If messages should be printed

    Returns:

        True if unlock minigame started and ended
/;
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
        if PlayerIsPresent()
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
    _customMinigameCritDuration = 0.85 - _getLockpickLevel(_MinigameSelectedLockID)*0.025
    _minMinigameStatSP = 0.6
    
    
    if minigamePostcheck(abSilent)
        _KeyGameON = True
        UD_Events.SendEvent_DeviceMinigameBegin(self,"KeyUnlock")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"KeyUnlock")
        _KeyGameON = False
        return true
    else
        return false
    endif
EndFunction


;With Help minigames

;/  Function: struggleMinigameWH
    Starts struggle minigame with helper. This function include all checks and is safew to be called at all times.


        ---Code
            |==========================================|
            |  aiType  |          Minigame             |
            |==========================================|
            |    0     |  Normal struggle minigame     |
            |    1     |  Desperate struggle minigame  |
            |    2     |  Magic struggle minigame      |
            |    3     |  Slow struggle minigame       |
            |    4     |  Don't start minigame         |
            |    5     |  Useless struggle minigame    |
            |==========================================|
        ---

    Parameters:

        akHelper    - Actor who will be used as helper
        aiType      - Type of minigame. If -1, function will open message box in which player can select which minigame struggleMinigame be started

    Returns:

        True if struggle minigame with helper started and ended
/;
bool Function struggleMinigameWH(Actor akHelper,int aiType = -1)
    int type = -1
    if type == -1
        String loc_msg = _GetDeviceStruggleMenuText()
        type = UDMain.UDMMM.ShowMessageBoxMenu(UDCDmain.StruggleMessageNPC, UDMain.UDMMM.NoValues, loc_msg, UDMain.UDMMM.NoButtons)
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
    setMinigameWidgetVar(True, False, False, 0xFF0000, 0x00FF00, -1, "icon-meter-struggle")
    setSecWidgetVar(True, True, False, -1, -1, -1, "icon-meter-condition")
    
    if type == 0 ;normal
        UD_durability_damage_add = 0.0
        UD_minigame_stamina_drain = UD_base_stat_drain*0.75 + getMaxActorValue(Wearer,"Stamina",0.03)
        UD_minigame_stamina_drain_helper = UD_base_stat_drain*0.5 + getMaxActorValue(akHelper,"Stamina",0.03)
        UD_durability_damage_add = 1.0*_durability_damage_mod*(0.25 + 2.5*(UDmain.UDSKILL.getActorAgilitySkillsPerc(getWearer()) + getHelperAgilitySkillsPerc()))
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
        UD_minigame_heal_drain_helper = 0.5*UD_base_stat_drain + getMaxActorValue(akHelper,"Health",0.05)
        
        UD_durability_damage_add = 1.0*_durability_damage_mod*((5.0 - 5.0*getRelativeDurability()) + UDmain.UDSKILL.getActorStrengthSkillsPerc(getWearer()) + getHelperStrengthSkillsPerc())
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
        UD_minigame_magicka_drain_helper = UD_base_stat_drain + getMaxActorValue(akHelper,"Magicka",0.05)
        UD_DamageMult = getModResistMagicka(1.0,0.3)*getAccesibility()
        UD_durability_damage_add = 2.0*_durability_damage_mod*(UDmain.UDSKILL.getActorMagickSkillsPerc(getWearer()) + getHelperMagickSkillsPerc())
        
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
        UD_Events.SendEvent_DeviceMinigameBegin(self,"Struggle_"+aiType)
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"Struggle_"+aiType)
        _StruggleGameON = False
        
        return true
    else
        return false
    endif
    
EndFunction

;/  Function: lockpickMinigameWH
    Starts lockpick minigame with helper. This function include all checks and is safew to be called at all times.
    
    Parameters:
        akHelper    - Actor who will be used as helper

    Returns:

        True if lockpick minigame with helper started and ended
/;
bool Function lockpickMinigameWH(Actor akHelper)
    if !minigamePrecheck()
        return false
    endif
    
    Int loc_SelectedLock = 0
    if PlayerIsPresent()
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
        if PlayerIsPresent()
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
        UD_Events.SendEvent_DeviceMinigameBegin(self,"Lockpick")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"Lockpick")
        _LockpickGameON = False
        setHelper(none)
        return true
    else
        return false
    endif
EndFunction

;/  Function: repairLocksMinigameWH
    Starts lock repair minigame with helper. This function include all checks and is safew to be called at all times.

    Parameters:

        akHelper    - Actor who will be used as helper

    Returns:

        True if lock repair minigame with helper started and ended
/;
bool Function repairLocksMinigameWH(Actor akHelper)
    setHelper(akHelper)
    
    if !minigamePrecheck()
        return false
    endif
    
    Int loc_SelectedLock = 0
    if PlayerIsPresent()
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
        if PlayerIsPresent()
            UDmain.Print("You can't repair "+UD_LockNameList[loc_SelectedLock]+"!")
        endif
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar(True, False, False, 0xffbd00, -1, -1, "icon-meter-repair")
    
    _MinigameSelectedLockID = loc_SelectedLock
    
    UD_minigame_stamina_drain = UD_base_stat_drain*1.25
    UD_minigame_stamina_drain_helper = UD_base_stat_drain
    UD_damage_device = False
    UD_minigame_canCrit = False
    
    _customMinigameCritChance = 10 + (4 - _getLockpickLevel(_MinigameSelectedLockID))*5
    UD_MinigameMult1 = getAccesibility() + 0.35*(UDmain.UDSKILL.getActorSmithingSkillsPerc(getWearer()) + UDmain.UDSKILL.getActorSmithingSkillsPerc(getHelper()))
    UD_RegenMag_Magicka = 0.5
    UD_RegenMag_Health = 0.5
    UD_RegenMagHelper_Magicka = 0.75
    UD_RegenMagHelper_Health = 0.75
    _customMinigameCritDuration = 0.85 - _getLockpickLevel(_MinigameSelectedLockID)*0.015
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
        UD_Events.SendEvent_DeviceMinigameBegin(self,"RepairLock")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"RepairLock")
        _RepairLocksMinigameON = False
        setHelper(none)
        return true
    else
        return false
    endif
EndFunction

;/  Function: cuttingMinigameWH
    Starts cutting minigame with helper. This function include all checks and is safew to be called at all times.

    Parameters:

        akHelper    - Actor who will be used as helper

    Returns:

        True if cutting minigame with helper started and ended
/;
bool Function cuttingMinigameWH(Actor akHelper)
    setHelper(akHelper)
    
    if !minigamePrecheck()
        return false
    endif
    
    resetMinigameValues()
    setMinigameWidgetVar(True, False, False, 0x4496C6, 0xffbd00, 0x4496C6, "icon-meter-cut")
    setSecWidgetVar(True, True, False, -1, -1, -1, "icon-meter-struggle")
    
    UD_damage_device = False
    UD_minigame_stamina_drain = UD_base_stat_drain + getMaxActorValue(Wearer,"Stamina",0.04)
    UD_minigame_stamina_drain_helper = UD_base_stat_drain*1.25 + getMaxActorValue(akHelper,"Stamina",0.04)
    UD_minigame_heal_drain = UD_base_stat_drain*0.75 + getMaxActorValue(Wearer,"Health",0.02)
    UD_RegenMag_Magicka = 0.5
    UD_RegenMagHelper_Magicka = 0.75
    UD_RegenMagHelper_Health = 0.75
    _minMinigameStatSP = 0.7
    _minMinigameStatHP = 0.4
    if minigamePostcheck()
        float loc_BaseMult = UDCDmain.getActorCuttingWeaponMultiplier(getWearer())
        float loc_BaseMultHelperAdd = UDCDmain.getActorCuttingWeaponMultiplier(getHelper()) - 1.0
        
        UD_DamageMult = loc_BaseMult + loc_BaseMultHelperAdd + UDmain.UDSKILL.getActorCuttingSkillsPerc(getWearer()) + UDmain.UDSKILL.getActorCuttingSkillsPerc(getHelper())
        UD_MinigameMult1 = UD_DamageMult;loc_BaseMult + loc_BaseMultHelper + UDCDmain.getActorCuttingSkillsPerc(getWearer()) + UDCDmain.getActorCuttingSkillsPerc(getHelper())
        
        if HelperFreeHands(True)
            UD_MinigameMult1 += 0.8
        elseif HelperFreeHands()
            UD_MinigameMult1 += 0.15
        endif
    
        ;register native meters
        if PlayerIsPresent()
            UDmain.UDWC.Meter_RegisterNative("device-main",1,0,fRange(200.0 - 7.0*UD_CutChance,125.0,200.0),true)
            
            UD_Native.RegisterDeviceCallback(_VMHandle1,_VMHandle2,DeviceRendered,UDCDMain.SpecialKey_Keycode,"_CuttingMG_SKPress")
            
            string loc_param = UDmain.UDWC.GetMeterIdentifier("device-main")
            UD_Native.AddDeviceCallbackArgument(UDCDMain.SpecialKey_Keycode,0,loc_param, none)
        endif
        _CuttingGameON = True
        UD_Events.SendEvent_DeviceMinigameBegin(self,"Cutting")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"Cutting")
        _CuttingGameON = False
        setHelper(none)
        return true
    else
        return false
    endif
EndFunction

;/  Function: keyMinigameWH
    Starts unlock minigame with helper. This function include all checks and is safew to be called at all times.

    Parameters:

        akHelper    - Actor who will be used as helper

    Returns:

        True if unlock minigame with helper started and ended
/;
bool Function keyMinigameWH(Actor akHelper)
    setHelper(akHelper)
    
    if !minigamePrecheck()
        return false
    endif
    
    Int loc_SelectedLock = 0
    if PlayerIsPresent()
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
        if PlayerIsPresent()
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
    _customMinigameCritDuration = 0.9 - _getLockpickLevel(_MinigameSelectedLockID)*0.03
    _minMinigameStatSP = 0.6
    
    if minigamePostcheck()
        _KeyGameON = True
        UD_Events.SendEvent_DeviceMinigameBegin(self,"KeyUnlock")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"KeyUnlock")
        _KeyGameON = False
        setHelper(none)
        return true
    else
        return false
    endif
EndFunction

;/  Function: tightUpDevice
    Tighten up device

    Parameters:

        akSource    - Actor who will tighten the device
/;
Function tightUpDevice(Actor akSource)
    if WearerIsPlayer()
        UDmain.Print(GetActorName(akSource) + " tighted your " + getDeviceName() + " !",1)
    elseif HelperIsPlayer()
        UDmain.Print("You tighted " + getWearerName() + "s " + getDeviceName() + " !",1)
    elseif !PlayerIsPresent()
        UDmain.Print(GetActorName(akSource) + " tighted " + getWearerName() + "s " + getDeviceName() + " !",1)
    endif
    current_device_health += RandomFloat(5.0,15.0)
    if (current_device_health > UD_Health)
        current_device_health = UD_Health
        _updateCondition(False)
    endif
EndFunction

;/  Function: repairDevice
    Repair device. Doesn't include check. Should be only called if <canBeRepaired> passes

    Parameters:

        akSource    - Actor who will tighten the device
/;
Function repairDevice(Actor akSource)
    if WearerIsPlayer()
        UDmain.Print(GetActorName(akSource) + " repaired your " + getDeviceName() + " !",1)
    elseif HelperIsPlayer()
        UDmain.Print("You repaired " + getWearerName() + "s " + getDeviceName() + " !",1)
    elseif !PlayerInMinigame()
        UDmain.Print(GetActorName(akSource) + " repaired " + getWearerName() + "s " + getDeviceName() + " !",1)
    endif
    
    ;repair durability
    current_device_health += RandomFloat(45.0,75.0)
    if (current_device_health > UD_Health)
        current_device_health = UD_Health
    endif
    
    ;repair condition
    _total_durability_drain -= 75
    if _total_durability_drain < 0.0
        _total_durability_drain = 0.0
    endif

    _updateCondition(False)

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

;https://en.uesp.net/wiki/Skyrim:Leveling


;/  Function: advanceSkill
    Advance skill based on currently ongoing minigame. Will do nothing if wearer/helper is not player

    Parameters:

        afMult    - Skill gain multiplier
/;
Function advanceSkill(float afMult)
    if !PlayerIsPresent()
        return
    endif
    
    float loc_mult     = afMult
    
    if !WearerIsPlayer()
        loc_mult *= 0.75
    endif
    
    if _StruggleGameON
        int loc_type = 0
        if haveHelper()
            loc_type = _struggleGame_Subtype_NPC
        else
            loc_type = _struggleGame_Subtype
        endif
        if loc_type == 0
            Game.AdvanceSkill("Pickpocket" ,loc_mult*(0.5*UDCDmain.UD_BaseDeviceSkillIncrease/8.10)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
        elseif loc_type == 1 
            Game.AdvanceSkill("TwoHanded"  ,loc_mult*(1.0*UDCDmain.UD_BaseDeviceSkillIncrease/5.95)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
        elseif loc_type == 2
            Game.AdvanceSkill("Destruction",loc_mult*(1.0*UDCDmain.UD_BaseDeviceSkillIncrease/1.35)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
        endif
    elseif _RepairLocksMinigameON
        Game.AdvanceSkill("Smithing" , loc_mult*(0.75*UDCDmain.UD_BaseDeviceSkillIncrease/1.0)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
    elseif _CuttingGameON
        Game.AdvanceSkill("OneHanded", loc_mult*(1.0*UDCDmain.UD_BaseDeviceSkillIncrease/5.3)/UDCDmain.getSlotArousalSkillMultEx(UD_WearerSlot))
    endif
    OnAdvanceSkill(loc_mult)
EndFunction

;cut device by progress_add
Function _cutDevice(float progress_add = 1.0)
    _CuttingProgress += progress_add*UDCDmain.getStruggleDifficultyModifier()*UD_MinigameMult1
    if _CuttingProgress >= 100.0
        ;only show message fo NPC, as player can see progress progress on widget
        if _CuttingGameON
            if !PlayerInMinigame() && UDCDmain.AllowNPCMessage(getWearer(), True)
                UDmain.Print(getWearerName() + " managed to cut "+getDeviceName()+" and reduce durability by big amount!",3)
            endif
        else
            if !PlayerInMinigame() && UDCDmain.AllowNPCMessage(getWearer(), True)
                UDmain.Print(getWearerName() + "s "+ getDeviceName() +" is cutted!",3)
            endif
        endif

        float cond_dmg = 40.0*UDCDmain.getStruggleDifficultyModifier()*(1.0 + _condition_mult_add)
        _total_durability_drain += cond_dmg

        _updateCondition()
        decreaseDurabilityAndCheckUnlock(UD_DamageMult*cond_dmg/6.0,0.0)

        _CuttingProgress = 0.0
        if UDmain.TraceAllowed()
            UDmain.Log(getDeviceHeader() + " is cutted for " + cond_dmg + "C ( " + (UD_DamageMult*cond_dmg*getModResistPhysical(1.0,0.25)/7.0) + " D) (Wearer: " + getWearerName() + ")",1)
        endif
        OnDeviceCutted()
    endif
EndFunction

;repair lock by progress_add
Function _repairLock(float progress_add = 1.0)
    Float loc_RepairProgress = UpdateNthLockRepairProgress(_MinigameSelectedLockID,progress_add*UDCDmain.getStruggleDifficultyModifier())
    if loc_RepairProgress >= _getLockDurability()
        loc_RepairProgress = UpdateNthLockRepairProgress(_MinigameSelectedLockID,-1*_getLockDurability()) ;reset value
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
Function _lockpickDevice()
    if _LockpickGameON && (UD_CurrentLocks - UD_JammedLocks > 0)
        int loc_result = 0
        if PlayerInMinigame()
            PauseMinigame() ;pause minigame untill lockpick minigame starts
            int loc_helperGivedLockpicks = 0
            if haveHelper()
                ;always transfere lockpicks to player
                if WearerIsPlayer()
                    loc_helperGivedLockpicks = getHelper().getItemCount(UDCDmain.Lockpick)
                    getHelper().removeItem(UDCDmain.Lockpick,loc_helperGivedLockpicks,True,getWearer())
                else
                    loc_helperGivedLockpicks = getWearer().getItemCount(UDCDmain.Lockpick)
                    getWearer().removeItem(UDCDmain.Lockpick,loc_helperGivedLockpicks,True,getHelper())
                endif
            endif
            
            Int loc_difficulty = GetNthLockDifficulty(_MinigameSelectedLockID)
            UDCDmain.ReadyLockPickContainer(loc_difficulty,Wearer)
            UDCDmain.startLockpickMinigame()
            
            float loc_elapsedTime   = 0.0
            float loc_maxtime       = 0.0
            bool  loc_broken        = false
            if UDCDMain.UD_LockpickMinigameDuration > 0
                loc_maxtime = (UDCDMain.UD_LockpickMinigameDuration as Float) - fRange((loc_difficulty/100.0)*0.5,0.0,1.75)*UDCDMain.UD_LockpickMinigameDuration
                bool loc_msgshown = false
                while (!UDCDmain.LockpickMinigameOver) && loc_elapsedTime <= loc_maxtime && !loc_broken
                    Utility.WaitMenuMode(0.1)
                    if !UD_Native.GetLockpickVariable(9)
                        loc_elapsedTime += 0.1
                    endif
                    
                    if !loc_msgshown && loc_elapsedTime > loc_maxtime*0.75 ;only 25% time left, warn player
                        if RandomInt(0,1)
                            UDmain.Print("Your hands are sweating")
                        else
                            UDmain.Print("Your hands are starting to tremble")
                        endif
                        loc_msgshown = true
                    endif
                    
                    Int loc_destroyed = Round(UD_Native.GetLockpickVariable(8))
                    
                    if (loc_destroyed >= UDCDmain.UD_LockpicksPerMinigame)
                        loc_broken = true
                    endif
                endwhile
            endif
            
            loc_result = UDCDmain.lockpickMinigameResult     ;first we fetch lockpicking result
            UDCDmain.DeleteLockPickContainer()           ;then we remove the container so IsLocked is not called on None
            
            if UDCDMain.UD_LockpickMinigameDuration > 0
                if loc_elapsedTime >= loc_maxtime
                    if UDmain.IsLockpickingMenuOpen()
                        closeLockpickMenu()
                    endif
                    UDmain.Print("You lost focus and broke the lockpick!")
                    loc_result = 2
                    getWearer().removeItem(UDCDmain.Lockpick,1)
                elseif loc_broken
                    if UDmain.IsLockpickingMenuOpen()
                        closeLockpickMenu()
                    endif
                    UDmain.Print("You broke all the lockpicks you had in hand!")
                    loc_result = 2
                endif
            endif
            
            if haveHelper()
                if WearerIsPlayer()
                    int lockpicks = getWearer().getItemCount(UDCDmain.Lockpick)
                    if lockpicks >= loc_helperGivedLockpicks
                        getWearer().removeItem(UDCDmain.Lockpick,loc_helperGivedLockpicks,True,getHelper())
                    else
                        getWearer().removeItem(UDCDmain.Lockpick,lockpicks,True,getHelper())
                    endif
                else
                    int lockpicks = getHelper().getItemCount(UDCDmain.Lockpick)
                    if lockpicks >= loc_helperGivedLockpicks
                        getHelper().removeItem(UDCDmain.Lockpick,loc_helperGivedLockpicks,True,getWearer())
                    else
                        getHelper().removeItem(UDCDmain.Lockpick,lockpicks,True,getWearer())
                    endif
                endif
            endif
        else
            if RandomInt(1,99) >= _getLockpickLevel(_MinigameSelectedLockID)*15
                loc_result = 1
            else
                loc_result = 2
                Wearer.RemoveItem(UDCDmain.Lockpick, 1, True)
            endif
        endif
        if UDmain.TraceAllowed()
            UDmain.Log("Lockpick minigame result for " + getWearerName() + ": " + loc_result,2)
        endif
        if loc_result == 0
            stopMinigame()
            _LockpickGameON = False
        elseif loc_result == 1 ;succes
            Int loc_shields = GetNthLockShields(_MinigameSelectedLockID)
            if loc_shields > 0 ;lock have shields, needs to unlock them first
                loc_shields = DecreaseLockShield(_MinigameSelectedLockID,1)
                if loc_shields
                    if PlayerInMinigame()
                        UDmain.Print("You succesfully unlocked one of the locks shields! Shields: [" + loc_shields + "]",1)
                    elseif UDCDmain.AllowNPCMessage(Wearer, True)
                        UDmain.Print(getWearerName() + " unlocked one of the locks shields! Shields: [" + loc_shields + "]",2)
                    endif
                else
                    if PlayerInMinigame()
                        UDmain.Print("You succesfully unlocked all of the shields!",1)
                    elseif UDCDmain.AllowNPCMessage(Wearer, True)
                        UDmain.Print(getWearerName() + " unlocked all of the shields!",2)
                    endif
                endif
                UnPauseMinigame()
            else ;no more shields on device, unlock the lock
                UnlockNthLock(_MinigameSelectedLockID)
                if PlayerInMinigame()
                    UDmain.Print("You succesfully unlocked the "+UD_LockNameList[_MinigameSelectedLockID]+"!",1)
                elseif UDCDmain.AllowNPCMessage(Wearer, True)
                    UDmain.Print(getWearerName() + " unlocked the "+UD_LockNameList[_MinigameSelectedLockID]+" on device "+GetDeviceName()+"!",2)
                endif
                onLockUnlocked(True)
                
                ;select next lock
                if PlayerInMinigame() && !(UD_CurrentLocks == 0 && UD_JammedLocks == 0)
                    Int loc_SelectedLock = 0
                    Bool loc_cond = False
                    while !loc_cond
                        loc_cond = true
                        loc_SelectedLock = UserSelectLock()
                        if loc_SelectedLock < 0
                            loc_cond = true
                            stopMinigame() ;stop minigame, as player needs to select next lock manually
                        else
                            loc_cond = loc_cond && !IsNthLockUnlocked(loc_SelectedLock)
                            loc_cond = loc_cond && !IsNthLockJammed(loc_SelectedLock)
                            loc_cond = loc_cond && (!IsNthLockTimeLocked(loc_SelectedLock) || !GetNthLockTimeLock(loc_SelectedLock))
                            if loc_cond
                                _MinigameSelectedLockID = loc_SelectedLock
                                _customMinigameCritChance   = getLockAccesChance(_MinigameSelectedLockID, false)
                                _customMinigameCritDuration = 0.8 - _getLockpickLevel(_MinigameSelectedLockID)*0.03
                            endif
                        endif
                    endwhile
                    UnPauseMinigame()
                else
                    stopMinigame() ;stop minigame, as player needs to select next lock manually
                endif
            endif
            if UD_CurrentLocks == 0 && UD_JammedLocks == 0 ;device gets unlocked
                if PlayerInMinigame()
                    UDmain.Print("You succesfully unlocked the last lock and removed the "+GetDeviceName()+"!",1)
                elseif UDCDmain.AllowNPCMessage(Wearer, True)
                    UDmain.Print(getWearerName() + " unlocked last lock and removed the "+GetDeviceName()+"!",2)
                endif
                unlockRestrain()
                stopMinigame()
                _LockpickGameON = False
                OnDeviceLockpicked()
            elseif UD_CurrentLocks == UD_JammedLocks ;device have no more free locks
                stopMinigame()
                _LockpickGameON = False
                _SetJammStatus()
            endif
        elseif loc_result == 2 ;failure
            if RandomInt() <= zad_JammLockChance*UDCDmain.CalculateKeyModifier() && !libs.Config.DisableLockJam
                if PlayerInMinigame()
                    UDmain.Print("Your lockpick jammed the lock!",1)
                elseif UDCDmain.AllowNPCMessage(Wearer, True)
                    UDmain.Print(getWearerName() + "s "+getDeviceName()+" lock gets jammed!",3)
                endif
                
                JammNthLock(_MinigameSelectedLockID)
                _SetJammStatus()
                stopMinigame()
                _LockpickGameON = False
                OnLockJammed()
            else
                int loc_lockpicks = getWearer().GetItemCount(libs.Lockpick)
                if haveHelper()
                    loc_lockpicks += getHelper().GetItemCount(libs.Lockpick)
                endif
                if loc_lockpicks == 0
                    stopMinigame()
                    _LockpickGameON = False
                elseif PlayerInMinigame()
                    UnPauseMinigame()
                endif
            endif
        endif
    endif
EndFunction

;unlock one of the locks if lock is reached
Function _keyUnlockDevice()
    UnlockNthLock(_MinigameSelectedLockID)
    
    if PlayerInMinigame()
        UDmain.Print("You managed to unlock "+GetDeviceName()+"s "+GetNthLockName(_MinigameSelectedLockID)+"!",1)
    elseif UDCDmain.AllowNPCMessage(Wearer, True)
        UDmain.Print(getWearerName() + " managed to unlock "+GetDeviceName()+"s "+GetNthLockName(_MinigameSelectedLockID)+"!",2)
    endif
    
    if zad_DestroyKey
        if _minigameHelper && _minigameHelper.GetItemCount(zad_deviceKey)
            _minigameHelper.RemoveItem(zad_deviceKey,1) ;first remove helper key
        else
            Wearer.RemoveItem(zad_deviceKey,1) ;then remove wearer key
        endif
        stopMinigame()
    elseif UDCDMain.KeyIsGeneric(zad_deviceKey) && UDCDmain.UD_KeyDurability > 0
        Int loc_dur = 0
        
        Actor loc_KeySource = none
        
        ; first should be used key on NPC, then on player
        if (!WearerIsPlayer() && Wearer.GetItemCount(zad_deviceKey) > 0)
            loc_KeySource = GetWearer()
        elseif (_minigameHelper && !HelperIsPlayer() && _minigameHelper.GetItemCount(zad_deviceKey) > 0)
            loc_KeySource = GetHelper()
        elseif PlayerInMinigame() && UDmain.Player.GetItemCount(zad_deviceKey) > 0
            loc_KeySource = UDmain.Player
        else
            UDmain.Error(GetDeviceHeader()+"::_keyUnlockDeviceError() - Finding actor with key failed!")
            return
        endif
        
        loc_dur = UDCDMain.ReduceKeyDurability(loc_KeySource, zad_DeviceKey)
        
        if !loc_dur
            if PlayerInMinigame()
                UDmain.Print("Key "+ zad_DeviceKey.GetName() +" gets destroyed",1)
            elseif UDCDmain.AllowNPCMessage(Wearer, True)
                UDmain.Print(getWearerName() + "'s key "+ zad_DeviceKey.GetName() +" gets destroyed",1)
            endif
            stopMinigame()
        else
            if PlayerInMinigame()
                UDmain.Print("Remaining durability of key " + zad_DeviceKey.GetName() + " = [" + loc_dur+"]",2)
            endif
            
            ;select next lock
            if PlayerIsPresent() && !(UD_CurrentLocks == 0 && UD_JammedLocks == 0)
                Int loc_SelectedLock = 0
                Bool loc_cond = False
                while !loc_cond
                    loc_cond = true
                    loc_SelectedLock = UserSelectLock()
                    if loc_SelectedLock < 0
                        loc_cond = true
                        stopMinigame()
                    else
                        loc_cond = loc_cond && !IsNthLockUnlocked(loc_SelectedLock)
                        loc_cond = loc_cond && !IsNthLockJammed(loc_SelectedLock)
                        loc_cond = loc_cond && (!IsNthLockTimeLocked(loc_SelectedLock) || !GetNthLockTimeLock(loc_SelectedLock))
                        if loc_cond
                            _MinigameSelectedLockID = loc_SelectedLock
                            _customMinigameCritChance   = getLockAccesChance(_MinigameSelectedLockID, false)
                            _customMinigameCritDuration = 0.85 - _getLockpickLevel(_MinigameSelectedLockID)*0.025
                        endif
                    endif
                endwhile
            else
                stopMinigame()
            endif
        endif
    else
        stopMinigame()
    endif
    
    if UD_CurrentLocks == 0
        unlockRestrain()
        OnDeviceUnlockedWithKey()
    else
        onLockUnlocked(false)
    endif
EndFunction

;/  Function: addStruggleExhaustion
    Adds struggle exhaustion to wearer and helper
    
    Parameters:
    
        akHelper - minigame helper
/;
Function addStruggleExhaustion(Actor akHelper)
    if UD_applyExhastionEffect
        if UDmain.TraceAllowed()
            UDmain.Log("UD_CustomDevice_RenderScript::addStruggleExhaustion("+getDeviceHeader()+") called")
        endif
        UDCDmain.AddExhaustion(Wearer,_exhaustion_mult)
        if akHelper
            UDCDmain.AddExhaustion(akHelper,_exhaustion_mult_helper)
            UDCDmain.ResetHelperCD(akHelper,Wearer,UDCDmain.UD_MinigameHelpXPBase)
        endif
    endif
EndFunction

;/  Function: startSentientDialogue
    Shows random sentient dialogue by device

    Parameters:

        aiType    - unused
/;
Function startSentientDialogue(int aiType = 1)
    UDCDmain.sendSentientDialogueEvent(UD_DeviceType,aiType)
EndFunction

;/  Group: Minigame Creation
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: resetMinigameValues
    Resets all minigame variables to default value
/;
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
    UD_useWidgetSec             = false
    UD_WidgetAutoColorSec       = false
    UD_AllowWidgetUpdateSec     = false
EndFunction

;/  Function: setMinigameOffensiveVar
    Sets minigame offensive variables

    Parameters:

        abDmgDevice     - If device can be damaged
        abDpsAdd        - Durability damage added to base damage
        abCondMultAdd   - Condition multiplier added to base condition multiplier
        abCanCrit       - If device can be critted. Toggling this off disables crits from occuring
        abDmgMult       - Durability damage multiplier
/;
Function setMinigameOffensiveVar(bool abDmgDevice,float abDpsAdd = 0.0,float abCondMultAdd = 0.0, bool abCanCrit = false,float abDmgMult = 1.0)
    UD_damage_device            = abDmgDevice
    UD_durability_damage_add    = abDpsAdd
    _condition_mult_add         = abCondMultAdd
    UD_minigame_canCrit         = abCanCrit
    UD_DamageMult               = abDmgMult
EndFunction

;/  Function: setMinigameDefaultCritVar
    Sets minigame offensive variables

    Parameters:

        abDefaultCrit       - If device can be critted. Toggling this off disables crits from occuring. Same option as abCanCrit from <setMinigameOffensiveVar>
        abCritReg           - If landing crit should regen some of the wearer stats
        abCritRegHelper     - If landing crit should regen some of the helper stats
/;
Function setMinigameDefaultCritVar(bool abDefaultCrit = true,bool abCritReg = true,bool abCritRegHelper = true)
    UD_minigame_canCrit             = abDefaultCrit
    UD_minigame_critRegen           = abCritReg
    UD_minigame_critRegen_helper    = abCritRegHelper
EndFunction

;/  Function: setMinigameCustomCrit
    Sets minigame custom crit variables.
    
    *This should never be called before <setMinigameDefaultCritVar> and <setMinigameOffensiveVar> !*

    Parameters:

        aiCritChance        - Chance for crit to happen every second
        afCritDuration      - Duration of crit
        afCritMult          - Crit multiplier
/;
Function setMinigameCustomCrit(int aiCritChance,float afCritDuration = 0.75,float afCritMult = 1.0)
    UD_minigame_canCrit         = False
    _customMinigameCritChance   = aiCritChance
    _customMinigameCritDuration = afCritDuration
    _customMinigameCritMult     = afCritMult
EndFunction

;set minigame min stats 0.0-1.0

;/  Function: setMinigameMinStats
    Sets minigame minimum values
    
    Parameters:

        afSp    - Minimum stamina as relative value (0.0-1.0)
        afHp    - Minimum health as relative value (0.0-1.0)
        afMp    - Minimum magicka as relative value (0.0-1.0)
/;
Function setMinigameMinStats(float afSp,float afHp = 0.0,float afMp = 0.0)
    _minMinigameStatSP = afSp
    _minMinigameStatHP = afHp
    _minMinigameStatMP = afMp
EndFunction

;/  Function: setMinigameDmgMult
    Sets minigame damage multiplier. Does same thing as abDmgMult from <setMinigameOffensiveVar>
    
    Parameters:

        afVal    - Minigame damage multiplier
/;
Function setMinigameDmgMult(float afVal)
    UD_DamageMult = afVal
EndFunction

;/  Function: setMinigameMult
    Sets minigame Nth multiplier. Does same thing as abDmgMult from <setMinigameOffensiveVar>
    
    ---Code
        |==========================================|
        |  aiMultIndx   |      Multiplier          |
        |==========================================|
        |       0       |  Damage multiplier       |
        |       1       |  Custom multiplier 1     |
        |       2       |  Custom multiplier 2     |
        |       3       |  Custom multiplier 3     |
        |==========================================|
    ---
    
    Parameters:

        aiMultIndx  - Index of multiplier
        afMult      - New value
/;
Function setMinigameMult(int aiMultIndx,float afValue)
    if aiMultIndx == 0 
        UD_DamageMult = afValue
    elseif aiMultIndx == 1
        UD_MinigameMult1 = afValue
    elseif aiMultIndx == 2
        UD_MinigameMult2 = afValue
    elseif aiMultIndx == 3
        UD_MinigameMult3 = afValue
    endif    
EndFunction

;/  Function: setMinigameMult
    Gets minigame Nth multiplier
    
    ---Code
        |==========================================|
        |  aiMultIndx   |      Multiplier          |
        |==========================================|
        |       0       |  Damage multiplier       |
        |       1       |  Custom multiplier 1     |
        |       2       |  Custom multiplier 2     |
        |       3       |  Custom multiplier 3     |
        |==========================================|
    ---
    
    Parameters:

        aiMultIndx  - Index of multiplier
        
    Returns:
        
        Multiplier value
/;
float Function getMinigameMult(int aiMultIndx)
    if aiMultIndx == 0 
        return UD_DamageMult
    elseif aiMultIndx == 1
        return UD_MinigameMult1
    elseif aiMultIndx == 2
        return UD_MinigameMult2
    elseif aiMultIndx == 3
        return UD_MinigameMult3
    endif
EndFunction

;/  Function: setMinigameWearerVar
    Sets minigame wearer values
    
    New values should use UD_base_stat_drain as base
    
    Parameters:

        abDrainPlayer   - If player stats should be drain while in minigame
        afStaminaDrain  - stamina drain per second of minigame
        afHealthDrain   - health drain per second of minigame
        afMagickaDrain  - magicka drain per second of minigame
        
    Example:
    
    ---Code
        ;calculate new stamina drain as 75% of base device drain + 3.5% of wearer maximum stamina
        Float loc_staminaDrain = (UD_base_stat_drain*0.75 + getMaxActorValue(GetWearer(),"Stamina",0.035))
        
        ;sets the wearer values
        setMinigameWearerVar(True,loc_staminaDrain)
    ---
/;
Function setMinigameWearerVar(bool abDrainPlayer,float afStaminaDrain = 10.0,float afHealthDrain = 0.0,float afMagickaDrain = 0.0)
    UD_drain_stats              = abDrainPlayer
    UD_minigame_stamina_drain   = afStaminaDrain
    UD_minigame_heal_drain      = afHealthDrain
    UD_minigame_magicka_drain   = afMagickaDrain
EndFunction

;/  Function: setMinigameWearerVar
    Sets minigame helper values
    
    New values should use UD_base_stat_drain as base
    
    Parameters:

        abDrainHelper   - If helper stats should be drain while in minigame
        afStaminaDrain  - stamina drain per second of minigame
        afHealthDrain   - health drain per second of minigame
        afMagickaDrain  - magicka drain per second of minigame
        
    Example:
    
    ---Code
        ;calculate drain values
        Float loc_StaminaDrain = (UD_base_stat_drain*0.75 + getMaxActorValue(GetHelper(),"Stamina",0.035))
        Float loc_HeatlhDrain  = (UD_base_stat_drain*0.25)
        Float loc_MagickaDrain = (UD_base_stat_drain*1.25 + getMaxActorValue(GetHelper(),"Stamina",0.050))
        
        ;sets the wearer values
        setMinigameWearerVar(True,loc_StaminaDrain,loc_HeatlhDrain,loc_MagickaDrain)
    ---
/;
Function setMinigameHelperVar(bool abDrainHelper,float afStaminaDrain = 10.0,float afHealthDrain = 0.0,float afMagickaDrain = 0.0)
    UD_drain_stats_helper               = abDrainHelper
    UD_minigame_stamina_drain_helper    = afStaminaDrain
    UD_minigame_heal_drain_helper       = afHealthDrain
    UD_minigame_magicka_drain_helper    = afMagickaDrain
EndFunction

;/  Function: setMinigameEffectVar
    Sets minigame exhaustion effect values for wearer
    
    Parameters:

        abUnused1           - Unused
        abAllowExhaustion   - If minigame can apply exhaustion after minigame ends
        afExhaustionMult    - Exhaustion duration multiplier
/;
Function setMinigameEffectVar(bool abUnused1 = True,bool abAllowExhaustion = True,float afExhaustionMult = 1.0)
    UD_applyExhastionEffect = abAllowExhaustion
    _exhaustion_mult        = afExhaustionMult
EndFunction

;/  Function: setMinigameEffectHelperVar
    Sets minigame exhaustion effect values for helper
    
    Parameters:

        abUnused1           - Unused
        abAllowExhaustion   - If minigame can apply exhaustion after minigame ends
        afExhaustionMult    - Exhaustion duration multiplier
/;
Function setMinigameEffectHelperVar(bool abUnused1 = True,bool abAllowExhaustion = True,float afExhaustionMult = 1.0)
    UD_applyExhastionEffectHelper   = abAllowExhaustion
    _exhaustion_mult_helper         = afExhaustionMult
EndFunction

;set minigame widget variables

;/  Function: setMinigameWidgetVar
    Sets minigame widget appearance values
    
    Parameters:

        abUseWidget         - If widget should be used
        abWidgetAutoColor   - If widget color should be calculated based on condition. When enabled, color setting will be ignored
        abWidgetUpdate      - IF widget value should be updated on every minigame tick. In case this is turned off, the value can be changed only using <setWidgetVal>
        aiColor1            - Widget main color
        aiColor2            - Widget secondary value
        aiFlashColor        - Widget flash color
        asIconName          - Widget icon name
        
    Example:
    ---Code
        ;shows widget
        ;widget color will change based on condition
        ;widget value will not be updated. Value have to be changed with setWidgetVal
        ;Color is ignored as abWidgetAutoColor is True
        ;icon next to widget will be "icon-meter-cut"
        self.setMinigameWidgetVar(True, True, False, -1, -1, -1, "icon-meter-cut")
    ---
/;
Function setMinigameWidgetVar(Bool abUseWidget = False, Bool abWidgetAutoColor = True, Bool abWidgetUpdate = True, Int aiColor1 = -1, Int aiColor2 = -1, Int aiFlashColor = -1, String asIconName = "", int aiFormula = 0)
    UD_useWidget            = abUseWidget
    UD_WidgetAutoColor      = abWidgetAutoColor
    UD_AllowWidgetUpdate    = abWidgetUpdate
    _WidgetFormula        = aiFormula
    
    setMainWidgetAppearance(aiColor1, aiColor2, aiFlashColor, asIconName)
EndFunction

;/  Function: setSecWidgetVar
    Sets secundary minigame widget appearance values
    
    Parameters:

        abUseWidget         - If widget should be used
        abWidgetAutoColor   - If widget color should be calculated based on condition. When enabled, color setting will be ignored
        abWidgetUpdate      - IF widget value should be updated on every minigame tick. In case this is turned off, the value can be changed only using <setWidgetVal>
        aiColor1            - Widget main color
        aiColor2            - Widget secondary value
        aiFlashColor        - Widget flash color
        asIconName          - Widget icon name
        
    Example:
    ---Code
        ;shows widget
        ;widget color will change based on condition
        ;widget value will not be updated. Value have to be changed with setWidgetVal
        ;Color is ignored as abWidgetAutoColor is True
        ;icon next to widget will be "icon-meter-cut"
        self.setSecWidgetVar(True, True, False, -1, -1, -1, "icon-meter-cut")
    ---
/;
Function setSecWidgetVar(Bool abUseWidget = False, Bool abWidgetAutoColor = True, Bool abWidgetUpdate = True, Int aiColor1 = -1, Int aiColor2 = -1, Int aiFlashColor = -1, String asIconName = "", int aiFormula = 0)
    UD_useWidgetSec            = abUseWidget
    UD_WidgetAutoColorSec      = abWidgetAutoColor
    UD_AllowWidgetUpdateSec    = abWidgetUpdate
    _WidgetFormulaSec        = aiFormula
    setSecWidgetAppearance(aiColor1, aiColor2, aiFlashColor, asIconName)
EndFunction

Function _UnsetMinigameDevice()
    if PlayerInMinigame()
        UDCDmain.resetCurrentMinigameDevice()
    else
        StorageUtil.UnSetFormValue(Wearer, "UD_currentMinigameDevice")
        if _minigameHelper
            StorageUtil.UnSetFormValue(_minigameHelper, "UD_currentMinigameDevice")
        endif
    endif
EndFunction

;/  Function: getStruggleMinigameSubType
    Returns:
    
        ---Code
            -1 => no struggle minigame
             0 => normal
             1 => desperate
             2 => magick
             3 => slow
             5 => useless struggle
        ---
/;
int Function getStruggleMinigameSubType()
    return _struggleGame_Subtype
EndFunction

;/  Function: getStruggleMinigameSubType
    Stops minigame
    
    Setting argument abWaitForStop to true will block the functionu ntill minigame ends
/;
Function StopMinigame(Bool abWaitForStop = False)
    _UnsetMinigameDevice()
    _StopMinigame = True
    _PauseMinigame = False
    _EndMinigameEffect()
    while abWaitForStop && IsMinigameOn()
        Utility.waitMenuMode(0.01)
    endwhile
EndFunction

;/  Function: PauseMinigame
    Pauses minigame
    
    This stops main loop from processing (decreasing stats, crits, etc..)
    
    Minigame can be still stoped while in this state with StopMinigame()
/;
Function PauseMinigame()
    if _MinigameON
        SpecialButtonReleased(0.0)
        _ToggleMinigameEffect(false)
        _PauseMinigame = True
    endif
EndFunction

;/  Function: UnPauseMinigame
    UnPauses minigame
/;
Function UnPauseMinigame()
    if _MinigameON
        _ToggleMinigameEffect(true)
        _PauseMinigame = False
    endif
EndFunction

;/  Function: IsMinigameOn
    Return:
    
        True if device have minigame going on
/;
bool Function IsMinigameOn()
    return _MinigameON
EndFunction

;/  Function: IsMinigameLoopRunning
    Return:
    
        True if main minigame loop is running
/;
bool Function IsMinigameLoopRunning()
    return _MinigameMainLoopON
EndFunction

;/  Function: IsPaused
    Return:
    
        True if minigame is paused
/;
bool Function IsPaused()
    return _PauseMinigame
EndFunction

;/  Function: minigamePostcheck
    Check wearer and helper minimum stats

    Parameters:
    
        abSilent - If message should be shown if function fails
    
    Return:
    
        True both wearer and helper have required stats
/;
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
    elseif haveHelper() && !checkMinAV(_minigameHelper)
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

;/  Function: minigamePrecheck
    Check wearer and helper for following
    
    - Wearer/Helper is not in minigame
    - Device have not ongoing minigame
    - Wearer/Helper is not animating
    - Wearer/Helper is not dead/disabled/in scene

    Parameters:
    
        abSilent - If message should be shown if function fails
    
    Return:
    
        True if all conditions are met
/;
bool Function minigamePrecheck(Bool abSilent = False)
    If UDmain.TraceAllowed()
        UDmain.Log("minigamePrecheck called for " + getDeviceHeader() + " abSilent="+abSilent)
    endif

    if _MinigameON || UDCDmain.actorInMinigame(Wearer)
        if !abSilent
            UDmain.Warning("Can't start minigame for " + getDeviceHeader() + " because wearer is already in minigame!")
            if WearerIsPlayer()
                UDmain.Print("You are already doing something")
            elseif UDCDmain.AllowNPCMessage(Wearer)
                UDmain.Print(getWearerName() + " is already doing something")
            endif
        endif
        return false
    endif

    if (UDAM.isAnimating(Wearer))
        if !abSilent
            UDmain.Warning("Can't start minigame for " + getDeviceHeader() + " because wearer is already in animating!")
            if WearerIsPlayer()
                UDmain.Print("You are already doing something",1)
            elseif UDCDmain.AllowNPCMessage(Wearer)
                UDmain.Print(getWearerName() + " is already doing something",1)
            endif
        endif
        return false
    endif
    
    ;Allow minigames on unloaded actors
    if (Wearer.IsDead() || Wearer.IsDisabled() || Wearer.GetCurrentScene())
        if !abSilent
            GWarning("Can't start minigame for " + getDeviceHeader() + " because wearer is invalid! Dead="+Wearer.IsDead() + ",Disabled="+Wearer.IsDisabled()+",Scene+"+Wearer.GetCurrentScene())
            if WearerIsPlayer()
                UDmain.Print("You are already doing something",1)
            elseif UDCDmain.AllowNPCMessage(Wearer)
                UDmain.Print(getWearerName() + " is already doing something",1)
            endif
        endif
        return false
    endif
    
    if haveHelper()
        if (UDAM.isAnimating(_minigameHelper))
            if !abSilent
                GWarning("Can't start minigame for " + getDeviceHeader() + " because helper is already in minigame!")
                if HelperIsPlayer()
                    UDmain.Print("You are already doing something")
                elseif UDCDmain.AllowNPCMessage(_minigameHelper)
                    UDmain.Print(getHelperName() + " is already doing something",1)
                endif
            endif
            return false
        endif
        if UDCDmain.actorInMinigame(_minigameHelper)
            if !abSilent
                GWarning("Can't start minigame for " + getDeviceHeader() + " because helper is already in minigame!")
                if HelperIsPlayer()
                    UDmain.Print("You are already doing something")
                elseif UDCDmain.AllowNPCMessage(_minigameHelper)
                    UDmain.Print(getHelperName() + " is already doing something")
                endif
            endif
            return false
        endif
        
        if (!libs.IsValidActor(_minigameHelper))
            if !abSilent
                GWarning("Can't start minigame for " + getDeviceHeader() + " because helper is invalid!")
                GWarning("Is3DLoaded = " + _minigameHelper.Is3DLoaded())
                GWarning("IsDead = " + _minigameHelper.IsDead())
                GWarning("IsDisabled = " + _minigameHelper.IsDisabled())
                GWarning("GetCurrentScene = " + _minigameHelper.GetCurrentScene())
                if HelperIsPlayer()
                    UDmain.Print("You are already doing something",1)
                elseif UDCDmain.AllowNPCMessage(_minigameHelper)
                    UDmain.Print(getHelperName() + " is already doing something",1)
                endif
            endif
            return false
        endif
    endif
    
    if _ParalelProcessRunning()
        if !abSilent
            if WearerIsPlayer() || WearerIsFollower()
                UDmain.Print("Slow down!",1)
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


;/  Function: minigame
    Starts minigame on device. Should be only used if both <minigamePrecheck> and <minigamePostcheck> were OK
    
    This function will block thread for duration of minigame
/;
Function minigame()
    if current_device_health <= 0 ;device is already unlocked (somehow)
        UnlockRestrain()
        return
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
    
    if UDmain.DebugMod && loc_PlayerInMinigame
        showDebugMinigameInfo()
    endif
    
    if loc_PlayerInMinigame
        closeMenu()
    endif
    
    _StopMinigame = False
    
    Wearer.AddToFaction(UDCDmain.MinigameFaction)
    if _minigameHelper
        _minigameHelper.AddToFaction(UDCDmain.MinigameFaction)
    endif
    
    UD_Native.ForceUpdateControls()
    
    if UDmain.TraceAllowed()
        UDmain.Log("Minigame started for: " + getDeviceName())
    endif
    
    _MinigameMainLoopON = true
    
    float durability_onstart = current_device_health
    
    Bool loc_UseInterAVCheck = True
    if loc_WearerSlot && loc_PlayerInMinigame
        loc_UseInterAVCheck = False
    else
        loc_UseInterAVCheck = True
    endif
    
    _SendMinigameThreads(loc_is3DLoaded,true,true,!loc_UseInterAVCheck)
    
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
    
    ;main loop, ends only when character run out off stats or device losts all durability
    int         tick_b                 = 0
    int         tick_s                 = 0
    float       fCurrentUpdateTime     = UDmain.UD_baseUpdateTime

    if !loc_is3DLoaded
        fCurrentUpdateTime = 1.0
    elseif !loc_PlayerInMinigame
        fCurrentUpdateTime = 0.25
    else
        fCurrentUpdateTime = 0.1 ;only for player
    endif

    _PauseMinigame = False
    
    float     loc_dmgnotimemult    = (_durability_damage_mod + UD_durability_damage_add)
    float     loc_dmg              = loc_dmgnotimemult*fCurrentUpdateTime*UD_DamageMult
    float     loc_condmult         = 1.0 + _condition_mult_add
    bool      loc_showwidget       = loc_PlayerInMinigame && UDCDmain.UD_UseWidget && (UD_UseWidget || UD_UseWidgetSec)
    bool      loc_updatewidget     = loc_showwidget && (UD_AllowWidgetUpdate || UD_AllowWidgetUpdateSec)
    bool      loc_updatewidgetcolor= loc_showwidget && (UD_WidgetAutoColor   || UD_WidgetAutoColorSec)
    Float     loc_ElapsedTime      = 0.0
    Bool      loc_DamageDevice     = UD_damage_device
    Bool      loc_MinigameEffectEnabled = False
    
    bool      loc_useNativeMeter   = PlayerInMinigame()
    bool      loc_useIWW           = UDmain.UseiWW()
    float     loc_health           = UD_Health
    
    ;register native meters
    if loc_useNativeMeter
        if loc_DamageDevice
            if UD_UseWidget
                UDmain.UDWC.Meter_RegisterNative("device-main",_WidgetFormula,getRelativeDurability()*100.0,-1.0*loc_dmgnotimemult,true)
                UDmain.UDWC.Meter_SetNativeMult("device-main",UD_DamageMult*100.0/loc_health)
            endif
            if loc_condmult != 0.0 && UD_UseWidgetSec
                UDmain.UDWC.Meter_RegisterNative("device-condition",_WidgetFormulaSec,getRelativeCondition()*100.0,-1.0*loc_dmgnotimemult,true)
                UDmain.UDWC.Meter_SetNativeMult("device-condition",loc_condmult*100.0/loc_health)
            endif
        endif
    endif
    
    if loc_showwidget
        showWidget()
    endif
    
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
                if !UDCDMain.UD_InitialDrainDelay || (loc_ElapsedTime > UDCDMain.UD_InitialDrainDelay)
                    if !loc_MinigameEffectEnabled
                        loc_MinigameEffectEnabled = true
                        _ToggleMinigameEffect(true)
                    endif
                    if !ProccesAV(fCurrentUpdateTime)
                        StopMinigame()
                    endif
                    if haveHelper()
                        if !ProccesAVHelper(fCurrentUpdateTime)
                            StopMinigame()
                        endif
                    endif
                endif
            endif
        endif
        
        if !_StopMinigame
            OnMinigameTick(fCurrentUpdateTime)
            ;reduce device durability
            if loc_DamageDevice
                if loc_useNativeMeter
                    ;native meter used. Calculation is done in skse plugin, so just fetch the value and recalculate it
                    
                    current_device_health = UDmain.UDWC.Meter_GetNativeValue("device-main")*loc_health/100.0
                    if loc_condmult != 0.0 && UD_UseWidgetSec
                        _total_durability_drain = (1.0 - UDmain.UDWC.Meter_GetNativeValue("device-condition")/100.0)*loc_health
                        _updateCondition()
                    endif
                    _CheckUnlock()
                else
                    decreaseDurabilityAndCheckUnlock(loc_dmg,loc_condmult)
                endif
            endif
            ;update widget
            if loc_updatewidget
                updateWidget()
            endif
            if loc_updatewidgetcolor
                updateWidgetColor()
            endif
        endif
        
        ;--one second timer--
        if (tick_b*fCurrentUpdateTime >= 1.0) && !_StopMinigame && !_PauseMinigame && current_device_health > 0.0 ;once per second
            ;update loc vars
            loc_dmg              = (_durability_damage_mod + UD_durability_damage_add)*fCurrentUpdateTime*UD_DamageMult
            loc_condmult         = 1.0 + _condition_mult_add
            loc_DamageDevice     = UD_damage_device
            
            if loc_PlayerInMinigame
                loc_updatewidget     = UDCDmain.UD_UseWidget && (UD_UseWidget || UD_UseWidgetSec) && UD_AllowWidgetUpdate
            endif
            
            ;check non struggle minigames
            if !loc_PlayerInMinigame
                if _CuttingGameON
                    _cutDevice(fCurrentUpdateTime*UD_CutChance/5.0)
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
                    if UDAM.UD_AlternateAnimation && !UDmain.ImprovedCameraInstalled && !(tick_s % UDAM.UD_AlternateAnimationPeriod) && tick_s
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
            loc_ElapsedTime += fCurrentUpdateTime
        endif
    endwhile

    _EndMinigameEffect()

    _MinigameMainLoopON = false
    
    ;remove registered meters
    if loc_useNativeMeter
        UDmain.UDWC.Meter_UnregisterNative("device-main")
        UDmain.UDWC.Meter_UnregisterNative("device-condition")
    endif
    
    if loc_PlayerInMinigame
        UDCDmain.MinigameKeysUnRegister()
        UD_Native.UnregisterDeviceCallbacks(_VMHandle1,_VMHandle2,DeviceRendered)
        ;close lockpick menu if lockpick minigame was for some reason stopped
        if _LockpickGameON && UDmain.IsLockpickingMenuOpen()
            closeLockpickMenu()
        endif
    endif
    
    if loc_StartedAnimation
        _StopMinigameAnimation()
    endif
    
    ;checks if Wearer succesfully escaped device
    if IsUnlocked
        if loc_WearerIsPlayer
            UDmain.Print("You have succesfully escaped out of " + getDeviceName() + "!",2)
        elseif UDCDmain.AllowNPCMessage(Wearer, true)
            UDmain.Print(getWearerName()+" succesfully escaped out of " + getDeviceName() + "!",2)
        endif
        if !loc_WearerIsPlayer
            UpdateMotivation(Wearer,50) ;increase NPC motivation on successful escape
        endif
        advanceSkill(15.0)
        if UDmain.ExperienceInstalled && PlayerIsPresent()
            Int loc_xp = Round(Math.Pow(UD_Level,0.8)*RandomFloat(1.0,2.0))
            Experience.addexperience(loc_xp,true)
            UDmain.Info("By escaping the "+GetDeviceHeader()+", you got " + loc_xp + " experience")
        endif
    endif

    ;remove disalbe from helper (can be done earlier as no devices were changed)
    if _minigameHelper && !UDOM.GetOrgasmInMinigame(_minigameHelper)
        UDCDMain.EndMinigameDisable(_minigameHelper, loc_HelperIsPlayer as Int)
    endif

    ;Wait for device to get fully removed
    Int loc_removetimer = 100
    while IsUnlocked && !_isRemoved && loc_removetimer > 0
        loc_removetimer -= 1
        Utility.waitMenuMode(0.1)
    endwhile
    if loc_removetimer <= 0
        UDMain.Error("No remove device event received. Skipping...")
    endif
    
    ;remove disable from wearer
    If !UDOM.GetOrgasmInMinigame(Wearer)
        UDCDMain.EndMinigameDisable(Wearer,loc_WearerIsPlayer as Int)
    EndIf

    if UDmain.TraceAllowed()
        UDmain.Log(getDeviceHeader() + "::minigame() - Minigame ended after " + loc_ElapsedTime + " s", 1)
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
        UDmain.Error(getDeviceHeader() + "::minigame() - Minigame paralel thread timeout! _deviceControlBitMap_1 = " + IntToBit(_deviceControlBitMap_1))
    endif
    
    _MinigameVarReset()
    
    OnMinigameEnd()
    
    if !IsUnlocked
        if loc_is3DLoaded
            libs.pant(Wearer)
        endif
        if loc_PlayerInMinigame
            if _minigameHelper
                UDmain.Print("One of you is too exhausted to continue struggling",1)
            else
                UDmain.Print("You are too exhausted to continue struggling",1)
            endif
        elseif UDCDmain.AllowNPCMessage(GetWearer(), true)
            UDmain.Print(getWearerName()+" is too exhausted to continue struggling",1)
        endif
        if loc_ElapsedTime >= 2.0
            if !loc_WearerIsPlayer
                UpdateMotivation(Wearer,-5) ;decrease NPC motivation on failed escape
            endif
        endif
    endif
    
    GoToState("")
    
    if loc_Profiling
        Debug.StopStackProfiling()
    endif
    
    ;debug message
    if UDmain.DebugMod && UD_damage_device && durability_onstart != current_device_health && loc_WearerIsPlayer
        UDmain.Print("[Debug] Durability reduced: "+ FormatFloat(durability_onstart - current_device_health,3) + "\n",1)
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

Function _CheckAndUpdateAnimationCache(Bool bClearCache = False)
    ; since GetActorConstraintsInt is time-heavy saving its result here for this call
    If _minigameHelper
        _ActorsConstraints = New Int[2]
        _ActorsConstraints[0] = UDAM.GetActorConstraintsInt(Wearer, abUseCache = False)
        _ActorsConstraints[1] = UDAM.GetActorConstraintsInt(_minigameHelper, abUseCache = False)
    Else
        _ActorsConstraints = New Int[1]
        _ActorsConstraints[0] = UDAM.GetActorConstraintsInt(Wearer, abUseCache = False)
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

;/
    See https://github.com/iiw2012/UnforgivingDevices/wiki#animation-selection-algorithm
/;
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
        ;add struggle keyword for animations if its not loaded
        if !UD_DeviceStruggleKeywords
            UD_DeviceStruggleKeywords = UDCDMain.GetDeviceStruggleKeywords(DeviceRendered)
        endif
        keywordsList = UD_DeviceStruggleKeywords
    EndIf
    
    If _minigameHelper
        _StruggleAnimationDefPairArray = UDAM.GetStruggleAnimDefsByKeywordsList(keywordsList, Wearer, _minigameHelper)
        If _StruggleAnimationDefPairArray.Length == 0
            ; if actor has heavy bondage then try to get paired animation for it
            Keyword heavyBondage = UDAM.GetHeavyBondageKeyword(_ActorsConstraints[0])
            If heavyBondage != None
                _StruggleAnimationDefPairArray = UDAM.GetStruggleAnimDefsByKeyword("." + heavyBondage.GetString(), Wearer, _minigameHelper)
            EndIf            
        EndIf
        If _StruggleAnimationDefPairArray.Length > 0
        ; using paired animation
            Int anim_index = RandomInt(0, _StruggleAnimationDefPairArray.Length - 1)
            If !bContinueAnimation || anim_index != _StruggleAnimationDefPairLastIndex
            ; start new animation
                _StruggleAnimationDefPairLastIndex = anim_index
                _animationDef = _StruggleAnimationDefPairArray[anim_index]
                If UDAM.PlayAnimationByDef(_animationDef, _ActorArray2(Wearer, _minigameHelper), bContinueAnimation, abDisableActors = False)
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
            _StruggleAnimationDefActorArray = _GetSoloStruggleAnimation(keywordsList, Wearer, _ActorsConstraints[0])
            String[] helperKeywordsList = New String[1]
            helperKeywordsList[0] = ".spectator"
            _StruggleAnimationDefHelperArray = _GetSoloStruggleAnimation(helperKeywordsList, _minigameHelper, _ActorsConstraints[1])
            
            UDAM.SetActorHeading(Wearer, _minigameHelper)
            UDAM.SetActorHeading(_minigameHelper, Wearer)
            
            If _StruggleAnimationDefActorArray.Length > 0
                Int anim_index = RandomInt(0, _StruggleAnimationDefActorArray.Length - 1)
                If !bContinueAnimation || anim_index != _StruggleAnimationDefActorLastIndex
                    ; start new animation
                    _StruggleAnimationDefActorLastIndex = anim_index
                    _animationDef = _StruggleAnimationDefActorArray[anim_index]
                    If UDAM.PlayAnimationByDef(_animationDef, _ActorArray1(Wearer), bContinueAnimation, abDisableActors = False)
                        result[0] = _StruggleAnimationDefActorArray.Length
                    EndIf
                Else
                    ; keep animation that is currently played
                    result[0] = _StruggleAnimationDefActorArray.Length
                EndIf
            EndIf

            If _StruggleAnimationDefHelperArray.Length > 0
                Int anim_index = RandomInt(0, _StruggleAnimationDefHelperArray.Length - 1)
                If !bContinueAnimation || anim_index != _StruggleAnimationDefHelperLastIndex
                    ; start new animation
                    _StruggleAnimationDefHelperLastIndex = anim_index
                    _animationDef = _StruggleAnimationDefHelperArray[anim_index]
                    If UDAM.PlayAnimationByDef(_animationDef, _ActorArray1(_minigameHelper), bContinueAnimation, abDisableActors = False)
                        result[1] = _StruggleAnimationDefHelperArray.Length
                    EndIf
                Else
                    ; keep animation that is currently played
                    result[1] = _StruggleAnimationDefHelperArray.Length
                EndIf
            EndIf
        EndIf
    Else
        _StruggleAnimationDefActorArray = _GetSoloStruggleAnimation(keywordsList, Wearer, _ActorsConstraints[0])
        If _StruggleAnimationDefActorArray.Length > 0
            _animationDef = _StruggleAnimationDefActorArray[RandomInt(0, _StruggleAnimationDefActorArray.Length - 1)]
            If UDAM.PlayAnimationByDef(_animationDef, _ActorArray1(Wearer), bContinueAnimation, abDisableActors = False)
                result[0] = _StruggleAnimationDefActorArray.Length
            EndIf
        EndIf
    EndIf
    Return result
EndFunction

;/
    See https://github.com/iiw2012/UnforgivingDevices/wiki#animation-selection-algorithm
/;
String[] Function _GetSoloStruggleAnimation(String[] asKeywords, Actor akActor, Int aiConstraints)
    String[] result
    result = UDAM.GetStruggleAnimDefsByKeywordsList(asKeywords, akActor, None)
    If result.Length == 0
        ; if actor has heavy bondage then try to get solo animation for it
        Keyword heavyBondage = UDAM.GetHeavyBondageKeyword(aiConstraints)
        If heavyBondage != None
            result = UDAM.GetStruggleAnimDefsByKeyword("." + heavyBondage.GetString(), akActor, None)
        EndIf
    EndIf
    If result.Length == 0
        result = UDAM.GetStruggleAnimDefsByKeyword(".zad_DeviousGloves", akActor, None)
    EndIf
    If result.Length == 0
        ; horny animation is our last hope!
        result = UDAM.GetStruggleAnimDefsByKeyword(".horny", akActor, None)
    EndIf
    Return result
EndFunction

Actor[] Function _ActorArray1(Actor actor1)
    Actor[] arr = new Actor[1]
    arr[0] = actor1
    Return arr
EndFunction

Actor[] Function _ActorArray2(Actor actor1, Actor actor2)
    Actor[] arr = new Actor[2]
    arr[0] = actor1
    arr[1] = actor2
    Return arr
EndFunction

Int[] Function _IntArray1(Int i1)
    Int[] arr = new Int[1]
    arr[0] = i1
    Return arr
EndFunction

Function _MinigameVarReset()
    if Wearer
        Wearer.RemoveFromFaction(UDCDmain.MinigameFaction)
    endif
    
    if _minigameHelper
        _minigameHelper.RemoveFromFaction(UDCDmain.MinigameFaction)
    endif
    
    UD_Native.ForceUpdateControls()
    
    _UnsetMinigameDevice()
    
    _MinigameON = False
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
        if !libs.Config.DisableLockJam && UDCDMain.KeyIsGeneric(zad_deviceKey) && (RandomInt() <= zad_KeyBreakChance*UDCDmain.CalculateKeyModifier())
            if PlayerInMinigame()
                debug.messagebox("You managed to insert the key but it snapped. Its remains also jammed the lock! You will have to find other way to escape.")
            endif
            
            Wearer.RemoveItem(zad_deviceKey)
            
            JammNthLock(_MinigameSelectedLockID)
            ;UD_JammedLocks += 1
            
            _SetJammStatus()
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
            float loc_critdmg
            if getStruggleMinigameSubType() == 2 
                loc_critdmg = UD_StruggleCritMul*(_durability_damage_mod + UD_durability_damage_add)*getModResistMagicka(1.0,0.25)*UD_DamageMult
            else
                loc_critdmg = UD_StruggleCritMul*(_durability_damage_mod + UD_durability_damage_add)*getModResistPhysical(1.0,0.25)*UD_DamageMult
            endif
            decreaseDurabilityAndCheckUnlock(loc_critdmg)
        elseif _LockpickGameON
            _lockpickDevice()
        elseif _KeyGameON
            _keyUnlockDevice()
        elseif _CuttingGameON
            _cutDevice(UD_StruggleCritMul*UD_CutChance/3.0)
        elseif _RepairLocksMinigameON
            _repairLock(15.0*UD_MinigameMult1)
        endif
        
        OnCritDevicePost()
        Bool loc_playerInMinigame = PlayerInMinigame()
        if Wearer && (loc_playerInMinigame || Wearer.Is3DLoaded())
            if loc_playerInMinigame && UDCDmain.UD_UseWidget && (UD_UseWidget || UD_UseWidgetSec)
                updateWidget()
            endif
            if loc_playerInMinigame || UDmain.ActorInCloseRange(wearer)
                libs.Pant(Wearer)
            endif
        endif
        
        advanceSkill(5.0)
    endif
EndFunction

;function called when player press special button
Function SpecialButtonPressed(float afMult = 1.0)
    if !IsPaused() && !IsUnlocked
        if _KeyGameON || _LockpickGameON || _RepairLocksMinigameON
            if (WearerHaveTelekinesis() || HelperHaveTelekinesis()) && !_usingTelekinesis
                _usingTelekinesis = true
                
                UD_Native.MinigameEffectUpdateMagicka(UDmain.Player,0.5*UD_base_stat_drain + UDmain.Player.getBaseAV("Magicka")*0.02)
                
                UD_minigame_magicka_drain = 0.5*UD_base_stat_drain + Wearer.getBaseAV("Magicka")*0.02
                if haveHelper()
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
                    _customMinigameCritChance += _GetTelekinesisLockModifier()
                endif
            endif
        endif

        onSpecialButtonPressed(afMult)
        
        if UDCDmain.UD_useWidget && (UD_UseWidget || UD_UseWidgetSec)
            updateWidget()
        endif
    endif
EndFunction

;function called when player release special button
Function SpecialButtonReleased(float afHoldTime)
    if !IsPaused() && !IsUnlocked
        if _KeyGameON || _LockpickGameON || _RepairLocksMinigameON
            if _usingTelekinesis
                _usingTelekinesis = false
                UD_minigame_magicka_drain = 0
                UD_minigame_magicka_drain_helper = 0
                
                UD_Native.MinigameEffectSetMagicka(UDmain.Player,0.0)
                
                if _RepairLocksMinigameON
                    if WearerHaveTelekinesis()
                        UD_MinigameMult1 -= 0.25
                    endif
                    if HelperHaveTelekinesis()
                        UD_MinigameMult1 -= 0.25
                    endif
                else
                    _customMinigameCritChance -= _GetTelekinesisLockModifier()
                endif
            endif
        endif
        onSpecialButtonReleased(afHoldTime)
    endif
EndFunction

;function called when wearer orgasms, 
; sexlab - True if orgasms is created by sexlab, False if created by DD
Function orgasm(bool abSexlab = false)
    if OnOrgasmPre(abSexlab)
        if _MinigameON
            OnMinigameOrgasm(abSexlab)
            OnMinigameOrgasmPost()
        endif
        OnOrgasmPost(abSexlab)
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

;biggest pain in the ass. 
Function showHUDbars(bool abFlashCall = True)
    bool actorOK    = PlayerIsPresent()
    bool stamina    = actorOK && (UD_minigame_stamina_drain == 0.0 && UD_minigame_stamina_drain_helper  == 0.0)
    bool health     = actorOK && (UD_minigame_heal_drain    == 0.0 && UD_minigame_heal_drain_helper     == 0.0)
    bool magicka    = actorOK && (UD_minigame_magicka_drain == 0.0 && UD_minigame_magicka_drain_helper  == 0.0)
    UDCDmain.sendHUDUpdateEvent(abFlashCall,stamina,health,magicka)
EndFunction

;does shit
Function hideHUDbars()
EndFunction

;checks if Wearer clear enough of exhaustion to start struggling
bool Function checkMaxExhaustion(Actor akActor)
    return !(UDOM.isOrgasmExhaustedMax(akActor) || UDCDMain.isMinigameExhaustedMax(akActor))
endFunction

;checks if Wearer have stats to start struggling
bool Function checkMinAV(Actor akActor)
    if !checkMaxExhaustion(akActor)
        if PlayerIsPresent()
            UDmain.Warning("checkMinAV("+GetActorName(akActor)+") - Actor cant struggle because of exhaustions")
        endif
        return False
    endif
    Float loc_staminamin  = _minMinigameStatSP
    Float loc_healthmin   = _minMinigameStatHP
    Float loc_magickahmin = _minMinigameStatMP
    if loc_staminamin > 0.0
        if (getCurrentActorValuePerc(akActor,"Stamina") < loc_staminamin)
            if PlayerIsPresent()
                UDmain.Warning("checkMinAV("+GetActorName(akActor)+") - Actor cant struggle because they have no stamina. Min="+loc_staminamin)
            endif
            return False
        endif
    endif
    if loc_healthmin > 0.0
        if (getCurrentActorValuePerc(akActor,"Health") < loc_healthmin)
            if PlayerIsPresent()
                UDmain.Warning("checkMinAV("+GetActorName(akActor)+") - Actor cant struggle because they have no health. Min="+loc_healthmin)
            endif
            return False
        endif
    endif
    if loc_magickahmin > 0.0
        if (getCurrentActorValuePerc(akActor,"magicka") < loc_magickahmin)
            if PlayerIsPresent()
                UDmain.Warning("checkMinAV("+GetActorName(akActor)+") - Actor cant struggle because they have no magicka. Min="+loc_magickahmin)
            endif
            return False
        endif
    endif
    return True
endFunction

bool Function ProccesAV(float fUpdateTime)
    if UD_drain_stats
        Float loc_staminadrain = UD_minigame_stamina_drain * UDCDMain.UD_MinigameDrainMult
        Float loc_healthdrain = UD_minigame_heal_drain * UDCDMain.UD_MinigameDrainMult
        Float loc_magickahdrain = UD_minigame_magicka_drain * UDCDMain.UD_MinigameDrainMult
        bool  loc_isplayer = WearerIsPlayer()
        if loc_isplayer
            if !UD_Native.MinigameStatsCheck(Wearer,loc_staminadrain > 0.0, loc_healthdrain  > 0.0, loc_magickahdrain  > 0.0)
                stopMinigame()
                return false
            endif
        else
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
    endif
    return true
EndFunction

bool Function ProccesAVHelper(float fUpdateTime)
    if UD_drain_stats_helper && _minigameHelper
        Float loc_staminadrain  = UD_minigame_stamina_drain_helper * UDCDMain.UD_MinigameDrainMult
        Float loc_healthdrain   = UD_minigame_heal_drain_helper * UDCDMain.UD_MinigameDrainMult
        Float loc_magickahdrain = UD_minigame_magicka_drain_helper * UDCDMain.UD_MinigameDrainMult
        bool  loc_isplayer      = HelperIsPlayer()
        if loc_isplayer
            if !UD_Native.MinigameStatsCheck(_minigameHelper,loc_staminadrain  > 0.0, loc_healthdrain  > 0.0, loc_magickahdrain  > 0.0)
                stopMinigame()
                return false
            endif
        else
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
    endif
    return true
EndFunction

Function _StartMinigameEffect()
    if WearerIsPlayer()
        Float loc_staminadrain  = UD_minigame_stamina_drain
        Float loc_healthdrain   = UD_minigame_heal_drain
        Float loc_magickahdrain = UD_minigame_magicka_drain
        UD_Native.StartMinigameEffect(Wearer,UDCDMain.UD_MinigameDrainMult,loc_staminadrain, loc_healthdrain, loc_magickahdrain,false)
    elseif HelperIsPlayer()
        Float loc_staminadrain  = UD_minigame_stamina_drain_helper
        Float loc_healthdrain   = UD_minigame_heal_drain_helper
        Float loc_magickahdrain = UD_minigame_magicka_drain_helper
        UD_Native.StartMinigameEffect(_minigameHelper,UDCDMain.UD_MinigameDrainMult,loc_staminadrain, loc_healthdrain, loc_magickahdrain,false)
    endif
EndFunction

Function _EndMinigameEffect()
    if PlayerInMinigame()
        UD_Native.EndMinigameEffect(UDmain.Player)
    endif
EndFunction

Function _ToggleMinigameEffect(Bool abToggle)
    if PlayerInMinigame()
        UD_Native.ToggleMinigameEffect(UDmain.Player,abToggle)
    endif
EndFunction


;/  Group: Details
===========================================================================================
===========================================================================================
===========================================================================================
/;

String Function _GetDeviceMainMenuText()
    String loc_res = ""
    loc_res += UDMTF.Header(getDeviceName(), 4)
    loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
;    loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
    
    loc_res += UDMTF.TextDecoration(UD_DeviceType + " (level " + UD_Level + ")", asAlign = "center")
    loc_res += UDMTF.LineBreak()
    loc_res += UDMTF.TextDecoration("Item has a " + getHealthString() + " health and in a " + getConditionString() + " condition.", asAlign = "center")
    loc_res += UDMTF.LineBreak()
    loc_res += UDMTF.TextDecoration("This device is " + getAccesibilityString() + " to reach, and it is " + getBaseDamageString() + " to get rid of.", asAlign = "center")
    loc_res += UDMTF.LineBreak()
    loc_res += UDMTF.TextDecoration("It has " + GetLockNumber() + " lock(s) (" + _GetLocksIcons() + ").", asAlign = "center")
    loc_res += UDMTF.LineBreak()
    loc_res += UDMTF.TextDecoration("You perceive that device is " + getResistanceString(UD_WeaponHitResist) + " to cuts.", asAlign = "center")
    loc_res += UDMTF.LineBreak()
    
    loc_res += UDMTF.FontEnd()
    
    Return loc_res
EndFunction

String Function _GetDeviceStruggleMenuText()
    String loc_res = ""
    loc_res += UDMTF.Header(getDeviceName(), 4)
    loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
;    loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
    
    loc_res += UDMTF.TextDecoration("You feel that device is " + getResistanceString(getModResistPhysical(0.0) * -100.0) + " to brute force.", asAlign = "center")
    loc_res += UDMTF.LineBreak()
    loc_res += UDMTF.TextDecoration("You sense that device is " + getResistanceString(getModResistMagicka(0.0) * -100.0) + " to magic.", asAlign = "center")
    loc_res += UDMTF.LineBreak()
    
    loc_res += UDMTF.FontEnd()
    
    Return loc_res
EndFunction

String Function _GetLocksIcons()
    String loc_frag = ""
    Int loc_i = 0
    loc_frag += UDMTF.FontBegin(asFontFace = "$EverywhereBoldFont")
    While loc_i < GetLockNumber()
        loc_frag += UDMTF.DeviceLockIcon(IsNthLockUnlocked(loc_i), IsNthLockJammed(loc_i), IsNthLockTimeLocked(loc_i) && GetNthLockTimeLock(loc_i))
        loc_frag += UDMTF.InlineIfString(loc_i  < GetLockNumber() - 1, " ")
        loc_i += 1
    EndWhile
    loc_frag += UDMTF.FontEnd()
    Return loc_frag
EndFunction

;/  Function: minigamePrecheck
    Shows message box with base information about device
/;
Function ShowBaseDetails()
    updateDifficulty()
    Float loc_accesibility = getAccesibility()
    String loc_res = ""
    String loc_frag
    Int loc_i
    
;    UDMTF.GoToState("")

    loc_res += UDMTF.Header(getDeviceName(), 4)
    loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
    loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
    loc_res += UDMTF.HeaderSplit()

    loc_res += UDMTF.TableRowDetails("Level:", UD_Level)
    loc_res += UDMTF.TableRowDetails("Type:", UD_DeviceType)
    
    loc_res += UDMTF.LineGap()
        
    loc_res += UDMTF.TableRowDetails("Device health:", FormatFloat(current_device_health, 1) + "/" + FormatFloat(UD_Health, 1), UDMTF.PercentToGrayscale(Round(100 * getRelativeDurability())))
    loc_res += UDMTF.TableRowDetails("Condition:", getConditionString() + " (" + FormatFloat(getRelativeCondition() * 100, 1) + "%)", UDMTF.PercentToGrayscale(Round(100 * getRelativeCondition())))
    loc_res += UDMTF.TableRowDetails("Accessibility:", getAccesibilityString())
    loc_res += UDMTF.TableRowDetails("Difficulty:", getBaseDamageString())

    loc_res += UDMTF.PageSplit(abForce = False)
    loc_res += UDMTF.LineGap()
        
    If canBeStruggled(loc_accesibility)
        loc_res += UDMTF.TableRowDetails("Phys. Resist:", Round(getModResistPhysical(0.0) * -100.0) + "%", UDMTF.PercentToRainbow(Round(50.0 + getModResistPhysical(0.0) * 50.0)))
        loc_res += UDMTF.TableRowDetails("Mag. Resist:", Round(getModResistMagicka(0.0) * -100.0) + "%", UDMTF.PercentToRainbow(Round(50.0 + getModResistMagicka(0.0) * 50.0)))
    Else
        loc_res += UDMTF.TableRowDetails("Phys. Resist:", "Inescapable", UDMTF.PercentToRainbow(0))
        loc_res += UDMTF.TableRowDetails("Mag. Resist:", "Inescapable", UDMTF.PercentToRainbow(0))
    EndIf
    If canBeCutted()
        loc_res += UDMTF.TableRowDetails("Cut Resist:", Round(UD_WeaponHitResist) + "%", UDMTF.PercentToRainbow(Round(100 - UD_WeaponHitResist)))
    Else
        loc_res += UDMTF.TableRowDetails("Cut Resist:", "Indestructable", UDMTF.PercentToRainbow(0))
    EndIf
    
    loc_res += UDMTF.PageSplit(abForce = False)
    loc_res += UDMTF.LineGap()
    
    if HaveLocks()
        loc_i = 0
        loc_frag = _GetLocksIcons()
        loc_res += UDMTF.TableRowDetails("Have locks:", loc_frag)
        loc_res += UDMTF.TableRowDetails("Lock multiplier:", Round((1.0 + _getLockMinigameModifier()) * 100.0) + "%")
        if zad_deviceKey
            loc_res += UDMTF.TableRowDetails("Key:", zad_deviceKey.GetName())
        else
            loc_res += UDMTF.TableRowDetails("Key:", "None", UDMTF.PercentToGrayscale(0))
        endif
    else
        loc_res += UDMTF.TableRowDetails("Have locks:", "None", UDMTF.PercentToGrayscale(0))
    endif

    loc_res += UDMTF.PageSplit(abForce = False)
    loc_res += UDMTF.LineGap()

    if UDmain.UDGV.UDG_ShowCritVars.Value    
        loc_res += UDMTF.TableRowDetails("Crit chance:", UD_StruggleCritChance + "%")
        loc_res += UDMTF.TableRowDetails("Crit duration:", FormatFloat(UD_StruggleCritDuration, 1) + " s")
        loc_res += UDMTF.TableRowDetails("Crit mult:", FormatFloat(UD_StruggleCritMul * 100, 1) + "%")
        loc_res += UDMTF.PageSplit(abForce = False)
        loc_res += UDMTF.LineGap()
    endif

    if canBeCutted()
        loc_res += UDMTF.TableRowDetails("Cutting:", FormatFloat(UD_CutChance, 1) + "%", UDMTF.PercentToRainbow(Round(UD_CutChance * 2)))
    else
        loc_res += UDMTF.TableRowDetails("Cutting:", "Uncuttable", UDMTF.PercentToRainbow(0))
    endif

    loc_res += UDMTF.PageSplit(abForce = False)
    loc_res += UDMTF.LineGap()
    
    if isNotShareActive()
        loc_res += UDMTF.TableRowDetails("Activation effect:", UD_ActiveEffectName)
        loc_res += UDMTF.TableRowDetails("Can be activated:", canBeActivated(), UDMTF.BoolToGrayscale(canBeActivated()))
        if UD_Cooldown > 0
            loc_res += UDMTF.TableRowDetails("Cooldown:", Round(UD_Cooldown * 0.75 * UDCDmain.UD_CooldownMultiplier) + " - " + Round(UD_Cooldown * 1.25 * UDCDmain.UD_CooldownMultiplier) + " min", UDMTF.PercentToGrayscale(100))
        else
            loc_res += UDMTF.TableRowDetails("Cooldown:", "None", UDMTF.PercentToRainbow(0))
        endif
        loc_res += UDMTF.PageSplit(abForce = False)
        loc_res += UDMTF.LineGap()
    endif
    
    loc_res += UDMTF.TableRowDetails("Locked for:", FormatFloat(GetGameTimeLockedTime() * 24.0, 2) + " hours")

    loc_res += UDMTF.FooterSplit()
    loc_res += UDMTF.TableEnd()
    loc_res += UDMTF.FontEnd()
        
    UDMain.ShowMessageBox(loc_res, UDMTF.HasHtmlMarkup())
    
EndFunction

;/  Function: minigamePrecheck
    Shows message box with all modifiers and some information about them
/;
Function ShowModifiers()
    ;string loc_res = "-Modifiers-\n"
    ;if !canBeStruggled() 
    ;    loc_res += "!Impossible to struggle from!\n"
    ;endif
    ;
    
    int         loc_i = 0
    string[]    loc_list
    while loc_i < UD_ModifiersRef.length
        UD_Modifier loc_mod = (UD_ModifiersRef[loc_i] as UD_Modifier)
        ;loc_res += (loc_mod.NameFull + "\n")
        loc_list = PapyrusUtil.PushString(loc_list,loc_mod.NameFull)
        loc_i   += 1
    endwhile
    
    loc_list = PapyrusUtil.PushString(loc_list,"==BACK==")
    
    int loc_res = UDmain.GetUserListInput(loc_list)
    
    if loc_res == (loc_list.length - 1)
        return ;user selected ==BACK==
    endif
    
    UD_Modifier loc_mod = (UD_ModifiersRef[loc_res] as UD_Modifier)
    loc_mod.ShowDetails(self,UD_ModifiersDataStr[loc_res],UD_ModifiersDataForm1[loc_res],UD_ModifiersDataForm2[loc_res],UD_ModifiersDataForm3[loc_res])
EndFunction


;/  Function: ShowLockDetails
    Shows message box with list off all locks. Selecting lock will open message box with information about the lock
/;
Function ShowLockDetails()

    while True
        Int loc_lockId = UserSelectLock()
        
        if loc_lockId < 0 || loc_lockId == GetLockNumber()
            return
        endif
        
        string loc_res = ""

        loc_res += UDMTF.Header(getDeviceName(), 4)
        loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
        loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
        loc_res += UDMTF.HeaderSplit()

        loc_res += UDMTF.TableRowDetails("Name:", GetNthLockName(loc_lockId))
        
        Bool loc_ShowDiff   = True
        Bool loc_ShowAcc    = True
        Bool loc_ShowShield = True
        if IsNthLockUnlocked(loc_lockId)
            loc_ShowDiff    = False
            loc_ShowAcc     = False
            loc_ShowShield  = False
            loc_res += UDMTF.TableRowDetails("Status:", "UNLOCKED", UDMTF.PercentToGrayscale(0))
        elseif IsNthLockJammed(loc_lockId)
            loc_res += UDMTF.TableRowDetails("Status:", "JAMMED", "#FF4444")
            Float loc_RepairProgress = GetNthLockRepairProgress(loc_lockId)
            loc_res += UDMTF.TableRowDetails("Repair progress:", FormatFloat(loc_RepairProgress, 1) + "%", "#FF4444")
        elseif IsNthLockTimeLocked(loc_lockId) && GetNthLockTimeLock(loc_lockId)
            loc_res += UDMTF.TableRowDetails("Status:", "TIME LOCKED", "#4444FF")
            loc_res += UDMTF.TableRowDetails("Timelock:", GetNthLockTimeLock(loc_lockId) + " hours")
        else
            loc_res += UDMTF.TableRowDetails("Status:", "LOCKED", "#FFFFFF")
        endif
        
        loc_res += UDMTF.PageSplit(abForce = False)
        loc_res += UDMTF.LineGap()
        
        if loc_ShowShield
            Int loc_shields = GetNthLockShields(loc_lockId)
            if loc_shields
                loc_res += UDMTF.TableRowDetails("Shields:", loc_shields as String)
            else
                loc_res += UDMTF.TableRowDetails("Shields:", "NONE", UDMTF.PercentToGrayscale(0))
            endif
            loc_res += UDMTF.PageSplit(abForce = False)
            loc_res += UDMTF.LineGap()
        endif

        if loc_ShowAcc
            Int loc_acc  = GetNthLockAccessibility(loc_lockId)
            Int loc_cacc = GetLockAccesChance(loc_lockId)
            
            loc_res += UDMTF.TableRowDetails("Base Access:", _GetLockAccessibilityString(loc_acc) + " (" + loc_acc + "%)", UDMTF.PercentToRainbow(loc_acc))
            loc_res += UDMTF.TableRowDetails("Current Access:", _GetLockAccessibilityString(loc_cacc)+ " (" + loc_cacc + "%)", UDMTF.PercentToRainbow(loc_cacc))
            loc_res += UDMTF.PageSplit(abForce = False)
            loc_res += UDMTF.LineGap()
        endif
        if loc_ShowDiff
            Int loc_diff = GetNthLockDifficulty(loc_lockId)
            loc_res += UDMTF.TableRowDetails("Difficulty:", _GetLockpickLevelString(_getLockpickLevel(-1, loc_diff)) + " (" +loc_diff + ")", UDMTF.PercentToRainbow(100 - loc_diff))
            loc_res += UDMTF.PageSplit(abForce = False)
            loc_res += UDMTF.LineGap()
        endif
        
        loc_res += UDMTF.FooterSplit()
        loc_res += UDMTF.TableEnd()
        loc_res += UDMTF.FontEnd()
    
        UDmain.ShowMessageBox(loc_res, UDMTF.HasHtmlMarkup())
    endwhile
EndFunction

;/  Function: showDebugInfo
    Shows message box with debug information about device
/;
Function showDebugInfo()
    updateDifficulty()
    string loc_res = ""
    
    loc_res += UDMTF.Header(getDeviceName(), 4)
    loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
    loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
    loc_res += UDMTF.HeaderSplit()

    if (zad_JammLockChance > 0)
        loc_res += UDMTF.TableRowDetails("Chance of lock jamming:", FormatFloat(zad_JammLockChance, 1) + "%", UDMTF.PercentToRainbow(Round(100 - zad_JammLockChance)))
        Float loc_val = fRange(zad_JammLockChance * UDCDmain.CalculateKeyModifier(), 0.0, 100.0)
        loc_res += UDMTF.TableRowDetails("With key modifier:", FormatFloat(loc_val, 1) + "%", UDMTF.PercentToRainbow(100 - Round(loc_val)))
        loc_res += UDMTF.PageSplit(abForce = False)
        loc_res += UDMTF.LineGap()
    endif
    if isNotShareActive(); && canBeActivated()
        loc_res += UDMTF.TableRowDetails("Cooldown:", _currentRndCooldown +" min")
        loc_res += UDMTF.TableRowDetails("Elapsed time:", FormatFloat(_updateTimePassed, 3) +" min ("+ FormatFloat(getRelativeElapsedCooldownTime() * 100, 1) + "%)")
        loc_res += UDMTF.TableRowDetails("Can be activated:", canBeActivated(), UDMTF.BoolToGrayscale(canBeActivated()))
        loc_res += UDMTF.PageSplit(abForce = False)
        loc_res += UDMTF.LineGap()
    endif
    loc_res += _getCritInfo()
    
    loc_res += UDMTF.FooterSplit()
    loc_res += UDMTF.TableEnd()
    loc_res += UDMTF.FontEnd()
    UDmain.ShowMessageBox(loc_res, UDMTF.HasHtmlMarkup())
EndFunction

;/  Function: showDebugMinigameInfo
    Shows message box with debug information about current minigame. Have to be called after minigame starts
/;
Function showDebugMinigameInfo()
    string loc_res = ""
    
    loc_res += UDMTF.Header(getDeviceName(), 4)
    loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
    loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140, aiColumn2Width = 70, aiColumn3Width = 70)
    loc_res += UDMTF.HeaderSplit()
    
    loc_res += UDMTF.TableRowDetails("Wearer:", getWearerName())
    if haveHelper()
        loc_res += UDMTF.TableRowDetails("Helper:", getHelperName())
    endif
    
    loc_res += UDMTF.PageSplit(abForce = False)
    loc_res += UDMTF.LineGap()
        
    if _StruggleGameON
        loc_res += UDMTF.TableRowDetails("Struggle type:", _struggleGame_Subtype)
    endif
    loc_res += UDMTF.TableRowDetails("Damage modifier:", Round(UD_DamageMult * 100.0) + " %")
    if UD_damage_device
        loc_res += UDMTF.TableRowDetails("Base DPS:", FormatFloat(UD_durability_damage_base,4) + " DPS")
        loc_res += UDMTF.TableRowDetails("DPS bonus:", FormatFloat(UD_durability_damage_add,2) + " DPS")
        loc_res += UDMTF.TableRowDetails("Total DPS:", (_durability_damage_mod + UD_durability_damage_add)*UD_DamageMult + " DPS")
        loc_res += UDMTF.TableRowDetails("Total increase:", FormatFloat((((_durability_damage_mod + UD_durability_damage_add)*UD_DamageMult)/UD_durability_damage_base)*100 - 100.0,2) + "%")
    elseif _CuttingGameON
        loc_res += UDMTF.TableRowDetails("Cutting modifier:", Round(UD_MinigameMult1*100.0) + "%")
    else
        loc_res += UDMTF.TextDecoration("No DPS", asAlign = "center") + UDMTF.LineBreak()
    endif
    loc_res += UDMTF.PageSplit(abForce = False)
    loc_res += UDMTF.LineGap()
    
    loc_res += UDMTF.TableRowDetails("Condition dmg increase:", Round(_condition_mult_add * 100) + "%")
    loc_res += UDMTF.TableRowDetails("Crits:", UD_minigame_canCrit)
    if UD_drain_stats
        if UD_minigame_stamina_drain
            loc_res += UDMTF.TableRowDetails("Stamina SPS:", FormatFloat(UD_minigame_stamina_drain,2))
        endif
        if UD_minigame_heal_drain
            loc_res += UDMTF.TableRowDetails("Health SPS:", FormatFloat(UD_minigame_heal_drain,2))
        endif
        if UD_minigame_magicka_drain
            loc_res += UDMTF.TableRowDetails("Magicka SPS:", FormatFloat(UD_minigame_magicka_drain,2))
        endif
    else
        loc_res += UDMTF.TextDecoration("Wearer doesn't loose stats", asAlign = "center") + UDMTF.LineBreak()
    endif

    loc_res += UDMTF.PageSplit(abForce = False)
    loc_res += UDMTF.LineGap()
    
    loc_res += UDMTF.TableRowWide("Required stats:", "S = " + Round(_minMinigameStatSP*100) + "%", "H = " + Round(_minMinigameStatHP*100) + "%", "M = " + Round(_minMinigameStatMP*100) + "%")
    if UD_RegenMag_Stamina || UD_RegenMag_Health || UD_RegenMag_Magicka
        loc_res += UDMTF.TableRowWide("Wearer regen:", "S = " + Round(UD_RegenMag_Stamina*100) + "%", "H = " + Round(UD_RegenMag_Health*100) + "%", "M = " + Round(UD_RegenMag_Magicka*100) + "%")
    endif
    if UD_RegenMagHelper_Stamina || UD_RegenMagHelper_Health || UD_RegenMagHelper_Magicka
        loc_res += UDMTF.TableRowWide("Helper regen:", "S = " + Round(UD_RegenMagHelper_Stamina*100) + "%", "H = " + Round(UD_RegenMagHelper_Health*100) + "%", "M = " + Round(UD_RegenMagHelper_Magicka*100) + "%")
    endif
    if UD_applyExhastionEffect
        loc_res += UDMTF.TableRowDetails("Exhastion mult:", Round(_exhaustion_mult*100) + "%")
    else
        loc_res += UDMTF.TableRowDetails("Exhastion mult:", "No exhastion")
    endif
    
    loc_res += UDMTF.FooterSplit()
    loc_res += UDMTF.TableEnd()
    loc_res += UDMTF.FontEnd()
    
    UDmain.ShowMessageBox(loc_res, UDMTF.HasHtmlMarkup())
EndFunction

string Function _getCritInfo()
    string loc_res = ""
    if (UD_StruggleCritChance > 0)
        loc_res += UDMTF.TableRowDetails("Crit chance:", UD_StruggleCritChance + "%")
        loc_res += UDMTF.TableRowDetails("Crit:", FormatFloat(UD_StruggleCritMul,1) + "x") 
        if UD_StruggleCritDuration >= 1
            loc_res += UDMTF.TableRowDetails("Crit difficulty:", "Easy", UDMTF.PercentToRainbow(100))
        elseif UD_StruggleCritDuration >= 0.5
            loc_res += UDMTF.TableRowDetails("Crit difficulty:", "Normal", UDMTF.PercentToRainbow(50))
        else
            loc_res += UDMTF.TableRowDetails("Crit difficulty:", "Hard", UDMTF.PercentToRainbow(0))
        endif
    else
        loc_res += UDMTF.TableRowDetails("Crit chance:", "NEVER", UDMTF.PercentToGrayscale(0))
    endif
    return loc_res
endFunction

;/  Group: Extension functions / Override
These functions are intended to be overriden by extending scripts.

Check <RenderDeviceTemplate> from docs folder for their default implementation.
===========================================================================================
===========================================================================================
===========================================================================================
/;

;--------------------------------------------------
;  ______      ________ _____  _____ _____  ______ 
; / __ \ \    / /  ____|  __ \|_   _|  __ \|  ____|
;| |  | \ \  / /| |__  | |__) | | | | |  | | |__   
;| |  | |\ \/ / |  __| |  _  /  | | | |  | |  __|  
;| |__| | \  /  | |____| | \ \ _| |_| |__| | |____ 
; \____/   \/   |______|_|  \_\_____|_____/|______|
;--------------------------------------------------                                                  
;theese function should be on every object instance, as not having them may cause multiple function calls to default class

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

Function patchDevice()
    UDCDmain.UDPatcher.patchGeneric(self)
EndFunction

Function activateDevice()
    if UDmain.TraceAllowed()
        UDmain.Log("Device " + getDeviceName() + " (W: " + getWearerName() + ") activated",1)
    endif
    resetCooldown(1.0)
EndFunction

bool Function canBeActivated()
    return true
EndFunction

bool Function OnMendPre(float mult)
    return True
EndFunction

Function OnMendPost(float afAmount)
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
    if haveHelper()
        ;1 hour cooldown
        ;UDCDMain.ResetHelperCD(GetHelper(),GetWearer(),UDCDmain.UD_MinigameHelpXPBase)
    endif
    
    if isSentient() && getRelativeDurability() > 0.0
        if RandomInt() > 75 && WearerIsPlayer()
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
        UD_durability_damage_add = (5.0 - 5.0*getRelativeDurability()) + UDmain.UDSKILL.getActorStrengthSkillsPerc(getWearer()) + getHelperStrengthSkillsPerc()
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

String Function getAccesibilityString()
    Float loc_acc = getAccesibility()
    String loc_str = ""
    If loc_acc > 0.8
        loc_str = "Very easy"
    ElseIf loc_acc > 0.6
        loc_str = "Easy"
    ElseIf loc_acc > 0.4
        loc_str = "Challenging"
    ElseIf loc_acc > 0.2
        loc_str = "Difficult"
    ElseIf loc_acc > 0.0
        loc_str = "Almost impossible"
    Else
        loc_str = "Impossible"
    EndIf
    Return UDMTF.TextDecoration("Impossible", asColor = UDMTF.PercentToRainbow(Round(loc_acc * 100)))
EndFunction

; afResist: -100.0 .. 100.0
String Function getResistanceString(Float afResist)
    String loc_str = ""
    If afResist < -75.0
        loc_str = "Extremely vulnerable"
    ElseIf afResist < -50.0
        loc_str = "Vulnerable"
    ElseIf afResist < -25.0
        loc_str = "Susceptible"
    ElseIf afResist < 25.0
        loc_str = "Not resistant"
    ElseIf afResist < 50.0
        loc_str = "Resistant"
    ElseIf afResist < 75.0
        loc_str = "Very resistant"
    ElseIf afResist < 99.0
        loc_str = "Almost immune"
    Else
        loc_str = "Immune"
    EndIf
    Return UDMTF.TextDecoration(loc_str, asColor = UDMTF.PercentToRainbow(Round(-afResist / 2 + 50)))
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
            if hasModifier("CLO")
                int loc_chance = Round(UD_Native.GetStringParamFloat(GetModifierParam("CLO"),0)*0.1)
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
    if _CuttingGameON
        ;setWidgetVal(getRelativeCuttingProgress(),force)
        setSecWidgetVal(GetRelativeDurability(), force)
    elseif _RepairLocksMinigameON
        setWidgetVal(_GetRelativeLockRepairProgress(_MinigameSelectedLockID),force)
    endif
EndFunction

Function updateWidgetColor()
    if UD_WidgetAutoColor; && !UDmain.UseiWW()
        if UD_Condition == 0
            setMainWidgetAppearance(0x4da319, 0x62ff00)
        elseif UD_Condition == 1
            setMainWidgetAppearance(0xafba24, 0x4da319)
        elseif UD_Condition == 2
            setMainWidgetAppearance(0xe37418, 0xafba24)
        elseif UD_Condition == 3
            setMainWidgetAppearance(0xdc1515, 0xe37418)
        else
            setMainWidgetAppearance(0x5a1515, 0xdc1515)
        endif
    ;elseif UD_WidgetAutoColor
    ;    setMainWidgetAppearance(0xFF307C, 0xFF005E)
    endif

    If UD_WidgetAutoColorSec; && !UDmain.UseiWW()
        if UD_Condition == 0
            setSecWidgetAppearance(0x4da319, 0x62ff00)
        elseif UD_Condition == 1
            setSecWidgetAppearance(0xafba24, 0x4da319)
        elseif UD_Condition == 2
            setSecWidgetAppearance(0xe37418, 0xafba24)
        elseif UD_Condition == 3
            setSecWidgetAppearance(0xdc1515, 0xe37418)
        else
            setSecWidgetAppearance(0x5a1515, 0xdc1515)
        endif
    ;elseif UD_WidgetAutoColorSec
    ;    setSecWidgetAppearance(0xFF307C, 0xFF005E)
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
            return zadexpressionlibs.CreateRandomExpression()
        endif
    else
        if RandomInt(0,1)
            return zadexpressionlibs.CreateRandomExpression()
        else
            return UDmain.UDEM.GetPrebuildExpression_Happy1()
        endif
    endif
EndFunction

Function removeDevice(actor akActor)
    if _removeDeviceCalled
        return
    endif
    _removeDeviceCalled = True
    
    GoToState("UpdatePaused")
        
    if !akActor.isDead()
        if !IsUnlocked
            _IsUnlocked = True
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
    
    StorageUtil.UnSetIntValue(Wearer, "UD_ignoreEvent" + deviceInventory)
    
    onRemoveDevicePost(akActor)
    
    _isRemoved = True
    
    UD_Events.SendEvent_DeviceUnlocked(self)
EndFunction

Function OnAdvanceSkill(Float afMult)
EndFunction

bool Function Details_CanShowResist()
    return true
EndFunction

bool Function Details_CanShowHitResist()
    return true
EndFunction 

Float Function ValidateAccessibility(Float afValue)
    if UDCDmain.UD_HardcoreAccess && afValue < 0.9
        return 0.0
    endif
    return fRange(afValue,0.0,1.0)
EndFunction

;function called when player clicks DETAILS button in device menu
Function processDetails()
    UDCDmain.currentDeviceMenu_switch1 = HaveLocks()
    int res = UDMain.UDMMM.ShowMessageBoxMenu(UDCDmain.DetailsMessage, UDMain.UDMMM.NoValues, "", UDMain.UDMMM.NoButtons)
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

;Priority for AI
Int Function GetAiPriority()
    return 25 ;generic value
EndFunction

;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------

State UpdatePaused
    Function Update(float timePassed)
        _updateTimePassed += (timePassed*24.0*60.0);*UDCDmain.UD_CooldownMultiplier
    EndFunction
    Function UpdateHour()
    EndFunction
EndState

;native events
Function RegisterDevice(Actor akActor,Armor akInvDevice, Armor akRenDevice)
    ;UDmain.Info(self + ":: Register device called - " + GetActorName(akActor) + " , " + akInvDevice)
    UD_WearerSlot.registerDevice(self)
EndFunction

Function _SendMinigameThreads(bool abStarter, bool abCritLoop, bool abParalelThread, bool abAVLoop)
    int loc_mode = 0x0
    if abStarter
        loc_mode += 1
    endif
    if abCritLoop
        loc_mode += 2
    endif
    if abParalelThread
        loc_mode += 4
    endif
    if abAVLoop
        loc_mode += 8
    endif
    
    Int loc_res = SendMinigameThreadEvents(GetWearer(),DeviceRendered,_VMHandle1,_VMHandle2,loc_mode)
    
    if loc_res > 0
        if loc_res == 3
            String loc_msg = "!!FATAL ERROR!!\nError finding script for device "+GetDeviceName()+". This likely mean that you installed patch incorrectly! Please close the game, and check you load order!"
            UDmain.Error(loc_msg)
            UDMain.ShowMessageBoxSafe(loc_msg)
        else
            UDmain.Error("Could not start minigame thread. Return code => " + loc_res)
        endif
        StopMinigame()
    endif
EndFunction

Function _MinigameStarterThread()
    bool    loc_canShowHUD      = canShowHUD()
    bool    loc_haveplayer      = PlayerInMinigame()
    bool    loc_is3DLoaded      = loc_haveplayer || UDmain.ActorInCloseRange(wearer)
    
    if UDmain.TraceAllowed()
        UDmain.Log("_MinigameStarterThread("+GetDeviceHeader()+")")
    endif
    
    _MinigameParProc_1 = true
    
    UDCDMain.StartMinigameDisable(Wearer)
    if _minigameHelper
        UDCDMain.StartMinigameDisable(_minigameHelper)
    endif
    
    if loc_haveplayer
        UDCDmain.setCurrentMinigameDevice(self)
        UDCDmain.MinigameKeysRegister()
        UD_Native.RegisterDeviceCallback(_VMHandle1,_VMHandle2,deviceRendered,UDCDMain.Stamina_meter_Keycode,"_MG_CKSPress")
        UD_Native.RegisterDeviceCallback(_VMHandle1,_VMHandle2,deviceRendered,UDCDMain.Magicka_meter_Keycode,"_MG_CKMPress")
    else
        StorageUtil.SetFormValue(Wearer, "UD_currentMinigameDevice", deviceRendered)
    endif
    
    _MinigameParProc_1 = false
    
    ;shows bars
    if loc_canShowHUD
        showHUDbars()
    endif
    
    OnMinigameStart()
    
    if loc_is3DLoaded
        libsp.pant(Wearer)
    endif
EndFunction

Function _MinigameParalelThread()
    Actor     akActor       = GetWearer()
    Actor     akHelper      = getHelper()
    
    _MinigameParProc_2 = true
    
    if UDmain.TraceAllowed()
        UDmain.Log("_MinigameParalelThread("+GetDeviceHeader()+")")
    endif
    
    ;process
    bool      loc_haveplayer    = PlayerInMinigame()
    bool      loc_is3DLoaded    = akActor.Is3DLoaded() || loc_haveplayer
    
    ;disable regen of all stats
    float staminaRate           = akActor.getBaseAV("StaminaRate")
    float HealRate              = akActor.getBaseAV("HealRate")
    float magickaRate           = akActor.getBaseAV("MagickaRate")

    akActor.setAV("StaminaRate", staminaRate*UD_RegenMag_Stamina)
    akActor.setAV("HealRate", HealRate*UD_RegenMag_Health)
    akActor.setAV("MagickaRate", magickaRate*UD_RegenMag_Magicka)

    float staminaRateHelper     = 0.0
    float HealRateHelper        = 0.0
    float magickaRateHelper     = 0.0
    if akHelper
        staminaRateHelper       = akHelper.getBaseAV("StaminaRate")
        HealRateHelper          = akHelper.getBaseAV("HealRate")
        magickaRateHelper       = akHelper.getBaseAV("MagickaRate")

        akHelper.setAV("StaminaRate", staminaRateHelper*UD_RegenMagHelper_Stamina)
        akHelper.setAV("HealRate"    , HealRateHelper*UD_RegenMagHelper_Health)
        akHelper.setAV("MagickaRate", magickaRateHelper*UD_RegenMagHelper_Magicka)
    endif
    
    bool loc_canShowHUD     = canShowHUD()
    bool loc_updatewidget   = (UD_UseWidget || UD_UseWidgetSec) && UDCDmain.UD_UseWidget && loc_haveplayer
    
    ;Send_MinigameCritLoop(akActor, self) TODO

    float[] loc_expression = GetCurrentMinigameExpression()
    libsp.ExpLibs.ApplyExpressionRaw(akActor, loc_expression, 100,false,15)
    if haveHelper()
        libsp.ExpLibs.ApplyExpressionRaw(akHelper, loc_expression, 100,false,15)
    endif
    
    float loc_currentOrgasmRate     = getStruggleOrgasmRate()
    float loc_currentArousalRate    = getArousalRate()
    
    string loc_orgkey = "UDMinigame." + getDeviceName()
    OrgasmSystem.AddOrgasmChange(akActor,loc_orgkey, 0,0x00000200,loc_currentOrgasmRate,0,0,0.25)
    OrgasmSystem.UpdateOrgasmChangeVar(akActor,loc_orgkey,9,loc_currentArousalRate,1)
    
    ;pause thred untill minigame end
    Float loc_UpdateTime   = 0.25
    if !loc_is3DLoaded
        loc_UpdateTime = 3.0
    elseif !loc_haveplayer
        loc_UpdateTime = 1.0
    endif
    
    Float loc_ElapsedTime1 = 0.0
    Float loc_ElapsedTime2 = 0.0
    Float loc_ElapsedTime3 = 0.0
    
    Udmain.UDMOM.Procces_UpdateModifiers_MinigameStarted(self)
    
    while IsMinigameLoopRunning()
        if !isPaused()
            ;set expression every 5 second
            if loc_is3DLoaded
                if loc_ElapsedTime1 >= 5.0
                    libsp.ExpLibs.ApplyExpressionRaw(akActor, loc_expression, 100,false,15)
                    if akHelper
                        libsp.ExpLibs.ApplyExpressionRaw(akHelper, loc_expression, 100,false,15)
                    endif
                    loc_ElapsedTime1 = 0.0
                endif
            endif
            ;update widget and HUD every 2 s
            if loc_haveplayer
                if loc_ElapsedTime2 >= 2.0
                    if loc_canShowHUD
                        showHUDbars(False)
                    endif
                    if loc_updatewidget
                        showWidget(False, False)
                    endif
                    loc_ElapsedTime2 = 0.0
                endif
                ;advance skill every 3 second
                if loc_ElapsedTime3 >= 1.0
                    advanceSkill(loc_ElapsedTime3)
                    if loc_is3DLoaded
                        loc_updatewidget    = (UD_UseWidget || UD_UseWidgetSec) && UDCDmain.UD_UseWidget && loc_haveplayer
                        loc_canShowHUD      = canShowHUD()
                    endif
                    loc_ElapsedTime3    = 0.0
                endif
            endif
        endif
        if IsMinigameLoopRunning()
            Utility.wait(loc_UpdateTime)
            loc_ElapsedTime1 += loc_UpdateTime
            loc_ElapsedTime2 += loc_UpdateTime
            loc_ElapsedTime3 += loc_UpdateTime
        endif
    endwhile
    
    OrgasmSystem.RemoveOrgasmChange(akActor,loc_orgkey)
    
    ;returns wearer regen
    akActor.setAV("StaminaRate", staminaRate)
    akActor.setAV("HealRate", healRate)
    akActor.setAV("MagickaRate", magickaRate)
    if akHelper
        akHelper.setAV("StaminaRate", staminaRateHelper)
        akHelper.setAV("HealRate", HealRateHelper)
        akHelper.setAV("MagickaRate", magickaRateHelper)
    endif
    
    if loc_haveplayer
        hideHUDbars() ;hides HUD (not realy?)
        hideWidget()
    endif
    
    Udmain.UDMOM.Procces_UpdateModifiers_MinigameEnded(self)
    
    _MinigameParProc_2 = false
    
    if loc_is3DLoaded
        libsp.ExpLibs.ResetExpressionRaw(akActor,15)
        if akHelper
            libsp.ExpLibs.ResetExpressionRaw(akHelper,15)
        endif
    endif
    
    if loc_is3DLoaded && (UDmain.UDGV.UDG_MinigameExhaustion.Value == 1)
        addStruggleExhaustion(akHelper)
    endif
EndFunction

Function _MinigameCritLoopThread()
    Actor akActor                           = GetWearer()
    
    _MinigameParProc_3           = true
    
    if UDmain.TraceAllowed()
        UDmain.Log("_MinigameCritLoopThread("+GetDeviceHeader()+")")
    endif
    
    Bool loc_playerInMinigame               = PlayerInMinigame()
    Bool loc_is3DLoaded                     = akActor.Is3DLoaded() || loc_playerInMinigame

    Float loc_elapsedTime = 0.0
    Float loc_updateTime  = 0.25
    string critType = "random"
    if !loc_playerInMinigame
        loc_updateTime = 1.0
        critType = "NPC"
    elseif UDCDmain.UD_AutoCrit
        critType = "Auto"
    endif
    
    if loc_playerInMinigame
        Utility.Wait(0.5) ;wait little time before starting crits
    endif
    
    ;process
    while IsMinigameLoopRunning()
        if !isPaused() && (!loc_is3DLoaded || !UDmain.IsMenuOpen())
            ;check crit every 1 s
            if loc_elapsedTime >= 1.0
                if UD_minigame_canCrit
                    UDCDmain.StruggleCritCheck(self,UD_StruggleCritChance,critType,UD_StruggleCritDuration)
                elseif _customMinigameCritChance
                    UDCDmain.StruggleCritCheck(self,_customMinigameCritChance,critType,_customMinigameCritDuration)
                endif
                loc_elapsedTime = 0.0
            endif
        endif
        if IsMinigameLoopRunning()
            Utility.Wait(loc_updateTime)
            loc_elapsedTime += loc_updateTime
        endif
    endwhile
    
    _MinigameParProc_3 = false
EndFunction

Function _MinigameAVCheckLoopThread()
    _MinigameParProc_4 = true
    
    if UDmain.TraceAllowed()
        UDmain.Log("_MinigameAVCheckLoopThread("+GetDeviceHeader()+")")
    endif
    
    float loc_CurrentUpdateTime             = UDmain.UD_baseUpdateTime
    Bool  loc_HaveHelper                    = haveHelper()
    Float loc_ElapsedTime                   = 0.0
    Bool  loc_MinigameEffectEnabled         = False
    
    _StartMinigameEffect()
    
    ;process
    while IsMinigameLoopRunning()
        if !isPaused()
            if UDCDMain.UD_InitialDrainDelay == 0 || (loc_ElapsedTime > UDCDMain.UD_InitialDrainDelay)
                if !loc_MinigameEffectEnabled
                    loc_MinigameEffectEnabled = true
                    _ToggleMinigameEffect(true)
                endif
                if !ProccesAV(loc_CurrentUpdateTime)
                    StopMinigame()
                endif
                if loc_HaveHelper
                    if !ProccesAVHelper(loc_CurrentUpdateTime)
                        StopMinigame()
                    endif
                endif
            endif
        endif
        if IsMinigameLoopRunning()
            Utility.Wait(loc_CurrentUpdateTime)
            loc_ElapsedTime += loc_CurrentUpdateTime
        endif
    endwhile
    
    _MinigameParProc_4 = false
EndFunction

Function _CuttingMG_SKPress(Float afValue)
    if IsPaused()
        return
    endif
    if afValue >= fRange(100.0 - Math.Pow(UD_CutChance,1.2)*2.0,0.0,96.0)
        if !UDCDmain.crit
            UDlibs.RedCrit.RemoteCast(UDmain.Player,UDmain.Player,UDmain.Player) ;show to player that they cutted device in right time by using shader effect
        endif
        _cutDevice(Math.Pow(UD_CutChance,1.2)*3.0/fRange((100.1-afValue),1.0,100.0))
    endif
EndFunction

Function _MG_CKSPress()
    bool     loc_crit                    = UDCDmain.crit 
    string   loc_selected_crit_meter     = UDCDmain.selected_crit_meter
    if IsPaused()
        return
    endif
    if (loc_crit) && !UDCDMain.UD_AutoCrit
        if loc_selected_crit_meter == "S"
            UDCDmain.crit = False
            critDevice()
        else
            UDCDmain.crit = False
            critFailure()
        endif
    else
        critFailure()
    endif
EndFunction

Function _MG_CKMPress()
    bool     loc_crit                    = UDCDmain.crit 
    string   loc_selected_crit_meter     = UDCDmain.selected_crit_meter
    if IsPaused()
        return
    endif
    if (loc_crit) && !UDCDMain.UD_AutoCrit
        if loc_selected_crit_meter == "M"
            UDCDmain.crit = False
            critDevice()
        else
            UDCDmain.crit = False
            critFailure()
        endif
    else
        critFailure()
    endif
EndFunction

; Used to unregister device which is invalid. This can happen if render device is removed by some mod, but script is still regesitered on NPCs still. 
; This causes script to be detached from object
; Either way, this basically means that actor no longer wears the device. They only have it registered in npc slot, and so it can be removed
Int _UnregisterInvalidCalled = 0
Function _UnregisterInvalid()
    ; Check if device was ever initiated
    if (_initState == 0)
        _UnregisterInvalidCalled = 2
        return
    endif
    
    if _UnregisterInvalidCalled
        return
    endif
    _UnregisterInvalidCalled = 1
    Utility.waitMenuMode(1.0)
    UDmain.WaitForUpdated()
    ;UDmain.Error("Device " + GetDeviceHeader() + " is invalid. Removing...")
    removeDevice(Wearer)
    ; Sometimes the device can be invalid, but valid script can be also present but not registered. 
    ; Calling removeLostRenderDevices should fix the issue
    UDCDmain.GetNPCSlot(Wearer).removeLostRenderDevices()
    _UnregisterInvalidCalled = 2
EndFunction