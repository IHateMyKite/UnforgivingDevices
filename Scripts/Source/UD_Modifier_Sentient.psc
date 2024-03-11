ScriptName UD_Modifier_Sentient extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    return (RandomInt(1,100) < (10)*PatchChanceMultiplier)
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    akDevice.addModifier(self,RandomInt(Round(5*PatchPowerMultiplier),Round(35*PatchPowerMultiplier)))
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Power: " + GetStringParamInt(aiDataStr,0,0) + "\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction