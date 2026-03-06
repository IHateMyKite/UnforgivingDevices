Scriptname UD_MCM_Page extends ReferenceAlias

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty

UD_MCM_Script _udmcm
UD_MCM_Script Property MCM Hidden
    UD_MCM_Script Function Get()
        if !_udmcm
            _udmcm = UD_Native.GetModuleByAlias("mcm") as UD_MCM_Script
        endif
        return _udmcm
    EndFunction
EndProperty

Int Property OPTION_FLAG_DISABLED Hidden
    Int Function Get()
        return MCM.OPTION_FLAG_DISABLED
    EndFunction
EndProperty
Int Property OPTION_FLAG_NONE Hidden
    Int Function Get()
        return MCM.OPTION_FLAG_NONE
    EndFunction
EndProperty
Int Property LEFT_TO_RIGHT Hidden
    Int Function Get()
        return MCM.LEFT_TO_RIGHT
    EndFunction
EndProperty
Int Property TOP_TO_BOTTOM Hidden
    Int Function Get()
        return MCM.TOP_TO_BOTTOM
    EndFunction
EndProperty

import UnforgivingDevicesMain
import UD_Native

String Property PageName = "" auto
Int    Property PagePriority = 0 auto

; Init of the page variables. Is done on every reload
Function PageInit()
EndFunction
Function PageUpdate()
EndFunction
Function PageReset(Bool abLockMenu)
EndFunction

Function PageOptionSelect(Int aiOption)
EndFunction

Function PageOptionSliderOpen(Int aiOption)
EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)
EndFunction

Function PageOptionKeyMapChange(Int aiOption, Int aiKeyCode, String asConflictControl, String asConflictName)
EndFunction

Function PageOptionInputOpen(int aiOption)
EndFunction
Function PageOptionInputAccept(Int aiOption, String asValue)
EndFunction

Function PageOptionMenuOpen(int aiOption)
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
EndFunction

Function PageDefault(int aiOption)
EndFunction
Function PageInfo(int aiOption)
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

function closeMCM()
    MCM.closeMCM()
endfunction

String Function InstallSwitch(Bool abSwitch)
    if abSwitch
        return "$INSTALLED"
    else
        return "$NOT INSTALLED"
    endif
EndFunction

function forcepagereset()
    MCM.forcepagereset()
endfunction
function setinfotext(string a_text)
    MCM.setinfotext(a_text)
endfunction
function setcursorposition(int a_position)
    MCM.setcursorposition(a_position)
endfunction
function setcursorfillmode(int a_fillmode)
    MCM.setcursorfillmode(a_fillmode)
endfunction
int function addemptyoption()
    return MCM.addemptyoption()
endfunction
int function addheaderoption(string a_text, int a_flags = 0)
    return MCM.addheaderoption(a_text,a_flags)
endfunction
int function addtextoption(string a_text, string a_value, int a_flags = 0)
    return MCM.addtextoption(a_text,a_value,a_flags)
endfunction
int function addtoggleoption(string a_text, bool a_checked, int a_flags = 0)
    return MCM.addtoggleoption(a_text,a_checked,a_flags)
endfunction
int function addslideroption(string a_text, float a_value, string a_formatstring = "{0}", int a_flags = 0)
    return MCM.addslideroption(a_text,a_value,a_formatstring,a_flags)
endfunction
int function addmenuoption(string a_text, string a_value, int a_flags = 0)
    return MCM.addmenuoption(a_text,a_value,a_flags)
endfunction
int function addcoloroption(string a_text, int a_color, int a_flags = 0)
    return MCM.addcoloroption(a_text,a_color,a_flags)
endfunction
int function addkeymapoption(string a_text, int a_keycode, int a_flags = 0)
    return MCM.addkeymapoption(a_text,a_keycode,a_flags)
endfunction
int function addinputoption(string a_text, string a_value, int a_flags = 0)
    return MCM.addinputoption(a_text,a_value,a_flags)
endfunction
function addtextoptionst(string a_statename, string a_text, string a_value, int a_flags = 0)
    MCM.addtextoptionst(a_statename,a_text,a_value,a_flags)
endfunction
function addtoggleoptionst(string a_statename, string a_text, bool a_checked, int a_flags = 0)
    MCM.addtoggleoptionst(a_statename,a_text,a_checked,a_flags)
endfunction
function addslideroptionst(string a_statename, string a_text, float a_value, string a_formatstring = "{0}", int a_flags = 0)
    MCM.addslideroptionst(a_statename,a_text,a_value,a_formatstring,a_flags)
endfunction
function addmenuoptionst(string a_statename, string a_text, string a_value, int a_flags = 0)
    MCM.addmenuoptionst(a_statename,a_text,a_value,a_flags)
endfunction
function addcoloroptionst(string a_statename, string a_text, int a_color, int a_flags = 0)
    MCM.addcoloroptionst(a_statename,a_text,a_color,a_flags)
endfunction
function addkeymapoptionst(string a_statename, string a_text, int a_keycode, int a_flags = 0)
    MCM.addkeymapoptionst(a_statename,a_text,a_keycode,a_flags)
endfunction
function addinputoptionst(string a_statename, string a_text, string a_value, int a_flags = 0)
    MCM.addinputoptionst(a_statename,a_text,a_value,a_flags)
endfunction
function loadcustomcontent(string a_source, float a_x = 0.0, float a_y = 0.0)
    MCM.loadcustomcontent(a_source,a_x,a_y)
endfunction
function unloadcustomcontent()
    MCM.unloadcustomcontent()
endfunction
function setoptionflags(int a_option, int a_flags, bool a_noupdate = false)
    MCM.setoptionflags(a_option,a_flags,a_noupdate)
endfunction
function settextoptionvalue(int a_option, string a_value, bool a_noupdate = false)
    MCM.settextoptionvalue(a_option,a_value,a_noupdate)
endfunction
function settoggleoptionvalue(int a_option, bool a_checked, bool a_noupdate = false)
    MCM.settoggleoptionvalue(a_option,a_checked,a_noupdate)
endfunction
function setslideroptionvalue(int a_option, float a_value, string a_formatstring = "{0}", bool a_noupdate = false)
    MCM.setslideroptionvalue(a_option,a_value,a_formatstring,a_noupdate)
endfunction
function setmenuoptionvalue(int a_option, string a_value, bool a_noupdate = false)
    MCM.setmenuoptionvalue(a_option,a_value,a_noupdate)
endfunction
function setcoloroptionvalue(int a_option, int a_color, bool a_noupdate = false)
    MCM.setcoloroptionvalue(a_option,a_color,a_noupdate)
endfunction
function setkeymapoptionvalue(int a_option, int a_keycode, bool a_noupdate = false)
    MCM.setkeymapoptionvalue(a_option,a_keycode,a_noupdate)
endfunction
function setinputoptionvalue(int a_option, string a_value, bool a_noupdate = false)
    MCM.setinputoptionvalue(a_option,a_value,a_noupdate)
endfunction
function setoptionflagsst(int a_flags, bool a_noupdate = false, string a_statename = "")
    MCM.setoptionflagsst(a_flags,a_noupdate,a_statename)
endfunction
function settextoptionvaluest(string a_value, bool a_noupdate = false, string a_statename = "")
    MCM.settextoptionvaluest(a_value,a_noupdate,a_statename)
endfunction
function settoggleoptionvaluest(bool a_checked, bool a_noupdate = false, string a_statename = "")
    MCM.settoggleoptionvaluest(a_checked,a_noupdate,a_statename)
endfunction
function setslideroptionvaluest(float a_value, string a_formatstring = "{0}", bool a_noupdate = false, string a_statename = "")
    MCM.setslideroptionvaluest(a_value,a_formatstring,a_noupdate,a_statename)
endfunction
function setmenuoptionvaluest(string a_value, bool a_noupdate = false, string a_statename = "")
    MCM.setmenuoptionvaluest(a_value,a_noupdate,a_statename)
endfunction
function setcoloroptionvaluest(int a_color, bool a_noupdate = false, string a_statename = "")
    MCM.setcoloroptionvaluest(a_color,a_noupdate,a_statename)
endfunction
function setkeymapoptionvaluest(int a_keycode, bool a_noupdate = false, string a_statename = "")
    MCM.setkeymapoptionvaluest(a_keycode,a_noupdate,a_statename)
endfunction
function setinputoptionvaluest(string a_value, bool a_noupdate = false, string a_statename = "")
    MCM.setinputoptionvaluest(a_value,a_noupdate,a_statename)
endfunction
function setsliderdialogstartvalue(float a_value)
    MCM.setsliderdialogstartvalue(a_value)
endfunction
function setsliderdialogdefaultvalue(float a_value)
    MCM.setsliderdialogdefaultvalue(a_value)
endfunction
function setsliderdialogrange(float a_minvalue, float a_maxvalue)
    MCM.setsliderdialogrange(a_minvalue,a_maxvalue)
endfunction
function setsliderdialoginterval(float a_value)
    MCM.setsliderdialoginterval(a_value)
endfunction
function setmenudialogstartindex(int a_value)
    MCM.setmenudialogstartindex(a_value)
endfunction
function setmenudialogdefaultindex(int a_value)
    MCM.setmenudialogdefaultindex(a_value)
endfunction
function setmenudialogoptions(string[] a_options)
    MCM.setmenudialogoptions(a_options)
endfunction
function setcolordialogstartcolor(int a_color)
    MCM.setcolordialogstartcolor(a_color)
endfunction
function setcolordialogdefaultcolor(int a_color)
    MCM.setcolordialogdefaultcolor(a_color)
endfunction
function setinputdialogstarttext(string a_text)
    MCM.setinputdialogstarttext(a_text)
endfunction
bool function showmessage(string a_message, bool a_withcancel = true, string a_acceptlabel = "$accept", string a_cancellabel = "$cancel")
    return MCM.showmessage(a_message,a_withcancel,a_acceptlabel,a_cancellabel)
endfunction