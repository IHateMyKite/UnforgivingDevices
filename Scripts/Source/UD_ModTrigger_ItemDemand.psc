;/  File: UD_ModTrigger_ItemDemand
    It triggers with a given chance after actor failed to obtain an item before time expires
    
    NameFull: Item Demand
    
    Parameters (DataStr):
        [0]     Int     (optional) Number of items demanded
                        Default value: 1
        
        [1]     Float   (optional) Base probability to trigger (in %) at the end of the check period if actor failed to obtain items
                        Default value: 100.0%
        
        [2]     Int     (optional) Only stolen items count
                        Default value: 0 (False)
                        
        [3]     Float   (optional) The time given to obtain items (in hours)
                        Default value: 8.0
                        
        [4]     Int     (optional) Repeat
                        Default value: 0 (False)
                        
        [5]     Int     (script) Number of obtained items so far
        
        [6]     Float   (script) Device locked time in the moment of the last trigger (ingame hours)

    Forms:
        Form1           Item or Keyword to filter demanded items
        
    Example:
        
/;
Scriptname UD_ModTrigger_ItemDemand extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Int Function GetEventProcessingMask()
    Return Math.LogicalOr(0x00000002, 0x00002000)
EndFunction

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

Bool Function TimeUpdateHour(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afHoursSinceLastCall, String aiDataStr, Form akForm1)
    Float loc_last = GetStringParamFloat(aiDataStr, 6, 0.0)
    Float loc_period = GetStringParamFloat(aiDataStr, 3, 0.0)
    Float loc_timer = akDevice.GetGameTimeLockedTime()
    
    If loc_last < 0 || (loc_period > 0 && (loc_last + loc_period) < loc_timer)
    ; once triggered or it is not the time yet
        Return False
    EndIf
    
    Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0
    Int loc_acc = GetStringParamInt(aiDataStr, 5, 0)
    Int loc_min_count = GetStringParamInt(aiDataStr, 0, 1)
    
    If loc_acc >= loc_min_count
        loc_acc = 0
        If !loc_repeat
        ; triggered once
            loc_last = -1.0
        Else
            loc_last = loc_timer
        EndIf
        akDevice.editStringModifier(akModifier.NameAlias, 5, loc_acc as String)
        akDevice.editStringModifier(akModifier.NameAlias, 6, FormatFloat(loc_last, 2))
        Return False
    EndIf

    Float loc_prob1 = GetStringParamFloat(aiDataStr, 1, 100.0)
    
    If RandomFloat(0.0, 100.0) < (loc_prob1)
        loc_acc = 0
        If !loc_repeat
        ; triggered once
            loc_last = -1.0
        Else
            loc_last = loc_timer
        EndIf
        akDevice.editStringModifier(akModifier.NameAlias, 5, loc_acc as String)
        akDevice.editStringModifier(akModifier.NameAlias, 6, FormatFloat(loc_last, 2))
        Return True
    EndIf
    Return False
EndFunction

Bool Function ItemAdded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akSourceContainer, Bool abIsStolen, String aiDataStr, Form akForm1)
    If !_IsValidForm(akForm1, akItemForm)
        Return False
    EndIf

    Int loc_acc = GetStringParamInt(aiDataStr, 5, 0)
    Int loc_min_count = GetStringParamInt(aiDataStr, 0, 1)
    Bool loc_stolen = GetStringParamInt(aiDataStr, 2, 0) > 0
    
    If loc_stolen && !abIsStolen
        Return False
    EndIf
    
    loc_acc += aiItemCount
    
    Int loc_consume = aiItemCount
    If loc_acc > loc_min_count
        loc_consume -= loc_acc - loc_min_count
        loc_acc = loc_min_count
    EndIf
    ; consume items (should it be an option?)
    akDevice.GetWearer().RemoveItem(akItemForm, loc_consume)

    akDevice.editStringModifier(akModifier.NameAlias, 5, loc_acc as String)
    
    Return False
EndFunction

Bool Function ItemRemoved(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akDestContainer, String aiDataStr, Form akForm1)
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Return Description
EndFunction
