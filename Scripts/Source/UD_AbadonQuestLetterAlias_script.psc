Scriptname UD_AbadonQuestLetterAlias_script extends ReferenceAlias  
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	if (akNewContainer == Game.getPlayer())
		;GetOwningQuest().setStage(10)
		GetOwningQuest().SetObjectiveDisplayed(10)
	endif
EndEvent


Event OnRead()
	if (GetOwningQuest() as UD_AbadonQuest_script).UseAnalVariant
		(GetOwningQuest().getAliasByName("AbadonPlugAnalAlias") as ReferenceAlias).TryToEnable()
	else
		(GetOwningQuest().getAliasByName("AbadonPlugAlias") as ReferenceAlias).TryToEnable()
	endif
	MCM.AbadonQuestFlag = MCM.OPTION_FLAG_DISABLED
	GetOwningQuest().SetObjectiveCompleted(10)
	GetOwningQuest().SetObjectiveDisplayed(20)	
EndEvent

UD_MCM_script Property MCM auto