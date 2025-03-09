;/  File: UD_Modifier_Sentient
    Device is sentient, and can activate other devices when in danger

    NameFull:   Sentient
    NameAlias:  SNT

    Parameters in DataStr:
        [0]     Int         How sentient is this device (0 - 100)
                            Default value: 0
/;
ScriptName UD_Modifier_Sentient extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Power:", MultInt(GetStringParamInt(aiDataStr, 0, 0), MultOutputQuantities))
    Return loc_res
EndFunction