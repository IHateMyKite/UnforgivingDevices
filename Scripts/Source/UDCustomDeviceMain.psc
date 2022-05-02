Scriptname UDCustomDeviceMain extends Quest  conditional

Spell Property SwimPenaltySpell auto
UnforgivingDevicesMain Property UDmain auto
UD_ParalelProcess Property UDPP auto
UD_libs Property UDlibs auto
zadlibs Property libs auto

;UI menus
UITextEntryMenu Property TextMenu auto
UIListMenu Property ListMenu auto

bool Property UD_HardcoreMode = true auto

;keys
Int Property Stamina_meter_Keycode 	= 32 	auto
int property StruggleKey_Keycode 	= 52 	auto
Int Property Magicka_meter_Keycode 	= 30 	auto
Int Property SpecialKey_Keycode 	= 31 	auto
Int Property PlayerMenu_KeyCode 	= 40 	auto
int property ActionKey_Keycode 		= 18 	auto

int Property NPCMenu_Keycode	= 39	auto

bool Property UD_UseDDdifficulty 	= True auto
bool Property UD_UseWidget 			= True auto

int Property UD_GagPhonemModifier = 50 auto

UD_Patcher Property UDPatcher auto
;UD_BreathplayScript Property BreathplayScript auto
UD_DialogueMain Property UDDmain auto
UD_CustomDevices_NPCSlotsManager Property UDCD_NPCM auto
UD_ExpressionManager Property UDEM auto
Int Property UD_StruggleDifficulty = 1 auto
float Property UD_BaseDeviceSkillIncrease = 35.0 auto
float Property UD_CooldownMultiplier = 1.0 auto
Bool Property UD_AutoCrit = False auto
Int Property UD_AutoCritChance = 80 auto

;changes how much is strength converted to orgasm rate, 
;example: if UD_VibrationMultiplier = 0.1 and vibration strength will be 100, orgasm rate will be 100*0.1 = 10 O/s 
float 	Property UD_VibrationMultiplier 	= 0.10	auto 
float 	Property UD_ArousalMultiplier 	    = 0.05	auto 
float 	Property UD_OrgasmResistence 		= 3.5 	auto ;orgasm rate required for actor to be able to orgasm, lower the value, the faster will orgasm rate increase stop
int 	Property UD_OrgasmArousalThreshold 	= 95 	auto ;arousal required for actor to be able to orgasm

;factions
Faction Property zadGagPanelFaction Auto
Faction Property FollowerFaction auto
Faction Property RegisteredNPCFaction auto
Faction Property MinigameFaction auto
Faction Property PlayerFaction auto

Faction Property BlockExpressionFaction auto
Faction Property BlockAnimationFaction auto
Faction Property BussyFaction auto
Faction Property OrgasmFaction auto
Faction Property OrgasmCheckLoopFaction auto
Faction Property ArousalCheckLoopFaction auto
Faction Property OrgasmResistFaction auto


MiscObject Property zad_GagPanelPlug Auto

float Property UD_StruggleExhaustionMagnitude = 60.0 auto ;magnitude of exhaustion, 50.0 will reduce player stats regen modifier by 50%. This cant make regen negative
int Property UD_StruggleExhaustionDuration = 10 auto ;How long will debuff last

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

int Property UD_SlotsNum = 20 AutoReadOnly
;UD_CustomDevice_RenderScript[] Property UD_equipedCustomDevices auto
MiscObject Property Lockpick auto
Int Property UD_LockpicksPerMinigame = 2 auto

Formlist Property UD_QuestKeywords auto

;Spell Property TelekinesisSpell auto

UDCustomHeavyBondageWidget1 Property widget1 auto
UD_WidgetBase Property widget2 auto

Bool Property UD_EquipMutex = False auto

Bool Property Ready = False auto

Bool Property EventsReady = false auto

Event OnInit()
	Utility.waitMenuMode(6.0)
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
	
	InitMenuArr()
	
	registerEvents()
	
	registerForSingleUpdate(1.0)
	RegisterForSingleUpdateGameTime(1.0)
	if TraceAllowed()	
		Log("UDCustomDeviceMain ready!",0)
	endif
	ready = True
EndEvent

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


String[] _Menus
Function InitMenuArr()
	if !_Menus
		_Menus = new String[21]
		_Menus[0] = "Journal Menu"
		_Menus[1] = "Book Menu"
		_Menus[2] = "Console"
		_Menus[3] = "ContainerMenu"
		_Menus[4] = "Crafting Menu"
		_Menus[5] = "Dialogue Menu"
		
		_Menus[6] = "FavoritesMenu"
		_Menus[7] = "GiftMenu"
		_Menus[8] = "Main Menu"
		_Menus[9] = "Loading Menu"
		_Menus[10] = "Lockpicking Menu"
		_Menus[11] = "MagicMenu"
		_Menus[12] = "MapMenu"
		_Menus[13] = "MessageBoxMenu"
	
		_Menus[14] = "RaceSex Menu"
		_Menus[15] = "Sleep/Wait Menu"
		_Menus[16] = "StatsMenu"
		_Menus[17] = "Tutorial Menu"
		_Menus[18] = "TweenMenu"
		
		_Menus[19] = "InventoryMenu"
		_Menus[20] = "BarterMenu"
	endif
EndFunction

Bool Function isMenuOpen()
	int i = _Menus.length
	while i
		i -= 1
		if UI.IsMenuOpen(_Menus[i])
			return true
		endif
		
	endwhile
	return false
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

;dedicated switches to hide options from menu
bool Property currentDeviceMenu_allowStruggling = false auto conditional
bool Property currentDeviceMenu_allowUselessStruggling = false auto conditional
bool Property currentDeviceMenu_allowLockpick = false auto conditional
bool Property currentDeviceMenu_allowKey = false auto conditional
bool Property currentDeviceMenu_allowCutting = false auto conditional
bool Property currentDeviceMenu_allowLockRepair = false auto conditional
bool Property currentDeviceMenu_allowTighten = false auto conditional
bool Property currentDeviceMenu_allowRepair = false auto conditional

;switches for special menu, allows only six buttons
bool Property currentDeviceMenu_switch1 = false auto conditional
bool Property currentDeviceMenu_switch2 = false auto conditional
bool Property currentDeviceMenu_switch3 = false auto conditional
bool Property currentDeviceMenu_switch4 = false auto conditional
bool Property currentDeviceMenu_switch5 = false auto conditional
bool Property currentDeviceMenu_switch6 = false auto conditional

bool Property currentDeviceMenu_allowCommand = false auto conditional
bool Property currentDeviceMenu_allowDetails = false auto conditional
bool Property currentDeviceMenu_allowLockMenu = false auto conditional
bool Property currentDeviceMenu_allowSpecialMenu = false auto conditional
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
		Log("DisableActor("+getActorName(akActor) + ")",1)
	endif
	if bBussy
		akActor.addToFaction(BussyFaction)
	endif
	if !akActor.HasMagicEffectWithKeyword(UDlibs.MinigameDisableEffect_KW)
		UDlibs.MinigameDisableSpell.cast(akActor)
	endif
EndFunction

Function EnableActor(Actor akActor,bool bBussy = false)
	if TraceAllowed()	
		Log("EnableActor("+getActorName(akActor)+")",1)
	endif
	akActor.DispelSpell(UDlibs.MinigameDisableSpell)
	
	
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
	
	if bBussy
		;StorageUtil.UnSetIntValue(akActor,"UD_Bussy")
		akActor.RemoveFromFaction(BussyFaction)
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
	return akActor.isEquipped(UDlibs.InvisibleArmbinder)
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
	return akActor.isEquipped(UDlibs.InvisibleHobble)
EndFunction

bool Function HaveInvisibleHobble(Actor akActor)
	return akActor.getItemCount(UDlibs.InvisibleHobble)
EndFunction

Function UpdateInvisibleHobble(Actor akActor)
	if !HaveInvisibleHobbleEquiped(akActor) && HaveInvisibleHobble(akActor) && !akActor.wornhaskeyword(libs.zad_deviousHobbleSkirt)
		EquipInvisibleHobble(akActor)
	endif
EndFunction

bool Property WHMenuOpened = false auto
int Property GiftMenuMode = 0 auto
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


UD_CustomDevice_RenderScript Property lastOpenedDevice = none auto
UD_CustomDevice_RenderScript _oCurrentPlayerMinigameDevice = none
;UD_CustomDevice_RenderScript _oCurrentPlayerHelpedDevice = none

Function setCurrentMinigameDevice(UD_CustomDevice_RenderScript oref)
	_oCurrentPlayerMinigameDevice = oref
EndFunction

Function resetCurrentMinigameDevice()
	_oCurrentPlayerMinigameDevice = none
EndFunction

int Function getNumberOfRegisteredDevices(Actor akActor)
	return UDCD_NPCM.getNPCSlotByActor(akActor).getNumberOfRegisteredDevices()
EndFunction

;returns number of devices that can be activated
bool Function isRegistered(Actor akActor)
	return akActor.isInFaction(RegisteredNPCFaction);UDCD_NPCM.isRegistered(akActor)
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlot(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor)
	else
		return none
	endif
EndFunction

UD_CustomDevice_RenderScript[] Function getNPCDevices(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).UD_equipedCustomDevices
	else
		return none
	endif
EndFunction

bool Function isScriptRunning(Actor akActor)
	return akActor.isInFaction(RegisteredNPCFaction)
EndFunction

Function sortSlots(Actor akActor)
	if isRegistered(akActor)
		UDCD_NPCM.getNPCSlotByActor(akActor).sortSlots()
	endif
EndFunction

bool Function registerDevice(UD_CustomDevice_RenderScript oref)
	return UDCD_NPCM.getNPCSlotByActor(oref.getWearer()).registerDevice(oref)
EndFunction

bool Function deviceAlreadyRegistered(Actor akActor, Armor deviceInventory)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).deviceAlreadyRegistered(deviceInventory)
	else
		return false
	endif
EndFunction

Function removeAllDevices(Actor akActor)
	if isRegistered(akActor)
		UDCD_NPCM.getNPCSlotByActor(akActor).removeAllDevices()
	endif
EndFunction

Function removeUnusedDevices(Actor akActor)
	UDCD_NPCM.getNPCSlotByActor(akActor).removeUnusedDevices()
EndFunction

int Function numberOfUnusedDevices(Actor akActor)
	return UDCD_NPCM.getNPCSlotByActor(akActor).numberOfUnusedDevices()
EndFunction

int Function unregisterDevice(UD_CustomDevice_RenderScript oref,int i = 0,bool sort = True)
	return UDCD_NPCM.getNPCSlotByActor(oref.getWearer()).unregisterDevice(oref,i,sort)
EndFunction

int Function getCopiesOfDevice(UD_CustomDevice_RenderScript oref)
	return UDCD_NPCM.getNPCSlotByActor(oref.getWearer()).getCopiesOfDevice(oref)
EndFunction

Function removeCopies(Actor akActor)
	UDCD_NPCM.getNPCSlotByActor(akActor).removeCopies()
EndFunction

int Function numberOfCopies(Actor akActor)
	return UDCD_NPCM.getNPCSlotByActor(akActor).numberOfCopies()
EndFunction

int Function debugSize(Actor akActor)
	return UDCD_NPCM.getNPCSlotByActor(akActor).debugSize()
EndFunction

string[] Function GetHeavyBondageAnimation_Armbinder(bool hobble = false)
	string[] temp
	int loc_animNum = 0
	if !hobble
		loc_animNum = 5
		if UDmain.ZaZAnimationPackInstalled
			loc_animNum += 6
		endif
		temp = Utility.CreateStringArray(loc_animNum)
		temp[0] = "DDRegArmbStruggle01"
		temp[1] = "DDRegArmbStruggle02"
		temp[2] = "DDRegArmbStruggle03"
		temp[3] = "DDRegArmbStruggle04"
		temp[4] = "DDRegArmbStruggle05"
		if UDmain.ZaZAnimationPackInstalled
			temp[5] = "ZapArmbStruggle01"
			temp[6] = "ZapArmbStruggle03"
			temp[7] = "ZapArmbStruggle05"
			temp[8] = "ZapArmbStruggle07"
			temp[9] = "ZapArmbStruggle08"
			temp[10] = "ZapArmbStruggle10"
		endif
	else
		loc_animNum = 2
		if UDmain.ZaZAnimationPackInstalled
			loc_animNum += 3
		endif
		temp = Utility.CreateStringArray(loc_animNum)
		temp[0] = "DDHobArmbStruggle01"
		temp[1] = "DDHobArmbStruggle02"
		if UDmain.ZaZAnimationPackInstalled
			temp[2] = "ZapArmbStruggle02"
			temp[3] = "ZapArmbStruggle06"
			temp[4] = "ZapArmbStruggle09"
		endif
	endif
	return temp
EndFunction

string[] Function GetStruggleAnimationsByKW(Keyword kwKeyword,bool bHobble = false)
	if !bHobble
		string[] temp 
		int loc_animNum = 0
		if kwKeyword == libs.zad_DeviousArmbinder
			temp = GetHeavyBondageAnimation_Armbinder(false)
		elseif kwKeyword==libs.zad_DeviousArmbinderElbow
			temp = new string[5]
			temp[0] = "DDRegElbStruggle01"
			temp[1] = "DDRegElbStruggle02"
			temp[2] = "DDRegElbStruggle03"
			temp[3] = "DDRegElbStruggle04"
			temp[4] = "DDRegElbStruggle05"
		elseif kwKeyword==libs.zad_DeviousStraitJacket
			loc_animNum = 6
			if UDmain.ZaZAnimationPackInstalled
				loc_animNum += 6
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDRegElbStruggle01"
			temp[1] = "DDRegElbStruggle02"
			temp[2] = "DDRegElbStruggle03"
			temp[3] = "DDRegElbStruggle04"
			temp[4] = "DDRegElbStruggle05"
			temp[5] = "DDRegbbyokeStruggle01"
			if UDmain.ZaZAnimationPackInstalled
				temp[6] = "ZapArmbStruggle01"
				temp[7] = "ZapArmbStruggle03"
				temp[8] = "ZapArmbStruggle05"
				temp[9] = "ZapArmbStruggle07"
				temp[10] = "ZapArmbStruggle08"
				temp[11] = "ZapArmbStruggle10"
			endif
		elseif kwKeyword==libs.zad_DeviousCuffsFront
			temp = new string[2]
			temp[0] = "DDRegcuffsfrontStruggle02"
			temp[1] = "DDRegcuffsfrontStruggle03"
		elseif kwKeyword==libs.zad_DeviousYoke
			loc_animNum = 5
			if UDmain.ZaZAnimationPackInstalled
				loc_animNum += 6
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDRegYokeStruggle01"
			temp[1] = "DDRegYokeStruggle02"
			temp[2] = "DDRegYokeStruggle03"
			temp[3] = "DDRegYokeStruggle04"
			temp[4] = "DDRegYokeStruggle05"
			if UDmain.ZaZAnimationPackInstalled
				temp[5] = "ZapYokeStruggle01"
				temp[6] = "ZapYokeStruggle03"
				temp[7] = "ZapYokeStruggle05"
				temp[8] = "ZapYokeStruggle07"
				temp[9] = "ZapYokeStruggle08"
				temp[10] = "ZapYokeStruggle10"
			endif
		elseif kwKeyword==libs.zad_DeviousYokeBB
			temp = new string[5]
			temp[0] = "DDRegbbyokeStruggle01"
			temp[1] = "DDRegbbyokeStruggle02"
			temp[2] = "DDRegbbyokeStruggle03"
			temp[3] = "DDRegbbyokeStruggle04"
			temp[4] = "DDRegbbyokeStruggle05"
		elseif kwKeyword==libs.zad_DeviousElbowTie
			temp = new string[3]
			temp[0] = "DDElbowTie_struggleone"
			temp[1] = "DDElbowTie_struggletwo"
			temp[2] = "DDElbowTie_strugglethree"
		elseif kwKeyword==libs.zad_deviousGag
			temp = new string[1]
			temp[0] = "ft_struggle_gag_1"
		elseif kwKeyword==libs.zad_DeviousLegCuffs || kwKeyword==libs.zad_DeviousBoots
			temp = new string[1]
			temp[0] = "ft_struggle_boots_1"
		elseif kwKeyword==libs.zad_DeviousArmCuffs || kwKeyword==libs.zad_DeviousGloves || kwKeyword==libs.zad_DeviousBondageMittens
			temp = new string[1]
			temp[0] = "ft_struggle_gloves_1"
		elseif kwKeyword==libs.zad_DeviousCollar
			temp = new string[1]
			temp[0] = "ft_struggle_head_1"
		elseif kwKeyword==libs.zad_DeviousBlindfold || kwKeyword==libs.zad_DeviousHood
			temp = new string[1]
			temp[0] = "ft_struggle_blindfold_1"
		elseif kwKeyword==libs.zad_DeviousSuit
			temp = new string[2]
			temp[0] = "ft_struggle_boots_1"
			temp[1] = "ft_struggle_gloves_1"
			;temp[2] = "ft_struggle_gag_1"
		elseif kwKeyword==libs.zad_DeviousBelt
			temp = new string[2]
			temp[0] = "DDChastityBeltStruggle01"
			temp[1] = "DDChastityBeltStruggle02"
		elseif kwKeyword==libs.zad_DeviousPlug
			temp = new string[2]
			temp[0] = "DDZazHornyA"
			temp[1] = "DDZazHornyD"
		else	
			temp = new string[1] ;default for other devices
			temp[0] = "ft_struggle_gag_1"
		endif
		return temp
	else
		string[] temp
		int loc_animNum = 0
		if kwKeyword==libs.zad_DeviousArmbinder
			temp = GetHeavyBondageAnimation_Armbinder(true)
		elseif kwKeyword==libs.zad_DeviousArmbinderElbow
			temp = new string[2]
			temp[0] = "DDHobElbStruggle01"
			temp[1] = "DDHobElbStruggle02"
		elseif kwKeyword==libs.zad_DeviousStraitJacket
			loc_animNum = 2
			if UDmain.ZaZAnimationPackInstalled
				loc_animNum += 3
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDHobArmbStruggle01"
			temp[1] = "DDHobArmbStruggle02"
			if UDmain.ZaZAnimationPackInstalled
				temp[2] = "ZapArmbStruggle02"
				temp[3] = "ZapArmbStruggle06"
				temp[4] = "ZapArmbStruggle09"
			endif
		elseif kwKeyword==libs.zad_DeviousCuffsFront
			temp = new string[2]
			temp[0] = "DDHobCuffsFrontStruggle01"
			temp[1] = "DDHobCuffsFrontStruggle02"
		elseif kwKeyword==libs.zad_DeviousYoke
			loc_animNum = 2
			if UDmain.ZaZAnimationPackInstalled
				loc_animNum += 3
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDHobYokeStruggle01"
			temp[1] = "DDHobYokeStruggle02"
			if UDmain.ZaZAnimationPackInstalled
				temp[2] = "ZapYokeStruggle02"
				temp[3] = "ZapYokeStruggle06"
				temp[4] = "ZapYokeStruggle09"
			endif
		elseif kwKeyword==libs.zad_DeviousYokeBB
			temp = new string[2]
			temp[0] = "DDHobBBYokeStruggle01"
			temp[1] = "DDHobBBYokeStruggle02"
		elseif kwKeyword==libs.zad_DeviousElbowTie
			temp = new string[3]
			temp[0] = "DDElbowTie_struggleone"
			temp[1] = "DDElbowTie_struggletwo"
			temp[2] = "DDElbowTie_strugglethree"
		elseif kwKeyword==libs.zad_deviousGag
			temp = new string[1]
			temp[0] = "ft_struggle_gag_1"
		elseif kwKeyword==libs.zad_DeviousLegCuffs || kwKeyword==libs.zad_DeviousBoots
			temp = new string[1]
			temp[0] = "ft_struggle_boots_1"
		elseif kwKeyword==libs.zad_DeviousArmCuffs || kwKeyword==libs.zad_DeviousGloves || kwKeyword==libs.zad_DeviousBondageMittens
			temp = new string[1]
			temp[0] = "ft_struggle_gloves_1"
		elseif kwKeyword==libs.zad_DeviousCollar
			temp = new string[1]
			temp[0] = "ft_struggle_head_1"
		elseif kwKeyword==libs.zad_DeviousBlindfold || kwKeyword==libs.zad_DeviousHood
			temp = new string[1]
			temp[0] = "ft_struggle_blindfold_1"
		elseif kwKeyword==libs.zad_DeviousSuit
			temp = new string[2]
			temp[0] = "ft_struggle_boots_1"
			temp[1] = "ft_struggle_gloves_1"
		elseif kwKeyword==libs.zad_DeviousBelt
			temp = new string[2]
			temp[0] = "DDChastityBeltStruggle01"
			temp[1] = "DDChastityBeltStruggle02"
		elseif kwKeyword==libs.zad_DeviousPlug
			temp = new string[2]
			temp[0] = "DDZazHornyA"
			temp[1] = "DDZazHornyD"
		else	
			temp = new string[1] ;default for other devices
			temp[0] = "ft_struggle_gag_1"
		endif
		return temp
	endif
EndFunction

string[] Function GetStruggleAnimations(Actor akActor,Armor renDevice)
	if !akActor.wornHasKeyword(libs.zad_DeviousHobbleSkirt)
		string[] temp 
		int loc_animNum = 0
		if renDevice.hasKeyword(libs.zad_DeviousArmbinder)
			temp = GetHeavyBondageAnimation_Armbinder(false)
		elseif renDevice.hasKeyword(libs.zad_DeviousArmbinderElbow)
			temp = new string[5]
			temp[0] = "DDRegElbStruggle01"
			temp[1] = "DDRegElbStruggle02"
			temp[2] = "DDRegElbStruggle03"
			temp[3] = "DDRegElbStruggle04"
			temp[4] = "DDRegElbStruggle05"
		elseif renDevice.hasKeyword(libs.zad_DeviousStraitJacket)
			loc_animNum = 6
			if UDmain.ZaZAnimationPackInstalled
				loc_animNum += 6
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDRegElbStruggle01"
			temp[1] = "DDRegElbStruggle02"
			temp[2] = "DDRegElbStruggle03"
			temp[3] = "DDRegElbStruggle04"
			temp[4] = "DDRegElbStruggle05"
			temp[5] = "DDRegbbyokeStruggle01"
			if UDmain.ZaZAnimationPackInstalled
				temp[6] = "ZapArmbStruggle01"
				temp[7] = "ZapArmbStruggle03"
				temp[8] = "ZapArmbStruggle05"
				temp[9] = "ZapArmbStruggle07"
				temp[10] = "ZapArmbStruggle08"
				temp[11] = "ZapArmbStruggle10"
			endif
		elseif renDevice.hasKeyword(libs.zad_DeviousCuffsFront)
			temp = new string[2]
			temp[0] = "DDRegcuffsfrontStruggle02"
			temp[1] = "DDRegcuffsfrontStruggle03"
		elseif renDevice.hasKeyword(libs.zad_DeviousYoke)
			loc_animNum = 5
			if UDmain.ZaZAnimationPackInstalled
				loc_animNum += 6
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDRegYokeStruggle01"
			temp[1] = "DDRegYokeStruggle02"
			temp[2] = "DDRegYokeStruggle03"
			temp[3] = "DDRegYokeStruggle04"
			temp[4] = "DDRegYokeStruggle05"
			if UDmain.ZaZAnimationPackInstalled
				temp[5] = "ZapYokeStruggle01"
				temp[6] = "ZapYokeStruggle03"
				temp[7] = "ZapYokeStruggle05"
				temp[8] = "ZapYokeStruggle07"
				temp[9] = "ZapYokeStruggle08"
				temp[10] = "ZapYokeStruggle10"
			endif
		elseif renDevice.hasKeyword(libs.zad_DeviousYokeBB)
			temp = new string[5]
			temp[0] = "DDRegbbyokeStruggle01"
			temp[1] = "DDRegbbyokeStruggle02"
			temp[2] = "DDRegbbyokeStruggle03"
			temp[3] = "DDRegbbyokeStruggle04"
			temp[4] = "DDRegbbyokeStruggle05"
		elseif renDevice.hasKeyword(libs.zad_DeviousElbowTie)
			temp = new string[3]
			temp[0] = "DDElbowTie_struggleone"
			temp[1] = "DDElbowTie_struggletwo"
			temp[2] = "DDElbowTie_strugglethree"
		elseif renDevice.hasKeyword(libs.zad_DeviousPetSuit)
			temp = new string[1]
			temp[0] = "none"
			return temp
		elseif renDevice.hasKeyword(libs.zad_deviousGag)
			temp = new string[1]
			temp[0] = "ft_struggle_gag_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousLegCuffs) || renDevice.hasKeyword(libs.zad_DeviousBoots)
			temp = new string[1]
			temp[0] = "ft_struggle_boots_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousArmCuffs) || renDevice.hasKeyword(libs.zad_DeviousGloves) || renDevice.hasKeyword(libs.zad_DeviousBondageMittens)
			temp = new string[1]
			temp[0] = "ft_struggle_gloves_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousCollar)
			temp = new string[1]
			temp[0] = "ft_struggle_head_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousBlindfold) || renDevice.hasKeyword(libs.zad_DeviousHood)
			temp = new string[1]
			temp[0] = "ft_struggle_blindfold_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousSuit)
			temp = new string[2]
			temp[0] = "ft_struggle_boots_1"
			temp[1] = "ft_struggle_gloves_1"
			;temp[2] = "ft_struggle_gag_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousBelt)
			temp = new string[2]
			temp[0] = "DDChastityBeltStruggle01"
			temp[1] = "DDChastityBeltStruggle02"
		elseif renDevice.hasKeyword(libs.zad_DeviousPlug)
			temp = new string[2]
			temp[0] = "DDZazHornyA"
			temp[1] = "DDZazHornyD"
		else	
			temp = new string[1] ;default for other devices
			temp[0] = "ft_struggle_gag_1"
		endif
		return temp
	else
		string[] temp
		int loc_animNum = 0
		if renDevice.hasKeyword(libs.zad_DeviousArmbinder)
			temp = GetHeavyBondageAnimation_Armbinder(true)
		elseif renDevice.hasKeyword(libs.zad_DeviousArmbinderElbow)
			temp = new string[2]
			temp[0] = "DDHobElbStruggle01"
			temp[1] = "DDHobElbStruggle02"
		elseif renDevice.hasKeyword(libs.zad_DeviousStraitJacket)
			loc_animNum = 2
			if UDmain.ZaZAnimationPackInstalled
				loc_animNum += 3
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDHobArmbStruggle01"
			temp[1] = "DDHobArmbStruggle02"
			if UDmain.ZaZAnimationPackInstalled
				temp[2] = "ZapArmbStruggle02"
				temp[3] = "ZapArmbStruggle06"
				temp[4] = "ZapArmbStruggle09"
			endif
		elseif renDevice.hasKeyword(libs.zad_DeviousCuffsFront)
			temp = new string[2]
			temp[0] = "DDHobCuffsFrontStruggle01"
			temp[1] = "DDHobCuffsFrontStruggle02"
		elseif renDevice.hasKeyword(libs.zad_DeviousYoke)
			loc_animNum = 2
			if UDmain.ZaZAnimationPackInstalled
				loc_animNum += 3
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDHobYokeStruggle01"
			temp[1] = "DDHobYokeStruggle02"
			if UDmain.ZaZAnimationPackInstalled
				temp[2] = "ZapYokeStruggle02"
				temp[3] = "ZapYokeStruggle06"
				temp[4] = "ZapYokeStruggle09"
			endif
		elseif renDevice.hasKeyword(libs.zad_DeviousYokeBB)
			temp = new string[2]
			temp[0] = "DDHobBBYokeStruggle01"
			temp[1] = "DDHobBBYokeStruggle02"
		elseif renDevice.hasKeyword(libs.zad_DeviousElbowTie)
			temp = new string[3]
			temp[0] = "DDElbowTie_struggleone"
			temp[1] = "DDElbowTie_struggletwo"
			temp[2] = "DDElbowTie_strugglethree"
		elseif renDevice.hasKeyword(libs.zad_DeviousPetSuit)
			temp = new string[1]
			temp[0] = "none"
			return temp
		elseif renDevice.hasKeyword(libs.zad_deviousGag)
			temp = new string[1]
			temp[0] = "ft_struggle_gag_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousLegCuffs) || renDevice.hasKeyword(libs.zad_DeviousBoots)
			temp = new string[1]
			temp[0] = "ft_struggle_boots_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousArmCuffs) || renDevice.hasKeyword(libs.zad_DeviousGloves) || renDevice.hasKeyword(libs.zad_DeviousBondageMittens)
			temp = new string[1]
			temp[0] = "ft_struggle_gloves_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousCollar)
			temp = new string[1]
			temp[0] = "ft_struggle_head_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousBlindfold) || renDevice.hasKeyword(libs.zad_DeviousHood)
			temp = new string[1]
			temp[0] = "ft_struggle_blindfold_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousSuit)
			temp = new string[2]
			temp[0] = "ft_struggle_boots_1"
			temp[1] = "ft_struggle_gloves_1"
		elseif renDevice.hasKeyword(libs.zad_DeviousBelt)
			temp = new string[2]
			temp[0] = "DDChastityBeltStruggle01"
			temp[1] = "DDChastityBeltStruggle02"
		elseif renDevice.hasKeyword(libs.zad_DeviousPlug)
			temp = new string[2]
			temp[0] = "DDZazHornyA"
			temp[1] = "DDZazHornyD"
		else	
			temp = new string[1] ;default for other devices
			temp[0] = "ft_struggle_gag_1"
		endif
		return temp
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
		UDCD_NPCM.getNPCSlotByActor(akActor).TurnOffAllVibrators()
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
	(libs as zadlibs_UDPatch).StartBoundEffectsPatched(akActor)
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
	if oref.getWearer() == Game.getPlayer() || isRegistered(oref.getWearer())
		;StorageUtil.SetIntValue(oref.getWearer(), "UD_blockSlotUpdate",1)
		unregisterDevice(oref)
		;StorageUtil.UnsetIntValue(oref.getWearer(), "UD_blockSlotUpdate")
	endif
	;UDCD_NPCM.updateSlots()
	;UDCD_NPCM.getNPCSlotByActor(oref.getWearer()).regainDevices()
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
	RegisterForModEvent("DeviceActorOrgasm", "OnOrgasm")
	RegisterForModEvent("DeviceEdgedActor", "OnEdge")
	RegisterForModEvent("HookOrgasmStart", "OnSexlabOrgasmStart")
	RegisterForModEvent("SexLabOrgasmSeparate", "OnSexlabSepOrgasmStart")
	RegisterForModEvent("UD_ActivateDevice","OnActivateDevice")
	RegisterForModEvent("UD_UpdateHud","updateHUDBars")
	RegisterForModEvent("UD_AVCheckLoopStart","AVCheckLoop")
	RegisterForModEvent("UD_AVCheckLoopStartHelper","AVCheckLoopHelper")
	RegisterForModEvent("UD_CritUpdateLoopStart","CritLoop")
	RegisterForModEvent("UD_OrgasmCheckLoop","OrgasmCheckLoop")
	RegisterForModEvent("UD_ArousalCheckLoop","ArousalCheckLoop")
	RegisterForModEvent("UD_StartVibFunction","FetchAndStartVibFunction")
	RegisterForModEvent("UD_Orgasm","Orgasm")
	RegisterForModEvent("UD_CritUpdateLoopStart_OrgasmResist","CritLoopOrgasmResist")
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
	while _SendExpression && loc_time <= 1.0
		Utility.waitMenuMode(0.05)
		loc_time += 0.05
	endwhile
	if loc_time >= 1.0
		_SendExpression = none
		Error("SendSetExpressionEvent timeout!!")
	endif
EndFunction

Function SetExpression(Form kActor,int iStrength,int openMouth)
	Actor akActor = kActor as Actor
	sslBaseExpression loc_expression = _SendExpression
	_SendExpression = none
	(libs as zadlibs_UDPatch).SetExpression(akActor,loc_expression,iStrength,openMouth)
EndFunction


;call devices function orgasm() when player have DD orgasm
Event OnOrgasm(string eventName, string strArg, float numArg, Form sender)
	UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByActorName(strArg)
	if slot
		slot.orgasm()
	endif
EndEvent

;call devices function orgasm() when player have sexlab orgasm
Event OnSexlabOrgasmStart(int tid, bool HasPlayer)   
	if HasPlayer
		UDCD_NPCM.getPlayerSlot().orgasm()
	endif
EndEvent 

Function OnSexlabSepOrgasmStart(Form kActor, Int iThread)
	Actor akActor = kActor as Actor
	UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByActor(akActor)
	if slot
		slot.orgasm()
	endif
EndFunction

;call devices function edge() when player get edged
Function OnEdge(string eventName, string strArg, float numArg, Form sender)
	if strArg != Game.getPlayer().getActorBase().getName()
		int random = Utility.randomInt(1,3)
		if random == 1
			debug.notification(strArg + " gets denied just before reaching the orgasm!")
		elseif random == 2
			debug.notification(strArg + " screams as they are edged just before climax!")
		elseif random == 3
			debug.notification(strArg + " is edged!")
		endif
	endif
	UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByActorName(strArg)
	if slot
		slot.edge()
	endif
EndFunction

;replece slot with new device
Function replaceSlot(UD_CustomDevice_RenderScript oref, Armor inventoryDevice)
	UDCD_NPCM.getNPCSlotByActor(oref.getWearer()).replaceSlot(oref,inventoryDevice)
EndFunction

;show MCM debug menu
Function showDebugMenu(Actor akActor,int slot_id)
	UDCD_NPCM.getNPCSlotByActor(akActor).showDebugMenu(slot_id)
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
	float timePassed = Utility.GetCurrentGameTime() - LastUpdateTime
	UDCD_NPCM.update(timePassed)
	LastUpdateTime = Utility.GetCurrentGameTime()
	RegisterForSingleUpdate(UD_UpdateTime)
EndEvent

float LastUpdateTime_Hour = 0.0 ;last time the update happened in days
Event OnUpdateGameTime()
	Utility.waitMenuMode(Utility.randomFloat(2.0,4.0))
	float currentgametime = Utility.GetCurrentGameTime()
	float mult = 24.0*(currentgametime - LastUpdateTime_Hour) ;multiplier for how much more then 1 hour have passed, ex: for 2.5 hours passed without update, the mult will be 2.5
	int i = 0	
	UDCD_NPCM.updateHour(mult)
	LastUpdateTime_Hour = Utility.GetCurrentGameTime()
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
Int Property UD_CritEffect = 2 auto
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

bool _specialButtonOn = false
Event OnKeyDown(Int KeyCode)
	if !Utility.IsInMenuMode() ;only if player is not in menu
		bool _crit = crit ;help variable to reduce lag
		if TraceAllowed()		
			Log("OnKeyDown(), Keycode: " + KeyCode,3)
		endif
		if actorInMinigame(Game.GetPlayer())
			if KeyCode == SpecialKey_Keycode
				if _PlayerOrgasmResist_MinigameOn
					_specialButtonOn = true
				else
					_oCurrentPlayerMinigameDevice.SpecialButtonPressed()
				endif
				return
			endif
			
			if (_crit) && !UD_AutoCrit
				if selected_crit_meter == "S" && KeyCode == Stamina_meter_Keycode
					if TraceAllowed()					
						Log("Crit detected for Stamina bar! Keycode: " + KeyCode)
					endif
					crit = False
					_crit = False
					if _PlayerOrgasmResist_MinigameOn
						OnCritSuccesOrgasmResist()
					else
						_oCurrentPlayerMinigameDevice.critDevice()
					endif
					return
				elseif selected_crit_meter == "M" && KeyCode == Magicka_meter_Keycode
					if TraceAllowed()					
						Log("Crit detected for Magicka bar! Keycode: " + KeyCode)
					endif
					crit = False
					_crit = False
					if _PlayerOrgasmResist_MinigameOn
						OnCritSuccesOrgasmResist()
					else
						_oCurrentPlayerMinigameDevice.critDevice()
					endif
					return
				elseif KeyCode == Magicka_meter_Keycode || KeyCode == Stamina_meter_Keycode
					if TraceAllowed()					
						Log("Crit failure detected! Keycode: " + KeyCode)
					endif
					crit = False
					_crit = False
					if _PlayerOrgasmResist_MinigameOn
						OnCritFailureOrgasmResist()
					else
						_oCurrentPlayerMinigameDevice.critFailure()
					endif
					
				elseif KeyCode == ActionKey_Keycode
					if TraceAllowed()					
						Log("ActionKey_Keycode pressed! Keycode: " + KeyCode)
					endif
					if _PlayerOrgasmResist_MinigameOn
						;StorageUtil.SetIntValue(Game.getPlayer(),"UD_OrgasmResistMinigame_EndFlag",1)
						Game.GetPlayer().removeFromFaction(OrgasmResistFaction)
					else
						_oCurrentPlayerMinigameDevice.stopMinigame()
					endif
					crit = false
					return 
				endif
			endif
			if KeyCode == ActionKey_Keycode
				if _PlayerOrgasmResist_MinigameOn
					;StorageUtil.SetIntValue(Game.getPlayer(),"UD_OrgasmResistMinigame_EndFlag",1)
					Game.GetPlayer().removeFromFaction(OrgasmResistFaction)
					crit = false
					return
				elseif _oCurrentPlayerMinigameDevice
					_oCurrentPlayerMinigameDevice.stopMinigame()
				endif
				return
			elseif (KeyCode == Stamina_meter_Keycode || KeyCode == Magicka_meter_Keycode) && !UD_AutoCrit
				crit = False
				_crit = False
				if _PlayerOrgasmResist_MinigameOn
					OnCritFailureOrgasmResist()
				else
					_oCurrentPlayerMinigameDevice.critFailure()
				endif
				return
			endif
		else ;when player is not bussy
			if !IsMenuOpen()
				if KeyCode == PlayerMenu_KeyCode
					PlayerMenu()
				elseif KeyCode == NPCMenu_Keycode
					ObjectReference loc_ref = Game.GetCurrentCrosshairRef()
					if loc_ref as Actor
						Actor loc_actor = loc_ref as Actor
						NPCMenu(loc_actor)
					endif
				endif
			endif
		endif
	endif
EndEvent

Event OnKeyUp(Int KeyCode, Float HoldTime)
	if KeyCode == StruggleKey_Keycode
		if !IsMenuOpen() && !actorInMinigame(Game.GetPlayer())
			if HoldTime < 0.4
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
		endif
	elseif KeyCode == SpecialKey_Keycode
		if _PlayerOrgasmResist_MinigameOn
			_specialButtonOn = false
		endif
		return
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

Bool Property UD_CurrentNPCMenuIsFollower = False auto conditional

Function NPCMenu(Actor akActor)
	SetMessageAlias(akActor)
	UD_CurrentNPCMenuIsFollower = ActorIsFollower(akActor)
	int loc_res = NPCDebugMenuMsg.show()
	if loc_res == 0
		UDCD_NPCM.RegisterNPC(akActor,true)
	elseif loc_res == 1
		UDCD_NPCM.UnregisterNPC(akActor,true)
	elseif loc_res == 2
		akActor.UpdateWeight(0)
	elseif loc_res == 3
		DebugFunction(akActor)
	elseif loc_res == 4
		akActor.openInventory(True)
	elseif loc_res == 5
		if !StorageUtil.GetIntValue(akActor,"UDNPCMenu_SetDontMove",0)
			StorageUtil.SetIntValue(akActor,"UDNPCMenu_SetDontMove",1)
			akActor.setDontMove(true)
		else
			StorageUtil.UnSetIntValue(akActor,"UDNPCMenu_SetDontMove")
			akActor.setDontMove(false)
		endif
	elseif loc_res == 6
		showActorDetails(akActor)
	else
		return
	endif
EndFunction

Function PlayerMenu()
	int loc_playerMenuRes = PlayerMenuMsg.show()
	if loc_playerMenuRes == 0
		FocusOrgasmResistMinigame(Game.getPlayer())
	elseif loc_playerMenuRes == 1
		showActorDetails(Game.getPlayer())
	elseif loc_playerMenuRes == 2
		DebugFunction(Game.getPlayer())
	else
		return
	endif
EndFunction

Function showActorDetails(Actor akActor)
	string loc_res = ""
	loc_res += "--BASE DETAILS--\n"
	loc_res += "Name: " + akActor.GetLeveledActorBase().GetName() + "\n"
	loc_res += "LVL: " + akActor.GetLevel() + "\n"
	loc_res += "HP: " + UDmain.formatString(akActor.getAV("Health"),1) + "/" +  UDmain.formatString(UDmain.getMaxActorValue(akActor,"Health"),1) + " ("+ Round(UDmain.getCurrentActorValuePerc(akActor,"Health")*100) +" %)" +"\n"
	loc_res += "MP: " + UDmain.formatString(akActor.getAV("Magicka"),1) + "/" + UDmain.formatString(UDmain.getMaxActorValue(akActor,"Magicka"),1) + " ( "+ Round(UDmain.getCurrentActorValuePerc(akActor,"Magicka")*100) +" %)" +"\n"
	loc_res += "SP: " + UDmain.formatString(akActor.getAV("Stamina"),1) + "/" +  UDmain.formatString(UDmain.getMaxActorValue(akActor,"Stamina"),1) + " ("+ Round(UDmain.getCurrentActorValuePerc(akActor,"Stamina")*100) +" %)" +"\n"
	
	
	loc_res += "Agility skill: " + Round(getActorAgilitySkills(akActor)) + "\n"
	loc_res += "Strenth skill: " + Round(getActorStrengthSkills(akActor)) + "\n"
	loc_res += "Magicka skill: " + Round(getActorMagickSkills(akActor)) + "\n"
	loc_res += "Cutting skill: " + Round(getActorCuttingSkills(akActor)) + "\n"
	
	;if getCurrentZadAnimation(akActor) != "none"
	;	loc_res += "Animation: " + getCurrentZadAnimation(akActor) + "\n"
	;endif
	
	ShowMessageBox(loc_res)
	if Game.UsingGamepad()
		Utility.waitMenuMode(0.75)
	endif
	string loc_orgStr = ""
	loc_orgStr += "--ORGASM DETAILS--\n"
	loc_orgStr += "Name: " + getActorName(akActor) + "\n"
	loc_orgStr += "Arousal: " + getArousal(akActor) + "\n"
	loc_orgStr += "Arousal Rate: " + UDmain.formatString(getArousalRate(akActor),2) + "\n"
	loc_orgStr += "Orgasm capacity: " + Round(getActorOrgasmCapacity(akActor)) + "\n"
	loc_orgStr += "Orgasm resistence: " + UDmain.FormatString(getActorOrgasmResist(akActor),1) + "\n"
	loc_orgStr += "Orgasm progress: " + UDmain.formatString(getOrgasmProgressPerc(akActor) * 100,2) + " %\n"
	loc_orgStr += "Orgasm rate: " + UDmain.formatString(getActorAfterMultOrgasmRate(akActor),2) + " - " + UDmain.formatString(getActorAfterMultAntiOrgasmRate(akActor),2) + " Op/s\n"
	loc_orgStr += "Orgasm mult: " + Round(getActorOrgasmRateMultiplier(akActor)*100.0) + " %\n"
	loc_orgStr += "Orgasm resisting: " + Round(getActorOrgasmResistMultiplier(akActor)*100.0) + " %\n"

	ShowMessageBox(loc_orgStr)
	if Game.UsingGamepad()
		Utility.waitMenuMode(0.75)
	endif
	Weapon loc_sharpestWeapon = getSharpestWeapon(akActor)
	if loc_sharpestWeapon
		string loc_cuttStr = ""
		loc_cuttStr += "--CUTTING DETAILS--\n"
		loc_cuttStr += "Sharpest weapon: " + loc_sharpestWeapon.getName() + "\n"
		loc_cuttStr += "Cutting multiplier: " + UDmain.FormatString(loc_sharpestWeapon.getBaseDamage()*2.5,1) + " %\n"
		
		ShowMessageBox(loc_cuttStr)
	endif
	
	if UDmain.DebugMod
		string loc_debugStr = "--DEBUG DETAILS--\n"
		loc_debugStr += "Registered: " + akActor.isInFaction(RegisteredNPCFaction) + "\n"
		loc_debugStr += "Orgasm Chack: " + akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW) + "\n"
		loc_debugStr += "Arousal Chack: " + akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW) + "\n"
		loc_debugStr += "Hardcore Disable: " + akActor.HasMagicEffectWithKeyword(UDlibs.HardcoreDisable_KW) + "\n"
		loc_debugStr += "Animating: " + libs.IsAnimating(akActor) + "\n"
		loc_debugStr += "Animation block: " + akActor.isInFaction(BlockAnimationFaction) + "\n"
		loc_debugStr += "Epression level: " + akActor.GetFactionRank(BlockExpressionFaction) +"\n"
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
EndFunction

;///////////////////////////////////////
;=======================================
;			SKILL FUNCTIONS
;=======================================
;//////////////////////////////////////;
;-Used to return absolute and relative skill values which are used by some minigames

float Function getActorAgilitySkills(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("Pickpocket")
	return loc_result
EndFunction

float Function getActorAgilitySkillsPerc(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("Pickpocket")/100.0
	return loc_result
EndFunction

float Function getActorStrengthSkills(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("TwoHanded")
	return loc_result
EndFunction

float Function getActorStrengthSkillsPerc(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("TwoHanded")/100.0
	return loc_result
EndFunction

float Function getActorMagickSkills(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("Destruction")
	return loc_result
EndFunction

float Function getActorMagickSkillsPerc(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("Destruction")/100.0
	
	return loc_result
EndFunction

float Function getActorCuttingSkills(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("OneHanded")
	return loc_result
EndFunction

float Function getActorCuttingSkillsPerc(Actor akActor)
	float loc_result = 0.0
	loc_result += akActor.GetActorValue("OneHanded")/100.0
	return loc_result
EndFunction

;calculates multiplier for cutting minigame
;value is decided by weapon with sharp wapon with most dmg
Float Function getActorCuttingWeaponMultiplier(Actor akActor)
	float loc_res = 1.0 ;100%
	
	Weapon loc_bestWeapon = getSharpestWeapon(akActor)
	
	if loc_bestWeapon
		loc_res += loc_bestWeapon.getBaseDamage()*0.025
	endif
	
	return fRange(loc_res,1.0,3.0)
EndFunction

Weapon Function getSharpestWeapon(Actor akActor)
	int loc_i = akActor.GetNumItems()
	
	Weapon loc_bestWeapon = none
	
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
	return loc_bestWeapon
EndFunction

bool Function isSharp(Weapon wWeapon)
	int loc_i = UDlibs.SharpWeaponsKeywords.length
	
	while loc_i
		loc_i -= 1
		if wWeapon.hasKeyword(UDlibs.SharpWeaponsKeywords[loc_i])
			return true
		endif
	endwhile
	return false
EndFunction

Int Function ActorBelted(Actor akActor)
	int loc_res = 0
	If akActor.WornHasKeyword(libs.zad_DeviousBelt)											;rewritten per issue: https://github.com/IHateMyKite/UnforgivingDevices/issues/17
		Armor loc_belt = libs.GetWornRenderedDeviceByKeyword(akActor, libs.zad_DeviousBelt)		;this function is painstakingly slow on cluttered inventories.
		if !loc_belt.HasKeyword(libs.zad_PermitAnal)
			loc_res = 1 ;Actor has belt which doesn't permit anal 
		else
			loc_res = 2 ;Actor has belt which permits anal 
		EndIf
	EndIf
	; if akActor.WornHasKeyword(libs.zad_deviousBelt)
	; 	loc_res = 1
	; endif
	; if akActor.WornHasKeyword(libs.zad_permitAnal) && loc_res == 1
	; 	loc_res = 2
	; endif
	return loc_res
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
bool Property LockpickMinigameOver = false auto
int Property LockpickMinigameResult = 0 auto
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

;returns first device which have connected corresponding Inventory Device
UD_CustomDevice_RenderScript Function getDeviceByInventory(Actor akActor, Armor deviceInventory)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getDeviceByInventory(deviceInventory)
	else
		return getDeviceScriptByRender(akActor,StorageUtil.GetFormValue(akActor, "UD_RenderDevice" + deviceInventory, none) as Armor)
	endif
EndFunction

;returns first device which have connected corresponding Inventory Device,uses fetch funtion
UD_CustomDevice_RenderScript Function FetchDeviceByInventory(Actor akActor, Armor deviceInventory)
	return getDeviceScriptByRender(akActor,StorageUtil.GetFormValue(deviceInventory, "UD_RenderDevice", none) as Armor)
EndFunction

;returns heavy bondage (hand restrain) device
UD_CustomDevice_RenderScript Function getHeavyBondageDevice(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getHeavyBondageDevice()
	else
		return getDeviceScriptByKw(akActor,libs.zad_deviousHeavyBondage)
	endif
EndFunction

;returns current device that have minigame on (return none if no minigame is on)
UD_CustomDevice_RenderScript Function getMinigameDevice(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getMinigameDevice()
	else
		return getDeviceScriptByRender(akActor,StorageUtil.GetFormValue(akActor, "UD_currentMinigameDevice", none) as Armor)
	endif
EndFunction

;returs first device by keywords
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
UD_CustomDevice_RenderScript Function getFirstDeviceByKeyword(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getFirstDeviceByKeyword(kw1,kw2,kw3,mod)
	else
		return getDeviceScriptByKw(akActor,kw1)
	endif
EndFunction

;returns last device containing keyword
UD_CustomDevice_RenderScript Function getLastDeviceByKeyword(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getLastDeviceByKeyword(kw1,kw2,kw3,mod)
	else
		return getDeviceScriptByKw(akActor,kw1)
	endif
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
UD_CustomDevice_RenderScript[] Function getAllDevicesByKeyword(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getAllDevicesByKeyword(kw1,kw2,kw3,mod)
	else
		return MakeNewDeviceSlots();getAllDeviceScriptsByKw(akActor,kw1,kw2,kw3,mod)
	endif
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
UD_CustomDevice_RenderScript[] Function getAllActivableDevicesByKeyword(Actor akActor,bool bCheckCondition,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getAllActivableDevicesByKeyword(bCheckCondition,kw1,kw2,kw3,mod)
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

UD_CustomDevice_RenderScript Property _transferedDevice = none auto
bool _transfereMutex = false
UD_CustomDevice_RenderScript Function getDeviceScriptByRender(Actor akActor,Armor deviceRendered)
	
	if akActor.getItemCount(deviceRendered) <= 0
		Error("getDeviceScriptByRender() - Actor doesn't have render device!")
		return none
	endif
	
	if !deviceRendered
		Error("getDeviceScriptByRender() - deviceRendered = None!!")
		return none
	endif
	
	UD_CustomDevice_RenderScript result = none
	while _transfereMutex
		Utility.waitMenuMode(0.1)
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
	while !_transferedDevice && loc_time < 2.0
		Utility.waitMenuMode(0.05)
		loc_time += 0.05
	endwhile
	
	if loc_time > 2.0 && !_transferedDevice		
		Error("getDeviceScriptByRender timeout for " + deviceRendered + "("+getActorName(akActor)+")")
	endif
	
	result = _transferedDevice
	_transferedDevice = none
	_transfereMutex = False
	if akActor != libs.playerRef
		akActor.UpdateWeight(0)
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
		return UDCD_NPCM.getNPCSlotByActor(akActor).getNumberOfDevicesWithKeyword(kw1,kw2,kw3,mod)
	endif
	return 0
EndFunction

;returns number of all device containing keyword in their render device
;mod = 0 => AND 	(device need all provided keyword)
;mod = 1 => OR 	(device need one provided keyword)
int Function getNumberOfActivableDevicesWithKeyword(Actor akActor,bool bCheckCondition, keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getNumberOfActivableDevicesWithKeyword(bCheckCondition,kw1,kw2,kw3,mod)
	else
		return 0;getAllActivableDevicesNumByKw(akActor,kw1,kw2,kw3,mod)
	endif
EndFunction

;returns all device that can be activated
UD_CustomDevice_RenderScript[] Function getActiveDevices(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getActiveDevices()
	else
		return MakeNewDeviceSlots();getAllActivableDevicesByKw(akActor,UDLibs.UnforgivingDevice)
	endif
EndFunction

;returns number of devices that can be activated
int Function getActiveDevicesNum(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getActiveDevicesNum()
	else
		return 0;getAllActivableDevicesNumByKw(akActor,UDLibs.UnforgivingDevice)
	endif
EndFunction

;returns number of vibrators
int Function getVibratorNum(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getVibratorNum()
	else
		return 0
	endif
EndFunction

;returns number of turned off vibrators
int Function getOffVibratorNum(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getOffVibratorNum()
	else
		return 0
	endif
EndFunction

;returns all vibrators
UD_CustomDevice_RenderScript[] Function getVibrators(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getVibrators()
	endif
	return none
EndFunction

;returns all turned off vibrators
UD_CustomDevice_RenderScript[] Function getOffVibrators(Actor akActor)
	if isRegistered(akActor)
		return UDCD_NPCM.getNPCSlotByActor(akActor).getOffVibrators()
	endif
	return none
EndFunction

;???
Function deleteLastUsedSlot(Actor akActor)
	if isRegistered(akActor)
		UDCD_NPCM.getNPCSlotByActor(akActor).deleteLastUsedSlot()
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

int Function getActorArousal(Actor akActor)
	;if isRegistered(akActor)
		;return UDCD_NPCM.getNPCSlotByActor(akActor).iNPCArousal
	;else
		return libs.Aroused.GetActorExposure(akActor)
	;endif
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

Function AVCheckLoop(Form fActor,Float fUpdateTime)
	if !akActor
		Error("None passed to sendMinigameCritUpdateLoop!!!")
	endif
	Actor akActor = fActor as Actor
	UD_CustomDevice_RenderScript device = _AVCheckLoop_Package
	_AVCheckLoop_Package = none
	if device
		device.checkAVLoop(fUpdateTime)
	endif
EndFunction

Function AVCheckLoopHelper(Form fActor,Float fUpdateTime)
	if !akActor
		Error("None passed to sendMinigameCritUpdateLoop!!!")
	endif
	Actor akActor = fActor as Actor
	UD_CustomDevice_RenderScript device = _AVCheckLoop_Package
	_AVCheckLoop_Package = none
	if device
		device.checkAVLoopHelper(fUpdateTime)
	endif
EndFunction

Function sendMinigameCritUpdateLoop(Actor akActor)
	if !akActor
		Error("None passed to sendMinigameCritUpdateLoop!!!")
	endif
	int handle = ModEvent.Create("UD_CritUpdateLoopStart")
	if (handle)
        ModEvent.PushForm(handle,akActor)
        ModEvent.Send(handle)
    endif
EndFunction

Function CritLoop(Form fActor)
	Actor akActor = fActor as Actor
	UD_CustomDevice_RenderScript device = getMinigameDevice(akActor)
	if device
		device.startCritLoop()
	endif
EndFunction

Function CheckOrgasmCheck(Actor akActor)
	if !akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW)
		UDlibs.OrgasmCheckSpell.cast(akActor);sendOrgasmCheckLoop(akActor)
	endif
EndFunction

Function CheckArousalCheck(Actor akActor)
	if !akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW)
		UDlibs.ArousalCheckSpell.cast(akActor);sendOrgasmCheckLoop(akActor)
	endif
EndFunction

Int Function UpdateArousal(Actor akActor ,float arousal)
	;StorageUtil.SetFloatValue(akActor, "SLAroused.ActorExposure",Round(fRange(StorageUtil.GetFloatValue(akActor, "SLAroused.ActorExposure", 0.0) + arousal,0.0,100.0)))
	;StorageUtil.SetFloatValue(akActor, "SLAroused.ActorExposureDate", Utility.GetCurrentGameTime())
	
	libs.UpdateExposure(akActor, arousal, true)
	
	return GetActorArousal(akActor)
EndFunction

Int Function getArousal(Actor akActor)
	if akActor.isInFaction(ArousalCheckLoopFaction)
		return akActor.GetFactionRank(ArousalCheckLoopFaction)
	else
		return getActorArousal(akActor)
	endif
EndFunction

bool _ArousalRateManip_Mutex = false
Float Function UpdateArousalRate(Actor akActor ,float fArousalRate)
	while _ArousalRateManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_ArousalRateManip_Mutex = true
	float loc_newArousalRate = StorageUtil.getFloatValue(akActor, "UD_ArousalRate",0.0) + fArousalRate
	StorageUtil.setFloatValue(akActor, "UD_ArousalRate",loc_newArousalRate)
	_ArousalRateManip_Mutex = false
	return loc_newArousalRate
EndFunction

Float Function getArousalRate(Actor akActor)
	return StorageUtil.getFloatValue(akActor, "UD_ArousalRate",0.0)
EndFunction

Function StartArousalCheckLoop(Actor akActor)
	if !akActor
		Error("None passed to StartArousalCheckLoop!!!")
	endif
	
	if TraceAllowed()	
		Log("StartArousalCheckLoop("+getActorName(akActor)+") called")
	endif
	if akActor.isInFaction(ArousalCheckLoopFaction)
		return
	endif
	akActor.AddToFaction(ArousalCheckLoopFaction)
	
	int handle = ModEvent.Create("UD_ArousalCheckLoop")
	if (handle)
		if TraceAllowed()		
			Log("StartArousalCheckLoop("+getActorName(akActor)+"), sending event")
		endif
        ModEvent.PushForm(handle,akActor)
        ModEvent.Send(handle)
    endif
EndFunction

Function ArousalCheckLoop(Form fActor)
	Actor akActor = fActor as Actor
	if TraceAllowed()	
		Log("ArousalCheckLoop("+getActorName(akActor)+") started")
	endif
	float loc_updateTime = 3.0
	while isRegistered(akActor) && akActor.isInFaction(ArousalCheckLoopFaction) && !akActor.isDead()
		Float loc_arousalRate = getArousalRate(akActor)

		Int loc_arousal = Round(loc_arousalRate*loc_updateTime)
		if TraceAllowed()	
			Log("ArousalCheckLoop("+getActorName(akActor)+") increasing arousal by: "+loc_arousal,3)
		endif
		if akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmExhaustionEffect_KW)
			loc_arousal = Round(loc_arousal * 0.5)
		endif
		;if TraceAllowed()	
		;	Log("ArousalCheckLoop("+getActorName(akActor)+") Arousal before: "+getActorArousal(akActor))
		;endif
		if loc_arousal > 0
			akActor.SetFactionRank(ArousalCheckLoopFaction,UpdateArousal(akActor ,loc_arousal))
		else
			akActor.SetFactionRank(ArousalCheckLoopFaction,getActorArousal(akActor))
		endif
		;if TraceAllowed()	
		;	Log("ArousalCheckLoop("+getActorName(akActor)+") Arousal after: "+akActor.GetFactionRank(ArousalCheckLoopFaction))
		;endif
		Utility.wait(loc_updateTime)
	endwhile
	akActor.RemoveFromFaction(ArousalCheckLoopFaction)
	if TraceAllowed()	
		Log("ArousalCheckLoop("+getActorName(akActor)+") ended")
	endif
EndFunction

;=======================================
;		  		ORGASM RATE
;=======================================
bool _OrgasmRateManip_Mutex = false
float Function UpdateOrgasmRate(Actor akActor ,float orgasmRate,float orgasmForcing)
	while _OrgasmRateManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmRateManip_Mutex = true
	float loc_newOrgasmRate = StorageUtil.getFloatValue(akActor, "UD_OrgasmRate",0.0) + orgasmRate
	StorageUtil.setFloatValue(akActor, "UD_OrgasmRate",loc_newOrgasmRate)
	StorageUtil.setFloatValue(akActor, "UD_OrgasmForcing",StorageUtil.getFloatValue(akActor, "UD_OrgasmForcing",0.0) + orgasmForcing)	
	_OrgasmRateManip_Mutex = false
	return orgasmRate
EndFunction
Function removeOrgasmRate(Actor akActor ,float orgasmRate,float orgasmForcing)
	while _OrgasmRateManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmRateManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmRate",StorageUtil.getFloatValue(akActor, "UD_OrgasmRate",0.0) - orgasmRate)
	StorageUtil.setFloatValue(akActor, "UD_OrgasmForcing",StorageUtil.getFloatValue(akActor, "UD_OrgasmForcing",0.0) - orgasmForcing)
	_OrgasmRateManip_Mutex = false
EndFunction
float Function getActorOrgasmRate(Actor akActor)
	return UDmain.fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmRate",0.0),0.0,200.0)
EndFunction
float Function getActorAfterMultOrgasmRate(Actor akActor)
	return getActorOrgasmRate(akActor)*getActorOrgasmRateMultiplier(akActor)
EndFunction
float Function getActorAfterMultAntiOrgasmRate(Actor akActor)
	return CulculateAntiOrgasmRateMultiplier(getArousal(akActor))*getActorOrgasmResistMultiplier(akActor)*(getActorOrgasmResist(akActor))
EndFunction


float Function getActorOrgasmForcing(Actor akActor)
	return StorageUtil.getFloatValue(akActor, "UD_OrgasmForcing",0.0)
EndFunction

;=======================================
;		  ORGASM RATE MULTIPLIER
;=======================================
bool _OrgasmRateMultManip_Mutex = false
Function UpdateOrgasmRateMultiplier(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmRateMultManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmRateMultManip_Mutex = true
	float loc_newOrgasmRateMult = StorageUtil.getFloatValue(akActor, "UD_OrgasmRateMultiplier",1.0) + orgasmRateMultiplier
	StorageUtil.setFloatValue(akActor, "UD_OrgasmRateMultiplier",loc_newOrgasmRateMult)
	_OrgasmRateMultManip_Mutex = false
EndFunction

Function removeOrgasmRateMultiplier(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmRateMultManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmRateMultManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmRateMultiplier",StorageUtil.getFloatValue(akActor, "UD_OrgasmRateMultiplier",1.0) - orgasmRateMultiplier)
	_OrgasmRateMultManip_Mutex = false
EndFunction
float Function getActorOrgasmRateMultiplier(Actor akActor) ;!!UNSED!!
	return fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmRateMultiplier",1.0),0.0,10.0)
	;return 1.0 
EndFunction

;=======================================
;	   	   ORGASM RESISTENCE
;=======================================
bool _OrgasmResistManip_Mutex = false
Function UpdateOrgasmResist(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmResistManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmResistManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmResist",fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmResist",UD_OrgasmResistence) + orgasmRateMultiplier,0.0,100.0))
	_OrgasmResistManip_Mutex = false
EndFunction
Function setActorOrgasmResist(Actor akActor,float fValue)
	while _OrgasmResistManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmResistManip_Mutex = true
	StorageUtil.SetFloatValue(akActor, "UD_OrgasmResist",fRange(fValue,0.0,100.0))
	_OrgasmResistManip_Mutex = false
EndFunction
float Function getActorOrgasmResist(Actor akActor)
	return fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmResist",UD_OrgasmResistence),0.0,100.0)
EndFunction

;=======================================
;	   ORGASM RESISTENCE MULTIPLIER
;=======================================
bool _OrgasmResistMultManip_Mutex = false
Function UpdateOrgasmResistMultiplier(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmResistMultManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmResistMultManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmResistMultiplier",StorageUtil.getFloatValue(akActor, "UD_OrgasmResistMultiplier",1.0) + orgasmRateMultiplier)
	_OrgasmResistMultManip_Mutex = false
EndFunction
Function removeOrgasmResistMultiplier(Actor akActor ,float orgasmRateMultiplier)
	while _OrgasmResistMultManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmResistMultManip_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmResistMultiplier",StorageUtil.getFloatValue(akActor, "UD_OrgasmResistMultiplier",1.0) - orgasmRateMultiplier)
	_OrgasmResistMultManip_Mutex = false
EndFunction
float Function getActorOrgasmResistMultiplier(Actor akActor)
	return StorageUtil.getFloatValue(akActor, "UD_OrgasmResistMultiplier",1.0)
EndFunction

;=======================================
;		 	 ORGASM PROGRESS
;=======================================
bool _OrgasmProgressManip_Mutex
Function SetActorOrgasmProgress(Actor akActor,Float fValue)
	while _OrgasmProgressManip_Mutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmProgressManip_Mutex = true
	StorageUtil.SetFloatValue(akActor, "UD_OrgasmProgress",fRange(fValue,0.0,getActorOrgasmCapacity(akActor)))
	_OrgasmProgressManip_Mutex = false
EndFunction
Function UpdateActorOrgasmProgress(Actor akActor,Float fValue,bool bUpdateWidget = false)
	while _OrgasmProgressManip_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmProgressManip_Mutex = true
	float loc_newValue = fRange(StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0) + fValue,0.0,getActorOrgasmCapacity(akActor))
	StorageUtil.SetFloatValue(akActor, "UD_OrgasmProgress",loc_newValue)
	if bUpdateWidget && UD_UseOrgasmWidget
		widget2.SetPercent(loc_newValue/getActorOrgasmCapacity(akActor))
	endif
	_OrgasmProgressManip_Mutex = false
EndFunction
Function ResetActorOrgasmProgress(Actor akActor)
	StorageUtil.UnSetFloatValue(akActor, "UD_OrgasmProgress")
EndFunction
float Function getActorOrgasmProgress(Actor akActor)
	return StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0)
EndFunction
float Function getOrgasmProgressPerc(Actor akActor)
	return StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0)/getActorOrgasmCapacity(akActor)
EndFunction


;=======================================
;ORGASM CAPACITY
;=======================================

float Function getActorOrgasmCapacity(Actor akActor)
	return StorageUtil.GetFloatValue(akActor, "UD_OrgasmCapacity",100.0)
EndFunction

bool _OrgasmCapacity_Mutex
Function UpdatetActorOrgasmCapacity(Actor akActor,float fValue)
	while _OrgasmCapacity_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmCapacity_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmCapacity",fRange(StorageUtil.getFloatValue(akActor, "UD_OrgasmCapacity",100.0) + fValue,10.0,500.0))
	_OrgasmCapacity_Mutex = false
EndFunction

Function SetActorOrgasmCapacity(Actor akActor,float fValue)
	while _OrgasmCapacity_Mutex
		Utility.waitMenuMode(0.1)
	endwhile
	_OrgasmCapacity_Mutex = true
	StorageUtil.setFloatValue(akActor, "UD_OrgasmCapacity",fRange(fValue,10.0,500.0))
	_OrgasmCapacity_Mutex = false
EndFunction

;=======================================
;ORGASM UTILITY CALCULATIONS
;=======================================

;return true if actor can orgasm at 100 arousal
bool Function ActorCanOrgasm(Actor akActor)
	return (getActorOrgasmRate(akActor)*getActorOrgasmRateMultiplier(akActor) > CulculateAntiOrgasmRateMultiplier(100)*UD_OrgasmResistence*getActorOrgasmResistMultiplier(akActor))
EndFunction

;return true if actor can orgasm at 50 arousal, because its not linear, orgasm rate would need to be gigantic 
bool Function ActorCanOrgasmHalf(Actor akActor)
	return (getActorOrgasmRate(akActor)*getActorOrgasmRateMultiplier(akActor) > CulculateAntiOrgasmRateMultiplier(50)*UD_OrgasmResistence*getActorOrgasmResistMultiplier(akActor))
EndFunction

bool Function ActorHaveExpressionApplied(Actor akActor)
	return StorageUtil.GetIntValue(akActor,"zad_expressionApplied",0)
EndFunction

float Function CulculateAntiOrgasmRateMultiplier(int iArousal)
	return fRange((Math.pow(10,fRange(100.0/iRange(iArousal,1,100),1.0,2.0) - 1.0)),1.0,100.0)
EndFunction

;///////////////////////////////////////
;=======================================
;ORGASM MAIN LOOP
;=======================================
;//////////////////////////////////////;
bool Property UD_UseOrgasmWidget = True auto
float Property UD_OrgasmUpdateTime = 0.2 auto
int Property UD_OrgasmAnimation = 1 auto
int Property UD_OrgasmDuration = 20 auto
bool Property UD_HornyAnimation = true auto
int Property UD_HornyAnimationDuration = 5 auto

Actor Property UD_StopActorOrgasmCheckLoop = none auto

Function OrgasmCheckLoop(Form fActor)
	Actor akActor = fActor as Actor
	if TraceAllowed()	
		Log("OrgasmCheckLoop() started for " + getActorName(akActor),1)
	endif
	;StartArousalCheckLoop(akActor)
	
	;StorageUtil.SetIntValue(akActor, "UD_OrgasmCheck",1)
	
	float loc_orgasmProgress = 0.0
	float loc_orgasmProgress2= 0.0
	int loc_hornyAnimTimer = 0
	bool[] loc_cameraState
	int loc_msID = -1

	sslBaseExpression expression = UDEM.getExpression("UDAroused");libs.SexLab.GetExpressionByName("UDAroused");

	float loc_currentUpdateTime = 1.5
	if UDmain.ActorIsPlayer(akActor)
		loc_currentUpdateTime = UD_OrgasmUpdateTime
	endif
	
	;local variables
	bool loc_widgetShown 				= false
	bool loc_forceStop 					= false
	float loc_orgasmRate 				= 0.0
	float loc_orgasmRate2 				= 0.0
	float loc_orgasmRateAnti 			= 0.0
	float loc_orgasmResistMultiplier	= getActorOrgasmResistMultiplier(akActor)
	float loc_orgasmRateMultiplier		= getActorOrgasmRateMultiplier(akActor)
	int loc_arousal 					= getArousal(akActor)
	int loc_tick 						= 1
	int loc_tickS						= 0
	int loc_expressionUpdateTimer 		= 0
	bool loc_orgasmResisting 			= akActor.isInFaction(OrgasmResistFaction)
	bool loc_expressionApplied 			= false;ActorHaveExpressionApplied(akActor)
	float loc_orgasmCapacity			= getActorOrgasmCapacity(akActor)
	float loc_orgasmResistence			= getActorOrgasmResist(akActor)
	
	bool loc_enoughArousal = false
	while isRegistered(akActor) && (UD_StopActorOrgasmCheckLoop != akActor) && !akActor.isDead()
		loc_orgasmProgress2 = loc_orgasmProgress
		
		loc_orgasmResisting = akActor.isInFaction(OrgasmResistFaction);StorageUtil.GetIntValue(akActor,"UD_OrgasmResisting",0)
		if loc_orgasmResisting
			loc_orgasmProgress = getActorOrgasmProgress(akActor)
		else
			loc_orgasmProgress += loc_orgasmRate*loc_orgasmRateMultiplier*loc_currentUpdateTime
		endif
		
		loc_orgasmRateAnti = CulculateAntiOrgasmRateMultiplier(loc_arousal)*loc_orgasmResistMultiplier*(loc_orgasmProgress*(loc_orgasmResistence/100.0))*loc_currentUpdateTime  ;edging, orgasm rate needs to be bigger then UD_OrgasmResistence, else actor will not reach orgasm
		
		if !loc_orgasmResisting
			if loc_orgasmRate*loc_orgasmRateMultiplier > 0.0
				loc_orgasmProgress -= loc_orgasmRateAnti
			else
				loc_orgasmProgress -= 3*loc_orgasmRateAnti
			endif
		endif
		
		
		;if loc_orgasmProgress/loc_orgasmCapacity > 0.85 ;edging thresdhold at 85%
			
			
		;endif
		
		if loc_widgetShown && !loc_orgasmResisting
			widget2.SetPercent(loc_orgasmProgress/loc_orgasmCapacity)
		endif

		;check orgasm
		if loc_orgasmProgress > 0.99*loc_orgasmCapacity
			if TraceAllowed()			
				Log("Starting orgasm for " + getActorName(akActor))
			endif
			if loc_orgasmResisting
				akActor.RemoveFromFaction(OrgasmResistFaction)
				;StorageUtil.SetIntValue(akActor,"UD_OrgasmResistMinigame_EndFlag",1)
			endif
			
			if loc_widgetShown
				loc_widgetShown = false
				toggleWidget2(false)
				widget2.SetPercent(0.0,true)
			endif
			
			loc_hornyAnimTimer = -30 ;cooldown
			
			startOrgasm(akActor,UD_OrgasmDuration,true)
			loc_orgasmProgress = 0.0
			SetActorOrgasmProgress(akActor,loc_orgasmProgress)
		endif
		
		if loc_tick * loc_currentUpdateTime >= 1.0
			loc_orgasmRate2 = loc_orgasmRate
			if UDmain.ActorIsPlayer(akActor)
				loc_currentUpdateTime = UD_OrgasmUpdateTime
			endif
			loc_tick = 0
			loc_tickS += 1
			
			if (loc_tickS % 2)
				loc_orgasmCapacity			= getActorOrgasmCapacity(akActor)
			else
				loc_orgasmResistence 		= getActorOrgasmResist(akActor)
			endif
			
			if !loc_orgasmResisting
				loc_arousal 				= getArousal(akActor)
				loc_orgasmRate 				= getActorOrgasmRate(akActor)
				loc_orgasmRateMultiplier	= getActorOrgasmRateMultiplier(akActor)
				loc_orgasmResistMultiplier 	= getActorOrgasmResistMultiplier(akActor)
				
				SetActorOrgasmProgress(akActor,loc_orgasmProgress)
			endif

			;expression
			if loc_orgasmRate >= loc_orgasmResistence*0.75 && (!loc_expressionApplied || loc_expressionUpdateTimer > 3) 
				;init expression
				(libs as zadlibs_UDPatch).ApplyExpressionPatched(akActor, expression, iRange(UDmain.Round(loc_orgasmProgress),25,100),false,10)
				loc_expressionApplied = true
				;expression.Apply(akActor,100,(akActor.GetBaseObject() as ActorBase).GetSex())
				loc_expressionUpdateTimer = 0
			elseif loc_orgasmRate < loc_orgasmResistence*0.75 && loc_expressionApplied
				;init expression
				loc_expressionApplied = false
				(libs as zadlibs_UDPatch).ResetExpressionPatched(akActor, expression,10)
			endif
			
			;can play horny animation ?
			if (loc_orgasmRate > 0.5*loc_orgasmResistMultiplier*loc_orgasmResistence) 
				if loc_enoughArousal
					;start moaning sound again
					if loc_msID == -1
						loc_msID = libs.MoanSound.Play(akActor)
						Sound.SetInstanceVolume(loc_msID, libs.GetMoanVolume(akActor))
					endif
				endif
			else
				;disable moaning sound when orgasm rate is too low
				if loc_msID != -1
					Sound.StopInstance(loc_msID)
					loc_msID = -1
				endif
			endif
			if !actorInMinigame(akActor)
				;bool loc_cond = false
				;loc_cond = loc_cond || ((loc_orgasmRate < loc_orgasmResistMultiplier*loc_orgasmResistence) && loc_orgasmRate >= loc_orgasmResistMultiplier*loc_orgasmResistence*0.5)
				;loc_cond = loc_cond || ((loc_orgasmProgress/loc_orgasmCapacity < 0.5) && loc_orgasmRate > loc_orgasmResistMultiplier*loc_orgasmResistence)
				if (loc_orgasmRate > 0.5*loc_orgasmResistMultiplier*loc_orgasmResistence) && !loc_orgasmResisting && !akActor.IsInCombat() ;orgasm progress is increasing
					if (loc_hornyAnimTimer == 0) && !libs.IsAnimating(akActor) && UD_HornyAnimation ;start horny animation for UD_HornyAnimationDuration
						if Utility.RandomInt() <= (Math.ceiling(100/fRange(loc_orgasmProgress,15.0,100.0))) 
							; Select animation
							loc_cameraState = libs.StartThirdPersonAnimation(akActor, libs.AnimSwitchKeyword(akActor, "Horny01"), permitRestrictive=true)
							loc_hornyAnimTimer += UD_HornyAnimationDuration
							if !loc_expressionApplied
								(libs as zadlibs_UDPatch).ApplyExpressionPatched(akActor, expression, iRange(UDmain.Round(loc_orgasmProgress),75,100),false,10)
								loc_expressionApplied = true
								loc_expressionUpdateTimer = 0
							endif
						endif
					EndIf
				endif
				
				if !loc_orgasmResisting
					if loc_hornyAnimTimer > 0 ;reduce horny animation timer 
						loc_hornyAnimTimer -= 1
						if (loc_hornyAnimTimer == 0)
							libs.EndThirdPersonAnimation(akActor, loc_cameraState, permitRestrictive=true)
							loc_hornyAnimTimer = -20 ;cooldown
						EndIf
					elseif loc_hornyAnimTimer < 0 ;cooldown
						loc_hornyAnimTimer += 1
					endif
				endif
			endif
			
			if UD_UseOrgasmWidget && UDmain.ActorIsPlayer(akActor)
				if (loc_widgetShown && loc_orgasmProgress < 2.5) ;|| (loc_widgetShown)
					toggleWidget2(false)
					loc_widgetShown = false
				elseif !loc_widgetShown && loc_orgasmProgress >= 2.5
					widget2.SetPercent(loc_orgasmProgress/loc_orgasmCapacity,true)
					toggleWidget2(true)
					loc_widgetShown = true
				endif
			endif
			
			if loc_orgasmProgress < 0.0
				loc_orgasmProgress = 0.0
			endif
			
			loc_expressionUpdateTimer += 1
		endif
		if loc_widgetShown
			Utility.wait(loc_currentUpdateTime)
		else
			Utility.wait(1.0)
		endif
		
		loc_tick += 1
	endwhile
	
	;stop moan sound
	if loc_msID != -1
		Sound.StopInstance(loc_msID)
	endif
	
	;end animation if it still exist
	if  loc_hornyAnimTimer > 0
		libs.EndThirdPersonAnimation(akActor, loc_cameraState, permitRestrictive=true)
		loc_hornyAnimTimer = 0
	EndIf
	
	;hide widget
	if loc_widgetShown
		toggleWidget2(false)
	endif
	
	;reset expression
	(libs as zadlibs_UDPatch).ResetExpressionPatched(akActor, expression)
	
	StorageUtil.UnsetFloatValue(akActor, "UD_OrgasmProgress")

	;end mutex
	;StorageUtil.UnSetIntValue(akActor, "UD_OrgasmCheck")
	akActor.RemoveFromFaction(OrgasmCheckLoopFaction)
	if UD_StopActorOrgasmCheckLoop == akActor
		UD_StopActorOrgasmCheckLoop = none
	endif
EndFunction

;=======================================
;START ORGASM EVENT
;=======================================

Function startOrgasm(Actor akActor,int duration,bool blocking = true)
	if TraceAllowed()	
		Log("startOrgasm() for " + getActorName(akActor) + ", duration = " + duration + ",blocking = " + blocking)
	endif
	int loc_orgasms = 0
	if blocking
		loc_orgasms = getOrgasmingCount(akActor)
	endif
	int handle = ModEvent.Create("UD_Orgasm")
	if (handle)
		ModEvent.PushForm(handle, akActor)
		ModEvent.PushInt(handle, duration)
        ModEvent.Send(handle)
		
		;check for orgasm start
		if blocking
			float loc_time = 0.0
			while (getOrgasmingCount(akActor) == loc_orgasms) && loc_time < 3.0
				Utility.waitMenuMode(0.05)
				loc_time += 0.05
			endwhile
			
			if loc_time >= 3.0
				Error("startOrgasm("+getActorName(akActor)+") timeout!")
			endif
		endif
    endIf	
EndFunction

;=======================================
;ORGASM
;=======================================

bool Function isOrgasming(Actor akActor)
	return akActor.isInFaction(OrgasmFaction)
EndFunction

Int Function getOrgasmingCount(Actor akActor)
	if isOrgasming(akActor)
		return akActor.GetFactionRank(OrgasmFaction)
	else
		return 0
	endif
EndFunction

Function addOrgasmToActor(Actor akActor)
	if !isOrgasming(akActor)
		akActor.addToFaction(OrgasmFaction)
		akActor.SetFactionRank(OrgasmFaction,0)
	endif
	
	akActor.ModFactionRank(OrgasmFaction,1)
EndFunction

Function removeOrgasmFromActor(Actor akActor)
	if !isOrgasming(akActor)
		return
	endif
	
	akActor.ModFactionRank(OrgasmFaction,-1)
	
	if getOrgasmingCount(akActor) == 0
		akActor.removeFromFaction(OrgasmFaction)
	endif
EndFunction

;will rework later
Function Orgasm(Form fActor,int duration)
	Actor akActor = fActor as Actor
	(libs as zadlibs_UDPatch).ActorOrgasmPatched(akActor,20,75,true)
EndFunction


;///////////////////////////////////////
;=======================================
;ORGASM RESIST MINIGAME
;=======================================
;//////////////////////////////////////;

;=======================================
;ORGASM CRIT FUNCTIONS
;=======================================

bool _PlayerOrgasmResist_MinigameOn = false
Function sendOrgasmResistCritUpdateLoop(Int iChance,Float fDifficulty)
	int handle = ModEvent.Create("UD_CritUpdateLoopStart_OrgasmResist")
	if (handle)
		ModEvent.PushInt(handle,iChance)
		ModEvent.PushFloat(handle,fDifficulty)
        ModEvent.Send(handle)
    endif
EndFunction

Function CritLoopOrgasmResist(Int iChance,Float fDifficulty)
	string loc_meter = "none"
	bool loc_sendCrit = false
	while _PlayerOrgasmResist_MinigameOn
		if Utility.randomInt(1,100) <= iChance
			if !UD_AutoCrit
				if Utility.randomInt(0,1)
					loc_meter = "S"
				else
					loc_meter = "M"
				endif
				loc_sendCrit = true
			else ;auto crits
				if Utility.randomInt() <= UD_AutoCritChance
					OnCritSuccesOrgasmResist()
				else
					OnCritFailureOrgasmResist()
				endif
				return	
			endif
		endif	
		if loc_sendCrit
			crit = True
			selected_crit_meter = loc_meter
			if (loc_meter == "S")
				if UD_CritEffect == 2 || UD_CritEffect == 1
					UDlibs.GreenCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
					Utility.wait(0.3)
				endif
				if UD_CritEffect == 2 || UD_CritEffect == 0
					UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartStaminaBlinking")
				endif
			elseif (loc_meter == "M")
				if UD_CritEffect == 2 || UD_CritEffect == 1
					UDlibs.BlueCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
					Utility.wait(0.3)
				endif
				if UD_CritEffect == 2 || UD_CritEffect == 0
					UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartMagickaBlinking")
				endif
			elseif (loc_meter == "R")
				if UD_CritEffect == 2 || UD_CritEffect == 1
					UDlibs.RedCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
					Utility.wait(0.3)
				endif
			endif
			
			Utility.wait(fDifficulty)
			crit = False
			loc_meter = "none"
			selected_crit_meter = "none"
			loc_sendCrit = false
		endif
		Utility.wait(1.0)
	endwhile
EndFunction

Function OnCritSuccesOrgasmResist()
	if TraceAllowed()	
		Log("OnCritSuccesOrgasmResist() callled!")
	endif
	Game.getPlayer().restoreAV("Stamina", 15)
	UpdateActorOrgasmProgress(Game.getPlayer(),-10,true)
EndFunction

Function OnCritFailureOrgasmResist()
	if TraceAllowed()	
		Log("OnCritFailureOrgasmResist() callled!")
	endif
	;Game.getPlayer().damageAV("Stamina", 25)
	UpdateActorOrgasmProgress(Game.getPlayer(),getActorOrgasmRate(Game.getPlayer())*2,true)
EndFunction

;=======================================
;ORGASM RESIST LOOP
;=======================================

Function FocusOrgasmResistMinigame(Actor akActor)
	if !akActor.isInFaction(OrgasmCheckLoopFaction)
		Print("ERROR: Can't start without orgasm check loop")
	endif
	if UDmain.getCurrentActorValuePerc(akActor,"Stamina") < 0.75; || UDmain.getCurrentActorValuePerc(akActor,"Magicka") < 0.65
		if UDmain.ActorIsPlayer(akActor)
			debug.notification("You are too exhausted!")
		endif
		return
	endif
	if actorInMinigame(akActor) || libs.isAnimating(akActor)
		if akActor == Game.getPlayer()
			Print("You are already bussy!")
		endif
		return
	endif
	
	if !(getActorAfterMultOrgasmRate(akActor) > 0)
		if UDmain.ActorIsPlayer(akActor)
			;
		endif
		return
	endif
	akActor.AddToFaction(MinigameFaction)
	akActor.AddToFaction(OrgasmResistFaction)
	;StorageUtil.SetIntValue(akActor,"UD_OrgasmResisting",1)
	
	float loc_staminaRate 	= akActor.getBaseAV("StaminaRate")
	;float loc_magickaRate 	= akActor.getBaseAV("MagickaRate")
		
	akActor.setAV("StaminaRate", 0.0)
	;akActor.setAV("MagickaRate", 0.0)
	
	DisableActor(akActor,true)
	bool[] loc_cameraState = libs.StartThirdPersonAnimation(akActor, libs.AnimSwitchKeyword(akActor, "Horny01"), permitRestrictive=true)
	Game.EnablePlayerControls(abMovement = true)
	sendHUDUpdateEvent(true,true,true,true)
	
	MinigameKeysRegister()
	
	if UDmain.ActorIsPlayer(akActor)
		_PlayerOrgasmResist_MinigameOn = true
		sendOrgasmResistCritUpdateLoop(15,0.8)
	endif
	
	float loc_baseDrain = 5.0
	float loc_currentOrgasmRate = getActorOrgasmRate(akActor)
	bool loc_cycleON = true
	int loc_tick = 0
	float loc_StaminaRateMult = 1.0
	float loc_orgasmResistence = getActorOrgasmResist(akActor)
	int loc_HightSpiritMode_Duration = -2*Round(1/UDmain.UD_baseUpdateTime)
	int loc_HightSpiritMode_Type = 1
	while loc_cycleON
		if !akActor.isInFaction(OrgasmResistFaction);StorageUtil.GetIntValue(akActor,"UD_OrgasmResistMinigame_EndFlag",0)
			loc_cycleON = false
		endif
		
		if loc_cycleON
			if akActor.getAV("Stamina") <= 0 ;|| akActor.getAV("magicka") <= 0
				loc_cycleON = false
			endif
		endif
		
		if loc_cycleON
			if _specialButtonOn
				if loc_HightSpiritMode_Duration > 0
					if loc_HightSpiritMode_Type == 1
						loc_StaminaRateMult = 0.25
					elseif loc_HightSpiritMode_Type == 2
						loc_StaminaRateMult = 0.75
						UpdateActorOrgasmProgress(akActor,-8.0*(UDmain.UD_baseUpdateTime),true)
					elseif loc_HightSpiritMode_Type == 3
						loc_StaminaRateMult = 0.75
						libs.UpdateExposure(akActor,-2*iRange(Math.Floor(5*UDmain.UD_baseUpdateTime),1,10))
					endif
				else
					loc_StaminaRateMult = 2.0
				endif
			else
				loc_StaminaRateMult = 1.0
			endif
		endif
		
		if loc_tick*UDmain.UD_baseUpdateTime >= 1.0
			loc_currentOrgasmRate 	= getActorOrgasmRate(akActor)
			loc_orgasmResistence	= getActorOrgasmResist(akActor)
			if loc_HightSpiritMode_Duration == 0
				if Utility.randomInt() <= 40 
					loc_HightSpiritMode_Type = Utility.randomInt(1,3)
					if loc_HightSpiritMode_Type == 1 ;RED
						widget2.SetColors(0xff0000, 0xff00d8,0xFF00BC)
					elseif loc_HightSpiritMode_Type == 2 ;GREEN
						widget2.SetColors(0x00ff68, 0x00ff68,0xFF00BC)
					elseif loc_HightSpiritMode_Type == 3 ;BLUE
						widget2.SetColors(0x2e40d8, 0x2e40d8,0xFF00BC)
					endif
					loc_HightSpiritMode_Duration += Utility.randomInt(3,6)*Round(1/UDmain.UD_baseUpdateTime)
				endif
			endif
			loc_tick = 0
		endif
		
		if loc_cycleON
			akActor.damageAV("Stamina", loc_StaminaRateMult*loc_baseDrain*fRange((loc_currentOrgasmRate/loc_orgasmResistence),0.5,3.5)*UDmain.UD_baseUpdateTime)
		endif
		
		if loc_HightSpiritMode_Duration > 0
			loc_HightSpiritMode_Duration -= 1
			if loc_HightSpiritMode_Duration == 0
				widget2.SetColors(0xE727F5, 0xF775FF,0xFF00BC)
				loc_HightSpiritMode_Duration -= Utility.randomInt(3,4)*Round(1/UDmain.UD_baseUpdateTime)
			endif
		elseif loc_HightSpiritMode_Duration < 0
			loc_HightSpiritMode_Duration += 1
		endif
		
		if loc_cycleON
			Utility.wait(UDmain.UD_baseUpdateTime)
			loc_tick += 1
		endif
	endwhile
	
	akActor.setAV("StaminaRate", loc_staminaRate)
	if UDmain.ActorIsPlayer(akActor)
		_PlayerOrgasmResist_MinigameOn = false
	endif
	
	UDlibs.StruggleExhaustionSpell.SetNthEffectMagnitude(0, 40)
	UDlibs.StruggleExhaustionSpell.SetNthEffectDuration(0, 15)
	Utility.wait(0.5)
	UDlibs.StruggleExhaustionSpell.cast(akActor)
	
	libs.EndThirdPersonAnimation(akActor, loc_cameraState, permitRestrictive=true)
	akActor.RemoveFromFaction(MinigameFaction)
	;if !isOrgasming(akActor)
		EnableActor(akActor,true)
	;endif
	MinigameKeysUnregister()
	widget2.SetColors(0xE727F5, 0xF775FF,0xFF00BC)
	;StorageUtil.UnsetIntValue(akActor,"UD_OrgasmResistMinigame_EndFlag")
	;StorageUtil.UnSetIntValue(akActor,"UD_OrgasmResisting")
	akActor.RemoveFromFaction(OrgasmResistFaction)
EndFunction


;=======================================
;ORGASM RESIST LOOP
;=======================================



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

Function createDeviceUpdateThread(string eventName, string strArg, float numArg, Form sender)
	;libs.Aroused.SetActorExposure(UDCD_NPCM.getNPCSlotByActorName(strArg).getActor(),Math.Floor(numArg))
	;UDCD_NPCM.getNPCSlotByActorName(strArg).setArousal(UDmain.round(numArg))
EndFunction

UD_CustomVibratorBase_RenderScript _startVibFunctionPackage = none
bool Function startVibFunction(UD_CustomVibratorBase_RenderScript udCustomVibrator,bool bBlocking = false)
	if !udCustomVibrator
		if TraceAllowed()		
			Log("startVibFunction() - ERROR: Can't turn none plug!!",1)
		endif
		return false
	endif
	if !udCustomVibrator.canVibrate()
		if TraceAllowed()		
			Log("startVibFunction() - " + udCustomVibrator.getDeviceName() + " can't vibrate!",3)
		endif
		return false
	endif
	
	while _startVibFunctionPackage
		Utility.waitMenuMode(0.1)
	endwhile
	_startVibFunctionPackage = udCustomVibrator
	if TraceAllowed()	
		Log("startVibFunction() - Sending " + _startVibFunctionPackage.getDeviceName(),3)
	endif
	int handle = ModEvent.Create("UD_StartVibFunction")
	if (handle)
        ModEvent.Send(handle)
		return true
    else
		if TraceAllowed()		
			Log("startVibFunction() - !!Sending of " + _startVibFunctionPackage.getDeviceName() + " failed!!",1)
		endif
		_startVibFunctionPackage = none
		return false
	endif
	while _startVibFunctionPackage && bBlocking
		Utility.waitMenuMode(0.1) ;wait untill vib starts
	endwhile
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

Function OnNPCEquipFirstUD(actor akActor)


EndFunction

;wrappers
float Function fRange(float fValue,float fMin,float fMax) ;interface for UDmain
	return UDmain.fRange(fValue,fMin,fMax)
EndFunction
int Function iRange(int iValue,int iMin,int iMax) ;interface for UDmain
	return UDmain.iRange(iValue,iMin,iMax)
EndFunction
int Function Round(float fValue)
	return UDmain.Round(fValue)
EndFunction
bool Function ActorIsPlayer(Actor akActor)
	return UDmain.ActorIsPlayer(akActor)
EndFunction
bool Function ActorIsFollower(Actor akActor)
	return UDmain.ActorIsFollower(akActor)
EndFunction
string Function getActorName(Actor akActor)
	return UDmain.getActorName(akActor)
EndFunction

;fixes
;will add update fixes here too
Function OnGameReset()
	(libs as zadlibs_UDPatch).ResetMutex()
	RegisterForSingleUpdate(2*UD_UpdateTime)
	Utility.waitMenuMode(5.0)
	if TraceAllowed()	
		Log("OnGameReset() called!",1)
	endif
	InitMenuArr()
	UDmain.CheckOptionalMods()
	UDmain.Config.LoadConfigPages()
	UDmain.CheckPatchesOrder()
	_activateDevicePackage = none
	_startVibFunctionPackage = none
	registerAllEvents()
	UDPP.RegisterEvents()
	CheckHardcoreDisabler(Game.getPlayer())
EndFunction

Function ApplyTears(Actor akActor)
	if UDmain.ZaZAnimationPackInstalled && UDmain.ZAZBS && UDmain.SlaveTatsInstalled
		if !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZTears_KW)
			SlaveTats.simple_add_tattoo(akActor, "Tears", "Tears 3", 0, true, true)
		endif
	endif
EndFUnction


Function RemoveTears(Actor akActor)
	if UDmain.ZaZAnimationPackInstalled && UDmain.ZAZBS && UDmain.SlaveTatsInstalled
		if !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZTears_KW)
			SlaveTats.simple_Remove_tattoo(akActor, "Tears", "Tears 3", true, true)
		endif
	endif
EndFUnction

Function ApplyDroll(Actor akActor)
	if UDmain.ZaZAnimationPackInstalled && UDmain.ZAZBS && UDmain.SlaveTatsInstalled
		SlaveTats.simple_add_tattoo(akActor, "Drool", "Drool 2", 0, true, true)
	endif
EndFUnction

Function RemoveDroll(Actor akActor)
	if UDmain.ZaZAnimationPackInstalled && UDmain.ZAZBS && UDmain.SlaveTatsInstalled
		SlaveTats.simple_Remove_tattoo(akActor, "Drool", "Drool 2", true, true)
	endif
EndFUnction

bool Function ApplyTearsEffect(Actor akActor)
	if UDmain.ZaZAnimationPackInstalled && UDmain.ZAZBS && UDmain.SlaveTatsInstalled
		if !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZTears_KW)
			UDlibs.ZAZTearsSpell.cast(akActor)
			return true
		endif
	endif
	return false
EndFUnction

bool Function ApplyDroolEffect(Actor akActor) ;works only for player
	if UDmain.ZaZAnimationPackInstalled && UDmain.ZAZBS && UDmain.SlaveTatsInstalled
		if !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZDrool_KW)
			UDlibs.ZAZDroolSpell.cast(akActor)
			return true
		endif
	endif
	return false
EndFUnction

Function ShowMessageBox(string strText)
	String[] loc_lines = StringUtil.split(strText,"\n")
	int loc_linesNum = loc_lines.length
	
	int loc_lineLimit = 12
	
	int loc_boxesNum = Math.Ceiling((loc_linesNum as float)/(loc_lineLimit as float))
	int loc_iterLine = 0
	int loc_iterBox = 0
	
	
	while loc_iterBox < (loc_boxesNum)
		string loc_messagebox = ""
		
		while loc_iterLine < iRange((loc_linesNum - loc_lineLimit*loc_iterBox),0,loc_lineLimit)
			loc_messagebox += (loc_lines[loc_iterLine + (loc_lineLimit)*loc_iterBox] + "\n")
			loc_iterLine += 1
			;/
			if loc_iterLine == (loc_lineLimit - 1); && (iRange((loc_linesNum - loc_lineLimit*(loc_iterBox + 1)),0,loc_lineLimit) > 0)
				loc_linesNum += 1
				loc_boxesNum = Math.Ceiling(loc_linesNum/loc_lineLimit)
				loc_messagebox += "===PAGE " + (loc_iterBox + 1) + "/" + (loc_boxesNum + 1) + "===\n"
				loc_iterLine = iRange((loc_linesNum - loc_lineLimit*loc_iterBox),0,loc_lineLimit)
			endif
			/;
		endwhile
		
		loc_iterBox += 1
		
		;if loc_iterBox == (loc_boxesNum + 1) && (loc_boxesNum > 0) && (loc_linesNum != loc_lineLimit)
		;	loc_messagebox += "===PAGE " + (loc_iterBox) + "/" + (loc_boxesNum + 1) + "===\n"
		;endif
		if loc_boxesNum > 1
			loc_messagebox += "===PAGE " + (loc_iterBox) + "/" + (loc_boxesNum) + "===\n"
		endif
		loc_iterLine = 0
		debug.messagebox(loc_messagebox)
		
		if Game.UsingGamepad()
			Utility.waitMenuMode(0.75)
		endif
	endwhile
EndFunction

Spell Property slaDesireSpell auto

Float Function getArousalSkillMult(Actor akActor)
	int i = 0
	int loc_effects = slaDesireSpell.GetNumEffects()
	
	while i < loc_effects
		if akActor.HasMagicEffect(slaDesireSpell.GetNthEffectMagicEffect(i))
			if i == 0
				return 0.8
			elseif i == 1
				return 0.9
			elseif i == 2
				return 0.95
			elseif i == 3
				return 1.05
			elseif i == 4
				return 0.6
			elseif i == 5
				return 0.2
			endif
		endif
		i += 1
	endwhile
	return 1.0
EndFunction

Function TestExpression(Actor akActor,sslBaseExpression sslExpression,bool bMouth = false,int iTime = 5)
	libs.resetExpression(akActor,none)
	
	if sslExpression
		(libs as zadlibs_UDPatch).ApplyExpressionPatched(akActor,sslExpression,50,bMouth,100)
		;(libs).ApplyExpression(akActor,sslExpression,100,bMouth)
		Print(sslExpression.Name + " applied!")
		Utility.wait(iTime)
		(libs as zadlibs_UDPatch).ResetExpressionPatched(akActor, none,100)
		;libs.resetExpression(akActor,none)
		Print(sslExpression.Name + " removed!")
	endif
EndFunction

Bool Function TraceAllowed()
	return UDmain.TraceAllowed()
EndFunction

bool _debugSwitch = false

Function DebugFunction(Actor akActor)
	;UDmain.UDRRM.LockRandomRestrain(akActor,false,iPrefSwitch = 0xffff)
	;DisableActor(akActor)
	;/
	if !_debugSwitch
		Print("Undetactable ON")
		if UDmain.ConsoleUtilInstalled
			ConsoleUtil.ExecuteCommand("ToggleDetection")
		endif
		_debugSwitch = true
	else
		Print("Undetactable OFF")
		if UDmain.ConsoleUtilInstalled
			ConsoleUtil.ExecuteCommand("ToggleDetection")
		endif
		_debugSwitch = false
	endif
	/;
	;string[] loc_list = new String[5]
	;loc_list[0] = "1"
	;loc_list[1] = "2"
	;loc_list[2] = "3"
	;loc_list[3] = "dggd"
	;loc_list[4] = "8"
	;int loc_res = GetUserListInput(loc_list)
	;Print(loc_res)
	
	UDlibs.GreenCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
	Utility.wait(1.5)
	UDlibs.BlueCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
	Utility.wait(1.5)
	UDlibs.RedCrit.RemoteCast(Game.GetPlayer(),Game.GetPlayer(),Game.GetPlayer())
	ApplyTearsEffect(akActor)
	ApplyDroolEffect(akActor)
	UDmain.UDRRM.LockAllSuitableRestrains(akActor,false,0x43ff)
	UDmain.UDRRM.LockAllSuitableRestrains(akActor,false,0x3C00)
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