Scriptname UD_RegisterNPC_AME extends activemagiceffect

UDCustomDeviceMain Property UDCDmain auto
Actor _target = none

Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    UDCDmain.UDCD_NPCM.RegisterNPC(akTarget,true)
EndEvent