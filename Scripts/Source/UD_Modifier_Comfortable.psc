;/  File: UD_Modifier_Comfortable
    This device is extremely comfortable. You almost don't want to take it off.

    NameFull:   Comfortable
    NameAlias:  COMF

    Parameters:
        [0]     Int         How comfortable is this device (0 - 100) in the mean of GetAiPriority()
                            Default value: 25
/;
ScriptName UD_Modifier_Comfortable extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

; TODO PR195: Implement valid effects for the player to keep it on

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Comfort:", GetStringParamInt(aiDataStr, 0, 0))
    Return loc_res
EndFunction
