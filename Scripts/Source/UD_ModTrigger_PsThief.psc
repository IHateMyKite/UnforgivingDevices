;/  File: UD_ModTrigger_PsThief
    It triggers from thief play style
    
    NameFull: Thief Playstyle
    
    Parameters in DataStr:
        [0]     Float       (optional) Probability to trigger on bow use
                            Default value: 0.0%

        [1]     Float       (optional) Probability to trigger on thief skill increase (Marksman, Pickpocket, LockPicking, Sneak)
                            Default value: 0.0%

        [2]     Float       (optional) Probability to trigger on lockpicking
                            Default value: 0.0%

    Example:
                    
/;
Scriptname UD_ModTrigger_PsThief extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Int aiEquipSlot, Form akSource, String aiDataStr, Form akForm1)
    If aiActorAction == 6
    ; Bow Release
        Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 0, 0.0), akModifier.MultProbabilities)
        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
    Return False
EndFunction

Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1)
    If asStatName == "Locks Picked"
        Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
        Return (RandomFloat(0.0, 100.0) < loc_prob)
    EndIf
    Return False
EndFunction

Bool Function SkillIncreased(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asSkill, Int aiValue, String aiDataStr, Form akForm1)
    If asSkill == "Marksman" || asSkill == "Pickpocket" || asSkill == "LockPicking" || asSkill == "Sneak"
        Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 1, 0.0), akModifier.MultProbabilities)
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
    Float loc_prob3 = MultFloat(GetStringParamFloat(aiDataStr, 2, 0.0), akModifier.MultProbabilities)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on bow use:", FormatFloat(loc_prob1, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on skill increase:", FormatFloat(loc_prob2, 1) + "%")
    loc_res += UDmain.UDMTF.Paragraph("(Marksman, Pickpocket, LockPicking, Sneak)", asAlign = "center")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on pick lock:", FormatFloat(loc_prob3, 1) + "%")
    Return loc_res
EndFunction