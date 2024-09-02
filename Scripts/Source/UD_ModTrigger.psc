;   File: UD_ModTrigger
;   This is base script of all triggers
Scriptname UD_ModTrigger extends MiscObject

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


;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function GameLoaded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function TimeUpdateSecond(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function TimeUpdateHour(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function Orgasm(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function DeviceUnlocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function MinigameAllowed(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    return true
EndFunction

Bool Function MinigameStarted(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function MinigameEnded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function WeaponHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function SpellHit(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function SpellCast(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function ConditionLoss(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function Sleep(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function KillMonitor(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1)
    Return False
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Return Description
EndFunction

;/  Function: TriggerOnValueChange

    This function is used to calculate and check probability to trigger on some value change with many options
    
    Parameters:
        akDevice                - Device with the modifier. Used to update its aiDataStr
        asNameAlias             - Alias of the modifier. Used to update its aiDataStr
        aiDataStr               - String with modifier parameters
        afValueAbs              - Absolute value (-1.0 if not used)
        afValueDelta            - The change of the value (0.0 if not used)
        afMinAccum              - Minimum accumulated value to trigger
        afProbBase              - Base probability to trigger on call
        afProbDelta             - Probability to trigger is proportional to the value change (afValueDelta)
        afProbAccum             - Probability to trigger is proportional to the accumulated value
        abRepeat                - Repeat flag
        aiAccumParamIndex       - (index of the parameter in DataStr) Accumulated value in DataStr. Resets after trigger
        
    Returns:
        True if triggered
/;
Bool Function TriggerOnValueDelta(UD_CustomDevice_RenderScript akDevice, String asNameAlias, String aiDataStr, Float afValueDelta, Float afMinAccum = 0.0, Float afProbBase = 100.0, Float afProbDelta = 0.0, Float afProbAccum = 0.0, Bool abRepeat = False, Int aiAccumParamIndex = -1)
    Float loc_accum_current = 0
    If aiAccumParamIndex >= 0
        loc_accum_current = GetStringParamFloat(aiDataStr, aiAccumParamIndex, 0.0)
    EndIf
    If loc_accum_current < 0
        ; did it once with no repeat option
        Return False
    EndIf
    loc_accum_current += afValueDelta
    If loc_accum_current >= afMinAccum
        If RandomFloat(0.0, 100.0) < (afProbBase + afProbDelta * afValueDelta + afProbAccum * loc_accum_current)
            If aiAccumParamIndex >= 0
                If abRepeat
                    akDevice.editStringModifier(asNameAlias, aiAccumParamIndex, "0.0")
                Else
                ; did it once with no repeat option
                    akDevice.editStringModifier(asNameAlias, aiAccumParamIndex, "-1.0")
                EndIf
            EndIf
            Return True
        Else
            If aiAccumParamIndex >= 0
                akDevice.editStringModifier(asNameAlias, aiAccumParamIndex, FormatFloat(loc_accum_current, 2))
            EndIf
            Return False
        EndIf
    Else 
    ; not enough accumulated value
        If aiAccumParamIndex >= 0
            akDevice.editStringModifier(asNameAlias, aiAccumParamIndex, FormatFloat(loc_accum_current, 2))
        EndIf
        Return False
    EndIf
    Return False
EndFunction

;/  Function: TriggerOnValueAbs

    This function is used to calculate and check probability to trigger on some absolute value (positive, increased over time) with many options
    
    Parameters:
        akDevice                - Device with the modifier. Used to update its aiDataStr
        asNameAlias             - Alias of the modifier. Used to update its aiDataStr
        aiDataStr               - String with modifier parameters
        afValueAbs              - Absolute value
        afMinValue              - Minimum value to trigger
        afProbBase              - Base probability to trigger on call
        afProbAccum             - Probability to trigger is proportional to the value delta since the last trigger
        abRepeat                - Repeat flag
        aiLastTriggerValueIndex - (index of the parameter in DataStr) Last trigger value
        
    Returns:
        True if triggered
/;
Bool Function TriggerOnValueAbs(UD_CustomDevice_RenderScript akDevice, String asNameAlias, String aiDataStr, Float afValueAbs, Float afMinValue = 0.0, Float afProbBase = 100.0, Float afProbAccum = 0.0, Bool abRepeat = False, Int aiLastTriggerValueIndex = -1)
    Float loc_last_trigger_value = 0
    If aiLastTriggerValueIndex >= 0
        loc_last_trigger_value = GetStringParamFloat(aiDataStr, aiLastTriggerValueIndex, 0.0)
    EndIf
    If loc_last_trigger_value < 0
        ; did it once with no repeat option
        Return False
    EndIf

    If loc_last_trigger_value == 0
        loc_last_trigger_value = afValueAbs
    EndIf
    If afValueAbs >= afMinValue
        If RandomFloat(0.0, 100.0) < (afProbBase + afProbAccum * (afValueAbs - loc_last_trigger_value))
            If aiLastTriggerValueIndex >= 0
                If abRepeat
                    akDevice.editStringModifier(asNameAlias, aiLastTriggerValueIndex, FormatFloat(loc_last_trigger_value, 2))
                Else
                ; did it once with no repeat option
                    akDevice.editStringModifier(asNameAlias, aiLastTriggerValueIndex, "-1.0")
                EndIf
            EndIf
            Return True
        Else
            Return False
        EndIf
    Else 
        Return False
    EndIf
    Return False
EndFunction
