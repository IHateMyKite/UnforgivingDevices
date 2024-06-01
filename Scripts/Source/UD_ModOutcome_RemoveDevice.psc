;/  File: UD_ModOutcome_RemoveDevice
    Removes device(s)

    NameFull:   
    NameAlias:  RDD

    Parameters in DataStr:
        [5]     (optional) Number of positions (devices with suitable keywords)
                Default value: 1
        [6]     (optional) Selection method (in general or for the keyword in list akForm1)
                    FIRST or F      - first suitable keyword from the list (akForm1, akForm2, akForm3 concatenated together)
                    RANDOM or R     - random keyword from the list (akForm1, akForm2, akForm3 concatenated together)
                Default value: R
        [7]     (optional) Selection method for the keywords in list akForm2
        [8]     (optional) Selection method for the keywords in list akForm3

    Form arguments:
        Form1 - Single device keyword to remove or FormList with keywords.
        Form2 - Single device keyword to remove or FormList with keyword.
        Form3 - Single device keyword to remove or FormList with keywords.

    Example:
/;
Scriptname UD_ModOutcome_RemoveDevice extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)
EndFunction
