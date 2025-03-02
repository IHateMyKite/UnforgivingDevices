;/  File: UD_Modifier_ComboGeneric
    Something will happen when all conditions are met. 
    Use modifiers with different generic aliases if you want to add several generic modifiers on the same device

    NameFull: Combo Generic
    NameAlias: CMP1, CMP2, CMP3, CMP4, CMP5, CMN1, CMN2, CMN3, CMN4, CMN5
    
    CMP*        - use these modifiers for positive effects
    CMN*        - use these modifiers for negative effects

    Parameters in DataStr:
        [0 .. 6]            Parameters for the trigger. See description of the set trigger for details.
        
        [7 .. n]            Parameters for the outcome. See description of the set outcome for details.

    Form arguments:
        Form1               Argument for the Trigger
        Form2               Argument for the Outcome
        Form3               Argument for the Outcome
        Form4               Trigger UD_ModTrigger. If it returns true then the Outcome will be called
        Form5               Outcome UD_ModOutcome
        
    Example:
        
/;
ScriptName UD_Modifier_ComboGeneric extends UD_Modifier_Combo

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
UD_ModTrigger Function GetTrigger(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return akForm4 as UD_ModTrigger
EndFunction

UD_ModOutcome Function GetOutcome(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return akForm5 as UD_ModOutcome
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    UD_ModTrigger loc_trigger = GetTrigger(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    UD_ModOutcome loc_outcome = GetOutcome(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    Return loc_trigger.NameFull + " => " + loc_outcome.NameFull
EndFunction