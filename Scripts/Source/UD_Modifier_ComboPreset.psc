;/  File: UD_Modifier_ComboPreset
    A pre-prepared Combo-based modifier to be used, for example, in a patcher

    NameFull: 
    NameAlias: 


    Parameters:
        [0 .. 6]    Parameters for the trigger. See description of the selected trigger for details.
        
        [7 .. n]    Parameters for the outcome. See description of the selected outcome for details.

    Form arguments:
        Form1 - Not used
        Form2 - Not used
        Form3 - Parameter for the ModTrigger
        Form4 - Parameter for the ModOutcome
        Form5 - Parameter for the ModOutcome
        
    Example:
        
/;
ScriptName UD_Modifier_ComboPreset extends UD_Modifier_Combo

import UnforgivingDevicesMain
import UD_Native

UD_ModTrigger Property ModTrigger Auto
UD_ModOutcome Property ModOutcome Auto


;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Update()
    EventProcessingMask = ModTrigger.GetEventProcessingMask()
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.GameLoaded(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.TimeUpdateSecond(akDevice, afTime, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.TimeUpdateHour(akDevice, afMult, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.Orgasm(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.DeviceLocked(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.DeviceUnlocked(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return Parent.MinigameAllowed(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.MinigameStarted(akDevice, akMinigameDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.MinigameEnded(akDevice, akMinigameDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.WeaponHit(akDevice, akWeapon, afDamage, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.SpellHit(akDevice, akSpell, afDamage, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.SpellCast(akDevice, akSpell, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.ConditionLoss(akDevice, aiCondition, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function StatEvent(UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.StatEvent(akDevice, asStatName, aiStatValue, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function Sleep(UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.Sleep(akDevice, afDuration, abInterrupted, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.ActorAction(akDevice, aiActorAction, akSource, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function KillMonitor(UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.KillMonitor(akDevice, akVictim, aiCrimeStatus, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function ItemAdded(UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akSourceContainer, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.ItemAdded(akDevice, akItemForm, aiItemCount, akSourceContainer, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction

Function ItemRemoved(UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akDestContainer, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Parent.ItemRemoved(akDevice, akItemForm, aiItemCount, akDestContainer, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4, akForm5)
EndFunction
;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== Trigger ===\n"
    loc_msg += ModTrigger.GetDetails(Self, akDevice, aiDataStr, akForm3)
    loc_msg += "\n"
    loc_msg += "\n"
    loc_msg += "=== Outcome ===\n"
    loc_msg += ModOutcome.GetDetails(Self, akDevice, aiDataStr, akForm4, akForm5)
    loc_msg += "\n"
    loc_msg += "\n"

    loc_msg += "=== Description ===\n"
    loc_msg += Description + "\n"

    Return loc_msg
EndFunction

String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return NameFull
EndFunction
