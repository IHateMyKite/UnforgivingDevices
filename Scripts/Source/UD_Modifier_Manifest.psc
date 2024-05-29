;/  File: UD_Modifier_Manifest
    Base abstract script for the modifiers with manifest outcome

    NameFull:   
    NameAlias:  *MA

    Parameters in DataStr:
        [0]     (optional) Base probability to summon devices
        [1]     (optional) Number of devices
                Default value: 1
        [2]     (optional) Selection method (in general or for the devices in list akForm1)
                    FIRST or F      - first suitable device from the list (akForm1, akForm2, akForm3 concatenated together)
                    RANDOM or R     - random device from the list (akForm1, akForm2, akForm3 concatenated together)
                Default value: R
        [3]     (optional) Selection method for the devices in list akForm2
        [4]     (optional) Selection method for the devices in list akForm3

    Form arguments:
        Form1 - Single device to manifest or FormList with devices.
        Form2 - Single device to manifest or FormList with devices.
        Form3 - Single device to manifest or FormList with devices.

    Example:
        10,1,FIRST      One device may be summoned with a 10% base probability. The first suitable device from the 
                        list in Form1 will be selected, starting from the top one.
        10,5,F,R        Five devices may be summoned with a 10% base probability. First the matching devices will be 
                        selected from the list in Form1, and then the remaining number will be selected randomly from the 
                        list in Form2.
/;
Scriptname UD_Modifier_Manifest extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Explosion Property ExplosionManifest Auto

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    ; check if another manifest modifier is already preset
    if akDevice.HasModifier("OMA") || akDevice.HasModifier("HMA") || akDevice.HasModifier("WMA") || akDevice.HasModifier("SMA") || akDevice.HasModifier("CMA")
        return false
    endif
EndFunction

Function Manifest(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_Manifest::Manifest() akDevice = " + akDevice + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    
    Int loc_count = GetStringParamInt(aiDataStr, 1, 1)
    Int loc_remain = loc_count
    String loc_method_list1 = GetStringParamString(aiDataStr, 2, "R")
    String loc_method_list2 = GetStringParamString(aiDataStr, 3, "")
    String loc_method_list3 = GetStringParamString(aiDataStr, 4, "")
    String loc_method = loc_method_list1
    
    Form[] loc_forms
    Int loc_i

    If (akForm1 as FormList) != None
        loc_i = (akForm1 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm1 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm1 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm1)
    EndIf

    If loc_method_list2 != ""
        loc_remain -= UDCDmain.ManifestDevicesFromArray(akDevice.GetWearer(), akDevice.getDeviceName(), loc_forms, loc_method == "R" || loc_method == "RANDOM", loc_remain)
        loc_forms = PapyrusUtil.ResizeFormArray(loc_forms, 0)
        loc_method = loc_method_list2
    EndIf
    
    If (akForm2 as FormList) != None
        loc_i = (akForm2 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm2 as FormList).GetAt(loc_i))
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
        loc_i = (akForm3 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm3 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm3 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm3)
    EndIf
    
    loc_remain -= UDCDmain.ManifestDevicesFromArray(akDevice.GetWearer(), akDevice.getDeviceName(), loc_forms, loc_method == "R" || loc_method == "RANDOM", loc_remain)
    
    If loc_remain < loc_count && ExplosionManifest != None
        akDevice.GetWearer().PlaceAtMe(ExplosionManifest)
    EndIf
    
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Base probability: " + FormatFloat(GetStringParamFloat(aiDataStr, 0), 2) + "%\n"
    loc_msg += "Devices: " + GetStringParamInt(aiDataStr, 1, 1) + "\n"
    
    loc_msg += "=== Description ===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction
