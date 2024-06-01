;/  File: UD_ModOutcome_AddItem
    Summons item

    NameFull:   
    NameAlias:  AIT

    Parameters in DataStr:
        [5]     (optional) Number of items
                Default value: 1
        [6]     (optional) Equip item (i.e. drink potion)
                Default value: 0

    Form arguments:
        Form1 - Single item to add or FormList with items.
        Form2 - Single item to add or FormList with items.
        Form3 - Single item to add or FormList with items.

    Example:
/;
Scriptname UD_ModOutcome_AddItem extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)
EndFunction
