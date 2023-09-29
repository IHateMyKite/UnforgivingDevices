;   File: UD_Modifier
;   This is base scripts of all modifiers
Scriptname UD_Modifier extends ReferenceAlias

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty

UD_Libs _udlibs
UD_Libs Property UDlibs Hidden
    UD_Libs Function Get()
        if !_udlibs
            _udlibs = UDmain.UDlibs
        endif
        return _udlibs
    EndFunction
EndProperty

;name of modifier
String      Property NameFull               Auto

;string alias of modifier (MAO for example if full name if Manifest At Orgasm)
String      Property NameAlias              Auto

;description of modifier (shown when opening the info in menu)
String      Property Description            Auto

;multiplier of modifier
;can be changed with MCM to adjust modifier
Float       Property Multiplier     = 1.0   Auto

;event hooks
String[]    Property EventHooks             Auto
String[]    Property EventHooks_Callback    Auto

Event RegisterEvents()
    ;int i = EventHooks.length
    ;while i
    ;    RegisterForModEvent(EventHooks[i],EventHooks_Callback[i])
    ;endwhile
EndEvent

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

int Function getStringParamNum(string asDataStr) global
    string[] loc_params = getStringParamAll(asDataStr)
    if !loc_params
        return 0
    else
        return loc_params.length
    endif
EndFunction

String[] Function getStringParamAll(string asDataStr) global
    if asDataStr != ""
        return StringUtil.split(asDataStr,",")
    else
        return Utility.CreateStringArray(0)
    endif
EndFunction

Int Function getStringParamInt(string asDataStr,int aiIndex = 0,int aiDefaultValue = 0) global
    string[] loc_params = getStringParamAll(asDataStr)
    if !loc_params
        return aiDefaultValue
    elseif aiIndex > (loc_params.length - 1)
        return aiDefaultValue
    else
        return loc_params[aiIndex] as Int
    endif
EndFunction

Float Function getStringParamFloat(string asDataStr,int aiIndex = 0,Float afDefaultValue = 0.0) global
    string[] loc_params = getStringParamAll(asDataStr)
    if !loc_params
        return afDefaultValue
    elseif aiIndex > (loc_params.length - 1)
        return afDefaultValue
    else
        return loc_params[aiIndex] as Float
    endif
EndFunction