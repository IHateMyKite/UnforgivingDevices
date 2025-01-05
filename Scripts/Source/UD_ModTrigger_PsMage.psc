;/  File: UD_ModTrigger_PsMage
    It triggers from mage play style
    
    NameFull: Mage Playstyle
    
    Parameters:
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
Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1)
    If aiActorAction == 2
    ; Spell Fire
        If akSource as Spell
        ; TODO PR195: check associated skill
        EndIf
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 0, 0.0))
    EndIf
    Return False
EndFunction

Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1)
    If asStatName == "Skill Increases" && (aiStatValue == 18 || aiStatValue == 19 || aiStatValue == 20 || aiStatValue == 21)
        ; Alteration, Conjuration, Destruction, Illusion
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 0.0))
    EndIf
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on spell use:", FormatFloat(GetStringParamFloat(aiDataStr, 0, 0.0), 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on skill increase:", FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 1) + "%")
    loc_res += UDmain.UDMTF.Paragraph("(Alteration, Conjuration, Destruction, Illusion)", asAlign = "center")
    Return loc_res
EndFunction