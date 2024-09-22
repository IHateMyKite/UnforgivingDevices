;/  File: UD_ModOutcome_RemoveItem
    Removes item(s) from inventory

    NameFull: Remove Item

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     (optional) Minimum number of items
                        Default value: 1
                        
        [+1]    Int     (optional) Maximum number of items
                        Default value: [+0]

    Form arguments:
        Form4 - Single item to remove or FormList with items.
        Form5 - Single item to remove or FormList with items.

    Example:
/;
Scriptname UD_ModOutcome_RemoveItem extends UD_ModOutcome

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
        
        akDevice.GetWearer().RemoveItem(loc_item, RandomInt(loc_min, loc_max))
    Endif
    
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    String loc_str = ""
    Int loc_min = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    Int loc_max = GetStringParamInt(aiDataStr, DataStrOffset + 1, loc_min)
    loc_str += "Removes item(s)"
    loc_str += "\n"
    loc_str += "Number of items: " + loc_min + " - " + loc_max
    loc_str += "\n"
    loc_str += "Items: " + akForm4 + ", " + akForm5
    
    Return loc_str
EndFunction
