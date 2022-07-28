scriptName zadEventVibrate_UDPatch extends zadEventVibrate

UDCustomDeviceMain Property UDCDmain auto

bool Function HasKeywords(actor akActor)
    if akActor.hasKeyword(UDCDmain.UDlibs.UnforgivingDevice) && UDCDmain.isRegistered(akActor)
        if UDCDmain.getVibratorNum(akActor) 
            return false
        else
            return parent.HasKeywords(akActor)
        endif
    else
        return parent.HasKeywords(akActor)
    endif
EndFunction