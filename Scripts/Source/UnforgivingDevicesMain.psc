;   File: UnforgivingDevicesMain
;   This is main script of Unforgiving Devices, which contains most important functions and propertiest filled with references to other scripts
Scriptname UnforgivingDevicesMain extends Quest  conditional
{Main script of Unforgiving Devices}

import UD_Native

Quest       Property UD_UtilityQuest    auto
Quest       Property UD_LibsQuest       auto

Actor Property Player auto hidden

zadBQ00 property zadbq
    zadBQ00 Function get()
        return (libs as Quest) as zadBQ00
    EndFunction
EndProperty
zadBoundCombatScript_UDPatch Property BoundCombat Hidden
    zadBoundCombatScript_UDPatch Function get()
        return libs.BoundCombat as zadBoundCombatScript_UDPatch
    EndFunction
EndProperty

bool    Property UD_OrgasmExhaustion            = True  auto
float   Property UD_OrgasmExhaustionMagnitude   = 0.0   auto
int     Property UD_OrgasmExhaustionDuration    = 50    auto

Float   Property UD_GamePadMenuWaitTime         = 0.25  auto

bool Property UD_AutoLoad = false auto


;/  Group: Modules
===========================================================================================
===========================================================================================
===========================================================================================
/;

;   Variable: libs
zadlibs                             property libs           auto

;/  Variable: libsp
    Patched version of <libs>. Should be used for calling DD functions, instead of <libs>
/;
zadlibs_UDPatch                     property libsp                  hidden
    zadlibs_UDPatch Function get()
        return libs as zadlibs_UDPatch
    EndFunction
EndProperty

;   Variable: libsx
zadxlibs                            property libsx          auto
;   Variable: libsx2
zadxlibs2                           property libsx2         auto
;   Variable: libsc
zadclibs                            property libsc          auto

;/  Variable: UDlibs
    This module contains many mod related properties, like abadon devices, utility items (lockpick, gold..), etc...
/;
UD_libs                             Property UDlibs         auto

;/  Variable: UDCDmain
    This module contains funtions for manipulating devices. See <UDCustomDeviceMain>
/;
UDCustomDeviceMain                  Property UDCDmain       auto

;/  Variable: UDAbadonQuest
    Abadon quest script
/;
UD_AbadonQuest_script               Property UDAbadonQuest  auto

;/  Variable: config
    MCM setting
/;
UD_MCM_script                       Property config         Auto

;/  Variable: ItemManager
    This module contains functionality for equipping abadon sets
/;
UDItemManager                       Property ItemManager    auto

;/  Variable: UDRRM
    
    Meaning: Random Restrain Manager
    
    This module contains functionality for locking random devices on actors. See <UD_RandomRestraintManager>
/;
UD_RandomRestraintManager           Property UDRRM          auto

;/  Variable: UDLLP
    
    Meaning: Leveled List Patcher
    
    This module contains functionality for injecting forms to leveled lists
/;
UD_LeveledList_Patcher              Property UDLLP          auto

; DO NOT USE
UD_ExpressionManager                Property UDEM           auto

UD_ParalelProcess                   Property UDPP           auto

;/  Variable: UDNPCM
    
    Meaning: NPC Manager
    
    This module contains functionality for manipulating NPC slots
/;
UD_CustomDevices_NPCSlotsManager    Property UDNPCM         auto

UD_MutexManagerScript               Property UDMM           auto

;/  Variable: UDMOM
    
    Meaning: Modifier Manager
    
    This module contains functionality calculations for device modifiers
/;
UD_ModifierManager_Script           Property UDMOM          auto

;/  Variable: UDOTM
    
    Meaning: Outfit Manager
    
    This module contains functionality for custom outfits
/;
UD_OutfitManager                    Property UDOTM          auto


;/  Variable: UDUI
    
    Meaning: User Input
    
    This module contains functionality for getting user input
/;
UD_UserInputScript                  Property UDUI           auto

;/  Variable: UDAM
    
    Meaning: Animation Manager
    
    This module contains functionality for manipulating animations. See <UD_AnimationManagerScript>
/;
UD_AnimationManagerScript           Property UDAM           auto

UD_CompatibilityManager_Script      Property UDCM           auto

;/  Variable: UDAI
    
    Meaning: Artifical inteligence
    
    This module contains calculations for AI
/;
UD_NPCInteligence                   Property UDAI           auto

;/  Variable: UDUIE
    
    Meaning: UI Extensions
    
    This module contains functions for opening some UI extension menus
/;
UD_UIEManager                       Property UDUIE          auto

;/  Variable: UDMC
    
    Meaning: Menu checker
    
    This module contains functions for fastly checking if menu is open. See <UD_MenuChecker>
/;
UD_MenuChecker                      Property UDMC Hidden
    UD_MenuChecker Function get() 
        return UD_UtilityQuest as UD_MenuChecker
    EndFunction
EndProperty

;/  Variable: UDWC
    
    Meaning: Widget Control
    
    This module contains functions for manipulating widgets. See <UD_WidgetControl>
/;
UD_WidgetControl                    Property UDWC           Auto

;/  Variable: UDGV
    
    Meaning: Global Variable
    
    This module contains properties with global variables. See <UD_GlobalVariables>
/;
UD_GlobalVariables                  Property UDGV Hidden
    UD_GlobalVariables Function get()
        return UD_UtilityQuest as UD_GlobalVariables
    EndFunction
EndProperty

;/  Variable: UDSKILL
    This module contains functions gettings actors UD skills
/;
UD_SkillManager_Script              Property UDSKILL Hidden
    UD_SkillManager_Script Function get()
        return (UDCDmain as Quest) as UD_SkillManager_Script
    EndFunction
EndProperty

;/  Variable: UDOMNPC
    
    Meaning: NPC Orgasm Manager
    
    This module contains functionality for manipulating orgasm variables
    
    Only use this on NPCs!! Using it on Player might break the framework!
    
    See <UD_OrgasmManager>
/;
UD_OrgasmManager                    Property UDOMNPC        auto

;/  Variable: UDOMPlayer
    
    Meaning: Player Orgasm Manager
    
    This module contains functionality for manipulating orgasm variables
    
    Only use this on Player!! Using it on NPC might break the framework!
    
    See <UD_OrgasmManager>
/;
UD_OrgasmManager                    Property UDOMPlayer     auto

UD_OrgasmManager                    Property UDOM Hidden
    UD_OrgasmManager Function get()
        return UDOMNPC ;NPC one is used as main one for storring MCM values
    EndFunction
EndProperty

;/  Variable: UDCONF
    
    Meaning: Mod Configuration
    
    (should) Contains configuration variables for all Unforgiving Devices modules
    
    See <UD_Config>
/;
UD_Config Property UDCONF auto

UD_MenuTextFormatter                Property UDMTF          Auto

UD_MenuMsgManager                   Property UDMMM          Auto


Package         Property UD_NPCDisablePackage           auto

;UI menus
Quest           Property UD_UIE_Quest                   auto
UITextEntryMenu Property TextMenu   hidden
    UITextEntryMenu Function Get()
        return (UD_UIE_Quest as UITextEntryMenu)
    EndFunction
EndProperty
UIListMenu      Property ListMenu   hidden
    UIListMenu Function Get()
        return (UD_UIE_Quest as UIListMenu)
    EndFunction
EndProperty

;/  Function: GetUDOM

    Parameters:

        akActor - Actor whose UD_OrgasmManager should be returned

    Returns:

        Correct UD_OrgasmManager for passed actor. There are currently 2 iterations of script, one for NPCs and one for player
/;
UD_OrgasmManager Function GetUDOM(Actor akActor)
    if IsPlayer(akActor)
        return UDOMPlayer
    else
        return UDOMNPC
    endif
EndFunction


;IWantWidgets. Not currently used, but have some ideas for future. No scripts are currently required to compile
Bool    Property iWidgetInstalled          = False      auto hidden
Quest   Property iWidgetQuest                           auto

;/  Function: UseiWW

    Returns:

        Returns true if iWantWidgets is installed and enabled in MCM
/;
Bool Function UseiWW()
    return iWidgetInstalled && UDWC.UD_UseIWantWidget
EndFunction

;Global switches
bool    property lockMCM                   = False      auto hidden
bool    property UD_LockDebugMCM           = False      auto hidden
bool    property DebugMod                  = False      auto hidden conditional
bool    Property AllowNPCSupport           = False      auto hidden
Bool    Property UD_WarningAllowed         = False      auto hidden
bool    Property UD_DisableUpdate          = False      auto hidden conditional
bool    Property UD_CheckAllKw             = False      auto hidden conditional

;zadlibs patch control
bool Property UD_zadlibs_ParalelProccesing = false auto

bool    _UD_hightPerformance
bool Property UD_hightPerformance
    Function set(bool bValue)
        _UD_hightPerformance = bValue
    EndFunction
    bool Function get()
        return _UD_hightPerformance
    EndFunction
EndProperty

float Property UD_LowPerformanceTime    = 1.0   autoreadonly
float Property UD_HightPerformanceTime  = 0.25  autoreadonly

;/  Variable: UD_baseUpdateTime

    Returns:

        Returns current update time of minigames
/;
float Property UD_baseUpdateTime hidden
    Float Function Get()
        if UDGV.UDG_CustomMinigameUpT.Value
            return fRange(UDGV.UDG_CustomMinigameUpT.Value,0.01,10.0)
        endif
        if UD_hightPerformance
            return UD_HightPerformanceTime
        else
            return UD_LowPerformanceTime
        endif
    EndFunction
EndProperty

zadConfig   Property DDconfig                   auto
String[]    Property UD_OfficialPatches         auto

;zbfBondageShell Property ZAZBS auto
bool Property OSLArousedInstalled       = false auto hidden
bool Property ConsoleUtilInstalled      = false auto hidden
bool Property SlaveTatsInstalled        = false auto hidden
bool Property OrdinatorInstalled        = false auto hidden
bool Property ZadExpressionSystemInstalled = false auto hidden
Bool Property DeviousStrikeInstalled    = False auto hidden
Bool Property ForHimInstalled           = False auto hidden
Bool Property PO3Installed              = False auto hidden ;https://www.nexusmods.com/skyrimspecialedition/mods/22854
Bool Property ImprovedCameraInstalled   = False auto hidden
Bool Property ExperienceInstalled       = False auto hidden
Bool Property SkyrimSoulsInstalled      = False auto hidden
Bool Property AllowMenBondage           = True  auto hidden

bool Property Ready = False auto hidden

;/  Group: Utility
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: UDReady

    Returns:

        Returns true if mod is fully ready (not installing or updating)
/;
bool Function UDReady()
    return Ready
EndFunction

;/  Function: WaitForReady

    This function will block thread until the mod is ready

    Returns:

        Returns true if there was error while waiting for mod to be ready
/;
Bool Function WaitForReady()
    while !Ready && !_FatalError
        Utility.waitMenuMode(0.5)
    endwhile
    if _FatalError
        return false
    else
        return true
    endif
EndFunction

;/  Function: WaitForUpdated

    This function will block thread until the mod is ready and updated

    Returns:

        Returns true if there was error while waiting for mod to be ready and updated
/;
Bool Function WaitForUpdated()
    WaitForReady()
    while _Updating && !_FatalError
        Utility.waitMenuMode(0.5)
    endwhile
    if _FatalError
        return false
    else
        return true
    endif
EndFunction

Event OnInit()
    Player = Game.GetPlayer()
    ;Print("Installing Unforgiving Devices...")
    if zadbq.modVersion
        ;DD is already installed when UD is installed
        ;UD will not correctly replace DD script when they are already set
        ;because of that UD is incompatible with already ongoing DD moded game
        string loc_msg = "!!!!ERROR!!!!\n"
        loc_msg += "Unforgiving Devices detected that it was installed on already ongoing game. "
        loc_msg += "Without starting fresh game, UD will not be able to correctly lock/unlock devices! "
        loc_msg += "\n\n!Please, start a new game or clean uninstall DD and install it on the same time with UD!"
        debug.messagebox(loc_msg)
    endif

    if CheckSubModules()
        RegisterForSingleUpdate(1.0)
    else
        DISABLE() ;disable UD
    endif
EndEvent

;/  Function: GetUDMain

    Returns:

        Returns singleton of UnforgivingDevicesMain script from main mod
/;
UnforgivingDevicesMain Function GetUDMain() Global
    return GetMeMyForm(0x005901,"UnforgivingDevices.esp") as UnforgivingDevicesMain
EndFunction

;/  Function: GetZadLibs

    Returns:

        Returns singleton of zadlibs script from dd
/;
zadlibs Function GetZadLibs() Global
    return GetMeMyForm(0x00F624,"Devious Devices - Integration.esm") as zadlibs
EndFunction

;/  Function: CheckSubModules

    This function will check all submodul scripts and returns if true if they are all ready

    In case one or more scripts don't get ready in first 20 seconds, it will toggle mod to error state, preventing any furthere gameplay. User needs to reload the save in hope that it will fix the issue.
    
    Returns:

        Returns true if all submodules are ready and there is not error
/;
Bool Function CheckSubModules()
    Bool    loc_cond = False
    Int     loc_elapsedTime = 0
    while !loc_cond && loc_elapsedTime < 10
        loc_cond = True
        loc_cond = loc_cond && UDCDmain.ready
        loc_cond = loc_cond && UDOM.ready
        
        Utility.WaitMenuMode(1.0)
        loc_elapsedTime += 1
    endwhile
    
    ;check for fatal error
    if !loc_cond
        _FatalError = True
        ShowSingleMessageBox("!!FATAL ERROR!!\nError loading Unforgiving devices. One or more of the modules are not ready. Please contact developers on LL or GitHub")
        
        String loc_modules = "--MODULES--\n"
        loc_modules += "UDCDmain="+UDCDmain.ready + "\n"
        loc_modules += "UDOM="+UDOM.ready + "\n"
        ShowMessageBox(loc_modules)
        
        ;Dumb info to console, use GInfo to skip ConsoleUtil installation check
        GInfo("!!FATAL ERROR!! = Error loading Unforgiving devices. One or more of the modules are not ready. Please contact developers on LL or GitHub")
        GInfo("UDCDmain="+UDCDmain.ready)
        GInfo("UDOM="+UDOM.ready)
        return False
    endif
    _FatalError = False
    return true && !_FatalError ;all OK
EndFunction

Bool Property _FatalError   = False Auto Hidden Conditional
Bool Property _Disabled     = False Auto Hidden Conditional
Bool Property _Updating     = False Auto Hidden Conditional

;/  Function: IsUpdating

    Returns:

        True if mod is currently updating. Mods should be threated as disabled when this happends
/;
Bool Function IsUpdating()
    return _Updating
EndFunction

;/  Function: IsEnabled

    Returns:

        True if mod is not updating, not disabled and is ready. Free camera should also be not used
/;
Bool Function IsEnabled()
    return !_Disabled && !_Updating && ready
EndFunction

;/  Function: PrintModStatus

    Returns:

        Print information about mod status in console
/;
Function PrintModStatus()
    GError("Disabled="+_Disabled)
    GError("Updating="+_Updating)
    GError("ready="+ready)
    GError("FatalError="+_FatalError)
EndFunction

;Previous states of scripts, so they are returned to correct state

String _State_UDNPCM
String _State_UDAI
String _State_UDOMNPC
String _State_UDOMPlayer

;/  Function: DISABLE

    Disables mod, preventing any periodicall updates and interactions
/;
Function DISABLE()
    _Disabled = True
    
    ;Save previous states
    _State_UDNPCM       = UDNPCM.GetState()
    _State_UDAI         = UDAI.GetState()
    _State_UDOMNPC      = UDOMNPC.GetState()
    _State_UDOMPlayer   = UDOMPlayer.GetState()
    
    UDNPCM.GoToState("Disabled") ;disable NPC manager, disabling all device updates
    UDAI.GoToState("Disabled") ;disable AI updates
    UDOMNPC.GoToState("Disabled") ;disable orgasm updates
    UDOMPlayer.GoToState("Disabled") ;disable orgasm updates
EndFunction

;/  Function: ENABLE

    Reenable mod from disabled state. See <DISABLE>
/;
Function ENABLE()
    _Disabled = False
    UDNPCM.GoToState(_State_UDNPCM)
    UDAI.GoToState(_State_UDAI)
    UDOMNPC.GoToState(_State_UDOMNPC)
    UDOMPlayer.GoToState(_State_UDOMPlayer)
EndFunction

;/  Function: ENABLE

    Checks if user have correct version of SKSE installed, and UDNative.dll present
    
    Returns:
        true if UDNative.dll can be used without issue
/;
bool Function NativeAllowed() global
    ;check if dll is installed
    if (SKSE.GetPluginVersion("UDNative") == -1)
        return false
    endif
    
    ;check if correct skse version is installed
    if SKSE.GetVersion() == 2
        int loc_minor = SKSE.GetVersionMinor()
        int loc_beta  = SKSE.GetVersionBeta()
        ;is version 2.0.20 (SE)
        if loc_minor == 0 && loc_beta == 20
            return true
        endif
        ;is version 2.1.X or 2.2.X (AE)
        if loc_minor == 1 || loc_minor == 2
            return true
        endif
    endif
    return false
EndFunction

;/  Function: IsSpecialEdition
    
    Returns:
        true if correct skyrim version is Special Edition (also AE and VR)
/;
Bool Function IsSpecialEdition() global
    return SKSE.GetVersion() == 2
EndFunction

int _updatecounter = 0
Function _ResetUpdateCounter()
    _updatecounter = 0
    Info("Update progress: 0 %%")
EndFunction
Function _IncrementUpdateCounter()
    _updatecounter += 1
    Info("Update progress: " + GetUpdateProgress() + " %%")
EndFunction

;/  Function: GetUpdateProgress
    
    Returns:
        Current update progress of the mod. It is whole number from 0 to 100, where mod is full ready on 100
/;
int Function GetUpdateProgress()
    return (Round(100.0*_updatecounter/22))
EndFunction

Function OnGameReload()
    if !_Initialized
        if !UDNPCM.Ready || !config.ready
            GWarning(self+"::OnGameReload() - Skipping because mod is not fully initialized")
            return
        else
            ;user installed mod after init variable was added
            _Initialized = True
        endif
    endif

    if _Disabled
        return ;mod is disabled, do nothing
    endif
    
    if _Updating
        return ;mod is already updating, most likely because user saved the game while the mod was already updating
    endif
    
    if !Ready
        return ;mod is not ready yet, not update will happen
    endif
    
    _Updating = True
    
    DISABLE()
    
    Print("Updating Unforgiving Devices, please wait...")
    Info(self+"::OnGameReload() - Updating Unforgiving Devices...")
    
    if _UpdateCheck()
        _ResetUpdateCounter()
    
        ;update all scripts
        Update()
        _IncrementUpdateCounter()   ;2
        
        int loc_removedmeters = UDWC.Meter_UnregisterAllNative()
        if loc_removedmeters > 0
            Info(self+"::OnGameReload() - Removed " + loc_removedmeters + " registered meters!")
        endif
        _IncrementUpdateCounter()   ;2
        
        if !CheckSubModules() || _FatalError
            _Updating = False
            ENABLE()
            Info("<=====| !!Unforgiving Devices FAILED!! |=====>")
            Print("Unforgiving Devices update FAILED")
            Info(self + "::OnGameReload() - CheckSubmodules() = " + CheckSubModules() + ";_FatalError = " + _FatalError)
            return ;Fatal error when initializing UD
        endif
        _IncrementUpdateCounter()   ;3
        
        UDWC.GameUpdate()
        _IncrementUpdateCounter()   ;4
        
        UDMC.Update()
        _IncrementUpdateCounter()   ;5
        
        BoundCombat.Update()
        _IncrementUpdateCounter()   ;6
        
        UDlibs.Update()
        _IncrementUpdateCounter()   ;7
        
        UDCDMain.Update()
        _IncrementUpdateCounter()   ;8
        
        Config.Update()
        _IncrementUpdateCounter()   ;9
        
        UDPP.Update()
        _IncrementUpdateCounter()   ;10
        
        UDOMNPC.Update()  ;NPC orgasm manager
        _IncrementUpdateCounter()   ;11
        UDOMPlayer.Update() ;player orgasm manager
        _IncrementUpdateCounter()   ;12
        
        UDEM.Update()
        _IncrementUpdateCounter()   ;13
        
        UDNPCM.GameUpdate()
        _IncrementUpdateCounter()   ;14
        
        UDLLP.Update()
        _IncrementUpdateCounter()   ;15
        
        UDRRM.Update()
        _IncrementUpdateCounter()   ;16
        
        if UDAM.Ready
            UDAM.Update()
        endif
        _IncrementUpdateCounter()   ;17
        
        if UDCM.Ready
            UDCM.Update()
        endif
        _IncrementUpdateCounter()   ;18
        
        UDAbadonQuest.Update()
        _IncrementUpdateCounter()   ;19
        
        UDMOM.Update()
        _IncrementUpdateCounter()   ;20
        
        UDOTM.Update()
        _IncrementUpdateCounter()   ;21
        
        UDMMM.Update()
        _IncrementUpdateCounter()   ;22
        
        Info("<=====| Unforgiving Devices updated |=====>")
        Print("Unforgiving Devices updated")
    else
        Info("<=====| !!Unforgiving Devices FAILED!! |=====>")
        Print("Unforgiving Devices update FAILED")
    endif
    
    _Updating = False
    ENABLE()
EndFunction

Event OnUpdate()
    GInfo(self + "::OnUpdate() - Called")
    _Init()
    Update()
EndEvent

Bool _Initialized = False
Function _Init()
    ;start quest manually
    UDNPCM.Start()
    
    Float loc_timeout = 0.0
    Float loc_maxtime = 5.0
    
    ;wait for quest to get ready
    while !UDNPCM.Ready && loc_timeout <= loc_maxtime
        Utility.wait(0.25)
        loc_timeout += 0.25
    endwhile
    if !UDNPCM.Ready
        ;ERROR
        GError("NPC manager can't be started!! Mod will be disabled!")
        ShowSingleMessageBox("!!FATAL ERROR!!\nFailed to load NPC manager and its slots!! Mod will be disabled untill quest correctly starts.\n Please contact developers on LL or GitHub")
        _FatalError = True
    else
        GInfo("NPC manager started successfully")
    endif
    
    ; Manually start modules, so the setting is correctly loaded from json
    _StartModulesManual()
    
    ;init mcm
    config.Init()
    
    _Initialized = True
EndFunction

Function Update()
    if !Player
        CLog("Detected that Player ref is not ready. Setting variable")
        Player = Game.GetPlayer()
    endif
    
    if _FatalError
        GError(self+"::Update() - Skipped because mod have fatal error")
        return
    endif
    
    RegisterForModEvent("UDForceUpdate","OnGameReload")
    
    _ValidateModules()
    _CheckOptionalMods()
    _CheckPatchesOrder()
    
    if !Ready
        if _UpdateCheck() && !_FatalError
            UD_hightPerformance = UD_hightPerformance
            
            RegisterForModEvent("UD_VibEvent","EventVib")
            
            Info("<=====| UnforgivingDevicesMain installed |=====>")
            
            Print("Unforgiving Devices Ready!")
            
            Ready = true
        else
            Error("<=====| !!UnforgivingDevicesMain installation FAILED!! |=====>")
            Print("Unforgiving Devices installation failed!")
            return
        endif
    endif
    
    SendModEvent("UD_PatchUpdate") ;send update event to all patches. Will force patches to check if they are installed correctly
    
    UDCDmain.UpdateQuestKeywords()
    UDCDmain.UpdateGenericKeys()
    
    _StartModulesManual()
EndFunction

;/  Function: ForceUpdate
    
    Forces mod to update. Function is not blocking.
/;
Function ForceUpdate()
    int handle = ModEvent.Create("UDForceUpdate")
    if (handle)
        ModEvent.Send(handle)
    endIf
EndFunction

;used for validating modules forms between versions
Function _ValidateModules()
    Info(self + "::_ValidateModules() - Validating modules...")
    ;validate modules that were moved between versions
    UDPP    = GetMeMyForm(0x0120B6,"UnforgivingDevices.esp") as UD_ParalelProcess
    UDLLP   = GetMeMyForm(0x0120B4,"UnforgivingDevices.esp") as UD_LeveledList_Patcher
    UD_LibsQuest    = GetMeMyForm(0x0120B5,"UnforgivingDevices.esp") as Quest
    UDlibs          = UD_LibsQuest as UD_Libs
    ItemManager     = UD_LibsQuest as UDItemManager
    UDRRM           = UD_LibsQuest as UD_RandomRestraintManager
    
    ;validate expression system
    Quest loc_DDexpressionQuest = GetMeMyForm(0x000800,"Devious Devices - Integration.esm") as Quest
    if !ZadExpressionSystemInstalled && loc_DDexpressionQuest
        Info("ZAD Expression System detected: switching...")
        ZadExpressionSystemInstalled = True
        if !libs.ExpLibs
            libs.ExpLibs = loc_DDexpressionQuest as zadexpressionlibs
        endif
        UDEM.GoToState("DDExpressionSystemInstalled")
        Info("ZAD Expression System detected: DONE")
    endif
    Info(self + "::_ValidateModules() - Modules validated")
EndFunction

Function _StartModulesManual()
    Info(self + "::_StartModulesManual() - Starting modules...")
    if !UDPP.IsRunning()
        UDPP.start()
    endif
    
    if !UDLLP.IsRunning()
        UDLLP.start()
    endif
    
    if !UDlibs.IsRunning()
        UDlibs.start()
    endif

    if !UDRRM.IsRunning()
        UDRRM.start()
    endif

    if !ItemManager.IsRunning()
        ItemManager.start()
    endif
    
    if !UDCM.IsRunning()
        UDCM.start()
    endif
    
    if !UDWC.IsRunning()
        UDWC.start()
    endif
    Info(self + "::_StartModulesManual() - Started modules")
EndFunction

;last check before mod is ready. At this point, all optional mods are checked as so, can be used.
Bool Function _UpdateCheck()
    Bool loc_cond = true
    
    loc_cond = loc_cond && (!PO3Installed || PO3_SKSEFunctions.IsScriptAttachedToForm(zadbq,"zadlibs_UDPatch")) ;ud patch script have to be pressent on zad quest

    return loc_cond
EndFunction

Function _CheckOptionalMods()
    UDNPCM.ResetIncompatibleFactionArray() ;reset incomatible scan factions
    
    if ModInstalled("OSLAroused.esp")
        OSLArousedInstalled = True
        if TraceAllowed()
            Log("OSLAroused detected!")
        endif
    else
        OSLArousedInstalled = false
    endif
        
    if ModInstalled("SlaveTats.esp")
        SlaveTatsInstalled = True
        if TraceAllowed()
            Log("SlaveTats detected!")
        endif
    else
        SlaveTatsInstalled = false
    endif
    
    if ModInstalled("UIExtensions.esp")
        if TraceAllowed()
            Log("UIExtensions detected!")
        endif
    else
        ShowMessageBox("--!ERROR!--\nUD can't detect UIExtensions. Without this mod, some features of Unforgiving Devices will not work as intended. Please be warned.")
    endif
    
    if PluginInstalled("ConsoleUtilSSE.dll")
        ConsoleUtilInstalled = True
        if TraceAllowed()
            Log("ConsoleUtil detected!")
        endif
    else
        ShowMessageBox("--!ERROR!--\nUD can't detect ConsoleUtil. Without this mod, some features of Unforgiving Devices will not work as intended. Please be warned.")
        ConsoleUtilInstalled = False
    endif
    
    if ModInstalled("Ordinator - Perks of Skyrim.esp")
        OrdinatorInstalled = True
        if TraceAllowed()
            Log("Ordinator - Perks of Skyrim detected!")
        endif
    else
        OrdinatorInstalled = false
    endif
    
    ;Check iWidgets
    iWidgetQuest = GetMeMyForm(0x000800,"iWant Widgets LE.esp",False) as Quest
    if !iWidgetQuest
        iWidgetQuest = GetMeMyForm(0x000800,"iWant Widgets.esl",False) as Quest
    endif
    
    if iWidgetQuest
        iWidgetInstalled = True
    else
        iWidgetInstalled = False
    endif
    
    if ModInstalled("Devious Strike.esp")
        DeviousStrikeInstalled = True
        if TraceAllowed()
            Log("Devious Strike detected!")
        endif
        ;2 Factions, as it looks like that the formID changes between versions
        UDNPCM.AddScanIncompatibleFaction(GetMeMyForm(0x000801,"Devious Strike.esp") as Faction)
        UDNPCM.AddScanIncompatibleFaction(GetMeMyForm(0x005930,"Devious Strike.esp") as Faction)
    else
        DeviousStrikeInstalled = false
    endif

    if ModInstalled("Devious Devices For Him.esp")
        ForHimInstalled = True
        if TraceAllowed()
            Log("DD For Him detected!")
        endif
    else
        ForHimInstalled = false
    endif
    
    if PluginInstalled("po3_PapyrusExtender.dll")
        PO3Installed = True
    else
        PO3Installed = False
    endif
    
    if PluginInstalled("ImprovedCameraSE.dll")
        ImprovedCameraInstalled = true
    else
        ImprovedCameraInstalled = false
    endif
    
    if PluginInstalled("Experience.dll")
        ExperienceInstalled = true
    else
        ExperienceInstalled = false
    endif
    
    if PluginInstalled("SkyrimSoulsRE.dll")
        SkyrimSoulsInstalled = true
    else
        SkyrimSoulsInstalled = false
    endif
EndFUnction

Function _CheckPatchesOrder()
    Int loc_issues = UD_Native.CheckPatchedDevices()
    if loc_issues > 0
        debug.messagebox("--!ERROR!--\nUD detected that "+ loc_issues +" device/s are patched incorrectly! Check SKSE log for more info. Please update your load order, and try to load the game again.")
    endif
    ;int loc_it = 0
    ;Info(self + "::_CheckPatchesOrder() - Checking patches order...")
    ;while loc_it < UD_OfficialPatches.length
    ;    if ModInstalled(UD_OfficialPatches[loc_it])
    ;        if !ModInstalledAfterUD(UD_OfficialPatches[loc_it])
    ;            debug.messagebox("--!ERROR!--\nUD detected that patch "+ UD_OfficialPatches[loc_it] +" is loaded before main mod! Patch always needs to be loaded after main mod or it will not work!!! Please change the load order, and reload save.")
    ;        endif
    ;    endif
    ;    loc_it += 1
    ;endwhile
    ;Info(self + "::_CheckPatchesOrder() - Patches order checked")
EndFunction

;/  Function: ResetQuest
    Resets the quest. Note that the quest will not be fully reset if it have Run Once flag
    Function will be blocked untill quest is fully reset

    Parameters:

        akQuest   - Quest to reset
/;
Function ResetQuest(Quest akQuest) global
    akQuest.Stop()
    Utility.wait(0.1)
    akQuest.Start()
    int loc_tick = 0
    while akQuest.IsStarting() && loc_tick < 10
        Utility.waitMenuMode(0.1)
        loc_tick += 1
    endwhile
EndFUnction

;/  Function: getDDescapeDifficulty

    Returns:

        --- Code
        |======================================|
        |   returns |           Meaning        |
        |======================================|
        |    00     =     Easiest difficulty   |
        |    04     =     Default value        |
        |    08     =     Hardest difficulty   |
        |======================================|
        ---

        Integer which repsesent difficulty from Devious Devices framework
/;
int Function getDDescapeDifficulty()
    if UDCDmain.UD_UseDDdifficulty
        return (8 - DDconfig.EscapeDifficulty)
    else
        return 4
    endif
EndFunction

;/  Function: hasAnyUD

    Returns:
        True if player have any Devious Device locked on
/;
bool function hasAnyUD()
    return Player.wornhaskeyword(libs.zad_Lockable)
endfunction

Function startVibEffect(Actor akActor, int aiStrenght, int aiDuration, bool abEdge)
    int loc_handle = ModEvent.Create("UD_VibEvent")
    ModEvent.PushForm(loc_handle,akActor)
    ModEvent.PushInt(loc_handle,aiStrenght)
    ModEvent.PushInt(loc_handle,aiDuration)
    ModEvent.pushBool(loc_handle,abEdge)
    ModEvent.Send(loc_handle)
EndFunction

Event EventVib(Form akActor, int aiStrenght, int aiDuration, bool abEdge)
    libs.VibrateEffect(akActor as Actor, aiStrenght, aiDuration, abEdge)
EndEvent

int Property LogLevel = 0 auto

;/  Function: Log

    Prints one line of text to Papyrus log
    
    Note that users needs to have Papyrus logging enabled first

    Parameters:

        asMsg   - Message which should be printed to Papyrus log.
        aiLevel - (optional) Level of imporatance for message. Is used for filtering messages based on MCM setting. 1 means most important message and 5 least important message
/;
Function Log(String asMsg, int aiLevel = 1)
    if (iRange(aiLevel,1,3) <= LogLevel) || DebugMod
        string loc_msg = "[UD," + aiLevel + ",T="+Utility.GetCurrentRealTime()+"]: " + asMsg
        debug.trace(loc_msg)
        if ConsoleUtilInstalled && UDGV.UDG_ConsoleLog.Value  ;print to console
            ConsoleUtil.PrintMessage(loc_msg)
        endif
    endif
EndFunction

Function LogDebug(String asMsg)
    string loc_msg = "[UD,D,T="+Utility.GetCurrentRealTime()+"]: " + asMsg
    debug.trace(loc_msg)
    ConsoleUtil.PrintMessage(loc_msg)
EndFunction

;/  Function: CLog

    Prints one line of text to console. User first needs to have ConsoleUtil installed!
    
    Parameters:

        asMsg   - Message which should be printed to Console
/;
Function CLog(String asMsg)
    if ConsoleUtilInstalled ;print to console
        ConsoleUtil.PrintMessage("[UD,INFO,T="+Utility.GetCurrentRealTime()+"]: " + asMsg)
    endif
EndFunction

int Property UD_PrintLevel = 3 auto

;/  Function: Print

    Prints one line of text to skyrim text output (left upper corner)
    
    Parameters:

        asMsg   - Message which should be printed to Console
        aiLevel - (optional) Level of imporatance for message. Is used for filtering messages based on MCM setting. 1 means most important message and 5 least important message
        abLog   - (optional) Set to true if the message should be also added to Papyrus log
/;
Function Print(String asMsg,int aiLevel = 1,bool abLog = false)
    if (iRange(aiLevel,0,3) <= UD_PrintLevel)
        ; debug.notification(msg)
        UDWC.Notification_Push(asMsg)
        if abLog || TraceAllowed()
            Log("Print -> " + asMsg)
        endif
    endif
EndFunction

;/  Function: Error

    Prints one line of error message to console and Papyrus log
    
    Parameters:

        asMsg   - Error message information
/;
Function Error(String asMsg)
    string loc_msg = "[UD,!ERROR!,T="+Utility.GetCurrentRealTime()+"]: " + asMsg
    debug.trace(loc_msg)
    if ConsoleUtilInstalled ;print to console
        ConsoleUtil.PrintMessage(loc_msg)
    endif
    debug.notification("UD ERROR - check console")
EndFunction

;/  Function: Warning

    Prints one line of warning message to console and Papyrus log
    
    Note: This feature can toggled off in MCM
    
    Parameters:

        asMsg   - Error message information
/;
Function Warning(String asMsg)
    string loc_msg = "[UD,WARNING,T="+Utility.GetCurrentRealTime()+"]: " + asMsg
    debug.trace(loc_msg)
    if ConsoleUtilInstalled ;print to console
        ConsoleUtil.PrintMessage(loc_msg)
    endif
EndFunction

;/  Function: Info

    Prints one line of info message to console and Papyrus log
    
    This function is intended to be only ussed for debugging
    
    Parameters:

        asMsg   - Info message information
/;
Function Info(String asMsg)
    string loc_msg = "[UD,INFO,T="+Utility.GetCurrentRealTime()+"]: " + asMsg
    debug.trace(loc_msg)
    if ConsoleUtilInstalled ;print to console
        ConsoleUtil.PrintMessage(loc_msg)
    endif
EndFunction


;/  Function: TraceAllowed

    Allways use this function first beffore calling Log function!
    
    Otherwise performance can be greatly affected for users which don't use Papyrus logging

    Returns:

        True if logging is enabled
        
    _Example_:
        --- Papyrus
        Function fun()
           if UDAPI.TraceAllowed()
               UDAPI.Log("fun called!",2)
           endif
           ; ||              ||
           ; VV FUNCTINALITY VV
        EndFunction
        ---
/;
bool Function TraceAllowed()
    return (LogLevel > 0)
EndFunction

;/  Function: WaitRandomTime

    Block thread for random time. Thread will also not continue unless menus are closed

    Can be used to separate threads (like many of same events firing at the same time)


    Parameters:

        afMin     - Minimum blocking time
        afMax     - Maximum blocking time
/;
Function WaitRandomTime(Float afMin = 0.1, Float afMax = 1.0) Global
    Utility.wait(RandomFloat(afMin,afMax))
EndFunction

;/  Function: WaitMenuRandomTime

    Same as <WaitRandomTime>, but will also work if menus are open
/;
Function WaitMenuRandomTime(Float afMin = 0.1, Float afMax = 1.0) Global
    Utility.waitMenuMode(RandomFloat(afMin,afMax))
EndFunction

;/  Function: CalcDistance

    Calculate distance between two objects

    Parameters:

        akObj1   - Object 1
        akObj2   - Object 2

    Returns:

        Distance between objects. *Returns 0* if the objects are same. *Returns -1* if objects are not in the same cell
/;
float Function CalcDistance(ObjectReference akObj1,ObjectReference akObj2) global
    if akObj1 == akObj2
        return 0.0
    endif
    if akObj1.GetParentCell() == akObj2.GetParentCell()
        float dX = akObj1.X - akObj2.X
        float dY = akObj1.Y - akObj2.Y
        float dZ = akObj1.Z - akObj2.Z
        return Math.Sqrt(Math.Pow(dX,2) + Math.Pow(dY,2) + Math.Pow(dZ,2))
    else
        return -1.0
    endif
EndFunction

;/  Function: getPlugsVibrationStrengthString

    Returns string with vibrator strength

    Table:
    --- Code
    aiStrenght == 1 -> "Very weak"
    aiStrenght == 2 -> "Weak"
    aiStrenght == 3 -> "Strong"
    aiStrenght == 4 -> "Very Strong"
    aiStrenght == 5 -> "Extremely Strong"
    ---

    Parameters:

        aiStrenght  - DD Vibrator strength

    Returns:

        Strength of vibrations
/;
string Function getPlugsVibrationStrengthString(int aiStrenght) global
    if aiStrenght >= 5
        return "Extremely Strong"
    endif
    if aiStrenght == 4
        return "Very Strong"
    endif
    if aiStrenght == 3
        return "Strong"
    endif
    if aiStrenght == 2
        return "Weak"
    endif
    if aiStrenght <= 1
        return "Very weak"
    endif
EndFunction

;/  Group: Math
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: IntToBit

    This function is internaly only used for debugging

    Parameters:

        argInt   - Integer which will be converted

    Returns:

        String containing converted int to bites. First is the most significant bit and last the least significant bit
        
    _Example_:
        --- Code
        Int loc_val     = 0xFEDCBA98
        String loc_res  = IntToBit(loc_val)
        Print(loc_res) -> 1111 1110 1101 1100 1011 1010 1001 1000
        ---
/;
string Function IntToBit(int argInt) global
    string  loc_res = ""
    int     loc_i   = 32
    while loc_i ;32 bit number
        loc_i -= 1
        if Math.LogicalAnd(argInt,Math.LeftShift(0x00000001,loc_i))
            loc_res += "1"
        else
            loc_res += "0"
        endif
        
        if !(loc_i % 4) && loc_i
            loc_res += " " ;add space for better readability
        endif
    endwhile
    return loc_res
EndFunction

;/  Function: iUnsig

    Truncate negative values from passed INT

    Parameters:

        aiValue     - Value to be truncated

    Returns:

        Truncated value

    _Example_:
        --- Code
        Int loc_val1 = -100
        Int loc_val2 = iUnsig(loc_var)
        
        Print(loc_val1) -> -100
        Print(loc_val2) -> 0
        ---
/;
Int Function iUnsig(Int aiValue) global
    if aiValue < 0
        return 0
    endif
    return aiValue
EndFunction


;/  Function: ConvertTime

    Convert passed time to days

    Parameters:

        akHours     - Hours
        akMinutes   - Minutes
        akSeconds   - Seconds

    Returns:

       Converted time

    _Example_:
        --- Code
        ;03:30:15
        ConvertTime(3,30,15) -> 0.1458 days
        
        ;24:00:00
        ConvertTime(24) -> 1.0 days
        
        ;120 minutes
        ConvertTime(0,120) -> 0.083 days
        ---
/;
Float Function ConvertTime(Float akHours, Float akMinutes = 0.0, Float akSeconds = 0.0) Global
    Float loc_res = 0.0
    loc_res += akHours/24
    loc_res += akMinutes/24/60
    loc_res += akSeconds/24/3600
    return loc_res
EndFunction

;/  Function: ConvertTimeHours

    Convert passed hours to days

    Parameters:

        akHours     - Hours

    Returns:

       Converted time
/;
Float Function ConvertTimeHours(Float akHours) global
    return akHours/24
EndFunction

;/  Function: ConvertTimeMinutes

    Convert passed minutes to days

    Parameters:

        akMinutes     - Minutes

    Returns:

       Converted time
/;
Float Function ConvertTimeMinutes(Float akMinutes) global
    return akMinutes/24/60
EndFunction

;/  Function: ConvertTimeSeconds

    Convert passed seconds to days

    Parameters:

        akSeconds     - Seconds

    Returns:

       Converted time
/;
Float Function ConvertTimeSeconds(Float akSeconds) global
    return akSeconds/24/3600
EndFunction

;/  Function: iAbs

    Calculate absolute value of passed INT

    Parameters:

        aiVal     - Value

    Returns:

       Absolute value

    _Example_:
        --- Code
        iAbs( 50)  -> 50
        iAbs(-10)  -> 10
        ---
/;
Int Function iAbs(Int aiVal) Global
    if aiVal > 0
        return aiVal
    else
        return -1*aiVal
    endif
EndFunction

;/  Function: fAbs

    Same as <iAbs>, but for FLOAT
/;
Float Function fAbs(Float afVal) Global
    if afVal > 0.0
        return afVal
    else
        return -1.0*afVal
    endif
EndFunction

;/  Group: Mods
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: ModInstalled

    Check if mod is installed

    Parameters:

        asModFileName  - name of mod WITH extension

    Returns:

        True if mod is installed

    _Example_:
        --- Code
        ;check if Slave tats is installed
        if ModInstalled("SlaveTats.esp")
            ;DO SOMETHING
        endif
        ---
/;
bool Function ModInstalled(string asModFileName) global
    return (Game.GetModByName(asModFileName) != 255) && (Game.GetModByName(asModFileName) != 0) ; 255 = not found, 0 = no skse
EndFunction

;/  Function: ModInstalledAfterUD

    Check if mod is installed after Unforgiving Devices

    Parameters:

        asModFileName  - Name of mod WITH extension

    Returns:

        True if mod is installed after Unforgiving Devices

    _Example_:
        --- Code
        ;check if patch is installed correctly
        if !ModInstalledAfterUD("CustomUDPatch.esp")
            Error("Patch have to be installed after main mod!!")
        endif
        ---
/;
bool Function ModInstalledAfterUD(string asModFileName) global
    return (Game.GetModByName(asModFileName) > Game.GetModByName("UnforgivingDevices.esp"))
EndFunction

;/  Function: MakeDeviceHeader

    Creates string containing formated information about device worn by actor

    Parameters:

        akActor     - Actor who is wearing akInvDevice
        akInvDevice - Device worn by akActor

    Returns:

        Formated string
/;
string Function MakeDeviceHeader(Actor akActor,Armor akInvDevice) global
    string loc_actorname = "NONE_ACTOR"
    string loc_devicename = "NONE_DEVICE"
    if akActor
        loc_actorname = GetActorName(akActor)
    endif
    if akInvDevice
        loc_devicename = akInvDevice.GetName()
    endif
    
    return (loc_devicename + "("+ loc_actorname + ")")
EndFunction

;only use for debugging
Function DCLog(String msg) global
    ConsoleUtil.PrintMessage("[UD,DEBUG,T="+Utility.GetCurrentRealTime()+"]: " + msg)
EndFunction

Function GInfo(String msg) global
    string loc_msg = "[UD,INFO,T="+Utility.GetCurrentRealTime()+"]: " + msg
    debug.trace(loc_msg)
    ConsoleUtil.PrintMessage(loc_msg)
EndFunction

Function GWarning(String msg) global
    string loc_msg = "[UD,WARNING,T="+Utility.GetCurrentRealTime()+"]: " + msg
    debug.trace(loc_msg)
    ConsoleUtil.PrintMessage(loc_msg)
EndFunction

;global error function. Ignore safety in sake of usebality
Function GError(String msg) global
    string loc_msg = "[UD,!ERROR!,T="+Utility.GetCurrentRealTime()+"]: " + msg
    debug.trace(loc_msg)
    ConsoleUtil.PrintMessage(loc_msg)
EndFunction


;/  Function: GetMeMyForm

    Returns form from plugin. Also works for esl plugins

    thanks to Subhuman#6830 for ESPFE form check, compatible with LE
    Notes given by him:
    1) it breaks the compile-time dependency.   GetformFromFile requires you to have the plugin you're getting a form for in order to compile, this does not
    2) less papyrus spam, if the plugin isn't found it prints a single line debug.trace instead 4-5 lines of errors
    3) related to 1, it doesn't verify you didn't screw up.   If you're trying to cast a package as a quest, for example, GetFormFromFile will throw a compiler error because it can't be done.  This will not.  You have to verify your own work.

    Parameters:

        aiFormNumber    - FormID of form. Fornumber format is 0xFULLFORMID, for example 0x00000007. Even for ESPFE format, ignoring 0xFE
        asPluginName    - Full name of the plugin WITH extension
        abErrorMsg      - If error message should be shown in case that the function can't find the form

    Returns:

        Corresponding form
/;
Form Function GetMeMyForm(int aiFormNumber, string asPluginName, Bool abErrorMsg = True) global
    int theLO = Game.GetModByName(asPluginName)
    if ((theLO == 255) || (theLO == 0)) ; 255 = not found, 0 = no skse
        if abErrorMsg
            GError(asPluginName + " not loaded or SKSE not found")
        endif
        return none
    elseIf (theLO > 255) ; > 255 = ESL
        ; the first FIVE hex digits in an ESL are its address, so a aiFormNumber exceeding 0xFFF or below 0x800 is invalid
        if ((Math.LogicalAnd(0xFFFFF000, aiFormNumber) != 0) || (Math.LogicalAnd(0x00000800, aiFormNumber) == 0))
            if abErrorMsg
                GError("Plugin " + asPluginName + " has FormIDs outside the range\nallocated for ESL plugins!: " + aiFormNumber)
                GError("ESL-flagged plugin " + asPluginName + " contains invalid FormIDs: " + aiFormNumber)
            endif
            return none
        endIf
        ; getmodbyname reports an ESL as 256 higher than the game indexes it internally
        theLO -= 256
        return Game.GetFormEx(Math.LogicalOr(Math.LogicalOr(0xFE000000, Math.LeftShift(theLO, 12)), aiFormNumber))
    else    ; regular ESL-free plugin
        return Game.GetFormEx(Math.LogicalOr(Math.LeftShift(theLO, 24), aiFormNumber))
    endIf
EndFunction

;/  Group: Input
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: GetUserTextInput

    Opens text input menu, and returns its result

    NOTE: User needs to have UI Extensions installed for this to work!

    Returns:

        String written to text menu
/;
string Function GetUserTextInput()
    return UDUIE.GetUserTextInput()
EndFunction

;/  Function: GetUserListInput

    Opens list menu and returns index of selected line. Top is 0, bottom is max index

    NOTE: User needs to have UI Extensions installed for this to work!

    Parameters:

        arrList  - String array of list elements which will be shown in menu

    Returns:

        Index of selected line
/;
Int Function GetUserListInput(string[] arrList)
    return UDUIE.GetUserListInput(arrList)
EndFunction

;/  Group: Output
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: ShowMessageBox

    Shows message box with passed string. This function should be only used for showing multiline strings.
    
    Once the number of lines is too big for message box to be shown, additiona lamssage box will be open.
    
    In case you want to show simple string, use instead <ShowSingleMessageBox>

    Limit of lines per one message box is *12* lines!

    Every line have also limited number of characters which it can show. If line is too long, it will be split to multiple lines by engine, which will break this function.

    This function will be blocked until user clicks on OK button (this is not done by debug.messagebox function)

    Parameters:

        asText     - String of lines to be shown

    _Example_:
        --- Code
        String loc_text = ""
        loc_text += "Line 1\n"
        loc_text += "Line 2\n"
        loc_text += "Line 3\n"
        ShowMessageBox(loc_text) -> This will show message box with 3 lines with their corresponding texts
        ---
/;
Function ShowMessageBox(string asText, Bool abHTML = False)

    String[] loc_pages = UDMTF.SplitMessageIntoPages(asText)
    Int loc_i = 0
    While loc_i < loc_pages.Length
;        Log("ShowMessageBox() page = " + loc_i + ", text = " + loc_pages[loc_i], 3)
        ShowSingleMessageBox(loc_pages[loc_i], abHTML)
        loc_i += 1
    EndWhile

EndFunction

;/  Function: ShowSingleMessageBox

    Shows message box with passed string.

    This function will be blocked until user clicks on OK button (this is not done by debug.messagebox function)

    Parameters:

        asMessage     - String to be shown in message box
/;
Function ShowSingleMessageBox(String asMessage, Bool abHTML = False)
    If !abHTML
        Debug.MessageBox(asMessage)
    Else
        Debug.MessageBox("Placeholder")
    
        String[] loc_args
        loc_args = Utility.CreateStringArray(2, "")
        loc_args[0] = asMessage
        loc_args[1] = "1"

        UI.SetBool("MessageBoxMenu", "_root.MessageMenu" + ".MessageText.wordWrap", false)
;        UI.SetBool("MessageBoxMenu", "_root.MessageMenu" + ".MessageText.noTranslate", false)
        UI.InvokeStringA("MessageBoxMenu", "_root.MessageMenu" + ".SetMessage", loc_args)
        
;        UI.SetString("MessageBoxMenu", "_root.MessageMenu" + ".MessageText.htmlText", asMessage + asMessage)
    EndIf

    ;wait for fucking messagebox to actually get OKd before continuing thread (holy FUCKING shit toad)
    Utility.waitMenuMode(0.3)
    while IsMessageboxOpen()
        Utility.waitMenuMode(0.05)
    EndWhile
EndFunction

Int Function ShowMessageBoxMenu(String asMessage, String[] aasButtons, Bool abHTML = False)
    If !abHTML
        Debug.MessageBox(asMessage)
    Else
        Debug.MessageBox("Placeholder")
    
        String[] loc_args
        loc_args = Utility.CreateStringArray(2, "")
        loc_args[0] = asMessage
        loc_args[1] = "1"
        
        UI.SetBool("MessageBoxMenu", "_root.MessageMenu" + ".MessageText.wordWrap", false)
        UI.InvokeStringA("MessageBoxMenu", "_root.MessageMenu" + ".SetMessage", loc_args)
    EndIf
    ; populate buttons
    If aasButtons.Length > 0
        Utility.waitMenuMode(0.1)
        String[] loc_btns = new String[1]
        loc_btns[0] = "1"
        loc_btns = PapyrusUtil.MergeStringArray(loc_btns, aasButtons)
        UI.InvokeStringA("MessageBoxMenu", "_root.MessageMenu" + ".setupButtons", loc_btns)
    EndIf
    ; wait for the player input
    Int loc_last_btn = -2
    Utility.waitMenuMode(0.2)
    while UI.IsMenuOpen("MessageBoxMenu") ; IsMessageboxOpen()
        Utility.waitMenuMode(0.05)
        loc_last_btn = UI.GetInt("MessageBoxMenu", "_root.MessageMenu" + ".lastTabIndex")
    EndWhile
    GInfo("ShowMessageBoxMenu() Button = " + loc_last_btn)
    Return loc_last_btn
EndFunction

;/  Group: Actor
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: getMaxActorValue

    Returns maximum value of AV from passed actor

    Inspiried by https://www.creationkit.com/index.php?title=GetActorValuePercentage_-_Actor

    Parameters:

        akActor  - Used actor
        akValue  - Name of AV
        afPerc   - Relative value of max value. Can be used to get specific elative value, like 75% of max health, etc...

    Returns:

        akValue maximum value from akActor
/;
float Function getMaxActorValue(Actor akActor,string akValue, float afPerc = 1.0) global
    Float loc_perc = akActor.GetActorValuePercentage(akValue)
    if loc_perc
        return (akActor.GetActorValue(akValue)/loc_perc)*afPerc
    else
        return akActor.GetBaseActorValue(akValue)*afPerc ;assume base stats. Dunno how is this possible
    endif
EndFunction

;/  Function: getCurrentActorValuePerc

    Parameters:

        akActor  - Used actor
        akValue  - Name of AV

    Returns:

        Current relative value of akActor akValue
/;
float Function getCurrentActorValuePerc(Actor akActor,string akValue) global
    return akActor.GetActorValuePercentage(akValue)
EndFunction

;/  Function: ActorIsFollower

    Parameters:

        akActor   - Actor which will be checked

    Returns:

        True if passed akActor is follower
/;
bool Function ActorIsFollower(Actor akActor)
    ;added check for followers that are not marked as followers by normal means, to make loc_res == 4 from UDCustomDeviceMain.NPCMenu() work on them as well
    ;yes yes, some of the followers don't have FollowerFaction assigned, DCL uses similar check for those.
    string acName = akActor.GetDisplayName()
    if acName == "Serana" || acName == "Inigo" || acName == "Sofia" || acName == "Vilja"
        return true
    endif
    return akActor.isInFaction(UDCDmain.FollowerFaction)
EndFunction

;/  Function: ActorIsValidForUD
    This function check if passed actor is valid for Unforgiving Devices (wearing devices, orgasm system, etc...).
    
    Following conditions have to be meet for actor to be valid

    - Actor is not child
    - Actors race is playable
    - Actor is not dead
    - Actor is not male IF For Him is not installed

    Parameters:

        akActor   - Actor which will be checked

    Returns:

        True if passed akActor is valid
/;
bool Function ActorIsValidForUD(Actor akActor)
    if akActor == Player
        return true
    endif
    if akActor.isDead()         ;check that actor is not dead
        return false
    endif
    ActorBase loc_actorbase = akActor.GetLeveledActorBase()
    Race loc_race = loc_actorbase.getRace()
    if !loc_race.haskeyword(UDlibs.ActorTypeNPC) && !loc_race.IsPlayable() ;check that race is playable or NPC
        return false
    endif
    if loc_race.IsChildRace()    ;check that actor is not child
        return false
    endif
    if ((!ForHimInstalled || !AllowMenBondage) && loc_actorbase.GetSex() == 0)
        return false
    endif
    return true
EndFunction

int Property UD_HearingRange = 4000 auto hidden

;/  Function: ActorInCloseRange
    This function check if passed actor is close to Player
    
    Checked range depends on MCM setting Hearing range

    Parameters:

        akActor   - Actor which will be checked if they are in close range of Player

    Returns:

        True if passed akActor is close to player
/;
bool Function ActorInCloseRange(Actor akActor)
    if IsPlayer(akActor)
        return true
    endif
    float loc_distance = CalcDistance(Player,akActor)
    return (loc_distance >= 0 && loc_distance < UD_HearingRange)
EndFunction

;/  Function: ActorFreeHands

    Check if actor have free hands

    Parameters:

        akActor         - Checked actor
        abCheckGrasp    - If True, mittens will also count as device which makes actors hands not free

    Returns:

        True if actor have free hands

    _Example_:
        --- Code
        if ActorFreeHands(SomeActor)
            ;Actor have no free hands
        endif
        
        if ActorFreeHands(SomeActor,True)
            ;Actor have no free hands OR they are wearing mittens
        endif
        ---
/;
bool Function ActorFreeHands(Actor akActor,bool abCheckGrasp = false)
    bool loc_res = !akActor.wornhaskeyword(libs.zad_deviousHeavyBondage)
    if abCheckGrasp
        if akActor.wornhaskeyword(libs.zad_DeviousBondageMittens)
            loc_res = false
        endif
    endif
    return loc_res
EndFunction

;/  Function: ActorIsHelpless

    Check if actor is helpless and cant resist player actions

    Actor is helpless in following scenarios

    - They dont have free hands
    - They are paralysed
    - They are bleeding out

    Parameters:

        akActor         - Checked actor

    Returns:

        True if actor is helpless
/;
Bool Function ActorIsHelpless(Actor akActor)
    Bool loc_res = False
    loc_res = loc_res || !ActorFreeHands(akActor)
    loc_res = loc_res || akActor.getAV("paralysis")
    ;loc_res = loc_res || (akActor.GetSleepState() == 3)
    loc_res = loc_res || akActor.IsBleedingOut()
    return loc_res
EndFunction


;/  Function: GetActorGender

    Parameters:

        akActor     - Checked actor

    Returns:

       Gender of actor
    --- Code
        -1 = None
         0 = Male
         1 = Female
    ---
/;
Int Function GetActorGender(Actor akActor) global
    return akActor.GetActorBase().GetSex()
EndFunction

;/  Function: ActorIsFemale

    Parameters:

        akActor   - Checked actor

    Returns:

        True if passed actor is female
/;
bool Function ActorIsFemale(Actor akActor) global
    if GetActorGender(akActor) == 1
        return true
    else
        return false
    endif
EndFunction

;/  Function: GetPronounceSelf

    Parameters:

        akActor     - Checked actor
        abCapital   - If first letter should be capital

    Returns:

       Self pronounce of akActor (Himself/Herself/Themself)
/;
String Function GetPronounceSelf(Actor akActor, Bool abCapital = False) global
    Int loc_gender = GetActorGender(akActor)
    if loc_gender == 0
        if abCapital
            return "Himself"
        else
            return "himself"
        endif
    elseif loc_gender == 1
        if abCapital
            return "Herself"
        else
            return "herself"
        endif
    else
        if abCapital
            return "Themself"
        else
            return "themself"
        endif
    endif
EndFunction

;/  Function: GetPronounce

    Parameters:

        akActor     - Checked actor
        abCapital   - If first letter should be capital

    Returns:

       Pronounce of akActor (He/She/They)
/;
String Function GetPronounce(Actor akActor, Bool abCapital = False) global
    Int loc_gender = GetActorGender(akActor)
    if loc_gender == 0
        if abCapital
            return "He"
        else
            return "he"
        endif
    elseif loc_gender == 1
        if abCapital
            return "She"
        else
            return "she"
        endif
    else
        if abCapital
            return "they"
        else
            return "They"
        endif
    endif
EndFunction

;SoS faction. If none, it means that the SoS is not installed
Faction _SOS_SchlongifiedActors
Faction Property UD_SOS_SchlongifiedActors
    Faction Function Get()
        if !_SOS_SchlongifiedActors
            _SOS_SchlongifiedActors = UnforgivingDevicesMain.GetMeMyForm(0x00AFF8,"Schlongs of Skyrim.esp") as Faction
        endif
        return _SOS_SchlongifiedActors
    EndFunction
EndProperty

;/  Function: ActorHaveSoS

    Parameters:

        akActor  - Used actor

    Returns:

       True if akActor have Schlong of Skyrim (SoS)
/;
Bool Function ActorHaveSoS(Actor akActor)
    if UD_SOS_SchlongifiedActors
        return akActor.IsInFaction(UD_SOS_SchlongifiedActors)
    else
        Info("UnforgivingDevicesMain::ActorHaveSoS() - SoS not installed, returning false")
        return false
    endif
EndFunction

;/  Function: SheatWeapons
    Forces actor to sheathe weapon, and wait untill they do so

    Use <DisableWeapons> to prevent actor from drawing the weapon again

    Parameters:

        akActor     - Target actor
/;
Function SheatWeapons(Actor akActor) global
    akActor.SheatheWeapon()
    while (akActor.IsWeaponDrawn())
        Utility.wait(0.1)
    endwhile
EndFunction

;/  Function: DisableWeapons
    Prevents NPC (not player) from drawing weapon. Also sheaths the actor weapon if its drawn

    Use <EnableWeapons> to enable weapons again

    This effect is not persistent, and will be removed on game reload
    
    Parameters:

        akActor     - Target actor
/;
Function DisableWeapons(Actor akActor) global
    UD_Native.DisableWeapons(akActor,true)
    SheatWeapons(akActor)
EndFunction

;/  Function: EnableWeapons
    Alows NPC again to draw weapon. Does nothing to player

    Does nothing if <DisableWeapons> was not called before
    
    Parameters:

        akActor     - Target actor
/;
Function EnableWeapons(Actor akActor) global
    UD_Native.DisableWeapons(akActor,false)
EndFunction


;/  Group: Menu
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: closeMenu

    Closes all following menus

    - Container menu
    - Dialogue menu
    - Inventory menu
    - Tween menu
    - Gift menu
/;
Function closeMenu() global
    ;https://www.reddit.com/r/skyrimmods/comments/elg97s/function_to_close_objects_container_menu/
    UI.InvokeString("ContainerMenu", "_global.skse.CloseMenu", "ContainerMenu")
    UI.InvokeString("Dialogue Menu", "_global.skse.CloseMenu", "Dialogue Menu")
    UI.InvokeString("InventoryMenu", "_global.skse.CloseMenu", "InventoryMenu")
    UI.InvokeString("TweenMenu", "_global.skse.CloseMenu", "TweenMenu")
    UI.InvokeString("GiftMenu", "_global.skse.CloseMenu", "GiftMenu")
EndFunction


;/  Function: closeLockpickMenu

    Closes lockpick menu
/;
Function closeLockpickMenu() global
    UI.InvokeString("Lockpicking Menu", "_global.skse.CloseMenu", "Lockpicking Menu")
EndFunction


;/  Function: IsMenuOpen

    This function check if any menu is open. It is much faster then its UI couterpart

    Returns:

        True if any menu is open
/;
Bool Function IsMenuOpen()
    return UDMC.UD_MenuOpened
EndFunction

;/  Function: IsMenuOpenRaw

    This function check if any menu is open. Ignores all checks.

    Returns:

        True if ANY menu is open
/;
Bool Function IsAnyMenuOpen()
    return UDMC.UD_MenuListIDBit
EndFunction

;/  Function: IsAnyMenuOpenRT

    This function check if any menu is open. Should be used only in relevance to runtime waits (Wait x WaitMenuMode)

    Returns:

        True if ANY menu is open and SkyrimSoulsInstalled is not installed
/;
Bool Function IsAnyMenuOpenRT()
    return UDMC.UD_MenuListIDBit && !SkyrimSoulsInstalled
EndFunction

;/  Function: IsMenuOpenID

    This function check if specific menu is open

    Parameters:

        aiID   - ID of menu which should be checked. See <Menus ID>

    Returns:

        True if menu with aiID is open
/;
Bool Function IsMenuOpenID(int aiID)
    return UDMC.isMenuOpen(iRange(aiID,0,UDMC.UD_MenuListID.length))
EndFunction

;/  Function: GetOpenMenuMap

    Get bit coded currently opened menus

    Returns:

        Bit coded menus
/;
Int Function GetOpenMenuMap()
    return UDMC.UD_MenuListIDBit
EndFunction

;/  Function: IsContainerMenuOpen

    Returns:

        True if *Container* menu is open
/;
Bool Function IsContainerMenuOpen()
    return UDMC.IsMenuOpen(0)
EndFunction

;/  Function: IsLockpickingMenuOpen

    Returns:

        True if *Lockpicking* menu is open
/;
Bool Function IsLockpickingMenuOpen()
    return UDMC.IsMenuOpen(1)
EndFunction

;/  Function: IsInventoryMenuOpen

    Returns:

        True if *Inventory* menu is open
/;
Bool Function IsInventoryMenuOpen()
    return UDMC.IsMenuOpen(2)
EndFunction

;/  Function: IsMessageboxOpen

    Returns:

        True if *Messagebox* menu is open
/;
Bool Function IsMessageboxOpen()
    return UDMC.IsMenuOpen(13) || UI.IsMenuOpen("MessageBoxMenu") ;I hope to god that this works
EndFunction


;/  Group: Static slos
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: GetStaticSlots

    Parameters:

        asName  - Name of static slots

    Returns:

        Static slots
/;
UD_StaticNPCSlots Function GetStaticSlots(String asName)
    return UDNPCM.GetStaticSlots(asName)
EndFunction