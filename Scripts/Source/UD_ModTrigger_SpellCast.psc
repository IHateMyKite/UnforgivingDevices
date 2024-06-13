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

Bool Function SpellCast(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr)
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
