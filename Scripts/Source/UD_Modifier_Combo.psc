;/  File: UD_Modifier_Combo
    Something will happen when all conditions are met. 
    Use modifiers with different aliases if you want to add several CMB modifiers on the same device

    NameFull: Combo
    NameAlias: CMP1, CMP2, CMP3, CMP4, CMP5, CMN1, CMN2, CMN3, CMN4, CMN5

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
    If (akForm1 as UD_ModTrigger).GameLoaded(Self, akDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).TimeUpdateSecond(Self, akDevice, afTime, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).TimeUpdateHour(Self, akDevice, afMult, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).Orgasm(Self, akDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).DeviceLocked(Self, akDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).DeviceUnlocked(Self, akDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    return true
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).MinigameStarted(Self, akDevice, akMinigameDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).MinigameEnded(Self, akDevice, akMinigameDevice, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).WeaponHit(Self, akDevice, akWeapon, afDamage, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).SpellHit(Self, akDevice, akSpell, afDamage, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).SpellCast(Self, akDevice, akSpell, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).ConditionLoss(Self, akDevice, aiCondition, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function StatEvent(UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).StatEvent(Self, akDevice, asStatName, aiStatValue, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function Sleep(UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).Sleep(Self, akDevice, afDuration, abInterrupted, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).ActorAction(Self, akDevice, aiActorAction, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function KillMonitor(UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If (akForm1 as UD_ModTrigger).KillMonitor(Self, akDevice, akVictim, aiCrimeStatus, aiDataStr) == True
        (akForm2 as UD_ModOutcome).Outcome(Self, akDevice, aiDataStr, akForm3, None)
    EndIf
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== Conditions ===\n"
    loc_msg += (akForm1 as UD_ModTrigger).GetDetails(Self, akDevice, aiDataStr, akForm1, akForm2, akForm3)
    loc_msg += "\n"
    loc_msg += "=== Outcome ===\n"
    loc_msg += (akForm2 as UD_ModOutcome).GetDetails(Self, akDevice, aiDataStr, akForm1, akForm2, akForm3)
    loc_msg += "\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction

String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    Return (akForm1 as UD_ModTrigger).NameFull + " => " + (akForm2 as UD_ModOutcome).NameFull
EndFunction
