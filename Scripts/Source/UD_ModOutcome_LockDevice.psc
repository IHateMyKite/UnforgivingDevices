;/  File: UD_ModOutcome_LockDevice
    Summons more devices

    NameFull: Equip Device

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     (optional) Number of devices
                        Default value: 1
                        
        [+1]    String  (optional) Selection method (in general or for the devices in list akForm4)
                            LIB or L        - random device by function UDCDmain::ManifestDevices()
                            FIRST or F      - first suitable device from the list (akForm4, akForm5 are concatenated together)
                            RANDOM or R     - random device from the list (akForm4, akForm5 are concatenated together)
                        Default value: L
                        
        [+2]    String  (optional) Selection method for the devices in list akForm4

    Form arguments:
        Form4 - Single device to manifest or FormList with devices.
        Form5 - Single device to manifest or FormList with devices.

    Example:
        1,L         Method UDCDmain::ManifestDevices will be called with given number of devices to lock
        1,FIRST     One device will be summoned. The first suitable device from the list in Form4 will be selected, 
                    starting from the top one.
        5,F,R       Five devices ill be summoned. First the matching devices will be selected from the list in Form4, and 
                    then the remaining number will be selected randomly from the list in Form5.
/;
Scriptname UD_ModOutcome_LockDevice extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

Explosion Property ManifestExplosion Auto

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_LockDevice::Outcome() akDevice = " + akDevice + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    Int loc_remain = loc_count
    String loc_method_list4 = GetStringParamString(aiDataStr, DataStrOffset + 1, "L")
    String loc_method_list5 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")
    String loc_method = loc_method_list4
    
    If loc_method_list4 == "L" || loc_method_list4 == "LIB"
        UDCDmain.ManifestDevices(akDevice.GetWearer(), akDevice.getDeviceName(), 100, loc_count)
        Return
    EndIf
    
    Form[] loc_forms
    Int loc_i

    If (akForm4 as FormList) != None
        loc_i = (akForm4 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm4 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm4 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm4)
    EndIf

    If loc_method_list5 != ""
        loc_remain -= UDCDmain.ManifestDevicesFromArray(akDevice.GetWearer(), akDevice.getDeviceName(), loc_forms, loc_method == "R" || loc_method == "RANDOM", loc_remain)
        loc_forms = PapyrusUtil.ResizeFormArray(loc_forms, 0)
        loc_method = loc_method_list5
    EndIf
    
    If (akForm5 as FormList) != None
        loc_i = (akForm5 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm5 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm5 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm5)
    EndIf
    
    loc_remain -= UDCDmain.ManifestDevicesFromArray(akDevice.GetWearer(), akDevice.getDeviceName(), loc_forms, loc_method == "R" || loc_method == "RANDOM", loc_remain)
    
    If loc_remain < loc_count && ManifestExplosion != None
        akDevice.GetWearer().PlaceAtMe(ManifestExplosion)
    EndIf
    
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    String loc_str = ""
    loc_str += "Equips device(s)"
    loc_str += "\n"
    loc_str += "Number of devices: " + GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    Return loc_str
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    String loc_res = ""
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list4 = GetStringParamString(aiDataStr, DataStrOffset + 1, "L")
    String loc_method_list5 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")

    loc_res += UDmain.UDMTF.TableRowDetails("Number of devices:", loc_count)
    If akForm4
        loc_res += PrintFormListSelectionDetails(akForm4, loc_method_list4)
    EndIf
    If akForm5
        loc_res += PrintFormListSelectionDetails(akForm5, loc_method_list5)
    EndIf
    Return loc_res
EndFunction