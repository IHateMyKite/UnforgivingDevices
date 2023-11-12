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
    
    int loc_gold = CalculateGold(aiDataStr,akDevice.UD_Level)
    if loc_gold > 0
        loc_actor.addItem(UDlibs.Gold,loc_gold)
    endif
EndFunction