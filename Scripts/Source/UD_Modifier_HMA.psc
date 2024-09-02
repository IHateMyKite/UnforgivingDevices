;/  File: UD_Modifier_HMA
    There is chance that wearer will be every hour locked in new manifested device

    NameFull:   Hour Manifest
    NameAlias:  HMA

    Parameters:
        [0]     Int     Chance to summon and lock random device (see UDCustomDeviceMain::ManifestDevices) on the wearer every hour.
                        
        [1]     Int     (optional) Number of devices to summon
                        Default value: 1

/;
ScriptName UD_Modifier_HMA extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    int loc_chance = Round(UD_Native.GetStringParamInt(aiDataStr,0)*Multiplier)
    int loc_number = UD_Native.GetStringParamInt(aiDataStr,1,1)
    UDCDmain.ManifestDevices(akDevice.GetWearer(), akDevice.getDeviceName(), loc_chance, loc_number)
EndFunction

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    ;check if orgasm manifest is already preset
    ;Both of these should be not present on device at the same time
    if akDevice.HasModifier("OMA")
        return false
    endif

    ;TODO - make native function for easier filtering device types
    Bool loc_res = false
    ;loc_res = loc_res || (akDevice.UD_DeviceKeyword == libs.zad_DeviousBelt)
    loc_res = loc_res || (akDevice.UD_DeviceKeyword == libs.zad_DeviousPiercingsNipple)
    ;loc_res = loc_res || (akDevice.UD_DeviceKeyword == libs.zad_DeviousHarness)
    return loc_res
EndFunction

Float Function PatchModifierProbability(UD_CustomDevice_RenderScript akDevice, Int aiSoftCap, Int aiValidMods)
    Return Parent.PatchModifierProbability(akDevice, aiSoftCap, aiValidMods) * 1.20
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    akDevice.addModifier(self,iRange(Round(RandomInt(2,8)*PatchPowerMultiplier),0,100) + "," + RandomInt(1,3))
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Chance: " + iRange(Round(UD_Native.GetStringParamInt(aiDataStr,0)*Multiplier),0,100) + " %\n"
    loc_msg += "Devices: " + UD_Native.GetStringParamInt(aiDataStr,1,1) + "\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction
