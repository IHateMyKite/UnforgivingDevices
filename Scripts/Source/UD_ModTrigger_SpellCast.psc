;/  File: UD_ModTrigger_SpellCast
    It triggers when actor cast a spell

    NameFull: On Spell Cast

    Parameters in DataStr:
        [0]     Int     (optional) Minimum accumulated cost to trigger
                        Default value: 0
        
        [1]     Float   (optional) Base probability to trigger (in %)
                        Default value: 100.0%
        
        [2]     Int     (optional) Probability to trigger is proportional to the spell cost
                        Default value: 0.0%
                        
        [3]     Int     (optional) Repeat
                        Default value: 0 (False)
                        
        [4]     Float   (script) Total mana spent so far

    Example:

/;
Scriptname UD_ModTrigger_SpellCast extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ValidateTrigger(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    EventProcessingMask = 0x00000400
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function SpellCast(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_SpellCast::SpellCast() akModifier = " + akModifier + ", akDevice = " + akDevice + ", akSpell = " + akSpell + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    Int loc_cost = iRange(akSpell.GetMagickaCost(), 5, 100)
    ; TODO: better cost calculation
    
    Float loc_min_cost = GetStringParamFloat(aiDataStr, 0, 0.0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_delta = GetStringParamFloat(aiDataStr, 2, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 0) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = loc_cost, afMinAccum = loc_min_cost, afProbBase = loc_prob_base, afProbDelta = loc_prob_delta, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_str = ""
    loc_str += "On spell cast (value is the base mana cost)"
    loc_str += "\n"
    loc_str += "Threshold value: " + GetStringParamInt(aiDataStr, 0, 0) + " mana"
    loc_str += "\n"
    loc_str += "Base probability: " + FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 2) + "%"
    loc_str += "\n"
    loc_str += "Value weight: " + FormatFloat(GetStringParamFloat(aiDataStr, 2, 0.0), 2) + "% per mana point"
    loc_str += "\n"
    If GetStringParamInt(aiDataStr, 3, 0) > 0
        loc_str += "Repeat: True"
    Else
        loc_str += "Repeat: False"
    EndIf
    loc_str += "\n"
    loc_str += "Accumulator: " + GetStringParamInt(aiDataStr, 4, 0) + " mana"
    loc_str += "\n"
    loc_str += "(Accumulator contains the total mana spent so far)"
    
    Return loc_str
EndFunction
