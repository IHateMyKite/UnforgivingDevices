;/  File: UD_ModTrigger_PsMage
    It triggers from mage play style
    
    NameFull: On Combat Event
    
    Parameters:
        [0]     Float       (optional) Probability to trigger on spell use
                            Default value: 0.0%
        
        [1]     Float       (optional) Probability to trigger on skill increase (Alteration, Conjuration, Destruction, Illusion)
                            Default value: 0.0%
                            
        [2]     Float       (optional) ???
                            Default value: 0.0%
                        
    Example:
                    
/;
Scriptname UD_ModTrigger_PsMage extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr)
    If aiActorAction == 2
    ; Spell Fire
        If akSource as Spell
        ; TODO: check associated skill
        EndIf
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 0, 0.0))
    EndIf
    Return False
EndFunction

Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr)
    If asStatName == "Skill Increases" && (aiStatValue == 18 || aiStatValue == 19 || aiStatValue == 20 || aiStatValue == 21)
        ; Alteration, Conjuration, Destruction, Illusion
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 0.0))
    EndIf
    Return False
EndFunction
