;/  File: UD_ModOutcome_AddGold
    Summons gold (or any other currency)

    NameFull:   
    NameAlias:  AIT

    Parameters in DataStr:
        [5]     Int     (optional) Minimum value of coefficient A (absolute value)
                        Default value: 0
                        
        [6]     Int     (optional) Maximum value of coefficient A (absolute value)
                        Default value: [5]
                        
        [7]     Int     (optional) Minimum value of coefficient B (proportional to level)
                        Default value: 0
                        
        [8]     Int     (optional) Maximum value of coefficient B (proportional to level)
                        Default value: [7]

    Form arguments:
        akForm1         If not None then it is used as currency to add
        
    Example:
        GoldVaue = A + B * <level>
        where A and B are in ranges defined by parameters above
/;
Scriptname UD_ModOutcome_AddGold extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)
    
    Actor loc_actor = akDevice.GetWearer()
    if !loc_actor || !IsPlayer(loc_actor) ;should only work for player
        return
    endif
    
    Int loc_A_min = GetStringParamInt(aiDataStr, 5, 0)
    Int loc_A_max = GetStringParamInt(aiDataStr, 6, loc_A_min)
    Int loc_B_min = GetStringParamInt(aiDataStr, 7, 0)
    Int loc_B_max = GetStringParamInt(aiDataStr, 8, loc_B_min)
    
    Int loc_gold = RandomInt(loc_A_min, loc_A_max) + RandomInt(loc_B_min, loc_B_max) * akDevice.UD_Level
    
    Form loc_currency = UDlibs.Gold
    If akForm1 != None
        loc_currency = akForm1
    EndIf
    
    if loc_gold > 0
        loc_actor.addItem(loc_currency, loc_gold)
    endif
    
EndFunction
