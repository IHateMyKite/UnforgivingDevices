;   File: UnforgivingDevicesMain
;   This is main script of Unforgiving Devices, which contains most important functions and propertiest filled with references to other scripts
Scriptname UnforgivingDevicesMain extends Quest  conditional
{Main script of Unforgiving Devices}


Quest       Property UD_UtilityQuest    auto

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
    This module contains funtions for manipulating devices
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
    
    This module contains functionality for locking random devices on actors
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

;/  Variable: UDUI
    
    Meaning: User Input
    
    This module contains functionality for getting user input
/;
UD_UserInputScript                  Property UDUI           auto

;/  Variable: UDAM
    
    Meaning: Animation mMnager
    
    This module contains functionality for manipulating animations
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
    
    This module contains functions for fastly checking if menu is open
/;
UD_MenuChecker                      Property UDMC Hidden
    UD_MenuChecker Function get() 
        return UD_UtilityQuest as UD_MenuChecker
    EndFunction
EndProperty

;/  Variable: UDWC
    
    Meaning: Widget Control
    
    This module contains functions for manipulating widgets
/;
UD_WidgetControl                    Property UDWC           Auto

;/  Variable: UDGV
    
    Meaning: Global Variable
    
    This module contains properties with global variables
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
/;
UD_OrgasmManager                    Property UDOMNPC        auto

;/  Variable: UDOMPlayer
    
    Meaning: Player Orgasm Manager
    
    This module contains functionality for manipulating orgasm variables
    
    Only use this on Player!! Using it on NPC might break the framework!
/;
UD_OrgasmManager                    Property UDOMPlayer     auto

;/  Variable: UDOM
    
    Meaning: Orgasm Manager
    
    Default Orgasm Manager. Do not use for manipulations, but only for reading MCM variables
/;
UD_OrgasmManager                    Property UDOM Hidden
    UD_OrgasmManager Function get()
        return UDOMNPC ;NPC one is used as main one for storring MCM values
    EndFunction
EndProperty


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
    if ActorIsPlayer(akActor)
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

bool Property ZaZAnimationPackInstalled = false auto hidden
;zbfBondageShell Property ZAZBS auto
bool Property OSLArousedInstalled       = false auto hidden
bool Property ConsoleUtilInstalled      = false auto hidden
bool Property SlaveTatsInstalled        = false auto hidden
bool Property OrdinatorInstalled        = false auto hidden
bool Property ZadExpressionSystemInstalled = false auto hidden
Bool Property DeviousStrikeInstalled    = False auto hidden
Bool Property ForHimInstalled           = False auto hidden
Bool Property PO3Installed              = False auto hidden ;https://www.nexusmods.com/skyrimspecialedition/mods/22854

Bool Property AllowMenBondage           = True auto hidden

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

Event OnInit()
    Player = Game.GetPlayer()
    
    Utility.waitmenumode(3.0)
    Print("Installing Unforgiving Devices...")
    if zadbq.modVersion
        ;DD is already installed when UD is installed
        ;UD will not correctly replace DD script when they are already set update
        ;because of that UD is incompatible with already ongoing DD moded game
        string loc_msg = "!!!!ERROR!!!!\n"
        loc_msg += "Unforgiving Devices detected that it was installed on already ongoing game. "
        loc_msg += "Without starting fresh game, UD will not be able to use mutexes which are needed for safe run of the mod. "
        loc_msg += "\n\n!Please consider starting new game for the best experience.!"
        debug.messagebox(loc_msg)
    endif
    

    if CheckSubModules()
        RegisterForSingleUpdate(1.0)
    else
        DISABLE() ;disable UD
    endif
EndEvent

;/  Function: CheckSubModules

    This function will check all submodul scripts and returns if true if they are all ready

    In case one or more scripts don't get ready in first 20 seconds, it will toggle mod to error state, preventing any furthere gameplay. User needs to reload the save in hope that it will fix the issue.
    
    Returns:

        Returns true if all submodules are ready and there is not error
/;
Bool Function CheckSubModules()
    Bool    loc_cond = False
    Int     loc_elapsedTime = 0
    while !loc_cond && loc_elapsedTime < 20
        loc_cond = True
        loc_cond = loc_cond && UDlibs.ready
        loc_cond = loc_cond && UDCDmain.ready
        loc_cond = loc_cond && config.ready
        loc_cond = loc_cond && ItemManager.ready
        loc_cond = loc_cond && UDLLP.ready
        loc_cond = loc_cond && UDOM.ready
        
        if !loc_cond
            Utility.WaitMenuMode(1.0)
            loc_elapsedTime += 1
        endif
    endwhile
    
    ;check for fatal error
    if !loc_cond
        _FatalError = True
        ShowSingleMessageBox("!!FATAL ERROR!!\nError loading Unforgiving devices. One or more of the modules are not ready. Please contact developers on LL or GitHub")
        
        String loc_modules = "--MODULES--\n"
        loc_modules += "UDlibs="+UDlibs.ready + "\n"
        loc_modules += "UDCDmain="+UDCDmain.ready + "\n"
        loc_modules += "config="+config.ready + "\n"
        loc_modules += "ItemManager="+ItemManager.ready + "\n"
        loc_modules += "UDLLP="+UDLLP.ready + "\n"
        loc_modules += "UDOM="+UDOM.ready + "\n"
        ShowMessageBox(loc_modules)
        
        ;Dumb info to console, use GInfo to skip ConsoleUtil installation check
        GInfo("!!FATAL ERROR!! = Error loading Unforgiving devices. One or more of the modules are not ready. Please contact developrs on LL or GitHub")
        GInfo("UDlibs="+UDlibs.ready)
        GInfo("UDCDmain="+UDCDmain.ready)
        GInfo("config="+config.ready)
        GInfo("ItemManager="+ItemManager.ready)
        GInfo("UDLLP="+UDLLP.ready)
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

        True if mod is not updating, not disabled and is ready
/;
Bool Function IsEnabled()
    return !_Disabled && !_Updating && ready
EndFunction

;Previous sattes of scripts, so they are returned to correct state

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

Function OnGameReload()
    if _Disabled
        return ;mod is disabled, do nothing
    endif
    
    if _Updating
        return ;mod is already updating, most likely because user saved the game while the mod was already updating
    endif
    
    if !CheckSubModules()
        return ;Fatal error when initializing UD
    endif
    
    _Updating = True
    DISABLE()
    
    Utility.waitMenuMode(1.5)
    
    Print("Updating Unforgiving Devices, please wait...")
    
    if !Ready
        Utility.waitMenuMode(2.5)
    endif
    
    Utility.waitMenuMode(1.5)
    
    CLog("OnGameReload() called! - Updating Unforgiving Devices...")
    
    ;update all scripts
    Update()
    
    if UDWC.Ready
        UDWC.Update()
    else
        Error("Can't update UDWC because the script is not ready")
    endif
    
    UDMC.Update()
    
    BoundCombat.Update()
    
    UDlibs.Update()
    
    UDCDMain.Update()

    Config.Update()
    
    UDPP.Update()
    
    UDOMNPC.Update()  ;NPC orgasm manager
    UDOMPlayer.Update() ;player orgasm manager
    
    UDEM.Update()
    
    UDNPCM.GameUpdate()
    
    UDLLP.Update()

    UDRRM.Update()
    
    if UDAM.Ready
        UDAM.Update()
    endif
    
    if UDCM.Ready
        UDCM.Update()
    endif

    UDAbadonQuest.Update()
    
    Info("<=====| Unforgiving Devices updated |=====>")
    
    _Updating = False
    ENABLE()
    
    Print("Unforgiving Devices updated")
    
EndFunction

Event OnUpdate()
    Update()
EndEvent

Function Update()
    if !Player
        CLog("Detected that Player ref is not ready. Setting variable")
        Player = Game.GetPlayer()
    endif
    
    if !UDEM
        Error("UDEM not loaded! Loading...")
        UDEM = GetMeMyForm(0x156417,"UnforgivingDevices.esp") as UD_ExpressionManager
        Error("UDEM set to "+UDEM)
    endif

    if !UDPP
        Error("UDPP not loaded! Loading...")
        UDPP = (self as Quest) as UD_ParalelProcess
        Error("UDPP set to "+UDPP)
    endif
    
    if !UDNPCM
        Error("UDNPCM not loaded! Loading...")
        UDNPCM = GetMeMyForm(0x14E7EB,"UnforgivingDevices.esp") as UD_CustomDevices_NPCSlotsManager
        Error("UDNPCM set to "+UDNPCM)
    endif
    
    if !UDMM
        Error("UDMM not loaded! Loading...")
        UDMM = GetMeMyForm(0x15B555,"UnforgivingDevices.esp") as UD_MutexManagerScript
        Error("UDMM set to "+UDMM)
    endif
    
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
    
    _CheckOptionalMods()
    _CheckPatchesOrder()
    
    if !Ready
        UD_hightPerformance = UD_hightPerformance
        UDlibs.OrgasmExhaustionSpell.SetNthEffectDuration(0, 180) ;for backward compatibility
        
        RegisterForModEvent("UD_VibEvent","EventVib")
        
        Info("<=====| UnforgivingDevicesMain installed |=====>")
        
        Print("Unforgiving Devices Ready!")
        
        Ready = true
    endif
    
    SendModEvent("UD_PatchUpdate") ;send update event to all patches. Will force patches to check if they are installed correctly
    
    UDCDmain.UpdateQuestKeywords()
    UDCDmain.UpdateGenericKeys()
EndFunction

Function _CheckOptionalMods()
    UDNPCM.ResetIncompatibleFactionArray() ;reset incomatible scan factions
    
    If ModInstalled("ZaZAnimationPack.esm")
        ZaZAnimationPackInstalled = True
        if TraceAllowed()
            Log("Zaz animation pack detected!")
        endif
    else
        ZaZAnimationPackInstalled = False
    endif
    
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
    
    if ConsoleUtil.GetVersion()
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
    
    if PO3_SKSEFunctions.GetPapyrusExtenderVersion()
        PO3Installed = True
    else
        PO3Installed = False
    endif
    
EndFUnction

Function _CheckPatchesOrder()
    int loc_it = 0
    while loc_it < UD_OfficialPatches.length
        if ModInstalled(UD_OfficialPatches[loc_it])
            if !ModInstalledAfterUD(UD_OfficialPatches[loc_it])
                debug.messagebox("--!ERROR!--\nUD detected that patch "+ UD_OfficialPatches[loc_it] +" is loaded before main mod! Patch always needs to be loaded after main mod or it will not work!!! Please change the load order, and reload save.")
            endif
        endif
        loc_it += 1
    endwhile
EndFunction

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
    Utility.wait(Utility.randomFloat(afMin,afMax))
EndFunction

;/  Function: WaitMenuRandomTime

    Same as <WaitRandomTime>, but will also work if menus are open
/;
Function WaitMenuRandomTime(Float afMin = 0.1, Float afMax = 1.0) Global
    Utility.waitMenuMode(Utility.randomFloat(afMin,afMax))
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

int Function codeBit_old(int iCodedMap,int iValue,int iSize,int iIndex) global
    if iIndex + iSize > 32
        return 0xFFFFFFFF ;returns error value
    endif
    int loc_clear_mask = 0x00000001 ;mask used to clear bits which will be set
    ;sets not shifted bit mask loc_clear_mask
    int loc_help_bit = 0x02
    while iSize > 1
        iSize -= 1
        loc_clear_mask = Math.LogicalOr(loc_clear_mask,loc_help_bit)
        loc_help_bit = Math.LeftShift(loc_help_bit,1)
    endwhile
    iValue = Math.LogicalAnd(loc_clear_mask,iValue)
    loc_clear_mask = Math.LogicalXor(Math.LeftShift(loc_clear_mask,iIndex),0xFFFFFFFF) ;shift and negate
    int loc_clear_map = Math.LogicalAnd(iCodedMap,loc_clear_mask) ;clear maps bits with mask
    return Math.LogicalOr(loc_clear_map,Math.LeftShift(iValue,iIndex)) ;sets bits
endfunction

;/  Function: codeBit

    Parameters:

        aiCodedMap   - Integer in to which should be additiona information coded
        aiValue      - Value to be coded in to passed aiCodedMap
        aiSize       - Size in bites of the information from aiValue
        aiIndex      - Start index from which will be information coded on aiCodedMap. Sum of aiIndex and aiSize have to be less then 32!

    Returns:

        *aiCodedMap* with coded *aiValue*. Returns *0xFFFFFFFF* in case of error

    _Example_:
        --- Code
        Int loc_map = 0x00000000                ;input value
            loc_map = codeBit(loc_map,0xF,4,27) ;change last four bits to 1
        ---
/;
int Function codeBit(int aiCodedMap,int aiValue,int aiSize,int aiIndex) global
    if aiIndex + aiSize > 32
        return 0xFFFFFFFF ;returns error value
    endif
    ;sets not shifted bit mask loc_clear_mask
    int loc_clear_mask = (Math.LeftShift(0x1,aiSize) - 1)                     ;mask used to clear bits which will be set
    aiValue = Math.LeftShift(Math.LogicalAnd(aiValue,loc_clear_mask),aiIndex)    ;clear value from bigger bits
    loc_clear_mask = Math.LogicalNot(Math.LeftShift(loc_clear_mask,aiIndex)) ;shift and negate
    aiCodedMap = Math.LogicalAnd(aiCodedMap,loc_clear_mask)                     ;clear maps bits with mask
    return Math.LogicalOr(aiCodedMap,aiValue)                                 ;sets bits
endfunction

int Function decodeBit_old(int iCodedMap,int iSize,int iIndex) global
    if iIndex + iSize > 32
        return 0xFFFFFFFF ;returns error value
    endif
    
    ;sets not shifted bit mask
    int loc_clear_mask = 0x00000001 ;mask used to clear all not wanted bits
    
    ;sets not shifted bit mask loc_clear_mask
    int loc_help_bit = 0x02
    while iSize > 1
        iSize -= 1
        loc_clear_mask = Math.LogicalOr(loc_clear_mask,loc_help_bit)
        loc_help_bit = Math.LeftShift(loc_help_bit,1)
    endwhile    
    
    loc_clear_mask = Math.LeftShift(loc_clear_mask,iIndex) ;shift to index position
    
    int loc_res = 0x00000000 ;return value, default is int
    loc_res = Math.LogicalAnd(iCodedMap,loc_clear_mask) ;clear maps bits with mask
    loc_res = Math.RightShift(loc_res,iIndex) ;shift to right, so value is correct
    return loc_res
EndFunction

;/  Function: decodeBit

    Parameters:

        aiCodedMap   - Integer from which should be information decoded
        aiSize       - Size in bites of the information which will be decoded
        aiIndex      - Start index from which will be information decoded from aiCodedMap. Sum of aiIndex and aiSize have to be less then 32!

    Returns:

        Decoded value from *iCodedMap*. Returns *0xFFFFFFFF* in case of error
        
    _Example_:
        --- Code
        Int loc_map = 0x000000F0             ;input value
        Int loc_res = decodeBit(loc_map,4,3) ;decode value and save it to loc_res. Value in result will be 0xF = 15.
        ---
/;
int Function decodeBit(int aiCodedMap,int aiSize,int aiIndex) global
    if aiIndex + aiSize > 32
        return 0xFFFFFFFF ;returns error value
    endif
    ;sets not shifted bit mask
    aiCodedMap = Math.RightShift(aiCodedMap,aiIndex) ;shift to right, so value is correct
    aiCodedMap = Math.LogicalAnd(aiCodedMap,(Math.LeftShift(0x1,aiSize) - 1)) ;clear maps bits with mask
    return aiCodedMap
EndFunction

;/  Function: fRange

    Truncate passed FLOAT value between two limits

    Parameters:

        afValue      - Value to be truncated
        afMin        - Minimum value
        afMax        - Maximum value

    Returns:

        Truncated value
/;
float Function fRange(float afValue,float afMin,float afMax) global
    if afValue > afMax
        return afMax
    endif
    if afValue < afMin
        return afMin
    endif
    return afValue
EndFunction

;/  Function: iRange

    Truncate passed INT value between two limits

    Parameters:

        aiValue      - Value to be truncated
        afMin        - Minimum value
        afMax        - Maximum value

    Returns:

        Truncated value
/;
int Function iRange(int aiValue,int aiMin,int aiMax) global
    if aiValue > aiMax
        return aiMax
    endif
    if aiValue < aiMin
        return aiMin
    endif
    return aiValue
EndFunction

;/  Function: iInRange

    Checks if passed value is in range

    Parameters:

        aiValue      - Value to be checked
        aiMin        - Minimum value
        aiMax        - Maximum value

    Returns:

        False if value is less then minimum or more then maximum
/;
Bool Function iInRange(int aiValue,int aiMin,int aiMax) global
    if aiValue > aiMax
        return false
    endif
    if aiValue < aiMin
        return false
    endif
    return true
EndFunction

;/  Function: fInRange

    Checks if passed value is in range

    Parameters:

        afValue      - Value to be checked
        afMin        - Minimum value
        afMax        - Maximum value

    Returns:

        False if value is less then minimum or more then maximum
/;
Bool Function fInRange(float afValue,float afMin,float afMax) global
    if afValue > afMax
        return false
    endif
    if afValue < afMin
        return false
    endif
    return true
EndFunction

;/  Function: formatString

    Formats float stored in string, so it can show only passed number of floating points

    Parameters:

        asValue         - Number which will be formated
        afFloatPoints   - Number of floating points to show

    Returns:

        Formated number in string

    _Example_:
        --- Code
        Float   loc_number      = 1.2345                            ;input value
        String  loc_formated    = formatString(loc_number,2)        ;formats number so it only shows 2 decimal points
        Print(loc_formated)                                         ;Will print 1.23 only
        ---
/;
string Function formatString(string asValue,int afFloatPoints) global
    int loc_floatPoint =  StringUtil.find(asValue,".")
    if (loc_floatPoint < 0)
        return asValue
    endif
    if ((afFloatPoints + loc_floatPoint + 1) > StringUtil.getLength(asValue))
        return asValue
    else
        return StringUtil.Substring(asValue, 0, loc_floatPoint + afFloatPoints + 1)
    endif
EndFunction

;/  Function: checkLimit

    Truncate passed value only in positive direction

    Parameters:

        afValue      - Value to be checked
        afLimit      - Number limit

    Returns:

        Returns truncated number so it is never more then afLimit
/;
float Function checkLimit(float afValue,float afLimit) global
    if afValue > afLimit
        return afLimit
    else
        return afValue
    endif
EndFunction


;/  Function: Round

    Round the FLOAT number to INT

    Parameters:

        afValue      - Value to be  rounded

    Returns:

        Rounded afValue

    _Example_:
        --- Code
        Round(0.1) -> Returns 0
        Round(0.4) -> Returns 0
        Round(0.5) -> Returns 1
        Round(0.9) -> Returns 1
        ---
/;
int Function Round(float afValue) global
    return Math.floor(afValue + 0.5)
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

;/  Function: fUnsig

    Truncate negative values from passed FLOAT

    Parameters:

        afValue     - Value to be truncated

    Returns:

        Truncated value

    _Example_:

    See <iUnsig>
/;
Float Function fUnsig(float afValue) global
    if afValue < 0.0
        return 0.0
    endif
    return afValue
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

        apList  - String array of list elements which will be shown in menu

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
Function ShowMessageBox(string asText)
    String[]    loc_lines = StringUtil.split(asText,"\n")
    int         loc_linesNum = loc_lines.length
    
    int         loc_lineLimit = 12
    
    int         loc_boxesNum = Math.Ceiling((loc_linesNum as float)/(loc_lineLimit as float))
    int         loc_iterLine = 0
    int         loc_iterBox = 0
    
    while loc_iterBox < (loc_boxesNum)
        string loc_messagebox = ""
        
        while loc_iterLine < iRange((loc_linesNum - loc_lineLimit*loc_iterBox),0,loc_lineLimit)
            loc_messagebox += (loc_lines[loc_iterLine + (loc_lineLimit)*loc_iterBox] + "\n")
            loc_iterLine += 1
        endwhile
        
        loc_iterBox += 1
        
        if loc_boxesNum > 1
            loc_messagebox += "===PAGE " + (loc_iterBox) + "/" + (loc_boxesNum) + "===\n"
        endif
        loc_iterLine = 0
        
        ShowSingleMessageBox(loc_messagebox)
    endwhile
EndFunction

;/  Function: ShowSingleMessageBox

    Shows message box with passed string.

    This function will be blocked until user clicks on OK button (this is not done by debug.messagebox function)

    Parameters:

        asMessage     - String to be shown in message box
/;
Function ShowSingleMessageBox(String asMessage)
    debug.messagebox(asMessage)
    ;wait for fucking messagebox to actually get OKd before continuing thread (holy FUCKING shit toad)
    Utility.waitMenuMode(0.3)
    while IsMessageboxOpen()
        Utility.waitMenuMode(0.05)
    EndWhile
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


;/  Function: ActorIsPlayer

    Parameters:

        akActor   - Actor which will be checked

    Returns:

        True if passed akActor is player
/;
bool Function ActorIsPlayer(Actor akActor)
    return akActor == Player
EndFunction

;/  Function: GActorIsPlayer

    Global version of <ActorIsPlayer>. This function is generaly slower, and its non-global variant should be used instead.

    Parameters:

        akActor   - Actor which will be checked

    Returns:

        True if passed *akActor* is player
/;
bool Function GActorIsPlayer(Actor akActor) global
    return akActor == Game.getPlayer()
EndFunction

;/  Function: GetActorName

    Parameters:

        akActor   - Actor whose name will be returned

    Returns:

        Name of passed actor. Returns *"ERROR:NONE"* if passed actor is none. Returns *"Unnamed X"* if actor have no name.
/;
string Function GetActorName(Actor akActor) global
    if !akActor
        return "ERROR:NONE"
    endif
    ActorBase loc_actorbase = akActor.GetLeveledActorBase()
    string loc_res = loc_actorbase.getName()
    if loc_res == "" ;actor have no name
        if loc_actorbase.GetSex() == 0
            loc_res = "Unnamed man"
        elseif loc_actorbase.GetSex() == 1
            loc_res = "Unnamed woman"
        else
            loc_res = "Unnamed person"
        endif
    endif
    return loc_res
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
    if ActorIsPlayer(akActor)
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
    return UDMC.IsMenuOpen(13) ;I hope to god that this works
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