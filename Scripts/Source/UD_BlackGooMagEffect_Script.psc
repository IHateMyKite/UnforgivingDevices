Scriptname UD_BlackGooMagEffect_Script extends activemagiceffect  

import UnforgivingDevicesMain

;Int Property rare_device_chance = 25 auto
UD_AbadonQuest_script Property AbadonQuest auto
UD_libs Property UDlibs auto
UDCustomDeviceMain Property UDCDmain auto
zadlibs Property libs auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    AbadonQuest.EquipAbadonDevices(akTarget, 0, iRange(Round(GetMagnitude()),1,20))
EndEvent


