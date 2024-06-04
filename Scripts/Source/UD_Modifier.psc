;   File: UD_Modifier
;   This is base scripts of all modifiers
Scriptname UD_Modifier extends ReferenceAlias

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

;/  Variable: Multiplier
    Multiplier which can be used to allow user to change difficulty of modifier.
    
    Have to be implemented manually at a correct place
    
    The bigger this will, the more punishing/rewarding should modifier be
    
    This will affect even equipped devices
/;
Float       Property Multiplier                 = 1.0   Auto hidden

;/  Variable: PatchPowerMultiplier
    Multiplier which can be used to allow user to change power at which are modifiers added by patcher
    
    This will not affect already equipped devices
/;
Float       Property PatchPowerMultiplier       = 1.0   Auto hidden

;/  Variable: PatchChanceMultiplier
    Multiplier which can be used to allow user to change cahnce that modifier will be added to patched device
/;
Float       Property PatchChanceMultiplier      = 1.0   Auto hidden

;/  Variable: Attributes
    
    Additional modifier attributes to better customize their automatic generation.
    Used as a bitmask.
    
    0x0001          - positive modifier (determines in which direction the difficulty multiplier will be used)
    
/;
Int         Property Attributes                         Auto

;event hooks
String[]    Property EventHooks             Auto
String[]    Property EventHooks_Callback    Auto

Event RegisterEvents()
    ;int i = EventHooks.length
    ;while i
    ;    RegisterForModEvent(EventHooks[i],EventHooks_Callback[i])
    ;endwhile
EndEvent

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
;- TODO
Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    Return True
EndFunction

Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akModDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    return true
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice,String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "Name: " + NameFull + "\n\n"
    
    if Description
        loc_msg += "==Description==" + "\n"
        loc_msg += Description
    endif
    
    UDmain.ShowMessageBox(loc_msg)
EndFunction

String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    Return NameFull
EndFunction

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    return false
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
EndFunction

Function RerollModifierStats(UD_CustomDevice_RenderScript akDevice, String aiDataStr)
EndFunction
