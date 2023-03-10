Scriptname zadLibs extends Quest

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

SexLabFramework property SexLab auto
slaUtilScr Property Aroused Auto
zadConfig Property Config Auto
zadNPCQuestScript Property zadNPCQuest Auto
zadEventSlots Property EventSlots Auto
zadDevicesUnderneathScript Property DevicesUnderneath Auto
Quest Property zadNPCSlots Auto
zadBoundCombatScript Property BoundCombat auto
Int Property TweenMenuKey Auto
bool Property Terminate Auto
zadexpressionlibs Property ExpLibs auto ;expression libs
Keyword Property zad_DeviousPlug Auto
Keyword Property zad_DeviousBelt Auto
Keyword Property zad_DeviousBra Auto
Keyword Property zad_DeviousCollar Auto
Keyword Property zad_DeviousArmCuffs Auto
Keyword Property zad_DeviousLegCuffs Auto
Keyword Property zad_DeviousArmbinder Auto
Keyword Property zad_DeviousArmbinderElbow Auto
Keyword Property zad_DeviousHeavyBondage Auto
Keyword Property zad_DeviousHobbleSkirt Auto
Keyword Property zad_DeviousHobbleSkirtRelaxed Auto
Keyword Property zad_DeviousAnkleShackles Auto
Keyword Property zad_DeviousStraitJacket Auto
Keyword Property zad_DeviousCuffsFront Auto
Keyword Property zad_DeviousPetSuit Auto
Keyword Property zad_DeviousYoke Auto
Keyword Property zad_DeviousYokeBB Auto
Keyword Property zad_DeviousCorset Auto
Keyword Property zad_DeviousClamps Auto
Keyword Property zad_DeviousGloves Auto
Keyword Property zad_DeviousHood Auto
Keyword Property zad_DeviousSuit Auto
Keyword Property zad_DeviousElbowTie Auto
Keyword Property zad_DeviousGag Auto
Keyword Property zad_DeviousGagLarge Auto
Keyword Property zad_DeviousGagPanel Auto
Keyword Property zad_DeviousPlugVaginal Auto
Keyword Property zad_DeviousPlugAnal Auto
Keyword Property zad_DeviousHarness Auto
Keyword Property zad_DeviousBlindfold Auto
Keyword Property zad_DeviousBoots Auto
Keyword Property zad_Lockable Auto
Keyword Property zad_DeviousPiercingsNipple Auto
Keyword Property zad_DeviousPiercingsVaginal Auto
Keyword Property zad_DeviousBondageMittens Auto
Keyword Property zad_DeviousPonyGear Auto
Keyword Property zad_PermitOral Auto
Keyword Property zad_PermitAnal Auto
Keyword Property zad_PermitVaginal Auto

Keyword Property zad_InventoryDevice Auto
Keyword Property zad_BlockGeneric Auto
Keyword Property zad_QuestItem Auto

Keyword Property zad_BraNoBlockPiercings Auto
Keyword Property zad_GagNoOpenMouth Auto
Keyword Property zad_GagCustomExpression Auto

Keyword Property zad_BoundCombatDisableKick Auto

Keyword Property zad_NonUniqueKey Auto		; A key tagged with this keyword will be consumed by the global Destroy Key feature, if enabled by the user.

Keyword Property zad_BlockGenericEvents Auto
Keyword Property zad_ExposedBreasts Auto

; All standard devices, at this time. Shorthand for mods, and to avoid the hassle of re-adding these as properties for other scripts.
; If you're using a custom device, you'll need to use EquipDevice, rather than the shorthand ManipulateDevice.
Armor Property beltPaddedRendered Auto         ; Internal Device
Armor Property beltPadded Auto        	       ; Inventory Device
Armor Property beltIronRendered Auto         ; Internal Device
Armor Property beltIron Auto        	     ; Inventory Device
Armor Property plugIronRendered Auto         ; Internal Device
Armor Property plugIron Auto        	     ; Inventory Device
Armor Property plugPrimitiveRendered Auto         ; Internal Device
Armor Property plugPrimitive Auto        	  ; Inventory Device
Armor Property plugInflatableRendered Auto         ; Internal Device
Armor Property plugInflatable Auto        	   ; Inventory Device
Armor Property plugSoulgemRendered Auto         ; Internal Device
Armor Property plugSoulgem Auto        		; Inventory Device
Armor Property braPaddedRendered Auto         ; Internal Device
Armor Property braPadded Auto        	      ; Inventory Device
Armor Property cuffsPaddedArmsRendered Auto         ; Internal Device
Armor Property cuffsPaddedArms Auto        	    ; Inventory Device
Armor Property cuffsPaddedLegsRendered Auto         ; Internal Device
Armor Property cuffsPaddedLegs Auto        	    ; Inventory Device
Armor Property cuffsPaddedCollarRendered Auto         ; Internal Device
Armor Property cuffsPaddedCollar Auto        	      ; Inventory Device
Armor Property cuffsPaddedCompleteRendered Auto         ; Internal Device
Armor Property cuffsPaddedComplete Auto        		; Inventory Device
Armor Property collarPostureRendered Auto         ; Internal Device
Armor Property collarPosture Auto        	  ; Inventory Device
Armor Property armbinderRendered Auto         ; Internal Device
Armor Property armbinder Auto        	  ; Inventory Device
Armor Property zad_armBinderHisec_Rendered Auto
Armor Property zad_armBinderHisec_Inventory Auto
Armor Property gagBall Auto
Armor Property gagBallRendered Auto
Armor Property gagPanel Auto
Armor Property gagPanelRendered Auto
Armor Property gagRing Auto
Armor Property gagRingRendered Auto

Armor Property gagStrapBall Auto                   ; Inventory Device
Armor Property gagStrapBallRendered Auto           ; Internal Device
Armor Property gagStrapRing Auto                   ; Inventory Device
Armor Property gagStrapRingRendered Auto           ; Internal Device
Armor Property blindfold Auto                        ; Inventory Device
Armor Property blindfoldRendered Auto                ; Internal Device
Armor Property cuffsLeatherArms Auto                 ; Inventory Device
Armor Property cuffsLeatherArmsRendered Auto         ; Internal Device
Armor Property cuffsLeatherLegs Auto                 ; Inventory Device
Armor Property cuffsLeatherLegsRendered Auto         ; Internal Device
Armor Property cuffsLeatherCollar Auto               ; Inventory Device
Armor Property cuffsLeatherCollarRendered Auto       ; Internal Device
Armor Property harnessBody Auto                          ; Inventory Device
Armor Property harnessBodyRendered Auto                  ; Internal Device
Armor Property harnessCollar Auto                  ; Inventory Device
Armor Property harnessCollarRendered Auto          ; Internal Device
Armor Property collarPostureLeather Auto
Armor Property collarPostureLeatherRendered Auto

Armor Property plugIronVag Auto                  ; Internal Device
Armor Property plugIronVagRendered Auto          ; Internal Device
Armor Property plugIronAn Auto                  ; Internal Device
Armor Property plugIronAnRendered Auto          ; Internal Device
Armor Property plugPrimitiveVag Auto                  ; Internal Device
Armor Property plugPrimitiveVagRendered Auto          ; Internal Device
Armor Property plugPrimitiveAn Auto                  ; Internal Device
Armor Property plugPrimitiveAnRendered Auto          ; Internal Device
Armor Property plugSoulgemVag Auto                  ; Internal Device
Armor Property plugSoulgemVagRendered Auto          ; Internal Device
Armor Property plugSoulgemAn Auto                  ; Internal Device
Armor Property plugSoulgemAnRendered Auto          ; Internal Device
Armor Property plugInflatableVag Auto                  ; Internal Device
Armor Property plugInflatableVagRendered Auto          ; Internal Device
Armor Property plugInflatableAn Auto                  ; Internal Device
Armor Property plugInflatableAnRendered Auto          ; Internal Device
Armor Property beltPaddedOpen Auto        	       ; Inventory Device
Armor Property beltPaddedOpenRendered Auto         ; Internal Device
Armor Property plugChargeableVag Auto
Armor Property plugChargeableRenderedVag Auto
Armor Property plugTrainingVag Auto
Armor Property plugTrainingRenderedVag Auto

Armor Property collarRestrictive Auto
Armor Property collarRestrictiveRendered Auto
Armor Property corset Auto
Armor Property corsetRendered Auto
Armor Property glovesRestrictive Auto
Armor Property glovesRestrictiveRendered Auto
Armor Property yoke Auto
Armor Property yokeRendered Auto

Armor Property piercingVSoul Auto
Armor Property piercingVSoulRendered Auto
Armor Property piercingNSoul Auto
Armor Property piercingNSoulRendered Auto

; Keys
Key Property chastityKey Auto
Key Property restraintsKey Auto
Key Property piercingKey Auto ; Piercing removal tool

; Sound fx
Sound Property VibrateVeryStrongSound Auto
Sound Property VibrateStrongSound Auto
Sound Property VibrateStandardSound Auto
Sound Property VibrateWeakSound Auto
Sound Property VibrateVeryWeakSound Auto
Sound Property EdgedSound Auto
Sound Property OrgasmSound  Auto
Sound Property MoanSound Auto
Sound Property GaggedSound Auto
Sound Property ShortMoanSound Auto
Sound Property ShortPantSound Auto

; Idles
Idle Property DD_FT_Unconcious Auto
Idle Property DD_FT_Surrender Auto
Idle Property DD_FT_Surrender_Hobbled Auto
Idle Property DD_FT_Bleedout_Armbinder Auto
Idle Property DD_FT_Bleedout_BBYoke Auto
Idle Property DD_FT_Bleedout_Elbowbinder Auto
Idle Property DD_FT_Bleedout_Frontcuffs Auto
Idle Property DD_FT_Bleedout_Yoke Auto
Idle Property DD_FT_CollarMe Auto
Idle Property DD_FT_Egyptian Auto
Idle Property DD_FT_Inspection Auto

Package Property zad_pk_surrender Auto
Package Property zad_pk_surrender_hobbled Auto
Package Property zad_pk_collarme Auto
Package Property zad_pk_egyptian Auto
Package Property zad_pk_inspection Auto

; Dialogue disable
GlobalVariable Property DialogueGagDisable Auto
GlobalVariable Property DialogueArmbinderDisable Auto

; Factions
Faction Property zadAnimatingFaction Auto
Faction Property zadVibratorFaction Auto
Faction Property zadGagPanelFaction Auto
Faction Property zadDisableDialogueFaction Auto

MiscObject Property zad_gagPanelPlug Auto
Outfit Property zadEmptyOutfit Auto

;Default Message for the new escape system to use as a fallback in case a legacy device doesn't have one defined.
Message Property zad_DeviceEscapeMsg Auto	; Device escape message
GlobalVariable Property zadDeviceEscapeSuccessCount Auto ; counter for succesful escape attempts
MiscObject Property Lockpick Auto
FormList Property zad_DD_StandardCuttingToolsList Auto		; List of allowed cutting tools
Message Property zad_DD_EscapeDeviceMSG Auto 				; Device escape dialogue. You can customize it if you want, but make sure not to change the order and functionality of the buttons.
Message Property zad_DD_OnEquipDeviceMSG Auto 				; Message is displayed upon device equip (dialogue only)
Message Property zad_DD_OnNoKeyMSG Auto 	 				; Message is displayed when the player has no key
Message Property zad_DD_OnNotEnoughKeysMSG	Auto 			; Message is displayed when the player has not enough keys
Message Property zad_DD_OnLeaveItNotWornMSG Auto 	 		; Message is displayed when the player clicks the "Leave it Alone" button while not wearing the device.
Message Property zad_DD_OnLeaveItWornMSG Auto 		 		; Message is displayed when the player clicks the "Leave it Alone" button while wearing the device.
Message Property zad_DD_KeyBreakMSG Auto 	 				; Message is displayed when a key breaks while trying to unlock this device.
Message Property zad_DD_KeyBreakJamMSG Auto 				; Message is displayed when a key breaks and gets stuck in the lock when trying to unlock this device.
Message Property zad_DD_UnlockFailJammedMSG	Auto 			; Message displayed when a player tries to unlock a jammed device.
Message Property zad_DD_RepairLockNotJammedMSG Auto 		; Message displayed when a player tries to repair a device that's not jammed.
Message Property zad_DD_RepairLockMSG Auto 					; Message displayed when a player tries to repair a lock.
Message Property zad_DD_RepairLockSuccessMSG Auto 			; Message displayed when a player successfully tries to repair a lock.
Message Property zad_DD_RepairLockFailureMSG Auto 			; Message displayed when a player fails to repair a lock.
Message Property zad_DD_EscapeStruggleMSG Auto 				; Message to be displayed when the player tries to struggle out of a restraint
Message Property zad_DD_EscapeStruggleFailureMSG Auto 		; Message to be displayed when the player fails to struggle out of a restraint
Message Property zad_DD_EscapeStruggleSuccessMSG Auto 		; Message to be displayed when the player succeeds to struggle out of a restraint
Message Property zad_DD_EscapeLockPickMSG Auto 				; Message to be displayed when the player tries to pick a restraint
Message Property zad_DD_EscapeLockPickFailureMSG Auto 		; Message to be displayed when the player fails to pick a restraint
Message Property zad_DD_EscapeLockPickSuccessMSG Auto 		; Message to be displayed when the player succeeds to pick a restraint
Message Property zad_DD_EscapeCutMSG Auto 					; Message to be displayed when the player tries to cut a restraint
Message Property zad_DD_EscapeCutFailureMSG Auto 			; Message to be displayed when the player fails to cut a restraint
Message Property zad_DD_EscapeCutSuccessMSG Auto 			; Message to be displayed when the player succeeds to cut open a restraint
Message Property zad_DD_OnPutOnDevice Auto					; Message to be displayed when the player locks on an item, so she can manipulate the locks if she choses.

; Internal Variables
Armor Property deviceRemovalToken Auto         ; Internal token for removal events
Bool Property DeviceMutex Auto ; Prevent oddities when swapping sets of items quickly.
Bool Property GlobalEventFlag Auto ; Events enabled/disabled, globally. Useful for scenes that don't want to be interrupted.
bool Property RepopulateMutex Auto ; Avoid 2.6.3 bug
Float Property lastRepopulateTime Auto ; Avoid 2.6.3 bug
; Misc
Actor Property PlayerRef Auto
Faction Property SexLabAnimatingFaction Auto
Spell Property ShockEffect Auto
Float Property SpellCastVibrateCooldown Auto
Spell Property zad_splMagickaPenalty Auto
bool Property BoundAnimsAvailable = True Auto ; Obsolete. Bound anims are now always available, post zap 6
FormList Property zadStandardKeywords Auto
Keyword Property questItemRemovalAuthorizationToken = None Auto
FormList Property zadDeviceTypes Auto	; List of all main device type keywords. Useful for iterating functions.
FormList Property zad_AlwaysSilent Auto	; Actors in this list will ALWAYS equip or unequip DD items silently.


; Rechargeable Soulgem Stuff
Soulgem Property SoulgemEmpty Auto
Soulgem Property SoulgemFilled Auto
MiscObject Property SoulgemStand Auto
Perk Property LustgemCrafting Auto

; Inflatable Plugs
Keyword Property zad_kw_InflatablePlugAnal Auto
Keyword Property zad_kw_InflatablePlugVaginal Auto
GlobalVariable Property zadInflatablePlugStateAnal Auto
GlobalVariable Property zadInflatablePlugStateVaginal Auto
Float Property LastInflationAdjustmentVaginal = 0.0 Auto
Float Property LastInflationAdjustmentAnal = 0.0 Auto
Message Property zad_PlugsConfirmMSG Auto
Message Property zad_PlugsDeflatePumpsFail Auto

; Nipple Piercings
Perk Property PiercedNipples Auto
Perk Property PiercedClit Auto

Spell Property PiercedNipplesSpell Auto
Spell Property PiercedClitSpell Auto

;;;;Effects
Keyword Property zad_HasPumps Auto

; stuff for NPC interaction

Keyword Property ActorTypeNPC Auto
Keyword Property ActorTypeAnimal Auto
Keyword Property ActorTypeCreature Auto
Race Property ManakinRace Auto
Faction Property currentfollowerfaction Auto
Keyword Property ActorTypeDwarven Auto
Faction Property dunPrisonerFaction Auto
Faction Property isGuardFaction Auto
Race Property ElderRace Auto
Keyword Property isBeastRace Auto

; Keywords for Device Effects
Keyword Property zad_EffectVibratingVeryStrong Auto
Keyword Property zad_EffectVibratingStrong Auto
Keyword Property zad_EffectVibrating Auto
Keyword Property zad_EffectVibratingWeak Auto
Keyword Property zad_EffectVibratingVeryWeak Auto
Keyword Property zad_EffectVibratingRandom Auto
Keyword Property zad_EffectVibrateOnSpellCast Auto
Keyword Property zad_EffectTrainOnSpellCast Auto
Keyword Property zad_EffectElectroStim Auto

Keyword Property zad_EffectHealthDraining Auto
Keyword Property zad_EffectStaminaDraining Auto
Keyword Property zad_EffectManaDraining Auto

Keyword Property zad_EffectShocking Auto ; Periodically shock actor.
Keyword Property zad_EffectChaosPlug Auto ; Coopervane's Random Plug.
Keyword Property zad_EffectShockOnFullArousal Auto ; Instead of vibrating, shock on full arousal.

 ; Effect modifiers
Keyword Property zad_EffectPossessed Auto ; Plugs will function stand-alone if this keyword is present.
Keyword Property zad_EffectRemote Auto

Keyword Property zad_EffectLively Auto       ; Increase chance of effect beyond mcm config.
Keyword Property zad_EffectVeryLively Auto   ; Further increase chance of effect. Stacks.

Keyword Property zad_EffectEdgeOnly Auto    ; Will never let the player cum for stimulating events (Vibration)
Keyword Property zad_EffectEdgeRandom Auto    ; Will sometimes let the player cum for stimulating events (Vibration)

Keyword Property zad_EffectsLinked Auto      ; If one effect fires, all effects fire.
Keyword Property zad_EffectCompressBreasts Auto ; Compress breasts to avoid hdt clipping through bras.
Keyword Property zad_NoCompressBreasts Auto ; Disable Compressing of breasts, despite previous keyword
Keyword Property zad_EffectCompressBelly Auto ; Compress belly to avoid hdt clipping through corsets, belts and harnesses.
Keyword Property zad_NoCompressBelly Auto ; Disable Compressing of belly, despite previous keyword
Keyword Property zad_EffectForcedWalk Auto ; Responsible for muting encumberance messages on reload, related to the zadx_ForcedWalk magiceffect

Bool Function LockDevice(actor akActor, armor deviceInventory, bool force = false)
EndFunction
Bool Function UnlockDevice(actor akActor, armor deviceInventory, armor deviceRendered = none, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = false)
EndFunction
Bool Function SwapDevices(actor akActor, armor deviceInventory, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = true)
EndFunction
Bool Function UnlockDeviceByKeyword(actor akActor, keyword zad_DeviousDevice, bool destroyDevice = false)
EndFunction
Function RemoveQuestDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, keyword RemovalToken, bool destroyDevice=false, bool skipMutex=false)
EndFunction
int Function IsWearingDevice(actor akActor, armor deviceRendered, keyword zad_DeviousDevice)
EndFunction
Bool Function TightenDevice(actor akActor, armor deviceInventory)
EndFunction
Bool Function UntightenDevice(actor akActor, armor deviceInventory)
EndFunction
Bool Function CanTightenDevice(actor akActor, armor deviceInventory)
EndFunction
Bool Function CanUntightenDevice(actor akActor, armor deviceInventory)
EndFunction
Int Function IsLockJammed(actor akActor, keyword zad_DeviousDevice)
EndFunction
Bool Function JamLock(actor akActor, keyword zad_DeviousDevice)
EndFunction
Bool Function UnJamLock(actor akActor, keyword zad_DeviousDevice)
EndFunction
Int Function GetSlotMaskForDeviceType(Keyword kw)
EndFunction
Armor Function GetWornRenderedDeviceByKeyword(Actor a, Keyword kw)
EndFunction
Bool Function IsGenericDevice(Actor a, Keyword kw)
EndFunction
Bool Function IsLockManipulated(Actor a, Keyword kw)
EndFunction
Bool Function SetLockManipulated(Actor a, Keyword kw)
EndFunction
Bool Function SetLockUnManipulated(Actor a, Keyword kw)
EndFunction
sslBaseAnimation[] function SelectValidDDAnimations(Actor[] actors, int count, bool forceaggressive = false, string includetag = "", string suppresstag = "")
EndFunction
Bool Function StartValidDDAnimation(Actor[] SexActors, bool forceaggressive = false, string includetag = "", string suppresstag = "", Actor victim = None, Bool allowbed = False, string hook = "", bool nofallbacks = false)
EndFunction
Armor Function GetWornDevice(Actor akActor, Keyword kw)
EndFunction
String Function GetDeviceName(armor device)
EndFunction
Armor Function GetWornDeviceFuzzyMatch(Actor akActor, Keyword kw)
EndFunction
Key Function GetDeviceKey(armor device)
EndFunction
Keyword Function GetDeviceKeyword(armor device)
EndFunction
Armor Function GetRenderedDevice(armor device)
EndFunction
Bool Function isWearingDeviceType(Actor akActor, Keyword kw)
EndFunction
Function PlayHornyAnimation(actor akActor)
EndFunction
Function Orgasm(actor akActor)
EndFunction
Function SendInflationEvent(Actor who, Bool PlugisVaginal, Bool WasInflated, Int PlugState)	
EndFunction
Function InflateAnalPlug(actor akActor, int amount = 1)	
EndFunction
Function InflateVaginalPlug(actor akActor, int amount = 1)	
EndFunction
Function InflateRandomPlug(actor akActor, int amount = 1)
EndFunction
Function DeflateVaginalPlug(actor akActor, int amount = 1)	
EndFunction
Function DeflateAnalPlug(actor akActor, int amount = 1)	
EndFunction
bool Function ValidForInteraction(actor currenttest, int genderreq = -1, bool creatureok = false, bool animalok = false, bool beastreaceok = false, bool elderok = false, bool guardok = true)
EndFunction
int Function ArousalThreshold(string index)
EndFunction
Function EnableEventProcessing()
EndFunction
Function DisableEventProcessing()
EndFunction
Bool Function AllowGenericEvents(Actor a, Keyword kw)
EndFunction
Bool Function HasBreastsExposed(Actor a)
EndFunction
bool[] Function StartThirdPersonAnimation(actor akActor, string animation, bool permitRestrictive=false)
EndFunction
Function PlayThirdPersonAnimation(actor akActor, string animation, int duration, bool permitRestrictive=false)
EndFunction
Function EndThirdPersonAnimation(actor akActor, bool[] cameraState, bool permitRestrictive=false)
EndFunction
float Function GetVersion()
EndFunction
String Function GetVersionString()
EndFunction
Function StoreExposureRate(actor akActor)
EndFunction
float Function GetOriginalRate(actor akActor)
EndFunction
float Function GetModifiedRate(actor akActor)
EndFunction
bool function CheckConfigInit()
EndFunction
float function GetPlugRateMult()
EndFunction
float function GetBeltRateMult()
EndFunction
Function Notify(string out, bool messageBox=false)
EndFunction
Function NotifyNPC(string out, bool messageBox=false)
EndFunction
Function NotifyPlayer(string out, bool messageBox=false)
EndFunction
Function NotifyActor(string out, Actor akActor, bool messageBox=false)
EndFunction
Function Log(string in, int level=0)
EndFunction
Function Warn(string in)
EndFunction
Function Error(string in)
EndFunction
bool Function WearingConflictingDevice(actor akActor, armor deviceRendered, keyword zad_DeviousDevice)
EndFunction
Function UpdateExposure(actor akRef, float val, bool skipMultiplier=false)
EndFunction
Function AcquireAndSpinlock()
EndFunction
Function SendDeviceRemovalEvent(string deviceName, actor akActor)
EndFunction
Function SendDeviceEquippedEvent(string deviceName, actor akActor)
EndFunction
Function SendDeviceEvent(string eventName, string actorName, int isPlayer)
EndFunction
Function SendDeviceEquippedEventVerbose(armor inventoryDevice, keyword deviceKeyword, actor akActor)	
EndFunction
Function SendDeviceRemovedEventVerbose(armor inventoryDevice, keyword deviceKeyword, actor akActor)
EndFunction
Function SendDeviceKeyBreakEventVerbose(armor inventoryDevice, keyword deviceKeyword, actor akActor)	
EndFunction
Function SendDeviceJamLockEventVerbose(armor inventoryDevice, keyword deviceKeyword, actor akActor)	
EndFunction
Function SendDeviceEscapeEvent(armor inventoryDevice, keyword deviceKeyword, bool successful)	
EndFunction
Function SendQuestSigTerm()	
EndFunction
FormList Property zadTemporaryDeviceStorage Auto
Function DDI_DebugFixDevices()
EndFunction
Function DDI_DebugTerminate()
EndFunction
function Masturbate(actor a, bool feedback = false)	
EndFunction
Function SendOrgasmEvent(Actor akActor, int aiArousalSet = -1)
EndFunction
Function ActorOrgasm(actor akActor, int setArousalTo=-1, int vsID=-1)
EndFunction
Function Pant(actor akActor)
EndFunction
Function SexlabMoan(actor akActor, int arousal=-1, sslBaseVoice voice = none)
EndFunction
Function Moan(actor akActor, int arousal=-1, sslBaseVoice voice = none)
EndFunction
bool Function PlaySceneAndWait(Scene toPlay, bool forceStart=false, int timeout=120, int increment=5)
EndFunction
Function SendEdgeEvent(Actor akActor)
EndFunction
Function EdgeActor(actor akActor)
EndFunction
float Function GetMoanVolume(actor akActor, int exposure = -1)
EndFunction
function DoApplyExpression(int[] presets, actor ActorRef, bool hasGag = false) global
endFunction
Function ApplyExpression(Actor akActor, sslBaseExpression expression, int strength, bool openMouth=false)
EndFunction
Function ResetExpression(actor akActor, sslBaseExpression expression)
EndFunction
Function ApplyExpression_v2(Actor akActor, sslBaseExpression expression,int iPriority, int strength = 100,bool openMouth=false)
EndFunction
Function ApplyExpressionRaw(Actor akActor, float[] expression ,int iPriority, int strength = 100,bool openMouth=false)
EndFunction
Function ResetExpressionRaw(actor akActor, int iPriority)
EndFunction
string function GetVibrationStrength(int vibStrength)
EndFunction
string Function BuildVibrationString(actor akActor, int vibStrength, bool vPlug, bool aPlug, bool vPiercings, bool nPiercings)
EndFunction
string Function BuildPostVibrationString(actor akActor, int vibStrength, bool vPlug, bool aPlug, bool vPiercings, bool nPiercings)
EndFunction
int Function VibrateEffect(actor akActor, int vibStrength, int duration, bool teaseOnly=false, bool silent = false)
EndFunction
Function AttrDrain(actor akActor, string attr)
EndFunction
Function HealthDrainEffect(actor akActor)
EndFunction
Function ManaDrainEffect(actor akActor)
EndFunction
Function StaminaDrainEffect(actor akActor)
EndFunction
Bool Function ShouldEdgeActor(actor akActor)
EndFunction
Bool Function ActorHasKeyword(actor akActor, keyword kwd)
EndFunction
Function ApplyMagickaPenalty(actor akActor)
EndFunction
Function SpellCastVibrate(Actor akActor, Form tmp)
EndFunction
bool Function IsValidActor(actor akActor)
EndFunction
Function DisableControls()
EndFunction
Function UpdateControls()
EndFunction
bool Function IsAnimating(actor akActor)
EndFunction
Function SetAnimating(actor akActor, bool isAnimating=true)
EndFunction
bool Function IsVibrating(actor akActor)
EndFunction
Function SetVibrating(actor akActor, int duration)
EndFunction
Function StopVibrating(actor akActor)
EndFunction
int Function GetVibrating(actor akActor)
EndFunction
Function ApplyGagEffect(actor akActor)
EndFunction
Function ApplyGagEffect_v2(actor akActor,Int[] apGagExp,Faction[] apGagModFactions)
EndFunction
Function RemoveGagEffect(actor akActor)
EndFunction
Function SendGagEffectEvent(actor akActor, bool isRemove)
EndFunction
string Function MakeSingularIfPlural(string theString)
EndFunction
String Function AnimSwitchKeyword(actor akActor, string idleName )
EndFunction
Function RepopulateNpcs()
EndFunction
Function PlugPanelGag(actor akActor)
EndFunction
Function UnPlugPanelGag(actor akActor)
EndFunction
bool Function IsBound(actor akActor)
EndFunction
bool Function NeedsBoundAnim(actor akActor)
EndFunction
Function ToggleCompass(bool show)
EndFunction
Function TrainingViolation(actor akActor, string violation)
EndFunction
Function ShockActor(actor akActor)
EndFunction
Form Function GetRenderedDeviceInstance(actor akActor, int Slot, Keyword kwd)
EndFunction
Form Function GetWornHeavyBondageInstance(actor akActor)
EndFunction
Function UpdateArousalTimerate(actor akActor, float val)
EndFunction
Function ChastityBeltStruggle(actor akActor)
EndFunction
Function Trip(actor akActor)
EndFunction
Function CatchBreath(actor akActor)
EndFunction
Function ApplyBoundAnim(actor akActor, idle theIdle = None)
EndFunction
Function PauseDialogue()
EndFunction
Function ResumeDialogue()
EndFunction
Function ResetDialogue()
EndFunction
Function AddToDisableDialogueFaction(Actor akActor)
EndFunction
Function RemoveFromDisableDialogueFaction(Actor akActor)
EndFunction
Function HideBreasts(actor akActor)
EndFunction
Function ShowBreasts(actor akActor)
EndFunction
Function HideBelly(actor akActor)
EndFunction
Function ShowBelly(actor akActor)
EndFunction
Function SetNodeHidden(Actor akActor, bool isFemale, string nodeName, bool value, string modkey = "DDi")
EndFunction
string Function LookupDeviceType(keyword kwd)
EndFunction
function strip(actor a, bool animate = false)
EndFunction
bool function hasAnyWeaponEquipped(actor a)
EndFunction
function stripweapons(actor a, bool unequiponly = true)		
endfunction
Event StartBoundEffects(Actor akTarget)
EndEvent
Event StopBoundEffects(Actor akTarget)
EndEvent
Event OnUpdate()
EndEvent
Function PlayBoundIdle()
EndFunction
Bool Function UseRubberSounds()
EndFunction
Float Function GetRubberSoundOffset()
EndFunction
Function UnsetStoredDevice(actor akActor, keyword zad_DeviousDevice)
EndFunction
Function RestoreSettings(actor akActor)
EndFunction
Function MuteOverEncumberedMSG()
EndFunction
Function EquipDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool skipEvents=false, bool skipMutex=false)			
EndFunction
Function RemoveDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool destroyDevice=false, bool skipEvents=false, bool skipMutex=false)	
EndFunction
bool Function ManipulateGenericDevice(actor akActor, armor device, bool equipOrUnequip, bool skipEvents = false , bool skipMutex = false)
EndFunction
bool Function ManipulateGenericDeviceByKeyword(Actor akActor, Keyword kw, bool equipOrUnequip, bool skipEvents = false, bool skipMutex = false)
EndFunction
Bool Function ForceEquipDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool skipEvents=false, bool skipMutex = True)	
EndFunction
Function ManipulateDevice(actor akActor, armor device, bool equipOrUnequip, bool skipEvents = false)
EndFunction
Function RegisterDevices()
EndFunction
Function RegisterGenericDevice(Armor inventoryDevice, String tags)
EndFunction
Armor Function GetGenericDeviceByKeyword(Keyword kw)
EndFunction
Armor Function GetDeviceByTags(Keyword kw, String tags, bool requireAll = true, String tagsToSuppress = "", bool fallBack = true)
EndFunction
bool Function HasTag(Armor item, String tag)
EndFunction
bool Function HasTags(Armor item, String[] tags, bool requireAll = true)
EndFunction
Function CorsetMagic(actor akActor)
EndFunction
bool Function UpdateCorsetState(actor akActor)
EndFunction