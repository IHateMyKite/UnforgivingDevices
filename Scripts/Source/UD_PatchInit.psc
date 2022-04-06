Scriptname UD_PatchInit extends Quest


Formlist Property KeywordFormList auto
Keyword[] Property QuestKeywords auto
UD_RandomRestraintManager Property UDRRM auto

;
Armor[] Property UD_PatchRandomDeviceList_ArmCuffs auto
Armor[] Property UD_PatchRandomDeviceList_LegCuffs auto
Armor[] Property UD_PatchRandomDeviceList_Collar auto
Armor[] Property UD_PatchRandomDeviceList_Boots auto
Armor[] Property UD_PatchRandomDeviceList_Belt auto
Armor[] Property UD_PatchRandomDeviceList_Bra auto
Armor[] Property UD_PatchRandomDeviceList_Gag auto
Armor[] Property UD_PatchRandomDeviceList_Hood auto
Armor[] Property UD_PatchRandomDeviceList_Blindfold auto

Armor[] Property UD_PatchRandomDeviceList_HeavyBondageWeak auto
Armor[] Property UD_PatchRandomDeviceList_HeavyBondage auto
Armor[] Property UD_PatchRandomDeviceList_HeavyBondage_Suit auto
Armor[] Property UD_PatchRandomDeviceList_HeavyBondageHard auto

Armor[] Property UD_PatchRandomDeviceList_Suit auto		    ;9
Armor[] Property UD_PatchRandomDeviceList_PlugVaginal auto		;10
Armor[] Property UD_PatchRandomDeviceList_PlugAnal auto	    ;11
Armor[] Property UD_PatchRandomDeviceList_PiercingVag auto		;12
Armor[] Property UD_PatchRandomDeviceList_PiercingNipple auto	;13
Armor[] Property UD_PatchRandomDeviceList_Gloves auto 			;14


Event onInit()
	Utility.wait(Utility.randomFloat(1.0,4.0))
	int i = QuestKeywords.length
	while i
		i-=1
		KeywordFormList.addForm(QuestKeywords[i])
	endwhile
	if UDRRM
		ProccesRandomDevices(UD_PatchRandomDeviceList_ArmCuffs,UDRRM.UD_RandomDeviceList_ArmCuffs)
		ProccesRandomDevices(UD_PatchRandomDeviceList_LegCuffs,UDRRM.UD_RandomDeviceList_LegCuffs)
		ProccesRandomDevices(UD_PatchRandomDeviceList_Collar,UDRRM.UD_RandomDeviceList_Collar)
		ProccesRandomDevices(UD_PatchRandomDeviceList_Boots,UDRRM.UD_RandomDeviceList_Boots)
		ProccesRandomDevices(UD_PatchRandomDeviceList_Belt,UDRRM.UD_RandomDeviceList_Belt)
		ProccesRandomDevices(UD_PatchRandomDeviceList_Bra,UDRRM.UD_RandomDeviceList_Bra)
		ProccesRandomDevices(UD_PatchRandomDeviceList_Gag,UDRRM.UD_RandomDeviceList_Gag)
		ProccesRandomDevices(UD_PatchRandomDeviceList_Hood,UDRRM.UD_RandomDeviceList_Hood)
		ProccesRandomDevices(UD_PatchRandomDeviceList_Blindfold,UDRRM.UD_RandomDeviceList_Blindfold)
		ProccesRandomDevices(UD_PatchRandomDeviceList_HeavyBondageWeak,UDRRM.UD_RandomDeviceList_HeavyBondageWeak)
		ProccesRandomDevices(UD_PatchRandomDeviceList_HeavyBondage,UDRRM.UD_RandomDeviceList_HeavyBondage)
		ProccesRandomDevices(UD_PatchRandomDeviceList_HeavyBondage_Suit,UDRRM.UD_RandomDeviceList_HeavyBondage_Suit)
		ProccesRandomDevices(UD_PatchRandomDeviceList_HeavyBondageHard,UDRRM.UD_RandomDeviceList_HeavyBondageHard)
		ProccesRandomDevices(UD_PatchRandomDeviceList_Suit,UDRRM.UD_RandomDeviceList_Suit)
		ProccesRandomDevices(UD_PatchRandomDeviceList_PlugVaginal,UDRRM.UD_RandomDeviceList_PlugVaginal)
		ProccesRandomDevices(UD_PatchRandomDeviceList_PlugAnal,UDRRM.UD_RandomDeviceList_PlugAnal)
		ProccesRandomDevices(UD_PatchRandomDeviceList_PiercingVag,UDRRM.UD_RandomDeviceList_PiercingVag)
		ProccesRandomDevices(UD_PatchRandomDeviceList_PiercingNipple,UDRRM.UD_RandomDeviceList_PiercingNipple)	
		ProccesRandomDevices(UD_PatchRandomDeviceList_Gloves,UDRRM.UD_RandomDeviceList_Gloves)	
	endif
EndEvent

Function ProccesRandomDevices(Armor[] aPatchList,FormList flTargetList)
	if !aPatchList 
		return
	endif
	if aPatchList.length
		Int i = aPatchList.length
		while i
			i-=1
			flTargetList.addForm(aPatchList[i])
		endwhile
	endif
EndFunction