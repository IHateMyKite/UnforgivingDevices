;/  File: UD_ModOutcome_RestoreDurability
    Restores durability of the device(s)

    NameFull: Restore Durability

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int     (optional) Number of positions (devices with suitable keywords) to regenerate
                        Default value: 1
                        
        [+1]    String  (optional) Selection method (in general or for the keyword in list akForm1)
                            SELF or S       - regains its own durability
                            ALL or A        - restores the durability of all devices
                            FIRST or F      - first suitable keyword from the list (akForm1, akForm2, akForm3 concatenated together)
                            RANDOM or R     - random keyword from the list (akForm1, akForm2, akForm3 concatenated together)
                        Default value: SELF
                        
        [+2]    Float   Minimum restored durability in %
        
        [+3]    Float   (optional) Maximum restored durability in %
                        Default value: [+2]

    Form arguments:
        Form1 - Single device keyword to regenerate or FormList with keywords (may be None if SELF or ALL selection method is used).

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)    
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_RestoreDurability::Outcome() akDevice = " + akDevice + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    
    Int loc_count = GetStringParamInt(aiDataStr, DataStrOffset + 0, 1)
    String loc_method_list1 = GetStringParamString(aiDataStr, DataStrOffset + 1, "S")
    Float loc_min = GetStringParamFloat(aiDataStr, DataStrOffset + 2)
    Float loc_max = GetStringParamFloat(aiDataStr, DataStrOffset + 3, loc_min)

    Form[] loc_devices = GetEquippedDevicesWithSelectionMethod(akDevice, loc_count, akForm1, loc_method_list1, akForm2, "", akForm3, "")

    Int loc_i = 0
    While loc_i < loc_devices.Length
        mendDevice(loc_devices[loc_i] as UD_CustomDevice_RenderScript, RandomFloat(loc_min, loc_max), 1.0, 1.0)
        loc_i += 1
    EndWhile
    
EndFunction

Function mendDevice(UD_CustomDevice_RenderScript akDevice, Float afStrength, float afMult = 1.0, float afTimePassed)
    if akDevice.onMendPre(afMult) && akDevice.GetRelativeDurability() > 0.0
        Float   loc_regen   = afStrength
        Float   loc_amount  = afTimePassed*loc_regen*(1 - 0.1*akDevice.UD_condition)*afMult*UDCDmain.getStruggleDifficultyModifier()
        akDevice.refillDurability(loc_amount)
        akDevice.refillCuttingProgress(afTimePassed*loc_regen)
        akDevice.onMendPost(loc_amount)
    endif
EndFunction