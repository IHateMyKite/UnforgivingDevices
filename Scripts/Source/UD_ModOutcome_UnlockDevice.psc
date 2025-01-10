;/  File: UD_ModOutcome_UnlockDevice
    Unlocks device(s)

    NameFull: Unlock Device

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         (optional) Number of positions (devices with suitable keywords) to remove
                            Default value: 1
                        
        [+1]    String      (optional) Selection method (in general or for the keyword in list akForm2)
                                SELF or S       - removes self
                                FIRST or F      - first suitable keyword from the list
                                RANDOM or R     - random keyword from the list
                            Default value: SELF
                        
        [+2]    String      (optional) Selection method for the keywords in list akForm3

    Form arguments:
        Form2               Single device keyword to remove or FormList with keywords.
        
        Form3               Single device keyword to remove or FormList with keywords.

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list2 = GetStringParamString(aiDataStr, DataStrOffset + 1, "S")
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")

    UD_CustomDevice_RenderScript[] loc_devices = GetEquippedDevicesWithSelectionMethod(akDevice, loc_count, akForm2, loc_method_list2, akForm3, loc_method_list3)

    if !loc_devices
        return
    endif
    
    Int loc_i = 0
    While loc_i < loc_devices.Length
        If loc_devices[loc_i]
            loc_devices[loc_i].unlockRestrain()
        EndIf
        loc_i += 1
    EndWhile
    
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_res = ""
    String loc_frag = ""
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list2 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R")
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")

    If loc_method_list2 == "S" || loc_method_list2 == "SELF"
        loc_frag = "SELF"
    ElseIf loc_method_list2 == "A" || loc_method_list2 == "ALL"
        loc_frag = "ALL"
    Else
        loc_frag = loc_count As String
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Number of devices:", loc_frag)
    
    If loc_method_list2 != "" || akForm2
        loc_res += akModifier.PrintFormListSelectionDetails(akForm2, loc_method_list2)
    EndIf
    If loc_method_list3 != "" || akForm3
        loc_res += akModifier.PrintFormListSelectionDetails(akForm3, loc_method_list3)
    EndIf
    Return loc_res
EndFunction
