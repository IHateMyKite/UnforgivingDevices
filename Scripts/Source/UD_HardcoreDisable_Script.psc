Scriptname UD_HardcoreDisable_Script extends activemagiceffect

; !!! REDUNDANT !!!

import UnforgivingDevicesMain

Actor _target = none
UDCustomDeviceMain      Property UDCDmain auto

UnforgivingDevicesMain  Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
EndProperty