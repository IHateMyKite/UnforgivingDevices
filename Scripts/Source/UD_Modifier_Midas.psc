;/  File: UD_Modifier_Midas
    This device generates a small amount of gold every hour

    NameFull:   Midas
    NameAlias:  MDS

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
/;
ScriptName UD_Modifier_Midas extends UD_Modifier_GoldBase

import UnforgivingDevicesMain
import UD_Native

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    if !akDevice
        return ;none device passed - exit
    endif
    
    Actor loc_actor = akDevice.GetWearer()
    
    if !loc_actor
        return
    endif
    
    Float loc_gold = CalculateGold2(aiDataStr, akDevice.UD_Level) * afMult
    if loc_gold >= 1.0
        loc_actor.addItem(UDlibs.Gold, Round(loc_gold))
    endif

    if !akDevice
        return ;none device passed - exit
    endif
EndFunction

;/  Group: Patcher overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

; obsolete
Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    int loc_A_min = iRange(Round(RandomInt(3,7)*PatchPowerMultiplier),0,100)
    int loc_A_max = iRange(Round(loc_A_min * RandomFloat(1.25,1.5)),loc_A_min,300)
    int loc_B_min = iRange(Round(RandomInt(1,3)*PatchPowerMultiplier),0,20)
    int loc_B_max = iRange(Round(loc_B_min * RandomFloat(1.25,1.5)),loc_B_min,60)
    
    akDevice.addModifier(self, loc_A_min + "," + loc_A_max + "," + loc_B_min + "," + loc_B_max)
EndFunction
