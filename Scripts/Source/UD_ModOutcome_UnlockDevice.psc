;/  File: UD_ModOutcome_UnlockDevice
    Unlocks device(s)

    NameFull: Unlock Device

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         (optional) Number of positions (devices with suitable keywords) to remove
                            Default value: 1
                        
        [+1]    String      (optional) Selection method (in general or for the keyword in list akForm4)
                                SELF or S       - removes self
                                FIRST or F      - first suitable keyword from the list
                                RANDOM or R     - random keyword from the list
                            Default value: SELF
                        
        [+2]    String      (optional) Selection method for the keywords in list akForm5

    Form arguments:
        Form4               Single device keyword to remove or FormList with keywords.
        
        Form5               Single device keyword to remove or FormList with keywords.

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)    
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

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
    String loc_res = ""
    String loc_frag = ""
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list4 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R")
    String loc_method_list5 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")

    If loc_method_list4 == "S" || loc_method_list4 == "SELF"
        loc_frag = "SELF"
    ElseIf loc_method_list4 == "A" || loc_method_list4 == "ALL"
        loc_frag = "ALL"
    Else
        loc_frag = loc_count As String
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Number of devices:", loc_frag)
    
    If loc_method_list4 != "" && akForm4
        loc_res += akModifier.PrintFormListSelectionDetails(akForm4, loc_method_list4)
    EndIf
    If loc_method_list5 != "" && akForm5
        loc_res += akModifier.PrintFormListSelectionDetails(akForm5, loc_method_list5)
    EndIf
    Return loc_res
EndFunction
