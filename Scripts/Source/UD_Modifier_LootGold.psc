ScriptName UD_Modifier_LootGold extends UD_Modifier

import UnforgivingDevicesMain

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    if !akDevice
        return ;none device passed - exit
    endif
    
    Actor loc_actor = akDevice.GetWearer()
    
    if loc_actor
        int goldNumMin = Round(UD_Modifier.getStringParamInt(aiDataStr,0,0)*Multiplier)
        int goldMode   = Round(UD_Modifier.getStringParamInt(aiDataStr,2,0)*Multiplier)
        
        if UD_Modifier.getStringParamNum(aiDataStr) > 1
            int goldNumMax = Round(UD_Modifier.getStringParamInt(aiDataStr,1,0)*Multiplier)
            if goldNumMax < goldNumMin
                goldNumMax = goldNumMin
            endif
            int goldNumMin2    = goldNumMin ;modified value
            int goldNumMax2    = goldNumMax ;modified value
            
            float goldModeParam = 0.0
            
            if goldMode == 0
                ;nothink
            elseif goldMode == 1 ;increase % gold based on level per parameter
                goldModeParam   = UD_Modifier.getStringParamFloat(aiDataStr,3,0.05)*Multiplier
                goldNumMin2     = Round(goldNumMin2*(1.0 + goldModeParam*akDevice.UD_Level))
                goldNumMax2     = Round(goldNumMax2*(1.0 + goldModeParam*akDevice.UD_Level))
            elseif goldMode == 2 ;increase ABS gold based on level per parameter
                goldModeParam   = UD_Modifier.getStringParamFloat(aiDataStr,3,10.0)*Multiplier
                goldNumMin2     = Round(goldNumMin2 + (goldModeParam*akDevice.UD_Level))
                goldNumMax2     = Round(goldNumMax2 + (goldModeParam*akDevice.UD_Level))
            else    ;unused
            endif
            
            int randomNum = Utility.randomInt(goldNumMin2,goldNumMax2)
            if randomNum > 0
                loc_actor.addItem(UDlibs.Gold,randomNum)
            endif
        else
            loc_actor.addItem(UDlibs.Gold,goldNumMin)
        endif
    endif
EndFunction