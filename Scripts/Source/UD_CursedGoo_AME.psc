Scriptname UD_CursedGoo_AME extends activemagiceffect  

UDCustomDeviceMain Property UDCDmain auto
UD_Libs Property UDlibs auto
zadlibs Property libs auto
Event OnEffectStart(Actor akTarget, Actor akCaster)
	UDCDmain.DisableActor(akTarget)
	libs = UDCDmain.libs
	UDlibs = UDCDmain.UDlibs
	UDlibs.Update()
	libs.LockDevice(akTarget,UDlibs.PunisherArmbinder)
	libs.LockDevice(akTarget,UDlibs.PunisherPiercing)
	UDCDmain.EnableActor(akTarget)
EndEvent