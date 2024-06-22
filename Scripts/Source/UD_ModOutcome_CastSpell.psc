;/  File: UD_ModOutcome_CastSpell
    Casts a spell

    NameFull: Cast Spell

    Parameters in DataStr (indices relative to DataStrOffset property):
    

    Form arguments:
        Form3 - Spell to cast or FormLists with spells
        Form4 - Spell to cast or FormLists with spells

    Example:
/;
Scriptname UD_ModOutcome_CastSpell extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_CastSpell::Outcome() akModifier = " + akModifier + ", akDevice = " + akDevice + ", aiDataStr = " + aiDataStr + ", akForm3 = " + akForm3 + ", akForm4 = " + akForm4, 3)
    EndIf
    Form[] loc_forms = CombineForms(akForm3, akForm4)
    If loc_forms.Length > 0
        Spell loc_spell = loc_forms[RandomInt(0, loc_forms.length - 1)] as Spell
        If loc_spell != None
            loc_spell.Cast(akDevice.GetWearer(), akDevice.GetWearer())
        EndIf
    EndIf
EndFunction

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)
    String loc_str = ""
    loc_str += "Applies spell"
    loc_str += "\n"
    loc_str += "Source: " + akForm3 + ", " + akForm4
    
    Return loc_str
EndFunction
