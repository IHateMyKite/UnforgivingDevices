;/  File: UD_Modifier_LootGold
    Escaping device will reward actor with gold

    NameFull: Gold loot
    NameAlias: LG

    Parameters:
        0 = Minimum gold rewarded, Int
        1 = (optional) Maximum gold rewarded, Int, not filling this parameter will result in actor gaining fixed amount of gold
        3 = (optional) Mode, Int, not filling this parameter will result in use of mode 0
            0 - Value is not affected
            1 - Value is % increased based on actor LEVEL per parameter
            2 - Value is ABS increased based on actor LEVEL per parameter
        4 = (optional) Mode parameter, Float, Parameter in case that Mode > 0
        
    Form arguments:
        Form1 - Unused
        Form2 - Unused
        Form3 - Unused
        
    Example:
        100             = Actor will get 100 gold
        100,500         = Actor will get random amount of gold in range 100 - 500
        100,500,1,0.1   = In case that actor have Level=10, then resulting gold will be in range 100*(1 + 10x0.1) - 500*(1 + 10x0.1) => 200 - 1000 Gold
        100,500,2,10.0  = In case that actor have Level=5, then resulting gold will be in range 100+(10x5) - 500+(10x5) => 150 - 550 Gold
/;
ScriptName UD_Modifier_LootGold extends UD_Modifier_GoldBase

import UnforgivingDevicesMain
import UD_Native

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    if !akDevice
        return ;none device passed - exit
    endif
    
    Actor loc_actor = akDevice.GetWearer()
    
    if !loc_actor || !IsPlayer(loc_actor) ;should only work for player
        return
    endif
    
    ;check if device didnt evolve
    String[] loc_evl = akDevice.getModifierAllParam("EVL")
    if (loc_evl && loc_evl[0] == -1) 
        return
    endif
    
    int loc_gold = CalculateGold(aiDataStr,akDevice.UD_Level)
    if loc_gold > 0
        loc_actor.addItem(UDlibs.Gold,loc_gold)
    endif
EndFunction