;/  File: UD_ModOutcome_Scene
    Play scene

    NameFull:   
    NameAlias:  SCE

    Parameters in DataStr:
        [5]     Int     Force 
                        Default value: 0 (False)

    Form arguments:
        Form1 - Scene to play or FormLists with scenes
        Form2 - Scene to play or FormLists with scenes
        Form3 - Scene to play or FormLists with scenes

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

Function Outcome(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)

    Form[] loc_forms = CombineForms(akForm1, akForm2, akForm3)
    
    If loc_forms.Length > 0
        Scene loc_scene = loc_forms[RandomInt(0, loc_forms.length - 1)] as Scene
        If loc_scene != None
            If GetStringParamInt(aiDataStr, 5, 0) > 0
                loc_scene.ForceStart()
            Else
                loc_scene.Start()
            EndIf
        EndIf
    EndIf
    
EndFunction
