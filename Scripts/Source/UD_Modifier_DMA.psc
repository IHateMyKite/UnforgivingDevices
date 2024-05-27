;/  File: UD_Modifier_DMA
    Device can manifest another device when damaged

    NameFull:   Manifest when damaged
    NameAlias:  DMA

    Parameters:
        0 = (optional) Monitored event
            HIT - Weapon hit (proportional to base damage)
            COND - Condition loss
            Default = HIT
            
        1 = (optional) Amount of value required to manifest
            [HIT]       Weapon hit      -> Chance in % to evolve in proportion to the damage taken (weapon base damage) [default 0.1]
            [COND]      Condition lost  -> Chance to evolve in % after device condition loss [default 10.0]
            
        2   (optional) Manifestation mode
            FIRST   - first suitable device from the list
            RANDOM  - random device from the list
            default = RANDOM
            
        3   (optional) Number of devices
            default = 1

    Form arguments:
        Form1 - Device to manifest. In case this is formlist, random device from formlist will be used.
        Form2 - Device to manifest. In case this is formlist, random device from formlist will be used.
        Form3 - Device to manifest. In case this is formlist, random device from formlist will be used.
    In case more than one FormX is filled, random one will be choosen

    Example:
        HIT,1,FIRST,1         = Can manifest a device with a 10% chance after receiving 10 point damage. It chooses one first device from the list provided
        COND,10,RANDOM,2      = Can manifest a device with a 10% chance after condition loss. It chooses two random devices from the list provided
/;
Scriptname UD_Modifier_DMA extends UD_Modifier_Manifest

import UnforgivingDevicesMain
import UD_Native
          
Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    ; check if another manifest modifier is already preset
    ; Only one of these should be not present on device at the same time
    if akDevice.HasModifier("OMA") || akDevice.HasModifier("HMA")
        return false
    endif

    ;TODO - make native function for easier filtering device types
    Bool loc_res = True
    ; TODO: device filter
    return loc_res && (RandomInt(1,100) < 30*PatchChanceMultiplier)
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    akDevice.addModifier(self,iRange(Round(RandomInt(2,8)*PatchPowerMultiplier),0,100) + "," + RandomInt(1,3))
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_DMA::WeaponHit() akDevice = " + akDevice + ", akWeapon = " + akWeapon + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    String loc_type = UD_Native.GetStringParamString(aiDataStr, 0, "HIT")
    if loc_type == "HIT"
        Float loc_value = UD_Native.GetStringParamFloat(aiDataStr, 1, 0.1)
        Float loc_damage = iRange(akWeapon.GetBaseDamage(), 5, 100)
        If UDmain.TraceAllowed()
            UDmain.Log("UD_Modifier_DMA::WeaponHit() loc_value = " + loc_value + ", loc_damage = " + loc_damage, 3)
        EndIf
        If RandomFloat(0.0, 10.0) < loc_value * loc_damage
            Bool loc_rnd = UD_Native.GetStringParamString(aiDataStr, 2, "RANDOM") == "RANDOM"
            Int loc_count = UD_Native.GetStringParamInt(aiDataStr, 3, 1)
            Manifest(akDevice, aiDataStr, akForm1, akForm2, akForm3, loc_rnd, loc_count)
        EndIf
    endif
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_DMA::ConditionLoss() akDevice = " + akDevice + ", aiCondition = " + aiCondition + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    String loc_type = UD_Native.GetStringParamString(aiDataStr, 0, "HIT")
    if loc_type == "COND"
    ; TODO: (as an option) worse condition, better odds
        Float loc_value = UD_Native.GetStringParamFloat(aiDataStr, 1, 10.0)
        If RandomFloat(0.0, 100.0) < loc_value
            Bool loc_rnd = UD_Native.GetStringParamString(aiDataStr, 2, "RANDOM") == "RANDOM"
            Int loc_count = UD_Native.GetStringParamInt(aiDataStr, 3, 1)
            Manifest(akDevice, aiDataStr, akForm1, akForm2, akForm3, loc_rnd, loc_count)
        EndIf
    endif
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Chance: " + FormatFloat(GetStringParamFloat(aiDataStr, 1, 0.1), 2) + " %\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction

