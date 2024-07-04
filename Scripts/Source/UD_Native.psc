;   File: UD_Native
Scriptname UD_Native hidden

;===Minigame Effect===
        Function StartMinigameEffect        (Actor akActor,Float afMult, Float afStamina, Float afHealth, Float afMagicka, Bool abToggle) global native
        Function EndMinigameEffect          (Actor akActor)                     global native
bool    Function IsMinigameEffectOn         (Actor akActor)                     global native
        Function UpdateMinigameEffectMult   (Actor akActor, float afNewMult)    global native
        Function ToggleMinigameEffect       (Actor akActor, bool abToggle)      global native ;abToggle = true -> enabled, abToggle = false -> disabled
bool    Function MinigameStatsCheck         (Actor akActor, bool abStamina, bool abHealth, bool abMagicka)                      global native
        Function MinigameEffectSetHealth    (Actor akActor, float afNewHealth)  global native
        Function MinigameEffectSetStamina   (Actor akActor, float afNewStamina) global native
        Function MinigameEffectSetMagicka   (Actor akActor, float afNewMagicka) global native
        Function MinigameEffectUpdateHealth (Actor akActor, float afHealth)     global native
        Function MinigameEffectUpdateStamina(Actor akActor, float afStamina)    global native
        Function MinigameEffectUpdateMagicka(Actor akActor, float afMagicka)    global native

;===UTILITY===
Int         Function CodeBit                    (int aiCodedMap,int aiValue,int aiSize,int aiIndex)             global native
Int         Function DecodeBit                  (int aiCodedMap,int aiSize,int aiIndex)                         global native
Int         Function Round                      (Float afValue)                                                 global native
Int         Function iRange                     (Int aiValue,Int aiMin,Int aiMax)                               global native
Float       Function fRange                     (Float afValue,Float afMin,Float afMax)                         global native
Bool        Function iInRange                   (Int afValue,Int afMin,Int afMax)                               global native
Bool        Function fInRange                   (Float afValue,Float afMin,Float afMax)                         global native
String      Function FormatFloat                (Float afValue,Int afFloatPoints)                               global native
Bool        Function IsPlayer                   (Actor akActor)                                                 global native
String      Function GetActorName               (Actor akActor)                                                 global native
Int         Function FloatToInt                 (Float afValue)                                                 global native
Float       Function RandomFloat                (Float afMin = 0.0, Float afMax = 99.99)                        global native
Int         Function RandomInt                  (Int aiMin = 0, Int aiMax = 99)                                 global native
Int         Function RandomIdFromDist           (Int[] aiDist)                                                  global native
Bool        Function PluginInstalled            (string asName)                                                 global native
Armor       Function CheckArmorEquipped         (Actor akActor, Armor akArmor)                                  global native
            Function ToggleDetection            (Bool a_val)                                                    global native
String[]    Function GetStringParamAll          (String asParam)                                                global native
Int         Function GetStringParamInt          (String asParam,Int aiIndex = 0,Int     aiDefaultValue = 0  )   global native
Float       Function GetStringParamFloat        (String asParam,Int aiIndex = 0,Float   afDefaultValue = 0.0)   global native
String      Function GetStringParamString       (String asParam,Int aiIndex = 0,String  asDefaultValue = "" )   global native
Alias       Function GetModifier                (String asModifier)                                             global native
Int         Function GetModifierIndex           (Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName)      global native
String      Function GetModifierStringParam     (Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName)      global native
String[]    Function GetModifierStringParamAll  (Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName)      global native
Bool        Function EditModifierStringParam    (Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName,Int aiIndex, String asNewvalue) global native
Armor       Function GetRandomDevice            (LeveledItem akDeviceList)                                      global native

;===UI===
int     Function RemoveAllMeterEntries()                                        global native
        Function ToggleAllMeters            (bool abToggle)                     global native

;iWantWidget meters
        Function AddMeterEntryIWW           (string asPath, int aiId, string asName, int aiFormula, float afBase, float afRate, bool abShow)   global native
        Function RemoveMeterEntryIWW        (int aiId)                          global native
        Function ToggleMeterIWW             (int aiId, bool abToggle)           global native
        Function SetMeterRateIWW            (int aiId, float afNewRate)         global native
        Function SetMeterMultIWW            (int aiId, float afNewMult)         global native
        Function SetMeterValueIWW           (int aiId, float afNewValue)        global native
Float   Function UpdateMeterValueIWW        (int aiId, float afDiffValue)       global native
Float   Function GetMeterValueIWW           (int aiId)                          global native

;SkyUi meters
        Function AddMeterEntrySkyUi         (string asPath, string asName, int aiFormula, float afBase, float afRate, bool abShow)             global native
        Function RemoveMeterEntrySkyUi      (string asPath)                     global native
        Function ToggleMeterSkyUi           (string asPath, bool abToggle)      global native
        Function SetMeterRateSkyUi          (string asPath, float afNewRate)    global native
        Function SetMeterMultSkyUi          (string asPath, float afNewMult)    global native
        Function SetMeterValueSkyUi         (string asPath, float afNewValue)   global native
Float   Function UpdateMeterValueSkyUi      (string asPath, float afDiffValue)  global native
Float   Function GetMeterValueSkyUi         (string asPath)                     global native

;===Inventory===
Armor[] Function GetInventoryDevices        (Actor akActor, bool abWorn)        global native
Armor[] Function GetRenderDevices           (Actor akActor, bool abWorn)        global native
Weapon  Function GetSharpestWeapon          (Actor akActor)                     global native

;===Animation===
Int     Function GetActorConstrains         (Actor akActor)                     global native
Bool    Function CheckWeaponDisabled        (Actor akActor)                     global native
        Function DisableWeapons             (Actor akActor, Bool abState)       global native

;===Skill===
Int     Function CalculateSkillFromPerks    (Actor akActor,Formlist akList,Int aiIncrease)      global native

;===ActorSlotManager===
Bool        Function RegisterSlotQuest(Quest akQuest)   global native
Actor[]     Function GetRegisteredActors()              global native

;===PlayerControl===
            Function SyncControlSetting(bool abHardcoreMode)    global native
;/
    Camera states...
    kError          =   -1
    kFirstPerson    =    0
    kAutoVanity     =    1
    kVATS           =    2
    kFree           =    3
    kIronSight,     =    4
    kFurniture      =    5
    kPCTransition   =    6
    kTween          =    7
    kAnimated       =    8
    kThirdPerson    =    9
    kMount          =   10
    kBleedout       =   11
    kDragon         =   12
/;
Int         Function GetCameraState() global native
Bool        Function RegisterDeviceCallback(Int aiHandle1, Int aiHandle2,Armor akDevice, Int aiDxKeycode, String asCallbackFun) global native
Bool        Function UnregisterDeviceCallbacks(Int aiHandle1, Int aiHandle2,Armor akDevice) global native
            Function UnregisterAllDeviceCallbacks() global native
Bool        Function AddDeviceCallbackArgument(int aiDxKeycode, int aiType, string asArgStr, Form akArgForm) global native

; ===Papyrus delegate===
            Function RegisterForHMTweenMenu(ReferenceAlias akRefAlias)      global native
Int         Function SendRegisterDeviceScriptEvent(Actor akActor, Armor[] akRenderDevices) global native
Int         Function SendMinigameThreadEvents(Actor akActor, Armor akRenderDevice, Int aiHandle1,Int aiHandle2, Int aiMode) global native
Int         Function SendRemoveRenderDeviceEvent(Actor akActor, Armor akRenderDevice) global native
Int         Function SetBitMapData(Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName,Int aiValue, Int aiSize, Int aiOff) global native
            Function UpdateVMHandles() global native
            
; ===Materials===
Bool Function IsSteel   (Armor akArmor) global native
Bool Function IsEbonite (Armor akArmor) global native
Bool Function IsRope    (Armor akArmor) global native
Bool Function IsSecure  (Armor akArmor) global native
Bool Function IsLeather (Armor akArmor) global native

; ===Diagnosis===
Int Function CheckPatchedDevices() global native

; ===Lockpick===
Float   Function GetLockpickVariable(Int aiVariable) global native
Bool    Function SetLockpickVariable(Int aiVariable, Float afValue)  global native