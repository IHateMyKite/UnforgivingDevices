;/  File: UD_Modifier_WEV
    Device will evolve when get hit by weapon

    NameFull: 
    NameAlias: *EV

    Parameters:
        [0]         (optional) Amount of something required to evolve
                    Default value: 1000

    Form arguments:
        Form1 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form2 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form3 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
    In case more then one FormX is filled, random one will be choosen

    Example:

/;
ScriptName UD_Modifier_WEV extends UD_Modifier_Evolution

import UnforgivingDevicesMain
import UD_Native

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_WEV::WeaponHit() akDevice = " + akDevice + ", akWeapon = " + akWeapon + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    Float loc_dmg = GetStringParamFloat(aiDataStr, 0, 1000.0) - iRange(akWeapon.GetBaseDamage(), 5, 100)
    If loc_dmg <= 0
        Evolve(akDevice, akForm1, akForm2, akForm3)
    Else 
        akDevice.editStringModifier(NameAlias, 0, FormatFloat(loc_dmg, 2))
    EndIf
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Device will evolve when get hit by weapons: " + FormatFloat(GetStringParamFloat(aiDataStr, 0), 0) + " damage left\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction
