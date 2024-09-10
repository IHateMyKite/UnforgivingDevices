;/  File: UD_Modifier_Sentient
    Device is sentient, and can activate other devices when in danger

    NameFull:   Sentient
    NameAlias:  SNT

    Parameters:
        [0]     Int     How sentient is this device (0 - 100)
                        Default value: 0
/;
ScriptName UD_Modifier_Sentient extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    EventProcessingMask = 0x00000000
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Power: " + GetStringParamInt(aiDataStr, 0, 0) + "\n"

    loc_msg += "\n"
    loc_msg += "=== Description ===\n"
    loc_msg += Description + "\n"

    Return loc_msg
EndFunction
