Scriptname UD_OutfitAbadon extends UD_Outfit

; Abadon suits use their own plugs/piercings which require more complicated logic, so just skip this part
Bool Function LockPlugVaginal(Actor akActor)
EndFunction
Bool Function LockPlugAnal(Actor akActor)
EndFunction
Bool Function LockPiercingVaginal(Actor akActor)
EndFunction
Bool Function LockPiercingNipples(Actor akActor)
EndFunction

Int Function LockDevicePost(Actor akActor, Int aiLocked)
    UDmain.ItemManager.lockAbadonPiercings(akActor)
    UDmain.ItemManager.lockAbadonHelperPlugs(akActor)
    return 0
EndFunction