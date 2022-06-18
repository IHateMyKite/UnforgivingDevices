Scriptname UD_MCM_script extends SKI_ConfigBase

;UDAbadonPlug_Event property abadon auto
UnforgivingDevicesMain property UDmain auto
UDCustomDeviceMain Property UDCDmain auto
UD_SwimmingScript Property UDSS auto
UDItemManager Property UDIM auto
UD_AbadonQuest_script Property AbadonQuest auto
UDCustomHeavyBondageWidget1 Property widget auto
UD_CustomDevices_NPCSlotsManager Property UDCD_NPCM auto
zadlibs_UDPatch Property libs auto hidden
int max_difficulty_S
int overaldifficulty_S ;0-3 where 3 is same as in MDS
int eventchancemod_S

int little_finisher_chance_S 
int min_orgasm_little_finisher_S 
int max_orgasm_little_finisher_S 

int  dmg_heal_T
int  dmg_magica_T
int dmg_stamina_T


int AbadonForceSuitOnEquip_T


string[] difficultyList
int difficulty_M

int little_finisher_cooldown_S ;in hours


int final_finisher_set_T

int final_finisher_pref_M
string[] property final_finisher_pref_list auto

int lockmenu_T
int hardcore_T
int UD_debugmod_T

int preset
int preset_M
string[] presetList

int abadon_flag 
int abadon_flag_2

int UD_OrgasmExhaustion_flag
int UD_OrgasmExhaustion_T
int UD_OrgasmExhaustionMagnitude_S
int UD_OrgasmExhaustionDuration_S

int UD_ActionKey_K
int UD_StruggleKey_K 

int UD_hightPerformance_T

string[] widgetXList
string[] widgetYList
string[] orgasmAnimation

int UD_LockMenu_flag

Function UpdateLockMenuFlag()
	if(UDmain.hasAnyUD() && UDmain.lockMCM)
		UD_LockMenu_flag = OPTION_FLAG_DISABLED
	else
		UD_LockMenu_flag = OPTION_FLAG_NONE
	endif
EndFunction

Int Function FlagSwitchAnd(int iFlag1,Int iFlag2)
	if iFlag1 == OPTION_FLAG_DISABLED && iFlag2 == OPTION_FLAG_DISABLED
		return OPTION_FLAG_DISABLED
	else
		return OPTION_FLAG_NONE
	endif
EndFunction

Int Function FlagSwitchOr(int iFlag1,Int iFlag2)
	if iFlag1 == OPTION_FLAG_DISABLED 
		return OPTION_FLAG_DISABLED
	elseif iFlag2 == OPTION_FLAG_DISABLED
		return OPTION_FLAG_DISABLED
	endif
	return OPTION_FLAG_NONE
EndFunction

int Function FlahSwitch(bool bVal)
	if bVal == true 
		return OPTION_FLAG_NONE
	else
		return OPTION_FLAG_DISABLED
	endif
EndFunction

Function LoadConfigPages()
	pages = new String[8]
	pages[0] = "General"
	pages[1] = "Custom devices"
	pages[2] = "Custom orgasm"
	pages[3] = "Patcher"
	pages[4] = "DD Patch"
	pages[5] = "Abadon Plug"
	pages[6] = "Debug panel"
	pages[7] = "Other"
EndFunction

bool Property Ready = False Auto
Event OnConfigInit()
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("MCM init started")
	endif

	LoadConfigPages()
	registered_devices_T = new Int[25]
	NPCSlots_T = new Int[11];Utility.CreateIntArray(UDCD_NPCM.getNumSlots());new Int[6]
	
	difficultyList = new string[3]
	difficultyList[0] = "Easy"
	difficultyList[1] = "Normal"
	difficultyList[2] = "Hard"
	
	widgetXList = new String[3]
	widgetXList[0] = "Left"
	widgetXList[1] = "Middle"
	widgetXList[2] = "Right"
	
	widgetYList = new String[3]
	widgetYList[0] = "Down"
	widgetYList[1] = "Less Down"
	widgetYList[2] = "Up"
	
	orgasmAnimation = new String[2]
	orgasmAnimation[0] = "Normal"
	orgasmAnimation[1] = "Expanded"
	
	presetList = new string[4]
	presetList[0] = "Forgiving"
	presetList[1] = "Pleasure slave"
	presetList[2] = "Game of time"
	presetList[3] = "Custom"
	
	criteffectList = new string[3]
	criteffectList[0] = "HUD"
	criteffectList[1] = "Body shader"
	criteffectList[2] = "HUD + Body shader"
	
	final_finisher_pref_list = new string[7]
	final_finisher_pref_list[0] = "Random"
	final_finisher_pref_list[1] = "Rope"
	final_finisher_pref_list[2] = "Transparent"
	final_finisher_pref_list[3] = "Rubber"
	final_finisher_pref_list[4] = "Restrictive"
	final_finisher_pref_list[5] = "Simple"
	final_finisher_pref_list[6] = "Yoke"
	setAbadonPreset(1)
	device_flag = OPTION_FLAG_NONE
	UD_autocrit_flag = OPTION_FLAG_DISABLED
	fix_flag = OPTION_FLAG_NONE
	UD_Horny_f = OPTION_FLAG_NONE
	if AbadonQuest.final_finisher_set
		abadon_flag_2 = OPTION_FLAG_NONE
	else
		abadon_flag_2 = OPTION_FLAG_DISABLED
	endif
	
	UD_LockMenu_flag = OPTION_FLAG_NONE
	
	libs = UDCDmain.libs as zadlibs_UDPatch
	
	actorIndex = 10
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("MCM ready")
	endif
	Ready = True
EndEvent

Event onConfigClose()
;/
	if selected_device >= 0
		;UI.InvokeString("Main Menu", "_global.skse.CloseMenu", "Main Menu")
		;UI.InvokeString("Loading Menu", "_global.skse.CloseMenu", "Loading Menu")
		;https://forums.nexusmods.com/index.php?/topic/4795300-starting-quests-from-mcm-quest-script-best-method/
		UI.Invoke("Journal Menu", "_root.QuestJournalFader.Menu_mc.ConfigPanelClose")
		UI.Invoke("Journal Menu", "_root.QuestJournalFader.Menu_mc.CloseMenu")
		UDCDmain.showDebugMenu(selected_device)
	endif
	/;
EndEvent

Event onConfigOpen()
	device_flag = OPTION_FLAG_NONE
	fix_flag = OPTION_FLAG_NONE
EndEvent

Event OnPageReset(string page)
	if (page == "General")
		resetGeneralPage()
	elseif (page == "Abadon Plug")
		resetAbadonPage()
	elseif (page == "Custom Devices")
		resetCustomBondagePage()
	elseif (page == "Custom orgasm")
		resetCustomOrgasmPage()
	elseif 	(page == "Patcher")
		resetPatcherPage()
	elseif (page == "DD patch")
		resetDDPatchPage()
	elseif (page == "Debug panel")
		resetDebugPage()
	elseif (page == "Other")
		resetOtherPage()
	endif
EndEvent

int UseAnalVariant_T
int Property AbadonQuestFlag auto
Function resetAbadonPage()
		
		setCursorFillMode(LEFT_TO_RIGHT)
		;addEmptyOption()
		AddHeaderOption("Abadon Plug Settings")
		if(!UDmain.hasAnyUD() || !UDmain.lockMCM)
			addEmptyOption()
			
			preset_M = AddMenuOption("Preset:", presetList[preset])
			
			UseAnalVariant_T = addToggleOption("Anal variant:", AbadonQuest.UseAnalVariant,AbadonQuestFlag)
			
			max_difficulty_S = AddSliderOption("Max strength:", AbadonQuest.max_difficulty, "{0}",abadon_flag)
			final_finisher_set_T = addToggleOption("Equip set:", AbadonQuest.final_finisher_set)
			
			difficulty_M = AddMenuOption("Difficulty:", difficultyList[AbadonQuest.overaldifficulty],abadon_flag)
			final_finisher_pref_M = AddMenuOption("Start set:", final_finisher_pref_list[AbadonQuest.final_finisher_pref],abadon_flag_2)
			
			hardcore_T = addToggleOption("Hardcore:", AbadonQuest.hardcore,abadon_flag)
			eventchancemod_S = AddSliderOption("Event modifier:", AbadonQuest.eventchancemod, "{0} %",abadon_flag)
			
			dmg_heal_T = addToggleOption("Damage health",AbadonQuest.dmg_heal,abadon_flag)
			addEmptyOption()
			
			dmg_stamina_T = addToggleOption("Damage stamina",AbadonQuest.dmg_stamina,abadon_flag)
			addEmptyOption()
			
			dmg_magica_T = addToggleOption("Damage magica",AbadonQuest.dmg_magica,abadon_flag)
			addEmptyOption()
			
			little_finisher_chance_S = AddSliderOption("Chance of smaller finisher:", AbadonQuest.little_finisher_chance, "{1} %",abadon_flag)
			little_finisher_cooldown_S = AddSliderOption("Smaller finisher cooldown:", AbadonQuest.little_finisher_cooldown, "{1} hours",abadon_flag)
			
			min_orgasm_little_finisher_S = AddSliderOption("Min. orgasms of smaller finisher:", AbadonQuest.min_orgasm_little_finisher, "{1}",abadon_flag)
			max_orgasm_little_finisher_S = AddSliderOption("Max. orgasms of smaller finisher:", AbadonQuest.max_orgasm_little_finisher, "{1}",abadon_flag)
		else
			addEmptyOption()
			AddHeaderOption("Menu locked")
		endif
endfunction

int UD_RandomFilter_S
int UD_useHoods_T
int UD_LoggingLevel_S
int UD_NPCSupport_T
int UD_PlayerMenu_K
int UD_NPCMenu_K
Event resetGeneralPage()
	UpdateLockMenuFlag()
	setCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("General")
	addEmptyOption()
	
	UD_StruggleKey_K = AddKeyMapOption("Action key: ", UDCDmain.StruggleKey_Keycode)
	UD_ActionKey_K = AddKeyMapOption("Stop key: ", UDCDmain.ActionKey_Keycode)
	
	UD_PlayerMenu_K = AddKeyMapOption("Player menu key:", UDCDmain.PlayerMenu_KeyCode)
	UD_NPCMenu_K = AddKeyMapOption("NPC menu key:", UDCDmain.NPCMenu_Keycode)
	
	UD_hightPerformance_T = addToggleOption("Hight performance mod",UDmain.UD_hightPerformance)
	UD_debugmod_T = addToggleOption("Debug mod",UDmain.DebugMod)
	
	UD_LoggingLevel_S = addSliderOption("Logging level",UDmain.LogLevel, "{0}")
	UD_NPCSupport_T = addToggleOption("NPC Auto Scan",UDmain.AllowNPCSupport)
	
	UD_RandomFilter_S = addSliderOption("Random filter:",Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0xFFFF),"{0}",UD_LockMenu_flag)
	addEmptyOption()
	
	;if (!UDmain.hasAnyUD() || !UDmain.lockMCM)
		lockmenu_T = addToggleOption("Lock menus",UDmain.lockMCM,UD_LockMenu_flag)
		UD_useHoods_T = addToggleOption("Use hoods",UDIM.UD_useHoods,UD_LockMenu_flag)
		UD_OrgasmExhaustion_T = addToggleOption("Orgasm exhaustion",UDmain.UD_OrgasmExhaustion,UD_LockMenu_flag)
		addEmptyOption()
		UD_OrgasmExhaustionMagnitude_S = addSliderOption("Orgasm exhaustion magnitude",UDmain.UD_OrgasmExhaustionMagnitude, "{0} %",FlagSwitchOr(UD_OrgasmExhaustion_flag,UD_LockMenu_flag))
		UD_OrgasmExhaustionDuration_S = addSliderOption("Orgasm exhaustion duration",UDmain.UD_OrgasmExhaustionDuration, "{0} s",FlagSwitchOr(UD_OrgasmExhaustion_flag,UD_LockMenu_flag))
	;else
	;	AddHeaderOption("Menu locked")
	;endif
EndEvent

int UD_Swimming_flag
int UD_autocrit_flag
int UD_CHB_Stamina_meter_Keycode_K
int UD_CHB_Magicka_meter_Keycode_K
int UDCD_SpecialKey_Keycode_K
int UD_UseDDdifficulty_T
int UD_UseWidget_T
int UD_AutoCrit_T
int UD_AutoCritChance_S
int UD_StruggleDifficulty_M
int UD_hardcore_swimming_T
int UD_hardcore_swimming_difficulty_M
int UD_UpdateTime_S
int UD_GagPhonemModifier_S
int UD_PatchMult_S
int UD_LockpickMinigameNum_S
int UD_WidgetPosX_M
int UD_WidgetPosY_M
int UD_BaseDeviceSkillIncrease_S
int UD_CooldownMultiplier_S
string[] criteffectList
int UD_CritEffect_M
int UD_HardcoreMode_T
Event resetCustomBondagePage()
	UpdateLockMenuFlag()
	setCursorFillMode(LEFT_TO_RIGHT)
	
	AddHeaderOption("Custom devices")
	addEmptyOption()
	
	UD_CHB_Stamina_meter_Keycode_K = AddKeyMapOption("Stamina key:", UDCDmain.Stamina_meter_Keycode)
	UD_CHB_Magicka_meter_Keycode_K = AddKeyMapOption("Magicka key:", UDCDmain.Magicka_meter_Keycode)	
	
	UDCD_SpecialKey_Keycode_K = AddKeyMapOption("Special key:", UDCDmain.SpecialKey_Keycode)
	UD_UseWidget_T = addToggleOption("Use widget:", UDCDmain.UD_UseWidget)	
	
	UD_UpdateTime_S = addSliderOption("Update time: ",UDCDmain.UD_UpdateTime, "{0} s")
	UD_CooldownMultiplier_S = addSliderOption("Cooldown multiplier: ",UDCDMain.Round(UDCDmain.UD_CooldownMultiplier*100), "{0} %",UD_LockMenu_flag)
	;addEmptyOption()
	
	UD_WidgetPosX_M = AddMenuOption("Widget pos X:", widgetXList[widget.PositionX])
	UD_WidgetPosY_M = AddMenuOption("Widget pos Y:", widgetYList[widget.PositionY])
	

	UD_StruggleDifficulty_M = AddMenuOption("Escape difficulty:", difficultyList[UDCDmain.UD_StruggleDifficulty],UD_LockMenu_flag)
	UD_UseDDdifficulty_T = addToggleOption("Use DD difficulty:", UDCDmain.UD_UseDDdifficulty,UD_LockMenu_flag)	
	
	;addEmptyOption()
	UD_HardcoreMode_T = addToggleOption("Hardcore mode:", UDCDmain.UD_HardcoreMode)
	;UD_PatchMult_S = addSliderOption("Patch mult: ",Math.floor(UDCDmain.UDPatcher.UD_PatchMult * 100 + 0.5), "{0} %",UD_LockMenu_flag)
	UD_CritEffect_M = AddMenuOption("Crit effect:", criteffectList[UDCDmain.UD_CritEffect])
	;addEmptyOption()
	
	UD_AutoCrit_T = addToggleOption("Auto crit:", UDCDmain.UD_AutoCrit,UD_LockMenu_flag)	
	UD_AutoCritChance_S = addSliderOption("Auto crit chance: ",UDCDmain.UD_AutoCritChance, "{0} %",FlagSwitchOr(UD_autocrit_flag,UD_LockMenu_flag))
	
	UD_BaseDeviceSkillIncrease_S = addSliderOption("Skill advance: ",UDCDmain.UD_BaseDeviceSkillIncrease, "{0}",UD_LockMenu_flag)
	UD_LockpickMinigameNum_S = addSliderOption("Lockpicks per minigame: ",UDCDmain.UD_LockpicksPerMinigame, "{0}",UD_LockMenu_flag)
	
	UD_hardcore_swimming_T = addToggleOption("Unforgiving swimming:", UDSS.UD_hardcore_swimming,UD_LockMenu_flag)	
	UD_hardcore_swimming_difficulty_M = AddMenuOption("Swimming difficulty:", difficultyList[UDSS.UD_hardcore_swimming_difficulty],FlagSwitchOr(UD_Swimming_flag,UD_LockMenu_flag))
	
	addEmptyOption()
	addEmptyOption()
	AddTextOption("Struggle difficulty:", Math.floor((2 - UDCDmain.getStruggleDifficultyModifier())*100 +0.5) + " %",OPTION_FLAG_DISABLED)
	AddTextOption("Mend difficulty:", Math.floor(UDCDmain.getMendDifficultyModifier()*100 + 0.5) + " %",OPTION_FLAG_DISABLED)
	AddTextOption("Key modifier:", Math.floor((UDCDmain.CalculateKeyModifier())*100 + 0.5) + " %",OPTION_FLAG_DISABLED)
EndEvent

int UD_OrgasmUpdateTime_S
int UD_OrgasmAnimation_M

int UD_OrgasmDuration_S
int UD_UseOrgasmWidget_T

int UD_HornyAnimation_T
int UD_Horny_f
int UD_HornyAnimationDuration_S

int UD_OrgasmResistence_S

int UD_VibrationMultiplier_S
int UD_ArousalMultiplier_S

Event resetCustomOrgasmPage()
	UpdateLockMenuFlag()
	setCursorFillMode(LEFT_TO_RIGHT)
	
	AddHeaderOption("Custom orgasm")
	addEmptyOption()
		
	UD_OrgasmUpdateTime_S = addSliderOption("Update time: ",UDCDmain.UDOM.UD_OrgasmUpdateTime, "{1} s")
	addEmptyOption()
	
	
	UD_UseOrgasmWidget_T = addToggleOption("Use widget:", UDCDmain.UDOM.UD_UseOrgasmWidget)
	UD_OrgasmResistence_S = addSliderOption("Orgasm resistence: ",UDCDmain.UDOM.UD_OrgasmResistence, "{1} Op/s",UD_LockMenu_flag)

	UD_HornyAnimation_T = addToggleOption("Horny animation:", UDCDmain.UDOM.UD_HornyAnimation)
	UD_HornyAnimationDuration_S = addSliderOption("Horny duration: ",UDCDmain.UDOM.UD_HornyAnimationDuration, "{0} s",UD_Horny_f)
		
	UD_VibrationMultiplier_S = addSliderOption("Vib. multiplier: ",UDCDmain.UD_VibrationMultiplier, "{3}",UD_LockMenu_flag)
	UD_ArousalMultiplier_S = addSliderOption("Arousal multiplier: ",UDCDmain.UD_ArousalMultiplier, "{3}",UD_LockMenu_flag)
		
	addEmptyOption()
	addEmptyOption()
	
	AddTextOption("Orgasm rate:", UDCDmain.UDOM.getActorOrgasmRate(Game.getPlayer()) + " OP/s",OPTION_FLAG_DISABLED)
	AddTextOption("Orgasm forcing:", UDCDmain.UDOM.getActorOrgasmForcing(Game.getPlayer()) + " %",OPTION_FLAG_DISABLED)
EndEvent


Int UD_MAOChanceMod_S
int UD_MAOMod_S
Int UD_MAHChanceMod_S
int UD_MAHMod_S
int UD_EscapeModifier_S
int UD_MinLocks_S
int UD_MaxLocks_S

;multipliers
int UD_PatchMult_HeavyBondage_S
int UD_PatchMult_Gag_S
int UD_PatchMult_Blindfold_S
int UD_PatchMult_ChastityBra_S
int UD_PatchMult_ChastityBelt_S
int UD_PatchMult_Plug_S
int UD_PatchMult_Piercing_S
int UD_PatchMult_Hood_S
int UD_PatchMult_Generic_S
Event resetPatcherPage()
	UpdateLockMenuFlag()
	setCursorFillMode(LEFT_TO_RIGHT)
	
	AddHeaderOption("Main values")
	addEmptyOption()
		
	UD_PatchMult_S = addSliderOption("Global Diffuculty Modifier",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult * 100), "{0} %",UD_LockMenu_flag)
	UD_EscapeModifier_S = addSliderOption("Escape modifier",UDCDmain.UDPatcher.UD_EscapeModifier, "{0}",UD_LockMenu_flag)
	
	UD_MinLocks_S = addSliderOption("Min. Locks",UDCDmain.UDPatcher.UD_MinLocks, "{0}",UD_LockMenu_flag)
	UD_MaxLocks_S = addSliderOption("Max. Locks",UDCDmain.UDPatcher.UD_MaxLocks, "{0}",UD_LockMenu_flag)
	
	addEmptyOption()
	addEmptyOption()
	
	AddHeaderOption("Manifest Modifiers")
	addEmptyOption()
	
	UD_MAOChanceMod_S = addSliderOption("Orgasm manifest chance multiplier",UDCDmain.UDPatcher.UD_MAOChanceMod, "{0} %",UD_LockMenu_flag)
	UD_MAOMod_S = addSliderOption("Orgasm manifest multiplier",UDCDmain.UDPatcher.UD_MAOMod, "{0} %",UD_LockMenu_flag)
	
	UD_MAHChanceMod_S = addSliderOption("Hour manifest chance multiplier",UDCDmain.UDPatcher.UD_MAHChanceMod, "{0} %",UD_LockMenu_flag)
	UD_MAHMod_S = addSliderOption("Hour manifest multiplier",UDCDmain.UDPatcher.UD_MAHMod, "{0} %",UD_LockMenu_flag)
	
	
	AddHeaderOption("Device Difficulty Modifiers")
	addEmptyOption()
	
	UD_PatchMult_HeavyBondage_S = addSliderOption("Heavy bondage",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage * 100), "{0} %",UD_LockMenu_flag)
	UD_PatchMult_Blindfold_S = addSliderOption("Blindfold",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Blindfold * 100), "{0} %",UD_LockMenu_flag)
	
	UD_PatchMult_Gag_S = addSliderOption("Gag",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Gag * 100), "{0} %",UD_LockMenu_flag)
	UD_PatchMult_Hood_S = addSliderOption("Hood",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Hood * 100), "{0} %",UD_LockMenu_flag)
	
	UD_PatchMult_ChastityBelt_S = addSliderOption("Chastity belt",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt * 100), "{0} %",UD_LockMenu_flag)
	UD_PatchMult_ChastityBra_S = addSliderOption("Chastity bra",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBra * 100), "{0} %",UD_LockMenu_flag)
	
	UD_PatchMult_Plug_S = addSliderOption("Plug",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Plug * 100), "{0} %",UD_LockMenu_flag)
	UD_PatchMult_Piercing_S = addSliderOption("Piercing",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Piercing * 100), "{0} %",UD_LockMenu_flag)
	
	UD_PatchMult_Generic_S = addSliderOption("Generic",UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Generic * 100), "{0} %",UD_LockMenu_flag)
	addEmptyOption()
	
EndEvent

int UD_StartThirdpersonAnimation_Switch_T
Event resetDDPatchPage()
	UpdateLockMenuFlag()
	setCursorFillMode(LEFT_TO_RIGHT)
	
	AddHeaderOption("Custom orgasm")
	addEmptyOption()
		
	UD_OrgasmAnimation_M = AddMenuOption("Animation list:", orgasmAnimation[UDCDmain.UDOM.UD_OrgasmAnimation])	
	UD_GagPhonemModifier_S = addSliderOption("Gag phonem mod: ",UDCDmain.UD_GagPhonemModifier, "{0}")
	
	UD_StartThirdpersonAnimation_Switch_T = addToggleOption("Animation patch", libs.UD_StartThirdPersonAnimation_Switch)
	addEmptyOption()
EndEvent

int[] registered_devices_T
int[] NPCSlots_T
int device_flag
int fix_flag
;int npc_flag
int fixBugs_T
int removeUnused_T
int rescanSlots_T
int unlockAll_T
int endAnimation_T
int actorIndex = 5
int unregisterNPC_T
int GlobalUpdateNPC_T

int OrgasmResist_S
int OrgasmCapacity_S

Event resetDebugPage()
	UpdateLockMenuFlag()
	setCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("-Device Slots-")
	AddHeaderOption("-NPC Slots-")	
	int i = 0
	
	

	UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(actorIndex)
	if !slot.isUsed()
		slot = UDCD_NPCM.getPlayerSlot()
		actorIndex = UDCD_NPCM.getPlayerIndex()
	endif
	UD_CustomDevice_RenderScript[] devices = slot.UD_equipedCustomDevices
	int size = devices.length
	
	;if slot.getScriptState() == 0
	;	fix_flag = OPTION_FLAG_DISABLED
	;else
	;	fix_flag = OPTION_FLAG_NONE
	;endif
	
	fix_flag = OPTION_FLAG_NONE
	
	while i < size
		if devices[i]
			registered_devices_T[i] = AddTextOption((i + 1) + ") " , devices[i].deviceInventory.getName(),device_flag)
		else
			registered_devices_T[i] = AddTextOption((i + 1) + ") " , "Empty" ,OPTION_FLAG_DISABLED)
		endif
			if i == 0
				setNPCSlot(10,"PlayerSlot",False)
			elseif i == 1
				setNPCSlot(0)
			elseif i == 2
				setNPCSlot(1)
			elseif i == 3
				setNPCSlot(2)
			elseif i == 4
				setNPCSlot(3)
			elseif i == 5
				setNPCSlot(4)
			elseif i == 6
				setNPCSlot(5)
			elseif i == 7
				setNPCSlot(6)
			elseif i == 8
				setNPCSlot(7)
			elseif i == 9
				setNPCSlot(8)
			elseif i == 10
				setNPCSlot(9)
			elseif i == 11
				AddHeaderOption("-TOOLS-")	;addEmptyOption()
			elseif i == 12
				AddTextOption("Devices", slot.getNumberOfRegisteredDevices() ,OPTION_FLAG_DISABLED)
				;AddTextOption("Script state: ", slot.getScriptState() ,OPTION_FLAG_DISABLED)
			elseif i == 13
				OrgasmResist_S 		= addSliderOption("Orgasm Resist:",UDCDmain.UDOM.getActorOrgasmResist(slot.getActor()), "{1}")
			elseif i == 14
				OrgasmCapacity_S 	= addSliderOption("Orgasm Capacity:",UDCDmain.UDOM.getActorOrgasmCapacity(slot.getActor()), "{0}")
				;addEmptyOption()
			elseif i == 15
				unlockAll_T = AddTextOption("Unlock all", "CLICK" ,fix_flag)
			elseif i == 16
				endAnimation_T = AddTextOption("Terminate animation", "CLICK" ,fix_flag)
			elseif i == 17
				fixBugs_T = AddTextOption("Fixes", "CLICK" ,fix_flag)
			elseif i == 18
				if !slot.isPlayer()
					unregisterNPC_T = AddTextOption("Unregister NPC","CLICK")
				else
					addEmptyOption()
				endif
			elseif i == 19
				rescanSlots_T = AddTextOption("Rescan slots", "CLICK")	
			else 	
				addEmptyOption()
			endif
		i += 1
	endwhile
EndEvent

Function setNPCSlot(int index,string text = "NPC Slot",bool useIndex = True)
	int npcflag = OPTION_FLAG_NONE
	UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(index)
	if !slot.isUsed()
		npcflag = OPTION_FLAG_DISABLED
	else
		npcflag = OPTION_FLAG_NONE
	endif
	string name = ""
	if actorIndex == index
		name = "->" +  slot.getSlotedNPCName()
	else
		name = slot.getSlotedNPCName()
	endif
	if useIndex
		NPCSlots_T[index] = AddTextOption(text + (index + 1)+": ", name ,npcflag)
	else
		NPCSlots_T[index] = AddTextOption(text +": ", name ,npcflag)
	endif
EndFunction
int UD_Export_T
int UD_Import_T
int UD_Default_T
int UD_AutoLoad_T
Function resetOtherPage()
	UpdateLockMenuFlag()
	setCursorFillMode(LEFT_TO_RIGHT)
	
	AddHeaderOption("Config")
	addEmptyOption()
	
	UD_Export_T =  AddTextOption("Save settings", "-PRESS-")
	UD_Import_T = AddTextOption("Load settings", "-PRESS-")
	
	UD_Default_T = AddTextOption("!Reset to default!", "-PRESS-")
	UD_AutoLoad_T = AddToggleOption("Auto load", UDmain.UD_AutoLoad)
	
	addEmptyOption()
	addEmptyOption()
	
	AddHeaderOption("Optional mods")
	addEmptyOption()
	
	AddTextOption("Zaz animation pack installed: ",UDmain.ZaZAnimationPackInstalled,FlahSwitch(UDmain.ZaZAnimationPackInstalled))
	addEmptyOption()
	
	AddTextOption("ConsoleUtil installed: ",UDmain.ConsoleUtilInstalled,FlahSwitch(UDmain.ConsoleUtilInstalled))
	addEmptyOption()
	
	AddTextOption("SlaveTats installed: ",UDmain.SlaveTatsInstalled,FlahSwitch(UDmain.SlaveTatsInstalled))
	addEmptyOption()
	
EndFunction

event OnOptionSelect(int option)
	OptionSelectGeneral(option)
	OptionCustomBondage(option)
	OptionCustomOrgasm(option)
	OptionDDPatch(option)
	OptionSelectAbadon(option)
	OptionSelectDebug(option)
	OptionSelectOther(option)
endEvent

Function OptionSelectGeneral(int option)
	if(option == lockmenu_T)
		UDmain.lockMCM = !UDmain.lockMCM
		SetToggleOptionValue(lockmenu_T, UDmain.lockMCM)
	elseif (option == UD_useHoods_T)
		UDIM.UD_useHoods = !UDIM.UD_useHoods
		SetToggleOptionValue(UD_useHoods_T, UDIM.UD_useHoods)
	elseif (option == UD_OrgasmExhaustion_T)
		UDmain.UD_OrgasmExhaustion = !UDmain.UD_OrgasmExhaustion
		if (UDmain.UD_OrgasmExhaustion)
			UD_OrgasmExhaustion_flag = OPTION_FLAG_NONE
		else
			UD_OrgasmExhaustion_flag = OPTION_FLAG_DISABLED
		endif
		SetToggleOptionValue(UD_OrgasmExhaustion_T, UDmain.UD_OrgasmExhaustion)
		forcePageReset()
	elseif (option == UD_hightPerformance_T)
		UDmain.UD_hightPerformance = !UDmain.UD_hightPerformance
		SetToggleOptionValue(UD_hightPerformance_T, UDmain.UD_hightPerformance)
	elseif (option == UD_debugmod_T)
		UDmain.debugmod = !UDmain.debugmod
		SetToggleOptionValue(UD_debugmod_T, UDmain.debugmod)
	elseif option == UD_NPCSupport_T
		UDmain.AllowNPCSupport = !UDmain.AllowNPCSupport
		SetToggleOptionValue(UD_NPCSupport_T, UDmain.AllowNPCSupport)	
	endif
EndFunction

Function OptionCustomBondage(int option)
	if(option == UD_hardcore_swimming_T)
		UDSS.UD_hardcore_swimming = !UDSS.UD_hardcore_swimming
		SetToggleOptionValue(UD_hardcore_swimming_T, UDSS.UD_hardcore_swimming)
		if (UDSS.UD_hardcore_swimming)
			UD_Swimming_flag = OPTION_FLAG_NONE
		else
			UD_Swimming_flag = OPTION_FLAG_DISABLED
		endif
		forcePageReset()
	elseif(option == UD_UseDDdifficulty_T)
		UDCDmain.UD_UseDDdifficulty = !UDCDmain.UD_UseDDdifficulty
		SetToggleOptionValue(UD_UseDDdifficulty_T, UDCDmain.UD_UseDDdifficulty)
	elseif(option == UD_UseWidget_T)
		UDCDmain.UD_UseWidget = !UDCDmain.UD_UseWidget
		SetToggleOptionValue(UD_UseWidget_T, UDCDmain.UD_UseWidget)
	elseif option == UD_AutoCrit_T	
		UDCDmain.UD_AutoCrit = !UDCDmain.UD_AutoCrit
		if UDCDmain.UD_AutoCrit
			UD_autocrit_flag = OPTION_FLAG_NONE
		else
			UD_autocrit_flag = OPTION_FLAG_DISABLED
		endif
		
		SetToggleOptionValue(UD_AutoCrit_T, UDCDmain.UD_AutoCrit)
		forcePageReset()
	elseif option == UD_HardcoreMode_T
		UDCDmain.UD_HardcoreMode = !UDCDmain.UD_HardcoreMode
		UDCDmain.RegisterForSingleUpdate(0.01)
		SetToggleOptionValue(UD_HardcoreMode_T, UDCDmain.UD_HardcoreMode)
	endif
EndFunction

Function OptionCustomOrgasm(int option)
	if(option == UD_UseOrgasmWidget_T)
		UDCDmain.UDOM.UD_UseOrgasmWidget = !UDCDmain.UDOM.UD_UseOrgasmWidget
		SetToggleOptionValue(UD_UseOrgasmWidget_T, UDCDmain.UDOM.UD_UseOrgasmWidget)
		forcePageReset()
	elseif(option == UD_HornyAnimation_T)
		UDCDmain.UDOM.UD_HornyAnimation = !UDCDmain.UDOM.UD_HornyAnimation
		SetToggleOptionValue(UD_HornyAnimation_T, UDCDmain.UDOM.UD_HornyAnimation)
		if UDCDmain.UDOM.UD_HornyAnimation
			UD_Horny_f = OPTION_FLAG_NONE
		else
			UD_Horny_f = OPTION_FLAG_DISABLED
		endif
		forcePageReset()
	endif
EndFunction

Function OptionDDPatch(int option)
	if(option == UD_StartThirdpersonAnimation_Switch_T)
		libs.UD_StartThirdpersonAnimation_Switch = !libs.UD_StartThirdpersonAnimation_Switch
		SetToggleOptionValue(UD_StartThirdpersonAnimation_Switch_T, libs.UD_StartThirdpersonAnimation_Switch)
	endif
EndFunction

Function OptionSelectAbadon(int option)
	if(option == UseAnalVariant_T)
		AbadonQuest.UseAnalVariant = !AbadonQuest.UseAnalVariant
		SetToggleOptionValue(UseAnalVariant_T, AbadonQuest.UseAnalVariant)
	elseif (option == dmg_heal_T)
		AbadonQuest.dmg_heal = !AbadonQuest.dmg_heal
		SetToggleOptionValue(dmg_heal_T, AbadonQuest.dmg_heal)
	elseif(option == dmg_stamina_T)
		AbadonQuest.dmg_stamina = !AbadonQuest.dmg_stamina
		SetToggleOptionValue(dmg_stamina_T, AbadonQuest.dmg_stamina)
	elseif(option == dmg_magica_T)
		AbadonQuest.dmg_magica = !AbadonQuest.dmg_magica
		SetToggleOptionValue(dmg_magica_T, AbadonQuest.dmg_magica)
	elseif(option == hardcore_T)
		AbadonQuest.hardcore = !AbadonQuest.hardcore
		SetToggleOptionValue(hardcore_T, AbadonQuest.hardcore)
	elseif(option == final_finisher_set_T)
		AbadonQuest.final_finisher_set = !AbadonQuest.final_finisher_set
		
		if AbadonQuest.final_finisher_set
			Abadon_flag_2 = OPTION_FLAG_NONE
		else
			Abadon_flag_2 = OPTION_FLAG_DISABLED
		endif
		
		SetToggleOptionValue(final_finisher_set_T, AbadonQuest.final_finisher_set)
		forcePageReset()
	endIf
EndFunction

int selected_device
Function OptionSelectDebug(int option)
	if fixBugs_T == option
		closeMCM()
		UDCD_NPCM.getNPCSlotByIndex(actorIndex).fix()
		;UDCDmain.removeCopies(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
		;forcePageReset()
	elseif removeUnused_T == option
		UDCDmain.removeUnusedDevices(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
		forcePageReset()
	elseif unlockAll_T == option
		closeMCM()
		UDCDmain.removeAllDevices(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
	elseif endAnimation_T == option
		closeMCM()
		bool[] cameraState = new Bool[2]
		cameraState[0] = False
		cameraState[1] = False
		UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor().RemoveFromFaction(UDCDmain.BlockAnimationFaction)
		UDCDmain.libs.EndThirdPersonAnimation(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), cameraState)
	elseif unregisterNPC_T == option
		UDCD_NPCM.unregisterNPC(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
		forcePageReset()
	elseif option == GlobalUpdateNPC_T
		int loc_globalupdate = StorageUtil.GetIntValue(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), "GlobalUpdate" , 0)
		StorageUtil.SetIntValue(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), "GlobalUpdate" , (!loc_globalupdate) as Int)
		SetToggleOptionValue(GlobalUpdateNPC_T, StorageUtil.GetIntValue(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), "GlobalUpdate" , 0))	
	elseif option == rescanSlots_T
		closeMCM()
		Utility.waitMenuMode(0.5)
		debug.notification("[UD] Scanning!")
		UDCD_NPCM.scanSlots(True)
		
		;forcePageReset()
	else
		int i = UDCD_NPCM.getNumSlots()
		while i 
			i -= 1
			if NPCSlots_T[i] == option
				actorIndex = i
				forcePageReset()
				return
			endif
		endwhile	
	
		i = registered_devices_T.length
		while i 
			i -= 1
			if registered_devices_T[i] == option
				selected_device = i
				
				closeMCM()
				UDCDmain.showDebugMenu(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(),selected_device)
				return
			endif
		endwhile
	endif
EndFunction

Function OptionSelectOther(int option)
	if UD_Export_T == option
		SaveToJSON(File)
		ShowMessage("Configuration saved!",false,"OK")
		;forcePageReset()
	elseif UD_Import_T == option
		LoadFromJSON(File)
		ShowMessage("Saved configuration loaded!",false,"OK")
		;forcePageReset()
	elseif option == UD_Default_T
		if ShowMessage("Do you really want to discard all changes and load default values?")
			ResetToDefaults()
		endif
	elseif option == UD_AutoLoad_T
		UDmain.UD_AutoLoad = !UDmain.UD_AutoLoad
		SetAutoLoad(UDmain.UD_AutoLoad)
		SetToggleOptionValue(UD_AutoLoad_T, UDmain.UD_AutoLoad)
	endif
EndFunction

event OnOptionSliderOpen(int option)
	OnOptionSliderOpenGeneral(option)
	OnOptionSliderOpenCustomBondage(option)
	OnOptionSliderOpenCustomOrgasm(option)
	OnOptionSliderOpenPatcher(option)
	OnOptionSliderOpenAbadon(option)
	OnOptionSliderOpenDebug(option)
endEvent

Function OnOptionSliderOpenGeneral(int option)
	if (option == UD_OrgasmExhaustionMagnitude_S)
		SetSliderDialogStartValue(Math.floor(UDmain.UD_OrgasmExhaustionMagnitude))
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == UD_OrgasmExhaustionDuration_S)
		SetSliderDialogStartValue(Math.floor(UDmain.UD_OrgasmExhaustionDuration))
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(10.0, 600.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_LoggingLevel_S)
		SetSliderDialogStartValue(UDmain.LogLevel)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 3.0)
		SetSliderDialogInterval(1.0)	
	elseif option == UD_RandomFilter_S
		SetSliderDialogStartValue(Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0xFFFF))
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 0xFFFF as Float)
		SetSliderDialogInterval(1.0)
	endIf
EndFunction

Function OnOptionSliderOpenCustomBondage(int option)
	if (option == UD_UpdateTime_S)
		SetSliderDialogStartValue(UDCDmain.UD_UpdateTime)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(1.0, 15.0)
		SetSliderDialogInterval(1.0)
	elseif option == UD_CooldownMultiplier_S
		SetSliderDialogStartValue(UDCDMain.Round(UDCDmain.UD_CooldownMultiplier*100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(25.0, 500.0)
		SetSliderDialogInterval(5.0)

	elseif (option == UD_LockpickMinigameNum_S)
		SetSliderDialogStartValue(UDCDmain.UD_LockpicksPerMinigame)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(1.0, 50.0)
		SetSliderDialogInterval(1.0)
	elseif (option == UD_AutoCritChance_S)
		SetSliderDialogStartValue(UDCDmain.UD_AutoCritChance)
		SetSliderDialogDefaultValue(80.0)
		SetSliderDialogRange(1.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == UD_BaseDeviceSkillIncrease_S)
		SetSliderDialogStartValue(UDCDmain.UD_BaseDeviceSkillIncrease)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(1.0, 1000.0)
		SetSliderDialogInterval(1.0)
	elseif option == UD_GagPhonemModifier_S
		SetSliderDialogStartValue(UDCDmain.UD_GagPhonemModifier)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	endif
EndFunction

Function OnOptionSliderOpenCustomOrgasm(int option)
	if (option == UD_OrgasmUpdateTime_S)
		SetSliderDialogStartValue(UDCDmain.UDOM.UD_OrgasmUpdateTime)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.1, 2.0)
		SetSliderDialogInterval(0.1)
	elseif (option == UD_OrgasmDuration_S)
		SetSliderDialogStartValue(UDmain.Round(UDCDmain.UDOM.UD_OrgasmDuration))
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(6.0,60.0)
		SetSliderDialogInterval(2.0)
	elseif (option == UD_HornyAnimationDuration_S)
		SetSliderDialogStartValue(UDmain.Round(UDCDmain.UDOM.UD_HornyAnimationDuration))
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(2.0,20.0)
		SetSliderDialogInterval(1.0)
	elseif option == UD_OrgasmResistence_S
		SetSliderDialogStartValue(UDCDmain.UDOM.UD_OrgasmResistence)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.1,10.0)
		SetSliderDialogInterval(0.1)
	elseif option == UD_VibrationMultiplier_S
		SetSliderDialogStartValue(UDCDmain.UD_VibrationMultiplier)
		SetSliderDialogDefaultValue(0.1)
		SetSliderDialogRange(0.01,0.5)
		SetSliderDialogInterval(0.01)
	elseif option == UD_ArousalMultiplier_S
		SetSliderDialogStartValue(UDCDmain.UD_ArousalMultiplier)
		SetSliderDialogDefaultValue(0.05)
		SetSliderDialogRange(0.01,0.5)
		SetSliderDialogInterval(0.01)
	endIf
EndFunction

Function OnOptionSliderOpenPatcher(int option)
	if (option == UD_MAOChanceMod_S)
		SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_MAOChanceMod)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 500.0)
		SetSliderDialogInterval(5.0)
	elseif (option == UD_MAOMod_S)
		SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_MAOMod)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 200.0)
		SetSliderDialogInterval(5.0)
	elseif (option == UD_MAHChanceMod_S)
		SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_MAHChanceMod)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 500.0)
		SetSliderDialogInterval(5.0)
	elseif (option == UD_MAHMod_S)
		SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_MAHMod)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 200.0)
		SetSliderDialogInterval(5.0)
	elseif (option == UD_PatchMult_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(10.0,300.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_EscapeModifier_S)
		SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_EscapeModifier)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(5.0,30.0)
		SetSliderDialogInterval(1.0)
	elseif option == UD_MinLocks_S
		SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_MinLocks)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(1.0,UDCDmain.UDPatcher.UD_MaxLocks)
		SetSliderDialogInterval(1.0)
	elseif option == UD_MaxLocks_S
		SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_MaxLocks)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(UDCDmain.UDPatcher.UD_MinLocks,30.0)
		SetSliderDialogInterval(1.0)
	elseif (option == UD_PatchMult_HeavyBondage_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(30.0,300.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_PatchMult_Blindfold_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Blindfold * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(30.0,300.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_PatchMult_Gag_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Gag * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(30.0,300.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_PatchMult_Hood_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Hood * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(30.0,300.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_PatchMult_ChastityBelt_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(30.0,300.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_PatchMult_ChastityBra_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBra * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(30.0,300.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_PatchMult_Plug_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Plug * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(30.0,300.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_PatchMult_Piercing_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Piercing * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(30.0,300.0)
		SetSliderDialogInterval(10.0)
	elseif (option == UD_PatchMult_Generic_S)
		SetSliderDialogStartValue(UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Generic * 100))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(30.0,300.0)
		SetSliderDialogInterval(10.0)
	endif
EndFunction

Function OnOptionSliderOpenAbadon(int option)
		if (option == max_difficulty_S)
			SetSliderDialogStartValue(AbadonQuest.max_difficulty)
			SetSliderDialogDefaultValue(100.0)
			SetSliderDialogRange(1.0, 300.0)
			SetSliderDialogInterval(1.0)
		elseIf (option == eventchancemod_S)
			SetSliderDialogStartValue(AbadonQuest.eventchancemod)
			SetSliderDialogDefaultValue(1.5)
			SetSliderDialogRange(0.0, 10.0)
			SetSliderDialogInterval(1.0)
		elseIf (option == little_finisher_chance_S)
			SetSliderDialogStartValue(AbadonQuest.little_finisher_chance)
			SetSliderDialogDefaultValue(1.5)
			SetSliderDialogRange(0.0, 100.0)
			SetSliderDialogInterval(1.0)
		elseIf (option == min_orgasm_little_finisher_S)
			SetSliderDialogStartValue(AbadonQuest.min_orgasm_little_finisher)
			SetSliderDialogDefaultValue(1.5)
			SetSliderDialogRange(1.0, 30.0)
			SetSliderDialogInterval(1.0)
		elseIf (option == max_orgasm_little_finisher_S)
			SetSliderDialogStartValue(AbadonQuest.max_orgasm_little_finisher)
			SetSliderDialogDefaultValue(1.5)
			SetSliderDialogRange(AbadonQuest.min_orgasm_little_finisher, 30.0)
			SetSliderDialogInterval(1.0)
		elseIf (option == little_finisher_cooldown_S)
			SetSliderDialogStartValue(AbadonQuest.little_finisher_cooldown)
			SetSliderDialogDefaultValue(1.5)
			SetSliderDialogRange(1.0, 12.0)
			SetSliderDialogInterval(0.5)
		endIf
EndFunction

Function OnOptionSliderOpenDebug(int option)
	if option == OrgasmResist_S
		UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(actorIndex)
		SetSliderDialogStartValue(UDCDmain.UDOM.getActorOrgasmResist(slot.getActor()))
		SetSliderDialogDefaultValue(UDCDmain.UDOM.UD_OrgasmResistence)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	elseif option == OrgasmCapacity_S
		UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(actorIndex)
		SetSliderDialogStartValue(UDCDmain.UDOM.getActorOrgasmCapacity(slot.getActor()))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(10.0, 500.0)
		SetSliderDialogInterval(5.0)		
	endIf
EndFunction
	
event OnOptionSliderAccept(int option, float value)
	OnOptionSliderAcceptGeneral(option,value)
	OnOptionSliderAcceptCustomBondage(option, value)
	OnOptionSliderAcceptCustomOrgasm(option, value)
	OnOptionSliderAcceptPatcher(option, value)
	OnOptionSliderAcceptAbadon(option, value)
	OnOptionSliderAcceptDebug(option,value)
endEvent

Function OnOptionSliderAcceptGeneral(int option, float value)
	if (option == UD_OrgasmExhaustionMagnitude_S)
		UDmain.UD_OrgasmExhaustionMagnitude = value
		SetSliderOptionValue(UD_OrgasmExhaustionMagnitude_S, UDmain.UD_OrgasmExhaustionMagnitude, "{0} %")
	elseif (option == UD_OrgasmExhaustionDuration_S)
		UDmain.UD_OrgasmExhaustionDuration = UDmain.Round(value)
		SetSliderOptionValue(UD_OrgasmExhaustionDuration_S, UDmain.UD_OrgasmExhaustionDuration, "{0} s")
	elseif (option == UD_LoggingLevel_S)
		UDmain.LogLevel = UDmain.round(value)
		SetSliderOptionValue(UD_LoggingLevel_S, UDmain.LogLevel, "{0}")
	elseif option == UD_RandomFilter_S
		UDmain.UDRRM.UD_RandomDevice_GlobalFilter =  Math.LogicalXor(UDmain.round(value),0xFFFF)
		SetSliderOptionValue(UD_RandomFilter_S, UDCDmain.Round(value), "{0}")
	endIf
EndFunction

Function OnOptionSliderAcceptCustomBondage(int option, float value)
	if (option == UD_UpdateTime_S)
		UDCDmain.UD_UpdateTime = value
		SetSliderOptionValue(UD_UpdateTime_S, UDCDmain.UD_UpdateTime, "{0} s")
	elseif option == UD_CooldownMultiplier_S
		UDCDmain.UD_CooldownMultiplier = value/100
		SetSliderOptionValue(UD_CooldownMultiplier_S, UDCDmain.Round(UDCDmain.UD_CooldownMultiplier*100), "{0} %")
	elseif (option == UD_LockpickMinigameNum_S)
		UDCDmain.UD_LockpicksPerMinigame = Math.floor(value + 0.5)
		SetSliderOptionValue(UD_LockpickMinigameNum_S, UDCDmain.UD_LockpicksPerMinigame, "{0}")
	elseif (option == UD_AutoCritChance_S)
		UDCDmain.UD_AutoCritChance = UDmain.round(value)
		SetSliderOptionValue(UD_AutoCritChance_S, UDCDmain.UD_AutoCritChance, "{0} %")
	elseif (option == UD_BaseDeviceSkillIncrease_S)
		UDCDmain.UD_BaseDeviceSkillIncrease = UDmain.round(value)
		SetSliderOptionValue(UD_BaseDeviceSkillIncrease_S, UDCDmain.UD_BaseDeviceSkillIncrease, "{0}")
	elseif option == UD_GagPhonemModifier_S
		UDCDmain.UD_GagPhonemModifier = UDmain.round(value)
		SetSliderOptionValue(UD_GagPhonemModifier_S, UDCDmain.UD_GagPhonemModifier, "{0}")
	endif
EndFunction

Function OnOptionSliderAcceptCustomOrgasm(int option, float value)
	if (option == UD_OrgasmUpdateTime_S)
		UDCDmain.UDOM.UD_OrgasmUpdateTime = value
		SetSliderOptionValue(UD_OrgasmUpdateTime_S, UDCDmain.UDOM.UD_OrgasmUpdateTime, "{1} s")
	elseif (option == UD_OrgasmDuration_S)
		UDCDmain.UDOM.UD_OrgasmDuration = UDmain.Round(value)
		SetSliderOptionValue(UD_OrgasmDuration_S, UDCDmain.UDOM.UD_OrgasmDuration, "{0} s")
	elseif (option == UD_HornyAnimationDuration_S)
		UDCDmain.UDOM.UD_HornyAnimationDuration = UDmain.Round(value)
		SetSliderOptionValue(UD_HornyAnimationDuration_S, UDCDmain.UDOM.UD_HornyAnimationDuration, "{0} s")
	elseif option == UD_OrgasmResistence_S
		UDCDmain.UDOM.UD_OrgasmResistence = value
		SetSliderOptionValue(UD_OrgasmResistence_S, UDCDmain.UDOM.UD_OrgasmResistence, "{1} Op/s")
	elseif option == UD_VibrationMultiplier_S
		UDCDmain.UD_VibrationMultiplier = value
		SetSliderOptionValue(UD_VibrationMultiplier_S, UDCDmain.UD_VibrationMultiplier, "{3}")
	elseif option == UD_ArousalMultiplier_S
		UDCDmain.UD_ArousalMultiplier = value
		SetSliderOptionValue(UD_ArousalMultiplier_S, UDCDmain.UD_ArousalMultiplier, "{3}")
	endIf
EndFunction

Function OnOptionSliderAcceptPatcher(int option, float value)
	int loc_value = UDCDmain.Round(value)
	if (option == UD_MAOChanceMod_S)
		UDCDmain.UDPatcher.UD_MAOChanceMod = loc_value
		SetSliderOptionValue(UD_MAOChanceMod_S, UDCDmain.UDPatcher.UD_MAOChanceMod, "{0} %")
	elseif (option == UD_MAOMod_S)
		UDCDmain.UDPatcher.UD_MAOMod = loc_value
		SetSliderOptionValue(UD_MAOMod_S, UDCDmain.UDPatcher.UD_MAOMod, "{0} %")
	elseif (option == UD_MAHChanceMod_S)
		UDCDmain.UDPatcher.UD_MAHChanceMod = loc_value
		SetSliderOptionValue(UD_MAHChanceMod_S, UDCDmain.UDPatcher.UD_MAHChanceMod, "{0} %")
	elseif (option == UD_MAHMod_S)
		UDCDmain.UDPatcher.UD_MAHMod = loc_value
		SetSliderOptionValue(UD_MAHMod_S, UDCDmain.UDPatcher.UD_MAHMod, "{0} %")
	elseif (option == UD_PatchMult_S)
		UDCDmain.UDPatcher.UD_PatchMult = value/100.0
		SetSliderOptionValue(UD_PatchMult_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult * 100), "{0} %")
	elseif (option == UD_EscapeModifier_S)
		UDCDmain.UDPatcher.UD_EscapeModifier = UDCDmain.Round(value)
		SetSliderOptionValue(UD_EscapeModifier_S, UDCDmain.UDPatcher.UD_EscapeModifier, "{0}")
	elseif option == UD_MinLocks_S
		UDCDmain.UDPatcher.UD_MinLocks = UDCDmain.Round(value)
		SetSliderOptionValue(UD_MinLocks_S, UDCDmain.UDPatcher.UD_MinLocks, "{0}")
	elseif option == UD_MaxLocks_S
		UDCDmain.UDPatcher.UD_MaxLocks = UDCDmain.Round(value)
		SetSliderOptionValue(UD_MaxLocks_S, UDCDmain.UDPatcher.UD_MaxLocks, "{0}")
	elseif (option == UD_PatchMult_HeavyBondage_S)
		UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage = value/100.0
		SetSliderOptionValue(UD_PatchMult_HeavyBondage_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage * 100), "{0} %")
	elseif (option == UD_PatchMult_Blindfold_S)
		UDCDmain.UDPatcher.UD_PatchMult_Blindfold = value/100.0
		SetSliderOptionValue(UD_PatchMult_Blindfold_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Blindfold * 100), "{0} %")
	elseif (option == UD_PatchMult_Gag_S)
		UDCDmain.UDPatcher.UD_PatchMult_Gag = value/100.0
		SetSliderOptionValue(UD_PatchMult_Gag_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Gag * 100), "{0} %")
	elseif (option == UD_PatchMult_Hood_S)
		UDCDmain.UDPatcher.UD_PatchMult_Hood = value/100.0
		SetSliderOptionValue(UD_PatchMult_Hood_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Hood * 100), "{0} %")
	elseif (option == UD_PatchMult_ChastityBelt_S)
		UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt = value/100.0
		SetSliderOptionValue(UD_PatchMult_ChastityBelt_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt * 100), "{0} %")
	elseif (option == UD_PatchMult_ChastityBra_S)
		UDCDmain.UDPatcher.UD_PatchMult_ChastityBra = value/100.0
		SetSliderOptionValue(UD_PatchMult_ChastityBra_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBra * 100), "{0} %")
	elseif (option == UD_PatchMult_Plug_S)
		UDCDmain.UDPatcher.UD_PatchMult_Plug = value/100.0
		SetSliderOptionValue(UD_PatchMult_Plug_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Plug * 100), "{0} %")
	elseif (option == UD_PatchMult_Piercing_S)
		UDCDmain.UDPatcher.UD_PatchMult_Piercing = value/100.0
		SetSliderOptionValue(UD_PatchMult_Piercing_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Piercing * 100), "{0} %")
	elseif (option == UD_PatchMult_Generic_S)
		UDCDmain.UDPatcher.UD_PatchMult_Generic = value/100.0
		SetSliderOptionValue(UD_PatchMult_Generic_S, UDCDmain.Round(UDCDmain.UDPatcher.UD_PatchMult_Generic * 100), "{0} %")
	endif
EndFunction

Function OnOptionSliderAcceptAbadon(int option, float value)
	if (option == max_difficulty_S)
		AbadonQuest.max_difficulty = value
		SetSliderOptionValue(max_difficulty_S, AbadonQuest.max_difficulty, "{0}")
	elseIf (option == eventchancemod_S)
		AbadonQuest.eventchancemod = value as int
		SetSliderOptionValue(eventchancemod_S, AbadonQuest.eventchancemod, "{0} %")
	elseIf (option == little_finisher_chance_S)
		AbadonQuest.little_finisher_chance = value as int
		SetSliderOptionValue(little_finisher_chance_S, AbadonQuest.little_finisher_chance, "{1} %")
	elseIf (option == min_orgasm_little_finisher_S)
		AbadonQuest.min_orgasm_little_finisher = value as int
		SetSliderOptionValue(min_orgasm_little_finisher_S, AbadonQuest.min_orgasm_little_finisher, "{1}")
	elseIf (option == max_orgasm_little_finisher_S)
		AbadonQuest.max_orgasm_little_finisher = value as int
		SetSliderOptionValue(max_orgasm_little_finisher_S, AbadonQuest.max_orgasm_little_finisher, "{1}")
	elseIf (option == little_finisher_cooldown_S)
		AbadonQuest.little_finisher_cooldown = value
		SetSliderOptionValue(little_finisher_cooldown_S, AbadonQuest.little_finisher_cooldown, "{1}")
	endIf
EndFunction

Function OnOptionSliderAcceptDebug(int option,float value)
	if option == OrgasmResist_S
		UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(actorIndex)
		UDCDmain.UDOM.setActorOrgasmResist(slot.getActor(),value)
		SetSliderOptionValue(OrgasmResist_S, UDCDmain.UDOM.GetActorOrgasmResist(slot.getActor()), "{1}")
	elseif option == OrgasmCapacity_S
		UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(actorIndex)
		UDCDmain.UDOM.setActorOrgasmCapacity(slot.getActor(),value)
		SetSliderOptionValue(OrgasmCapacity_S, UDCDmain.UDOM.GetActorOrgasmCapacity(slot.getActor()), "{0}")		
	endIf
EndFunction

event OnOptionMenuOpen(int option)
	OnOptionMenuOpenCustomBondage(option)
	OnOptionMenuOpenCustomOrgasm(option)
	OnOptionMenuOpenAbadon(option)
endEvent

Function OnOptionMenuOpenAbadon(int option)
	if (option == difficulty_M)
		SetMenuDialogOptions(difficultyList)
		SetMenuDialogStartIndex(AbadonQuest.overaldifficulty)
		SetMenuDialogDefaultIndex(1)
	elseif (option == preset_M)
		SetMenuDialogOptions(presetList)
		SetMenuDialogStartIndex(preset)
		SetMenuDialogDefaultIndex(0)
	elseif option == final_finisher_pref_M
		SetMenuDialogOptions(final_finisher_pref_list)
		SetMenuDialogStartIndex(AbadonQuest.final_finisher_pref)
		SetMenuDialogDefaultIndex(1)
	endif
EndFunction

Function OnOptionMenuOpenCustomBondage(int option)
	if (option == UD_hardcore_swimming_difficulty_M)
		SetMenuDialogOptions(difficultyList)
		SetMenuDialogStartIndex(UDSS.UD_hardcore_swimming_difficulty)
		SetMenuDialogDefaultIndex(1)
	elseif (option == UD_StruggleDifficulty_M)
		SetMenuDialogOptions(difficultyList)
		SetMenuDialogStartIndex(UDCDmain.UD_StruggleDifficulty)
		SetMenuDialogDefaultIndex(1)
	elseif (option == UD_WidgetPosX_M)
		SetMenuDialogOptions(widgetXList)
		SetMenuDialogStartIndex(widget.PositionX)
		SetMenuDialogDefaultIndex(1)
	elseif (option == UD_WidgetPosY_M)
		SetMenuDialogOptions(widgetYList)
		SetMenuDialogStartIndex(widget.PositionY)
		SetMenuDialogDefaultIndex(1)
	elseif option == UD_CritEffect_M
		SetMenuDialogOptions(criteffectList)
		SetMenuDialogStartIndex(UDCDmain.UD_CritEffect)
		SetMenuDialogDefaultIndex(2)
	endif
EndFunction

Function OnOptionMenuOpenCustomOrgasm(int option)
	if (option == UD_OrgasmAnimation_M)
		SetMenuDialogOptions(orgasmAnimation)
		SetMenuDialogStartIndex(UDCDmain.UDOM.UD_OrgasmAnimation)
		SetMenuDialogDefaultIndex(0)
	endif
EndFunction

event OnOptionMenuAccept(int option, int index)
	OnOptionMenuAcceptCustomBondage(option,index)
	OnOptionMenuAcceptCustomOrgasm(option,index)
	OnOptionMenuAcceptAbadon(option, index)
endEvent

Function OnOptionMenuAcceptAbadon(int option, int index)
	if (option == difficulty_M)
		AbadonQuest.overaldifficulty = index
		SetMenuOptionValue(difficulty_M, difficultyList[AbadonQuest.overaldifficulty])
	elseif (option == preset_M)
		preset = index
		setAbadonPreset(preset)
		SetMenuOptionValue(preset_M, presetList[preset])
		forcePageReset()
	elseif (option == final_finisher_pref_M)
		AbadonQuest.final_finisher_pref = index
		SetMenuOptionValue(final_finisher_pref_M, final_finisher_pref_list[AbadonQuest.final_finisher_pref])
	endIf
EndFunction

Function OnOptionMenuAcceptCustomBondage(int option, int index)
	if (option == UD_hardcore_swimming_difficulty_M)
		UDSS.UD_hardcore_swimming_difficulty = index
		SetMenuOptionValue(UD_hardcore_swimming_difficulty_M, difficultyList[UDSS.UD_hardcore_swimming_difficulty])
	elseif (option == UD_StruggleDifficulty_M)
		UDCDmain.UD_StruggleDifficulty = index
		SetMenuOptionValue(UD_StruggleDifficulty_M, difficultyList[UDCDmain.UD_StruggleDifficulty])
		forcePageReset()
	elseif (option == UD_WidgetPosX_M)
		widget.PositionX = index
		UDCDmain.widget2.PositionX = index
		SetMenuOptionValue(UD_WidgetPosX_M, widgetXList[widget.PositionX])
		forcePageReset()
	elseif (option == UD_WidgetPosY_M)
		widget.PositionY = index
		UDCDmain.widget2.PositionY = index
		SetMenuOptionValue(UD_WidgetPosY_M, widgetYList[widget.PositionY])
		forcePageReset()
	elseif option == UD_CritEffect_M
		UDCDmain.UD_CritEffect = index
		SetMenuOptionValue(UD_CritEffect_M, criteffectList[UDCDmain.UD_CritEffect])
		forcePageReset()
	endIf
EndFunction

Function OnOptionMenuAcceptCustomOrgasm(int option, int index)
	if (option == UD_OrgasmAnimation_M)
		UDCDmain.UDOM.UD_OrgasmAnimation = index
		SetMenuOptionValue(UD_OrgasmAnimation_M, orgasmAnimation[UDCDmain.UDOM.UD_OrgasmAnimation])
	endIf
EndFunction

bool Function checkMinigameKeyConflict(int iKeyCode)
	bool loc_res = true
	loc_res = loc_res && (iKeyCode != UDCDmain.Stamina_meter_Keycode)
	loc_res = loc_res && (iKeyCode != UDCDmain.Magicka_meter_Keycode)
	loc_res = loc_res && (iKeyCode != UDCDmain.SpecialKey_Keycode)
	
	return loc_res
EndFunction

bool Function checkGeneralKeyConflict(int iKeyCode)
	bool loc_res = true
	loc_res = loc_res && (iKeyCode != UDCDmain.StruggleKey_Keycode)
	loc_res = loc_res && (iKeyCode != UDCDmain.PlayerMenu_KeyCode)
	loc_res = loc_res && (iKeyCode != UDCDmain.ActionKey_Keycode)
	loc_res = loc_res && (iKeyCode != UDCDmain.NPCMenu_Keycode)
	return loc_res
EndFunction

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	if (option == UD_StruggleKey_K)
		if checkGeneralKeyConflict(keyCode)
			UDCDmain.UnRegisterForKey(UDCDmain.StruggleKey_Keycode)
			UDCDmain.StruggleKey_Keycode = keyCode
			SetKeyMapOptionValue(UD_StruggleKey_K, UDCDmain.StruggleKey_Keycode)
			UDCDmain.RegisterForKey(UDCDmain.StruggleKey_Keycode)
		endif
	elseif (option == UD_ActionKey_K)
		if checkGeneralKeyConflict(keyCode)
			UDCDmain.UnRegisterForKey(UDCDmain.ActionKey_Keycode)
			UDCDmain.ActionKey_Keycode = keyCode
			UDCDmain.RegisterForKey(UDCDmain.ActionKey_Keycode)
			SetKeyMapOptionValue(UD_ActionKey_K, UDCDmain.ActionKey_Keycode)
		endif
	elseif option == UD_PlayerMenu_K
		if checkGeneralKeyConflict(keyCode)
			UDCDmain.UnRegisterForKey(UDCDmain.PlayerMenu_KeyCode)
			UDCDmain.PlayerMenu_KeyCode = keyCode
			SetKeyMapOptionValue(UD_PlayerMenu_K, UDCDmain.PlayerMenu_KeyCode)
			UDCDmain.RegisterForKey(UDCDmain.PlayerMenu_KeyCode)
		endif
	elseif option == UD_NPCMenu_K
		if checkGeneralKeyConflict(keyCode)
			UDCDmain.UnRegisterForKey(UDCDmain.NPCMenu_Keycode)
			UDCDmain.NPCMenu_Keycode = keyCode
			SetKeyMapOptionValue(UD_NPCMenu_K, UDCDmain.NPCMenu_Keycode)
			UDCDmain.RegisterForKey(UDCDmain.NPCMenu_Keycode)
		endif
	elseif (option == UD_CHB_Stamina_meter_Keycode_K)
		if checkMinigameKeyConflict(keyCode)
			UDCDmain.UnRegisterForKey(UDCDmain.Stamina_meter_Keycode)
			UDCDmain.Stamina_meter_Keycode = keyCode
			UDCDmain.RegisterForKey(UDCDmain.Stamina_meter_Keycode)
			SetKeyMapOptionValue(UD_CHB_Stamina_meter_Keycode_K, UDCDmain.Stamina_meter_Keycode)
		endif
	elseif (option == UD_CHB_Magicka_meter_Keycode_K)
		if checkMinigameKeyConflict(keyCode)
			UDCDmain.UnRegisterForKey(UDCDmain.Magicka_meter_Keycode)
			UDCDmain.Magicka_meter_Keycode = keyCode
			UDCDmain.RegisterForKey(UDCDmain.Magicka_meter_Keycode)
			SetKeyMapOptionValue(UD_CHB_Magicka_meter_Keycode_K, UDCDmain.Magicka_meter_Keycode)
		endif
	elseif (option == UDCD_SpecialKey_Keycode_K)
		if checkMinigameKeyConflict(keyCode)
			UDCDmain.UnRegisterForKey(UDCDmain.SpecialKey_Keycode)
			UDCDmain.SpecialKey_Keycode = keyCode
			UDCDmain.RegisterForKey(UDCDmain.SpecialKey_Keycode)
			SetKeyMapOptionValue(UDCD_SpecialKey_Keycode_K, UDCDmain.SpecialKey_Keycode)
		endif
	endIf	
endEvent

Event OnOptionHighlight(int option)
	GeneralPageInfo(option)
	AbadanPageInfo(option)
	CustomBondagePageInfo(option)
	CustomOrgasmPageInfo(option)
	PatcherPageInfo(option)
	DebugPageInfo(option)
EndEvent

Function GeneralPageInfo(int option)
	if(option == lockmenu_T)
		SetInfoText("Dissable MCM when any of Unforgiving devices is equiped")
	elseif(option == UD_OrgasmExhaustion_T)
		SetInfoText("Adds debuff to player on orgasm. Thsi debuff reduces stamina and magicka regeneration for short time. This effect is applied as on DD orgasm as on Sexlab scene orgasm.")
	elseif(option == UD_OrgasmExhaustionMagnitude_S)
		SetInfoText("Strength of debuff in percent. This value is only modifier and doesn't represent excant reduction of regeneration. Example: 50% will not half regeneratio but reduce it much less. On ther hand 60% may reduce regeneration to zero.")
	elseif(option == UD_OrgasmExhaustionDuration_S)
		SetInfoText("Duration of debuff. 30 second is duration of taper that take place after effect ends. Taper will reduce debuff strength over time untill it get reduced to zero. So 50s duration is 20 base duration + 30 taper duration, when only during 20s will have effect maximum effect.")
	elseif(option == UD_ActionKey_K)
		SetInfoText("Current use: Stops struggling")
	elseif(option == UD_StruggleKey_K)
		SetInfoText("Current use: Starts struggling")
	elseif(option == UD_hightPerformance_T)
		SetInfoText("Hight performance mod will decrease update time. This will make struggle game more smooth and also less buggy.")
	elseif(option == UD_useHoods_T)
		SetInfoText("Toogle if hoods can be equipped on player by this mod.")
	elseif(option == UD_debugmod_T)
		SetInfoText("Toogle debug mod. Debug mod shows more information for devices from this mod.")
	elseif (option == UD_NPCSupport_T)
		SetInfoText("Toogle automatic scaning")
	elseif option == UD_RandomFilter_S
		SetInfoText("Set random restrain filter. This is bitcoded value. For more info check LL or GitHub")
	Endif
EndFunction
Function CustomBondagePageInfo(int option)
	if(option == UD_CHB_Stamina_meter_Keycode_K)
		SetInfoText("Key to crit device while struggling when stamina bar blinks")
	elseif option == UD_UseWidget_T
		SetInfoText("Shows widget in minigame that shows current relevant value. Not all minigames will show widget because they may not use them.")
	elseif(option == UD_CHB_Magicka_meter_Keycode_K)
		SetInfoText("Key to crit device while struggling when magicka bar blinks")
	elseif(option == UD_StruggleDifficulty_M)
		SetInfoText("General escape difficulty of custom heavy bondage.")
	elseif(option == UD_UpdateTime_S)
		SetInfoText("Update time for all registered devices.")
	elseif(option == UD_UseDDdifficulty_T)
		SetInfoText("Integrate difficulty from DD framework. This adds to general escape difficulty of custom heavy bondage")
	elseif(option == UD_hardcore_swimming_T)
		SetInfoText("Toggle hardcore swimming. If on, player will have hard time swimming with tied hands. This works for any devices, not only for devices from this mod. Slow will be applied on player and stamina will starts to decrease. Once all stamina is consumed, player will be slowed even further and health will now starts to decrease too.")
	elseif(option == UD_hardcore_swimming_difficulty_M)
		SetInfoText("Difficulty of swimming with tied hands. The harded the difficulty, the more stamina and health will be drain. Player will also be more slowed.")
	elseif option == UD_WidgetPosX_M
		SetInfoText("Change widget X position\nDefault: Right")
	elseif option == UD_WidgetPosY_M
		SetInfoText("Change widget Y position\nDefault: Down")
	elseif option == UD_LockpickMinigameNum_S
		SetInfoText("Change number of lockpicks player can use in lockpick minigame.\nDefault: 2")
	elseif option == UD_BaseDeviceSkillIncrease_S
		SetInfoText("How many skill points are acquired for second of struggling.\nDefault: 35")
	elseif option == UD_GagPhonemModifier_S
		SetInfoText("Change how much is mouth opened when gagged. Is disabled for panel gags, as it cause clipping.\nDefault: 0")
	elseif option == UD_AutoCrit_T
		SetInfoText("Toggle auto crit. Auto crit will crit instead of user. Use this if you don't like crits or you can't crit for some other reason.\nDefault: OFF")
	elseif option == UD_AutoCritChance_S
		SetInfoText("Chance that auto crit will result in sucessfull crit.\nDefault: 80%")
	elseif option == UD_CritEffect_M
		SetInfoText("Effect used to indicate that crit is happening.\n[HUD] HUD will blink when crit is happening\n[Body shader] Actor body will have shader applied for short time\n[HUD + Body shader] Both of the previous effects combined\nDefault: [HUD + Body shader]")
	elseif option == UD_CooldownMultiplier_S
		SetInfoText("Change how big the devices cooldowns are. The bigger the value the bigger they will be.\nExamle: 200% makes all devices cooldown two times bigger.\nDefault: 100%")
	elseif option == UD_HardcoreMode_T
		SetInfoText("Hardcore mode disables most game features when players hands are tied up, to empathize the helpless feeling\n*Disables Inventory, Magick Menu and Fast travel (Map still works)\nTween menu is disabled, pressing it will open list of devices\nStats and Map can only be opened with key\nDefault: OFF")
	Endif
EndFunction

Function CustomOrgasmPageInfo(int option)
	if(option == UD_OrgasmUpdateTime_S)
		SetInfoText("Update time for orgasm checking (how fast is orgasm widget updated). Is only used for player.\n Default: 0.2s")
	elseif option == UD_OrgasmAnimation_M
		SetInfoText("List of orgasm animations.\nNormal = Normal orgasm animation by  DD\nExtended = Orgasm animation + horny animations\nDefault: Normal")
	elseif option == UD_UseOrgasmWidget_T
		SetInfoText("Toogle orgasm progress widget\nDefault: ON")
	elseif option == UD_OrgasmResistence_S
		SetInfoText("Defines how much orgasm rate is required for actor to orgasm. If orgasm rate is less then this, orgasm progress will stop before 100%. Also changes how fast is orgasm progress reduced for every update.\nDefault: 2.0")
	elseif option == UD_HornyAnimation_T
		SetInfoText("Toogle if random horny animation can play while orgasm rate is bigger then 0\nDefault: YES")
	elseif option == UD_HornyAnimationDuration_S
		SetInfoText("Duration of random horny animation\nDefault: 5 s")
	elseif option == UD_VibrationMultiplier_S
		SetInfoText("Constant for calculating Orgasm rate from Vibration strength. Example: If this value is 0.1 and vibrator strength is 100, resulting Orgasm rate is 10\nDefault: 0.1 s")
	elseif option == UD_VibrationMultiplier_S
		SetInfoText("Constant for calculating Arousal rate from Vibration strength. Example: If this value is 0.025 and vibrator strength is 100, resulting Arousal rate is 2.5\nDefault: 0.025 s")
	Endif
EndFunction

Function PatcherPageInfo(int option)
	if  option == UD_PatchMult_S
		SetInfoText("Sets patching multiplier. The more this value the harder will be patched devices.\nDefault: 100%")
	elseif option == UD_MAOChanceMod_S
		SetInfoText("Sets MAO chance multiplier. Bigger the value, the more likely will patched device have MAO modifier\nExample: If patcher have set value of 8% of adding this modifier to device and this value will be 50%, result chance is 4%.\nDefault: 100%")
	elseif option == UD_MAHChanceMod_S
		SetInfoText("Sets MAH chance multiplier. Bigger the value, the more likely will patched device have MAH modifier\nExample: If patcher have set value of 8% of adding this modifier to device and this value will be 50%, result chance is 4%.\nDefault: 100%")
	elseif option == UD_MAOMod_S
		SetInfoText("Sets Orgasm manifest (MAO) multiplier. Bigger the value, the more likely will device manifest when actor orgasms.\nExample: If device have manifest 50% and this value will be 50%, result chance is 25%.\nDefault: 100%")
	elseif option == UD_MAHMod_S
		SetInfoText("Sets Hour manifest (MAH) multiplier. Bigger the value, the more likely will device manifest every hour.\nExample: If device have manifest 50% and this value will be 50%, result chance is 25%.\nDefault: 100%")
	elseif option == UD_EscapeModifier_S
		SetInfoText("Sets escape modifier. Escape modifier determinates how patched device DPS is calculated. Default formalu is DDEscapeChance/EscapeModifier = DPS\n Example: if this is 10 and to be patched device have escape chance 10%, resulting base DPS will be 1.0\nDefault: 10")
	elseif option == UD_MinLocks_S
		SetInfoText("Minimum number of locks which device can get by patcher\nDefault: 1")
	elseif option == UD_MaxLocks_S
		SetInfoText("Maximum number of locks which device can get by patcher\nDefault: 1")
	endif
EndFunction

Function AbadanPageInfo(int option)
	;dear mother of god
	if (option == dmg_heal_T)
		SetInfoText("Toggle if plug should sap health from player on Orgasm,Edge or Vib")
	elseif (option == UseAnalVariant_T)
		SetInfoText("Toggle if Anal plug will be used instead of vaginal plug. This only switch which is used for Abadon Curse quest and gets disabled after the letter from courier is readed.")
	elseif(option == dmg_stamina_T)
		SetInfoText("Toggle if plug should sap stamina from player on Orgasm,Edge or Vib")
	elseif(option == dmg_magica_T)
		SetInfoText("Toggle if plug should sap magica from player on Orgasm,Edge or Vib")
	elseif(option == hardcore_T)
		SetInfoText("Toggle Hardcore mod.\n This makes it possible for plug to kill you. Otherwise the plug will only sap your health to 1")
	elseif (option == difficulty_M)
		SetInfoText("Select plug difficulty. This changes how much health,stamina and magica is sapped from player")
	elseif (option == preset_M)
		SetInfoText("Overal setting preset. If you want to change values to your liking, then select custom preset")
	elseif (option == max_difficulty_S)
		SetInfoText("Maximum strength at which last finisher is activated")
	elseIf (option == eventchancemod_S)
		SetInfoText("Chance of abadon plug event modifier.\nEnd formula of event happening is base_chance + eventmodifier*(Strength -> 0.0-1.0)\nBase chance can be changed in Devious Devices MCM under Events pages. Just look for Abadon Plug Chance.\n Default base_chance is 50%.")
	elseIf (option == little_finisher_chance_S)
		SetInfoText("Chance of little finisher happening when plug grow stronger.\nWarning: This is max value thet is only achieved at maximum plug strength.")
	elseIf (option == min_orgasm_little_finisher_S)
		SetInfoText("Minimum number of orgasms player will have to receive for little finisher to end.")
	elseIf (option == max_orgasm_little_finisher_S)
		SetInfoText("Maximum number of orgasms player will have to receive for little finisher to end.")
	elseIf (option == little_finisher_cooldown_S)
		SetInfoText("Time in hours after which can little finisher happen again.")
	elseIf (option == final_finisher_pref_M)
		SetInfoText("Set equiped when player equip plug.")
	endIf
EndFunction
Function DebugPageInfo(int option)
	;dear mother of god
	if (option == rescanSlots_T)
		SetInfoText("Rescan all slots with nearby npcs. This is only way to fill slots if Auto scan is turned off.")
	elseif option == fixBugs_T
		SetInfoText("Apply some fixes for selected slot.\n-Rest orgasm check loop\n-Remove lost devices\n-Removes copies\n-Removes unused devices\n-Resets minigame states")
	elseif option == removeUnused_T
		SetInfoText("Remove all unused devices. (Buggy, probably doesn't work)")	
	elseif option == unlockAll_T
		SetInfoText("Unlock all currently REGISTERED devices")
	elseif option == endAnimation_T
		SetInfoText("Ends animation for currently sloted npc")
	elseif option == unregisterNPC_T
		SetInfoText("Unregister whole slot. This will not unlock any devices.")
	elseif option == OrgasmCapacity_S
		SetInfoText("Change registered NPC orgasm capacity.This change how fast will actor reach orgasm.\nDefault: 100")
	elseif option == OrgasmResist_S
		SetInfoText("Change registered NPC orgasm resistence.This change how fast will actor reach orgasm AND if actor will reach orgasm at all.\nDefault: Set in MCM (Custom Orgasm tab)")
	endIf
EndFunction

Function setAbadonPreset(int selected_preset)
	preset = selected_preset
	if preset == 3
		abadon_flag = OPTION_FLAG_NONE
		return
	else
		abadon_flag = OPTION_FLAG_DISABLED
	endif
	
	
	if (preset == 0) ;forgiving
		AbadonQuest.max_difficulty = 150.0
		AbadonQuest.overaldifficulty = 0 ;0-3 where 3 is same as in MDS
		AbadonQuest.eventchancemod = 2

		AbadonQuest.little_finisher_chance = 60
		AbadonQuest.min_orgasm_little_finisher = 2
		AbadonQuest.max_orgasm_little_finisher = 4

		AbadonQuest.dmg_heal = False
		AbadonQuest.dmg_magica = True
		AbadonQuest.dmg_stamina = True
		AbadonQuest.little_finisher_cooldown = 6.0 ;in hours

		AbadonQuest.hardcore = False
	elseif (preset == 1) ;pleasure slave
		AbadonQuest.max_difficulty = 100.0
		AbadonQuest.overaldifficulty = 1 ;0-3 where 3 is same as in MDS
		AbadonQuest.eventchancemod = 10

		AbadonQuest.little_finisher_chance = 100
		AbadonQuest.min_orgasm_little_finisher = 4
		AbadonQuest.max_orgasm_little_finisher = 8
		AbadonQuest.little_finisher_cooldown = 3.0 ;in hours
		
		AbadonQuest.dmg_heal = True
		AbadonQuest.dmg_magica = True
		AbadonQuest.dmg_stamina = True
		
		AbadonQuest.hardcore = False
	elseif (preset == 2) ;game of time
		AbadonQuest.max_difficulty = 100.0
		AbadonQuest.overaldifficulty = 0 ;1-3 where 3 is same as in MDS
		AbadonQuest.eventchancemod = 4

		AbadonQuest.little_finisher_chance = 50
		AbadonQuest.min_orgasm_little_finisher = 3
		AbadonQuest.max_orgasm_little_finisher = 6
		AbadonQuest.little_finisher_cooldown = 12.0 ;in hours
		
		AbadonQuest.dmg_heal = True
		AbadonQuest.dmg_magica = True
		AbadonQuest.dmg_stamina = True
		
		AbadonQuest.hardcore = True
	endif
EndFunction 

;https://forums.nexusmods.com/index.php?/topic/4795300-starting-quests-from-mcm-quest-script-best-method/
Function closeMCM()
	UI.Invoke("Journal Menu", "_root.QuestJournalFader.Menu_mc.ConfigPanelClose")
	UI.Invoke("Journal Menu", "_root.QuestJournalFader.Menu_mc.CloseMenu")
EndFunction

string property File hidden
	string function get()
		return "../UD/Config.json"
	endFunction
endProperty

Function SaveToJSON(string strFile)
	JsonUtil.ClearAll(strFile)
	
	;UDmain
	JsonUtil.SetIntValue(strFile, "hightPerformance", UDmain.UD_hightPerformance as Int)
	JsonUtil.SetIntValue(strFile, "AllowNPCSupport", UDmain.AllowNPCSupport as Int)
	JsonUtil.SetIntValue(strFile, "lockMCM", UDmain.lockMCM as Int)
	JsonUtil.SetIntValue(strFile, "Debug mode", UDmain.DebugMod as Int)
	JsonUtil.SetIntValue(strFile, "OrgasmExhastion", UDmain.UD_OrgasmExhaustion as int)
	JsonUtil.SetFloatValue(strFile, "OrgasmExhaustionMag", UDmain.UD_OrgasmExhaustionMagnitude)
	JsonUtil.SetIntValue(strFile, "OrgasmExhaustionDuration", UDmain.UD_OrgasmExhaustionDuration)
	JsonUtil.SetIntValue(strFile, "AutoLoad", UDmain.UD_AutoLoad as int)
	JsonUtil.SetIntValue(strFile, "LogLevel", UDmain.LogLevel as int)

	;UDCDmain
	JsonUtil.SetIntValue(strFile, "Stamina_meter_Keycode", UDCDmain.Stamina_meter_Keycode)
	JsonUtil.SetIntValue(strFile, "StruggleKey_Keycode", UDCDmain.StruggleKey_Keycode)
	JsonUtil.SetIntValue(strFile, "Magicka_meter_Keycode", UDCDmain.Magicka_meter_Keycode)
	JsonUtil.SetIntValue(strFile, "SpecialKey_Keycode", UDCDmain.SpecialKey_Keycode)
	JsonUtil.SetIntValue(strFile, "PlayerMenu_KeyCode", UDCDmain.PlayerMenu_KeyCode)
	JsonUtil.SetIntValue(strFile, "ActionKey_Keycode", UDCDmain.ActionKey_Keycode)
	JsonUtil.SetIntValue(strFile, "NPCMenu_Keycode", UDCDmain.NPCMenu_Keycode)
	
	JsonUtil.SetIntValue(strFile, "UseDDdifficulty", UDCDmain.UD_UseDDdifficulty as Int)
	JsonUtil.SetIntValue(strFile, "UseWidget", UDCDmain.UD_UseWidget as Int)
	JsonUtil.SetIntValue(strFile, "GagPhonemModifier", UDCDmain.UD_GagPhonemModifier)
	JsonUtil.SetIntValue(strFile, "StruggleDifficulty", UDCDmain.UD_StruggleDifficulty)
	JsonUtil.SetFloatValue(strFile, "BaseDeviceSkillIncrease", UDCDmain.UD_BaseDeviceSkillIncrease)
	JsonUtil.SetFloatValue(strFile, "DeviceUpdateTime", UDCDmain.UD_UpdateTime)
	
	JsonUtil.SetIntValue(strFile, "AutoCrit", UDCDmain.UD_AutoCrit as Int)
	JsonUtil.SetIntValue(strFile, "AutoCritChance", UDCDmain.UD_AutoCritChance)
	JsonUtil.SetFloatValue(strFile, "VibrationMultiplier", UDCDmain.UD_VibrationMultiplier)
	JsonUtil.SetFloatValue(strFile, "ArousalMultiplier", UDCDmain.UD_ArousalMultiplier)
	JsonUtil.SetFloatValue(strFile, "OrgasmResistence", UDCDmain.UDOM.UD_OrgasmResistence)
	JsonUtil.SetIntValue(strFile, "OrgasmArousalThreshold", UDCDmain.UDOM.UD_OrgasmArousalThreshold)
	JsonUtil.SetIntValue(strFile, "LockpicksPerMinigame", UDCDmain.UD_LockpicksPerMinigame as Int)
	JsonUtil.SetIntValue(strFile, "UseOrgasmWidget", UDCDmain.UDOM.UD_UseOrgasmWidget as Int)
	JsonUtil.SetFloatValue(strFile, "OrgasmUpdateTime", UDCDmain.UDOM.UD_OrgasmUpdateTime)
	JsonUtil.SetIntValue(strFile, "OrgasmAnimation", UDCDmain.UDOM.UD_OrgasmAnimation)
	JsonUtil.SetIntValue(strFile, "HornyAnimation", UDCDmain.UDOM.UD_HornyAnimation as Int)
	JsonUtil.SetIntValue(strFile, "HornyAnimationDuration", UDCDmain.UDOM.UD_HornyAnimationDuration)
	JsonUtil.SetFloatValue(strFile, "CooldownMultiplier", UDCDmain.UD_CooldownMultiplier)
	
	JsonUtil.SetIntValue(strFile, "CritEffect", UDCDmain.UD_CritEffect)
	JsonUtil.SetIntValue(strFile, "HardcoreMode", UDCDmain.UD_HardcoreMode as Int)
	
	;ABADON
	JsonUtil.SetIntValue(strFile, "AbadonForceSet", AbadonQuest.final_finisher_set as Int)
	JsonUtil.SetIntValue(strFile, "AbadonForceSetPref", AbadonQuest.final_finisher_pref as Int)
	JsonUtil.SetIntValue(strFile, "AbadonUseAnalVariant", AbadonQuest.UseAnalVariant as Int)
	
	;PATCHER
	JsonUtil.SetIntValue(strFile, "MAOChanceMod", UDCDmain.UDPatcher.UD_MAOChanceMod)
	JsonUtil.SetIntValue(strFile, "MAOMod", UDCDmain.UDPatcher.UD_MAOMod)
	JsonUtil.SetIntValue(strFile, "MAHChanceMod", UDCDmain.UDPatcher.UD_MAHChanceMod)
	JsonUtil.SetIntValue(strFile, "MAHMod", UDCDmain.UDPatcher.UD_MAHMod)
	JsonUtil.SetIntValue(strFile, "EscapeModifier", UDCDmain.UDPatcher.UD_EscapeModifier)
	JsonUtil.SetIntValue(strFile, "MinLocks", UDCDmain.UDPatcher.UD_MinLocks)
	JsonUtil.SetIntValue(strFile, "MaxLocks", UDCDmain.UDPatcher.UD_MaxLocks)
	JsonUtil.SetFloatValue(strFile, "PatchMult", UDCDmain.UDPatcher.UD_PatchMult)
	JsonUtil.SetFloatValue(strFile, "PatchMult_HeavyBondage"	, UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage)
	JsonUtil.SetFloatValue(strFile, "PatchMult_Blindfold"		, UDCDmain.UDPatcher.UD_PatchMult_Blindfold)
	JsonUtil.SetFloatValue(strFile, "PatchMult_Gag"				, UDCDmain.UDPatcher.UD_PatchMult_Gag)
	JsonUtil.SetFloatValue(strFile, "PatchMult_Hood"			, UDCDmain.UDPatcher.UD_PatchMult_Hood)
	JsonUtil.SetFloatValue(strFile, "PatchMult_ChastityBelt"	, UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt)
	JsonUtil.SetFloatValue(strFile, "PatchMult_ChastityBra"		, UDCDmain.UDPatcher.UD_PatchMult_ChastityBra)
	JsonUtil.SetFloatValue(strFile, "PatchMult_Plug"			, UDCDmain.UDPatcher.UD_PatchMult_Plug)
	JsonUtil.SetFloatValue(strFile, "PatchMult_Piercing"		, UDCDmain.UDPatcher.UD_PatchMult_Piercing)
	JsonUtil.SetFloatValue(strFile, "PatchMult_Generic"			, UDCDmain.UDPatcher.UD_PatchMult_Generic)
	
	;OTHER
	JsonUtil.SetIntValue(strFile, "UseHoods", UDIM.UD_UseHoods as Int)
	JsonUtil.SetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)
	JsonUtil.SetIntValue(strFile, "SwimmingDifficulty", UDSS.UD_hardcore_swimming_difficulty)
	JsonUtil.SetIntValue(strFile, "WidgetPosX", widget.PositionX)
	JsonUtil.SetIntValue(strFile, "WidgetPosY", widget.PositionY)
	JsonUtil.SetIntValue(strFile, "RandomFiler", UDmain.UDRRM.UD_RandomDevice_GlobalFilter)
	
	
	JsonUtil.Save(strFile, true)
EndFunction

Function LoadFromJSON(string strFile)
	;UDmain
	UDmain.UD_hightPerformance = JsonUtil.GetIntValue(strFile, "hightPerformance", UDmain.UD_hightPerformance as Int)
	UDmain.AllowNPCSupport = JsonUtil.GetIntValue(strFile, "AllowNPCSupport", UDmain.AllowNPCSupport as Int)
	UDmain.lockMCM = JsonUtil.GetIntValue(strFile, "lockMCM", UDmain.lockMCM as Int)
	UDmain.DebugMod = JsonUtil.GetIntValue(strFile, "Debug mode", UDmain.DebugMod as Int)
	UDmain.UD_OrgasmExhaustion = JsonUtil.GetIntValue(strFile, "OrgasmExhastion", UDmain.UD_OrgasmExhaustion as int)
	UDmain.UD_OrgasmExhaustionMagnitude = JsonUtil.GetFloatValue(strFile, "OrgasmExhaustionMag", UDmain.UD_OrgasmExhaustionMagnitude)
	UDmain.UD_OrgasmExhaustionDuration = JsonUtil.GetIntValue(strFile, "OrgasmExhaustionDuration", UDmain.UD_OrgasmExhaustionDuration)
	UDmain.UD_AutoLoad = JsonUtil.GetIntValue(strFile, "AutoLoad", UDmain.UD_AutoLoad as int)
	UDmain.LogLevel = JsonUtil.GetIntValue(strFile, "LogLevel", UDmain.LogLevel as int)
	
	;UDCDmain
	UDCDmain.UnregisterGlobalKeys()
	UDCDmain.Stamina_meter_Keycode = JsonUtil.GetIntValue(strFile, "Stamina_meter_Keycode", UDCDmain.Stamina_meter_Keycode)
	UDCDmain.StruggleKey_Keycode = JsonUtil.GetIntValue(strFile, "StruggleKey_Keycode", UDCDmain.StruggleKey_Keycode)
	UDCDmain.Magicka_meter_Keycode = JsonUtil.GetIntValue(strFile, "Magicka_meter_Keycode", UDCDmain.Magicka_meter_Keycode)
	UDCDmain.SpecialKey_Keycode = JsonUtil.GetIntValue(strFile, "SpecialKey_Keycode", UDCDmain.SpecialKey_Keycode)
	UDCDmain.PlayerMenu_KeyCode = JsonUtil.GetIntValue(strFile, "PlayerMenu_KeyCode", UDCDmain.PlayerMenu_KeyCode)
	UDCDmain.ActionKey_Keycode = JsonUtil.GetIntValue(strFile, "ActionKey_Keycode", UDCDmain.ActionKey_Keycode)
	UDCDmain.NPCMenu_Keycode = JsonUtil.GetIntValue(strFile, "NPCMenu_Keycode", UDCDmain.NPCMenu_Keycode)
	UDCDmain.RegisterGlobalKeys()
	
	UDCDmain.UD_UseDDdifficulty = JsonUtil.GetIntValue(strFile, "UseDDdifficulty", UDCDmain.UD_UseDDdifficulty as Int)
	UDCDmain.UD_UseWidget = JsonUtil.GetIntValue(strFile, "UseWidget", UDCDmain.UD_UseWidget as Int)
	UDCDmain.UD_GagPhonemModifier = JsonUtil.GetIntValue(strFile, "GagPhonemModifier", UDCDmain.UD_GagPhonemModifier)
	UDCDmain.UD_StruggleDifficulty = JsonUtil.GetIntValue(strFile, "StruggleDifficulty", UDCDmain.UD_StruggleDifficulty)
	UDCDmain.UD_BaseDeviceSkillIncrease = JsonUtil.GetFloatValue(strFile, "BaseDeviceSkillIncrease", UDCDmain.UD_BaseDeviceSkillIncrease)
	UDCDmain.UD_UpdateTime = JsonUtil.GetFloatValue(strFile, "DeviceUpdateTime", UDCDmain.UD_UpdateTime)
	
	UDCDmain.UD_AutoCrit = JsonUtil.GetIntValue(strFile, "AutoCrit", UDCDmain.UD_AutoCrit as Int)
	if UDCDmain.UD_AutoCrit
		UD_autocrit_flag = OPTION_FLAG_NONE
	else
		UD_autocrit_flag = OPTION_FLAG_DISABLED
	endif
	UDCDmain.UD_AutoCritChance = JsonUtil.GetIntValue(strFile, "AutoCritChance", UDCDmain.UD_AutoCritChance)
	UDCDmain.UD_VibrationMultiplier = JsonUtil.GetFloatValue(strFile, "VibrationMultiplier", UDCDmain.UD_VibrationMultiplier)
	UDCDmain.UD_ArousalMultiplier = JsonUtil.GetFloatValue(strFile, "ArousalMultiplier", UDCDmain.UD_ArousalMultiplier)
	UDCDmain.UDOM.UD_OrgasmResistence = JsonUtil.GetFloatValue(strFile, "OrgasmResistence", UDCDmain.UDOM.UD_OrgasmResistence)
	UDCDmain.UDOM.UD_OrgasmArousalThreshold = JsonUtil.GetIntValue(strFile, "OrgasmArousalThreshold", UDCDmain.UDOM.UD_OrgasmArousalThreshold)
	UDCDmain.UD_LockpicksPerMinigame = JsonUtil.GetIntValue(strFile, "LockpicksPerMinigame", UDCDmain.UD_LockpicksPerMinigame)
	UDCDmain.UDOM.UD_UseOrgasmWidget = JsonUtil.GetIntValue(strFile, "UseOrgasmWidget", UDCDmain.UDOM.UD_UseOrgasmWidget as Int)
	UDCDmain.UDOM.UD_OrgasmUpdateTime = JsonUtil.GetFloatValue(strFile, "OrgasmUpdateTime", UDCDmain.UDOM.UD_OrgasmUpdateTime)
	UDCDmain.UDOM.UD_OrgasmAnimation = JsonUtil.GetIntValue(strFile, "OrgasmAnimation", UDCDmain.UDOM.UD_OrgasmAnimation)
	UDCDmain.UDOM.UD_HornyAnimation = JsonUtil.GetIntValue(strFile, "HornyAnimation", UDCDmain.UDOM.UD_HornyAnimation as Int)
	UDCDmain.UDOM.UD_HornyAnimationDuration = JsonUtil.GetIntValue(strFile, "HornyAnimationDuration", UDCDmain.UDOM.UD_HornyAnimationDuration)
	UDCDmain.UD_CooldownMultiplier = JsonUtil.GetFloatValue(strFile, "CooldownMultiplier", UDCDmain.UD_CooldownMultiplier)
	
	UDCDmain.UD_CritEffect = JsonUtil.GetIntValue(strFile, "CritEffect", UDCDmain.UD_CritEffect)
	UDCDmain.UD_HardcoreMode = JsonUtil.GetIntValue(strFile, "HardcoreMode", UDCDmain.UD_HardcoreMode as Int)
	
	;ABADON
	AbadonQuest.final_finisher_set = JsonUtil.GetIntValue(strFile, "AbadonForceSet", AbadonQuest.final_finisher_set as Int)
	AbadonQuest.final_finisher_pref = JsonUtil.GetIntValue(strFile, "AbadonForceSetPref", AbadonQuest.final_finisher_pref as Int)
	AbadonQuest.UseAnalVariant = JsonUtil.GetIntValue(strFile, "AbadonUseAnalVariant", AbadonQuest.UseAnalVariant as Int)
	
	;PATCHER
	UDCDmain.UDPatcher.UD_MAOChanceMod = JsonUtil.GetIntValue(strFile, "MAOChanceMod", UDCDmain.UDPatcher.UD_MAOChanceMod)
	UDCDmain.UDPatcher.UD_MAOMod = JsonUtil.GetIntValue(strFile, "MAOMod", UDCDmain.UDPatcher.UD_MAOMod)
	UDCDmain.UDPatcher.UD_MAHChanceMod = JsonUtil.GetIntValue(strFile, "MAHChanceMod", UDCDmain.UDPatcher.UD_MAHChanceMod)
	UDCDmain.UDPatcher.UD_MAHMod = JsonUtil.GetIntValue(strFile, "MAHMod", UDCDmain.UDPatcher.UD_MAHMod)
	UDCDmain.UDPatcher.UD_EscapeModifier = JsonUtil.GetIntValue(strFile, "EscapeModifier", UDCDmain.UDPatcher.UD_EscapeModifier)
	UDCDmain.UDPatcher.UD_MinLocks = JsonUtil.GetIntValue(strFile, "MinLocks", UDCDmain.UDPatcher.UD_MinLocks)
	UDCDmain.UDPatcher.UD_MaxLocks = JsonUtil.GetIntValue(strFile, "MaxLocks", UDCDmain.UDPatcher.UD_MaxLocks)
	UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage = JsonUtil.GetFloatValue(strFile, "PatchMult_HeavyBondage", UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage)
	UDCDmain.UDPatcher.UD_PatchMult_Blindfold = JsonUtil.GetFloatValue(strFile, "PatchMult_Blindfold", UDCDmain.UDPatcher.UD_PatchMult_Blindfold)
	UDCDmain.UDPatcher.UD_PatchMult_Gag = JsonUtil.GetFloatValue(strFile, "PatchMult_Gag", UDCDmain.UDPatcher.UD_PatchMult_Gag)
	UDCDmain.UDPatcher.UD_PatchMult_Hood = JsonUtil.GetFloatValue(strFile, "PatchMult_Hood", UDCDmain.UDPatcher.UD_PatchMult_Hood)
	UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt = JsonUtil.GetFloatValue(strFile, "PatchMult_ChastityBelt", UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt)
	UDCDmain.UDPatcher.UD_PatchMult_ChastityBra = JsonUtil.GetFloatValue(strFile, "PatchMult_ChastityBra", UDCDmain.UDPatcher.UD_PatchMult_ChastityBra)
	UDCDmain.UDPatcher.UD_PatchMult_Plug = JsonUtil.GetFloatValue(strFile, "PatchMult_Plug", UDCDmain.UDPatcher.UD_PatchMult_Plug)
	UDCDmain.UDPatcher.UD_PatchMult_Piercing = JsonUtil.GetFloatValue(strFile, "PatchMult_Piercing", UDCDmain.UDPatcher.UD_PatchMult_Piercing)
	UDCDmain.UDPatcher.UD_PatchMult_Generic = JsonUtil.GetFloatValue(strFile, "PatchMult_Generic", UDCDmain.UDPatcher.UD_PatchMult_Generic)
	
	;Other
	UDIM.UD_UseHoods = JsonUtil.GetIntValue(strFile, "UseHoods", UDIM.UD_UseHoods as Int)
	libs.UD_StartThirdpersonAnimation_Switch = JsonUtil.GetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)
	UDSS.UD_hardcore_swimming_difficulty = JsonUtil.GetIntValue(strFile, "SwimmingDifficulty", UDSS.UD_hardcore_swimming_difficulty)
	widget.PositionX = JsonUtil.GetIntValue(strFile, "WidgetPosX", widget.PositionX)
	widget.PositionY = JsonUtil.GetIntValue(strFile, "WidgetPosY", widget.PositionY)
	UDCDmain.widget2.PositionX = widget.PositionX
	UDCDmain.widget2.PositionY = widget.PositionY
	UDmain.UDRRM.UD_RandomDevice_GlobalFilter =  JsonUtil.GetIntValue(strFile, "RandomFiler", UDmain.UDRRM.UD_RandomDevice_GlobalFilter)
EndFunction

Function ResetToDefaults()
	;UDmain
	UDmain.UD_hightPerformance = true
	UDmain.AllowNPCSupport = false
	UDmain.lockMCM = false
	UDmain.DebugMod = false
	UDmain.UD_OrgasmExhaustion = true
	UDmain.UD_OrgasmExhaustionMagnitude = 20.0
	UDmain.UD_OrgasmExhaustionDuration = 30
	UDmain.UD_AutoLoad = false
	UDmain.LogLevel = 0
	
	;UDCDmain
	UDCDmain.UnregisterGlobalKeys()
	if !Game.UsingGamepad()
		UDCDmain.Stamina_meter_Keycode = 32
		UDCDmain.StruggleKey_Keycode = 52
		UDCDmain.Magicka_meter_Keycode = 30
		UDCDmain.SpecialKey_Keycode = 31
		UDCDmain.PlayerMenu_KeyCode = 40
		UDCDmain.ActionKey_Keycode = 18
		UDCDmain.NPCMenu_Keycode = 39
	else
		UDCDmain.Stamina_meter_Keycode = 275
		UDCDmain.StruggleKey_Keycode = 275
		UDCDmain.Magicka_meter_Keycode = 274
		UDCDmain.SpecialKey_Keycode = 276
		UDCDmain.PlayerMenu_KeyCode = 268
		UDCDmain.NPCMenu_Keycode = 269
		UDCDmain.ActionKey_Keycode = 279
	endif
	UDCDmain.RegisterGlobalKeys()
	
	UDCDmain.UD_UseDDdifficulty = true
	UDCDmain.UD_UseWidget = true
	UDCDmain.UD_GagPhonemModifier = 50
	UDCDmain.UD_StruggleDifficulty = 1
	UDCDmain.UD_BaseDeviceSkillIncrease = 35.0
	UDCDmain.UD_UpdateTime = 5.0
	
	UDCDmain.UD_AutoCrit = false
	if UDCDmain.UD_AutoCrit
		UD_autocrit_flag = OPTION_FLAG_NONE
	else
		UD_autocrit_flag = OPTION_FLAG_DISABLED
	endif
	UDCDmain.UD_AutoCritChance = 80
	UDCDmain.UD_VibrationMultiplier = 0.1
	UDCDmain.UD_ArousalMultiplier = 0.025
	UDCDmain.UDOM.UD_OrgasmResistence = 3.5
	UDCDmain.UDOM.UD_OrgasmArousalThreshold = 95
	UDCDmain.UD_LockpicksPerMinigame = 2
	UDCDmain.UDOM.UD_UseOrgasmWidget = true
	UDCDmain.UDOM.UD_OrgasmUpdateTime = 0.5
	UDCDmain.UDOM.UD_OrgasmAnimation = 1
	UDCDmain.UDOM.UD_HornyAnimation = true
	UDCDmain.UDOM.UD_HornyAnimationDuration = 5
	UDCDmain.UD_CooldownMultiplier = 1.0
	UDCDmain.UD_CritEffect = 2
	UDCDmain.UD_HardcoreMode = false
	
	;ABADON
	AbadonQuest.final_finisher_set = true
	AbadonQuest.final_finisher_pref = 0
	AbadonQuest.UseAnalVariant = false
	
	;PATCHER
	UDCDmain.UDPatcher.UD_MAOChanceMod = 100
	UDCDmain.UDPatcher.UD_MAOMod = 100
	UDCDmain.UDPatcher.UD_MAHChanceMod = 100
	UDCDmain.UDPatcher.UD_MAHMod = 100
	UDCDmain.UDPatcher.UD_EscapeModifier = 10
	UDCDmain.UDPatcher.UD_MinLocks = 1
	UDCDmain.UDPatcher.UD_MaxLocks = 6
	UDCDmain.UDPatcher.UD_PatchMult 				= 1.0
	UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage 	= 1.0
	UDCDmain.UDPatcher.UD_PatchMult_Blindfold 		= 1.0
	UDCDmain.UDPatcher.UD_PatchMult_Gag 			= 1.0
	UDCDmain.UDPatcher.UD_PatchMult_Hood 			= 1.0	
	UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt 	= 1.0
	UDCDmain.UDPatcher.UD_PatchMult_ChastityBra  	= 1.0
	UDCDmain.UDPatcher.UD_PatchMult_Plug         	= 1.0
	UDCDmain.UDPatcher.UD_PatchMult_Piercing     	= 1.0
	UDCDmain.UDPatcher.UD_PatchMult_Generic      	= 1.0
	
	;Other
	UDIM.UD_UseHoods = true
	libs.UD_StartThirdpersonAnimation_Switch = true
	UDSS.UD_hardcore_swimming_difficulty = 1
	widget.PositionX = 2
	widget.PositionY = 0
	UDCDmain.widget2.PositionX = widget.PositionX
	UDCDmain.widget2.PositionY = widget.PositionY
	UDmain.UDRRM.UD_RandomDevice_GlobalFilter = 0x0000FFFF ;16b
EndFunction

Function SetAutoLoad(bool bValue)
	JsonUtil.SetIntValue(FILE, "AutoLoad", bValue as Int)
	JsonUtil.Save(FILE, true)
EndFunction

bool Function GetAutoLoad()
	UDmain.UD_AutoLoad = JsonUtil.GetIntValue(FILE, "AutoLoad", UDmain.UD_AutoLoad as int)
	return UDmain.UD_AutoLoad
EndFunction