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

        [3]     Int         (optional) Repeat
                            Default value: 0 (False)

        [4]     Float       (script) Total damage recieved so far

    Example:

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
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 0) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afDamage, afMinAccum = loc_min_dmg, afProbBase = loc_prob_base, afProbDelta = loc_prob_delta, abRepeat = loc_repeat, aiAccumParamIndex = 4)
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
    loc_res += UDmain.UDMTF.TableRowDetails("Value weight:", FormatFloat(GetStringParamFloat(aiDataStr, 2, 0.0), 1) + "% per dmg point")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(GetStringParamInt(aiDataStr, 3, 0) > 0, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:", GetStringParamInt(aiDataStr, 4, 0) + " dmg")
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains the total physical damage recieved so far)", asAlign = "center")
    Return loc_res
EndFunction