Scriptname UD_CursedGoo_AME extends activemagiceffect  

UDCustomDeviceMain Property UDCDmain auto
UD_Libs Property UDlibs auto
zadlibs Property libs auto
Event OnEffectStart(Actor akTarget, Actor akCaster)
	UDCDmain.DisableActor(akTarget)
	libs = UDCDmain.libs
	UDlibs = UDCDmain.UDlibs
	UDlibs.Update()
	libs.LockDevice(akTarget,UDlibs.PunisherPiercing)
	libs.LockDevice(akTarget,UDlibs.AbadonSuit)
	libs.LockDevice(akTarget,UDlibs.PunisherArmbinder)
	UDCDmain.EnableActor(akTarget)
EndEvent