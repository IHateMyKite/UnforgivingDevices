Scriptname UD_MCM_script extends SKI_ConfigBase

import UnforgivingDevicesMain

;UDAbadonPlug_Event property abadon auto
UnforgivingDevicesMain              Property UDmain auto
UDCustomDeviceMain                  Property UDCDmain auto
UD_SwimmingScript                   Property UDSS auto
UDItemManager                       Property UDIM auto
UD_AbadonQuest_script               Property AbadonQuest auto
UD_CustomDevices_NPCSlotsManager    Property UDCD_NPCM auto
zadlibs_UDPatch                     Property libs auto hidden

UD_OrgasmManager Property UDOM
    UD_OrgasmManager Function Get()
        return UDmain.UDOM
    EndFunction
EndProperty

UD_UserInputScript Property UDUI
    UD_UserInputScript Function Get()
        return UDmain.UDUI
    EndFunction
EndProperty

UD_NPCInteligence Property UDAI
    UD_NPCInteligence Function Get()
        return UDmain.UDAI
    EndFunction
EndProperty

int max_difficulty_S
int overaldifficulty_S ;0-3 where 3 is same as in MDS
int eventchancemod_S

int little_finisher_chance_S 
int min_orgasm_little_finisher_S 
int max_orgasm_little_finisher_S 

int dmg_heal_T
int dmg_magica_T
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
;int UD_OrgasmExhaustionMagnitude_S
;int UD_OrgasmExhaustionDuration_S

int UD_ActionKey_K
int UD_StruggleKey_K 

int UD_hightPerformance_T

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

Int Function FlagNegate(int aiFlag)
    if aiFlag == OPTION_FLAG_DISABLED 
        return OPTION_FLAG_NONE
    else
        return OPTION_FLAG_DISABLED
    endif
EndFunction

int Function FlagSwitch(bool bVal)
    if bVal == true 
        return OPTION_FLAG_NONE
    else
        return OPTION_FLAG_DISABLED
    endif
EndFunction

;check if button can be used for UD
Bool Function CheckButton(Int aiKeyCode)
    Bool loc_res = True
    
    loc_res = loc_res && (aiKeyCode != 264) ;is not mouse wheel up
    loc_res = loc_res && (aiKeyCode != 265) ;is not mouse wheel down
    
    return loc_res
EndFunction

String Property UD_NPCsPageName = "NPCs Config" auto

Function LoadConfigPages()
    pages = new String[12]
    pages[0] = "General"
    pages[1] = "Device filter"
    pages[2] = "Custom devices"
    pages[3] = "Custom orgasm"
    pages[4] = UD_NPCsPageName
    pages[5] = "Patcher"
    pages[6] = "DD Patch"
    pages[7] = "Abadon Plug"
    pages[8] = "UI/Widgets"
    pages[9] = "Animations"
    pages[10] = "Debug panel"
    pages[11] = "Other"
EndFunction

bool Property Ready = False Auto
Event OnConfigInit()
    if UDmain.TraceAllowed()    
        UDmain.Log("MCM init started")
    endif
    
    Update()
    
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
    
    actorIndex = 10
    UDmain.Info("MCM Ready")
    Ready = True
EndEvent

Function Update()
    LoadConfigPages()
    registered_devices_T = new Int[25]
    NPCSlots_T = Utility.CreateIntArray(UDCD_NPCM.GetNumAliases())
    
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

    UD_IconsAnchorList = new String[3]
    UD_IconsAnchorList[0] = "LEFT"
    UD_IconsAnchorList[1] = "CENTER"
    UD_IconsAnchorList[2] = "RIGHT"
    
    UD_TextAnchorList = new String[4]
    UD_TextAnchorList[0] = "BOTTOM"
    UD_TextAnchorList[1] = "BELOW CENTER"
    UD_TextAnchorList[2] = "TOP"
    UD_TextAnchorList[3] = "CENTER"
    
    UD_IconVariant_EffExhaustionList = new String[3]
    UD_IconVariant_EffExhaustionList[0] = "Variant 1"
    UD_IconVariant_EffExhaustionList[1] = "Variant 2"
    UD_IconVariant_EffExhaustionList[2] = "Variant 3"
    UD_IconVariant_EffOrgasmList = new String[3]
    UD_IconVariant_EffOrgasmList[0] = "Variant 1"
    UD_IconVariant_EffOrgasmList[1] = "Variant 2"
    UD_IconVariant_EffOrgasmList[2] = "Variant 3"

    libs = UDCDmain.libs as zadlibs_UDPatch
EndFunction

Event onConfigClose()
EndEvent

Event onConfigOpen()
    device_flag = OPTION_FLAG_NONE
    fix_flag = OPTION_FLAG_NONE
EndEvent

String _lastPage
Event OnPageReset(string page)
    if !UDmain.IsEnabled()
        AddHeaderOption("Unforgiving devices is updating...")
        return
    endif
    
    _lastPage = page
    if (page == "General")
        resetGeneralPage()
    elseif (page == "Device filter")
        resetFilterPage()
    elseif (page == "Abadon Plug")
        resetAbadonPage()
    elseif (page == "Custom Devices")
        resetCustomBondagePage()
    elseif (page == UD_NPCsPageName)
        ResetNPCsPage()
    elseif (page == "Custom orgasm")
        resetCustomOrgasmPage()
    elseif (page == "Patcher")
        resetPatcherPage()
    elseif (page == "DD patch")
        resetDDPatchPage()
    elseif (page == "UI/Widgets")
        resetUIWidgetPage()
    elseif (page == "Animations")
        resetAnimationsPage()
    elseif (page == "Debug panel")
        resetDebugPage()
    elseif (page == "Other")
        resetOtherPage()
    endif
EndEvent

int UseAnalVariant_T
int Property AbadonQuestFlag auto
Function resetAbadonPage()
    UpdateLockMenuFlag()
    
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("Abadon Plug Settings")
    addEmptyOption()

    preset_M = AddMenuOption("Preset:", presetList[preset])
    UseAnalVariant_T = addToggleOption("Anal variant:", AbadonQuest.UseAnalVariant,AbadonQuestFlag)
    
    max_difficulty_S = AddSliderOption("Max strength:", AbadonQuest.max_difficulty, "{0}",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    final_finisher_set_T = addToggleOption("Equip set:", AbadonQuest.final_finisher_set,UD_LockMenu_flag)
    
    difficulty_M = AddMenuOption("Difficulty:", difficultyList[AbadonQuest.overaldifficulty],FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    if AbadonQuest.final_finisher_pref >= AbadonQuest.UD_AbadonSuitNumber
        AbadonQuest.final_finisher_pref = 0 ;turn to random if the previous suit is no longer valid
    endif
    final_finisher_pref_M = AddMenuOption("Start set:", AbadonQuest.UD_AbadonSuitNames[AbadonQuest.final_finisher_pref],abadon_flag_2)
    
    hardcore_T = addToggleOption("Hardcore:", AbadonQuest.hardcore,FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    eventchancemod_S = AddSliderOption("Event modifier:", AbadonQuest.eventchancemod, "{0} %",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    
    dmg_heal_T = addToggleOption("Damage health",AbadonQuest.dmg_heal,FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    addEmptyOption()
    
    dmg_stamina_T = addToggleOption("Damage stamina",AbadonQuest.dmg_stamina,FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    addEmptyOption()
    
    dmg_magica_T = addToggleOption("Damage magica",AbadonQuest.dmg_magica,FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    addEmptyOption()
    
    little_finisher_chance_S = AddSliderOption("Chance of smaller finisher:", AbadonQuest.little_finisher_chance, "{1} %",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    little_finisher_cooldown_S = AddSliderOption("Smaller finisher cooldown:", AbadonQuest.little_finisher_cooldown, "{1} hours",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    
    min_orgasm_little_finisher_S = AddSliderOption("Min. orgasms of smaller finisher:", AbadonQuest.min_orgasm_little_finisher, "{1}",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    max_orgasm_little_finisher_S = AddSliderOption("Max. orgasms of smaller finisher:", AbadonQuest.max_orgasm_little_finisher, "{1}",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
endfunction

int UD_LoggingLevel_S
int UD_NPCSupport_T
int UD_PlayerMenu_K
int UD_NPCMenu_K
int UD_HearingRange_S
int UD_WarningAllowed_T
Int UD_PrintLevel_S
Int UD_LockDebugMCM_T
Int UD_GamepadKey_K
int UD_EasyGamepadMode_T
Event resetGeneralPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)

    AddHeaderOption("Key mapping")
    addEmptyOption()
    
    UD_StruggleKey_K        = AddKeyMapOption("Action key: ", UDCDmain.StruggleKey_Keycode,FlagSwitch(!UDUI.UD_EasyGamepadMode || !Game.UsingGamepad()))
    addEmptyOption()
    
    UD_PlayerMenu_K         = AddKeyMapOption("Player menu key:", UDCDmain.PlayerMenu_KeyCode,FlagSwitch(!UDUI.UD_EasyGamepadMode || !Game.UsingGamepad()))
    UD_NPCMenu_K            = AddKeyMapOption("NPC menu key:", UDCDmain.NPCMenu_Keycode,FlagSwitch(!UDUI.UD_EasyGamepadMode || !Game.UsingGamepad()))
    
    UD_EasyGamepadMode_T    = addToggleOption("Easy Gamepad Mode",UDUI.UD_EasyGamepadMode,FlagSwitch(Game.UsingGamepad() || UDUI.UD_EasyGamepadMode))
    UD_GamepadKey_K         = AddKeyMapOption("Gamepad key:", UDmain.UDUI.UD_GamepadKey,FlagSwitch(UDUI.UD_EasyGamepadMode))
    
    AddHeaderOption("General settings")
    addEmptyOption()
    
    UD_hightPerformance_T   = addToggleOption("High performance mod",UDmain.UD_hightPerformance)
    addEmptyOption()
    
    UD_HearingRange_S       = addSliderOption("Message range:",UDmain.UD_HearingRange,"{0}")
    UD_PrintLevel_S         = addSliderOption("Message level",UDmain.UD_PrintLevel, "{0}")

    lockmenu_T              = addToggleOption("Lock menus",UDmain.lockMCM,UD_LockMenu_flag)
    UD_LockDebugMCM_T       = addToggleOption("Lock Debug",UDmain.UD_LockDebugMCM,FlagSwitchAnd(UD_LockMenu_flag,FlagSwitch(!UDmain.UD_LockDebugMCM)))

    AddHeaderOption("Debug")
    addEmptyOption()
    UD_debugmod_T           = addToggleOption("Debug mod",UDmain.DebugMod)
    UD_LoggingLevel_S       = addSliderOption("Logging level",UDmain.LogLevel, "{0}")
    
    UD_WarningAllowed_T     = addToggleOption("Warnings allowed",UDmain.UD_WarningAllowed)
    addEmptyOption()
EndEvent

int UD_RandomFilter_T ; leaving this just in case
int UD_UseArmCuffs_T
int UD_UseBelts_T
int UD_UseBlindfolds_T
int UD_UseBoots_T
int UD_UseBras_T
int UD_UseCollars_T
int UD_UseCorsets_T
int UD_UseGags_T
int UD_UseGloves_T
int UD_UseHarnesses_T
int UD_UseHeavyBondage_T
int UD_UseHoods_T
int UD_UseLegCuffs_T
int UD_UsePiercingsNipple_T
int UD_UsePiercingsVaginal_T
int UD_UsePlugsAnal_T
int UD_UsePlugsVaginal_T
int UD_UseSuits_T
Event resetFilterPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)

    AddHeaderOption("Device filter")
    addEmptyOption()

    UD_UseArmCuffs_T        = AddToggleOption("Arm cuffs", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00001000), UD_LockMenu_flag)
    UD_UseLegCuffs_T        = AddToggleOption("Leg cuffs", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00002000), UD_LockMenu_flag)
    UD_UseBras_T            = AddToggleOption("Chastity Bras", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00010000), UD_LockMenu_flag)
    UD_UseBelts_T           = AddToggleOption("Chastity belts", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00020000), UD_LockMenu_flag)
    UD_UseBlindfolds_T      = AddToggleOption("Blindfolds", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000400), UD_LockMenu_flag)
    UD_UseBoots_T           = AddToggleOption("Boots", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000800), UD_LockMenu_flag)
    UD_UseCollars_T         = AddToggleOption("Collars", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000100), UD_LockMenu_flag)
    UD_UseCorsets_T         = AddToggleOption("Corsets", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000040), UD_LockMenu_flag)
    UD_UseGags_T            = AddToggleOption("Gags", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000200), UD_LockMenu_flag)
    UD_UseGloves_T          = AddToggleOption("Gloves", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00008000), UD_LockMenu_flag)
    UD_UseHarnesses_T       = AddToggleOption("Harnesses", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000020), UD_LockMenu_flag)
    UD_UseHoods_T           = AddToggleOption("Use hoods",UDIM.UD_useHoods,UD_LockMenu_flag) ; leave it as it is, no point in changing, unless we get rid of this variable
    UD_UsePiercingsNipple_T = AddToggleOption("Piercings on nipples", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000002), UD_LockMenu_flag)
    UD_UsePiercingsVaginal_T= AddToggleOption("Piercings clitoral", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000001), UD_LockMenu_flag)
    UD_UsePlugsAnal_T       = AddToggleOption("Plugs anal", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000008), UD_LockMenu_flag)
    UD_UsePlugsVaginal_T    = AddToggleOption("Plugs vaginal", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000004), UD_LockMenu_flag)
    UD_UseHeavyBondage_T    = AddToggleOption("Heavy Bondage", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000010), UD_LockMenu_flag)
    UD_UseSuits_T           = AddToggleOption("Suits", Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00004000), UD_LockMenu_flag)
    addEmptyOption()
    addEmptyOption()
    UD_RandomFilter_T       = AddInputOption("Random filter", Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0xFFFFFFFF), UD_LockMenu_flag) ; leaving this just in case
    addEmptyOption()

EndEvent


int UD_Swimming_flag
int UD_autocrit_flag
int UD_CHB_Stamina_meter_Keycode_K
int UD_CHB_Magicka_meter_Keycode_K
int UDCD_SpecialKey_Keycode_K
int UD_UseDDdifficulty_T
int UD_AutoCrit_T
int UD_AutoCritChance_S
int UD_StruggleDifficulty_M
int UD_hardcore_swimming_T
int UD_hardcore_swimming_difficulty_M
int UD_UpdateTime_S
int UD_GagPhonemModifier_S
int UD_PatchMult_S
int UD_LockpickMinigameNum_S
int UD_BaseDeviceSkillIncrease_S
Int UD_SkillEfficiency_S
int UD_CooldownMultiplier_S
string[] criteffectList
int UD_CritEffect_M
int UD_HardcoreMode_T
int UD_AllowArmTie_T
int UD_AllowLegTie_T
Int UD_MinigameHelpCd_S
Int UD_MinigameHelpCD_PerLVL_S
Int UD_MinigameHelpXPBase_S
Int UD_DeviceLvlHealth_S
Int UD_DeviceLvlLockpick_S
Int UD_DeviceLvlLocks_S
Int UD_PreventMasterLock_T
Int UD_MandatoryCrit_T
Int UD_CritDurationAdjust_S

Int UD_KeyDurability_S
Int UD_HardcoreAccess_T

Event resetCustomBondagePage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    ;KEY MAPPING
    AddHeaderOption("Key mapping")
    addEmptyOption()
    UD_CHB_Stamina_meter_Keycode_K = AddKeyMapOption("Stamina key", UDCDmain.Stamina_meter_Keycode)
    UD_CHB_Magicka_meter_Keycode_K = AddKeyMapOption("Magicka key", UDCDmain.Magicka_meter_Keycode)

    UDCD_SpecialKey_Keycode_K   = AddKeyMapOption("Special key", UDCDmain.SpecialKey_Keycode)
    UD_ActionKey_K              = AddKeyMapOption("Stop key", UDCDmain.ActionKey_Keycode)
    
    ;MAIN SETTING
    AddHeaderOption("Main setting")
    addEmptyOption()
    UD_UpdateTime_S = addSliderOption("Update time",UDCDmain.UD_UpdateTime, "{0} s")
    UD_CooldownMultiplier_S = addSliderOption("Cooldown multiplier",Round(UDCDmain.UD_CooldownMultiplier*100), "{0} %",UD_LockMenu_flag)
    
    UD_PreventMasterLock_T = addToggleOption("Prevent master locks",UDCDmain.UD_PreventMasterLock,UD_LockMenu_flag)
    UD_LockpickMinigameNum_S = addSliderOption("Lockpicks per minigame",UDCDmain.UD_LockpicksPerMinigame, "{0}",UD_LockMenu_flag)
    
    UD_KeyDurability_S = addSliderOption("Key Durability",UDCDmain.UD_KeyDurability, "{0}",UD_LockMenu_flag)
    UD_HardcoreAccess_T = addToggleOption("Hardcore Access", UDCDmain.UD_HardcoreAccess,UD_LockMenu_flag)
    
    UD_AllowArmTie_T = addToggleOption("Arm tie", UDCDmain.UD_AllowArmTie,UD_LockMenu_flag)
    UD_AllowLegTie_T = addToggleOption("Leg tie", UDCDmain.UD_AllowLegTie,UD_LockMenu_flag)
    
    addEmptyOption()
    addEmptyOption()
    
    ;SKILL
    AddHeaderOption("Skill setting")
    addEmptyOption()
    
    UD_BaseDeviceSkillIncrease_S = addSliderOption("Skill advance",UDCDmain.UD_BaseDeviceSkillIncrease, "{0}",UD_LockMenu_flag)
    UD_SkillEfficiency_S = addSliderOption("Skill efficiency",UDCDmain.UD_SkillEfficiency, "{0} %",UD_LockMenu_flag)
    
    ;HELPER SETTING
    AddHeaderOption("Helping setting")
    addEmptyOption()
    UD_MinigameHelpCd_S = addSliderOption("Base cooldown",UDCDmain.UD_MinigameHelpCd, "{0} min",UD_LockMenu_flag)
    UD_MinigameHelpXPBase_S = addSliderOption("Base XP gain",UDCDmain.UD_MinigameHelpXPBase, "{0} XP",UD_LockMenu_flag)
    
    UD_MinigameHelpCD_PerLVL_S = addSliderOption("LVL Cooldown Modifier",UDCDmain.UD_MinigameHelpCD_PerLVL, "{0} %",UD_LockMenu_flag)
    addEmptyOption()
    
    ;HARDCORE SWIMMING
    AddHeaderOption("Unforgiving Swimming")
    AddEmptyOption()
    UD_hardcore_swimming_T = addToggleOption("Unforgiving swimming", UDSS.UD_hardcore_swimming,UD_LockMenu_flag)    
    UD_hardcore_swimming_difficulty_M = AddMenuOption("Swimming difficulty", difficultyList[UDSS.UD_hardcore_swimming_difficulty],FlagSwitchOr(UD_Swimming_flag,UD_LockMenu_flag))
    
    ;CRITS
    AddHeaderOption("Device Crits")
    AddEmptyOption()
    UD_CritEffect_M     = AddMenuOption("Crit effect", criteffectList[UDCDmain.UD_CritEffect],FlagNegate(UD_autocrit_flag))
    UD_MandatoryCrit_T  = addToggleOption("Mandatory crit", UDCDmain.UD_MandatoryCrit,FlagSwitchOr(FlagNegate(UD_autocrit_flag),UD_LockMenu_flag))
    
    UD_AutoCrit_T       = addToggleOption("Auto crit", UDCDmain.UD_AutoCrit,UD_LockMenu_flag)
    UD_AutoCritChance_S = addSliderOption("Auto crit chance",UDCDmain.UD_AutoCritChance, "{0} %",FlagSwitchOr(UD_autocrit_flag,UD_LockMenu_flag))
    
    UD_CritDurationAdjust_S = addSliderOption("Crit duration adjust.",UDCDmain.UD_CritDurationAdjust, "{2} s",FlagSwitchOr(FlagNegate(UD_autocrit_flag),UD_LockMenu_flag))
    AddEmptyOption()
    
    ;DEVICE LEVEL scaling
    AddHeaderOption("Level scaling")
    AddEmptyOption()
    
    UD_DeviceLvlHealth_S    = addSliderOption("Health increase",UDCDmain.UD_DeviceLvlHealth*100, "{1} %",UD_LockMenu_flag)
    UD_DeviceLvlLockpick_S  = addSliderOption("Lockpick increase",UDCDmain.UD_DeviceLvlLockpick, "{1}",UD_LockMenu_flag)
    
    UD_DeviceLvlLocks_S     = addSliderOption("Lock increase",UDCDmain.UD_DeviceLvlLocks, "{0} LVLs");,UD_LockMenu_flag)
    AddEmptyOption()
    
    ;DIFFICULTY
    AddHeaderOption("Difficulty")
    AddEmptyOption()
    UD_HardcoreMode_T = addToggleOption("Hardcore mode:", UDCDmain.UD_HardcoreMode)
    AddTextOption("Struggle difficulty:", Math.floor((2 - UDCDmain.getStruggleDifficultyModifier())*100 +0.5) + " %",OPTION_FLAG_DISABLED)
    
    UD_StruggleDifficulty_M = AddMenuOption("Escape difficulty:", difficultyList[UDCDmain.UD_StruggleDifficulty],UD_LockMenu_flag)
    AddTextOption("Mend difficulty:", Math.floor(UDCDmain.getMendDifficultyModifier()*100 + 0.5) + " %",OPTION_FLAG_DISABLED)
     
    UD_UseDDdifficulty_T = addToggleOption("Use DD difficulty:", UDCDmain.UD_UseDDdifficulty,UD_LockMenu_flag)
    AddTextOption("Key modifier:", Math.floor((UDCDmain.CalculateKeyModifier())*100 + 0.5) + " %",OPTION_FLAG_DISABLED)
EndEvent

int UD_OrgasmUpdateTime_S
int UD_OrgasmAnimation_M
int UD_UseOrgasmWidget_T
int UD_HornyAnimation_T
int UD_Horny_f
int UD_HornyAnimationDuration_S
int UD_OrgasmResistence_S
int UD_VibrationMultiplier_S
int UD_ArousalMultiplier_S
int UD_OrgasmArousalReduce_S
int UD_OrgasmArousalReduceDuration_S

Event resetCustomOrgasmPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("General")
    addEmptyOption()
        
    UD_OrgasmUpdateTime_S   = addSliderOption("Update time: ",UDOM.UD_OrgasmUpdateTime, "{1} s")
    UD_OrgasmExhaustion_T   = addToggleOption("Orgasm exhaustion",UDmain.UD_OrgasmExhaustion,UD_LockMenu_flag)
    
    UD_UseOrgasmWidget_T    = addToggleOption("Use widget:", UDOM.UD_UseOrgasmWidget)
    UD_OrgasmResistence_S   = addSliderOption("Orgasm resistence: ",UDOM.UD_OrgasmResistence, "{1} Op/s",UD_LockMenu_flag)

    UD_HornyAnimation_T     = addToggleOption("Horny animation:", UDOM.UD_HornyAnimation)
    UD_HornyAnimationDuration_S     = addSliderOption("Horny duration: ",UDOM.UD_HornyAnimationDuration, "{0} s",UD_Horny_f)
    
    AddHeaderOption("Post-Orgasm")
    addEmptyOption()
    UD_OrgasmArousalReduce_S    = addSliderOption("Post-Orgasm arousal: ",UDOM.UD_OrgasmArousalReduce, "{0} /s")
    UD_OrgasmArousalReduceDuration_S = addSliderOption("Post-Orgasm arousal duration: ",UDOM.UD_OrgasmArousalReduceDuration, "{0} s")
    
    AddHeaderOption("Vib. setting")
    addEmptyOption()    
    UD_VibrationMultiplier_S    = addSliderOption("Vib. multiplier: ",UDCDmain.UD_VibrationMultiplier, "{3}",UD_LockMenu_flag)
    UD_ArousalMultiplier_S      = addSliderOption("Arousal multiplier: ",UDCDmain.UD_ArousalMultiplier, "{3}",UD_LockMenu_flag)
EndEvent

Int UD_AIEnable_T
Int UD_AIUpdateTime_S
Int UD_AICooldown_S
Event resetNPCsPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("NPCs Inteligence")
    addEmptyOption()
    
    UD_AIEnable_T = addToggleOption("Enabled", UDAI.Enabled)
    addEmptyOption()
    
    UD_AIUpdateTime_S   = addSliderOption("Update time: ",UDAI.UD_UpdateTime, "{0} s",      FlagSwitch(UDAI.Enabled))
    UD_AICooldown_S     = addSliderOption("Base Cooldown",UDAI.UD_AICooldown, "{0} min",    FlagSwitchOr(UD_LockMenu_flag,FlagSwitch(UDAI.Enabled)))
    
    AddHeaderOption("Autoscan")
    addEmptyOption()
    
    UD_NPCSupport_T         = addToggleOption("NPC Auto Scan",UDmain.AllowNPCSupport)
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
int UD_MinResistMult_S
int UD_MaxResistMult_S

Event resetPatcherPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("Main values")
    addEmptyOption()
        
    UD_PatchMult_S = addSliderOption("Global Diffuculty Modifier",Round(UDCDmain.UDPatcher.UD_PatchMult * 100), "{0} %",UD_LockMenu_flag)
    UD_EscapeModifier_S = addSliderOption("Escape modifier",UDCDmain.UDPatcher.UD_EscapeModifier, "{0}",UD_LockMenu_flag)
    
    UD_MinLocks_S = addSliderOption("Min. Lock Shields",UDCDmain.UDPatcher.UD_MinLocks, "{0}",UD_LockMenu_flag)
    UD_MaxLocks_S = addSliderOption("Max. Lock Shields",UDCDmain.UDPatcher.UD_MaxLocks, "{0}",UD_LockMenu_flag)
    
    UD_MinResistMult_S = addSliderOption("Min. Resist Sum",Round(UDCDmain.UDPatcher.UD_MinResistMult*100), "{0} %",UD_LockMenu_flag)
    UD_MaxResistMult_S = addSliderOption("Max. Resist Sum",Round(UDCDmain.UDPatcher.UD_MaxResistMult*100), "{0} %",UD_LockMenu_flag)
    
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
    
    UD_PatchMult_HeavyBondage_S = addSliderOption("Heavy bondage",Round(UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage * 100), "{0} %",UD_LockMenu_flag)
    UD_PatchMult_Blindfold_S = addSliderOption("Blindfold",Round(UDCDmain.UDPatcher.UD_PatchMult_Blindfold * 100), "{0} %",UD_LockMenu_flag)
    
    UD_PatchMult_Gag_S = addSliderOption("Gag",Round(UDCDmain.UDPatcher.UD_PatchMult_Gag * 100), "{0} %",UD_LockMenu_flag)
    UD_PatchMult_Hood_S = addSliderOption("Hood",Round(UDCDmain.UDPatcher.UD_PatchMult_Hood * 100), "{0} %",UD_LockMenu_flag)
    
    UD_PatchMult_ChastityBelt_S = addSliderOption("Chastity belt",Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt * 100), "{0} %",UD_LockMenu_flag)
    UD_PatchMult_ChastityBra_S = addSliderOption("Chastity bra",Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBra * 100), "{0} %",UD_LockMenu_flag)
    
    UD_PatchMult_Plug_S = addSliderOption("Plug",Round(UDCDmain.UDPatcher.UD_PatchMult_Plug * 100), "{0} %",UD_LockMenu_flag)
    UD_PatchMult_Piercing_S = addSliderOption("Piercing",Round(UDCDmain.UDPatcher.UD_PatchMult_Piercing * 100), "{0} %",UD_LockMenu_flag)
    
    UD_PatchMult_Generic_S = addSliderOption("Generic",Round(UDCDmain.UDPatcher.UD_PatchMult_Generic * 100), "{0} %",UD_LockMenu_flag)
    addEmptyOption()
EndEvent

zadBoundCombatScript_UDPatch Property AAScript
    zadBoundCombatScript_UDPatch Function get()
        return libs.BoundCombat as zadBoundCombatScript_UDPatch
    EndFunction
EndProperty

int UD_StartThirdpersonAnimation_Switch_T
int UD_DAR_T
Int UD_OutfitRemove_T
Int UD_CheckAllKw_T
Int UD_AllowMenBondage_T

Event resetDDPatchPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("General")
    addEmptyOption()
    
    UD_GagPhonemModifier_S = addSliderOption("Gag phonem mod",UDCDmain.UD_GagPhonemModifier, "{0}",FlagSwitch(!UDmain.ZadExpressionSystemInstalled))
    UD_CheckAllKw_T = addToggleOption("All Keyword check",UDmain.UD_CheckAllKw)
    
    AddHeaderOption("Animation setting")
    addEmptyOption()
    
    UD_StartThirdpersonAnimation_Switch_T = addToggleOption("Animation patch", libs.UD_StartThirdPersonAnimation_Switch)
    UD_OrgasmAnimation_M = AddMenuOption("Animation list", orgasmAnimation[UDOM.UD_OrgasmAnimation]) 
    
    UD_DAR_T = addToggleOption("DAR Patch", AAScript.UD_DAR,FlagSwitch(AAScript))
    addEmptyOption()
    
    AddHeaderOption("Device setting")
    addEmptyOption()
    UD_OutfitRemove_T = addToggleOption("Outfit removal", UDCDmain.UD_OutfitRemove)
    UD_AllowMenBondage_T = addToggleOption("Allow DD devices on men", UDmain.AllowMenBondage,FlagSwitch(UDmain.ForHimInstalled))
EndEvent

UD_WidgetControl Property UDWC Hidden
    UD_WidgetControl Function Get()
        return UDMain.UDWC
    EndFunction
EndProperty

int UD_UseIWantWidget_T
Int UD_AutoAdjustWidget_T
; device widgets
int UD_UseWidget_T
int UD_WidgetPosX_M
int UD_WidgetPosY_M
string[] widgetXList
string[] widgetYList
; overlay settings
Int UD_TextFontSize_S
Int UD_TextReadSpeed_S
Int UD_TextLineLength_S
Int UD_FilterVibNotifications_T
Int UD_EnableCNotifications_S
Int UD_EnableDeviceIcons_T
Int UD_EnableDebuffIcons_T
Int UD_IconsSize_S
Int UD_IconsAnchor_M
String[] UD_IconsAnchorList
Int UD_IconsPadding_S
Int UD_TextAnchor_M
String[] UD_TextAnchorList
Int UD_TextPadding_S
Int UD_WidgetTest_T
Int UD_WidgetReset_T
Int UD_IconVariant_EffExhaustion_M
String[] UD_IconVariant_EffExhaustionList
Int UD_IconVariant_EffOrgasm_M
String[] UD_IconVariant_EffOrgasmList

Event resetUIWidgetPage()
    UpdateLockMenuFlag()
    
    SetCursorFillMode(TOP_TO_BOTTOM)

    ; LEFT COLUMN
    AddHeaderOption("Widgets")
    AddTextOption("iWantWidgets", InstallSwitch(UDmain.iWidgetInstalled), FlagSwitch(UDmain.iWidgetInstalled))
    UD_UseIWantWidget_T = AddToggleOption("Use iWW", UDWC.UD_UseIWantWidget, FlagSwitch(UDmain.iWidgetInstalled))
    UD_AutoAdjustWidget_T = addToggleOption("Auto adjust", UDWC.UD_AutoAdjustWidget, FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    ; device widgets
    AddHeaderOption("Device widgets")
    UD_UseWidget_T = addToggleOption("Use device widgets", UDCDmain.UD_UseWidget)
    UD_WidgetPosX_M = AddMenuOption("Widgets horizontal position", widgetXList[UDWC.UD_WidgetXPos], FlagSwitch(UDCDmain.UD_UseWidget))
    UD_WidgetPosY_M = AddMenuOption("Widgets vertical position", widgetYList[UDWC.UD_WidgetYPos], FlagSwitch(UDCDmain.UD_UseWidget))
;    
    ; RIGHT COLUMN
    SetCursorPosition(1)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("Overlay Settings")
    UD_EnableCNotifications_S = AddToggleOption("Show customized notifications", UDWC.UD_EnableCNotifications, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    UD_TextFontSize_S = addSliderOption("Notification font size", UDWC.UD_TextFontSize, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_TextLineLength_S = addSliderOption("Notification line length", UDWC.UD_TextLineLength, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_TextReadSpeed_S = addSliderOption("Notification text read speed", UDWC.UD_TextReadSpeed, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_FilterVibNotifications_T = AddToggleOption("Filter vibrator notifications", UDWC.UD_FilterVibNotifications, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    If UDWC.UD_TextAnchor < 0 || UDWC.UD_TextAnchor > 3
        UDMain.Warning("UD_MCM_script::resetUIWidgetPage() WTF! UDWC.UD_TextAnchor = " + UDWC.UD_TextAnchor)
        UDWC.UD_TextAnchor = 1
    EndIf
    UD_TextAnchor_M = addMenuOption("Notifications base position", UD_TextAnchorList[UDWC.UD_TextAnchor], a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_TextPadding_S = addSliderOption("Notifications offset", UDWC.UD_TextPadding, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_EnableDeviceIcons_T = AddToggleOption("Show DD icons", UDWC.UD_EnableDeviceIcons, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    UD_EnableDebuffIcons_T = AddToggleOption("Show effect icons", UDWC.UD_EnableDebuffIcons, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    UD_IconsSize_S = addSliderOption("Icon size", UDWC.UD_IconsSize, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && (UDWC.UD_EnableDeviceIcons || UDWC.UD_EnableDebuffIcons)))
    If UDWC.UD_IconsAnchor < 0 || UDWC.UD_IconsAnchor > 2
        UDMain.Warning("UD_MCM_script::resetUIWidgetPage() WTF! UDWC.UD_IconsAnchor = " + UDWC.UD_IconsAnchor)
        UDWC.UD_IconsAnchor = 1
    EndIf
    UD_IconsAnchor_M = addMenuOption("Icons base position", UD_IconsAnchorList[UDWC.UD_IconsAnchor], a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && (UDWC.UD_EnableDeviceIcons || UDWC.UD_EnableDebuffIcons)))
    UD_IconsPadding_S = addSliderOption("Icons offset", UDWC.UD_IconsPadding, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && (UDWC.UD_EnableDeviceIcons || UDWC.UD_EnableDebuffIcons)))
    
    Int variant_index = UDWC.StatusEffect_GetVariant("effect-exhaustion")
    String variant_str = ""
    Bool variant_err = False
    If variant_index < 0 || variant_index >= UD_IconVariant_EffExhaustionList.Length
        variant_str = "ERROR"
        variant_err = True
    Else
        variant_err = False
        variant_str = UD_IconVariant_EffExhaustionList[variant_index]
    EndIf
    UD_IconVariant_EffExhaustion_M = addMenuOption("Struggle exhaustion icon variant", variant_str, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableDebuffIcons && !variant_err))
    variant_index = UDWC.StatusEffect_GetVariant("effect-orgasm")
    If variant_index < 0 || variant_index >= UD_IconVariant_EffOrgasmList.Length
        variant_str = "ERROR"
        variant_err = True
    Else
        variant_err = False
        variant_str = UD_IconVariant_EffOrgasmList[variant_index]
    EndIf
    UD_IconVariant_EffOrgasm_M = addMenuOption("Orgasm icon variant", variant_str, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableDebuffIcons && !variant_err))
    
    UD_WidgetTest_T = AddTextOption("TEST WIDGETS", "-CLICK-")
    UD_WidgetReset_T = AddTextOption("RESET UI", "-CLICK-")
EndEvent


UD_AnimationManagerScript Property UDAM Hidden
    UD_AnimationManagerScript Function Get()
        return UDmain.UDAM
    EndFunction
EndProperty

Int UDAM_AnimationJSON_First_T
Int UDAM_Reload_T

Int UDAM_TestQuery_PlayerArms_M
String[] UDAM_TestQuery_PlayerArms_List
Int[] UDAM_TestQuery_PlayerArms_Bit
Int UDAM_TestQuery_PlayerArms_Index

Int UDAM_TestQuery_PlayerLegs_M
String[] UDAM_TestQuery_PlayerLegs_List
Int[] UDAM_TestQuery_PlayerLegs_Bit
Int UDAM_TestQuery_PlayerLegs_Index

Int UDAM_TestQuery_PlayerMittens_T
Bool UDAM_TestQuery_PlayerMittens

Int UDAM_TestQuery_PlayerGag_T
Bool UDAM_TestQuery_PlayerGag

Int UDAM_TestQuery_HelperArms_M
Int UDAM_TestQuery_HelperArms_Index

Int UDAM_TestQuery_HelperLegs_M
Int UDAM_TestQuery_HelperLegs_Index

Int UDAM_TestQuery_HelperMittens_T
Bool UDAM_TestQuery_HelperMittens

Int UDAM_TestQuery_HelperGag_T
Bool UDAM_TestQuery_HelperGag

Int UDAM_TestQuery_Request_T
Int UDAM_TestQuery_StopAnimation_T 

Int UDAM_TestQuery_Keyword_M
String[] UDAM_TestQuery_Keyword_List
Int UDAM_TestQuery_Keyword_Index

Int UDAM_TestQuery_Type_M
String[] UDAM_TestQuery_Type_List
Int UDAM_TestQuery_Type_Index

Float UDAM_TestQuery_TimeSpan

String[] UDAM_TestQuery_Results
Int UDAM_TestQuery_Results_First_T

Int UDAM_TestQuery_ElapsedTime_T

Int UD_AlternateAnimation_T
Int UD_AlternateAnimationPeriod_S

Int UD_UseSingleStruggleKeyword_T

Actor LastHelper
Int UD_Helper_T

Event resetAnimationsPage() 
; FIRST RUN
    If UDAM_TestQuery_Type_List.Length == 0
        UDAM_TestQuery_Type_List = new String[2]
        UDAM_TestQuery_Type_List[0] = ".solo"
        UDAM_TestQuery_Type_List[1] = ".paired"
        UDAM_TestQuery_Type_Index = 1
    EndIf
    If UDAM_TestQuery_Keyword_List.Length == 0
        UDAM_TestQuery_Keyword_List = new String[37]
        UDAM_TestQuery_Keyword_List[0] = ".zad_DeviousBoots"
        UDAM_TestQuery_Keyword_List[1] = ".zad_DeviousPlug"
        UDAM_TestQuery_Keyword_List[2] = ".zad_DeviousBelt"
        UDAM_TestQuery_Keyword_List[3] = ".zad_DeviousBra"
        UDAM_TestQuery_Keyword_List[4] = ".zad_DeviousCollar"
        UDAM_TestQuery_Keyword_List[5] = ".zad_DeviousArmCuffs"
        UDAM_TestQuery_Keyword_List[6] = ".zad_DeviousLegCuffs"
        UDAM_TestQuery_Keyword_List[7] = ".zad_DeviousArmbinder"
        UDAM_TestQuery_Keyword_List[8] = ".zad_DeviousArmbinderElbow"
        UDAM_TestQuery_Keyword_List[9] = ".zad_DeviousHobbleSkirt"
        UDAM_TestQuery_Keyword_List[10] = ".zad_DeviousHobbleSkirtRelaxed"
        UDAM_TestQuery_Keyword_List[11] = ".zad_DeviousAnkleShackles"
        UDAM_TestQuery_Keyword_List[12] = ".zad_DeviousStraitJacket"
        UDAM_TestQuery_Keyword_List[13] = ".zad_DeviousCuffsFront"
        UDAM_TestQuery_Keyword_List[14] = ".zad_DeviousPetSuit"
        UDAM_TestQuery_Keyword_List[15] = ".zad_DeviousYoke"
        UDAM_TestQuery_Keyword_List[16] = ".zad_DeviousYokeBB"
        UDAM_TestQuery_Keyword_List[17] = ".zad_DeviousCorset"
        UDAM_TestQuery_Keyword_List[18] = ".zad_DeviousClamps"
        UDAM_TestQuery_Keyword_List[19] = ".zad_DeviousGloves"
        UDAM_TestQuery_Keyword_List[20] = ".zad_DeviousHood"
        UDAM_TestQuery_Keyword_List[21] = ".zad_DeviousElbowTie"
        UDAM_TestQuery_Keyword_List[22] = ".zad_DeviousGag"
        UDAM_TestQuery_Keyword_List[23] = ".zad_DeviousGagLarge"
        UDAM_TestQuery_Keyword_List[24] = ".zad_DeviousGagPanel"
        UDAM_TestQuery_Keyword_List[25] = ".zad_DeviousPlugVaginal"
        UDAM_TestQuery_Keyword_List[26] = ".zad_DeviousPlugAnal"
        UDAM_TestQuery_Keyword_List[27] = ".zad_DeviousHarness"
        UDAM_TestQuery_Keyword_List[28] = ".zad_DeviousBlindfold"
        UDAM_TestQuery_Keyword_List[29] = ".zad_DeviousPiercingsNipple"
        UDAM_TestQuery_Keyword_List[30] = ".zad_DeviousPiercingsVaginal"
        UDAM_TestQuery_Keyword_List[31] = ".zad_DeviousBondageMittens"
        UDAM_TestQuery_Keyword_List[32] = ".zad_DeviousSuit"
        UDAM_TestQuery_Keyword_List[33] = ".horny"
        UDAM_TestQuery_Keyword_List[34] = ".edged"
        UDAM_TestQuery_Keyword_List[35] = ".orgasm"
        UDAM_TestQuery_Keyword_List[36] = ".spectator"
        UDAM_TestQuery_Keyword_Index = 0
    EndIf
    If UDAM_TestQuery_PlayerArms_List.Length == 0
        UDAM_TestQuery_PlayerArms_List = new String[9]
        UDAM_TestQuery_PlayerArms_Bit = new Int[9]
        UDAM_TestQuery_PlayerArms_List[0] = "NOTHING"
        UDAM_TestQuery_PlayerArms_Bit[0] = 0
        UDAM_TestQuery_PlayerArms_List[1] = "Yoke"
        UDAM_TestQuery_PlayerArms_Bit[1] = 4
        UDAM_TestQuery_PlayerArms_List[2] = "Front Cuffs"
        UDAM_TestQuery_PlayerArms_Bit[2] = 8
        UDAM_TestQuery_PlayerArms_List[3] = "Armbinder"
        UDAM_TestQuery_PlayerArms_Bit[3] = 16
        UDAM_TestQuery_PlayerArms_List[4] = "Elbowbinder"
        UDAM_TestQuery_PlayerArms_Bit[4] = 32
        UDAM_TestQuery_PlayerArms_List[5] = "Pet suit"
        UDAM_TestQuery_PlayerArms_Bit[5] = 64
        UDAM_TestQuery_PlayerArms_List[6] = "Elbowtie"
        UDAM_TestQuery_PlayerArms_Bit[6] = 128
        UDAM_TestQuery_PlayerArms_List[7] = "Straitjacket"
        UDAM_TestQuery_PlayerArms_Bit[7] = 512
        UDAM_TestQuery_PlayerArms_List[8] = "YokeBB"
        UDAM_TestQuery_PlayerArms_Bit[8] = 1024
        UDAM_TestQuery_PlayerArms_Index = 0
    EndIf
    If UDAM_TestQuery_PlayerLegs_List.Length == 0
        UDAM_TestQuery_PlayerLegs_List = new String[3]
        UDAM_TestQuery_PlayerLegs_Bit = new Int[3]
        UDAM_TestQuery_PlayerLegs_List[0] = "NOTHING"
        UDAM_TestQuery_PlayerLegs_Bit[0] = 0
        UDAM_TestQuery_PlayerLegs_List[1] = "Bound Ankles"
        UDAM_TestQuery_PlayerLegs_Bit[1] = 2
        UDAM_TestQuery_PlayerLegs_List[2] = "Hobble Skirt"
        UDAM_TestQuery_PlayerLegs_Bit[2] = 1
    EndIf
    
    Actor actor_in_crosshair = (Game.GetCurrentCrosshairRef() as Actor)
    ; change helper if the last one is not in animation
    If !(LastHelper && UDAM.IsAnimating(LastHelper)) && actor_in_crosshair
        LastHelper = actor_in_crosshair
    EndIf
    
    Int flags = OPTION_FLAG_NONE
        
    UpdateLockMenuFlag()
    Int rows_right = 0
    Int rows_left = 0
    
; LEFT COLUMN

    SetCursorPosition(0)
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    AddHeaderOption("Animation playback options")
    rows_left += 1
    UD_AlternateAnimation_T = addToggleOption("Alternate animation:", UDAM.UD_AlternateAnimation)
    rows_left += 1
    If UDAM.UD_AlternateAnimation
        flags = OPTION_FLAG_NONE
    Else
        flags = OPTION_FLAG_DISABLED
    EndIf
    UD_AlternateAnimationPeriod_S = AddSliderOption("Switch period", UDAM.UD_AlternateAnimationPeriod, "{0} s", flags)
    rows_left += 1
    UD_UseSingleStruggleKeyword_T = AddToggleOption("Use single keyword from device", UDAM.UD_UseSingleStruggleKeyword)
    rows_left += 1
    
; LEFT COLUMN

    If rows_right > rows_left
        SetCursorPosition(rows_right * 2)
    Else
        SetCursorPosition(rows_left * 2)
    EndIf
    
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("Loaded JSONs")
    rows_left += 1
    Int i = 0
    While i < UDAM.UD_AnimationJSON_All.Length
        Bool val = False
        flags = OPTION_FLAG_NONE
        If (UDAM.UD_AnimationJSON_Inv.Find(UDAM.UD_AnimationJSON_All[i]) > -1)
            flags = OPTION_FLAG_DISABLED
        Else
            val = (UDAM.UD_AnimationJSON_Dis.Find(UDAM.UD_AnimationJSON_All[i]) == -1)
        EndIf
        Int id = AddToggleOption(UDAM.UD_AnimationJSON_All[i], val, flags)
        If i == 0
            UDAM_AnimationJSON_First_T = id
        EndIf
        i += 1
        rows_left += 1
    EndWhile
    UDAM_Reload_T =  AddTextOption("Reload JSONs", "-PRESS-")
    rows_left += 1
    
; RIGHT COLUMN

    SetCursorPosition(1)
    AddHeaderOption("Test animation query")
    rows_right += 1
    UDAM_TestQuery_Type_M = AddMenuOption("Animation type", UDAM_TestQuery_Type_List[UDAM_TestQuery_Type_Index])
    rows_right += 1
    UDAM_TestQuery_Keyword_M = AddMenuOption("Keyword", UDAM_TestQuery_Keyword_List[UDAM_TestQuery_Keyword_Index])
    rows_right += 1

    UDAM_TestQuery_PlayerArms_M = AddMenuOption("Player arms restraints", UDAM_TestQuery_PlayerArms_List[UDAM_TestQuery_PlayerArms_Index])
    rows_right += 1
    UDAM_TestQuery_PlayerLegs_M = AddMenuOption("Player legs restraints", UDAM_TestQuery_PlayerLegs_List[UDAM_TestQuery_PlayerLegs_Index])
    rows_right += 1
    UDAM_TestQuery_PlayerMittens_T = AddToggleOption("Player wears mittens", UDAM_TestQuery_PlayerMittens)
    rows_right += 1
    UDAM_TestQuery_PlayerGag_T = AddToggleOption("Player wears gag", UDAM_TestQuery_PlayerGag)
    rows_right += 1
    
    Int helper_flags = OPTION_FLAG_NONE
    If UDAM_TestQuery_Type_Index == 0
        helper_flags = OPTION_FLAG_DISABLED
    EndIf
    If LastHelper
        AddTextOption("Helper", LastHelper.GetActorBase().GetName(), OPTION_FLAG_DISABLED)
    Else
        UD_Helper_T = AddTextOption("Helper", "----", OPTION_FLAG_NONE)
    EndIf
    
    UDAM_TestQuery_HelperArms_M = AddMenuOption("Helper arms restraints", UDAM_TestQuery_PlayerArms_List[UDAM_TestQuery_HelperArms_Index], helper_flags)
    rows_right += 1
    UDAM_TestQuery_HelperLegs_M = AddMenuOption("Helper legs restraints", UDAM_TestQuery_PlayerLegs_List[UDAM_TestQuery_HelperLegs_Index], helper_flags)
    rows_right += 1
    UDAM_TestQuery_HelperMittens_T = AddToggleOption("Helper wears mittens", UDAM_TestQuery_HelperMittens, helper_flags)
    rows_right += 1
    UDAM_TestQuery_HelperGag_T = AddToggleOption("Helper wears gag", UDAM_TestQuery_HelperGag, helper_flags)
    rows_right += 1
    
    UDAM_TestQuery_Request_T =  AddTextOption("Test query", "-PRESS-")
    rows_right += 1
    If UDAM.IsAnimating(UDMain.Player)
        flags = OPTION_FLAG_NONE
    Else
        flags = OPTION_FLAG_DISABLED
    EndIf
    UDAM_TestQuery_StopAnimation_T =  AddTextOption("Try to stop animation", "-PRESS-", flags)
    rows_right += 1
    
; BOTH COLUMNS 
    If rows_right > rows_left
        SetCursorPosition(rows_right * 2)
    Else
        SetCursorPosition(rows_left * 2)
    EndIf
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("Test animation query results (file)")
    AddHeaderOption("Test animation query results (path)")
    
    AddTextOption("Number of found animations", UDAM_TestQuery_Results.Length, OPTION_FLAG_DISABLED)
    UDAM_TestQuery_ElapsedTime_T = AddTextOption("Elapsed time", (UDAM_TestQuery_TimeSpan * 1000) As Int + " ms", OPTION_FLAG_DISABLED)
    
    If LastHelper == None && UDAM_TestQuery_Type_Index == 1
        flags = OPTION_FLAG_DISABLED
    Else
        flags = OPTION_FLAG_NONE
    EndIf
    i = 0
    While i < UDAM_TestQuery_Results.Length
        Int part_index = StringUtil.Find(UDAM_TestQuery_Results[i], ":")
        If part_index > -1
            String file_part = StringUtil.Substring(UDAM_TestQuery_Results[i], 0, part_index)
            String path_part = StringUtil.Substring(UDAM_TestQuery_Results[i], part_index + 1)
            AddTextOption(file_part, ":", OPTION_FLAG_DISABLED)
            Int id = AddTextOption(path_part, "-PLAY-", flags)
            If i == 0
                UDAM_TestQuery_Results_First_T = id
            EndIf
        EndIf
        i += 1
    EndWhile
    
EndEvent


int[] registered_devices_T
int[] NPCSlots_T
int device_flag
int fix_flag
;int npc_flag
int fixBugs_T
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
    
    fix_flag = OPTION_FLAG_NONE
    
    while i < size
        if devices[i]
            registered_devices_T[i] = AddTextOption((i + 1) + ") " , devices[i].deviceInventory.getName(),FlagSwitchAnd(UD_LockMenu_flag,FlagSwitch(!UDmain.UD_LockDebugMCM)))
        else
            registered_devices_T[i] = AddTextOption((i + 1) + ") " , "Empty" ,OPTION_FLAG_DISABLED)
        endif
            if i == 0
                setNPCSlot(15,"PlayerSlot",False)
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
                setNPCSlot(10)
            elseif i == 12
                setNPCSlot(11)
            elseif i == 13
                setNPCSlot(12)
            elseif i == 14
                setNPCSlot(13)
            elseif i == 15
                setNPCSlot(14)
            elseif i == 16
                AddHeaderOption("-TOOLS-")
            elseif i == 17
                AddTextOption("Devices", slot.getNumberOfRegisteredDevices() ,OPTION_FLAG_DISABLED)
            elseif i == 18
                OrgasmResist_S          = addSliderOption("Orgasm Resist:",UDOM.getActorOrgasmResist(slot.getActor()), "{1}")
            elseif i == 19
                OrgasmCapacity_S        = addSliderOption("Orgasm Capacity:",UDOM.getActorOrgasmCapacity(slot.getActor()), "{0}")
            elseif i == 20
                unlockAll_T             = AddTextOption("Unlock all", "CLICK" ,FlagSwitchAnd(UD_LockMenu_flag,FlagSwitch(!UDmain.UD_LockDebugMCM)))
            elseif i == 21
                endAnimation_T          = AddTextOption("Show details", "CLICK" )
            elseif i == 22
                fixBugs_T               = AddTextOption("Fixes", "CLICK" ,fix_flag)
            elseif i == 23
                if !slot.isPlayer()
                    unregisterNPC_T = AddTextOption("Unregister NPC","CLICK")
                else
                    addEmptyOption()
                endif
            elseif i == 24
                addEmptyOption()
                    
            else     
                addEmptyOption()
            endif
        i += 1
    endwhile
    
    AddHeaderOption("--GLOBAL--")
    addEmptyOption()
    
    rescanSlots_T = AddTextOption("Rescan slots", "CLICK")
    addEmptyOption()
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
    
    AddTextOption("Zaz animation pack installed",InstallSwitch(UDmain.ZaZAnimationPackInstalled),FlagSwitch(UDmain.ZaZAnimationPackInstalled))
    addEmptyOption()
    
    AddTextOption("ConsoleUtil installed",InstallSwitch(UDmain.ConsoleUtilInstalled),FlagSwitch(UDmain.ConsoleUtilInstalled))
    addEmptyOption()
    
    AddTextOption("SlaveTats installed",InstallSwitch(UDmain.SlaveTatsInstalled),FlagSwitch(UDmain.SlaveTatsInstalled))
    addEmptyOption()

    AddTextOption("Devious Devices For Him",InstallSwitch(UDmain.ForHimInstalled),FlagSwitch(UDmain.ForHimInstalled))
    addEmptyOption()

    AddTextOption("powerofthree's Papyrus Extender",InstallSwitch(UDmain.PO3Installed),FlagSwitch(UDmain.PO3Installed))
    addEmptyOption()

EndFunction

String Function InstallSwitch(Bool abSwitch)
    if abSwitch
        return "INSTALLED"
    else
        return "NOT INSTALLED"
    endif
EndFunction

event OnOptionSelect(int option)
    OptionSelectGeneral(option)
    OptionSelectFilter(option)
    OptionCustomBondage(option)
    OptionCustomOrgasm(option)
    OptionSelectNPCs(option)
    OptionDDPatch(option)
    OptionSelectAbadon(option)
    OptionSelectUiWidget(option)
    OptionSelectAnimations(option)
    OptionSelectDebug(option)
    OptionSelectOther(option)
endEvent

Function OptionSelectGeneral(int option)
    if(option == lockmenu_T)
        UDmain.lockMCM = !UDmain.lockMCM
        SetToggleOptionValue(lockmenu_T, UDmain.lockMCM)
    elseif (option == UD_hightPerformance_T)
        UDmain.UD_hightPerformance = !UDmain.UD_hightPerformance
        SetToggleOptionValue(UD_hightPerformance_T, UDmain.UD_hightPerformance)
    elseif (option == UD_debugmod_T)
        UDmain.debugmod = !UDmain.debugmod
        SetToggleOptionValue(UD_debugmod_T, UDmain.debugmod)
    elseif option == UD_WarningAllowed_T
        UDmain.UD_WarningAllowed = !UDmain.UD_WarningAllowed
        SetToggleOptionValue(UD_WarningAllowed_T, UDmain.UD_WarningAllowed)  
    elseif option == UD_LockDebugMCM_T
        UDmain.UD_LockDebugMCM = !UDmain.UD_LockDebugMCM
        SetToggleOptionValue(UD_LockDebugMCM_T, UDmain.UD_LockDebugMCM)
    elseif option == UD_EasyGamepadMode_T
        UDUI.UD_EasyGamepadMode = !UDUI.UD_EasyGamepadMode
        SetToggleOptionValue(UD_EasyGamepadMode_T, UDUI.UD_EasyGamepadMode)
        forcePageReset()
    endif
EndFunction

Function OptionSelectFilter(int option)
    if (option == UD_UseArmCuffs_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00001000)
        SetToggleOptionValue(UD_UseArmCuffs_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00001000))
        forcePageReset()
    elseif (option == UD_UseBelts_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00020000)
        SetToggleOptionValue(UD_UseBelts_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00020000))
        forcePageReset()
    elseif (option == UD_UseBlindfolds_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000400)
        SetToggleOptionValue(UD_UseBlindfolds_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000400))
        forcePageReset()
    elseif (option == UD_UseBoots_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000800)
        SetToggleOptionValue(UD_UseBoots_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000800))
        forcePageReset()
    elseif (option == UD_UseBras_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00010000)
        SetToggleOptionValue(UD_UseBras_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00010000))
        forcePageReset()
    elseif (option == UD_UseCollars_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000100)
        SetToggleOptionValue(UD_UseCollars_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000100))
        forcePageReset()
    elseif (option == UD_UseCorsets_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000040)
        SetToggleOptionValue(UD_UseCorsets_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000040))
        forcePageReset()
    elseif (option == UD_UseGags_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000200)
        SetToggleOptionValue(UD_UseGags_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000200))
        forcePageReset()
    elseif (option == UD_UseGloves_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00008000)
        SetToggleOptionValue(UD_UseGloves_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00008000))
        forcePageReset()
    elseif (option == UD_UseHarnesses_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000020)
        SetToggleOptionValue(UD_UseHarnesses_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000020))
        forcePageReset()
    elseif (option == UD_UseHeavyBondage_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000010)
        SetToggleOptionValue(UD_UseHeavyBondage_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000010))
        forcePageReset()
    elseif (option == UD_UseHoods_T)
        UDIM.UD_useHoods = !UDIM.UD_useHoods
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000080)
        SetToggleOptionValue(UD_UseHoods_T, UDIM.UD_useHoods)
        forcePageReset()
    elseif (option == UD_UseLegCuffs_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00002000)
        SetToggleOptionValue(UD_UseLegCuffs_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00002000))
        forcePageReset()
    elseif (option == UD_UsePiercingsNipple_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000002)
        SetToggleOptionValue(UD_UsePiercingsNipple_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000002))
        forcePageReset()
    elseif (option == UD_UsePiercingsVaginal_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000001)
        SetToggleOptionValue(UD_UsePiercingsVaginal_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000001))
        forcePageReset()
    elseif (option == UD_UsePlugsAnal_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000008)
        SetToggleOptionValue(UD_UsePlugsAnal_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000008))
        forcePageReset()
    elseif (option == UD_UsePlugsVaginal_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000004)
        SetToggleOptionValue(UD_UsePlugsVaginal_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00000004))
        forcePageReset()
    elseif (option == UD_UseSuits_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00004000)
        SetToggleOptionValue(UD_UseSuits_T, Math.LogicalAnd(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0x00004000))
        forcePageReset()
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
    elseif option == UD_AllowArmTie_T
        UDCDmain.UD_AllowArmTie = !UDCDmain.UD_AllowArmTie
        SetToggleOptionValue(UD_AllowArmTie_T, UDCDmain.UD_AllowArmTie)
    elseif option == UD_AllowLegTie_T
        UDCDmain.UD_AllowLegTie = !UDCDmain.UD_AllowLegTie
        SetToggleOptionValue(UD_AllowLegTie_T, UDCDmain.UD_AllowLegTie)
    elseif option == UD_PreventMasterLock_T
        UDCDmain.UD_PreventMasterLock = !UDCDmain.UD_PreventMasterLock
        SetToggleOptionValue(UD_PreventMasterLock_T, UDCDmain.UD_PreventMasterLock)  
    elseif option == UD_MandatoryCrit_T
        UDCDmain.UD_MandatoryCrit = !UDCDmain.UD_MandatoryCrit
        SetToggleOptionValue(UD_MandatoryCrit_T, UDCDmain.UD_MandatoryCrit)
    elseif option == UD_HardcoreAccess_T
        UDCDmain.UD_HardcoreAccess = !UDCDmain.UD_HardcoreAccess
        SetToggleOptionValue(UD_HardcoreAccess_T, UDCDmain.UD_HardcoreAccess)
    endif
EndFunction

Function OptionCustomOrgasm(int option)
    if(option == UD_UseOrgasmWidget_T)
        UDOM.UD_UseOrgasmWidget = !UDOM.UD_UseOrgasmWidget
        SetToggleOptionValue(UD_UseOrgasmWidget_T, UDOM.UD_UseOrgasmWidget)
        forcePageReset()
    elseif (option == UD_OrgasmExhaustion_T)
        UDmain.UD_OrgasmExhaustion = !UDmain.UD_OrgasmExhaustion
        if (UDmain.UD_OrgasmExhaustion)
            UD_OrgasmExhaustion_flag = OPTION_FLAG_NONE
        else
            UD_OrgasmExhaustion_flag = OPTION_FLAG_DISABLED
        endif
        SetToggleOptionValue(UD_OrgasmExhaustion_T, UDmain.UD_OrgasmExhaustion)
        forcePageReset()
    elseif(option == UD_HornyAnimation_T)
        UDOM.UD_HornyAnimation = !UDOM.UD_HornyAnimation
        SetToggleOptionValue(UD_HornyAnimation_T, UDOM.UD_HornyAnimation)
        if UDOM.UD_HornyAnimation
            UD_Horny_f = OPTION_FLAG_NONE
        else
            UD_Horny_f = OPTION_FLAG_DISABLED
        endif
        forcePageReset()
    endif
EndFunction

Function OptionSelectNPCs(int option)
    if(option == UD_AIEnable_T)
        UDAI.Enabled = !UDAI.Enabled
        SetToggleOptionValue(UD_AIEnable_T, UDAI.Enabled)
        forcePageReset()
    elseif option == UD_NPCSupport_T
        UDmain.AllowNPCSupport = !UDmain.AllowNPCSupport
        SetToggleOptionValue(UD_NPCSupport_T, UDmain.AllowNPCSupport)
    endif
EndFunction

Function OptionDDPatch(int option)
    if(option == UD_StartThirdpersonAnimation_Switch_T)
        libs.UD_StartThirdpersonAnimation_Switch = !libs.UD_StartThirdpersonAnimation_Switch
        SetToggleOptionValue(UD_StartThirdpersonAnimation_Switch_T, libs.UD_StartThirdpersonAnimation_Switch)
    elseif option == UD_DAR_T
        AAScript.UD_DAR = !AAScript.UD_DAR
        SetToggleOptionValue(UD_DAR_T, AAScript.UD_DAR)
    elseif option == UD_OutfitRemove_T
        UDCDMain.UD_OutfitRemove = !UDCDMain.UD_OutfitRemove
        SetToggleOptionValue(UD_OutfitRemove_T, UDCDMain.UD_OutfitRemove)
    elseif option == UD_AllowMenBondage_T
        UDmain.AllowMenBondage = !UDmain.AllowMenBondage
        SetToggleOptionValue(UD_AllowMenBondage_T, UDmain.AllowMenBondage)
    elseif option == UD_CheckAllKw_T
        UDmain.UD_CheckAllKw = !UDmain.UD_CheckAllKw
        SetToggleOptionValue(UD_CheckAllKw_T, UDMain.UD_CheckAllKw)
    endif
EndFunction

Function OptionSelectUiWidget(int option)
    if(option == UD_UseIWantWidget_T)
        UDWC.UD_UseIWantWidget = !UDWC.UD_UseIWantWidget
        SetToggleOptionValue(UD_UseIWantWidget_T, UDWC.UD_UseIWantWidget)
        ShowMessage("To avoid possible errors when switching between different UI modes, please save your game and then load from that save.", False, "OK")
        forcePageReset()
    elseif (option == UD_AutoAdjustWidget_T)
        UDWC.UD_AutoAdjustWidget = !UDWC.UD_AutoAdjustWidget
        SetToggleOptionValue(UD_AutoAdjustWidget_T, UDWC.UD_AutoAdjustWidget)
    elseif(option == UD_UseWidget_T)
        UDCDmain.UD_UseWidget = !UDCDmain.UD_UseWidget
        SetToggleOptionValue(UD_UseWidget_T, UDCDmain.UD_UseWidget)
        forcePageReset()
    ElseIf option == UD_FilterVibNotifications_T
        UDWC.UD_FilterVibNotifications = !UDWC.UD_FilterVibNotifications
        SetToggleOptionValue(UD_FilterVibNotifications_T, UDWC.UD_FilterVibNotifications)
    ElseIf option == UD_EnableCNotifications_S
        UDWC.UD_EnableCNotifications = !UDWC.UD_EnableCNotifications
        SetToggleOptionValue(UD_EnableCNotifications_S, UDWC.UD_EnableCNotifications)
        forcePageReset()
    ElseIf option == UD_EnableDeviceIcons_T
        UDWC.UD_EnableDeviceIcons = !UDWC.UD_EnableDeviceIcons
        SetToggleOptionValue(UD_EnableDeviceIcons_T, UDWC.UD_EnableDeviceIcons)
        forcePageReset()
    ElseIf option == UD_EnableDebuffIcons_T
        UDWC.UD_EnableDebuffIcons = !UDWC.UD_EnableDebuffIcons
        SetToggleOptionValue(UD_EnableDebuffIcons_T, UDWC.UD_EnableDebuffIcons)
        forcePageReset()
    ElseIf option == UD_WidgetTest_T
        closeMCM()
        UDWC.TestWidgets()
    ElseIf option == UD_WidgetReset_T
        closeMCM()
        UDWC.Notification_Reset()
        UDWC.StatusEffect_ResetValues()
        UDWC.InitWidgetsRequest(abMeters = True, abIcons = True, abText = True)
    endif
EndFunction

Function OptionSelectAnimations(int option)
    If UDAM_AnimationJSON_First_T == 0 
        Return
    EndIf
    If (option >= UDAM_AnimationJSON_First_T) && (option <= (UDAM_AnimationJSON_First_T + (UDAM.UD_AnimationJSON_All.Length - 1) * 2)) && (((option - UDAM_AnimationJSON_First_T) % 2) == 0)
        Int index = (option - UDAM_AnimationJSON_First_T) / 2
        String val = UDAM.UD_AnimationJSON_All[index]
        If UDAM.UD_AnimationJSON_Dis.Find(val) == -1
            UDAM.UD_AnimationJSON_Dis = PapyrusUtil.PushString(UDAM.UD_AnimationJSON_Dis, UDAM.UD_AnimationJSON_All[index])
            SetToggleOptionValue(option, False)
        Else
            UDAM.UD_AnimationJSON_Dis = PapyrusUtil.RemoveString(UDAM.UD_AnimationJSON_Dis, UDAM.UD_AnimationJSON_All[index])
            SetToggleOptionValue(option, True)
        EndIf
    ElseIf option == UDAM_Reload_T
        SetOptionFlags(option, OPTION_FLAG_DISABLED)
        UDAM.LoadAnimationJSONFiles()
        SetOptionFlags(option, OPTION_FLAG_NONE)
    ElseIf option == UDAM_TestQuery_Request_T
        SetOptionFlags(option, OPTION_FLAG_DISABLED)
        Float start_time = Utility.GetCurrentRealTime()
        String[] kwds = new String[1]
        kwds[0] = UDAM_TestQuery_Keyword_List[UDAM_TestQuery_Keyword_Index]
        String anim_type = UDAM_TestQuery_Type_List[UDAM_TestQuery_Type_Index]
        If UDAM_TestQuery_Type_Index == 1                                       ; .paired
            Int[] constr = new Int[2]
            constr[0] = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int) + 2048 * (UDAM_TestQuery_PlayerGag as Int)
            constr[1] = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_HelperArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_HelperLegs_Index] + 256 * (UDAM_TestQuery_HelperMittens as Int) + 2048 * (UDAM_TestQuery_HelperGag as Int)
            UDAM_TestQuery_Results = UDAM.GetAnimationsFromDB(anim_type, kwds, "", constr)
        Else                                                                    ; .solo
            Int[] constr = new Int[1]
            constr[0] = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int) + 2048 * (UDAM_TestQuery_PlayerGag as Int)
            UDAM_TestQuery_Results = UDAM.GetAnimationsFromDB(anim_type, kwds, "", constr)
        EndIf
        UDAM_TestQuery_TimeSpan = Utility.GetCurrentRealTime() - start_time
        forcePageReset()
        SetOptionFlags(option, OPTION_FLAG_NONE)
    ElseIf option == UDAM_TestQuery_PlayerMittens_T
        UDAM_TestQuery_PlayerMittens = !UDAM_TestQuery_PlayerMittens
        SetToggleOptionValue(option, UDAM_TestQuery_PlayerMittens)
    ElseIf option == UDAM_TestQuery_HelperMittens_T
        UDAM_TestQuery_HelperMittens = !UDAM_TestQuery_HelperMittens
        SetToggleOptionValue(option, UDAM_TestQuery_HelperMittens)
    ElseIf option == UDAM_TestQuery_PlayerGag_T
        UDAM_TestQuery_PlayerGag = !UDAM_TestQuery_PlayerGag
        SetToggleOptionValue(option, UDAM_TestQuery_PlayerGag)
    ElseIf option == UDAM_TestQuery_HelperGag_T
        UDAM_TestQuery_HelperGag = !UDAM_TestQuery_HelperGag
        SetToggleOptionValue(option, UDAM_TestQuery_HelperGag)
    elseif option == UD_AlternateAnimation_T
        UDAM.UD_AlternateAnimation = !UDAM.UD_AlternateAnimation
        SetToggleOptionValue(UD_AlternateAnimation_T, UDAM.UD_AlternateAnimation)
        If UDAM.UD_AlternateAnimation
            SetOptionFlags(UD_AlternateAnimationPeriod_S, OPTION_FLAG_NONE)
        Else
            SetOptionFlags(UD_AlternateAnimationPeriod_S, OPTION_FLAG_DISABLED)
        EndIf
    ElseIf (option >= UDAM_TestQuery_Results_First_T) && (option <= (UDAM_TestQuery_Results_First_T + (UDAM_TestQuery_Results.Length - 1) * 2)) && (((option - UDAM_TestQuery_Results_First_T) % 2) == 0)
        Int index = (option - UDAM_TestQuery_Results_First_T) / 2
        String val = UDAM_TestQuery_Results[index]
        If UDAM_TestQuery_Type_Index == 1 && !LastHelper
            ShowMessage("First you need to choose a helper. Hover your crosshair over an NPC in the game and make sure its name appears in the 'Helper' option above")
        Else
            If ShowMessage("FOR DEBUG ONLY! To stop animation use command 'Stop animation' in this menu. Animation will start if you press ACCEPT and close menu.", True)
                closeMCM()
                If LastHelper && UDAM_TestQuery_Type_Index == 1
                    Actor[] actors = new Actor[2]
                    actors[0] = Game.GetPlayer()
                    actors[1] = LastHelper
                    Int constrA1 = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int)
                    Int constrA2 = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_HelperArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_HelperLegs_Index] + 256 * (UDAM_TestQuery_HelperMittens as Int)
                    UDAM.PlayAnimationByDef(val, actors, False, True, constrA1, constrA2)
                Else
                    Actor[] actors = new Actor[1]
                    actors[0] = Game.GetPlayer()
                    Int constr = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int)
                    UDAM.PlayAnimationByDef(val, actors, False, True, constr)
                EndIf
            EndIf
        EndIf
    ElseIf option == UDAM_TestQuery_StopAnimation_T
        ShowMessage("Lets try to stop animation", False)
        UDAM.StopAnimation(Game.GetPlayer(), LastHelper)
        closeMCM()
    ElseIf option == UD_UseSingleStruggleKeyword_T
        UDAM.UD_UseSingleStruggleKeyword = !UDAM.UD_UseSingleStruggleKeyword
        SetToggleOptionValue(UD_UseSingleStruggleKeyword_T, UDAM.UD_UseSingleStruggleKeyword)
    EndIf
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
    elseif unlockAll_T == option
        closeMCM()
        UDCDmain.removeAllDevices(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
    elseif endAnimation_T == option
        closeMCM()
        UDCDmain.ShowActorDetails(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
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

Function OnOptionInputOpen(int option)
    OnOptionInputOpenGeneral(option)
    OnOptionInputOpenAnimations(option)
EndFunction

Function OnOptionInputOpenGeneral(int option)
    if option == UD_RandomFilter_T
        SetInputDialogStartText(Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0xFFFFFFFF))
    endif
EndFunction

Function OnOptionInputOpenAnimations(int option)

EndFunction

Function OnOptionInputAccept(int option, string value)
    OnOptionInputAcceptGeneral(option, value)
    OnOptionInputAcceptAnimations(option, value)
EndFunction

Function OnOptionInputAcceptGeneral(int option, string value)
    if(option == UD_RandomFilter_T)
        UDmain.UDRRM.UD_RandomDevice_GlobalFilter = Math.LogicalXor(value as Int,0xFFFFFFFF)
        SetInputOptionValue(UD_RandomFilter_T, Math.LogicalXor(UDmain.UDRRM.UD_RandomDevice_GlobalFilter,0xFFFFFFFF))
    endif
EndFunction

Function OnOptionInputAcceptAnimations(int option, string value)

EndFunction

event OnOptionSliderOpen(int option)
    OnOptionSliderOpenGeneral(option)
    OnOptionSliderOpenCustomBondage(option)
    OnOptionSliderOpenCustomOrgasm(option)
    OnOptionSliderOpenNPCs(option)
    OnOptionSliderOpenPatcher(option)
    OnOptionSliderOpenAbadon(option)
    OnOptionSliderOpenDebug(option)
    OnOptionSliderOpenUIWidget(option)
    OnOptionSliderOpenAnimations(option)
endEvent

Function OnOptionSliderOpenGeneral(int option)
    if (option == UD_LoggingLevel_S)
        SetSliderDialogStartValue(UDmain.LogLevel)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 3.0)
        SetSliderDialogInterval(1.0)    
    elseif option == UD_PrintLevel_S
        SetSliderDialogStartValue(UDmain.UD_PrintLevel)
        SetSliderDialogDefaultValue(3.0)
        SetSliderDialogRange(0.0, 3.0)
        SetSliderDialogInterval(1.0)  
    elseif option == UD_HearingRange_S
        SetSliderDialogStartValue(UDmain.UD_HearingRange)
        SetSliderDialogDefaultValue(UDmain.UD_HearingRange)
        SetSliderDialogRange(1000.0, 50000.0)
        SetSliderDialogInterval(500.0)
    endIf
EndFunction

Function OnOptionSliderOpenCustomBondage(int option)
    if (option == UD_UpdateTime_S)
        SetSliderDialogStartValue(UDCDmain.UD_UpdateTime)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(1.0, 15.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_CooldownMultiplier_S
        SetSliderDialogStartValue(Round(UDCDmain.UD_CooldownMultiplier*100))
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
        SetSliderDialogDefaultValue(35.0)
        SetSliderDialogRange(0.0, 1000.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_SkillEfficiency_S
        SetSliderDialogStartValue(UDCDmain.UD_SkillEfficiency)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 10.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_GagPhonemModifier_S
        SetSliderDialogStartValue(UDCDmain.UD_GagPhonemModifier)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_MinigameHelpCd_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameHelpCd)
        SetSliderDialogDefaultValue(60.0)
        SetSliderDialogRange(5.0, 60.0*24.0)
        SetSliderDialogInterval(5.0)
    elseif option == UD_MinigameHelpCD_PerLVL_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameHelpCD_PerLVL)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(1.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_MinigameHelpXPBase_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameHelpXPBase)
        SetSliderDialogDefaultValue(35.0)
        SetSliderDialogRange(5.0, 200.0)
        SetSliderDialogInterval(5.0)
    elseif option == UD_DeviceLvlHealth_S
        SetSliderDialogStartValue(UDCDmain.UD_DeviceLvlHealth*100)
        SetSliderDialogDefaultValue(2.5)
        SetSliderDialogRange(0.0, 25.0)
        SetSliderDialogInterval(0.5)
    elseif option == UD_DeviceLvlLockpick_S
        SetSliderDialogStartValue(UDCDmain.UD_DeviceLvlLockpick)
        SetSliderDialogDefaultValue(0.5)
        SetSliderDialogRange(0.0, 1.0)
        SetSliderDialogInterval(0.1)
    elseif option == UD_DeviceLvlLocks_S
        SetSliderDialogStartValue(UDCDmain.UD_DeviceLvlLocks)
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(0.0, 20.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_CritDurationAdjust_S
        SetSliderDialogStartValue(UDCDmain.UD_CritDurationAdjust)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(-0.5, 0.5)
        SetSliderDialogInterval(0.05)
    elseif option == UD_KeyDurability_S
        SetSliderDialogStartValue(UDCDmain.UD_KeyDurability)
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(0, 20)
        SetSliderDialogInterval(1)
    endif
EndFunction

Function OnOptionSliderOpenCustomOrgasm(int option)
    if (option == UD_OrgasmUpdateTime_S)
        SetSliderDialogStartValue(UDOM.UD_OrgasmUpdateTime)
        SetSliderDialogDefaultValue(0.5)
        SetSliderDialogRange(0.1, 2.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_HornyAnimationDuration_S)
        SetSliderDialogStartValue(Round(UDOM.UD_HornyAnimationDuration))
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(2.0,20.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_OrgasmResistence_S
        SetSliderDialogStartValue(UDOM.UD_OrgasmResistence)
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
    elseif option == UD_OrgasmArousalReduce_S
        SetSliderDialogStartValue(UDOM.UD_OrgasmArousalReduce)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(1.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_OrgasmArousalReduceDuration_S
        SetSliderDialogStartValue(UDOM.UD_OrgasmArousalReduceDuration)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(1.0, 30.0)
        SetSliderDialogInterval(1.0)
    endIf
EndFunction

Function OnOptionSliderOpenNPCs(int option)
    if (option == UD_AIUpdateTime_S)
        SetSliderDialogStartValue(UDAI.UD_UpdateTime)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(1.0, 30.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_AICooldown_S
        SetSliderDialogStartValue(UDAI.UD_AICooldown)
        SetSliderDialogDefaultValue(30.0)
        SetSliderDialogRange(5.0, 120.0)
        SetSliderDialogInterval(5.0)
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
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult * 100))
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
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(0.0,UDCDmain.UDPatcher.UD_MaxLocks)
        SetSliderDialogInterval(1.0)
    elseif option == UD_MaxLocks_S
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_MaxLocks)
        SetSliderDialogDefaultValue(2.0)
        SetSliderDialogRange(UDCDmain.UDPatcher.UD_MinLocks,30.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_MinResistMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_MinResistMult * 100))
        SetSliderDialogDefaultValue(-100.0)
        SetSliderDialogRange(-200.0,Round(UDCDmain.UDPatcher.UD_MaxResistMult * 100))
        SetSliderDialogInterval(10.0)
    elseif option == UD_MaxResistMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_MaxResistMult * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(Round(UDCDmain.UDPatcher.UD_MinResistMult * 100),200.0)
        SetSliderDialogInterval(10.0)
    elseif (option == UD_PatchMult_HeavyBondage_S)
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(30.0,300.0)
        SetSliderDialogInterval(10.0)
    elseif (option == UD_PatchMult_Blindfold_S)
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult_Blindfold * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(30.0,300.0)
        SetSliderDialogInterval(10.0)
    elseif (option == UD_PatchMult_Gag_S)
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult_Gag * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(30.0,300.0)
        SetSliderDialogInterval(10.0)
    elseif (option == UD_PatchMult_Hood_S)
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult_Hood * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(30.0,300.0)
        SetSliderDialogInterval(10.0)
    elseif (option == UD_PatchMult_ChastityBelt_S)
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(30.0,300.0)
        SetSliderDialogInterval(10.0)
    elseif (option == UD_PatchMult_ChastityBra_S)
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBra * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(30.0,300.0)
        SetSliderDialogInterval(10.0)
    elseif (option == UD_PatchMult_Plug_S)
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult_Plug * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(30.0,300.0)
        SetSliderDialogInterval(10.0)
    elseif (option == UD_PatchMult_Piercing_S)
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult_Piercing * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(30.0,300.0)
        SetSliderDialogInterval(10.0)
    elseif (option == UD_PatchMult_Generic_S)
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_PatchMult_Generic * 100))
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
        SetSliderDialogStartValue(UDOM.getActorOrgasmResist(slot.getActor()))
        SetSliderDialogDefaultValue(UDOM.UD_OrgasmResistence)
        SetSliderDialogRange(0.0, 10.0)
        SetSliderDialogInterval(0.1)
    elseif option == OrgasmCapacity_S
        UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(actorIndex)
        SetSliderDialogStartValue(UDOM.getActorOrgasmCapacity(slot.getActor()))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(10.0, 500.0)
        SetSliderDialogInterval(5.0)
    endIf
EndFunction

Function OnOptionSliderOpenUIWidget(Int option)
    If option == UD_TextFontSize_S
        SetSliderDialogStartValue(UDWC.UD_TextFontSize)
        SetSliderDialogDefaultValue(24.0)
        SetSliderDialogRange(16.0, 36.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_TextLineLength_S
        SetSliderDialogStartValue(UDWC.UD_TextLineLength)
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(50.0, 200.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_TextReadSpeed_S
        SetSliderDialogStartValue(UDWC.UD_TextReadSpeed)
        SetSliderDialogDefaultValue(20.0)
        SetSliderDialogRange(10.0, 50.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_IconsSize_S
        SetSliderDialogStartValue(UDWC.UD_IconsSize)
        SetSliderDialogDefaultValue(60.0)
        SetSliderDialogRange(40.0, 80.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_IconsPadding_S
        SetSliderDialogStartValue(UDWC.UD_IconsPadding)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(-200, 500.0)
        SetSliderDialogInterval(1.0)
    ElseIf option == UD_TextPadding_S
        SetSliderDialogStartValue(UDWC.UD_TextPadding)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(0.0, 300.0)
        SetSliderDialogInterval(1.0)
    EndIf
EndFunction

Function OnOptionSliderOpenAnimations(int option)
    if (option == UD_AlternateAnimationPeriod_S)
        SetSliderDialogStartValue(UDAM.UD_AlternateAnimationPeriod)
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(3.0, 15.0)
        SetSliderDialogInterval(1.0)
    endIf
EndFunction
    
event OnOptionSliderAccept(int option, float value)
    OnOptionSliderAcceptGeneral(option,value)
    OnOptionSliderAcceptCustomBondage(option, value)
    OnOptionSliderAcceptCustomOrgasm(option, value)
    OnOptionSliderAcceptNPCs(option, value)
    OnOptionSliderAcceptPatcher(option, value)
    OnOptionSliderAcceptAbadon(option, value)
    OnOptionSliderAcceptDebug(option,value)
    OnOptionSliderAcceptUIWidget(option,value)
    OnOptionSliderAcceptAnimations(option, value)
endEvent

Function OnOptionSliderAcceptGeneral(int option, float value)
    if (option == UD_LoggingLevel_S)
        UDmain.LogLevel = Round(value)
        SetSliderOptionValue(UD_LoggingLevel_S, UDmain.LogLevel, "{0}")
    elseif option == UD_PrintLevel_S
        UDmain.UD_PrintLevel = Round(value)
        SetSliderOptionValue(UD_PrintLevel_S, UDmain.UD_PrintLevel, "{0}")
    ;elseif option == UD_RandomFilter_T
    ;    UDmain.UDRRM.UD_RandomDevice_GlobalFilter =  Math.LogicalXor(round(value),0xFFFFFFFF)
    ;    SetSliderOptionValue(UD_RandomFilter_T, Round(value), "{0}")
    elseif option == UD_HearingRange_S
        UDmain.UD_HearingRange =  Round(value)
        SetSliderOptionValue(UD_HearingRange_S, UDmain.UD_HearingRange, "{0}")
    endIf
EndFunction

Function OnOptionSliderAcceptCustomBondage(int option, float value)
    if (option == UD_UpdateTime_S)
        UDCDmain.UD_UpdateTime = value
        SetSliderOptionValue(UD_UpdateTime_S, UDCDmain.UD_UpdateTime, "{0} s")
    elseif option == UD_CooldownMultiplier_S
        UDCDmain.UD_CooldownMultiplier = value/100
        SetSliderOptionValue(UD_CooldownMultiplier_S, Round(UDCDmain.UD_CooldownMultiplier*100), "{0} %")
    elseif (option == UD_LockpickMinigameNum_S)
        UDCDmain.UD_LockpicksPerMinigame = Math.floor(value + 0.5)
        SetSliderOptionValue(UD_LockpickMinigameNum_S, UDCDmain.UD_LockpicksPerMinigame, "{0}")
    elseif (option == UD_AutoCritChance_S)
        UDCDmain.UD_AutoCritChance = round(value)
        SetSliderOptionValue(UD_AutoCritChance_S, UDCDmain.UD_AutoCritChance, "{0} %")
    elseif (option == UD_BaseDeviceSkillIncrease_S)
        UDCDmain.UD_BaseDeviceSkillIncrease = round(value)
        SetSliderOptionValue(UD_BaseDeviceSkillIncrease_S, UDCDmain.UD_BaseDeviceSkillIncrease, "{0}")
    elseif option == UD_SkillEfficiency_S
        UDCDmain.UD_SkillEfficiency = round(value)
        SetSliderOptionValue(UD_SkillEfficiency_S, UDCDmain.UD_SkillEfficiency, "{0} %")
    elseif option == UD_GagPhonemModifier_S
        UDCDmain.UD_GagPhonemModifier = round(value)
        SetSliderOptionValue(UD_GagPhonemModifier_S, UDCDmain.UD_GagPhonemModifier, "{0}")
    elseif option == UD_MinigameHelpCd_S
        UDCDmain.UD_MinigameHelpCd = round(value)
        SetSliderOptionValue(UD_MinigameHelpCd_S, UDCDmain.UD_MinigameHelpCd, "{0} min")
    elseif option == UD_MinigameHelpCD_PerLVL_S
        UDCDmain.UD_MinigameHelpCD_PerLVL = Round(value)
        SetSliderOptionValue(UD_MinigameHelpCD_PerLVL_S, UDCDmain.UD_MinigameHelpCD_PerLVL, "{0} %")
    elseif option == UD_MinigameHelpXPBase_S
        UDCDmain.UD_MinigameHelpXPBase = round(value)
        SetSliderOptionValue(UD_MinigameHelpXPBase_S, UDCDmain.UD_MinigameHelpXPBase, "{0} XP")
    elseif option == UD_DeviceLvlHealth_S
        UDCDmain.UD_DeviceLvlHealth = value/100
        SetSliderOptionValue(UD_DeviceLvlHealth_S, UDCDmain.UD_DeviceLvlHealth*100, "{1} %")
    elseif option == UD_DeviceLvlLockpick_S
        UDCDmain.UD_DeviceLvlLockpick = value
        SetSliderOptionValue(UD_DeviceLvlLockpick_S, UDCDmain.UD_DeviceLvlLockpick, "{1}")
    elseif option == UD_DeviceLvlLocks_S
        UDCDmain.UD_DeviceLvlLocks = Round(value)
        SetSliderOptionValue(UD_DeviceLvlLocks_S, UDCDmain.UD_DeviceLvlLocks, "{0} LVLs")
    elseif option == UD_CritDurationAdjust_S
        UDCDmain.UD_CritDurationAdjust = value
        SetSliderOptionValue(UD_CritDurationAdjust_S, UDCDmain.UD_CritDurationAdjust, "{2} s")
    elseif option == UD_KeyDurability_S
        UDCDmain.UD_KeyDurability = Round(value)
        SetSliderOptionValue(UD_KeyDurability_S, UDCDmain.UD_KeyDurability, "{0}")
    endif
EndFunction

Function OnOptionSliderAcceptCustomOrgasm(int option, float value)
    if (option == UD_OrgasmUpdateTime_S)
        UDOM.UD_OrgasmUpdateTime = value
        SetSliderOptionValue(UD_OrgasmUpdateTime_S, UDOM.UD_OrgasmUpdateTime, "{1} s")
    elseif (option == UD_HornyAnimationDuration_S)
        UDOM.UD_HornyAnimationDuration = Round(value)
        SetSliderOptionValue(UD_HornyAnimationDuration_S, UDOM.UD_HornyAnimationDuration, "{0} s")
    elseif option == UD_OrgasmResistence_S
        UDOM.UD_OrgasmResistence = value
        SetSliderOptionValue(UD_OrgasmResistence_S, UDOM.UD_OrgasmResistence, "{1} Op/s")
    elseif option == UD_VibrationMultiplier_S
        UDCDmain.UD_VibrationMultiplier = value
        SetSliderOptionValue(UD_VibrationMultiplier_S, UDCDmain.UD_VibrationMultiplier, "{3}")
    elseif option == UD_ArousalMultiplier_S
        UDCDmain.UD_ArousalMultiplier = value
        SetSliderOptionValue(UD_ArousalMultiplier_S, UDCDmain.UD_ArousalMultiplier, "{3}")
    elseif option == UD_OrgasmArousalReduce_S
        UDOM.UD_OrgasmArousalReduce = Round(value)
        SetSliderOptionValue(UD_OrgasmArousalReduce_S, UDOM.UD_OrgasmArousalReduce, "{0} /s")
    elseif option == UD_OrgasmArousalReduceDuration_S
        UDOM.UD_OrgasmArousalReduceDuration = Round(value)
        SetSliderOptionValue(UD_OrgasmArousalReduceDuration_S, UDOM.UD_OrgasmArousalReduceDuration, "{0} s")
    endIf
EndFunction

Function OnOptionSliderAcceptNPCs(int option, float value)
    if (option == UD_AIUpdateTime_S)
        UDAI.UD_UpdateTime = Round(value)
        SetSliderOptionValue(UD_AIUpdateTime_S, UDAI.UD_UpdateTime, "{0} s")
    elseif option == UD_AICooldown_S
        UDAI.UD_AICooldown = Round(value)
        SetSliderOptionValue(UD_AICooldown_S, UDAI.UD_AICooldown, "{0} min")
    endIf
EndFunction

Function OnOptionSliderAcceptPatcher(int option, float value)
    int loc_value = Round(value)
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
        SetSliderOptionValue(UD_PatchMult_S, Round(UDCDmain.UDPatcher.UD_PatchMult * 100), "{0} %")
    elseif (option == UD_EscapeModifier_S)
        UDCDmain.UDPatcher.UD_EscapeModifier = Round(value)
        SetSliderOptionValue(UD_EscapeModifier_S, UDCDmain.UDPatcher.UD_EscapeModifier, "{0}")
    elseif option == UD_MinLocks_S
        UDCDmain.UDPatcher.UD_MinLocks = Round(value)
        SetSliderOptionValue(UD_MinLocks_S, UDCDmain.UDPatcher.UD_MinLocks, "{0}")
    elseif option == UD_MaxLocks_S
        UDCDmain.UDPatcher.UD_MaxLocks = Round(value)
        SetSliderOptionValue(UD_MaxLocks_S, UDCDmain.UDPatcher.UD_MaxLocks, "{0}")
    elseif option == UD_MinResistMult_S
        UDCDmain.UDPatcher.UD_MinResistMult = value/100.0
        SetSliderOptionValue(UD_MinResistMult_S, Round(UDCDmain.UDPatcher.UD_MinResistMult * 100), "{0} %")
    elseif option == UD_MaxResistMult_S
        UDCDmain.UDPatcher.UD_MaxResistMult = value/100.0
        SetSliderOptionValue(UD_MaxResistMult_S, Round(UDCDmain.UDPatcher.UD_MaxResistMult * 100), "{0} %")
    elseif (option == UD_PatchMult_HeavyBondage_S)
        UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage = value/100.0
        SetSliderOptionValue(UD_PatchMult_HeavyBondage_S, Round(UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage * 100), "{0} %")
    elseif (option == UD_PatchMult_Blindfold_S)
        UDCDmain.UDPatcher.UD_PatchMult_Blindfold = value/100.0
        SetSliderOptionValue(UD_PatchMult_Blindfold_S, Round(UDCDmain.UDPatcher.UD_PatchMult_Blindfold * 100), "{0} %")
    elseif (option == UD_PatchMult_Gag_S)
        UDCDmain.UDPatcher.UD_PatchMult_Gag = value/100.0
        SetSliderOptionValue(UD_PatchMult_Gag_S, Round(UDCDmain.UDPatcher.UD_PatchMult_Gag * 100), "{0} %")
    elseif (option == UD_PatchMult_Hood_S)
        UDCDmain.UDPatcher.UD_PatchMult_Hood = value/100.0
        SetSliderOptionValue(UD_PatchMult_Hood_S, Round(UDCDmain.UDPatcher.UD_PatchMult_Hood * 100), "{0} %")
    elseif (option == UD_PatchMult_ChastityBelt_S)
        UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt = value/100.0
        SetSliderOptionValue(UD_PatchMult_ChastityBelt_S, Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt * 100), "{0} %")
    elseif (option == UD_PatchMult_ChastityBra_S)
        UDCDmain.UDPatcher.UD_PatchMult_ChastityBra = value/100.0
        SetSliderOptionValue(UD_PatchMult_ChastityBra_S, Round(UDCDmain.UDPatcher.UD_PatchMult_ChastityBra * 100), "{0} %")
    elseif (option == UD_PatchMult_Plug_S)
        UDCDmain.UDPatcher.UD_PatchMult_Plug = value/100.0
        SetSliderOptionValue(UD_PatchMult_Plug_S, Round(UDCDmain.UDPatcher.UD_PatchMult_Plug * 100), "{0} %")
    elseif (option == UD_PatchMult_Piercing_S)
        UDCDmain.UDPatcher.UD_PatchMult_Piercing = value/100.0
        SetSliderOptionValue(UD_PatchMult_Piercing_S, Round(UDCDmain.UDPatcher.UD_PatchMult_Piercing * 100), "{0} %")
    elseif (option == UD_PatchMult_Generic_S)
        UDCDmain.UDPatcher.UD_PatchMult_Generic = value/100.0
        SetSliderOptionValue(UD_PatchMult_Generic_S, Round(UDCDmain.UDPatcher.UD_PatchMult_Generic * 100), "{0} %")
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
        UDOM.setActorOrgasmResist(slot.getActor(),value)
        SetSliderOptionValue(OrgasmResist_S, UDOM.GetActorOrgasmResist(slot.getActor()), "{1}")
    elseif option == OrgasmCapacity_S
        UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(actorIndex)
        UDOM.setActorOrgasmCapacity(slot.getActor(),value)
        SetSliderOptionValue(OrgasmCapacity_S, UDOM.GetActorOrgasmCapacity(slot.getActor()), "{0}")        
    endIf
EndFunction

Function OnOptionSliderAcceptUIWidget(Int option, Float value)
    If option == UD_TextFontSize_S
        UDWC.UD_TextFontSize = value as Int
        SetSliderOptionValue(UD_TextFontSize_S, value)
    ElseIf option == UD_TextLineLength_S
        UDWC.UD_TextLineLength = value as Int
        SetSliderOptionValue(UD_TextLineLength_S, value)
    ElseIf option == UD_TextReadSpeed_S
        UDWC.UD_TextReadSpeed = value as Int
        SetSliderOptionValue(UD_TextReadSpeed_S, value)
    ElseIf option == UD_IconsSize_S
        UDWC.UD_IconsSize = value as Int
        SetSliderOptionValue(UD_IconsSize_S, value)
    ElseIf option == UD_IconsPadding_S
        UDWC.UD_IconsPadding = value as Int
        SetSliderOptionValue(UD_IconsPadding_S, value)
    ElseIf option == UD_TextPadding_S
        UDWC.UD_TextPadding = value as Int
        SetSliderOptionValue(UD_TextPadding_S, value)
    EndIf
EndFunction

Function OnOptionSliderAcceptAnimations(int option, float value)
    if option == UD_AlternateAnimationPeriod_S
        UDAM.UD_AlternateAnimationPeriod = (value As Int)
        SetSliderOptionValue(UD_AlternateAnimationPeriod_S, value, "{0} s")
    endIf
EndFunction

event OnOptionMenuOpen(int option)
    OnOptionMenuOpenDefault(option)
    OnOptionMenuOpenCustomBondage(option)
    OnOptionMenuOpenCustomOrgasm(option)
    OnOptionMenuOpenAbadon(option)
    OnOptionMenuOpenUIWidget(option)
    OnOptionMenuOpenAnimations(option)
endEvent

Function OnOptionMenuOpenDefault(int option)
EndFUnction

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
        SetMenuDialogOptions(AbadonQuest.UD_AbadonSuitNames)
        SetMenuDialogStartIndex(AbadonQuest.final_finisher_pref)
        SetMenuDialogDefaultIndex(0)
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
    elseif option == UD_CritEffect_M
        SetMenuDialogOptions(criteffectList)
        SetMenuDialogStartIndex(UDCDmain.UD_CritEffect)
        SetMenuDialogDefaultIndex(2)
    endif
EndFunction

Function OnOptionMenuOpenCustomOrgasm(int option)
    if (option == UD_OrgasmAnimation_M)
        SetMenuDialogOptions(orgasmAnimation)
        SetMenuDialogStartIndex(UDOM.UD_OrgasmAnimation)
        SetMenuDialogDefaultIndex(0)
    endif
EndFunction


Function OnOptionMenuOpenUIWidget(int option)
    if (option == UD_IconsAnchor_M)
        SetMenuDialogOptions(UD_IconsAnchorList)
        SetMenuDialogStartIndex(UDWC.UD_IconsAnchor)
        SetMenuDialogDefaultIndex(1)
    ElseIf (option == UD_TextAnchor_M)
        SetMenuDialogOptions(UD_TextAnchorList)
        SetMenuDialogStartIndex(UDWC.UD_TextAnchor)
        SetMenuDialogDefaultIndex(1)
    ElseIf (option == UD_IconVariant_EffExhaustion_M)
        SetMenuDialogOptions(UD_IconVariant_EffExhaustionList)
        Int variant = UDWC.StatusEffect_GetVariant("effect-exhaustion")
        If variant < 0 || variant >= UD_IconVariant_EffExhaustionList.Length
            variant = 0
        EndIf
        SetMenuDialogStartIndex(variant)
        SetMenuDialogDefaultIndex(0)
    ElseIf (option == UD_IconVariant_EffOrgasm_M)
        SetMenuDialogOptions(UD_IconVariant_EffOrgasmList)
        Int variant = UDWC.StatusEffect_GetVariant("effect-orgasm")
        If variant < 0 || variant >= UD_IconVariant_EffOrgasmList.Length
            variant = 0
        EndIf
        SetMenuDialogStartIndex(variant)
        SetMenuDialogDefaultIndex(0)
    elseif (option == UD_WidgetPosX_M)
        SetMenuDialogOptions(widgetXList)
        SetMenuDialogStartIndex(UDWC.UD_WidgetXPos)
        SetMenuDialogDefaultIndex(1)
    elseif (option == UD_WidgetPosY_M)
        SetMenuDialogOptions(widgetYList)
        SetMenuDialogStartIndex(UDWC.UD_WidgetYPos)
        SetMenuDialogDefaultIndex(1)
    endif
EndFunction

Function OnOptionMenuOpenAnimations(Int option)
    If option == UDAM_TestQuery_Type_M
        SetMenuDialogOptions(UDAM_TestQuery_Type_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_Type_Index)
        SetMenuDialogDefaultIndex(1)
    ElseIf option == UDAM_TestQuery_Keyword_M
        SetMenuDialogOptions(UDAM_TestQuery_Keyword_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_Keyword_Index)
        SetMenuDialogDefaultIndex(0)
    ElseIf option == UDAM_TestQuery_PlayerArms_M
        SetMenuDialogOptions(UDAM_TestQuery_PlayerArms_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_PlayerArms_Index)
        SetMenuDialogDefaultIndex(0)
    ElseIf option == UDAM_TestQuery_PlayerLegs_M
        SetMenuDialogOptions(UDAM_TestQuery_PlayerLegs_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_PlayerLegs_Index)
        SetMenuDialogDefaultIndex(0)
    ElseIf option == UDAM_TestQuery_HelperArms_M
        SetMenuDialogOptions(UDAM_TestQuery_PlayerArms_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_HelperArms_Index)
        SetMenuDialogDefaultIndex(0)
    ElseIf option == UDAM_TestQuery_HelperLegs_M
        SetMenuDialogOptions(UDAM_TestQuery_PlayerLegs_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_HelperLegs_Index)
        SetMenuDialogDefaultIndex(0)
    EndIf
EndFunction

event OnOptionMenuAccept(int option, int index)
    OnOptionMenuAcceptDefault(option,index)
    OnOptionMenuAcceptCustomBondage(option,index)
    OnOptionMenuAcceptCustomOrgasm(option,index)
    OnOptionMenuAcceptAbadon(option, index)
    OnOptionMenuAcceptUIWidget(option, index)
    OnOptionMenuAcceptAnimations(option, index)
endEvent

Function OnOptionMenuAcceptDefault(int option, int index)
EndFunction

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
        SetMenuOptionValue(final_finisher_pref_M, AbadonQuest.UD_AbadonSuitNames[AbadonQuest.final_finisher_pref])
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
    elseif option == UD_CritEffect_M
        UDCDmain.UD_CritEffect = index
        SetMenuOptionValue(UD_CritEffect_M, criteffectList[UDCDmain.UD_CritEffect])
        forcePageReset()
    endIf
EndFunction

Function OnOptionMenuAcceptCustomOrgasm(int option, int index)
    if (option == UD_OrgasmAnimation_M)
        UDOM.UD_OrgasmAnimation = index
        SetMenuOptionValue(UD_OrgasmAnimation_M, orgasmAnimation[UDOM.UD_OrgasmAnimation])
    endIf
EndFunction

Function OnOptionMenuAcceptUIWidget(Int option, Int index)
    if option == UD_IconsAnchor_M && index >= 0 && index < 3
        UDWC.UD_IconsAnchor = index
        SetMenuOptionValue(UD_IconsAnchor_M, UD_IconsAnchorList[index])
    ElseIf option == UD_TextAnchor_M && index >= 0 && index < 4
        UDWC.UD_TextAnchor = index
        SetMenuOptionValue(UD_TextAnchor_M, UD_TextAnchorList[index])
    ElseIf (option == UD_IconVariant_EffExhaustion_M)
        UDWC.StatusEffect_Register("effect-exhaustion", -1, index)
        SetMenuOptionValue(UD_IconVariant_EffExhaustion_M, UD_IconVariant_EffExhaustionList[index])
    ElseIf (option == UD_IconVariant_EffOrgasm_M)
        UDWC.StatusEffect_Register("effect-orgasm", -1, index)
        SetMenuOptionValue(UD_IconVariant_EffOrgasm_M, UD_IconVariant_EffOrgasmList[index])
    elseif (option == UD_WidgetPosX_M)
        UDWC.UD_WidgetXPos = index
        SetMenuOptionValue(UD_WidgetPosX_M, widgetXList[UDWC.UD_WidgetXPos])
        forcePageReset()
    elseif (option == UD_WidgetPosY_M)
        UDWC.UD_WidgetYPos = index
        SetMenuOptionValue(UD_WidgetPosY_M, widgetYList[UDWC.UD_WidgetYPos])
        forcePageReset()
    endif
EndFunction

Function OnOptionMenuAcceptAnimations(Int option, Int index)
    If option == UDAM_TestQuery_Type_M
        UDAM_TestQuery_Type_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_Type_List[index])
        Int helper_flags = OPTION_FLAG_NONE
        If index == 0
            helper_flags = OPTION_FLAG_DISABLED
        EndIf
        SetOptionFlags(UDAM_TestQuery_HelperArms_M, helper_flags)
        SetOptionFlags(UDAM_TestQuery_HelperLegs_M, helper_flags)
        SetOptionFlags(UDAM_TestQuery_HelperMittens_T, helper_flags)
        SetOptionFlags(UDAM_TestQuery_HelperGag_T, helper_flags)
    ElseIf option == UDAM_TestQuery_Keyword_M
        UDAM_TestQuery_Keyword_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_Keyword_List[index])
    ElseIf option == UDAM_TestQuery_PlayerArms_M
        UDAM_TestQuery_PlayerArms_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_PlayerArms_List[index])
    ElseIf option == UDAM_TestQuery_PlayerLegs_M
        UDAM_TestQuery_PlayerLegs_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_PlayerLegs_List[index])
    ElseIf option == UDAM_TestQuery_HelperArms_M
        UDAM_TestQuery_HelperArms_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_PlayerArms_List[index])
    ElseIf option == UDAM_TestQuery_HelperLegs_M
        UDAM_TestQuery_HelperLegs_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_PlayerLegs_List[index])
    EndIf
EndFunction

bool Function checkMinigameKeyConflict(int iKeyCode)
    bool loc_res = true
    loc_res = loc_res && CheckButton(iKeyCode)
    loc_res = loc_res && (iKeyCode != UDCDmain.Stamina_meter_Keycode)
    loc_res = loc_res && (iKeyCode != UDCDmain.Magicka_meter_Keycode)
    loc_res = loc_res && (iKeyCode != UDCDmain.SpecialKey_Keycode)
    return loc_res
EndFunction

bool Function checkGeneralKeyConflict(int iKeyCode)
    bool loc_res = true
    loc_res = loc_res && CheckButton(iKeyCode)
    loc_res = loc_res && (iKeyCode != UDCDmain.StruggleKey_Keycode)
    loc_res = loc_res && (iKeyCode != UDCDmain.PlayerMenu_KeyCode)
    loc_res = loc_res && (iKeyCode != UDCDmain.ActionKey_Keycode)
    loc_res = loc_res && (iKeyCode != UDCDmain.NPCMenu_Keycode)
    return loc_res
EndFunction

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
    if (option == UD_StruggleKey_K)
        if checkGeneralKeyConflict(keyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.StruggleKey_Keycode)
            UDCDmain.StruggleKey_Keycode = keyCode
            SetKeyMapOptionValue(UD_StruggleKey_K, UDCDmain.StruggleKey_Keycode)
            UDmain.UDUI.RegisterForKey(UDCDmain.StruggleKey_Keycode)
        endif
    elseif (option == UD_ActionKey_K)
        if checkGeneralKeyConflict(keyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.ActionKey_Keycode)
            UDCDmain.ActionKey_Keycode = keyCode
            UDmain.UDUI.RegisterForKey(UDCDmain.ActionKey_Keycode)
            SetKeyMapOptionValue(UD_ActionKey_K, UDCDmain.ActionKey_Keycode)
        endif
    elseif option == UD_PlayerMenu_K
        if checkGeneralKeyConflict(keyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.PlayerMenu_KeyCode)
            UDCDmain.PlayerMenu_KeyCode = keyCode
            SetKeyMapOptionValue(UD_PlayerMenu_K, UDCDmain.PlayerMenu_KeyCode)
            UDmain.UDUI.RegisterForKey(UDCDmain.PlayerMenu_KeyCode)
        endif
    elseif option == UD_NPCMenu_K
        if checkGeneralKeyConflict(keyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.NPCMenu_Keycode)
            UDCDmain.NPCMenu_Keycode = keyCode
            SetKeyMapOptionValue(UD_NPCMenu_K, UDCDmain.NPCMenu_Keycode)
            UDmain.UDUI.RegisterForKey(UDCDmain.NPCMenu_Keycode)
        endif
    elseif (option == UD_CHB_Stamina_meter_Keycode_K)
        if checkMinigameKeyConflict(keyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.Stamina_meter_Keycode)
            UDCDmain.Stamina_meter_Keycode = keyCode
            UDmain.UDUI.RegisterForKey(UDCDmain.Stamina_meter_Keycode)
            SetKeyMapOptionValue(UD_CHB_Stamina_meter_Keycode_K, UDCDmain.Stamina_meter_Keycode)
        endif
    elseif (option == UD_CHB_Magicka_meter_Keycode_K)
        if checkMinigameKeyConflict(keyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.Magicka_meter_Keycode)
            UDCDmain.Magicka_meter_Keycode = keyCode
            UDmain.UDUI.RegisterForKey(UDCDmain.Magicka_meter_Keycode)
            SetKeyMapOptionValue(UD_CHB_Magicka_meter_Keycode_K, UDCDmain.Magicka_meter_Keycode)
        endif
    elseif (option == UDCD_SpecialKey_Keycode_K)
        if checkMinigameKeyConflict(keyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.SpecialKey_Keycode)
            UDCDmain.SpecialKey_Keycode = keyCode
            UDmain.UDUI.RegisterForKey(UDCDmain.SpecialKey_Keycode)
            SetKeyMapOptionValue(UDCD_SpecialKey_Keycode_K, UDCDmain.SpecialKey_Keycode)
        endif
    elseif (option == UD_GamepadKey_K)
        if checkGeneralKeyConflict(keyCode)
            UDmain.UDUI.UnRegisterForKey(UDmain.UDUI.UD_GamepadKey)
            UDmain.UDUI.UD_GamepadKey = keyCode
            UDmain.UDUI.RegisterForKey(UDmain.UDUI.UD_GamepadKey)
            SetKeyMapOptionValue(UD_GamepadKey_K, UDmain.UDUI.UD_GamepadKey)
        endif
    endIf
endEvent


;=========================================
;             DEFAULT VALUES..............
;=========================================
Event OnOptionDefault(int option)
    if (_lastPage == "General")
        GeneralPageDefault(option)
    elseif (_lastPage == "Device filter")
        ;FilterPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "Abadon Plug")
        ;AbadanPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "Custom Devices")
        ;CustomBondagePageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "Custom orgasm")
        ;CustomOrgasmPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == UD_NPCsPageName)
        NPCsPageDefault(option)
    elseif (_lastPage == "Patcher")
        ;PatcherPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "DD patch")
        ;DDPatchPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "Debug panel")
        ;DebugPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "Other")
    elseif (_lastPage == "Animations")
        ; AnimationPageDefault(option)  ; copy-paste, where did you take me?!
    endif
EndEvent

Function GeneralPageDefault(int option)
    if(option == lockmenu_T)
        UDmain.lockMCM = false
        SetToggleOptionValue(lockmenu_T, UDmain.lockMCM)
    elseif(option == UD_ActionKey_K)
        if !Game.UsingGamepad()
            UDCDMain.ActionKey_Keycode = 18
        else
            UDCDMain.ActionKey_Keycode = 279
        endif
        SetKeyMapOptionValue(UD_ActionKey_K, UDCDMain.ActionKey_Keycode)
    elseif(option == UD_StruggleKey_K)
        if !Game.UsingGamepad()
            UDCDMain.StruggleKey_Keycode = 52
        else
            UDCDMain.StruggleKey_Keycode = 275
        endif
        SetKeyMapOptionValue(UD_StruggleKey_K, UDCDMain.StruggleKey_Keycode)
    elseif(option == UD_hightPerformance_T)
        UDmain.UD_hightPerformance = true
        SetToggleOptionValue(UD_hightPerformance_T, UDmain.UD_hightPerformance)
    elseif(option == UD_debugmod_T)
        UDmain.DebugMod = false
        SetToggleOptionValue(UD_debugmod_T, UDmain.DebugMod)
    elseif option == UD_HearingRange_S
        UDmain.UD_HearingRange = 4000
        SetSliderOptionValue(UD_HearingRange_S, UDmain.UD_HearingRange)
    elseif option == UD_WarningAllowed_T
        UDmain.UD_WarningAllowed = false
        SetToggleOptionValue(UD_WarningAllowed_T, UDmain.UD_WarningAllowed)
    elseif option == UD_PrintLevel_S
        UDmain.UD_PrintLevel = 3
        SetSliderOptionValue(UD_PrintLevel_S, UDmain.UD_PrintLevel)
    elseif(option == UD_PlayerMenu_K)
        if !Game.UsingGamepad()
            UDCDMain.PlayerMenu_KeyCode = 40
        else
            UDCDMain.PlayerMenu_KeyCode = 268
        endif
        SetKeyMapOptionValue(UD_PlayerMenu_K, UDCDMain.PlayerMenu_KeyCode)
    elseif(option == UD_NPCMenu_K)
        if !Game.UsingGamepad()
            UDCDMain.NPCMenu_Keycode = 39
        else
            UDCDMain.NPCMenu_Keycode = 269
        endif
        SetKeyMapOptionValue(UD_NPCMenu_K, UDCDMain.NPCMenu_Keycode)
    elseif(option == UD_LoggingLevel_S)
        UDmain.LogLevel = 0
        SetSliderOptionValue(UD_LoggingLevel_S, UDmain.LogLevel)
    elseif option == UD_LockDebugMCM_T
        UDmain.UD_LockDebugMCM = false
        SetToggleOptionValue(UD_LockDebugMCM_T, UDmain.UD_LockDebugMCM)
    elseif option == UD_EasyGamepadMode_T
        UDUI.UD_EasyGamepadMode = false
        SetToggleOptionValue(UD_EasyGamepadMode_T, UDUI.UD_EasyGamepadMode)
    Endif
EndFunction

Function FilterPageDefault(int option)
    if(option == UD_UseArmCuffs_T)
        SetInfoText("Toggle if arm cuffs are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseBelts_T)
        SetInfoText("Toggle if chastity belts are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseBlindfolds_T)
        SetInfoText("Toggle if blindfolds are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseBoots_T)
        SetInfoText("Toggle if boots are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseBras_T)
        SetInfoText("Toggle if chastity bras are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseCollars_T)
        SetInfoText("Toggle if collars are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseCorsets_T)
        SetInfoText("Toggle if corsets are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseGags_T)
        SetInfoText("Toggle if gags are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseGloves_T)
        SetInfoText("Toggle if gloves are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseHarnesses_T)
        SetInfoText("Toggle if harnesses are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseHeavyBondage_T)
        SetInfoText("Toggle if heavy bondage are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseHoods_T)
        SetInfoText("Toggle if hoods are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseLegCuffs_T)
        SetInfoText("Toggle if leg cuffs are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UsePiercingsNipple_T)
        SetInfoText("Toggle if nipple piercings are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UsePiercingsVaginal_T)
        SetInfoText("Toggle if clitoral piercings are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UsePlugsAnal_T)
        SetInfoText("Toggle if anal plugs are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UsePlugsVaginal_T)
        SetInfoText("Toggle if vaginal plugs are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseSuits_T)
        SetInfoText("Toggle if suits are allowed to be equipped by this mod. Default: TRUE")
    elseif option == UD_RandomFilter_T ;this option will be deleted
        SetInfoText("Set random restraint filter. This is bitcoded value. Normally no need to use it instead of checkboxes. For more info check LL or GitHub. Default: 0")
    endif
EndFunction

Function CustomBondagePageDefault(int option)
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
        SetInfoText("Toggle hardcore swimming. If on, player will have hard time swimming with tied hands. This works for any devices, not only for devices from this mod. Slow will be applied on player and stamina will start to decrease. Once all stamina is consumed, player will be slowed even further and health will start to decrease too.")
    elseif(option == UD_hardcore_swimming_difficulty_M)
        SetInfoText("Difficulty of swimming with tied hands. The harder the difficulty, the more stamina and health will be drained. Player will also be more slowed.")
    elseif option == UD_WidgetPosX_M
        SetInfoText("Change widget X position\nDefault: Right")
    elseif option == UD_WidgetPosY_M
        SetInfoText("Change widget Y position\nDefault: Down")
    elseif option == UD_LockpickMinigameNum_S
        SetInfoText("Change number of lockpicks player can use in lockpick minigame.\nDefault: 2")
    elseif option == UD_BaseDeviceSkillIncrease_S
        SetInfoText("How many skill points are acquired for second of struggling.\nDefault: 35")
    elseif option == UD_SkillEfficiency_S
        SetInfoText("How many percents is minigame easier per skill point\nExample: If Strength skill is 50 and efficiency is 1%, desperate minigame will be 50% more powerful\nDefault: 1 %")
    elseif option == UD_AutoCrit_T
        SetInfoText("Toggle auto crit. Auto crit will crit instead of user. Use this if you don't like crits or you can't crit for some other reason.\nDefault: OFF")
    elseif option == UD_AutoCritChance_S
        SetInfoText("Chance that auto crit will result in successfull crit.\nDefault: 80%")
    elseif option == UD_CritEffect_M
        SetInfoText("Effect used to indicate that crit is happening.\n[HUD] HUD will blink when crit is happening\n[Body shader] Actor body will have shader applied for short time\n[HUD + Body shader] Both of the previous effects combined\nDefault: [HUD + Body shader]")
    elseif option == UD_CooldownMultiplier_S
        SetInfoText("Change how big the devices cooldowns are. The bigger the value the longer they will be.\nExamle: 200% makes all devices cooldown two times longer.\nDefault: 100%")
    elseif option == UD_HardcoreMode_T
        SetInfoText("Hardcore mode disables most game features when players hands are tied up, to emulate the helpless feeling\n*Disables Inventory, Magic Menu and Fast travel (Map still works)\nTween menu is disabled, pressing it will open list of devices\nStats and Map can only be opened with key\nDefault: OFF")
    elseif option == UD_AllowArmTie_T
        SetInfoText("Toggle Arm tie active effect from Arm cuffs. Toogling this off will prevent effect from activating.\nDefault: ON")
    elseif option == UD_AllowLegTie_T
        SetInfoText("Toggle Leg tie active effect from Leg cuffs. Toogling this off will prevent effect from activating.\nDefault: ON")
    elseif option == UD_MinigameHelpCd_S
        SetInfoText("Base cooldown which activates after one character helps another character. Character can't help others while on cooldown\nDefault: 60 minutes")
    elseif option == UD_MinigameHelpCD_PerLVL_S
        SetInfoText("By how many % will base cooldown reduce per Helper LVL\nDefault: 10 %")
    elseif option == UD_MinigameHelpXPBase_S
        SetInfoText("How much helper XP will character get after helping others.\nXP Formula: XPNEEDED = LVL*100*1.03^LVL\nDefault: 35 XP")
    elseif option == UDCD_SpecialKey_Keycode_K
        SetInfoText("Key that progress key mashing minigame, like cutting or forcing out plug.")
    elseif option == UD_DeviceLvlHealth_S
        SetInfoText("How much will device durability be increased per device level.\nNote: This will only affect max value, not current value.\nDefault: 2.5%")
    elseif option == UD_DeviceLvlLockpick_S
        SetInfoText("How much will lockpick difficulty increase per device level.\nDefault: 0.5")
    elseif option == UD_PreventMasterLock_T
        SetInfoText("Prevent devices from having locks with master difficulty\nDefault: OFF")
    elseif option == UD_DeviceLvlLocks_S
        SetInfoText("How many levels are needed for number of maximum locks to increase.Setting this to 0 will disable Lock level scaling\nExample: If this is 5, and device have level 10, maximum level will be increased by 2\nDefault: 5")
    elseif option == UD_MandatoryCrit_T
        SetInfoText("When this option is enabled, not landing crits will punish player\nDefault: OFF")
    elseif option == UD_CritDurationAdjust_S
        SetInfoText("By how much time will be crit duration changed. Setting this to small negative value might make crits impossible.\nIn case you are experiencing bigger lags when using UD, you may need to increase this value to make crits easier.\nDefault: 0.0 s")
    elseif option == UD_KeyDurability_S
        UDCDmain.UD_KeyDurability = 5
        SetSliderOptionValue(UD_KeyDurability_S, UDCDmain.UD_KeyDurability, "{0}")
    elseif option == UD_HardcoreAccess_T
        UDCDmain.UD_HardcoreAccess = False
        SetToggleOptionValue(UD_HardcoreAccess_T, UDCDmain.UD_HardcoreAccess)
    Endif
EndFunction

Function CustomOrgasmPageDefault(int option)
    if     option == UD_OrgasmUpdateTime_S
        SetInfoText("Update time for orgasm checking (how fast is orgasm widget updated). Is only used for player.\n Default: 0.2s")
    elseif option == UD_UseOrgasmWidget_T
        SetInfoText("Toggle orgasm progress widget\nDefault: ON")
    elseif option == UD_OrgasmResistence_S
        SetInfoText("Defines how much orgasm rate is required for actor to orgasm. If orgasm rate is less than this, orgasm progress will stop before 100%. Also changes how fast is orgasm progress reduced for every update.\nDefault: 2.0")
    elseif option == UD_HornyAnimation_T
        SetInfoText("Toggle if random horny animation can play while orgasm rate is bigger than 0\nDefault: YES")
    elseif option == UD_HornyAnimationDuration_S
        SetInfoText("Duration of random horny animation\nDefault: 5 s")
    elseif option == UD_VibrationMultiplier_S
        SetInfoText("Constant for calculating Orgasm rate from Vibration strength. Example: If this value is 0.1 and vibrator strength is 100, resulting Orgasm rate is 10\nDefault: 0.1 s")
    elseif option == UD_ArousalMultiplier_S
        SetInfoText("Constant for calculating Arousal rate from Vibration strength. Example: If this value is 0.025 and vibrator strength is 100, resulting Arousal rate is 2.5\nDefault: 0.025 s")
    elseif option == UD_OrgasmArousalReduce_S
        SetInfoText("Post-orgasm amount of arousal that will removed from actor per second\nDefault: 25 Arousal/s")
    elseif option == UD_OrgasmArousalReduceDuration_S
        SetInfoText("Duration of post-orgasm effect\nDefault: 7 seconds")
    elseif(option == UD_OrgasmExhaustion_T)
        SetInfoText("Adds debuff to player on orgasm. This debuff reduces stamina and magicka regeneration for short time. This effect is applied as on DD orgasm as on Sexlab scene orgasm.")
    Endif
EndFunction

Function NPCsPageDefault(int option)
    if option == UD_AIEnable_T
        UDAI.Enabled = True
        SetToggleOptionValue(UD_AIEnable_T, UDAI.Enabled)
    elseif     option == UD_AIUpdateTime_S
        UDAI.UD_UpdateTime = 10
        SetSliderOptionValue(UD_AIUpdateTime_S, UDAI.UD_UpdateTime)
    elseif option == UD_AICooldown_S
        UDAI.UD_AICooldown = 30
        SetSliderOptionValue(UD_AICooldown_S, UDAI.UD_AICooldown)
    elseif (option == UD_NPCSupport_T)
        UDmain.AllowNPCSupport = false
        SetToggleOptionValue(UD_NPCSupport_T, UDmain.AllowNPCSupport)
    Endif
EndFunction

Function PatcherPageDefault(int option)
    if  option == UD_PatchMult_S
        SetInfoText("Sets patching multiplier. The more this value the harder will be patched devices.\nDefault: 100%")
    elseif option == UD_MAOChanceMod_S
        SetInfoText("Sets Orgasm manifest (MAO) chance multiplier. Bigger the value, the more likely will patched device have MAO modifier\nExample: If patcher have set value of 8% of adding this modifier to device and this value will be 50%, result chance is 4%.\nDefault: 100%")
    elseif option == UD_MAHChanceMod_S
        SetInfoText("Sets Hour manifest (MAH) chance multiplier. Bigger the value, the more likely will patched device have MAH modifier\nExample: If patcher have set value of 8% of adding this modifier to device and this value will be 50%, result chance is 4%.\nDefault: 100%")
    elseif option == UD_MAOMod_S
        SetInfoText("Sets Orgasm manifest (MAO) multiplier. Bigger the value, the more likely will device manifest when actor orgasms.\nExample: If device have manifest 50% and this value will be 50%, result chance is 25%.\nDefault: 100%")
    elseif option == UD_MAHMod_S
        SetInfoText("Sets Hour manifest (MAH) multiplier. Bigger the value, the more likely will device manifest every hour.\nExample: If device have manifest 50% and this value will be 50%, result chance is 25%.\nDefault: 100%")
    elseif option == UD_EscapeModifier_S
        SetInfoText("Sets escape modifier. Escape modifier determinates how patched device DPS is calculated. Default formula is DDEscapeChance/EscapeModifier = DPS\n Example: if this is 10 and to be patched device have escape chance 10%, resulting base DPS will be 1.0\nDefault: 10")
    elseif option == UD_MinLocks_S
        SetInfoText("Minimum number of lock shields that device can get by patcher\nDefault: 0")
    elseif option == UD_MaxLocks_S
        SetInfoText("Maximum number of lock shields that device can get by patcher\nDefault: 2")
    elseif option == UD_MinResistMult_S
        SetInfoText("Minimum sum of both resistances (Physical + Magical). If their sum is smaller than this value, one of the resists will be increased so the total sum is this number. The smaller this number will be, the smaller device resistances will be (device is easier)\nDefault: -100%")
    elseif option == UD_MaxResistMult_S
        SetInfoText("Maximum sum of both resistances (Physical + Magical). If their sum is bigger than this value, one of the resists will be reduced so the total sum is this number. The bigger this number will be, the bigger device resistance will be (device is harder)\nDefault: 100%")
    elseif option == UD_MaxResistMult_S
    endif
EndFunction

Function AbadanPageDefault(int option)
    ;dear mother of god
    if (option == dmg_heal_T)
        SetInfoText("Toggle if plug should sap health from player on Orgasm,Edge or Vib")
    elseif (option == UseAnalVariant_T)
        SetInfoText("Toggle if Anal plug will be used instead of vaginal plug. This switch is used only for Abadon Curse quest and gets disabled after reading the letter from courier.")
    elseif(option == dmg_stamina_T)
        SetInfoText("Toggle if plug should sap stamina from player on Orgasm,Edge or Vib")
    elseif(option == dmg_magica_T)
        SetInfoText("Toggle if plug should sap magicka from player on Orgasm,Edge or Vib")
    elseif(option == hardcore_T)
        SetInfoText("Toggle Hardcore mod.\n This makes it possible for plug to kill you. Otherwise the plug will only sap your health to 1")
    elseif (option == difficulty_M)
        SetInfoText("Select plug difficulty. This changes how much health,stamina and magica is sapped from player")
    elseif (option == preset_M)
        SetInfoText("Overall setting preset. If you want to change values to your liking, then select custom preset")
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
        SetInfoText("Set equipped when player equip plug.")
    endIf
EndFunction

Function DDPatchPageDefault(int option)
    if  option == UD_DAR_T
        SetInfoText("Toggle DAR compatibility. Please read more about it in changelog on LL\nDefault: OFF")
    elseif option == UD_GagPhonemModifier_S
        SetInfoText("Gag modifier which change gag expression for simple gag to better fit mouth. Not used if DD beta 7 is installed\nDefault: 0")
    elseif option == UD_OutfitRemove_T
        SetInfoText("Prevent NPC outfit from being removed when hand restraint is locked on. Removing outfit can by default cause compatibility issue with NPC overhaul mods. This will obviously prevent NPC from being naked until player undresses them\nDefault: True")
    elseif option == UD_OrgasmAnimation_M
        SetInfoText("List of orgasm animations.\nNormal = Normal orgasm animations by  DD\nExtended = Orgasm animations + horny animations\nDefault: Normal")
    elseif option == UD_AllowMenBondage_T
        SetInfoText("Allow use of DD devices on men.\nDevious Devices For Him required.\nDefault: False")
    elseif option == UD_CheckAllKw_T
        SetInfoText("!!EXPERIMENTAL FEATURE!!\nWhen enabled, Lock/Unlock devices will use patched functions which doesn't check ID script devious keyword, but instead all keywords on RD. This way, framework should somehow work when processing devices which have multiple major keywords on RD (for example when some catsuit would have both belt and suit keyword)\nDefault: OFF")
    endif
EndFunction

Function DebugPageDefault(int option)
    ;dear mother of god
    if (option == rescanSlots_T)
        SetInfoText("Rescan all slots with nearby npcs. This is only way to fill slots if Auto scan is turned off.")
    elseif option == fixBugs_T
        SetInfoText("Apply some fixes for selected slot.\n-Resets orgasm check loop\n-Removes lost devices\n-Removes copies\n-Removes unused devices\n-Resets minigame states")
    elseif option == unlockAll_T
        SetInfoText("Unlock all currently REGISTERED devices")
    elseif option == endAnimation_T
        SetInfoText("End animation for currently slotted npc")
    elseif option == unregisterNPC_T
        SetInfoText("Unregister NPC slot all its devices. This will not unlock any devices.")
    elseif option == OrgasmCapacity_S
        SetInfoText("Change registered NPC's orgasm capacity. This changes how fast the actor will reach orgasm.\nDefault: 100")
    elseif option == OrgasmResist_S
        SetInfoText("Change registered NPC orgasm resistance.This change how fast will actor reach orgasm AND if actor will reach orgasm at all.\nDefault: Set in MCM (Custom Orgasm tab)")
    endIf
EndFunction

Function AnimationPageDefault(Int option)
    If option == UD_AlternateAnimation_T
        SetInfoText("Enabling this will force struggle animation to randomly switch to different animation periodically\nDefault: OFF")
    EndIf
EndFunction
;=========================================
;                 INFO.      .............
;=========================================
Event OnOptionHighlight(int option)
    if (_lastPage == "General")
        GeneralPageInfo(option)
    elseif (_lastPage == "Device filter")
        FilterPageInfo(option)
    elseif (_lastPage == "Abadon Plug")
        AbadanPageInfo(option)
    elseif (_lastPage == "Custom Devices")
         CustomBondagePageInfo(option)
    elseif (_lastPage == "Custom orgasm")
        CustomOrgasmPageInfo(option)
    elseif (_lastPage == UD_NPCsPageName)
        NPCsPageInfo(option)
    elseif (_lastPage == "Patcher")
        PatcherPageInfo(option)
    elseif (_lastPage == "DD patch")
        DDPatchPageInfo(option)
    elseif (_lastPage == "UI/Widgets")
        UiWidgetPageInfo(option)
    elseif (_lastPage == "Debug panel")
        DebugPageInfo(option)
    elseif (_lastPage == "Other")
    
    elseif (_lastPage == "Animations")
        AnimationPageInfo(option)
    endif
EndEvent

Function GeneralPageInfo(int option)
    if(option == lockmenu_T)
        SetInfoText("Disable MCM when any Unforgiving device is equipped")
    elseif(option == UD_ActionKey_K)
        SetInfoText("Current use: Stops struggling")
    elseif(option == UD_StruggleKey_K)
        SetInfoText("Current use: Starts struggling")
    elseif(option == UD_hightPerformance_T)
        SetInfoText("High performance mod will decrease update time. This will make struggle game more smooth and also less buggy.")
    elseif(option == UD_debugmod_T)
        SetInfoText("Toggle debug mod. Debug mod shows more information for devices from this mod.")
    elseif option == UD_HearingRange_S
        SetInfoText("Actor needs to be in this range from player so user receives actor specific messages (like that some device starts vibratin, other do something else etc...)\n Default: 4000\n(4000 is around the distance of one big hallway. 500 is next to player.)")
    elseif option == UD_WarningAllowed_T
        SetInfoText("Toggle Warning console messages.\nDefault: OFF")
    elseif option == UD_PrintLevel_S
        SetInfoText("Message level for notifications which show to user. The lower this value is, the less messages will appear in top left. 0 will disable all messages\nDefault: 3")
    elseif(option == UD_PlayerMenu_K)
        SetInfoText("Current use: Opens player menu")
    elseif(option == UD_NPCMenu_K)
        SetInfoText("Current use: Opens NPC menu for NPC that player is currently looking at")
    elseif(option == UD_LoggingLevel_S)
        SetInfoText("Sets logging level. By default logging is turned off, as it can have noticable performance impact. Changing this to 3 will trace aeverything. 1 will Trace only the most important information.\n Default: 0")
    elseif option == UD_LockDebugMCM_T
        SetInfoText("Disable MCM Debug panel if player have any Unforigivng Device equipped. Only active if \"Lock menus\" is also enabled")
    elseif option == UD_EasyGamepadMode_T
        SetInfoText("Toggle Easy Gamepad Mode. While in this mode, only the Gamepad button is usable. This button will open menu with all options that are opened by other buttons.\nDefault: OFF")
    Endif
EndFunction

Function FilterPageInfo(int option)
    if(option == UD_UseArmCuffs_T)
        SetInfoText("Toggle if arm cuffs are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseBelts_T)
        SetInfoText("Toggle if chastity belts are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseBlindfolds_T)
        SetInfoText("Toggle if blindfolds are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseBoots_T)
        SetInfoText("Toggle if boots are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseBras_T)
        SetInfoText("Toggle if chastity bras are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseCollars_T)
        SetInfoText("Toggle if collars are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseCorsets_T)
        SetInfoText("Toggle if corsets are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseGags_T)
        SetInfoText("Toggle if gags are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseGloves_T)
        SetInfoText("Toggle if gloves are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseHarnesses_T)
        SetInfoText("Toggle if harnesses are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseHeavyBondage_T)
        SetInfoText("Toggle if heavy bondage are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseHoods_T)
        SetInfoText("Toggle if hoods are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseLegCuffs_T)
        SetInfoText("Toggle if leg cuffs are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UsePiercingsNipple_T)
        SetInfoText("Toggle if nipple piercings are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UsePiercingsVaginal_T)
        SetInfoText("Toggle if clitoral piercings are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UsePlugsAnal_T)
        SetInfoText("Toggle if anal plugs are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UsePlugsVaginal_T)
        SetInfoText("Toggle if vaginal plugs are allowed to be equipped by this mod. Default: TRUE")
    elseif(option == UD_UseSuits_T)
        SetInfoText("Toggle if suits are allowed to be equipped by this mod. Default: TRUE")
    elseif option == UD_RandomFilter_T ;this option will be deleted
        SetInfoText("Set random restraint filter. This is bitcoded value. Normally no need to use it instead of checkboxes. For more info check LL or GitHub. Default: 0")
    endif
EndFunction

Function CustomBondagePageInfo(int option)
    if(option == UD_CHB_Stamina_meter_Keycode_K)
        SetInfoText("Key to crit device while struggling when stamina bar blinks")
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
        SetInfoText("Difficulty of swimming with tied hands. The harder the difficulty, the more stamina and health will be drained. Player will also be more slowed.")
    elseif option == UD_LockpickMinigameNum_S
        SetInfoText("Change number of lockpicks player can use in lockpick minigame.\nDefault: 2")
    elseif option == UD_BaseDeviceSkillIncrease_S
        SetInfoText("How many skill points are acquired for second of struggling.\nDefault: 35")
    elseif option == UD_SkillEfficiency_S
        SetInfoText("How many percents is minigame easier per skill point\nExample: If Strength skill is 50 and efficiency is 1%, desperate minigame will be 50% more powerful\nDefault: 1 %")
    elseif option == UD_AutoCrit_T
        SetInfoText("Toggle auto crit. Auto crit will crit instead of user. Use this if you don't like crits or you can't crit for some other reason.\nDefault: OFF")
    elseif option == UD_AutoCritChance_S
        SetInfoText("Chance that auto crit will result in successfull crit.\nDefault: 80%")
    elseif option == UD_CritEffect_M
        SetInfoText("Effect used to indicate that crit is happening.\n[HUD] HUD will blink when crit is happening\n[Body shader] Actor body will have shader applied for short time\n[HUD + Body shader] Both of the previous effects combined\nDefault: [HUD + Body shader]")
    elseif option == UD_CooldownMultiplier_S
        SetInfoText("Change how big the devices cooldowns are. The bigger the value the longer they will be.\nExamle: 200% makes all devices cooldown two times longer.\nDefault: 100%")
    elseif option == UD_HardcoreMode_T
        SetInfoText("Hardcore mode disables most game features when players hands are tied up, to emulate the helpless feeling\n*Disables Inventory, Magick Menu and Fast travel (Map still works)\nTween menu is disabled, pressing it will open list of devices\nStats and Map can only be opened with key\nDefault: OFF")
    elseif option == UD_AllowArmTie_T
        SetInfoText("Toggle Arm tie active effect from Arm cuffs. Toggling this off will prevent effect from activating.\nDefault: ON")
    elseif option == UD_AllowLegTie_T
        SetInfoText("Toggle Leg tie active effect from Leg cuffs. Toggling this off will prevent effect from activating.\nDefault: ON")
    elseif option == UD_MinigameHelpCd_S
        SetInfoText("Base cooldown which activates after one character helps another character. Character can't help others while on cooldown\nDefault: 60 minutes")
    elseif option == UD_MinigameHelpCD_PerLVL_S
        SetInfoText("By how many % will base cooldown reduce per Helper LVL\nDefault: 10 %")
    elseif option == UD_MinigameHelpXPBase_S
        SetInfoText("How any XP will character get after helping others.\nXP Formula: XPNEEDED = LVL*100*1.03^LVL\nDefault: 35 XP")
    elseif option == UDCD_SpecialKey_Keycode_K
        SetInfoText("Key that progresses key smashing minigame, like cutting or forcing out plug.")
    elseif option == UD_DeviceLvlHealth_S
        SetInfoText("How much will device durability be increased per device level.\nNote: This will only affect max value, not current value.\nDefault: 2.5%")
    elseif option == UD_DeviceLvlLockpick_S
        SetInfoText("How much will lockpick difficulty increase per device level.\nDefault: 0.5")
    elseif option == UD_PreventMasterLock_T
        SetInfoText("Prevent devices from having locks with master difficulty\nDefault: OFF")
    elseif option == UD_DeviceLvlLocks_S
        SetInfoText("How many levels are needed for number of maximum locks to increase.Setting this to 0 will disable Lock level scaling\nExample: If this is 5, and device have level 10, maximum level will be increased by 2\nDefault: 5")
    elseif option == UD_MandatoryCrit_T
        SetInfoText("When this option is enabled, not landing crits will punish player\nDefault: OFF")
    elseif option == UD_CritDurationAdjust_S
        SetInfoText("By how much time will be crit duration changed. Setting this to small negative value might make crits impossible.\nIn case you are experiencing bigger lags when using UD, you might increase this value to make crits easier.\nDefault: 0.0 s")
    elseif option == UD_KeyDurability_S
        SetInfoText("How many times can be key used to unlock the restrains lock before it gets destroyed. Set this to 0 to make keys indestructible\nDefault: 5")
    elseif option == UD_HardcoreAccess_T
        SetInfoText("Toggling this on will make all devices with accessibility less then 90% inaccessible\nDefault: False")
    Endif
EndFunction

Function CustomOrgasmPageInfo(int option)
    if     option == UD_OrgasmUpdateTime_S
        SetInfoText("Update time for orgasm checking (how fast is orgasm widget updated). Is only used for player.\n Default: 0.2s")
    elseif option == UD_UseOrgasmWidget_T
        SetInfoText("Toggle orgasm progress widget\nDefault: ON")
    elseif option == UD_OrgasmResistence_S
        SetInfoText("Defines how much orgasm rate is required for actor to orgasm. If orgasm rate is less than this, orgasm progress will stop before 100%. Also changes how fast is orgasm progress reduced for every update.\nDefault: 2.0")
    elseif option == UD_HornyAnimation_T
        SetInfoText("Toogle if random horny animation can play while orgasm rate is bigger than 0\nDefault: YES")
    elseif option == UD_HornyAnimationDuration_S
        SetInfoText("Duration of random horny animation\nDefault: 5 s")
    elseif option == UD_VibrationMultiplier_S
        SetInfoText("Constant for calculating Orgasm rate from Vibration strength. Example: If this value is 0.1 and vibrator strength is 100, resulting Orgasm rate is 10\nDefault: 0.1 s")
    elseif option == UD_ArousalMultiplier_S
        SetInfoText("Constant for calculating Arousal rate from Vibration strength. Example: If this value is 0.025 and vibrator strength is 100, resulting Arousal rate is 2.5\nDefault: 0.025 s")
    elseif option == UD_OrgasmArousalReduce_S
        SetInfoText("Post-orgasm amount of arousal that will removed from actor per second\nDefault: 25 Arousal/s")
    elseif option == UD_OrgasmArousalReduceDuration_S
        SetInfoText("Duration of post-orgasm effect\nDefault: 7 seconds")
    elseif(option == UD_OrgasmExhaustion_T)
        SetInfoText("Adds debuff to player on orgasm. This debuff reduces stamina and magicka regeneration for short time. This effect is applied as on DD orgasm as on Sexlab scene orgasm.")
    Endif
EndFunction

Function NPCsPageInfo(int option)
    if (option == UD_NPCSupport_T)
        SetInfoText("Toogle automatic scaning\nDefault: OFF")
    elseif option == UD_AIEnable_T
        SetInfoText("Enable/Disable NPCs AI. When enabled, NPCs will try to escape the devices on their own. Only applies for registered NPCs\n Default: ON")
    elseif option == UD_AIUpdateTime_S
        SetInfoText("How offten will slotted NPCs AI be checked. Default value should be sufficient\n Default: 10 s")
    elseif option == UD_AICooldown_S
        SetInfoText("Base cooldown for NPC Ai. AI can only try to escape device on this time have passed (in-game time). This value is further affected by motivation of NPC\n Default: 30 minutes") 
    Endif
EndFunction

Function PatcherPageInfo(int option)
    if  option == UD_PatchMult_S
        SetInfoText("Sets patching multiplier. The more this value is the harder the patched devices will be.\nDefault: 100%")
    elseif option == UD_MAOChanceMod_S
        SetInfoText("Sets Orgasm manifest (MAO) chance multiplier. Bigger the value, the more likely will patched device have MAO modifier\nExample: If patcher have set value of 8% of adding this modifier to device and this value will be 50%, result chance is 4%.\nDefault: 100%")
    elseif option == UD_MAHChanceMod_S
        SetInfoText("Sets Hour manifest (MAH) chance multiplier. Bigger the value, the more likely will patched device have MAH modifier\nExample: If patcher have set value of 8% of adding this modifier to device and this value will be 50%, result chance is 4%.\nDefault: 100%")
    elseif option == UD_MAOMod_S
        SetInfoText("Sets Orgasm manifest (MAO) multiplier. Bigger the value, the more likely will device manifest when actor orgasms.\nExample: If device have manifest 50% and this value will be 50%, result chance is 25%.\nDefault: 100%")
    elseif option == UD_MAHMod_S
        SetInfoText("Sets Hour manifest (MAH) multiplier. Bigger the value, the more likely will device manifest every hour.\nExample: If device have manifest 50% and this value will be 50%, result chance is 25%.\nDefault: 100%")
    elseif option == UD_EscapeModifier_S
        SetInfoText("Sets escape modifier. Escape modifier determinates how patched device DPS is calculated. Default formalu is DDEscapeChance/EscapeModifier = DPS\n Example: if this is 10 and to be patched device have escape chance 10%, resulting base DPS will be 1.0\n So basically, the bigger this value is, the harder will patched device be to be escaped by struggle minigames\nDefault: 10")
    elseif option == UD_MinLocks_S
        SetInfoText("Minimum number of locks which device can get by patcher\nDefault: 1")
    elseif option == UD_MaxLocks_S
        SetInfoText("Maximum number of locks which device can get by patcher\nDefault: 1")
    elseif option == UD_MinResistMult_S
        SetInfoText("Minimum sum of both resistances (Physical + Magical). If their sum is smaller than this value, one of the resists will be increased so the total sum is this number. The smaller this number will be, the smaller device resistances will be (device is easier)\nDefault: -100%")
    elseif option == UD_MaxResistMult_S
        SetInfoText("Maximum sum of both resistances (Physical + Magical). If their sum is bigger than this value, one of the resists will be reduced so the total sum is this number. The bigger this number will be, the bigger device resistance will be (device is harder)\nDefault: 100%")
    elseif option == UD_MaxResistMult_S
    endif
EndFunction

Function AbadanPageInfo(int option)
    ;dear mother of god
    if (option == dmg_heal_T)
        SetInfoText("Toggle if plug should sap health from player on Orgasm,Edge or Vib")
    elseif (option == UseAnalVariant_T)
        SetInfoText("Toggle if Anal plug will be used instead of vaginal plug. This switch is used only for Abadon Curse quest and gets disabled after reading the letter from courier.")
    elseif(option == dmg_stamina_T)
        SetInfoText("Toggle if plug should sap stamina from player on Orgasm,Edge or Vib")
    elseif(option == dmg_magica_T)
        SetInfoText("Toggle if plug should sap magicka from player on Orgasm,Edge or Vib")
    elseif(option == hardcore_T)
        SetInfoText("Toggle Hardcore mod.\n This makes it possible for plug to kill you. Otherwise the plug will only sap your health to 1")
    elseif (option == difficulty_M)
        SetInfoText("Select plug difficulty. This changes how much health,stamina and magica is sapped from player")
    elseif (option == preset_M)
        SetInfoText("Overall setting preset. If you want to change values to your liking, then select custom preset")
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
        SetInfoText("Set equipped when player equip plug.")
    endIf
EndFunction

Function DDPatchPageInfo(int option)
    if  option == UD_DAR_T
        SetInfoText("Toggle DAR compatibility. Please read more about it in changelog on LL\nDefault: OFF")
    elseif option == UD_GagPhonemModifier_S
        SetInfoText("Gag modifier which change gag expression for simple gag to better fit mouth. Not used if DD beta 7 is installed\nDefault: 0")
    elseif option == UD_OutfitRemove_T
        SetInfoText("Prevent NPC outfit from being removed when hand restraint is locked on. Removing outfit can by default cause compatibility issue with NPC overhaul mods. This will obviously prevent NPC from being naked until player undress them\nDefault: True")
    elseif option == UD_AllowMenBondage_T
        SetInfoText("Allow use of DD devices on men.\nDevious Devices For Him required.\nDefault: False")
    elseif option == UD_OrgasmAnimation_M
        SetInfoText("List of orgasm animations.\nNormal = Normal orgasm animation by  DD\nExtended = Orgasm animation + horny animations\nDefault: Normal")
    elseif option == UD_CheckAllKw_T
        SetInfoText("!!EXPERIMENTAL FEATURE!!\nWhen enabled, Lock/Unlock devices will use patched functions which doesn't check ID script devious keyword, but instead all keywords on RD. This way, framework should somehow work when processing devices which have multiple major keywords on RD (for example when some catsuit would have both belt and suit keywords)\nDefault: OFF")
    endif
EndFunction

Function UiWidgetPageInfo(int option)
    if  option == UD_AutoAdjustWidget_T
        SetInfoText("Toggle auto adjust for iWantWidget widgets. If ON, it will cause widgets to get rearranged every time they are shown/hidden. This make it more compact, but also slower. \nDefault: OFF")
    elseif option == UD_UseIWantWidget_T
        SetInfoText("Toggle if iWantWidget should be used instead of currect widget implementation. Only works if iWW is installed\n!!IMPORTANT: After changing this value, you will have to save and reload the game, otherwise the changes will not be applied!!\nDefault: ON")
    elseif option == UD_UseWidget_T
        SetInfoText("Shows widget in minigame that shows current relevant value. Not all minigames will show widget because they may not use them.")
    elseif option == UD_WidgetPosX_M
        SetInfoText("Change widget X position\nDefault: Right")
    elseif option == UD_WidgetPosY_M
        SetInfoText("Change widget Y position\nDefault: Down")
    ElseIf option == UD_TextFontSize_S
        SetInfoText("Notification text font size.\nDefault: 24")
    ElseIf option == UD_TextLineLength_S
        SetInfoText("Notification text line length.\nDefault: 100")
    ElseIf option == UD_TextReadSpeed_S
        SetInfoText("Notification text read speed (symbols per second). How fast notification will disappear.\nDefault: 20")
    ElseIf option == UD_FilterVibNotifications_T
        SetInfoText("Toggle to hide notifications from vibrators.\nDefault: ON")
    ElseIf option == UD_EnableCNotifications_S
        SetInfoText("Toggle to enable customized text notifications.\nDefault: ON")
    ElseIf option == UD_EnableDeviceIcons_T
        SetInfoText("Toggle to enable icons for 'installed' devious devices.\nDefault: ON")
    ElseIf option == UD_EnableDebuffIcons_T
        SetInfoText("Toggle to enable icons for UD (de)buffs.\nDefault: ON")
    ElseIf option == UD_IconsSize_S
        SetInfoText("Icon size.\nDefault: 60")
    ElseIf option == UD_IconsAnchor_M
        SetInfoText("Base positions of the icons cluster.\nDefault: CENTER")
    ElseIf option == UD_IconsPadding_S
        SetInfoText("Horizontal offset of the icons cluster relative to its base position.\nDefault: 0")
    ElseIf option == UD_TextAnchor_M
        SetInfoText("Base positions of the notifications.\nDefault: BELLOW CENTER")
    ElseIf option == UD_TextPadding_S
        SetInfoText("Vertical offset of the notifications relative to its base position.\nDefault: 0")
    ElseIf option == UD_WidgetTest_T
        SetInfoText("Press to view all widgets on screen (they dissappear after 5 seconds)")
    ElseIf option == UD_WidgetReset_T
        SetInfoText("Press to reset UI.\nATTENTION: It also resets all effects magnitudes and modifiers! If you have active effects or devices icons then they may not display correctly!")
    endif
EndFunction

Function DebugPageInfo(int option)
    ;dear mother of god
    if (option == rescanSlots_T)
        SetInfoText("Rescan all slots with nearby npcs. This is only way to fill slots if Auto scan is turned off.")
    elseif option == fixBugs_T
        SetInfoText("Apply some fixes for selected slot.\n-Resets orgasm check loop\n-Removes lost devices\n-Removes copies\n-Removes unused devices\n-Resets minigame states")
    elseif option == unlockAll_T
        SetInfoText("Unlock all currently REGISTERED devices")
    elseif option == endAnimation_T
        SetInfoText("End animation for currently sloted npc")
    elseif option == unregisterNPC_T
        SetInfoText("Unregister whole slot. This will not unlock any devices.")
    elseif option == OrgasmCapacity_S
        SetInfoText("Change registered NPC orgasm capacity.This change how fast will actor reach orgasm.\nDefault: 100")
    elseif option == OrgasmResist_S
        SetInfoText("Change registered NPC orgasm resistance.This change how fast will actor reach orgasm AND if actor will reach orgasm at all.\nDefault: Set in MCM (Custom Orgasm tab)")
    endIf
EndFunction

Function AnimationPageInfo(Int option)
    If (option >= UDAM_AnimationJSON_First_T) && (option <= (UDAM_AnimationJSON_First_T + (UDAM.UD_AnimationJSON_All.Length - 1) * 2)) && (((option - UDAM_AnimationJSON_First_T) % 2) == 0)
        SetInfoText("Toggle file to be loaded into animation pull. Use Reload option to apply changes.")
    ElseIf option == UDAM_Reload_T
        SetInfoText("Click to reload all files from the disk. Unchecked files will be ignored. These settings are persisted through saves.")
    elseif option == UD_AlternateAnimation_T
        SetInfoText("Enabling this will force struggle animation to randomly switch to different animation periodically\nDefault: OFF")
    elseif option == UD_UseSingleStruggleKeyword_T
        SetInfoText("If this option is enabled, then only one (defining) device keyword will be used when filtering the struggle animation. Otherwise, all suitable keywords will be applied.\nDefault: ON")
    elseif option == UD_AlternateAnimationPeriod_S
        SetInfoText("Animation is picked from an array of suitable ones with a given period.\nDefault: 5 sec")
    ElseIf option == UDAM_TestQuery_Request_T
        SetInfoText("Request animations with specified conditions")
    ElseIf option == UDAM_TestQuery_StopAnimation_T
        SetInfoText("You can try to stop the animation. No guarantees!")
    ElseIf option == UDAM_TestQuery_ElapsedTime_T
        SetInfoText("")
    ElseIf (option >= UDAM_TestQuery_Results_First_T) && (option <= (UDAM_TestQuery_Results_First_T + (UDAM_TestQuery_Results.Length - 1) * 2)) && (((option - UDAM_TestQuery_Results_First_T) % 2) == 0)
        SetInfoText("FOR DEBUG ONLY! It is impossible to stop the animation, only switch to another one.")
    ElseIf option == UD_Helper_T
        SetInfoText("Put crosshair on actor to set it as helper in animation")
    EndIf
EndFunction
;=========================================
;                 OTHER.     .............
;=========================================

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
    JsonUtil.SetIntValue(strFile, "AutoLoad", UDmain.UD_AutoLoad as int)
    JsonUtil.SetIntValue(strFile, "LogLevel", UDmain.LogLevel as int)
    JsonUtil.SetIntValue(strFile, "HearingRange", UDmain.UD_HearingRange)
    JsonUtil.SetIntValue(strFile, "WarningAllowed", UDmain.UD_WarningAllowed as Int)
    JsonUtil.SetIntValue(strFile, "PrintLevel", UDmain.UD_PrintLevel)
    JsonUtil.SetIntValue(strFile, "LockDebug", UDmain.UD_LockDebugMCM as Int)
    JsonUtil.SetIntValue(strFile, "EasyGamepadMode", UDUI.UD_EasyGamepadMode as Int)
    JsonUtil.SetIntValue(strFile, "AllKeywordCheck",UDmain.UD_CheckAllKw as Int)

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
    JsonUtil.SetFloatValue(strFile, "OrgasmResistence", UDOM.UD_OrgasmResistence)
    JsonUtil.SetIntValue(strFile, "LockpicksPerMinigame", UDCDmain.UD_LockpicksPerMinigame as Int)
    JsonUtil.SetIntValue(strFile, "UseOrgasmWidget", UDOM.UD_UseOrgasmWidget as Int)
    JsonUtil.SetFloatValue(strFile, "OrgasmUpdateTime", UDOM.UD_OrgasmUpdateTime)
    JsonUtil.SetIntValue(strFile, "OrgasmAnimation", UDOM.UD_OrgasmAnimation)
    JsonUtil.SetIntValue(strFile, "HornyAnimation", UDOM.UD_HornyAnimation as Int)
    JsonUtil.SetIntValue(strFile, "HornyAnimationDuration", UDOM.UD_HornyAnimationDuration)
    JsonUtil.SetFloatValue(strFile, "CooldownMultiplier", UDCDmain.UD_CooldownMultiplier)
    JsonUtil.SetIntValue(strFile, "SkillEfficiency", UDCDmain.UD_SkillEfficiency)
    JsonUtil.SetIntValue(strFile, "CritEffect", UDCDmain.UD_CritEffect)
    JsonUtil.SetIntValue(strFile, "HardcoreMode", UDCDmain.UD_HardcoreMode as Int)
    JsonUtil.SetIntValue(strFile, "AllowArmTie", UDCDmain.UD_AllowArmTie as Int)
    JsonUtil.SetIntValue(strFile, "AllowLegTie", UDCDmain.UD_AllowLegTie as Int)
    JsonUtil.SetIntValue(strFile, "MinigameHelpCD", UDCDmain.UD_MinigameHelpCd)
    JsonUtil.SetIntValue(strFile, "MinigameHelpCD_PerLVL", Round(UDCDmain.UD_MinigameHelpCD_PerLVL))
    JsonUtil.SetIntValue(strFile, "MinigameHelpXPBase", UDCDmain.UD_MinigameHelpXPBase)
    JsonUtil.SetFloatValue(strFile, "DeviceLvlHealth", UDCDMain.UD_DeviceLvlHealth*100)
    JsonUtil.SetFloatValue(strFile, "DeviceLvlLockpick", UDCDMain.UD_DeviceLvlLockpick)
    JsonUtil.SetIntValue(strFile, "DeviceLvlLocks", UDCDMain.UD_DeviceLvlLocks)
    JsonUtil.SetIntValue(strFile, "PreventMasterLock", UDCDmain.UD_PreventMasterLock as Int)
    JsonUtil.SetIntValue(strFile, "PostOrgasmArousalReduce", UDOM.UD_OrgasmArousalReduce)
    JsonUtil.SetIntValue(strFile, "PostOrgasmArousalReduce_Duration", UDOM.UD_OrgasmArousalReduceDuration)
    JsonUtil.SetIntValue(strFile, "MandatoryCrit", UDCDmain.UD_MandatoryCrit as Int)
    JsonUtil.SetFloatValue(strFile, "CritDurationAdjust", UDCDmain.UD_CritDurationAdjust)
    JsonUtil.SetIntValue(strFile, "KeyDurability", UDCDmain.UD_KeyDurability)
    JsonUtil.SetIntValue(strFile, "HardcoreAccess", UDCDmain.UD_HardcoreAccess as Int)
    
    ;ABADON
    JsonUtil.SetIntValue(strFile, "AbadonForceSet", AbadonQuest.final_finisher_set as Int)
    JsonUtil.SetIntValue(strFile, "AbadonForceSetPref", AbadonQuest.final_finisher_pref as Int)
    JsonUtil.SetIntValue(strFile, "AbadonUseAnalVariant", AbadonQuest.UseAnalVariant as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugPreset", preset as Int)
    JsonUtil.SetFloatValue(strFile, "AbadonPlugMaxDifficulty", AbadonQuest.max_difficulty)
    JsonUtil.SetIntValue(strFile, "AbadonPlugOverallDifficulty", AbadonQuest.overaldifficulty as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugEventChanceMod", AbadonQuest.eventchancemod as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugLittleFinisherChance", AbadonQuest.little_finisher_chance as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugMinOrgasmLittleFinisher", AbadonQuest.min_orgasm_little_finisher as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugMaxOrgasmLittleFinisher", AbadonQuest.max_orgasm_little_finisher as Int)
    JsonUtil.SetFloatValue(strFile, "AbadonPlugLittleFinisherCooldown", AbadonQuest.little_finisher_cooldown)
    JsonUtil.SetIntValue(strFile, "AbadonPlugDmgHeal", AbadonQuest.dmg_heal as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugDmgMagicka", AbadonQuest.dmg_magica as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugDmgStamina", AbadonQuest.dmg_stamina as Int)
    JsonUtil.SetIntValue(strFile, "AbadonPlugHardcore", AbadonQuest.hardcore as Int)

    ;PATCHER
    JsonUtil.SetIntValue(strFile, "MAOChanceMod", UDCDmain.UDPatcher.UD_MAOChanceMod)
    JsonUtil.SetIntValue(strFile, "MAOMod", UDCDmain.UDPatcher.UD_MAOMod)
    JsonUtil.SetIntValue(strFile, "MAHChanceMod", UDCDmain.UDPatcher.UD_MAHChanceMod)
    JsonUtil.SetIntValue(strFile, "MAHMod", UDCDmain.UDPatcher.UD_MAHMod)
    JsonUtil.SetIntValue(strFile, "EscapeModifier", UDCDmain.UDPatcher.UD_EscapeModifier)
    JsonUtil.SetIntValue(strFile, "MinLocks", UDCDmain.UDPatcher.UD_MinLocks)
    JsonUtil.SetIntValue(strFile, "MaxLocks", UDCDmain.UDPatcher.UD_MaxLocks)
    JsonUtil.SetIntValue(strFile, "MinResist", Round(UDCDmain.UDPatcher.UD_MinResistMult*100))
    JsonUtil.SetIntValue(strFile, "MaxResist", Round(UDCDmain.UDPatcher.UD_MaxResistMult*100))
    JsonUtil.SetFloatValue(strFile, "PatchMult", UDCDmain.UDPatcher.UD_PatchMult)
    JsonUtil.SetFloatValue(strFile, "PatchMult_HeavyBondage"    , UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Blindfold"        , UDCDmain.UDPatcher.UD_PatchMult_Blindfold)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Gag"                , UDCDmain.UDPatcher.UD_PatchMult_Gag)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Hood"            , UDCDmain.UDPatcher.UD_PatchMult_Hood)
    JsonUtil.SetFloatValue(strFile, "PatchMult_ChastityBelt"    , UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt)
    JsonUtil.SetFloatValue(strFile, "PatchMult_ChastityBra"        , UDCDmain.UDPatcher.UD_PatchMult_ChastityBra)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Plug"            , UDCDmain.UDPatcher.UD_PatchMult_Plug)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Piercing"        , UDCDmain.UDPatcher.UD_PatchMult_Piercing)
    JsonUtil.SetFloatValue(strFile, "PatchMult_Generic"            , UDCDmain.UDPatcher.UD_PatchMult_Generic)
    
    ;UI/WIDGET
    JsonUtil.SetIntValue(strFile, "AutoAdjustWidget", UDWC.UD_AutoAdjustWidget as Int)
    JsonUtil.SetIntValue(strFile, "UseIWantWidget", UDWC.UD_UseIWantWidget as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_EnableDeviceIcons", UDWC.UD_EnableDeviceIcons as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_EnableEffectIcons", UDWC.UD_EnableDebuffIcons as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_EnableCNotifications", UDWC.UD_EnableCNotifications as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextFontSize", UDWC.UD_TextFontSize)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextLineLength", UDWC.UD_TextLineLength)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextReadSpeed", UDWC.UD_TextReadSpeed)
    JsonUtil.SetIntValue(strFile, "iWidgets_FilterVibNotifications", UDWC.UD_FilterVibNotifications as Int)
    JsonUtil.SetIntValue(strFile, "iWidgets_IconsSize", UDWC.UD_IconsSize)
    JsonUtil.SetIntValue(strFile, "iWidgets_IconsAnchor", UDWC.UD_IconsAnchor)
    JsonUtil.SetIntValue(strFile, "iWidgets_IconsPadding", UDWC.UD_IconsPadding)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextAnchor", UDWC.UD_TextAnchor)
    JsonUtil.SetIntValue(strFile, "iWidgets_TextPadding", UDWC.UD_TextPadding)
    JsonUtil.SetIntValue(strFile, "WidgetPosX", UDWC.UD_WidgetXPos)
    JsonUtil.SetIntValue(strFile, "WidgetPosY", UDWC.UD_WidgetYPos)
    JsonUtil.SetIntValue(strFile, "iWidgets_EffectExhaustion_Icon", UDWC.StatusEffect_GetVariant("effect-exhaustion"))
    JsonUtil.SetIntValue(strFile, "iWidgets_EffectOrgasm_Icon", UDWC.StatusEffect_GetVariant("effect-orgasm"))
    
    ;OTHER
    JsonUtil.SetIntValue(strFile, "UseHoods", UDIM.UD_UseHoods as Int)
    JsonUtil.SetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)
    JsonUtil.SetIntValue(strFile, "SwimmingDifficulty", UDSS.UD_hardcore_swimming_difficulty)
    JsonUtil.SetIntValue(strFile, "RandomFiler", UDmain.UDRRM.UD_RandomDevice_GlobalFilter)
    JsonUtil.SetIntValue(strFile, "DAR", AAScript.UD_DAR as Int)
    JsonUtil.SetIntValue(strFile, "SlotUpdateTime", Round(UDCD_NPCM.UD_SlotUpdateTime))
    JsonUtil.SetIntValue(strFile, "OutfitRemove", UDCDMain.UD_OutfitRemove as Int)
    JsonUtil.SetIntValue(strFile, "AllowMenBondage", UDmain.AllowMenBondage as Int)
    
    ; ANIMATIONS
    JsonUtil.StringListCopy(strFile, "Anims_UserDisabledJSONs", UDAM.UD_AnimationJSON_Dis)
    JsonUtil.SetIntValue(strFile, "AlternateAnimation", UDAM.UD_AlternateAnimation as Int)
    JsonUtil.SetIntValue(strFile, "AlternateAnimationPeriod", UDAM.UD_AlternateAnimationPeriod)
    JsonUtil.SetIntValue(strFile, "UseSingleStruggleKeyword", UDAM.UD_UseSingleStruggleKeyword as Int)

    JsonUtil.Save(strFile, true)
EndFunction

Function LoadFromJSON(string strFile)
    ;UDmain
    UDmain.UD_hightPerformance = JsonUtil.GetIntValue(strFile, "hightPerformance", UDmain.UD_hightPerformance as Int)
    UDmain.AllowNPCSupport = JsonUtil.GetIntValue(strFile, "AllowNPCSupport", UDmain.AllowNPCSupport as Int)
    UDmain.lockMCM = JsonUtil.GetIntValue(strFile, "lockMCM", UDmain.lockMCM as Int)
    UDmain.DebugMod = JsonUtil.GetIntValue(strFile, "Debug mode", UDmain.DebugMod as Int)
    UDmain.UD_OrgasmExhaustion = JsonUtil.GetIntValue(strFile, "OrgasmExhastion", UDmain.UD_OrgasmExhaustion as int)
    ;UDmain.UD_OrgasmExhaustionMagnitude = JsonUtil.GetFloatValue(strFile, "OrgasmExhaustionMag", UDmain.UD_OrgasmExhaustionMagnitude)
    ;UDmain.UD_OrgasmExhaustionDuration = JsonUtil.GetIntValue(strFile, "OrgasmExhaustionDuration", UDmain.UD_OrgasmExhaustionDuration)
    UDmain.UD_AutoLoad = JsonUtil.GetIntValue(strFile, "AutoLoad", UDmain.UD_AutoLoad as int)
    UDmain.LogLevel = JsonUtil.GetIntValue(strFile, "LogLevel", UDmain.LogLevel as int)
    UDmain.UD_HearingRange = JsonUtil.GetIntValue(strFile, "HearingRange", UDmain.UD_HearingRange)
    UDmain.UD_WarningAllowed = JsonUtil.GetIntValue(strFile, "WarningAllowed", UDmain.UD_WarningAllowed as Int)
    UDmain.UD_PrintLevel = JsonUtil.GetIntValue(strFile, "PrintLevel", UDmain.UD_PrintLevel)
    UDmain.UD_LockDebugMCM = JsonUtil.GetIntValue(strFile, "LockDebug", UDmain.UD_LockDebugMCM as Int)
    UDUI.UD_EasyGamepadMode = JsonUtil.GetIntValue(strFile, "EasyGamepadMode", UDUI.UD_EasyGamepadMode as Int)
    UDmain.UD_CheckAllKw = JsonUtil.GetIntValue("AllKeywordCheck",UDmain.UD_CheckAllKw as Int)

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
    UDOM.UD_OrgasmResistence = JsonUtil.GetFloatValue(strFile, "OrgasmResistence", UDOM.UD_OrgasmResistence)
    UDCDmain.UD_LockpicksPerMinigame = JsonUtil.GetIntValue(strFile, "LockpicksPerMinigame", UDCDmain.UD_LockpicksPerMinigame)
    UDOM.UD_UseOrgasmWidget = JsonUtil.GetIntValue(strFile, "UseOrgasmWidget", UDOM.UD_UseOrgasmWidget as Int)
    UDOM.UD_OrgasmUpdateTime = JsonUtil.GetFloatValue(strFile, "OrgasmUpdateTime", UDOM.UD_OrgasmUpdateTime)
    UDOM.UD_OrgasmAnimation = JsonUtil.GetIntValue(strFile, "OrgasmAnimation", UDOM.UD_OrgasmAnimation)
    UDOM.UD_HornyAnimation = JsonUtil.GetIntValue(strFile, "HornyAnimation", UDOM.UD_HornyAnimation as Int)
    UDOM.UD_HornyAnimationDuration = JsonUtil.GetIntValue(strFile, "HornyAnimationDuration", UDOM.UD_HornyAnimationDuration)
    UDCDmain.UD_CooldownMultiplier = JsonUtil.GetFloatValue(strFile, "CooldownMultiplier", UDCDmain.UD_CooldownMultiplier)
    UDCDMain.UD_SkillEfficiency = JsonUtil.GetIntValue(strFile, "SkillEfficiency", UDCDmain.UD_SkillEfficiency)
    UDCDmain.UD_CritEffect      = JsonUtil.GetIntValue(strFile, "CritEffect", UDCDmain.UD_CritEffect)
    UDCDmain.UD_HardcoreMode    = JsonUtil.GetIntValue(strFile, "HardcoreMode", UDCDmain.UD_HardcoreMode as Int)
    UDCDmain.UD_AllowArmTie     = JsonUtil.GetIntValue(strFile, "AllowArmTie", UDCDmain.UD_AllowArmTie as Int)
    UDCDmain.UD_AllowLegTie     = JsonUtil.GetIntValue(strFile, "AllowLegTie", UDCDmain.UD_AllowLegTie as Int)
    UDCDmain.UD_MinigameHelpCd  = JsonUtil.GetIntValue(strFile, "MinigameHelpCD",UDCDmain.UD_MinigameHelpCd)
    UDCDmain.UD_MinigameHelpCD_PerLVL   = JsonUtil.GetIntValue(strFile, "MinigameHelpCD_PerLVL", Round(UDCDmain.UD_MinigameHelpCD_PerLVL))
    UDCDmain.UD_MinigameHelpXPBase      = JsonUtil.GetIntValue(strFile, "MinigameHelpXPBase", UDCDmain.UD_MinigameHelpXPBase)
    UDCDMain.UD_DeviceLvlHealth             = JsonUtil.GetFloatValue(strFile, "DeviceLvlHealth", UDCDMain.UD_DeviceLvlHealth*100)/100
    UDCDMain.UD_DeviceLvlLockpick           = JsonUtil.GetFloatValue(strFile, "DeviceLvlLockpick", UDCDMain.UD_DeviceLvlLockpick)
    UDCDMain.UD_DeviceLvlLocks              = JsonUtil.GetIntValue(strFile, "DeviceLvlLocks", UDCDMain.UD_DeviceLvlLocks)
    UDCDmain.UD_PreventMasterLock           = JsonUtil.GetIntValue(strFile, "PreventMasterLock", UDCDmain.UD_PreventMasterLock as Int)
    UDOM.UD_OrgasmArousalReduce = JsonUtil.GetIntValue(strFile, "PostOrgasmArousalReduce", UDOM.UD_OrgasmArousalReduce)
    UDOM.UD_OrgasmArousalReduceDuration = JsonUtil.GetIntValue(strFile, "PostOrgasmArousalReduce_Duration", UDOM.UD_OrgasmArousalReduceDuration)
    UDCDmain.UD_MandatoryCrit = JsonUtil.GetIntValue(strFile, "MandatoryCrit", UDCDmain.UD_MandatoryCrit as Int)
    UDCDmain.UD_CritDurationAdjust = JsonUtil.GetFloatValue(strFile, "CritDurationAdjust", UDCDmain.UD_CritDurationAdjust)
    UDCDmain.UD_KeyDurability = JsonUtil.GetIntValue(strFile, "KeyDurability", UDCDmain.UD_KeyDurability)
    UDCDmain.UD_HardcoreAccess = JsonUtil.GetIntValue(strFile, "HardcoreAccess", UDCDmain.UD_HardcoreAccess as Int)
    
    ;ABADON
    AbadonQuest.final_finisher_set = JsonUtil.GetIntValue(strFile, "AbadonForceSet", AbadonQuest.final_finisher_set as Int)
    AbadonQuest.final_finisher_pref = JsonUtil.GetIntValue(strFile, "AbadonForceSetPref", AbadonQuest.final_finisher_pref as Int)
    AbadonQuest.UseAnalVariant = JsonUtil.GetIntValue(strFile, "AbadonUseAnalVariant", AbadonQuest.UseAnalVariant as Int)
    preset = JsonUtil.GetIntValue(strFile, "AbadonPlugPreset", preset as Int)
    AbadonQuest.max_difficulty = JsonUtil.GetFloatValue(strFile, "AbadonPlugMaxDifficulty", AbadonQuest.max_difficulty)
    AbadonQuest.overaldifficulty = JsonUtil.GetIntValue(strFile, "AbadonPlugOverallDifficulty", AbadonQuest.overaldifficulty as Int)
    AbadonQuest.eventchancemod = JsonUtil.GetIntValue(strFile, "AbadonPlugEventChanceMod", AbadonQuest.eventchancemod as Int)
    AbadonQuest.little_finisher_chance = JsonUtil.GetIntValue(strFile, "AbadonPlugLittleFinisherChance", AbadonQuest.little_finisher_chance as Int)
    AbadonQuest.min_orgasm_little_finisher = JsonUtil.GetIntValue(strFile, "AbadonPlugMinOrgasmLittleFinisher", AbadonQuest.min_orgasm_little_finisher as Int)
    AbadonQuest.max_orgasm_little_finisher = JsonUtil.GetIntValue(strFile, "AbadonPlugMaxOrgasmLittleFinisher", AbadonQuest.max_orgasm_little_finisher as Int)
    AbadonQuest.little_finisher_cooldown = JsonUtil.GetFloatValue(strFile, "AbadonPlugLittleFinisherCooldown", AbadonQuest.little_finisher_cooldown)
    AbadonQuest.dmg_heal = JsonUtil.GetIntValue(strFile, "AbadonPlugDmgHeal", AbadonQuest.dmg_heal as Int)
    AbadonQuest.dmg_magica = JsonUtil.GetIntValue(strFile, "AbadonPlugDmgMagicka", AbadonQuest.dmg_magica as Int)
    AbadonQuest.dmg_stamina = JsonUtil.GetIntValue(strFile, "AbadonPlugDmgStamina", AbadonQuest.dmg_stamina as Int)
    AbadonQuest.hardcore = JsonUtil.GetIntValue(strFile, "AbadonPlugHardcore", AbadonQuest.hardcore as Int)

    ;PATCHER
    UDCDmain.UDPatcher.UD_MAOChanceMod = JsonUtil.GetIntValue(strFile, "MAOChanceMod", UDCDmain.UDPatcher.UD_MAOChanceMod)
    UDCDmain.UDPatcher.UD_MAOMod = JsonUtil.GetIntValue(strFile, "MAOMod", UDCDmain.UDPatcher.UD_MAOMod)
    UDCDmain.UDPatcher.UD_MAHChanceMod = JsonUtil.GetIntValue(strFile, "MAHChanceMod", UDCDmain.UDPatcher.UD_MAHChanceMod)
    UDCDmain.UDPatcher.UD_MAHMod = JsonUtil.GetIntValue(strFile, "MAHMod", UDCDmain.UDPatcher.UD_MAHMod)
    UDCDmain.UDPatcher.UD_EscapeModifier = JsonUtil.GetIntValue(strFile, "EscapeModifier", UDCDmain.UDPatcher.UD_EscapeModifier)
    UDCDmain.UDPatcher.UD_MinLocks = JsonUtil.GetIntValue(strFile, "MinLocks", UDCDmain.UDPatcher.UD_MinLocks)
    UDCDmain.UDPatcher.UD_MaxLocks = JsonUtil.GetIntValue(strFile, "MaxLocks", UDCDmain.UDPatcher.UD_MaxLocks)
    UDCDmain.UDPatcher.UD_MinResistMult = JsonUtil.GetIntValue(strFile, "MinResist", Round(UDCDmain.UDPatcher.UD_MinResistMult*100))/100
    UDCDmain.UDPatcher.UD_MaxResistMult = JsonUtil.GetIntValue(strFile, "MaxResist", Round(UDCDmain.UDPatcher.UD_MaxResistMult*100))/100
    UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage = JsonUtil.GetFloatValue(strFile, "PatchMult_HeavyBondage", UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage)
    UDCDmain.UDPatcher.UD_PatchMult_Blindfold = JsonUtil.GetFloatValue(strFile, "PatchMult_Blindfold", UDCDmain.UDPatcher.UD_PatchMult_Blindfold)
    UDCDmain.UDPatcher.UD_PatchMult_Gag = JsonUtil.GetFloatValue(strFile, "PatchMult_Gag", UDCDmain.UDPatcher.UD_PatchMult_Gag)
    UDCDmain.UDPatcher.UD_PatchMult_Hood = JsonUtil.GetFloatValue(strFile, "PatchMult_Hood", UDCDmain.UDPatcher.UD_PatchMult_Hood)
    UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt = JsonUtil.GetFloatValue(strFile, "PatchMult_ChastityBelt", UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt)
    UDCDmain.UDPatcher.UD_PatchMult_ChastityBra = JsonUtil.GetFloatValue(strFile, "PatchMult_ChastityBra", UDCDmain.UDPatcher.UD_PatchMult_ChastityBra)
    UDCDmain.UDPatcher.UD_PatchMult_Plug = JsonUtil.GetFloatValue(strFile, "PatchMult_Plug", UDCDmain.UDPatcher.UD_PatchMult_Plug)
    UDCDmain.UDPatcher.UD_PatchMult_Piercing = JsonUtil.GetFloatValue(strFile, "PatchMult_Piercing", UDCDmain.UDPatcher.UD_PatchMult_Piercing)
    UDCDmain.UDPatcher.UD_PatchMult_Generic = JsonUtil.GetFloatValue(strFile, "PatchMult_Generic", UDCDmain.UDPatcher.UD_PatchMult_Generic)
    
    ;UI/WIDGET
    UDWC.UD_AutoAdjustWidget = JsonUtil.GetIntValue(strFile, "AutoAdjustWidget", UDWC.UD_AutoAdjustWidget as Int)
    UDWC.UD_UseIWantWidget = JsonUtil.GetIntValue(strFile, "UseIWantWidget", UDWC.UD_UseIWantWidget as Int)
    UDWC.UD_EnableDeviceIcons = JsonUtil.GetIntValue(strFile, "iWidgets_EnableDeviceIcons", UDWC.UD_EnableDeviceIcons as Int)
    UDWC.UD_EnableDebuffIcons = JsonUtil.GetIntValue(strFile, "iWidgets_EnableEffectIcons", UDWC.UD_EnableDebuffIcons as Int)
    UDWC.UD_EnableCNotifications = JsonUtil.GetIntValue(strFile, "iWidgets_EnableCNotifications", UDWC.UD_EnableCNotifications as Int)
    UDWC.UD_TextFontSize = JsonUtil.GetIntValue(strFile, "iWidgets_TextFontSize", UDWC.UD_TextFontSize)
    UDWC.UD_TextLineLength = JsonUtil.GetIntValue(strFile, "iWidgets_TextLineLength", UDWC.UD_TextLineLength)
    UDWC.UD_TextReadSpeed = JsonUtil.GetIntValue(strFile, "iWidgets_TextReadSpeed", UDWC.UD_TextReadSpeed)
    UDWC.UD_FilterVibNotifications = JsonUtil.GetIntValue(strFile, "iWidgets_FilterVibNotifications", UDWC.UD_FilterVibNotifications as Int) == 1
    UDWC.UD_IconsSize = JsonUtil.GetIntValue(strFile, "iWidgets_IconsSize", UDWC.UD_IconsSize)
    UDWC.UD_IconsAnchor = JsonUtil.GetIntValue(strFile, "iWidgets_IconsAnchor", UDWC.UD_IconsAnchor)
    UDWC.UD_IconsPadding = JsonUtil.GetIntValue(strFile, "iWidgets_IconsPadding", UDWC.UD_IconsPadding)
    UDWC.UD_TextAnchor = JsonUtil.GetIntValue(strFile, "iWidgets_TextAnchor", UDWC.UD_TextAnchor)
    UDWC.UD_TextPadding = JsonUtil.GetIntValue(strFile, "iWidgets_TextPadding", UDWC.UD_TextPadding)
    Int variant = JsonUtil.GetIntValue(strFile, "iWidgets_EffectExhaustion_Icon", -1)
    UDWC.StatusEffect_Register("effect-exhaustion", -1, variant)
    variant = JsonUtil.GetIntValue(strFile, "iWidgets_EffectOrgasm_Icon", -1)
    UDWC.StatusEffect_Register("effect-orgasm", -1, variant)
    UDWC.UD_WidgetXPos = JsonUtil.GetIntValue(strFile, "WidgetPosX", UDWC.UD_WidgetXPos)
    UDWC.UD_WidgetYPos = JsonUtil.GetIntValue(strFile, "WidgetPosY", UDWC.UD_WidgetXPos)
    UDWC.UD_WidgetXPos = JsonUtil.GetIntValue(strFile, "WidgetPosX", UDWC.UD_WidgetXPos)
    UDWC.UD_WidgetYPos = JsonUtil.GetIntValue(strFile, "WidgetPosY", UDWC.UD_WidgetXPos)
    
    ;Other
    UDIM.UD_UseHoods = JsonUtil.GetIntValue(strFile, "UseHoods", UDIM.UD_UseHoods as Int)
    libs.UD_StartThirdpersonAnimation_Switch = JsonUtil.GetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)
    UDSS.UD_hardcore_swimming_difficulty = JsonUtil.GetIntValue(strFile, "SwimmingDifficulty", UDSS.UD_hardcore_swimming_difficulty)
    UDWC.UD_WidgetXPos = JsonUtil.GetIntValue(strFile, "WidgetPosX", UDWC.UD_WidgetXPos)
    UDWC.UD_WidgetYPos = JsonUtil.GetIntValue(strFile, "WidgetPosY", UDWC.UD_WidgetXPos)
    UDmain.UDRRM.UD_RandomDevice_GlobalFilter =  JsonUtil.GetIntValue(strFile, "RandomFiler", UDmain.UDRRM.UD_RandomDevice_GlobalFilter)
    AAScript.UD_DAR =  JsonUtil.GetIntValue(strFile, "DAR", AAScript.UD_DAR as Int)
    UDCD_NPCM.UD_SlotUpdateTime =  JsonUtil.GetIntValue(strFile, "SlotUpdateTime", Round(UDCD_NPCM.UD_SlotUpdateTime))
    UDCDMain.UD_OutfitRemove = JsonUtil.GetIntValue(strFile, "OutfitRemove", UDCDMain.UD_OutfitRemove as Int)
    UDmain.AllowMenBondage = JsonUtil.GetIntValue(strFile, "AllowMenBondage", UDmain.AllowMenBondage as Int)

    ; ANIMATIONS
    If JsonUtil.StringListCount(strFile, "Anims_UserDisabledJSONs") > 0
        UDAM.UD_AnimationJSON_Dis = JsonUtil.StringListToArray(strFile, "Anims_UserDisabledJSONs")
    EndIf
    UDAM.UD_AlternateAnimation = JsonUtil.GetIntValue(strFile, "AlternateAnimation", UDAM.UD_AlternateAnimation as Int) > 0
    UDAM.UD_AlternateAnimationPeriod = JsonUtil.GetIntValue(strFile, "AlternateAnimationPeriod", UDAM.UD_AlternateAnimationPeriod)
    UDAM.UD_UseSingleStruggleKeyword = JsonUtil.GetIntValue(strFile, "UseSingleStruggleKeyword", UDAM.UD_UseSingleStruggleKeyword as Int) > 0

EndFunction

Function ResetToDefaults()
    ;UDmain
    UDmain.UD_hightPerformance          = true
    UDmain.AllowNPCSupport              = false
    UDmain.lockMCM                      = false
    UDmain.DebugMod                     = false
    UDmain.UD_OrgasmExhaustion          = true
    UDmain.UD_OrgasmExhaustionMagnitude = 20.0
    UDmain.UD_OrgasmExhaustionDuration  = 30
    UDmain.UD_AutoLoad                  = false
    UDmain.LogLevel                     = 0
    UDmain.UD_HearingRange              = 4000
    UDmain.UD_WarningAllowed            = false
    UDmain.UD_PrintLevel                = 3
    UDmain.UD_LockDebugMCM              = False
    UDUI.UD_EasyGamepadMode             = false
    UDmain.UD_CheckAllKw                = False
    
    ;UDCDmain
    UDCDmain.UnregisterGlobalKeys()
    if !Game.UsingGamepad()
        UDCDmain.Stamina_meter_Keycode  = 32
        UDCDmain.StruggleKey_Keycode    = 52
        UDCDmain.Magicka_meter_Keycode  = 30
        UDCDmain.SpecialKey_Keycode     = 31
        UDCDmain.PlayerMenu_KeyCode     = 40
        UDCDmain.ActionKey_Keycode      = 18
        UDCDmain.NPCMenu_Keycode        = 39
    else
        UDCDmain.Stamina_meter_Keycode  = 275
        UDCDmain.StruggleKey_Keycode    = 275
        UDCDmain.Magicka_meter_Keycode  = 274
        UDCDmain.SpecialKey_Keycode     = 276
        UDCDmain.PlayerMenu_KeyCode     = 268
        UDCDmain.NPCMenu_Keycode        = 269
        UDCDmain.ActionKey_Keycode      = 279
    endif
    UDCDmain.RegisterGlobalKeys()
    
    UDCDmain.UD_UseDDdifficulty         = true
    UDCDmain.UD_UseWidget               = true
    UDCDmain.UD_GagPhonemModifier       = 50
    UDCDmain.UD_StruggleDifficulty      = 1
    UDCDmain.UD_BaseDeviceSkillIncrease = 35.0
    UDCDmain.UD_UpdateTime              = 5.0
    UDCDmain.UD_AutoCrit = false
    if UDCDmain.UD_AutoCrit
        UD_autocrit_flag = OPTION_FLAG_NONE
    else
        UD_autocrit_flag = OPTION_FLAG_DISABLED
    endif
    UDCDmain.UD_AutoCritChance          = 80
    UDCDmain.UD_VibrationMultiplier     = 0.1
    UDCDmain.UD_ArousalMultiplier       = 0.025
    UDOM.UD_OrgasmResistence            = 3.5
    UDCDmain.UD_LockpicksPerMinigame    = 2
    UDOM.UD_UseOrgasmWidget             = true
    UDOM.UD_OrgasmUpdateTime            = 0.5
    UDOM.UD_OrgasmAnimation             = 1
    UDOM.UD_HornyAnimation              = true
    UDOM.UD_HornyAnimationDuration      = 5
    UDCDmain.UD_CooldownMultiplier      = 1.0
    UDCDmain.UD_CritEffect              = 2
    UDCDmain.UD_HardcoreMode            = false
    UDCDmain.UD_AllowArmTie             = true
    UDCDmain.UD_AllowLegTie             = true
    UDCDMain.UD_SkillEfficiency         = 1
    UDCDmain.UD_MinigameHelpCd          = 60
    UDCDmain.UD_MinigameHelpCD_PerLVL   = 10
    UDCDmain.UD_MinigameHelpXPBase      = 35
    UDCDmain.UD_DeviceLvlHealth         = 0.025
    UDCDmain.UD_DeviceLvlLockpick       = 0.5
    UDCDMain.UD_DeviceLvlLocks          = 5
    UDCDmain.UD_PreventMasterLock       = False
    UDOM.UD_OrgasmArousalReduce         = 25
    UDOM.UD_OrgasmArousalReduceDuration =  7
    UDCDmain.UD_MandatoryCrit           = False
    UDCDmain.UD_CritDurationAdjust      = 0.0
    UDCDmain.UD_KeyDurability           = 5
    UDCDmain.UD_HardcoreAccess          = False
    
    ;ABADON
    AbadonQuest.final_finisher_set      = true
    AbadonQuest.final_finisher_pref     = 0
    AbadonQuest.UseAnalVariant          = false
    
    ;PATCHER
    UDCDmain.UDPatcher.UD_MAOChanceMod              = 100
    UDCDmain.UDPatcher.UD_MAOMod                    = 100
    UDCDmain.UDPatcher.UD_MAHChanceMod              = 100
    UDCDmain.UDPatcher.UD_MAHMod                    = 100
    UDCDmain.UDPatcher.UD_EscapeModifier            = 10
    UDCDmain.UDPatcher.UD_MinLocks                  = 0
    UDCDmain.UDPatcher.UD_MaxLocks                  = 2
    UDCDmain.UDPatcher.UD_MinResistMult             =-1.0
    UDCDmain.UDPatcher.UD_MaxResistMult             = 1.0
    UDCDmain.UDPatcher.UD_PatchMult                 = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage    = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Blindfold       = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Gag             = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Hood            = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt    = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_ChastityBra     = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Plug            = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Piercing        = 1.0
    UDCDmain.UDPatcher.UD_PatchMult_Generic         = 1.0
    
    ;UI/WIDGET
    UDWC.ResetToDefault()
    
    ;Other
    UDIM.UD_UseHoods                                = true
    libs.UD_StartThirdpersonAnimation_Switch        = true
    UDSS.UD_hardcore_swimming_difficulty            = 1
    UDWC.UD_WidgetXPos                       = 2
    UDWC.UD_WidgetYPos                       = 0
    UDmain.UDRRM.UD_RandomDevice_GlobalFilter       = 0xFFFFFFFF ;32b
    AAScript.UD_DAR                                 =  false
    UDCD_NPCM.UD_SlotUpdateTime                     = 10.0
    UDCDMain.UD_OutfitRemove                        = True
    UDmain.AllowMenBondage                          = False
    
    ; Animations
    UDAM.LoadDefaultMCMSettings()

EndFunction

Function SetAutoLoad(bool bValue)
    JsonUtil.SetIntValue(FILE, "AutoLoad", bValue as Int)
    JsonUtil.Save(FILE, true)
EndFunction

bool Function GetAutoLoad()
    UDmain.UD_AutoLoad = JsonUtil.GetIntValue(FILE, "AutoLoad", UDmain.UD_AutoLoad as int)
    return UDmain.UD_AutoLoad
EndFunction