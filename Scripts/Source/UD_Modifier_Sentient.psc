ScriptName UD_Modifier_Sentient extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    return True
EndFunction

Float Function PatchModifierProbability(UD_CustomDevice_RenderScript akDevice, Int aiSoftCap, Int aiValidMods)
    Return Parent.PatchModifierProbability(akDevice, aiSoftCap, aiValidMods) * 0.10
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    akDevice.addModifier(self,RandomInt(Round(5*PatchPowerMultiplier),Round(35*PatchPowerMultiplier)))
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Power: " + GetStringParamInt(aiDataStr,0,0) + "\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction