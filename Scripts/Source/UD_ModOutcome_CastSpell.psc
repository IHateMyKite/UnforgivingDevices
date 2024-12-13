;/  File: UD_ModOutcome_CastSpell
    Casts a spell

    NameFull: Cast Spell

    Parameters in DataStr (indices relative to DataStrOffset property):
        None

    Form arguments:
        Form4               Spell to cast or FormLists with spells
        
        Form5               Spell to cast or FormLists with spells

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_CastSpell::Outcome() akModifier = " + akModifier + ", akDevice = " + akDevice + ", aiDataStr = " + aiDataStr + ", akForm4 = " + akForm4 + ", akForm5 = " + akForm5, 3)
    EndIf
    Form[] loc_forms = CombineForms(akForm4, akForm5)
    If loc_forms.Length > 0
        Spell loc_spell = loc_forms[RandomInt(0, loc_forms.length - 1)] as Spell
        If loc_spell != None
            loc_spell.Cast(akDevice.GetWearer(), akDevice.GetWearer())
        EndIf
    EndIf
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
    String loc_res = ""
    If akForm4
        loc_res += akModifier.PrintFormListSelectionDetails(akForm4, "R")
    EndIf
    If akForm5
        loc_res += akModifier.PrintFormListSelectionDetails(akForm5, "R")
    EndIf
    Return loc_res
EndFunction