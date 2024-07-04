ScriptName UD_Modifier_Midas extends UD_Modifier_GoldBase

import UnforgivingDevicesMain
import UD_Native

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    if !akDevice
        return ;none device passed - exit
    endif
    
    Actor loc_actor = akDevice.GetWearer()
    
    if !loc_actor
        return
    endif
    
    int loc_gold = CalculateGold(aiDataStr,akDevice.UD_Level)
    if loc_gold > 0
        loc_actor.addItem(UDlibs.Gold,loc_gold)
    endif

    if !akDevice
        return ;none device passed - exit
    endif
EndFunction

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    return (RandomInt(0,99) < Round(5*PatchChanceMultiplier))
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    int loc_min = iRange(Round(RandomInt(5,10)*PatchPowerMultiplier),0,100)
    int loc_max = iRange(Round(loc_min*RandomFloat(1.25,1.5)*PatchPowerMultiplier),loc_min,300)
    int loc_lvlinc = iRange(Round(RandomInt(1,4)*PatchPowerMultiplier),0,20)
    akDevice.addModifier(self,loc_min + "," + loc_max + ",2," + loc_lvlinc)
EndFunction