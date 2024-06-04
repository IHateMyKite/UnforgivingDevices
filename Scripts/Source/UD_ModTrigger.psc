;   File: UD_ModTrigger
;   This is base script of all triggers
Scriptname UD_ModTrigger extends Form

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

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    Return Description
EndFunction
