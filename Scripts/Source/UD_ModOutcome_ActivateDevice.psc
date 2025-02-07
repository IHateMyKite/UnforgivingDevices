;/  File: UD_ModOutcome_ActivateDevice
    Activates devices

    NameFull: Activate

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         (optional) Number of devices
                            Default value: 1
                        
        [+1]    String      (optional) Selection method (in general or for the devices in list akForm2)
                                SELF or S       - self        
                                FIRST or F      - first suitable device from the list (akForm2, akForm3 concatenated together)
                                RANDOM or R     - random device from the list (akForm2, akForm3 concatenated together)
                            Default value: R
                       
        [+2]    String      (optional) Selection method for the devices in list akForm3

    Form arguments:
        Form2               Single device keyword to activate or FormList with keywords.
        
        Form3               Single device keyword to activate or FormList with keywords.

    Example:
        ,,,,,,,1,FIRST      One device will be activated. The first suitable device from the list in Form4 will be selected by its keyword, 
                            starting from the top one.
        ,,,,,,,5,F,R        Five devices will be activated. First the matching devices will be selected from the list in Form4, and 
                            then the remaining number will be selected randomly from the list in Form5.
/;
Scriptname UD_ModOutcome_ActivateDevice extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

Explosion Property ManifestExplosion Auto

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Int loc_count = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 0, 1), akModifier.MultOutputQuantities)
    String loc_method_list2 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R")
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")

    UD_CustomDevice_RenderScript[] loc_devices = GetEquippedDevicesWithSelectionMethod(akDevice, loc_count, akForm2, loc_method_list2, akForm3, loc_method_list3)

    Int loc_i = 0
    While loc_i < loc_devices.Length
        If loc_devices[loc_i]
            loc_devices[loc_i].activateDevice()
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
    Int loc_count = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 0, 1), akModifier.MultOutputQuantities)
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
    If akForm3
        loc_res += akModifier.PrintFormListSelectionDetails(akForm3, loc_method_list3)
    EndIf
    Return loc_res
EndFunction
