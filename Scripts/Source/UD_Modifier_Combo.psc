;/  File: UD_Modifier_Combo
    Abstract

    NameFull:
    NameAlias: 

    Parameters in DataStr:
        [0 .. 6]            Parameters for the trigger. See description of the set trigger for details.
        
        [7 .. n]            Parameters for the outcome. See description of the set outcome for details.

    Form arguments:
        Form1               Parameter Form1 for the Trigger
        Form2               Parameter Form1 for the Outcome
        Form3               Parameter Form2 for the Outcome
        Form4               
        Form5               
        
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
Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Bool loc_result = True
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger == None
        Return False
    Else
        loc_result = loc_result && loc_trigger.ValidateTrigger(akDevice, aiDataStr, akForm1)
    EndIf
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_outcome == None
        Return False
    EndIf
    Return loc_result
EndFunction

UD_ModTrigger Function GetTrigger(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UDmain.Error(Self + "::GetTrigger() Abstract method call!")
    Return None
EndFunction

UD_ModOutcome Function GetOutcome(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UDmain.Error(Self + "::GetOutcome() Abstract method call!")
    Return None
EndFunction

Function OnBeforeOutcome(UD_ModOutcome akOutcome, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
EndFunction

Function OnAfterOutcome(UD_ModOutcome akOutcome, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    loc_outcome.OnGameLoaded(Self, akDevice, aiDataStr, akForm2, akForm3)
    If loc_trigger.GameLoaded(Self, akDevice, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function TimeUpdateSeconds(UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, Float afRealSecondsSinceLastCall, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.TimeUpdateSeconds(Self, akDevice, afGameHoursSinceLastCall, afRealSecondsSinceLastCall, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afHoursSinceLastCall, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.TimeUpdateHour(Self, akDevice, afHoursSinceLastCall, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.Orgasm(Self, akDevice, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    loc_outcome.OnDeviceLocked(Self, akDevice, aiDataStr, akForm2, akForm3)
    If loc_trigger.DeviceLocked(Self, akDevice, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    loc_outcome.OnDeviceUnlocked(Self, akDevice, aiDataStr, akForm2, akForm3)
    If loc_trigger.DeviceUnlocked(Self, akDevice, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_outcome
        Return loc_outcome.MinigameAllowed(Self, akDevice, aiDataStr, akForm2, akForm3)
    Else
        Return True
    EndIf
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.MinigameStarted(Self, akDevice, akMinigameDevice, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.MinigameEnded(Self, akDevice, akMinigameDevice, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.WeaponHit(Self, akDevice, akWeapon, afDamage, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.SpellHit(Self, akDevice, akSpell, afDamage, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.SpellCast(Self, akDevice, akSpell, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.ConditionLoss(Self, akDevice, aiCondition, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function StatEvent(UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.StatEvent(Self, akDevice, asStatName, aiStatValue, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function Sleep(UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.Sleep(Self, akDevice, afDuration, abInterrupted, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Int aiEquipSlot, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.ActorAction(Self, akDevice, aiActorAction, aiEquipSlot, akSource, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function KillMonitor(UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.KillMonitor(Self, akDevice, akVictim, aiCrimeStatus, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function ItemAdded(UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akSourceContainer, Bool abIsStolen, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.ItemAdded(Self, akDevice, akItemForm, aiItemCount, akSourceContainer, abIsStolen, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function ItemRemoved(UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akDestContainer, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.ItemRemoved(Self, akDevice, akItemForm, aiItemCount, akDestContainer, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

Function SkillIncreased(UD_CustomDevice_RenderScript akDevice, String asSkill, Int aiValue, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    If loc_trigger.SkillIncreased(Self, akDevice, asSkill, aiValue, aiDataStr, akForm1) == True
        _DoCallOutcome(loc_outcome, akDevice, aiDataStr, akForm2, akForm3)
    EndIf
EndFunction

; Privates
Function _DoCallOutcome(UD_ModOutcome akOutcome, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    OnBeforeOutcome(akOutcome, akDevice, aiDataStr, akForm2, akForm3)
    If akOutcome
        If UDmain.TraceAllowed()
            UDmain.Log(akOutcome + "::Outcome() akModifier = " + Self + ", akDevice = " + akDevice + ", aiDataStr = " + aiDataStr + ", akForm2 = " + akForm2 + ", akForm3 = " + akForm3, 3)
        EndIf
        akOutcome.Outcome(Self, akDevice, aiDataStr, akForm2, akForm3)
        OnAfterOutcome(akOutcome, akDevice, aiDataStr, akForm2, akForm3)
    Else
        UDmain.Warning(Self + "::_DoCallOutcome() akOutcome is None!")
    EndIf
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.Header(NameFull, UDMain.UDMTF.FontSize + 4)
    loc_res += UDmain.UDMTF.FontBegin(aiFontSize = UDmain.UDMTF.FontSize, asColor = UDmain.UDMTF.TextColorDefault)
    loc_res += UDmain.UDMTF.HeaderSplit()
    If Description
        loc_res += UDmain.UDMTF.Paragraph(Description, asAlign = "center")
        loc_res += UDmain.UDMTF.LineGap()
    EndIf
; Trigger
    loc_res += UDmain.UDMTF.PageSplit(abForce = False)
    loc_res += UDmain.UDMTF.Header("Trigger")
    loc_res += loc_trigger.GetDetails(Self, akDevice, aiDataStr, akForm1)
; Outcome
    loc_res += UDmain.UDMTF.PageSplit(abForce = False)
    loc_res += UDmain.UDMTF.Header("Outcome")
    loc_res += loc_outcome.GetDetails(Self, akDevice, aiDataStr, akForm2, akForm3)
    
    loc_res += UDmain.UDMTF.FooterSplit()
    loc_res += UDmain.UDMTF.FontEnd()

    Return loc_res
EndFunction

; A message in the device description that explains the minigame prohibition
String Function MinigameProhibitedMessage(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    Return loc_outcome.MinigameProhibitedMessage(Self, akDevice, aiDataStr, akForm2, akForm3)
EndFunction