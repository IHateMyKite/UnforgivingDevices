;/  File: UD_Modifier_TimerBlock
    
    The modifier blocks all attempts to escape for the specified time after equipping

    NameFull:   Temporary Block
    NameAlias:  TMB

    Parameters:
        [0]     Float   The time during which all escape attempts are blocked (in-game hours)
                        
        [1]     Int     (optional) Self-destruct
                        Default value: 0 (False)
                        
        [2]     Float   (script) Elapsed time (in-game hours)

    Form arguments:
        Not used
        
    Example:
        
/;
ScriptName UD_Modifier_TimerBlock extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Update()
    EventProcessingMask = 0x00000001
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function TimeUpdateSecond(UD_CustomDevice_RenderScript akDevice, Float afTime, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Float loc_sp = GetStringParamFloat(aiDataStr, 0, 0.0)
    Float loc_period = GetStringParamFloat(aiDataStr, 2, 0.0)
    Int loc_destruct = GetStringParamInt(aiDataStr, 1, 0)
    
    If loc_period > loc_sp
        akDevice.editStringModifier(NameAlias, 2, FormatFloat(loc_period + afTime, 2))
        If loc_destruct > 0
            akDevice.unlockRestrain()
        EndIf
    EndIf
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Float loc_sp = GetStringParamFloat(aiDataStr, 0, 0.0)
    Float loc_period = GetStringParamFloat(aiDataStr, 2, 0.0)
    
    Return (loc_period > loc_sp)
EndFunction

String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "==== " + NameFull + " ====\n"
    loc_msg += "Block Timer: \t" + FormatFloat(GetStringParamFloat(aiDataStr, 0, 0.0), 2) + " hours\n"
    loc_msg += "Self-destruct: \t" + InlineIfStr(GetStringParamInt(aiDataStr, 1, 0) > 0, "True", "False") + "\n"
    
    if Description
        loc_msg += "=== Description ===" + "\n"
        loc_msg += Description
    endif
    Return loc_msg
EndFunction
