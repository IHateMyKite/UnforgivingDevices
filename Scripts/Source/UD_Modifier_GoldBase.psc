ScriptName UD_Modifier_GoldBase extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akModDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    return true
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice,String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    
    int goldNumMin = Round(UD_Native.GetStringParamInt(aiDataStr,0,0)*Multiplier)
    int goldMode   = UD_Native.GetStringParamInt(aiDataStr,2,0)
    
    if UD_Native.GetStringParamAll(aiDataStr).length > 1
        int goldNumMax = Round(UD_Native.GetStringParamInt(aiDataStr,1,0)*Multiplier)
        if goldNumMax < goldNumMin
            goldNumMax = goldNumMin
        endif
        
        int goldNumMin2    = goldNumMin ;modified value
        int goldNumMax2    = goldNumMax ;modified value
        
        float goldModeParam = 0.0
        
        if goldMode == 0
            ;nothink
        elseif goldMode == 1 ;increase % gold based on level per parameter
            goldModeParam   = UD_Native.GetStringParamFloat(aiDataStr,3,0.05)
            goldNumMin2     = Round(goldNumMin2*(1.0 + goldModeParam*akDevice.UD_Level))
            goldNumMax2     = Round(goldNumMax2*(1.0 + goldModeParam*akDevice.UD_Level))
        elseif goldMode == 2 ;increase ABS gold based on level per parameter
            goldModeParam   = UD_Native.GetStringParamFloat(aiDataStr,3,10.0)*Multiplier
            goldNumMin2     = Round(goldNumMin2 + (goldModeParam*akDevice.UD_Level))
            goldNumMax2     = Round(goldNumMax2 + (goldModeParam*akDevice.UD_Level))
        else    ;unused
        endif
        
        if goldNumMin2 != goldNumMax2
            loc_msg += "Gold: "+ goldNumMin2 +"-"+ goldNumMax2 +"\n"
        else
            loc_msg += "Gold "+ goldNumMax2 +"\n"
        endif
    else
        loc_msg += "Gold: "+ goldNumMin +"\n"
    endif
    
    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction

Int Function CalculateGold(String aiDataStr,int aiLevel, Bool abRandom = true)
    ; para 0 = min
    ; para 1 = max
    ; para 2 = mode
    ; para 3 = mode modfier

    int goldNumMin = Round(UD_Native.GetStringParamInt(aiDataStr,0,0)*Multiplier)
    int goldMode   = UD_Native.GetStringParamInt(aiDataStr,2,0)
    
    if UD_Native.GetStringParamAll(aiDataStr).length > 1
        int goldNumMax = Round(UD_Native.GetStringParamInt(aiDataStr,1,0)*Multiplier)
        if goldNumMax < goldNumMin
            goldNumMax = goldNumMin
        endif
        int goldNumMin2    = goldNumMin ;modified value
        int goldNumMax2    = goldNumMax ;modified value
        
        float goldModeParam = 0.0
        
        if goldMode == 0
            ;nothink
        elseif goldMode == 1 ;increase % gold based on level per parameter
            goldModeParam   = UD_Native.GetStringParamFloat(aiDataStr,3,0.05)
            goldNumMin2     = Round(goldNumMin2*(1.0 + goldModeParam*aiLevel))
            goldNumMax2     = Round(goldNumMax2*(1.0 + goldModeParam*aiLevel))
        elseif goldMode == 2 ;increase ABS gold based on level per parameter
            goldModeParam   = UD_Native.GetStringParamFloat(aiDataStr,3,10.0)*Multiplier
            goldNumMin2     = Round(goldNumMin2 + (goldModeParam*aiLevel))
            goldNumMax2     = Round(goldNumMax2 + (goldModeParam*aiLevel))
        else    ;unused
        endif
        
        int randomNum = 0
        if abRandom
            randomNum = RandomInt(goldNumMin2,goldNumMax2)
        else
            randomNum = goldNumMax2
        endif
        
        return randomNum
    else
        return goldNumMin
    endif
EndFunction