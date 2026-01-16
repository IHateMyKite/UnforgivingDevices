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

UD_OrgasmManager Property UDOM
    UD_OrgasmManager Function Get()
        return UDmain.UDOM
    EndFunction
EndProperty

UD_UserInputScript Property UDUI
    UD_UserInputScript Function Get()
        return UDmain.UDUI
    EndFunction
EndProperty

UD_NPCInteligence Property UDAI
    UD_NPCInteligence Function Get()
        return UDmain.UDAI
    EndFunction
EndProperty

UD_Config         Property UDCONF hidden
    UD_Config Function Get()
        return UDmain.UDCONF
    EndFunction
EndProperty

UD_OutfitManager  Property UDOTM hidden
    UD_OutfitManager Function Get()
        return UDmain.UDOTM
    EndFunction
EndProperty

UD_MenuTextFormatter  Property UDMTF hidden
    UD_MenuTextFormatter Function Get()
        return UDmain.UDMTF
    EndFunction
EndProperty

UD_MenuMsgManager  Property UDMMM hidden
    UD_MenuMsgManager Function Get()
        return UDmain.UDMMM
    EndFunction
EndProperty

int UD_OrgasmExhaustion_flag
int UD_OrgasmExhaustion_T

int UD_hightPerformance_T

string[] orgasmAnimation

int UD_LockMenu_flag

Function UpdateLockMenuFlag()
    if(UDmain.hasAnyUD() && UDmain.lockMCM)
        UD_LockMenu_flag = OPTION_FLAG_DISABLED
    else
        UD_LockMenu_flag = OPTION_FLAG_NONE
    endif
EndFunction

Int Function FlagSwitchAnd(int iFlag1,Int iFlag2)
    if iFlag1 == OPTION_FLAG_DISABLED && iFlag2 == OPTION_FLAG_DISABLED
        return OPTION_FLAG_DISABLED
    else
        return OPTION_FLAG_NONE
    endif
EndFunction

Int Function FlagSwitchOr(int iFlag1,Int iFlag2)
    if iFlag1 == OPTION_FLAG_DISABLED 
        return OPTION_FLAG_DISABLED
    elseif iFlag2 == OPTION_FLAG_DISABLED
        return OPTION_FLAG_DISABLED
    endif
    return OPTION_FLAG_NONE
EndFunction

Int Function FlagNegate(int aiFlag)
    if aiFlag == OPTION_FLAG_DISABLED 
        return OPTION_FLAG_NONE
    else
        return OPTION_FLAG_DISABLED
    endif
EndFunction

int Function FlagSwitch(bool bVal)
    if bVal == true 
        return OPTION_FLAG_NONE
    else
        return OPTION_FLAG_DISABLED
    endif
EndFunction

String Function SwitchBool(Bool abVal)
    if abVal
        return "True"
    else
        return "False"
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
    
    device_flag         = OPTION_FLAG_NONE
    UD_autocrit_flag    = OPTION_FLAG_DISABLED
    fix_flag            = OPTION_FLAG_NONE
    
    UD_LockMenu_flag    = OPTION_FLAG_NONE
    
    actorIndex = 10
    MCMM.InitPages()
    ;Update()
    InitConfigPresets(true)
    LoadConfig(false)
    Ready = True
    UDmain.LogDebug("MCM Ready")
EndFunction

Function Update()
    LoadConfigPages()
    ;registered_devices_T = new Int[25]
    ;NPCSlots_T = Utility.CreateIntArray(UDCD_NPCM.GetNumAliases())
    ;
    
    MCMM.UpdatePages()
    
    InitConfigPresets(false)
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
    device_flag = OPTION_FLAG_NONE
    fix_flag = OPTION_FLAG_NONE
EndEvent

String _lastPage
Event OnPageReset(string page)
    if !UDmain.IsEnabled() && Ready
        setCursorFillMode(LEFT_TO_RIGHT)
        AddHeaderOption("$Unforgiving devices is updating or disabled...")
        AddEmptyOption()
        
        AddTextOption("Mod ready",UDmain.Ready)
        AddTextOption("MCM ready",Ready)
        AddTextOption("Mod updating",UDmain.IsUpdating())
        AddTextOption("Mod disabled",UDmain._Disabled)
        AddTextOption("Update progress",UDmain.GetUpdateProgress())
        return
    endif
    
    if !UD_Native.AreModulesReady(true) && Ready
        setCursorFillMode(LEFT_TO_RIGHT)
        AddHeaderOption("$Unforgiving devices is initiating or reloading its modules...")
        AddEmptyOption()
        
        AddTextOption("Modules ready",UD_Native.AreModulesReady(false))
        AddTextOption("Modules reloading",UD_Native.AreModulesReady(true))
        return
    endif
    
    if !Ready
        setCursorFillMode(LEFT_TO_RIGHT)
        AddHeaderOption("$MCM menu is not loaded!")
        AddEmptyOption()
        
        AddTextOption("Mod ready",UDmain.Ready)
        AddTextOption("MCM ready",Ready)
        AddTextOption("Mod updating",UDmain.IsUpdating())
        AddTextOption("Mod disabled",UDmain._Disabled)
        return
    endif

    _lastPage = page
    UpdateLockMenuFlag()
    
    MCMM.ResetPages(page,UD_LockMenu_flag)
EndEvent

int Property AbadonQuestFlag auto

; DELETE
int UD_autocrit_flag

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

Int       UD_Modules_M
Int       UD_Modules_Id
String[]  UD_Modules_List
Function resetModulesPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    Quest[] loc_modules = UD_Native.GetModules()
    Int loc_i = 0
    UD_Modules_List = Utility.CreateStringArray(loc_modules.length)
    while loc_i < loc_modules.length
        UD_ModuleBase tmp_module = loc_modules[loc_i] as UD_ModuleBase
        UD_Modules_List[loc_i] = tmp_module.MODULE_NAME
        loc_i += 1
    endwhile
    
    AddHeaderOption("Modules")
    addEmptyOption()
    
    UD_Modules_M = AddMenuOption("Module", UD_Modules_List[UD_Modules_Id])
    addEmptyOption()
    
    UD_ModuleBase loc_module = loc_modules[UD_Modules_Id] as UD_ModuleBase
    Quest[]       loc_dependency = GetModuleDependency(loc_module)
    AddTextOption("Alias",loc_module.MODULE_ALIAS)
    AddHeaderOption("==Dependency==")
    AddTextOption("Priority",loc_module.MODULE_PRIO)
    if loc_dependency.length > 0
        AddTextOption("1) ",loc_dependency[0])
    endif
    AddTextOption("Description",loc_module.MODULE_DESC)
    
    loc_i = 1
    while loc_i < loc_dependency.length
        AddTextOption(loc_i + ") " , loc_dependency[loc_i])
        addEmptyOption()
        loc_i += 1
    endwhile

EndFunction

int[] registered_devices_T
int[] NPCSlots_T
int device_flag
int fix_flag
;int npc_flag
int fixBugs_T
int rescanSlots_T
int unlockAll_T
int showDetails_T
int actorIndex = 15
int unregisterNPC_T
int GlobalUpdateNPC_T
int OrgasmResist_S
int OrgasmCapacity_S
Event resetDebugPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("$UD_H_DEVICE_SLOTS")
    AddHeaderOption("$UD_H_NPC SLOTS")
    int i = 0
    
    UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(actorIndex)
    if !slot.isUsed()
        slot = UDCD_NPCM.getPlayerSlot()
        actorIndex = UDCD_NPCM.getPlayerIndex()
    endif
    UD_CustomDevice_RenderScript[] devices = slot.UD_equipedCustomDevices
    int size = devices.length
    
    fix_flag = OPTION_FLAG_NONE
    
    while i < size
        if devices[i]
            registered_devices_T[i] = AddTextOption((i + 1) + ") " , devices[i].deviceInventory.getName(),FlagSwitchAnd(UD_LockMenu_flag,FlagSwitch(!UDmain.UD_LockDebugMCM)))
        else
            registered_devices_T[i] = AddTextOption((i + 1) + ") " , "$UD_EMPTY" ,OPTION_FLAG_DISABLED)
        endif
            if i == 0
                setNPCSlot(15,"PlayerSlot",False)
            elseif i == 1
                setNPCSlot(0)
            elseif i == 2
                setNPCSlot(1)
            elseif i == 3
                setNPCSlot(2)
            elseif i == 4
                setNPCSlot(3)
            elseif i == 5
                setNPCSlot(4)
            elseif i == 6
                setNPCSlot(5)
            elseif i == 7
                setNPCSlot(6)
            elseif i == 8
                setNPCSlot(7)
            elseif i == 9
                setNPCSlot(8)
            elseif i == 10
                setNPCSlot(9)
            elseif i == 11
                setNPCSlot(10)
            elseif i == 12
                setNPCSlot(11)
            elseif i == 13
                setNPCSlot(12)
            elseif i == 14
                setNPCSlot(13)
            elseif i == 15
                setNPCSlot(14)
            elseif i == 16
                AddHeaderOption("$UD_H_TOOLS")
            elseif i == 17
                AddTextOption("$UD_DEVICES", slot.getNumberOfRegisteredDevices() ,OPTION_FLAG_DISABLED)
            elseif i == 18
                OrgasmResist_S          = addSliderOption("$UD_ORGASMRESIST",OrgasmSystem.GetOrgasmVariable(slot.getActor(),3), "{1}",OPTION_FLAG_DISABLED)
            elseif i == 19
                OrgasmCapacity_S        = addSliderOption("$UD_ORGASMCAPACITY",OrgasmSystem.GetOrgasmVariable(slot.getActor(),5), "{0}",OPTION_FLAG_DISABLED)
            elseif i == 20
                unlockAll_T             = AddTextOption("$UD_UNLOCK_ALL", "$CLICK" ,FlagSwitchAnd(UD_LockMenu_flag,FlagSwitch(!UDmain.UD_LockDebugMCM)))
            elseif i == 21
                showDetails_T           = AddTextOption("$UD_DEBUGSHOWDETAILS", "$CLICK" )
            elseif i == 22
                fixBugs_T               = AddTextOption("$UD_FIXBUGS", "$CLICK" ,fix_flag)
            elseif i == 23
                if !slot.isPlayer()
                    unregisterNPC_T = AddTextOption("$UD_UNREGISTER_NPC","$CLICK")
                else
                    addEmptyOption()
                endif
            elseif i == 24
                addEmptyOption()
                    
            else     
                addEmptyOption()
            endif
        i += 1
    endwhile
    
    AddHeaderOption("$UD_H_GLOBAL")
    addEmptyOption()
    
    rescanSlots_T = AddTextOption("$UD_RESCANSLOTS", "$CLICK")
    addEmptyOption()
EndEvent

Function setNPCSlot(int index,string text = "NPC Slot",bool useIndex = True)
    int npcflag = OPTION_FLAG_NONE
    UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(index)
    if !slot.isUsed()
        npcflag = OPTION_FLAG_DISABLED
    else
        npcflag = OPTION_FLAG_NONE
    endif
    string name = ""
    if actorIndex == index
        name = "->" +  slot.getSlotedNPCName()
    else
        name = slot.getSlotedNPCName()
    endif
    if useIndex
        NPCSlots_T[index] = AddTextOption(text + (index + 1)+": ", name ,npcflag)
    else
        NPCSlots_T[index] = AddTextOption(text +": ", name ,npcflag)
    endif
EndFunction

int UD_Export_T
int UD_Import_T
int UD_Default_T
int UD_AutoLoad_T
int UD_ConfigPresets_M
int UD_ConfigPresets_T

String[]    ConfigPresets
String      SelectedPreset   = "Config.json"
Int         SelectedPresetId = 0
String      ConfigPath = "Data\\skse\\plugins\\StorageUtilData\\UD\\Presets"

Function InitConfigPresets(Bool abInit)
    String[] loc_files = MiscUtil.FilesInFolder(ConfigPath,".json")
    ConfigPresets = Utility.CreateStringArray(loc_files.length)
    
    ;UDmain.Info(loc_files)
    
    int loc_i = 0
    while loc_i < ConfigPresets.length
        ConfigPresets[loc_i] = loc_files[loc_i]
        loc_i += 1
    endwhile
    
    if !ConfigPresets || ConfigPresets.find("Default.json") == -1
        ConfigPresets = PapyrusUtil.PushString(ConfigPresets,"Default.json")
    endif
    
    ;UDmain.Info("MCM Presets found: " + ConfigPresets)
    
    ; Find preset with autoload (if any)
    if abInit
        int loc_preset = 0
        while loc_preset < ConfigPresets.length
            String loc_path = GetConfigPath(ConfigPresets[loc_preset])
            Bool loc_autoload = JsonUtil.GetIntValue(loc_path, "AutoLoad", 0)
            if loc_autoload
                SelectedPresetId = loc_preset
                SelectedPreset = ConfigPresets[SelectedPresetId]
                loc_preset = ConfigPresets.length
            else
                loc_preset += 1
            endif
        endwhile
    endif
    UpdateSelectedPresetId()
EndFunction

Function UpdateSelectedPresetId()
    SelectedPresetId = ConfigPresets.find(SelectedPreset)
    if SelectedPresetId == -1
        SelectedPreset = "Default.json"
        SelectedPresetId = ConfigPresets.find(SelectedPreset)
        SaveToJSON(File)
    endif
EndFunction

Function resetOtherPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_H_CONFIG")
    addEmptyOption()
    
    UpdateSelectedPresetId()
    UD_ConfigPresets_M = AddMenuOption("Preset: ",ConfigPresets[SelectedPresetId],UD_LockMenu_flag)
    UD_ConfigPresets_T = AddInputOption("Create preset: ","$-PRESS-",UD_LockMenu_flag)
    
    UD_Export_T =  AddTextOption("$UD_SAVE_SETTINGS", "$-PRESS-",UD_LockMenu_flag)
    UD_Import_T = AddTextOption("$UD_LOAD_SETTINGS", "$-PRESS-",UD_LockMenu_flag)
    
    UD_Default_T = AddTextOption("$UD_RESET_TO_DEFAULT", "$-PRESS-",UD_LockMenu_flag)
    UD_AutoLoad_T = AddToggleOption("$UD_AUTO_LOAD", UDmain.UD_AutoLoad,UD_LockMenu_flag)
    
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("$UD_H_OPTIONAL_MODS")
    addEmptyOption()
    
    AddTextOption("$ConsoleUtil installed",InstallSwitch(UDmain.ConsoleUtilInstalled),FlagSwitch(UDmain.ConsoleUtilInstalled))
    addEmptyOption()
    
    AddTextOption("$SlaveTats installed",InstallSwitch(UDmain.SlaveTatsInstalled),FlagSwitch(UDmain.SlaveTatsInstalled))
    addEmptyOption()

    AddTextOption("Devious Devices For Him",InstallSwitch(UDmain.ForHimInstalled),FlagSwitch(UDmain.ForHimInstalled))
    addEmptyOption()

    AddTextOption("powerofthree's Papyrus Extender",InstallSwitch(UDmain.PO3Installed),FlagSwitch(UDmain.PO3Installed))
    addEmptyOption()

    AddTextOption("Improved Camera",InstallSwitch(UDmain.ImprovedCameraInstalled),FlagSwitch(UDmain.ImprovedCameraInstalled))
    addEmptyOption()
    
    AddTextOption("Experience",InstallSwitch(UDmain.ExperienceInstalled),FlagSwitch(UDmain.ExperienceInstalled))
    addEmptyOption()
    
    AddTextOption("Skyrim Souls",InstallSwitch(UDmain.SkyrimSoulsInstalled),FlagSwitch(UDmain.SkyrimSoulsInstalled))
    addEmptyOption()
EndFunction

String Function InstallSwitch(Bool abSwitch)
    if abSwitch
        return "$INSTALLED"
    else
        return "$NOT INSTALLED"
    endif
EndFunction

event OnOptionSelect(int option)
    MCMM.OptionSelect(_lastPage,option)
endEvent

int selected_device
Function OnOptionSelectDebug(int option)
    if fixBugs_T == option
        closeMCM()
        UDCD_NPCM.getNPCSlotByIndex(actorIndex).fix()
    elseif unlockAll_T == option
        closeMCM()
        UDCDmain.removeAllDevices(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
    elseif showDetails_T == option
        closeMCM()
        UDCDmain.ShowActorDetailsMenu(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
    elseif unregisterNPC_T == option
        UDCD_NPCM.unregisterNPC(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
        forcePageReset()
    elseif option == GlobalUpdateNPC_T
        int loc_globalupdate = StorageUtil.GetIntValue(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), "GlobalUpdate" , 0)
        StorageUtil.SetIntValue(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), "GlobalUpdate" , (!loc_globalupdate) as Int)
        SetToggleOptionValue(GlobalUpdateNPC_T, StorageUtil.GetIntValue(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), "GlobalUpdate" , 0))    
    elseif option == rescanSlots_T
        closeMCM()
        Utility.waitMenuMode(0.5)
        debug.notification("$[UD] Scanning!")
        UDCD_NPCM.scanSlots(True)
        
        ;forcePageReset()
    else
        int i = UDCD_NPCM.getNumSlots()
        while i 
            i -= 1
            if NPCSlots_T[i] == option
                actorIndex = i
                forcePageReset()
                return
            endif
        endwhile    
    
        i = registered_devices_T.length
        while i 
            i -= 1
            if registered_devices_T[i] == option
                selected_device = i
                
                closeMCM()
                UDCDmain.showDebugMenu(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(),selected_device)
                return
            endif
        endwhile
    endif
EndFunction

Function OnOptionSelectOther(int option)
    if UD_Export_T == option
        SaveToJSON(File)
        ShowMessage("$Configuration saved!",false,"OK")
        ;forcePageReset()
    elseif UD_Import_T == option
        LoadFromJSON(File)
        ShowMessage("$Saved configuration loaded!",false,"OK")
    elseif option == UD_Default_T
        if ShowMessage("$Do you really want to discard all changes and load default values?")
            ResetToDefaults()
        endif
    elseif option == UD_AutoLoad_T
        UDmain.UD_AutoLoad = !UDmain.UD_AutoLoad
        SetAutoLoad(UDmain.UD_AutoLoad)
        SetToggleOptionValue(UD_AutoLoad_T, UDmain.UD_AutoLoad)
    endif
EndFunction

Function OnOptionInputOpen(int option)
    MCMM.OptionInputOpen(_lastPage,option)
    ;OnOptionInputOpenGeneral(option)
    ;OnOptionInputOpenOther(option)
EndFunction

Function OnOptionInputOpenOther(int option)
    if option == UD_ConfigPresets_T
        SetInputDialogStartText("")
    endif
EndFunction

Function OnOptionInputAccept(int option, string value)
    MCMM.OptionInputAccept(_lastPage,option,value)
    ;OnOptionInputAcceptGeneral(option, value)
    ;OnOptionInputAcceptOther(option,value)
EndFunction

Function OnOptionInputAcceptOther(int option, string value)
    if(option == UD_ConfigPresets_T)
        if value
            if StringUtil.Find(value,".json") == -1
                value = value + ".json"
            endif
            if ConfigPresets.find(value) == -1
                ConfigPresets = PapyrusUtil.PushString(ConfigPresets,value)
                SelectedPreset = value
                SelectedPresetId = ConfigPresets.length - 1
                SaveToJSON(File)
                forcePageReset()
            endif
        endif
    endif
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

Function OnOptionMenuOpenOther(Int option)
    If option == UD_ConfigPresets_M
        SetMenuDialogOptions(ConfigPresets)
        SetMenuDialogStartIndex(SelectedPresetId)
        SetMenuDialogDefaultIndex(0)
    EndIf
EndFunction

event OnOptionMenuAccept(int option, int index)
    MCMM.OptionMenuAccept(_lastPage,option,index)
endEvent

Function OnOptionMenuAcceptOther(Int option, Int index)
    If option == UD_ConfigPresets_M
        SelectedPresetId    = index
        SelectedPreset      = ConfigPresets[index]
        SetMenuOptionValue(option, SelectedPreset)
        LoadFromJSON(File)
        forcePageReset()
    EndIf
EndFunction

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

Function DebugPageDefault(int option)
    ;dear mother of god
    if (option == rescanSlots_T)
        SetInfoText("$UD_RESCANSLOTS_INFO")
    elseif option == fixBugs_T
        SetInfoText("$UD_FIXBUGS_INFO")
    elseif option == unlockAll_T
        SetInfoText("$UD_UNLOCK_ALL_INFO")
    elseif option == showDetails_T
        SetInfoText("$UD_DEBUGSHOWDETAILS_INFO")
    elseif option == unregisterNPC_T
        SetInfoText("$UD_UNREGISTER_NPC_INFO")
    elseif option == OrgasmCapacity_S
        SetInfoText("$UD_ORGASMCAPACITY_INFO")
    elseif option == OrgasmResist_S
        SetInfoText("$UD_ORGASMRESIST_INFO")
    endIf
EndFunction

;=========================================
;                 INFO.      .............
;=========================================
Event OnOptionHighlight(int option)
    MCMM.PageInfo(_lastPage,option)
EndEvent

Function DebugPageInfo(int option)
    ;dear mother of god
    if (option == rescanSlots_T)
        SetInfoText("$UD_RESCANSLOTS_INFO")
    elseif option == fixBugs_T
        SetInfoText("$UD_FIXBUGS_INFO")
    elseif option == unlockAll_T
        SetInfoText("$UD_UNLOCK_ALL_INFO")
    elseif option == showDetails_T
        SetInfoText("$UD_DEBUGSHOWDETAILS_INFO")
    elseif option == unregisterNPC_T
        SetInfoText("$UD_UNREGISTER_NPC_INFO")
    elseif option == OrgasmCapacity_S
        SetInfoText("$UD_ORGASMCAPACITY_INFO")
    elseif option == OrgasmResist_S
        SetInfoText("$UD_ORGASMRESIST_INFO")
    endIf
EndFunction

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

    JsonUtil.ClearAll(strFile)
    
    ;UDmain
    JsonUtil.SetIntValue(strFile, "hightPerformance", UDmain.UD_hightPerformance as Int)
    JsonUtil.SetIntValue(strFile, "AllowNPCSupport", UDmain.AllowNPCSupport as Int)
    JsonUtil.SetIntValue(strFile, "lockMCM", UDmain.lockMCM as Int)
    JsonUtil.SetIntValue(strFile, "Debug mode", UDmain.DebugMod as Int)
    JsonUtil.SetIntValue(strFile, "OrgasmExhastion", UDmain.UD_OrgasmExhaustion as int)
    JsonUtil.SetIntValue(strFile, "AutoLoad", UDmain.UD_AutoLoad as int)
    JsonUtil.SetIntValue(strFile, "LogLevel", UDmain.LogLevel as int)
    JsonUtil.SetIntValue(strFile, "HearingRange", UDmain.UD_HearingRange)
    JsonUtil.SetIntValue(strFile, "WarningAllowed", UDmain.UD_WarningAllowed as Int)
    JsonUtil.SetIntValue(strFile, "PrintLevel", UDmain.UD_PrintLevel)
    JsonUtil.SetIntValue(strFile, "LockDebug", UDmain.UD_LockDebugMCM as Int)
    JsonUtil.SetIntValue(strFile, "EasyGamepadMode", UDUI.UD_EasyGamepadMode as Int)
    JsonUtil.SetIntValue(strFile, "AllKeywordCheck",UDmain.UD_CheckAllKw as Int)

    ;UDCDmain
    JsonUtil.SetIntValue(strFile, "Stamina_meter_Keycode", UDCDmain.Stamina_meter_Keycode)
    JsonUtil.SetIntValue(strFile, "StruggleKey_Keycode", UDCDmain.StruggleKey_Keycode)
    JsonUtil.SetIntValue(strFile, "Magicka_meter_Keycode", UDCDmain.Magicka_meter_Keycode)
    JsonUtil.SetIntValue(strFile, "SpecialKey_Keycode", UDCDmain.SpecialKey_Keycode)
    JsonUtil.SetIntValue(strFile, "PlayerMenu_KeyCode", UDCDmain.PlayerMenu_KeyCode)
    JsonUtil.SetIntValue(strFile, "ActionKey_Keycode", UDCDmain.ActionKey_Keycode)
    JsonUtil.SetIntValue(strFile, "NPCMenu_Keycode", UDCDmain.NPCMenu_Keycode)
    JsonUtil.SetIntValue(strFile, "UseDDdifficulty", UDCDmain.UD_UseDDdifficulty as Int)
    JsonUtil.SetIntValue(strFile, "UseWidget", UDCDmain.UD_UseWidget as Int)
    JsonUtil.SetIntValue(strFile, "GagPhonemModifier", UDCDmain.UD_GagPhonemModifier)
    JsonUtil.SetIntValue(strFile, "StruggleDifficulty", UDCDmain.UD_StruggleDifficulty)
    JsonUtil.SetFloatValue(strFile, "DeviceUpdateTime", UDCONF.UD_UpdateTime)
    JsonUtil.SetIntValue(strFile, "AutoCrit", UDCDmain.UD_AutoCrit as Int)
    JsonUtil.SetIntValue(strFile, "AutoCritChance", UDCDmain.UD_AutoCritChance)
    JsonUtil.SetFloatValue(strFile, "VibrationMultiplier", UDCDmain.UD_VibrationMultiplier)
    JsonUtil.SetFloatValue(strFile, "ArousalMultiplier", UDCDmain.UD_ArousalMultiplier)
    JsonUtil.SetFloatValue(strFile, "OrgasmResistence", UDCONF.UD_OrgasmResistence)
    JsonUtil.SetIntValue(strFile, "OrgasmExhaustionStruggleMax", UDCONF.UD_OrgasmExhaustionStruggleMax)
    JsonUtil.SetIntValue(strFile, "LockpicksPerMinigame", UDCDmain.UD_LockpicksPerMinigame as Int)
    JsonUtil.SetIntValue(strFile, "UseOrgasmWidget", UDCONF.UD_UseOrgasmWidget as Int)
    JsonUtil.SetFloatValue(strFile, "OrgasmUpdateTime", UDCONF.UD_OrgasmUpdateTime)
    JsonUtil.SetIntValue(strFile, "OrgasmAnimation", UDCONF.UD_OrgasmAnimation)
    JsonUtil.SetIntValue(strFile, "HornyAnimation", UDCONF.UD_HornyAnimation as Int)
    JsonUtil.SetIntValue(strFile, "HornyAnimationDuration", UDCONF.UD_HornyAnimationDuration)
    JsonUtil.SetFloatValue(strFile, "CooldownMultiplier", UDCDmain.UD_CooldownMultiplier)
    JsonUtil.SetIntValue(strFile, "SkillEfficiency", UDCDmain.UD_SkillEfficiency)
    JsonUtil.SetIntValue(strFile, "CritEffect", UDCDmain.UD_CritEffect)
    JsonUtil.SetIntValue(strFile, "HardcoreMode", UDCDmain.UD_HardcoreMode as Int)
    JsonUtil.SetIntValue(strFile, "AllowArmTie", UDCDmain.UD_AllowArmTie as Int)
    JsonUtil.SetIntValue(strFile, "AllowLegTie", UDCDmain.UD_AllowLegTie as Int)
    JsonUtil.SetIntValue(strFile, "MinigameHelpCD", UDCDmain.UD_MinigameHelpCd)
    JsonUtil.SetIntValue(strFile, "MinigameHelpCD_PerLVL", Round(UDCDmain.UD_MinigameHelpCD_PerLVL))
    JsonUtil.SetIntValue(strFile, "MinigameHelpXPBase", UDCDmain.UD_MinigameHelpXPBase)
    JsonUtil.SetFloatValue(strFile, "DeviceLvlHealth", UDCDMain.UD_DeviceLvlHealth*100)
    JsonUtil.SetFloatValue(strFile, "DeviceLvlLockpick", UDCDMain.UD_DeviceLvlLockpick)
    JsonUtil.SetIntValue(strFile, "DeviceLvlLocks", UDCDMain.UD_DeviceLvlLocks)
    JsonUtil.SetIntValue(strFile, "PreventMasterLock", UDCDmain.UD_PreventMasterLock as Int)
    JsonUtil.SetIntValue(strFile, "PostOrgasmArousalReduce", UDCONF.UD_OrgasmArousalReduce)
    JsonUtil.SetIntValue(strFile, "PostOrgasmArousalReduce_Duration", UDCONF.UD_OrgasmArousalReduceDuration)
    JsonUtil.SetIntValue(strFile, "MandatoryCrit", UDCDmain.UD_MandatoryCrit as Int)
    JsonUtil.SetFloatValue(strFile, "CritDurationAdjust", UDCDmain.UD_CritDurationAdjust)
    JsonUtil.SetIntValue(strFile, "KeyDurability", UDCDmain.UD_KeyDurability)
    JsonUtil.SetIntValue(strFile, "HardcoreAccess", UDCDmain.UD_HardcoreAccess as Int)
    JsonUtil.SetFloatValue(strFile, "MinigameDrainMult", UDCDmain.UD_MinigameDrainMult)
    JsonUtil.SetFloatValue(strFile, "InitialDrainDelay", UDCDmain.UD_InitialDrainDelay)
    JsonUtil.SetFloatValue(strFile, "MinigameExhDurationMult", UDCDmain.UD_MinigameExhDurationMult)
    JsonUtil.SetFloatValue(strFile, "MinigameExhMagnitudeMult", UDCDmain.UD_MinigameExhMagnitudeMult)
    JsonUtil.SetIntValue(strFile, "LockpickMinigameDuration", UDCDmain.UD_LockpickMinigameDuration)
    JsonUtil.SetFloatValue(strFile, "MinigameExhExponential", UDCDMain.UD_MinigameExhExponential)
    JsonUtil.SetIntValue(strFile, "MinigameExhNoStruggleMax", UDCDMAIN.UD_MinigameExhNoStruggleMax as Int)
    
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

    ;PATCHER
    JsonUtil.SetIntValue(strFile, "EscapeModifier", UDCDmain.UDPatcher.UD_EscapeModifier)
    JsonUtil.SetIntValue(strFile, "MinLocks", UDCDmain.UDPatcher.UD_MinLocks)
    JsonUtil.SetIntValue(strFile, "MaxLocks", UDCDmain.UDPatcher.UD_MaxLocks)
    JsonUtil.SetIntValue(strFile, "MinResist", Round(UDCDmain.UDPatcher.UD_MinResistMult*100))
    JsonUtil.SetIntValue(strFile, "MaxResist", Round(UDCDmain.UDPatcher.UD_MaxResistMult*100))
    JsonUtil.SetFloatValue(strFile, "PatchMult", UDCDmain.UDPatcher.UD_PatchMult)
    JsonUtil.SetFloatValue(strFile, "PatchMult_HeavyBondage"    , UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Blindfold"        , UDCDmain.UDPatcher.UD_PatchMult_Blindfold)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Gag"                , UDCDmain.UDPatcher.UD_PatchMult_Gag)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Hood"            , UDCDmain.UDPatcher.UD_PatchMult_Hood)
    JsonUtil.SetFloatValue(strFile, "PatchMult_ChastityBelt"    , UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt)
    JsonUtil.SetFloatValue(strFile, "PatchMult_ChastityBra"        , UDCDmain.UDPatcher.UD_PatchMult_ChastityBra)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Plug"            , UDCDmain.UDPatcher.UD_PatchMult_Plug)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Piercing"        , UDCDmain.UDPatcher.UD_PatchMult_Piercing)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Generic"            , UDCDmain.UDPatcher.UD_PatchMult_Generic)
    JsonUtil.SetIntValue(strFile, "TimedLocks", UDCDmain.UDPatcher.UD_TimedLocks as Int)
    
    ;UI/WIDGET
    JsonUtil.SetIntValue(strFile, "UseIWantWidget", UDWC.UD_UseIWantWidget as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_EnableDeviceIcons", UDWC.UD_EnableDeviceIcons as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_EnableEffectIcons", UDWC.UD_EnableDebuffIcons as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_EnableCNotifications", UDWC.UD_EnableCNotifications as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextFontSize", UDWC.UD_TextFontSize)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextLineLength", UDWC.UD_TextLineLength)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextReadSpeed", UDWC.UD_TextReadSpeed)
    JsonUtil.SetIntValue(strFile, "iWidgets_FilterVibNotifications", UDWC.UD_FilterVibNotifications as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_IconsSize", UDWC.UD_IconsSize)
    JsonUtil.SetIntValue(strFile, "iWidgets_IconsAnchor", UDWC.UD_IconsAnchor)
    JsonUtil.SetIntValue(strFile, "iWidgets_IconsPadding", UDWC.UD_IconsPadding)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextAnchor", UDWC.UD_TextAnchor)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextPadding", UDWC.UD_TextPadding)
    JsonUtil.SetIntValue(strFile, "WidgetPosX", UDWC.UD_WidgetXPos)
    JsonUtil.SetIntValue(strFile, "WidgetPosY", UDWC.UD_WidgetYPos)
    JsonUtil.SetStringValue(strFile, "MenuTextFormatter", UDMTF.GetMode())
    JsonUtil.SetStringValue(strFile, "MenuMsgManager", UDMMM.GetMode())
    JsonUtil.SetIntValue(strFile, "iWidgets_EffectExhaustion_Icon", UDWC.StatusEffect_GetVariant("effect-exhaustion"))
    JsonUtil.SetIntValue(strFile, "iWidgets_EffectOrgasm_Icon", UDWC.StatusEffect_GetVariant("effect-orgasm"))
    
    ;OTHER
    JsonUtil.SetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)
    JsonUtil.SetIntValue(strFile, "SwimmingDifficulty", UDSS.UD_hardcore_swimming_difficulty)
    JsonUtil.SetIntValue(strFile, "RandomFiler", UDCONF.UD_RandomDevice_GlobalFilter)
    JsonUtil.SetIntValue(strFile, "SlotUpdateTime", Round(UDCD_NPCM.UD_SlotUpdateTime))
    JsonUtil.SetIntValue(strFile, "AllowMenBondage", UDmain.AllowMenBondage as Int)
    JsonUtil.SetIntValue(strFile, "AICooldown", UDAI.UD_AICooldown)
    JsonUtil.SetIntValue(strFile, "AIUpdateTime", UDAI.UD_UpdateTime)
    JsonUtil.SetIntValue(strFile, "AIEnabled", UDAI.Enabled as Int)
    
    ; ANIMATIONS
    JsonUtil.StringListCopy(strFile, "Anims_UserDisabledJSONs", UDAM.UD_AnimationJSON_Off)
    JsonUtil.SetIntValue(strFile, "AlternateAnimation", UDAM.UD_AlternateAnimation as Int)
    JsonUtil.SetIntValue(strFile, "AlternateAnimationPeriod", UDAM.UD_AlternateAnimationPeriod)
    JsonUtil.SetIntValue(strFile, "UseSingleStruggleKeyword", UDAM.UD_UseSingleStruggleKeyword as Int)
    
    ; MODIFIERS
    JsonUtil.SetIntValue(strFile, "Patcher_ModsMin", UDCDmain.UDPatcher.UD_ModsMin)
    JsonUtil.SetIntValue(strFile, "Patcher_ModsMax", UDCDmain.UDPatcher.UD_ModsMax)
    JsonUtil.SetFloatValue(strFile, "Patcher_ModGlobalProbabilityMult", UDCDmain.UDPatcher.UD_ModGlobalProbabilityMult)
    JsonUtil.SetFloatValue(strFile, "Patcher_ModGlobalSeverityShift", UDCDmain.UDPatcher.UD_ModGlobalSeverityShift)
    JsonUtil.SetFloatValue(strFile, "Patcher_ModGlobalSeverityDispMult", UDCDmain.UDPatcher.UD_ModGlobalSeverityDispMult)
    Int loc_i = 0
    While loc_i < UDmain.UDMOM.UD_ModifierListRef.Length
        UD_Modifier loc_mod = UDmain.UDMOM.UD_ModifierListRef[loc_i] as UD_Modifier
        If loc_mod != None
            loc_mod.SaveToJSON(strFile)
        EndIf
        loc_i += 1
    EndWhile

    ; Skill
    JsonUtil.SetIntValue(strFile, "MinigameLockpickSkillAdjust", UDCDmain.UD_MinigameLockpickSkillAdjust)
    JsonUtil.SetFloatValue(strFile, "BaseDeviceSkillIncrease", UDCDmain.UD_BaseDeviceSkillIncrease)
    JsonUtil.SetIntValue(strFile, "ExperienceGain", UDCDmain.UD_ExperienceGainBase)
    JsonUtil.SetFloatValue(strFile, "ExperienceExp", UDCDmain.UD_ExperienceGainExp)

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

    ;UDmain
    UDmain.UD_hightPerformance = JsonUtil.GetIntValue(strFile, "hightPerformance", UDmain.UD_hightPerformance as Int)
    UDmain.AllowNPCSupport = JsonUtil.GetIntValue(strFile, "AllowNPCSupport", UDmain.AllowNPCSupport as Int)
    UDmain.lockMCM = JsonUtil.GetIntValue(strFile, "lockMCM", UDmain.lockMCM as Int)
    UDmain.DebugMod = JsonUtil.GetIntValue(strFile, "Debug mode", UDmain.DebugMod as Int)
    UDmain.UD_OrgasmExhaustion = JsonUtil.GetIntValue(strFile, "OrgasmExhastion", UDmain.UD_OrgasmExhaustion as int)
    ;UDmain.UD_OrgasmExhaustionMagnitude = JsonUtil.GetFloatValue(strFile, "OrgasmExhaustionMag", UDmain.UD_OrgasmExhaustionMagnitude)
    ;UDmain.UD_OrgasmExhaustionDuration = JsonUtil.GetIntValue(strFile, "OrgasmExhaustionDuration", UDmain.UD_OrgasmExhaustionDuration)
    UDmain.UD_AutoLoad = JsonUtil.GetIntValue(strFile, "AutoLoad", UDmain.UD_AutoLoad as int)
    UDmain.LogLevel = JsonUtil.GetIntValue(strFile, "LogLevel", UDmain.LogLevel as int)
    UDmain.UD_HearingRange = JsonUtil.GetIntValue(strFile, "HearingRange", UDmain.UD_HearingRange)
    UDmain.UD_WarningAllowed = JsonUtil.GetIntValue(strFile, "WarningAllowed", UDmain.UD_WarningAllowed as Int)
    UDmain.UD_PrintLevel = JsonUtil.GetIntValue(strFile, "PrintLevel", UDmain.UD_PrintLevel)
    UDmain.UD_LockDebugMCM = JsonUtil.GetIntValue(strFile, "LockDebug", UDmain.UD_LockDebugMCM as Int)
    UDUI.UD_EasyGamepadMode = JsonUtil.GetIntValue(strFile, "EasyGamepadMode", UDUI.UD_EasyGamepadMode as Int)
    UDmain.UD_CheckAllKw = JsonUtil.GetIntValue(strFile,"AllKeywordCheck",UDmain.UD_CheckAllKw as Int)

    ;UDCDmain
    UDCDmain.UnregisterGlobalKeys()
    UDCDmain.Stamina_meter_Keycode = JsonUtil.GetIntValue(strFile, "Stamina_meter_Keycode", UDCDmain.Stamina_meter_Keycode)
    UDCDmain.StruggleKey_Keycode = JsonUtil.GetIntValue(strFile, "StruggleKey_Keycode", UDCDmain.StruggleKey_Keycode)
    UDCDmain.Magicka_meter_Keycode = JsonUtil.GetIntValue(strFile, "Magicka_meter_Keycode", UDCDmain.Magicka_meter_Keycode)
    UDCDmain.SpecialKey_Keycode = JsonUtil.GetIntValue(strFile, "SpecialKey_Keycode", UDCDmain.SpecialKey_Keycode)
    UDCDmain.PlayerMenu_KeyCode = JsonUtil.GetIntValue(strFile, "PlayerMenu_KeyCode", UDCDmain.PlayerMenu_KeyCode)
    UDCDmain.ActionKey_Keycode = JsonUtil.GetIntValue(strFile, "ActionKey_Keycode", UDCDmain.ActionKey_Keycode)
    UDCDmain.NPCMenu_Keycode = JsonUtil.GetIntValue(strFile, "NPCMenu_Keycode", UDCDmain.NPCMenu_Keycode)
    UDCDmain.RegisterGlobalKeys()
    
    UDCDmain.UD_UseDDdifficulty = JsonUtil.GetIntValue(strFile, "UseDDdifficulty", UDCDmain.UD_UseDDdifficulty as Int)
    UDCDmain.UD_UseWidget = JsonUtil.GetIntValue(strFile, "UseWidget", UDCDmain.UD_UseWidget as Int)
    UDCDmain.UD_GagPhonemModifier = JsonUtil.GetIntValue(strFile, "GagPhonemModifier", UDCDmain.UD_GagPhonemModifier)
    UDCDmain.UD_StruggleDifficulty = JsonUtil.GetIntValue(strFile, "StruggleDifficulty", UDCDmain.UD_StruggleDifficulty)
    UDCONF.UD_UpdateTime = JsonUtil.GetFloatValue(strFile, "DeviceUpdateTime", UDCONF.UD_UpdateTime)
    
    UDCDmain.UD_AutoCrit = JsonUtil.GetIntValue(strFile, "AutoCrit", UDCDmain.UD_AutoCrit as Int)
    if UDCDmain.UD_AutoCrit
        UD_autocrit_flag = OPTION_FLAG_NONE
    else
        UD_autocrit_flag = OPTION_FLAG_DISABLED
    endif
    
    UDCDmain.UD_AutoCritChance              = JsonUtil.GetIntValue(strFile, "AutoCritChance", UDCDmain.UD_AutoCritChance)
    UDCDmain.UD_VibrationMultiplier         = JsonUtil.GetFloatValue(strFile, "VibrationMultiplier", UDCDmain.UD_VibrationMultiplier)
    UDCDmain.UD_ArousalMultiplier           = JsonUtil.GetFloatValue(strFile, "ArousalMultiplier", UDCDmain.UD_ArousalMultiplier)
    UDCONF.UD_OrgasmResistence                = JsonUtil.GetFloatValue(strFile, "OrgasmResistence", UDCONF.UD_OrgasmResistence)
    UDCONF.UD_OrgasmExhaustionStruggleMax     = JsonUtil.GetIntValue(strFile, "OrgasmExhaustionStruggleMax", UDCONF.UD_OrgasmExhaustionStruggleMax)
    UDCDmain.UD_LockpicksPerMinigame        = JsonUtil.GetIntValue(strFile, "LockpicksPerMinigame", UDCDmain.UD_LockpicksPerMinigame)
    UDCONF.UD_UseOrgasmWidget                 = JsonUtil.GetIntValue(strFile, "UseOrgasmWidget", UDCONF.UD_UseOrgasmWidget as Int)
    UDCONF.UD_OrgasmUpdateTime                = JsonUtil.GetFloatValue(strFile, "OrgasmUpdateTime", UDCONF.UD_OrgasmUpdateTime)
    UDCONF.UD_OrgasmAnimation                 = JsonUtil.GetIntValue(strFile, "OrgasmAnimation", UDCONF.UD_OrgasmAnimation)
    UDCONF.UD_HornyAnimation                  = JsonUtil.GetIntValue(strFile, "HornyAnimation", UDCONF.UD_HornyAnimation as Int)
    UDCONF.UD_HornyAnimationDuration          = JsonUtil.GetIntValue(strFile, "HornyAnimationDuration", UDCONF.UD_HornyAnimationDuration)
    UDCDmain.UD_CooldownMultiplier          = JsonUtil.GetFloatValue(strFile, "CooldownMultiplier", UDCDmain.UD_CooldownMultiplier)
    UDCDMain.UD_SkillEfficiency             = JsonUtil.GetIntValue(strFile, "SkillEfficiency", UDCDmain.UD_SkillEfficiency)
    UDCDmain.UD_CritEffect                  = JsonUtil.GetIntValue(strFile, "CritEffect", UDCDmain.UD_CritEffect)
    UDCDmain.UD_HardcoreMode                = JsonUtil.GetIntValue(strFile, "HardcoreMode", UDCDmain.UD_HardcoreMode as Int)
    UDCDmain.UD_AllowArmTie                 = JsonUtil.GetIntValue(strFile, "AllowArmTie", UDCDmain.UD_AllowArmTie as Int)
    UDCDmain.UD_AllowLegTie                 = JsonUtil.GetIntValue(strFile, "AllowLegTie", UDCDmain.UD_AllowLegTie as Int)
    UDCDmain.UD_MinigameHelpCd              = JsonUtil.GetIntValue(strFile, "MinigameHelpCD",UDCDmain.UD_MinigameHelpCd)
    UDCDmain.UD_MinigameHelpCD_PerLVL       = JsonUtil.GetIntValue(strFile, "MinigameHelpCD_PerLVL", Round(UDCDmain.UD_MinigameHelpCD_PerLVL))
    UDCDmain.UD_MinigameHelpXPBase          = JsonUtil.GetIntValue(strFile, "MinigameHelpXPBase", UDCDmain.UD_MinigameHelpXPBase)
    UDCDMain.UD_DeviceLvlHealth             = JsonUtil.GetFloatValue(strFile, "DeviceLvlHealth", UDCDMain.UD_DeviceLvlHealth*100)/100
    UDCDMain.UD_DeviceLvlLockpick           = JsonUtil.GetFloatValue(strFile, "DeviceLvlLockpick", UDCDMain.UD_DeviceLvlLockpick)
    UDCDMain.UD_DeviceLvlLocks              = JsonUtil.GetIntValue(strFile, "DeviceLvlLocks", UDCDMain.UD_DeviceLvlLocks)
    UDCDmain.UD_PreventMasterLock           = JsonUtil.GetIntValue(strFile, "PreventMasterLock", UDCDmain.UD_PreventMasterLock as Int)
    UDCONF.UD_OrgasmArousalReduce             = JsonUtil.GetIntValue(strFile, "PostOrgasmArousalReduce", UDCONF.UD_OrgasmArousalReduce)
    UDCONF.UD_OrgasmArousalReduceDuration     = JsonUtil.GetIntValue(strFile, "PostOrgasmArousalReduce_Duration", UDCONF.UD_OrgasmArousalReduceDuration)
    UDCDmain.UD_MandatoryCrit               = JsonUtil.GetIntValue(strFile, "MandatoryCrit", UDCDmain.UD_MandatoryCrit as Int)
    UDCDmain.UD_CritDurationAdjust          = JsonUtil.GetFloatValue(strFile, "CritDurationAdjust", UDCDmain.UD_CritDurationAdjust)
    UDCDmain.UD_KeyDurability               = JsonUtil.GetIntValue(strFile, "KeyDurability", UDCDmain.UD_KeyDurability)
    UDCDmain.UD_HardcoreAccess              = JsonUtil.GetIntValue(strFile, "HardcoreAccess", UDCDmain.UD_HardcoreAccess as Int)
    UDCDmain.UD_MinigameDrainMult           = JsonUtil.GetFloatValue(strFile, "MinigameDrainMult", UDCDmain.UD_MinigameDrainMult)
    UDCDmain.UD_InitialDrainDelay           = JsonUtil.GetFloatValue(strFile, "InitialDrainDelay", UDCDmain.UD_InitialDrainDelay)
    UDCDmain.UD_MinigameExhDurationMult     = JsonUtil.GetFloatValue(strFile, "MinigameExhDurationMult", UDCDmain.UD_MinigameExhDurationMult)
    UDCDmain.UD_MinigameExhMagnitudeMult    = JsonUtil.GetFloatValue(strFile, "MinigameExhMagnitudeMult", UDCDmain.UD_MinigameExhMagnitudeMult)
    UDCDmain.UD_LockpickMinigameDuration    = JsonUtil.GetIntValue(strFile, "LockpickMinigameDuration", UDCDmain.UD_LockpickMinigameDuration)
    UDCDMain.UD_MinigameExhExponential      = JsonUtil.GetFloatValue(strFile, "MinigameExhExponential", UDCDMain.UD_MinigameExhExponential)
    UDCDMain.UD_MinigameExhNoStruggleMax   = JsonUtil.GetIntValue(strFile, "MinigameExhNoStruggleMax", UDCDMain.UD_MinigameExhNoStruggleMax)
    
    
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

    ;PATCHER
    UDCDmain.UDPatcher.UD_EscapeModifier = JsonUtil.GetIntValue(strFile, "EscapeModifier", UDCDmain.UDPatcher.UD_EscapeModifier)
    UDCDmain.UDPatcher.UD_MinLocks = JsonUtil.GetIntValue(strFile, "MinLocks", UDCDmain.UDPatcher.UD_MinLocks)
    UDCDmain.UDPatcher.UD_MaxLocks = JsonUtil.GetIntValue(strFile, "MaxLocks", UDCDmain.UDPatcher.UD_MaxLocks)
    UDCDmain.UDPatcher.UD_MinResistMult = JsonUtil.GetIntValue(strFile, "MinResist", Round(UDCDmain.UDPatcher.UD_MinResistMult*100))/100
    UDCDmain.UDPatcher.UD_MaxResistMult = JsonUtil.GetIntValue(strFile, "MaxResist", Round(UDCDmain.UDPatcher.UD_MaxResistMult*100))/100
    UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage = JsonUtil.GetFloatValue(strFile, "PatchMult_HeavyBondage", UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage)
    UDCDmain.UDPatcher.UD_PatchMult_Blindfold = JsonUtil.GetFloatValue(strFile, "PatchMult_Blindfold", UDCDmain.UDPatcher.UD_PatchMult_Blindfold)
    UDCDmain.UDPatcher.UD_PatchMult_Gag = JsonUtil.GetFloatValue(strFile, "PatchMult_Gag", UDCDmain.UDPatcher.UD_PatchMult_Gag)
    UDCDmain.UDPatcher.UD_PatchMult_Hood = JsonUtil.GetFloatValue(strFile, "PatchMult_Hood", UDCDmain.UDPatcher.UD_PatchMult_Hood)
    UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt = JsonUtil.GetFloatValue(strFile, "PatchMult_ChastityBelt", UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt)
    UDCDmain.UDPatcher.UD_PatchMult_ChastityBra = JsonUtil.GetFloatValue(strFile, "PatchMult_ChastityBra", UDCDmain.UDPatcher.UD_PatchMult_ChastityBra)
    UDCDmain.UDPatcher.UD_PatchMult_Plug = JsonUtil.GetFloatValue(strFile, "PatchMult_Plug", UDCDmain.UDPatcher.UD_PatchMult_Plug)
    UDCDmain.UDPatcher.UD_PatchMult_Piercing = JsonUtil.GetFloatValue(strFile, "PatchMult_Piercing", UDCDmain.UDPatcher.UD_PatchMult_Piercing)
    UDCDmain.UDPatcher.UD_PatchMult_Generic = JsonUtil.GetFloatValue(strFile, "PatchMult_Generic", UDCDmain.UDPatcher.UD_PatchMult_Generic)
    UDCDmain.UDPatcher.UD_TimedLocks = JsonUtil.GetIntValue(strFile, "TimedLocks", UDCDmain.UDPatcher.UD_TimedLocks as Int)
    
    ;UI/WIDGET
    UDWC.UD_UseIWantWidget = JsonUtil.GetIntValue(strFile, "UseIWantWidget", UDWC.UD_UseIWantWidget as Int)
    UDWC.UD_EnableDeviceIcons = JsonUtil.GetIntValue(strFile, "iWidgets_EnableDeviceIcons", UDWC.UD_EnableDeviceIcons as Int)
    UDWC.UD_EnableDebuffIcons = JsonUtil.GetIntValue(strFile, "iWidgets_EnableEffectIcons", UDWC.UD_EnableDebuffIcons as Int)
    UDWC.UD_EnableCNotifications = JsonUtil.GetIntValue(strFile, "iWidgets_EnableCNotifications", UDWC.UD_EnableCNotifications as Int)
    UDWC.UD_TextFontSize = JsonUtil.GetIntValue(strFile, "iWidgets_TextFontSize", UDWC.UD_TextFontSize)
    UDWC.UD_TextLineLength = JsonUtil.GetIntValue(strFile, "iWidgets_TextLineLength", UDWC.UD_TextLineLength)
    UDWC.UD_TextReadSpeed = JsonUtil.GetIntValue(strFile, "iWidgets_TextReadSpeed", UDWC.UD_TextReadSpeed)
    UDWC.UD_FilterVibNotifications = JsonUtil.GetIntValue(strFile, "iWidgets_FilterVibNotifications", UDWC.UD_FilterVibNotifications as Int) == 1
    UDWC.UD_IconsSize = JsonUtil.GetIntValue(strFile, "iWidgets_IconsSize", UDWC.UD_IconsSize)
    UDWC.UD_IconsAnchor = JsonUtil.GetIntValue(strFile, "iWidgets_IconsAnchor", UDWC.UD_IconsAnchor)
    UDWC.UD_IconsPadding = JsonUtil.GetIntValue(strFile, "iWidgets_IconsPadding", UDWC.UD_IconsPadding)
    UDWC.UD_TextAnchor = JsonUtil.GetIntValue(strFile, "iWidgets_TextAnchor", UDWC.UD_TextAnchor)
    UDWC.UD_TextPadding = JsonUtil.GetIntValue(strFile, "iWidgets_TextPadding", UDWC.UD_TextPadding)
    Int variant = JsonUtil.GetIntValue(strFile, "iWidgets_EffectExhaustion_Icon", -1)
    UDWC.StatusEffect_Register("effect-exhaustion", -1, variant)
    variant = JsonUtil.GetIntValue(strFile, "iWidgets_EffectOrgasm_Icon", -1)
    UDWC.StatusEffect_Register("effect-orgasm", -1, variant)
    UDWC.UD_WidgetXPos = JsonUtil.GetIntValue(strFile, "WidgetPosX", UDWC.UD_WidgetXPos)
    UDWC.UD_WidgetYPos = JsonUtil.GetIntValue(strFile, "WidgetPosY", UDWC.UD_WidgetYPos)
    UDMTF.SetMode(JsonUtil.GetStringValue(strFile, "MenuTextFormatter", "HTML"))
    UDMMM.SetMode(JsonUtil.GetStringValue(strFile, "MenuMsgManager", "Native_UI"))
    
    ;Other
    libs.UD_StartThirdpersonAnimation_Switch = JsonUtil.GetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)
    UDSS.UD_hardcore_swimming_difficulty = JsonUtil.GetIntValue(strFile, "SwimmingDifficulty", UDSS.UD_hardcore_swimming_difficulty)
    UDCONF.UD_RandomDevice_GlobalFilter =  JsonUtil.GetIntValue(strFile, "RandomFiler", UDCONF.UD_RandomDevice_GlobalFilter)
    UDCD_NPCM.UD_SlotUpdateTime =  JsonUtil.GetIntValue(strFile, "SlotUpdateTime", Round(UDCD_NPCM.UD_SlotUpdateTime))
    UDmain.AllowMenBondage = JsonUtil.GetIntValue(strFile, "AllowMenBondage", UDmain.AllowMenBondage as Int)
    UDAI.Enabled = JsonUtil.GetIntValue(strFile, "AIEnabled", UDAI.Enabled as Int)
    UDAI.UD_AICooldown = JsonUtil.GetIntValue(strFile, "AICooldown", UDAI.UD_AICooldown)
    UDAI.UD_UpdateTime = JsonUtil.GetIntValue(strFile, "AIUpdateTime", UDAI.UD_UpdateTime)
    
    ; ANIMATIONS
    If JsonUtil.StringListCount(strFile, "Anims_UserDisabledJSONs") > 0
        UDAM.UD_AnimationJSON_Off = JsonUtil.StringListToArray(strFile, "Anims_UserDisabledJSONs")
    EndIf
    UDAM.UD_AlternateAnimation = JsonUtil.GetIntValue(strFile, "AlternateAnimation", UDAM.UD_AlternateAnimation as Int) > 0
    UDAM.UD_AlternateAnimationPeriod = JsonUtil.GetIntValue(strFile, "AlternateAnimationPeriod", UDAM.UD_AlternateAnimationPeriod)
    UDAM.UD_UseSingleStruggleKeyword = JsonUtil.GetIntValue(strFile, "UseSingleStruggleKeyword", UDAM.UD_UseSingleStruggleKeyword as Int) > 0

    UD_Native.SyncAnimationSetting(UDAM.UD_AnimationJSON_Off)
    
    ; MODIFIERS
    UDCDmain.UDPatcher.UD_ModsMin = JsonUtil.GetIntValue(strFile, "Patcher_ModsMinCap", UDCDmain.UDPatcher.UD_ModsMin)
    UDCDmain.UDPatcher.UD_ModsMax = JsonUtil.GetIntValue(strFile, "Patcher_ModsSoftCap", UDCDmain.UDPatcher.UD_ModsMax)
    UDCDmain.UDPatcher.UD_ModGlobalProbabilityMult = JsonUtil.GetFloatValue(strFile, "Patcher_ModGlobalProbabilityMult", UDCDmain.UDPatcher.UD_ModGlobalProbabilityMult)
    UDCDmain.UDPatcher.UD_ModGlobalSeverityShift = JsonUtil.GetFloatValue(strFile, "Patcher_ModGlobalSeverityShift", UDCDmain.UDPatcher.UD_ModGlobalSeverityShift)
    UDCDmain.UDPatcher.UD_ModGlobalSeverityDispMult = JsonUtil.GetFloatValue(strFile, "Patcher_ModGlobalSeverityDispMult", UDCDmain.UDPatcher.UD_ModGlobalSeverityDispMult)
    Int loc_i = 0
    While loc_i < UDmain.UDMOM.UD_ModifierListRef.Length
        UD_Modifier loc_mod = UDmain.UDMOM.UD_ModifierListRef[loc_i] as UD_Modifier
        If loc_mod != None
            loc_mod.LoadFromJSON(strFile)
        EndIf
        loc_i += 1
    EndWhile
    
    ;Skill
    UDCDmain.UD_MinigameLockpickSkillAdjust = JsonUtil.GetIntValue(strFile, "MinigameLockpickSkillAdjust", UDCDmain.UD_MinigameLockpickSkillAdjust)
    UDCDmain.UD_BaseDeviceSkillIncrease = JsonUtil.GetFloatValue(strFile, "BaseDeviceSkillIncrease", UDCDmain.UD_BaseDeviceSkillIncrease)
    UDCDmain.UD_ExperienceGainBase = JsonUtil.GetIntValue(strFile, "ExperienceGainBase", UDCDmain.UD_ExperienceGainBase)
    UDCDmain.UD_ExperienceGainExp = JsonUtil.GetFloatValue(strFile, "ExperienceExp", UDCDmain.UD_ExperienceGainExp)
EndFunction

Function ResetToDefaults()
    ; CONF
    UDCONF.UD_UpdateTime                = 5.0

    ;UDmain
    UDmain.UD_hightPerformance          = true
    UDmain.AllowNPCSupport              = true
    UDmain.lockMCM                      = false
    UDmain.DebugMod                     = false
    UDmain.UD_OrgasmExhaustion          = true
    UDmain.UD_OrgasmExhaustionMagnitude = 20.0
    UDmain.UD_OrgasmExhaustionDuration  = 30
    UDmain.UD_AutoLoad                  = false
    UDmain.LogLevel                     = 0
    UDmain.UD_HearingRange              = 4000
    UDmain.UD_WarningAllowed            = false
    UDmain.UD_PrintLevel                = 3
    UDmain.UD_LockDebugMCM              = False
    UDUI.UD_EasyGamepadMode             = false
    UDmain.UD_CheckAllKw                = False
    
    ;UDCDmain
    UDCDmain.UnregisterGlobalKeys()
    if !Game.UsingGamepad()
        UDCDmain.Stamina_meter_Keycode  = 32
        UDCDmain.StruggleKey_Keycode    = 52
        UDCDmain.Magicka_meter_Keycode  = 30
        UDCDmain.SpecialKey_Keycode     = 31
        UDCDmain.PlayerMenu_KeyCode     = 40
        UDCDmain.ActionKey_Keycode      = 18
        UDCDmain.NPCMenu_Keycode        = 39
    else
        UDCDmain.Stamina_meter_Keycode  = 275
        UDCDmain.StruggleKey_Keycode    = 275
        UDCDmain.Magicka_meter_Keycode  = 274
        UDCDmain.SpecialKey_Keycode     = 276
        UDCDmain.PlayerMenu_KeyCode     = 268
        UDCDmain.NPCMenu_Keycode        = 269
        UDCDmain.ActionKey_Keycode      = 279
    endif
    UDCDmain.RegisterGlobalKeys()
    
    UDCDmain.UD_UseDDdifficulty         = true
    UDCDmain.UD_UseWidget               = true
    UDCDmain.UD_GagPhonemModifier       = 50
    UDCDmain.UD_StruggleDifficulty      = 1
    UDCDmain.UD_AutoCrit = false
    if UDCDmain.UD_AutoCrit
        UD_autocrit_flag = OPTION_FLAG_NONE
    else
        UD_autocrit_flag = OPTION_FLAG_DISABLED
    endif
    UDCDmain.UD_AutoCritChance          = 80
    UDCDmain.UD_VibrationMultiplier     = 0.1
    UDCDmain.UD_ArousalMultiplier       = 0.025
    UDCONF.UD_OrgasmResistence            = 3.5
    UDCONF.UD_OrgasmExhaustionStruggleMax = 6
    UDCDmain.UD_LockpicksPerMinigame    = 2
    UDCONF.UD_UseOrgasmWidget             = true
    UDCONF.UD_OrgasmUpdateTime            = 0.5
    UDCONF.UD_OrgasmAnimation             = 1
    UDCONF.UD_HornyAnimation              = false
    UDCONF.UD_HornyAnimationDuration      = 5
    UDCDmain.UD_CooldownMultiplier      = 1.0
    UDCDmain.UD_CritEffect              = 2
    UDCDmain.UD_HardcoreMode            = false
    UDCDmain.UD_AllowArmTie             = true
    UDCDmain.UD_AllowLegTie             = true
    UDCDMain.UD_SkillEfficiency         = 1
    UDCDmain.UD_MinigameHelpCd          = 60
    UDCDmain.UD_MinigameHelpCD_PerLVL   = 10
    UDCDmain.UD_MinigameHelpXPBase      = 35
    UDCDmain.UD_DeviceLvlHealth         = 0.025
    UDCDmain.UD_DeviceLvlLockpick       = 0.5
    UDCDMain.UD_DeviceLvlLocks          = 5
    UDCDmain.UD_PreventMasterLock       = False
    UDCONF.UD_OrgasmArousalReduce         = 25
    UDCONF.UD_OrgasmArousalReduceDuration =  7
    UDCDmain.UD_MandatoryCrit           = False
    UDCDmain.UD_CritDurationAdjust      = 0.0
    UDCDmain.UD_KeyDurability           = 5
    UDCDmain.UD_HardcoreAccess          = False
    UDCDmain.UD_MinigameDrainMult       = 1.0
    UDCDmain.UD_InitialDrainDelay       = 0
    UDCDmain.UD_MinigameExhDurationMult = 1.0
    UDCDmain.UD_MinigameExhMagnitudeMult= 1.0
    UDCDMain.UD_MinigameExhExponential  = 1.0
    UDCDMain.UD_MinigameExhNoStruggleMax= 2
    
    ;ABADON
    AbadonQuest.final_finisher_set      = true
    AbadonQuest.final_finisher_pref     = 0
    AbadonQuest.UseAnalVariant          = false
    
    ;PATCHER
    UDCDmain.UDPatcher.UD_EscapeModifier            = 10
    UDCDmain.UDPatcher.UD_MinLocks                  = 0
    UDCDmain.UDPatcher.UD_MaxLocks                  = 2
    UDCDmain.UDPatcher.UD_MinResistMult             =-1.0
    UDCDmain.UDPatcher.UD_MaxResistMult             = 1.0
    UDCDmain.UDPatcher.UD_PatchMult                 = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage    = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Blindfold       = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Gag             = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Hood            = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt    = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_ChastityBra     = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Plug            = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Piercing        = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Generic         = 1.0
    
    ;UI/WIDGET
    UDWC.ResetToDefault()
    
    ;Other
    libs.UD_StartThirdpersonAnimation_Switch        = true
    UDSS.UD_hardcore_swimming_difficulty            = 1
    UDWC.UD_WidgetXPos                              = 2
    UDWC.UD_WidgetYPos                              = 0
    UDCONF.UD_RandomDevice_GlobalFilter             = 0xFFFFFFFF ;32b
    UDCD_NPCM.UD_SlotUpdateTime                     = 10.0
    UDmain.AllowMenBondage                          = False
    UDAI.Enabled                                    = True
    UDAI.UD_AICooldown                              = 30
    UDAI.UD_UpdateTime                              = 10
    
    ; Animations
    UDAM.LoadDefaultMCMSettings()
    
    ; Skill
    UDCDmain.UD_BaseDeviceSkillIncrease = 1.0
    UDCDmain.UD_MinigameLockpickSkillAdjust = 2
    UDCDmain.UD_ExperienceGainBase = 15
    UDCDmain.UD_ExperienceGainExp = 0.8
EndFunction

Function SetAutoLoad(bool abValue)
    if abValue
        ; Reset all presets auto load, as only one preset at the time can have AutoLoad enabled
        int loc_preset = 0
        while loc_preset < ConfigPresets.length
            String loc_path = GetConfigPath(ConfigPresets[loc_preset])
            JsonUtil.SetIntValue(loc_path, "AutoLoad", abValue as Int)
            JsonUtil.Save(loc_path, true)
            loc_preset += 1
        endwhile
    endif
    JsonUtil.SetIntValue(FILE, "AutoLoad", abValue as Int)
    JsonUtil.Save(FILE, true)
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
