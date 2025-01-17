;   File: UD_ModTrigger
;   This is base script of all triggers
Scriptname UD_ModTrigger extends MiscObject Hidden

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
    Full name of the trigger which is shown to the player
/;
String      Property NameFull               Auto

;/  Variable: Description
    Additional info about trigger shown in the modifier description
/;
String      Property Description            Auto

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ValidateTrigger(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function GameLoaded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function TimeUpdateSeconds(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afHoursSinceLastCall, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function TimeUpdateHour(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afHoursSinceLastCall, String aiDataStr, Form akForm1)
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

Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Int aiEquipSlot, Form akSource, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function KillMonitor(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function ItemAdded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akSourceContainer, Bool abIsStolen, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function ItemRemoved(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akDestContainer, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function SkillIncreased(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asSkill, Int aiValue, String aiDataStr, Form akForm1)
    Return False
EndFunction

Bool Function Stance(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool[] aabStances, String aiDataStr, Form akForm1)
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    If Description
        loc_res += UDmain.UDMTF.Paragraph(Description, asAlign = "center")
    EndIf
    loc_res += UDmain.UDMTF.TableBegin(aiLeftMargin = 40, aiColumn1Width = 150)
    loc_res += GetParamsTableRows(akModifier, akDevice, aiDataStr, akForm1)
    loc_res += UDmain.UDMTF.TableEnd()
    loc_res += UDmain.UDMTF.LineGap()
    Return loc_res
EndFunction

String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
;    loc_res += UDmain.UDMTF.TableRowDetails("Name:", NameFull)
;    loc_res += UDmain.UDMTF.TableRowDetails("Param:", Param)
    Return loc_res
EndFunction

;/  Group: Protected methods
===========================================================================================
===========================================================================================
===========================================================================================
/;

Int Function MultInt(Float afValue, Float afMult)
    Return UD_Native.Round(afValue * afMult)
EndFunction

Float Function MultFloat(Float afValue, Float afMult)
    Return afValue * afMult
EndFunction

;/  Function: TriggerOnValueDelta

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
    If UDmain.TraceAllowed()
        UDmain.Log(Self + "::TriggerOnValueDelta() asNameAlias = " + asNameAlias + ", Probability = " + FormatFloat(afProbBase, 2) + "% + " + FormatFloat(afValueDelta, 2) + " * " + FormatFloat(afProbDelta, 2) + "% + " + FormatFloat(loc_accum_current, 2) + " * " + FormatFloat(afProbAccum, 2) + "%", 3)
    EndIf
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
    
    If UDmain.TraceAllowed()
        UDmain.Log(Self + "::TriggerOnValueDelta() asNameAlias = " + asNameAlias + ", Probability = " + FormatFloat(afProbBase, 2) + "% + (" + FormatFloat(afValueAbs, 2) + " - " + FormatFloat(loc_last_trigger_value, 2) + ") * " + FormatFloat(afProbAccum, 2) + "%", 3)
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

;/  Function: _IsValidForm
    Checks that the form fits the criteria of the specified filter
    
    Parameters:
        akFilter            - filter can be specified in several ways. The filter implemented 
                              for inventory events is taken as a basis.
                              If akFilter is a Form then akForm is checked by direct comparison.
                              If akFilter is a Keyword then it checks that akForm has the given keyword.
                              If akFilter is a FormList then akForm is checked against each element of the list 
                              in a way that depends on its type.
                              
        akForm              - form to check
/;
Bool Function _IsValidForm(Form akFilter, Form akForm)
    If akFilter as FormList
        FormList loc_fl = akFilter as FormList
        Int loc_i = loc_fl.GetSize()
        While loc_i > 0
            loc_i -= 1
            Form loc_f = loc_fl.GetAt(loc_i)
            If loc_f as Keyword 
                If akForm.HasKeyword(loc_f as Keyword)
                    Return True
                EndIf
            Else
                If akForm == loc_f
                    Return True
                EndIf
            EndIf            
        EndWhile
        Return False
    ElseIf akFilter as Keyword
        Return akForm.HasKeyword(akFilter as Keyword)
    Else
        Return akForm == akFilter
    EndIf
EndFunction
