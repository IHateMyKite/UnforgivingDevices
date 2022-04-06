Scriptname UD_ConcBlackGoo_AME extends activemagiceffect  

UD_AbadonQuest_script Property UD_AbadonQuest auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	UD_AbadonQuest.AbadonEquipSuit(akTarget,0)
EndEvent