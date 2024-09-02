;/  File: UD_Modifier_LootGold
    Escaping device will reward actor with gold

    NameFull: Gold loot
    NameAlias: LG

    Parameters:
        [0]     Int     (optional) Minimum value of coefficient A (absolute value)
                        Default value: 0
                        
        [1]     Int     (optional) Maximum value of coefficient A (absolute value)
                        Default value: Parameter [0]
                        
        [2]     Int     (optional) Minimum value of coefficient B (proportional to level)
                        Default value: 0
                        
        [3]     Int     (optional) Maximum value of coefficient B (proportional to level)
                        Default value: Parameter [2]
    
    Example:
        GoldVaue = A + B * <level>
        where A and B are in ranges defined by parameters above
        100             = Actor will get 100 gold
        100,500         = Actor will get gold in range (100; 500)
        100,500,10,50   = Actor with lvl 10 will get gold in range (100; 500) + 10 * (10; 50) or (200; 1000)
        100,500,10      = Actor with lvl 5 will get gold in range (100; 500) + 5 * (10; 10) or (150; 550)
/;
ScriptName UD_Modifier_LootGold extends UD_Modifier_GoldBase

import UnforgivingDevicesMain
import UD_Native

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
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
    
    int loc_gold = CalculateGold2(aiDataStr, akDevice.UD_Level)
    if loc_gold > 0
        loc_actor.addItem(UDlibs.Gold,loc_gold)
    endif
EndFunction
