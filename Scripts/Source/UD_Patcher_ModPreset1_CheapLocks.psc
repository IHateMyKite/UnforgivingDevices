;   File: UD_Patcher_ModPreset1_CheapLocks
;   
Scriptname UD_Patcher_ModPreset1_CheapLocks extends UD_Patcher_ModPreset1

Int Function CheckDeviceCompatibility(UD_CustomDevice_RenderScript akDevice, Bool abCheckWearer = True)
    If (akDevice.GetLockNumber() == 0)
        Return -1
    Endif
    Return Parent.CheckDeviceCompatibility(akDevice, abCheckWearer)
EndFunction