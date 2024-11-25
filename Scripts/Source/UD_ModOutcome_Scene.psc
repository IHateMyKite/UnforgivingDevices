;/  File: UD_ModOutcome_Scene
    Plays scene

    NameFull: Scene

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     Force 
                        Default value: 0 (False)

    Form arguments:
        Form4 - Scene to play or FormLists with scenes
        Form5 - Scene to play or FormLists with scenes

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    Form[] loc_forms = CombineForms(akForm4, akForm5)
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
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    String loc_res = ""

    If akForm4
        loc_res += PrintFormListSelectionDetails(akForm4, "R")
    EndIf
    If akForm5
        loc_res += PrintFormListSelectionDetails(akForm5, "R")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Force:", InlineIfStr(GetStringParamInt(aiDataStr, DataStrOffset + 0, 0) > 0, "True", "False"))
    Return loc_res
EndFunction