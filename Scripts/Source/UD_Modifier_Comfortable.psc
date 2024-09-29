;/  File: UD_Modifier_Comfortable
    This device is extremely convenient. You almost don't want to take it off.

    NameFull:   Comfortable
    NameAlias:  CMF

    Parameters:
        [0]     Int     How comfortable is this device (0 - 100) in the mean of GetAiPriority()
                        Default value: 25
/;
ScriptName UD_Modifier_Comfortable extends UD_Modifier

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

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Comfort: " + GetStringParamInt(aiDataStr, 0, 0) + "\n"

    loc_msg += "\n"
    loc_msg += "=== Description ===\n"
    loc_msg += Description + "\n"

    Return loc_msg
EndFunction
