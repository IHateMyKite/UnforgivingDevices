;/  File: UD_ModOutcome_RemoveDevice
    Removes device(s)

    NameFull:   
    NameAlias:  RDD

    Parameters in DataStr:
        [5]     Int     (optional) Number of positions (devices with suitable keywords) to remove
                        Default value: 1
                        
        [6]     String  (optional) Selection method (in general or for the keyword in list akForm1)
                            SELF or S       - removes self
                            FIRST or F      - first suitable keyword from the list (akForm1, akForm2, akForm3 concatenated together)
                            RANDOM or R     - random keyword from the list (akForm1, akForm2, akForm3 concatenated together)
                        Default value: SELF
                        
        [7]     String  (optional) Selection method for the keywords in list akForm2
        
        [8]     String  (optional) Selection method for the keywords in list akForm3

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
    
    Int loc_count = GetStringParamInt(aiDataStr, 5, 1)
    Int loc_remain = loc_count
    String loc_method_list1 = GetStringParamString(aiDataStr, 6, "S")
    String loc_method_list2 = GetStringParamString(aiDataStr, 7, "")
    String loc_method_list3 = GetStringParamString(aiDataStr, 8, "")

    If loc_method_list1 == "S" || loc_method_list1 == "SELF"
        akDevice.unlockRestrain()
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
                    loc_device.unlockRestrain()
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
                    loc_device.unlockRestrain()
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
                loc_device.unlockRestrain()
                loc_remain -= 1
            EndIf
        EndIf
    EndWhile
    
EndFunction
