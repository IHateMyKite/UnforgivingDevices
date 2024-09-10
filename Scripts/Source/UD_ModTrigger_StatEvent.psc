;/  File: UD_ModTrigger_StatEvent
    It triggers on the change of statistics value
    
    NameFull: On Statistics Change
    
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
        Quests Completed,,10    - Triggers on completed quest with 10% probability
        
    Stats:
            asStatName                          aiStatValue
        Locations Discovered                    (total number)
        Quests Completed                        (total number of completed quests)
        Skill Increases                         <Actor Value IDs> (https://ck.uesp.net/wiki/ActorValueInfo_Script#Actor_Value_IDs)
        Whiterun Bounty                         <Bounty Value>
        Locks Picked                            (total number)
        Misc Objectives Completed               (total number)
        Skill Book Read                         (total number)
        Armor Made                              (total number)
        Dungeons Cleared                        (total number)
        Locations Discovered                    (total number)
        Most Gold Carried                       (subj)
        Level Increases                         (current accepted level)
        Weapons Made                            (total number)
        Armor Made                              (total number)
        Pockets Picked                          (total number of items, and 1 gold counts as 1 item)

        IT JUST WORKS (nope)

        Weapons Improved                        NOPE
        Training Sessions                       NOPE
        Potions Used                            NOPE
        Food Eaten                              NOPE
        Ingredients Harvested                   NOPE
        Ingredients Eaten                       NOPE
        Persuasions                             NOPE
        Hours Waiting                           NOPE
        Times Shouted                           NOPE
        Gold Found                              NOPE
        Murders                                 NOPE
        Assaults                                PROBABLY NOT
        Bunnies Slaughtered                     NOPE
/;
Scriptname UD_ModTrigger_StatEvent extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ValidateTrigger(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    EventProcessingMask = 0x00001000
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1)
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

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    String loc_str = ""
    loc_str += "On stat event (" + loc_event + ")"
    loc_str += "\n"
    loc_str += "Minimum accumulated value: " + GetStringParamInt(aiDataStr, 1, 0)
    loc_str += "\n"
    loc_str += "Base probability: " + FormatFloat(GetStringParamFloat(aiDataStr, 2, 100.0), 2) + "%"
    loc_str += "\n"
    If GetStringParamInt(aiDataStr, 3, 0) > 0
        loc_str += "Repeat: True"
    Else
        loc_str += "Repeat: False"
    EndIf
    loc_str += "\n"
    loc_str += "Accumulator: " + GetStringParamInt(aiDataStr, 4, 0)
    loc_str += "\n"
    loc_str += "(Accumulator contains stat change since the last trigger)"
    
    Return loc_str
EndFunction
