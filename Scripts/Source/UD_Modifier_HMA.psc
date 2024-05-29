;/  File: UD_Modifier_HMA
    There is chance that wearer will be every hour locked in new manifested device

    NameFull:   Hour Manifest
    NameAlias:  HMA

    Parameters in DataStr:
        [0]     (optional) Base probability to summon devices, checked every hour
        [1]     (optional) Number of devices
                Default value: 1
        [2]     (optional) Selection method (in general or for the devices in list akForm1)
                    FIRST or F      - first suitable device from the list (akForm1, akForm2, akForm3 concatenated together)
                    RANDOM or R     - random device from the list (akForm1, akForm2, akForm3 concatenated together)
                Default value: R
        [3]     (optional) Selection method for the devices in list akForm2
        [4]     (optional) Selection method for the devices in list akForm3

    Form arguments:
        Form1 - Single device to manifest or FormList with devices.
        Form2 - Single device to manifest or FormList with devices.
        Form3 - Single device to manifest or FormList with devices.

    Example:
        10,1,FIRST      One device may be summoned every hour with a 10% probability. The first suitable device from the 
                        list in Form1 will be selected, starting from the top one.
        10,5,F,R        Five devices may be summoned every hour with a 10% probability. First the matching devices will be 
                        selected from the list in Form1, and then the remaining number will be selected randomly from the 
                        list in Form2.
/;
ScriptName UD_Modifier_HMA extends UD_Modifier_Manifest

import UnforgivingDevicesMain
import UD_Native

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    int loc_chance = Round(GetStringParamInt(aiDataStr, 0) * Multiplier)
    If RandomInt(0, 100) < loc_chance
        Manifest(akDevice, aiDataStr, akForm1, akForm2, akForm3)
    EndIf
EndFunction

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    ;TODO - make native function for easier filtering device types
    Bool loc_res = Parent.PatchModifierCondition(akDevice)
    ;loc_res = loc_res || (akDevice.UD_DeviceKeyword == libs.zad_DeviousBelt)
    loc_res = loc_res || (akDevice.UD_DeviceKeyword == libs.zad_DeviousPiercingsNipple)
    ;loc_res = loc_res || (akDevice.UD_DeviceKeyword == libs.zad_DeviousHarness)
    return loc_res && (RandomInt(1,100) < 30*PatchChanceMultiplier)
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    akDevice.addModifier(self,iRange(Round(RandomInt(2,8)*PatchPowerMultiplier),0,100) + "," + RandomInt(1,3))
EndFunction
