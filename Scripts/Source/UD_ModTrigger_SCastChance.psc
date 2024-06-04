;/  File: UD_ModTrigger_SCastChance
    Triggers when actor cast a spell

    NameFull:   
    NameAlias:  TWC

    Parameters in DataStr:
        [0]     Float   Base probability on cast
        
        [1]     Float   (optional) The weight of the spell cost in the final probability %
                        Default value: 0.0

    Example:

/;
Scriptname UD_ModTrigger_SCastChance extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function SpellCast(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr)
    Float loc_prob = GetStringParamFloat(aiDataStr, 0)
    Float loc_cost_weight = GetStringParamFloat(aiDataStr, 1, 0.0)
    Float loc_cost = iRange(akSpell.GetMagickaCost(), 5, 100)
    Return (RandomFloat(0.0, 100.0) < (loc_prob + loc_cost_weight * loc_cost))
EndFunction
