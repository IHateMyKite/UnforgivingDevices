;   File: UD_ModTrigger
;   This is base script of all triggers
Scriptname UD_ModTrigger extends Form

import UnforgivingDevicesMain
import UD_Native

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty
UD_Libs Property UDlibs Hidden
    UD_Libs Function Get()
        return UDmain.UDlibs
    EndFunction
EndProperty
UDCustomDeviceMain Property UDCDmain Hidden
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_CustomDevices_NPCSlotsManager Property UDNPCM
    UD_CustomDevices_NPCSlotsManager Function get()
        return UDmain.UDNPCM
    EndFunction
EndProperty
zadlibs Property libs
    zadlibs Function get()
        return UDmain.libs
    EndFunction
EndProperty


;/  Variable: NameFull
    Full name of the modifier which is shown to the player
/;
String      Property NameFull               Auto

;/  Variable: Description
    Additional info shown to player when selecting modifier on device
/;
String      Property Description            Auto

;/  Variable: UserDifficultyMultiplier
    Multiplier which can be used to allow user to change difficulty of modifier.
    
    Have to be implemented manually at a correct place
    
    The bigger this will, the more punishing/rewarding should modifier be
    
    This will affect even equipped devices
/;
Float       Property UserDifficultyMultiplier   = 1.0   Auto hidden

;/  Variable: PatchPowerMultiplier
    Multiplier which can be used to allow user to change power at which are modifiers added by patcher
    
    This will not affect already equipped devices
/;
Float       Property PatchPowerMultiplier       = 1.0   Auto hidden

;/  Variable: PatchChanceMultiplier
    Multiplier which can be used to allow user to change cahnce that modifier will be added to patched device
/;
Float       Property PatchChanceMultiplier      = 1.0   Auto hidden


;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function GameLoaded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    Return False
EndFunction

Bool Function TimeUpdateSecond(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr)
    Return False
EndFunction

Bool Function TimeUpdateHour(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr)
    Return False
EndFunction

Bool Function Orgasm(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    Return False
EndFunction

Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    Return False
EndFunction

Bool Function DeviceUnlocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    Return False
EndFunction

Bool Function MinigameAllowed(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    return true
EndFunction

Bool Function MinigameStarted(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr)
    Return False
EndFunction

Bool Function MinigameEnded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr)
    Return False
EndFunction

Bool Function WeaponHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr)
    Return False
EndFunction

Bool Function SpellHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr)
    Return False
EndFunction

Bool Function SpellCast(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr)
    Return False
EndFunction

Bool Function ConditionLoss(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr)
    Return False
EndFunction

Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr)
    Return False
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    Return Description
EndFunction

;/  Function: TriggerOnValueChange

    This function is used to calculate and check probability to trigger on some value change with many options
    
    Parameters:
        akDevice                - Device with the modifier. Used to update its aiDataStr.
        asNameAlias             - Alias of the modifier. Used to update its aiDataStr.
        aiDataStr               - Parameters of the modifier.
        aiValueChange           - Change of the value.
        aiMinAccumIndex         - (index of the parameter in DataStr) Minimum accumulated value to trigger.
        aiBaseProbIndex         - (index of the parameter in DataStr) Base probability to trigger on call.
        aiValueProbIndex        - (index of the parameter in DataStr) Probability to trigger proportional to the value delta.
        aiAccumProbIndex        - (index of the parameter in DataStr) Probability to trigger proportional to the accumulated value
        aiRepeatIndex           - (index of the parameter in DataStr) Repeat flag.
        aiAccumIndex            - (index of the parameter in DataStr) Accumulated value. Resets after trigger.
        
    Returns:
        True if triggered
/;
Bool Function TriggerOnValueChange(UD_CustomDevice_RenderScript akDevice, String asNameAlias, String aiDataStr, Int aiValueAbs = -1, Int aiValueDelta = 0, Int aiMinAccumIndex = -1, Int aiBaseProbIndex = -1, Int aiValueProbIndex = -1, Int aiAccumProbIndex = -1, Int aiRepeatIndex = -1, Int aiAccumIndex = -1)   
    Int loc_accum_current = 0
    If aiAccumIndex >= 0
        loc_accum_current = GetStringParamInt(aiDataStr, aiAccumIndex, 0)
    EndIf
    If loc_accum_current < 0
        ; did it once with no repeat option
        Return False
    EndIf
    Float loc_base_prob = 100.0
    Float loc_value_prob = 0.0
    Float loc_accum_prob = 0.0
    Int loc_accum_needed = 0
    Bool loc_repeat = False
    
    If aiBaseProbIndex >= 0
        loc_base_prob = GetStringParamFloat(aiDataStr, aiBaseProbIndex, 100.0)
    EndIf
    If aiValueProbIndex >= 0
        loc_value_prob = GetStringParamFloat(aiDataStr, aiValueProbIndex, 0.0)
    EndIf
    If aiValueProbIndex >= 0
        loc_value_prob = GetStringParamFloat(aiDataStr, aiValueProbIndex, 0.0)
    EndIf
    If aiAccumProbIndex >= 0
        loc_accum_prob = GetStringParamFloat(aiDataStr, aiAccumProbIndex, 0.0)
    EndIf
    If aiMinAccumIndex >= 0
        loc_accum_needed = GetStringParamInt(aiDataStr, aiMinAccumIndex, 0)
    EndIf
    If aiRepeatIndex >= 0
        loc_repeat = GetStringParamInt(aiDataStr, aiRepeatIndex, 0) > 0
    EndIf
    If aiValueAbs >= 0
        loc_accum_current = aiValueAbs
    ElseIf aiValueDelta > 0
        loc_accum_current += aiValueDelta
    EndIf
    If loc_accum_current >= loc_accum_needed
        If aiAccumIndex >= 0
            If loc_repeat
                akDevice.editStringModifier(asNameAlias, aiAccumIndex, 0)
            Else
            ; did it once with no repeat option
                akDevice.editStringModifier(asNameAlias, aiAccumIndex, -1)
            EndIf
        EndIf
        Return (RandomFloat(0.0, 100.0) < loc_base_prob + loc_value_prob * aiValueDelta + loc_accum_current * loc_accum_prob)
    Else 
    ; not enough accumulated value
        If aiAccumIndex >= 0
            akDevice.editStringModifier(asNameAlias, aiAccumIndex, loc_accum_current)
        EndIf
        Return False
    EndIf
    Return False
EndFunction
