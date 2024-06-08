;/  File: UD_ModTrigger_StatEvent
    It triggers on the change of statistics value
    
    NameFull: Statistics
    
    Parameters (DataStr):
        [0]     String  Stat event to trigger
                            See https://ck.uesp.net/wiki/ListOfTrackedStats
                            Not all of those stats are working
                            
        [1]     Int     (optional) Minimum accumulated stat value to trigger
                        Default value: 0 (chance on every call)
        
        [2]     Float   (optional) Probability to trigger on event in %
                        Default value: 100.0%
                        
        [3]     Int     (optional) Repeat
                        Default value: 0 (False)
                        
        [4]     Int     (script) Accumulated delta so far

    Example:
        Locks Picked,10,,1      - Triggers on every 10th lock picked
        Intimidations,,10       - Triggers on intimidation with 10% probability
        
    Stat works:
            asStatName                          aiStatValue
        Quests Completed                        ??? (MS13 => 11)
        Skill Increases                         <Actor Value IDs> (https://ck.uesp.net/wiki/ActorValueInfo_Script#Actor_Value_IDs)
        Whiterun Bounty                         <Bounty Value>
        Locks Picked                            <Number of locks>
        Misc Objectives Completed               ???
/;
Scriptname UD_ModTrigger_StatEvent extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_StatEvent::StatEvent() akModifier = " + akModifier + ", akDevice = " + akDevice + ", asStatName = " + asStatName + ", aiStatValue = " + aiStatValue + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    If asStatName != GetStringParamString(aiDataStr, 0, "")
        Return False
    EndIf
    Int loc_min_value = GetStringParamInt(aiDataStr, 1, 0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 2, 100.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 0) > 0
    
    Return TriggerOnValueAbs(akDevice, akModifier.NameAlias, aiDataStr, afValueAbs = aiStatValue, afMinValue = loc_min_value, afProbBase = loc_prob_base, abRepeat = loc_repeat, aiLastTriggerValueIndex = 4)
EndFunction
