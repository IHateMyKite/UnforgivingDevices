;/  File: UD_ModOutcome_AddItem
    Summons item

    NameFull:   
    NameAlias:  AIT

    Parameters in DataStr:
        [5]     Int     (optional) Number of items
                        Default value: 1
        [6]     Int     (optional) Equip item (i.e. drink potion)
                        Default value: 0 (False)

    Form arguments:
        Form1 - Single item to add or FormList with items.
        Form2 - Single item to add or FormList with items.
        Form3 - Single item to add or FormList with items.

    Example:
/;
Scriptname UD_ModOutcome_AddItem extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)

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
    
    If (akForm2 as FormList) != None
        loc_i = (akForm2 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm2 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm2 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm2)
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
        
    if loc_forms.Length > 0
        Int loc_size = loc_forms.length
        Form loc_item = loc_forms[RandomInt(0, loc_size - 1)]
        Int loc_count = GetStringParamInt(aiDataStr, 5, 1)
        Bool loc_use = GetStringParamInt(aiDataStr, 6, 0) > 0
        akDevice.GetWearer().AddItem(loc_item, loc_count)
        If loc_use
            akDevice.GetWearer().EquipItem(loc_item)
        EndIf
    endif
    
EndFunction
