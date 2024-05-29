;/  File: UD_Modifier_HEV
    The device evolves after a certain period of time

    NameFull: 
    NameAlias: *EV

    Parameters:
        [0]         (optional) Amount of something required to evolve
                    Default value: 6.0

    Form arguments:
        Form1 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form2 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form3 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
    In case more then one FormX is filled, random one will be choosen

    Example:

/;
ScriptName UD_Modifier_HEV extends UD_Modifier_Evolution

import UnforgivingDevicesMain
import UD_Native

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    Float loc_hours = GetStringParamFloat(aiDataStr, 0, 6.0) - 1.0 * afMult
    If loc_hours <= 0
        Evolve(akDevice, akForm1, akForm2, akForm3)
    Else 
        akDevice.editStringModifier(NameAlias, 0, FormatFloat(loc_hours, 2))
    EndIf
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Hours left before device evolves: " + FormatFloat(GetStringParamFloat(aiDataStr, 0), 2) + "\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction
