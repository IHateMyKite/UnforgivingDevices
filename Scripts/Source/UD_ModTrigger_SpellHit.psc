;/  File: UD_ModTrigger_SpellHit
    It triggers when actor is hit with a spell

    NameFull: On Spell Hit

    Parameters in DataStr:
        [0]     Int     (optional) Minimum accumulated damage to trigger
                        Default value: 0
        
        [1]     Float   (optional) Base probability to trigger (in %)
                        Default value: 100.0%
        
        [2]     Int     (optional) Probability to trigger is proportional to the spell damage
                        Default value: 0.0%
                        
        [3]     Int     (optional) Repeat
                        Default value: 0 (False)
                        
        [4]     Float   (script) Total damage recieved so far

    Example:

/;
Scriptname UD_ModTrigger_SpellHit extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function SpellHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage, String aiDataStr, Form akForm1)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_SpellHit::SpellHit() akModifier = " + akModifier + ", akDevice = " + akDevice + ", akSpell = " + akSpell + ", afDamage = " + afDamage + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    If afDamage <= 0.0
        Return False
    EndIf    
    Float loc_min_dmg = GetStringParamFloat(aiDataStr, 0, 0.0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_delta = GetStringParamFloat(aiDataStr, 2, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 0) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afDamage, afMinAccum = loc_min_dmg, afProbBase = loc_prob_base, afProbDelta = loc_prob_delta, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_str = ""
    loc_str += "On spell hit taken (value is the damage or so)"
    loc_str += "\n"
    loc_str += "Threshold value: " + FormatFloat(GetStringParamFloat(aiDataStr, 0, 0.0), 2) + " dmg"
    loc_str += "\n"
    loc_str += "Base probability: " + FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 2) + "%"
    loc_str += "\n"
    loc_str += "Value weight: " + FormatFloat(GetStringParamFloat(aiDataStr, 2, 0.0), 2) + "% per dmg point"
    loc_str += "\n"
    If GetStringParamInt(aiDataStr, 3, 0) > 0
        loc_str += "Repeat: True"
    Else
        loc_str += "Repeat: False"
    EndIf
    loc_str += "\n"
    loc_str += "Accumulator: " + FormatFloat(GetStringParamFloat(aiDataStr, 4, 0.0), 2) + " dmg"
    loc_str += "\n"
    loc_str += "(Accumulator contains the total magical damage recieved so far)"
    
    Return loc_str
EndFunction