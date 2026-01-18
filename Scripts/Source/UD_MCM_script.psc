Scriptname UD_MCM_script extends SKI_ConfigBase

import UnforgivingDevicesMain
import UD_Native

;UDAbadonPlug_Event property abadon auto
UnforgivingDevicesMain              Property UDmain auto
UDCustomDeviceMain                  Property UDCDmain auto
UD_SwimmingScript                   Property UDSS auto
UDItemManager                       Property UDIM auto
UD_AbadonQuest_script               Property AbadonQuest auto
UD_CustomDevices_NPCSlotsManager    Property UDCD_NPCM auto
zadlibs_UDPatch                     Property libs
    zadlibs_UDPatch Function get()
        return UDMain.libsp
    EndFunction
EndProperty

UD_MCM_Module Property MCMM
    UD_MCM_Module Function get()
        return (self as Quest) as UD_MCM_Module
    EndFunction
EndProperty

int UD_LockMenu_flag

Function UpdateLockMenuFlag()
    if(UDmain.hasAnyUD() && UDmain.lockMCM)
        UD_LockMenu_flag = OPTION_FLAG_DISABLED
    else
        UD_LockMenu_flag = OPTION_FLAG_NONE
    endif
EndFunction

;check if button can be used for UD
Bool Function CheckButton(Int aiKeyCode)
    Bool loc_res = True
    
    loc_res = loc_res && (aiKeyCode != 264) ;is not mouse wheel up
    loc_res = loc_res && (aiKeyCode != 265) ;is not mouse wheel down
    
    return loc_res
EndFunction

Function LoadConfigPages()
    pages = MCMM.GetPagesNames()
EndFunction

bool Property Ready = False Auto
Event OnConfigInit()
EndEvent

Function Init()
    if UDmain.TraceAllowed()
        UDmain.Log("MCM init started")
    endif
    
    UD_LockMenu_flag    = OPTION_FLAG_NONE
    
    MCMM.InitPages()

    LoadConfig(false)
    
    Ready = True
    ;UDmain.LogDebug("MCM Ready")
EndFunction

Function Update()
    LoadConfigPages()
    
    MCMM.UpdatePages()
EndFunction

Function LoadConfig(Bool abResetToDef = True)
    if abResetToDef
        ResetToDefaults()
    endif
    if getAutoLoad()
        LoadFromJSON(File)
        GInfo("MCM setting loaded from saved config file!")
    endif
EndFunction

Event onConfigClose()
EndEvent

Event onConfigOpen()
EndEvent

String _lastPage
Int   _ResetAllModules_T
Bool  _Trap = false
Event OnPageReset(string page)
    if !UD_Native.AreModulesReady(true) && Ready
        setCursorFillMode(LEFT_TO_RIGHT)
        AddHeaderOption("$Unforgiving devices is initiating or reloading its modules...")
        AddEmptyOption()
        
        AddTextOption("Modules ready",UD_Native.AreModulesReady(false))
        AddTextOption("Modules reloading",UD_Native.AreModulesReady(true))
        
        _ResetAllModules_T = AddTextOption("--RESET ALL MODULES--","CLICK")
        _Trap = True
        return
    endif
    
    _Trap = False

    _lastPage = page
    UpdateLockMenuFlag()
    
    MCMM.ResetPages(page,UD_LockMenu_flag)
EndEvent

int Property AbadonQuestFlag auto

; DELETE
UD_WidgetControl Property UDWC Hidden
    UD_WidgetControl Function Get()
        return UDMain.UDWC
    EndFunction
EndProperty

UD_AnimationManagerScript Property UDAM Hidden
    UD_AnimationManagerScript Function Get()
        return UDmain.UDAM
    EndFunction
EndProperty

String      Property SelectedPreset   = "Config.json" auto hidden

event OnOptionSelect(int option)
    if option == _ResetAllModules_T && _Trap
        UD_Native.ResetAllModuleS()
        closeMCM()
    else
        MCMM.OptionSelect(_lastPage,option)
    endif
endEvent

Function OnOptionInputOpen(int option)
    MCMM.OptionInputOpen(_lastPage,option)
EndFunction

Function OnOptionInputAccept(int option, string value)
    MCMM.OptionInputAccept(_lastPage,option,value)
EndFunction

event OnOptionSliderOpen(int option)
    MCMM.OptionSliderOpen(_lastPage,option)
endEvent

event OnOptionSliderAccept(int option, float value)
    MCMM.OptionSliderAccept(_lastPage,option,value)
endEvent

event OnOptionMenuOpen(int option)
    MCMM.OptionMenuOpen(_lastPage,option)
endEvent

event OnOptionMenuAccept(int option, int index)
    MCMM.OptionMenuAccept(_lastPage,option,index)
endEvent

bool Function checkMinigameKeyConflict(int iKeyCode)
    bool loc_res = true
    loc_res = loc_res && CheckButton(iKeyCode)
    loc_res = loc_res && (iKeyCode != UDCDmain.Stamina_meter_Keycode)
    loc_res = loc_res && (iKeyCode != UDCDmain.Magicka_meter_Keycode)
    loc_res = loc_res && (iKeyCode != UDCDmain.SpecialKey_Keycode)
    return loc_res
EndFunction

bool Function checkGeneralKeyConflict(int iKeyCode)
    bool loc_res = true
    loc_res = loc_res && CheckButton(iKeyCode)
    loc_res = loc_res && (iKeyCode != UDCDmain.StruggleKey_Keycode)
    loc_res = loc_res && (iKeyCode != UDCDmain.PlayerMenu_KeyCode)
    loc_res = loc_res && (iKeyCode != UDCDmain.ActionKey_Keycode)
    loc_res = loc_res && (iKeyCode != UDCDmain.NPCMenu_Keycode)
    return loc_res
EndFunction

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
    MCMM.OptionKeyMapChange(_lastPage, option, keyCode, conflictControl, conflictName)
endEvent

;=========================================
;             DEFAULT VALUES..............
;=========================================
Event OnOptionDefault(int option)
    MCMM.PageDefault(_lastPage,option)
EndEvent

;=========================================
;                 INFO.      .............
;=========================================
Event OnOptionHighlight(int option)
    MCMM.PageInfo(_lastPage,option)
EndEvent

;=========================================
;                 OTHER.     .............
;=========================================

;https://forums.nexusmods.com/index.php?/topic/4795300-starting-quests-from-mcm-quest-script-best-method/
Function closeMCM()
    UI.Invoke("Journal Menu", "_root.QuestJournalFader.Menu_mc.ConfigPanelClose")
    UI.Invoke("Journal Menu", "_root.QuestJournalFader.Menu_mc.CloseMenu")
EndFunction

string property File hidden
    string function get()
        return GetConfigPath(SelectedPreset)
    endFunction
endProperty

String Function GetConfigPath(String asName)
    return "./UD/Presets/" + asName
EndFunction

Function SaveToJSON(string strFile)
    if !strFile
        UDMain.Error("Incorrect config path.")
        return
    endif

    GInfo("Saving configuration to [" +strFile+"]")

    JsonUtil.ClearAll(strFile)
    
    Quest[] loc_modules = UD_Native.GetModules()
    Int loc_indx = 0
    while loc_indx < loc_modules.length
        UD_ModuleBase loc_module = loc_modules[loc_indx] as UD_ModuleBase
        if loc_module
            loc_module._SaveJSON(strFile)
        endif
        loc_indx += 1
    endwhile
    
    ; TODO: Move to CONF
    ;ABADON
    JsonUtil.SetIntValue(strFile, "AbadonForceSet", AbadonQuest.final_finisher_set as Int)
    JsonUtil.SetIntValue(strFile, "AbadonForceSetPref", AbadonQuest.final_finisher_pref as Int)
    JsonUtil.SetIntValue(strFile, "AbadonUseAnalVariant", AbadonQuest.UseAnalVariant as Int)
    ;JsonUtil.SetIntValue(strFile, "AbadonPlugPreset", preset as Int)
    JsonUtil.SetFloatValue(strFile, "AbadonPlugMaxDifficulty", AbadonQuest.max_difficulty)
    JsonUtil.SetIntValue(strFile, "AbadonPlugOverallDifficulty", AbadonQuest.overaldifficulty as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugEventChanceMod", AbadonQuest.eventchancemod as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugLittleFinisherChance", AbadonQuest.little_finisher_chance as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugMinOrgasmLittleFinisher", AbadonQuest.min_orgasm_little_finisher as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugMaxOrgasmLittleFinisher", AbadonQuest.max_orgasm_little_finisher as Int)
    JsonUtil.SetFloatValue(strFile, "AbadonPlugLittleFinisherCooldown", AbadonQuest.little_finisher_cooldown)
    JsonUtil.SetIntValue(strFile, "AbadonPlugDmgHeal", AbadonQuest.dmg_heal as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugDmgMagicka", AbadonQuest.dmg_magica as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugDmgStamina", AbadonQuest.dmg_stamina as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugHardcore", AbadonQuest.hardcore as Int)

    ;;OTHER
    JsonUtil.SetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)

    JsonUtil.Save(strFile, true)
EndFunction

Function LoadFromJSON(string strFile)
    if !strFile
        UDMain.Error("Incorrect config path.")
        return
    endif
    String loc_abspath = "Data/skse/Plugins/StorageUtilData/" + strFile
    if !MiscUtil.FileExists(loc_abspath)
        UDMain.Error("Can't load config " + loc_abspath + " , as the file does not exist.")
        return
    endif

    GInfo("Loading configuration from [" +strFile+"]")

    Quest[] loc_modules = UD_Native.GetModules()
    Int loc_indx = 0
    while loc_indx < loc_modules.length
        UD_ModuleBase loc_module = loc_modules[loc_indx] as UD_ModuleBase
        if loc_module
            loc_module._LoadJSON(strFile)
        endif
        loc_indx += 1
    endwhile

    ; TODO: Move to CONF
    ;ABADON
    AbadonQuest.final_finisher_set = JsonUtil.GetIntValue(strFile, "AbadonForceSet", AbadonQuest.final_finisher_set as Int)
    AbadonQuest.final_finisher_pref = JsonUtil.GetIntValue(strFile, "AbadonForceSetPref", AbadonQuest.final_finisher_pref as Int)
    AbadonQuest.UseAnalVariant = JsonUtil.GetIntValue(strFile, "AbadonUseAnalVariant", AbadonQuest.UseAnalVariant as Int)
    ;preset = JsonUtil.GetIntValue(strFile, "AbadonPlugPreset", preset as Int)
    AbadonQuest.max_difficulty = JsonUtil.GetFloatValue(strFile, "AbadonPlugMaxDifficulty", AbadonQuest.max_difficulty)
    AbadonQuest.overaldifficulty = JsonUtil.GetIntValue(strFile, "AbadonPlugOverallDifficulty", AbadonQuest.overaldifficulty as Int)
    AbadonQuest.eventchancemod = JsonUtil.GetIntValue(strFile, "AbadonPlugEventChanceMod", AbadonQuest.eventchancemod as Int)
    AbadonQuest.little_finisher_chance = JsonUtil.GetIntValue(strFile, "AbadonPlugLittleFinisherChance", AbadonQuest.little_finisher_chance as Int)
    AbadonQuest.min_orgasm_little_finisher = JsonUtil.GetIntValue(strFile, "AbadonPlugMinOrgasmLittleFinisher", AbadonQuest.min_orgasm_little_finisher as Int)
    AbadonQuest.max_orgasm_little_finisher = JsonUtil.GetIntValue(strFile, "AbadonPlugMaxOrgasmLittleFinisher", AbadonQuest.max_orgasm_little_finisher as Int)
    AbadonQuest.little_finisher_cooldown = JsonUtil.GetFloatValue(strFile, "AbadonPlugLittleFinisherCooldown", AbadonQuest.little_finisher_cooldown)
    AbadonQuest.dmg_heal = JsonUtil.GetIntValue(strFile, "AbadonPlugDmgHeal", AbadonQuest.dmg_heal as Int)
    AbadonQuest.dmg_magica = JsonUtil.GetIntValue(strFile, "AbadonPlugDmgMagicka", AbadonQuest.dmg_magica as Int)
    AbadonQuest.dmg_stamina = JsonUtil.GetIntValue(strFile, "AbadonPlugDmgStamina", AbadonQuest.dmg_stamina as Int)
    AbadonQuest.hardcore = JsonUtil.GetIntValue(strFile, "AbadonPlugHardcore", AbadonQuest.hardcore as Int)

    ;Other
    libs.UD_StartThirdpersonAnimation_Switch = JsonUtil.GetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)
EndFunction

Function ResetToDefaults()
    Quest[] loc_modules = UD_Native.GetModules()
    Int loc_indx = 0
    while loc_indx < loc_modules.length
        UD_ModuleBase loc_module = loc_modules[loc_indx] as UD_ModuleBase
        if loc_module
            loc_module._ResetToDefault()
        endif
        loc_indx += 1
    endwhile

    ; TODO: Move to CONF
    ;ABADON
    AbadonQuest.final_finisher_set      = true
    AbadonQuest.final_finisher_pref     = 0
    AbadonQuest.UseAnalVariant          = false
    
    ;Other
    libs.UD_StartThirdpersonAnimation_Switch        = true
EndFunction

bool Function GetAutoLoad()
    UDmain.UD_AutoLoad = JsonUtil.GetIntValue(FILE, "AutoLoad", UDmain.UD_AutoLoad as int)
    return UDmain.UD_AutoLoad
EndFunction

String Function KeywordArrayToString(Keyword[] aasKeywords)
    Int loc_i = 0
    String loc_res = ""
    While loc_i < aasKeywords.Length
        If loc_i > 0
            loc_res += ", "
        EndIf
        loc_res += (aasKeywords[loc_i] As Keyword).GetString()
        loc_i += 1
    EndWhile
    Return loc_res
EndFunction

String Function StringArrayToString(String[] aasStrings)
    Return PapyrusUtil.StringJoin(aasStrings, ", ")
EndFunction
