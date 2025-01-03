;/  File: UD_ModOutcome_LockDevice
    Summons more devices

    NameFull: Equip Device

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         (optional) Number of devices
                            Default value: 1
                        
        [+1]    String      (optional) Selection method (in general or for the devices in list Form2)
                                LIB or L        - random device selected by function UDCDmain::ManifestDevices()
                                FIRST or F      - first suitable device from the list
                                RANDOM or R     - random device from the list
                            Default value: L
                        
        [+2]    String      (optional) Selection method for the devices in list Form3

    Form arguments:
        Form2               Single device to manifest or FormList with devices.
        
        Form3               Single device to manifest or FormList with devices.

    Example:
        1,L         Method UDCDmain::ManifestDevices will be called with given number of devices to lock
        1,FIRST     One device will be summoned. The first suitable device from the list in Form2 will be selected, 
                    starting from the top one.
        5,F,R       Five devices ill be summoned. First the matching devices will be selected from the list in Form2, and 
                    then the remaining number will be selected randomly from the list in Form3.
/;
Scriptname UD_ModOutcome_LockDevice extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

Explosion Property ManifestExplosion Auto

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    Int loc_remain = loc_count
    String loc_method_list2 = GetStringParamString(aiDataStr, DataStrOffset + 1, "L")
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")
    String loc_method = loc_method_list2
    
    If loc_method_list2 == "L" || loc_method_list2 == "LIB"
        UDCDmain.ManifestDevices(akDevice.GetWearer(), akDevice.getDeviceName(), 100, loc_count)
        Return
    EndIf
    
    Form[] loc_forms
    Int loc_i
    Int loc_n

    If (akForm2 as FormList) != None
        loc_n = (akForm2 as FormList).GetSize()
        loc_i = 0
        While loc_i < loc_n
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm2 as FormList).GetAt(loc_i))
            loc_i += 1
        EndWhile
    ElseIf akForm2 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm2)
    EndIf

    If loc_method_list3 != ""
        loc_remain -= UDCDmain.ManifestDevicesFromArray(akDevice.GetWearer(), akDevice.getDeviceName(), loc_forms, loc_method == "R" || loc_method == "RANDOM", loc_remain)
        loc_forms = PapyrusUtil.ResizeFormArray(loc_forms, 0)
        loc_method = loc_method_list3
    EndIf
    
    If (akForm3 as FormList) != None
        loc_n = (akForm3 as FormList).GetSize()
        loc_i = 0
        While loc_i < loc_n
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm3 as FormList).GetAt(loc_i))
            loc_i += 1
        EndWhile
    ElseIf akForm3 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm3)
    EndIf
    
    loc_remain -= UDCDmain.ManifestDevicesFromArray(akDevice.GetWearer(), akDevice.getDeviceName(), loc_forms, loc_method == "R" || loc_method == "RANDOM", loc_remain)
    
    If loc_remain < loc_count && ManifestExplosion != None
        akDevice.GetWearer().PlaceAtMe(ManifestExplosion)
    EndIf
    
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_res = ""
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list2 = GetStringParamString(aiDataStr, DataStrOffset + 1, "L")
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")

    loc_res += UDmain.UDMTF.TableRowDetails("Number of devices:", loc_count)
    If loc_method_list2 != "" || akForm2
        loc_res += akModifier.PrintFormListSelectionDetails(akForm2, loc_method_list2)
    EndIf
    If akForm3
        loc_res += akModifier.PrintFormListSelectionDetails(akForm3, loc_method_list3)
    EndIf
    Return loc_res
EndFunction