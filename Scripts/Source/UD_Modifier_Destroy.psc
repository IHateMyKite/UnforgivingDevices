;/  File: UD_Modifier_Destroy
    This device will be destroyed on removal

    NameFull:   Destroy
    NameAlias:  DOR

    Parameters:

/;
ScriptName UD_Modifier_Destroy extends UD_Modifier

import UnforgivingDevicesMain

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    if akDevice.zad_DestroyOnRemove
        akDevice.GetWearer().RemoveItem(akDevice.deviceInventory, 1, true)
    EndIf
EndFunction