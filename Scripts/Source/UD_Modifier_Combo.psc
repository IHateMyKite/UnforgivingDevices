;/  File: UD_Modifier_Combo
    Something will happen when all conditions are met. 
    Use modifiers with different aliases if you want to add several CMB modifiers on the same device

    NameFull: 
    NameAlias: CMB1, CMB2, CMB3

    Parameters:
        [0 .. 4]    Parameters for the trigger
        
        [5 .. n]    Parameters for the outcome

    Form arguments:
        Form1 - Trigger UD_ModTrigger
        Form2 - Outcome UD_ModOutcome
        Form3 - Parameter Form1 for the Outcome
        Form4 - (????) Parameter Form2 for the Outcome
        
    Example:

/;
ScriptName UD_Modifier_Combo extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger) == None
        Return False
    EndIf
    If (akForm2 as UD_ModOutcome) == None
        Return False
    EndIf
    Return True
EndFunction

Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).GameLoaded(NameAlias, akDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).TimeUpdateSecond(NameAlias, akDevice, afTime, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).TimeUpdateHour(NameAlias, akDevice, afMult, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).Orgasm(NameAlias, akDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).DeviceLocked(NameAlias, akDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).DeviceUnlocked(NameAlias, akDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    return true
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).MinigameStarted(NameAlias, akDevice, akMinigameDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).MinigameEnded(NameAlias, akDevice, akMinigameDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).WeaponHit(NameAlias, akDevice, akWeapon, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).SpellHit(NameAlias, akDevice, akSpell, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).SpellCast(NameAlias, akDevice, akSpell, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).ConditionLoss(NameAlias, akDevice, aiCondition, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== Conditions ===\n"
    loc_msg += (akForm1 as UD_ModTrigger).GetDetails(akDevice, aiDataStr, akForm1, akForm2, akForm3)
    loc_msg += "\n"
    loc_msg += "=== Outcome ===\n"
    loc_msg += (akForm2 as UD_ModOutcome).GetDetails(akDevice, aiDataStr, akForm1, akForm2, akForm3)
    loc_msg += "\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction

String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    Return (akForm1 as UD_ModTrigger).NameFull + " => " + (akForm2 as UD_ModOutcome).NameFull
EndFunction
