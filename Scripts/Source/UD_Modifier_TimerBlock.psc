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
        Form1   Spell   Penalty spell (not implemented)
        
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

Function TimeUpdateSeconds(UD_CustomDevice_RenderScript akDevice, Float afHoursSinceLastCall, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Float loc_sp = GetStringParamFloat(aiDataStr, 0, 0.0)
    Float loc_period = GetStringParamFloat(aiDataStr, 2, 0.0)
    Int loc_destruct = GetStringParamInt(aiDataStr, 1, 0)
    
    If loc_period > loc_sp
        akDevice.editStringModifier(NameAlias, 2, FormatFloat(loc_period + afHoursSinceLastCall, 2))
        If loc_destruct > 0
            akDevice.unlockRestrain()
        EndIf
    EndIf
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Float loc_sp = GetStringParamFloat(aiDataStr, 0, 0.0)
    Float loc_period = GetStringParamFloat(aiDataStr, 2, 0.0)
    
; TODO PR195: penalty spell (electric shock for trying to struggle before the timeout expires)

    Return (loc_period > loc_sp)
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Block Timer:", FormatFloat(GetStringParamFloat(aiDataStr, 0, 0.0), 2) + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Self-destruct:", UDmain.UDMTF.InlineIfString(GetStringParamInt(aiDataStr, 1, 0) > 0, "True", "False"))
    Return loc_res
EndFunction