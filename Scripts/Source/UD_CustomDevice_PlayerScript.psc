Scriptname UD_CustomDevice_PlayerScript extends ReferenceAlias  

zadlibs Property libs auto
UD_libs Property UDlibs auto 
UDCustomDeviceMain Property UDCDmain auto

Event OnPlayerLoadGame()
	UDCDmain.OnGameReset()
EndEvent

