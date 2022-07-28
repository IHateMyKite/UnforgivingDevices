Scriptname UD_PurifiedGoo_AME extends activemagiceffect  

UD_RandomRestraintManager Property UDRRM auto
UDCustomDeviceMain Property UDCDmain auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    UDCDmain.DisableActor(akTarget)
    int loc_filter = 0xffffffff
    if Utility.randomInt(0,1) ;50 % chance for suit
        loc_filter = Math.LogicalAnd(loc_filter,0xFFFFFDFF)
    endif
    UDRRM.LockAllSuitableRestrains(akTarget,false,loc_filter)
    UDCDmain.EnableActor(akTarget)
EndEvent