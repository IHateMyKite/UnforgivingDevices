;/  File: UD_Modifier_Demanding
    Wearer have to pay for every escape attempt

    NameFull:   Demanding
    NameAlias:  DEM

    Parameters in DataStr:
        [0]     Int         (optional) Minimum value of coefficient A (absolute value)
                            Default value: 0
                        
        [1]     Int         (optional) Maximum value of coefficient A (absolute value)
                            Default value: Parameter [0]
                        
        [2]     Int         (optional) Minimum value of coefficient B (proportional to level)
                            Default value: 0
                        
        [3]     Int         (optional) Maximum value of coefficient B (proportional to level)
                            Default value: Parameter [2]

    Form arguments:
        Form1               If not None then it defines a custom currency to pay

    Example:
        GoldVaue = A + B * <level>
        where A and B are in ranges defined by parameters above
/;
ScriptName UD_Modifier_Demanding extends UD_Modifier_GoldBase

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akModDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    ;only pay device if user have device locked less then 1 real time hour (safeback)
    if akModDevice.GetRealTimeLockedTime() > 0.5
        return true
    endif

    ; checking max. possible value
    Int loc_gold = CalculateGold2(aiDataStr, akModDevice.UD_Level, false)
    Int loc_WearerGold = akModDevice.GetWearer().GetItemCount(UDLibs.Gold)
    
    Actor loc_helper   = akModDevice.GetHelper()
    Int loc_HelperGold = 0
    if loc_helper
        loc_HelperGold = loc_helper.GetItemCount(UDLibs.Gold)
    endif
    
    Bool loc_cond = loc_WearerGold > loc_gold || loc_HelperGold > loc_gold
    
;    if !loc_cond && IsPlayer(akModDevice.GetWearer())
;        UDmain.Print("You dont have enough gold to pay the device!")
;    endif
    
    return loc_cond
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    if akModDevice == akMinigameDevice
        if akModDevice.GetRealTimeLockedTime() < 0.5
            Int loc_Gold = CalculateGold2(aiDataStr, akModDevice.UD_Level)
            
            if akModDevice.GetWearer().GetItemCount(UDLibs.Gold) >= loc_Gold
                akMinigameDevice.GetWearer().RemoveItem(UDlibs.Gold, loc_Gold)
                return
            endif
            
            Actor loc_helper = akModDevice.GetHelper()
            if loc_helper && (loc_helper.GetItemCount(UDLibs.Gold) >= loc_Gold)
                loc_helper.RemoveItem(UDlibs.Gold, loc_Gold)
                return
            endif
        endif
    endif
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
; A message in the device description to explain the minigame prohibition
String Function MinigameProhibitedMessage(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_currency = "gold"
    If akForm1
        loc_currency = akForm1.GetName()
    EndIf
    Return "You don't have enough " + loc_currency + " to pay the device!"
EndFunction
