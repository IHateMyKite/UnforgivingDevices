;/  File: UD_Modifier_Disabler
    Disables some of the player controls. Probably not the best idea

    NameFull:   Disabler
    NameAlias:  DIS

    Parameters:
        [0]     Int     (optional) Disable fast travel
                        Default value: 0
        
        [1]     Int     (optional) Disable waiting
                        Default value: 0
/;
Scriptname UD_Modifier_Disabler extends UD_Modifier

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
Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    
EndFunction

String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "==== " + NameFull + " ====\n"
    loc_msg += "\n"
    
    if Description
        loc_msg += "=== Description ===" + "\n"
        loc_msg += Description
    endif
    Return loc_msg
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Disable fast travel:", UDmain.UDMTF.InlineIfString(GetStringParamInt(aiDataStr, 0, 0) != 0, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Disable waiting:", UDmain.UDMTF.InlineIfString(GetStringParamInt(aiDataStr, 1, 0) != 0, "True", "False"))
    Return loc_res
EndFunction