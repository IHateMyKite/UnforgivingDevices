;/  File: UD_ModOutcome_Quest
    Starts quest and/or sets stage

    NameFull: Quest

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     Stage to set 
                        Default value: -1 (Ignore)

    Form arguments:
        Form3 - Quest to start or FormLists with quests
        Form4 - Quest to start or FormLists with quests

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)

    Form[] loc_forms = CombineForms(akForm3, akForm4)
    
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

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)
    String loc_str = ""
    Int loc_stage = GetStringParamInt(aiDataStr, DataStrOffset + 0, -1)
    loc_str += "Changes the status of the quest"
    loc_str += "\n"
    loc_str += "Quest: " + akForm3 + ", " + akForm4
    loc_str += "Stage: " + loc_stage
    Return loc_str
EndFunction
