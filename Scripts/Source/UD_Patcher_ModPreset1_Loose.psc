;   File: UD_Patcher_ModPreset1_Loose
;   
Scriptname UD_Patcher_ModPreset1_Loose extends UD_Patcher_ModPreset1

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty

zadlibs Property libs
    zadlibs Function get()
        return UDmain.libs
    EndFunction
EndProperty

Int Function CheckDeviceCompatibility(UD_CustomDevice_RenderScript akDevice, Bool abCheckWearer = True)
    If !akDevice.CanBeStruggled(1.0) || akDevice.CanBeStruggled(0.0) || akDevice.IsPlug()
        Return -1
    Endif
    Return Parent.CheckDeviceCompatibility(akDevice, abCheckWearer)
EndFunction

Float Function GetProbability(UD_CustomDevice_RenderScript akDevice, Float afNormMult, Float afGlobalProbabilityMult)
    Float loc_prob = Parent.GetProbability(akDevice, afNormMult, afGlobalProbabilityMult)
    If akDevice.UD_DeviceKeyword == libs.zad_DeviousBlindfold
        Return loc_prob * 0.70
    ElseIf akDevice.UD_DeviceKeyword == libs.zad_DeviousGag
        Return loc_prob * 0.30
    ElseIf akDevice.UD_DeviceKeyword == libs.zad_DeviousHood || akDevice.isMittens()
        Return loc_prob * 1.0
    Else
        Return loc_prob * 0.50
    Endif
EndFunction