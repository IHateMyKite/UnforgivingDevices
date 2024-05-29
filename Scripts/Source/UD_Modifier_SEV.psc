;/  File: UD_Modifier_SEV
    Device will evolve when get hit by magic

    NameFull: 
    NameAlias: SEV

    Parameters:
        [0]         (optional) Mana cost of all spells that hit the wearer
                    Default value: 1000

    Form arguments:
        Form1 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form2 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form3 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
    In case more then one FormX is filled, random one will be choosen

    Example:

/;
ScriptName UD_Modifier_SEV extends UD_Modifier_Evolution

import UnforgivingDevicesMain
import UD_Native

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_SEV::SpellHit() akDevice = " + akDevice + ", akSpell = " + akSpell + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    Float loc_mana = GetStringParamFloat(aiDataStr, 0, 1000.0) - iRange(akSpell.GetMagickaCost(), 5, 100)
    If loc_mana <= 0
        Evolve(akDevice, akForm1, akForm2, akForm3)
    Else 
        akDevice.editStringModifier(NameAlias, 0, FormatFloat(loc_mana, 2))
    EndIf
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Device will evolve when get hit by magic: " + FormatFloat(GetStringParamFloat(aiDataStr, 0), 0) + " mana left\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction
