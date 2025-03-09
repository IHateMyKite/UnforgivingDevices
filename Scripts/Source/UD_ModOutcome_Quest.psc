;/  File: UD_ModOutcome_Quest
    Starts quest and/or sets stage

    NameFull: Quest

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         Stage to set 
                            Default value: -1 (Ignore)

    Form arguments:
        Form2 - Quest to start or FormLists with quests (a random quest from the list will be started)

        Form3 - Quest to start or FormLists with quests (a random quest from the list will be started)

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Quest loc_quest = None
    loc_quest = UD_Modifier.GetRandomForm(akForm2) as Quest
    If loc_quest as UD_ModInjection_Quest
        loc_quest = loc_quest as UD_ModInjection_Quest
    EndIf
    If loc_quest != None
        If !loc_quest.IsRunning()
            loc_quest.Start()
        EndIf
        Int loc_stage = GetStringParamInt(aiDataStr, DataStrOffset + 0, -1)
        If loc_stage >= 0
            loc_quest.SetStage(loc_stage)
        EndIf
    EndIf

    loc_quest = UD_Modifier.GetRandomForm(akForm3) as Quest
    If loc_quest as UD_ModInjection_Quest
        loc_quest = loc_quest as UD_ModInjection_Quest
    EndIf
    If loc_quest != None
        If !loc_quest.IsRunning()
            loc_quest.Start()
        EndIf
        Int loc_stage = GetStringParamInt(aiDataStr, DataStrOffset + 0, -1)
        If loc_stage >= 0
            loc_quest.SetStage(loc_stage)
        EndIf
    EndIf
    
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_res = ""

    If akForm2
        loc_res += akModifier.PrintFormListSelectionDetails(akForm2, "R")
    EndIf
    If akForm3
        loc_res += akModifier.PrintFormListSelectionDetails(akForm3, "R")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Stage:", GetStringParamInt(aiDataStr, DataStrOffset + 0, -1))
    Return loc_res
EndFunction