ScriptName UD_Modifier_Demanding extends UD_Modifier_GoldBase

import UnforgivingDevicesMain
import UD_Native

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akModDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    ;only pay device if user have device locked less then 1 real time hour (safeback)
    if akModDevice.GetRealTimeLockedTime() > 0.5
        return true
    endif

    Int loc_gold = CalculateGold(aiDataStr,akModDevice.UD_Level,false)
    Int loc_WearerGold = akModDevice.GetWearer().GetItemCount(UDLibs.Gold)
    
    Actor loc_helper   = akModDevice.GetHelper()
    Int loc_HelperGold = 0
    if loc_helper
        loc_HelperGold = loc_helper.GetItemCount(UDLibs.Gold)
    endif
    
    Bool loc_cond = loc_WearerGold > loc_gold || loc_HelperGold > loc_gold
    
    if !loc_cond && IsPlayer(akModDevice.GetWearer())
        UDmain.Print("You dont have enough gold to pay the device!")
    endif
    
    return loc_cond
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    if akModDevice == akMinigameDevice
        if akModDevice.GetRealTimeLockedTime() < 0.5
            Int loc_Gold = CalculateGold(aiDataStr,akModDevice.UD_Level)
            
            if akModDevice.GetWearer().GetItemCount(UDLibs.Gold) >= loc_Gold
                akMinigameDevice.GetWearer().RemoveItem(UDlibs.Gold,loc_Gold)
                return
            endif
            
            Actor loc_helper   = akModDevice.GetHelper()
            if loc_helper && (loc_helper.GetItemCount(UDLibs.Gold) >= loc_Gold)
                loc_helper.RemoveItem(UDlibs.Gold,loc_Gold)
                return
            endif
        endif
    endif
EndFunction

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    return True
EndFunction

Float Function PatchModifierProbability(UD_CustomDevice_RenderScript akDevice, Int aiSoftCap, Int aiValidMods)
    Return Parent.PatchModifierProbability(akDevice, aiSoftCap, aiValidMods) * 0.06
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    int loc_min = iRange(Round(RandomInt(3,7)*PatchPowerMultiplier),0,100)
    int loc_max = iRange(Round(loc_min*RandomFloat(1.25,1.5)*PatchPowerMultiplier),loc_min,300)
    int loc_lvlinc = iRange(Round(RandomInt(1,3)*PatchPowerMultiplier),0,20)
    akDevice.addModifier(self,loc_min + "," + loc_max + ",2," + loc_lvlinc)
EndFunction
