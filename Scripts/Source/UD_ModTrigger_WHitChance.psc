;/  File: UD_ModTrigger_WHitChance
    Triggers when hit with a weapon

    NameFull:   
    NameAlias:  TWC

    Parameters in DataStr:
        [0]     Float   Base probability on hit
        
        [1]     Float   (optional) The weight of the base weapon damage in the final probability
                        Default value: 0.0

    Example:

/;
Scriptname UD_ModTrigger_WHitChance extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function WeaponHit(String asNameAlias, UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr)
    Float loc_prob = GetStringParamFloat(aiDataStr, 0)
    Float loc_dmg_weight = GetStringParamFloat(aiDataStr, 1, 0.0)
    Float loc_dmg = iRange(akWeapon.GetBaseDamage(), 5, 100)
    Return (RandomFloat(0.0, 100.0) < (loc_prob + loc_dmg * loc_dmg_weight))
EndFunction
