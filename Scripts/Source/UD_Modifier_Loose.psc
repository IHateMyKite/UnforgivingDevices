;/  File: UD_Modifier_Loose
    Device is loose, allowing to wearer to struggle from it even when they have tied hands

    NameFull:   Loose
    NameAlias:  LOS

    Parameters:
        [0]     Float       (optional) The accessibility of the device (0.0 - 1.0). Used to check accessibility in UD_CustomDevice_RenderScript::getAccesibility
                            Default value: 0.0
/;
ScriptName UD_Modifier_Loose extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Update()
    EventProcessingMask = 0x00000000
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Looseness:", iRange(Round(GetStringParamFloat(aiDataStr, 0, 0.0) * 100.0), 0, 100))
    Return loc_res
EndFunction
