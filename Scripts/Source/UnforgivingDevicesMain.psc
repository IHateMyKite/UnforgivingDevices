Scriptname UnforgivingDevicesMain extends Quest  conditional
{Main script of Unforgiving Devices}

zadlibs     property libs               auto 
zadxlibs    property libsx              auto
zadxlibs2   property libsx2             auto
Quest       Property UD_UtilityQuest    auto

Actor Property Player auto hidden

;patched zadlibs
zadlibs_UDPatch property libsp
    zadlibs_UDPatch Function get()
        return libs as zadlibs_UDPatch
    EndFunction
EndProperty
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

UD_libs                 Property UDlibs         auto
UDCustomDeviceMain      Property UDCDmain       auto
UD_AbadonQuest_script   Property UDAbadonQuest  auto

bool Property UD_AutoLoad = false auto

UD_MCM_script                       Property config         Auto
UDItemManager                       Property ItemManager    auto
UD_RandomRestraintManager           Property UDRRM          auto
UD_LeveledList_Patcher              Property UDLLP          auto
UD_OrgasmManager                    Property UDOM           auto
UD_ExpressionManager                Property UDEM           auto
UD_ParalelProcess                   Property UDPP           auto
UD_CustomDevices_NPCSlotsManager    Property UDNPCM         auto
UD_MutexManagerScript               Property UDMM           auto
UD_ModifierManager_Script           Property UDMOM          auto
UD_UserInputScript                  Property UDUI           auto
UD_AnimationManagerScript           Property UDAM           auto
UD_CompatibilityManager_Script      Property UDCM           auto
UD_MenuChecker                      Property UDMC
    UD_MenuChecker Function get()
        return UD_UtilityQuest as UD_MenuChecker
    EndFunction
EndProperty
UD_WidgetControl                    Property UDWC
    UD_WidgetControl Function get()
        return UD_UtilityQuest as UD_WidgetControl
    EndFunction
EndProperty
UD_SkillManager_Script              Property UDSKILL
    UD_SkillManager_Script Function get()
        return (UDCDmain as Quest) as UD_SkillManager_Script
    EndFunction
EndProperty

;UI menus
UITextEntryMenu Property TextMenu                       auto
UIListMenu      Property ListMenu                       auto

;IWantWidgets. Not currently used, but have some ideas for future. No scripts are currently required to compile
Bool    Property iWidgetInstalled          = False      auto
Quest   Property iWidgetQuest                           auto
Bool Function UseiWW()
    return iWidgetInstalled && UDWC.UD_UseIWantWidget
EndFunction
;Global switches
bool    property lockMCM                   = False      auto hidden
bool    property UD_LockDebugMCM           = False      auto hidden
bool    property DebugMod                  = False      auto hidden conditional
bool    Property AllowNPCSupport           = False      auto
Bool    Property UD_WarningAllowed         = False      auto hidden
bool    Property UD_DisableUpdate          = False      auto hidden conditional
bool    Property UD_CheckAllKw             = False      auto hidden conditional

;zadlibs patch control
bool Property UD_zadlibs_ParalelProccesing = false auto

Spell   OrgasmExhaustionSpell
bool    _UD_hightPerformance
bool Property UD_hightPerformance
    Function set(bool bValue)
        _UD_hightPerformance = bValue
        if _UD_hightPerformance 
            UD_baseUpdateTime = UD_HightPerformanceTime
            ;ItemManager.UD_WaitTime = 0.3
        else
            UD_baseUpdateTime = UD_LowPerformanceTime
            ;ItemManager.UD_WaitTime = 0.8
        endif
    EndFunction
    
    bool Function get()
        return _UD_hightPerformance
    EndFunction
EndProperty

float Property UD_LowPerformanceTime    = 1.0   autoreadonly
float Property UD_HightPerformanceTime  = 0.25  autoreadonly
float Property UD_baseUpdateTime                auto
zadConfig   Property DDconfig                   auto
String[]    Property UD_OfficialPatches         auto

bool Property ZaZAnimationPackInstalled = false auto
;zbfBondageShell Property ZAZBS auto
bool Property OSLArousedInstalled       = false auto
bool Property ConsoleUtilInstalled      = false auto
bool Property SlaveTatsInstalled        = false auto
bool Property OrdinatorInstalled        = false auto
bool Property ZadExpressionSystemInstalled = false auto
Bool Property DeviousStrikeInstalled    = False auto

bool Property Ready = False auto hidden
bool Function UDReady()
    return Ready
EndFunction

Event OnInit()
    Utility.waitmenumode(3.0)
    Print("Installing Unforgiving Devices...")
    if zadbq.modVersion
        ;DD is already installed when UD is installed
        ;UD will not correctly replace DD script when they are already set update
        ;because of that UD is incompatible with already ongoing DD moded game
        string loc_msg = "!!!!ERROR!!!!\n"
        loc_msg += "Unforgiving Devices detected that it was installed on already ongoing game. "
        loc_msg += "Without starting fresh game, UD will not be able to use mutexes which are needed for safety run of the mod. "
        loc_msg += "\n\n!Please, consider starting new game for best experience.!"
        debug.messagebox(loc_msg)
    endif
    While !UDlibs.ready
        Utility.waitMenuMode(0.25)
    EndWhile
    if TraceAllowed()    
        Log("UDLibs ready!",0)
    endif
    While !UDCDmain.ready
        Utility.waitMenuMode(0.25)
    EndWhile
    if TraceAllowed()    
        Log("UDCDmain ready!",0)
    endif
    While !config.ready
        Utility.waitMenuMode(0.25)
    EndWhile    
    if TraceAllowed()    
        Log("config ready!",0)
    endif
    While !ItemManager.ready
        Utility.waitMenuMode(0.25)
    EndWhile        
    if TraceAllowed()    
        Log("ItemManager ready!",0)
    endif
    While !UDLLP.ready
        Utility.waitMenuMode(0.25)
    endwhile
    if TraceAllowed()    
        Log("UDLLP ready!",0)
    endif

    While !UDOM.ready
        Utility.WaitMenuMode(0.1)
    endwhile
    if TraceAllowed()    
        Log("UDOM ready!",0)
    endif
    
    UD_hightPerformance = UD_hightPerformance
    
    OrgasmExhaustionSpell = UDlibs.OrgasmExhaustionSpell
    OrgasmExhaustionSpell.SetNthEffectDuration(0, 180) ;for backward compatibility

    if UD_hightPerformance
        UD_baseUpdateTime = UD_HightPerformanceTime
    else
        UD_baseUpdateTime = UD_LowPerformanceTime
    endif
    
    Player = Game.GetPlayer()
    
    CheckOptionalMods()
    
    if TraceAllowed()    
        Log("UnforgivingDevicesMain initialized",0)
    endif
    Print("Unforgiving Devices Ready!")
    Utility.wait(5.0)
    RegisterForModEvent("UD_VibEvent","EventVib")
    RegisterForSingleUpdate(0.1)
EndEvent

Function OnGameReload()
    if !Ready
        Utility.waitMenuMode(2.5)
    endif
    
    Utility.waitMenuMode(3.5)
        
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
    
    UDOM.Update()
    
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
    
    CLog("Unforgiving Devices updated.")
EndFunction

Event OnUpdate()
    Update()
EndEvent

Function Update()
    if !Player
        CLog("Detected that Player ref is not ready. Setting variable")
        Player = Game.GetPlayer()
    endif
    
    if !UDOM
        Error("UDOM not loaded! Loading...")
        UDOM = GetMeMyForm(0x15B532,"UnforgivingDevices.esp") as UD_OrgasmManager
        Error("UDOM set to "+UDOM)
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
    
    if !Ready
        Ready = true
        Info("Detected that UD is not ready. Changing state to ready.")
    endif
    
    CheckOptionalMods()
    CheckPatchesOrder()
EndFunction

Function CheckOptionalMods()
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
        debug.messagebox("--!ERROR!--\nUD can't detect UIExtensions. Without this mode, some features of Unforgiving Devices will not work as intended. Please be warned.")
    endif
    
    if ConsoleUtil.GetVersion()
        ConsoleUtilInstalled = True
        if TraceAllowed()
            Log("ConsoleUtil detected!")
        endif
    else
        debug.messagebox("--!ERROR!--\nUD can't detect ConsoleUtil. Without this mode, some features of Unforgiving Devices will not work as intended. Please be warned.")
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
    iWidgetInstalled = true
    
    iWidgetQuest = GetMeMyForm(0x000800,"iWant Widgets LE.esp") as Quest
    if !iWidgetQuest
        iWidgetQuest = GetMeMyForm(0x000800,"iWant Widgets.esl") as Quest
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
        ;2 Factions, as it looks like that the forID changes between versions
        UDNPCM.AddScanIncompatibleFaction(GetMeMyForm(0x000801,"Devious Strike.esp") as Faction) 
        UDNPCM.AddScanIncompatibleFaction(GetMeMyForm(0x005930,"Devious Strike.esp") as Faction)
    else
        DeviousStrikeInstalled = false
    endif
EndFUnction

Function CheckPatchesOrder()
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

int Function getDDescapeDifficulty()
    if UDCDmain.UD_UseDDdifficulty
        return (8 - DDconfig.EscapeDifficulty)
    else
        return 4
    endif
EndFunction

Function addOrgasmExhaustion(Actor akActor)
    OrgasmExhaustionSpell.cast(akActor)
    if TraceAllowed()    
        Log("Orgasm exhaustion debuff applied to "+ getActorName(akActor),1)
    endif
EndFunction

bool function hasAnyUD()
    return Player.wornhaskeyword(libs.zad_Lockable)
endfunction

;vib function queue
Function startVibEffect(Actor akActor,int strength,int duration,bool edge)
    int handle = ModEvent.Create("UD_VibEvent")
    ModEvent.PushForm(handle,akActor)
    ModEvent.PushInt(handle,strength)
    ModEvent.PushInt(handle,duration)
    ModEvent.pushBool(handle,edge)
    ModEvent.Send(handle)
EndFunction

Event EventVib(Form fActor, int strenght, int duration, bool edge)
    libs.VibrateEffect(fActor as Actor, strenght, duration, edge)
EndEvent

int Property LogLevel = 0 auto
Function Log(String msg, int level = 1)
    if (iRange(level,1,3) <= LogLevel) || DebugMod
        debug.trace("[UD," + level + ",T="+Utility.GetCurrentRealTime()+"]: " + msg)
        if ConsoleUtilInstalled ;print to console
            ConsoleUtil.PrintMessage("[UD," + level + ",T="+Utility.GetCurrentRealTime()+"]: " + msg)
        endif
    endif
EndFunction

Function CLog(String msg)
    if ConsoleUtilInstalled ;print to console
        ConsoleUtil.PrintMessage("[UD,INFO,T="+Utility.GetCurrentRealTime()+"]: " + msg)
    endif
EndFunction

int Property UD_PrintLevel = 3 auto
Function Print(String msg,int iLevel = 1,bool bLog = false)
    if (iRange(iLevel,0,3) <= UD_PrintLevel)
        ; debug.notification(msg)
        UDWC.ShowNotification(msg)
        if bLog || TraceAllowed()
            Log("Print -> " + msg)
        endif
    endif
EndFunction

Function Error(String msg)
    debug.trace("[UD,!ERROR!,T="+Utility.GetCurrentRealTime()+"]: " + msg)
    if ConsoleUtilInstalled ;print to console
        ConsoleUtil.PrintMessage("[UD,!ERROR!,T="+Utility.GetCurrentRealTime()+"]: " + msg)
    endif
EndFunction

Function Warning(String msg)
    string loc_msg = "[UD,WARNING,T="+Utility.GetCurrentRealTime()+"]: " + msg
    debug.trace(loc_msg)
    if ConsoleUtilInstalled ;print to console
        ConsoleUtil.PrintMessage(loc_msg)
    endif
EndFunction

Function Info(String msg)
    string loc_msg = "[UD,INFO,T="+Utility.GetCurrentRealTime()+"]: " + msg
    debug.trace(loc_msg)
    if ConsoleUtilInstalled ;print to console
        ConsoleUtil.PrintMessage(loc_msg)
    endif
EndFunction

bool Function ActorIsFollower(Actor akActor)
    ;added check for followers that are not marked as followers by normal means, to make loc_res == 4 from UDCustomDeviceMain.NPCMenu() work on them as well
    ;yes yes, some of the followers don't have FollowerFaction assigned, DCL uses similar check for those.
    string acName = akActor.GetDisplayName()
    if acName == "Serana" || acName == "Inigo" || acName == "Sofia" || acName == "Vilja"
        return true
    endif
    return akActor.isInFaction(UDCDmain.FollowerFaction)
EndFunction

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
    return true
EndFunction

int Property UD_HearingRange = 4000 auto
bool Function ActorInCloseRange(Actor akActor)
    if ActorIsPlayer(akActor)
        return true
    endif
    float loc_distance = CalcDistance(Player,akActor)
    return (loc_distance >= 0 && loc_distance < UD_HearingRange)
EndFunction

bool Function TraceAllowed()
    return (LogLevel > 0)
EndFunction

bool Function ActorIsPlayer(Actor akActor)
    return akActor == Player
EndFunction

;=======================================================================
;                            GLOBAL FUNCTIONS
;========================================================================

;convert int to bit map
string Function IntToBit(int argInt) global
    string     loc_res =     ""
    int     loc_i     =    32
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

float Function CalcDistance(ObjectReference obj1,ObjectReference obj2) global
    if obj1 == obj2
        return 0.0
    endif
    if obj1.GetParentCell() == obj2.GetParentCell()
        float dX = obj1.X - obj2.X
        float dY = obj1.Y - obj2.Y
        float dZ = obj1.Z - obj2.Z
        return Math.Sqrt(Math.Pow(dX,2) + Math.Pow(dY,2) + Math.Pow(dZ,2))
    else
        return -1.0
    endif
EndFunction

bool Function GActorIsPlayer(Actor akActor) global
    return akActor == Game.getPlayer()
EndFunction

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

int Function codeBit(int iCodedMap,int iValue,int iSize,int iIndex) global
    if iIndex + iSize > 32
        return 0xFFFFFFFF ;returns error value
    endif
    ;sets not shifted bit mask loc_clear_mask
    int loc_clear_mask = (Math.LeftShift(0x1,iSize) - 1)                     ;mask used to clear bits which will be set
    iValue = Math.LeftShift(Math.LogicalAnd(iValue,loc_clear_mask),iIndex)    ;clear value from bigger bits
    loc_clear_mask = Math.LogicalNot(Math.LeftShift(loc_clear_mask,iIndex)) ;shift and negate
    iCodedMap = Math.LogicalAnd(iCodedMap,loc_clear_mask)                     ;clear maps bits with mask
    return Math.LogicalOr(iCodedMap,iValue)                                 ;sets bits
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

int Function decodeBit(int iCodedMap,int iSize,int iIndex) global
    if iIndex + iSize > 32
        return 0xFFFFFFFF ;returns error value
    endif
    ;sets not shifted bit mask
    iCodedMap = Math.RightShift(iCodedMap,iIndex) ;shift to right, so value is correct
    iCodedMap = Math.LogicalAnd(iCodedMap,(Math.LeftShift(0x1,iSize) - 1)) ;clear maps bits with mask
    return iCodedMap
EndFunction

float Function fRange(float fValue,float fMin,float fMax) global
    if fValue > fMax
        return fMax
    endif
    if fValue < fMin
        return fMin
    endif
    return fValue
EndFunction

int Function iRange(int iValue,int iMin,int iMax) global
    if iValue > iMax
        return iMax
    endif
    if iValue < iMin
        return iMin
    endif
    return iValue
EndFunction

string Function formatString(string str,int floatPoints) global
    int float_point =  StringUtil.find(str,".")
    if (float_point == -1)
        return str
    endif
    if (floatPoints + float_point + 1 > StringUtil.getLength(str))
        return str
    else
        return StringUtil.Substring(str, 0, float_point + floatPoints + 1)
    endif
EndFunction

float Function checkLimit(float value,float limit) global
    if value > limit
        return limit
    else
        return value
    endif
EndFunction

int Function Round(float value) global
    return Math.floor(value + 0.5)
EndFunction

Function closeMenu() global
    ;https://www.reddit.com/r/skyrimmods/comments/elg97s/function_to_close_objects_container_menu/
    UI.InvokeString("ContainerMenu", "_global.skse.CloseMenu", "ContainerMenu")
    UI.InvokeString("Dialogue Menu", "_global.skse.CloseMenu", "Dialogue Menu")
    UI.InvokeString("InventoryMenu", "_global.skse.CloseMenu", "InventoryMenu")
    UI.InvokeString("TweenMenu", "_global.skse.CloseMenu", "TweenMenu")
    UI.InvokeString("GiftMenu", "_global.skse.CloseMenu", "GiftMenu")
EndFunction

Function closeLockpickMenu() global
    UI.InvokeString("Lockpicking Menu", "_global.skse.CloseMenu", "Lockpicking Menu")
EndFunction

string Function getPlugsVibrationStrengthString(int strenght) global
    if strenght >= 5
        return "Extremely Strong"
    endif
    if strenght == 4
        return "Very Strong"
    endif
    if strenght == 3
        return "Strong"
    endif
    if strenght == 2
        return "Weak"
    endif
    if strenght <= 1
        return "Very weak"
    endif
EndFunction

;https://www.creationkit.com/index.php?title=GetActorValuePercentage_-_Actor
float Function getMaxActorValue(Actor akActor,string akValue, float perc_part = 1.0) global
    return (akActor.GetActorValue(akValue)/akActor.GetActorValuePercentage(akValue))*perc_part
EndFunction

float Function getCurrentActorValuePerc(Actor akActor,string akValue) global
    return akActor.GetActorValuePercentage(akValue)
EndFunction

float Function getCurrentActorValuePercCustom(Actor akActor,string akValue,float fBase) global
    return akActor.GetActorValue(akValue)/fBase
EndFunction

bool Function ModInstalled(string sModFileName) global
    return (Game.GetModByName(sModFileName) != 255) && (Game.GetModByName(sModFileName) != 0) ; 255 = not found, 0 = no skse
EndFunction

bool Function ModInstalledAfterUD(string sModFileName) global
    return (Game.GetModByName(sModFileName) > Game.GetModByName("UnforgivingDevices.esp"))
EndFunction

string Function MakeDeviceHeader(Actor akActor,Armor invDevice) global
    string loc_actorname = "NONE_ACTOR"
    string loc_devicename = "NONE_DEVICE"
    if akActor
        loc_actorname = GetActorName(akActor)
    endif
    if invDevice
        loc_devicename = invDevice.GetName()
    endif
    
    return (loc_devicename + "("+ loc_actorname + ")")
EndFunction

Int Function ToUnsig(Int iValue) global
    if iValue < 0
        return 0
    endif
    return iValue
EndFunction

Int Function iUnsig(Int aiValue) global
    if aiValue < 0
        return 0
    endif
    return aiValue
EndFunction

Float Function fUnsig(float afValue) global
    if afValue < 0.0
        return 0.0
    endif
    return afValue
EndFunction

Function ShowMessageBox(string strText) global
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
        endwhile
        
        loc_iterBox += 1
        
        if loc_boxesNum > 1
            loc_messagebox += "===PAGE " + (loc_iterBox) + "/" + (loc_boxesNum) + "===\n"
        endif
        loc_iterLine = 0
        
        debug.messagebox(loc_messagebox)
        
        ;wait for fucking messagebox to actually get OKd before continuing thread (holy FUCKING shit toad)
        GamepadMenuPause()
    endwhile
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

; thanks to Subhuman#6830 for ESPFE form check, compatible with LE
; Notes given by him:
; 1) it breaks the compile-time dependency.   GetformFromFile requires you to have the plugin you're getting a form for in order to compile, this does not
; 2) less papyrus spam, if the plugin isn't found it prints a single line debug.trace instead 4-5 lines of errors
; 3) related to 1, it doesn't verify you didn't screw up.   If you're trying to cast a package as a quest, for example, GetFormFromFile will throw a compiler error because it can't be done.  This will not.  You have to verify your own work. 
form function GetMeMyForm(int formNumber, string pluginName) global;fornumber format is 0xFULLFORMID, for example 0x00000007. Even for ESPFE format, ignoring 0xFE
    int theLO = Game.GetModByName(pluginName)
    if ((theLO == 255) || (theLO == 0)) ; 255 = not found, 0 = no skse
        GError(pluginName + " not loaded or SKSE not found")
        return none
    elseIf (theLO > 255) ; > 255 = ESL
        ; the first FIVE hex digits in an ESL are its address, so a formNumber exceeding 0xFFF or below 0x800 is invalid
        if ((Math.LogicalAnd(0xFFFFF000, formNumber) != 0) || (Math.LogicalAnd(0x00000800, formNumber) == 0))
            GError("Plugin " + pluginName + " has FormIDs outside the range\nallocated for ESL plugins!: " + formNumber)
            GError("ESL-flagged plugin " + pluginName + " contains invalid FormIDs: " + formNumber)
            return none
        endIf
        ; getmodbyname reports an ESL as 256 higher than the game indexes it internally
        theLO -= 256
        return Game.GetFormEx(Math.LogicalOr(Math.LogicalOr(0xFE000000, Math.LeftShift(theLO, 12)), formNumber))
    else    ; regular ESL-free plugin
        return Game.GetFormEx(Math.LogicalOr(Math.LeftShift(theLO, 24), formNumber))
    endIf
endFunction

;open text input for user and return string
string Function GetUserTextInput()
    TextMenu.ResetMenu()
    TextMenu.OpenMenu()
    TextMenu.BlockUntilClosed()
    return TextMenu.GetResultString()
EndFunction

;open list of options and return selected option
Int Function GetUserListInput(string[] arrList)
    ListMenu.ResetMenu()
    int loc_i = 0
    while loc_i < arrList.length
        ListMenu.AddEntryItem(arrList[loc_i])
        loc_i+=1
    endwhile
    ListMenu.OpenMenu()
    ListMenu.BlockUntilClosed()
    return ListMenu.GetResultInt()
EndFunction

Form Function GetShield(Actor akActor) Global
    Form loc_shield = akActor.GetEquippedObject(0)
    if loc_shield && (loc_shield.GetType() == 26 || loc_shield.GetType() == 31)
        return loc_shield
    else
        return none
    endif
EndFunction

Function GamepadMenuPause() Global
    if Game.UsingGamepad()
        Utility.wait(0.1)
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

;might or might not be used in future
Bool Function ActorHaveSoS(Actor akActor)
    if UD_SOS_SchlongifiedActors
        return akActor.IsInFaction(UD_SOS_SchlongifiedActors)
    else
        Info("UnforgivingDevicesMain::ActorHaveSoS() - SoS not installed, returning false")
        return false
    endif
EndFunction

;very fast function for checking if menu is open
;have little lag because it works by checking events
Bool Function IsMenuOpen()
    return UDMC.UD_MenuOpened
EndFunction
Bool Function IsMenuOpenID(int aiID)
    return UDMC.isMenuOpen(iRange(aiID,0,UDMC.UD_MenuListID.length))
EndFunction
Bool Function IsContainerMenuOpen()
    return UDMC.IsMenuOpen(0)
EndFunction
Bool Function IsLockpickingMenuOpen()
    return UDMC.IsMenuOpen(1)
EndFunction
Bool Function IsInventoryMenuOpen()
    return UDMC.IsMenuOpen(2)
EndFunction