;/  File: UD_Modifier_OEV
    The device evolves after a few orgasms

    NameFull: 
    NameAlias: *EV

    Parameters:
        [0]         (optional) Number of orgasms required to evolve
                    Default Value: 3

    Form arguments:
        Form1 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form2 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form3 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
    In case more then one FormX is filled, random one will be choosen

    Example:

/;
ScriptName UD_Modifier_OEV extends UD_Modifier_Evolution

import UnforgivingDevicesMain
import UD_Native

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    int loc_value = UD_Native.GetStringParamInt(aiDataStr, 0, 3) - 1
    if loc_value > 0
        akDevice.editStringModifier(NameAlias, 0, loc_value)
    else
        Evolve(akDevice, akForm1, akForm2, akForm3)
    endif
EndFunction

; Do not use for patched devices. Instead it have to be added manually
Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    return false
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Orgasms left before device evolves: " + GetStringParamInt(aiDataStr, 0, 3) + "\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction
