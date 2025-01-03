;/  File: UD_Modifier_ComboPreset
    A modifier with pre-determined Triggers and Outcome. Bind the script to an alias and use it like any other modifier.

    NameFull:   
    NameAlias:  


    Parameters:
        [0 .. 6]            Parameters for the trigger. See description of the selected trigger for details.
        
        [7 .. n]            Parameters for the outcome. See description of the selected outcome for details.

    Form arguments:
        Form1               Argument for the ModTrigger
        Form2               Argument for the ModOutcome
        Form3               Argument for the ModOutcome
        Form4               Not used! (Use ModTrigger property instead)
        Form5               Not used! (Use ModOutcome property instead)
        
    Example:
/;
ScriptName UD_Modifier_ComboPreset extends UD_Modifier_Combo

import UnforgivingDevicesMain
import UD_Native

UD_ModTrigger Property ModTrigger Auto
UD_ModOutcome Property ModOutcome Auto


;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
UD_ModTrigger Function GetTrigger(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return ModTrigger
EndFunction

UD_ModOutcome Function GetOutcome(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return ModOutcome
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return NameFull
EndFunction