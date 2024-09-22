;/  File: UD_ModOutcome_UnlockDevice
    Removes device(s)

    NameFull: Remove Device

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     (optional) Number of positions (devices with suitable keywords) to remove
                        Default value: 1
                        
        [+1]    String  (optional) Selection method (in general or for the keyword in list akForm3)
                            SELF or S       - removes self
                            FIRST or F      - first suitable keyword from the list (akForm3, akForm4 concatenated together)
                            RANDOM or R     - random keyword from the list (akForm3, akForm4 concatenated together)
                        Default value: SELF
                        
        [+2]    String  (optional) Selection method for the keywords in list akForm4

    Form arguments:
        Form4 - Single device keyword to remove or FormList with keywords.
        Form5 - Single device keyword to remove or FormList with keywords.

    Example:
/;
Scriptname UD_ModOutcome_UnlockDevice extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)    
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_UnlockDevice::Outcome() akDevice = " + akDevice + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list4 = GetStringParamString(aiDataStr, DataStrOffset + 1, "S")
    String loc_method_list5 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")

    Form[] loc_devices = GetEquippedDevicesWithSelectionMethod(akDevice, loc_count, akForm4, loc_method_list4, akForm5, loc_method_list5)

    Int loc_i = 0
    While loc_i < loc_devices.Length
        (loc_devices[loc_i] as UD_CustomDevice_RenderScript).unlockRestrain()
        loc_i += 1
    EndWhile
    
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    String loc_str = ""
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R") 
    loc_str += "Removes device(s)"
    loc_str += "\n"
    loc_str += "Number of devices: "
    If loc_method_list3 == "S"
        loc_str += "SELF"
    ElseIf loc_method_list3 == "A"
        loc_str += "ALL"
    Else
        loc_str += GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)   
    EndIf
    Return loc_str
EndFunction
