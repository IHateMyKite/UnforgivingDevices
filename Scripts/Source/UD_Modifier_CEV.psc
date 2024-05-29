;/  File: UD_Modifier_CEV
    When the durability of a device falls below a given threshold, it evolves

    NameFull: 
    NameAlias: *EV

    Parameters:
        [0]         (optional) When the durability of a device falls below a given threshold, it evolves
                    Default value: 3

    Form arguments:
        Form1 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form2 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form3 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
    In case more then one FormX is filled, random one will be choosen

    Example:

/;
ScriptName UD_Modifier_CEV extends UD_Modifier_Evolution

import UnforgivingDevicesMain
import UD_Native

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_CEV::ConditionLoss() akDevice = " + akDevice + ", aiCondition = " + aiCondition + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    Int loc_threshold = GetStringParamInt(aiDataStr, 0, 3)
    If aiCondition >= loc_threshold
        Evolve(akDevice, akForm1, akForm2, akForm3)
    EndIf
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Device evolves when reach condition: " + UDCDMain.GetConditionString(GetStringParamInt(aiDataStr, 0, 3)) + "\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction
