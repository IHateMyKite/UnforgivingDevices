;/  File: UD_ModOutcome_CastSpell
    Casts a spell

    NameFull: Cast Spell

    Parameters in DataStr (indices relative to DataStrOffset property):
    

    Form arguments:
        Form1 - Spell to cast or FormLists with spells
        Form2 - Spell to cast or FormLists with spells
        Form3 - Spell to cast or FormLists with spells

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_CastSpell::Outcome() akModifier = " + akModifier + ", akDevice = " + akDevice + ", aiDataStr = " + aiDataStr + ", akForm1 = " + akForm1, 3)
    EndIf
    Form[] loc_forms = CombineForms(akForm1, akForm2, akForm3)
    If loc_forms.Length > 0
        Spell loc_spell = loc_forms[RandomInt(0, loc_forms.length - 1)] as Spell
        If loc_spell != None
            loc_spell.Cast(akDevice.GetWearer(), akDevice.GetWearer())
        EndIf
    EndIf
EndFunction
