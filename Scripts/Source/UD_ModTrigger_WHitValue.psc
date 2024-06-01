;/  File: UD_ModTrigger_WHitValue
    Triggers when hit with a weapon

    NameFull: 
    NameAlias:  TWV

    Parameters in DataStr:
        [0]     Int     The total damage the actor must take for the trigger to work
        
        [1]     Int     (optional) Repeat
                        Default value: 0 (False)
        
        [2]     Int     (script) Cumulative damage the actor has taken so far
                        If it is negative then trigger will never occur

    Example:

/;
ScriptName UD_ModTrigger_WHitValue extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function WeaponHit(String asNameAlias, UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_WHitValue::WeaponHit() asNameAlias = " + asNameAlias + ", akDevice = " + akDevice + ", akWeapon = " + akWeapon + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    Int loc_dmg_current = GetStringParamInt(aiDataStr, 2, 0)
    If loc_dmg_current < 0
        Return False
    EndIf
    loc_dmg_current += iRange(akWeapon.GetBaseDamage(), 5, 100)
    Int loc_dmg_needed = GetStringParamInt(aiDataStr, 0)
    If loc_dmg_current >= loc_dmg_needed
        If GetStringParamInt(aiDataStr, 1, 0) > 0
            akDevice.editStringModifier(asNameAlias, 2, 0)
        Else
            akDevice.editStringModifier(asNameAlias, 2, -1)
        EndIf
        Return True
    Else 
        akDevice.editStringModifier(asNameAlias, 2, loc_dmg_current)
        Return False
    EndIf
EndFunction
