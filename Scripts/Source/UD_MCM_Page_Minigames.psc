Scriptname UD_MCM_Page_Minigames extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty

Int       _Minigames_M
Int       _Minigames_Id = 0
String[]  _Minigames_List
String[]  _Minigames

String[]  _Exports

Int[]     _Exports_Ids

Int       _MinigameConfigId = -1

Function PageUpdate()
    _Minigames_Id = 0
    _MinigameConfigId = -1
EndFunction

Int _Description_T
Int _Reset_T
Int _ResetAll_T
Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)
    
    _Minigames = UD_Native.GetMinigameConfigs()
    
    _Minigames_List = Utility.CreateStringArray(_Minigames.length)
    
    if _Minigames.length == 0
        return
    endif
    
    Int loc_i = 0
    while loc_i < _Minigames.length
        _Minigames_List[loc_i] = GetJsonValue(_Minigames[loc_i],"name","ERROR")
        loc_i += 1
    endwhile
    
    AddHeaderOption("Minigame select")
    addEmptyOption()
    
    _Minigames_M = AddMenuOption("=== Minigame", _Minigames_List[_Minigames_Id])
    AddTextOption("Number of minigames",_Minigames_List.length,FlagSwitch(false))
    
    _MinigameConfigId = GetJsonValue(_Minigames[_Minigames_Id],"id","-1") as Int
    if _MinigameConfigId != -1
        addEmptyOption()
        addEmptyOption()
        AddHeaderOption("Minigame variables")
        addEmptyOption()
        _Exports = UD_Native.GetMinigameExports(_MinigameConfigId as Int)
        ;UDmain.info(_Exports)
        _Exports_Ids = Utility.CreateIntArray(_Exports.length)
        
        loc_i = 0
        while loc_i < _Exports.length
            String loc_name     = GetJsonValue(_Exports[loc_i],"name","ERROR")
            String loc_type     = GetJsonValue(_Exports[loc_i],"mcm.type","num")
            String loc_config   = GetJsonValue(_Exports[loc_i],"config","")
            if loc_type == "num"
                Float   loc_val      = UD_Native.GetMinigameVariable(_MinigameConfigId,loc_config,"0.0") as Float
                Float   loc_mult     = GetJsonValue(_Exports[loc_i],"mcm.mult","1.0") as Float
                String  loc_format   = GetJsonValue(_Exports[loc_i],"mcm.format","{0}")
                _Exports_Ids[loc_i]  = AddSliderOption(loc_name,loc_val*loc_mult,loc_format)
            elseif loc_type == "bool"
                Bool   loc_val       = UD_Native.GetMinigameVariable(_MinigameConfigId,loc_config,"false") == "true"
                _Exports_Ids[loc_i]  = addToggleOption(loc_name,loc_val)
            endif
            loc_i += 1
        endwhile
        
        
    endif

EndFunction

Function PageOptionSelect(Int aiOption)
    int loc_i = 0
    while loc_i < _Exports_Ids.length
        if aiOption == _Exports_Ids[loc_i]
            String loc_type = GetJsonValue(_Exports[loc_i],"mcm.type","num")
            if loc_type == "bool"
                String  loc_config   = GetJsonValue(_Exports[loc_i],"config","")
                bool    loc_val     = UD_Native.GetMinigameVariable(_MinigameConfigId,loc_config,"false") == "true"
                loc_val = !loc_val
                UD_Native.SetMinigameVariable(_MinigameConfigId,loc_config,loc_val as String)
                SetToggleOptionValue(aiOption, loc_val)
                return
            endif
        endif
        loc_i += 1
    endwhile
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    int loc_i = 0
    while loc_i < _Exports_Ids.length
        if aiOption == _Exports_Ids[loc_i]
            String loc_type = GetJsonValue(_Exports[loc_i],"mcm.type","num")
            if loc_type == "num"
                String  loc_config   = GetJsonValue(_Exports[loc_i],"config","")
                Float   loc_val     = UD_Native.GetMinigameVariable(_MinigameConfigId,loc_config,"0.0") as Float
                Float   loc_defval  = GetJsonValue(_Exports[loc_i],"default","0.0") as Float
                Float   loc_mult    = GetJsonValue(_Exports[loc_i],"mcm.mult","1.0") as Float
                Float   loc_min     = GetJsonValue(_Exports[loc_i],"mcm.min","0.0") as Float
                Float   loc_max     = GetJsonValue(_Exports[loc_i],"mcm.max","100.0") as Float
                Float   loc_prec    = GetJsonValue(_Exports[loc_i],"mcm.precision","1.0") as Float
                SetSliderDialogStartValue(loc_val*loc_mult)
                SetSliderDialogDefaultValue(loc_defval*loc_mult)
                SetSliderDialogRange(loc_min*loc_mult, loc_max*loc_mult)
                SetSliderDialogInterval(loc_prec*loc_mult)
                return
            endif
        endif
        loc_i += 1
    endwhile
EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)
    int loc_i = 0
    while loc_i < _Exports_Ids.length
        if (aiOption == _Exports_Ids[loc_i] && GetJsonValue(_Exports[loc_i],"mcm.type","num") == "num")
            String  loc_config  = GetJsonValue(_Exports[loc_i],"config","")
            Float   loc_mult    = GetJsonValue(_Exports[loc_i],"mcm.mult","1.0") as Float
            String  loc_format  = GetJsonValue(_Exports[loc_i],"mcm.format","{0}")
            Float   loc_newval  = (afValue/loc_mult)
            UD_Native.SetMinigameVariable(_MinigameConfigId,loc_config,loc_newval as String)
            SetSliderOptionValue(_Exports_Ids[loc_i], afValue, loc_format)
            return
        endif
        loc_i += 1
    endwhile
EndFunction

Function PageOptionMenuOpen(int aiOption)
    if (aiOption == _Minigames_M)
        SetMenuDialogOptions(_Minigames_List)
        SetMenuDialogStartIndex(_Minigames_Id)
        SetMenuDialogDefaultIndex(0)
    endif
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
    if (aiOption == _Minigames_M)
        _Minigames_Id = aiIndex
        SetMenuOptionValue(_Minigames_M, _Minigames_List[_Minigames_Id])
        forcePageReset()
    endIf
EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int aiOption)
    int loc_i = 0
    while loc_i < _Exports_Ids.length
        if (aiOption == _Exports_Ids[loc_i])
            String  loc_desc  = GetJsonValue(_Exports[loc_i],"description","")
            if loc_desc
                setinfotext(loc_desc)
            endif
            return
        endif
        loc_i += 1
    endwhile
EndFunction