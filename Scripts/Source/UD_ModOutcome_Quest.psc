;/  File: UD_ModOutcome_Quest
    Starts quest and/or sets stage

    NameFull: Quest

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         Stage to set 
                            Default value: -1 (Ignore)

    Form arguments:
        Form4 - Quest to start or FormLists with quests
        Form5 - Quest to start or FormLists with quests

    Example:
/;
Scriptname UD_ModOutcome_Quest extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)

    Form[] loc_forms = CombineForms(akForm4, akForm5)
    
    If loc_forms.Length > 0
        Quest loc_quest = loc_forms[RandomInt(0, loc_forms.length - 1)] as Quest
        If loc_quest != None
            If !loc_quest.IsRunning()
                loc_quest.Start()
            EndIf
            Int loc_stage = GetStringParamInt(aiDataStr, DataStrOffset + 0, -1)
            If loc_stage >= 0
                loc_quest.SetStage(loc_stage)
            EndIf
        EndIf
    EndIf
    
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
    String loc_res = ""

    If akForm4
        loc_res += akModifier.PrintFormListSelectionDetails(akForm4, "R")
    EndIf
    If akForm5
        loc_res += akModifier.PrintFormListSelectionDetails(akForm5, "R")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Stage:", GetStringParamInt(aiDataStr, DataStrOffset + 0, -1))
    Return loc_res
EndFunction