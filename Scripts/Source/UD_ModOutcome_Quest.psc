;/  File: UD_ModOutcome_Quest
    Start quest and/or set stage

    NameFull:   
    NameAlias:  QUE

    Parameters in DataStr:
        [5]     Int     Stage to set 
                        Default value: -1 (Ignore)

    Form arguments:
        Form1 - Quest to start or FormLists with quests
        Form2 - Quest to start or FormLists with quests
        Form3 - Quest to start or FormLists with quests

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)

    Form[] loc_forms = CombineForms(akForm1, akForm2, akForm3)
    
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
