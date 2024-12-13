;/  File: UD_ModOutcome_RestoreDurability
    Restores durability of the device(s)

    NameFull: Restore Durability

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     (optional) Number of positions (devices with suitable keywords) to regenerate
                        Default value: 1
                        
        [+1]    String  (optional) Selection method (in general or for the keyword in list akForm4)
                            SELF or S       - regains its own durability
                            ALL or A        - restores the durability of all devices
                            FIRST or F      - first suitable keyword from the list (akForm4, akForm5 concatenated together)
                            RANDOM or R     - random keyword from the list (akForm4, akForm5 concatenated together)
                        Default value: SELF
                        
        [+2]    Float   Minimum restored durability in %
        
        [+3]    Float   (optional) Maximum restored durability in %
                        Default value: [+2]

    Form arguments:
        Form4           Single device keyword to regenerate or FormList with keywords (may be None if SELF or ALL selection method is used).
        Form5           Single device keyword to regenerate or FormList with keywords (may be None if SELF or ALL selection method is used).

    Example:
        
/;
Scriptname UD_ModOutcome_RestoreDurability extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)    
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_RestoreDurability::Outcome() akDevice = " + akDevice + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list4 = GetStringParamString(aiDataStr, DataStrOffset + 1, "S")
    Float loc_min = GetStringParamFloat(aiDataStr, DataStrOffset + 2)
    Float loc_max = GetStringParamFloat(aiDataStr, DataStrOffset + 3, loc_min)

    Form[] loc_devices = GetEquippedDevicesWithSelectionMethod(akDevice, loc_count, akForm4, loc_method_list4, akForm5, "")

    Int loc_i = 0
    While loc_i < loc_devices.Length
        mendDevice(loc_devices[loc_i] as UD_CustomDevice_RenderScript, RandomFloat(loc_min, loc_max), 1.0, 1.0)
        loc_i += 1
    EndWhile
    
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
    String loc_res = ""
    String loc_frag = "" 
    String loc_method_list4 = GetStringParamString(aiDataStr, DataStrOffset + 1, "R")
    Float loc_min = GetStringParamFloat(aiDataStr, DataStrOffset + 2)
    Float loc_max = GetStringParamFloat(aiDataStr, DataStrOffset + 3, loc_min)   
    If loc_method_list4 == "S"
        loc_frag = "SELF"
    ElseIf loc_method_list4 == "A"
        loc_frag = "ALL"
    Else
        loc_frag = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)   
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Number of devices:", loc_frag)
    If loc_method_list4 != ""
        loc_res += akModifier.PrintFormListSelectionDetails(akForm4, loc_method_list4)
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Magnitude:", FormatFloat(loc_min, 1) + " - " + FormatFloat(loc_max, 1) + "%")
    Return loc_res
EndFunction

;/  Group: Protected methods
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function mendDevice(UD_CustomDevice_RenderScript akDevice, Float afStrength, float afMult = 1.0, float afTimePassed = 1.0)
    if akDevice.onMendPre(afMult) && akDevice.GetRelativeDurability() > 0.0
        Float   loc_regen   = afStrength
        Float   loc_amount  = afTimePassed*loc_regen*(1 - 0.1*akDevice.UD_condition)*afMult*UDCDmain.getStruggleDifficultyModifier()
        akDevice.refillDurability(loc_amount)
        akDevice.refillCuttingProgress(afTimePassed*loc_regen)
        akDevice.onMendPost(loc_amount)
    endif
EndFunction