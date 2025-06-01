;/  File: UD_Modifier_CheapLocks
    Devices locks can get randomely jammed over time or when wearer is attacked

    NameFull:   Cheap Locks
    NameAlias:  CLO

    Parameters in DataStr:
        [0]     Float       (optional) Chance to get jammed lock every hour
                            Default value: 0.0%

        [1]     Float       (optional) Chance to get jammed lock when hit with a weapon
                            Default value: 0.0%
                        
        [2]     Float       (optional) Chance that the lock will jam, proportional to the damage taken
                            Default value: 0.0% per damage point
/;
ScriptName UD_Modifier_CheapLocks extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    if !akDevice.HaveUnlockableLocks()
        return
    endif
    Float loc_chance_h = MultFloat(UD_Native.GetStringParamFloat(aiDataStr, 0, 0.0), MultProbabilities)
    If loc_chance_h <= 0.0
        Return
    EndIf
    Int loc_i = 0
    While loc_i < Math.Floor(afGameHoursSinceLastCall)
        akDevice.AddJammedLock(Round(loc_chance_h))
        loc_i += 1
    EndWhile
    If afGameHoursSinceLastCall - Math.Floor(afGameHoursSinceLastCall) > 0.01
        Int loc_prob = Round((1.0 - Math.Pow(0.01 * loc_chance_h, afGameHoursSinceLastCall - Math.Floor(afGameHoursSinceLastCall))) * 100)
        akDevice.AddJammedLock(loc_prob)
    EndIf
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If akWeapon == None || afDamage < 0.0
        Return
    EndIf
    Float loc_chance1 = MultFloat(UD_Native.GetStringParamFloat(aiDataStr, 1, 0.0), MultProbabilities)
    Float loc_chance2 = MultFloat(UD_Native.GetStringParamFloat(aiDataStr, 2, 0.0), MultProbabilities)
    If loc_chance1 + loc_chance2 * afDamage <= 0.0
        Return
    EndIf
    akDevice.AddJammedLock(MultInt(loc_chance1 + loc_chance2 * afDamage, MultOutputQuantities))
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Chance per hour:", FormatFloat(MultFloat(UD_Native.GetStringParamFloat(aiDataStr, 0, 0.0), MultProbabilities), 2) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Chance per hit:", FormatFloat(MultFloat(UD_Native.GetStringParamFloat(aiDataStr, 1, 0.0), MultProbabilities), 2) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Chance per dmg:", FormatFloat(MultFloat(UD_Native.GetStringParamFloat(aiDataStr, 2, 0.0), MultProbabilities), 2) + "%")
    Return loc_res
EndFunction