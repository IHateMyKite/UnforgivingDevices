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

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    EventProcessingMask = 0x00000004
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
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
