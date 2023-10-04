ScriptName UD_Modifier_Loose extends UD_Modifier

import UnforgivingDevicesMain

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    ;TODO - make native function for easier filtering device types
    
    if !akDevice.CanBeStruggled(1.0) || akDevice.CanBeStruggled(0.0) || akDevice.IsPlug()
        return false
    endif
    
    if akDevice.UD_DeviceKeyword == libs.zad_DeviousBlindfold
        return Utility.randomInt(1,100) < 70*PatchChanceMultiplier
    elseif akDevice.UD_DeviceKeyword == libs.zad_DeviousGag
        return Utility.randomInt(1,100) < 30*PatchChanceMultiplier
    elseif akDevice.UD_DeviceKeyword == libs.zad_DeviousHood || akDevice.isMittens()
        return true
    else
        return Utility.randomInt(1,100) < 50*PatchChanceMultiplier
    endif
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    akDevice.addModifier(self,formatString(fRange(Utility.randomFloat(0.10,0.50)*PatchPowerMultiplier,0.0,1.0),2))
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Strength: " + iRange(Round(UD_Modifier.getStringParamFloat(aiDataStr,0,0.0)*100.0),0,100) + " %\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction