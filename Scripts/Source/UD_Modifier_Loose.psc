ScriptName UD_Modifier_Loose extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    ;TODO - make native function for easier filtering device types
    
    if !akDevice.CanBeStruggled(1.0) || akDevice.CanBeStruggled(0.0) || akDevice.IsPlug()
        return false
    endif
    
    Return True
EndFunction

Float Function PatchModifierProbability(UD_CustomDevice_RenderScript akDevice, Int aiSoftCap, Int aiValidMods)
    Float loc_base = 100.0
    
    if akDevice.UD_DeviceKeyword == libs.zad_DeviousBlindfold
        return loc_base * 0.70
    elseif akDevice.UD_DeviceKeyword == libs.zad_DeviousGag
        return loc_base * 0.30
    elseif akDevice.UD_DeviceKeyword == libs.zad_DeviousHood || akDevice.isMittens()
        return loc_base
    else
        return loc_base * 0.50
    endif
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    akDevice.addModifier(self,FormatFloat(fRange(RandomFloat(0.10,0.50)*PatchPowerMultiplier,0.0,1.0),2))
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Strength: " + iRange(Round(UD_Native.GetStringParamFloat(aiDataStr,0,0.0)*100.0),0,100) + " %\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction
