Scriptname zadConfig extends SKI_ConfigBase Conditional

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

zadLibs Property libs Auto

Perk Property zad_keyCraftingEasy Auto ; Obsolete, will remove later
Perk Property zad_keyCraftingHard Auto ; Obsolete, will remove later.
Int Property EscapeDifficulty = 4 Auto
Int Property CooldownDifficulty = 4 Auto
Int Property KeyDifficulty = 4 Auto
Bool Property GlobalDestroyKey = True Auto
Bool Property DisableLockJam = False Auto
int Property UnlockThreshold Auto
int Property ThresholdModifier Auto
float Property BeltRateMult = 1.5 Auto
float Property PlugRateMult = 3.0 Auto
int Property KeyCrafting Auto Conditional
bool Property NpcMessages = True Auto
bool Property PlayerMessages = True Auto
Float Property ArmbinderStruggleBaseChance = 5.0 Auto
Int Property ArmbinderMinStruggle = 5 Auto
Int Property YokeRemovalCostPerLevel = 200 Auto
bool Property LogMessages = True Auto
bool Property preserveAggro = True Auto
bool Property breastNodeManagement = false Auto
bool Property bellyNodeManagement = false Auto
bool Property UseItemManipulation = False Auto
bool Property UseBoundCombat = True Auto
bool Property UseBoundCombatPerks = True Auto
bool Property useBoundAnims =  true Auto
bool Property useAnimFilter =  true Auto
bool Property useAnimFilterCreatures =  true Auto
int Property blindfoldMode = 2 Auto
float Property blindfoldStrength = 0.5 Auto
int Property darkfogStrength = 500 Auto
int Property darkfogStrength2 Auto
int Property FurnitureNPCActionKey = 0xC9 Auto ; mapped to PgUp key
bool Property BlindfoldTooltip Auto
bool Property GagTooltip Auto
float Property EventInterval = 1.5 Auto
int Property EffectVibrateChance = 25 Auto
int Property EffectHealthDrainChance = 50 Auto
int Property EffectManaDrainChance = 50 Auto
int Property EffectStaminaDrainChance = 50 Auto
int Property BaseMessageChance = 10 Auto
int Property BaseHornyChance = 5 Auto
int Property BaseBumpPumpChance = 17 Auto
int Property numNpcs = 15 Auto Conditional
float Property VolumeOrgasm = 1.0 Auto
float Property VolumeEdged = 1.0 Auto
float Property VolumeVibrator = 0.5 Auto
float Property VolumeVibratorNPC = 0.25 Auto
int Property RubberSoundMode = 0 Auto
bool Property ForbiddenTome = true Auto
bool Property SergiusExperiment = true Auto
bool Property SurreptitiousStreets = false Auto
bool Property RadiantMaster = false Auto
int Property ssSleepChance = 100 Auto
int Property ssTrapChance = 100 Auto
bool Property ssWarningMessages = false Auto
float Property rmHeartbeatInterval = 2.0 Auto
float Property rmSummonHeartbeatInterval = 0.25 Auto
bool Property DevicesUnderneathEnabled = True Auto
Int Property DevicesUnderneathSlot = 12 Auto
int Property DevicesUnderneathSlotDefault = 12 Auto
bool Property UseQueueNiNode = False Auto
bool Property bootsSlowdownToggle = True Auto Conditional
bool Property mittensDropToggle = True Auto Conditional
Int Property HobbleSkirtSpeedDebuff = 50 Auto
bool Property debugSigTerm = False Auto
bool Property debugFixDevices = False Auto
bool property lockmenuwhentied = true Auto
bool Property RegisterDevices = False Auto
string[] Property EsccapeDifficultyList Auto
GlobalVariable Property zadDebugMode Auto

Function SetupBlindfolds()
EndFunction
Function SetupSoundDuration()
EndFunction
Function SetupEscapeDifficulties()
EndFunction
Function SetupDifficulties()
EndFunction
Function SetupPages()
EndFunction
Function SetupSlotMasks()
EndFunction
Event OnConfigInit()
EndEvent
int Function GetVersion()
EndFunction
Event OnVersionUpdate(int newVersion)
EndEvent
bool Function isWearingRestraints()	
endfunction
Event OnPageReset(string page)
EndEvent
Event OnOptionKeyMapChange(Int Option, Int keyCode, String conflictControl, String conflictName)
EndEvent
Event OnOptionMenuOpen(int option)
EndEvent
Function CheckRemovePerk(Perk perkName)
EndFunction
Function UpdateCraftingPerks(int index)
EndFunction
Event OnOptionMenuAccept(int option, int index)
EndEvent
Event OnOptionSliderOpen(int option)
EndEvent
Event OnOptionSelect(int option)
EndEvent
Event OnOptionDefault(int option)
EndEvent
Event OnOptionHighlight(int option)
EndEvent
Event OnOptionSliderAccept(int option, float value)
EndEvent
int function LookupSlotMask(int i)
EndFunction
function ExportInt(string Name, int Value)
endFunction
int function ImportInt(string Name, int Value)
endFunction
function ExportBool(string Name, bool Value)
endFunction
bool function ImportBool(string Name, bool Value)
endFunction
function ExportFloat(string Name, float Value)
endFunction
float function ImportFloat(string Name, float Value)
endFunction
function ExportDevicesUnderneath()
endFunction
function ImportDevicesUnderneath()
endFunction
function ExportEvents()
endFunction
function ImportEvents()
endFunction
function ExportSettings()
EndFunction
function ImportSettings()
EndFunction
