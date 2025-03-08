;   File: UD_Patcher_ModPreset1_Loose
;   
Scriptname UD_Patcher_ModPreset1_Loose extends UD_Patcher_ModPreset1

Int Function CheckDeviceCompatibility(UD_CustomDevice_RenderScript akDevice, Bool abCheckWearer = True)
    If !akDevice.CanBeStruggled(1.0) || akDevice.CanBeStruggled(0.0) || akDevice.IsPlug()
        Return -1
    Endif
    Return Parent.CheckDeviceCompatibility(akDevice, abCheckWearer)
EndFunction

Float Function GetProbability(UD_CustomDevice_RenderScript akDevice, Float afGlobalProbabilityMult)
    Float loc_prob = Parent.GetProbability(akDevice, afGlobalProbabilityMult)
    If akDevice.UD_DeviceKeyword == GetModifier().libs.zad_DeviousBlindfold
        Return loc_prob * 0.70
    ElseIf akDevice.UD_DeviceKeyword == GetModifier().libs.zad_DeviousGag
        Return loc_prob * 0.30
    ElseIf akDevice.UD_DeviceKeyword == GetModifier().libs.zad_DeviousHood || akDevice.isMittens()
        Return loc_prob * 1.0
    Else
        Return loc_prob * 0.50
    Endif
EndFunction