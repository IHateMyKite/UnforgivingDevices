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

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Chance per hour: " + iRange(Round(UD_Native.GetStringParamFloat(aiDataStr, 0, 0.0) * Multiplier), 0, 100) + " %\n"
    loc_msg += "Chance per hit: " + iRange(Round(UD_Native.GetStringParamFloat(aiDataStr, 1, 0.0) * Multiplier), 0, 100) + " %\n"
    loc_msg += "Chance per dp: " + iRange(Round(UD_Native.GetStringParamFloat(aiDataStr, 2, 0.0) * Multiplier), 0, 100) + " %\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction

;/  Group: Patcher overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function PatchModifierFastCheckOverride(UD_CustomDevice_RenderScript akDevice)
    Return (akDevice.GetLockNumber() > 0)
EndFunction

; obsolete
Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    String loc_p1 = FormatFloat(fRange(RandomFloat(5.0, 15.0) * PatchPowerMultiplier, 0.0, 100.0), 1)
    ; negative values to enforce 0 with some probability
    String loc_p2 = FormatFloat(fRange(RandomFloat(-5.0, 5.0) * PatchPowerMultiplier, 0.0, 100.0), 1)
    String loc_p3 = FormatFloat(fRange(RandomFloat(-1.0, 1.0) * PatchPowerMultiplier, 0.0, 100.0), 1)
    akDevice.addModifier(self, loc_p1 + "," + loc_p2 + "," + loc_p3)
EndFunction
