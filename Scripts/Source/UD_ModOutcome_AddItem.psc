;/  File: UD_ModOutcome_AddItem
    Adds item(s) to wearer inventory
    
    NameFull: Add Item

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         (optional) Minimum number of items
                            Default value: 1
                        
        [+1]    Int         (optional) Maximum number of items
                            Default value: [+0]
                        
        [+2]    Int         (optional) Equip item (i.e. drink potion)
                            Default value: 0 (False)

    Form arguments:
        Form4               Single item to add or FormList with items.
        
        Form5               Single item to add or FormList with items.

    Example:
        DataStr = 1         
        DataForm4 = <Lockpick>          Adds 1 lockpick to inventory

        DataStr = 0,0,1         
        DataForm4 = <Health Potion>     Force to drink health potion from inventory
/;
Scriptname UD_ModOutcome_AddItem extends UD_ModOutcome

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
        Bool loc_use = GetStringParamInt(aiDataStr, DataStrOffset + 2, 0) > 0
        Actor loc_wearer = akDevice.GetWearer()
        Int loc_count = RandomInt(loc_min, loc_max)
        
        If loc_count == 0 && loc_wearer.GetItemCount(loc_item) == 0
        ; can't use absent item
            loc_use = False
        EndIf
        
        If (loc_item As LeveledItem) != None && loc_use
            loc_wearer.EquipItem(loc_item)
        Else
            loc_wearer.AddItem(loc_item, loc_count)
            If loc_use
                loc_wearer.EquipItem(loc_item)
            EndIf
        EndIf
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