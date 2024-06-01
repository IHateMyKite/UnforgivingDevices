;/  File: UD_ModTrigger_SHitValue
    Triggers when hit with a spell

    NameFull: 
    NameAlias:  TSV

    Parameters in DataStr:
        [0]     Int     The cost of all spells that must hit the actor for the trigger to work
        
        [1]     Int     (optional) Repeat
                        Default value: 0 (False)
                        
        [2]     Int     (script) The cost of all spells that have hit the actor so far
                        If it is negative then trigger will never occur

    Example:

/;
ScriptName UD_ModTrigger_SHitValue extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function SpellHit(String asNameAlias, UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr)
    Int loc_cost_current = GetStringParamInt(aiDataStr, 2, 0)
    If loc_cost_current < 0
        Return False
    EndIf
    loc_cost_current += iRange(akSpell.GetMagickaCost(), 5, 100)
    Int loc_cost_needed = GetStringParamInt(aiDataStr, 0)
    If loc_cost_current >= loc_cost_needed
        If GetStringParamInt(aiDataStr, 1, 0) > 0
            akDevice.editStringModifier(asNameAlias, 2, 0)
        Else
            akDevice.editStringModifier(asNameAlias, 2, -1)
        EndIf
        Return True
    Else 
        akDevice.editStringModifier(asNameAlias, 2, loc_cost_current)
        Return False
    EndIf
EndFunction
