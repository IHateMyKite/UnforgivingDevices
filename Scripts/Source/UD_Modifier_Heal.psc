ScriptName UD_Modifier_Heal extends UD_Modifier

import UnforgivingDevicesMain

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    if akDevice.WearerIsRegistered()
        UD_CustomDevice_RenderScript[] loc_devices = UDCDmain.getNPCDevices(akDevice.getWearer())
        int loc_i = 0
        while loc_devices[loc_i]
            loc_devices[loc_i].refillDurability(afTime*UD_Modifier.getStringParamInt(aiDataStr)*UDCDmain.getStruggleDifficultyModifier())
            loc_i+=1
        endwhile
    endif
EndFunction