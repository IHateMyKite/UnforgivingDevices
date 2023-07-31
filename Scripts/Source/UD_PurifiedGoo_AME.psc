Scriptname UD_PurifiedGoo_AME extends activemagiceffect  

UDCustomDeviceMain Property UDCDmain auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if !UDCDMain.UDmain.ActorIsValidForUD(akTarget)
        return ;non valid actor, return
    endif
    UDCDmain.DisableActor(akTarget)
    int loc_filter = 0xffffffff
    if Utility.randomInt(0,1) ;50 % chance for suit being excluded from equip for bra and belt being visible
        loc_filter = Math.LogicalAnd(loc_filter,0xFFFFBFFF)
    endif
    UDCDmain.UDMain.UDRRM.LockAllSuitableRestrains(akTarget,false,loc_filter)
    UDCDmain.EnableActor(akTarget)
EndEvent