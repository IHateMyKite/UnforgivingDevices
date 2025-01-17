;/  File: UD_ModTrigger_Condition
    It triggers with a given chance when the condition of the device is worsened
    
    NameFull: On Condition Loss
    
    Parameters in DataStr:
        [0]     Int         (optional) Triggers when the condition of a device falls below given threshold
                                0 - "Excellent"
                                1 - "Good"
                                2 - "Normal"
                                3 - "Bad"
                                4 - "Destroyed"
                            Default value: 0 (Always)

        [1]     Float       (optional) Base probability to trigger on call (in %)
                            Default value: 100.0% (Always)
                        
        [2]     Float       (optional) Probability that proportional to the absolute value (device condition) (in %)
                            Default value: 0.0%
        
        [3]     Int         (optional) Repeat
                            Default value: 0 (False)

    Example:
        1           - triggers once the condition becomes "good" or worse
        0,50,0,1    - can trigger with a 50% probability each time the device deteriorates
        2,0,10,0    - can trigger once on "normal" or worse condition with increased probability on every step down
                        normal  -> 2*10 = 20% probability
                        bad     -> 3*10 = 30% probability

/;
Scriptname UD_ModTrigger_Condition extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function ConditionLoss(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1)
    If aiCondition > 3
    ; ignoring "destroyed" state. Use UD_ModTrigger_SimpleEvent + DeviceBroken instead.
        Return False
    EndIf
    Int loc_min_condition = iRange(MultInt(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities), 0, 4)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_value = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 0) > 0
    Return TriggerOnValueAbs(akDevice, akModifier.NameAlias, aiDataStr, afValueAbs = aiCondition, afMinValue = loc_min_condition, afProbBase = loc_prob_base, afProbAccum = loc_prob_value, abRepeat = loc_repeat)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Int loc_min_condition = iRange(MultInt(GetStringParamInt(aiDataStr, 0, 0), akModifier.MultInputQuantities), 0, 4)
    Float loc_prob_base = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    Float loc_prob_value = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:", UDCDMain.GetConditionString(loc_min_condition))
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Cur. value weight:", FormatFloat(loc_prob_value, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(GetStringParamInt(aiDataStr, 3, 0) > 0, "True", "False"))
    Return loc_res
EndFunction