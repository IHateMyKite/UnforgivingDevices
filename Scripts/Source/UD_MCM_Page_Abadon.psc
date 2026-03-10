Scriptname UD_MCM_Page_Abadon extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_AbadonQuest_script Property AbadonQuest
    UD_AbadonQuest_script Function Get()
        return MCM.AbadonQuest
    EndFunction
EndProperty

string[] final_finisher_pref_list

Function PageInit()
    if AbadonQuest.final_finisher_set
        abadon_flag_2 = OPTION_FLAG_NONE
    else
        abadon_flag_2 = OPTION_FLAG_DISABLED
    endif
    setAbadonPreset(1)
EndFunction

Function PageUpdate()
    presetList = new string[4]
    presetList[0] = "$Forgiving"
    presetList[1] = "$Pleasure slave"
    presetList[2] = "$Game of time"
    presetList[3] = "$Custom"
    
    final_finisher_pref_list = new string[7]
    final_finisher_pref_list[0] = "$Random"
    final_finisher_pref_list[1] = "$Rope"
    final_finisher_pref_list[2] = "$Transparent"
    final_finisher_pref_list[3] = "$Rubber"
    final_finisher_pref_list[4] = "$Restrictive"
    final_finisher_pref_list[5] = "$Simple"
    final_finisher_pref_list[6] = "$Yoke"
    
    difficultyList = new string[3]
    difficultyList[0] = "$Easy"
    difficultyList[1] = "$Normal"
    difficultyList[2] = "$Hard"
EndFunction

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
int hardcore_T
int preset
int preset_M
string[] presetList
int abadon_flag 
int abadon_flag_2
int UseAnalVariant_T

Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_H_ABADONPLUGSETTINGS")
    addEmptyOption()

    preset_M = AddMenuOption("$UD_PRESET", presetList[preset])
    UseAnalVariant_T = addToggleOption("$UD_ANALVARIANT", AbadonQuest.UseAnalVariant,MCM.AbadonQuestFlag)
    
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
    little_finisher_cooldown_S = AddSliderOption("$UD_LITTLEFINISHERCOOLDOWN", AbadonQuest.little_finisher_cooldown, "{1} hours",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    
    min_orgasm_little_finisher_S = AddSliderOption("$UD_MINORGASMLITTLEFINISHER", AbadonQuest.min_orgasm_little_finisher, "{1}",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
    max_orgasm_little_finisher_S = AddSliderOption("$UD_MAX_ORGASM_LITTLE_FINISHER", AbadonQuest.max_orgasm_little_finisher, "{1}",FlagSwitchOr(abadon_flag,UD_LockMenu_flag))
EndFunction

Function PageOptionSelect(Int aiOption)
    if(aiOption == UseAnalVariant_T)
        AbadonQuest.UseAnalVariant = !AbadonQuest.UseAnalVariant
        SetToggleOptionValue(UseAnalVariant_T, AbadonQuest.UseAnalVariant)
    elseif (aiOption == dmg_heal_T)
        AbadonQuest.dmg_heal = !AbadonQuest.dmg_heal
        SetToggleOptionValue(dmg_heal_T, AbadonQuest.dmg_heal)
    elseif(aiOption == dmg_stamina_T)
        AbadonQuest.dmg_stamina = !AbadonQuest.dmg_stamina
        SetToggleOptionValue(dmg_stamina_T, AbadonQuest.dmg_stamina)
    elseif(aiOption == dmg_magica_T)
        AbadonQuest.dmg_magica = !AbadonQuest.dmg_magica
        SetToggleOptionValue(dmg_magica_T, AbadonQuest.dmg_magica)
    elseif(aiOption == hardcore_T)
        AbadonQuest.hardcore = !AbadonQuest.hardcore
        SetToggleOptionValue(hardcore_T, AbadonQuest.hardcore)
    elseif(aiOption == final_finisher_set_T)
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

Function PageOptionSliderOpen(Int aiOption)
    if (aiOption == max_difficulty_S)
        SetSliderDialogStartValue(AbadonQuest.max_difficulty)
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(1.0, 300.0)
        SetSliderDialogInterval(1.0)
    elseIf (aiOption == eventchancemod_S)
        SetSliderDialogStartValue(AbadonQuest.eventchancemod)
        SetSliderDialogDefaultValue(1.5)
        SetSliderDialogRange(0.0, 10.0)
        SetSliderDialogInterval(1.0)
    elseIf (aiOption == little_finisher_chance_S)
        SetSliderDialogStartValue(AbadonQuest.little_finisher_chance)
        SetSliderDialogDefaultValue(1.5)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseIf (aiOption == min_orgasm_little_finisher_S)
        SetSliderDialogStartValue(AbadonQuest.min_orgasm_little_finisher)
        SetSliderDialogDefaultValue(1.5)
        SetSliderDialogRange(1.0, 30.0)
        SetSliderDialogInterval(1.0)
    elseIf (aiOption == max_orgasm_little_finisher_S)
        SetSliderDialogStartValue(AbadonQuest.max_orgasm_little_finisher)
        SetSliderDialogDefaultValue(1.5)
        SetSliderDialogRange(AbadonQuest.min_orgasm_little_finisher, 30.0)
        SetSliderDialogInterval(1.0)
    elseIf (aiOption == little_finisher_cooldown_S)
        SetSliderDialogStartValue(AbadonQuest.little_finisher_cooldown)
        SetSliderDialogDefaultValue(1.5)
        SetSliderDialogRange(1.0, 12.0)
        SetSliderDialogInterval(0.5)
    endIf
EndFunction

Function PageOptionSliderAccept(Int aiOption, Float afValue)
    if (aiOption == max_difficulty_S)
        AbadonQuest.max_difficulty = afValue
        SetSliderOptionValue(max_difficulty_S, AbadonQuest.max_difficulty, "{0}")
    elseIf (aiOption == eventchancemod_S)
        AbadonQuest.eventchancemod = afValue as int
        SetSliderOptionValue(eventchancemod_S, AbadonQuest.eventchancemod, "{0} %")
    elseIf (aiOption == little_finisher_chance_S)
        AbadonQuest.little_finisher_chance = afValue as int
        SetSliderOptionValue(little_finisher_chance_S, AbadonQuest.little_finisher_chance, "{1} %")
    elseIf (aiOption == min_orgasm_little_finisher_S)
        AbadonQuest.min_orgasm_little_finisher = afValue as int
        SetSliderOptionValue(min_orgasm_little_finisher_S, AbadonQuest.min_orgasm_little_finisher, "{1}")
    elseIf (aiOption == max_orgasm_little_finisher_S)
        AbadonQuest.max_orgasm_little_finisher = afValue as int
        SetSliderOptionValue(max_orgasm_little_finisher_S, AbadonQuest.max_orgasm_little_finisher, "{1}")
    elseIf (aiOption == little_finisher_cooldown_S)
        AbadonQuest.little_finisher_cooldown = afValue
        SetSliderOptionValue(little_finisher_cooldown_S, AbadonQuest.little_finisher_cooldown, "{1}")
    endIf
EndFunction

Function PageOptionMenuOpen(int aiOption)
    if (aiOption == difficulty_M)
        SetMenuDialogOptions(difficultyList)
        SetMenuDialogStartIndex(AbadonQuest.overaldifficulty)
        SetMenuDialogDefaultIndex(1)
    elseif (aiOption == preset_M)
        SetMenuDialogOptions(presetList)
        SetMenuDialogStartIndex(preset)
        SetMenuDialogDefaultIndex(0)
    endif
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
    if (aiOption == difficulty_M)
        AbadonQuest.overaldifficulty = aiIndex
        SetMenuOptionValue(difficulty_M, difficultyList[AbadonQuest.overaldifficulty])
    elseif (aiOption == preset_M)
        preset = aiIndex
        setAbadonPreset(preset)
        SetMenuOptionValue(preset_M, presetList[preset])
        forcePageReset()
    endIf
EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int aiOption)
    ;dear mother of god
    if (aiOption == dmg_heal_T)
        SetInfoText("$UD_DMGHEAL_INFO")
    elseif (aiOption == UseAnalVariant_T)
        SetInfoText("$UD_ANALVARIANT_INFO")
    elseif(aiOption == dmg_stamina_T)
        SetInfoText("$UD_DMGSTAMINA_INFO")
    elseif(aiOption == dmg_magica_T)
        SetInfoText("$UD_DAMAGEMAGICA_INFO")
    elseif(aiOption == hardcore_T)
        SetInfoText("$UD_HARDCORE_INFO")
    elseif (aiOption == difficulty_M)
        SetInfoText("$UD_DIFFICULTY_INFO")
    elseif (aiOption == preset_M)
        SetInfoText("$UD_PRESET_INFO")
    elseif (aiOption == max_difficulty_S)
        SetInfoText("$UD_MAXDIFFICULTY_INFO")
    elseIf (aiOption == eventchancemod_S)
        SetInfoText("$UD_EVENTCHANCEMOD_INFO")
    elseIf (aiOption == little_finisher_chance_S)
        SetInfoText("$UD_LITTLEFINISHERCHANCE_INFO")
    elseIf (aiOption == min_orgasm_little_finisher_S)
        SetInfoText("$UD_MINORGASMLITTLEFINISHER_INFO")
    elseIf (aiOption == max_orgasm_little_finisher_S)
        SetInfoText("$UD_MAX_ORGASM_LITTLE_FINISHER_INFO")
    elseIf (aiOption == little_finisher_cooldown_S)
        SetInfoText("$UD_LITTLEFINISHERCOOLDOWN_INFO")
    elseIf (aiOption == final_finisher_pref_M)
        SetInfoText("$UD_FINALFINISHERPREF_INFO")
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
