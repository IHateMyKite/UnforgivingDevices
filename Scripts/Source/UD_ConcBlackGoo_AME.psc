Scriptname UD_ConcBlackGoo_AME extends activemagiceffect  

UD_AbadonQuest_script Property UD_AbadonQuest auto

zadlibs_UDPatch Property libsp
    zadlibs_UDPatch Function get()
        return UD_AbadonQuest.UDCDmain.libsp
    EndFunction
EndProperty

Event OnEffectStart(Actor akTarget, Actor akCaster)
    libsp.strip(akTarget,false)
    UD_AbadonQuest.AbadonEquipSuit(akTarget,0)
    libsp.strip(akTarget,false)
EndEvent