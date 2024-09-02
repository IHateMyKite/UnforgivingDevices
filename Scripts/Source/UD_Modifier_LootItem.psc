;/  File: UD_Modifier_LootItem
    Upon release from the device, the actor will receive items as a reward

    NameFull:   Loot Item
    NameAlias:  LI

    Parameters:
        [0]     Int     (optional) Number of items from Form1 to award
                        Default value: 1
                        
        [1]     Int     (optional) Number of items from Form2 to award
                        Default value: 1
                        
        [2]     Int     (optional) Number of items from Form3 to award
                        Default value: 1
                        
        [3]     Int     (optional) Number of items from Form4 to award
                        Default value: 1

    Form arguments:
        Form1           Item the actor will receive
        Form2           Item the actor will receive
        Form3           Item the actor will receive
        Form4           Item the actor will receive
        
    Example:
        1               Reward actor with 1x Form1,Form2,Form3 (if filled)
        1,2,3           Reward actor with 1x Form1, 2x Form2, 3x Form3 (if filled)
/;
ScriptName UD_Modifier_LootItem extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    if !akDevice
        return ;none device passed - exit
    endif
    
    Actor loc_actor = akDevice.GetWearer()
    
    ;check if device didnt evolve
    String[] loc_evl = akDevice.getModifierAllParam("EVL")
    if (loc_evl && loc_evl[0] == -1) 
        return
    endif
    
    if loc_actor && (akForm1 || akForm2 || akForm3)
        int loc_num1 = Round(UD_Native.GetStringParamInt(aiDataStr,0,1)*Multiplier)
        int loc_num2 = Round(UD_Native.GetStringParamInt(aiDataStr,1,1)*Multiplier)
        int loc_num3 = Round(UD_Native.GetStringParamInt(aiDataStr,2,1)*Multiplier)
        int loc_num4 = Round(UD_Native.GetStringParamInt(aiDataStr,3,1)*Multiplier)

        if akForm1 && loc_num1 > 0
            loc_actor.addItem(akForm1,loc_num1)
        endif
        
        if akForm2 && loc_num2 > 0
            loc_actor.addItem(akForm2,loc_num2)
        endif
        
        if akForm3 && loc_num3 > 0
            loc_actor.addItem(akForm3,loc_num3)
        endif
        
        if akForm4 && loc_num4 > 0
            loc_actor.addItem(akForm4,loc_num4)
        endif
    endif
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    
    if akForm1
        loc_msg += "Item = " + akForm1 + " x" + Round(UD_Native.GetStringParamInt(aiDataStr,0,0)*Multiplier) + "\n"
    endif
    
    if akForm2
        loc_msg += "Item = " + akForm2 + " x" + Round(UD_Native.GetStringParamInt(aiDataStr,1,0)*Multiplier) + "\n"
    endif
    
    if akForm3
        loc_msg += "Item = " + akForm3 + " x" + Round(UD_Native.GetStringParamInt(aiDataStr,2,0)*Multiplier) + "\n"
    endif
    
    if akForm4
        loc_msg += "Item = " + akForm4 + " x" + Round(UD_Native.GetStringParamInt(aiDataStr,3,0)*Multiplier) + "\n"
    endif
    
    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction

