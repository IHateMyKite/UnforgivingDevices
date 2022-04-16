Scriptname UD_Patcher extends Quest  
{Patches devices and safecheck animations}

zadlibs Property libs auto
UDCustomDeviceMain Property UDCDmain auto
UD_libs Property UDlibs auto

Float Property UD_PatchMult = 1.0 auto
bool Property UD_PatcherMutex = false auto

;MCM options
Float Property UD_ManifestMod = 1.0 auto


;modifiers switches
Int Property UD_MAOChanceMod = 100 auto
int Property UD_MAOMod = 100 auto
Int Property UD_MAHChanceMod = 100 auto
int Property UD_MAHMod = 100 auto

Bool Property Ready = False auto
Event OnInit()
	Ready = True
EndEvent

string[] Function GetHeavyBondageAnimation_Armbinder(bool hobble = false)
	string[] temp
	int loc_animNum = 0
	if !hobble
		loc_animNum = 5
		if UDCDmain.UDmain.ZaZAnimationPackInstalled
			loc_animNum += 6
		endif
		temp = Utility.CreateStringArray(loc_animNum)
		temp[0] = "DDRegArmbStruggle01"
		temp[1] = "DDRegArmbStruggle02"
		temp[2] = "DDRegArmbStruggle03"
		temp[3] = "DDRegArmbStruggle04"
		temp[4] = "DDRegArmbStruggle05"
		if UDCDmain.UDmain.ZaZAnimationPackInstalled
			temp[5] = "ZapArmbStruggle01"
			temp[6] = "ZapArmbStruggle03"
			temp[7] = "ZapArmbStruggle05"
			temp[8] = "ZapArmbStruggle07"
			temp[9] = "ZapArmbStruggle08"
			temp[10] = "ZapArmbStruggle10"
		endif
	else
		loc_animNum = 2
		if UDCDmain.UDmain.ZaZAnimationPackInstalled
			loc_animNum += 3
		endif
		temp = Utility.CreateStringArray(loc_animNum)
		temp[0] = "DDHobArmbStruggle01"
		temp[1] = "DDHobArmbStruggle02"
		if UDCDmain.UDmain.ZaZAnimationPackInstalled
			temp[2] = "ZapArmbStruggle02"
			temp[3] = "ZapArmbStruggle06"
			temp[4] = "ZapArmbStruggle09"
		endif
	endif
	return temp
EndFunction


Function safeCheckAnimations(UD_CustomDevice_RenderScript device,bool force = false)
	if !device.UD_struggleAnimations || force
		string[] temp 
		int loc_animNum = 0
		if device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinder)
			temp = GetHeavyBondageAnimation_Armbinder(false)
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinderElbow)
			temp = new string[5]
			temp[0] = "DDRegElbStruggle01"
			temp[1] = "DDRegElbStruggle02"
			temp[2] = "DDRegElbStruggle03"
			temp[3] = "DDRegElbStruggle04"
			temp[4] = "DDRegElbStruggle05"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousStraitJacket)
			loc_animNum = 9
			if UDCDmain.UDmain.ZaZAnimationPackInstalled
				loc_animNum += 6
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDRegElbStruggle01"
			temp[1] = "DDRegElbStruggle02"
			temp[2] = "DDRegElbStruggle03"
			temp[3] = "DDRegElbStruggle04"
			temp[4] = "DDRegElbStruggle05"
			temp[5] = "DDElbowTie_struggleone"
			temp[6] = "DDElbowTie_struggletwo"
			temp[7] = "DDElbowTie_strugglethree"
			temp[8] = "DDRegbbyokeStruggle01"
			if UDCDmain.UDmain.ZaZAnimationPackInstalled
				temp[9] = "ZapArmbStruggle01"
				temp[10] = "ZapArmbStruggle03"
				temp[11] = "ZapArmbStruggle05"
				temp[12] = "ZapArmbStruggle07"
				temp[13] = "ZapArmbStruggle08"
				temp[14] = "ZapArmbStruggle10"
			endif
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousCuffsFront)
			temp = new string[2]
			temp[0] = "DDRegcuffsfrontStruggle02"
			temp[1] = "DDRegcuffsfrontStruggle03"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousYoke)
			loc_animNum = 5
			if UDCDmain.UDmain.ZaZAnimationPackInstalled
				loc_animNum += 6
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDRegYokeStruggle01"
			temp[1] = "DDRegYokeStruggle02"
			temp[2] = "DDRegYokeStruggle03"
			temp[3] = "DDRegYokeStruggle04"
			temp[4] = "DDRegYokeStruggle05"
			if UDCDmain.UDmain.ZaZAnimationPackInstalled
				temp[5] = "ZapYokeStruggle01"
				temp[6] = "ZapYokeStruggle03"
				temp[7] = "ZapYokeStruggle05"
				temp[8] = "ZapYokeStruggle07"
				temp[9] = "ZapYokeStruggle08"
				temp[10] = "ZapYokeStruggle10"
			endif
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousYokeBB)
			temp = new string[5]
			temp[0] = "DDRegbbyokeStruggle01"
			temp[1] = "DDRegbbyokeStruggle02"
			temp[2] = "DDRegbbyokeStruggle03"
			temp[3] = "DDRegbbyokeStruggle04"
			temp[4] = "DDRegbbyokeStruggle05"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousElbowTie)
			temp = new string[3]
			temp[0] = "DDElbowTie_struggleone"
			temp[1] = "DDElbowTie_struggletwo"
			temp[2] = "DDElbowTie_strugglethree"
		elseif device.deviceRendered.hasKeyword(libs.zad_deviousGag)
			temp = new string[1]
			temp[0] = "ft_struggle_gag_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousLegCuffs) || device.deviceRendered.hasKeyword(libs.zad_DeviousBoots)
			temp = new string[1]
			temp[0] = "ft_struggle_boots_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousArmCuffs) || device.deviceRendered.hasKeyword(libs.zad_DeviousGloves) || device.deviceRendered.hasKeyword(libs.zad_DeviousBondageMittens)
			temp = new string[1]
			temp[0] = "ft_struggle_gloves_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousCollar)
			temp = new string[1]
			temp[0] = "ft_struggle_head_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousBlindfold) || device.deviceRendered.hasKeyword(libs.zad_DeviousHood)
			temp = new string[1]
			temp[0] = "ft_struggle_blindfold_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousSuit)
			temp = new string[2]
			temp[0] = "ft_struggle_boots_1"
			temp[1] = "ft_struggle_gloves_1"
			;temp[2] = "ft_struggle_gag_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousBelt)
			temp = new string[2]
			temp[0] = "DDChastityBeltStruggle01"
			temp[1] = "DDChastityBeltStruggle02"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousPlug)
			temp = new string[2]
			temp[0] = "DDZazHornyA"
			temp[1] = "DDZazHornyD"
		else	
			temp = new string[1] ;default for other devices
			temp[0] = "ft_struggle_gag_1"
		endif
		device.UD_struggleAnimations = temp
	endif
	
	if !device.UD_struggleAnimationsHobl || force
		string[] temp
		int loc_animNum = 0
		if device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinder)
			temp = GetHeavyBondageAnimation_Armbinder(true)
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinderElbow)
			temp = new string[2]
			temp[0] = "DDHobElbStruggle01"
			temp[1] = "DDHobElbStruggle02"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousStraitJacket)
			loc_animNum = 2
			if UDCDmain.UDmain.ZaZAnimationPackInstalled
				loc_animNum += 3
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDHobElbStruggle01"
			temp[1] = "DDHobElbStruggle02"
			if UDCDmain.UDmain.ZaZAnimationPackInstalled
				temp[2] = "ZapArmbStruggle02"
				temp[3] = "ZapArmbStruggle06"
				temp[4] = "ZapArmbStruggle09"
			endif
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousCuffsFront)
			temp = new string[2]
			temp[0] = "DDHobCuffsFrontStruggle01"
			temp[1] = "DDHobCuffsFrontStruggle02"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousYoke)
			loc_animNum = 2
			if UDCDmain.UDmain.ZaZAnimationPackInstalled
				loc_animNum += 3
			endif
			temp = Utility.CreateStringArray(loc_animNum)
			temp[0] = "DDHobYokeStruggle01"
			temp[1] = "DDHobYokeStruggle02"
			if UDCDmain.UDmain.ZaZAnimationPackInstalled
				temp[2] = "ZapYokeStruggle02"
				temp[3] = "ZapYokeStruggle06"
				temp[4] = "ZapYokeStruggle09"
			endif
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousYokeBB)
			temp = new string[2]
			temp[0] = "DDHobBBYokeStruggle01"
			temp[1] = "DDHobBBYokeStruggle02"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousElbowTie)
			temp = new string[3]
			temp[0] = "DDElbowTie_struggleone"
			temp[1] = "DDElbowTie_struggletwo"
			temp[2] = "DDElbowTie_strugglethree"
		elseif device.deviceRendered.hasKeyword(libs.zad_deviousGag)
			temp = new string[1]
			temp[0] = "ft_struggle_gag_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousLegCuffs) || device.deviceRendered.hasKeyword(libs.zad_DeviousBoots)
			temp = new string[1]
			temp[0] = "ft_struggle_boots_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousArmCuffs) || device.deviceRendered.hasKeyword(libs.zad_DeviousGloves) || device.deviceRendered.hasKeyword(libs.zad_DeviousBondageMittens)
			temp = new string[1]
			temp[0] = "ft_struggle_gloves_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousCollar)
			temp = new string[1]
			temp[0] = "ft_struggle_head_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousBlindfold) || device.deviceRendered.hasKeyword(libs.zad_DeviousHood)
			temp = new string[1]
			temp[0] = "ft_struggle_blindfold_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousSuit)
			temp = new string[2]
			temp[0] = "ft_struggle_boots_1"
			temp[1] = "ft_struggle_gloves_1"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousBelt)
			temp = new string[2]
			temp[0] = "DDChastityBeltStruggle01"
			temp[1] = "DDChastityBeltStruggle02"
		elseif device.deviceRendered.hasKeyword(libs.zad_DeviousPlug)
			temp = new string[2]
			temp[0] = "DDZazHornyA"
			temp[1] = "DDZazHornyD"
		else	
			temp = new string[1] ;default for other devices
			temp[0] = "ft_struggle_gag_1"
		endif
		device.UD_struggleAnimationsHobl = temp
	endif
EndFunction

Function patchHeavyBondage(UD_CustomHeavyBondage_RenderScript device)
	device.UD_LockpickDifficulty = 25
	device.UD_LockAccessDifficulty = 100.0
	device.UD_CutChance = 0.0

	device.UD_ResistPhysical = Utility.randomFloat(-0.1,0.7)
	device.UD_ResistMagicka = Utility.randomFloat(-0.5,0.75)
	device.UD_base_stat_drain = Utility.randomFloat(8.0,10.0)
	device.UD_StruggleCritDuration = Utility.randomFloat(0.62,0.9)
	device.UD_StruggleCritChance = Utility.randomInt(8,15)
	device.UD_StruggleCritMul = Utility.randomFloat(4.0,8.0)
	device.UD_LockpickDifficulty = 25*Utility.randomInt(1,3)
	
	int sentientModChance = 40
	device.UD_durability_damage_base = Utility.randomFloat(0.1,0.8)
	
	int loc_control = 0x0F
	
	if device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinder)
		device.UD_durability_damage_base = Utility.randomFloat(0.7,1.0)
		device.UD_CutChance = Utility.randomFloat(5.0,20.0)
		device.UD_Locks = 2
		if isSteel(device)
			device.UD_Locks = 6
			device.UD_LockpickDifficulty = 50 ;Adept
			device.UD_LockAccessDifficulty = 85
			;_AutoPatchLockpicking = False
			;_AutoPatchLockAcces = False
			loc_control = Math.LogicalAnd(loc_control,0x03)
		endif
	elseif device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinderElbow)
		device.UD_durability_damage_base = Utility.randomFloat(0.65,0.8)
		device.UD_Locks = 2
		device.UD_CutChance = Utility.randomFloat(5.0,12.0)
		if isSteel(device)
			device.UD_Locks = 6
			device.UD_LockpickDifficulty = 50 ;Adept
			device.UD_LockAccessDifficulty = 85
			;_AutoPatchLockpicking = False
			;_AutoPatchLockAcces = False
			loc_control = Math.LogicalAnd(loc_control,0x03)
		endif		
	elseif device.deviceRendered.hasKeyword(libs.zad_DeviousStraitJacket)
		device.UD_durability_damage_base = Utility.randomFloat(0.7,0.9)
		device.UD_Locks = 6
		device.UD_CutChance = Utility.randomFloat(2.0,8.0)
		sentientModChance = 75
		if isSteel(device)
			device.UD_Locks = 6
			device.UD_LockpickDifficulty = 50 ;Adept
			device.UD_LockAccessDifficulty = 85
			;_AutoPatchLockpicking = False
			;_AutoPatchLockAcces = False
			loc_control = Math.LogicalAnd(loc_control,0x03)
		endif
	elseif device.deviceRendered.hasKeyword(libs.zad_DeviousCuffsFront)
		device.UD_durability_damage_base = Utility.randomFloat(0.3,0.8)
		device.UD_Locks = 4
		device.UD_LockAccessDifficulty = Utility.randomInt(70,80)
		
	elseif device.deviceRendered.hasKeyword(libs.zad_DeviousYoke)
		device.UD_durability_damage_base = Utility.randomFloat(0.1,0.3)
		device.UD_Locks = 2
		device.UD_LockAccessDifficulty = Utility.randomInt(75,90)
		
	elseif device.deviceRendered.hasKeyword(libs.zad_DeviousYokeBB)
		device.UD_durability_damage_base = Utility.randomFloat(0.2,0.4)
		device.UD_Locks = 2
		device.UD_LockAccessDifficulty = Utility.randomInt(55,65)

	elseif device.deviceRendered.hasKeyword(libs.zad_DeviousElbowTie)
		device.UD_durability_damage_base = Utility.randomFloat(0.05,0.1)
		device.UD_Locks = 1
		device.UD_LockpickDifficulty = 100
		device.UD_StruggleCritChance = Utility.randomInt(4,7)
		device.UD_StruggleCritMul = Utility.randomFloat(500.0,1500.0)
		sentientModChance = 65
	elseif device.deviceRendered.hasKeyword(libs.zad_DeviousPetSuit)
		device.UD_durability_damage_base = Utility.randomFloat(0.9,1.4)
		device.UD_Locks = 4
		device.UD_LockAccessDifficulty = Utility.randomInt(60,80)
		device.UD_CutChance = Utility.randomFloat(2.0,5.0)
		sentientModChance = 75
	endif
	
	;materials
	if (StringUtil.find(device.deviceInventory.getName(),"High Security") != -1 || StringUtil.find(device.deviceInventory.getName(),"Secure") != -1)
		device.UD_durability_damage_base /= 4.0
		device.UD_StruggleCritDuration = 0.5
		device.UD_Locks += 2
		device.UD_LockpickDifficulty = 100
		if device.UD_LockAccessDifficulty < 85
			device.UD_LockAccessDifficulty = 85
		endif
		
		device.UD_ResistPhysical = Utility.randomFloat(0.5,0.9)
		device.UD_ResistMagicka = Utility.randomFloat(-0.3,1.0)
	endif
	
	checkSentientModifier(device,sentientModChance,3.0)

	if isEbonite(device)
		checkMendingModifier(device,55,1.25)
	else
		checkMendingModifier(device,35,0.8)
	endif
	
	patchFinish(device,loc_control)
EndFunction

Function patchBlindfold(UD_CustomBlindfold_RenderScript device)
	patchDefaultValues(device)
	;materials
	if StringUtil.find(device.deviceInventory.getName(),"Extreme") != -1 || (StringUtil.find(device.deviceInventory.getName(),"High Security") != -1 || StringUtil.find(device.deviceInventory.getName(),"Secure") != -1)
		device.UD_Locks = 4
		device.UD_LockpickDifficulty = 100
		device.UD_durability_damage_base = Utility.randomFloat(0.1,0.3)
		
		device.UD_ResistPhysical = Utility.randomFloat(0.4,0.8)
		device.UD_ResistMagicka = Utility.randomFloat(0.2,1.0)

	endif
	
	checkSentientModifier(device,15,1.0)
	
	checkLooseModifier(device,75,0.2,0.5)
	
	patchFinish(device)
EndFunction

Function patchGag(UD_CustomGag_RenderScript device)
	patchDefaultValues(device)
	
	if StringUtil.find(device.deviceInventory.getName(),"Extreme") != -1 || (StringUtil.find(device.deviceInventory.getName(),"High Security") != -1 || StringUtil.find(device.deviceInventory.getName(),"Secure") != -1)
		device.UD_Locks = 4
		device.UD_LockpickDifficulty = 100
		device.UD_durability_damage_base = Utility.randomFloat(0.2,0.4)
				
	endif
	
	checkSentientModifier(device,10,1.0)
	
	checkLooseModifier(device,30,0.05, 0.15)
	
	if device as UD_CustomPanelGag_RenderScript
		(device as UD_CustomPanelGag_RenderScript).UD_RemovePlugDifficulty = Utility.randomInt(50,100)
	endif

	patchFinish(device)
EndFunction

Function patchBelt(UD_CustomBelt_RenderScript device)
	patchDefaultValues(device)
	
	device.UD_Locks = Utility.randomInt(2,5)
	device.UD_Cooldown = UDCDmain.UDmain.Round(Utility.randomInt(140,200)/UDCDmain.fRange(UD_PatchMult,0.5,2.0))
	;materials
	if isEbonite(device)
		device.UD_ResistPhysical = Utility.randomFloat(-0.25,0.7)
		device.UD_ResistMagicka = Utility.randomFloat(0.25,0.5)
	elseif (StringUtil.find(device.deviceInventory.getName(),"Leather") != -1)
		device.UD_ResistPhysical = Utility.randomFloat(-0.4,0.1)
		device.UD_ResistMagicka = Utility.randomFloat(-0.5,0.5)
	elseif (StringUtil.find(device.deviceInventory.getName(),"Rope") != -1)
		device.UD_ResistPhysical = Utility.randomFloat(-0.5,0.0)
		device.UD_ResistMagicka = Utility.randomFloat(-0.1,0.1)
		device.UD_Locks = 0
	endif
				
	checkSentientModifier(device,70,1.25)
	
	patchFinish(device)
EndFunction

Function patchPlug(UD_CustomPlug_RenderScript device)
	patchDefaultValues(device)
	
	device.UD_Locks = 0
	device.UD_durability_damage_base = Utility.randomFloat(10.0,20.0)
	device.UD_VibDuration = Math.Floor(Utility.randomInt(45,80)*UDCDmain.fRange(UD_PatchMult,0.5,5.0))
	device.UD_OrgasmMult  = Utility.randomFloat(0.75,1.5)*UDCDmain.fRange(UD_PatchMult,0.7,1.0)
	device.UD_ArousalMult = Utility.randomFloat(0.5,1.5)*UDCDmain.fRange(UD_PatchMult,1.0,5.0)
	device.UD_Cooldown = UDCDmain.UDmain.Round(Utility.randomInt(120,240)/UDCDmain.fRange(UD_PatchMult,0.5,2.0))
	
	int loc_control = 0x0F
		
	loc_control = Math.LogicalAnd(loc_control,0x06)
	
	if device as UD_CustomInflatablePlug_RenderScript
		(device as UD_CustomInflatablePlug_RenderScript).UD_PumpDifficulty = Utility.randomInt(50,100)
		(device as UD_CustomInflatablePlug_RenderScript).UD_DeflateRate = Utility.randomInt(150,250)
	elseif device as UD_ControlablePlug_RenderScript
		device.UD_VibDuration = Utility.randomInt(450,750)
		device.UD_Cooldown = UDCDmain.UDmain.Round(Utility.randomInt(300,420)/UDCDmain.fRange(UD_PatchMult,0.5,2.0))
	else
		
	endif
	
	if device.zad_deviceKey ;lockable plug
		device.UD_Locks = 1
		device.UD_LockAccessDifficulty = 70
		device.UD_durability_damage_base = 0.0 
	endif
	checkMAOModifier(device,25,10,25)
	
	checkSentientModifier(device,50,1.25)
	patchFinish(device,loc_control)
EndFunction

Function patchHood(UD_CustomHood_RenderScript device)
	patchDefaultValues(device)
	;patchStart(device)
	checkSentientModifier(device,20,1.0)
	checkLooseModifier(device,100,0.05, 0.4)
	patchFinish(device)
EndFunction

Function patchBra(UD_CustomBra_RenderScript device)
	patchDefaultValues(device)
	;patchStart(device)
	device.UD_Locks = Utility.randomInt(2,4)
	device.UD_LockpickDifficulty = 25*Utility.randomInt(1,3)
	device.UD_LockAccessDifficulty = Utility.randomFloat(70.0,90.0)
	device.UD_durability_damage_base *= 0.5
	checkSentientModifier(device,25,1.3)
	patchFinish(device)
EndFunction

Function patchGeneric(UD_CustomDevice_RenderScript device)
	patchDefaultValues(device)
	;patchStart(device)
		
	If device as UD_CustomGloves_RenderScript
		device.UD_Locks = Utility.randomInt(1,3)*2
	EndIf
	
	If device as UD_CustomBoots_RenderScript
		device.UD_Locks = Utility.randomInt(1,3)*2
	EndIf
	int loc_control = 0x0F
	if device as UD_CustomMittens_RenderScript
		device.UD_Locks = 2
		if !device.UD_durability_damage_base
			device.UD_durability_damage_base = Utility.randomFloat(0.25,1.0) ;so mittens are always escapable
		endif
		checkLooseModifier(device,100,0.25, 1.0)
		loc_control = Math.LogicalAnd(loc_control,0x0E)
	endif
	
	If device as UD_CustomDynamicHeavyBondage_RS
		(device as UD_CustomDynamicHeavyBondage_RS).UD_UntieDifficulty = Utility.randomFloat(75.0,125.0)
		device.UD_Locks = Utility.randomInt(1,3)*2
		checkLooseModifier(device,100,0.5, 0.9)
		device.UD_Cooldown = UDCDmain.Round(Utility.randomInt(160,240)/UDCDmain.fRange(UD_PatchMult,0.5,2.0))
	EndIf
	
	checkLooseModifier(device,50,0.15, 0.4)
	checkSentientModifier(device,10,1.0)
	
	patchFinish(device,loc_control)
EndFunction

Function patchPiercing(UD_CustomPiercing_RenderScript device)
	patchDefaultValues(device)
	;patchStart(device)
	device.UD_VibDuration = UDCDmain.UDmain.Round(Utility.randomInt(40,75)*UDCDmain.fRange(UD_PatchMult,0.3,5.0))
	device.UD_Cooldown = UDCDmain.UDmain.Round(Utility.randomInt(45,90)/UDCDmain.fRange(UD_PatchMult,0.5,2.0))
	if device.UD_DeviceKeyword == libs.zad_deviousPiercingsNipple
		device.UD_Locks = 2
		device.UD_OrgasmMult  = Utility.randomFloat(0.3,0.8)*UDCDmain.fRange(UD_PatchMult,1.0,5.0)
		device.UD_ArousalMult = Utility.randomFloat(1.5,2.0)*UDCDmain.fRange(UD_PatchMult,1.0,3.0)
		checkMAHModifier(device,45,3,8,1,3)
	elseif device.UD_DeviceKeyword == libs.zad_DeviousPiercingsVaginal
		device.UD_Locks = 1
		device.UD_OrgasmMult  = Utility.randomFloat(1.5,2.5)*UDCDmain.fRange(UD_PatchMult,0.8,3.0)
		checkMAOModifier(device,15,5,15)
	endif

	device.UD_ResistPhysical = 0.75
	device.UD_ResistMagicka = 0.1
	checkSentientModifier(device,50,1.0)
	
	patchFinish(device)
EndFunction

bool Function isEbonite(UD_CustomDevice_RenderScript device)
	if (StringUtil.find(device.deviceInventory.getName(),"Ebonite") != -1) || (StringUtil.find(device.deviceInventory.getName(),"Latex") != -1) || (StringUtil.find(device.deviceInventory.getName(),"Rubber") != -1)
		return True
	Else
		Return False
	EndIF
EndFunction

bool Function isSteel(UD_CustomDevice_RenderScript device)
	return (StringUtil.find(device.deviceInventory.getName(),"Steel") != -1) || (StringUtil.find(device.deviceInventory.getName(),"Iron") != -1)
EndFunction

bool Function isRope(UD_CustomDevice_RenderScript device)
	return (StringUtil.find(device.deviceInventory.getName(),"Rope") != -1) ;|| (StringUtil.find(device.deviceInventory.getName(),"Iron") != -1)
EndFunction

bool Function DeviceCanHaveModes(UD_CustomDevice_RenderScript device)
	return !device.deviceRendered.haskeyword(UDlibs.PatchNoModes_KW)
EndFunction

Function checkSentientModifier(UD_CustomDevice_RenderScript device,int chance,float modifier)
	if Utility.randomInt() <= chance && DeviceCanHaveModes(device)
		device.addModifier("Sentient",Utility.randomInt(Math.ceiling(5*modifier),Math.ceiling(35*modifier)))
	endif
EndFunction

Function checkMendingModifier(UD_CustomDevice_RenderScript device,int chance,float modifier)
	if Utility.randomInt() <= chance && DeviceCanHaveModes(device)
		device.addModifier("Regen",UDCDmain.UDmain.formatString(120*modifier*Utility.randomFloat(0.5,2.0),1))
	endif
EndFunction

Function checkLooseModifier(UD_CustomDevice_RenderScript device,int chance,float rand_start = 0.0,float rand_end = 1.0)
	if Utility.randomInt() <= chance; && DeviceCanHaveModes(device)
		device.addModifier("Loose",UDCDmain.UDmain.formatString(Utility.randomFloat(rand_start,rand_end),2))
	endif
EndFunction

Function checkMAHModifier(UD_CustomDevice_RenderScript device,int chance,int rand_start_c = 0,int rand_end_c = 100,int rand_start_d = 1,int rand_end_d = 1)
	if Utility.randomInt() <= UDCDmain.Round(chance*UD_MAHChanceMod/100) && DeviceCanHaveModes(device)
		device.addModifier("MAH",Utility.randomInt(rand_start_c,rand_end_c) + "," + Utility.randomInt(rand_start_d,rand_end_d))
	endif
EndFunction

Function checkMAOModifier(UD_CustomDevice_RenderScript device,int chance,int rand_start_c = 0,int rand_end_c = 100,int rand_start_d = 1,int rand_end_d = 1)
	if Utility.randomInt() <= UDCDmain.Round(chance*UD_MAOChanceMod/100) && DeviceCanHaveModes(device)
		device.addModifier("MAO",Utility.randomInt(rand_start_c,rand_end_c) + "," + Utility.randomInt(rand_start_d,rand_end_d))
	endif
EndFunction

Function checkHealModifier(UD_CustomDevice_RenderScript device,int chance,int rand_start_d = 25,int rand_end_d = 50)
	if Utility.randomInt() <= chance && DeviceCanHaveModes(device)
		device.addModifier("_HEAL",Utility.randomInt(rand_start_d,rand_end_d))
	endif
EndFunction

Function patchFinish(UD_CustomDevice_RenderScript device,int argControlVar = 0x0F)
	checkInventoryScript(device,argControlVar)
	
	if device.deviceRendered.hasKeyword(libs.zad_EffectLively)
		device.UD_Cooldown = UDCDmain.Round(device.UD_Cooldown*0.85)
	endif
	
	if device.deviceRendered.hasKeyword(libs.zad_EffectVeryLively)
		device.UD_Cooldown = UDCDmain.Round(device.UD_Cooldown*0.6)
	endif
	
	device.UD_WeaponHitResist = device.UD_ResistPhysical
	int loc_random = Utility.randomInt(0,100)
	if loc_random > 75
		if loc_random < 90
			device.UD_WeaponHitResist = device.UD_WeaponHitResist + 0.25
		else
			device.UD_WeaponHitResist = device.UD_WeaponHitResist - 0.25
		endif
	endif
	device.UD_SpellHitResist = device.UD_ResistMagicka
EndFunction

Function checkInventoryScript(UD_CustomDevice_RenderScript device,int argControlVar = 0x0F)
	UD_CustomDevice_EquipScript inventoryScript = device.getInventoryScript()
	
	if Math.LogicalAnd(argControlVar,0x01)
		device.UD_durability_damage_base = (inventoryScript.BaseEscapeChance/10.0)/UD_PatchMult
	else
		;if !inventoryScript.BaseEscapeChance
		;	device.UD_durability_damage_base = 0.0 ;inescapable device
		;endif
	endif
	
	if device.UD_durability_damage_base == 0.0
		device.removeModifier("Loose")
	endif
	
	if Math.LogicalAnd(argControlVar,0x02)
		device.UD_CutChance = inventoryScript.CutDeviceEscapeChance/UDCDmain.fRange(UD_PatchMult,0.5,3.0)
	endif
	
	if Math.LogicalAnd(argControlVar,0x04)
		if inventoryScript.LockPickEscapeChance >= 50.0
			device.UD_LockpickDifficulty = 1 ;Novic
		elseif inventoryScript.LockPickEscapeChance >= 25.0
			device.UD_LockpickDifficulty = 25 ;Apprentice
		elseif inventoryScript.LockPickEscapeChance >= 12.0
			device.UD_LockpickDifficulty = 50 ;Adept
		elseif inventoryScript.LockPickEscapeChance >= 5.0
			device.UD_LockpickDifficulty = 75 ;Expert
		elseif inventoryScript.LockPickEscapeChance > 0.0
			device.UD_LockpickDifficulty = 100	;Master
		else 
			device.UD_LockpickDifficulty = 255 ;Requires Key
		endif
		
		if !inventoryScript.deviceKey && inventoryScript.LockPickEscapeChance == 0.0
			device.UD_Locks = 0
		elseif 	inventoryScript.deviceKey; && inventoryScript.LockAccessDifficulty < 100.0
			if device.UD_Locks == 0
				device.UD_Locks = Utility.randomInt(1,3)
			endif
		endif
	endif
	
	if Math.LogicalAnd(argControlVar,0x08)
		if !device.UD_durability_damage_base && inventoryScript.LockAccessDifficulty < 100.0 && device.UD_LockAccessDifficulty == 100.0
			device.UD_LockAccessDifficulty = inventoryScript.LockAccessDifficulty
		endif
	endif
		
	inventoryScript.delete()
EndFunction

Function patchDefaultValues(UD_CustomDevice_RenderScript device)
	device.UD_Locks = Utility.randomInt(1,8)
	device.UD_LockpickDifficulty = 25*Utility.randomInt(1,3)
	device.UD_LockAccessDifficulty = Utility.randomFloat(40.0,70.0) + 20*(UD_PatchMult - 1.0)
	device.UD_base_stat_drain = Utility.randomFloat(7.0,13.0)
	device.UD_durability_damage_base = Utility.randomFloat(0.8,1.6)/UD_PatchMult
	device.UD_ResistPhysical = Utility.randomFloat(-0.5,0.9)
	device.UD_ResistMagicka = Utility.randomFloat(-0.9,1.0)
	device.UD_StruggleCritDuration = 0.8
	device.UD_StruggleCritChance = Utility.randomInt(15,30)
	device.UD_StruggleCritMul = Utility.randomFloat(2.0,6.0)
	device.UD_Cooldown = UDCDmain.UDmain.Round(Utility.randomInt(100,240)/(UDCDmain.fRange(UD_PatchMult,0.5,5.0)))
	if isEbonite(device)
		checkMendingModifier(device,50,1.25)
		checkHealModifier(device,20)
	else
		checkMendingModifier(device,25,0.8)
	endif
	
	if !device.isHeavyBondage()
		if isRope(device)
			checkLooseModifier(device,50,0.25, 0.5)
		endif
	else
		;device.addModifier("Loose",1.0)
	endif
	
	checkHealModifier(device,10)
EndFunction
