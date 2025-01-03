;/  File: UD_ModOutcome_Scene
    Plays scene

    NameFull: Scene

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         Force 
                            Default value: 0 (False)

    Form arguments:
        Form4               Scene to play or FormLists with scenes (a random scene from the merged list will be started)
        
        Form5               Scene to play or FormLists with scenes (a random scene from the merged list will be started)

    Example:
/;
Scriptname UD_ModOutcome_Scene extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Form[] loc_forms = UD_Modifier.GetAllForms(akForm2, akForm3)
    If loc_forms.Length > 0
        Scene loc_scene = loc_forms[RandomInt(0, loc_forms.length - 1)] as Scene
        If loc_scene != None
            If GetStringParamInt(aiDataStr, DataStrOffset + 0, 0) > 0
                loc_scene.ForceStart()
            Else
                loc_scene.Start()
            EndIf
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
    loc_res += UDmain.UDMTF.TableRowDetails("Force:", InlineIfStr(GetStringParamInt(aiDataStr, DataStrOffset + 0, 0) > 0, "True", "False"))
    Return loc_res
EndFunction