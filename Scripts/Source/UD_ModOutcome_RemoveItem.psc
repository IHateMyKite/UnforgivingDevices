;/  File: UD_ModOutcome_RemoveItem
    Removes item(s) from inventory

    NameFull: Remove Item

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         (optional) Minimum number of items
                            Default value: 1
                        
        [+1]    Int         (optional) Maximum number of items
                            Default value: [+0]

    Form arguments:
        Form4               Single item to remove or FormList with items.

        Form5               Single item to remove or FormList with items.

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)

    Form[] loc_forms = CombineForms(akForm4, akForm5)
        
    If loc_forms.Length > 0
        Form loc_item = loc_forms[RandomInt(0, loc_forms.Length - 1)]
        Int loc_min = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
        Int loc_max = GetStringParamInt(aiDataStr, DataStrOffset + 1, loc_min)
        
        akDevice.GetWearer().RemoveItem(loc_item, RandomInt(loc_min, loc_max))
    Endif
    
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
    String loc_res = ""
    Int loc_min = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    Int loc_max = GetStringParamInt(aiDataStr, DataStrOffset + 1, loc_min)

    loc_res += UDmain.UDMTF.TableRowDetails("Number of items:", loc_min + " - " + loc_max)
    If akForm4
        loc_res += akModifier.PrintFormListSelectionDetails(akForm4, "R")
    EndIf
    If akForm5
        loc_res += akModifier.PrintFormListSelectionDetails(akForm5, "R")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Instant use:", InlineIfStr(GetStringParamInt(aiDataStr, DataStrOffset + 2, 0) > 0, "True", "False"))
    Return loc_res
EndFunction