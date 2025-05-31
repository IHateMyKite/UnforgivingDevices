;/  File: UD_ModOutcome_CastSpell
    Casts a spell

    NameFull: Cast Spell

    Parameters in DataStr (indices relative to DataStrOffset property):
        None

    Form arguments:
        Form2               Spell to cast or FormLists with spells
        
        Form3               Spell to cast or FormLists with spells

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

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Spell loc_spell = UD_Modifier.GetRandomForm(akForm2, akForm3) as Spell

    PrintNotification(akDevice, ;/changed/; "and cast a magic spell.")

    If loc_spell
        loc_spell.Cast(akDevice.GetWearer(), akDevice.GetWearer())
    EndIf
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_res = ""
    If akForm2
        loc_res += akModifier.PrintFormListSelectionDetails(akForm2, "R")
    EndIf
    If akForm3
        loc_res += akModifier.PrintFormListSelectionDetails(akForm3, "R")
    EndIf
    Return loc_res
EndFunction