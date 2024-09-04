;   File: UD_Modifier
;   This is base scripts of all modifiers
Scriptname UD_Modifier extends ReferenceAlias Hidden

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

;/  Group: Variables
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: NameFull
    Full name of the modifier which is shown to the player
/;
String      Property NameFull               Auto

;/  Variable: NameAlias
    Short name of the modifier which is used internaly (MAO for example if full name if Manifest At Orgasm)
/;
String      Property NameAlias              Auto

;/  Variable: Description
    Additional info shown to player when selecting modifier on device
/;
String      Property Description            Auto

Int         Property ConcealmentPower  = 0  Auto

;/  Variable: Description
    Additional info shown to player when selecting modifier on device
/;
String      Property Tags                   Auto

;/  Variable: Multiplier
    Multiplier which can be used to allow user to change difficulty of modifier.
    
    Have to be implemented manually at a correct place
    
    The bigger this will, the more punishing/rewarding should modifier be
    
    This will affect even equipped devices
/;
Float       Property Multiplier                 = 1.0   Auto Hidden

;/  Variable: ConcealmentPower

    Value between 0 and 100

    TODO:
    
    The degree to which the modifier resists recognition.
    If the degree is 0, the character will easily reveal the modifier's properties.
    If the degree of concealment is higher than the character's abilities, then 
    information about the modifier will not be visible.
/;
;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
;- TODO
Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akModDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    return true
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice,String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function StatEvent(UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function Sleep(UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function KillMonitor(UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    If ConcealmentPower > 50
        loc_msg += "Name: ??? \n\n"
        loc_msg += "==Description==" + "\n"
        loc_msg += "You are unable to recognize this enchantment"
    Else
        loc_msg += "Name: " + NameFull + "\n\n"
        
        if Description
            loc_msg += "==Description==" + "\n"
            loc_msg += Description
        endif
    EndIf
    
    UDmain.ShowMessageBox(loc_msg)
EndFunction

String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    ; TODO: implement proper use of the ConcealmentPower
    If ConcealmentPower > 50
        Return "???"
    Else
        Return NameFull
    EndIf
EndFunction

;/  Group: Patcher
===========================================================================================
===========================================================================================
===========================================================================================
/;

; Quickly check the applicability of a modifier without considering dependencies and conflicts. 
; Used for approximate calculation of the upper limit for the number of available mods
; Could be overriden for more accurate calculation
Bool Function PatchModifierFastCheck(UD_CustomDevice_RenderScript akDevice)
    ; get random preset
    UD_Patcher_ModPreset loc_preset = (Self as ReferenceAlias) as UD_Patcher_ModPreset
    Return (loc_preset != None) && loc_preset.FastCheckDevice(akDevice) && PatchModifierFastCheckOverride(akDevice)
EndFunction

; Carefully check the compatibility of the modifier and try to add it taking into account the given probabilities
Bool Function PatchModifierCheckAndAdd(UD_CustomDevice_RenderScript akDevice, Int aiSoftCap, Int aiValidMods, Float afGlobalProbabilityMult = 1.0, Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityEasing = 1.0)
    UD_Patcher_ModPreset loc_preset = _GetBestPatcherPreset(akDevice)
    If loc_preset == None 
        Return False
    EndIf
    Float loc_prob = loc_preset.BaseProbability
    ; Adjust the probability with the soft limit if it is allowed in the preset settings
    If loc_prob > 0.0 && loc_preset.IsNormalizedProbability
        aiValidMods = UD_Native.iRange(aiValidMods, 1, 99)
        aiSoftCap = UD_Native.iRange(aiSoftCap, 0, 99)
        loc_prob *= (aiSoftCap as Float) / (aiValidMods as Float)
    EndIf
    
    loc_prob *= PatchModifierCheckAndAddOverride(akDevice)
    loc_prob *= afGlobalProbabilityMult
    
    If UD_Native.RandomFloat(0.0, 100.0) < loc_prob
        akDevice.AddModifier(Self, loc_preset.GetDataStr(afGlobalSeverityShift, afGlobalSeverityEasing), loc_preset.GetForm1(afGlobalSeverityShift, afGlobalSeverityEasing), loc_preset.GetForm2(afGlobalSeverityShift, afGlobalSeverityEasing), loc_preset.GetForm3(afGlobalSeverityShift, afGlobalSeverityEasing), loc_preset.GetForm4(afGlobalSeverityShift, afGlobalSeverityEasing), loc_preset.GetForm5(afGlobalSeverityShift, afGlobalSeverityEasing))
        Return True
    Else
        Return False
    EndIf
EndFunction

; Overrides
Bool Function PatchModifierFastCheckOverride(UD_CustomDevice_RenderScript akDevice)
    Return True
EndFunction

Float Function PatchModifierCheckAndAddOverride(UD_CustomDevice_RenderScript akDevice)
    Return 1.0
EndFunction

; Private methods
UD_Patcher_ModPreset Function _GetBestPatcherPreset(UD_CustomDevice_RenderScript akDevice)
    UD_Patcher_ModPreset loc_preset1 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset1) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset2 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset2) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset3 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset3) as UD_Patcher_ModPreset
    
    UD_Patcher_ModPreset loc_result = None
    Int loc_priority = -10
    
    If loc_preset1
        Int loc_temp = loc_preset1.CheckDevice(akDevice)
        If loc_temp > loc_priority
            loc_priority = loc_temp
            loc_result = loc_preset1
        EndIf
    EndIf
    
    If loc_preset2
        Int loc_temp = loc_preset2.CheckDevice(akDevice)
        If loc_temp > loc_priority
            loc_priority = loc_temp
            loc_result = loc_preset2
        EndIf
    EndIf
    
    If loc_preset3
        Int loc_temp = loc_preset3.CheckDevice(akDevice)
        If loc_temp > loc_priority
            loc_priority = loc_temp
            loc_result = loc_preset3
        EndIf
    EndIf
    
    If loc_priority > 0
        Return loc_result
    Else
        Return None
    EndIf
    
EndFunction
