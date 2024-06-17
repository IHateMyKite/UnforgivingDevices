;/  File: UD_ModOutcome_RemoveDevice
    Removes device(s)

    NameFull: Remove Device

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     (optional) Number of positions (devices with suitable keywords) to remove
                        Default value: 1
                        
        [+1]    String  (optional) Selection method (in general or for the keyword in list akForm1)
                            SELF or S       - removes self
                            FIRST or F      - first suitable keyword from the list (akForm1, akForm2, akForm3 concatenated together)
                            RANDOM or R     - random keyword from the list (akForm1, akForm2, akForm3 concatenated together)
                        Default value: SELF
                        
        [+2]    String  (optional) Selection method for the keywords in list akForm2
        
        [+3]    String  (optional) Selection method for the keywords in list akForm3

    Form arguments:
        Form1 - Single device keyword to remove or FormList with keywords.
        Form2 - Single device keyword to remove or FormList with keyword.
        Form3 - Single device keyword to remove or FormList with keywords.

    Example:
/;
Scriptname UD_ModOutcome_RemoveDevice extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)    
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_RemoveDevice::Outcome() akDevice = " + akDevice + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list1 = GetStringParamString(aiDataStr, DataStrOffset + 1, "S")
    String loc_method_list2 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 3, "")

    Form[] loc_devices = GetEquippedDevicesWithSelectionMethod(akDevice, loc_count, akForm1, loc_method_list1, akForm2, loc_method_list2, akForm3, loc_method_list3)

    Int loc_i = 0
    While loc_i < loc_devices.Length
        (loc_devices[loc_i] as UD_CustomDevice_RenderScript).unlockRestrain()
        loc_i += 1
    EndWhile
    
EndFunction
