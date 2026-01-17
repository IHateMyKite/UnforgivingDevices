Scriptname UD_MCM_Page_Other extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty


Function PageInit()
    InitConfigPresets(true)
EndFunction

Function PageUpdate()
    InitConfigPresets(false)
EndFunction

String[]    ConfigPresets
String Property     SelectedPreset
    String Function get()
        return MCM.SelectedPreset
    EndFunction
    Function set(String asVal)
        MCM.SelectedPreset = asVal
    EndFunction
EndProperty
Int         SelectedPresetId = 0
String      ConfigPath = "Data\\skse\\plugins\\StorageUtilData\\UD\\Presets"

int UD_Export_T
int UD_Import_T
int UD_Default_T
int UD_AutoLoad_T
int UD_ConfigPresets_M
int UD_ConfigPresets_T
Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
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

Function PageOptionSelect(Int option)
    if UD_Export_T == option
        MCM.SaveToJSON(File)
        ShowMessage("$Configuration saved!",false,"OK")
        ;forcePageReset()
    elseif UD_Import_T == option
        MCM.LoadFromJSON(File)
        ShowMessage("$Saved configuration loaded!",false,"OK")
    elseif option == UD_Default_T
        if ShowMessage("$Do you really want to discard all changes and load default values?")
            MCM.ResetToDefaults()
        endif
    elseif option == UD_AutoLoad_T
        UDmain.UD_AutoLoad = !UDmain.UD_AutoLoad
        SetAutoLoad(UDmain.UD_AutoLoad)
        SetToggleOptionValue(UD_AutoLoad_T, UDmain.UD_AutoLoad)
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)
EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)
EndFunction

Function PageOptionMenuOpen(int option)
    If option == UD_ConfigPresets_M
        SetMenuDialogOptions(ConfigPresets)
        SetMenuDialogStartIndex(SelectedPresetId)
        SetMenuDialogDefaultIndex(0)
    EndIf
EndFunction
Function PageOptionMenuAccept(int option, int index)
    If option == UD_ConfigPresets_M
        SelectedPresetId    = index
        SelectedPreset      = ConfigPresets[index]
        SetMenuOptionValue(option, SelectedPreset)
        MCM.LoadFromJSON(File)
        forcePageReset()
    EndIf
EndFunction

Function PageOptionInputOpen(int aiOption)
    if aiOption == UD_ConfigPresets_T
        SetInputDialogStartText("")
    endif
EndFunction
Function PageOptionInputAccept(Int option, String value)
    if(option == UD_ConfigPresets_T)
        if value
            if StringUtil.Find(value,".json") == -1
                value = value + ".json"
            endif
            if ConfigPresets.find(value) == -1
                ConfigPresets = PapyrusUtil.PushString(ConfigPresets,value)
                SelectedPreset = value
                SelectedPresetId = ConfigPresets.length - 1
                MCM.SaveToJSON(File)
                forcePageReset()
            endif
        endif
    endif
EndFunction


Function PageDefault(int aiOption)
EndFunction

Function PageInfo(int option)
EndFunction

Function UpdateSelectedPresetId()
    SelectedPresetId = ConfigPresets.find(SelectedPreset)
    if SelectedPresetId == -1
        SelectedPreset = "Default.json"
        SelectedPresetId = ConfigPresets.find(SelectedPreset)
        MCM.SaveToJSON(File)
    endif
EndFunction

string property File hidden
    string function get()
        return GetConfigPath(SelectedPreset)
    endFunction
endProperty

String Function GetConfigPath(String asName)
    return "./UD/Presets/" + asName
EndFunction

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