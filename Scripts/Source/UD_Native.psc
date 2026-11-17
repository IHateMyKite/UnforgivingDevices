;   File: UD_Native
Scriptname UD_Native hidden

;===UTILITY===
Form[]      Function RemoveDuplicateForms       (Form[] modifier_forms)                                         global native
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
Armor       Function GetRandomDevice            (LeveledItem akDeviceList)                                      global native
Bool        Function IsConcentrationSpell       (Spell akSpell)                                                 global native
Bool        Function IsConcentrationEnch        (Enchantment akEnch)                                            global native
String      Function GetJsonValue               (String asJson, String asKey, String asDef)                     global native
String      Function SetJsonValue               (String asJson, String asKey, String asVal)                     global native
String      Function DecompressString           (String asInput)                                                global native

;===UI===
int         Function RemoveAllMeterEntries()                                                                    global native
            Function ToggleAllMeters            (bool abToggle)                                                 global native

;===Inventory===
Armor[]     Function GetInventoryDevices        (Actor akActor, bool abWorn)                                    global native
Armor[]     Function GetRenderDevices           (Actor akActor, bool abWorn)                                    global native
Weapon      Function GetSharpestWeapon          (Actor akActor)                                                 global native

;===Animation===
Int         Function GetActorConstrains        (Actor akActor)                                                  global native
String[]    Function GetAnimationsFromJSON     (String asDef, Actor[] aaActors, Int aiConstraintsORA1, Int aiConstraintsORA2) global native
String[]    Function GetAnimationsFromDB       (String asType, String[] aasKeywords, String asField, Int[] aaiActorConstraints, Int aiLewdMin = 0, Int aiLewdMax = 10, Int aiAggroMin = -10, Int aiAggroMax = 10) global native
Bool        Function CheckWeaponDisabled       (Actor akActor)                                                  global native
            Function DisableWeapons            (Actor akActor, Bool abState)                                    global native
String[]    Function GetAllAnimationFiles      ()                                                               global native
String[]    Function GetAllAnimationFilesErrors()                                                               global native
Int[]       Function GetAllAnimationFilesStatus()                                                               global native
            Function SyncAnimationSetting      (String[] aasAnimationOff)                                       global native

;===Skill===
Int         Function CalculateSkillFromPerks    (Actor akActor,String asSkill,Int aiIncrease)                   global native
Perk[]      Function GetPerksForSkill           (String asSkill)                                                global native
            Function AdvanceSkillPerc           (String asSkill, Float afPerc)                                  global native

;===ActorSlotManager===
Bool        Function RegisterSlotQuest(Quest akQuest)                                                           global native
Actor[]     Function GetRegisteredActors()                                                                      global native

;===PlayerControl===
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
            Function ForceUpdateControls() global native

; ===Papyrus delegate===
            Function RegisterForHMTweenMenu(ReferenceAlias akRefAlias)      global native
Int         Function SendRegisterDeviceScriptEvent(Actor akActor, Armor[] akRenderDevices) global native
Int         Function RegisterDeviceScripts(Actor akActor) global native
Int         Function SendMinigameThreadEvents(Actor akActor, Armor akRenderDevice, Int aiHandle1,Int aiHandle2, Int aiMode) global native
Int         Function SendRemoveRenderDeviceEvent(Actor akActor, Armor akRenderDevice) global native
Int         Function SetBitMapData(Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName,Int aiValue, Int aiSize, Int aiOff) global native
            Function UpdateVMHandles() global native
Bool        Function GetDeviceScript(Actor akActor, Armor akDeviceRendered, String asScript, String asVariable) global native
ObjectReference  Function GetDeviceScript2(Actor akActor, Armor akID, Armor akRD) global native
Bool        Function GetInventoryDeviceScript(Actor akActor, Armor akDeviceInventory, String asScript, String asVariable) global native

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

; ===Modifiers===
Alias       Function GetModifier                (String asModifier)                                             global native
Int         Function GetModifierIndex           (Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName)      global native
String      Function GetModifierStringParam     (Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName)      global native
String[]    Function GetModifierStringParamAll  (Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName)      global native
Bool        Function EditModifierStringParam    (Int aiHandle1,Int aiHandle2,Armor akRenDev,String asName,Int aiIndex, String asNewvalue) global native
String[]    Function GetModifierAliases         (Int aiHandle1,Int aiHandle2,Armor akRenDev)                    global native

; ===Messagebox===
; Copied from https://github.com/SkyrimScripting/MessageBox
function Delete(int messageBoxId) global native
int     function ShowNonBlocking            (String asBodyText, string asButton1, string asButton2 = "", string asButton3 = "", string asButton4 = "", string asButton5 = "", string asButton6 = "", string asButton7 = "", string asButton8 = "", string asButton9 = "", string asButton10 = "", bool abUseHtml = False, bool abWordWrap = True) global native
int     function ShowArrayNonBlocking       (String asBodyText, String[] asButtons, Bool abUseHtml = False, bool abWordWrap = True) global native
int     function ShowArrayNonBlockingTemplate(Message akMemplate, String asBodyText, float[] afValues, string[] asButtons, bool abUseHtml = False, bool abWordWrap = True) global native
string  function GetResultText              (Int MessageBoxId, Bool abDeleteResultOnAccess = true)      global native
int     function GetResultIndex             (Int aiMessageBoxId, Bool abDeleteResultOnAccess = true)    global native
bool    function IsMessageResultAvailable   (Int MessageBoxId)                                          global native

; ===Config===
Int       Function GetIniVariableInt   (String asName, Int     aiDef)                               global native
String    Function GetIniVariableString(String asName, String  asDef)                               global native
Float     Function GetIniVariableFloat (String asName, Float   afDef)                               global native
Bool      Function GetIniVariableBool  (String asName, Bool    abDef)                               global native
Int[]     Function GetIniArrayInt      (String asName, String  asSep = ",")                         global native
String[]  Function GetIniArrayString   (String asName, Bool    abText = true, String asSep = ",")   global native
Float[]   Function GetIniArrayFloat    (String asName, String  asSep = ",")                         global native
Bool[]    Function GetIniArrayBool     (String asName, String  asSep = ",")                         global native

; ===Module Manager===
Bool      Function AreModulesReady    (Bool abCheckReload)  global native
Quest     Function GetModuleByAlias   (String asAlias)      global native
Quest[]   Function GetModules         ()                    global native
Quest[]   Function GetModuleDependency(Quest akModule)      global native
Quest[]   Function GetDependantModules(Quest akModule)      global native
          Function ResetModule        (Quest akModule)      global native
Quest[]   Function GetModulesByScript (String asScript)     global native
Alias[]   Function GetModulesAliasesByScript(String asScript) global native
          Function ResetAllModuleS    ()                    global native

; === UI ===
Bool      Function IsDeviceMenuOpen     () global native
Bool      Function ShowDeviceMenu       (Actor akWearer, Actor akHelper, String[] aasCallbacks) global native
Bool      Function ShowDeviceMenuSingle (Armor akID, Armor akRD, Actor akWearer, Actor akHelper, String[] aasCallbacks) global native
          Function ReloadHudConfigs     () global native

; === Minigame Manager ===
String[]  Function GetListOfMinigames (Actor akWearer, Armor akId)                      global native
Bool      Function StopMinigame       (Actor akActor)                                   global native
String[]  Function GetMinigameConfigs ()                                                global native
String[]  Function GetMinigameExports (int aiIndx)                                      global native
Bool      Function SetMinigameVariable(int aiIndx, String asConfig, String asValue)     global native
String    Function GetMinigameVariable(int aiIndx, String asConfig, String asDefValue)  global native
          Function ReloadMinigameConfigs()                                              global native
; === Device Manager ===
Float     Function GetDeviceAccessibility(Actor akWearer, Actor akHelper, Armor akRenderDevice) global native

; === Save Manager ===
          Function SetSave(String asData, Bool abDecode)    global native
String    Function GetSave(Bool abEncode)                   global native
