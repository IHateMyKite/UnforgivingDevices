;/  File: UD_ModOutcome_RemoveItem
    Removes item(s) from inventory

    NameFull: Remove Item

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         (optional) Minimum number of items
                            Default value: 1
                        
        [+1]    Int         (optional) Maximum number of items
                            Default value: [+0]

    Form arguments:
        Form2               Single item to remove or FormList with items

        Form3               Single item to remove or FormList with items (a random item from the merged list will be removed)

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Form loc_item = UD_Modifier.GetRandomForm(akForm2, akForm3)
        
    If loc_item
        Int loc_min = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 0, 1), akModifier.MultOutputQuantities)
        Int loc_max = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 1, loc_min), akModifier.MultOutputQuantities)
        
        akDevice.GetWearer().RemoveItem(loc_item, RandomInt(loc_min, loc_max))
    Endif
    
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_res = ""
    Int loc_min = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 0, 1), akModifier.MultOutputQuantities)
    Int loc_max = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 1, loc_min), akModifier.MultOutputQuantities)

    loc_res += UDmain.UDMTF.TableRowDetails("Number of items:", loc_min + " - " + loc_max)
    If akForm2
        loc_res += akModifier.PrintFormListSelectionDetails(akForm2, "R")
    EndIf
    If akForm3
        loc_res += akModifier.PrintFormListSelectionDetails(akForm3, "R")
    EndIf
    Return loc_res
EndFunction