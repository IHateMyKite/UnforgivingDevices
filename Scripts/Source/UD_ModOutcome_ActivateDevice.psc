;/  File: UD_ModOutcome_ActivateDevice
    Activates devices

    NameFull: Activate

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     (optional) Number of devices
                        Default value: 1
                        
        [+1]    String  (optional) Selection method (in general or for the devices in list akForm1)
                            SELF or S       - self        
                            FIRST or F      - first suitable device from the list (akForm1, akForm2, akForm3 concatenated together)
                            RANDOM or R     - random device from the list (akForm1, akForm2, akForm3 concatenated together)
                        Default value: R
                       
        [+2]    String  (optional) Selection method for the devices in list akForm2
        
        [+3]    String  (optional) Selection method for the devices in list akForm3

    Form arguments:
        Form1 - Single device keyword to activate or FormList with keywords.
        Form2 - Single device keyword to activate or FormList with keywords.
        Form3 - Single device keyword to activate or FormList with keywords.

    Example:
        1,FIRST     One device will be activated. The first suitable device from the list in Form1 will be selected by its keyword, 
                    starting from the top one.
        5,F,R       Five devices will be activated. First the matching devices will be selected from the list in Form1, and 
                    then the remaining number will be selected randomly from the list in Form2.
/;
Scriptname UD_ModOutcome_ActivateDevice extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

Explosion Property ManifestExplosion Auto

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_ActivateDevice::Outcome() akDevice = " + akDevice + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list1 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R")
    String loc_method_list2 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 3, "")

    Form[] loc_devices = GetEquippedDevicesWithSelectionMethod(akDevice, loc_count, akForm1, loc_method_list1, akForm2, loc_method_list2, akForm3, loc_method_list3)

    Int loc_i = 0
    While loc_i < loc_devices.Length
        (loc_devices[loc_i] as UD_CustomDevice_RenderScript).activateDevice()
        loc_i += 1
    EndWhile

EndFunction
