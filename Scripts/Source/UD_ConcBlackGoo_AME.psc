Scriptname UD_ConcBlackGoo_AME extends activemagiceffect  

UD_AbadonQuest_script Property UD_AbadonQuest auto

zadlibs_UDPatch Property libsp
    zadlibs_UDPatch Function get()
        return UD_AbadonQuest.UDCDmain.libsp
    EndFunction
EndProperty

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if !UD_AbadonQuest.UDmain.ActorIsValidForUD(akTarget)
        return ;non valid actor, return
    endif
    libsp.strip(akTarget,false)
    UD_AbadonQuest.AbadonEquipSuit(akTarget,UD_AbadonQuest.final_finisher_pref)
    libsp.strip(akTarget,false)
EndEvent