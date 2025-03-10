;/  File: UD_ModTrigger_ItemObtain
    It triggers with a given chance after actor obtains an item
    
    NameFull: On Obtain Item
    
    Parameters in DataStr:
        [0]     Int         (optional) Minimun number of items to trigger
                            Default value: 1
        
        [1]     Float       (optional) Base probability to trigger (in %)
                            Default value: 100.0%
        
        [2]     Float       (optional) Probability to trigger that is proportional to the accumulated value (number of obtained items)
                            Default value: 0.0%
                        
        [3]     Float       (optional) Reset period (in hours). If negative then it triggers once
                            Default value: -1.0 (It triggers once)
                        
        [4]     Int         (optional) Only stolen items count
                            Default value: 0 (False)
                        
        [5]     Int         (script) Number of obtained items so far
        
        [6]     Float       (script) Timestamp of the last trigger

    Form arguments:
        Form1               Form or FormList with Forms to filter obtained items. Keywords don't work
    
    Example:
        DataStr = 1,100,0,24,,,        
        Form1   = FoodSweetroll     It will be 100% triggered when wearer receives a Sweet Roll, 
                                    but not more than once every 24 hours
/;
Scriptname UD_ModTrigger_ItemObtain extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    UD_CustomDevice_NPCSlot loc_slot = akDevice.UD_WearerSlot
    loc_slot.RegisterItemEvent(akForm1)
    
    Float loc_timer = akDevice.GetGameTimeLockedTime()
    akDevice.editStringModifier(akModifier.NameAlias, 5, FormatFloat(loc_timer, 2))
    
    Return False
EndFunction

Bool Function DeviceUnlocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    UD_CustomDevice_NPCSlot loc_slot = akDevice.UD_WearerSlot
    loc_slot.UnregisterItemEvent(akForm1)
    
    Return False
EndFunction

Bool Function ItemAdded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akSourceContainer, Bool abIsStolen, String aiDataStr, Form akForm1)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_ItemObtain::ItemAdded() akItemForm = " + akItemForm + " abIsStolen = " + abIsStolen, 3)
    EndIf
    If !_IsValidForm(akForm1, akItemForm)
        Return False
    EndIf

    Float loc_last = GetStringParamFloat(aiDataStr, 6, 0.0)
    Float loc_period = MultFloat(GetStringParamFloat(aiDataStr, 3, -1.0), 1.0 / akModifier.MultInputQuantities)
    
    If loc_last < 0.0 && loc_period < 0.0
    ; already triggered with trigger-once settings
        Return False
    EndIf
    Bool loc_result = False
    
    Bool loc_stolen = GetStringParamInt(aiDataStr, 4, 0) > 0
    
    If loc_stolen && !abIsStolen
        Return False
    EndIf
    
    Float loc_timer = akDevice.GetGameTimeLockedTime()
    Int loc_min_count = MultInt(GetStringParamInt(aiDataStr, 0, 1), akModifier.MultInputQuantities)
    Int loc_acc = GetStringParamInt(aiDataStr, 5, 0)
    
    loc_acc += aiItemCount
    
    If (loc_last + loc_period) > loc_timer && loc_min_count <= loc_acc
        Float loc_prob1 = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
        Float loc_prob2 = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
        If RandomFloat(0.0, 100.0) < (loc_prob1 + loc_prob2 * loc_acc)
            loc_result = True
            loc_acc = 0
            loc_last = loc_timer
            If loc_period < 0.0
            ; triggered once
                loc_last = -1.0
            EndIf
        EndIf
    EndIf
    akDevice.editStringModifier(akModifier.NameAlias, 5, loc_acc as String)
    akDevice.editStringModifier(akModifier.NameAlias, 6, FormatFloat(loc_last, 2))
    
    Return loc_result
EndFunction

Bool Function ItemRemoved(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akDestContainer, String aiDataStr, Form akForm1)
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Min. num. of items:", MultInt(GetStringParamInt(aiDataStr, 0, 1), akModifier.MultInputQuantities))
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities), 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Accum weight:", FormatFloat(MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities), 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Reset period:", FormatFloat(MultFloat(GetStringParamFloat(aiDataStr, 3, -1.0), 1.0 / akModifier.MultInputQuantities), 1) + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Only stolen items:", InlineIfStr(GetStringParamInt(aiDataStr, 4, 0) > 0, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Items obtained:", GetStringParamInt(aiDataStr, 5, 0))
    loc_res += UDmain.UDMTF.TableRowDetails("Timestamp:", FormatFloat(GetStringParamFloat(aiDataStr, 6, 0), 2))
    Return loc_res
EndFunction
