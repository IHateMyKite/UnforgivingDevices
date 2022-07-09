Scriptname UDCustomDeviceMain extends Quest  conditional

import UnforgivingDevicesMain

Spell Property SwimPenaltySpell auto
UnforgivingDevicesMain Property UDmain auto
UD_ParalelProcess Property UDPP auto
UD_libs Property UDlibs auto
zadlibs Property libs auto
zadlibs_UDPatch Property libsp hidden
	zadlibs_UDPatch Function get()
		return libs as zadlibs_UDPatch
	EndFunction
EndProperty
zadxlibs Property libsx hidden
	zadxlibs Function get()
		return UDmain.libsx
	EndFunction
EndProperty
zadxlibs2 Property libsx2 hidden
	zadxlibs2 Function get()
		return UDmain.libsx2
	EndFunction
EndProperty
UD_Patcher Property UDPatcher auto
UD_DialogueMain Property UDDmain auto
UD_CustomDevices_NPCSlotsManager Property UDCD_NPCM auto
UD_ExpressionManager Property UDEM auto
UD_OrgasmManager Property UDOM auto 

;UI menus
UITextEntryMenu Property TextMenu auto
UIListMenu Property ListMenu auto

bool Property UD_HardcoreMode = true auto hidden

;keys
Int Property Stamina_meter_Keycode 	= 32 	auto hidden
int property StruggleKey_Keycode 	= 52 	auto hidden
Int Property Magicka_meter_Keycode 	= 30 	auto hidden
Int Property SpecialKey_Keycode 	= 31 	auto hidden
Int Property PlayerMenu_KeyCode 	= 40 	auto hidden
int property ActionKey_Keycode 		= 18 	auto hidden

int Property NPCMenu_Keycode		= 39	auto hidden

bool Property UD_UseDDdifficulty 	= True  auto hidden
bool Property UD_UseWidget 			= True  auto hidden

int Property UD_GagPhonemModifier 	= 50 	auto hidden

int OSLLoadOrderRelative = 0
int SLALoadOrder = 0
perk[] DesirePerks

Int Property UD_StruggleDifficulty = 1 auto hidden
float Property UD_BaseDeviceSkillIncrease = 35.0 auto hidden
float Property UD_CooldownMultiplier = 1.0 auto hidden
Bool Property UD_AutoCrit = False auto hidden
Int Property UD_AutoCritChance = 80 auto hidden
Int Property UD_MinigameHelpCd = 45 auto
Float Property UD_MinigameHelpCD_PerLVL = 15.0 auto;CD % decrease per Helper LVL
Int Property UD_MinigameHelpXPBase = 35 auto
Float Property UD_MutexTimeOutTime = 1.0 auto
Float Property UD_LockUnlockMutexTimeOutTime = 15.0 auto hidden
bool Property UD_AllowArmTie = true auto hidden
bool Property UD_AllowLegTie = true auto hidden

;changes how much is strength converted to orgasm rate, 
;example: if UD_VibrationMultiplier = 0.1 and vibration strength will be 100, orgasm rate will be 100*0.1 = 10 O/s 
float 	Property UD_VibrationMultiplier 	= 0.10	auto hidden
float 	Property UD_ArousalMultiplier 	    = 0.05	auto hidden

UD_PlayerSlotScript Property UD_PlayerSlot auto

;factions
Faction Property zadGagPanelFaction Auto
Faction Property FollowerFaction auto
Faction Property RegisteredNPCFaction auto
Faction Property MinigameFaction auto
Faction Property PlayerFaction auto

Faction Property BlockExpressionFaction auto
Faction Property BlockAnimationFaction auto
Faction Property BussyFaction auto

Faction Property VibrationFaction auto

FormList Property UD_AgilityPerks auto
FormList Property UD_StrengthPerks auto
FormList Property UD_MagickPerks auto

MiscObject Property zad_GagPanelPlug Auto

float 	Property UD_StruggleExhaustionMagnitude = 60.0 	auto hidden;magnitude of exhaustion, 50.0 will reduce player stats regen modifier by 50%. This cant make regen negative
int 	Property UD_StruggleExhaustionDuration 	= 10 	auto hidden;How long will debuff last

;messages
Message Property DebugMessage auto
Message Property StruggleMessage auto
Message Property StruggleMessageNPC auto
Message Property DetailsMessage auto
Message Property VibDetailsMessage auto
Message Property ControlablePlugVibMessage auto
Message Property ControlablePlugModMessage auto

Message Property DefaultLockMenuMessage auto
Message Property DefaultLockMenuMessageWH auto

;DEFAULT MENUS
Message Property DefaultEquipDeviceMessage auto
Message Property DefaultInteractionDeviceMessage auto
Message Property DefaultInteractionDeviceMessageWH auto
Message Property DefaultInteractionPlugMessage auto
Message Property DefaultInteractionPlugMessageWH auto

;SPECIAL MENUS
Message Property DefaultCTRPlugSpecialMsg auto
Message Property DefaultCTRPlugSpecialMsgWH auto
Message Property DefaultINFPlugSpecialMsg auto
Message Property DefaultINFPlugSpecialMsgWH auto
Message Property DefaultPanelGagSpecialMsg auto
Message Property DefaultPanelGagSpecialMsgWH auto
Message Property DefaultAbadonPlugSpecialMsg auto
Message Property DefaultAbadonPlugSpecialMsgWH auto
Message Property DefaultDynamicHBSpecialMsg auto
Message Property DefaultVibratorSpecialMsg auto

;DEBUG MENUS
Message Property PlayerMenuMsg auto
Message Property NPCDebugMenuMsg auto

ObjectReference Property LockPickContainer_ObjRef auto
ObjectReference _LockPickContainer
Container Property LockPickContainer auto

ObjectReference Property EventContainer_ObjRef auto
ObjectReference Property TransfereContainer_ObjRef auto

ReferenceAlias Property MessageActor1 auto
ReferenceAlias Property MessageActor2 auto
ReferenceAlias Property MessageDevice auto
UD_MutexScript Property MutexSlot auto

;int Property UD_SlotsNum = 20 AutoReadOnly
;UD_CustomDevice_RenderScript[] Property UD_equipedCustomDevices auto
MiscObject 	Property Lockpick auto
Int			Property UD_LockpicksPerMinigame = 2 auto hidden

Formlist Property UD_QuestKeywords auto
FormList Property UD_HeavyBondageKeywords auto
;Spell Property TelekinesisSpell auto

UDCustomHeavyBondageWidget1 Property widget1 auto
UD_WidgetBase Property widget2 auto

Bool Property UD_EquipMutex = False auto hidden
Bool Property Ready = False auto hidden
Bool Property EventsReady = false auto hidden

Event OnInit()
	While !UDPatcher.ready
		Utility.WaitMenuMode(0.1)
	EndWhile
	if TraceAllowed()	
		Log("UDPatcher ready!",0)	
	endif
	While !UDCD_NPCM.ready
		Utility.WaitMenuMode(0.1)
	EndWhile
	if TraceAllowed()	
		Log("UDCD_NPCM ready!",0)
	endif
	While !UDEM.ready
		Utility.WaitMenuMode(0.1)
	endwhile
	if TraceAllowed()	
		Log("UDEM ready!",0)
	endif

	registerEvents()
	
	registerForSingleUpdate(5.0)
	RegisterForSingleUpdateGameTime(1.0)
	if TraceAllowed()	
		Log("UDCustomDeviceMain ready!",0)
	endif
	ready = True
EndEvent

bool Property ZAZAnimationsInstalled = false auto hidden
Function Update()

	RegisterForSingleUpdate(2*UD_UpdateTime)
	
	_activateDevicePackage = none
	
	_startVibFunctionPackage = none
	
	registerAllEvents()
	
	UDPP.RegisterEvents()
	
	CheckHardcoreDisabler(Game.getPlayer())
	
	SetArousalPerks()
	
	if !ZAZAnimationsInstalled && UDmain.ZaZAnimationPackInstalled
		GInfo("Zaz animations not installed, installing...")
		;add armbinder animations
		UD_StruggleAnimation_Armbinder 		= PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder		,"ZapArmbStruggle01")
		UD_StruggleAnimation_Armbinder 		= PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder		,"ZapArmbStruggle03")
		UD_StruggleAnimation_Armbinder 		= PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder		,"ZapArmbStruggle05")
		UD_StruggleAnimation_Armbinder 		= PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder		,"ZapArmbStruggle07")
		UD_StruggleAnimation_Armbinder 		= PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder		,"ZapArmbStruggle08")
		UD_StruggleAnimation_Armbinder 		= PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder		,"ZapArmbStruggle10")
		UD_StruggleAnimation_Armbinder_HB 	= PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder_HB	,"ZapArmbStruggle02")
		UD_StruggleAnimation_Armbinder_HB 	= PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder_HB	,"ZapArmbStruggle06")
		UD_StruggleAnimation_Armbinder_HB 	= PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder_HB	,"ZapArmbStruggle09")

		;straitjacket
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle01")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle03")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle05")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle07")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle08")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle10")
		UD_StruggleAnimation_StraitJacket_HB 	= PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket_HB	,"ZapArmbStruggle02")
		UD_StruggleAnimation_StraitJacket_HB 	= PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket_HB	,"ZapArmbStruggle06")
		UD_StruggleAnimation_StraitJacket_HB 	= PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket_HB	,"ZapArmbStruggle09")
		
		;yoke
		UD_StruggleAnimation_Yoke 		= PapyrusUtil.PushString(UD_StruggleAnimation_Yoke		,"ZapYokeStruggle01")
		UD_StruggleAnimation_Yoke 		= PapyrusUtil.PushString(UD_StruggleAnimation_Yoke		,"ZapYokeStruggle03")
		UD_StruggleAnimation_Yoke 		= PapyrusUtil.PushString(UD_StruggleAnimation_Yoke		,"ZapYokeStruggle05")
		UD_StruggleAnimation_Yoke 		= PapyrusUtil.PushString(UD_StruggleAnimation_Yoke		,"ZapYokeStruggle07")
		UD_StruggleAnimation_Yoke 		= PapyrusUtil.PushString(UD_StruggleAnimation_Yoke		,"ZapYokeStruggle08")
		UD_StruggleAnimation_Yoke 		= PapyrusUtil.PushString(UD_StruggleAnimation_Yoke		,"ZapYokeStruggle10")
		UD_StruggleAnimation_Yoke_HB 	= PapyrusUtil.PushString(UD_StruggleAnimation_Yoke_HB	,"ZapYokeStruggle02")
		UD_StruggleAnimation_Yoke_HB 	= PapyrusUtil.PushString(UD_StruggleAnimation_Yoke_HB	,"ZapYokeStruggle06")
		UD_StruggleAnimation_Yoke_HB 	= PapyrusUtil.PushString(UD_StruggleAnimation_Yoke_HB	,"ZapYokeStruggle09")

		GInfo("Zaz animations installed")
		ZAZAnimationsInstalled = true
	endif
	
	if ZAZAnimationsInstalled && !UDmain.ZaZAnimationPackInstalled
		GInfo("Zaz animations installed but mod is not installed, uninstalling...")
		;remove armbinder animations
		UD_StruggleAnimation_Armbinder 			= PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder			,"ZapArmbStruggle01")
		UD_StruggleAnimation_Armbinder 			= PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder			,"ZapArmbStruggle03")
		UD_StruggleAnimation_Armbinder 			= PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder			,"ZapArmbStruggle05")
		UD_StruggleAnimation_Armbinder 			= PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder			,"ZapArmbStruggle07")
		UD_StruggleAnimation_Armbinder 			= PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder			,"ZapArmbStruggle08")
		UD_StruggleAnimation_Armbinder 			= PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder			,"ZapArmbStruggle10")
		UD_StruggleAnimation_Armbinder_HB 		= PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder_HB		,"ZapArmbStruggle02")
		UD_StruggleAnimation_Armbinder_HB 		= PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder_HB		,"ZapArmbStruggle06")
		UD_StruggleAnimation_Armbinder_HB 		= PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder_HB		,"ZapArmbStruggle09")

		;straitjacket
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle01")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle03")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle05")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle07")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle08")
		UD_StruggleAnimation_StraitJacket 		= PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket		,"ZapArmbStruggle10")
		UD_StruggleAnimation_StraitJacket_HB 	= PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket_HB		,"ZapArmbStruggle02")
		UD_StruggleAnimation_StraitJacket_HB 	= PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket_HB		,"ZapArmbStruggle06")
		UD_StruggleAnimation_StraitJacket_HB 	= PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket_HB		,"ZapArmbStruggle09")
		
		;yoke
		UD_StruggleAnimation_Yoke 				= PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke				,"ZapYokeStruggle01")
		UD_StruggleAnimation_Yoke 				= PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke				,"ZapYokeStruggle03")
		UD_StruggleAnimation_Yoke 				= PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke				,"ZapYokeStruggle05")
		UD_StruggleAnimation_Yoke 				= PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke				,"ZapYokeStruggle07")
		UD_StruggleAnimation_Yoke 				= PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke				,"ZapYokeStruggle08")
		UD_StruggleAnimation_Yoke 				= PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke				,"ZapYokeStruggle10")
		UD_StruggleAnimation_Yoke_HB 			= PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke_HB				,"ZapYokeStruggle02")
		UD_StruggleAnimation_Yoke_HB 			= PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke_HB				,"ZapYokeStruggle06")
		UD_StruggleAnimation_Yoke_HB 			= PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke_HB				,"ZapYokeStruggle09")
		GInfo("Zaz animations uninstalled")
		ZAZAnimationsInstalled = false
	endif
EndFunction

UD_CustomDevice_RenderScript[] Function MakeNewDeviceSlots()
	return new UD_CustomDevice_RenderScript[25]
EndFunction

Function SendLoadConfig()
	RegisterForModEvent("UD_LoadConfig","LoadConfig")
	
	int handle = ModEvent.Create("UD_LoadConfig")
	if (handle)
        ModEvent.Send(handle)
    endif

	UnRegisterForModEvent("UD_LoadConfig")
EndFunction

Function LoadConfig()
	UDmain.config.ResetToDefaults()
	if UDmain.config.getAutoLoad()
		UDmain.config.LoadFromJSON(UDmain.config.File)
	endif
	if TraceAllowed()	
		Log("Config loaded!")
	endif
EndFunction

;dedicated switches to hide options from menu
bool Property currentDeviceMenu_allowStruggling = false auto conditional hidden
bool Property currentDeviceMenu_allowUselessStruggling = false auto conditional hidden
bool Property currentDeviceMenu_allowLockpick = false auto conditional hidden
bool Property currentDeviceMenu_allowKey = false auto conditional hidden
bool Property currentDeviceMenu_allowCutting = false auto conditional hidden
bool Property currentDeviceMenu_allowLockRepair = false auto conditional hidden
bool Property currentDeviceMenu_allowTighten = false auto conditional hidden
bool Property currentDeviceMenu_allowRepair = false auto conditional hidden

;switches for special menu, allows only six buttons
bool Property currentDeviceMenu_switch1 = false auto conditional hidden
bool Property currentDeviceMenu_switch2 = false auto conditional hidden
bool Property currentDeviceMenu_switch3 = false auto conditional hidden
bool Property currentDeviceMenu_switch4 = false auto conditional hidden
bool Property currentDeviceMenu_switch5 = false auto conditional hidden
bool Property currentDeviceMenu_switch6 = false auto conditional hidden

bool Property currentDeviceMenu_allowCommand = false auto conditional hidden
bool Property currentDeviceMenu_allowDetails = false auto conditional hidden
bool Property currentDeviceMenu_allowLockMenu = false auto conditional hidden
bool Property currentDeviceMenu_allowSpecialMenu = false auto conditional hidden
Function resetCondVar()
	currentDeviceMenu_allowstruggling = false
	currentDeviceMenu_allowUselessStruggling = false	
	currentDeviceMenu_allowcutting = false
	currentDeviceMenu_allowkey = false
	currentDeviceMenu_allowlockpick = false
	currentDeviceMenu_allowlockrepair = false
	currentDeviceMenu_allowTighten = false
	currentDeviceMenu_allowRepair = false
	
	currentDeviceMenu_switch1 = false
	currentDeviceMenu_switch2 = false
	currentDeviceMenu_switch3 = false
	currentDeviceMenu_switch4 = false
	currentDeviceMenu_switch5 = false
	currentDeviceMenu_switch6 = false
	
	currentDeviceMenu_allowCommand = False
	currentDeviceMenu_allowDetails = True
	currentDeviceMenu_allowLockMenu = False
	currentDeviceMenu_allowSpecialMenu = False
EndFunction

Function disableStruggleCondVar(bool bDisableLock = true, bool bUselessStruggle = false)
	currentDeviceMenu_allowstruggling = false
	currentDeviceMenu_allowUselessStruggling = bUselessStruggle	
	currentDeviceMenu_allowcutting = false
	if bDisableLock
		currentDeviceMenu_allowkey = false
		currentDeviceMenu_allowLockMenu = False
		currentDeviceMenu_allowlockpick = false
		currentDeviceMenu_allowlockrepair = false
	endif
	currentDeviceMenu_allowTighten = false
	currentDeviceMenu_allowRepair = false
EndFunction

Function CheckAndDisableSpecialMenu()
	bool loc_cond = false
	loc_cond = loc_cond || currentDeviceMenu_switch1
	loc_cond = loc_cond || currentDeviceMenu_switch2
	loc_cond = loc_cond || currentDeviceMenu_switch3
	loc_cond = loc_cond || currentDeviceMenu_switch4
	loc_cond = loc_cond || currentDeviceMenu_switch5
	loc_cond = loc_cond || currentDeviceMenu_switch6
	if !loc_cond
		currentDeviceMenu_allowSpecialMenu = false
	endif
EndFunction

Function DisableActor(Actor akActor,bool bBussy = false)
	if TraceAllowed()	
		Log("DisableActor("+getActorName(akActor) + ")",2)
	endif
	StartMinigameDisable(akActor)
	;if !akActor.HasMagicEffectWithKeyword(UDlibs.MinigameDisableEffect_KW)
	;	UDlibs.MinigameDisableSpell.cast(akActor)
	;endif
EndFunction

Function UpdateDisabledActor(Actor akActor,bool bBussy = false)
	if TraceAllowed()	
		Log("UpdateDisabledActor("+getActorName(akActor) + ")",2)
	endif
	UpdateMinigameDisable(akActor)
EndFunction

Function EnableActor(Actor akActor,bool bBussy = false)
	if TraceAllowed()	
		Log("EnableActor("+getActorName(akActor)+")",2)
	endif
	;akActor.DispelSpell(UDlibs.MinigameDisableSpell)
	EndMinigameDisable(akActor)
	;/
	if akActor == Game.getPlayer()
		if !akActor.HasMagicEffectWithKeyword(UDlibs.HardcoreDisable_KW)
			Game.EnablePlayerControls()
		else
			Game.EnablePlayerControls(abMenu = false)
		endif
		Game.SetPlayerAiDriven(False)
	else
		akActor.SetDontMove(False)
	endif
	/;
EndFunction

Function StartMinigameDisable(Actor akActor)
	akActor.AddToFaction(BussyFaction)

	if akActor == Game.getPlayer()
		if !akActor.HasMagicEffectWithKeyword(UDlibs.HardcoreDisable_KW)
			Game.EnablePlayerControls(abMovement = False)
		endif
		Game.DisablePlayerControls(abMovement = False)
		Game.SetPlayerAiDriven(True)
	else
		akActor.SetDontMove(True)
		akActor.SheatheWeapon()
	endif
EndFunction

Function UpdateMinigameDisable(Actor akActor)
	if akActor.IsInFaction(BussyFaction)
		if akActor == Game.getPlayer()
			if !akActor.HasMagicEffectWithKeyword(UDlibs.HardcoreDisable_KW)
				Game.EnablePlayerControls(abMovement = False)
			endif
			Game.DisablePlayerControls(abMovement = False)
			Game.SetPlayerAiDriven(True)
		else
			akActor.SetDontMove(True)
		endif
	endif
EndFunction

Function EndMinigameDisable(Actor akActor)
	akActor.RemoveFromFaction(BussyFaction)
	if akActor == Game.getPlayer()
		if !akActor.HasMagicEffectWithKeyword(UDlibs.HardcoreDisable_KW)
			Game.EnablePlayerControls(abMovement = False)
		endif
		Game.SetPlayerAiDriven(False)
	else
		akActor.SetDontMove(False)
	endif
EndFunction

bool Function InSelabAnimation(Actor akActor)
	return akActor.IsInFaction(libs.Sexlab.AnimatingFaction)
EndFunction

bool Function InZadAnimation(Actor akActor)
	return akActor.IsInFaction(libs.zadAnimatingFaction)
EndFunction

Function CheckHardcoreDisabler(Actor akActor)
	if UD_HardcoreMode && ActorIsPlayer(akActor)
		if akActor.wornhaskeyword(libs.zad_deviousHeavyBondage) && !akActor.HasMagicEffectWithKeyword(UDlibs.HardcoreDisable_KW)
			UDlibs.HardcoreDisableSpell.cast(akActor)
		endif
	endif
EndFunction

bool Function actorInMinigame(Actor akActor)
	if !akActor
		return false
	endif
	return akActor.IsInFaction(MinigameFaction)
EndFunction

Function StopMinigame(Actor akActor)
	if !akActor
		return
	endif
	return akActor.RemoveFromFaction(MinigameFaction)
EndFunction

bool Function actorFreeHands(Actor akActor,bool checkGrasp = false)
	bool res = !akActor.wornhaskeyword(libs.zad_deviousHeavyBondage) 
		
	if checkGrasp
		if akActor.wornhaskeyword(libs.zad_DeviousBondageMittens)
			res = false
		endif
	endif
	return res
EndFunction

Function BlockActorExpression(Actor akActor,sslBaseExpression sslExpression)
	StorageUtil.SetStringValue(akActor,"zad_BlockinkExpression",sslExpression.name)
EndFunction

Function UnBlockActorExpression(Actor akActor)
	StorageUtil.UnSetStringValue(akActor,"zad_BlockinkExpression")
EndFunction

Function AddInvisibleArmbinder(Actor akActor)
	if !akActor.getItemCount(UDlibs.InvisibleArmbinder)
		akActor.EquipItem(UDlibs.InvisibleArmbinder,false,true)
		CheckHardcoreDisabler(akActor)
		libs.StartBoundEffects(akActor)
	endif
EndFunction

Function RemoveInvisibleArmbinder(Actor akActor)
	akActor.RemoveItem(UDlibs.InvisibleArmbinder,1,true)
	if !akActor.wornhaskeyword(libs.zad_deviousHeavyBondage)
		libs.StopBoundEffects(akActor)
	endif
EndFunction

Function EquipInvisibleArmbinder(Actor akActor)
	akActor.EquipItem(UDlibs.InvisibleArmbinder,false,true)
EndFunction

Function UnequipInvisibleArmbinder(Actor akActor)
	akActor.UnEquipItem(UDlibs.InvisibleArmbinder,false,true)
EndFunction

bool Function HaveInvisibleArmbinderEquiped(Actor akActor)
	return CheckRenderDeviceEquipped(akActor,UDlibs.InvisibleArmbinder)
EndFunction

bool Function HaveInvisibleArmbinder(Actor akActor)
	return akActor.getItemCount(UDlibs.InvisibleArmbinder)
EndFunction

Function UpdateInvisibleArmbinder(Actor akActor)
	if !HaveInvisibleArmbinderEquiped(akActor) && HaveInvisibleArmbinder(akActor) && !akActor.wornhaskeyword(libs.zad_deviousHeavyBondage)
		EquipInvisibleArmbinder(akActor)
	endif
EndFunction

Function AddInvisibleHobble(Actor akActor)
	if !akActor.getItemCount(UDlibs.InvisibleHobble)
		akActor.EquipItem(UDlibs.InvisibleHobble,false,true)
		libs.StartBoundEffects(akActor)
	endif
EndFunction

Function RemoveInvisibleHobble(Actor akActor)
	akActor.RemoveItem(UDlibs.InvisibleHobble,1,true)
	if !akActor.wornhaskeyword(libs.zad_DeviousHobbleSkirt)
		libs.StopBoundEffects(akActor)
	endif
EndFunction

Function EquipInvisibleHobble(Actor akActor)
	akActor.EquipItem(UDlibs.InvisibleHobble,false,true)
EndFunction

Function UnequipInvisibleHobble(Actor akActor)
	akActor.UnEquipItem(UDlibs.InvisibleHobble,false,true)
EndFunction

bool Function HaveInvisibleHobbleEquiped(Actor akActor)
	return CheckRenderDeviceEquipped(akActor,UDlibs.InvisibleHobble)
EndFunction

bool Function HaveInvisibleHobble(Actor akActor)
	return akActor.getItemCount(UDlibs.InvisibleHobble)
EndFunction

Function UpdateInvisibleHobble(Actor akActor)
	if !HaveInvisibleHobbleEquiped(akActor) && HaveInvisibleHobble(akActor) && !akActor.wornhaskeyword(libs.zad_deviousHobbleSkirt)
		EquipInvisibleHobble(akActor)
	endif
EndFunction

bool Property WHMenuOpened = false auto hidden
int Property GiftMenuMode = 0 auto hidden
Function openNPCLockMenu(Actor akTarget)
	GiftMenuMode = 1
	;StorageUtil.SetIntValue(akTarget, "UD_blockZad" + deviceInventory, 1)
	;StorageUtil.SetIntValue(Game.getPlayer(), "UD_blockZad" + deviceInventory, 1)
	akTarget.ShowGiftMenu(True, UDlibs.GiftMenuFilter,True,False)
	;StorageUtil.UnSetIntValue(akTarget, "UD_blockZad" + deviceInventory)
	;StorageUtil.UnSetIntValue(Game.getPlayer(), "UD_blockZad" + deviceInventory)
EndFunction


Function openPlayerHelpMenu(Actor akHelper)
	GiftMenuMode = 2
	;StorageUtil.SetIntValue(akHelper, "UD_blockZad" + deviceInventory, 1)
	;StorageUtil.SetIntValue(Game.getPlayer(), "UD_blockZad" + deviceInventory, 1)
	akHelper.ShowGiftMenu(True, UDlibs.GiftMenuFilter,True,False)
	;StorageUtil.UnSetIntValue(akHelper, "UD_blockZad" + deviceInventory)
	;StorageUtil.UnSetIntValue(Game.getPlayer(), "UD_blockZad" + deviceInventory)
EndFunction


Function openNPCHelpMenu(Actor akTarget)
	GiftMenuMode = 3
	;StorageUtil.SetIntValue(akTarget, "UD_blockZad" + deviceInventory, 1)
	;StorageUtil.SetIntValue(Game.getPlayer(), "UD_blockZad" + deviceInventory, 1)
	akTarget.ShowGiftMenu(False, UDlibs.GiftMenuFilter,True,False)
	;StorageUtil.UnSetIntValue(akTarget, "UD_blockZad" + deviceInventory)
	;StorageUtil.UnSetIntValue(Game.getPlayer(), "UD_blockZad" + deviceInventory)
EndFunction


UD_CustomDevice_RenderScript Property lastOpenedDevice = none auto hidden
UD_CustomDevice_RenderScript _oCurrentPlayerMinigameDevice = none
;UD_CustomDevice_RenderScript _oCurrentPlayerHelpedDevice = none

Function setCurrentMinigameDevice(UD_CustomDevice_RenderScript oref)
	_oCurrentPlayerMinigameDevice = oref
EndFunction

Function resetCurrentMinigameDevice()
	_oCurrentPlayerMinigameDevice = none
EndFunction

int Function getNumberOfRegisteredDevices(Actor akActor)
	return getNPCSlot(akActor).getNumberOfRegisteredDevices()
EndFunction

;returns number of devices that can be activated
bool Function isRegistered(Actor akActor)
	if ActorIsPlayer(akActor)
		return true
	endif
	return akActor.isInFaction(RegisteredNPCFaction);UDCD_NPCM.isRegistered(akActor)
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlot(Actor akActor)
	if ActorIsPlayer(akActor)
		return UD_PlayerSlot ;faster acces
	endif
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor)
	else
		return none
	endif
EndFunction

UD_CustomDevice_RenderScript[] Function getNPCDevices(Actor akActor)
	if isRegistered(akActor)
		return getNPCSlot(akActor).UD_equipedCustomDevices
	else
		return none
	endif
EndFunction

bool Function isScriptRunning(Actor akActor)
	return akActor.isInFaction(RegisteredNPCFaction)
EndFunction

Function sortSlots(Actor akActor)
	if isRegistered(akActor)
		getNPCSlot(akActor).sortSlots()
	endif
EndFunction

bool Function registerDevice(UD_CustomDevice_RenderScript oref)
	UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(oref.getWearer())
	if loc_slot
		return loc_slot.registerDevice(oref)
	else
		Error("registerDevice("+oref.getDeviceHeader()+") - can't find slot for actor " + oref.getWearerName())
	endif
EndFunction

bool Function deviceAlreadyRegistered(Actor akActor, Armor deviceInventory)
	if isRegistered(akActor)
		return getNPCSlot(akActor).deviceAlreadyRegistered(deviceInventory)
	else
		return false
	endif
EndFunction

Function removeAllDevices(Actor akActor)
	if isRegistered(akActor)
		getNPCSlot(akActor).removeAllDevices()
	endif
EndFunction

Function removeUnusedDevices(Actor akActor)
	getNPCSlot(akActor).removeUnusedDevices()
EndFunction

int Function numberOfUnusedDevices(Actor akActor)
	return getNPCSlot(akActor).numberOfUnusedDevices()
EndFunction

int Function unregisterDevice(UD_CustomDevice_RenderScript oref,int i = 0,bool sort = True)
	UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(oref.getWearer())
	if loc_slot
		return loc_slot.unregisterDevice(oref,i,sort)
	else
		Error("unregisterDevice("+oref.getDeviceHeader()+") - can't find slot for actor " + oref.getWearerName())
	endif
EndFunction

int Function unregisterDeviceByInv(Actor akActor,Armor invDevice,int i = 0,bool sort = True)
	return getNPCSlot(akActor).unregisterDeviceByInv(invDevice,i,sort)
EndFunction

int Function getCopiesOfDevice(UD_CustomDevice_RenderScript oref)
	return getNPCSlot(oref.getWearer()).getCopiesOfDevice(oref)
EndFunction

Function removeCopies(Actor akActor)
	getNPCSlot(akActor).removeCopies()
EndFunction

int Function numberOfCopies(Actor akActor)
	return getNPCSlot(akActor).numberOfCopies()
EndFunction

int Function debugSize(Actor akActor)
	return getNPCSlot(akActor).debugSize()
EndFunction

;animations arrays for faster acces
;normal animations without hobble skirt
String[] Property UD_StruggleAnimation_Armbinder 		auto
String[] Property UD_StruggleAnimation_Elbowbinder 		auto
String[] Property UD_StruggleAnimation_StraitJacket		auto
String[] Property UD_StruggleAnimation_CuffsFront		auto
String[] Property UD_StruggleAnimation_Yoke 			auto
String[] Property UD_StruggleAnimation_YokeBB 			auto
String[] Property UD_StruggleAnimation_ElbowTie 		auto
;String[] Property UD_StruggleAnimation_PetSuit			auto !TODO
String[] Property UD_StruggleAnimation_Gag 				auto
String[] Property UD_StruggleAnimation_Boots 			auto ;also leg cuffs
String[] Property UD_StruggleAnimation_ArmCuffs 		auto ;also gloves and mittens
String[] Property UD_StruggleAnimation_Collar 			auto
String[] Property UD_StruggleAnimation_Blindfold 		auto ;also includes hood
String[] Property UD_StruggleAnimation_Suit 			auto
String[] Property UD_StruggleAnimation_Belt 			auto
String[] Property UD_StruggleAnimation_Plug 			auto
String[] Property UD_StruggleAnimation_Default 			auto
;animations with hobble skirt
String[] Property UD_StruggleAnimation_Armbinder_HB 	auto
String[] Property UD_StruggleAnimation_Elbowbinder_HB 	auto
String[] Property UD_StruggleAnimation_StraitJacket_HB	auto
String[] Property UD_StruggleAnimation_CuffsFront_HB	auto
String[] Property UD_StruggleAnimation_Yoke_HB			auto
String[] Property UD_StruggleAnimation_YokeBB_HB 		auto
String[] Property UD_StruggleAnimation_ElbowTie_HB 		auto
;String[] Property UD_StruggleAnimation_PetSuit_HB		auto !TODO
String[] Property UD_StruggleAnimation_Gag_HB 			auto
String[] Property UD_StruggleAnimation_Boots_HB 		auto ;also leg cuffs
String[] Property UD_StruggleAnimation_ArmCuffs_HB 		auto ;also gloves and mittens
String[] Property UD_StruggleAnimation_Collar_HB 		auto
String[] Property UD_StruggleAnimation_Blindfold_HB 	auto ;also includes hood
String[] Property UD_StruggleAnimation_Suit_HB 			auto
String[] Property UD_StruggleAnimation_Belt_HB 			auto
String[] Property UD_StruggleAnimation_Plug_HB 			auto
String[] Property UD_StruggleAnimation_Default_HB 		auto

string[] Function GetHeavyBondageAnimation_Armbinder(bool hobble = false)
	if !hobble
		return UD_StruggleAnimation_Armbinder
	else
		return UD_StruggleAnimation_Armbinder_HB
	endif
EndFunction

string[] Function GetStruggleAnimations(Actor akActor,Armor renDevice)
	if !akActor.wornHasKeyword(libs.zad_DeviousHobbleSkirt)
		if renDevice.hasKeyword(libs.zad_deviousheavybondage)
			if renDevice.hasKeyword(libs.zad_DeviousArmbinder)
				return UD_StruggleAnimation_Armbinder
			elseif renDevice.hasKeyword(libs.zad_DeviousArmbinderElbow)
				return UD_StruggleAnimation_Elbowbinder
			elseif renDevice.hasKeyword(libs.zad_DeviousStraitJacket)
				return UD_StruggleAnimation_StraitJacket
			elseif renDevice.hasKeyword(libs.zad_DeviousCuffsFront)
				return UD_StruggleAnimation_CuffsFront
			elseif renDevice.hasKeyword(libs.zad_DeviousYoke)
				return UD_StruggleAnimation_Yoke
			elseif renDevice.hasKeyword(libs.zad_DeviousYokeBB)
				return UD_StruggleAnimation_YokeBB
			elseif renDevice.hasKeyword(libs.zad_DeviousElbowTie)
				return UD_StruggleAnimation_ElbowTie
			elseif renDevice.hasKeyword(libs.zad_DeviousPetSuit)
				string[] temp = new string[1]
				temp[0] = "none"
				return temp
			else
				return UD_StruggleAnimation_Default
			endif
		else
			if renDevice.hasKeyword(libs.zad_deviousGag)
				return UD_StruggleAnimation_Gag
			elseif renDevice.hasKeyword(libs.zad_DeviousLegCuffs) || renDevice.hasKeyword(libs.zad_DeviousBoots)
				return UD_StruggleAnimation_Boots
			elseif renDevice.hasKeyword(libs.zad_DeviousArmCuffs) || renDevice.hasKeyword(libs.zad_DeviousGloves) || renDevice.hasKeyword(libs.zad_DeviousBondageMittens)
				return UD_StruggleAnimation_ArmCuffs
			elseif renDevice.hasKeyword(libs.zad_DeviousCollar)
				return UD_StruggleAnimation_Collar
			elseif renDevice.hasKeyword(libs.zad_DeviousBlindfold) || renDevice.hasKeyword(libs.zad_DeviousHood)
				return UD_StruggleAnimation_Blindfold
			elseif renDevice.hasKeyword(libs.zad_DeviousSuit)
				return UD_StruggleAnimation_Suit
			elseif renDevice.hasKeyword(libs.zad_DeviousBelt)
				return UD_StruggleAnimation_Belt
			elseif renDevice.hasKeyword(libs.zad_DeviousPlug)
				return UD_StruggleAnimation_Plug
			else	
				return UD_StruggleAnimation_Default
			endif
		endif
	else
		if renDevice.hasKeyword(libs.zad_deviousheavybondage)
			if renDevice.hasKeyword(libs.zad_DeviousArmbinder)
				return UD_StruggleAnimation_Armbinder_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousArmbinderElbow)
				return UD_StruggleAnimation_Elbowbinder_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousStraitJacket)
				return UD_StruggleAnimation_StraitJacket_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousCuffsFront)
				return UD_StruggleAnimation_CuffsFront_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousYoke)
				return UD_StruggleAnimation_Yoke_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousYokeBB)
				return UD_StruggleAnimation_YokeBB_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousElbowTie)
				return UD_StruggleAnimation_ElbowTie_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousPetSuit)
				string[] temp = new string[1]
				temp[0] = "none"
				return temp
			else
				return UD_StruggleAnimation_Default_HB
			endif
		else
			if renDevice.hasKeyword(libs.zad_deviousGag)
				return UD_StruggleAnimation_Gag_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousLegCuffs) || renDevice.hasKeyword(libs.zad_DeviousBoots)
				return UD_StruggleAnimation_Boots_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousArmCuffs) || renDevice.hasKeyword(libs.zad_DeviousGloves) || renDevice.hasKeyword(libs.zad_DeviousBondageMittens)
				return UD_StruggleAnimation_ArmCuffs_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousCollar)
				return UD_StruggleAnimation_Collar_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousBlindfold) || renDevice.hasKeyword(libs.zad_DeviousHood)
				return UD_StruggleAnimation_Blindfold_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousSuit)
				return UD_StruggleAnimation_Suit_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousBelt)
				return UD_StruggleAnimation_Belt_HB
			elseif renDevice.hasKeyword(libs.zad_DeviousPlug)
				return UD_StruggleAnimation_Plug_HB
			else	
				return UD_StruggleAnimation_Default_HB
			endif
		endif
	endif
EndFunction

string[] Function GetStruggleAnimationsByKeyword(Actor akActor,Keyword akKeyword,bool abHobble = false)
	if !abHobble
		if akKeyword == libs.zad_DeviousArmbinder
			return UD_StruggleAnimation_Armbinder
		elseif akKeyword == libs.zad_DeviousArmbinderElbow
			return UD_StruggleAnimation_Elbowbinder
		elseif akKeyword == libs.zad_DeviousStraitJacket
			return UD_StruggleAnimation_StraitJacket
		elseif akKeyword == libs.zad_DeviousCuffsFront
			return UD_StruggleAnimation_CuffsFront
		elseif akKeyword == libs.zad_DeviousYoke
			return UD_StruggleAnimation_Yoke
		elseif akKeyword == libs.zad_DeviousYokeBB
			return UD_StruggleAnimation_YokeBB
		elseif akKeyword == libs.zad_DeviousElbowTie
			return UD_StruggleAnimation_ElbowTie
		elseif akKeyword == libs.zad_DeviousPetSuit
			string[] temp = new string[1]
			temp[0] = "none"
			return temp
		elseif akKeyword == libs.zad_deviousGag
			return UD_StruggleAnimation_Gag
		elseif akKeyword == libs.zad_DeviousLegCuffs || akKeyword == libs.zad_DeviousBoots
			return UD_StruggleAnimation_Boots
		elseif akKeyword == libs.zad_DeviousArmCuffs || akKeyword == libs.zad_DeviousGloves || akKeyword == libs.zad_DeviousBondageMittens
			return UD_StruggleAnimation_ArmCuffs
		elseif akKeyword == libs.zad_DeviousCollar
			return UD_StruggleAnimation_Collar
		elseif akKeyword == libs.zad_DeviousBlindfold || akKeyword == libs.zad_DeviousHood
			return UD_StruggleAnimation_Blindfold
		elseif akKeyword == libs.zad_DeviousSuit
			return UD_StruggleAnimation_Suit
		elseif akKeyword == libs.zad_DeviousBelt
			return UD_StruggleAnimation_Belt
		elseif akKeyword == libs.zad_DeviousPlug
			return UD_StruggleAnimation_Plug
		else	
			return UD_StruggleAnimation_Default
		endif
	else
		if akKeyword == libs.zad_DeviousArmbinder
			return UD_StruggleAnimation_Armbinder_HB
		elseif akKeyword == libs.zad_DeviousArmbinderElbow
			return UD_StruggleAnimation_Elbowbinder_HB
		elseif akKeyword == libs.zad_DeviousStraitJacket
			return UD_StruggleAnimation_StraitJacket_HB
		elseif akKeyword == libs.zad_DeviousCuffsFront
			return UD_StruggleAnimation_CuffsFront_HB
		elseif akKeyword == libs.zad_DeviousYoke
			return UD_StruggleAnimation_Yoke_HB
		elseif akKeyword == libs.zad_DeviousYokeBB
			return UD_StruggleAnimation_YokeBB_HB
		elseif akKeyword == libs.zad_DeviousElbowTie
			return UD_StruggleAnimation_ElbowTie_HB
		elseif akKeyword == libs.zad_DeviousPetSuit
			string[] temp = new string[1]
			temp[0] = "none"
			return temp
		elseif akKeyword == libs.zad_deviousGag
			return UD_StruggleAnimation_Gag_HB
		elseif akKeyword == libs.zad_DeviousLegCuffs || akKeyword == libs.zad_DeviousBoots
			return UD_StruggleAnimation_Boots_HB
		elseif akKeyword == libs.zad_DeviousArmCuffs || akKeyword == libs.zad_DeviousGloves || akKeyword == libs.zad_DeviousBondageMittens
			return UD_StruggleAnimation_ArmCuffs_HB
		elseif akKeyword == libs.zad_DeviousCollar
			return UD_StruggleAnimation_Collar_HB
		elseif akKeyword == libs.zad_DeviousBlindfold || akKeyword == libs.zad_DeviousHood
			return UD_StruggleAnimation_Blindfold_HB
		elseif akKeyword == libs.zad_DeviousSuit
			return UD_StruggleAnimation_Suit_HB
		elseif akKeyword == libs.zad_DeviousBelt
			return UD_StruggleAnimation_Belt_HB
		elseif akKeyword == libs.zad_DeviousPlug
			return UD_StruggleAnimation_Plug_HB
		else	
			return UD_StruggleAnimation_Default_HB
		endif
	endif
EndFunction

Function LockDeviceParalel(actor akActor, armor deviceInventory, bool force = false)
	int handle = ModEvent.Create("UD_LockDeviceParalel")
	if (handle)
		ModEvent.PushForm(handle,akActor)
		ModEvent.PushForm(handle,deviceInventory)
		ModEvent.PushInt(handle,force as int)
        ModEvent.Send(handle)
    endif
EndFunction

Function LockDevice(form fActor, form fDeviceInventory, int iForce)
	(libs as zadlibs_UDPatch).LockDevicePatched(fActor as Actor,fDeviceInventory as Armor,iForce as Bool)
EndFunction


Function StopAllVibrators(Actor akActor)
	if isRegistered(akActor)
		getNPCSlot(akActor).TurnOffAllVibrators()
	endif
EndFunction
float Function getStruggleDifficultyModifier()
	float res = 1.0
	
	if UD_UseDDdifficulty
		res += (0.6 - 0.15*UDmain.getDDescapeDifficulty())
	endif
	
	res += 0.25*(1 - UD_StruggleDifficulty)
	
	return res
EndFunction

Function SendStartBoundEffectEvent(Actor akActor)
	int handle = ModEvent.Create("UD_SBEParalel")
	if (handle)
		ModEvent.PushForm(handle, akActor)
        ModEvent.Send(handle)
    endIf	
EndFunction

Event StartBoundEffectsParalel(Form kTarget)
	Actor akActor = kTarget as Actor
	libsp.StartBoundEffectsPatched(akActor)
EndEvent

float Function getMendDifficultyModifier()
	float res = 1.0
	
	if UD_UseDDdifficulty
		res += (0.10*UDmain.getDDescapeDifficulty() - 0.4)
	endif
	
	res += 0.25*(UD_StruggleDifficulty - 1)
	
	return res
EndFunction
bool started = false
Function startScript(UD_CustomDevice_RenderScript oref)
	if TraceAllowed()	
		Log("UDCustomDeviceMain startScript() called for " + oref.getDeviceHeader(),1)
	endif
	if oref.getWearer() == Game.getPlayer() 
		registerDevice(oref)
	elseif isRegistered(oref.getWearer())
		registerDevice(oref)
	endif
EndFunction

Function endScript(UD_CustomDevice_RenderScript oref)
	if TraceAllowed()	
		Log("UDCustomDeviceMain endScript() called for " + oref.DeviceInventory.getName(),1)
	endif
	updateLastOpenedDeviceOnRemove(oref)
	if isRegistered(oref.getWearer())
		;StorageUtil.SetIntValue(oref.getWearer(), "UD_blockSlotUpdate",1)
		unregisterDevice(oref)
		;StorageUtil.UnsetIntValue(oref.getWearer(), "UD_blockSlotUpdate")
	endif
	;UDCD_NPCM.updateSlots()
	;getNPCSlot(oref.getWearer()).regainDevices()
EndFunction

Function RegisterGlobalKeys()
	if TraceAllowed()	
		Log("RegisterGlobalKeys")
	endif
	RegisterForKey(StruggleKey_Keycode)
	RegisterForKey(PlayerMenu_KeyCode)
	RegisterForKey(ActionKey_Keycode)
	RegisterForKey(NPCMenu_Keycode)
EndFunction

Function UnregisterGlobalKeys()
	if TraceAllowed()	
		Log("UnregisterGlobalKeys")
	endif
	UnRegisterForKey(StruggleKey_Keycode)
	UnRegisterForKey(PlayerMenu_KeyCode)
	UnRegisterForKey(ActionKey_Keycode)
	UnRegisterForKey(NPCMenu_Keycode)
EndFunction

Function registerAllEvents()
	if TraceAllowed()	
		Log("registerAllEvents")
	endif
	registerEvents()
	RegisterGlobalKeys()
EndFunction

Function registerEvents()
	if TraceAllowed()	
		Log("registerEvents")
	endif
	RegisterForModEvent("UD_ActivateDevice","OnActivateDevice")
	RegisterForModEvent("UD_UpdateHud","updateHUDBars")
	RegisterForModEvent("UD_AVCheckLoopStart","AVCheckLoop")
	RegisterForModEvent("UD_AVCheckLoopStartHelper","AVCheckLoopHelper")
	RegisterForModEvent("UD_CritUpdateLoopStart","CritLoop")
	RegisterForModEvent("UD_StartVibFunction","FetchAndStartVibFunction")
	RegisterForModEvent("UD_LockDeviceParalel","LockDevice")
	RegisterForModEvent("UD_SBEParalel","StartBoundEffectsParalel")
	RegisterForModEvent("UD_SetExpression","SetExpression")
EndFunction

bool _SetexpressionMutex = false
sslBaseExpression _SendExpression = none
Function SendSetExpressionEvent(Actor akActor, sslBaseExpression sslExpression, int iStrength, bool openMouth=false)
	while _SendExpression
		Utility.waitMenuMode(0.1)
	endwhile
	_SendExpression = sslExpression
	int handle = ModEvent.Create("UD_SetExpression")
	if (handle)
        ModEvent.PushForm(handle,akActor)
		ModEvent.PushInt(handle,iStrength)
		ModEvent.PushInt(handle,openMouth as Int)
        ModEvent.Send(handle)
    endif
	
	float loc_time = 0.0
	while _SendExpression && loc_time <= 3.0
		Utility.waitMenuMode(0.05)
		loc_time += 0.05
	endwhile
	if loc_time >= 3.0
		_SendExpression = none
		Error("SendSetExpressionEvent timeout!!")
	endif
EndFunction

Function SetExpression(Form kActor,int iStrength,int openMouth)
	Actor akActor = kActor as Actor
	sslBaseExpression loc_expression = _SendExpression
	_SendExpression = none
	UDEM.SetExpression(akActor,loc_expression,iStrength,openMouth)
EndFunction

;replece slot with new device
Function replaceSlot(UD_CustomDevice_RenderScript oref, Armor inventoryDevice)
	getNPCSlot(oref.getWearer()).replaceSlot(oref,inventoryDevice)
EndFunction

;show MCM debug menu
Function showDebugMenu(Actor akActor,int slot_id)
	getNPCSlot(akActor).showDebugMenu(slot_id)
EndFunction

bool Function AllowNPCMessage(Actor akActor)
	if ActorIsFollower(akActor) 
		return true
	endif
	return UDmain.ActorInCloseRange(akActor)
EndFunction

;///////////////////////////////////////
;=======================================
;			UPDATE FUNCTION
;=======================================
;//////////////////////////////////////;

float Property UD_UpdateTime = 5.0 auto
float LastUpdateTime = 0.0
bool loc_init = false
;update the devices once per UD_UpdateTime
Event onUpdate()
	if !loc_init
		LoadConfig()
		RegisterGlobalKeys()
		if UDmain.DebugMod
			Game.getPlayer().addItem(UDlibs.AbadonPlug,1)
		endif
		LastUpdateTime = Utility.GetCurrentGameTime()
		LastUpdateTime_Hour = Utility.GetCurrentGameTime()
		loc_init = true
	endif
	if !UDmain.UD_DisableUpdate
		float timePassed = Utility.GetCurrentGameTime() - LastUpdateTime
		UDCD_NPCM.update(timePassed)
		LastUpdateTime = Utility.GetCurrentGameTime()
	endif
	RegisterForSingleUpdate(UD_UpdateTime)
EndEvent

float LastUpdateTime_Hour = 0.0 ;last time the update happened in days
Event OnUpdateGameTime()
	if !UDmain.UD_DisableUpdate
		Utility.waitMenuMode(Utility.randomFloat(2.0,4.0))
		float currentgametime = Utility.GetCurrentGameTime()
		float mult = 24.0*(currentgametime - LastUpdateTime_Hour) ;multiplier for how much more then 1 hour have passed, ex: for 2.5 hours passed without update, the mult will be 2.5
		UDCD_NPCM.updateHour(mult)
		LastUpdateTime_Hour = Utility.GetCurrentGameTime()
	endif
	registerForSingleUpdateGameTime(1.0)
endEvent

;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------

Event keyUnregister(string eventName = "none", string strArg = "", float numArg = 0.0, Form sender = none)
	if TraceAllowed()	
		Log("UDCustomHeavyBondageMain OnKeyUnregister called",1)
	endif
	UnregisterForAllKeys()
EndEvent

Event MinigameKeysRegister()
	if TraceAllowed()	
		Log("UDCustomDevicemain MinigameKeysRegister called",1)
	endif
	RegisterForKey(Stamina_meter_Keycode)
	RegisterForKey(SpecialKey_Keycode)
	RegisterForKey(Magicka_meter_Keycode)
	_specialButtonOn = false
EndEvent

Event MinigameKeysUnregister()
	if TraceAllowed()	
		Log("UDCustomDevicemain MinigameKeysUnregister called",1)
	endif
	if !KeyIsUsedGlobaly(Stamina_meter_Keycode)
		UnregisterForKey(Stamina_meter_Keycode)
	endif
	if !KeyIsUsedGlobaly(SpecialKey_Keycode)
		UnregisterForKey(SpecialKey_Keycode)
	endif
	if !KeyIsUsedGlobaly(Magicka_meter_Keycode)
		UnregisterForKey(Magicka_meter_Keycode)
	endif
	_specialButtonOn = false
EndEvent

bool Function KeyIsUsedGlobaly(int keyCode)
	bool loc_res = false
	loc_res = loc_res || (keyCode == StruggleKey_Keycode)
	loc_res = loc_res || (keyCode == PlayerMenu_KeyCode)
	loc_res = loc_res || (keyCode == NPCMenu_Keycode)
	loc_res = loc_res || (keyCode == ActionKey_Keycode)
	return loc_res
EndFunction

bool crit = false
string selected_crit_meter =  "Error"
Int Property UD_CritEffect = 2 auto hidden
Event StruggleCritCheck(UD_CustomDevice_RenderScript device, int chance, string strArg, float difficulty)
	string meter
	if Utility.randomInt(1,100) <= chance
		if strArg != "NPC" && strArg != "Auto"
			if strArg == "random"
				if Utility.randomInt(0,1)
					meter = "S"
				else
					meter = "M"
				endif
			else
				meter = strArg
			endif
		elseif strArg == "Auto" ;auto crits
			if Utility.randomInt() <= UD_AutoCritChance ;npc reacted
				device.critDevice() ;succes
			else
				device.critFailure() ;failure
			endif
			return	
		elseif strArg == "NPC"
			if Utility.randomInt() > 30 ;npc reacted
				float randomResponceTime = Utility.randomFloat(0.4,0.85) ;random reaction time
				if randomResponceTime <= difficulty
					device.critDevice() ;succes
				else
					device.critFailure() ;failure
				endif
			endif
			return	
		endif
	endif	
		
	crit = True
	selected_crit_meter = meter
	
	if (selected_crit_meter == "S")
		if UD_CritEffect == 2 || UD_CritEffect == 1
			UDlibs.GreenCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
			Utility.wait(0.3)
		endif
		if UD_CritEffect == 2 || UD_CritEffect == 0
			UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartStaminaBlinking")
		endif
	elseif (selected_crit_meter == "M")
		if UD_CritEffect == 2 || UD_CritEffect == 1
			UDlibs.BlueCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
			Utility.wait(0.3)
		endif
		if UD_CritEffect == 2 || UD_CritEffect == 0
			UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartMagickaBlinking")
		endif
	elseif (selected_crit_meter == "R")
		if UD_CritEffect == 2 || UD_CritEffect == 1
			UDlibs.RedCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
			Utility.wait(0.3)
		endif
	endif
	;UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.FlashShoutMeter")
	
	Utility.wait(difficulty)
	crit = False
EndEvent

bool Function registeredKeyPressed(Int KeyCode)
	if KeyCode == Stamina_meter_Keycode
		return True
	elseif KeyCode == Magicka_meter_Keycode
		return True
	endif
	return false
endFunction

Function updateLastOpenedDeviceOnRemove(UD_CustomDevice_RenderScript removed_device)
	if lastOpenedDevice == removed_device
		lastOpenedDevice = none
	endif
EndFunction

Function setLastOpenedDevice(UD_CustomDevice_RenderScript device)
	lastOpenedDevice = device
EndFunction

bool _SpeacialButtonMutex = false
int _SpecialButton_Bonus = 0 ;how much times was special button pressed while it was proccessing
bool _specialButtonOn = false
State Minigame
	Event OnKeyDown(Int KeyCode)
		bool _crit = crit ;help variable to reduce lag
		if _SpeacialButtonMutex
			if KeyCode == SpecialKey_Keycode
				_SpecialButton_Bonus += 1
				return ;too much thread, remove new ones
			endif
		endif
		bool loc_menuopen = UDmain.IsMenuOpen()
		if !loc_menuopen ;only if player is not in menu
			if TraceAllowed()		
				Log("OnKeyDown(), Keycode: " + KeyCode,3)
			endif
			if _oCurrentPlayerMinigameDevice
				if KeyCode == SpecialKey_Keycode
					_specialButtonOn = true
					if _oCurrentPlayerMinigameDevice
						_SpeacialButtonMutex = true
						int loc_mult = 1 + _SpecialButton_Bonus
						_SpecialButton_Bonus = 0
						_oCurrentPlayerMinigameDevice.SpecialButtonPressed(loc_mult)
						_SpeacialButtonMutex = false
					endif
					return
				endif
				if (_crit) && !UD_AutoCrit
					if selected_crit_meter == "S" && KeyCode == Stamina_meter_Keycode
						crit = False
						_crit = False
						if TraceAllowed()					
							Log("Crit detected for Stamina bar! Keycode: " + KeyCode)
						endif
						_oCurrentPlayerMinigameDevice.critDevice()
						return
					elseif selected_crit_meter == "M" && KeyCode == Magicka_meter_Keycode
						crit = False
						_crit = False
						if TraceAllowed()					
							Log("Crit detected for Magicka bar! Keycode: " + KeyCode)
						endif
						_oCurrentPlayerMinigameDevice.critDevice()
						return
					elseif KeyCode == Magicka_meter_Keycode || KeyCode == Stamina_meter_Keycode
						crit = False
						_crit = False
						if TraceAllowed()					
							Log("Crit failure detected! Keycode: " + KeyCode)
						endif
						_oCurrentPlayerMinigameDevice.critFailure()
						return
					elseif KeyCode == ActionKey_Keycode
						if TraceAllowed()					
							Log("ActionKey_Keycode pressed! Keycode: " + KeyCode)
						endif
						_oCurrentPlayerMinigameDevice.stopMinigame()
						crit = false
						return 
					endif
				endif
				if KeyCode == ActionKey_Keycode
					if _oCurrentPlayerMinigameDevice
						_oCurrentPlayerMinigameDevice.stopMinigame()
					endif
					return
				elseif (KeyCode == Stamina_meter_Keycode || KeyCode == Magicka_meter_Keycode) && !UD_AutoCrit
					crit = False
					_crit = False
					_oCurrentPlayerMinigameDevice.critFailure()
					return
				endif
			endif
		endif
	EndEvent

	Event OnKeyUp(Int KeyCode, Float HoldTime)
		if KeyCode == SpecialKey_Keycode
			_specialButtonOn = false
			if _oCurrentPlayerMinigameDevice
				_oCurrentPlayerMinigameDevice.SpecialButtonReleased(HoldTime)
			endif
			return
		endif
	EndEvent
EndState

;bool _SpeacialButtonMutex = false
;int _SpecialButton_Bonus = 0 ;how much times was special button pressed while it was proccessing
;bool _specialButtonOn = false
Event OnKeyDown(Int KeyCode)
	bool loc_menuopen = UDmain.IsMenuOpen()
	if !loc_menuopen ;only if player is not in menu
		if KeyCode == PlayerMenu_KeyCode
			PlayerMenu()
		endif
	endif
EndEvent

Event OnKeyUp(Int KeyCode, Float HoldTime)
	if !UDmain.IsMenuOpen()
		if KeyCode == StruggleKey_Keycode
			if HoldTime < 0.2
				if lastOpenedDevice
					lastOpenedDevice.deviceMenu(new Bool[30])
				elseif libs.playerRef.wornhaskeyword(libs.zad_deviousheavybondage)
					if !lastOpenedDevice
						lastOpenedDevice = getHeavyBondageDevice(Game.getPlayer())
					endif
					lastOpenedDevice.deviceMenu(new Bool[30])
				endif
			else
				UD_CustomDevice_RenderScript loc_device = UDCD_NPCM.getPlayerSlot().GetUserSelectedDevice()
				if loc_device
					loc_device.deviceMenu(new Bool[30])
				endif
			endif
		elseif KeyCode == NPCMenu_Keycode
			ObjectReference loc_ref = Game.GetCurrentCrosshairRef()
			if loc_ref as Actor
				Actor loc_actor = loc_ref as Actor
				if !loc_actor.isDead() && UDmain.ActorIsValidForUD(loc_actor)
					if HoldTime <= 0.2
						NPCMenu(loc_actor)
					else
						bool loc_actorisregistered = isRegistered(loc_actor)
						if loc_actorisregistered
							bool loc_actorisfollower = ActorIsFollower(loc_actor)
							bool loc_actorishelpless = (!actorFreeHands(loc_actor) || loc_actor.getAV("paralysis") || loc_actor.GetSleepState() == 3) && actorFreeHands(Game.getPlayer())
							if loc_actorisfollower || loc_actorishelpless
								HelpNPC(loc_actor,Game.getPlayer(),loc_actorisfollower)
							endif
						endif
					endif
				endif
			endif
		endif
	endif
EndEvent

Function SetMessageAlias(Actor akActor1,Actor akActor2 = none,zadequipscript arDevice = none)
	if akActor1
		MessageActor1.ForceRefTo(akActor1)
	endif
	if akActor2
		MessageActor2.ForceRefTo(akActor2)
	endif
	if arDevice
		MessageDevice.ForceRefTo(arDevice)
	endif
EndFunction

Bool Property UD_CurrentNPCMenuIsFollower = False auto conditional hidden
Bool Property UD_CurrentNPCMenuIsRegistered = False auto conditional hidden
Bool Property UD_CurrentNPCMenuTargetIsHelpless = False auto conditional hidden
Function NPCMenu(Actor akActor)
	SetMessageAlias(akActor)
	UD_CurrentNPCMenuIsFollower = ActorIsFollower(akActor)
	UD_CurrentNPCMenuIsRegistered = isRegistered(akActor)
	UD_CurrentNPCMenuTargetIsHelpless = (!actorFreeHands(akActor) || akActor.getAV("paralysis") || akActor.GetSleepState() == 3) && actorFreeHands(Game.getPlayer())
	int loc_res = NPCDebugMenuMsg.show()
	if loc_res == 0
		UDCD_NPCM.RegisterNPC(akActor,true)
	elseif loc_res == 1
		UDCD_NPCM.UnregisterNPC(akActor,true)
	elseif loc_res == 2 ;Acces devices
		HelpNPC(akActor,Game.getPlayer(),ActorIsFollower(akActor))
	elseif loc_res == 3 ; get help
		HelpNPC(Game.getPlayer(),akActor,false)
	elseif loc_res == 4
		UndressArmor(akActor)
		akActor.UpdateWeight(0)
	elseif loc_res == 5
		DebugFunction(akActor)
	elseif loc_res == 6
		akActor.openInventory(True)
	elseif loc_res == 7
		if !StorageUtil.GetIntValue(akActor,"UDNPCMenu_SetDontMove",0)
			StorageUtil.SetIntValue(akActor,"UDNPCMenu_SetDontMove",1)
			akActor.setDontMove(true)
		else
			StorageUtil.UnSetIntValue(akActor,"UDNPCMenu_SetDontMove")
			akActor.setDontMove(false)
		endif
	elseif loc_res == 8
		showActorDetails(akActor)
	else
		return
	endif
EndFunction

Function HelpNPC(Actor akVictim,Actor akHelper,bool bAllowCommand)
	UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akVictim)
	if loc_slot
		UD_CustomDevice_RenderScript loc_device = loc_slot.GetUserSelectedDevice()
		if loc_device
			OpenHelpDeviceMenu(loc_device,akHelper,bAllowCommand)
		endif
	endif
EndFunction

Function OpenHelpDeviceMenu(UD_CustomDevice_RenderScript device,Actor akHelper,bool bAllowCommand,bool bIgnoreCooldown = false)
	if device && akHelper
		bool[] loc_arrcontrol = new bool[30]
		bool loc_cond = true
		if !bIgnoreCooldown
			float loc_currenttime = Utility.GetCurrentGameTime()
			float loc_cooldowntime = StorageUtil.GetFloatValue(akHelper,"UDNPCCD:"+device.getWearer(),loc_currenttime)
			if loc_cooldowntime > loc_currenttime
				Print("On cooldown! (" + ToUnsig(Round(((loc_cooldowntime - loc_currenttime)*24*60)))+" min)")
				loc_cond = false
			endif
		endif
		
		if UDOM.GetOrgasmingCount(device.getWearer()) ||  UDOM.GetOrgasmingCount(akHelper) ;actor is orgasming, prevent help
			loc_cond = false
			bAllowCommand = false
		endif
		
		if !loc_cond 
			int i = 18
			while i 
				i -= 1
				loc_arrcontrol[i] = true
			endwhile
			loc_arrcontrol[15] = false
			loc_arrcontrol[16] = false
		else
			;tying and repairing doesn't sound like helping
			loc_arrcontrol[06] = true
			loc_arrcontrol[07] = true
		endif

		loc_arrcontrol[14] = !bAllowCommand

		device.deviceMenuWH(akHelper,loc_arrcontrol)
	endif
EndFunction


float Function CalculateHelperCD(Actor akActor,Int iLevel = 0)
	if iLevel <= 0
		iLevel = GetHelperLVL(akActor)
	endif
	float loc_res = UD_MinigameHelpCd - Round((iLevel - 1)*(UD_MinigameHelpCD_PerLVL/100.0)*UD_MinigameHelpCd)
	loc_res = fRange(loc_res,5.0,600.0) ;crop the value
	loc_res = loc_res/(60.0*24.0) ;convert to days
	return loc_res
EndFunction

int Function ResetHelperCD(Actor akHelper,Actor akHelped,Int iXP = 0)
	Int loc_lvl = 1
	if iXP > 0
		loc_lvl = addHelperXP(akHelper, iXP)
	else
		loc_lvl = GetHelperLVL(akHelper)
	endif
	StorageUtil.SetFloatValue(akHelper,"UDNPCCD:"+akHelped,Utility.GetCurrentGameTime() + CalculateHelperCD(akHelper,loc_lvl))
	return loc_lvl
EndFunction


;returns updated lvl
int Function addHelperXP(Actor akHelper, int iXP)
	int loc_currentXP = StorageUtil.GetIntValue(akHelper,"UDNPCXP",0)
	int loc_currentLVL = GetHelperLVL(akHelper)
	int loc_nextXP = loc_currentXP + iXP
	int loc_nextLVL = loc_currentLVL
	while loc_nextXP >= loc_nextLVL*100
		loc_nextXP -= loc_nextLVL*100
		loc_nextLVL += 1
	endwhile
	StorageUtil.SetIntValue(akHelper,"UDNPCXP",loc_nextXP)
	if loc_nextLVL != loc_currentLVL
		StorageUtil.SetIntValue(akHelper,"UDNPCLVL",loc_nextLVL)
	endif
	return loc_nextLVL
EndFunction

int Function GetHelperLVL(Actor akHelper)
	return StorageUtil.GetIntValue(akHelper,"UDNPCLVL",1)
EndFunction

float Function GetHelperLVLProgress(Actor akHelper)
	int loc_currentXP = StorageUtil.GetIntValue(akHelper,"UDNPCXP",0)
	int loc_currentLVL = StorageUtil.GetIntValue(akHelper,"UDNPCLVL",1)
	return loc_currentXP/(100.0*(loc_currentLVL))
EndFunction

Function PlayerMenu()
	int loc_playerMenuRes = PlayerMenuMsg.show()
	if loc_playerMenuRes == 0
		UDOM.FocusOrgasmResistMinigame(Game.getPlayer())
	elseif loc_playerMenuRes == 1
		UndressArmor(Game.getPlayer())
	elseif loc_playerMenuRes == 2
		showActorDetails(Game.getPlayer())
	elseif loc_playerMenuRes == 3
		DebugFunction(Game.getPlayer())
	else
		return
	endif
EndFunction

Function UndressArmor(Actor akActor)
	Form[] loc_armors
	String[] loc_armorsnames
	int loc_mask = 0x00000001
	while loc_mask != 0x00004000
		Form loc_armor = akActor.GetWornForm(loc_mask)
		if loc_armor
			if !loc_armor.haskeyword(libs.zad_Lockable) && !loc_armor.HasKeyWordString("SexLabNoStrip")
				if !loc_armors || !PapyrusUtil.CountForm(loc_armors,loc_armor)
					loc_armors = PapyrusUtil.PushForm(loc_armors,loc_armor)
					loc_armorsnames = PapyrusUtil.PushString(loc_armorsnames,loc_armor.getName())
				endif
			endif
		endif
		loc_mask = Math.LeftShift(loc_mask,1)
	endwhile
	loc_armorsnames = PapyrusUtil.PushString(loc_armorsnames,"--ALL--")
	loc_armorsnames = PapyrusUtil.PushString(loc_armorsnames,"--BACK--")
	int loc_res = GetUserListInput(loc_armorsnames)
	if loc_res == (loc_armorsnames.length - 2)
		libs.strip(akActor,false)
	elseif loc_res < (loc_armorsnames.length - 2) && loc_res >= 0
		akActor.unequipItem(loc_armors[loc_res], abSilent = true)
	endif
EndFunction

Function UndressAllArmor(Actor akActor)
	Form[] loc_armors
	int loc_mask = 0x00000001
	while loc_mask != 0x00004000
		Form loc_armor = akActor.GetWornForm(loc_mask)
		if loc_armor
			if !loc_armor.haskeyword(libs.zad_Lockable) && !loc_armor.HasKeyWordString("SexLabNoStrip")
				if !loc_armors || !PapyrusUtil.CountForm(loc_armors,loc_armor)
					loc_armors = PapyrusUtil.PushForm(loc_armors,loc_armor)
				endif
			endif
		endif
		loc_mask = Math.LeftShift(loc_mask,1)
	endwhile
	int loc_armornum = loc_armors.length
	while loc_armornum
		loc_armornum -= 1
		akActor.unequipItem(loc_armors[loc_armornum], abSilent = true)
	endwhile
EndFunction

;function made as replacemant for akActor.isEquipped, because that function doesn't work for NPCs
bool Function CheckRenderDeviceEquipped(Actor akActor, Armor rendDevice)
	if !akActor
		return false
	endif
	if ActorIsPlayer(akActor)
		return akActor.isEquipped(rendDevice) ;works fine for player, use this as its faster
	endif
	int loc_mask = 0x00000001
	int loc_devicemask = rendDevice.GetSlotMask()
	while loc_mask < 0x80000000
		if loc_mask > loc_devicemask
			return false
		endif
		if Math.LogicalAnd(loc_mask,loc_devicemask)
			Form loc_armor = akActor.GetWornForm(loc_mask)
			if loc_armor ;check if there is anything in slot
				if (loc_armor as Armor) == rendDevice
					return true ;render device is equipped
				else
					return false ;;render device is unequipped
				endif
			endif
		endif
		loc_mask = Math.LeftShift(loc_mask,1)
	endwhile
	return false ;device is not equipped
EndFunction

Form Function GetShield(Actor akActor)
	Form loc_shield = akActor.GetEquippedObject(0)
	if loc_shield && (loc_shield.GetType() == 26 || loc_shield.GetType() == 31)
		return loc_shield
	else
		return none
	endif
EndFunction

;function made as replacemant for akActor.isEquipped, because that function doesn't work for NPCs
int Function CheckRenderDeviceConflict(Actor akActor, Armor rendDevice)
	if !akActor
		return 3
	endif
	int loc_mask = 0x00000001
	int loc_devicemask = rendDevice.GetSlotMask()
	while loc_mask < 0x80000000
		if loc_mask > loc_devicemask
			return 0 ;slots are empty, lock should succes
		endif
		if Math.LogicalAnd(loc_mask,loc_devicemask)
			Form loc_armor = akActor.GetWornForm(loc_mask)
			if loc_armor ;check if there is anything in slot
				if (loc_armor as Armor) == rendDevice
					return 1 ;same render device is already equipped
				elseif loc_armor.haskeyword(libs.zad_Lockable)
					return 2 ;slot already occupied
				endif
			else
				;slot if empty, continue
			endif
		endif
		loc_mask = Math.LeftShift(loc_mask,1)
	endwhile
	return 0 ;slots are empty, lock should succes
EndFunction

Function showActorDetails(Actor akActor)
	string loc_res = ""
	loc_res += "--BASE DETAILS--\n"

	if UDmain.UD_InfoLevel == 2
		loc_res += "Name: " + akActor.GetLeveledActorBase().GetName() + "\n"
		loc_res += "LVL: " + akActor.GetLevel() + "\n"
		loc_res += "HP: " + formatString(akActor.getAV("Health"),1) + "/" +  formatString(getMaxActorValue(akActor,"Health"),1) + " ("+ Round(getCurrentActorValuePerc(akActor,"Health")*100) +" %)" +"\n"
		loc_res += "MP: " + formatString(akActor.getAV("Magicka"),1) + "/" + formatString(getMaxActorValue(akActor,"Magicka"),1) + " ( "+ Round(getCurrentActorValuePerc(akActor,"Magicka")*100) +" %)" +"\n"
		loc_res += "SP: " + formatString(akActor.getAV("Stamina"),1) + "/" +  formatString(getMaxActorValue(akActor,"Stamina"),1) + " ("+ Round(getCurrentActorValuePerc(akActor,"Stamina")*100) +" %)" +"\n"
		if IsRegistered(akActor)
			UD_CustomDevice_NPCSlot loc_slot = GetNPCSlot(akActor)
			if loc_slot
				loc_res += "Agility skill: " + Round(loc_slot.AgilitySkill) + "\n"
				loc_res += "Strength skill: " + Round(loc_slot.StrengthSkill) + "\n"
				loc_res += "Magicka skill: " + Round(loc_slot.MagickSkill) + "\n"
				loc_res += "Cutting skill: " + Round(loc_slot.CuttingSkill) + "\n"
			else
				loc_res += "Agility skill: " + Round(getAgilitySkill(akActor)) + "\n"
				loc_res += "Strength skill: " + Round(getStrengthSkill(akActor)) + "\n"
				loc_res += "Magicka skill: " + Round(getMagickSkill(akActor)) + "\n"
				loc_res += "Cutting skill: " + Round(getCuttingSkill(akActor)) + "\n"
			endif
		else
			loc_res += "Agility skill: " + Round(getAgilitySkill(akActor)) + "\n"
			loc_res += "Strength skill: " + Round(getStrengthSkill(akActor)) + "\n"
			loc_res += "Magicka skill: " + Round(getMagickSkill(akActor)) + "\n"
			loc_res += "Cutting skill: " + Round(getCuttingSkill(akActor)) + "\n"
		endif

		ShowMessageBox(loc_res)
		
		if Game.UsingGamepad()
			Utility.waitMenuMode(0.75)
		endif
		string loc_orgStr = ""
		loc_orgStr += "--ORGASM DETAILS--\n"
		loc_orgStr += "Active vibrators: " + GetActivatedVibrators(akActor) + "(S="+StorageUtil.GetIntValue(akActor,"UD_ActiveVib_Strength",0)+")" + "\n"
		loc_orgStr += "Arousal: " + UDOM.getArousal(akActor) + "\n"
		loc_orgStr += "Arousal Rate(M): " + formatString(UDOM.getArousalRateM(akActor),2) + "\n"
		loc_orgStr += "Arousal Rate Mult: " + Round(UDOM.getArousalRateMultiplier(akActor)*100) + " %\n"
		loc_orgStr += "Orgasm capacity: " + Round(UDOM.getActorOrgasmCapacity(akActor)) + "\n"
		loc_orgStr += "Orgasm resistence(M): " + FormatString(UDOM.getActorOrgasmResistM(akActor),1) + "\n"
		loc_orgStr += "Orgasm progress: " + formatString(UDOM.getOrgasmProgressPerc(akActor) * 100,2) + " %\n"
		loc_orgStr += "Orgasm rate: " + formatString(UDOM.getActorAfterMultOrgasmRate(akActor),2) + " - " + formatString(UDOM.getActorAfterMultAntiOrgasmRate(akActor),2) + " Op/s\n"
		loc_orgStr += "Orgasm mult: " + Round(UDOM.getActorOrgasmRateMultiplier(akActor)*100.0) + " %\n"
		loc_orgStr += "Orgasm resisting: " + Round(UDOM.getActorOrgasmResistMultiplier(akActor)*100.0) + " %\n"
		loc_orgStr += "Orgasm exhaustion: " + UDOM.GetOrgasmExhaustion(akActor) + "\n"
		
		ShowMessageBox(loc_orgStr)
		if Game.UsingGamepad()
			Utility.waitMenuMode(0.75)
		endif
		
		ShowHelperDetails(akActor)
		
		if Game.UsingGamepad()
			Utility.waitMenuMode(0.75)
		endif
		
		Weapon loc_sharpestWeapon = getSharpestWeapon(akActor)
		if loc_sharpestWeapon
			string loc_cuttStr = ""
			loc_cuttStr += "--CUTTING DETAILS--\n"
			loc_cuttStr += "Sharpest weapon: " + loc_sharpestWeapon.getName() + "\n"
			loc_cuttStr += "Cutting multiplier: " + FormatString(loc_sharpestWeapon.getBaseDamage()*2.5,1) + " %\n"
			
			ShowMessageBox(loc_cuttStr)
		endif
		
		if UDmain.DebugMod
			string loc_debugStr = "--DEBUG DETAILS--\n"
			loc_debugStr += "Registered: " + akActor.isInFaction(RegisteredNPCFaction) + "\n"
			loc_debugStr += "Orgasm Check: " + akActor.IsInFaction(UDOM.OrgasmCheckLoopFaction) + "\n"
			loc_debugStr += "Arousal Check: " + akActor.isInFaction(UDOM.ArousalCheckLoopFaction) + "\n"
			loc_debugStr += "Orgasm Check Spell: " + akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW) + "\n"
			loc_debugStr += "Arousal Check Spell: " + akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW) + "\n"
			loc_debugStr += "Hardcore Disable: " + akActor.HasMagicEffectWithKeyword(UDlibs.HardcoreDisable_KW) + "\n"
			loc_debugStr += "Animating: " + libs.IsAnimating(akActor) + "\n"
			loc_debugStr += "Animation block: " + akActor.isInFaction(BlockAnimationFaction) + "\n"
			loc_debugStr += "Expression level: " + akActor.GetFactionRank(BlockExpressionFaction) +"\n"
			loc_debugStr += "Valid: " + libs.IsValidActor(akActor) +"\n"
			ShowMessageBox(loc_debugStr)
			
			if !libs.IsValidActor(akActor)
				loc_debugStr = "--DEBUG VALID DETAILS--\n"
				loc_debugStr += "Is3DLoaded: " + akActor.Is3DLoaded() +"\n"
				loc_debugStr += "IsDead: " + akActor.IsDead() +"\n"
				loc_debugStr += "IsDisabled: " + akActor.IsDisabled() +"\n"
				loc_debugStr += "CurrentScene: " + akActor.GetCurrentScene() +"\n"
				if akActor.GetCurrentScene() != none 
					loc_debugStr += "CurrentScene-Playing: " + akActor.GetCurrentScene().IsPlaying() +"\n"
					loc_debugStr += "CurrentScene-Quest: " + akActor.GetCurrentScene().GetOwningQuest() +"\n"
				endif
				
				
				ShowMessageBox(loc_debugStr)
			endif
			
		endif
	elseif UDmain.UD_InfoLevel == 1
		loc_res += "Name: " + akActor.GetLeveledActorBase().GetName() + "(LVL = " +akActor.GetLevel() + ")\n"
		loc_res += "HP: " + formatString(akActor.getAV("Health"),1) + "/" +  formatString(getMaxActorValue(akActor,"Health"),1) + " ("+ Round(getCurrentActorValuePerc(akActor,"Health")*100) +" %)" +"\n"
		loc_res += "MP: " + formatString(akActor.getAV("Magicka"),1) + "/" + formatString(getMaxActorValue(akActor,"Magicka"),1) + " ( "+ Round(getCurrentActorValuePerc(akActor,"Magicka")*100) +" %)" +"\n"
		loc_res += "SP: " + formatString(akActor.getAV("Stamina"),1) + "/" +  formatString(getMaxActorValue(akActor,"Stamina"),1) + " ("+ Round(getCurrentActorValuePerc(akActor,"Stamina")*100) +" %)" +"\n"
		Weapon loc_sharpestWeapon = getSharpestWeapon(akActor)
		loc_res += "Sharpest weapon: " + loc_sharpestWeapon.getName() +" (" + FormatString(loc_sharpestWeapon.getBaseDamage()*2.5,1) +" %)\n"
		loc_res += "Active vibrators: " + GetActivatedVibrators(akActor) + " (Str = "+StorageUtil.GetIntValue(akActor,"UD_ActiveVib_Strength",0)+")" + "\n"
		loc_res += "Arousal / rate: " + UDOM.getArousal(akActor) + " / " + formatString(UDOM.getArousalRateM(akActor),2) + "\n"
		loc_res += "Orgasm progress: " + formatString(UDOM.getOrgasmProgressPerc(akActor) * 100,2) + " %\n"
		loc_res += "Orgasm Rate(M): " + formatString(UDOM.getActorAfterMultOrgasmRate(akActor),2) + " - " + formatString(UDOM.getActorAfterMultAntiOrgasmRate(akActor),2) + " Op/s\n"
		loc_res += "Orgasm exhaustion: " + UDOM.GetOrgasmExhaustion(akActor) + "\n"
		
		loc_res += GetHelperDetails(akActor)
		
		ShowMessageBox(loc_res)
		
		if UDmain.DebugMod
			string loc_debugStr = "--DEBUG DETAILS--\n"
			loc_debugStr += "Registered: " + akActor.isInFaction(RegisteredNPCFaction) + "\n"
			loc_debugStr += "Orgasm Check: " + akActor.IsInFaction(UDOM.OrgasmCheckLoopFaction) + "\n"
			loc_debugStr += "Arousal Check: " + akActor.isInFaction(UDOM.ArousalCheckLoopFaction) + "\n"
			loc_debugStr += "Orgasm Check Spell: " + akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW) + "\n"
			loc_debugStr += "Arousal Check Spell: " + akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW) + "\n"
			loc_debugStr += "Hardcore Disable: " + akActor.HasMagicEffectWithKeyword(UDlibs.HardcoreDisable_KW) + "\n"
			loc_debugStr += "Animating: " + libs.IsAnimating(akActor) + "\n"
			loc_debugStr += "Animation block: " + akActor.isInFaction(BlockAnimationFaction) + "\n"
			loc_debugStr += "Expression level: " + akActor.GetFactionRank(BlockExpressionFaction) +"\n"
			loc_debugStr += "Valid: " + libs.IsValidActor(akActor) +"\n"
			ShowMessageBox(loc_debugStr)
			
			if !libs.IsValidActor(akActor)
				loc_debugStr = "--DEBUG VALID DETAILS--\n"
				loc_debugStr += "Is3DLoaded: " + akActor.Is3DLoaded() +"\n"
				loc_debugStr += "IsDead: " + akActor.IsDead() +"\n"
				loc_debugStr += "IsDisabled: " + akActor.IsDisabled() +"\n"
				loc_debugStr += "CurrentScene: " + akActor.GetCurrentScene() +"\n"
				if akActor.GetCurrentScene() != none 
					loc_debugStr += "CurrentScene-Playing: " + akActor.GetCurrentScene().IsPlaying() +"\n"
					loc_debugStr += "CurrentScene-Quest: " + akActor.GetCurrentScene().GetOwningQuest() +"\n"
				endif
				
				
				ShowMessageBox(loc_debugStr)
			endif
		endif
	elseif UDmain.UD_InfoLevel == 0
		loc_res += "Name: " + akActor.GetLeveledActorBase().GetName() + "(LVL = " +akActor.GetLevel() + ")\n"
		loc_res += "HP/MP/SP: "+ Round(getCurrentActorValuePerc(akActor,"Health")*100) + " / " + Round(getCurrentActorValuePerc(akActor,"Magicka")*100) +" / "+ Round(getCurrentActorValuePerc(akActor,"Stamina")*100) +" %\n"
		loc_res += "Active vibrators: " + GetActivatedVibrators(akActor) + "(S="+StorageUtil.GetIntValue(akActor,"UD_ActiveVib_Strength",0)+")" + "\n"
		loc_res += "Arousal / rate: " + UDOM.getArousal(akActor) + " / " + formatString(UDOM.getArousalRateM(akActor),2) + "\n"
		loc_res += "Orgasm progress: " + formatString(UDOM.getOrgasmProgressPerc(akActor) * 100,2) + " %\n"
		loc_res += "Orgasm Rate(M): " + formatString(UDOM.getActorAfterMultOrgasmRate(akActor),2) + " - " + formatString(UDOM.getActorAfterMultAntiOrgasmRate(akActor),2) + " Op/s\n"
		loc_res += "Helper LVL: " + GetHelperLVL(akActor) +"("+Round(GetHelperLVLProgress(akActor)*100)+"%)" + "\n"
		ShowMessageBox(loc_res)
	endif
EndFunction

Function ShowHelperDetails(Actor akActor)
	ShowMessageBox(GetHelperDetails(akActor))
EndFunction

string Function GetHelperDetails(Actor akActor)
	string loc_res = ""
	loc_res += "--Helper details--\n"
	loc_res += "Helper LVL: " + GetHelperLVL(akActor) +"("+Round(GetHelperLVLProgress(akActor)*100)+"%)" + "\n"
	loc_res += "Base Cooldown: " + Round(CalculateHelperCD(akActor)*24*60) + " min\n"
	float loc_currenttime = Utility.GetCurrentGameTime()
	float loc_cooldowntimeHP = StorageUtil.GetFloatValue(akActor,"UDNPCCD:"+Game.getPlayer(),loc_currenttime)
	float loc_cooldowntimePH = StorageUtil.GetFloatValue(Game.getPlayer(),"UDNPCCD:"+akActor,loc_currenttime)
	loc_res += "Avaible in (H->P): " + ToUnsig(Round(((loc_cooldowntimeHP - loc_currenttime)*24*60))) + " min\n"
	loc_res += "Avaible in (P->H): " + ToUnsig(Round(((loc_cooldowntimePH - loc_currenttime)*24*60))) + " min\n"
	return loc_res
EndFunction

;///////////////////////////////////////
;=======================================
;			SKILL FUNCTIONS
;=======================================
;//////////////////////////////////////;
;-Used to return absolute and relative skill values which are used by some minigames

float Function GetAgilitySkill(Actor akActor)
	UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akActor)
	if loc_slot
		return loc_slot.AgilitySkill
	else
		return getActorAgilitySkills(akActor)
	endif
EndFunction

float Function getActorAgilitySkills(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("Pickpocket")
	loc_result += GetPerkSkill(akActor,UD_AgilityPerks,10)
	return loc_result
EndFunction

float Function getActorAgilitySkillsPerc(Actor akActor)
	return GetAgilitySkill(akActor)/100.0
EndFunction

float Function GetStrengthSkill(Actor akActor)
	UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akActor)
	if loc_slot
		return loc_slot.StrengthSkill
	else
		return getActorStrengthSkills(akActor)
	endif
EndFunction

float Function getActorStrengthSkills(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("TwoHanded")
	loc_result += GetPerkSkill(akActor,UD_StrengthPerks,10)
	return loc_result
EndFunction

float Function getActorStrengthSkillsPerc(Actor akActor)
	return GetStrengthSkill(akActor)/100.0
EndFunction

float Function GetMagickSkill(Actor akActor)
	UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akActor)
	if loc_slot
		return loc_slot.MagickSkill
	else
		return getActorMagickSkills(akActor)
	endif
EndFunction

float Function getActorMagickSkills(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("Destruction")
	loc_result += GetPerkSkill(akActor,UD_MagickPerks,10)
	return loc_result
EndFunction

float Function getActorMagickSkillsPerc(Actor akActor)
	return GetMagickSkill(akActor)/100.0
EndFunction

float Function GetCuttingSkill(Actor akActor)
	UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akActor)
	if loc_slot
		return loc_slot.CuttingSkill
	else
		return getActorCuttingSkills(akActor)
	endif
EndFunction

float Function getActorCuttingSkills(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("OneHanded")
	return loc_result
EndFunction

float Function getActorCuttingSkillsPerc(Actor akActor)
	return GetCuttingSkill(akActor)/100.0
EndFunction

float Function GetSmithingSkill(Actor akActor)
	UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akActor)
	if loc_slot
		return loc_slot.SmithingSkill
	else
		return getActorSmithingSkills(akActor)
	endif
EndFunction

float Function getActorSmithingSkills(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("Smithing")
	
	return loc_result
EndFunction

float Function getActorSmithingSkillsPerc(Actor akActor)
	return GetSmithingSkill(akActor)/100.0
EndFunction

int Function GetPerkSkill(Actor akActor, Formlist akPerkList, int aiSkillPerPerk = 10)
	if !akActor
		Error("GetPerkSkill - actor is none")
		return 0
	endif
	if !akPerkList
		Error("GetPerkSkill("+getActorName(akActor)+") - akPerkList is none")
		return 0
	endif
	int loc_size = akPerkList.getSize()
	int loc_res = 0
	while loc_size
		loc_size -= 1
		Perk loc_perk = akPerkList.GetAt(loc_size) as Perk
		if akActor.hasperk(loc_perk)
			loc_res += aiSkillPerPerk
		endif
	endwhile
	return loc_res
EndFunction

;calculates multiplier for cutting minigame
;value is decided by weapon with sharp wapon with most dmg
;is much faster if NPC is registered, otherwise it will need to search whole inventory
Float Function getActorCuttingWeaponMultiplier(Actor akActor)
	float loc_res = 1.0 ;100%
	
	Weapon loc_bestWeapon = getSharpestWeapon(akActor)
	
	if loc_bestWeapon
		loc_res += loc_bestWeapon.getBaseDamage()*0.025
	endif
	
	return fRange(loc_res,1.0,3.0)
EndFunction

Weapon Function getSharpestWeapon(Actor akActor)
	Weapon loc_bestWeapon = none
	if isRegistered(akActor)
		UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akActor)
		loc_bestWeapon = loc_slot.getBestWeapon()
	else
		int loc_i = akActor.GetNumItems()
		while loc_i
			loc_i -= 1
			Weapon loc_weapon = akActor.GetNthForm(loc_i) as Weapon
			if loc_weapon
				if isSharp(loc_weapon)
					if !loc_bestWeapon
						loc_bestWeapon = loc_weapon
					elseif (loc_weapon.getBaseDamage() > loc_bestWeapon.GetBaseDamage())
						loc_bestWeapon = loc_weapon
					endif
				endif
			endif
		endwhile
	endif
	return loc_bestWeapon
EndFunction

bool Function isSharp(Weapon wWeapon)
	bool 	loc_cond = false
	int		loc_type = wWeapon.GetWeaponType()
	loc_cond = loc_cond || (loc_type > 0 && loc_type < 4) ;swords, daggers, war axes
	loc_cond = loc_cond || (loc_type == 5) ;great swords
	loc_cond = loc_cond || (loc_type == 6) ;battleaxes and warhammes
	return loc_cond
	;/
	int loc_i = UDlibs.SharpWeaponsKeywords.length
	
	while loc_i
		loc_i -= 1
		if wWeapon.hasKeyword(UDlibs.SharpWeaponsKeywords[loc_i])
			return true
		endif
	endwhile
	return false
	/;
EndFunction

Int Function ActorBelted(Actor akActor)
	int loc_res = 0 ;actor doesn't have belt
	If akActor.WornHasKeyword(libs.zad_DeviousBelt)		;rewritten per issue: https://github.com/IHateMyKite/UnforgivingDevices/issues/17
		;Armor loc_belt = libs.GetWornRenderedDeviceByKeyword(akActor, libs.zad_DeviousBelt)	;this function is painstakingly slow on cluttered inventories.
		Armor loc_belt = getEquippedRender(akActor,libs.zad_DeviousBelt) ;little faster acces
		if loc_belt
			if !loc_belt.HasKeyword(libs.zad_PermitAnal)
				loc_res = 1 ;Actor has belt which doesn't permit anal 
			else
				loc_res = 2 ;Actor has belt which permits anal 
			EndIf
		else
			Error("ActorBelted("+getActorName(akActor)+") - actor have belt keyword but doesn't have belt!")
		endif
	EndIf
	return loc_res
EndFunction

Int Function GetActivatedVibrators(Actor akActor)
	;/
	if akActor.isInFaction(VibrationFaction)
		return akActor.getFactionRank(VibrationFaction)
	else
		return 0
	endif
	/;
	return StorageUtil.GetIntValue(akActor,"UD_ActiveVib",0)
EndFunction

;manipulation vars, don't tough!
int lockpicknum
int usedLockpicks

;sets lockpick container
Function ReadyLockPickContainer(int lock_difficulty,Actor owner)
	_LockPickContainer = LockPickContainer_ObjRef.placeAtMe(LockPickContainer)
	_LockPickContainer.lock(True)
	_LockPickContainer.SetLockLevel(lock_difficulty)
	_LockPickContainer.SetActorOwner(owner.GetActorBase())
	_LockPickContainer.SetFactionOwner(PlayerFaction)
EndFunction

Function DeleteLockPickContainer()
	_LockPickContainer.delete()
EndFunction

;starts vannila lockpick minigame
Function startLockpickMinigame()
	;setScriptState(_oCurrentPlayerMinigameDevice.getWearer(),3)
	LockpickMinigameOver = false
	
	lockpicknum = Game.getPlayer().GetItemCount(Lockpick)
	
	if lockpicknum >= UD_LockpicksPerMinigame
		usedLockpicks = UD_LockpicksPerMinigame
	else
		usedLockpicks = lockpicknum
	endif
	Game.getPlayer().RemoveItem(Lockpick, lockpicknum - usedLockpicks, True)
	if TraceAllowed()	
		Log("Lockpick minigame opened, lockpicks before: "+lockpicknum+" ;lockpicks taken: " + (lockpicknum - usedLockpicks) + " ;Lockpicks to use: "+ usedLockpicks,1)
	endif
	RegisterForMenu("Lockpicking Menu")
	if UDmain.ConsoleUtilInstalled
		ConsoleUtil.ExecuteCommand("ToggleDetection")
	endif
	_LockPickContainer.activate(Game.getPlayer())
EndFunction

;detect when the lockpick minigame ends
bool Property LockpickMinigameOver = false auto hidden
int Property LockpickMinigameResult = 0 auto hidden
Event OnMenuClose(String MenuName)
	if MenuName == "Lockpicking Menu"
		if UDmain.ConsoleUtilInstalled
			ConsoleUtil.ExecuteCommand("ToggleDetection")
		endif
		int remainingLockpicks = Game.getPlayer().GetItemCount(Lockpick)
		
		if remainingLockpicks > 0
			if !_LockPickContainer.IsLocked()
				LockpickMinigameResult = 1 ;player succesfully finished minigame
			elseif remainingLockpicks == usedLockpicks
				LockpickMinigameResult = 0 ;player exited minigame before trying to pick the lock
			else
				LockpickMinigameResult = 2 ;player aborted mnigame after breaking at least one lockpick
			endif
		else
			LockpickMinigameResult = 2 ;player tried to lockpick the device but failed (all lockpicks broke)
		endif
		if TraceAllowed()		
			Log("Lockpick minigame closed, lockpicks returned: " + (lockpicknum - usedLockpicks) + " ; Result: " + LockpickMinigameResult,1)
		endif
		Game.getPlayer().AddItem(Lockpick, lockpicknum - usedLockpicks, True)
		UnregisterForAllMenus()
		LockpickMinigameOver = True
	endif
EndEvent

Keyword Function GetHeavyBondageKeyword(Armor akDevice)
	int loc_kwnum = UD_HeavyBondageKeywords.getSize()
	while loc_kwnum
		loc_kwnum -= 1
		Keyword loc_kw = UD_HeavyBondageKeywords.GetAt(loc_kwnum) as Keyword
		if akDevice.haskeyword(loc_kw)
			return loc_kw
		endif
	endwhile
	return none
EndFunction

;returns first device which have connected corresponding Inventory Device
UD_CustomDevice_RenderScript Function getDeviceByInventory(Actor akActor, Armor deviceInventory)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getDeviceByInventory(deviceInventory)
	else
		return getDeviceScriptByRender(akActor,StorageUtil.GetFormValue(akActor, "UD_RenderDevice" + deviceInventory, none) as Armor)
	endif
EndFunction

;returns first device which have connected corresponding Render Device
UD_CustomDevice_RenderScript Function getDeviceByRender(Actor akActor, Armor deviceRendered)
	if isRegistered(akActor)
		UD_CustomDevice_RenderScript loc_device = getNPCSlot(akActor).getDeviceByRender(deviceRendered)
		if loc_device
			return loc_device
		else
			return getDeviceScriptByRender(akActor,deviceRendered)
		endif
	else
		return getDeviceScriptByRender(akActor,deviceRendered)
	endif
EndFunction

;returns first device which have connected corresponding Inventory Device,uses fetch funtion
UD_CustomDevice_RenderScript Function FetchDeviceByInventory(Actor akActor, Armor deviceInventory)
	return getDeviceScriptByRender(akActor,StorageUtil.GetFormValue(deviceInventory, "UD_RenderDevice", none) as Armor)
EndFunction

;returns heavy bondage (hand restrain) device
UD_CustomDevice_RenderScript Function getHeavyBondageDevice(Actor akActor)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getHeavyBondageDevice()
	else
		return getDeviceScriptByKw(akActor,libs.zad_deviousHeavyBondage)
	endif
EndFunction

;returns current device that have minigame on (return none if no minigame is on)
UD_CustomDevice_RenderScript Function getMinigameDevice(Actor akActor)
	if _oCurrentPlayerMinigameDevice.getWearer() == akActor || _oCurrentPlayerMinigameDevice.getHelper() == akActor
		return _oCurrentPlayerMinigameDevice
	endif
	if isRegistered(akActor)
		return getNPCSlot(akActor).getMinigameDevice()
	else
		return getDeviceScriptByRender(akActor,StorageUtil.GetFormValue(akActor, "UD_currentMinigameDevice", none) as Armor)
	endif
EndFunction

;returs device with main keyword
UD_CustomDevice_RenderScript Function getDeviceByKeyword(Actor akActor,keyword akKeyword)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getDeviceByKeyword(akKeyword)
	else
		return getDeviceScriptByKw(akActor,akKeyword)
	endif
EndFunction

;returs first device by keywords
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
UD_CustomDevice_RenderScript Function getFirstDeviceByKeyword(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getFirstDeviceByKeyword(kw1,kw2,kw3,mod)
	else
		return getDeviceScriptByKw(akActor,kw1)
	endif
EndFunction

;returns last device containing keyword
UD_CustomDevice_RenderScript Function getLastDeviceByKeyword(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getLastDeviceByKeyword(kw1,kw2,kw3,mod)
	else
		return getDeviceScriptByKw(akActor,kw1)
	endif
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
UD_CustomDevice_RenderScript[] Function getAllDevicesByKeyword(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getAllDevicesByKeyword(kw1,kw2,kw3,mod)
	else
		return MakeNewDeviceSlots();getAllDeviceScriptsByKw(akActor,kw1,kw2,kw3,mod)
	endif
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
UD_CustomDevice_RenderScript[] Function getAllActivableDevicesByKeyword(Actor akActor,bool bCheckCondition,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getAllActivableDevicesByKeyword(bCheckCondition,kw1,kw2,kw3,mod)
	else
		return MakeNewDeviceSlots();getAllActivableDevicesByKw(akActor,kw1,kw2,kw3,mod)
	endif
EndFunction

Function ResetFetchFunction()
	_transfereMutex = false
	_transferedDevice = none
EndFunction

Armor Function getStoredInventoryDevice(Armor renDevice)
	return StorageUtil.GetFormValue(renDevice, "UD_InventoryDevice", none) as Armor
EndFunction
Armor Function getStoredRenderDevice(Armor invDevice)
	return libs.GetRenderedDevice(invDevice)
EndFunction

;returs render device with main keyword
Armor Function getEquippedRender(Actor akActor,keyword akKeyword)
	if !akActor.wornhaskeyword(akKeyword)
		return none ;actor have no device equipped
	endif
	if false;isRegistered(akActor)
		UD_CustomDevice_RenderScript loc_device = getNPCSlot(akActor).getDeviceByKeyword(akKeyword)
		if loc_device
			return loc_device.deviceRendered
		else
			Error("getEquippedRender("+getActorName(akActor)+","+akKeyword+") - actor is registered but device was not found")
			return libs.GetWornRenderedDeviceByKeyword(akActor,akKeyword)
		endif
	else
		return libs.GetWornRenderedDeviceByKeyword(akActor,akKeyword)
	endif
EndFunction

UD_CustomDevice_RenderScript Property _transferedDevice = none auto hidden
bool _transfereMutex = false
UD_CustomDevice_RenderScript Function getDeviceScriptByRender(Actor akActor,Armor deviceRendered)
	if !deviceRendered
		Error("getDeviceScriptByRender() - deviceRendered = None!!")
		return none
	endif
	
	if !akActor
		Error("getDeviceScriptByRender() - akActor = None!!")
		return none
	endif
	
	if akActor.getItemCount(deviceRendered) <= 0
		Error("getDeviceScriptByRender("+GetActorName(akActor)+") - Actor doesn't have render device!")
		return none
	endif
	UD_CustomDevice_RenderScript result = none
	while _transfereMutex
		Utility.waitMenuMode(0.05)
	endwhile
	
	_transfereMutex = True
	
	if TraceAllowed()	
		Log("getDeviceScriptByRender called for " + deviceRendered + "("+getActorName(akActor)+")")
	endif
	
	_transferedDevice = none
	
	akActor.removeItem(deviceRendered,1,True,TransfereContainer_ObjRef)
	TransfereContainer_ObjRef.removeItem(deviceRendered,1,True,akActor)
	akActor.equipItem(deviceRendered,True,True)
	float loc_time = 0.0
	bool loc_isplayer = ActorIsPlayer(akActor)

	while !_transferedDevice && loc_time <= 4.0
		Utility.waitMenuMode(0.05)
		loc_time += 0.05
	endwhile
	
	if loc_time >= 4.0 && !_transferedDevice		
		Error("getDeviceScriptByRender timeout for " + deviceRendered + "("+getActorName(akActor)+")")
	endif
	
	result = _transferedDevice
	_transferedDevice = none
	_transfereMutex = False
	if akActor != libs.playerRef
		if deviceRendered.haskeyword(libs.zad_deviousheavybondage)
			akActor.UpdateWeight(0)
		endif
	endif
	return result
EndFunction

UD_CustomDevice_RenderScript Function getDeviceScriptByKw(Actor akActor,Keyword kw)
	if !akActor.wornhaskeyword(kw)
		return none ;actor doesn't have equipped the device with provided keyword
	endif

	UD_CustomDevice_RenderScript result = none
	while _transfereMutex
		Utility.waitMenuMode(0.05)
	endwhile
	_transfereMutex = True
		Armor deviceRendered = libs.GetWornRenderedDeviceByKeyword(akActor,kw)
		if deviceRendered
			akActor.removeItem(deviceRendered,1,True,TransfereContainer_ObjRef)
			TransfereContainer_ObjRef.removeItem(deviceRendered,1,True,akActor)
			akActor.equipItem(deviceRendered,True,True)
			while !_transferedDevice
				Utility.waitMenuMode(0.05)
			endwhile
			result = _transferedDevice
			_transferedDevice = none
		endif
	_transfereMutex = False
	if akActor != libs.playerRef
		akActor.UpdateWeight(0)
	endif
	return result
EndFunction

UD_CustomDevice_RenderScript[] Function getAllDeviceScriptsByKw(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)

	if !kw2
		kw2 = kw1
	endif
	
	if !kw3
		kw3 = kw1
	endif
			
	UD_CustomDevice_RenderScript[] res = MakeNewDeviceSlots()
	int iItem = akActor.GetNumItems()
	Form[] loc_devices
	
	while iItem
		iItem -= 1
		Form loc_item = akActor.GetNthForm(iItem)
		if (loc_item as Armor) && loc_item.haskeyword(UDlibs.UnforgivingDevice)
			Armor deviceRendered = loc_item as Armor
			if mod == 0
				if deviceRendered.hasKeyword(kw1) && deviceRendered.hasKeyword(kw2) && deviceRendered.hasKeyword(kw3)
					loc_devices = PapyrusUtil.PushForm(loc_devices,deviceRendered)
				endif
			elseif mod == 1
				if deviceRendered.hasKeyword(kw1) || deviceRendered.hasKeyword(kw2) || deviceRendered.hasKeyword(kw3)
					loc_devices = PapyrusUtil.PushForm(loc_devices,deviceRendered)
				endif
			endif
		endif
	endwhile
	
	while _transfereMutex
		Utility.waitMenuMode(0.05)
	endwhile
	_transfereMutex = True
	
	int loc_i1 = loc_devices.length
	while loc_i1
		loc_i1 -= 1
		Armor loc_renDevice = loc_devices[loc_i1] as Armor
		if loc_renDevice
			_transferedDevice = none
			akActor.removeItem(loc_renDevice,1,True,TransfereContainer_ObjRef)
			TransfereContainer_ObjRef.removeItem(loc_renDevice,1,True,akActor)
			akActor.equipItem(loc_renDevice,True,True)
			float loc_time = 0.0
			while !_transferedDevice && loc_time < 2.0
				Utility.waitMenuMode(0.05)
				loc_time += 0.05
			endwhile
			
			if loc_time > 1.0 && !_transferedDevice
				if TraceAllowed()				
					Error("getDeviceScriptByRender timeout for " + loc_renDevice + "("+getActorName(akActor)+")")
				endif
			endif
		endif
		if _transferedDevice
			int loc_i2 = 0
			while !res[loc_i2]
				loc_i2 += 1
			endwhile
			res[loc_i2] = _transferedDevice
		endif
		_transferedDevice = none
	endwhile
	_transfereMutex = False
	if akActor != libs.playerRef
		akActor.UpdateWeight(0)
	endif
	return res
EndFunction

Int Function getAllActivableDevicesNumByKw(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	UD_CustomDevice_RenderScript[] loc_devices = getAllDeviceScriptsByKw(akActor,kw1,kw2,kw3, mod)
	int loc_i = 0
	int loc_resNum = 0
	while loc_devices[loc_i]
		if loc_devices[loc_i].canBeActivated()
			loc_resNum += 1
		endif
		
		loc_i += 1
	endwhile
	return loc_resNum
EndFunction

UD_CustomDevice_RenderScript[] Function getAllActivableDevicesByKw(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	UD_CustomDevice_RenderScript[] loc_devices = getAllDeviceScriptsByKw(akActor,kw1,kw2,kw3, mod)
	UD_CustomDevice_RenderScript[] loc_res = MakeNewDeviceSlots()
	int loc_i = 0
	int loc_resNum = 0
	while loc_devices[loc_i]
		if loc_devices[loc_i].canBeActivated()
			loc_res[loc_resNum] = loc_devices[loc_i] 
			loc_resNum += 1
		endif
		
		loc_i += 1
	endwhile
	return loc_res
EndFunction

;returns number of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
int Function getNumberOfDevicesWithKeyword(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getNumberOfDevicesWithKeyword(kw1,kw2,kw3,mod)
	endif
	return 0
EndFunction

;returns number of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
int Function getNumberOfActivableDevicesWithKeyword(Actor akActor,bool bCheckCondition, keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getNumberOfActivableDevicesWithKeyword(bCheckCondition,kw1,kw2,kw3,mod)
	else
		return 0;getAllActivableDevicesNumByKw(akActor,kw1,kw2,kw3,mod)
	endif
EndFunction

;returns all device that can be activated
UD_CustomDevice_RenderScript[] Function getActiveDevices(Actor akActor)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getActiveDevices()
	else
		return MakeNewDeviceSlots();getAllActivableDevicesByKw(akActor,UDLibs.UnforgivingDevice)
	endif
EndFunction

;returns number of devices that can be activated
int Function getActiveDevicesNum(Actor akActor)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getActiveDevicesNum()
	else
		return 0;getAllActivableDevicesNumByKw(akActor,UDLibs.UnforgivingDevice)
	endif
EndFunction

;returns number of vibrators
int Function getVibratorNum(Actor akActor)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getVibratorNum()
	else
		return 0
	endif
EndFunction

;returns number of turned off vibrators
int Function getOffVibratorNum(Actor akActor)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getOffVibratorNum()
	else
		return 0
	endif
EndFunction

;returns all vibrators
UD_CustomDevice_RenderScript[] Function getVibrators(Actor akActor)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getVibrators()
	endif
	return none
EndFunction

;returns all turned off vibrators
UD_CustomDevice_RenderScript[] Function getOffVibrators(Actor akActor)
	if isRegistered(akActor)
		return getNPCSlot(akActor).getOffVibrators()
	endif
	return none
EndFunction

;???
Function deleteLastUsedSlot(Actor akActor)
	if isRegistered(akActor)
		getNPCSlot(akActor).deleteLastUsedSlot()
	endif
EndFunction

;toggle widget
Function toggleWidget(bool val)
	if val
		widget1.show(True)
	else
		widget1.hide(True)
	endif
EndFunction

;toggle widget2
Function toggleWidget2(bool val)
	if val
		widget2.show(True)
	else
		widget2.hide(True)
	endif
EndFunction

bool Function ChangeSoulgemState(Actor akActor,Int iSoulgemType,bool bState = true)
	if !akActor
		return false
	endif
	if iSoulgemType > 2 || iSoulgemType < 0
		return false
	endif
	
	if bState ;discharge
		if iSoulgemType == 0
			akActor.removeItem(UDlibs.FilledSoulgem_Petty,1,true)
			akActor.AddItem(UDlibs.EmptySoulgem_Petty,1,true)
		elseif iSoulgemType == 1
			akActor.removeItem(UDlibs.FilledSoulgem_Lesser,1,true)
			akActor.AddItem(UDlibs.EmptySoulgem_Lesser,1,true)
		elseif iSoulgemType == 2
			akActor.removeItem(UDlibs.FilledSoulgem_Common,1,true)
			akActor.AddItem(UDlibs.EmptySoulgem_Common,1,true)
		endif
	else	;charge
		if iSoulgemType == 0
			akActor.removeItem(UDlibs.EmptySoulgem_Petty,1,true)
			akActor.AddItem(UDlibs.FilledSoulgem_Petty,1,true)
		elseif iSoulgemType == 1
			akActor.removeItem(UDlibs.EmptySoulgem_Lesser,1,true)
			akActor.AddItem(UDlibs.FilledSoulgem_Lesser,1,true)
		elseif iSoulgemType == 2
			akActor.removeItem(UDlibs.EmptySoulgem_Common,1,true)
			akActor.AddItem(UDlibs.FilledSoulgem_Common,1,true)
		endif
	endif
	return true
EndFunction

Message Property UD_SoulgemSelect_MSG auto
Int Function ShowSoulgemMessage(Actor akActor,Bool bEmpty = false)
	;precheck
	resetCondVar()
	if !bEmpty
		if akActor.getItemCount(UDlibs.FilledSoulgem_Petty) > 0
			currentDeviceMenu_switch1 = true
		endif
		if akActor.getItemCount(UDlibs.FilledSoulgem_Lesser) > 0
			currentDeviceMenu_switch2 = true
		endif
		if akActor.getItemCount(UDlibs.FilledSoulgem_Common) > 0
			currentDeviceMenu_switch3 = true
		endif
	else
		if akActor.getItemCount(UDlibs.EmptySoulgem_Petty) > 0
			currentDeviceMenu_switch1 = true
		endif
		if akActor.getItemCount(UDlibs.EmptySoulgem_Lesser) > 0
			currentDeviceMenu_switch2 = true
		endif
		if akActor.getItemCount(UDlibs.EmptySoulgem_Common) > 0
			currentDeviceMenu_switch3 = true
		endif
	endif
	;message
	Int loc_res = UD_SoulgemSelect_MSG.Show()
	if loc_res == 3
		return -1
	endif
	return loc_res
EndFunction

;copied and modified from zadEquipScript
Float Function CalculateKeyModifier()
	Float val = 1.0
	float mcmSize = libs.config.EsccapeDifficultyList.Length
	int median = Math.floor((mcmSize/2)) ; This assumes the array to be uneven, otherwise there is no median value.
	val += (median - libs.config.KeyDifficulty)*(1.0/median)
	return val
EndFunction

UD_CustomDevice_RenderScript _activateDevicePackage = none
bool Function activateDevice(UD_CustomDevice_RenderScript udCustomDevice)
	if !udCustomDevice.canBeActivated() ;can't be activated, return
		if TraceAllowed()		
			Log("activateDevice() - " + udCustomDevice.getDeviceName() + " can't be activated",3)
		endif
		return false
	endif
	
	if !udCustomDevice.isNotShareActive() ;share active
		;activate other device
		int loc_num = getActiveDevicesNum(udCustomDevice.getWearer())
		if loc_num > 0
			UD_CustomDevice_RenderScript[] loc_device_arr = getActiveDevices(udCustomDevice.getWearer())
			UD_CustomDevice_RenderScript loc_device = loc_device_arr[Utility.randomInt(0,loc_num - 1)]
			if udCustomDevice.WearerIsPlayer()
				debug.notification("Your " + udCustomDevice.getDeviceName() + " activates " + loc_device.getDeviceName() + " !!")
			endif
			udCustomDevice = loc_device
		else
			return false
		endif
	endif
	
	while _activateDevicePackage
		Utility.waitMenuMode(0.15)
	endwhile
	_activateDevicePackage = udCustomDevice
	if TraceAllowed()	
		Log("activateDevice() - Sending " + udCustomDevice.getDeviceName(),3)
	endif
	int handle = ModEvent.Create("UD_ActivateDevice")
	if (handle)
        ModEvent.Send(handle)
		return true
    else
		if TraceAllowed()		
			Log("activateDevice() - !!Sending of " + udCustomDevice.getDeviceName() + " failed!!",1)
		endif
		_activateDevicePackage = none
		return false
	endif
EndFunction

Function OnActivateDevice()
	UD_CustomDevice_RenderScript loc_fetchedPackage = _activateDevicePackage
	_activateDevicePackage = none ;free package
	if TraceAllowed()	
		Log("activateDevice() - Received " + loc_fetchedPackage.getDeviceName(),3)
	endif
	loc_fetchedPackage.activateDevice()
EndFunction


UD_CustomDevice_RenderScript _AVCheckLoop_Package = none
Function sendMinigameActorValUpdateLoop(Actor akActor, UD_CustomDevice_RenderScript device, bool bHelper,Float fUpdateTime,Float fUpdateTimeHelper)
	_AVCheckLoop_Package = device
	int handle = ModEvent.Create("UD_AVCheckLoopStart")
	if (handle)
        ModEvent.PushForm(handle,akActor)
		ModEvent.PushFloat(handle,fUpdateTime)
        ModEvent.Send(handle)
    endIf
	
	while _AVCheckLoop_Package
		Utility.waitMenuMode(0.01)
	endwhile
	
	if bHelper
		_AVCheckLoop_Package = device
		handle = ModEvent.Create("UD_AVCheckLoopStartHelper")
		if (handle)
			ModEvent.PushForm(handle,akActor)
			ModEvent.PushFloat(handle,fUpdateTimeHelper)
			ModEvent.Send(handle)
		endIf	
		while _AVCheckLoop_Package
			Utility.waitMenuMode(0.01)
		endwhile
	endif
	
EndFunction

string Function getCurrentZadAnimation(Actor akActor)
	return StorageUtil.getStringValue(akActor,"zad_animation","none")
EndFunction

Function sendSentientDialogueEvent(string type,int force)
	SendModEvent("UD_SentientDialogue", type, force as float)
EndFunction

Function sendHUDUpdateEvent(bool flashCall,bool stamina,bool health,bool magicka)
	int handle = ModEvent.Create("UD_UpdateHud")
	if (handle)
        ModEvent.PushInt(handle,flashCall as Int) ;actor
        ModEvent.PushInt(handle, stamina as Int) ;value
		ModEvent.PushInt(handle, health as Int) ;value
		ModEvent.PushInt(handle, magicka as Int) ;value
        ModEvent.Send(handle)
    endIf	
EndFunction

Function updateHUDBars(int flashCall,int stamina,int health,int magicka)
	if flashCall
		UI.SetBool("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._visible",True)
		UI.SetBool("HUD Menu", "_root.HUDMovieBaseInstance.Health._visible",True)
		UI.SetBool("HUD Menu", "_root.HUDMovieBaseInstance.Magica._visible",True)
	endif
	
	if stamina
	;if (WearerIsPlayer() || HelperIsPlayer()) && (UD_minigame_stamina_drain != 0.0 || UD_minigame_stamina_drain_helper != 0)
		Game.getPlayer().damageAV("Stamina",  0.1)
		Game.getPlayer().restoreAV("Stamina",  0.1)
	endif
	
	if health
	;if (WearerIsPlayer() || HelperIsPlayer()) && (UD_minigame_heal_drain != 0.0 || UD_minigame_heal_drain_helper != 0.0)
		Game.getPlayer().damageAV("Health",  0.1)
		Game.getPlayer().restoreAV("Health",  0.1)
	endif
	
	if magicka
	;if (WearerIsPlayer() || HelperIsPlayer()) &&  (UD_minigame_magicka_drain != 0.0 || UD_minigame_magicka_drain_helper != 0)
		Game.getPlayer().damageAV("Magicka",  0.1)
		Game.getPlayer().restoreAV("Magicka",  0.1)
	endif
EndFunction

UD_CustomVibratorBase_RenderScript _startVibFunctionPackage = none
bool Function startVibFunction(UD_CustomVibratorBase_RenderScript udCustomVibrator,bool bBlocking = false)
	if !udCustomVibrator	
		Error("startVibFunction() - Can't turn none plug!!")
		return false
	endif
	if !udCustomVibrator.canVibrate()		
		Error("startVibFunction() - " + udCustomVibrator.getDeviceHeader() + " can't vibrate!")
		return false
	endif
	
	while _startVibFunctionPackage
		Utility.waitMenuMode(0.1)
	endwhile
	_startVibFunctionPackage = udCustomVibrator
	if TraceAllowed()	
		Log("startVibFunction() - Sending " + udCustomVibrator.getDeviceHeader(),3)
	endif
	int handle = ModEvent.Create("UD_StartVibFunction")
	if (handle)
        ModEvent.Send(handle)
		return true
    else
		if TraceAllowed()		
			Log("startVibFunction() - !!Sending of " + _startVibFunctionPackage.getDeviceHeader() + " failed!!",1)
		endif
		_startVibFunctionPackage = none
		return false
	endif
	float loc_elapsedtime = 0.0
	while _startVibFunctionPackage && bBlocking && loc_elapsedtime <= 2.0
		Utility.waitMenuMode(0.1) ;wait untill vib starts
		loc_elapsedtime += 0.1
	endwhile
	if loc_elapsedtime >= 2.0
		Error("startVibFunction() - "+udCustomVibrator.getDeviceHeader()+"Timeout")
	endif
EndFunction

int Function getGaggedLevel(Actor akActor)
	if !akActor.wornhaskeyword(libs.zad_deviousgag)
		return 0 ;ungagged
	else
		if akActor.wornhaskeyword(libs.zad_GagNoOpenMouth)
			return 3
		elseif akActor.wornhaskeyword(libs.zad_DeviousGagLarge)
			return 2
		else
			return 1
		endif
	endif
EndFunction

;always delete after use!!!
zadequipscript Function GetEquipScript(Armor arg_InventoryDevice)
    zadequipscript loc_res = none
	if arg_InventoryDevice
		if arg_InventoryDevice.haskeyword(libs.zad_inventoryDevice)
			loc_res = TransfereContainer_ObjRef.placeAtMe(arg_InventoryDevice) as zadequipscript
		endif
	endif
    return loc_res
EndFunction

Armor Function GetRenderDevice(Armor arg_InventoryDevice)
    Armor loc_res = none
	if arg_InventoryDevice
		if arg_InventoryDevice.haskeyword(libs.zad_inventoryDevice)
			zadEquipScript temp_objRef = (TransfereContainer_ObjRef.placeAtMe(arg_InventoryDevice) as zadequipscript)
			loc_res = temp_objRef.deviceRendered
			temp_objRef.delete()
		endif
	endif
    return loc_res
EndFunction

Function FetchAndStartVibFunction()
	UD_CustomVibratorBase_RenderScript loc_fetchedPackage = _startVibFunctionPackage
	if TraceAllowed()	
		Log("startVibFunction() - Received " + loc_fetchedPackage.getDeviceName(),3)
	endif
	_startVibFunctionPackage = none ;free package
	loc_fetchedPackage.vibrate() ;vibrate
EndFunction

;wrappers
bool Function ActorIsFollower(Actor akActor)
	return UDmain.ActorIsFollower(akActor)
EndFunction

Function Log(String msg, int level = 1)
	UDmain.Log(msg,level)
EndFunction
Function Error(String msg)
	UDmain.Error(msg)
EndFunction
Function Print(String strMsg, int iLevel = 1,bool bLog = false)
	UDmain.Print(strMsg,iLevel,bLog)
EndFunction
Function CLog(String strMsg)
	UDmain.CLog(strMsg)
EndFunction

Function SetArousalPerks()
	if UDMain.OSLArousedInstalled
		OSLLoadOrderRelative = Game.GetModByName("OSLAroused.esp")
		If (OSLLoadOrderRelative > 255)
        	OSLLoadOrderRelative -= 256
		endif
		log("Assuming OSL load order: "+OSLLoadOrderRelative,3)
	else
		SLALoadOrder = Game.GetModByName("SexLabAroused.esm")
		log("Assuming SLA load order: "+SLALoadOrder,3)
	endif
	if !UDmain.OSLArousedInstalled
		DesirePerks = new perk[6]
		DesirePerks[0] = SLAPerkFastFetch(formNumber=0x0003FC35) as Perk
		DesirePerks[1] = SLAPerkFastFetch(formNumber=0x00038057) as Perk
		DesirePerks[2] = SLAPerkFastFetch(formNumber=0x0007F09C) as Perk
		DesirePerks[3] = SLAPerkFastFetch(formNumber=0x0003FC34) as Perk
		DesirePerks[4] = SLAPerkFastFetch(formNumber=0x0007E072) as Perk
		DesirePerks[5] = SLAPerkFastFetch(formNumber=0x0007E074) as Perk
	else
		DesirePerks = new perk[5]
		DesirePerks[0] = SLAPerkFastFetch(formNumber=0x0000080D, OSL = true) as Perk
		DesirePerks[1] = SLAPerkFastFetch(formNumber=0x00000814, OSL = true) as Perk
		DesirePerks[2] = SLAPerkFastFetch(formNumber=0x00000815, OSL = true) as Perk
		DesirePerks[3] = SLAPerkFastFetch(formNumber=0x00000813, OSL = true) as Perk
		DesirePerks[4] = SLAPerkFastFetch(formNumber=0x00000816, OSL = true) as Perk
	endif
endfunction
bool Function ApplyTearsEffect(Actor akActor)
	if UDmain.ZaZAnimationPackInstalled && UDmain.SlaveTatsInstalled
		if !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZTears_KW)
			UDlibs.ZAZTearsSpell.cast(akActor)
			return true
		endif
	endif
	return false
EndFUnction

bool Function ApplyDroolEffect(Actor akActor) ;works only for player
	if UDmain.ZaZAnimationPackInstalled && UDmain.SlaveTatsInstalled
		if !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZDrool_KW)
			UDlibs.ZAZDroolSpell.cast(akActor)
			return true
		endif
	endif
	return false
EndFUnction

; gets Lover's Desire perks faster than calling GetMeMyForm every time, based on predefined load order ids on game load
form Function SLAPerkFastFetch(int formNumber, bool OSL = false)
	if !OSL
		; log("Fetched perk " + (Game.GetFormEx(Math.LogicalOr(Math.LeftShift(SLALoadOrder, 24), formNumber))).getName(), 3)
		return Game.GetFormEx(Math.LogicalOr(Math.LeftShift(SLALoadOrder, 24), formNumber))
	else
		; log("Fetched perk " + (Game.GetFormEx(Math.LogicalOr(Math.LogicalOr(0xFE000000, Math.LeftShift(OSLLoadOrderRelative, 12)), formNumber))).getName(), 3)
		return Game.GetFormEx(Math.LogicalOr(Math.LogicalOr(0xFE000000, Math.LeftShift(OSLLoadOrderRelative, 12)), formNumber))
	endif
endFunction

; Spell Property slaDesireSpell auto

Float Function getArousalSkillMult(Actor akActor)
	; int i = 0
	; int loc_effects = slaDesireSpell.GetNumEffects()
	
	; while i < loc_effects
	; 	if akActor.HasMagicEffect(slaDesireSpell.GetNthEffectMagicEffect(i))
	; 		if i == 0
	; 			return 0.8
	; 		elseif i == 1
	; 			return 0.9
	; 		elseif i == 2
	; 			return 0.95
	; 		elseif i == 3
	; 			return 1.05
	; 		elseif i == 4
	; 			return 0.6
	; 		elseif i == 5
	; 			return 0.2
	; 		endif
	; 	endif
	; 	i += 1
	; endwhile

	; int OSL = Game.GetModByName("OSLAroused.esp")
	; bool OSLSwitch = false
    ; if ((OSL != 255) && (OSL != 0)) ; 255 = not found, 0 = no skse
	; 	OSLSwitch = true
	; endif

	if !UDmain.OSLArousedInstalled
		if akActor.HasPerk(DesirePerks[0]) 
			return 0.95
		elseif akActor.HasPerk(DesirePerks[1]) 
			return 0.8
		elseif akActor.HasPerk(DesirePerks[2]) 
			return 0.6
		elseif akActor.HasPerk(DesirePerks[3]) 
			return 0.9
		elseif akActor.HasPerk(DesirePerks[4]) 
			return 0.2
		elseif akActor.HasPerk(DesirePerks[5]) 
			return 1.05
		endif
	else
		if akActor.HasPerk(DesirePerks[0])
			return 0.95
		elseif akActor.HasPerk(DesirePerks[1]) 
			return 0.8
		elseif akActor.HasPerk(DesirePerks[2]) 
			return 0.6
		elseif akActor.HasPerk(DesirePerks[3]) 
			return 0.9
		elseif akActor.HasPerk(DesirePerks[4]) 
			return 0.2
		endif
	endif
	return 1.0
EndFunction

Function TestExpression(Actor akActor,sslBaseExpression sslExpression,bool bMouth = false,int iTime = 5)
	libs.resetExpression(akActor,none)
	
	if sslExpression
		UDEM.ApplyExpression(akActor,sslExpression,50,bMouth,100)
		Print(sslExpression.Name + " applied!")
		Utility.wait(iTime)
		UDEM.ResetExpression(akActor, none,100)
		Print(sslExpression.Name + " removed!")
	endif
EndFunction

Bool Function TraceAllowed()
	return UDmain.TraceAllowed()
EndFunction

bool _debugSwitch = false

;function used for mod development
Function DebugFunction(Actor akActor)
	int loc_map = 0x00000000
	int loc_value = 65535
	int loc_iter = 1000
	int loc_number = loc_iter
	startRecordTime()
	while loc_number
		loc_map = codeBit_old(loc_map,loc_value, 16, 15)
		loc_number -= 1
	endwhile
	float loc_time_codeBit_old = FinishRecordTime("codeBit_old (iter = "+loc_iter+" )")
	
	loc_number = loc_iter
	int loc_res = 0
	startRecordTime()
	while loc_number
		loc_res = decodeBit_old(loc_map, 16, 15)
		loc_number -= 1
	endwhile
	float loc_time_decodeBit_old = FinishRecordTime("decodeBit_old res = "+loc_res+" (iter = "+loc_iter+" )")
	
	loc_number = loc_iter
	startRecordTime()
	while loc_number
		loc_map = codeBit(loc_map,loc_value, 16, 15)
		loc_number -= 1
	endwhile
	float loc_time_codeBit = FinishRecordTime("codeBit (iter = "+loc_iter+" )")
	
	loc_number = loc_iter
	startRecordTime()
	while loc_number
		loc_res = decodeBit(loc_map, 16, 15)
		loc_number -= 1
	endwhile
	float loc_time_decodeBit = FinishRecordTime("decodeBit res = "+loc_res+" (iter = "+loc_iter+" )")
	
	GInfo("Speed increase - codeBit   - " + Round((loc_time_codeBit_old/loc_time_codeBit)*100) + " %")
	GInfo("Speed increase - decodeBit - " + Round((loc_time_decodeBit_old/loc_time_decodeBit)*100) + " %")
	
	
	;UDmain.UDRRM.LockAllSuitableRestrains(akActor,false,0xffff)
	
	;libs.LockDevice(akActor,libsx.zadx_gag_facemask_biz_transparent_Inventory)
	;libs.LockDevice(akActor,libsx.zadx_catsuit_gasmask_tube_black_Inventory)
		
	;libs.LockDevice(akActor,libsx.zadx_StraitJacketLatexBlackInventory)
	;libs.LockDevice(akActor,libsx.zadx_HR_IronCuffsFrontInventory)		
		
	;UDEM.ApplyExpressionRaw(akActor,UDEM.CreateRandomExpression(true), strength = 100, openMouth=false, iPriority = 0)
EndFunction

string Function GetUserTextInput()
	TextMenu.ResetMenu()
	TextMenu.OpenMenu()
	TextMenu.BlockUntilClosed()
	return TextMenu.GetResultString()
EndFunction

Int Function GetUserListInput(string[] arrList)
	ListMenu.ResetMenu()
	;ListMenu.SetPropertyStringA("appendEntries", arrList)
	int loc_i = 0
	while loc_i < arrList.length
		ListMenu.AddEntryItem(arrList[loc_i])
		loc_i+=1
	endwhile
	ListMenu.OpenMenu()
	ListMenu.BlockUntilClosed()
	return ListMenu.GetResultInt()
EndFunction

float _startTime = 0.0
Function StartRecordTime()
	_startTime = Utility.GetCurrentRealTime()
EndFunction

float Function FinishRecordTime(string strObject = "",bool bReset = false,bool bLog = true,bool bPrint = true)
	float loc_res = Utility.GetCurrentRealTime() - _startTime
	
	CLog("ElapsedTime for "+ strObject + " = " + loc_res)
	
	if bLog
		debug.trace("[UD]: ElapsedTime for "+ strObject + " = " + loc_res)
		;Log("Elapsed time for " + strObject + " = " + loc_res + " s",1)
	endif
	if bPrint
		debug.notification("ElapsedTime for "+ strObject + " = " + loc_res)
	endif
	
	if bReset
		StartRecordTime()
	endif
	return loc_res
EndFunction
