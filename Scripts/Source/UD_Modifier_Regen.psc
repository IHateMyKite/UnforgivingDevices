;/  File: UD_Modifier_Regen
    Device will slowly repair itself

    NameFull:   Regeneration
    NameAlias:  REG

    Parameters:
        [0]     Float   Regeneration ability per game day
/;
ScriptName UD_Modifier_Regen extends UD_Modifier

import UnforgivingDevicesMain
import UDCustomDeviceMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Update()
    EventProcessingMask = 0x00000001
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function TimeUpdateSeconds(UD_CustomDevice_RenderScript akDevice, Float afHoursSinceLastCall, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    if akDevice.getRelativeDurability() < 1.0
        mendDevice(akDevice, UD_Native.GetStringParamFloat(aiDataStr, 0), 1.0, afHoursSinceLastCall * 24.0)
    endif
EndFunction

Function mendDevice(UD_CustomDevice_RenderScript akDevice, Float afStrength,float afMult = 1.0,float afTimePassed)
    if akDevice.onMendPre(afMult) && akDevice.GetRelativeDurability() > 0.0
        Float   loc_regen   = (afStrength*Multiplier)
        Float   loc_amount  = afTimePassed*loc_regen*(1 - 0.1*akDevice.UD_condition)*afMult*UDCDmain.getStruggleDifficultyModifier()
        akDevice.refillDurability(loc_amount)
        akDevice.refillCuttingProgress(afTimePassed*loc_regen)
        akDevice.onMendPost(loc_amount)
    endif
EndFunction

String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Regen: " + FormatFloat(UD_Native.GetStringParamFloat(aiDataStr)*Multiplier/24.0,1) + " per hour\n"
    loc_msg += "\n"
    loc_msg += "=== Description ===\n"
    loc_msg += Description + "\n"
    
    Return loc_msg
EndFunction
