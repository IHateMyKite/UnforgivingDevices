;/  File: UD_Modifier_CheapLocks
    Devices locks can get randomely jammed over time or when wearer is attacked

    NameFull:   Cheap Locks
    NameAlias:  CLO

    Parameters:
        [0]     Float   (optional) Chance to get jammed lock every hour
                        Default value: 0.0

        [1]     Float   (optional) Chance to get jammed lock when hit with a weapon
                        Default value: 0.0
                        
        [2]     Float   (optional) Chance that the lock will jam, proportional to the damage taken
                        Default value: 0.0 per damage point
/;
ScriptName UD_Modifier_CheapLocks extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Update()
    EventProcessingMask = Math.LogicalOr(0x00000002, 0x00000020)
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    if !akDevice.HaveUnlockableLocks()
        return
    endif
    Float loc_chance_h = UD_Native.GetStringParamFloat(aiDataStr, 0, 0.0) * Multiplier
    If loc_chance_h <= 0.0
        Return
    EndIf
    Int loc_i = 0
    While loc_i < Math.Floor(afMult)
        akDevice.AddJammedLock(Round(loc_chance_h))
        loc_i += 1
    EndWhile
    If afMult - Math.Floor(afMult) > 0.01
        Int loc_prob = Round((1.0 - Math.Pow(0.01 * loc_chance_h, afMult - Math.Floor(afMult))) * 100)
        akDevice.AddJammedLock(loc_prob)
    EndIf
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If akWeapon == None || afDamage < 0.0
        Return
    EndIf
    Float loc_chance1 = UD_Native.GetStringParamFloat(aiDataStr, 1, 0.0)
    Float loc_chance2 = UD_Native.GetStringParamFloat(aiDataStr, 2, 0.0)
    If loc_chance1 + loc_chance2 <= 0.0
        Return
    EndIf
    akDevice.AddJammedLock(Round((loc_chance1 + loc_chance2 * afDamage) * Multiplier))
EndFunction

String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Chance per hour: " + FormatFloat(fRange(UD_Native.GetStringParamFloat(aiDataStr, 0, 0.0) * Multiplier, 0.0, 100.0), 2) + " %\n"
    loc_msg += "Chance per hit: " + FormatFloat(fRange(UD_Native.GetStringParamFloat(aiDataStr, 1, 0.0) * Multiplier, 0.0, 100.0), 2) + " %\n"
    loc_msg += "Chance per dp: " + FormatFloat(fRange(UD_Native.GetStringParamFloat(aiDataStr, 2, 0.0) * Multiplier, 0.0, 100.0), 2) + " %\n"

    loc_msg += "\n"
    loc_msg += "=== Description ===\n"
    loc_msg += Description + "\n"

    Return loc_msg
EndFunction

;/  Group: Patcher overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function PatchModifierFastCheckOverride(UD_CustomDevice_RenderScript akDevice)
    Return (akDevice.GetLockNumber() > 0)
EndFunction
