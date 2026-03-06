Scriptname UD_MCM_Page_Devices extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_UserInputScript Property UDUI
    UD_UserInputScript Function Get()
        return UDmain.UDUI
    EndFunction
EndProperty
UD_Config         Property UDCONF hidden
    UD_Config Function Get()
        return UDmain.UDCONF
    EndFunction
EndProperty
UD_SwimmingScript Property UDSS hidden
    UD_SwimmingScript Function Get()
        return MCM.UDSS
    EndFunction
EndProperty

string[] difficultyList
Function PageUpdate()
    difficultyList = new string[3]
    difficultyList[0] = "$Easy"
    difficultyList[1] = "$Normal"
    difficultyList[2] = "$Hard"
    
    criteffectList = new string[3]
    criteffectList[0] = "HUD"
    criteffectList[1] = "$Body shader"
    criteffectList[2] = "$HUD + Body shader"
EndFunction

int UD_ActionKey_K
int UD_NPCSupport_T
int UD_Swimming_flag
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
Function PageReset(Bool abLockMenu)
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
    UD_UpdateTime_S = addSliderOption("$UD_UPDATETIME",UDCONF.UD_UpdateTime, "${0} s")
    UD_CooldownMultiplier_S = addSliderOption("$UD_COOLDOWNMULTIPLIER",Round(UDCDmain.UD_CooldownMultiplier*100), "{0} %",FlagSwitch(!abLockMenu))
    
    UD_PreventMasterLock_T = addToggleOption("$UD_PREVENTMASTERLOCK",UDCDmain.UD_PreventMasterLock,FlagSwitch(!abLockMenu))
    UD_LockpickMinigameNum_S = addSliderOption("$UD_LOCKPICKMINIGAMENUM",UDCDmain.UD_LockpicksPerMinigame, "{0}",FlagSwitch(!abLockMenu))
    
    addEmptyOption()
    UD_LockpickMinigameDuration_S       = addSliderOption("$UD_LOCKPICKMINIGAMEDURATION",UDCDmain.UD_LockpickMinigameDuration, "{0} s",FlagSwitch(!abLockMenu))
    
    UD_KeyDurability_S = addSliderOption("$UD_KEYDURABILITY",UDCDmain.UD_KeyDurability, "{0}",FlagSwitch(!abLockMenu))
    UD_HardcoreAccess_T = addToggleOption("$UD_HARDCOREACCESS", UDCDmain.UD_HardcoreAccess,FlagSwitch(!abLockMenu))
    
    UD_AllowArmTie_T = addToggleOption("$UD_KALLOWARMTIE", UDCDmain.UD_AllowArmTie,FlagSwitch(!abLockMenu))
    UD_AllowLegTie_T = addToggleOption("$UD_ALLOWLEGTIE", UDCDmain.UD_AllowLegTie,FlagSwitch(!abLockMenu))
    
    UD_MinigameDrainMult_S = addSliderOption("$UD_MINIGAMEDRAINMULT", Round(UDCDmain.UD_MinigameDrainMult * 100), "{1} %", FlagSwitch(!abLockMenu))
    UD_InitialDrainDelay_S = addSliderOption("$UD_INITIALDRAINDELAY", UDCDmain.UD_InitialDrainDelay, "{0} s", FlagSwitch(!abLockMenu))
    
    
    ;MINIGAME EXHAUSTION
    AddHeaderOption("$UD_H_MINIEXHAUS")
    addEmptyOption()
    
    UD_MinigameExhDurationMult_S     = addSliderOption("$UD_MINIEXHAUSDUR", Round(UDCDmain.UD_MinigameExhDurationMult * 100), "{0} %", FlagSwitch(!abLockMenu))
    UD_MinigameExhExponential_S      = addSliderOption("$UD_MINIEXHEXP", UDCDmain.UD_MinigameExhExponential, "{1}", FlagSwitch(!abLockMenu))

    UD_MinigameExhMagnitudeMult_S    = addSliderOption("$UD_MINIEXHAUSMAG", Round(UDCDmain.UD_MinigameExhMagnitudeMult * 100), "{0} %", FlagSwitch(!abLockMenu))
    UD_MinigameExhNoStruggleMax_S    = addSliderOption("$UD_MINIEXHNOSTRUGGMAX", Round(UDCDmain.UD_MinigameExhNoStruggleMax), "{0}", FlagSwitch(!abLockMenu))

    ;HELPER SETTING
    AddHeaderOption("$UD_H_HELPINGSETTING")
    addEmptyOption()
    UD_MinigameHelpCd_S = addSliderOption("$UD_MINIGAMEHELPCD",UDCDmain.UD_MinigameHelpCd, "${0} min",FlagSwitch(!abLockMenu))
    UD_MinigameHelpXPBase_S = addSliderOption("$UD_MINIGAMEHELPXPBASE",UDCDmain.UD_MinigameHelpXPBase, "{0} XP",FlagSwitch(!abLockMenu))
    
    UD_MinigameHelpCD_PerLVL_S = addSliderOption("$UD_MINIGAMEHELPAMPL",UDCDmain.UD_MinigameHelpCD_PerLVL, "{0} %",FlagSwitch(!abLockMenu))
    addEmptyOption()
    
    ;HARDCORE SWIMMING
    AddHeaderOption("$UD_UNFORGIVING_SWIMMING")
    AddEmptyOption()
    UD_hardcore_swimming_T = addToggleOption("$UD_HARDCORESWIMMING", UDSS.UD_hardcore_swimming,FlagSwitch(!abLockMenu))    
    UD_hardcore_swimming_difficulty_M = AddMenuOption("$UD_HARDCORESWIMMINGDIFFICULTY", difficultyList[UDSS.UD_hardcore_swimming_difficulty],FlagSwitchOr(UD_Swimming_flag,FlagSwitch(!abLockMenu)))
    
    ;CRITS
    AddHeaderOption("$UD_H_DEVICECRITS")
    AddEmptyOption()
    UD_CritEffect_M     = AddMenuOption("$UD_CRITEFFECT", criteffectList[UDCDmain.UD_CritEffect],FlagNegate(FlagSwitch(UDCDmain.UD_AutoCrit)))
    UD_MandatoryCrit_T  = addToggleOption("$UD_MANDATORYCRIT", UDCDmain.UD_MandatoryCrit,FlagSwitchOr(FlagNegate(FlagSwitch(UDCDmain.UD_AutoCrit)),FlagSwitch(!abLockMenu)))
    
    UD_AutoCrit_T       = addToggleOption("$UD_AUTOCRIT", UDCDmain.UD_AutoCrit,FlagSwitch(!abLockMenu))
    UD_AutoCritChance_S = addSliderOption("$UD_AUTOCRITCHANCE",UDCDmain.UD_AutoCritChance, "{0} %",FlagSwitchOr(FlagSwitch(UDCDmain.UD_AutoCrit),FlagSwitch(!abLockMenu)))
    
    UD_CritDurationAdjust_S = addSliderOption("$UD_CRITDURATIONADJUST",UDCDmain.UD_CritDurationAdjust, "${2} s",FlagSwitchOr(FlagNegate(FlagSwitch(UDCDmain.UD_AutoCrit)),FlagSwitch(!abLockMenu)))
    AddEmptyOption()
    
    ;DEVICE LEVEL scaling
    AddHeaderOption("$UD_H_LEVELSCALING")
    AddEmptyOption()
    
    UD_DeviceLvlHealth_S    = addSliderOption("$UD_DEVICELVLHEALTH",UDCDmain.UD_DeviceLvlHealth*100, "{1} %",FlagSwitch(!abLockMenu))
    UD_DeviceLvlLockpick_S  = addSliderOption("$UD_DEVICELVLLOCKPICK",UDCDmain.UD_DeviceLvlLockpick, "{1}",FlagSwitch(!abLockMenu))
    UD_DeviceLvlLocks_S     = addSliderOption("$UD_DEVICELVLLOCKS",UDCDmain.UD_DeviceLvlLocks, "{0} LVLs",FlagSwitch(!abLockMenu))
    AddEmptyOption()
    
    ;DIFFICULTY
    AddHeaderOption("$UD_H_DIFFICULTY")
    AddEmptyOption()
    UD_HardcoreMode_T = addToggleOption("$UD_HARDCOREMODE", UDCDmain.UD_HardcoreMode)
    AddTextOption("$UD_STRUGGLEDIFFICULTY", Math.floor((2 - UDCDmain.getStruggleDifficultyModifier())*100 +0.5) + " %",OPTION_FLAG_DISABLED)
    
    UD_StruggleDifficulty_M = AddMenuOption("$UD_ESCAPEDIFFICULTY", difficultyList[UDCDmain.UD_StruggleDifficulty],FlagSwitch(!abLockMenu))
    AddTextOption("$UD_MENDDIFFICULTY", Math.floor(UDCDmain.getMendDifficultyModifier()*100 + 0.5) + " %",OPTION_FLAG_DISABLED)
     
    UD_UseDDdifficulty_T = addToggleOption("$UD_USEDDDIFFICULTY", UDCDmain.UD_UseDDdifficulty,FlagSwitch(!abLockMenu))
    AddTextOption("$UD_KEYMODIFIER", Math.floor((UDCDmain.CalculateKeyModifier())*100 + 0.5) + " %",OPTION_FLAG_DISABLED)
EndFunction

Function PageOptionSelect(Int aiOption)
    if(aiOption == UD_hardcore_swimming_T)
        UDSS.UD_hardcore_swimming = !UDSS.UD_hardcore_swimming
        SetToggleOptionValue(UD_hardcore_swimming_T, UDSS.UD_hardcore_swimming)
        if (UDSS.UD_hardcore_swimming)
            UD_Swimming_flag = OPTION_FLAG_NONE
        else
            UD_Swimming_flag = OPTION_FLAG_DISABLED
        endif
        forcePageReset()
    elseif(aiOption == UD_UseDDdifficulty_T)
        UDCDmain.UD_UseDDdifficulty = !UDCDmain.UD_UseDDdifficulty
        SetToggleOptionValue(UD_UseDDdifficulty_T, UDCDmain.UD_UseDDdifficulty)
    elseif aiOption == UD_AutoCrit_T
        UDCDmain.UD_AutoCrit = !UDCDmain.UD_AutoCrit
        SetToggleOptionValue(UD_AutoCrit_T, UDCDmain.UD_AutoCrit)
        forcePageReset()
    elseif aiOption == UD_HardcoreMode_T
        UDCDmain.UD_HardcoreMode = !UDCDmain.UD_HardcoreMode
        UDCDmain.RegisterForSingleUpdate(0.01)
        SetToggleOptionValue(UD_HardcoreMode_T, UDCDmain.UD_HardcoreMode)
    elseif aiOption == UD_AllowArmTie_T
        UDCDmain.UD_AllowArmTie = !UDCDmain.UD_AllowArmTie
        SetToggleOptionValue(UD_AllowArmTie_T, UDCDmain.UD_AllowArmTie)
    elseif aiOption == UD_AllowLegTie_T
        UDCDmain.UD_AllowLegTie = !UDCDmain.UD_AllowLegTie
        SetToggleOptionValue(UD_AllowLegTie_T, UDCDmain.UD_AllowLegTie)
    elseif aiOption == UD_PreventMasterLock_T
        UDCDmain.UD_PreventMasterLock = !UDCDmain.UD_PreventMasterLock
        SetToggleOptionValue(UD_PreventMasterLock_T, UDCDmain.UD_PreventMasterLock)  
    elseif aiOption == UD_MandatoryCrit_T
        UDCDmain.UD_MandatoryCrit = !UDCDmain.UD_MandatoryCrit
        SetToggleOptionValue(UD_MandatoryCrit_T, UDCDmain.UD_MandatoryCrit)
    elseif aiOption == UD_HardcoreAccess_T
        UDCDmain.UD_HardcoreAccess = !UDCDmain.UD_HardcoreAccess
        SetToggleOptionValue(UD_HardcoreAccess_T, UDCDmain.UD_HardcoreAccess)
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    if (aiOption == UD_UpdateTime_S)
        SetSliderDialogStartValue(UDCONF.UD_UpdateTime)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(1.0, 15.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_CooldownMultiplier_S
        SetSliderDialogStartValue(Round(UDCDmain.UD_CooldownMultiplier*100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(25.0, 500.0)
        SetSliderDialogInterval(5.0)
    elseif (aiOption == UD_LockpickMinigameNum_S)
        SetSliderDialogStartValue(UDCDmain.UD_LockpicksPerMinigame)
        SetSliderDialogDefaultValue(2.0)
        SetSliderDialogRange(1.0, 50.0)
        SetSliderDialogInterval(1.0)
    elseif (aiOption == UD_AutoCritChance_S)
        SetSliderDialogStartValue(UDCDmain.UD_AutoCritChance)
        SetSliderDialogDefaultValue(80.0)
        SetSliderDialogRange(1.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_GagPhonemModifier_S
        SetSliderDialogStartValue(UDCDmain.UD_GagPhonemModifier)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_MinigameHelpCd_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameHelpCd)
        SetSliderDialogDefaultValue(60.0)
        SetSliderDialogRange(5.0, 60.0*24.0)
        SetSliderDialogInterval(5.0)
    elseif aiOption == UD_MinigameHelpCD_PerLVL_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameHelpCD_PerLVL)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(1.0, 100.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_MinigameHelpXPBase_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameHelpXPBase)
        SetSliderDialogDefaultValue(35.0)
        SetSliderDialogRange(5.0, 200.0)
        SetSliderDialogInterval(5.0)
    elseif aiOption == UD_DeviceLvlHealth_S
        SetSliderDialogStartValue(UDCDmain.UD_DeviceLvlHealth*100)
        SetSliderDialogDefaultValue(2.5)
        SetSliderDialogRange(0.0, 25.0)
        SetSliderDialogInterval(0.5)
    elseif aiOption == UD_DeviceLvlLockpick_S
        SetSliderDialogStartValue(UDCDmain.UD_DeviceLvlLockpick)
        SetSliderDialogDefaultValue(0.5)
        SetSliderDialogRange(0.0, 1.0)
        SetSliderDialogInterval(0.1)
    elseif aiOption == UD_DeviceLvlLocks_S
        SetSliderDialogStartValue(UDCDmain.UD_DeviceLvlLocks)
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(0.0, 20.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_CritDurationAdjust_S
        SetSliderDialogStartValue(UDCDmain.UD_CritDurationAdjust)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(-0.5, 0.5)
        SetSliderDialogInterval(0.05)
    elseif aiOption == UD_KeyDurability_S
        SetSliderDialogStartValue(UDCDmain.UD_KeyDurability)
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(0, 20)
        SetSliderDialogInterval(1)
    ElseIf aiOption == UD_MinigameDrainMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UD_MinigameDrainMult * 100))
        SetSliderDialogDefaultValue(100)
        SetSliderDialogRange(10, 500)
        SetSliderDialogInterval(5)
    ElseIf aiOption == UD_InitialDrainDelay_S
        SetSliderDialogStartValue(UDCDmain.UD_InitialDrainDelay)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogRange(0, 10.0)
        SetSliderDialogInterval(1)
    ElseIf aiOption == UD_MinigameExhDurationMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UD_MinigameExhDurationMult * 100))
        SetSliderDialogDefaultValue(100)
        SetSliderDialogRange(0, 5000)
        SetSliderDialogInterval(100)
    ElseIf aiOption == UD_MinigameExhMagnitudeMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UD_MinigameExhMagnitudeMult * 100))
        SetSliderDialogDefaultValue(100)
        SetSliderDialogRange(0, 200)
        SetSliderDialogInterval(5)
    elseif aiOption == UD_LockpickMinigameDuration_S
        SetSliderDialogStartValue(UDCDmain.UD_LockpickMinigameDuration)
        SetSliderDialogDefaultValue(20)
        SetSliderDialogRange(0, 120)
        SetSliderDialogInterval(5)
    elseif aiOption == UD_MinigameExhNoStruggleMax_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameExhNoStruggleMax)
        SetSliderDialogDefaultValue(2)
        SetSliderDialogRange(0, 10)
        SetSliderDialogInterval(1)
    elseif aiOption == UD_MinigameExhExponential_S
        SetSliderDialogStartValue(UDCDmain.UD_MinigameExhExponential)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.1, 10)
        SetSliderDialogInterval(0.1)
    endif
EndFunction

Function PageOptionSliderAccept(Int aiOption, Float afValue)
    if (aiOption == UD_UpdateTime_S)
        UDCONF.UD_UpdateTime = afValue
        SetSliderOptionValue(UD_UpdateTime_S, UDCONF.UD_UpdateTime, "{0} s")
    elseif aiOption == UD_CooldownMultiplier_S
        UDCDmain.UD_CooldownMultiplier = afValue/100
        SetSliderOptionValue(UD_CooldownMultiplier_S, Round(UDCDmain.UD_CooldownMultiplier*100), "{0} %")
    elseif (aiOption == UD_LockpickMinigameNum_S)
        UDCDmain.UD_LockpicksPerMinigame = Round(afValue)
        SetSliderOptionValue(UD_LockpickMinigameNum_S, UDCDmain.UD_LockpicksPerMinigame, "{0}")
    elseif (aiOption == UD_AutoCritChance_S)
        UDCDmain.UD_AutoCritChance = round(afValue)
        SetSliderOptionValue(UD_AutoCritChance_S, UDCDmain.UD_AutoCritChance, "{0} %")
    elseif aiOption == UD_GagPhonemModifier_S
        UDCDmain.UD_GagPhonemModifier = round(afValue)
        SetSliderOptionValue(UD_GagPhonemModifier_S, UDCDmain.UD_GagPhonemModifier, "{0}")
    elseif aiOption == UD_MinigameHelpCd_S
        UDCDmain.UD_MinigameHelpCd = round(afValue)
        SetSliderOptionValue(UD_MinigameHelpCd_S, UDCDmain.UD_MinigameHelpCd, "{0} min")
    elseif aiOption == UD_MinigameHelpCD_PerLVL_S
        UDCDmain.UD_MinigameHelpCD_PerLVL = Round(afValue)
        SetSliderOptionValue(UD_MinigameHelpCD_PerLVL_S, UDCDmain.UD_MinigameHelpCD_PerLVL, "{0} %")
    elseif aiOption == UD_MinigameHelpXPBase_S
        UDCDmain.UD_MinigameHelpXPBase = round(afValue)
        SetSliderOptionValue(UD_MinigameHelpXPBase_S, UDCDmain.UD_MinigameHelpXPBase, "{0} XP")
    elseif aiOption == UD_DeviceLvlHealth_S
        UDCDmain.UD_DeviceLvlHealth = afValue/100
        SetSliderOptionValue(UD_DeviceLvlHealth_S, UDCDmain.UD_DeviceLvlHealth*100, "{1} %")
    elseif aiOption == UD_DeviceLvlLockpick_S
        UDCDmain.UD_DeviceLvlLockpick = afValue
        SetSliderOptionValue(UD_DeviceLvlLockpick_S, UDCDmain.UD_DeviceLvlLockpick, "{1}")
    elseif aiOption == UD_DeviceLvlLocks_S
        UDCDmain.UD_DeviceLvlLocks = Round(afValue)
        SetSliderOptionValue(UD_DeviceLvlLocks_S, UDCDmain.UD_DeviceLvlLocks, "{0} LVLs")
    elseif aiOption == UD_CritDurationAdjust_S
        UDCDmain.UD_CritDurationAdjust = afValue
        SetSliderOptionValue(UD_CritDurationAdjust_S, UDCDmain.UD_CritDurationAdjust, "{2} s")
    elseif aiOption == UD_KeyDurability_S
        UDCDmain.UD_KeyDurability = Round(afValue)
        SetSliderOptionValue(UD_KeyDurability_S, UDCDmain.UD_KeyDurability, "{0}")
    ElseIf aiOption == UD_MinigameDrainMult_S
        UDCDmain.UD_MinigameDrainMult = afValue / 100
        SetSliderOptionValue(UD_MinigameDrainMult_S, UDCDmain.UD_MinigameDrainMult * 100, "{1} %")
    ElseIf aiOption == UD_InitialDrainDelay_S
        UDCDmain.UD_InitialDrainDelay = Round(afValue)
        SetSliderOptionValue(UD_InitialDrainDelay_S, UDCDmain.UD_InitialDrainDelay, "{0} s")
    ElseIf aiOption == UD_MinigameExhDurationMult_S
        UDCDmain.UD_MinigameExhDurationMult = afValue / 100.0
        SetSliderOptionValue(UD_MinigameExhDurationMult_S, UDCDmain.UD_MinigameExhDurationMult * 100.0, "{0} %")
    ElseIf aiOption == UD_MinigameExhMagnitudeMult_S
        UDCDmain.UD_MinigameExhMagnitudeMult = afValue / 100.0
        SetSliderOptionValue(UD_MinigameExhMagnitudeMult_S, UDCDmain.UD_MinigameExhMagnitudeMult * 100.0, "{0} %")
    elseif aiOption == UD_LockpickMinigameDuration_S
        UDCDmain.UD_LockpickMinigameDuration = Round(afValue)
        SetSliderOptionValue(UD_LockpickMinigameDuration_S, UDCDmain.UD_LockpickMinigameDuration, "{0} s")
    elseif aiOption == UD_MinigameExhNoStruggleMax_S
        UDCDMain.UD_MinigameExhNoStruggleMax = Round(afValue)
        SetSliderOptionValue(UD_MinigameExhNoStruggleMax_S, UDCDMain.UD_MinigameExhNoStruggleMax, "{0}")
    elseif aiOption == UD_MinigameExhExponential_S
        UDCDMain.UD_MinigameExhExponential = afValue
        SetSliderOptionValue(UD_MinigameExhExponential_S, UDCDMain.UD_MinigameExhExponential, "{1}")
    endif
EndFunction

Function PageOptionKeyMapChange(Int aiOption, Int aiKeyCode, String asConflictControl, String asConflictName)
    if (aiOption == UD_ActionKey_K)
        if MCM.checkGeneralKeyConflict(aiKeyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.ActionKey_Keycode)
            UDCDmain.ActionKey_Keycode = aiKeyCode
            UDmain.UDUI.RegisterForKey(UDCDmain.ActionKey_Keycode)
            SetKeyMapOptionValue(UD_ActionKey_K, UDCDmain.ActionKey_Keycode)
        endif
    elseif (aiOption == UD_CHB_Stamina_meter_Keycode_K)
        if MCM.checkMinigameKeyConflict(aiKeyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.Stamina_meter_Keycode)
            UDCDmain.Stamina_meter_Keycode = aiKeyCode
            UDmain.UDUI.RegisterForKey(UDCDmain.Stamina_meter_Keycode)
            SetKeyMapOptionValue(UD_CHB_Stamina_meter_Keycode_K, UDCDmain.Stamina_meter_Keycode)
        endif
    elseif (aiOption == UD_CHB_Magicka_meter_Keycode_K)
        if MCM.checkMinigameKeyConflict(aiKeyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.Magicka_meter_Keycode)
            UDCDmain.Magicka_meter_Keycode = aiKeyCode
            UDmain.UDUI.RegisterForKey(UDCDmain.Magicka_meter_Keycode)
            SetKeyMapOptionValue(UD_CHB_Magicka_meter_Keycode_K, UDCDmain.Magicka_meter_Keycode)
        endif
    elseif (aiOption == UDCD_SpecialKey_Keycode_K)
        if MCM.checkMinigameKeyConflict(aiKeyCode)
            UDmain.UDUI.UnRegisterForKey(UDCDmain.SpecialKey_Keycode)
            UDCDmain.SpecialKey_Keycode = aiKeyCode
            UDmain.UDUI.RegisterForKey(UDCDmain.SpecialKey_Keycode)
            SetKeyMapOptionValue(UDCD_SpecialKey_Keycode_K, UDCDmain.SpecialKey_Keycode)
        endif
    endIf
EndFunction

Function PageOptionMenuOpen(int aiOption)
    if (aiOption == UD_hardcore_swimming_difficulty_M)
        SetMenuDialogOptions(difficultyList)
        SetMenuDialogStartIndex(UDSS.UD_hardcore_swimming_difficulty)
        SetMenuDialogDefaultIndex(1)
    elseif (aiOption == UD_StruggleDifficulty_M)
        SetMenuDialogOptions(difficultyList)
        SetMenuDialogStartIndex(UDCDmain.UD_StruggleDifficulty)
        SetMenuDialogDefaultIndex(1)
    elseif aiOption == UD_CritEffect_M
        SetMenuDialogOptions(criteffectList)
        SetMenuDialogStartIndex(UDCDmain.UD_CritEffect)
        SetMenuDialogDefaultIndex(2)
    endif
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
    if (aiOption == UD_hardcore_swimming_difficulty_M)
        UDSS.UD_hardcore_swimming_difficulty = aiIndex
        SetMenuOptionValue(UD_hardcore_swimming_difficulty_M, difficultyList[UDSS.UD_hardcore_swimming_difficulty])
    elseif (aiOption == UD_StruggleDifficulty_M)
        UDCDmain.UD_StruggleDifficulty = aiIndex
        SetMenuOptionValue(UD_StruggleDifficulty_M, difficultyList[UDCDmain.UD_StruggleDifficulty])
        forcePageReset()
    elseif aiOption == UD_CritEffect_M
        UDCDmain.UD_CritEffect = aiIndex
        SetMenuOptionValue(UD_CritEffect_M, criteffectList[UDCDmain.UD_CritEffect])
        forcePageReset()
    endif
EndFunction

Function PageDefault(int aiOption)
    if aiOption == UD_KeyDurability_S
        UDCDmain.UD_KeyDurability = 5
        SetSliderOptionValue(UD_KeyDurability_S, UDCDmain.UD_KeyDurability, "{0}")
    elseif aiOption == UD_HardcoreAccess_T
        UDCDmain.UD_HardcoreAccess = False
        SetToggleOptionValue(UD_HardcoreAccess_T, UDCDmain.UD_HardcoreAccess)
    ElseIf aiOption == UD_MinigameDrainMult_S
        UDCDmain.UD_MinigameDrainMult = 1
        SetSliderOptionValue(UD_MinigameDrainMult_S, UDCDmain.UD_MinigameDrainMult * 100, "{1} %")
    ElseIf aiOption == UD_InitialDrainDelay_S
        UDCDmain.UD_InitialDrainDelay = 0
        SetSliderOptionValue(UD_InitialDrainDelay_S, UDCDmain.UD_InitialDrainDelay, "{0} s")
    ElseIf aiOption == UD_MinigameExhDurationMult_S
        UDCDmain.UD_MinigameExhDurationMult = 1.0
        SetSliderOptionValue(UD_MinigameExhDurationMult_S, UDCDmain.UD_MinigameExhDurationMult * 100, "{0} %")
    ElseIf aiOption == UD_MinigameExhMagnitudeMult_S
        UDCDmain.UD_MinigameExhMagnitudeMult = 1.0
        SetSliderOptionValue(UD_MinigameExhMagnitudeMult_S, UDCDmain.UD_MinigameExhMagnitudeMult * 100, "{0} %")
    ElseIf aiOption == UD_LockpickMinigameDuration_S
        UDCDmain.UD_LockpickMinigameDuration = 20
        SetSliderOptionValue(UD_LockpickMinigameDuration_S, UDCDmain.UD_LockpickMinigameDuration, "{0} s")
    elseif(aiOption == UD_ActionKey_K)
        if !Game.UsingGamepad()
            UDCDMain.ActionKey_Keycode = 18
        else
            UDCDMain.ActionKey_Keycode = 279
        endif
       SetKeyMapOptionValue(UD_ActionKey_K, UDCDMain.ActionKey_Keycode)
    endif
EndFunction

Function PageInfo(int aiOption)
    if(aiOption == UD_CHB_Stamina_meter_Keycode_K)
        SetInfoText("$UD_STAMINAMETER_INFO")
    elseif(aiOption == UD_ActionKey_K)
        SetInfoText("$UD_ACTIONKEY_INFO")
    elseif(aiOption == UD_CHB_Magicka_meter_Keycode_K)
        SetInfoText("$UD_MAGICKAMETER_INFO")
    elseif(aiOption == UD_StruggleDifficulty_M)
        SetInfoText("$UD_ESCAPEDIFFICULTY_INFO")
    elseif(aiOption == UD_UpdateTime_S)
        SetInfoText("$UD_UPDATETIME_INFO")
    elseif(aiOption == UD_UseDDdifficulty_T)
        SetInfoText("$UD_USEDDDIFFICULTY_INFO")
    elseif(aiOption == UD_hardcore_swimming_T)
        SetInfoText("$UD_HARDCORESWIMMING_INFO")
    elseif(aiOption == UD_hardcore_swimming_difficulty_M)
        SetInfoText("$UD_HARDCORESWIMMINGDIFFICULTY_INFO")
    elseif aiOption == UD_LockpickMinigameNum_S
        SetInfoText("$UD_LOCKPICKMINIGAMENUM_INFO")
    elseif aiOption == UD_AutoCrit_T
        SetInfoText("$UD_AUTOCRIT_INFO")
    elseif aiOption == UD_AutoCritChance_S
        SetInfoText("$UD_AUTOCRITCHANCE_INFO")
    elseif aiOption == UD_CritEffect_M
        SetInfoText("$UD_CRITEFFECT_INFO")
    elseif aiOption == UD_CooldownMultiplier_S
        SetInfoText("$UD_COOLDOWNMULTIPLIER_INFO")
    elseif aiOption == UD_HardcoreMode_T
        SetInfoText("$UD_HARDCOREMODE_INFO")
    elseif aiOption == UD_AllowArmTie_T
        SetInfoText("$UD_ALLOWARMTIE_INFO")
    elseif aiOption == UD_AllowLegTie_T
        SetInfoText("$UD_ALLOWLEGTIE_INFO")
    elseif aiOption == UD_MinigameHelpCd_S
        SetInfoText("$UD_MINIGAMEHELPCD_INFO")
    elseif aiOption == UD_MinigameHelpCD_PerLVL_S
        SetInfoText("$UD_MINIGAMEHELPAMPL_INFO")
    elseif aiOption == UD_MinigameHelpXPBase_S
        SetInfoText("$UD_MINIGAMEHELPXPBASE_INFO")
    elseif aiOption == UDCD_SpecialKey_Keycode_K
        SetInfoText("$UD_SPECIALKEYKEY_INFO")
    elseif aiOption == UD_DeviceLvlHealth_S
        SetInfoText("$UD_DEVICELVLHEALTH_INFO")
    elseif aiOption == UD_DeviceLvlLockpick_S
        SetInfoText("$UD_DEVICELVLLOCKPICK_INFO")
    elseif aiOption == UD_PreventMasterLock_T
        SetInfoText("$UD_PREVENTMASTERLOCK_INFO")
    elseif aiOption == UD_DeviceLvlLocks_S
        SetInfoText("$UD_DEVICELVLLOCKS_INFO")
    elseif aiOption == UD_MandatoryCrit_T
        SetInfoText("$UD_WMANDATORYCRIT_INFO")
    elseif aiOption == UD_CritDurationAdjust_S
        SetInfoText("$UD_CRITDURATIONADJUST_INFO")
    elseif aiOption == UD_KeyDurability_S
        SetInfoText("$UD_KEYDURABILITY_INFO")
    elseif aiOption == UD_HardcoreAccess_T
        SetInfoText("$UD_HARDCOREACCESS_INFO")
    ElseIf aiOption == UD_MinigameDrainMult_S
        SetInfoText("$UD_MINIGAMEDRAINMULT_INFO")
    ElseIf aiOption == UD_InitialDrainDelay_S
        SetInfoText("$UD_INITIALDRAINDELAY_INFO")
    ElseIf aiOption == UD_MinigameExhDurationMult_S
        SetInfoText("$UD_MINIEXHAUSDUR_INFO")
    ElseIf aiOption == UD_MinigameExhMagnitudeMult_S
        SetInfoText("$UD_MINIEXHAUSMAG_INFO")
    elseif aiOption == UD_LockpickMinigameDuration_S
        SetInfoText("$UD_LOCKPICKMINIGAMEDURATION_INFO")
    elseif aiOption == UD_MinigameExhExponential_S
        SetInfoText("$UD_MINIEXHEXP_INFO")
    elseif aiOption == UD_MinigameExhNoStruggleMax_S
        SetInfoText("$UD_MINIEXHNOSTRUGGMAX_INFO")
    Endif
EndFunction