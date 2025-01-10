;/  File: UD_ModTrigger_WeaponHit
    It triggers when actor is hit with a weapon

    NameFull: On Weapon Hit

    Parameters in DataStr:
        [0]     Int         (optional) Minimum accumulated damage to trigger
                            Default value: 0

        [1]     Float       (optional) Base probability to trigger (in %)
                            Default value: 100.0%

        [2]     Float       (optional) Probability to trigger is proportional to the hit damage
                            Default value: 0.0%

        [3]     Float       (optional) Probability to trigger that is proportional to the accumulated value (total damage recieved)
                            Default value: 0.0%

        [4]     Int         (optional) Repeat
                            Default value: 0 (False)

        [5]     Float       (script) Total damage recieved so far

    Example:
        200,,,,,,           It will trigger once on the first hit after the wearer has recieved a total of 200 dmg.
        0,50,,,1,,          It will trigger with a 50% probability on each hit.
        0,10,1.0,0.1,1,,    It will trigger at each hit with a probability calculated by the formula: 10% + <dmg> * 1.0% + <dmg recieved since the last trigger> * 0.1%.
/;
Scriptname UD_ModTrigger_WeaponHit extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function WeaponHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_WeaponHit::WeaponHit() akModifier = " + akModifier + ", akDevice = " + akDevice + ", akWeapon = " + akWeapon + ", afDamage = " + afDamage + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    If afDamage <= 0.0
        Return False
    EndIf
    Int loc_min_dmg = GetStringParamInt(aiDataStr, 0, 0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_delta = GetStringParamFloat(aiDataStr, 2, 0.0)
    Float loc_prob_acc = GetStringParamFloat(aiDataStr, 3, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 4, 0) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afDamage, afMinAccum = loc_min_dmg, afProbBase = loc_prob_base, afProbDelta = loc_prob_delta, afProbAccum = loc_prob_acc, abRepeat = loc_repeat, aiAccumParamIndex = 5)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:", GetStringParamInt(aiDataStr, 0, 0) + " dmg")
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Value weight:", FormatFloat(GetStringParamFloat(aiDataStr, 2, 0.0), 2) + "% per dmg point")
    loc_res += UDmain.UDMTF.TableRowDetails("Accum weight:", FormatFloat(GetStringParamFloat(aiDataStr, 3, 0.0), 2) + "% total dmg")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(GetStringParamInt(aiDataStr, 4, 0) > 0, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:", GetStringParamInt(aiDataStr, 5, 0) + " dmg")
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains the total physical damage recieved so far)", asAlign = "center")
    Return loc_res
EndFunction