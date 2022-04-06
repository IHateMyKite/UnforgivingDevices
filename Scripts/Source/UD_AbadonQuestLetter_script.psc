Scriptname UD_AbadonQuestLetter_script extends ObjectReference  

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	if (akNewContainer == Game.getPlayer())
		AbadonQuest.setStage(10)
		AbadonQuest.SetObjectiveDisplayed(10)
	endif
EndEvent


Event OnRead()
	AbadonQuest.SetObjectiveCompleted(10)
	AbadonQuest.SetObjectiveDisplayed(20)
EndEvent


;ObjectReference Property Player auto
Quest Property AbadonQuest  Auto  
