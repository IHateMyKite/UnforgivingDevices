;/  File: UD_Modifier_Heal
    This device restores the durability of all equipment over time

    NameFull:   Mass regeneration
    NameAlias:  MRG

    Parameters:
        [0]     Float   Regeneration ability per game day
/;
ScriptName UD_Modifier_Heal extends UD_Modifier

import UnforgivingDevicesMain
import UDCustomDeviceMain
import UD_Native

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    if akDevice.WearerIsRegistered()
        UD_CustomDevice_RenderScript[] loc_devices = UDCDmain.getNPCDevices(akDevice.getWearer())
        int loc_i = 0
        while loc_devices[loc_i]
            loc_devices[loc_i].refillDurability(afTime*UD_Native.GetStringParamFloat(aiDataStr, 0) * UDCDmain.getStruggleDifficultyModifier())
            loc_i+=1
        endwhile
    endif
EndFunction

String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Healing: " + FormatFloat(UD_Native.GetStringParamFloat(aiDataStr, 0) / 24.0, 1) + " per hour\n"
    loc_msg += "\n"
    loc_msg += "=== Description ===\n"
    loc_msg += Description + "\n"
    
    Return loc_msg
EndFunction
