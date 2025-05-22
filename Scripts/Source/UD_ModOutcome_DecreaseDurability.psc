;/  File: UD_ModOutcome_DecreaseDurability
    Decreases durability of the device(s)

    NameFull: Decrease Durability

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         (optional) Number of positions (devices with suitable keywords) to corrode
                            Default value: 1
                        
        [+1]    String      (optional) Selection method (in general or for the keyword in list akForm4)
                                SELF or S       - decrease its own durability
                                ALL or A        - decrease the durability of all devices
                                FIRST or F      - first suitable keyword from the list (akForm2, akForm3 concatenated together)
                                RANDOM or R     - random keyword from the list (akForm2, akForm3 concatenated together)
                            Default value: SELF
                        
        [+2]    Float       Minimum amount (positive number) to decrease in %
        
        [+3]    Float       (optional) Maximum amount (positive number) to decrease in %
                            Default value: [+2]

    Form arguments:
        Form2               Single device keyword to corrode or FormList with keywords (may be None if SELF or ALL selection method is used).
        
        Form3               Single device keyword to corrode or FormList with keywords (may be None if SELF or ALL selection method is used).

    Example:
        
/;
Scriptname UD_ModOutcome_DecreaseDurability extends UD_ModOutcome

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
    Float loc_min = MultFloat(GetStringParamFloat(aiDataStr, DataStrOffset + 2), akModifier.MultOutputQuantities)
    Float loc_max = MultFloat(GetStringParamFloat(aiDataStr, DataStrOffset + 3, loc_min), akModifier.MultOutputQuantities)

    UD_CustomDevice_RenderScript[] loc_devices = GetEquippedDevicesWithSelectionMethod(akDevice, loc_count, akForm2, loc_method_list2, akForm3, "")

    If loc_devices.Length > 0
        If RandomFloat(0.0, 100.0) < 50.0
            PrintNotification(akDevice, ;/changed/; "and weakened some of your devices a little bit.")
        EndIf
    EndIf

    Int loc_i = 0
    While loc_i < loc_devices.Length
        If loc_devices[loc_i]
            corrodeDevice(loc_devices[loc_i], RandomFloat(loc_min, loc_max), 1.0, 1.0)
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
    String loc_method_list2 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R")
    Float loc_min = MultFloat(GetStringParamFloat(aiDataStr, DataStrOffset + 2), akModifier.MultOutputQuantities)
    Float loc_max = MultFloat(GetStringParamFloat(aiDataStr, DataStrOffset + 3, loc_min), akModifier.MultOutputQuantities)
    If loc_method_list2 == "S"
        loc_frag = "SELF"
    ElseIf loc_method_list2 == "A"
        loc_frag = "ALL"
    Else
        loc_frag = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Number of devices:", loc_frag)
    If loc_method_list2 != "" || akForm2
        loc_res += akModifier.PrintFormListSelectionDetails(akForm2, loc_method_list2)
    EndIf
    If akForm3
        loc_res += akModifier.PrintFormListSelectionDetails(akForm3, "")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Magnitude:", FormatFloat(loc_min, 1) + " - " + FormatFloat(loc_max, 1) + "%")
    Return loc_res
EndFunction

;/  Group: Protected methods
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function corrodeDevice(UD_CustomDevice_RenderScript akDevice, Float afStrength, float afMult = 1.0, float afTimePassed = 1.0)
    Float   loc_regen   = afStrength
    Float   loc_amount  = afTimePassed*loc_regen*(1 - 0.1*akDevice.UD_condition)*afMult*UDCDmain.getStruggleDifficultyModifier()
    akDevice.decreaseDurabilityAndCheckUnlock(loc_amount)
EndFunction