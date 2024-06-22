;/  File: UD_ModOutcome_Scene
    Plays scene

    NameFull: Scene

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     Force 
                        Default value: 0 (False)

    Form arguments:
        Form3 - Scene to play or FormLists with scenes
        Form4 - Scene to play or FormLists with scenes

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)
    Form[] loc_forms = CombineForms(akForm3, akForm4)
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

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)
    String loc_str = ""
    Bool loc_force = GetStringParamInt(aiDataStr, DataStrOffset + 0, 0) > 0
    loc_str += "Starts scene"
    loc_str += "\n"
    loc_str += "Scene: " + akForm3 + ", " + akForm4
    loc_str += "Force: "
    If loc_force
        loc_str += "True"
    Else
        loc_str += "False"
    EndIf
    Return loc_str
EndFunction
