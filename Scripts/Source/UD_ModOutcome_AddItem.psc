;/  File: UD_ModOutcome_AddItem
    Summons item

    NameFull: Add Item

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     (optional) Minimum number of items
                        Default value: 1
                        
        [+1]    Int     (optional) Maximum number of items
                        Default value: [+0]
                        
        [+2]    Int     (optional) Equip item (i.e. drink potion)
                        Default value: 0 (False)

    Form arguments:
        Form5 - Single item to add or FormList with items.
        Form6 - Single item to add or FormList with items.

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)

    Form[] loc_forms = CombineForms(akForm4, akForm5)
        
    If loc_forms.Length > 0
        Form loc_item = loc_forms[RandomInt(0, loc_forms.Length - 1)]
        Int loc_min = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
        Int loc_max = GetStringParamInt(aiDataStr, DataStrOffset + 1, loc_min)
        Bool loc_use = GetStringParamInt(aiDataStr, DataStrOffset + 2, 0) > 0
        
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

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    String loc_str = ""
    Int loc_min = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    Int loc_max = GetStringParamInt(aiDataStr, DataStrOffset + 1, loc_min)
    Bool loc_use = GetStringParamInt(aiDataStr, DataStrOffset + 2, 0) > 0
    loc_str += "Gives item(s)"
    loc_str += "\n"
    loc_str += "Number of items: " + loc_min + " - " + loc_max
    loc_str += "\n"
    loc_str += "Source: " + akForm4 + ", " + akForm5
    loc_str += "\n"
    loc_str += "Instant use: "
    If loc_use
        loc_str += "True"
    Else
        loc_str += "False"
    EndIf
    
    Return loc_str
EndFunction