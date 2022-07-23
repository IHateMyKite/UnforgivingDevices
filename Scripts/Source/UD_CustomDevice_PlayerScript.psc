Scriptname UD_CustomDevice_PlayerScript extends ReferenceAlias  

UnforgivingDevicesMain Property UDmain auto

Event OnPlayerLoadGame()
    UDmain.OnGameReload()
EndEvent

