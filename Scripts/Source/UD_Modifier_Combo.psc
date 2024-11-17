;/  File: UD_Modifier_Combo
    Something will happen when all conditions are met. 
    Use modifiers with different aliases if you want to add several Combo modifiers on the same device

    NameFull: Combo
    NameAlias: CMP1, CMP2, CMP3, CMP4, CMP5, CMN1, CMN2, CMN3, CMN4, CMN5
    
    CMP*        - use these modifiers for positive effects
    CMN*        - use these modifiers for negative effects

    Parameters:
        [0 .. 6]    Parameters for the trigger. See description of the set trigger for details.
        
        [7 .. n]    Parameters for the outcome. See description of the set outcome for details.

    Form arguments:
        Form1       Trigger UD_ModTrigger. When it returns true the outcome will be called
        Form2       Outcome UD_ModOutcome
        Form3       Parameter Form1 for the Trigger
        Form4       Parameter Form1 for the Outcome
        Form5       Parameter Form2 for the Outcome
        
    Example:
        
/;
ScriptName UD_Modifier_Combo extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native


;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Update()
    EventProcessingMask = 0x80000000
EndFunction

Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Bool loc_result = True
    If (akForm1 as UD_ModTrigger) == None
        Return False
    Else
        loc_result = loc_result && (akForm1 as UD_ModTrigger).ValidateTrigger(akDevice, aiDataStr, akForm1)
    EndIf
    If (akForm2 as UD_ModOutcome) == None
        Return False
    EndIf
    Return loc_result
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).GameLoaded(Self, akDevice, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function TimeUpdateSeconds(UD_CustomDevice_RenderScript akDevice, Float afHoursSinceLastCall, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).TimeUpdateSeconds(Self, akDevice, afHoursSinceLastCall, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afHoursSinceLastCall, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).TimeUpdateHour(Self, akDevice, afHoursSinceLastCall, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).Orgasm(Self, akDevice, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).DeviceLocked(Self, akDevice, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).DeviceUnlocked(Self, akDevice, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    return true
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).MinigameStarted(Self, akDevice, akMinigameDevice, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).MinigameEnded(Self, akDevice, akMinigameDevice, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).WeaponHit(Self, akDevice, akWeapon, afDamage, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).SpellHit(Self, akDevice, akSpell, afDamage, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).SpellCast(Self, akDevice, akSpell, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).ConditionLoss(Self, akDevice, aiCondition, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function StatEvent(UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).StatEvent(Self, akDevice, asStatName, aiStatValue, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function Sleep(UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).Sleep(Self, akDevice, afDuration, abInterrupted, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).ActorAction(Self, akDevice, aiActorAction, akSource, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function KillMonitor(UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).KillMonitor(Self, akDevice, akVictim, aiCrimeStatus, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function ItemAdded(UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akSourceContainer, Bool abIsStolen, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).ItemAdded(Self, akDevice, akItemForm, aiItemCount, akSourceContainer, abIsStolen, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

Function ItemRemoved(UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akDestContainer, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If (akForm1 as UD_ModTrigger).ItemRemoved(Self, akDevice, akItemForm, aiItemCount, akDestContainer, aiDataStr, akForm3) == True
        _DoCallOutcome(akForm2 as UD_ModOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

; Overrides
Function OnBeforeOutcome(UD_ModOutcome akOutcome, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
EndFunction

Function OnAfterOutcome(UD_ModOutcome akOutcome, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
EndFunction

; Privates
Function _DoCallOutcome(UD_ModOutcome akOutcome, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
    OnBeforeOutcome(akOutcome, akDevice, aiDataStr, akForm4, akForm5)
    If akOutcome
        akOutcome.Outcome(Self, akDevice, aiDataStr, akForm4, akForm5)
        OnAfterOutcome(akOutcome, akDevice, aiDataStr, akForm4, akForm5)
    EndIf
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.Header(NameFull, 4)
    loc_res += UDmain.UDMTF.FontBegin(aiFontSize = UDmain.UDMTF.FontSize, asColor = UDmain.UDMTF.TextColorDefault)
    If Description
        loc_res += UDmain.UDMTF.LineBreak()
        loc_res += UDmain.UDMTF.Text(Description, asAlign = "center")
    EndIf
; Trigger
    loc_res += UDmain.UDMTF.LineBreak()
    loc_res += UDmain.UDMTF.Header("Trigger", 0)
    loc_res += UDmain.UDMTF.LineGap()
    loc_res += (akForm1 as UD_ModTrigger).GetDetails(Self, akDevice, aiDataStr, akForm3)
; Outcome
    loc_res += UDmain.UDMTF.LineBreak()
    loc_res += UDmain.UDMTF.Header("Outcome", 0)
    loc_res += UDmain.UDMTF.LineGap()
    loc_res += (akForm2 as UD_ModOutcome).GetDetails(Self, akDevice, aiDataStr, akForm4, akForm5)
    
    loc_res += UDmain.UDMTF.FontEnd()

    Return loc_res
EndFunction

String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return (akForm1 as UD_ModTrigger).NameFull + " => " + (akForm2 as UD_ModOutcome).NameFull
EndFunction
