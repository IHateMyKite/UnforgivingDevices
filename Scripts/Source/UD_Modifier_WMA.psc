;/  File: UD_Modifier_WMA
    Device can manifest more devices when damaged with weapon

    NameFull:   Manifest on weapon hit
    NameAlias:  WMA

    Parameters in DataStr:
        [0]     (optional) Base probability to summon devices when taking damage, proportional to the damage taken.
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
        0.1,1,FIRST     One device may be summoned with a 0.1% probability per point of damage. The first suitable device from the 
                        list in Form1 will be selected, starting from the top one.
        0.1,5,F,R       Five devices may be summoned with a 0.1% probability per point of damage. First the matching devices will be 
                        selected from the list in Form1, and then the remaining number will be selected randomly from the 
                        list in Form2.
/;
Scriptname UD_Modifier_WMA extends UD_Modifier_Manifest

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

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_WMA::WeaponHit() akDevice = " + akDevice + ", akWeapon = " + akWeapon + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    Float loc_prob = GetStringParamFloat(aiDataStr, 0)
    Float loc_damage = iRange(akWeapon.GetBaseDamage(), 5, 100)
    If RandomFloat(0.0, 100.0) < loc_prob * loc_damage * _DebugDamageMutliplier
        Manifest(akDevice, aiDataStr, akForm1, akForm2, akForm3)
    EndIf

EndFunction
