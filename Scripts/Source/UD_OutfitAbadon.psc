Scriptname UD_OutfitAbadon extends UD_Outfit

import UD_Native

; Level needed for outfit to be available
Int Property LevelNeeded = 0 Auto

Bool Function Condition(Actor akActor)
    return parent.Condition(akActor) && (akActor.GetLevel() >= LevelNeeded)
EndFunction

Bool Function LockHood(Actor akActor)
    return parent.LockHood(akActor)
EndFunction
Bool Function LockGag(Actor akActor)
    return parent.LockGag(akActor)
EndFunction
Bool Function LockBlidnfold(Actor akActor)
    return parent.LockBlidnfold(akActor)
EndFunction
Bool Function LockCollar(Actor akActor)
    return parent.LockCollar(akActor)
EndFunction
Bool Function LockSuit(Actor akActor)
    return parent.LockSuit(akActor)
EndFunction
Bool Function LockBelt(Actor akActor)
    return parent.LockBelt(akActor)
EndFunction
Bool Function LockBra(Actor akActor)
    return parent.LockBra(akActor)
EndFunction
Bool Function LockCorsetHarness(Actor akActor)
    return parent.LockCorsetHarness(akActor)
EndFunction
Bool Function LockGloves(Actor akActor)
    return parent.LockGloves(akActor)
EndFunction
Bool Function LockCuffsArms(Actor akActor)
    return parent.LockCuffsArms(akActor)
EndFunction
Bool Function LockHeavyBondage(Actor akActor)
    return parent.LockHeavyBondage(akActor)
EndFunction
Bool Function LockBoots(Actor akActor)
    return parent.LockBoots(akActor)
EndFunction
Bool Function LockCuffsLegs(Actor akActor)
    return parent.LockCuffsLegs(akActor)
EndFunction
Bool Function LockPlugVaginal(Actor akActor)
    return parent.LockPlugVaginal(akActor)
EndFunction
Bool Function LockPlugAnal(Actor akActor)
    return parent.LockPlugAnal(akActor)
EndFunction
Bool Function LockPiercingVaginal(Actor akActor)
    return parent.LockPiercingVaginal(akActor)
EndFunction
Bool Function LockPiercingNipples(Actor akActor)
    return parent.LockPiercingNipples(akActor)
EndFunction

Bool Function LockDevicePre(Actor akActor)
    return parent.LockDevicePre(akActor)
EndFunction
Int Function LockDevicePost(Actor akActor, Int aiLocked)
    int loc_res = 0
    if !UD_PiercingVag || !UD_PiercingNip
        loc_res += UDmain.ItemManager.lockAbadonPiercings(akActor)
    endif
    if !UD_PlugVaginal || !UD_PlugAnal
        loc_res += UDmain.ItemManager.lockAbadonHelperPlugs(akActor)
    endif
    return loc_res
EndFunction