Scriptname UDCustomDeviceMain extends Quest  conditional

import UnforgivingDevicesMain
import UD_NPCInteligence

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
;UD_OrgasmManager Property UDOM auto 
UD_UserInputScript Property UDUI hidden
    UD_UserInputScript Function get()
        return UDmain.UDUI
    EndFunction
EndProperty
UD_AnimationManagerScript Property UDAM hidden
    UD_AnimationManagerScript Function get()
        return UDmain.UDAM
    EndFunction
EndProperty
Package Property NPCDisablePackage Hidden
    Package Function Get()
        return libs.SexLab.Config.DoNothing
    EndFunction
EndProperty


bool Property UD_HardcoreMode = true auto hidden

;keys
Int Property Stamina_meter_Keycode      = 32        auto hidden
int property StruggleKey_Keycode        = 52        auto hidden
Int Property Magicka_meter_Keycode      = 30        auto hidden
Int Property SpecialKey_Keycode         = 31        auto hidden
Int Property PlayerMenu_KeyCode         = 40        auto hidden
int property ActionKey_Keycode          = 18        auto hidden
int Property NPCMenu_Keycode            = 39        auto hidden

bool Property UD_UseDDdifficulty        = True      auto hidden
bool Property UD_UseWidget              = True      auto hidden

int Property UD_GagPhonemModifier       = 50        auto hidden

int OSLLoadOrderRelative = 0
int SLALoadOrder = 0
perk[] DesirePerks

Int     Property UD_StruggleDifficulty              = 1         auto hidden
float   Property UD_BaseDeviceSkillIncrease         = 35.0      auto hidden
float   Property UD_CooldownMultiplier              = 1.0       auto hidden
Bool    Property UD_AutoCrit                        = False     auto hidden
Int     Property UD_AutoCritChance                  = 80        auto hidden
Int     Property UD_MinigameHelpCd                  = 60        auto hidden
Float   Property UD_MinigameHelpCD_PerLVL           = 10.0      auto hidden ;CD % decrease per Helper LVL
Int     Property UD_MinigameHelpXPBase              = 35        auto hidden
Float   Property UD_MutexTimeOutTime                = 1.0       auto hidden
bool    Property UD_AllowArmTie                     = true      auto hidden
bool    Property UD_AllowLegTie                     = true      auto hidden
Int     Property UD_BlackGooRareDeviceChance        = 10        auto hidden
Bool    Property UD_PreventMasterLock               = False     auto hidden
Int     Property UD_KeyDurability                   = 5         auto hidden ;how many times can be key used before it gets destroyed
Bool    Property UD_HardcoreAccess                  = False     auto hidden ;if true, device accessibility can be only either 0 or 1. If number is less then 0.90, it will be 0

;Lvl scalling
Float   Property UD_DeviceLvlHealth                 = 0.025     auto hidden
Float   Property UD_DeviceLvlLockpick               = 0.5       auto hidden
Int     Property UD_DeviceLvlLocks                  = 5         auto hidden
;changes how much is strength converted to orgasm rate, 
;example: if UD_VibrationMultiplier = 0.1 and vibration strength will be 100, orgasm rate will be 100*0.1 = 10 O/s 
float     Property UD_VibrationMultiplier           = 0.10    auto hidden
float     Property UD_ArousalMultiplier             = 0.05    auto hidden

Bool      Property UD_OutfitRemove                  = True    auto hidden
UD_PlayerSlotScript Property UD_PlayerSlot auto

;factions
Faction     Property zadGagPanelFaction     Auto
Faction     Property FollowerFaction        auto
Faction     Property RegisteredNPCFaction   auto
Faction     Property MinigameFaction        auto
Faction     Property PlayerFaction          auto

Faction     Property BlockExpressionFaction auto
Faction     Property BlockAnimationFaction  auto
Faction     Property BussyFaction           auto

Faction     Property VibrationFaction       auto

FormList    Property UD_AgilityPerks        auto
FormList    Property UD_StrengthPerks       auto
FormList    Property UD_MagickPerks         auto

MiscObject Property zad_GagPanelPlug        Auto

float       Property UD_StruggleExhaustionMagnitude     = 60.0      auto hidden;magnitude of exhaustion, 50.0 will reduce player stats regen modifier by 50%. This cant make regen negative
int         Property UD_StruggleExhaustionDuration      = 10        auto hidden;How long will debuff last

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
MiscObject     Property Lockpick auto
Int            Property UD_LockpicksPerMinigame = 2 auto hidden

Formlist Property UD_QuestKeywords auto
FormList Property UD_HeavyBondageKeywords auto
;Spell Property TelekinesisSpell auto

UD_WidgetBase Property widget1 auto
UD_WidgetBase Property widget2 auto

Bool Property UD_EquipMutex = False auto hidden
Bool Property Ready = False auto hidden
Bool Property EventsReady = false auto hidden

Event OnInit()
    While !UDPatcher.ready
        Utility.WaitMenuMode(0.1)
    EndWhile
    if UDmain.TraceAllowed()    
        Log("UDPatcher ready!",0)    
    endif
    While !UDCD_NPCM.ready
        Utility.WaitMenuMode(0.1)
    EndWhile
    if UDmain.TraceAllowed()    
        Log("UDCD_NPCM ready!",0)
    endif
    While !UDEM.ready
        Utility.WaitMenuMode(0.1)
    endwhile
    if UDmain.TraceAllowed()    
        Log("UDEM ready!",0)
    endif

    registerEvents()
    
    registerForSingleUpdate(5.0)
    RegisterForSingleUpdateGameTime(1.0)
    if UDmain.TraceAllowed()    
        Log("UDCustomDeviceMain ready!",0)
    endif
    ready = True
EndEvent

bool Property ZAZAnimationsInstalled = false auto hidden
Function Update()

    RegisterForSingleUpdate(2*UD_UpdateTime)
    
    _activateDevicePackage = none
    _startVibFunctionPackage = none
    
    ResetUI()
    registerAllEvents()
    
    UDPP.RegisterEvents()
    
    CheckHardcoreDisabler(UDmain.Player)
    
    SetArousalPerks()

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
        GInfo("MCM Config loaded!")
    endif
EndFunction

;dedicated switches to hide options from menu
bool Property currentDeviceMenu_allowStruggling         = false auto conditional hidden

bool Property currentDeviceMenu_allowUselessStruggling  = false auto conditional hidden
bool Property currentDeviceMenu_allowLockpick           = false auto conditional hidden
bool Property currentDeviceMenu_allowKey                = false auto conditional hidden
bool Property currentDeviceMenu_allowCutting            = false auto conditional hidden
bool Property currentDeviceMenu_allowLockRepair         = false auto conditional hidden
bool Property currentDeviceMenu_allowTighten            = false auto conditional hidden
bool Property currentDeviceMenu_allowRepair             = false auto conditional hidden

;switches for special menu, allows only six buttons
bool Property currentDeviceMenu_switch1                 = false auto conditional hidden
bool Property currentDeviceMenu_switch2                 = false auto conditional hidden
bool Property currentDeviceMenu_switch3                 = false auto conditional hidden
bool Property currentDeviceMenu_switch4                 = false auto conditional hidden
bool Property currentDeviceMenu_switch5                 = false auto conditional hidden
bool Property currentDeviceMenu_switch6                 = false auto conditional hidden

bool Property currentDeviceMenu_allowCommand            = false auto conditional hidden
bool Property currentDeviceMenu_allowDetails            = false auto conditional hidden
bool Property currentDeviceMenu_allowLockMenu           = false auto conditional hidden
bool Property currentDeviceMenu_allowSpecialMenu        = false auto conditional hidden
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

Function DisableActor(Actor akActor,int aiIsPlayer = -1)
    if UDmain.TraceAllowed()    
        Log("DisableActor("+getActorName(akActor) + ")",2)
    endif
    StartMinigameDisable(akActor,aiIsPlayer)
EndFunction

Function UpdateDisabledActor(Actor akActor,int aiIsPlayer = -1)
    if UDmain.TraceAllowed()    
        Log("UpdateDisabledActor("+getActorName(akActor) + ")",2)
    endif
    UpdateMinigameDisable(akActor,aiIsPlayer)
EndFunction

Function EnableActor(Actor akActor,int aiIsPlayer = -1)
    if UDmain.TraceAllowed()    
        Log("EnableActor("+getActorName(akActor)+")",2)
    endif
    EndMinigameDisable(akActor,aiIsPlayer)
EndFunction

Function StartMinigameDisable(Actor akActor,Int aiIsPlayer = -1)
    akActor.AddToFaction(BussyFaction)
    if aiIsPlayer == 1 || UDmain.ActorIsPlayer(akActor)
        UpdatePlayerControl()
        Game.SetPlayerAiDriven(True)
    else
        ActorUtil.AddPackageOverride(akActor, UDmain.UD_NPCDisablePackage, 100, 1)
        akActor.EvaluatePackage()
        akActor.SetDontMove(True)
        akActor.SheatheWeapon()
    endif
EndFunction

Function UpdateMinigameDisable(Actor akActor,Int aiIsPlayer = -1)
    if akActor.IsInFaction(BussyFaction)
        if aiIsPlayer == 1 || UDmain.ActorIsPlayer(akActor)
            UpdatePlayerControl()
            Game.SetPlayerAiDriven(True)
        else
            akActor.SetDontMove(True)
            akActor.EvaluatePackage()
        endif
    endif
EndFunction

Function EndMinigameDisable(Actor akActor,Int aiIsPlayer = -1)
    akActor.RemoveFromFaction(BussyFaction)
    if aiIsPlayer == 1 || UDmain.ActorIsPlayer(akActor)
        libsp.ProcessPlayerControls(false)
        Game.SetPlayerAiDriven(False)
    else
        ActorUtil.RemovePackageOverride(akActor, UDmain.UD_NPCDisablePackage)
        akActor.EvaluatePackage()
        akActor.SetDontMove(False)
    endif
EndFunction

;returns true if actor is bussy (disabled)
Bool Function IsBussy(Actor akActor)
    return akActor.IsInFaction(BussyFaction)
EndFunction

Function UpdatePlayerControl()
    Game.EnablePlayerControls(abMovement = true, abFighting = false, abSneaking = false, abMenu = False, abActivate = false)
    Utility.waitMenuMode(0.05)
    Game.DisablePlayerControls(abMovement = False, abMenu = True)
EndFunction

bool Function InZadAnimation(Actor akActor)
    return akActor.IsInFaction(libs.zadAnimatingFaction)
EndFunction

Function CheckHardcoreDisabler(Actor akActor)
    if UD_HardcoreMode
        if !UDmain.Player.HasSpell(UDlibs.HardcoreDisableSpell) && UDmain.Player.HasMagicEffectWithKeyword(UDlibs.HardcoreDisable_KW) 
            UDmain.Player.DispelSpell(UDlibs.HardcoreDisableSpell)
        endif
        if UDmain.Player.wornhaskeyword(libs.zad_deviousHeavyBondage) && !UDmain.Player.HasSpell(UDlibs.HardcoreDisableSpell)
            bool loc_applyeffect = false
            if UDmain.Player.wornhaskeyword(UDlibs.InvisibleHBKW)
                loc_applyeffect = true ;player have invisible heavy bondage (from cuffs)
            else
                ;only apply if heavy bondage device is UD
                UD_CustomDevice_RenderScript loc_hbdevice = GetHeavyBondageDevice(UDmain.Player)
                if loc_hbdevice
                    loc_applyeffect = true
                endif
            endif
            if loc_applyeffect
                UDmain.Player.AddSpell(UDlibs.HardcoreDisableSpell,false)
            endif
        endif
    endif
EndFunction

bool Function actorInMinigame(Actor akActor)
    if !akActor
        return false
    endif
    return akActor.IsInFaction(MinigameFaction)
EndFunction

bool Function PlayerInMinigame()
    return UDmain.Player.IsInFaction(MinigameFaction)
EndFunction

;stops current device minigiame. Takes up to 1s second
Function StopMinigame(Actor akActor, Bool abWaitForStop)
    if !akActor
        return
    endif
    
    UD_CustomDevice_RenderScript loc_device = GetMinigameDevice(akActor)
    if loc_device
        loc_device.StopMinigame(abWaitForStop)
    endif
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
    akTarget.ShowGiftMenu(True, UDlibs.GiftMenuFilter,True,False)
EndFunction


Function openPlayerHelpMenu(Actor akHelper)
    GiftMenuMode = 2
    akHelper.ShowGiftMenu(True, UDlibs.GiftMenuFilter,True,False)
EndFunction


Function openNPCHelpMenu(Actor akTarget)
    GiftMenuMode = 3
    akTarget.ShowGiftMenu(False, UDlibs.GiftMenuFilter,True,False)
EndFunction

UD_CustomDevice_RenderScript Property CurrentPlayerMinigameDevice     = none auto hidden

Function setCurrentMinigameDevice(UD_CustomDevice_RenderScript oref)
    CurrentPlayerMinigameDevice = oref
EndFunction

Function resetCurrentMinigameDevice()
    CurrentPlayerMinigameDevice = none
EndFunction

int Function getNumberOfRegisteredDevices(Actor akActor)
    return getNPCSlot(akActor).getNumberOfRegisteredDevices()
EndFunction

;returns number of devices that can be activated
bool Function isRegistered(Actor akActor)
    if akActor == UDmain.Player
        return true
    endif
    return akActor.isInFaction(RegisteredNPCFaction);UDCD_NPCM.isRegistered(akActor)
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlot(Actor akActor)
    if akActor == UDmain.Player
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
    libsp.LockDevicePatched(fActor as Actor,fDeviceInventory as Armor,iForce as Bool)
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

Function startScript(UD_CustomDevice_RenderScript oref)
    if UDmain.TraceAllowed()    
        Log("UDCustomDeviceMain startScript() called for " + oref.getDeviceHeader(),1)
    endif
    if oref.WearerIsPlayer()
        registerDevice(oref)
    elseif isRegistered(oref.getWearer())
        registerDevice(oref)
    endif
EndFunction

Function endScript(UD_CustomDevice_RenderScript oref)
    if UDmain.TraceAllowed()    
        Log("UDCustomDeviceMain endScript() called for " + oref.DeviceInventory.getName(),1)
    endif
    updateLastOpenedDeviceOnRemove(oref)
    if isRegistered(oref.getWearer())
        unregisterDevice(oref)
    endif
EndFunction

Function RegisterGlobalKeys()
    UDUI.RegisterGlobalKeys()
EndFunction

Function UnregisterGlobalKeys()
    UDUI.UnregisterGlobalKeys()
EndFunction

Function registerAllEvents()
    if UDmain.TraceAllowed()
        Log("registerAllEvents")
    endif
    registerEvents()
    RegisterGlobalKeys()
EndFunction

Function registerEvents()
    if UDmain.TraceAllowed()
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

bool Function AllowNPCMessage(Actor akActor,Bool abOnlyFollower = false)
    if ActorIsFollower(akActor) || UDmain.ActorIsPlayer(akActor)
        return true
    endif
    if !abOnlyFollower
        return UDmain.ActorInCloseRange(akActor)
    else
        return false
    endif
EndFunction

;///////////////////////////////////////
;=======================================
;            UPDATE FUNCTION
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
            UDmain.Player.addItem(UDlibs.AbadonPlug,1)
        endif
        loc_init = true
    endif
EndEvent

State Minigame
EndState

;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------


Event keyUnregister(string eventName = "none", string strArg = "", float numArg = 0.0, Form sender = none)
    ResetUI()
EndEvent

Event ResetUI()
    UnregisterForAllKeys()
    UDUI.keyUnregister()
EndEvent

Event MinigameKeysRegister()
    UDUI.MinigameKeysRegister()
    UDUI.GoToState("Minigame")
EndEvent

Event MinigameKeysUnregister()
    UDUI.GoToState("")
    UDUI.MinigameKeysUnregister()
EndEvent

bool Function KeyIsUsedGlobaly(int keyCode)
    return UDUI.KeyIsUsedGlobaly(keyCode)
EndFunction

bool    Property crit                   = false         auto hidden
string  Property selected_crit_meter    =  "Error"      auto hidden
Int     Property UD_CritEffect          = 2             auto hidden
Bool    Property UD_MandatoryCrit       = False         auto hidden
Float   Property UD_CritDurationAdjust  = 0.0           auto hidden

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
                float randomResponceTime = Utility.randomFloat(0.4,0.95) ;random reaction time
                if randomResponceTime <= difficulty
                    device.critDevice() ;succes
                else
                    device.critFailure() ;failure
                endif
            endif
            return 
        endif
        
        selected_crit_meter = meter
        crit = True
        
        if (selected_crit_meter == "S")
            if UD_CritEffect == 2 || UD_CritEffect == 1
                UDlibs.GreenCrit.RemoteCast(UDmain.Player,UDmain.Player,UDmain.Player)
            endif
            if UD_CritEffect == 2 || UD_CritEffect == 0
                UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartStaminaBlinking")
            endif
        elseif (selected_crit_meter == "M")
            if UD_CritEffect == 2 || UD_CritEffect == 1
                UDlibs.BlueCrit.RemoteCast(UDmain.Player,UDmain.Player,UDmain.Player)
            endif
            if UD_CritEffect == 2 || UD_CritEffect == 0
                UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StartMagickaBlinking")
            endif
        elseif (selected_crit_meter == "R")
            if UD_CritEffect == 2 || UD_CritEffect == 1
                UDlibs.RedCrit.RemoteCast(UDmain.Player,UDmain.Player,UDmain.Player)
            endif
        endif

        Utility.wait(fRange(difficulty + UD_CritDurationAdjust,0.25,2.0))

        if UD_MandatoryCrit
            if crit
                crit = False
                device.CritFailure()
            endif
        endif
        crit = False
    endif
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
    if UDUI.lastOpenedDevice == removed_device
        UDUI.lastOpenedDevice = none
    endif
EndFunction

Function setLastOpenedDevice(UD_CustomDevice_RenderScript device)
    UDUI.lastOpenedDevice = device
EndFunction

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

Bool Property UD_CurrentNPCMenuIsFollower           = False auto conditional hidden
Bool Property UD_CurrentNPCMenuIsRegistered         = False auto conditional hidden
Bool Property UD_CurrentNPCMenuIsPersistent         = False auto conditional hidden
Bool Property UD_CurrentNPCMenuTargetIsHelpless     = False auto conditional hidden
Bool Property UD_CurrentNPCMenuTargetIsInMinigame   = False auto conditional hidden
Function NPCMenu(Actor akActor)
    SetMessageAlias(akActor)
    UD_CurrentNPCMenuIsFollower         = ActorIsFollower(akActor)
    UD_CurrentNPCMenuIsRegistered       = isRegistered(akActor)
    UD_CurrentNPCMenuTargetIsHelpless   = UDmain.ActorIsHelpless(akActor) && UDmain.ActorFreeHands(UDmain.Player)
    UD_CurrentNPCMenuTargetIsInMinigame = ActorInMinigame(akActor)
    UD_CurrentNPCMenuIsPersistent       = StorageUtil.GetIntValue(akActor, "UD_ManualRegister", 0)

    int loc_res = NPCDebugMenuMsg.show()
    if loc_res == 0
        UDCD_NPCM.RegisterNPC(akActor,true)
    elseif loc_res == 1
        UDCD_NPCM.UnregisterNPC(akActor,true)
    elseif loc_res == 2
        StorageUtil.SetIntValue(akActor, "UD_ManualRegister", 1)
    elseif loc_res == 3
        StorageUtil.SetIntValue(akActor, "UD_ManualRegister", 0)
    elseif loc_res == 4 ;Acces devices
        HelpNPC(akActor,UDmain.Player,ActorIsFollower(akActor))
    elseif loc_res == 5 ; get help
        HelpNPC(UDmain.Player,akActor,false)
    elseif loc_res == 6
        UndressArmor(akActor)
        akActor.UpdateWeight(0)
    elseif loc_res == 10
        DebugFunction(akActor)
    elseif loc_res == 7
        akActor.openInventory(True)
    elseif loc_res == 11
        if !StorageUtil.GetIntValue(akActor,"UDNPCMenu_SetDontMove",0)
            StorageUtil.SetIntValue(akActor,"UDNPCMenu_SetDontMove",1)
            akActor.setDontMove(true)
        else
            StorageUtil.UnSetIntValue(akActor,"UDNPCMenu_SetDontMove")
            akActor.setDontMove(false)
        endif
    elseif loc_res == 8
        showActorDetails(akActor)
    elseif loc_res == 9
        getMinigameDevice(akActor).StopMinigame()
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
        bool loc_cond = true
        if !bIgnoreCooldown
            float loc_currenttime = Utility.GetCurrentGameTime()
            float loc_cooldowntime = StorageUtil.GetFloatValue(akHelper,"UDNPCCD:"+device.getWearer(),loc_currenttime)
            if loc_cooldowntime > loc_currenttime
                Print("On cooldown! (" + ToUnsig(Round(((loc_cooldowntime - loc_currenttime)*24*60)))+" min)",0)
                loc_cond = false
            endif
        endif
        
        if UDmain.GetUDOM(device.getWearer()).GetOrgasmingCount(device.getWearer()) ||  UDmain.GetUDOM(akHelper).GetOrgasmingCount(akHelper) ;actor is orgasming, prevent help
            loc_cond = false
            bAllowCommand = false
        endif

        bool[] loc_arrcontrol; = new bool[30]
        if !loc_cond 
            loc_arrcontrol = Utility.CreateBoolArray(30,True)
            loc_arrcontrol[15] = false
            loc_arrcontrol[16] = false
        else
            loc_arrcontrol = new bool[30]
            ;tying and repairing doesn't sound like helping
            ;allow for now, will have to add some switch later which will determinate if player can be dick to NPC or not
            ;loc_arrcontrol[06] = true
            ;loc_arrcontrol[07] = true
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
    loc_res = fRange(loc_res,5.0,60.0*24.0) ;crop the value
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

Int Function CalculateHelperXpRequired(Int aiLevel)
    return Round(aiLevel*100*Math.Pow(1.03,aiLevel))
EndFunction

;returns updated lvl
int Function addHelperXP(Actor akHelper, int iXP)
    int loc_currentXP   = StorageUtil.GetIntValue(akHelper,"UDNPCXP",0)
    int loc_currentLVL  = GetHelperLVL(akHelper)
    int loc_nextXP      = loc_currentXP + iXP
    int loc_nextLVL     = loc_currentLVL
    while loc_nextXP >= CalculateHelperXpRequired(loc_nextLVL)
        loc_nextXP      -= CalculateHelperXpRequired(loc_nextLVL)
        loc_nextLVL     += 1
        if UDmain.ActorIsPlayer(akHelper)
            UDmain.Print("Your Helper skill level increased to " + loc_nextLVL + " !")
        elseif ActorIsFollower(akHelper)
            UDmain.Print(GetActorName(akHelper) + "'s helper level have increased to " + loc_nextLVL + " !")
        endif
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
    Float loc_currentXP = StorageUtil.GetIntValue(akHelper,"UDNPCXP",0)
    int loc_currentLVL = StorageUtil.GetIntValue(akHelper,"UDNPCLVL",1)
    return loc_currentXP/CalculateHelperXpRequired(loc_currentLVL);(100.0*(loc_currentLVL))
EndFunction

Function PlayerMenu()
    int loc_playerMenuRes = PlayerMenuMsg.show()
    if loc_playerMenuRes == 0
        UDmain.UDOMPlayer.FocusOrgasmResistMinigame(UDmain.Player)
    elseif loc_playerMenuRes == 1
        UndressArmor(UDmain.Player)
    elseif loc_playerMenuRes == 2
        showActorDetails(UDmain.Player)
    elseif loc_playerMenuRes == 3
        DebugFunction(UDmain.Player)
    else
        return
    endif
EndFunction

Function UndressArmor(Actor akActor)
    while True
        Form[] loc_armors
        String[] loc_armorsnames
        int loc_mask = 0x00000001
        while loc_mask != 0x80000000
            Armor loc_armor = akActor.GetWornForm(loc_mask) as Armor
            if loc_armor && loc_armor.GetName()
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
        loc_armorsnames = PapyrusUtil.PushString(loc_armorsnames,"--TOGGLE OUTFIT--")
        loc_armorsnames = PapyrusUtil.PushString(loc_armorsnames,"--BACK--")
        int loc_res = GetUserListInput(loc_armorsnames)
        if loc_res == (loc_armorsnames.length - 3)
            libs.strip(akActor,false)
        elseif loc_res == (loc_armorsnames.length - 2)
            if !UDmain.ActorIsFollower(akActor) && !UDmain.ActorIsPlayer(akActor)
                Outfit originalOutfit = akActor.GetActorBase().GetOutfit()
                If originalOutfit == libs.zadEmptyOutfit
                    DressOutfit(akActor)
                else
                    UndressOutfit(akActor)
                endif
            else
                GInfo("TOGGLE OUTFIT can't be used for player or follower!")
            endif
        elseif loc_res < (loc_armorsnames.length - 3) && loc_res >= 0
            akActor.unequipItem(loc_armors[loc_res], abSilent = true)
        else
            return ;exit undress menu
        endif
        loc_armors = Utility.CreateFormArray(0)
        loc_armorsnames = Utility.CreateStringArray(0)
        Utility.wait(0.05)
    endwhile
EndFunction

;default undress mask, all slots with 0 will be skipped
;By default, amulet and ring is excluded
Int Property UD_UndressMask = 0xFFFFFF9F auto

;Unequp all armors that are no DD, unnamed or with sexlab keyword
Function UndressAllArmor(Actor akActor)
    Form[] loc_armors = Utility.CreateFormArray(0)
    int loc_mask = 0x00000001
    while loc_mask != 0x80000000
        if Math.LogicalAnd(UD_UndressMask,loc_mask)
            Form loc_armor = akActor.GetWornForm(loc_mask)
            if loc_armor
                if loc_armor.GetName() && !loc_armor.haskeyword(libs.zad_Lockable) && !loc_armor.HasKeyWordString("SexLabNoStrip")
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
    Weapon  loc_weap1   = akActor.GetEquippedWeapon(abLeftHand = false)
    Weapon  loc_weap2   = akActor.GetEquippedWeapon(abLeftHand = True)
    Armor   loc_shield  = akActor.GetEquippedShield()
    if loc_weap1
        akActor.unequipItem(loc_weap1, abSilent = true)
    endif
    if loc_weap2
        akActor.unequipItem(loc_weap2, abSilent = true)
    endif
    if loc_shield
        akActor.unequipItem(loc_shield, abSilent = true)
    endif
EndFunction

;this function replace NPC outfit. Should only be used for non-follower actors. Might cause issues with NPC overhaul mods
; If NPC is using armor which it have in inventory, this function will remove it when changing outfit
Function UndressOutfit(Actor akActor)
    if !UDmain.ActorIsPlayer(akActor)
        ; We change the outfit only for unique actors because SetOutfit() seems to operate on the ActorBASE and not the actor, so changing a non-unique actors's gear would change it for ALL instances of this actor.
        Outfit originalOutfit = akActor.GetActorBase().GetOutfit()
        If originalOutfit != libs.zadEmptyOutfit
            StorageUtil.SetFormValue(akActor.GetActorBase(), "zad_OriginalOutfit", originalOutfit)
            akActor.SetOutfit(libs.zadEmptyOutfit, false)
        EndIf
    endIf
EndFunction

;undo UndressOutfit()
Function DressOutfit(Actor akActor)
    if !UDmain.ActorIsPlayer(akActor)
        ; We change the outfit only for unique actors because SetOutfit() seems to operate on the ActorBASE and not the actor, so changing a non-unique actors's gear would change it for ALL instances of this actor.
        Outfit originalOutfit = akActor.GetActorBase().GetOutfit()
        If originalOutfit == libs.zadEmptyOutfit
            Outfit loc_oldOutfit = StorageUtil.GetFormValue(akActor.GetActorBase(), "zad_OriginalOutfit", none) as OutFit
            if loc_oldOutfit
                akActor.SetOutfit(loc_oldOutfit, false)
            else
                UDmain.Error("DressOutfit("+GetActorName(akActor)+")No saved default outfit for found!")
            endif
        EndIf
    endIf
EndFunction

;function made as replacemant for akActor.isEquipped, because that function doesn't work for NPCs
bool Function CheckRenderDeviceEquipped(Actor akActor, Armor rendDevice)
    if !akActor
        return false
    endif
    if UDmain.ActorIsPlayer(akActor)
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

;returns conflicting device, should be only used after equipitem function fails
Armor Function GetConflictDevice(Actor akActor, Armor rendDevice)
    if !akActor
        return none
    endif
    int loc_mask = 0x00000001
    int loc_devicemask = rendDevice.GetSlotMask()
    while loc_mask < 0x80000000
        if loc_mask > loc_devicemask
            return none
        endif
        if Math.LogicalAnd(loc_mask,loc_devicemask)
            Armor loc_armor = akActor.GetWornForm(loc_mask) as Armor
            if loc_armor ;check if there is anything in slot
                if loc_armor == rendDevice
                    return none ;render device is equipped
                else
                    return loc_armor ;;render device is unequipped
                endif
            endif
        endif
        loc_mask = Math.LeftShift(loc_mask,1)
    endwhile
    return none ;device is not equipped
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

Message Property UD_ActorDetailsOptions auto

Function showActorDetails(Actor akActor)
    while True
        Int loc_option = UD_ActorDetailsOptions.Show()
        if !UDmain.IsContainerMenuOpen() && !UDmain.IsInventoryMenuOpen()
            Utility.wait(0.01)
        endif
        UD_OrgasmManager _UDOM = UDmain.GetUDOM(akActor)
        if loc_option == 0 ;base details
            String loc_res = "--BASE DETAILS--\n"
            loc_res += "Name: " + akActor.GetLeveledActorBase().GetName() + "\n"
            Race loc_race = akActor.getActorBase().GetRace()
            loc_res += "Race: " + loc_race.GetName() + "\n"
            loc_res += "LVL: " + akActor.GetLevel() + "\n"
            loc_res += "HP: " + formatString(akActor.getAV("Health"),1) + "/" +  formatString(getMaxActorValue(akActor,"Health"),1) + " ("+ Round(getCurrentActorValuePerc(akActor,"Health")*100) +" %)" +"\n"
            loc_res += "MP: " + formatString(akActor.getAV("Magicka"),1) + "/" + formatString(getMaxActorValue(akActor,"Magicka"),1) + " ( "+ Round(getCurrentActorValuePerc(akActor,"Magicka")*100) +" %)" +"\n"
            loc_res += "SP: " + formatString(akActor.getAV("Stamina"),1) + "/" +  formatString(getMaxActorValue(akActor,"Stamina"),1) + " ("+ Round(getCurrentActorValuePerc(akActor,"Stamina")*100) +" %)" +"\n"
            if UDmain.UDAI.Enabled && !UDmain.ActorIsPlayer(akActor)
                loc_res += "Motivation: " + getMotivation(akActor) + "\n"
                loc_res += "AI Cooldown: " + iUnsig(GetAIRemainingCooldown(akActor)) + " min\n"
            endif
            loc_res += "Arousal: " + _UDOM.getArousal(akActor) + "\n"
            loc_res += "Orgasm progress: " + formatString(_UDOM.getOrgasmProgressPerc(akActor) * 100,2) + " %\n"
            UDmain.ShowMessageBox(loc_res)
        elseif loc_option == 1 ;skills
            String loc_res = "--SKILL DETAILS--\n"
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
            UDmain.ShowMessageBox(loc_res)
        elseif loc_option == 2 ;arousal/orgasm details
            string loc_orgStr = ""
            loc_orgStr += "--ORGASM DETAILS--\n"
            loc_orgStr += "State: " + _UDOM.GetHornyLevelString(akActor) + "\n"
            loc_orgStr += "Horny progress: " + Round(_UDOM.GetRelativeHornyProgress(akActor)*100.0) + " %\n"
            loc_orgStr += "Active vibrators: " + GetActivatedVibrators(akActor) + "(S="+StorageUtil.GetIntValue(akActor,"UD_ActiveVib_Strength",0)+")" + "\n"
            loc_orgStr += "Arousal: " + _UDOM.getArousal(akActor) + "\n"
            loc_orgStr += "Arousal Rate(M): " + Math.Ceiling(_UDOM.getArousalRateM(akActor)) + "\n"
            loc_orgStr += "Arousal Rate Mult: " + Round(_UDOM.getArousalRateMultiplier(akActor)*100) + " %\n"
            loc_orgStr += "Orgasm capacity: " + Round(_UDOM.getActorOrgasmCapacity(akActor)) + "\n"
            loc_orgStr += "Orgasm resistance(M): " + FormatString(_UDOM.getActorOrgasmResistM(akActor),1) + "\n"
            loc_orgStr += "Orgasm progress: " + formatString(_UDOM.getOrgasmProgressPerc(akActor) * 100,2) + " %\n"
            loc_orgStr += "Orgasm rate: " + formatString(_UDOM.getActorAfterMultOrgasmRate(akActor),2) + " - " + formatString(_UDOM.getActorAfterMultAntiOrgasmRate(akActor),2) + " Op/s\n"
            loc_orgStr += "Orgasm mult: " + Round(_UDOM.getActorOrgasmRateMultiplier(akActor)*100.0) + " %\n"
            loc_orgStr += "Orgasm resisting: " + Round(_UDOM.getActorOrgasmResistMultiplier(akActor)*100.0) + " %\n"
            if isRegistered(akActor)
                loc_orgStr += "Orgasm exhaustion: " + _UDOM.GetOrgasmExhaustion(akActor) + "\n"
                if !UDmain.ActorIsPlayer(akActor)
                    UD_CustomDevice_NPCSlot loc_slot = GetNPCSlot(akActor)
                    if loc_slot
                        loc_orgStr += "Orgasm exhaustion dur.: " + loc_slot.GetOrgasmExhaustionDuration() + " s\n"
                    endif
                endif
            endif
            UDmain.ShowMessageBox(loc_orgStr)
        elseif loc_option == 3 ;Helper details
            ShowHelperDetails(akActor)
        elseif loc_option == 4 ;other details
            Weapon loc_sharpestWeapon = getSharpestWeapon(akActor)
            string loc_otherStr = "--OTHER--\n"
            if loc_sharpestWeapon
                loc_otherStr += "Sharpest weapon: " + loc_sharpestWeapon.getName() + "\n"
                loc_otherStr += "Cutting multiplier: " + FormatString(loc_sharpestWeapon.getBaseDamage()*2.5,1) + " %\n"
            else
                loc_otherStr += "Sharpest weapon: NONE\n"
                loc_otherStr += "Cutting multiplier: 0 %\n"
            endif
            UDmain.ShowMessageBox(loc_otherStr)
        else
            return
        endif
        if !UDmain.IsContainerMenuOpen() && !UDmain.IsInventoryMenuOpen()
            Utility.wait(0.01)
        endif
    endwhile
EndFunction

Function ShowHelperDetails(Actor akActor)
    UDmain.ShowMessageBox(GetHelperDetails(akActor))
EndFunction

string Function GetHelperDetails(Actor akActor)
    string loc_res = ""
    loc_res += "--HELPER DETAILS--\n"
    loc_res += "Helper LVL: " + GetHelperLVL(akActor) +"("+Round(GetHelperLVLProgress(akActor)*100)+"%)" + "\n"
    loc_res += "Base Cooldown: " + Round(CalculateHelperCD(akActor)*24*60) + " min\n"
    float loc_currenttime = Utility.GetCurrentGameTime()
    float loc_cooldowntimeHP = StorageUtil.GetFloatValue(akActor,"UDNPCCD:"+UDmain.Player,0)
    float loc_cooldowntimePH = StorageUtil.GetFloatValue(UDmain.Player,"UDNPCCD:"+akActor,0)
    loc_res += "Available in (H->P): " + iUnsig(Round(((loc_cooldowntimeHP - loc_currenttime)*24*60))) + " min\n"
    loc_res += "Available in (P->H): " + iUnsig(Round(((loc_cooldowntimePH - loc_currenttime)*24*60))) + " min\n"
    return loc_res
EndFunction

;///////////////////////////////////////
;=======================================
;            SKILL FUNCTIONS
;=======================================
;//////////////////////////////////////;
;-Used to return absolute and relative skill values which are used by some minigames

Int Property UD_SkillEfficiency = 1 auto ;% increase per one skill point

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
    return GetAgilitySkill(akActor)*UD_SkillEfficiency/100.0
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
    return GetStrengthSkill(akActor)*UD_SkillEfficiency/100.0
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
    return GetMagickSkill(akActor)*UD_SkillEfficiency/100.0
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
    return GetCuttingSkill(akActor)*UD_SkillEfficiency/100.0
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
    return GetSmithingSkill(akActor)*UD_SkillEfficiency/100.0
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
        loc_bestWeapon = loc_slot.UD_BestWeapon
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
    bool     loc_cond = false
    int        loc_type = wWeapon.GetWeaponType()
    loc_cond = loc_cond || (loc_type > 0 && loc_type < 4) ;swords, daggers, war axes
    loc_cond = loc_cond || (loc_type == 5) ;great swords
    loc_cond = loc_cond || (loc_type == 6) ;battleaxes and warhammers
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
    If akActor.WornHasKeyword(libs.zad_DeviousBelt)        ;rewritten per issue: https://github.com/IHateMyKite/UnforgivingDevices/issues/17
        ;Armor loc_belt = libs.GetWornRenderedDeviceByKeyword(akActor, libs.zad_DeviousBelt)    ;this function is painstakingly slow on cluttered inventories.
        Armor loc_belt = none
        if akActor.WornHasKeyword(libs.zad_DeviousHarness)
            loc_belt = getEquippedRender(akActor,libs.zad_DeviousHarness)
        else
            loc_belt = getEquippedRender(akActor,libs.zad_DeviousBelt)
        endif
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
int     lockpicknum
int     usedLockpicks
Bool    _PO3PEDetection = False
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
    LockpickMinigameOver = false
    
    if UDmain.PO3Installed
        _PO3PEDetection = UDmain.UDGV.UDG_PO3PEDetection.Value
        PO3_SKSEFunctions.PreventActorDetection(UDmain.Player)
    endif
    
    lockpicknum = UDmain.Player.GetItemCount(Lockpick)
    
    if lockpicknum >= UD_LockpicksPerMinigame
        usedLockpicks = UD_LockpicksPerMinigame
    else
        usedLockpicks = lockpicknum
    endif
    
    UDmain.Player.RemoveItem(Lockpick, lockpicknum - usedLockpicks, True)
    
    if UDmain.TraceAllowed()
        Log("Lockpick minigame opened, lockpicks before: "+lockpicknum+" ;lockpicks taken: " + (lockpicknum - usedLockpicks) + " ;Lockpicks to use: "+ usedLockpicks,1)
    endif
    
    RegisterForMenu("Lockpicking Menu")
    
    if UDmain.PO3Installed
        while _PO3PEDetection && PO3_SKSEFunctions.IsDetectedByAnyone(UDmain.Player)
            Utility.wait(0.05)
        endwhile
    elseif UDmain.ConsoleUtilInstalled
        ConsoleUtil.ExecuteCommand("ToggleDetection")
    endif
    
    _LockPickContainer.activate(UDmain.Player)
EndFunction

;detect when the lockpick minigame ends
bool Property LockpickMinigameOver      = false auto hidden
int  Property LockpickMinigameResult    = 0     auto hidden
Event OnMenuClose(String MenuName)
    if _PO3PEDetection && UDmain.PO3Installed
        PO3_SKSEFunctions.ResetActorDetection(UDmain.Player)
    elseif UDmain.ConsoleUtilInstalled
        ConsoleUtil.ExecuteCommand("ToggleDetection")
    endif
    
    int remainingLockpicks = UDmain.Player.GetItemCount(Lockpick)
    
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
    if UDmain.TraceAllowed()        
        Log("Lockpick minigame closed, lockpicks returned: " + (lockpicknum - usedLockpicks) + " ; Result: " + LockpickMinigameResult,1)
    endif
    UDmain.Player.AddItem(Lockpick, lockpicknum - usedLockpicks, True)
    LockpickMinigameOver = True
    UnregisterForAllMenus()
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

String[] Function GetDeviousKeywords(Armor akDevice)
    String[] result
    Int i = akDevice.GetNumKeywords()
    While i > 0
        i -= 1
        Keyword k = akDevice.GetNthKeyword(i)
        String ks = "." + k.GetString()                         ; "." is crucial so that the papyrus won't mess with the case of letters
        If StringUtil.Find(ks, "zad_devious") > -1
            result = PapyrusUtil.PushString(result, ks)
        EndIf
    EndWhile
    Return result
EndFunction

String[] Function GetDeviceStruggleKeywords(Armor akDevice)
    String[] result
    If akDevice.HasKeyword(libs.zad_DeviousHeavyBondage)
        String hb = "." + GetHeavyBondageKeyword(akDevice).GetString()      ; "." is crucial so that the papyrus won't mess with the case of letters
        If hb == "."
            UDMain.Error("UDCustomDeiceMain::GetDeviceStruggleKeywords() No keyword for heavy bondage on " + akDevice)
        Else
            result = PapyrusUtil.PushString(result, hb)
        EndIf
    Else
        result = GetDeviousKeywords(akDevice)
    EndIf
    if UDmain.TraceAllowed()
        UDMain.Log("UDCustomDeviceMain::GetDeviceStruggleKeywords() " + akDevice + " : " + result, 3)
    endif
    Return result
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
        return getNPCSlot(akActor).UD_HandRestrain
    else
        return getDeviceScriptByKw(akActor,libs.zad_deviousHeavyBondage)
    endif
EndFunction

UD_CustomDevice_RenderScript Function getSlotHeavyBondageDevice(UD_CustomDevice_NPCSlot akSlot)
    if akSlot
        akSlot.UD_HandRestrain
    else
        return none
    endif
EndFunction

;returns current device that have minigame on (return none if no minigame is on)
UD_CustomDevice_RenderScript Function getMinigameDevice(Actor akActor)
    UD_CustomDevice_RenderScript loc_device = CurrentPlayerMinigameDevice
    if loc_device && (loc_device.getWearer() == akActor || loc_device.getHelper() == akActor)
        return loc_device
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
;mod = 0 => AND (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
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
;mod = 0 => AND (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
UD_CustomDevice_RenderScript[] Function getAllDevicesByKeyword(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getAllDevicesByKeyword(kw1,kw2,kw3,mod)
    else
        return MakeNewDeviceSlots();getAllDeviceScriptsByKw(akActor,kw1,kw2,kw3,mod)
    endif
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
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
    
    if UDmain.TraceAllowed()    
        Log("getDeviceScriptByRender called for " + deviceRendered + "("+getActorName(akActor)+")")
    endif
    
    _transferedDevice = none
    
    akActor.removeItem(deviceRendered,1,True,TransfereContainer_ObjRef)
    TransfereContainer_ObjRef.removeItem(deviceRendered,1,True,akActor)
    akActor.equipItem(deviceRendered,True,True)
    float loc_time = 0.0
    bool loc_isplayer = UDmain.ActorIsPlayer(akActor)

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
                if UDmain.TraceAllowed()                
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
;mod = 0 => AND     (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
int Function getNumberOfDevicesWithKeyword(Actor akActor,keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getNumberOfDevicesWithKeyword(kw1,kw2,kw3,mod)
    endif
    return 0
EndFunction

;returns number of all device containing keyword in their render device
;mod = 0 => AND     (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
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

;returns number of activable vibrators
int Function getActivableVibratorNum(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getActivableVibratorNum()
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

;returns all turned off vibrators
UD_CustomDevice_RenderScript[] Function getActivableVibrators(Actor akActor)
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

bool Function ChangeSoulgemState(Actor akActor,Int iSoulgemType,bool bState = true)
    if !akActor
        return false
    endif
    if iSoulgemType > 4 || iSoulgemType < 0
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
        elseif iSoulgemType == 3
            akActor.removeItem(UDlibs.FilledSoulgem_Great,1,true)
            akActor.AddItem(UDlibs.EmptySoulgem_Great,1,true)
        elseif iSoulgemType == 4
            akActor.removeItem(UDlibs.FilledSoulgem_Grand,1,true)
            akActor.AddItem(UDlibs.EmptySoulgem_Grand,1,true)
        endif
    else    ;charge
        if iSoulgemType == 0
            akActor.removeItem(UDlibs.EmptySoulgem_Petty,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Petty,1,true)
        elseif iSoulgemType == 1
            akActor.removeItem(UDlibs.EmptySoulgem_Lesser,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Lesser,1,true)
        elseif iSoulgemType == 2
            akActor.removeItem(UDlibs.EmptySoulgem_Common,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Common,1,true)
        elseif iSoulgemType == 3
            akActor.removeItem(UDlibs.EmptySoulgem_Great,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Great,1,true)
        elseif iSoulgemType == 4
            akActor.removeItem(UDlibs.EmptySoulgem_Grand,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Grand,1,true)
        endif
    endif
    return true
EndFunction

Message Property UD_SoulgemSelect_MSG auto
Int Function ShowSoulgemMessage(Actor akActor,Bool bEmpty = false)
    ;precheck
    resetCondVar()
    if !bEmpty
        if akActor.getItemCount(UDlibs.FilledSoulgem_Petty)  > 0
            currentDeviceMenu_switch1 = true
        endif
        if akActor.getItemCount(UDlibs.FilledSoulgem_Lesser) > 0
            currentDeviceMenu_switch2 = true
        endif
        if akActor.getItemCount(UDlibs.FilledSoulgem_Common) > 0
            currentDeviceMenu_switch3 = true
        endif
        if akActor.getItemCount(UDlibs.FilledSoulgem_Great)  > 0
            currentDeviceMenu_switch4 = true
        endif
        if akActor.getItemCount(UDlibs.FilledSoulgem_Grand)  > 0
            currentDeviceMenu_switch5 = true
        endif
    else
        if akActor.getItemCount(UDlibs.EmptySoulgem_Petty)  > 0
            currentDeviceMenu_switch1 = true
        endif
        if akActor.getItemCount(UDlibs.EmptySoulgem_Lesser) > 0
            currentDeviceMenu_switch2 = true
        endif
        if akActor.getItemCount(UDlibs.EmptySoulgem_Common) > 0
            currentDeviceMenu_switch3 = true
        endif
        if akActor.getItemCount(UDlibs.EmptySoulgem_Great)  > 0
            currentDeviceMenu_switch4 = true
        endif
        if akActor.getItemCount(UDlibs.EmptySoulgem_Grand)  > 0
            currentDeviceMenu_switch5 = true
        endif
    endif
    ;message
    Int loc_res = UD_SoulgemSelect_MSG.Show()
    if loc_res > 5
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
        if UDmain.TraceAllowed()        
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
                ;debug.notification("Your " + udCustomDevice.getDeviceName() + " activates " + loc_device.getDeviceName() + " !!")
                UDmain.Print("Your " + udCustomDevice.getDeviceName() + " activates " + loc_device.getDeviceName() + " !!",2)
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
    if UDmain.TraceAllowed()    
        Log("activateDevice() - Sending " + udCustomDevice.getDeviceName(),3)
    endif
    int handle = ModEvent.Create("UD_ActivateDevice")
    if (handle)
        ModEvent.Send(handle)
        return true
    else
        if UDmain.TraceAllowed()        
            Log("activateDevice() - !!Sending of " + udCustomDevice.getDeviceName() + " failed!!",1)
        endif
        _activateDevicePackage = none
        return false
    endif
EndFunction

Function OnActivateDevice()
    UD_CustomDevice_RenderScript loc_fetchedPackage = _activateDevicePackage
    _activateDevicePackage = none ;free package
    if UDmain.TraceAllowed()    
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
        UDmain.Player.damageAV("Stamina",  0.1)
        UDmain.Player.restoreAV("Stamina",  0.1)
    endif
    
    if health
    ;if (WearerIsPlayer() || HelperIsPlayer()) && (UD_minigame_heal_drain != 0.0 || UD_minigame_heal_drain_helper != 0.0)
        UDmain.Player.damageAV("Health",  0.1)
        UDmain.Player.restoreAV("Health",  0.1)
    endif
    
    if magicka
    ;if (WearerIsPlayer() || HelperIsPlayer()) &&  (UD_minigame_magicka_drain != 0.0 || UD_minigame_magicka_drain_helper != 0)
        UDmain.Player.damageAV("Magicka",  0.1)
        UDmain.Player.restoreAV("Magicka",  0.1)
    endif
EndFunction

UD_CustomVibratorBase_RenderScript _startVibFunctionPackage = none
bool Function startVibFunction(UD_CustomVibratorBase_RenderScript udCustomVibrator,bool bBlocking = false)
    if !udCustomVibrator
        Error("UDCustomDeiceMain::startVibFunction() - Can't start vibration because passed vibrator is NONE!!")
        return false
    endif
    if !udCustomVibrator.canVibrate()        
        Error("UDCustomDeiceMain::startVibFunction() - " + udCustomVibrator.getDeviceHeader() + " can't vibrate!")
        return false
    endif
    
    while _startVibFunctionPackage
        Utility.waitMenuMode(0.1)
    endwhile
    _startVibFunctionPackage = udCustomVibrator
    if UDmain.TraceAllowed()    
        Log("startVibFunction() - Sending " + udCustomVibrator.getDeviceHeader(),3)
    endif
    int handle = ModEvent.Create("UD_StartVibFunction")
    if (handle)
        ModEvent.Send(handle)
        return true
    else
        if UDmain.TraceAllowed()        
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
    if UDmain.TraceAllowed()    
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
        if akActor.Is3DLoaded() && !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZTears_KW)
            UDlibs.ZAZTearsSpell.cast(akActor)
            return true
        endif
    endif
    return false
EndFUnction

bool Function ApplyDroolEffect(Actor akActor) ;works only for player
    if UDmain.ZaZAnimationPackInstalled && UDmain.SlaveTatsInstalled
        if akActor.Is3DLoaded() && !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZDrool_KW)
            UDlibs.ZAZDroolSpell.cast(akActor)
            return true
        endif
    endif
    return false
EndFUnction

; gets Lover's Desire perks faster than calling GetMeMyForm every time, based on predefined load order ids on game load
form Function SLAPerkFastFetch(int formNumber, bool OSL = false)
    if !OSL
        return Game.GetFormEx(Math.LogicalOr(Math.LeftShift(SLALoadOrder, 24), formNumber))
    else
        return Game.GetFormEx(Math.LogicalOr(Math.LogicalOr(0xFE000000, Math.LeftShift(OSLLoadOrderRelative, 12)), formNumber))
    endif
endFunction

Float Function getArousalSkillMult(Actor akActor)
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

Float Function getArousalSkillMultEx(Actor akActor)
    UD_CustomDevice_NPCSlot loc_slot = GetNPCSlot(akActor)
    if loc_slot
        return loc_slot.ArousalSkillMult
    else
        return getArousalSkillMult(akActor)
    endif
EndFunction

Float Function getSlotArousalSkillMultEx(UD_CustomDevice_NPCSlot akSlot)
    if !akSlot
        return 1.0
    endif
    return akSlot.ArousalSkillMult
EndFunction

;function used for mod development
Function DebugFunction(Actor akActor)
    UDmain.UDRRM.LockAllSuitableRestrains(akActor,false,0xffffffff)
    ;updateHUDBars(1,1,1,1)
    ;UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.MagickaMeter.StartBlinking")
    ;UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.StaminaMeter.StartBlinking")
    ;UI.Invoke("HUD Menu", "_root.HUDMovieBaseInstance.HealthMeterLeft.StartBlinking")
EndFunction

string Function GetUserTextInput()
    return UDmain.GetUserTextInput()
EndFunction

Int Function GetUserListInput(string[] arrList)
    return UDmain.GetUserListInput(arrList)
EndFunction

float _startTime = 0.0
Function StartRecordTime()
    _startTime = Utility.GetCurrentRealTime()
EndFunction

float Function FinishRecordTime(string strObject = "",bool bReset = false,bool bLog = true,bool bPrint = true)
    float loc_res = Utility.GetCurrentRealTime() - _startTime
    
    CLog("[T1]: ElapsedTime for "+ strObject + " = " + loc_res)
    
    if bLog
        debug.trace("[UD]: [T1]: ElapsedTime for "+ strObject + " = " + loc_res)
        ;Log("Elapsed time for " + strObject + " = " + loc_res + " s",1)
    endif
    if bPrint
        debug.notification("[T1]: ElapsedTime for "+ strObject + " = " + loc_res)
    endif
    
    if bReset
        StartRecordTime()
    endif
    return loc_res
EndFunction

float _startTime2 = 0.0
Function StartRecordTime2()
    _startTime2 = Utility.GetCurrentRealTime()
EndFunction

float Function FinishRecordTime2(string strObject = "",bool bReset = false,bool bLog = true,bool bPrint = true)
    float loc_res = Utility.GetCurrentRealTime() - _startTime2
    
    CLog("[T2]: ElapsedTime for "+ strObject + " = " + loc_res)
    
    if bLog
        debug.trace("[UD]: [T2]: ElapsedTime for "+ strObject + " = " + loc_res)
        ;Log("Elapsed time for " + strObject + " = " + loc_res + " s",1)
    endif
    if bPrint
        debug.notification("[T2]: ElapsedTime for "+ strObject + " = " + loc_res)
    endif
    
    if bReset
        StartRecordTime2()
    endif
    return loc_res
EndFunction


;Reduce the key durability by amount set in MCM. 
; aiDurability = By how much will durability be reduced
Int Function ReduceKeyDurability(Actor akActor, Form akKey, Int aiDurability = 1)
    Int loc_durability   = StorageUtil.GetIntValue(akActor,akKey+",UDKeyDurability",UD_KeyDurability)
    loc_durability      -= aiDurability ;remove one durability
    if loc_durability == 0
        akActor.RemoveItem(akKey,1)
        StorageUtil.SetIntValue(akActor,akKey+",UDKeyDurability",UD_KeyDurability) ;reset durability
        return 0
    else
        StorageUtil.SetIntValue(akActor,akKey+",UDKeyDurability",loc_durability)
        return loc_durability
    endif
EndFunction
