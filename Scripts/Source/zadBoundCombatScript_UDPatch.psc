Scriptname zadBoundCombatScript_UDPatch Extends zadBoundCombatScript Hidden

Function EvaluateAA(actor akActor)
	if StorageUtil.GetIntValue(akActor,"DDStartBoundEffectQue",0)
		return
	endif
	StorageUtil.SetIntValue(akActor,"DDStartBoundEffectQue",1)
	
	bool loc_paralysis = false
	while akActor.getAV("Paralysis")
		loc_paralysis = true
		Utility.wait(1.0) ;wait for actors paralysis to worn out first, because it can cause issue if idle is set when paralysed
	endwhile
	
	if loc_paralysis
		Utility.wait(8.0)
	endif
	
	parent.EvaluateAA(akActor)
	StorageUtil.UnSetIntValue(akActor,"DDStartBoundEffectQue")
EndFunction