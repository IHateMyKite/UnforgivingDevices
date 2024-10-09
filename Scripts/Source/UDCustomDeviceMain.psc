;   File: UDCustomDeviceMain
;   Contains all functionality which is relevant to Custom Devices
Scriptname UDCustomDeviceMain extends Quest  conditional

import UnforgivingDevicesMain
import UD_NPCInteligence
import UD_CustomDevice_RenderScript
import UD_Native

Spell Property SwimPenaltySpell auto
UnforgivingDevicesMain Property UDmain auto
UD_ParalelProcess Property UDPP hidden
    UD_ParalelProcess Function Get()
        return UDmain.UDPP
    EndFunction
EndProperty
UD_libs Property UDlibs hidden
    UD_libs Function Get()
        return UDmain.UDlibs
    EndFunction
EndProperty
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

UD_MenuTextFormatter    _UDMTF
UD_MenuTextFormatter        Property UDMTF      Hidden  ; Menu Text Formatter
    UD_MenuTextFormatter Function Get()
        If !_UDMTF
            _UDMTF = UDmain.UDMTF
        EndIf
        Return _UDMTF
    EndFunction
EndProperty

int                 OSLLoadOrderRelative    = 0
int                 SLALoadOrder            = 0
Perk[]              DesirePerks
ObjectReference     _LockPickContainer

bool    Property UD_HardcoreMode                    = true  auto hidden

Int     Property Stamina_meter_Keycode              = 32    auto hidden
int     property StruggleKey_Keycode                = 52    auto hidden
Int     Property Magicka_meter_Keycode              = 30    auto hidden
Int     Property SpecialKey_Keycode                 = 31    auto hidden
Int     Property PlayerMenu_KeyCode                 = 40    auto hidden
int     property ActionKey_Keycode                  = 18    auto hidden
int     Property NPCMenu_Keycode                    = 39    auto hidden
bool    Property UD_UseDDdifficulty                 = True  auto hidden
bool    Property UD_UseWidget                       = True  auto hidden
int     Property UD_GagPhonemModifier               = 50    auto hidden
Int     Property UD_StruggleDifficulty              = 1     auto hidden
float   Property UD_BaseDeviceSkillIncrease         = 35.0  auto hidden
float   Property UD_CooldownMultiplier              = 1.0   auto hidden
Bool    Property UD_AutoCrit                        = False auto hidden
Int     Property UD_AutoCritChance                  = 80    auto hidden
Int     Property UD_MinigameHelpCd                  = 60    auto hidden
Float   Property UD_MinigameHelpCD_PerLVL           = 10.0  auto hidden ;CD % decrease per Helper LVL
Int     Property UD_MinigameHelpXPBase              = 35    auto hidden
Float   Property UD_MutexTimeOutTime                = 1.0   auto hidden
bool    Property UD_AllowArmTie                     = true  auto hidden
bool    Property UD_AllowLegTie                     = true  auto hidden
Int     Property UD_BlackGooRareDeviceChance        = 10    auto hidden
Bool    Property UD_PreventMasterLock               = False auto hidden
Int     Property UD_KeyDurability                   = 5     auto hidden ;how many times can be key used before it gets destroyed
Bool    Property UD_HardcoreAccess                  = False auto hidden ;if true, device accessibility can be only either 0 or 1. If number is less then 0.90, it will be 0
Float   Property UD_MinigameDrainMult               = 1.0   Auto Hidden ; minigame drain multiplier
Float   Property UD_InitialDrainDelay               = 0.0   Auto Hidden ; minigame timespan that is free from drain
Float   Property UD_MinigameExhDurationMult         = 1.0   Auto Hidden ; multiplier for minigame exhaustion duration
Float   Property UD_MinigameExhMagnitudeMult        = 1.0   Auto Hidden ; multiplier for minigame exhaustion magnitude
Int     Property UD_MinigameLockpickSkillAdjust     = 2     Auto Hidden ; index from list of possible options. 0 = 100%, 1 = 90%, 2 = 75%, 3 = 50%, 4 = 0%
Int     Property UD_LockpickMinigameDuration        = 20    Auto Hidden ;duration of lockpick minigame. After this time passe, minigame will close itself and fail. This value is adjusted by difficulty of lock
Float   Property UD_MinigameExhExponential          = 1.0   Auto Hidden ; determines how much longer subsequent exhaustions get applied for
Int     Property UD_MinigameExhNoStruggleMax        = 2     Auto Hidden ; how many exhaustions prevent further struggle. 0 disables this feature

;Lvl scalling
Float   Property UD_DeviceLvlHealth                 = 0.025 auto hidden
Float   Property UD_DeviceLvlLockpick               = 0.5   auto hidden
Int     Property UD_DeviceLvlLocks                  = 5     auto hidden
;changes how much is strength converted to orgasm rate, 
;example: if UD_VibrationMultiplier = 0.1 and vibration strength will be 100, orgasm rate will be 100*0.1 = 10 O/s 
float   Property UD_VibrationMultiplier             = 0.10  auto hidden
float   Property UD_ArousalMultiplier               = 0.05  auto hidden

Bool            Property UD_OutfitRemove            = True  auto hidden
UD_PlayerSlotScript Property UD_PlayerSlot auto

;factions
Faction         Property zadGagPanelFaction                 Auto
Faction         Property FollowerFaction                    auto
Faction         Property RegisteredNPCFaction               auto
Faction         Property MinigameFaction                    auto
Faction         Property PlayerFaction                      auto
Faction         Property BlockExpressionFaction             auto
Faction         Property BussyFaction                       auto
FormList        Property UD_AgilityPerks                    auto
FormList        Property UD_StrengthPerks                   auto
FormList        Property UD_MagickPerks                     auto

MiscObject      Property zad_GagPanelPlug                   Auto

float           Property UD_StruggleExhaustionMagnitude     = 60.0      auto hidden;magnitude of exhaustion, 50.0 will reduce player stats regen modifier by 50%. This cant make regen negative
int             Property UD_StruggleExhaustionDuration      = 10        auto hidden;How long will debuff last

;messages
Message         Property DebugMessage                       auto
Message         Property StruggleMessage                    auto
Message         Property StruggleMessageNPC                 auto
Message         Property DetailsMessage                     auto
Message         Property VibDetailsMessage                  auto
Message         Property ControlablePlugVibMessage          auto
Message         Property ControlablePlugModMessage          auto

Message         Property DefaultLockMenuMessage             auto
Message         Property DefaultLockMenuMessageWH           auto

;DEFAULT MENUS
Message         Property DefaultEquipDeviceMessage          auto
Message         Property DefaultInteractionDeviceMessage    auto
Message         Property DefaultInteractionDeviceMessageWH  auto
Message         Property DefaultInteractionPlugMessage      auto
Message         Property DefaultInteractionPlugMessageWH    auto

;SPECIAL MENUS
Message         Property DefaultCTRPlugSpecialMsg           auto
Message         Property DefaultCTRPlugSpecialMsgWH         auto
Message         Property DefaultINFPlugSpecialMsg           auto
Message         Property DefaultINFPlugSpecialMsgWH         auto
Message         Property DefaultPanelGagSpecialMsg          auto
Message         Property DefaultPanelGagSpecialMsgWH        auto
Message         Property DefaultAbadonPlugSpecialMsg        auto
Message         Property DefaultAbadonPlugSpecialMsgWH      auto
Message         Property DefaultDynamicHBSpecialMsg         auto
Message         Property DefaultVibratorSpecialMsg          auto

;MENUS
Message         Property PlayerMenuMsg                      auto
Message         Property NPCDebugMenuMsg                    auto

ObjectReference Property LockPickContainer_ObjRef           auto
Container       Property LockPickContainer                  auto

ObjectReference Property EventContainer_ObjRef              auto
ObjectReference Property TransfereContainer_ObjRef          auto

ReferenceAlias  Property MessageActor1                      auto hidden
ReferenceAlias  Property MessageActor2                      auto hidden
ReferenceAlias  Property MessageDevice                      auto hidden
UD_MutexScript  Property MutexSlot                          auto
MiscObject      Property Lockpick                           auto
Int             Property UD_LockpicksPerMinigame = 2        auto hidden
Formlist        Property UD_GenericKeys                     auto
Formlist        Property UD_QuestKeywords                   auto
FormList        Property UD_HeavyBondageKeywords            auto

Bool            Property UD_EquipMutex              = False auto hidden
Bool            Property Ready                      = False auto hidden

Event OnInit()
    if CheckSubModules()
        registerEvents()
        ready = True
        registerForSingleUpdate(5.0)
        if UDmain.TraceAllowed()
            UDmain.Log("UDCustomDeviceMain ready!",0)
        endif
    else
        ready = False
    endif
    RegisterForSingleUpdateGameTime(1.0)
EndEvent

Bool Function CheckSubModules()
    Bool    loc_cond = False
    Int     loc_elapsedTime = 0
    while !loc_cond && loc_elapsedTime < 15
        loc_cond = True
        loc_cond = loc_cond && UDPatcher.ready
        loc_cond = loc_cond && UDEM.ready
        
        loc_elapsedTime += 1
        Utility.WaitMenuMode(1.0)
    endwhile
    
    ;check for fatal error
    if !loc_cond
        UDmain.ShowSingleMessageBox("!!FATAL ERROR!!\nError loading Unforgiving devices. One or more of the modules are not ready. Please contact developers on LL or GitHub")
        
        String loc_modules = "--MODULES--\n"
        loc_modules += "UDPatcher="+UDPatcher.ready + "\n"
        loc_modules += "UDEM="+UDEM.ready + "\n"
        UDmain.ShowMessageBox(loc_modules)
        
        ;Dumb info to console, use GInfo to skip ConsoleUtil installation check
        GInfo("!!FATAL ERROR!! = Error loading Unforgiving devices. One or more of the modules are not ready. Please contact developrs on LL or GitHub")
        GInfo("UDPatcher="+UDPatcher.ready)
        GInfo("UDEM="+UDEM.ready)
        
        return False
    endif
    return true
EndFunction

Function Update()
    RegisterForSingleUpdate(2*UD_UpdateTime)
    
    _activateDevicePackage = none
    _startVibFunctionPackage = none
    
    ResetUI()
    registerAllEvents()
    
    ;CheckHardcoreDisabler(UDmain.Player)
    
    SetArousalPerks()

EndFunction

;dedicated switches to hide options from menu

; Group: Device menu

;/  Variable: currentDeviceMenu_allowStruggling

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowStruggling         = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowUselessStruggling

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowUselessStruggling  = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowLockpick

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowLockpick           = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowKey

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowKey                = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowCutting

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowCutting            = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowLockRepair

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowLockRepair         = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowTighten

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowTighten            = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowRepair

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowRepair             = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowCommand

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowCommand            = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowDetails

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowDetails            = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowLockMenu

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowLockMenu           = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowSpecialMenu

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowSpecialMenu        = false auto conditional hidden

;/  Variable: currentDeviceMenu_allowEscape

    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_allowEscape             = false auto conditional hidden

;switches for special menu, allows only six buttons

;/  Variable: currentDeviceMenu_switch1
    Switch for special menu, allows only six buttons
    
    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_switch1                 = false auto conditional hidden

;/  Variable: currentDeviceMenu_switch2
    Switch for special menu, allows only six buttons
    
    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_switch2                 = false auto conditional hidden

;/  Variable: currentDeviceMenu_switch3
    Switch for special menu, allows only six buttons
    
    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_switch3                 = false auto conditional hidden

;/  Variable: currentDeviceMenu_switch4
    Switch for special menu, allows only six buttons
    
    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_switch4                 = false auto conditional hidden

;/  Variable: currentDeviceMenu_switch5
    Switch for special menu, allows only six buttons
    
    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_switch5                 = false auto conditional hidden

;/  Variable: currentDeviceMenu_switch6
    Switch for special menu, allows only six buttons
    
    Conditional variable intended to be used by conditions on messages
/;
bool Property currentDeviceMenu_switch6                 = false auto conditional hidden

;/  Function: resetCondVar

    Resets all variables which are intended to be used by messages  to show buttons
/;
Function resetCondVar()
    currentDeviceMenu_allowstruggling = false
    currentDeviceMenu_allowUselessStruggling = false
    currentDeviceMenu_allowcutting = false
    currentDeviceMenu_allowkey = false
    currentDeviceMenu_allowlockpick = false
    currentDeviceMenu_allowlockrepair = false
    currentDeviceMenu_allowTighten = false
    currentDeviceMenu_allowRepair = false
    currentDeviceMenu_allowEscape = false
    
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

;/  Function: disableStruggleCondVar

    Resets all struggle related variables which are intended to be used by messages to show buttons

    Parameters:

        abDisableLock       - Also disable lock related buttons
        abUselessStruggle   - Also disable useless struggle button
/;
Function disableStruggleCondVar(bool abDisableLock = true, bool abUselessStruggle = false)
    currentDeviceMenu_allowstruggling = false
    currentDeviceMenu_allowUselessStruggling = abUselessStruggle
    currentDeviceMenu_allowcutting = false
    if abDisableLock
        currentDeviceMenu_allowkey = false
        currentDeviceMenu_allowLockMenu = False
        currentDeviceMenu_allowlockpick = false
        currentDeviceMenu_allowlockrepair = false
    endif
    currentDeviceMenu_allowTighten = false
    currentDeviceMenu_allowRepair = false
EndFunction

;/  Function: CheckAndDisableSpecialMenu

    Validate if special menu should be shown. Should be called after changes to any currentDeviceMenu_switchX variable was done
/;
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

; Group: Generic

;/  Function: MakeNewDeviceSlots

    Returns:

        New array of devices. Size of array is same as maximum amount of devices which can have one actor registered at once
/;
UD_CustomDevice_RenderScript[] Function MakeNewDeviceSlots()
    return new UD_CustomDevice_RenderScript[25]
EndFunction

;/  Function: DisableActor

    Wrapper of function <StartMinigameDisable>

    Parameters:

        akActor     - Actor to disable
        aiIsPlayer  - If actor is player. Is optional and inteded to fasten up the function as there will be not need to check if actor is player if this value 1
/;
Function DisableActor(Actor akActor,int aiIsPlayer = -1)
    StartMinigameDisable(akActor,aiIsPlayer)
EndFunction

;/  Function: UpdateDisabledActor

    Wrapper of function <UpdateMinigameDisable>

    Parameters:

        akActor     - Actor to update
        aiIsPlayer  - If actor is player. Is optional and inteded to fasten up the function as there will be not need to check if actor is player if this value 1
/;
Function UpdateDisabledActor(Actor akActor,int aiIsPlayer = -1)
    UpdateMinigameDisable(akActor,aiIsPlayer)
EndFunction

;/  Function: EnableActor

    Wrapper of function <EndMinigameDisable>

    Parameters:

        akActor     - Actor to enable
        aiIsPlayer  - If actor is player. Is optional and inteded to fasten up the function as there will be not need to check if actor is player if this value 1
/;
Function EnableActor(Actor akActor,int aiIsPlayer = -1)
    EndMinigameDisable(akActor,aiIsPlayer)
EndFunction

;/  Function: StartMinigameDisable

    Disalbe actor, preventing it from moving. In case of player, it also disables any inputs.

    Parameters:

        akActor     - Actor to disable
        aiIsPlayer  - If actor is player. Is optional and inteded to fasten up the function as there will be not need to check if actor is player if this value 1
/;
Function StartMinigameDisable(Actor akActor,Int aiIsPlayer = -1)
    if UDmain.TraceAllowed()
        UDmain.Log("StartMinigameDisable("+getActorName(akActor) + ")",2)
    endif
    akActor.AddToFaction(BussyFaction)
    UnforgivingDevicesMain.DisableWeapons(akActor)
    if aiIsPlayer == 1 || IsPlayer(akActor)
    else
        akActor.SetDontMove(True)
    endif
EndFunction

;/  Function: UpdateMinigameDisable

    Update actor disable. Should be used once in the while, as there is chance that other mod might enable actor

    Parameters:

        akActor     - Actor to update
        aiIsPlayer  - If actor is player. Is optional and inteded to fasten up the function as there will be not need to check if actor is player if this value 1
/;
Function UpdateMinigameDisable(Actor akActor,Int aiIsPlayer = -1)
    if UDmain.TraceAllowed()    
        UDmain.Log("UpdateMinigameDisable("+getActorName(akActor)+")",2)
    endif
    if akActor.IsInFaction(BussyFaction)
        if aiIsPlayer == 1 || IsPlayer(akActor)
        else
            akActor.SetDontMove(True)
        endif
    endif
EndFunction

;/  Function: EndMinigameDisable

    Reenable actor, allowing it again to move and use inputs.

    Parameters:

        akActor     - Actor to enable
        aiIsPlayer  - If actor is player. Is optional and inteded to fasten up the function as there will be not need to check if actor is player if this value 1
/;
Function EndMinigameDisable(Actor akActor,Int aiIsPlayer = -1)
    if UDmain.TraceAllowed()    
        UDmain.Log("EndMinigameDisable("+getActorName(akActor)+")",2)
    endif
    akActor.RemoveFromFaction(BussyFaction)
    if aiIsPlayer == 1 || IsPlayer(akActor)
    else
        akActor.SetDontMove(False)
    endif
    UnforgivingDevicesMain.EnableWeapons(akActor)
EndFunction

;/  Function: IsBussy

    Parameters:

        akActor     - Actor to enable
        
    Returns:
    
        True if actor is disabled by <DisableActor> function
/;
Bool Function IsBussy(Actor akActor)
    return akActor.IsInFaction(BussyFaction)
EndFunction

;/  Function: actorInMinigame

    Parameters:

        akActor     - Actor to check

    Returns:
    
        True if actor is currently in minigame
/;
bool Function actorInMinigame(Actor akActor)
    if !akActor
        return false
    endif
    return akActor.IsInFaction(MinigameFaction)
EndFunction

;/  Function: PlayerInMinigame

    Returns:
    
        True if player is currently in minigame
/;
bool Function PlayerInMinigame()
    return UDmain.Player.IsInFaction(MinigameFaction)
EndFunction

;/  Function: StopMinigame

    Will try to stop current minigame in which is *akActor*. Will not work if *akActor* is not wearer of the device

    Parameters:

        akActor         - Actor to process
        abWaitForStop   - Function will ba blocked untill minigame fully stops
/;
Function StopMinigame(Actor akActor, Bool abWaitForStop)
    if !akActor
        return
    endif
    
    UD_CustomDevice_RenderScript loc_device = GetMinigameDevice(akActor)
    if loc_device
        loc_device.StopMinigame(abWaitForStop)
    endif
EndFunction

Function AddInvisibleArmbinder(Actor akActor)
    if !akActor.getItemCount(UDlibs.InvisibleArmbinder)
        if akActor.wornhaskeyword(libs.zad_DeviousHeavyBondage)
            ;actor already have HB equipped, only add the invisible HB, but not equip it
            akActor.AddItem(UDlibs.InvisibleArmbinder,1)
        else
            ;actor dont have HB, equip it (which will also add it) and start idle animation
            akActor.EquipItem(UDlibs.InvisibleArmbinder,false,true)
            libs.StartBoundEffects(akActor)
        endif
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
        if akActor.wornhaskeyword(libs.zad_deviousHobbleSkirt)
            ;actor already have hobble skirt equipped, only add the invisible hobble, but not equip it
            akActor.AddItem(UDlibs.InvisibleHobble,1)
        else
            ;actor dont have hobble skirt, equip it (which will also add it) and start idle animation
            akActor.EquipItem(UDlibs.InvisibleHobble,false,true)
            libs.StartBoundEffects(akActor)
        endif
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

int Property GiftMenuMode = 0 auto hidden

Function openNPCHelpMenu(Actor akTarget)
    GiftMenuMode = 3
    akTarget.ShowGiftMenu(False, UDlibs.GiftMenuFilter,True,False)
EndFunction

;/  Variable: CurrentPlayerMinigameDevice

    Players device which is currently used in minigame.

    *!!DO NOT EDIT, READ ONLY!!*
/;
UD_CustomDevice_RenderScript Property CurrentPlayerMinigameDevice     = none auto hidden

Function setCurrentMinigameDevice(UD_CustomDevice_RenderScript oref)
    CurrentPlayerMinigameDevice = oref
EndFunction

Function resetCurrentMinigameDevice()
    CurrentPlayerMinigameDevice = none
EndFunction

;/  Function: getNumberOfRegisteredDevices

    Parameters:

        akActor     - Actor to check

    Returns:
    
        Number of registered devices
/;
int Function getNumberOfRegisteredDevices(Actor akActor)
    return getNPCSlot(akActor).getNumberOfRegisteredDevices()
EndFunction

;/  Group: Register and device
    Functions used for manipulating NPC slots, and regstered devices
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: isRegistered

    Parameters:

        akActor     - Actor to check

    Returns:
    
        True is actor is registered in any NPC slot
/;
bool Function isRegistered(Actor akActor)
    if akActor == UDmain.Player
        return true
    endif
    return akActor.isInFaction(RegisteredNPCFaction);UDCD_NPCM.isRegistered(akActor)
EndFunction

;/  Function: getNPCSlot

    Parameters:

        akActor     - Actor to process

    Returns:
    
        NPC slot in which is *akActor* registered
/;
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

;/  Function: getNPCDevices

    *Actor have to be registred for this function to work, otherwise none is returned*

    Parameters:

        akActor     - Actor to process

    Returns:
    
        Array of all registered devices.
/;
UD_CustomDevice_RenderScript[] Function getNPCDevices(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).UD_equipedCustomDevices
    else
        return none
    endif
EndFunction

;/  Function: registerDevice

    Try to register passed *akDevice* on its wearer slot.

    *Actor have to be registred for this function to work!*

    Parameters:

        akDevice     - Device to register

    Returns:
    
        True if operation was succesfull
/;
bool Function registerDevice(UD_CustomDevice_RenderScript akDevice)
    UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akDevice.getWearer())
    if loc_slot
        return loc_slot.registerDevice(akDevice)
    else
        UDmain.Error("UDCustomDeiceMain::registerDevice("+akDevice.getDeviceHeader()+") - can't find slot for actor " + akDevice.getWearerName())
        return false
    endif
EndFunction

;/  Function: deviceAlreadyRegistered

    Check if passed *akDeviceInventory* is already registered on *akActor* slot

    *Actor have to be registred for this function to work!*

    Parameters:

        akActor             - Actor to check
        akDeviceInventory   - Inventory device

    Returns:
    
        True if device is not registered yet
/;
bool Function deviceAlreadyRegistered(Actor akActor, Armor akDeviceInventory)
    if isRegistered(akActor)
        return getNPCSlot(akActor).deviceAlreadyRegistered(akDeviceInventory)
    else
        return false
    endif
EndFunction

Function removeAllDevices(Actor akActor)
    if isRegistered(akActor)
        getNPCSlot(akActor).removeAllDevices()
    endif
EndFunction

;/  Function: unregisterDevice

    Unregister *akDevice* from its wearer NPC slot

    *Actor have to be registred for this function to work!*

    Parameters:

        akDevice    - Device to unregister
        aiStartID   - Start index from which will function unregister device. Used for optimization
        abSort      - If slots should be sorted after device is unregistered

    Returns:
    
        Number of unregistered devices
/;
int Function unregisterDevice(UD_CustomDevice_RenderScript akDevice,int aiStartID = 0,bool abSort = True)
    UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akDevice.getWearer())
    if loc_slot
        return loc_slot.unregisterDevice(akDevice,aiStartID,abSort)
    else
        UDmain.Error("UDCustomDeviceMain::unregisterDevice("+akDevice.getDeviceHeader()+") - can't find slot for actor " + akDevice.getWearerName())
    endif
EndFunction


;/  Function: LockDevice

    Lock *akDeviceInventory* on *akActor*.

    This function is blocking and will be blocked untill the device is fully locked, or untill error occurs

    Parameters:

        akActor             - Actor to lock device on
        akDeviceInventory   - Device to lock
        aiForce             - If the lock operation should be forced

    See:  <LockDeviceParalel>
/;
Function LockDevice(form akActor, form akDeviceInventory, int aiForce)
    libsp.LockDevicePatched(akActor as Actor,akDeviceInventory as Armor,aiForce as Bool)
EndFunction

;/  Function: LockDeviceParalel

    Lock *akDeviceInventory* on *akActor*.

    This function will create paralel thread which does all operation, and thus is not blocking.

    Parameters:

        akActor             - Actor to lock device on
        akDeviceInventory   - Device to lock
        abForce             - If the lock operation should be forced
        
    See:  <LockDevice>
/;
Function LockDeviceParalel(actor akActor, armor akDeviceInventory, bool abForce = false)
    int handle = ModEvent.Create("UD_LockDeviceParalel")
    if (handle)
        ModEvent.PushForm(handle,akActor)
        ModEvent.PushForm(handle,akDeviceInventory)
        ModEvent.PushInt(handle,abForce as int)
        ModEvent.Send(handle)
    endif
EndFunction

;/  Function: StopAllVibrators

    Turns off all vibrators on *akActor*

    Parameters:

        akActor             - Actor to process
/;
Function StopAllVibrators(Actor akActor)
    if isRegistered(akActor)
        getNPCSlot(akActor).TurnOffAllVibrators()
    endif
EndFunction

;/  Function: getStruggleDifficultyModifier

    Returns modifier float number. The harder the difficulty, the bigger this number is.
    
    Depends on MCM setting of both DD and UD.
    
    Intended to be used by Struggle minigames
    
    Returns:
    
        Modifier. In case that default MCM setting is used, this number will be 1.0
/;
float Function getStruggleDifficultyModifier()
    float res = 1.0
    
    if UD_UseDDdifficulty
        res += (0.6 - 0.15*UDmain.getDDescapeDifficulty())
    endif
    
    res += 0.25*(1 - UD_StruggleDifficulty)
    
    return res
EndFunction

;/  Function: getMendDifficultyModifier

    Returns modifier float number. The harder the difficulty, the bigger this number is.
    
    Depends on MCM setting of both DD and UD.
    
    Intended to be used by any regen related modifiers
    
    Returns:
    
        Modifier. In case that default MCM setting is used, this number will be 1.0
/;
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
        UDmain.Log("UDCustomDeviceMain startScript() called for " + oref.getDeviceHeader(),1)
    endif
    if oref.WearerIsPlayer()
        registerDevice(oref)
    elseif isRegistered(oref.getWearer())
        registerDevice(oref)
    endif
    ; invalidate constraintsInt for the actor to update it on the next call
    UDAM.InvalidateActorConstraintsInt(oref.getWearer())
EndFunction

Function endScript(UD_CustomDevice_RenderScript oref)
    if UDmain.TraceAllowed()    
        UDmain.Log("UDCustomDeviceMain endScript() called for " + oref.DeviceInventory.getName(),1)
    endif
    updateLastOpenedDeviceOnRemove(oref)
    if isRegistered(oref.getWearer())
        unregisterDevice(oref)
    endif
    ; invalidate constraintsInt for the actor to update it on the next call
    UDAM.InvalidateActorConstraintsInt(oref.getWearer())
EndFunction

Function RegisterGlobalKeys()
    UDUI.RegisterGlobalKeys()
EndFunction

Function UnregisterGlobalKeys()
    UDUI.UnregisterGlobalKeys()
EndFunction

Function registerAllEvents()
    if UDmain.TraceAllowed()
        UDmain.Log("registerAllEvents")
    endif
    registerEvents()
    RegisterGlobalKeys()
EndFunction

Function registerEvents()
    if UDmain.TraceAllowed()
        UDmain.Log("registerEvents")
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

;replece slot with new device
Function replaceSlot(UD_CustomDevice_RenderScript oref, Armor inventoryDevice)
    getNPCSlot(oref.getWearer()).replaceSlot(oref,inventoryDevice)
EndFunction

;show MCM debug menu
Function showDebugMenu(Actor akActor,int slot_id)
    getNPCSlot(akActor).showDebugMenu(slot_id)
EndFunction

;/  Function: AllowNPCMessage

    Filter actors, so messages can be only shown for relevant actors

    Parameters:

        akActor         - Actor to check
        abOnlyFollower  - If only follower can show message

    Returns:

        True if actor related message can be printed
        
    See: <Print>
/;
bool Function AllowNPCMessage(Actor akActor,Bool abOnlyFollower = false)
    if UDmain.ActorIsFollower(akActor) || IsPlayer(akActor)
        return true
    endif
    if !abOnlyFollower
        return UDmain.ActorInCloseRange(akActor)
    else
        return false
    endif
EndFunction

UD_CustomDevice_RenderScript _activateDevicePackage = none

;/  Function: activateDevice

    Activates passed *akCustomDevice*

    Parameters:
        
        akCustomDevice  - Device to activate
        
    Returns:

        True if operation was succesfull
/;
bool Function activateDevice(UD_CustomDevice_RenderScript akCustomDevice)
    if !akCustomDevice.canBeActivated() ;can't be activated, return
        if UDmain.TraceAllowed()        
            UDmain.Log("activateDevice(" + akCustomDevice.GetDeviceHeader() + ") - Can't be activated",3)
        endif
        return false
    endif
    
    if !akCustomDevice.isNotShareActive() ;share active
        ;activate other device
        int loc_num = getActiveDevicesNum(akCustomDevice.getWearer())
        if loc_num > 0
            UD_CustomDevice_RenderScript[] loc_device_arr = getActiveDevices(akCustomDevice.getWearer())
            UD_CustomDevice_RenderScript loc_device = loc_device_arr[RandomInt(0,loc_num - 1)]
            if akCustomDevice.WearerIsPlayer()
                UDmain.Print("Your " + akCustomDevice.getDeviceName() + " activates " + loc_device.getDeviceName() + " !!", 2)
            endif
            akCustomDevice = loc_device
        else
            return false
        endif
    endif
    
    while _activateDevicePackage
        Utility.waitMenuMode(0.15)
    endwhile
    _activateDevicePackage = akCustomDevice
    if UDmain.TraceAllowed()
        UDmain.Log("activateDevice(" + akCustomDevice.GetDeviceHeader() + ") - Sending event",3)
    endif
    int handle = ModEvent.Create("UD_ActivateDevice")
    if (handle)
        ModEvent.Send(handle)
        return true
    else
        if UDmain.TraceAllowed()
            UDmain.Log("activateDevice(" + akCustomDevice.GetDeviceHeader() + ") - !!Sending of event failed!!",1)
        endif
        _activateDevicePackage = none
        return false
    endif
EndFunction

Function OnActivateDevice()
    UD_CustomDevice_RenderScript loc_fetchedPackage = _activateDevicePackage
    _activateDevicePackage = none ;free package
    if UDmain.TraceAllowed()    
        UDmain.Log("activateDevice() - Received " + loc_fetchedPackage.getDeviceName(),3)
    endif
    loc_fetchedPackage.activateDevice()
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
        ;LoadConfig()
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
string  Property selected_crit_meter    =  "UDmain.Error"      auto hidden
Int     Property UD_CritEffect          = 2             auto hidden
Bool    Property UD_MandatoryCrit       = False         auto hidden
Float   Property UD_CritDurationAdjust  = 0.0           auto hidden

Event StruggleCritCheck(UD_CustomDevice_RenderScript device, int chance, string strArg, float difficulty)
    string meter
    if RandomInt(1,100) <= chance
        if strArg != "NPC" && strArg != "Auto"
            if strArg == "random"
                if RandomInt(0,1)
                    meter = "S"
                else
                    meter = "M"
                endif
            else
                meter = strArg
            endif
        elseif strArg == "Auto" ;auto crits
            if RandomInt() <= UD_AutoCritChance ;npc reacted
                device.critDevice() ;succes
            else
                device.critFailure() ;failure
            endif
            return
        elseif strArg == "NPC"
            if RandomInt() > 30 ;npc reacted
                float randomResponceTime = RandomFloat(0.4,0.95) ;random reaction time
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
Bool Property UD_CurrentNPCMenuIsStatic             = False auto conditional hidden
Bool Property UD_CurrentNPCMenuIsPersistent         = False auto conditional hidden
Bool Property UD_CurrentNPCMenuTargetIsHelpless     = False auto conditional hidden
Bool Property UD_CurrentNPCMenuTargetIsInMinigame   = False auto conditional hidden


;/  Function: NPCMenu

    Opends NPC menu for passed *akActor*

    Parameters:

        akActor         - Actor to open menu on
/;
Function NPCMenu(Actor akActor)
    SetMessageAlias(akActor)
    UD_CurrentNPCMenuIsFollower         = UDmain.ActorIsFollower(akActor)
    UD_CurrentNPCMenuIsRegistered       = isRegistered(akActor)
    UD_CurrentNPCMenuIsStatic           = akActor.IsInFaction(UDlibs.StaticNPC)
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
        HelpNPC(akActor,UDmain.Player,UDmain.ActorIsFollower(akActor))
    elseif loc_res == 5 ; get help
        HelpNPC(UDmain.Player,akActor,false)
    elseif loc_res == 6
        UndressArmor(akActor)
        ;akActor.UpdateWeight(0)
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

;/  Function: HelpNPC

    Opends the list of registered npcs on *akVictim*.
    
    Selecting the device will open Device menu with relevnt options.

    Parameters:

        akVictim        - Actor that is getting the help
        akHelper        - Actor who is helping *akVictim*
        abAllowCommand  - If player can command the NPC. Is ignored if *akVictim* is Player
        
    Example:
    --- Code
        HelpNPC(SomeNPC,Player,False)  -> Player can help SomeNPC, but can't command them
        HelpNPC(Follower,Player,False) -> Player can help Follower, and can command them
        HelpNPC(Player,SomeNPC,False)  -> SomeNPC can help Player
    ---
/;
Function HelpNPC(Actor akVictim,Actor akHelper,bool abAllowCommand)
    UD_CustomDevice_NPCSlot loc_slot = getNPCSlot(akVictim)
    if loc_slot
        if IsPlayer(akHelper)
            SetPlayerFollower(akVictim,true,2)
        elseif IsPlayer(akVictim)
            SetPlayerFollower(akHelper,true,2)
        endif
        
        UD_CustomDevice_RenderScript loc_device = loc_slot.GetUserSelectedDevice()
        if loc_device
            OpenHelpDeviceMenu(loc_device,akHelper,abAllowCommand)
        endif
        
        if IsPlayer(akHelper)
            SetPlayerFollower(akVictim,false,2)
        elseif IsPlayer(akVictim)
            SetPlayerFollower(akHelper,false,2)
        endif
    endif
EndFunction

;/  Function: OpenHelpDeviceMenu

    Opends the Device menu of specific device with helper set to *akHelper*

    Parameters:

        akDevice            - Device on which will be menu opened
        akHelper            - Actor who is helping *akVictim*
        abAllowCommand      - If player can command the NPC. Is ignored if device wearer is Player
        abIgnoreCooldown    - If Helper cooldown should be ignored
/;
Function OpenHelpDeviceMenu(UD_CustomDevice_RenderScript akDevice,Actor akHelper,bool abAllowCommand,bool abIgnoreCooldown = false)
    if akDevice && akHelper
        bool loc_cond = true
        if !abIgnoreCooldown
            float loc_currenttime = Utility.GetCurrentGameTime()
            float loc_cooldowntime = StorageUtil.GetFloatValue(akHelper,"UDNPCCD:"+akDevice.getWearer(),loc_currenttime)
            if loc_cooldowntime > loc_currenttime
                UDmain.Print("On cooldown! (" + iUnsig(Round(((loc_cooldowntime - loc_currenttime)*24*60)))+" min)",0)
                loc_cond = false
            endif
        endif
        
        if OrgasmSystem.GetOrgasmingCount(akDevice.getWearer()) || OrgasmSystem.GetOrgasmingCount(akHelper) ;actor is orgasming, prevent help
            loc_cond = false
            abAllowCommand = false
        endif

        bool[] loc_arrcontrol; = new bool[30]
        if !loc_cond 
            loc_arrcontrol = CreateControlArrayTrue()
            loc_arrcontrol[15] = false
            loc_arrcontrol[16] = false
        else
            loc_arrcontrol = CreateControlArrayFalse()
            ;tying and repairing doesn't sound like helping
            ;allow for now, will have to add some switch later which will determinate if player can be dick to NPC or not
            ;loc_arrcontrol[06] = true
            ;loc_arrcontrol[07] = true
        endif
        
        if IsPlayer(akHelper)
            SetPlayerFollower(akDevice.getWearer(),true,1)
        elseif IsPlayer(akDevice.getWearer())
            SetPlayerFollower(akHelper,true,1)
        endif

        loc_arrcontrol[14] = !abAllowCommand
        akDevice.deviceMenuWH(akHelper,loc_arrcontrol)
        
        if IsPlayer(akHelper)
            SetPlayerFollower(akDevice.getWearer(),false,1)
        elseif IsPlayer(akDevice.getWearer())
            SetPlayerFollower(akHelper,false,1)
        endif
    endif
EndFunction

float Function _CalculateHelperCD(Actor akActor,Int aiLevel = 0)
    if aiLevel <= 0
        aiLevel = GetHelperLVL(akActor)
    endif
    float loc_res = UD_MinigameHelpCd - Round((aiLevel - 1)*(UD_MinigameHelpCD_PerLVL/100.0)*UD_MinigameHelpCd)
    loc_res = fRange(loc_res,5.0,60.0*24.0) ;crop the value
    loc_res = loc_res/(60.0*24.0) ;convert to days
    return loc_res
EndFunction

;/  Function: ResetHelperCD

    Increases helper xp, and reset cooldown to new value

    Parameters:

        akHelper    - Actor whos XP will increase
        akHelped    - Actor that is getting the help
        aiXP        - How much XP to add

    Returns:
    
        Helper LVL after XP is increased
/;
int Function ResetHelperCD(Actor akHelper,Actor akHelped,Int aiXP = 0)
    Int loc_lvl = 1
    if aiXP > 0
        loc_lvl = addHelperXP(akHelper, aiXP)
    else
        loc_lvl = GetHelperLVL(akHelper)
    endif
    StorageUtil.SetFloatValue(akHelper,"UDNPCCD:"+akHelped,Utility.GetCurrentGameTime() + _CalculateHelperCD(akHelper,loc_lvl))
    return loc_lvl
EndFunction

Int Function _CalculateHelperXpRequired(Int aiLevel)
    return Round(aiLevel*100*Math.pow(1.03,aiLevel))
EndFunction

;/  Function: addHelperXP

    Adds helper XP to *akHelper*. Will automatically increase actors Helper LVL

    Parameters:

        akHelper    - Actor whos XP will increase
        aiXP        - How much XP to add

    Returns:
    
        Helper LVL after XP is increased
/;
int Function addHelperXP(Actor akHelper, int aiXP)
    int loc_currentXP   = StorageUtil.GetIntValue(akHelper,"UDNPCXP",0)
    int loc_currentLVL  = GetHelperLVL(akHelper)
    int loc_nextXP      = loc_currentXP + aiXP
    int loc_nextLVL     = loc_currentLVL
    while loc_nextXP >= _CalculateHelperXpRequired(loc_nextLVL)
        loc_nextXP      -= _CalculateHelperXpRequired(loc_nextLVL)
        loc_nextLVL     += 1
        if IsPlayer(akHelper)
            UDmain.Print("Your Helper skill level increased to " + loc_nextLVL + " !")
        elseif AllowNPCMessage(akHelper)
            UDmain.Print(GetActorName(akHelper) + "'s helper level have increased to " + loc_nextLVL + " !")
        endif
    endwhile
    StorageUtil.SetIntValue(akHelper,"UDNPCXP",loc_nextXP)
    if loc_nextLVL != loc_currentLVL
        StorageUtil.SetIntValue(akHelper,"UDNPCLVL",loc_nextLVL)
    endif
    return loc_nextLVL
EndFunction

;/  Function: GetHelperLVL

    Parameters:

        akHelper    - Actor whos XP will increase

    Returns:

        Helper LVL of *akHelper*
/;
int Function GetHelperLVL(Actor akHelper)
    return StorageUtil.GetIntValue(akHelper,"UDNPCLVL",1)
EndFunction

float Function GetHelperLVLProgress(Actor akHelper)
    Float loc_currentXP = StorageUtil.GetIntValue(akHelper,"UDNPCXP",0)
    int loc_currentLVL = StorageUtil.GetIntValue(akHelper,"UDNPCLVL",1)
    return loc_currentXP/_CalculateHelperXpRequired(loc_currentLVL);(100.0*(loc_currentLVL))
EndFunction

;/  Function: PlayerMenu

    Opens Player menu
/;
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

;/  Function: UndressArmor

    Opens menu with all equipped armos, allowing user to undress certain parts of the outfit

    Parameters:

        akActor    - Actor who will be undressed
/;
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
        loc_armorsnames = PapyrusUtil.PushString(loc_armorsnames,"--STRIP--")
        loc_armorsnames = PapyrusUtil.PushString(loc_armorsnames,"--UN-STRIP--")
        loc_armorsnames = PapyrusUtil.PushString(loc_armorsnames,"--UNDRESS-ALL--")
        loc_armorsnames = PapyrusUtil.PushString(loc_armorsnames,"--BACK--")
        int loc_res = UDmain.GetUserListInput(loc_armorsnames)
        if loc_res == (loc_armorsnames.length - 2)
            UndressAllArmor(akActor)
        elseif loc_res == (loc_armorsnames.length - 3)
            zadNativeFunctions.SetActorStripped(akActor,false)
        elseif loc_res == (loc_armorsnames.length - 4)
            zadNativeFunctions.SetActorStripped(akActor,true)
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

;/  Function: UndressAllArmor

    Undress all armors that are not DD, have name and don't have SexLabNoStrip keyword

    Parameters:

        akActor    - Actor who will be undressed
/;
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
    Form  loc_weap1   = akActor.GetEquippedObject(0)
    Form  loc_weap2   = akActor.GetEquippedObject(1)
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

;/  Function: CheckRenderDeviceEquipped

    Function made as replacemant for akActor.isEquipped, because that function doesn't work for NPCs

    Should be used in case that user wants to check if device is equipped

    Parameters:

        akActor         - Actor who will be checked
        akRendDevice    - *Render* device
/;
bool Function CheckRenderDeviceEquipped(Actor akActor, Armor akRendDevice)
    Armor loc_res = UD_Native.CheckArmorEquipped(akActor,akRendDevice)
    if loc_res && !_IsDevice(loc_res)
        akActor.unequipItem(loc_res)
        akActor.equipItem(akRendDevice)
        loc_res = UD_Native.CheckArmorEquipped(akActor,akRendDevice)
    endif
    return loc_res == none
EndFunction

bool Function _IsDevice(Armor akArmor)
    return akArmor.HasKeyword(libs.zad_Lockable) || akArmor.haskeyword(libs.zad_DeviousPlug)
EndFunction

;returns conflicting device, should be only used after equipitem function fails
Armor Function GetConflictDevice(Actor akActor, Armor akRendDevice)
    return UD_Native.CheckArmorEquipped(akActor,akRendDevice)
EndFunction

;/  Function: CheckRenderDeviceConflict

    Check if passed *akRendDevice* can be correctly locked on *akActor*

    Parameters:

        akActor         - Actor whos conflict will be checked
        akRendDevice    - *Render* device
        
    Returns:
    
        --- Code
        |=======================================================================|
        |   returns |           Meaning                                         |
        |=======================================================================|
        |    00     =     No issue                                              |
        |    01     =     Same device is already equipped                       |
        |    02     =     Different device is already equipped in same slot     |
        |    03     =     Other issue                                           |
        |=======================================================================|
        ---
/;
int Function CheckRenderDeviceConflict(Actor akActor, Armor akRendDevice)
    if !akActor
        return 3
    endif
    
    Armor loc_res = UD_Native.CheckArmorEquipped(akActor,akRendDevice)
    if loc_res == akRendDevice
        return 1 ;same render device is already equipped
    elseif _IsDevice(loc_res)
        return 2 ;slot already occupied
    endif
    return 0
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
            String loc_res = ""
            loc_res += UDMTF.Header("Base details", 4)
            loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
            loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
            loc_res += UDMTF.HeaderSplit()
    
            loc_res += UDMTF.TableRowDetails("Name:", akActor.GetLeveledActorBase().GetName())
            Race loc_race = akActor.getActorBase().GetRace()
            loc_res += UDMTF.TableRowDetails("Race:", loc_race.GetName())
            loc_res += UDMTF.TableRowDetails("Level:", akActor.GetLevel())
            
            loc_res += UDMTF.PageSplit(abForce = False)
            loc_res += UDMTF.LineGap()
            
            loc_res += UDMTF.TableRowDetails("HP:", FormatFloat(akActor.getAV("Health"), 1) + "/" +  FormatFloat(getMaxActorValue(akActor, "Health"), 1) + " (" + Round(getCurrentActorValuePerc(akActor,"Health") * 100) + "%)")
            loc_res += UDMTF.TableRowDetails("MP:", FormatFloat(akActor.getAV("Magicka"), 1) + "/" + FormatFloat(getMaxActorValue(akActor, "Magicka"), 1) + " (" + Round(getCurrentActorValuePerc(akActor,"Magicka") * 100) + "%)")
            loc_res += UDMTF.TableRowDetails("SP:", FormatFloat(akActor.getAV("Stamina"), 1) + "/" +  FormatFloat(getMaxActorValue(akActor, "Stamina"), 1) + " (" + Round(getCurrentActorValuePerc(akActor,"Stamina") * 100) + "%)")
            
            loc_res += UDMTF.PageSplit(abForce = False)
            loc_res += UDMTF.LineGap()
        
            if UDmain.UDAI.Enabled && !IsPlayer(akActor)
                loc_res += UDMTF.TableRowDetails("Motivation:", getMotivation(akActor))
                loc_res += UDMTF.TableRowDetails("AI Cooldown:", iUnsig(GetAIRemainingCooldown(akActor)) + " min")
                loc_res += UDMTF.PageSplit(abForce = False)
                loc_res += UDMTF.LineGap()
            endif
            loc_res += UDMTF.TableRowDetails("Arousal:", FormatFloat(OrgasmSystem.GetOrgasmVariable(akActor,8),1))
            loc_res += UDMTF.TableRowDetails("Orgasm progress:", FormatFloat(OrgasmSystem.GetOrgasmProgress(akActor,1) * 100,2) + "%")
            
            loc_res += UDMTF.FooterSplit()
            loc_res += UDMTF.TableEnd()
            loc_res += UDMTF.FontEnd()
                
            UDMain.ShowMessageBox(loc_res, UDMTF.HasHtmlMarkup())
        elseif loc_option == 1 ;skills
            String loc_res = ""
            loc_res += UDMTF.Header("Skill details", 4)
            loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
            loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
            loc_res += UDMTF.HeaderSplit()
            if IsRegistered(akActor)
                UD_CustomDevice_NPCSlot loc_slot = GetNPCSlot(akActor)
                if loc_slot
                    loc_res += UDMTF.TableRowDetails("Agility skill:", Round(loc_slot.AgilitySkill))
                    loc_res += UDMTF.TableRowDetails("Strength skill:", Round(loc_slot.StrengthSkill))
                    loc_res += UDMTF.TableRowDetails("Magicka skill:", Round(loc_slot.MagickSkill))
                    loc_res += UDMTF.TableRowDetails("Cutting skill:", Round(loc_slot.CuttingSkill))
                else
                    loc_res += UDMTF.TableRowDetails("Agility skill:", Round(UDmain.UDSKILL.getAgilitySkill(akActor)))
                    loc_res += UDMTF.TableRowDetails("Strength skill:", Round(UDmain.UDSKILL.getStrengthSkill(akActor)))
                    loc_res += UDMTF.TableRowDetails("Magicka skill:", Round(UDmain.UDSKILL.getMagickSkill(akActor)))
                    loc_res += UDMTF.TableRowDetails("Cutting skill:", Round(UDmain.UDSKILL.getCuttingSkill(akActor)))
                endif
            else
                loc_res += UDMTF.TableRowDetails("Agility skill:", Round(UDmain.UDSKILL.getAgilitySkill(akActor)))
                loc_res += UDMTF.TableRowDetails("Strength skill:", Round(UDmain.UDSKILL.getStrengthSkill(akActor)))
                loc_res += UDMTF.TableRowDetails("Magicka skill:", Round(UDmain.UDSKILL.getMagickSkill(akActor)))
                loc_res += UDMTF.TableRowDetails("Cutting skill:", Round(UDmain.UDSKILL.getCuttingSkill(akActor)))
            endif
            
            loc_res += UDMTF.FooterSplit()
            loc_res += UDMTF.TableEnd()
            loc_res += UDMTF.FontEnd()
            
            UDmain.ShowMessageBox(loc_res, UDMTF.HasHtmlMarkup())
        elseif loc_option == 2 ;arousal/orgasm details
            String loc_res = ""
            loc_res += UDMTF.Header("Orgasm details", 4)
            loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
            loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
            loc_res += UDMTF.HeaderSplit()
            
            loc_res += UDMTF.TableRowDetails("State:", _UDOM.GetHornyLevelString(akActor))
            loc_res += UDMTF.TableRowDetails("Horny level:", FormatFloat(OrgasmSystem.GetOrgasmVariable(akActor,14),2))
            
            loc_res += UDMTF.TableRowDetails("Active vibrators:", GetActivatedVibrators(akActor))
            loc_res += UDMTF.TableRowDetails("Vibrators strength:", StorageUtil.GetIntValue(akActor,"UD_ActiveVib_Strength",0))
            
            loc_res += UDMTF.PageSplit(abForce = False)
            loc_res += UDMTF.LineGap()
            
            loc_res += UDMTF.TableRowDetails("Arousal:", FormatFloat(OrgasmSystem.GetOrgasmVariable(akActor,8),1))
            loc_res += UDMTF.TableRowDetails("Arousal Rate(M):", FormatFloat(OrgasmSystem.GetOrgasmVariable(akActor,9)*OrgasmSystem.GetOrgasmVariable(akActor,10),1))
            loc_res += UDMTF.TableRowDetails("Arousal Rate Mult:", Round(OrgasmSystem.GetOrgasmVariable(akActor,10)*100))
            
            loc_res += UDMTF.PageSplit(abForce = False)
            loc_res += UDMTF.LineGap()
            
            loc_res += UDMTF.TableRowDetails("Orgasm capacity:", Round(OrgasmSystem.GetOrgasmVariable(akActor,5)))
            loc_res += UDMTF.TableRowDetails("Orgasm resistance(M):", FormatFloat(OrgasmSystem.GetOrgasmVariable(akActor,3)*OrgasmSystem.GetOrgasmVariable(akActor,4),1))
            loc_res += UDMTF.TableRowDetails("Orgasm resisting:", Round(OrgasmSystem.GetOrgasmVariable(akActor,4)*100.0) + "%")
            loc_res += UDMTF.TableRowDetails("Orgasm progress:", FormatFloat(OrgasmSystem.GetOrgasmProgress(akActor,1) * 100,2) + "%")
            loc_res += UDMTF.TableRowDetails("Orgasm rate:", FormatFloat(OrgasmSystem.GetOrgasmVariable(akActor,1),2) + " - " + FormatFloat(OrgasmSystem.GetAntiOrgasmRate(akActor),2) + " Op/s")
            loc_res += UDMTF.TableRowDetails("Orgasm mult:", Round(OrgasmSystem.GetOrgasmVariable(akActor,2)*100.0) + "%")

            ;if isRegistered(akActor)
            ;    loc_orgStr += "Orgasm exhaustion: " + _UDOM.GetOrgasmExhaustion(akActor) + "\n"
            ;    if !IsPlayer(akActor)
            ;        UD_CustomDevice_NPCSlot loc_slot = GetNPCSlot(akActor)
            ;        if loc_slot
            ;            loc_orgStr += "Orgasm exhaustion dur.: " + loc_slot.GetOrgasmExhaustionDuration() + " s\n"
            ;        endif
            ;    endif
            ;endif
            
            loc_res += UDMTF.FooterSplit()
            loc_res += UDMTF.TableEnd()
            loc_res += UDMTF.FontEnd()
            
            UDmain.ShowMessageBox(loc_res, UDMTF.HasHtmlMarkup())
        elseif loc_option == 3 ;Helper details
            ShowHelperDetails(akActor)
        elseif loc_option == 4 ;other details
            Weapon loc_sharpestWeapon = getSharpestWeapon(akActor)
            String loc_res = ""
            loc_res += UDMTF.Header("Other", 4)
            loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
            loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
            loc_res += UDMTF.HeaderSplit()
            
            if loc_sharpestWeapon
                loc_res += UDMTF.TableRowDetails("Sharpest weapon:", loc_sharpestWeapon.getName())
                loc_res += UDMTF.TableRowDetails("Cutting bonus:", FormatFloat(getActorCuttingWeaponMultiplier(akActor)*100.0 - 100.0,0) + "%")
            else
                loc_res += UDMTF.TableRowDetails("Sharpest weapon:", "NONE", UDMTF.PercentToGrayscale(0))
            endif
            
            loc_res += UDMTF.FooterSplit()
            loc_res += UDMTF.TableEnd()
            loc_res += UDMTF.FontEnd()
            
            UDmain.ShowMessageBox(loc_res, UDMTF.HasHtmlMarkup())
        else
            return
        endif
        if !UDmain.IsContainerMenuOpen() && !UDmain.IsInventoryMenuOpen()
            Utility.wait(0.01)
        endif
    endwhile
EndFunction

Function ShowHelperDetails(Actor akActor)
    String loc_res = ""
    loc_res += UDMTF.Header("Helper details", 4)
    loc_res += UDMTF.FontBegin(aiFontSize = UDMTF.FontSize, asColor = UDMTF.TextColorDefault)
    loc_res += UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 140)
    loc_res += UDMTF.HeaderSplit()
    
    loc_res += UDMTF.TableRowDetails("Helper level:", GetHelperLVL(akActor))
    loc_res += UDMTF.TableRowDetails("Level progress:", Round(GetHelperLVLProgress(akActor)*100) + "%")
    loc_res += UDMTF.TableRowDetails("Base cooldown:", Round(_CalculateHelperCD(akActor)*24*60) + " min")
                
    if UDmain.Player != akActor
        loc_res += UDMTF.PageSplit(abForce = False)
        loc_res += UDMTF.LineGap()
        
        float loc_currenttime = Utility.GetCurrentGameTime()
        float loc_cooldowntimeHP = StorageUtil.GetFloatValue(akActor,"UDNPCCD:"+UDmain.Player,0)
        float loc_cooldowntimePH = StorageUtil.GetFloatValue(UDmain.Player,"UDNPCCD:"+akActor,0)
        loc_res += UDMTF.TableRowDetails("Available in (H->P):", iUnsig(Round(((loc_cooldowntimeHP - loc_currenttime)*24*60))) + " min")
        loc_res += UDMTF.TableRowDetails("Available in (P->H):", iUnsig(Round(((loc_cooldowntimePH - loc_currenttime)*24*60))) + " min")
    endif
    
    loc_res += UDMTF.FooterSplit()
    loc_res += UDMTF.TableEnd()
    loc_res += UDMTF.FontEnd()
    
    UDmain.ShowMessageBox(loc_res, UDMTF.HasHtmlMarkup())
EndFunction

;///////////////////////////////////////
;=======================================
;            SKILL FUNCTIONS
;=======================================
;//////////////////////////////////////;
;-Used to return absolute and relative skill values which are used by some minigames

Int Property UD_SkillEfficiency = 1 auto ;% increase per one skill point

;/  Function: getActorCuttingWeaponMultiplier

    Calculates multiplier for cutting minigame. Value is decided by weapon with sharp wapon with most dmg
    
    *Is much faster if NPC is registered, otherwise it will need to search whole inventory*
    
    Parameters:

        akActor         - Actor to check
        
    Returns:

        Actors smithing skill as modifier value. Depends on MCM setting and amount of skill
/;
Float Function getActorCuttingWeaponMultiplier(Actor akActor)
    float loc_res = 1.0 ;100%
    
    Weapon loc_bestWeapon = getSharpestWeapon(akActor)
    
    if loc_bestWeapon
        loc_res += loc_bestWeapon.getBaseDamage()*0.025
    endif
    
    loc_res = Math.Pow(loc_res,1.5)
    
    return fRange(loc_res,1.0,3.0)
EndFunction

;/  Function: getSharpestWeapon

    Parameters:

        akActor         - Actor to check
        
    Returns:

        Weapong with most damage
/;
Weapon Function getSharpestWeapon(Actor akActor)
    return UD_Native.GetSharpestWeapon(akActor)
EndFunction

;/  Function: isSharp

    Parameters:

        akWeapon         - Weapon to check
        
    Returns:

        True if weapon is sharp
/;
bool Function isSharp(Weapon akWeapon)
    bool     loc_cond = false
    int        loc_type = akWeapon.GetWeaponType()
    loc_cond = loc_cond || (loc_type > 0 && loc_type < 4) ;swords, daggers, war axes
    loc_cond = loc_cond || (loc_type == 5) ;great swords
    loc_cond = loc_cond || (loc_type == 6) ;battleaxes and warhammers
    return loc_cond
EndFunction

;/  Function: ActorBelted

    Parameters:

        akActor - Actor to check
        
    Returns:

        --- Code
        |===========================================================|
        |   returns |           Meaning                             |
        |===========================================================|
        |    00     =     Actor is not belted                       |
        |    01     =     Actor is belted, anal is not accessible   |
        |    02     =     Actor is belted, anal is accessible       |
        |===========================================================|
        ---
/;
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
            UDmain.Error("ActorBelted("+getActorName(akActor)+") - actor have belt keyword but doesn't have belt!")
        endif
    EndIf
    return loc_res
EndFunction

;/  Function: GetActivatedVibrators

    Parameters:

        akActor - Actor to check
        
    Returns:

        Number of active vibrators
/;
Int Function GetActivatedVibrators(Actor akActor)
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
    
    _ApplyLockpickSkillMult(UDmain.Player)
    
    RegisterForMenu("Lockpicking Menu")
    
    _LockPickContainer.activate(UDmain.Player)
EndFunction

;detect when the lockpick minigame ends
bool Property LockpickMinigameOver      = false auto hidden
int  Property LockpickMinigameResult    = 0     auto hidden
Event OnMenuClose(String MenuName)
    Int loc_destroyed = Round(UD_Native.GetLockpickVariable(8))
    if (loc_destroyed < UD_LockpicksPerMinigame)
        if !_LockPickContainer.IsLocked()
            LockpickMinigameResult = 1 ;player succesfully finished minigame
        elseif loc_destroyed == 0
            LockpickMinigameResult = 0 ;player exited minigame before trying to pick the lock
        else
            LockpickMinigameResult = 2 ;player aborted minigame after breaking at least one lockpick
        endif
    else
        LockpickMinigameResult = 2 ;player tried to lockpick the device but failed (all lockpicks broke)
    endif
    
    _RemoveLockpickSkillMult(UDmain.Player)
    
    LockpickMinigameOver = True
    UnregisterForAllMenus()
EndEvent

Function _ApplyLockpickSkillMult(Actor akActor)
    if UD_MinigameLockpickSkillAdjust == 0
        akActor.AddPerk(UDlibs.LockpickPerk00)
    elseif UD_MinigameLockpickSkillAdjust == 1
        akActor.AddPerk(UDlibs.LockpickPerk10)
    elseif UD_MinigameLockpickSkillAdjust == 2
        akActor.AddPerk(UDlibs.LockpickPerk25)
    elseif UD_MinigameLockpickSkillAdjust == 3
        akActor.AddPerk(UDlibs.LockpickPerk50)
    endif
EndFunction

Function _RemoveLockpickSkillMult(Actor akActor)
    akActor.RemovePerk(UDlibs.LockpickPerk00)
    akActor.RemovePerk(UDlibs.LockpickPerk10)
    akActor.RemovePerk(UDlibs.LockpickPerk25)
    akActor.RemovePerk(UDlibs.LockpickPerk50)
EndFunction


;/  Function: GetHeavyBondageKeyword

    Parameters:

        akDevice - *Render* device to check
        
    Returns:

        Heavy bondage Keyword that the passed *akDevice* have
/;
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
            UDmain.Error("UDCustomDeiceMain::GetDeviceStruggleKeywords() No keyword for heavy bondage on " + akDevice)
        Else
            result = PapyrusUtil.PushString(result, hb)
        EndIf
    Else
        result = GetDeviousKeywords(akDevice)
    EndIf
    if UDmain.TraceAllowed()
        UDmain.Log("UDCustomDeviceMain::GetDeviceStruggleKeywords() " + akDevice + " : " + result, 3)
    endif
    Return result
EndFunction

;/  Group: Device getters
    Functions for getting devices from actors
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: getDeviceByInventory

    Utility script for fetching UD device scripts

    Parameters:
        
        akActor             - Actor to check
        akDeviceInventory   - *Inventory* device to check
        
    Returns:

        First device script which uses *akDeviceInventory*. Returns none if device is not present
/;
UD_CustomDevice_RenderScript Function getDeviceByInventory(Actor akActor, Armor akDeviceInventory)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getDeviceByInventory(akDeviceInventory)
    else
        return getDeviceScriptByRender(akActor,StorageUtil.GetFormValue(akActor, "UD_RenderDevice" + akDeviceInventory, none) as Armor)
    endif
EndFunction

;/  Function: getDeviceByRender

    Utility script for fetching UD device scripts

    Parameters:
        
        akActor             - Actor to check
        akDeviceRendered    - *Render* device to check
        
    Returns:

        First device script which uses *akDeviceRendered*. Returns none if device is not present
/;
UD_CustomDevice_RenderScript Function getDeviceByRender(Actor akActor, Armor akDeviceRendered)
    if isRegistered(akActor)
        UD_CustomDevice_RenderScript loc_device = getNPCSlot(akActor).getDeviceByRender(akDeviceRendered)
        if loc_device
            return loc_device
        else
            return getDeviceScriptByRender(akActor,akDeviceRendered)
        endif
    else
        return getDeviceScriptByRender(akActor,akDeviceRendered)
    endif
EndFunction

;returns first device which have connected corresponding Inventory Device,uses fetch funtion
UD_CustomDevice_RenderScript Function FetchDeviceByInventory(Actor akActor, Armor deviceInventory)
    return getDeviceScriptByRender(akActor,StorageUtil.GetFormValue(deviceInventory, "UD_RenderDevice", none) as Armor)
EndFunction

;/  Function: getHeavyBondageDevice

    Utility script for fetching UD device scripts

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        First device script which uses Heavy Bondage keyword. Returns none if device is not present
/;
UD_CustomDevice_RenderScript Function getHeavyBondageDevice(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).UD_HandRestrain
    else
        return getDeviceScriptByKw(akActor,libs.zad_deviousHeavyBondage)
    endif
EndFunction

;/  Function: getMinigameDevice

    Utility script for fetching UD device scripts

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        First device script which is currently in minigame. Returns none if device is not present
/;
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

;/  Function: getDeviceByKeyword

    Utility script for fetching UD device scripts

    Parameters:
        
        akActor     - Actor to check
        akKeyword   - Keyword to check
        
    Returns:

        First device script which have main keyword set to *akKeyword*. Returns none if device is not present
/;
UD_CustomDevice_RenderScript Function getDeviceByKeyword(Actor akActor,keyword akKeyword)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getDeviceByKeyword(akKeyword)
    else
        return getDeviceScriptByKw(akActor,akKeyword)
    endif
EndFunction

;/  Function: getFirstDeviceByKeyword

    Utility script for fetching UD device scripts

    Note: Keywords are checked on render device. Main keyword is ignored

    Parameters:
        
        akActor     - Actor to check
        akKwd1      - Render Keyword 1 to check
        akKwd2      - Render Keyword 2 to check
        akKwd3      - Render Keyword 3 to check
        aiMode      - 0 => AND (device needs all provided keyword), 1 => OR (device need one provided keyword)
        
    Returns:

        First device script that meets condition. Returns none if device is not present
        
    See: <getLastDeviceByKeyword>, <getAllDevicesByKeyword>
/;
UD_CustomDevice_RenderScript Function getFirstDeviceByKeyword(Actor akActor,keyword akKwd1,keyword akKwd2 = none,keyword akKwd3 = none, int aiMode = 0)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getFirstDeviceByKeyword(akKwd1,akKwd2,akKwd3,aiMode)
    else
        return getDeviceScriptByKw(akActor,akKwd1)
    endif
EndFunction

;/  Function: getLastDeviceByKeyword

    Utility script for fetching UD device scripts

    Note: Keywords are checked on render device. Main keyword is ignored

    Parameters:
        
        akActor     - Actor to check
        akKwd1      - Render Keyword 1 to check
        akKwd2      - Render Keyword 2 to check
        akKwd3      - Render Keyword 3 to check
        aiMode      - 0 => AND (device needs all provided keyword), 1 => OR (device need one provided keyword)
        
    Returns:

        Last device script that meets condition. Returns none if device is not present
        
    See: <getFirstDeviceByKeyword>, <getAllDevicesByKeyword>
/;
UD_CustomDevice_RenderScript Function getLastDeviceByKeyword(Actor akActor,keyword akKwd1,keyword akKwd2 = none,keyword akKwd3 = none, int aiMode = 0)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getLastDeviceByKeyword(akKwd1,akKwd2,akKwd3,aiMode)
    else
        return getDeviceScriptByKw(akActor,akKwd1)
    endif
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)

;/  Function: getAllDevicesByKeyword

    Utility script for fetching UD device scripts

    Note: Keywords are checked on render device. Main keyword is ignored

    *This function will not work for unregistered actors!*

    Parameters:
        
        akActor     - Actor to check
        akKwd1      - Render Keyword 1 to check
        akKwd2      - Render Keyword 2 to check
        akKwd3      - Render Keyword 3 to check
        aiMode      - 0 => AND (device needs all provided keyword), 1 => OR (device need one provided keyword)
        
    Returns:

        All device script that meets condition. Returns none if device is not present
        
    See: <getFirstDeviceByKeyword>, <getLastDeviceByKeyword>
/;
UD_CustomDevice_RenderScript[] Function getAllDevicesByKeyword(Actor akActor,keyword akKwd1,keyword akKwd2 = none,keyword akKwd3 = none, int aiMode = 0)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getAllDevicesByKeyword(akKwd1,akKwd2,akKwd3,aiMode)
    else
        return MakeNewDeviceSlots()
    endif
EndFunction

;/  Function: getAllActivableDevicesByKeyword

    Utility script for fetching UD device scripts

    Note: Keywords are checked on render device. Main keyword is ignored

    *This function will not work for unregistered actors!*

    Parameters:
        
        akActor             - Actor to check
        abCheckCondition    - ???
        akKwd1              - Render Keyword 1 to check
        akKwd2              - Render Keyword 2 to check
        akKwd3              - Render Keyword 3 to check
        aiMode              - 0 => AND (device needs all provided keyword), 1 => OR (device need one provided keyword)
        
    Returns:

        All device script that meets condition and can be activated. Returns none if device is not present
        
    See: <getFirstDeviceByKeyword>, <getLastDeviceByKeyword>, <getAllDevicesByKeyword>
/;
UD_CustomDevice_RenderScript[] Function getAllActivableDevicesByKeyword(Actor akActor,bool abCheckCondition,keyword akKwd1,keyword akKwd2 = none,keyword akKwd3 = none, int aiMode = 0)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getAllActivableDevicesByKeyword(abCheckCondition,akKwd1,akKwd2,akKwd3,aiMode)
    else
        return MakeNewDeviceSlots()
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
            UDmain.Error("getEquippedRender("+getActorName(akActor)+","+akKeyword+") - actor is registered but device was not found")
            return libs.GetWornRenderedDeviceByKeyword(akActor,akKeyword)
        endif
    else
        return libs.GetWornRenderedDeviceByKeyword(akActor,akKeyword)
    endif
EndFunction

UD_CustomDevice_RenderScript Property _transferedDevice = none auto hidden
UD_CustomDevice_EquipScript Property _transferedDeviceID = none auto hidden
bool _transfereMutex = false
bool _transfereMutexID = false

;/  Function: getDeviceScriptByRender

    Allow to return device script from actor that is not registered.

    *This is done by doing some black magick fuckery*

    Parameters:
        
        akActor             - Actor that have the device equipped
        akDeviceRendered    - *Render* device
        
    Returns:

        Device script. This is not copy but actual script. Because of that it is possible to reregister NPC that unregistered before.
/;
UD_CustomDevice_RenderScript Function getDeviceScriptByRender(Actor akActor,Armor akDeviceRendered)
    if !akDeviceRendered
        UDmain.Error("getDeviceScriptByRender() - deviceRendered = None!!")
        return none
    endif
    
    if !akActor
        UDmain.Error("getDeviceScriptByRender() - akActor = None!!")
        return none
    endif
    
    if akActor.getItemCount(akDeviceRendered) <= 0
        UDmain.Error("getDeviceScriptByRender("+GetActorName(akActor)+") - Actor doesn't have render device!")
        return none
    endif
    
    while _transfereMutex
        Utility.waitMenuMode(0.05)
    endwhile
    
    _transfereMutex = True
    
    _transferedDevice = none
    UD_CustomDevice_RenderScript result = none
    
    if UDmain.TraceAllowed()
        UDmain.Log("getDeviceScriptByRender called for " + akDeviceRendered + "("+getActorName(akActor)+")")
    endif
    
    bool loc_res = UD_Native.GetDeviceScript(akActor,akDeviceRendered,"UDCustomDeviceMain","_transferedDevice")
     
    if !loc_res
       UDMain.Error("Error getting script for " + akDeviceRendered + " on " + akActor)
       return none
    endif
     
    result = _transferedDevice
    
    _transferedDevice = none
        
    _transfereMutex = False
    return result
EndFunction

;/  Function: getDeviceInventoryScriptByID

    Allow to return inventory device script from actor

    *This is done by doing some black magick fuckery*

    Parameters:
        
        akActor             - Actor that have the device equipped
        akDeviceInventory    - *Inventory* device
        
    Returns:

        Inventory Device script. This is not copy but actual script. In case there are multiple instances of same script, only first will be returned
/;
UD_CustomDevice_EquipScript Function getDeviceInventoryScriptByID(Actor akActor,Armor akDeviceInventory)
    if !akDeviceInventory
        UDmain.Error("getDeviceInventoryScriptByID() - deviceRendered = None!!")
        return none
    endif
    
    if !akActor
        UDmain.Error("getDeviceInventoryScriptByID() - akActor = None!!")
        return none
    endif
    
    if akActor.getItemCount(akDeviceInventory) <= 0
        UDmain.Error("getDeviceInventoryScriptByID("+GetActorName(akActor)+") - Actor doesn't have inventory device!")
        return none
    endif
    
    while _transfereMutexID
        Utility.waitMenuMode(0.05)
    endwhile
    
    _transfereMutexID = True
    
    _transferedDeviceID = none
    UD_CustomDevice_EquipScript result = none
    
    if UDmain.TraceAllowed()
        UDmain.Log("getDeviceInventoryScriptByID called for " + akDeviceInventory + "("+getActorName(akActor)+")")
    endif
    
    bool loc_res = UD_Native.GetInventoryDeviceScript(akActor,akDeviceInventory,"UDCustomDeviceMain","_transferedDeviceID")
     
    if !loc_res
       UDMain.Error("Error getting script for " + akDeviceInventory + " on " + akActor)
       return none
    endif
     
    result = _transferedDeviceID
    
    _transferedDeviceID = none
        
    _transfereMutexID = False
    return result
EndFunction

;/  Function: getDeviceScriptByKw

    Same as <getDeviceScriptByRender>, but returns device based on main keyword

    Parameters:
        
        akActor             - Actor that have the device equipped
        akKw                - Main DD keyword
        
    Returns:

        Device script. This is not copy but actual script. Because of that it is possible to reregister NPC that unregistered before.
/;
UD_CustomDevice_RenderScript Function getDeviceScriptByKw(Actor akActor,Keyword akKw)
    if !akActor.wornhaskeyword(akKw)
        return none ;actor doesn't have equipped the device with provided keyword
    endif

    UD_CustomDevice_RenderScript result = none
    while _transfereMutex
        Utility.waitMenuMode(0.05)
    endwhile
    _transfereMutex = True
        Armor deviceRendered = libs.GetWornRenderedDeviceByKeyword(akActor,akKw)
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

;/  Function: getNumberOfDevicesWithKeyword

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor     - Actor to check
        akKwd1      - Render Keyword 1 to check
        akKwd2      - Render Keyword 2 to check
        akKwd2      - Render Keyword 3 to check
        aiMode      - 0 => AND (device needs all provided keyword), 1 => OR (device need one provided keyword)
        
    Returns:

        Number of all device script that meets condition
/;
int Function getNumberOfDevicesWithKeyword(Actor akActor,keyword akKwd1,keyword akKwd2 = none,keyword akKwd3 = none, int aiMode = 0)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getNumberOfDevicesWithKeyword(akKwd1,akKwd2,akKwd2,aiMode)
    endif
    return 0
EndFunction

;/  Function: getNumberOfActivableDevicesWithKeyword

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor             - Actor to check
        abCheckCondition    - ???
        akKwd1              - Render Keyword 1 to check
        akKwd2              - Render Keyword 2 to check
        akKwd2              - Render Keyword 3 to check
        aiMode              - 0 => AND (device needs all provided keyword), 1 => OR (device need one provided keyword)
        
    Returns:

        Number of all device script that meets condition and can be activated
/;
int Function getNumberOfActivableDevicesWithKeyword(Actor akActor,bool abCheckCondition, keyword akKwd1,keyword akKwd2 = none,keyword akKwd3 = none, int aiMode = 0)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getNumberOfActivableDevicesWithKeyword(abCheckCondition,akKwd1,akKwd2,akKwd3,aiMode)
    else
        return 0
    endif
EndFunction

;/  Function: getActiveDevices

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        All device scripts that can be activated
/;
UD_CustomDevice_RenderScript[] Function getActiveDevices(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getActiveDevices()
    else
        return MakeNewDeviceSlots()
    endif
EndFunction

;/  Function: getActiveDevicesNum

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        Number of all device scripts that can be activated
/;
int Function getActiveDevicesNum(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getActiveDevicesNum()
    else
        return 0
    endif
EndFunction

;/  Function: getVibratorNum

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        Number of all vibrators
/;
int Function getVibratorNum(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getVibratorNum()
    else
        return 0
    endif
EndFunction

;/  Function: getOffVibratorNum

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        Number of all turned off vibrators
/;
int Function getOffVibratorNum(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getOffVibratorNum()
    else
        return 0
    endif
EndFunction

;/  Function: getActivableVibratorNum

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        Number of all vibrators that can be activated
/;
int Function getActivableVibratorNum(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getActivableVibratorNum()
    else
        return 0
    endif
EndFunction

;/  Function: getVibrators

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        Array of all vibrators
/;
UD_CustomDevice_RenderScript[] Function getVibrators(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getVibrators()
    endif
    return none
EndFunction

;/  Function: getOffVibrators

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        Array of all turned off vibrators
/;
UD_CustomDevice_RenderScript[] Function getOffVibrators(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getOffVibrators()
    endif
    return none
EndFunction

;/  Function: getActivableVibrators

    *This function will not work is akActor is no registered*

    Parameters:
        
        akActor             - Actor to check
        
    Returns:

        Array of all vibrators that can be activated
/;
UD_CustomDevice_RenderScript[] Function getActivableVibrators(Actor akActor)
    if isRegistered(akActor)
        return getNPCSlot(akActor).getActivableVibrators()
    endif
    return none
EndFunction

;/  Group: Utility
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: ChangeSoulgemState

    Changes state of one of the actors soulgems

    Parameters:
        
        akActor             - Actor to check
        aiSoulgemType       - Type of soulgem (0=Petty,1=Lesser,2=Common,3=Great,4=Grand)
        abState             - True = Discharge, False = Charge

    Returns:

        True if operation was succesfull
/;
bool Function ChangeSoulgemState(Actor akActor,Int aiSoulgemType,bool abState = true)
    if !akActor
        return false
    endif
    if aiSoulgemType > 4 || aiSoulgemType < 0
        return false
    endif
    
    if abState ;discharge
        if aiSoulgemType == 0
            akActor.removeItem(UDlibs.FilledSoulgem_Petty,1,true)
            akActor.AddItem(UDlibs.EmptySoulgem_Petty,1,true)
        elseif aiSoulgemType == 1
            akActor.removeItem(UDlibs.FilledSoulgem_Lesser,1,true)
            akActor.AddItem(UDlibs.EmptySoulgem_Lesser,1,true)
        elseif aiSoulgemType == 2
            akActor.removeItem(UDlibs.FilledSoulgem_Common,1,true)
            akActor.AddItem(UDlibs.EmptySoulgem_Common,1,true)
        elseif aiSoulgemType == 3
            akActor.removeItem(UDlibs.FilledSoulgem_Great,1,true)
            akActor.AddItem(UDlibs.EmptySoulgem_Great,1,true)
        elseif aiSoulgemType == 4
            akActor.removeItem(UDlibs.FilledSoulgem_Grand,1,true)
            akActor.AddItem(UDlibs.EmptySoulgem_Grand,1,true)
        endif
    else    ;charge
        if aiSoulgemType == 0
            akActor.removeItem(UDlibs.EmptySoulgem_Petty,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Petty,1,true)
        elseif aiSoulgemType == 1
            akActor.removeItem(UDlibs.EmptySoulgem_Lesser,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Lesser,1,true)
        elseif aiSoulgemType == 2
            akActor.removeItem(UDlibs.EmptySoulgem_Common,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Common,1,true)
        elseif aiSoulgemType == 3
            akActor.removeItem(UDlibs.EmptySoulgem_Great,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Great,1,true)
        elseif aiSoulgemType == 4
            akActor.removeItem(UDlibs.EmptySoulgem_Grand,1,true)
            akActor.AddItem(UDlibs.FilledSoulgem_Grand,1,true)
        endif
    endif
    return true
EndFunction

Message Property UD_SoulgemSelect_MSG auto

;/  Function: ShowSoulgemMessage

    Opens menu that allow user to select which soulgem they want to use

    If *akActor* doesn't have the soulgem, it will not show

    Parameters:
        
        akActor             - Actor to check
        abEmpty             - True=Player choose empty soulgem, False=Player choose filled soulgem
        
    Returns:

        0=Petty,1=Lesser,2=Common,3=Great,4=Grand
/;
Int Function ShowSoulgemMessage(Actor akActor,Bool abEmpty = false)
    ;precheck
    resetCondVar()
    if !abEmpty
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

Function sendSentientDialogueEvent(string type,int force)
    SendModEvent("UD_SentientDialogue", type, force as float)
EndFunction

Function sendHUDUpdateEvent(bool abFlashCall,bool abStamina,bool abHealth,bool abMagicka)
    int handle = ModEvent.Create("UD_UpdateHud")
    if (handle)
        ModEvent.PushInt(handle,abFlashCall as Int) ;actor
        ModEvent.PushInt(handle, abStamina as Int) ;value
        ModEvent.PushInt(handle, abHealth as Int) ;value
        ModEvent.PushInt(handle, abMagicka as Int) ;value
        ModEvent.Send(handle)
    endIf
EndFunction

Function updateHUDBars(Int abFlashCall,Int abStamina,Int abHealth,Int abMagicka)
    if abFlashCall
        UI.SetBool("HUD Menu", "_root.HUDMovieBaseInstance.Stamina._visible",True)
        UI.SetBool("HUD Menu", "_root.HUDMovieBaseInstance.Health._visible",True)
        UI.SetBool("HUD Menu", "_root.HUDMovieBaseInstance.Magica._visible",True)
    endif
    
    if abStamina
        UDmain.Player.damageAV("Stamina",  0.1)
        UDmain.Player.restoreAV("Stamina",  0.1)
    endif
    
    if abHealth
        UDmain.Player.damageAV("Health",  0.1)
        UDmain.Player.restoreAV("Health",  0.1)
    endif
    
    if abMagicka
        UDmain.Player.damageAV("Magicka",  0.1)
        UDmain.Player.restoreAV("Magicka",  0.1)
    endif
EndFunction

UD_CustomVibratorBase_RenderScript _startVibFunctionPackage = none

;/  Function: startVibFunction

    Makes passed *akCustomVibrator* to vibrate

    Parameters:
        
        akCustomVibrator    - Vibrator which will be turned on
        abBlocking          - If function should be blocked untill vibrations fully start

    Returns:

        True if operation was succesfull
/;
bool Function startVibFunction(UD_CustomVibratorBase_RenderScript akCustomVibrator,bool abBlocking = false)
    if !akCustomVibrator
        UDmain.Error("UDCustomDeiceMain::startVibFunction(NONE) - Can't start vibration because passed vibrator is NONE!!")
        return false
    endif
    if !akCustomVibrator.canVibrate()
        UDmain.Error("UDCustomDeiceMain::startVibFunction("+akCustomVibrator.getDeviceHeader()+") - Passed device can't vibrate!")
        return false
    endif
    
    while _startVibFunctionPackage
        Utility.waitMenuMode(0.1)
    endwhile
    _startVibFunctionPackage = akCustomVibrator
    if UDmain.TraceAllowed()
        UDmain.Log("UDCustomDeiceMain::startVibFunction("+akCustomVibrator.getDeviceHeader()+") - Sending event",3)
    endif
    int handle = ModEvent.Create("UD_StartVibFunction")
    if (handle)
        ModEvent.Send(handle)
    else
        UDmain.Error("UDCustomDeiceMain::startVibFunction("+akCustomVibrator.getDeviceHeader()+") - !!Sending of event failed!!")
        _startVibFunctionPackage = none
        return false
    endif
    if abBlocking
        float loc_elapsedtime = 0.0
        while _startVibFunctionPackage && loc_elapsedtime <= 2.0
            Utility.waitMenuMode(0.1) ;wait untill vib starts
            loc_elapsedtime += 0.1
        endwhile
        if loc_elapsedtime >= 2.0
            UDmain.Error("UDCustomDeiceMain::startVibFunction("+akCustomVibrator.getDeviceHeader()+") - Event timeout")
            return false
        endif
    endif
    return true
EndFunction

Function FetchAndStartVibFunction()
    UD_CustomVibratorBase_RenderScript loc_fetchedPackage = _startVibFunctionPackage
    if UDmain.TraceAllowed()    
        UDmain.Log("startVibFunction() - Received " + loc_fetchedPackage.getDeviceName(),3)
    endif
    _startVibFunctionPackage = none ;free package
    loc_fetchedPackage.vibrate() ;vibrate
EndFunction

;/  Function: getGaggedLevel

    Calculates Gag difficulty level

    Parameters:

        akActor    - Actor to check

    Returns:

        --- Code
        |=======================================|
        |   returns |           Meaning         |
        |=======================================|
        |    00     =     Not gagged            |
        |    01     =     Normal gag            |
        |    02     =     Large gag             |
        |    03     =     Close mouth gag       |
        |=======================================|
        ---
/;
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

Armor Function GetRenderDevice(Armor akInventoryDevice)
    if akInventoryDevice
        return libs.GetRenderedDevice(akInventoryDevice)
    endif
    return none
EndFunction

Function SetArousalPerks()
    if UDMain.OSLArousedInstalled
        OSLLoadOrderRelative = Game.GetModByName("OSLAroused.esp")
        If (OSLLoadOrderRelative > 255)
            OSLLoadOrderRelative -= 256
        endif
        UDmain.Log("Assuming OSL load order: "+OSLLoadOrderRelative,3)
    else
        SLALoadOrder = Game.GetModByName("SexLabAroused.esm")
        UDmain.Log("Assuming SLA load order: "+SLALoadOrder,3)
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

;/  Function: ApplyTearsEffect

    Apply tears overlay to *akActor*

    Note: Requires SlaveTats to work

    Parameters:

        akActor - Actor have effect applied

    Returns:

        True if operation was succesfull
/;
bool Function ApplyTearsEffect(Actor akActor)
    if akActor.Is3DLoaded() && !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZTears_KW)
        UDlibs.ZAZTearsSpell.cast(akActor)
        return true
    endif
    return false
EndFUnction

;/  Function: ApplyDroolEffect

    Apply drool overlay to *akActor*

    Note: Requires SlaveTats to work

    Parameters:

        akActor - Actor have effect applied

    Returns:

        True if operation was succesfull
/;
bool Function ApplyDroolEffect(Actor akActor)
    if akActor.Is3DLoaded() && !akActor.HasMagicEffectWithKeyword(UDlibs.ZAZDrool_KW)
        UDlibs.ZAZDroolSpell.cast(akActor)
        return true
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
    if DesirePerks
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
    endif
    return 1.0
EndFunction

;/  Function: addExhaustion
    Adds struggle exhaustion to actor

    Parameters:

        akActor - Actor to apply effect on
        afMult  - Effect duration multiplier
/;
Function addExhaustion(Actor akActor, float afMult = 1.0)
    if UDmain.TraceAllowed()
        UDmain.Log(self + "::addExhaustion("+akActor+","+afMult+")")
    endif
    if (UDmain.UDGV.UDG_MinigameExhaustion.Value == 1)
        Float loc_Exponent = Math.pow(UD_MinigameExhExponential, getMinigameExhaustion(akActor))
        UDlibs.StruggleExhaustionSpell.SetNthEffectMagnitude(0, UD_StruggleExhaustionMagnitude*UD_MinigameExhMagnitudeMult*RandomFloat(0.75,1.25))
        UDlibs.StruggleExhaustionSpell.SetNthEffectDuration(0, Round(UD_StruggleExhaustionDuration*UD_MinigameExhDurationMult*afMult*RandomFloat(0.75,1.25)*loc_Exponent))
        UDlibs.StruggleExhaustionSpell.cast(akActor)
    endif
EndFunction

;/  Function getMinigameExhaustion
    Gets number of minigame exhaustion debuffs on actor

    Parameters:

        akActor - Actor to check

    Returns:

        Number of active minigame exhaustion effects on the player
/;
Int Function getMinigameExhaustion(Actor akActor)
    return StorageUtil.getIntValue(akActor,"UD_DeviceExhaustionNum")
EndFunction

;/  Function isMinigameExhaustedMax
    Checks whether the actor has more than the configured amount of minigame exhaustion debuffs

    Parameters:

        akActor - Actor to check
    
    Returns:

        False if the actor has less than the set amount of minigame exhaustions, or the set amount is 0. True otherwise.
/;
Bool Function isMinigameExhaustedMax(Actor akActor)
    return UD_MinigameExhNoStruggleMax > 0 && (getMinigameExhaustion(akActor) >= UD_MinigameExhNoStruggleMax)
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

;Injects passed keywords to quest keyword formlist. Devices which will have this keyword will be taken as quest devices
Bool _InjectQuestKeywordMutex = False
Function InjectQuestKeywords(Keyword[] aaList)
    if !aaList
        return
    endif
    
    while _InjectQuestKeywordMutex
        Utility.waitMenuMode(0.1)
    endwhile
    _InjectQuestKeywordMutex = True

    int loc_i = aaList.length
    while loc_i
        loc_i-=1
        UD_QuestKeywords.addForm(aaList[loc_i])
    endwhile

    _InjectQuestKeywordMutex = False
EndFunction

;Update all quest keywords. Is not blocking
Function UpdateQuestKeywords()
    UD_QuestKeywords.Revert()
    SendModEvent("UD_QuestKeywordUpdate")
EndFunction

;Injects passed keys to generic key formlist. Keys in this formlist can be destroyed
Bool _InjectGenericKeysMutex = False
Function InjectGenericKeys(Key[] aaList)
    if !aaList
        return
    endif
    
    while _InjectGenericKeysMutex
        Utility.waitMenuMode(0.1)
    endwhile
    _InjectGenericKeysMutex = True


    int loc_i = aaList.length
    while loc_i
        loc_i-=1
        UD_GenericKeys.addForm(aaList[loc_i])
    endwhile

    _InjectGenericKeysMutex = False
EndFunction

;Update all generic keys. Is not blocking
Function UpdateGenericKeys()
    UD_GenericKeys.Revert()
    SendModEvent("UD_GenericKeyUpdate")
EndFunction

;/  Function: KeyIsGeneric

    Parameters:

        akKey - Key to check

    Returns:

        True if key is generic (can be destroyed)
/;
Bool Function KeyIsGeneric(Key akKey)
    return UD_GenericKeys.HasForm(akKey)
EndFunction

Function _PrintFormList(FormList akList)
    UDmain.Info("===Showing content of " + akList + " ===")
    Int loc_size = akList.GetSize()
    while loc_size
        loc_size -= 1
        UDmain.Info(akList.GetAt(loc_size))
    endwhile
EndFunction

;function used for mod development
Function DebugFunction(Actor akActor)
    UDmain.UDAbadonQuest.AbadonEquipSuit(akActor,0)
    ;UDmain.UDRRM.LockAllSuitableRestrains(akActor,false,0xffffffff)
EndFunction

float _startTime = 0.0
Function StartRecordTime()
    _startTime = Utility.GetCurrentRealTime()
EndFunction

float Function FinishRecordTime(string strObject = "",bool bReset = false,bool bLog = true,bool bPrint = true)
    float loc_res = Utility.GetCurrentRealTime() - _startTime
    
    UDmain.CLog("[T1]: ElapsedTime for "+ strObject + " = " + loc_res)
    
    if bLog
        debug.trace("[UD]: [T1]: ElapsedTime for "+ strObject + " = " + loc_res)
        ;UDmain.Log("Elapsed time for " + strObject + " = " + loc_res + " s",1)
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
    
    UDmain.CLog("[T2]: ElapsedTime for "+ strObject + " = " + loc_res)
    
    if bLog
        debug.trace("[UD]: [T2]: ElapsedTime for "+ strObject + " = " + loc_res)
        ;UDmain.Log("Elapsed time for " + strObject + " = " + loc_res + " s",1)
    endif
    if bPrint
        debug.notification("[T2]: ElapsedTime for "+ strObject + " = " + loc_res)
    endif
    
    if bReset
        StartRecordTime2()
    endif
    return loc_res
EndFunction

;/  Function: ReduceKeyDurability

    Changes key durability by *aiDurability*.
    
    Destroys key once durability reaches 0.

    Parameters:

        akActor         - Actor to process
        akKey           - Key to check
        aiDurability    - By how much (can be both positive and negative)

    Returns:

        Durability after it is updated
/;
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

;distribute lock shields betweeen locks, returns array of distributed lock shields which corresponds to number of locks
Int[] Function DistributeLockShields(Int aiLockNum, Int aiLockShieldNum)
    if aiLockNum < 0
        aiLockNum = 0
    endif
    
    Int[] loc_res = Utility.CreateIntArray(aiLockNum)

    While aiLockShieldNum
        loc_res[RandomInt(0,loc_res.length - 1)] = loc_res[RandomInt(0,loc_res.length - 1)] + 1 ;add one shield to random lock
        aiLockShieldNum -= 1
    endwhile
    
    return loc_res
EndFunction

;/  Function: ManifestDevices

    Locks actor in specific number of device
    Parameters:

        akActor         - Actor to lock device on
        asSource        - string which will be printed as source of device manifest
        aiChance        - Chance devices will be manifested (0-100)

    Returns:

        Number of devices locked
/;
int Function ManifestDevices(Actor akActor,string asSource ,int aiChance,int aiNumber)
    Form[] loc_array
    if aiChance == 100 || RandomInt(1,99) < aiChance
        while aiNumber
            while UDmain.UDOM.isOrgasming(akActor)
                Utility.wait(0.1)
            endwhile
            aiNumber -= 1
            Armor loc_device = UDmain.UDRRM.LockRandomRestrain(akActor)
            if loc_device
                loc_array = PapyrusUtil.PushForm(loc_array,loc_device)
            else
                aiNumber = 0 ;end, because no more devices can be locked
            endif
        endwhile
    endif
    if loc_array
        if loc_array.length > 0
            if IsPlayer(akActor)
                UDmain.Print(asSource + " suddenly locks you in bondage restraint!",1)
                ;/
                string loc_str = "Devices locked: \n"
                int i = 0
                while i < loc_array.length
                    loc_str += (loc_array[i] as Armor).getName() + "\n"
                    i+= 1
                endwhile
                ShowMessageBox(loc_str)
                /;
            elseif AllowNPCMessage(akActor)
                UDmain.Print(GetActorName(akActor) + "s "+ asSource +" suddenly locks them in bondage restraint!",3)
            endif
        endif
    endif
    if loc_array
        return loc_array.length
    else
        return 0
    endif
EndFunction

ReferenceAlias property UD_PlayerFollowerLongAlias1 auto
ReferenceAlias property UD_PlayerFollowerLongAlias2 auto
Actor _playerfollower1 = none
Actor _playerfollower2 = none

;/  Function: SetPlayerFollower

    Forces NPC to followe player. This also stops any packages/idles
    Copied from ORomance
    
    Parameters:

        akActor         - Actor which will follow player
        abFollow        - If actor should start or stop following player
        aiAliasIndex    - Which slot to use. By default there are 2 slots, so player can have 2 following actors at once. Valid values are 1 and 2
/;
function SetPlayerFollower(actor akActor, bool abFollow, int aiAliasIndex = 1) ; follower in literal sense, not combat ally
    if IsPlayer(akActor)
        return
    endif

    ReferenceAlias loc_alias
    if aiAliasIndex == 1
        loc_alias = UD_PlayerFollowerLongAlias1
    elseif aiAliasIndex == 2
        loc_alias = UD_PlayerFollowerLongAlias2
    endif 

    if abFollow
        loc_alias.ForceRefTo(akActor)
        if aiAliasIndex == 1
            _playerfollower1 = akActor
        elseif aiAliasIndex == 2
            _playerfollower2 = akActor
        endif
    Else
        loc_alias.clear()
        if aiAliasIndex == 1
            _playerfollower1 = none
        elseif aiAliasIndex == 2
            _playerfollower2 = none
        endif 
    endif

    akActor.EvaluatePackage()
EndFunction

;/  Function: IsFollowingPlayer

    Parameters:

        akActor         - Actor to check
        
    Returns:
        True if actor is following player
/;
Bool Function IsFollowingPlayer(Actor akActor)
    return akActor && ((akActor == _playerfollower1) || (akActor == _playerfollower2))
EndFunction

Function DeviceLockIssueReport(Actor akActor,Armor akDevice, Int aiError)
    
    Int     loc_severity    = 0
    String  loc_reason      = ""
    
    if aiError == 0
        ; No issue ?
    elseif aiError == 1
        loc_severity    = 3
        loc_reason      = "Render device already present in inventory"
    elseif aiError == 2
        loc_severity    = 2
        loc_reason      = "Wearing conflicting device type"
    elseif aiError == 3
        loc_severity    = 2
        loc_reason      = "Wearing conflicting device"
    elseif aiError == 4
        loc_severity    = 1
        loc_reason      = "Player refused to equip device"
    elseif aiError == 5
        loc_severity    = 1
        loc_reason      = "Equip Filter activated"
    elseif aiError == 6
        loc_severity    = 3
        loc_reason      = "Render device doesn't have UD keyword!"
    elseif aiError == 7
        loc_severity    = 3
        loc_reason      = "Other fatal issue"
    elseif aiError == 8
        loc_severity    = 3
        loc_reason      = "Mutex timeout"
    else
        ; Other issue ?
    endif

    if loc_severity > 0
        if loc_severity == 1
            UDmain.Info("Locking device failed - Actor="+GetActorName(akActor)+" Device="+akDevice.getName()+" Reason=" + loc_reason)
        elseif loc_severity == 2
            if UDmain.UD_WarningAllowed
                UDmain.Warning("Locking device failed - Actor="+GetActorName(akActor)+" Device="+akDevice.getName()+" Reason=" + loc_reason)
            endif
        elseif loc_severity == 3
            UDmain.Error("!!Locking device failed!! Actor="+GetActorName(akActor)+" Device="+akDevice.getName()+" Reason=" + loc_reason)
        endif
    endif

EndFunction