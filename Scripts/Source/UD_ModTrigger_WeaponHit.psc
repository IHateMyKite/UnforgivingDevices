;/  File: UD_ModTrigger_WeaponHit
    Triggers when hit with a weapon

    NameFull:   

    Parameters in DataStr:
        [0]     Int     (optional) Minimum accumulated damage to trigger
                        Default value: 0
        
        [1]     Float   (optional) Base probability to trigger (in %)
                        Default value: 100.0%
        
        [2]     Int     (optional) Probability to trigger is proportional to the hit damage (base weapon damage)
                        Default value: 0.0%
                        
        [3]     Int     (optional) Repeat
                        Default value: 0 (False)
                        
        [4]     Float   (script) Total damage recieved so far

    Example:

/;
Scriptname UD_ModTrigger_WeaponHit extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function WeaponHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_WeaponHit::WeaponHit() akModifier = " + akModifier + ", akDevice = " + akDevice + ", akWeapon = " + akWeapon + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    
    Int loc_damage = iRange(akWeapon.GetBaseDamage(), 5, 100)
    ; TODO: better damage calculation
    
    Float loc_min_dmg = GetStringParamFloat(aiDataStr, 0, 0.0)
    Float loc_prob_base = GetStringParamFloat(aiDataStr, 1, 100.0)
    Float loc_prob_delta = GetStringParamFloat(aiDataStr, 2, 0.0)
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 1) > 0
    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = loc_damage, afMinAccum = loc_min_dmg, afProbBase = loc_prob_base, afProbDelta = loc_prob_delta, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction
