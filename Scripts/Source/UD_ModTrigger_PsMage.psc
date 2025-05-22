;/  File: UD_ModTrigger_PsMage
    It triggers from mage play style
    
    NameFull: Mage Playstyle
    
    Parameters in DataStr:
        [0]     Float       (optional) Probability to trigger on spell use
                            Default value: 0.0%

        [1]     Float       (optional) Probability to trigger on skill increase (Alteration, Conjuration, Destruction, Illusion)
                            Default value: 0.0%

    Example:
                    
/;
Scriptname UD_ModTrigger_PsMage extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Int aiEquipSlot, Form akSource, String aiDataStr, Form akForm1)
    Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 0, 0.0), akModifier.MultProbabilities)
    If aiActorAction == 2
    ; Spell Fire
        If akSource as Spell
        ; TODO PR195: check associated skill
        EndIf

        If RandomFloat(0.0, 100.0) < 50.0
            PrintNotification(akDevice, ;/ reacted /;" as it is happy with your behavior. For a moment, you see the silhouette of a mage.")
        EndIf

        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
    Return False
EndFunction

Bool Function SkillIncreased(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asSkill, Int aiValue, String aiDataStr, Form akForm1)
    If asSkill == "Alteration" || asSkill == "Conjuration" || asSkill == "Destruction" || asSkill == "Illusion"
        Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 1, 0.0), akModifier.MultProbabilities)
        
        If RandomFloat(0.0, 100.0) < 50.0
            PrintNotification(akDevice, ;/ reacted /;" as it is happy with your behavior. For a moment, you see the silhouette of a mage.")
        EndIf

        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Float loc_prob1 = MultFloat(GetStringParamFloat(aiDataStr, 0, 0.0), akModifier.MultProbabilities)
    Float loc_prob2 = MultFloat(GetStringParamFloat(aiDataStr, 1, 0.0), akModifier.MultProbabilities)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on spell use:", FormatFloat(loc_prob1, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on skill increase:", FormatFloat(loc_prob2, 1) + "%")
    loc_res += UDmain.UDMTF.Paragraph("(Alteration, Conjuration, Destruction, Illusion)", asAlign = "center")
    Return loc_res
EndFunction