Scriptname UD_MCM_script extends SKI_ConfigBase

import UnforgivingDevicesMain
import UD_Native

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

UD_Config         Property UDCONF hidden
    UD_Config Function Get()
        return UDmain.UDCONF
    EndFunction
EndProperty

UD_OutfitManager  Property UDOTM hidden
    UD_OutfitManager Function Get()
        return UDmain.UDOTM
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

String Function SwitchBool(Bool abVal)
    if abVal
        return "True"
    else
        return "False"
    endif
EndFunction

;check if button can be used for UD
Bool Function CheckButton(Int aiKeyCode)
    Bool loc_res = True
    
    loc_res = loc_res && (aiKeyCode != 264) ;is not mouse wheel up
    loc_res = loc_res && (aiKeyCode != 265) ;is not mouse wheel down
    
    return loc_res
EndFunction

String Property UD_NPCsPageName = "$UD_NPCSCONFIG" auto

Function LoadConfigPages()
    pages = new String[15]
    pages[00] = "$UD_GENERAL"
    pages[01] = "$UD_DEVICEFILTER"
    pages[02] = "$UD_CUSTOMDEVICES"
    pages[03] = "Custom Modifiers"  ;TODO - add to translation file
    pages[04] = "Custom Outfits"    ;TODO - add to translation file
    pages[05] = "$UD_CUSTOMORGASM"
    pages[06] = UD_NPCsPageName
    pages[07] = "$UD_PATCHER"
    pages[08] = "$UD_DDPATCH"
    pages[09] = "$UD_ABADONPLUG"
    pages[10] = "$UD_UIWIDGETS"
    pages[11] = "$UD_ANIMATIONS"
    pages[12] = "$UD_ANIMATIONS_PLAYGROUND"
    pages[13] = "$UD_DEBUGPANEL"
    pages[14] = "$UD_OTHER"
EndFunction

bool Property Ready = False Auto
Event OnConfigInit()
EndEvent

Function Init()
    if UDmain.TraceAllowed()
        UDmain.Log("MCM init started")
    endif
    
    device_flag         = OPTION_FLAG_NONE
    UD_autocrit_flag    = OPTION_FLAG_DISABLED
    fix_flag            = OPTION_FLAG_NONE
    UD_Horny_f          = OPTION_FLAG_NONE
    
    if AbadonQuest.final_finisher_set
        abadon_flag_2 = OPTION_FLAG_NONE
    else
        abadon_flag_2 = OPTION_FLAG_DISABLED
    endif
    
    UD_LockMenu_flag = OPTION_FLAG_NONE
    
    actorIndex = 10
    Update()
    setAbadonPreset(1)
    LoadConfig(false)
    Ready = True
    UDmain.LogDebug("MCM Ready")
EndFunction

Function Update()
    LoadConfigPages()
    registered_devices_T = new Int[25]
    NPCSlots_T = Utility.CreateIntArray(UDCD_NPCM.GetNumAliases())
    
    difficultyList = new string[3]
    difficultyList[0] = "$Easy"
    difficultyList[1] = "$Normal"
    difficultyList[2] = "$Hard"
    
    widgetXList = new String[3]
    widgetXList[0] = "$Left"
    widgetXList[1] = "$Middle"
    widgetXList[2] = "$Right"
    
    widgetYList = new String[3]
    widgetYList[0] = "$Down"
    widgetYList[1] = "$Less Down"
    widgetYList[2] = "$Up"
    
    orgasmAnimation = new String[2]
    orgasmAnimation[0] = "$Normal"
    orgasmAnimation[1] = "$Expanded"
    
    presetList = new string[4]
    presetList[0] = "$Forgiving"
    presetList[1] = "$Pleasure slave"
    presetList[2] = "$Game of time"
    presetList[3] = "$Custom"
    
    criteffectList = new string[3]
    criteffectList[0] = "HUD"
    criteffectList[1] = "$Body shader"
    criteffectList[2] = "$HUD + Body shader"
    
    final_finisher_pref_list = new string[7]
    final_finisher_pref_list[0] = "$Random"
    final_finisher_pref_list[1] = "$Rope"
    final_finisher_pref_list[2] = "$Transparent"
    final_finisher_pref_list[3] = "$Rubber"
    final_finisher_pref_list[4] = "$Restrictive"
    final_finisher_pref_list[5] = "$Simple"
    final_finisher_pref_list[6] = "$Yoke"

    UD_IconsAnchorList = new String[3]
    UD_IconsAnchorList[0] = "$Left"
    UD_IconsAnchorList[1] = "$CENTER"
    UD_IconsAnchorList[2] = "$Right"
    
    UD_TextAnchorList = new String[4]
    UD_TextAnchorList[0] = "$BOTTOM"
    UD_TextAnchorList[1] = "$BELOW CENTER"
    UD_TextAnchorList[2] = "$TOP"
    UD_TextAnchorList[3] = "$CENTER"
    
    UD_IconVariant_EffExhaustionList = new String[3]
    UD_IconVariant_EffExhaustionList[0] = "$Variant 1"
    UD_IconVariant_EffExhaustionList[1] = "$Variant 2"
    UD_IconVariant_EffExhaustionList[2] = "$Variant 3"
    UD_IconVariant_EffOrgasmList = new String[3]
    UD_IconVariant_EffOrgasmList[0] = "$Variant 1"
    UD_IconVariant_EffOrgasmList[1] = "$Variant 2"
    UD_IconVariant_EffOrgasmList[2] = "$Variant 3"
    
    UD_MinigameLockpickSkillAdjust_ML = new String[5]
    UD_MinigameLockpickSkillAdjust_ML[0] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT100"
    UD_MinigameLockpickSkillAdjust_ML[1] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT90"
    UD_MinigameLockpickSkillAdjust_ML[2] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT75"
    UD_MinigameLockpickSkillAdjust_ML[3] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT50"
    UD_MinigameLockpickSkillAdjust_ML[4] = "$UD_MINIGAMELOCKPICKSKILLADJUST_OPT00"

    UD_OutfitSections_ML = new String[5]
    UD_OutfitSections_ML[0] = "Head"
    UD_OutfitSections_ML[1] = "Body"
    UD_OutfitSections_ML[2] = "Hands"
    UD_OutfitSections_ML[3] = "Legs"
    UD_OutfitSections_ML[4] = "Toys"

    libs = UDCDmain.libs as zadlibs_UDPatch
    
    UD_ModifierSelected = 0
EndFunction

Function LoadConfig(Bool abResetToDef = True)
    if abResetToDef
        ResetToDefaults()
    endif
    if getAutoLoad()
        LoadFromJSON(File)
        GInfo("MCM setting loaded from saved config file!")
    endif
EndFunction

Event onConfigClose()
EndEvent

Event onConfigOpen()
    device_flag = OPTION_FLAG_NONE
    fix_flag = OPTION_FLAG_NONE
EndEvent

String _lastPage
Event OnPageReset(string page)
    if !UDmain.IsEnabled() && Ready
        setCursorFillMode(LEFT_TO_RIGHT)
        AddHeaderOption("$Unforgiving devices is updating or disabled...")
        AddEmptyOption()
        
        AddTextOption("Mod ready",UDmain.Ready)
        AddTextOption("MCM ready",Ready)
        AddTextOption("Mod updating",UDmain.IsUpdating())
        AddTextOption("Mod disabled",UDmain._Disabled)
        AddTextOption("Update progress",UDmain.GetUpdateProgress())
        return
    endif
    
    if !Ready
        setCursorFillMode(LEFT_TO_RIGHT)
        AddHeaderOption("$MCM menu is not loaded!")
        AddEmptyOption()
        
        AddTextOption("Mod ready",UDmain.Ready)
        AddTextOption("MCM ready",Ready)
        AddTextOption("Mod updating",UDmain.IsUpdating())
        AddTextOption("Mod disabled",UDmain._Disabled)
        return
    endif
    
    _lastPage = page
    if (page == "$UD_GENERAL")
        resetGeneralPage()
    elseif (page == "$UD_DEVICEFILTER")
        resetFilterPage()
    elseif (page == "$UD_ABADONPLUG")
        resetAbadonPage()
    elseif (page == "$UD_CUSTOMDEVICES")
        resetCustomBondagePage()
    elseif (page == "Custom Modifiers")
        resetModifiersPage()
    elseif (page == "Custom Outfits")
        resetOutfitPage()
    elseif (page == UD_NPCsPageName)
        ResetNPCsPage()
    elseif (page == "$UD_CUSTOMORGASM")
        resetCustomOrgasmPage()
    elseif (page == "$UD_PATCHER")
        resetPatcherPage()
    elseif (page == "$UD_DDPATCH")
        resetDDPatchPage()
    elseif (page == "$UD_UIWIDGETS")
        resetUIWidgetPage()
    elseif (page == "$UD_ANIMATIONS")
        resetAnimationsPage()
    elseif (page == "$UD_ANIMATIONS_PLAYGROUND")
        resetAnimationsPlaygroundPage()
    elseif (page == "$UD_DEBUGPANEL")
        resetDebugPage()
    elseif (page == "$UD_OTHER")
        resetOtherPage()
    endif
EndEvent

int UseAnalVariant_T
int Property AbadonQuestFlag auto
Function resetAbadonPage()
    UpdateLockMenuFlag()
    
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_H_ABADONPLUGSETTINGS")
    addEmptyOption()

    preset_M = AddMenuOption("$UD_PRESET", presetList[preset])
    UseAnalVariant_T = addToggleOption("$UD_ANALVARIANT", AbadonQuest.UseAnalVariant,AbadonQuestFlag)
    
    max_difficulty_S = AddSliderOption("$UD_MAXDIFFICULTY", AbadonQuest.max_difficulty, "{0}",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    final_finisher_set_T = addToggleOption("$UD_FINALFINISHERSET", AbadonQuest.final_finisher_set,UD_LockMenu_flag)
    
    difficulty_M = AddMenuOption("$UD_DIFFICULTY", difficultyList[AbadonQuest.overaldifficulty],FlagSwitchOr(abadon_flag,UD_LockMenu_flag))

    addEmptyOption()
    
    
    hardcore_T = addToggleOption("$UD_HARDCORE", AbadonQuest.hardcore,FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    eventchancemod_S = AddSliderOption("$UD_EVENTCHANCEMOD", AbadonQuest.eventchancemod, "{0} %",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    
    dmg_heal_T = addToggleOption("$UD_DMGHEAL",AbadonQuest.dmg_heal,FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    addEmptyOption()
    
    dmg_stamina_T = addToggleOption("$UD_DMGSTAMINA_INFO",AbadonQuest.dmg_stamina,FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    addEmptyOption()
    
    dmg_magica_T = addToggleOption("$UD_DAMAGEMAGICA",AbadonQuest.dmg_magica,FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    addEmptyOption()
    
    little_finisher_chance_S = AddSliderOption("$UD_LITTLEFINISHERCHANCE", AbadonQuest.little_finisher_chance, "{1} %",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    little_finisher_cooldown_S = AddSliderOption("$UD_LITTLEFINISHERCOOLDOWN", AbadonQuest.little_finisher_cooldown, "${1} hours",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    
    min_orgasm_little_finisher_S = AddSliderOption("$UD_MINORGASMLITTLEFINISHER", AbadonQuest.min_orgasm_little_finisher, "{1}",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    max_orgasm_little_finisher_S = AddSliderOption("$UD_MAX_ORGASM_LITTLE_FINISHER", AbadonQuest.max_orgasm_little_finisher, "{1}",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
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
int UD_UseNativeFunctions_T
Event resetGeneralPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)

    AddHeaderOption("$UD_H_KEYMAPPING")
    addEmptyOption()
    
    UD_StruggleKey_K        = AddKeyMapOption("$UD_STRUGGLEKEY", UDCDmain.StruggleKey_Keycode,FlagSwitch(!UDUI.UD_EasyGamepadMode || !Game.UsingGamepad()))
    addEmptyOption()
    
    UD_PlayerMenu_K         = AddKeyMapOption("$UD_PLAYERMENU", UDCDmain.PlayerMenu_KeyCode,FlagSwitch(!UDUI.UD_EasyGamepadMode || !Game.UsingGamepad()))
    UD_NPCMenu_K            = AddKeyMapOption("$UD_NPCMENU", UDCDmain.NPCMenu_Keycode,FlagSwitch(!UDUI.UD_EasyGamepadMode || !Game.UsingGamepad()))
    
    UD_EasyGamepadMode_T    = addToggleOption("$UD_EASYGAMEPADMODE",UDUI.UD_EasyGamepadMode,FlagSwitch(Game.UsingGamepad() || UDUI.UD_EasyGamepadMode))
    UD_GamepadKey_K         = AddKeyMapOption("$UD_GAMEPADKEY", UDmain.UDUI.UD_GamepadKey,FlagSwitch(UDUI.UD_EasyGamepadMode))
    
    AddHeaderOption("$UD_H_GENERALSETTINGS")
    addEmptyOption()
    
    UD_hightPerformance_T   = addToggleOption("$UD_HIGHPERFORMANCE",UDmain.UD_hightPerformance)
    UD_UseNativeFunctions_T = addToggleOption("$UD_NATIVESWITCH",True,FlagSwitch(False)) ;disabled on LE
    
    UD_HearingRange_S       = addSliderOption("$UD_HEARINGRANGE",UDmain.UD_HearingRange,"{0}")
    UD_PrintLevel_S         = addSliderOption("$UD_PRINTLEVEL",UDmain.UD_PrintLevel, "{0}")

    lockmenu_T              = addToggleOption("$UD_LOCKMENU",UDmain.lockMCM,UD_LockMenu_flag)
    UD_LockDebugMCM_T       = addToggleOption("$UD_LOCKDEBUGMCM",UDmain.UD_LockDebugMCM,FlagSwitchAnd(UD_LockMenu_flag,FlagSwitch(!UDmain.UD_LockDebugMCM)))

    AddHeaderOption("$UD_H_DEBUG")
    addEmptyOption()
    UD_debugmod_T           = addToggleOption("$UD_DEBUGMOD",UDmain.DebugMod)
    UD_LoggingLevel_S       = addSliderOption("$UD_LOGGINGLEVEL",UDmain.LogLevel, "{0}")
    
    UD_WarningAllowed_T     = addToggleOption("$UD_WARNINGALLOWED",UDmain.UD_WarningAllowed)
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

    AddHeaderOption("$UD_DEVICEFILTER")
    addEmptyOption()

    UD_UseArmCuffs_T        = AddToggleOption("$UD_USEARMCUFFS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00001000), UD_LockMenu_flag)
    UD_UseLegCuffs_T        = AddToggleOption("$UD_USELEGCUFFS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00002000), UD_LockMenu_flag)
    UD_UseBras_T            = AddToggleOption("$UD_USECHASTITYBRAS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00010000), UD_LockMenu_flag)
    UD_UseBelts_T           = AddToggleOption("$UD_USECHASTITYBELTS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00020000), UD_LockMenu_flag)
    UD_UseBlindfolds_T      = AddToggleOption("$UD_USEBLINDFOLDS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000400), UD_LockMenu_flag)
    UD_UseBoots_T           = AddToggleOption("$UD_USEBOOTS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000800), UD_LockMenu_flag)
    UD_UseCollars_T         = AddToggleOption("$UD_USECOLLARS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000100), UD_LockMenu_flag)
    UD_UseCorsets_T         = AddToggleOption("$UD_USECORSETS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000040), UD_LockMenu_flag)
    UD_UseGags_T            = AddToggleOption("$UD_USEGAGS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000200), UD_LockMenu_flag)
    UD_UseGloves_T          = AddToggleOption("$UD_USEGLOVES", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00008000), UD_LockMenu_flag)
    UD_UseHarnesses_T       = AddToggleOption("$UD_USEHARNESSES", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000020), UD_LockMenu_flag)
    UD_UseHoods_T           = AddToggleOption("$UD_USEHOODS",Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000080),UD_LockMenu_flag) ; leave it as it is, no point in changing, unless we get rid of this variable
    UD_UsePiercingsNipple_T = AddToggleOption("$UD_USEPIERCINGSNIPPLE", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000002), UD_LockMenu_flag)
    UD_UsePiercingsVaginal_T= AddToggleOption("$UD_USEPIERCINGSVAGINAL", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000001), UD_LockMenu_flag)
    UD_UsePlugsAnal_T       = AddToggleOption("$UD_USEPLUGSANAL", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000008), UD_LockMenu_flag)
    UD_UsePlugsVaginal_T    = AddToggleOption("$UD_USEPLUGSVAGINAL", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000004), UD_LockMenu_flag)
    UD_UseHeavyBondage_T    = AddToggleOption("$UD_USEHEAVYBONDAGE", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000010), UD_LockMenu_flag)
    UD_UseSuits_T           = AddToggleOption("$UD_USESUITS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00004000), UD_LockMenu_flag)
    addEmptyOption()
    addEmptyOption()
    UD_RandomFilter_T       = AddInputOption("$UD_RANDOMFILTER", Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0xFFFFFFFF), UD_LockMenu_flag) ; leaving this just in case
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
Int UD_MinigameDrainMult_S
Int UD_InitialDrainDelay_S
Int UD_KeyDurability_S
Int UD_HardcoreAccess_T
Int UD_MinigameExhDurationMult_S
Int UD_MinigameExhMagnitudeMult_S
Int UD_MinigameLockpickSkillAdjust_M
String[] UD_MinigameLockpickSkillAdjust_ML
Int UD_LockpickMinigameDuration_S
Int UD_MinigameExhExponential_S
Int UD_MinigameExhNoStruggleMax_S
Event resetCustomBondagePage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    ;KEY MAPPING
    AddHeaderOption("$UD_H_KEYMAPPING")
    addEmptyOption()
    UD_CHB_Stamina_meter_Keycode_K = AddKeyMapOption("$UD_STAMINAMETER", UDCDmain.Stamina_meter_Keycode)
    UD_CHB_Magicka_meter_Keycode_K = AddKeyMapOption("$UD_MAGICKAMETER", UDCDmain.Magicka_meter_Keycode)

    UDCD_SpecialKey_Keycode_K   = AddKeyMapOption("$UD_SPECIALKEYKEY", UDCDmain.SpecialKey_Keycode)
    UD_ActionKey_K              = AddKeyMapOption("$UD_ACTIONKEY", UDCDmain.ActionKey_Keycode)
    
    ;MAIN SETTING
    AddHeaderOption("$UD_H_MAINSETTING")
    addEmptyOption()
    UD_UpdateTime_S = addSliderOption("$UD_UPDATETIME",UDCDmain.UD_UpdateTime, "${0} s")
    UD_CooldownMultiplier_S = addSliderOption("$UD_COOLDOWNMULTIPLIER",Round(UDCDmain.UD_CooldownMultiplier*100), "{0} %",UD_LockMenu_flag)
    
    UD_PreventMasterLock_T = addToggleOption("$UD_PREVENTMASTERLOCK",UDCDmain.UD_PreventMasterLock,UD_LockMenu_flag)
    UD_LockpickMinigameNum_S = addSliderOption("$UD_LOCKPICKMINIGAMENUM",UDCDmain.UD_LockpicksPerMinigame, "{0}",UD_LockMenu_flag)
    
    UD_MinigameLockpickSkillAdjust_M    = AddMenuOption("$UD_MINIGAMELOCKPICKSKILLADJUST", UD_MinigameLockpickSkillAdjust_ML[UDCDmain.UD_MinigameLockpickSkillAdjust],UD_LockMenu_flag)
    UD_LockpickMinigameDuration_S       = addSliderOption("$UD_LOCKPICKMINIGAMEDURATION",UDCDmain.UD_LockpickMinigameDuration, "{0} s",UD_LockMenu_flag)
    
    UD_KeyDurability_S = addSliderOption("$UD_KEYDURABILITY",UDCDmain.UD_KeyDurability, "{0}",UD_LockMenu_flag)
    UD_HardcoreAccess_T = addToggleOption("$UD_HARDCOREACCESS", UDCDmain.UD_HardcoreAccess,UD_LockMenu_flag)
    
    UD_AllowArmTie_T = addToggleOption("$UD_KALLOWARMTIE", UDCDmain.UD_AllowArmTie,UD_LockMenu_flag)
    UD_AllowLegTie_T = addToggleOption("$UD_ALLOWLEGTIE", UDCDmain.UD_AllowLegTie,UD_LockMenu_flag)
    
    UD_MinigameDrainMult_S = addSliderOption("$UD_MINIGAMEDRAINMULT", Round(UDCDmain.UD_MinigameDrainMult * 100), "{1} %", UD_LockMenu_flag)
    UD_InitialDrainDelay_S = addSliderOption("$UD_INITIALDRAINDELAY", UDCDmain.UD_InitialDrainDelay, "{0} s", UD_LockMenu_flag)
    
    
    ;MINIGAME EXHAUSTION
    AddHeaderOption("$UD_H_MINIEXHAUS")
    addEmptyOption()
    
    UD_MinigameExhDurationMult_S     = addSliderOption("$UD_MINIEXHAUSDUR", Round(UDCDmain.UD_MinigameExhDurationMult * 100), "{0} %", UD_LockMenu_flag)
    UD_MinigameExhExponential_S      = addSliderOption("$UD_MINIEXHEXP", UDCDmain.UD_MinigameExhExponential, "{1}", UD_LockMenu_flag)

    UD_MinigameExhMagnitudeMult_S    = addSliderOption("$UD_MINIEXHAUSMAG", Round(UDCDmain.UD_MinigameExhMagnitudeMult * 100), "{0} %", UD_LockMenu_flag)
    UD_MinigameExhNoStruggleMax_S    = addSliderOption("$UD_MINIEXHNOSTRUGGMAX", Round(UDCDmain.UD_MinigameExhNoStruggleMax), "{0}", UD_LockMenu_flag)


    ;SKILL
    AddHeaderOption("$UD_H_SKILLSETTING")
    addEmptyOption()
    
    UD_BaseDeviceSkillIncrease_S = addSliderOption("$UD_BASEDEVICESKILLINCREASE",UDCDmain.UD_BaseDeviceSkillIncrease, "{0}",UD_LockMenu_flag)
    UD_SkillEfficiency_S = addSliderOption("$UD_SKILLEFFICIENCY",UDCDmain.UD_SkillEfficiency, "{0} %",UD_LockMenu_flag)
    
    ;HELPER SETTING
    AddHeaderOption("$UD_H_HELPINGSETTING")
    addEmptyOption()
    UD_MinigameHelpCd_S = addSliderOption("$UD_MINIGAMEHELPCD",UDCDmain.UD_MinigameHelpCd, "${0} min",UD_LockMenu_flag)
    UD_MinigameHelpXPBase_S = addSliderOption("$UD_MINIGAMEHELPXPBASE",UDCDmain.UD_MinigameHelpXPBase, "{0} XP",UD_LockMenu_flag)
    
    UD_MinigameHelpCD_PerLVL_S = addSliderOption("$UD_MINIGAMEHELPAMPL",UDCDmain.UD_MinigameHelpCD_PerLVL, "{0} %",UD_LockMenu_flag)
    addEmptyOption()
    
    ;HARDCORE SWIMMING
    AddHeaderOption("$UD_UNFORGIVING_SWIMMING")
    AddEmptyOption()
    UD_hardcore_swimming_T = addToggleOption("$UD_HARDCORESWIMMING", UDSS.UD_hardcore_swimming,UD_LockMenu_flag)    
    UD_hardcore_swimming_difficulty_M = AddMenuOption("$UD_HARDCORESWIMMINGDIFFICULTY", difficultyList[UDSS.UD_hardcore_swimming_difficulty],FlagSwitchOr(UD_Swimming_flag,UD_LockMenu_flag))
    
    ;CRITS
    AddHeaderOption("$UD_H_DEVICECRITS")
    AddEmptyOption()
    UD_CritEffect_M     = AddMenuOption("$UD_CRITEFFECT", criteffectList[UDCDmain.UD_CritEffect],FlagNegate(UD_autocrit_flag))
    UD_MandatoryCrit_T  = addToggleOption("$UD_MANDATORYCRIT", UDCDmain.UD_MandatoryCrit,FlagSwitchOr(FlagNegate(UD_autocrit_flag),UD_LockMenu_flag))
    
    UD_AutoCrit_T       = addToggleOption("$UD_AUTOCRIT", UDCDmain.UD_AutoCrit,UD_LockMenu_flag)
    UD_AutoCritChance_S = addSliderOption("$UD_AUTOCRITCHANCE",UDCDmain.UD_AutoCritChance, "{0} %",FlagSwitchOr(UD_autocrit_flag,UD_LockMenu_flag))
    
    UD_CritDurationAdjust_S = addSliderOption("$UD_CRITDURATIONADJUST",UDCDmain.UD_CritDurationAdjust, "${2} s",FlagSwitchOr(FlagNegate(UD_autocrit_flag),UD_LockMenu_flag))
    AddEmptyOption()
    
    ;DEVICE LEVEL scaling
    AddHeaderOption("$UD_H_LEVELSCALING")
    AddEmptyOption()
    
    UD_DeviceLvlHealth_S    = addSliderOption("$UD_DEVICELVLHEALTH",UDCDmain.UD_DeviceLvlHealth*100, "{1} %",UD_LockMenu_flag)
    UD_DeviceLvlLockpick_S  = addSliderOption("$UD_DEVICELVLLOCKPICK",UDCDmain.UD_DeviceLvlLockpick, "{1}",UD_LockMenu_flag)
    
    UD_DeviceLvlLocks_S     = addSliderOption("$UD_DEVICELVLLOCKS",UDCDmain.UD_DeviceLvlLocks, "{0} LVLs");,UD_LockMenu_flag)
    AddEmptyOption()
    
    ;DIFFICULTY
    AddHeaderOption("$UD_H_DIFFICULTY")
    AddEmptyOption()
    UD_HardcoreMode_T = addToggleOption("$UD_HARDCOREMODE", UDCDmain.UD_HardcoreMode)
    AddTextOption("$UD_STRUGGLEDIFFICULTY", Math.floor((2 - UDCDmain.getStruggleDifficultyModifier())*100 +0.5) + " %",OPTION_FLAG_DISABLED)
    
    UD_StruggleDifficulty_M = AddMenuOption("$UD_ESCAPEDIFFICULTY", difficultyList[UDCDmain.UD_StruggleDifficulty],UD_LockMenu_flag)
    AddTextOption("$UD_MENDDIFFICULTY", Math.floor(UDCDmain.getMendDifficultyModifier()*100 + 0.5) + " %",OPTION_FLAG_DISABLED)
     
    UD_UseDDdifficulty_T = addToggleOption("$UD_USEDDDIFFICULTY", UDCDmain.UD_UseDDdifficulty,UD_LockMenu_flag)
    AddTextOption("$UD_KEYMODIFIER", Math.floor((UDCDmain.CalculateKeyModifier())*100 + 0.5) + " %",OPTION_FLAG_DISABLED)
EndEvent



Int UD_ModifierSelected = 0
int UD_ModifierList_M

int UD_ModifierMultiplier_S
int UD_ModifierPatchPowerMultiplier_S
int UD_ModifierPatchChanceMultiplier_S
int UD_ModifierDescription_T

Function resetModifiersPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("Custom modifiers")
    addEmptyOption()
    
    UD_Modifier loc_mod = (UDmain.UDMOM.UD_ModifierListRef[UD_ModifierSelected] as UD_Modifier)
    
    UD_ModifierList_M = AddMenuOption("Selected modifier: ", UDmain.UDMOM.UD_ModifierList[UD_ModifierSelected])
    AddTextOption("Source",loc_mod.GetOwningQuest().GetName(),FlagSwitch(false))
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("Base details")
    addEmptyOption()
    
    AddTextOption("Name",loc_mod.NameFull,FlagSwitch(false))
    AddTextOption("Alias",loc_mod.NameAlias,FlagSwitch(false))
    
    UD_ModifierDescription_T = AddTextOption("Description","")
    addEmptyOption()
    
    AddHeaderOption("Runtime configuration")
    addEmptyOption()
    
    UD_ModifierMultiplier_S = AddSliderOption("Strength multiplier",loc_mod.Multiplier,"{1} x",UD_LockMenu_flag)
    addEmptyOption()
    
    AddHeaderOption("Patcher configuration")
    addEmptyOption()
    
;    UD_ModifierPatchPowerMultiplier_S   = AddSliderOption("Patch Strength multiplier",loc_mod.PatchPowerMultiplier,"{1} x",UD_LockMenu_flag)
;    UD_ModifierPatchChanceMultiplier_S  = AddSliderOption("Patch Chance multiplier",loc_mod.PatchChanceMultiplier,"{1} x",UD_LockMenu_flag)
EndFunction

Int UD_OutfitSelected = 0
int UD_OutfitList_M

int         UD_OutfitDisable_T
Int         UD_OutfitReset_T
Int         UD_OutfitEquip_T

Int         UD_OutfitSectionSelected = 0
int         UD_OutfitSections_M
string[]    UD_OutfitSections_ML

Function resetOutfitPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("Custom Outfits")
    addEmptyOption()
    
    UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
    
    UD_OutfitList_M = AddMenuOption("Selected outfit: ", UDOTM.UD_OutfitList[UD_OutfitSelected])
    AddTextOption("Source",loc_outfit.GetOwningQuest().GetName(),FlagSwitch(false))
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("Base details")
    addEmptyOption()
    
    AddTextOption("Name",loc_outfit.NameFull,FlagSwitch(false))
    AddTextOption("Alias",loc_outfit.NameAlias,FlagSwitch(false))
    
    UD_OutfitDisable_T  = AddToggleOption("Disabled",loc_outfit.Disable)
    AddTextOption("Random?",loc_outfit.Random as String,FlagSwitch(false))
    
    UD_OutfitReset_T    = AddTextOption("==RESET==", "$-PRESS-")
    UD_OutfitEquip_T    = AddTextOption("==EQUIP==", "$-PRESS-",FlagSwitch(UDMain.DebugMod))
    
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("Devices")
    UD_OutfitSections_M = AddMenuOption("Section: ", UD_OutfitSections_ML[UD_OutfitSectionSelected])
    
    ShowOutfitDevices(loc_outfit)
    ; TODO - Show all devices locked by outfit
EndFunction

Int[] UD_OutfitDeviceSelected_S
Int[] UD_OutfitDeviceSelectedType
Int[] UD_OutfitDeviceSelectedIndex
Function ShowOutfitDevices(UD_Outfit akOutfit)
    UD_OutfitDeviceSelected_S = Utility.CreateIntArray(0)
    UD_OutfitDeviceSelectedType = Utility.CreateIntArray(0)
    UD_OutfitDeviceSelectedIndex = Utility.CreateIntArray(0)
    if UD_OutfitSectionSelected == 0
        ShowOutfitDevicesFromList("Hoods",akOutfit.UD_Hood, akOutfit.UD_Hood_RND,1)
        ShowOutfitDevicesFromList("Gags",akOutfit.UD_Gag, akOutfit.UD_Gag_RND,2)
        ShowOutfitDevicesFromList("Blindfold",akOutfit.UD_Blindfold, akOutfit.UD_Blindfold_RND,3)
        ShowOutfitDevicesFromList("Collar",akOutfit.UD_Collar, akOutfit.UD_Collar_RND,4)
    elseif UD_OutfitSectionSelected == 1
        ShowOutfitDevicesFromList("Suit",akOutfit.UD_Suit, akOutfit.UD_Suit_RND,5)
        ShowOutfitDevicesFromList("Belt",akOutfit.UD_Belt, akOutfit.UD_Belt_RND,6)
        ShowOutfitDevicesFromList("Bra",akOutfit.UD_Bra, akOutfit.UD_Bra_RND,7)
        ShowOutfitDevicesFromList("CorsetHarness",akOutfit.UD_CorsetHarness, akOutfit.UD_CorsetHarness_RND,8)
    elseif UD_OutfitSectionSelected == 2
        ShowOutfitDevicesFromList("Gloves",akOutfit.UD_Gloves, akOutfit.UD_Gloves_RND,9)
        ShowOutfitDevicesFromList("Arm cuffs",akOutfit.UD_CuffsArms, akOutfit.UD_CuffsArms_RND,10)
        ShowOutfitDevicesFromList("Heavy Bondage",akOutfit.UD_HeavyBondage, akOutfit.UD_HeavyBondage_RND,11)
    elseif UD_OutfitSectionSelected == 3
        ShowOutfitDevicesFromList("Boots",akOutfit.UD_Boots, akOutfit.UD_Boots_RND,12)
        ShowOutfitDevicesFromList("Leg cuffs",akOutfit.UD_CuffsLegs, akOutfit.UD_CuffsLegs_RND,13)
    elseif UD_OutfitSectionSelected == 4
        ShowOutfitDevicesFromList("Plug Vaginal",akOutfit.UD_PlugVaginal, akOutfit.UD_PlugVaginal_RND,14)
        ShowOutfitDevicesFromList("Plug Anal",akOutfit.UD_PlugAnal, akOutfit.UD_PlugAnal_RND,15)
        ShowOutfitDevicesFromList("Piercing vaginal",akOutfit.UD_PiercingVag, akOutfit.UD_PiercingVag_RND,16)
        ShowOutfitDevicesFromList("Piercing nipple",akOutfit.UD_PiercingNip, akOutfit.UD_PiercingNip_RND,17)
    endif
EndFunction

Function ShowOutfitDevicesFromList(String asSubSection, Armor[] aakList, Int[] aaiRnd,Int aiType)
    if !aakList
        return
    endif
    
    AddHeaderOption(asSubSection)
    addEmptyOption()

    int loc_i = 0
    while loc_i < aakList.length
        AddTextOption("["+loc_i+"]",aakList[loc_i].GetName())
        int loc_id = AddSliderOption("Weight: ",aaiRnd[loc_i],"{0}")
        UD_OutfitDeviceSelected_S   = PapyrusUtil.PushInt(UD_OutfitDeviceSelected_S,loc_id)
        UD_OutfitDeviceSelectedType = PapyrusUtil.PushInt(UD_OutfitDeviceSelectedType,aiType)
        UD_OutfitDeviceSelectedIndex = PapyrusUtil.PushInt(UD_OutfitDeviceSelectedIndex,loc_i)
        loc_i += 1
    endwhile
EndFunction

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
int UD_OrgasmExhaustionStruggleMax_S

Event resetCustomOrgasmPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_GENERAL")
    addEmptyOption()
        
    UD_OrgasmUpdateTime_S   = addSliderOption("$UD_ORGASMUPDATETIME",UDCONF.UD_OrgasmUpdateTime, "${1} s")

    UD_OrgasmExhaustion_T   = addToggleOption("$UD_ORGASMEXHAUSTION",UDmain.UD_OrgasmExhaustion,UD_LockMenu_flag)
    addEmptyOption()
    UD_OrgasmExhaustionStruggleMax_S = addSliderOption("$UD_ORGASMEXHAUSTIONSTRUGGLEMAX", UDCONF.UD_OrgasmExhaustionStruggleMax, "${0} orgasms",UD_LockMenu_flag)
    
    UD_UseOrgasmWidget_T    = addToggleOption("$UD_USEORGASMWIDGET", UDCONF.UD_UseOrgasmWidget)
    UD_OrgasmResistence_S   = addSliderOption("$UD_ORGASMRESISTENCE",UDCONF.UD_OrgasmResistence, "{1} Op/s",UD_LockMenu_flag)

    UD_HornyAnimation_T     = addToggleOption("$UD_HORNYANIMATION", UDCONF.UD_HornyAnimation)
    UD_HornyAnimationDuration_S     = addSliderOption("$UD_HORNYANIMATIONDURATION",UDCONF.UD_HornyAnimationDuration, "${0} s",UD_Horny_f)
    
    AddHeaderOption("$UD_H_POSTORGASM")
    addEmptyOption()
    UD_OrgasmArousalReduce_S    = addSliderOption("$UD_ORGASMAROUSALREDUCE",UDCONF.UD_OrgasmArousalReduce, "${0} /s")
    UD_OrgasmArousalReduceDuration_S = addSliderOption("$UD_ORGASMAROUSALREDUCEDURATION",UDCONF.UD_OrgasmArousalReduceDuration, "${0} s")
    
    AddHeaderOption("$UD_H_VIBRATIONSETTING")
    addEmptyOption()    
    UD_VibrationMultiplier_S    = addSliderOption("$UD_VIBRATIONMULTIPLIER",UDCDmain.UD_VibrationMultiplier, "{3}",UD_LockMenu_flag)
    UD_ArousalMultiplier_S      = addSliderOption("$UD_AROUSALMULTIPLIER",UDCDmain.UD_ArousalMultiplier, "{3}",UD_LockMenu_flag)
EndEvent

Int UD_AIEnable_T
Int UD_AIUpdateTime_S
Int UD_AICooldown_S
Event resetNPCsPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_H_NPCSINTELIGENCE")
    addEmptyOption()
    
    UD_AIEnable_T = addToggleOption("$UD_AIENABLE", UDAI.Enabled)
    addEmptyOption()
    
    UD_AIUpdateTime_S   = addSliderOption("$UD_ORGASMUPDATETIME",UDAI.UD_UpdateTime, "${0} s",      FlagSwitch(UDAI.Enabled))
    UD_AICooldown_S     = addSliderOption("$UD_MINIGAMEHELPCD",UDAI.UD_AICooldown, "${0} min",    FlagSwitchOr(UD_LockMenu_flag,FlagSwitch(UDAI.Enabled)))
    
    AddHeaderOption("$UD_H_AUTOSCAN")
    addEmptyOption()
    
    UD_NPCSupport_T         = addToggleOption("$UD_NPCSUPPORT",UDmain.AllowNPCSupport)
EndEvent

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
int UD_TimedLocks_T

Event resetPatcherPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_H_MAINVALUES")
    addEmptyOption()
 
    UD_PatchMult_S = addSliderOption("$UD_PATCHMULT",UDCDmain.UDPatcher.UD_PatchMult, "{1} x",UD_LockMenu_flag)
    UD_EscapeModifier_S = addSliderOption("$UD_ESCAPEMODIFIER",UDCDmain.UDPatcher.UD_EscapeModifier, "{0}",UD_LockMenu_flag)
    
    UD_MinLocks_S = addSliderOption("$UD_MINLOCKS",UDCDmain.UDPatcher.UD_MinLocks, "{0}",UD_LockMenu_flag)
    UD_MaxLocks_S = addSliderOption("$UD_MAXLOCKS",UDCDmain.UDPatcher.UD_MaxLocks, "{0}",UD_LockMenu_flag)
    
    UD_MinResistMult_S = addSliderOption("$UD_MINRESISTMULT",Round(UDCDmain.UDPatcher.UD_MinResistMult*100), "{0} %",UD_LockMenu_flag)
    UD_MaxResistMult_S = addSliderOption("$UD_MAXRESISTMULT",Round(UDCDmain.UDPatcher.UD_MaxResistMult*100), "{0} %",UD_LockMenu_flag)
    
    UD_TimedLocks_T    = addToggleOption("Timed locks", UDCDmain.UDPatcher.UD_TimedLocks)
    addEmptyOption()
    
    AddHeaderOption("$UD_H_DEVICEDIFFICULTYMODIFIERS")
    addEmptyOption()
    
    UD_PatchMult_HeavyBondage_S = addSliderOption("$UD_USEHEAVYBONDAGE",UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage, "{1} x",UD_LockMenu_flag)
    UD_PatchMult_Blindfold_S = addSliderOption("$UD_BLINDFOLD",UDCDmain.UDPatcher.UD_PatchMult_Blindfold, "{1} x",UD_LockMenu_flag)
    
    UD_PatchMult_Gag_S = addSliderOption("$UD_GAG",UDCDmain.UDPatcher.UD_PatchMult_Gag, "{1} x",UD_LockMenu_flag)
    UD_PatchMult_Hood_S = addSliderOption("$UD_HOOD",UDCDmain.UDPatcher.UD_PatchMult_Hood, "{1} x",UD_LockMenu_flag)
    
    UD_PatchMult_ChastityBelt_S = addSliderOption("$UD_CHASTITYBELT",UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt, "{1} x",UD_LockMenu_flag)
    UD_PatchMult_ChastityBra_S = addSliderOption("$UD_CHASTITYBRA",UDCDmain.UDPatcher.UD_PatchMult_ChastityBra, "{1} x",UD_LockMenu_flag)
    
    UD_PatchMult_Plug_S = addSliderOption("$UD_PLUG",UDCDmain.UDPatcher.UD_PatchMult_Plug, "{1} x",UD_LockMenu_flag)
    UD_PatchMult_Piercing_S = addSliderOption("$UD_PIERCING",UDCDmain.UDPatcher.UD_PatchMult_Piercing, "{1} x",UD_LockMenu_flag)
    
    UD_PatchMult_Generic_S = addSliderOption("$UD_GENERIC",UDCDmain.UDPatcher.UD_PatchMult_Generic, "{1} x",UD_LockMenu_flag)
    addEmptyOption()
EndEvent

zadBoundCombatScript_UDPatch Property AAScript
    zadBoundCombatScript_UDPatch Function get()
        return libs.BoundCombat as zadBoundCombatScript_UDPatch
    EndFunction
EndProperty

int UD_StartThirdpersonAnimation_Switch_T
Int UD_OutfitRemove_T
Int UD_CheckAllKw_T
Int UD_AllowMenBondage_T

Event resetDDPatchPage()
    UpdateLockMenuFlag()
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_GENERAL")
    addEmptyOption()
    
    UD_GagPhonemModifier_S = addSliderOption("$UD_GAGPHONEMMODIFIER",UDCDmain.UD_GagPhonemModifier, "{0}",FlagSwitch(!UDmain.ZadExpressionSystemInstalled))
    UD_CheckAllKw_T = addToggleOption("$UD_CHECKALLKW",UDmain.UD_CheckAllKw)
    
    AddHeaderOption("$UD_H_ANIMATIONSETTING")
    addEmptyOption()
    
    UD_StartThirdpersonAnimation_Switch_T = addToggleOption("$UD_STARTTHIRDPERSONANIMATIONSWITCH", libs.UD_StartThirdPersonAnimation_Switch)
    UD_OrgasmAnimation_M = AddMenuOption("$UD_ORGASMANIMATION", orgasmAnimation[UDCONF.UD_OrgasmAnimation]) 
    
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("$UD_H_DEVICESETTING")
    addEmptyOption()
    ;UD_OutfitRemove_T = addToggleOption("$UD_OUTFITREMOVE", UDCDmain.UD_OutfitRemove)
    addEmptyOption()
    UD_AllowMenBondage_T = addToggleOption("$UD_ALLOWMENBONDAGE", UDmain.AllowMenBondage,FlagSwitch(UDmain.ForHimInstalled))
EndEvent

UD_WidgetControl Property UDWC Hidden
    UD_WidgetControl Function Get()
        return UDMain.UDWC
    EndFunction
EndProperty

int UD_UseIWantWidget_T
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
    AddHeaderOption("$UD_H_WIDGETS")
    AddTextOption("iWantWidgets", InstallSwitch(UDmain.iWidgetInstalled), FlagSwitch(UDmain.iWidgetInstalled))
    UD_UseIWantWidget_T = AddToggleOption("$UD_USEIWANTWIDGET", UDWC.UD_UseIWantWidget, FlagSwitch(UDmain.iWidgetInstalled))
    ; device widgets
    AddHeaderOption("$UD_H_DEVICEWIDGETS")
    UD_UseWidget_T = addToggleOption("$UD_USEWIDGET", UDCDmain.UD_UseWidget)
    UD_WidgetPosX_M = AddMenuOption("$UD_WIDGETPOSX", widgetXList[UDWC.UD_WidgetXPos], FlagSwitch(UDCDmain.UD_UseWidget))
    UD_WidgetPosY_M = AddMenuOption("$UD_WIDGETPOSY", widgetYList[UDWC.UD_WidgetYPos], FlagSwitch(UDCDmain.UD_UseWidget))
;    
    ; RIGHT COLUMN
    SetCursorPosition(1)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_H_OVERLAYSETTINGS")
    UD_EnableCNotifications_S = AddToggleOption("$UD_ENABLECNOTIFICATIONS", UDWC.UD_EnableCNotifications, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    UD_TextFontSize_S = addSliderOption("$UD_TEXTFONTSIZE", UDWC.UD_TextFontSize, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_TextLineLength_S = addSliderOption("$UD_TEXTLINELENGTH", UDWC.UD_TextLineLength, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_TextReadSpeed_S = addSliderOption("$UD_TEXTREADSPEED", UDWC.UD_TextReadSpeed, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_FilterVibNotifications_T = AddToggleOption("$UD_FILTERVIBNOTIFICATIONS", UDWC.UD_FilterVibNotifications, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    If UDWC.UD_TextAnchor < 0 || UDWC.UD_TextAnchor > 3
        UDMain.Warning("UD_MCM_script::resetUIWidgetPage() WTF! UDWC.UD_TextAnchor = " + UDWC.UD_TextAnchor)
        UDWC.UD_TextAnchor = 1
    EndIf
    UD_TextAnchor_M = addMenuOption("$UD_TEXTANCHOR", UD_TextAnchorList[UDWC.UD_TextAnchor], a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_TextPadding_S = addSliderOption("$UD_TEXTPADDING", UDWC.UD_TextPadding, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableCNotifications))
    UD_EnableDeviceIcons_T = AddToggleOption("$UD_ENABLEDEVICEICONS", UDWC.UD_EnableDeviceIcons, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    UD_EnableDebuffIcons_T = AddToggleOption("$UD_ENABLEDEBUFFICONS", UDWC.UD_EnableDebuffIcons, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget))
    UD_IconsSize_S = addSliderOption("$UD_ICONSSIZE", UDWC.UD_IconsSize, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && (UDWC.UD_EnableDeviceIcons || UDWC.UD_EnableDebuffIcons)))
    If UDWC.UD_IconsAnchor < 0 || UDWC.UD_IconsAnchor > 2
        UDMain.Warning("UD_MCM_script::resetUIWidgetPage() WTF! UDWC.UD_IconsAnchor = " + UDWC.UD_IconsAnchor)
        UDWC.UD_IconsAnchor = 1
    EndIf
    UD_IconsAnchor_M = addMenuOption("$UD_ICONSANCHOR", UD_IconsAnchorList[UDWC.UD_IconsAnchor], a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && (UDWC.UD_EnableDeviceIcons || UDWC.UD_EnableDebuffIcons)))
    UD_IconsPadding_S = addSliderOption("$UD_ICONSPADDING", UDWC.UD_IconsPadding, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && (UDWC.UD_EnableDeviceIcons || UDWC.UD_EnableDebuffIcons)))
    
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
    UD_IconVariant_EffExhaustion_M = addMenuOption("$UD_ICONVARIANTEFFEXHAUSTION", variant_str, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableDebuffIcons && !variant_err))
    variant_index = UDWC.StatusEffect_GetVariant("effect-orgasm")
    If variant_index < 0 || variant_index >= UD_IconVariant_EffOrgasmList.Length
        variant_str = "ERROR"
        variant_err = True
    Else
        variant_err = False
        variant_str = UD_IconVariant_EffOrgasmList[variant_index]
    EndIf
    UD_IconVariant_EffOrgasm_M = addMenuOption("$UD_ICONVARIANT_EFFORGASM", variant_str, a_flags = FlagSwitch(UDmain.iWidgetInstalled && UDWC.UD_UseIWantWidget && UDWC.UD_EnableDebuffIcons && !variant_err))
    
    UD_WidgetTest_T = AddTextOption("$UD_WIDGETTEST", "$-CLICK-")
    UD_WidgetReset_T = AddTextOption("$UD_WIDGETRESET", "$-CLICK-")
EndEvent

UD_AnimationManagerScript Property UDAM Hidden
    UD_AnimationManagerScript Function Get()
        return UDmain.UDAM
    EndFunction
EndProperty

Int UDAM_AnimationJSON_First_T
Int UDAM_AnimationJSON_First_INFO
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

String[] UDAM_TestQuery_Results_JsonPath
String[] UDAM_TestQuery_Results_AnimEvent

Int UDAM_TestQuery_Results_JsonPath_First_T
Int UDAM_TestQuery_Results_AnimEvent_First_T

Int UDAM_TestQuery_ElapsedTime_T

Int UD_AlternateAnimation_T
Int UD_AlternateAnimationPeriod_S

Int UD_UseSingleStruggleKeyword_T

Actor LastHelper
Int UD_Helper_T

Event resetAnimationsPage() 
       
    Int flags = OPTION_FLAG_NONE
        
    UpdateLockMenuFlag()
    Int rows_right = 0
    Int rows_left = 0
    Int json_section_pos = 0
    
; LEFT COLUMN

    SetCursorPosition(0)
    
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    AddHeaderOption("$UD_H_ANIMATIONPLAYBACKOPTIONS")
    rows_left += 1
    UD_AlternateAnimation_T = addToggleOption("$UD_ALTERNATEANIMATION", UDAM.UD_AlternateAnimation)
    rows_left += 1
    If UDAM.UD_AlternateAnimation
        flags = OPTION_FLAG_NONE
    Else
        flags = OPTION_FLAG_DISABLED
    EndIf
    UD_AlternateAnimationPeriod_S = AddSliderOption("$UD_ALTERNATEANIMATIONPERIOD", UDAM.UD_AlternateAnimationPeriod, "${0} s", flags)
    rows_left += 1
    UD_UseSingleStruggleKeyword_T = AddToggleOption("$UD_USESINGLESTRUGGLEKEYWORD", UDAM.UD_UseSingleStruggleKeyword)
    rows_left += 1
    
; JSONS SECTION
    If rows_right > rows_left
        json_section_pos = rows_right * 2
        rows_left = rows_right
    Else
        json_section_pos = rows_left * 2
        rows_right = rows_left
    EndIf

; LEFT COLUMN
    SetCursorPosition(json_section_pos)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_LOADEDJSONS")
    rows_left += 1
    Int i = 0
    While i < UDAM.UD_AnimationJSON_All.Length
        Bool val = False
        flags = OPTION_FLAG_NONE
        If UDAM.UD_AnimationJSON_Status[i] > 1
            flags = OPTION_FLAG_DISABLED
        Else
            val = UDAM.UD_AnimationJSON_Status[i] == 0
        EndIf
        Int id = AddToggleOption(UDAM.UD_AnimationJSON_All[i], val, flags)
        If i == 0
            UDAM_AnimationJSON_First_T = id
        EndIf
        i += 1
        rows_left += 1
    EndWhile
    UDAM_Reload_T =  AddTextOption("$UD_RELOADJSONS", "$-PRESS-")
    rows_left += 1
    
; RIGHT COLUMN
    SetCursorPosition(json_section_pos + 1)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_LOADEDJSONS_STATUS")
    rows_right += 1
    i = 0
    While i < UDAM.UD_AnimationJSON_All.Length
        String status = "$UD_LOADEDJSONS_STATUS_UNKNOWN"
        If UDAM.UD_AnimationJSON_Status[i] <= 1
            status = "$UD_LOADEDJSONS_STATUS_READY"
        ElseIf UDAM.UD_AnimationJSON_Status[i] == 2
            status = "$UD_LOADEDJSONS_STATUS_CONDITION"
        ElseIf UDAM.UD_AnimationJSON_Status[i] == 3
            status = "$UD_LOADEDJSONS_STATUS_ERRORS"
        EndIf
        Int id = AddTextOption(status, "$-INFO-")
        If i == 0
            UDAM_AnimationJSON_First_INFO = id
        EndIf
        i += 1
        rows_right += 1
    EndWhile

EndEvent

Event resetAnimationsPlaygroundPage() 
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
        UDAM_TestQuery_PlayerArms_List[1] = "$Yoke"
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
    AddHeaderOption("$UD_H_TESTANIMATIONQUERY")
    rows_left += 1
    UDAM_TestQuery_Type_M = AddMenuOption("$UD_TESTQUERY", UDAM_TestQuery_Type_List[UDAM_TestQuery_Type_Index])
    rows_left += 1
    UDAM_TestQuery_Keyword_M = AddMenuOption("$UD_TESTQUERY_KEYWORD", UDAM_TestQuery_Keyword_List[UDAM_TestQuery_Keyword_Index])
    rows_left += 1

    UDAM_TestQuery_PlayerArms_M = AddMenuOption("$UD_TESTQUERY_PLAYERARMS", UDAM_TestQuery_PlayerArms_List[UDAM_TestQuery_PlayerArms_Index])
    rows_left += 1
    UDAM_TestQuery_PlayerLegs_M = AddMenuOption("$UD_TESTQUERY_PLAYERLEGS", UDAM_TestQuery_PlayerLegs_List[UDAM_TestQuery_PlayerLegs_Index])
    rows_left += 1
    UDAM_TestQuery_PlayerMittens_T = AddToggleOption("$UD_TESTQUERY_PLAYERMITTENS", UDAM_TestQuery_PlayerMittens)
    rows_left += 1
    UDAM_TestQuery_PlayerGag_T = AddToggleOption("$UD_TESTQUERY_PLAYERGAG", UDAM_TestQuery_PlayerGag)
    rows_left += 1
    
; RIGHT COLUMN

    SetCursorPosition(1)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_H_TESTANIMATIONQUERY")
    rows_right += 1
    AddEmptyOption()
    rows_right += 1
    
    Int helper_flags = OPTION_FLAG_NONE
    If UDAM_TestQuery_Type_Index == 0
        helper_flags = OPTION_FLAG_DISABLED
    EndIf
    If LastHelper
        AddTextOption("$UD_HELPER", LastHelper.GetActorBase().GetName(), OPTION_FLAG_DISABLED)
    Else
        UD_Helper_T = AddTextOption("$UD_HELPER", "----", OPTION_FLAG_NONE)
    EndIf
    rows_right += 1
    
    UDAM_TestQuery_HelperArms_M = AddMenuOption("$UD_TESTQUERY_HELPERARMS", UDAM_TestQuery_PlayerArms_List[UDAM_TestQuery_HelperArms_Index])
    rows_right += 1
    UDAM_TestQuery_HelperLegs_M = AddMenuOption("$UD_TESTQUERY_HELPERLEGS", UDAM_TestQuery_PlayerLegs_List[UDAM_TestQuery_HelperLegs_Index])
    rows_right += 1
    UDAM_TestQuery_HelperMittens_T = AddToggleOption("$UD_TESTQUERY_HELPERMITTENS", UDAM_TestQuery_HelperMittens)
    rows_right += 1
    UDAM_TestQuery_HelperGag_T = AddToggleOption("$UD_TESTQUERY_HELPERGAG", UDAM_TestQuery_HelperGag)
    rows_right += 1
    
    UDAM_TestQuery_Request_T =  AddTextOption("$UD_TESTQUERY_REQUEST", "$-PRESS-")
    rows_right += 1
    If UDAM.IsAnimating(UDMain.Player)
        flags = OPTION_FLAG_NONE
    Else
        flags = OPTION_FLAG_DISABLED
    EndIf
    UDAM_TestQuery_StopAnimation_T =  AddTextOption("$UD_TESTQUERY_STOPANIMATION", "$-PRESS-", flags)
    rows_right += 1
    
; BOTH COLUMNS 
    If rows_right > rows_left
        SetCursorPosition(rows_right * 2)
    Else
        SetCursorPosition(rows_left * 2)
    EndIf
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("$UD_H_TEST_ANIMATION_QUERY_RESULTS_FILE")
    AddHeaderOption("$UD_H_TEST_ANIMATION_QUERY_RESULTS_PATH")
    
    AddTextOption("$UD_H_NUMBER_OF_FOUND_ANIMATIONS", UDAM_TestQuery_Results_JsonPath.Length, OPTION_FLAG_DISABLED)
    UDAM_TestQuery_ElapsedTime_T = AddTextOption("$UD_TESTQUERY_ELAPSEDTIME", (UDAM_TestQuery_TimeSpan * 1000) As Int + " ms", OPTION_FLAG_DISABLED)
    
    If LastHelper == None && UDAM_TestQuery_Type_Index == 1
        flags = OPTION_FLAG_DISABLED
    Else
        flags = OPTION_FLAG_NONE
    EndIf
    Int i = 0
    While i < UDAM_TestQuery_Results_JsonPath.Length
        String item_name = ""
        Int part_index = StringUtil.Find(UDAM_TestQuery_Results_JsonPath[i], ":")
;       String file_part = StringUtil.Substring(UDAM_TestQuery_Results_JsonPath[i], 0, part_index)
;       String path_part = StringUtil.Substring(UDAM_TestQuery_Results_JsonPath[i], part_index + 1)
        If part_index > -1
            item_name = StringUtil.Substring(UDAM_TestQuery_Results_JsonPath[i], 0, part_index)         ; part of the path with file name
        Else
            item_name = UDAM_TestQuery_Results_JsonPath[i]
        EndIf
        Int id = AddTextOption(item_name, "$-INFO-")
        If i == 0
            UDAM_TestQuery_Results_JsonPath_First_T = id
        EndIf
        id = AddTextOption("", "$-PLAY-")
        If i == 0
            UDAM_TestQuery_Results_AnimEvent_First_T = id
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
    AddHeaderOption("$UD_H_DEVICE_SLOTS")
    AddHeaderOption("$UD_H_NPC SLOTS")
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
            registered_devices_T[i] = AddTextOption((i + 1) + ") " , "$UD_EMPTY" ,OPTION_FLAG_DISABLED)
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
                AddHeaderOption("$UD_H_TOOLS")
            elseif i == 17
                AddTextOption("$UD_DEVICES", slot.getNumberOfRegisteredDevices() ,OPTION_FLAG_DISABLED)
            elseif i == 18
                OrgasmResist_S          = addSliderOption("$UD_ORGASMRESIST",OrgasmSystem.GetOrgasmVariable(slot.getActor(),3), "{1}",OPTION_FLAG_DISABLED)
            elseif i == 19
                OrgasmCapacity_S        = addSliderOption("$UD_ORGASMCAPACITY",OrgasmSystem.GetOrgasmVariable(slot.getActor(),5), "{0}",OPTION_FLAG_DISABLED)
            elseif i == 20
                unlockAll_T             = AddTextOption("$UD_UNLOCK_ALL", "$CLICK" ,FlagSwitchAnd(UD_LockMenu_flag,FlagSwitch(!UDmain.UD_LockDebugMCM)))
            elseif i == 21
                endAnimation_T          = AddTextOption("$UD_ENDANIMATION", "$CLICK" )
            elseif i == 22
                fixBugs_T               = AddTextOption("$UD_FIXBUGS", "$CLICK" ,fix_flag)
            elseif i == 23
                if !slot.isPlayer()
                    unregisterNPC_T = AddTextOption("$UD_UNREGISTER_NPC","$CLICK")
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
    
    AddHeaderOption("$UD_H_GLOBAL")
    addEmptyOption()
    
    rescanSlots_T = AddTextOption("$UD_RESCANSLOTS", "$CLICK")
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
    
    AddHeaderOption("$UD_H_CONFIG")
    addEmptyOption()
    
    UD_Export_T =  AddTextOption("$UD_SAVE_SETTINGS", "$-PRESS-")
    UD_Import_T = AddTextOption("$UD_LOAD_SETTINGS", "$-PRESS-")
    
    UD_Default_T = AddTextOption("$UD_RESET_TO_DEFAULT", "$-PRESS-")
    UD_AutoLoad_T = AddToggleOption("$UD_AUTO_LOAD", UDmain.UD_AutoLoad)
    
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("$UD_H_OPTIONAL_MODS")
    addEmptyOption()
    
    AddTextOption("$ConsoleUtil installed",InstallSwitch(UDmain.ConsoleUtilInstalled),FlagSwitch(UDmain.ConsoleUtilInstalled))
    addEmptyOption()
    
    AddTextOption("$SlaveTats installed",InstallSwitch(UDmain.SlaveTatsInstalled),FlagSwitch(UDmain.SlaveTatsInstalled))
    addEmptyOption()

    AddTextOption("Devious Devices For Him",InstallSwitch(UDmain.ForHimInstalled),FlagSwitch(UDmain.ForHimInstalled))
    addEmptyOption()

    AddTextOption("powerofthree's Papyrus Extender",InstallSwitch(UDmain.PO3Installed),FlagSwitch(UDmain.PO3Installed))
    addEmptyOption()

    AddTextOption("Improved Camera",InstallSwitch(UDmain.ImprovedCameraInstalled),FlagSwitch(UDmain.ImprovedCameraInstalled))
    addEmptyOption()
    
    AddTextOption("Experience",InstallSwitch(UDmain.ExperienceInstalled),FlagSwitch(UDmain.ExperienceInstalled))
    addEmptyOption()
    
    AddTextOption("Skyrim Souls",InstallSwitch(UDmain.SkyrimSoulsInstalled),FlagSwitch(UDmain.SkyrimSoulsInstalled))
    addEmptyOption()
EndFunction

String Function InstallSwitch(Bool abSwitch)
    if abSwitch
        return "$INSTALLED"
    else
        return "$NOT INSTALLED"
    endif
EndFunction

event OnOptionSelect(int option)
    OptionSelectGeneral(option)
    OptionSelectPatcher(option)
    OptionSelectModifiers(option)
    OptionSelectOutfit(option)
    OptionSelectFilter(option)
    OptionCustomBondage(option)
    OptionCustomOrgasm(option)
    OptionSelectNPCs(option)
    OptionDDPatch(option)
    OptionSelectAbadon(option)
    OptionSelectUiWidget(option)
    OptionSelectAnimations(option)
    OptionSelectAnimationsPlayground(option)
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

Function OptionSelectPatcher(int option)
    if(option == UD_TimedLocks_T)
        UDCDmain.UDPatcher.UD_TimedLocks = !UDCDmain.UDPatcher.UD_TimedLocks
        SetToggleOptionValue(UD_TimedLocks_T, UDCDmain.UDPatcher.UD_TimedLocks)
    endif
EndFunction

Function OptionSelectModifiers(int option)
    if(option == UD_ModifierDescription_T)
        UD_Modifier loc_mod = (UDmain.UDMOM.UD_ModifierListRef[UD_ModifierSelected] as UD_Modifier)
        ShowMessage(loc_mod.Description,false,"Close")
    endif
EndFunction

Function OptionSelectOutfit(int option)
    if(option == UD_OutfitDisable_T)
        UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
        loc_outfit.Disable = !loc_outfit.Disable
        SetToggleOptionValue(UD_OutfitDisable_T, loc_outfit.Disable)
    elseif option == UD_OutfitReset_T
        if ShowMessage("Do you really want to reset the outfit and set it to default values?")
            UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
            loc_outfit.Reset()
            forcePageReset()
        endif
    elseif option == UD_OutfitEquip_T
        UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
        closeMCM()
        loc_outfit.LockDevices(UDMain.Player)
    endif
EndFunction

Function OptionSelectFilter(int option)
    if (option == UD_UseArmCuffs_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00001000)
        SetToggleOptionValue(UD_UseArmCuffs_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00001000))
        forcePageReset()
    elseif (option == UD_UseBelts_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00020000)
        SetToggleOptionValue(UD_UseBelts_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00020000))
        forcePageReset()
    elseif (option == UD_UseBlindfolds_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000400)
        SetToggleOptionValue(UD_UseBlindfolds_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000400))
        forcePageReset()
    elseif (option == UD_UseBoots_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000800)
        SetToggleOptionValue(UD_UseBoots_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000800))
        forcePageReset()
    elseif (option == UD_UseBras_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00010000)
        SetToggleOptionValue(UD_UseBras_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00010000))
        forcePageReset()
    elseif (option == UD_UseCollars_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000100)
        SetToggleOptionValue(UD_UseCollars_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000100))
        forcePageReset()
    elseif (option == UD_UseCorsets_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000040)
        SetToggleOptionValue(UD_UseCorsets_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000040))
        forcePageReset()
    elseif (option == UD_UseGags_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000200)
        SetToggleOptionValue(UD_UseGags_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000200))
        forcePageReset()
    elseif (option == UD_UseGloves_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00008000)
        SetToggleOptionValue(UD_UseGloves_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00008000))
        forcePageReset()
    elseif (option == UD_UseHarnesses_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000020)
        SetToggleOptionValue(UD_UseHarnesses_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000020))
        forcePageReset()
    elseif (option == UD_UseHeavyBondage_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000010)
        SetToggleOptionValue(UD_UseHeavyBondage_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000010))
        forcePageReset()
    elseif (option == UD_UseHoods_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000080)
        SetToggleOptionValue(UD_UseHeavyBondage_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000080))
        forcePageReset()
    elseif (option == UD_UseLegCuffs_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00002000)
        SetToggleOptionValue(UD_UseLegCuffs_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00002000))
        forcePageReset()
    elseif (option == UD_UsePiercingsNipple_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000002)
        SetToggleOptionValue(UD_UsePiercingsNipple_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000002))
        forcePageReset()
    elseif (option == UD_UsePiercingsVaginal_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000001)
        SetToggleOptionValue(UD_UsePiercingsVaginal_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000001))
        forcePageReset()
    elseif (option == UD_UsePlugsAnal_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000008)
        SetToggleOptionValue(UD_UsePlugsAnal_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000008))
        forcePageReset()
    elseif (option == UD_UsePlugsVaginal_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000004)
        SetToggleOptionValue(UD_UsePlugsVaginal_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000004))
        forcePageReset()
    elseif (option == UD_UseSuits_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00004000)
        SetToggleOptionValue(UD_UseSuits_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00004000))
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
        UDCONF.UD_UseOrgasmWidget = !UDCONF.UD_UseOrgasmWidget
        SetToggleOptionValue(UD_UseOrgasmWidget_T, UDCONF.UD_UseOrgasmWidget)
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
        UDCONF.UD_HornyAnimation = !UDCONF.UD_HornyAnimation
        SetToggleOptionValue(UD_HornyAnimation_T, UDCONF.UD_HornyAnimation)
        if UDCONF.UD_HornyAnimation
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
        ShowMessage("$To avoid possible errors when switching between different UI modes, please save your game and then load from that save.", False, "OK")
        forcePageReset()
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
        UDmain.Print("UI reset start - wait!")
        UDWC.Notification_Reset()
        UDWC.StatusEffect_ResetValues()
        UDWC.InitWidgetsRequest(abMeters = True, abIcons = True, abText = True)
        UnforgivingDevicesMain.ResetQuest(UDWC)
        while !UDWC.Ready
            Utility.WaitMenuMode(0.5)
        endwhile
        UDmain.UDWC.Meter_RegisterNative("player-orgasm",0,0.0,0.0, true)
        UDmain.UDWC.Meter_LinkActorOrgasm(Game.GetPlayer(),"player-orgasm")
        UDmain.Print("UI reset done!")
    endif
EndFunction

Function OptionSelectAnimations(int option)
    If UDAM_AnimationJSON_First_T == 0 
        Return
    EndIf
    If (option >= UDAM_AnimationJSON_First_T) && (option <= (UDAM_AnimationJSON_First_T + (UDAM.UD_AnimationJSON_All.Length - 1) * 2)) && (((option - UDAM_AnimationJSON_First_T) % 2) == 0)
        Int index = (option - UDAM_AnimationJSON_First_T) / 2
        String val = UDAM.UD_AnimationJSON_All[index]
        If UDAM.UD_AnimationJSON_Off.Find(val) == -1
            UDAM.UD_AnimationJSON_Off = PapyrusUtil.PushString(UDAM.UD_AnimationJSON_Off, UDAM.UD_AnimationJSON_All[index])
            SetToggleOptionValue(option, False)
        Else
            UDAM.UD_AnimationJSON_Off = PapyrusUtil.RemoveString(UDAM.UD_AnimationJSON_Off, UDAM.UD_AnimationJSON_All[index])
            SetToggleOptionValue(option, True)
        EndIf
        UD_Native.SyncAnimationSetting(UDAM.UD_AnimationJSON_Off)
    ElseIf option == UDAM_Reload_T
        SetOptionFlags(option, OPTION_FLAG_DISABLED)
        UDAM.LoadAnimationJSONFiles()
        SetOptionFlags(option, OPTION_FLAG_NONE)
        UD_Native.SyncAnimationSetting(UDAM.UD_AnimationJSON_Off)
    Elseif option == UD_AlternateAnimation_T
        UDAM.UD_AlternateAnimation = !UDAM.UD_AlternateAnimation
        SetToggleOptionValue(UD_AlternateAnimation_T, UDAM.UD_AlternateAnimation)
        If UDAM.UD_AlternateAnimation
            SetOptionFlags(UD_AlternateAnimationPeriod_S, OPTION_FLAG_NONE)
        Else
            SetOptionFlags(UD_AlternateAnimationPeriod_S, OPTION_FLAG_DISABLED)
        EndIf
    ElseIf option == UD_UseSingleStruggleKeyword_T
        UDAM.UD_UseSingleStruggleKeyword = !UDAM.UD_UseSingleStruggleKeyword
        SetToggleOptionValue(UD_UseSingleStruggleKeyword_T, UDAM.UD_UseSingleStruggleKeyword)
    EndIf
EndFunction

Function OptionSelectAnimationsPlayground(int option)
    If option == UDAM_TestQuery_Request_T
        SetOptionFlags(option, OPTION_FLAG_DISABLED)
        Float start_time = Utility.GetCurrentRealTime()
        String[] kwds = new String[1]
        kwds[0] = UDAM_TestQuery_Keyword_List[UDAM_TestQuery_Keyword_Index]
        String anim_type = UDAM_TestQuery_Type_List[UDAM_TestQuery_Type_Index]
        If UDAM_TestQuery_Type_Index == 1                                       ; .paired
            Int[] constr = new Int[2]
            constr[0] = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int) + 2048 * (UDAM_TestQuery_PlayerGag as Int)
            constr[1] = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_HelperArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_HelperLegs_Index] + 256 * (UDAM_TestQuery_HelperMittens as Int) + 2048 * (UDAM_TestQuery_HelperGag as Int)
            UDAM_TestQuery_Results_AnimEvent = UDAM.GetAnimationsFromDB(anim_type, kwds, ".A1.anim", constr)
            UDAM_TestQuery_Results_JsonPath = UDAM.GetAnimationsFromDB(anim_type, kwds, "", constr)
        Else                                                                    ; .solo
            Int[] constr = new Int[1]
            constr[0] = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int) + 2048 * (UDAM_TestQuery_PlayerGag as Int)
            UDAM_TestQuery_Results_AnimEvent = UDAM.GetAnimationsFromDB(anim_type, kwds, ".A1.anim", constr)
            UDAM_TestQuery_Results_JsonPath = UDAM.GetAnimationsFromDB(anim_type, kwds, "", constr)
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
    ElseIf (option >= UDAM_TestQuery_Results_AnimEvent_First_T) && (option <= (UDAM_TestQuery_Results_AnimEvent_First_T + (UDAM_TestQuery_Results_JsonPath.Length - 1) * 2)) && (((option - UDAM_TestQuery_Results_AnimEvent_First_T) % 2) == 0)
        Int index = (option - UDAM_TestQuery_Results_AnimEvent_First_T) / 2
        String val = UDAM_TestQuery_Results_JsonPath[index]
        If UDAM_TestQuery_Type_Index == 1 && !LastHelper
            ShowMessage("$First you need to choose a helper. Hover your crosshair over an NPC in the game and make sure its name appears in the 'Helper' option above")
        Else
            If ShowMessage("$FOR DEBUG ONLY! To stop animation use command 'Stop animation' in this menu. Animation will start if you press ACCEPT and close menu.", True)
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
    ElseIf (option >= UDAM_TestQuery_Results_JsonPath_First_T) && (option <= (UDAM_TestQuery_Results_JsonPath_First_T + (UDAM_TestQuery_Results_JsonPath.Length - 1) * 2)) && (((option - UDAM_TestQuery_Results_JsonPath_First_T) % 2) == 0)
;        Int index = (option - UDAM_TestQuery_Results_JsonPath_First_T) / 2
;        String val = UDAM_TestQuery_Results_JsonPath[index]
    ElseIf option == UDAM_TestQuery_StopAnimation_T
        ShowMessage("$Lets try to stop animation", False)
        UDAM.StopAnimation(Game.GetPlayer(), LastHelper)
        closeMCM()
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
        debug.notification("$[UD] Scanning!")
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
        ShowMessage("$Configuration saved!",false,"OK")
        ;forcePageReset()
    elseif UD_Import_T == option
        LoadFromJSON(File)
        ShowMessage("$Saved configuration loaded!",false,"OK")
    elseif option == UD_Default_T
        if ShowMessage("$Do you really want to discard all changes and load default values?")
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
EndFunction

Function OnOptionInputOpenGeneral(int option)
    if option == UD_RandomFilter_T
        SetInputDialogStartText(Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0xFFFFFFFF))
    endif
EndFunction

Function OnOptionInputAccept(int option, string value)
    OnOptionInputAcceptGeneral(option, value)
EndFunction

Function OnOptionInputAcceptGeneral(int option, string value)
    if(option == UD_RandomFilter_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(value as Int,0xFFFFFFFF)
        SetInputOptionValue(UD_RandomFilter_T, Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0xFFFFFFFF))
    endif
EndFunction

event OnOptionSliderOpen(int option)
    OnOptionSliderOpenGeneral(option)
    OnOptionSliderOpenCustomBondage(option)
    OnOptionSliderOpenCustomOrgasm(option)
    OnOptionSliderOpenOutfit(option)
    OnOptionSliderOpenNPCs(option)
    OnOptionSliderOpenPatcher(option)
    OnOptionSliderOpenAbadon(option)
    OnOptionSliderOpenDebug(option)
    OnOptionSliderOpenUIWidget(option)
    OnOptionSliderOpenAnimations(option)
    OnOptionSliderOpenModifiers(option)
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
    ElseIf option == UD_MinigameDrainMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UD_MinigameDrainMult * 100))
        SetSliderDialogDefaultValue(100)
        SetSliderDialogRange(10, 500)
        SetSliderDialogInterval(5)
    ElseIf option == UD_InitialDrainDelay_S
        SetSliderDialogStartValue(UDCDmain.UD_InitialDrainDelay)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogRange(0, 10.0)
        SetSliderDialogInterval(1)
    ElseIf option == UD_MinigameExhDurationMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UD_MinigameExhDurationMult * 100))
        SetSliderDialogDefaultValue(100)
        SetSliderDialogRange(100, 5000)
        SetSliderDialogInterval(100)
    ElseIf option == UD_MinigameExhMagnitudeMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UD_MinigameExhMagnitudeMult * 100))
        SetSliderDialogDefaultValue(100)
        SetSliderDialogRange(25, 200)
        SetSliderDialogInterval(5)
    elseif option == UD_LockpickMinigameDuration_S
        SetSliderDialogStartValue(UDCDmain.UD_LockpickMinigameDuration)
        SetSliderDialogDefaultValue(20)
        SetSliderDialogRange(0, 120)
        SetSliderDialogInterval(5)
    elseif option == UD_MinigameExhNoStruggleMax_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameExhNoStruggleMax)
        SetSliderDialogDefaultValue(2)
        SetSliderDialogRange(0, 10)
        SetSliderDialogInterval(1)
    elseif option == UD_MinigameExhExponential_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameExhExponential)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.1, 10)
        SetSliderDialogInterval(0.1)
    endif
EndFunction

Function OnOptionSliderOpenCustomOrgasm(int option)
    if (option == UD_OrgasmUpdateTime_S)
        SetSliderDialogStartValue(UDCONF.UD_OrgasmUpdateTime)
        SetSliderDialogDefaultValue(0.5)
        SetSliderDialogRange(0.1, 2.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_HornyAnimationDuration_S)
        SetSliderDialogStartValue(Round(UDCONF.UD_HornyAnimationDuration))
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(2.0,20.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_OrgasmResistence_S
        SetSliderDialogStartValue(UDCONF.UD_OrgasmResistence)
        SetSliderDialogDefaultValue(0.5)
        SetSliderDialogRange(0.1,10.0)
        SetSliderDialogInterval(0.1)
    elseif option == UD_OrgasmExhaustionStruggleMax_S
        SetSliderDialogStartValue(UDCONF.UD_OrgasmExhaustionStruggleMax)
        SetSliderDialogDefaultValue(6)
        SetSliderDialogRange(0,10)
        SetSliderDialogInterval(1)
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
        SetSliderDialogStartValue(UDCONF.UD_OrgasmArousalReduce)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(1.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif option == UD_OrgasmArousalReduceDuration_S
        SetSliderDialogStartValue(UDCONF.UD_OrgasmArousalReduceDuration)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(1.0, 30.0)
        SetSliderDialogInterval(1.0)
    endIf
EndFunction

Function OnOptionSliderOpenOutfit(int option)
    if UD_OutfitDeviceSelected_S
        int loc_i = UD_OutfitDeviceSelected_S.find(option)
        if loc_i >= 0
            UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
            SetSliderDialogStartValue(loc_outfit.GetRnd(UD_OutfitDeviceSelectedType[loc_i],UD_OutfitDeviceSelectedIndex[loc_i]))
            SetSliderDialogDefaultValue(50.0)
            SetSliderDialogRange(0.0, 100.0)
            SetSliderDialogInterval(1.0)
        endif
    endif
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
    if (option == UD_PatchMult_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
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
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_PatchMult_Blindfold_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Blindfold)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_PatchMult_Gag_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Gag)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_PatchMult_Hood_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Hood)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_PatchMult_ChastityBelt_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_PatchMult_ChastityBra_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_ChastityBra)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_PatchMult_Plug_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Plug)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_PatchMult_Piercing_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Piercing)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (option == UD_PatchMult_Generic_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Generic)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
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
    
Function OnOptionSliderOpenModifiers(int option)
    if (option == UD_ModifierMultiplier_S)
        UD_Modifier loc_mod = (UDmain.UDMOM.UD_ModifierListRef[UD_ModifierSelected] as UD_Modifier)
        SetSliderDialogStartValue(loc_mod.Multiplier)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(0.1)
;    elseif (option == UD_ModifierPatchPowerMultiplier_S)
;        UD_Modifier loc_mod = (UDmain.UDMOM.UD_ModifierListRef[UD_ModifierSelected] as UD_Modifier)
;        SetSliderDialogStartValue(loc_mod.PatchPowerMultiplier)
;        SetSliderDialogDefaultValue(1.0)
;        SetSliderDialogRange(0.0, 100.0)
;        SetSliderDialogInterval(0.1)
;    elseif (option == UD_ModifierPatchChanceMultiplier_S)
;        UD_Modifier loc_mod = (UDmain.UDMOM.UD_ModifierListRef[UD_ModifierSelected] as UD_Modifier)
;        SetSliderDialogStartValue(loc_mod.PatchCHanceMultiplier)
;        SetSliderDialogDefaultValue(1.0)
;        SetSliderDialogRange(0.0, 100.0)
;        SetSliderDialogInterval(0.1)
    endIf
EndFunction

event OnOptionSliderAccept(int option, float value)
    OnOptionSliderAcceptGeneral(option,value)
    OnOptionSliderAcceptCustomBondage(option, value)
    OnOptionSliderAcceptCustomOrgasm(option, value)
    OnOptionSliderAcceptOutfit(option, value)
    OnOptionSliderAcceptNPCs(option, value)
    OnOptionSliderAcceptPatcher(option, value)
    OnOptionSliderAcceptAbadon(option, value)
    OnOptionSliderAcceptDebug(option,value)
    OnOptionSliderAcceptUIWidget(option,value)
    OnOptionSliderAcceptAnimations(option, value)
    OnOptionSliderAcceptModifiers(option, value)
endEvent

Function OnOptionSliderAcceptGeneral(int option, float value)
    if (option == UD_LoggingLevel_S)
        UDmain.LogLevel = Round(value)
        SetSliderOptionValue(UD_LoggingLevel_S, UDmain.LogLevel, "{0}")
    elseif option == UD_PrintLevel_S
        UDmain.UD_PrintLevel = Round(value)
        SetSliderOptionValue(UD_PrintLevel_S, UDmain.UD_PrintLevel, "{0}")
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
        UDCDmain.UD_LockpicksPerMinigame = Round(value)
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
    ElseIf option == UD_MinigameDrainMult_S
        UDCDmain.UD_MinigameDrainMult = value / 100
        SetSliderOptionValue(UD_MinigameDrainMult_S, UDCDmain.UD_MinigameDrainMult * 100, "{1} %")
    ElseIf option == UD_InitialDrainDelay_S
        UDCDmain.UD_InitialDrainDelay = Round(value)
        SetSliderOptionValue(UD_InitialDrainDelay_S, UDCDmain.UD_InitialDrainDelay, "{0} s")
    ElseIf option == UD_MinigameExhDurationMult_S
        UDCDmain.UD_MinigameExhDurationMult = value / 100.0
        SetSliderOptionValue(UD_MinigameExhDurationMult_S, UDCDmain.UD_MinigameExhDurationMult * 100.0, "{0} %")
    ElseIf option == UD_MinigameExhMagnitudeMult_S
        UDCDmain.UD_MinigameExhMagnitudeMult = value / 100.0
        SetSliderOptionValue(UD_MinigameExhMagnitudeMult_S, UDCDmain.UD_MinigameExhMagnitudeMult * 100.0, "{0} %")
    elseif option == UD_LockpickMinigameDuration_S
        UDCDmain.UD_LockpickMinigameDuration = Round(value)
        SetSliderOptionValue(UD_LockpickMinigameDuration_S, UDCDmain.UD_LockpickMinigameDuration, "{0} s")
    elseif option == UD_MinigameExhNoStruggleMax_S
        UDCDMain.UD_MinigameExhNoStruggleMax = Round(value)
        SetSliderOptionValue(UD_MinigameExhNoStruggleMax_S, UDCDMain.UD_MinigameExhNoStruggleMax, "{0}")
    elseif option == UD_MinigameExhExponential_S
        UDCDMain.UD_MinigameExhExponential = value
        SetSliderOptionValue(UD_MinigameExhExponential_S, UDCDMain.UD_MinigameExhExponential, "{1}")
    endif
EndFunction

Function OnOptionSliderAcceptCustomOrgasm(int option, float value)
    if (option == UD_OrgasmUpdateTime_S)
        UDCONF.UD_OrgasmUpdateTime = value
        SetSliderOptionValue(UD_OrgasmUpdateTime_S, UDCONF.UD_OrgasmUpdateTime, "{1} s")
    elseif (option == UD_HornyAnimationDuration_S)
        UDCONF.UD_HornyAnimationDuration = Round(value)
        SetSliderOptionValue(UD_HornyAnimationDuration_S, UDCONF.UD_HornyAnimationDuration, "{0} s")
    elseif option == UD_OrgasmResistence_S
        UDCONF.UD_OrgasmResistence = value
        SetSliderOptionValue(UD_OrgasmResistence_S, UDCONF.UD_OrgasmResistence, "{1} Op/s")
    elseif option == UD_OrgasmExhaustionStruggleMax_S
        UDCONF.UD_OrgasmExhaustionStruggleMax = Round(value)
        SetSliderOptionValue(UD_OrgasmExhaustionStruggleMax_S, UDCONF.UD_OrgasmExhaustionStruggleMax, "{0} orgasms")
    elseif option == UD_VibrationMultiplier_S
        UDCDmain.UD_VibrationMultiplier = value
        SetSliderOptionValue(UD_VibrationMultiplier_S, UDCDmain.UD_VibrationMultiplier, "{3}")
    elseif option == UD_ArousalMultiplier_S
        UDCDmain.UD_ArousalMultiplier = value
        SetSliderOptionValue(UD_ArousalMultiplier_S, UDCDmain.UD_ArousalMultiplier, "{3}")
    elseif option == UD_OrgasmArousalReduce_S
        UDCONF.UD_OrgasmArousalReduce = Round(value)
        SetSliderOptionValue(UD_OrgasmArousalReduce_S, UDCONF.UD_OrgasmArousalReduce, "{0} /s")
    elseif option == UD_OrgasmArousalReduceDuration_S
        UDCONF.UD_OrgasmArousalReduceDuration = Round(value)
        SetSliderOptionValue(UD_OrgasmArousalReduceDuration_S, UDCONF.UD_OrgasmArousalReduceDuration, "{0} s")
    endIf
EndFunction

Function OnOptionSliderAcceptOutfit(int option, float value)
    if UD_OutfitDeviceSelected_S
        int loc_i = UD_OutfitDeviceSelected_S.find(option)
        if loc_i >= 0
            UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
            loc_outfit.UpdateRnd(UD_OutfitDeviceSelectedType[loc_i],UD_OutfitDeviceSelectedIndex[loc_i],Round(value))
            SetSliderOptionValue(option, loc_outfit.GetRnd(UD_OutfitDeviceSelectedType[loc_i],UD_OutfitDeviceSelectedIndex[loc_i]), "{0}")
        endif
    endif
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
    if (option == UD_PatchMult_S)
        UDCDmain.UDPatcher.UD_PatchMult = value
        SetSliderOptionValue(UD_PatchMult_S, UDCDmain.UDPatcher.UD_PatchMult, "{1} x")
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
        UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage = value
        SetSliderOptionValue(UD_PatchMult_HeavyBondage_S, UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage, "{1} x")
    elseif (option == UD_PatchMult_Blindfold_S)
        UDCDmain.UDPatcher.UD_PatchMult_Blindfold = value
        SetSliderOptionValue(UD_PatchMult_Blindfold_S, UDCDmain.UDPatcher.UD_PatchMult_Blindfold, "{1} x")
    elseif (option == UD_PatchMult_Gag_S)
        UDCDmain.UDPatcher.UD_PatchMult_Gag = value
        SetSliderOptionValue(UD_PatchMult_Gag_S, UDCDmain.UDPatcher.UD_PatchMult_Gag, "{1} x")
    elseif (option == UD_PatchMult_Hood_S)
        UDCDmain.UDPatcher.UD_PatchMult_Hood = value
        SetSliderOptionValue(UD_PatchMult_Hood_S, UDCDmain.UDPatcher.UD_PatchMult_Hood, "{1} x")
    elseif (option == UD_PatchMult_ChastityBelt_S)
        UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt = value
        SetSliderOptionValue(UD_PatchMult_ChastityBelt_S, UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt, "{1} x")
    elseif (option == UD_PatchMult_ChastityBra_S)
        UDCDmain.UDPatcher.UD_PatchMult_ChastityBra = value
        SetSliderOptionValue(UD_PatchMult_ChastityBra_S, UDCDmain.UDPatcher.UD_PatchMult_ChastityBra, "{1} x")
    elseif (option == UD_PatchMult_Plug_S)
        UDCDmain.UDPatcher.UD_PatchMult_Plug = value
        SetSliderOptionValue(UD_PatchMult_Plug_S, UDCDmain.UDPatcher.UD_PatchMult_Plug, "{1} x")
    elseif (option == UD_PatchMult_Piercing_S)
        UDCDmain.UDPatcher.UD_PatchMult_Piercing = value
        SetSliderOptionValue(UD_PatchMult_Piercing_S, UDCDmain.UDPatcher.UD_PatchMult_Piercing, "{1} x")
    elseif (option == UD_PatchMult_Generic_S)
        UDCDmain.UDPatcher.UD_PatchMult_Generic = value
        SetSliderOptionValue(UD_PatchMult_Generic_S, UDCDmain.UDPatcher.UD_PatchMult_Generic, "{1} x")
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

Function OnOptionSliderAcceptModifiers(int option, float value)
    if (option == UD_ModifierMultiplier_S)
        UD_Modifier loc_mod = (UDmain.UDMOM.UD_ModifierListRef[UD_ModifierSelected] as UD_Modifier)
        loc_mod.Multiplier  = value
        SetSliderOptionValue(UD_ModifierMultiplier_S, value, "{1} x")
;    elseif (option == UD_ModifierPatchPowerMultiplier_S)
;        UD_Modifier loc_mod = (UDmain.UDMOM.UD_ModifierListRef[UD_ModifierSelected] as UD_Modifier)
;        loc_mod.PatchPowerMultiplier  = value
;        SetSliderOptionValue(UD_ModifierPatchPowerMultiplier_S, value, "{1} x")
;    elseif (option == UD_ModifierPatchChanceMultiplier_S)
;        UD_Modifier loc_mod = (UDmain.UDMOM.UD_ModifierListRef[UD_ModifierSelected] as UD_Modifier)
;        loc_mod.PatchChanceMultiplier  = value
;        SetSliderOptionValue(UD_ModifierPatchChanceMultiplier_S, value, "{1} x")
    endIf
EndFunction

event OnOptionMenuOpen(int option)
    OnOptionMenuOpenDefault(option)
    OnOptionMenuOpenCustomBondage(option)
    OnOptionMenuOpenCustomOrgasm(option)
    OnOptionMenuOpenAbadon(option)
    OnOptionMenuOpenUIWidget(option)
    OnOptionMenuOpenAnimationsPlayground(option)
    OnOptionMenuOpenModifiers(option)
    OnOptionMenuOpenOutfit(option)
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
    elseif (option == UD_MinigameLockpickSkillAdjust_M)
        SetMenuDialogOptions(UD_MinigameLockpickSkillAdjust_ML)
        SetMenuDialogStartIndex(UDCDmain.UD_MinigameLockpickSkillAdjust)
        SetMenuDialogDefaultIndex(2)
    endif
EndFunction

Function OnOptionMenuOpenCustomOrgasm(int option)
    if (option == UD_OrgasmAnimation_M)
        SetMenuDialogOptions(orgasmAnimation)
        SetMenuDialogStartIndex(UDCONF.UD_OrgasmAnimation)
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

Function OnOptionMenuOpenAnimationsPlayground(Int option)
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

Function OnOptionMenuOpenModifiers(Int option)
    If option == UD_ModifierList_M
        SetMenuDialogOptions(UDmain.UDMOM.UD_ModifierList)
        SetMenuDialogStartIndex(UD_ModifierSelected)
        SetMenuDialogDefaultIndex(0)
    EndIf
EndFunction

Function OnOptionMenuOpenOutfit(Int option)
    If option == UD_OutfitList_M
        SetMenuDialogOptions(UDOTM.UD_OutfitList)
        SetMenuDialogStartIndex(UD_OutfitSelected)
        SetMenuDialogDefaultIndex(UD_OutfitSelected)
    elseif option == UD_OutfitSections_M
        SetMenuDialogOptions(UD_OutfitSections_ML)
        SetMenuDialogStartIndex(UD_OutfitSectionSelected)
        SetMenuDialogDefaultIndex(UD_OutfitSectionSelected)
    EndIf
EndFunction

event OnOptionMenuAccept(int option, int index)
    OnOptionMenuAcceptDefault(option,index)
    OnOptionMenuAcceptCustomBondage(option,index)
    OnOptionMenuAcceptCustomOrgasm(option,index)
    OnOptionMenuAcceptAbadon(option, index)
    OnOptionMenuAcceptUIWidget(option, index)
    OnOptionMenuAcceptAnimationsPlayground(option, index)
    OnOptionMenuAcceptModifiers(option, index)
    OnOptionMenuAcceptOutfit(option, index)
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
    elseif (option == UD_MinigameLockpickSkillAdjust_M)
        UDCDmain.UD_MinigameLockpickSkillAdjust = index
        SetMenuOptionValue(UD_MinigameLockpickSkillAdjust_M, UD_MinigameLockpickSkillAdjust_ML[UDCDmain.UD_MinigameLockpickSkillAdjust])
        forcePageReset()
    endIf
EndFunction

Function OnOptionMenuAcceptCustomOrgasm(int option, int index)
    if (option == UD_OrgasmAnimation_M)
        UDCONF.UD_OrgasmAnimation = index
        SetMenuOptionValue(UD_OrgasmAnimation_M, orgasmAnimation[UDCONF.UD_OrgasmAnimation])
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

Function OnOptionMenuAcceptAnimationsPlayground(Int option, Int index)
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

Function OnOptionMenuAcceptModifiers(Int option, Int index)
    If option == UD_ModifierList_M
        UD_ModifierSelected = index
        SetMenuOptionValue(option, UDmain.UDMOM.UD_ModifierList[index])
        forcePageReset()
    EndIf
EndFunction

Function OnOptionMenuAcceptOutfit(Int option, Int index)
    If option == UD_OutfitList_M
        UD_OutfitSelected = index
        SetMenuOptionValue(option, UDOTM.UD_OutfitList[index])
        forcePageReset()
    elseif option == UD_OutfitSections_M
        UD_OutfitSectionSelected = index
        SetMenuOptionValue(option, UD_OutfitSections_ML[index])
        forcePageReset()
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
    if (_lastPage == "$UD_GENERAL")
        GeneralPageDefault(option)
    elseif (_lastPage == "$UD_DEVICEFILTER")
        ;FilterPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "$UD_ABADONPLUG")
        ;AbadanPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "$UD_CUSTOMDEVICES")
        ;CustomBondagePageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "$UD_CUSTOMORGASM")
        ;CustomOrgasmPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == UD_NPCsPageName)
        NPCsPageDefault(option)
    elseif (_lastPage == "$UD_PATCHER")
        PatcherPageDefault(option)
    elseif (_lastPage == "$UD_DDPATCH")
        ;DDPatchPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "$UD_DEBUGPANEL")
        ;DebugPageDefault(option) ;TODO. Will winish later, as doing this is pain in the ass
    elseif (_lastPage == "$UD_OTHER")
    elseif (_lastPage == "$UD_ANIMATIONS")
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
        SetInfoText("$UD_USEARMCUFFS_INFO")
    elseif(option == UD_UseBelts_T)
        SetInfoText("$UD_USECHASTITYBELTS_INFO")
    elseif(option == UD_UseBlindfolds_T)
        SetInfoText("$UD_USEBLINDFOLDS_INFO")
    elseif(option == UD_UseBoots_T)
        SetInfoText("$UD_USEBOOTS_INFO")
    elseif(option == UD_UseBras_T)
        SetInfoText("$UD_USECHASTITYBRAS_INFO")
    elseif(option == UD_UseCollars_T)
        SetInfoText("$UD_USECOLLARS_INFO")
    elseif(option == UD_UseCorsets_T)
        SetInfoText("$UD_USECORSETS_INFO")
    elseif(option == UD_UseGags_T)
        SetInfoText("$UD_USEGAGS_INFO")
    elseif(option == UD_UseGloves_T)
        SetInfoText("$UD_USEGLOVES_INFO")
    elseif(option == UD_UseHarnesses_T)
        SetInfoText("$UD_USEHARNESSES_INFO")
    elseif(option == UD_UseHeavyBondage_T)
        SetInfoText("$UD_USEHEAVYBONDAGE_INFO")
    elseif(option == UD_UseHoods_T)
        SetInfoText("$UD_USEHOODS_INFO")
    elseif(option == UD_UseLegCuffs_T)
        SetInfoText("$UD_USELEGCUFFS_INFO")
    elseif(option == UD_UsePiercingsNipple_T)
        SetInfoText("$UD_USEPIERCINGSNIPPLE_INFO")
    elseif(option == UD_UsePiercingsVaginal_T)
        SetInfoText("$UD_USEPIERCINGSVAGINAL_INFO")
    elseif(option == UD_UsePlugsAnal_T)
        SetInfoText("$UD_USEPLUGSANAL_INFO")
    elseif(option == UD_UsePlugsVaginal_T)
        SetInfoText("$UD_USEPLUGSVAGINAL_INFO")
    elseif(option == UD_UseSuits_T)
        SetInfoText("$UD_USESUITS_INFO")
    elseif option == UD_RandomFilter_T ;this option will be deleted
        SetInfoText("$UD_RANDOMFILTER_INFO")
    endif
EndFunction

Function CustomBondagePageDefault(int option)
    if(option == UD_CHB_Stamina_meter_Keycode_K)
        SetInfoText("$UD_STAMINAMETER_INFO")
    elseif option == UD_UseWidget_T
        SetInfoText("$UD_USEWIDGET_INFO")
    elseif(option == UD_CHB_Magicka_meter_Keycode_K)
        SetInfoText("$UD_MAGICKAMETER_INFO")
    elseif(option == UD_StruggleDifficulty_M)
        SetInfoText("$UD_ESCAPEDIFFICULTY_INFO")
    elseif(option == UD_UpdateTime_S)
        SetInfoText("$UD_UPDATETIME_INFO")
    elseif(option == UD_UseDDdifficulty_T)
        SetInfoText("$UD_USEDDDIFFICULTY_INFO")
    elseif(option == UD_hardcore_swimming_T)
        SetInfoText("$UD_HARDCORE_SWIMMING_INFO")
    elseif(option == UD_hardcore_swimming_difficulty_M)
        SetInfoText("$UD_HARDCORESWIMMINGDIFFICULTY_INFO")
    elseif option == UD_WidgetPosX_M
        SetInfoText("$UD_CWIDGETPOSX_INFO")
    elseif option == UD_WidgetPosY_M
        SetInfoText("$UD_WIDGETPOSY_INFO")
    elseif option == UD_LockpickMinigameNum_S
        SetInfoText("$UD_PREVENTMASTERLOCK_INFO")
    elseif option == UD_BaseDeviceSkillIncrease_S
        SetInfoText("$UD_BASEDEVICESKILLINCREASE_INFO")
    elseif option == UD_SkillEfficiency_S
        SetInfoText("$UD_SKILLEFFICIENCY_INFO")
    elseif option == UD_AutoCrit_T
        SetInfoText("$UD_AUTOCRIT_INFO")
    elseif option == UD_AutoCritChance_S
        SetInfoText("$UD_AUTOCRITCHANCE_INFO")
    elseif option == UD_CritEffect_M
        SetInfoText("$UD_CRITEFFECT_INFO")
    elseif option == UD_CooldownMultiplier_S
        SetInfoText("$UD_COOLDOWNMULTIPLIER_INFO")
    elseif option == UD_HardcoreMode_T
        SetInfoText("$UD_HARDCOREMODE_INFO")
    elseif option == UD_AllowArmTie_T
        SetInfoText("$UD_ALLOWARMTIE_INFO")
    elseif option == UD_AllowLegTie_T
        SetInfoText("$UD_ALLOWLEGTIE_INFO")
    elseif option == UD_MinigameHelpCd_S
        SetInfoText("$UD_MINIGAMEHELPCD_INFO")
    elseif option == UD_MinigameHelpCD_PerLVL_S
        SetInfoText("$UD_MINIGAMEHELPCD_INFO")
    elseif option == UD_MinigameHelpXPBase_S
        SetInfoText("$UD_MINIGAMEHELPXPBASE_INFO")
    elseif option == UDCD_SpecialKey_Keycode_K
        SetInfoText("$UD_SPECIALKEYKEY_INFO")
    elseif option == UD_DeviceLvlHealth_S
        SetInfoText("$UD_DEVICELVLHEALTH_INFO")
    elseif option == UD_DeviceLvlLockpick_S
        SetInfoText("$UD_DEVICELVLLOCKPICK_INFO")
    elseif option == UD_PreventMasterLock_T
        SetInfoText("$UD_PREVENTMASTERLOCK_INFO")
    elseif option == UD_DeviceLvlLocks_S
        SetInfoText("$UD_DEVICELVLLOCKS_INFO")
    elseif option == UD_MandatoryCrit_T
        SetInfoText("$UD_WMANDATORYCRIT_INFO")
    elseif option == UD_CritDurationAdjust_S
        SetInfoText("$UD_CRITDURATIONADJUST_INFO")
    elseif option == UD_KeyDurability_S
        UDCDmain.UD_KeyDurability = 5
        SetSliderOptionValue(UD_KeyDurability_S, UDCDmain.UD_KeyDurability, "{0}")
    elseif option == UD_HardcoreAccess_T
        UDCDmain.UD_HardcoreAccess = False
        SetToggleOptionValue(UD_HardcoreAccess_T, UDCDmain.UD_HardcoreAccess)
    ElseIf option == UD_MinigameDrainMult_S
        UDCDmain.UD_MinigameDrainMult = 1
        SetSliderOptionValue(UD_MinigameDrainMult_S, UDCDmain.UD_MinigameDrainMult * 100, "{1} %")
    ElseIf option == UD_InitialDrainDelay_S
        UDCDmain.UD_InitialDrainDelay = 0
        SetSliderOptionValue(UD_InitialDrainDelay_S, UDCDmain.UD_InitialDrainDelay, "{0} s")
    ElseIf option == UD_MinigameExhDurationMult_S
        UDCDmain.UD_MinigameExhDurationMult = 1.0
        SetSliderOptionValue(UD_MinigameExhDurationMult_S, UDCDmain.UD_MinigameExhDurationMult * 100, "{0} %")
    ElseIf option == UD_MinigameExhMagnitudeMult_S
        UDCDmain.UD_MinigameExhMagnitudeMult = 1.0
        SetSliderOptionValue(UD_MinigameExhMagnitudeMult_S, UDCDmain.UD_MinigameExhMagnitudeMult * 100, "{0} %")
    elseif (option == UD_MinigameLockpickSkillAdjust_M)
        UDCDmain.UD_MinigameLockpickSkillAdjust = 2
        SetMenuOptionValue(UD_MinigameLockpickSkillAdjust_M, UD_MinigameLockpickSkillAdjust_ML[UDCDmain.UD_MinigameLockpickSkillAdjust])
        forcePageReset()
    elseif option == UD_LockpickMinigameDuration_S
        UDCDmain.UD_LockpickMinigameDuration = 20
        SetSliderOptionValue(UD_LockpickMinigameDuration_S, UDCDmain.UD_LockpickMinigameDuration, "{0} s")
    endif
EndFunction

Function CustomOrgasmPageDefault(int option)
    if     option == UD_OrgasmUpdateTime_S
        SetInfoText("$UD_ORGASMUPDATETIME_INFO")
    elseif option == UD_UseOrgasmWidget_T
        SetInfoText("$UD_USEORGASMWIDGET_INFO")
    elseif option == UD_OrgasmResistence_S
        SetInfoText("$UD_ORGASMRESISTENCE_INFO")
    elseif option == UD_OrgasmExhaustionStruggleMax_S
        SetInfoText("$UD_ORGASMEXHAUSTIONSTRUGGLEMAX_INFO")
    elseif option == UD_HornyAnimation_T
        SetInfoText("$UD_HORNYANIMATION_INFO")
    elseif option == UD_HornyAnimationDuration_S
        SetInfoText("$UD_HORNYANIMATIONDURATION_INFO")
    elseif option == UD_VibrationMultiplier_S
        SetInfoText("$UD_VIBRATIONMULTIPLIER_INFO")
    elseif option == UD_ArousalMultiplier_S
        SetInfoText("$UD_AROUSALMULTIPLIER_INFO")
    elseif option == UD_OrgasmArousalReduce_S
        SetInfoText("$UD_ORGASMAROUSALREDUCE_INFO")
    elseif option == UD_OrgasmArousalReduceDuration_S
        SetInfoText("$UD_ORGASMAROUSALREDUCEDURATION_INFO")
    elseif(option == UD_OrgasmExhaustion_T)
        SetInfoText("$UD_ORGASMEXHAUSTION_INFO")
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
        ;SetInfoText("$UD_PATCHMULT_INFO")
    elseif option == UD_EscapeModifier_S
        ;SetInfoText("$UD_ESCAPEMODIFIER_INFO")
    elseif option == UD_MinLocks_S
        ;SetInfoText("$UD_MINLOCKS_INFO")
    elseif option == UD_MaxLocks_S
        ;SetInfoText("$UD_MAXLOCKS_INFO")
    elseif option == UD_MinResistMult_S
        ;SetInfoText("$UD_MINRESISTMULT_INFO")
    elseif option == UD_MaxResistMult_S
        ;SetInfoText("$UD_MAXRESISTMULT_INFO")
    elseif option == UD_TimedLocks_T
        UDCDmain.UDPatcher.UD_TimedLocks = false
        SetToggleOptionValue(UD_TimedLocks_T, UDCDmain.UDPatcher.UD_TimedLocks)
    endif
EndFunction

Function AbadanPageDefault(int option)
    ;dear mother of god
    if (option == dmg_heal_T)
        SetInfoText("$UD_DMGHEAL_INFO")
    elseif (option == UseAnalVariant_T)
        SetInfoText("$UD_ANALVARIANT_INFO")
    elseif(option == dmg_stamina_T)
        SetInfoText("$UD_DMGSTAMINA_INFO")
    elseif(option == dmg_magica_T)
        SetInfoText("$UD_DAMAGEMAGICA_INFO")
    elseif(option == hardcore_T)
        SetInfoText("$UD_HARDCORE_INFO")
    elseif (option == difficulty_M)
        SetInfoText("$UD_DIFFICULTY_INFO")
    elseif (option == preset_M)
        SetInfoText("$UD_PRESET_INFO")
    elseif (option == max_difficulty_S)
        SetInfoText("$UD_MAXDIFFICULTY_INFO")
    elseIf (option == eventchancemod_S)
        SetInfoText("$UD_EVENTCHANCEMOD_INFO")
    elseIf (option == little_finisher_chance_S)
        SetInfoText("$UD_LITTLEFINISHERCHANCE_INFO")
    elseIf (option == min_orgasm_little_finisher_S)
        SetInfoText("$UD_MINORGASMLITTLEFINISHER_INFO")
    elseIf (option == max_orgasm_little_finisher_S)
        SetInfoText("$UD_MAX_ORGASM_LITTLE_FINISHER_INFO")
    elseIf (option == little_finisher_cooldown_S)
        SetInfoText("$UD_LITTLEFINISHERCOOLDOWN_INFO")
    elseIf (option == final_finisher_pref_M)
        SetInfoText("$UD_FINALFINISHERPREF_INFO")
    endIf
EndFunction

Function DDPatchPageDefault(int option)
    if option == UD_GagPhonemModifier_S
        SetInfoText("$UD_GAGPHONEMMODIFIER_INFO")
    elseif option == UD_OutfitRemove_T
        SetInfoText("$UD_OUTFITREMOVE_INFO")
    elseif option == UD_OrgasmAnimation_M
        SetInfoText("$UD_ORGASMANIMATION_INFO")
    elseif option == UD_AllowMenBondage_T
        SetInfoText("$UD_ALLOWMENBONDAGE")
    elseif option == UD_CheckAllKw_T
        SetInfoText("$UD_CHECKALLKW_INFO")
    endif
EndFunction

Function DebugPageDefault(int option)
    ;dear mother of god
    if (option == rescanSlots_T)
        SetInfoText("$UD_RESCANSLOTS_INFO")
    elseif option == fixBugs_T
        SetInfoText("$UD_FIXBUGS_INFO")
    elseif option == unlockAll_T
        SetInfoText("$UD_UNLOCK_ALL_INFO")
    elseif option == endAnimation_T
        SetInfoText("$UD_ENDANIMATION_INFO")
    elseif option == unregisterNPC_T
        SetInfoText("$UD_UNREGISTER_NPC_INFO")
    elseif option == OrgasmCapacity_S
        SetInfoText("$UD_ORGASMCAPACITY_INFO")
    elseif option == OrgasmResist_S
        SetInfoText("$UD_ORGASMRESIST_INFO")
    endIf
EndFunction

Function AnimationPageDefault(Int option)
    If option == UD_AlternateAnimation_T
        SetInfoText("$UD_ALTERNATEANIMATION_INFO")
    EndIf
EndFunction
;=========================================
;                 INFO.      .............
;=========================================
Event OnOptionHighlight(int option)
    if (_lastPage == "$UD_GENERAL")
        GeneralPageInfo(option)
    elseif (_lastPage == "$UD_DEVICEFILTER")
        FilterPageInfo(option)
    elseif (_lastPage == "Custom Modifiers")
        ModifierPageInfo(option)
    elseif (_lastPage == "$UD_ABADONPLUG")
        AbadanPageInfo(option)
    elseif (_lastPage == "$UD_CUSTOMDEVICES")
         CustomBondagePageInfo(option)
    elseif (_lastPage == "$UD_CUSTOMORGASM")
        CustomOrgasmPageInfo(option)
    elseif (_lastPage == UD_NPCsPageName)
        NPCsPageInfo(option)
    elseif (_lastPage == "$UD_PATCHER")
        PatcherPageInfo(option)
    elseif (_lastPage == "$UD_DDPATCH")
        DDPatchPageInfo(option)
    elseif (_lastPage == "$UD_UIWIDGETS")
        UiWidgetPageInfo(option)
    elseif (_lastPage == "$UD_DEBUGPANEL")
        DebugPageInfo(option)
    elseif (_lastPage == "$UD_OTHER")
    
    elseif (_lastPage == "$UD_ANIMATIONS")
        AnimationPageInfo(option)  
    elseif (_lastPage == "$UD_ANIMATIONS_PLAYGROUND")
        AnimationPlaygroundPageInfo(option)
    endif
EndEvent

Function GeneralPageInfo(int option)
    if(option == lockmenu_T)
        SetInfoText("$UD_LOCKMENU_INFO")
    elseif(option == UD_ActionKey_K)
        SetInfoText("$UD_ACTIONKEY_INFO")
    elseif(option == UD_StruggleKey_K)
        SetInfoText("$UD_STRUGGLEKEY_INFO")
    elseif(option == UD_hightPerformance_T)
        SetInfoText("$UD_HIGHPERFORMANCE_INFO")
    elseif(option == UD_debugmod_T)
        SetInfoText("$UD_DEBUGMOD_INFO")
    elseif option == UD_HearingRange_S
        SetInfoText("$UD_HEARINGRANGE_INFO")
    elseif option == UD_WarningAllowed_T
        SetInfoText("$UD_WARNINGALLOWED_INFO")
    elseif option == UD_PrintLevel_S
        SetInfoText("$UD_PRINTLEVEL_INFO")
    elseif(option == UD_PlayerMenu_K)
        SetInfoText("$UD_PLAYERMENU_INFO")
    elseif(option == UD_NPCMenu_K)
        SetInfoText("$UD_NPCMENU_INFO")
    elseif(option == UD_LoggingLevel_S)
        SetInfoText("$UD_LOGGINGLEVEL_INFO")
    elseif option == UD_LockDebugMCM_T
        SetInfoText("$UD_LOCKDEBUGMCM_INFO")
    elseif option == UD_EasyGamepadMode_T
        SetInfoText("$UD_EASYGAMEPADMODE_INFO")
    elseif option == UD_UseNativeFunctions_T
        SetInfoText("$UD_NATIVESWITCH_INFO")
    Endif
EndFunction

Function FilterPageInfo(int option)
    if(option == UD_UseArmCuffs_T)
        SetInfoText("$UD_USEARMCUFFS_INFO")
    elseif(option == UD_UseBelts_T)
        SetInfoText("$UD_USECHASTITYBELTS_INFO")
    elseif(option == UD_UseBlindfolds_T)
        SetInfoText("$UD_USEBLINDFOLDS_INFO")
    elseif(option == UD_UseBoots_T)
        SetInfoText("$UD_USEBOOTS_INFO")
    elseif(option == UD_UseBras_T)
        SetInfoText("$UD_USECHASTITYBRAS_INFO")
    elseif(option == UD_UseCollars_T)
        SetInfoText("$UD_USECOLLARS_INFO")
    elseif(option == UD_UseCorsets_T)
        SetInfoText("$UD_USECORSETS_INFO")
    elseif(option == UD_UseGags_T)
        SetInfoText("$UD_USEGAGS_INFO")
    elseif(option == UD_UseGloves_T)
        SetInfoText("$UD_USEGLOVES_INFO")
    elseif(option == UD_UseHarnesses_T)
        SetInfoText("$UD_USEHARNESSES_INFO")
    elseif(option == UD_UseHeavyBondage_T)
        SetInfoText("$UD_USEHEAVYBONDAGE_INFO")
    elseif(option == UD_UseHoods_T)
        SetInfoText("$UD_USEHOODS_INFO")
    elseif(option == UD_UseLegCuffs_T)
        SetInfoText("$UD_USELEGCUFFS_INFO")
    elseif(option == UD_UsePiercingsNipple_T)
        SetInfoText("$UD_USEPIERCINGSNIPPLE_INFO")
    elseif(option == UD_UsePiercingsVaginal_T)
        SetInfoText("$UD_USEPIERCINGSVAGINAL_INFO")
    elseif(option == UD_UsePlugsAnal_T)
        SetInfoText("$UD_USEPLUGSANAL_INFO")
    elseif(option == UD_UsePlugsVaginal_T)
        SetInfoText("$UD_USEPLUGSVAGINAL_INFO")
    elseif(option == UD_UseSuits_T)
        SetInfoText("$UD_USESUITS_INFO")
    elseif option == UD_RandomFilter_T ;this option will be deleted
        SetInfoText("$UD_RANDOMFILTER_INFO")
    endif
EndFunction

Function ModifierPageInfo(int option)
    if(option == UD_ModifierMultiplier_S)
        SetInfoText("Strength multiplier for specific modifier. Is applied to all modifiers of selected type")
;    elseif(option == UD_ModifierPatchChanceMultiplier_S)
;        SetInfoText("Multiplier for chance of modifier being added to patched device")
;    elseif(option == UD_ModifierPatchPowerMultiplier_S)
;        SetInfoText("Patched strength multiplier for specific modifier. Is applied to modifier of this type when it is patched. It is used only once when device is patched. After that, this value cant be changed")
    endif
EndFunction

Function CustomBondagePageInfo(int option)
    if(option == UD_CHB_Stamina_meter_Keycode_K)
        SetInfoText("$UD_STAMINAMETER_INFO")
    elseif(option == UD_CHB_Magicka_meter_Keycode_K)
        SetInfoText("$UD_MAGICKAMETER_INFO")
    elseif(option == UD_StruggleDifficulty_M)
        SetInfoText("$UD_ESCAPEDIFFICULTY_INFO")
    elseif(option == UD_UpdateTime_S)
        SetInfoText("$UD_UPDATETIME_INFO")
    elseif(option == UD_UseDDdifficulty_T)
        SetInfoText("$UD_USEDDDIFFICULTY_INFO")
    elseif(option == UD_hardcore_swimming_T)
        SetInfoText("$UD_HARDCORESWIMMING_INFO")
    elseif(option == UD_hardcore_swimming_difficulty_M)
        SetInfoText("$UD_HARDCORESWIMMINGDIFFICULTY_INFO")
    elseif option == UD_LockpickMinigameNum_S
        SetInfoText("$UD_LOCKPICKMINIGAMENUM_INFO")
    elseif option == UD_BaseDeviceSkillIncrease_S
        SetInfoText("$UD_BASEDEVICESKILLINCREASE_INFO")
    elseif option == UD_SkillEfficiency_S
        SetInfoText("$UD_SKILLEFFICIENCY_INFO")
    elseif option == UD_AutoCrit_T
        SetInfoText("$UD_AUTOCRIT_INFO")
    elseif option == UD_AutoCritChance_S
        SetInfoText("$UD_AUTOCRITCHANCE_INFO")
    elseif option == UD_CritEffect_M
        SetInfoText("$UD_CRITEFFECT_INFO")
    elseif option == UD_CooldownMultiplier_S
        SetInfoText("$UD_COOLDOWNMULTIPLIER_INFO")
    elseif option == UD_HardcoreMode_T
        SetInfoText("$UD_HARDCOREMODE_INFO")
    elseif option == UD_AllowArmTie_T
        SetInfoText("$UD_ALLOWARMTIE_INFO")
    elseif option == UD_AllowLegTie_T
        SetInfoText("$UD_ALLOWLEGTIE_INFO")
    elseif option == UD_MinigameHelpCd_S
        SetInfoText("$UD_MINIGAMEHELPCD_INFO")
    elseif option == UD_MinigameHelpCD_PerLVL_S
        SetInfoText("$UD_MINIGAMEHELPAMPL_INFO")
    elseif option == UD_MinigameHelpXPBase_S
        SetInfoText("$UD_MINIGAMEHELPXPBASE_INFO")
    elseif option == UDCD_SpecialKey_Keycode_K
        SetInfoText("$UD_SPECIALKEYKEY_INFO")
    elseif option == UD_DeviceLvlHealth_S
        SetInfoText("$UD_DEVICELVLHEALTH_INFO")
    elseif option == UD_DeviceLvlLockpick_S
        SetInfoText("$UD_DEVICELVLLOCKPICK_INFO")
    elseif option == UD_PreventMasterLock_T
        SetInfoText("$UD_PREVENTMASTERLOCK_INFO")
    elseif option == UD_DeviceLvlLocks_S
        SetInfoText("$UD_DEVICELVLLOCKS_INFO")
    elseif option == UD_MandatoryCrit_T
        SetInfoText("$UD_WMANDATORYCRIT_INFO")
    elseif option == UD_CritDurationAdjust_S
        SetInfoText("$UD_CRITDURATIONADJUST_INFO")
    elseif option == UD_KeyDurability_S
        SetInfoText("$UD_KEYDURABILITY_INFO")
    elseif option == UD_HardcoreAccess_T
        SetInfoText("$UD_HARDCOREACCESS_INFO")
    ElseIf option == UD_MinigameDrainMult_S
        SetInfoText("$UD_MINIGAMEDRAINMULT_INFO")
    ElseIf option == UD_InitialDrainDelay_S
        SetInfoText("$UD_INITIALDRAINDELAY_INFO")
    ElseIf option == UD_MinigameExhDurationMult_S
        SetInfoText("$UD_MINIEXHAUSDUR_INFO")
    ElseIf option == UD_MinigameExhMagnitudeMult_S
        SetInfoText("$UD_MINIEXHAUSMAG_INFO")
    elseif (option == UD_MinigameLockpickSkillAdjust_M)
        SetInfoText("$UD_MINIGAMELOCKPICKSKILLADJUST_INFO")
    elseif option == UD_LockpickMinigameDuration_S
        SetInfoText("$UD_LOCKPICKMINIGAMEDURATION_INFO")
    elseif option == UD_MinigameExhExponential_S
        SetInfoText("$UD_MINIEXHEXP_INFO")
    elseif option == UD_MinigameExhNoStruggleMax_S
        SetInfoText("$UD_MINIEXHNOSTRUGGMAX_INFO")
    Endif
EndFunction

Function CustomOrgasmPageInfo(int option)
    if     option == UD_OrgasmUpdateTime_S
        SetInfoText("$UD_ORGASMUPDATETIME_INFO")
    elseif option == UD_UseOrgasmWidget_T
        SetInfoText("$UD_USEORGASMWIDGET_INFO")
    elseif option == UD_OrgasmResistence_S
        SetInfoText("$UD_ORGASMRESISTENCE_INFO")
    elseif option == UD_OrgasmExhaustionStruggleMax_S
        SetInfoText("$UD_ORGASMEXHAUSTIONSTRUGGLEMAX_INFO")
    elseif option == UD_HornyAnimation_T
        SetInfoText("$UD_HORNYANIMATION_INFO")
    elseif option == UD_HornyAnimationDuration_S
        SetInfoText("$UD_HORNYANIMATIONDURATION_INFO")
    elseif option == UD_VibrationMultiplier_S
        SetInfoText("$UD_VIBRATIONMULTIPLIER_INFO")
    elseif option == UD_ArousalMultiplier_S
        SetInfoText("$UD_AROUSALMULTIPLIER_INFO")
    elseif option == UD_OrgasmArousalReduce_S
        SetInfoText("$UD_ORGASMAROUSALREDUCE_INFO")
    elseif option == UD_OrgasmArousalReduceDuration_S
        SetInfoText("$UD_ORGASMAROUSALREDUCEDURATION_INFO")
    elseif(option == UD_OrgasmExhaustion_T)
        SetInfoText("$UD_ORGASMEXHAUSTION_INFO")
    Endif
EndFunction

Function NPCsPageInfo(int option)
    if (option == UD_NPCSupport_T)
        SetInfoText("$UD_NPCSUPPORT_INFO")
    elseif option == UD_AIEnable_T
        SetInfoText("$UD_AIENABLE_INFO")
    elseif option == UD_AIUpdateTime_S
        SetInfoText("$UD_AIUPDATETIME_INFO")
    elseif option == UD_AICooldown_S
        SetInfoText("$UD_AICOOLDOWN_INFO") 
    Endif
EndFunction

Function PatcherPageInfo(int option)
    if  option == UD_PatchMult_S
        SetInfoText("$UD_PATCHMULT_INFO")
    elseif option == UD_EscapeModifier_S
        SetInfoText("$UD_ESCAPEMODIFIER_INFO")
    elseif option == UD_MinLocks_S
        SetInfoText("$UD_MINLOCKS_INFO")
    elseif option == UD_MaxLocks_S
        SetInfoText("$UD_MAXLOCKS_INFO")
    elseif option == UD_MinResistMult_S
        SetInfoText("$UD_MINRESISTMULT_INFO")
    elseif option == UD_MaxResistMult_S
        SetInfoText("$UD_MAXRESISTMULT_INFO")
    elseif option == UD_TimedLocks_T
        SetInfoText("If patched devices can have timed locks")
    endif
EndFunction

Function AbadanPageInfo(int option)
    ;dear mother of god
    if (option == dmg_heal_T)
        SetInfoText("$UD_DMGHEAL_INFO")
    elseif (option == UseAnalVariant_T)
        SetInfoText("$UD_ANALVARIANT_INFO")
    elseif(option == dmg_stamina_T)
        SetInfoText("$UD_DMGSTAMINA_INFO")
    elseif(option == dmg_magica_T)
        SetInfoText("$UD_DAMAGEMAGICA_INFO")
    elseif(option == hardcore_T)
        SetInfoText("$UD_HARDCORE_INFO")
    elseif (option == difficulty_M)
        SetInfoText("$UD_DIFFICULTY_INFO")
    elseif (option == preset_M)
        SetInfoText("$UD_PRESET_INFO")
    elseif (option == max_difficulty_S)
        SetInfoText("$UD_MAXDIFFICULTY_INFO")
    elseIf (option == eventchancemod_S)
        SetInfoText("$UD_EVENTCHANCEMOD_INFO")
    elseIf (option == little_finisher_chance_S)
        SetInfoText("$UD_LITTLEFINISHERCHANCE_INFO")
    elseIf (option == min_orgasm_little_finisher_S)
        SetInfoText("$UD_MINORGASMLITTLEFINISHER_INFO")
    elseIf (option == max_orgasm_little_finisher_S)
        SetInfoText("$UD_MAX_ORGASM_LITTLE_FINISHER_INFO")
    elseIf (option == little_finisher_cooldown_S)
        SetInfoText("$UD_LITTLEFINISHERCOOLDOWN_INFO")
    elseIf (option == final_finisher_pref_M)
        SetInfoText("$UD_FINALFINISHERPREF_INFO")
    endIf
EndFunction

Function DDPatchPageInfo(int option)
    if option == UD_GagPhonemModifier_S
        SetInfoText("$UD_GAGPHONEMMODIFIER_INFO")
    elseif option == UD_OutfitRemove_T
        SetInfoText("$UD_OUTFITREMOVE_INFO")
    elseif option == UD_AllowMenBondage_T
        SetInfoText("$UD_ALLOWMENBONDAGE")
    elseif option == UD_OrgasmAnimation_M
        SetInfoText("$UD_ORGASMANIMATION_INFO")
    elseif option == UD_CheckAllKw_T
        SetInfoText("$UD_CHECKALLKW_INFO")
    endif
EndFunction

Function UiWidgetPageInfo(int option)
    if option == UD_UseIWantWidget_T
        SetInfoText("$UD_USEIWANTWIDGET_INFO")
    elseif option == UD_UseWidget_T
        SetInfoText("$UD_USEWIDGET_INFO")
    elseif option == UD_WidgetPosX_M
        SetInfoText("$UD_CWIDGETPOSX_INFO")
    elseif option == UD_WidgetPosY_M
        SetInfoText("$UD_WIDGETPOSY_INFO")
    ElseIf option == UD_TextFontSize_S
        SetInfoText("$UD_TEXTFONTSIZE_INFO")
    ElseIf option == UD_TextLineLength_S
        SetInfoText("$UD_TEXTLINELENGTH_INFO")
    ElseIf option == UD_TextReadSpeed_S
        SetInfoText("$UD_TEXTREADSPEED_INFO")
    ElseIf option == UD_FilterVibNotifications_T
        SetInfoText("$UD_FILTERVIBNOTIFICATIONS_INFO")
    ElseIf option == UD_EnableCNotifications_S
        SetInfoText("$UD_ENABLECNOTIFICATIONS_INFO")
    ElseIf option == UD_EnableDeviceIcons_T
        SetInfoText("$UD_ENABLEDEVICEICONS_INFO")
    ElseIf option == UD_EnableDebuffIcons_T
        SetInfoText("$UD_ENABLEDEBUFFICONS_INFO")
    ElseIf option == UD_IconsSize_S
        SetInfoText("$UD_ICONSSIZE_INFO")
    ElseIf option == UD_IconsAnchor_M
        SetInfoText("$UD_ICONSANCHOR_INFO")
    ElseIf option == UD_IconsPadding_S
        SetInfoText("$UD_ICONSPADDING_INFO")
    ElseIf option == UD_TextAnchor_M
        SetInfoText("$UD_TEXTANCHOR_INFO")
    ElseIf option == UD_TextPadding_S
        SetInfoText("$UD_TEXTANCHOR_INFO")
    ElseIf option == UD_WidgetTest_T
        SetInfoText("$UD_WIDGETTEST_INFO")
    ElseIf option == UD_WidgetReset_T
        SetInfoText("$UD_WIDGETRESET_INFO")
    endif
EndFunction

Function DebugPageInfo(int option)
    ;dear mother of god
    if (option == rescanSlots_T)
        SetInfoText("$UD_RESCANSLOTS_INFO")
    elseif option == fixBugs_T
        SetInfoText("$UD_FIXBUGS_INFO")
    elseif option == unlockAll_T
        SetInfoText("$UD_UNLOCK_ALL_INFO")
    elseif option == endAnimation_T
        SetInfoText("$UD_ENDANIMATION_INFO")
    elseif option == unregisterNPC_T
        SetInfoText("$UD_UNREGISTER_NPC_INFO")
    elseif option == OrgasmCapacity_S
        SetInfoText("$UD_ORGASMCAPACITY_INFO")
    elseif option == OrgasmResist_S
        SetInfoText("$UD_ORGASMRESIST_INFO")
    endIf
EndFunction

Function AnimationPageInfo(Int option)
    If (option >= UDAM_AnimationJSON_First_T) && (option <= (UDAM_AnimationJSON_First_T + (UDAM.UD_AnimationJSON_All.Length - 1) * 2)) && (((option - UDAM_AnimationJSON_First_T) % 2) == 0)
        SetInfoText("$UD_JSONFILENAME_INFO")
    ElseIf (option >= UDAM_AnimationJSON_First_INFO) && (option <= (UDAM_AnimationJSON_First_INFO + (UDAM.UD_AnimationJSON_All.Length - 1) * 2)) && (((option - UDAM_AnimationJSON_First_INFO) % 2) == 0)
        Int loc_file_index = (option - UDAM_AnimationJSON_First_INFO) / 2
        SetInfoText(UDAM.UD_AnimationJSON_Error[loc_file_index])
    ElseIf option == UDAM_Reload_T
        SetInfoText("$UD_RELOADJSONS_INFO")
    elseif option == UD_AlternateAnimation_T
        SetInfoText("$UD_ALTERNATEANIMATION_INFO")
    elseif option == UD_UseSingleStruggleKeyword_T
        SetInfoText("$UD_USESINGLESTRUGGLEKEYWORD_INFO")
    elseif option == UD_AlternateAnimationPeriod_S
        SetInfoText("$UD_ALTERNATEANIMATIONPERIOD_INFO")
    EndIf
EndFunction

Function AnimationPlaygroundPageInfo(Int option)
    If option == UDAM_TestQuery_Request_T
        SetInfoText("$UD_TESTQUERY_INFO")
    ElseIf option == UDAM_TestQuery_StopAnimation_T
        SetInfoText("$UD_TESTQUERY_STOPANIMATION_INFO")
    ElseIf option == UDAM_TestQuery_ElapsedTime_T
        SetInfoText("")
    ElseIf (option >= UDAM_TestQuery_Results_JsonPath_First_T) && (option <= (UDAM_TestQuery_Results_JsonPath_First_T + (UDAM_TestQuery_Results_JsonPath.Length - 1) * 2)) && (((option - UDAM_TestQuery_Results_JsonPath_First_T) % 2) == 0)
        Int index = (option - UDAM_TestQuery_Results_JsonPath_First_T) / 2
        String val = UDAM_TestQuery_Results_JsonPath[index]
        SetInfoText("Json path: " + UDAM_TestQuery_Results_JsonPath[index] + "\nAnim. event(s): " + UDAM_TestQuery_Results_AnimEvent[index])
    ElseIf option == UD_Helper_T
        SetInfoText("$UD_HELPER_INFO")
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
    JsonUtil.SetFloatValue(strFile, "OrgasmResistence", UDCONF.UD_OrgasmResistence)
    JsonUtil.SetIntValue(strFile, "OrgasmExhaustionStruggleMax", UDCONF.UD_OrgasmExhaustionStruggleMax)
    JsonUtil.SetIntValue(strFile, "LockpicksPerMinigame", UDCDmain.UD_LockpicksPerMinigame as Int)
    JsonUtil.SetIntValue(strFile, "UseOrgasmWidget", UDCONF.UD_UseOrgasmWidget as Int)
    JsonUtil.SetFloatValue(strFile, "OrgasmUpdateTime", UDCONF.UD_OrgasmUpdateTime)
    JsonUtil.SetIntValue(strFile, "OrgasmAnimation", UDCONF.UD_OrgasmAnimation)
    JsonUtil.SetIntValue(strFile, "HornyAnimation", UDCONF.UD_HornyAnimation as Int)
    JsonUtil.SetIntValue(strFile, "HornyAnimationDuration", UDCONF.UD_HornyAnimationDuration)
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
    JsonUtil.SetIntValue(strFile, "PostOrgasmArousalReduce", UDCONF.UD_OrgasmArousalReduce)
    JsonUtil.SetIntValue(strFile, "PostOrgasmArousalReduce_Duration", UDCONF.UD_OrgasmArousalReduceDuration)
    JsonUtil.SetIntValue(strFile, "MandatoryCrit", UDCDmain.UD_MandatoryCrit as Int)
    JsonUtil.SetFloatValue(strFile, "CritDurationAdjust", UDCDmain.UD_CritDurationAdjust)
    JsonUtil.SetIntValue(strFile, "KeyDurability", UDCDmain.UD_KeyDurability)
    JsonUtil.SetIntValue(strFile, "HardcoreAccess", UDCDmain.UD_HardcoreAccess as Int)
    JsonUtil.SetFloatValue(strFile, "MinigameDrainMult", UDCDmain.UD_MinigameDrainMult)
    JsonUtil.SetFloatValue(strFile, "InitialDrainDelay", UDCDmain.UD_InitialDrainDelay)
    JsonUtil.SetFloatValue(strFile, "MinigameExhDurationMult", UDCDmain.UD_MinigameExhDurationMult)
    JsonUtil.SetFloatValue(strFile, "MinigameExhMagnitudeMult", UDCDmain.UD_MinigameExhMagnitudeMult)
    JsonUtil.SetIntValue(strFile, "MinigameLockpickSkillAdjust", UDCDmain.UD_MinigameLockpickSkillAdjust)
    JsonUtil.SetIntValue(strFile, "LockpickMinigameDuration", UDCDmain.UD_LockpickMinigameDuration)
    JsonUtil.SetFloatValue(strFile, "MinigameExhExponential", UDCDMain.UD_MinigameExhExponential)
    JsonUtil.SetIntValue(strFile, "MinigameExhNoStruggleMax", UDCDMAIN.UD_MinigameExhNoStruggleMax as Int)
    
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
    JsonUtil.SetIntValue(strFile, "TimedLocks", UDCDmain.UDPatcher.UD_TimedLocks as Int)
    
    ;UI/WIDGET
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
    JsonUtil.SetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)
    JsonUtil.SetIntValue(strFile, "SwimmingDifficulty", UDSS.UD_hardcore_swimming_difficulty)
    JsonUtil.SetIntValue(strFile, "RandomFiler", UDCONF.UD_RandomDevice_GlobalFilter)
    JsonUtil.SetIntValue(strFile, "SlotUpdateTime", Round(UDCD_NPCM.UD_SlotUpdateTime))
    JsonUtil.SetIntValue(strFile, "OutfitRemove", UDCDMain.UD_OutfitRemove as Int)
    JsonUtil.SetIntValue(strFile, "AllowMenBondage", UDmain.AllowMenBondage as Int)
    
    ; ANIMATIONS
    JsonUtil.StringListCopy(strFile, "Anims_UserDisabledJSONs", UDAM.UD_AnimationJSON_Off)
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
    UDmain.UD_CheckAllKw = JsonUtil.GetIntValue(strFile,"AllKeywordCheck",UDmain.UD_CheckAllKw as Int)

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
    
    UDCDmain.UD_AutoCritChance              = JsonUtil.GetIntValue(strFile, "AutoCritChance", UDCDmain.UD_AutoCritChance)
    UDCDmain.UD_VibrationMultiplier         = JsonUtil.GetFloatValue(strFile, "VibrationMultiplier", UDCDmain.UD_VibrationMultiplier)
    UDCDmain.UD_ArousalMultiplier           = JsonUtil.GetFloatValue(strFile, "ArousalMultiplier", UDCDmain.UD_ArousalMultiplier)
    UDCONF.UD_OrgasmResistence                = JsonUtil.GetFloatValue(strFile, "OrgasmResistence", UDCONF.UD_OrgasmResistence)
    UDCONF.UD_OrgasmExhaustionStruggleMax     = JsonUtil.GetIntValue(strFile, "OrgasmExhaustionStruggleMax", UDCONF.UD_OrgasmExhaustionStruggleMax)
    UDCDmain.UD_LockpicksPerMinigame        = JsonUtil.GetIntValue(strFile, "LockpicksPerMinigame", UDCDmain.UD_LockpicksPerMinigame)
    UDCONF.UD_UseOrgasmWidget                 = JsonUtil.GetIntValue(strFile, "UseOrgasmWidget", UDCONF.UD_UseOrgasmWidget as Int)
    UDCONF.UD_OrgasmUpdateTime                = JsonUtil.GetFloatValue(strFile, "OrgasmUpdateTime", UDCONF.UD_OrgasmUpdateTime)
    UDCONF.UD_OrgasmAnimation                 = JsonUtil.GetIntValue(strFile, "OrgasmAnimation", UDCONF.UD_OrgasmAnimation)
    UDCONF.UD_HornyAnimation                  = JsonUtil.GetIntValue(strFile, "HornyAnimation", UDCONF.UD_HornyAnimation as Int)
    UDCONF.UD_HornyAnimationDuration          = JsonUtil.GetIntValue(strFile, "HornyAnimationDuration", UDCONF.UD_HornyAnimationDuration)
    UDCDmain.UD_CooldownMultiplier          = JsonUtil.GetFloatValue(strFile, "CooldownMultiplier", UDCDmain.UD_CooldownMultiplier)
    UDCDMain.UD_SkillEfficiency             = JsonUtil.GetIntValue(strFile, "SkillEfficiency", UDCDmain.UD_SkillEfficiency)
    UDCDmain.UD_CritEffect                  = JsonUtil.GetIntValue(strFile, "CritEffect", UDCDmain.UD_CritEffect)
    UDCDmain.UD_HardcoreMode                = JsonUtil.GetIntValue(strFile, "HardcoreMode", UDCDmain.UD_HardcoreMode as Int)
    UDCDmain.UD_AllowArmTie                 = JsonUtil.GetIntValue(strFile, "AllowArmTie", UDCDmain.UD_AllowArmTie as Int)
    UDCDmain.UD_AllowLegTie                 = JsonUtil.GetIntValue(strFile, "AllowLegTie", UDCDmain.UD_AllowLegTie as Int)
    UDCDmain.UD_MinigameHelpCd              = JsonUtil.GetIntValue(strFile, "MinigameHelpCD",UDCDmain.UD_MinigameHelpCd)
    UDCDmain.UD_MinigameHelpCD_PerLVL       = JsonUtil.GetIntValue(strFile, "MinigameHelpCD_PerLVL", Round(UDCDmain.UD_MinigameHelpCD_PerLVL))
    UDCDmain.UD_MinigameHelpXPBase          = JsonUtil.GetIntValue(strFile, "MinigameHelpXPBase", UDCDmain.UD_MinigameHelpXPBase)
    UDCDMain.UD_DeviceLvlHealth             = JsonUtil.GetFloatValue(strFile, "DeviceLvlHealth", UDCDMain.UD_DeviceLvlHealth*100)/100
    UDCDMain.UD_DeviceLvlLockpick           = JsonUtil.GetFloatValue(strFile, "DeviceLvlLockpick", UDCDMain.UD_DeviceLvlLockpick)
    UDCDMain.UD_DeviceLvlLocks              = JsonUtil.GetIntValue(strFile, "DeviceLvlLocks", UDCDMain.UD_DeviceLvlLocks)
    UDCDmain.UD_PreventMasterLock           = JsonUtil.GetIntValue(strFile, "PreventMasterLock", UDCDmain.UD_PreventMasterLock as Int)
    UDCONF.UD_OrgasmArousalReduce             = JsonUtil.GetIntValue(strFile, "PostOrgasmArousalReduce", UDCONF.UD_OrgasmArousalReduce)
    UDCONF.UD_OrgasmArousalReduceDuration     = JsonUtil.GetIntValue(strFile, "PostOrgasmArousalReduce_Duration", UDCONF.UD_OrgasmArousalReduceDuration)
    UDCDmain.UD_MandatoryCrit               = JsonUtil.GetIntValue(strFile, "MandatoryCrit", UDCDmain.UD_MandatoryCrit as Int)
    UDCDmain.UD_CritDurationAdjust          = JsonUtil.GetFloatValue(strFile, "CritDurationAdjust", UDCDmain.UD_CritDurationAdjust)
    UDCDmain.UD_KeyDurability               = JsonUtil.GetIntValue(strFile, "KeyDurability", UDCDmain.UD_KeyDurability)
    UDCDmain.UD_HardcoreAccess              = JsonUtil.GetIntValue(strFile, "HardcoreAccess", UDCDmain.UD_HardcoreAccess as Int)
    UDCDmain.UD_MinigameDrainMult           = JsonUtil.GetFloatValue(strFile, "MinigameDrainMult", UDCDmain.UD_MinigameDrainMult)
    UDCDmain.UD_InitialDrainDelay           = JsonUtil.GetFloatValue(strFile, "InitialDrainDelay", UDCDmain.UD_InitialDrainDelay)
    UDCDmain.UD_MinigameExhDurationMult     = JsonUtil.GetFloatValue(strFile, "MinigameExhDurationMult", UDCDmain.UD_MinigameExhDurationMult)
    UDCDmain.UD_MinigameExhMagnitudeMult    = JsonUtil.GetFloatValue(strFile, "MinigameExhMagnitudeMult", UDCDmain.UD_MinigameExhMagnitudeMult)
    UDCDmain.UD_MinigameLockpickSkillAdjust = JsonUtil.GetIntValue(strFile, "MinigameLockpickSkillAdjust", UDCDmain.UD_MinigameLockpickSkillAdjust)
    UDCDmain.UD_LockpickMinigameDuration    = JsonUtil.GetIntValue(strFile, "LockpickMinigameDuration", UDCDmain.UD_LockpickMinigameDuration)
    UDCDMain.UD_MinigameExhExponential      = JsonUtil.GetFloatValue(strFile, "MinigameExhExponential", UDCDMain.UD_MinigameExhExponential)
    UDCDMain.UD_MinigameExhNoStruggleMax   = JsonUtil.GetIntValue(strFile, "MinigameExhNoStruggleMax", UDCDMain.UD_MinigameExhNoStruggleMax)
    
    
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
    UDCDmain.UDPatcher.UD_TimedLocks = JsonUtil.GetIntValue(strFile, "TimedLocks", UDCDmain.UDPatcher.UD_TimedLocks as Int)
    
    ;UI/WIDGET
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
    
    ;Other
    libs.UD_StartThirdpersonAnimation_Switch = JsonUtil.GetIntValue(strFile, "StartThirdpersonAnimation_Switch", libs.UD_StartThirdpersonAnimation_Switch as Int)
    UDSS.UD_hardcore_swimming_difficulty = JsonUtil.GetIntValue(strFile, "SwimmingDifficulty", UDSS.UD_hardcore_swimming_difficulty)
    UDCONF.UD_RandomDevice_GlobalFilter =  JsonUtil.GetIntValue(strFile, "RandomFiler", UDCONF.UD_RandomDevice_GlobalFilter)
    UDCD_NPCM.UD_SlotUpdateTime =  JsonUtil.GetIntValue(strFile, "SlotUpdateTime", Round(UDCD_NPCM.UD_SlotUpdateTime))
    UDCDMain.UD_OutfitRemove = JsonUtil.GetIntValue(strFile, "OutfitRemove", UDCDMain.UD_OutfitRemove as Int)
    UDmain.AllowMenBondage = JsonUtil.GetIntValue(strFile, "AllowMenBondage", UDmain.AllowMenBondage as Int)

    ; ANIMATIONS
    If JsonUtil.StringListCount(strFile, "Anims_UserDisabledJSONs") > 0
        UDAM.UD_AnimationJSON_Off = JsonUtil.StringListToArray(strFile, "Anims_UserDisabledJSONs")
    EndIf
    UDAM.UD_AlternateAnimation = JsonUtil.GetIntValue(strFile, "AlternateAnimation", UDAM.UD_AlternateAnimation as Int) > 0
    UDAM.UD_AlternateAnimationPeriod = JsonUtil.GetIntValue(strFile, "AlternateAnimationPeriod", UDAM.UD_AlternateAnimationPeriod)
    UDAM.UD_UseSingleStruggleKeyword = JsonUtil.GetIntValue(strFile, "UseSingleStruggleKeyword", UDAM.UD_UseSingleStruggleKeyword as Int) > 0

    UD_Native.SyncAnimationSetting(UDAM.UD_AnimationJSON_Off)
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
    UDCONF.UD_OrgasmResistence            = 3.5
    UDCONF.UD_OrgasmExhaustionStruggleMax = 6
    UDCDmain.UD_LockpicksPerMinigame    = 2
    UDCONF.UD_UseOrgasmWidget             = true
    UDCONF.UD_OrgasmUpdateTime            = 0.5
    UDCONF.UD_OrgasmAnimation             = 1
    UDCONF.UD_HornyAnimation              = true
    UDCONF.UD_HornyAnimationDuration      = 5
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
    UDCONF.UD_OrgasmArousalReduce         = 25
    UDCONF.UD_OrgasmArousalReduceDuration =  7
    UDCDmain.UD_MandatoryCrit           = False
    UDCDmain.UD_CritDurationAdjust      = 0.0
    UDCDmain.UD_KeyDurability           = 5
    UDCDmain.UD_HardcoreAccess          = False
    UDCDmain.UD_MinigameDrainMult       = 1.0
    UDCDmain.UD_InitialDrainDelay       = 0
    UDCDmain.UD_MinigameExhDurationMult = 1.0
    UDCDmain.UD_MinigameExhMagnitudeMult= 1.0
    UDCDmain.UD_MinigameLockpickSkillAdjust = 2
    UDCDMain.UD_MinigameExhExponential  = 1.0
    UDCDMain.UD_MinigameExhNoStruggleMax= 2
    
    ;ABADON
    AbadonQuest.final_finisher_set      = true
    AbadonQuest.final_finisher_pref     = 0
    AbadonQuest.UseAnalVariant          = false
    
    ;PATCHER
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
    libs.UD_StartThirdpersonAnimation_Switch        = true
    UDSS.UD_hardcore_swimming_difficulty            = 1
    UDWC.UD_WidgetXPos                              = 2
    UDWC.UD_WidgetYPos                              = 0
    UDCONF.UD_RandomDevice_GlobalFilter             = 0xFFFFFFFF ;32b
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
