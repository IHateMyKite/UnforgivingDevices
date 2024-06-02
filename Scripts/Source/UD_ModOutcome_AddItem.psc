;/  File: UD_ModOutcome_AddItem
    Summons item

    NameFull:   
    NameAlias:  AIT

    Parameters in DataStr:
        [5]     Int     (optional) Minimum number of items
                        Default value: 1
                        
        [6]     Int     (optional) Maximum number of items
                        Default value: [5]
                        
        [7]     Int     (optional) Equip item (i.e. drink potion)
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

    Form[] loc_forms = CombineForms(akForm1, akForm2, akForm3)
        
    If loc_forms.Length > 0
        Form loc_item = loc_forms[RandomInt(0, loc_forms.Length - 1)]
        Int loc_min = GetStringParamInt(aiDataStr, 5, 1)
        Int loc_max = GetStringParamInt(aiDataStr, 6, loc_min)
        Bool loc_use = GetStringParamInt(aiDataStr, 7, 0) > 0
        
        If (loc_item As LeveledItem) != None && loc_use
            akDevice.GetWearer().EquipItem(loc_item)
        Else
            akDevice.GetWearer().AddItem(loc_item, RandomInt(loc_min, loc_max))
            If loc_use
                akDevice.GetWearer().EquipItem(loc_item)
            EndIf
        EndIf
    Endif
    
EndFunction
