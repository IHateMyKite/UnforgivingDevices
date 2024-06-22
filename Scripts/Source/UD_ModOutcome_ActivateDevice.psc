;/  File: UD_ModOutcome_ActivateDevice
    Activates devices

    NameFull: Activate

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     (optional) Number of devices
                        Default value: 1
                        
        [+1]    String  (optional) Selection method (in general or for the devices in list akForm3)
                            SELF or S       - self        
                            FIRST or F      - first suitable device from the list (akForm3, akForm4 concatenated together)
                            RANDOM or R     - random device from the list (akForm3, akForm4 concatenated together)
                        Default value: R
                       
        [+2]    String  (optional) Selection method for the devices in list akForm4

    Form arguments:
        Form3 - Single device keyword to activate or FormList with keywords.
        Form4 - Single device keyword to activate or FormList with keywords.

    Example:
        1,FIRST     One device will be activated. The first suitable device from the list in Form3 will be selected by its keyword, 
                    starting from the top one.
        5,F,R       Five devices will be activated. First the matching devices will be selected from the list in Form3, and 
                    then the remaining number will be selected randomly from the list in Form4.
/;
Scriptname UD_ModOutcome_ActivateDevice extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

Explosion Property ManifestExplosion Auto

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_ActivateDevice::Outcome() akDevice = " + akDevice + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R")
    String loc_method_list4 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")

    Form[] loc_devices = GetEquippedDevicesWithSelectionMethod(akDevice, loc_count, akForm3, loc_method_list3, akForm4, loc_method_list4)

    Int loc_i = 0
    While loc_i < loc_devices.Length
        (loc_devices[loc_i] as UD_CustomDevice_RenderScript).activateDevice()
        loc_i += 1
    EndWhile

EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)
    String loc_str = ""
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R") 
    loc_str += "Activates Device(s)"
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
