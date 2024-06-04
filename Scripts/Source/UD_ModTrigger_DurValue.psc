;/  File: UD_ModTrigger_DurValue
    It triggers when the durability of the device falls below a given threshold
    
    NameFull: 
    NameAlias: TDV
    
    Parameters (DataStr):
        [0]     Int     When the durability of a device falls below given threshold, it evolves
                            0 - "Excellent"
                            1 - "Good"
                            2 - "Normal"
                            3 - "Bad"
                            4 - "Destroyed"
                            
    Example:
                    
/;
Scriptname UD_ModTrigger_DurValue extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ConditionLoss(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr)
    Int loc_threshold = GetStringParamInt(aiDataStr, 0)
    Return (aiCondition >= loc_threshold)
EndFunction
