Scriptname UD_BlackGooMagEffect_Script extends activemagiceffect  

import UnforgivingDevicesMain
import UD_Native

;Int Property rare_device_chance = 25 auto
UD_AbadonQuest_script   Property AbadonQuest    auto
UDCustomDeviceMain      Property UDCDmain       auto
zadlibs                 Property libs           auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    AbadonQuest.AbadonGooEffect(akTarget)
EndEvent


