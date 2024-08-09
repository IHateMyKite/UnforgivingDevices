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
        Form3 - Parameter Form1 for the ModOutcome
        Form4 - Parameter Form2 for the ModOutcome
        
    Example:
        
/;
ScriptName UD_Modifier_ComboPreset extends UD_Modifier_Combo

import UnforgivingDevicesMain
import UD_Native

UD_ModTrigger Property ModTrigger Auto
UD_ModOutcome Property ModOutcome Auto

Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Return True
EndFunction

Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.GameLoaded(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.TimeUpdateSecond(akDevice, afTime, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.TimeUpdateHour(akDevice, afMult, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.Orgasm(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.DeviceLocked(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.DeviceUnlocked(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Return Parent.MinigameAllowed(akDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.MinigameStarted(akDevice, akMinigameDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.MinigameEnded(akDevice, akMinigameDevice, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.WeaponHit(akDevice, akWeapon, afDamage, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.SpellHit(akDevice, akSpell, afDamage, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.SpellCast(akDevice, akSpell, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.ConditionLoss(akDevice, aiCondition, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function StatEvent(UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.StatEvent(akDevice, asStatName, aiStatValue, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function Sleep(UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.Sleep(akDevice, afDuration, abInterrupted, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.ActorAction(akDevice, aiActorAction, akSource, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Function KillMonitor(UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Parent.KillMonitor(akDevice, akVictim, aiCrimeStatus, aiDataStr, ModTrigger, ModOutcome, akForm3, akForm4)
EndFunction

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    UD_Patcher_ComboPreset loc_patcher = ((Self as ReferenceAlias) as UD_Patcher_ComboPreset)
    If loc_patcher == None
        Return False
    EndIf
    Return loc_patcher.CheckDevice(akDevice)
EndFunction

Float Function PatchModifierProbability(UD_CustomDevice_RenderScript akDevice, Int aiSoftCap, Int aiValidMods)
    Return Parent.PatchModifierProbability(akDevice, aiSoftCap, aiValidMods)
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    UD_Patcher_ComboPreset loc_patcher = ((Self as ReferenceAlias) as UD_Patcher_ComboPreset)
    If loc_patcher == None
        Return
    EndIf
    akDevice.AddModifier(Self, loc_patcher.GetDataStr(PatchPowerMultiplier), None, None, loc_patcher.GetForm3(PatchPowerMultiplier), loc_patcher.GetForm4(PatchPowerMultiplier))
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    String loc_msg = ""
    
    loc_msg += "=== Trigger ===\n"
    loc_msg += ModTrigger.GetDetails(Self, akDevice, aiDataStr)
    loc_msg += "\n"
    loc_msg += "\n"
    loc_msg += "=== Outcome ===\n"
    loc_msg += ModOutcome.GetDetails(Self, akDevice, aiDataStr, akForm3, akForm4)
    loc_msg += "\n"
    loc_msg += "\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction

String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    Return NameFull
EndFunction
