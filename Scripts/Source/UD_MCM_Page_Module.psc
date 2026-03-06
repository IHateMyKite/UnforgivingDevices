Scriptname UD_MCM_Page_Module extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty

Int       _Modules_M
Int       _Modules_Id
String[]  _Modules_List
Quest[]   _Modules

Function PageUpdate()
EndFunction

Int _Description_T
Int _Reset_T
Int _ResetAll_T
Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)
    
    _Modules = UD_Native.GetModules()
    
    Int loc_i = 0
    _Modules_List = Utility.CreateStringArray(_Modules.length)
    while loc_i < _Modules.length
        UD_ModuleBase tmp_module = _Modules[loc_i] as UD_ModuleBase
        _Modules_List[loc_i] = tmp_module.MODULE_NAME
        loc_i += 1
    endwhile
    
    AddHeaderOption("Module select")
    addEmptyOption()
    
    _Modules_M = AddMenuOption("=== Module", _Modules_List[_Modules_Id])
    AddTextOption("Modules loaded",_Modules_List.length,FlagSwitch(false))
    
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("Module info")
    addEmptyOption()
    
    UD_ModuleBase loc_module = _Modules[_Modules_Id] as UD_ModuleBase
    Quest[]       loc_dependency = GetModuleDependency(loc_module)
    
    AddTextOption("Alias",loc_module.MODULE_ALIAS,FlagSwitch(false))
    _Description_T = AddTextOption("Description","INFO")
    
    Bool loc_init   = loc_module.IsInitiated()
    Bool loc_reload = loc_module.IsReloaded()
    
    AddTextOption("Initiated",loc_init as String,FlagSwitch(false))
    AddTextOption("Reloaded",loc_reload as String,FlagSwitch(false))
    
    AddTextOption("Priority",loc_module.MODULE_PRIO)
    addEmptyOption()
    
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("Module Operations")
    addEmptyOption()
    _Reset_T = AddTextOption("--RESET--","CLICK",FlagSwitch(loc_init && loc_reload))
    _ResetAll_T = AddTextOption("--RESET ALL--","CLICK",FlagSwitch(UD_Native.AreModulesReady(true)))
EndFunction

Function PageOptionSelect(Int aiOption)
    if _Reset_T == aiOption
        UD_ModuleBase loc_module = _Modules[_Modules_Id] as UD_ModuleBase
        loc_module.ResetModule()
        forcePageReset()
    elseif aiOption == _ResetAll_T
        closeMCM()
        UD_Native.ResetAllModules()
        ;forcePageReset()
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)

EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)

EndFunction

Function PageOptionMenuOpen(int aiOption)
    if (aiOption == _Modules_M)
        SetMenuDialogOptions(_Modules_List)
        SetMenuDialogStartIndex(_Modules_Id)
        SetMenuDialogDefaultIndex(0)
    endif
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
    if (aiOption == _Modules_M)
        _Modules_Id = aiIndex
        SetMenuOptionValue(_Modules_M, _Modules_List[_Modules_Id])
        forcePageReset()
    endIf
EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int aiOption)
    if _Description_T == aiOption
        UD_ModuleBase loc_module = _Modules[_Modules_Id] as UD_ModuleBase
        setinfotext(loc_module.MODULE_DESC)
    endif
EndFunction