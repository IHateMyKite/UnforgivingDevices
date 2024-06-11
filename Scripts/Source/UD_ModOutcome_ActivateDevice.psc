;/  File: UD_ModOutcome_ActivateDevice
    Activates devices

    NameFull: 

    Parameters in DataStr:
        [5]     Int     (optional) Number of devices
                        Default value: 1
                        
        [6]     String  (optional) Selection method (in general or for the devices in list akForm1)
                            SELF or S       - self        
                            FIRST or F      - first suitable device from the list (akForm1, akForm2, akForm3 concatenated together)
                            RANDOM or R     - random device from the list (akForm1, akForm2, akForm3 concatenated together)
                        Default value: R
                        
        [7]     String  (optional) Selection method for the devices in list akForm2
        
        [8]     String  (optional) Selection method for the devices in list akForm3

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
    Int loc_remain = loc_count
    String loc_method_list1 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R")
    String loc_method_list2 = GetStringParamString(aiDataStr, DataStrOffset + 2, "")
    String loc_method_list3 = GetStringParamString(aiDataStr, DataStrOffset + 3, "")

    If loc_method_list1 == "S" || loc_method_list1 == "SELF"
        akDevice.activateDevice()
        Return
    EndIf
        
    String loc_method = loc_method_list1
    
    Form[] loc_forms
    Form loc_kw
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
        While loc_forms.Length > 0 && loc_remain > 0
            If loc_method == "R" || loc_method == "RANDOM"
                loc_kw = loc_forms[RandomInt(0, loc_forms.Length - 1)]
            Else
                loc_kw = loc_forms[0]
            EndIf
            loc_forms = PapyrusUtil.RemoveForm(loc_forms, loc_kw)
            If loc_kw as Keyword != None
                UD_CustomDevice_RenderScript loc_device = UDCDmain.getFirstDeviceByKeyword(akDevice.GetWearer(), loc_kw as Keyword)
                If loc_device != None
                    loc_device.activateDevice()
                    loc_remain -= 1
                EndIf
            EndIf
        EndWhile
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
        While loc_forms.Length > 0 && loc_remain > 0
            If loc_method == "R" || loc_method == "RANDOM"
                loc_kw = loc_forms[RandomInt(0, loc_forms.Length - 1)]
            Else
                loc_kw = loc_forms[0]
            EndIf
            loc_forms = PapyrusUtil.RemoveForm(loc_forms, loc_kw)
            If loc_kw as Keyword != None
                UD_CustomDevice_RenderScript loc_device = UDCDmain.getFirstDeviceByKeyword(akDevice.GetWearer(), loc_kw as Keyword)
                If loc_device != None
                    loc_device.activateDevice()
                    loc_remain -= 1
                EndIf
            EndIf
        EndWhile
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

    While loc_forms.Length > 0 && loc_remain > 0
        If loc_method == "R" || loc_method == "RANDOM"
            loc_kw = loc_forms[RandomInt(0, loc_forms.Length - 1)]
        Else
            loc_kw = loc_forms[0]
        EndIf
        loc_forms = PapyrusUtil.RemoveForm(loc_forms, loc_kw)
        If loc_kw as Keyword != None
            UD_CustomDevice_RenderScript loc_device = UDCDmain.getFirstDeviceByKeyword(akDevice.GetWearer(), loc_kw as Keyword)
            If loc_device != None
                loc_device.activateDevice()
                loc_remain -= 1
            EndIf
        EndIf
    EndWhile
    
EndFunction
