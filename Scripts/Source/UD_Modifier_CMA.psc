;/  File: UD_Modifier_CMA
    Device can manifest more devices on condition loss

    NameFull:   Manifest on condition loss
    NameAlias:  CMA

    Parameters in DataStr:
        [0]     (optional) Base probability to summon devices.
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
        10,1,FIRST     One device may be summoned with a 10% probability on condition loss. The first suitable device from the 
                        list in Form1 will be selected, starting from the top one.
        10,5,F,R       Five devices may be summoned with a 10% probability on condition loss. First the matching devices will be 
                        selected from the list in Form1, and then the remaining number will be selected randomly from the 
                        list in Form2.
/;
Scriptname UD_Modifier_CMA extends UD_Modifier_Manifest

import UnforgivingDevicesMain
import UD_Native

Float _DebugDamageMutliplier = 10.0

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    ;TODO - make native function for easier filtering device types
    Bool loc_res = Parent.PatchModifierCondition(akDevice)
    ; TODO: device filter
    return loc_res && (RandomInt(1,100) < 30 * PatchChanceMultiplier)
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    akDevice.addModifier(self,iRange(Round(RandomInt(2,8)*PatchPowerMultiplier),0,100) + "," + RandomInt(1,3))
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_CMA::ConditionLoss() akDevice = " + akDevice + ", aiCondition = " + aiCondition + ", aiDataStr = " + aiDataStr, 3)
    EndIf
; TODO: (as an option) worse condition, better odds
    Float loc_prob = UD_Native.GetStringParamFloat(aiDataStr, 0)
    If RandomFloat(0.0, 100.0) < loc_prob * _DebugDamageMutliplier
        Manifest(akDevice, aiDataStr, akForm1, akForm2, akForm3)
    EndIf
EndFunction
