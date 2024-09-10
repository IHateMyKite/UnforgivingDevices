;/  File: UD_Modifier_CP_TempTrouble
    

    NameFull:   Temporary Trouble
    NameAlias:  CTT

    Parameters:
        [0 .. 6]    Parameters for the trigger. See description of the selected trigger for details.
        
        [7 .. n]    Parameters for the outcome. See description of the selected outcome for details.

    Form arguments:
        Not used
        
    Example:
        
/;
ScriptName UD_Modifier_CP_TempTrouble extends UD_Modifier_ComboPreset

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    ;EventProcessingMask = 0x80000000
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return False
EndFunction

String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "=== Trigger ===\n"
    loc_msg += ModTrigger.GetDetails(Self, akDevice, aiDataStr, akForm3)
    loc_msg += "\n"
    loc_msg += "\n"
    loc_msg += "=== Outcome ===\n"
    loc_msg += ModOutcome.GetDetails(Self, akDevice, aiDataStr, akForm4, akForm5)
    loc_msg += "\n"
    loc_msg += "\n"

    loc_msg += "=== Description ===\n"
    loc_msg += Description + "\n"

    Return loc_msg
EndFunction
