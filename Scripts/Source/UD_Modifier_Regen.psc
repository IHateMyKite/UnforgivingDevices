ScriptName UD_Modifier_Regen extends UD_Modifier

import UnforgivingDevicesMain
import UDCustomDeviceMain
import UD_Native

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    if akDevice.getRelativeDurability() < 1.0
        mendDevice(akDevice,UD_Modifier.getStringParamInt(aiDataStr),1.0,afTime)
    endif
EndFunction

Function mendDevice(UD_CustomDevice_RenderScript akDevice, Int aiStrength,float afMult = 1.0,float afTimePassed)
    if akDevice.onMendPre(afMult) && akDevice.GetRelativeDurability() > 0.0
        int     loc_regen   = Round(aiStrength*Multiplier)
        Float   loc_amount  = afTimePassed*loc_regen*(1 - 0.1*akDevice.UD_condition)*afMult*UDCDmain.getStruggleDifficultyModifier()
        akDevice.refillDurability(loc_amount)
        akDevice.refillCuttingProgress(afTimePassed*loc_regen)
        akDevice.onMendPost(loc_amount)
    endif
EndFunction

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    return akDevice.CanBeStruggled() && (Utility.randomInt(1,100) < (25 + 25*(IsEbonite(akDevice) as Int))*PatchChanceMultiplier)
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    float loc_addmult = 0.0
    
    if IsEbonite(akDevice)
        loc_addmult = 1.0
    endif

    akDevice.addModifier(self,formatString(120*PatchPowerMultiplier*Utility.randomFloat(0.5 + loc_addmult,2.0 + loc_addmult),1))
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Regen: " + formatString(UD_Modifier.getStringParamInt(aiDataStr)*Multiplier/24.0,1) + " per hour\n"
    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"
    
    UDmain.ShowMessageBox(loc_msg)
EndFunction