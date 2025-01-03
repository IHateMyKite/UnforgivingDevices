;/  File: UD_ModTrigger_PsThief
    It triggers from thief play style
    
    NameFull: Thief Playstyle
    
    Parameters:
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

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Int Function GetEventProcessingMask()
    Return Math.LogicalOr(0x00000800, 0x00000200)
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1)
    If aiActorAction == 6
    ; Bow Release
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 0, 0.0))
    EndIf
    Return False
EndFunction

Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1)
    If asStatName == "Skill Increases" && (aiStatValue == 8 || aiStatValue == 13 || aiStatValue == 14 || aiStatValue == 15)
        ; Marksman, Pickpocket, LockPicking, Sneak
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 0.0))
    ElseIf asStatName == "Locks Picked"
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 2, 0.0))
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
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on bow use:", FormatFloat(GetStringParamFloat(aiDataStr, 0, 0.0), 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on skill increase:", FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 1) + "%")
    loc_res += UDmain.UDMTF.Paragraph("(Marksman, Pickpocket, LockPicking, Sneak)", asAlign = "center")
    loc_res += UDmain.UDMTF.TableRowDetails("Prob. on pick lock:", FormatFloat(GetStringParamFloat(aiDataStr, 2, 100.0), 1) + "%")
    Return loc_res
EndFunction