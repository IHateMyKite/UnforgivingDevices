Scriptname UD_MCM_Page_Mods extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_MenuMsgManager  Property UDMMM hidden
    UD_MenuMsgManager Function Get()
        return UDmain.UDMMM
    EndFunction
EndProperty
UD_MenuTextFormatter  Property UDMTF hidden
    UD_MenuTextFormatter Function Get()
        return UDmain.UDMTF
    EndFunction
EndProperty

Function PageUpdate()
    UD_ModifierSelected = 0
    UD_ModifierPatchSelected = 0
EndFunction

Int UD_ModifierStorageSelected = 0
Int UD_ModifierSelected = 0
Int UD_ModifierList_M
Int UD_ModStorageList_M

String[] UD_ModStorageList
String[] UD_ModifierList

Int UD_ModifierPatchSelected = 0
Int UD_ModifierPatchList_M

Int UD_ModReset_T

Int UD_ModsMin_S
Int UD_ModsMax_S
Int UD_ModGlobalProbabilityMult_S
Int UD_ModGlobalSeverityShift_S
Int UD_ModGlobalSeverityDispMult_S
Int UD_Modifier_AddToTest_T

int UD_ModifierMultiplier1_S
int UD_ModifierMultiplier2_S
int UD_ModifierMultiplier3_S
int UD_ModifierPatchPowerMultiplier_S
int UD_ModifierPatchChanceMultiplier_S
int UD_ModifierDescription_T
Int UD_ModifierDetailTags_T

Int UD_ModPP_ApplicableToNPC_T
Int UD_ModPP_ApplicableToPlayer_T
Int UD_ModPP_BaseProbability_S
Int UD_ModPP_IsAbsoluteProbability_T
Int UD_ModPP_BaseSeverity_S
Int UD_ModPP_SeverityDispersion_S

Int UD_ModifierNoModsDesc_T
Int UD_ModifierNoPPDesc_T

Int UD_ModifierVarEasyDesc_T
Int UD_ModifierVarEasy_T
Int UD_ModifierVarNormDesc_T
Int UD_ModifierVarNorm_T
Int UD_ModifierVarHardDesc_T
Int UD_ModifierVarHard_T

Int UD_ModifierDeviceTagsDesc_T
Int UD_ModifierDeviceTags_T
Int UD_ModifierGlobalTagsDesc_T
Int UD_ModifierGlobalTags_T

Int UD_ModifierPreferredDevicesDesc_T
Int UD_ModifierPreferredDevices_T
Int UD_ModifierForbiddenDevicesDesc_T
Int UD_ModifierForbiddenDevices_T
Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)

    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_PATCHER_GLOBALSETTINGS")     ;  Global Patcher Settings
    AddHeaderOption("")
    
    SetCursorPosition(2)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_PATCHER_MODSNUMTOADD")       ; Number of Modifiers to Add
    UD_ModsMin_S = AddSliderOption("$UD_PATCHER_MODSMIN", UDCDmain.UDPatcher.UD_ModsMin, "{0}", UD_LockMenu_flag)                   ; No less than
    UD_ModsMax_S = AddSliderOption("$UD_PATCHER_MODSMAX", UDCDmain.UDPatcher.UD_ModsMax, "{0}", UD_LockMenu_flag)                   ; No more than
    
    SetCursorPosition(3)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_PATCHER_GLOBALMODSSETTINGS")        ; Global Modifiers Settings
    UD_ModGlobalProbabilityMult_S = AddSliderOption("$UD_PATCHER_MODSPROBMULT", UDCDmain.UDPatcher.UD_ModGlobalProbabilityMult, "{2}", UD_LockMenu_flag)        ; Probability multiplier
    UD_ModGlobalSeverityShift_S = AddSliderOption("$UD_PATCHER_MODSSEVSHIFT", UDCDmain.UDPatcher.UD_ModGlobalSeverityShift, "{2}", UD_LockMenu_flag)            ; Severity shift
    UD_ModGlobalSeverityDispMult_S = AddSliderOption("$UD_PATCHER_MODSSEVDISP", UDCDmain.UDPatcher.UD_ModGlobalSeverityDispMult, "{2}", UD_LockMenu_flag)      ; Severity dispersion multiplier
    
    SetCursorPosition(12)
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("$UD_CUSTOMMODS")         ; Custom Modifiers
    AddHeaderOption("")

    If UDmain.UDMOM.UD_ModifierListRef.Length == 0
        UD_ModifierNoModsDesc_T = AddTextOption("$UD_CUSTOMMOD_ERROR_NOMODS", "$-INFO-", FlagSwitch(True))      ; No modifiers found!
        Return
    Else
        UD_ModifierNoModsDesc_T = -1
    EndIf

    If UD_ModifierStorageSelected < 0 || UD_ModifierStorageSelected >= UDmain.UDMOM.GetModifierStorageCount()
        UDmain.Warning(Self + "::resetModifiersPage() Selected storage index was outside the array")
        UD_ModifierStorageSelected = 0
    EndIf

    UD_ModifierStorage loc_storage = UDmain.UDMOM.GetNthModifierStorage(UD_ModifierStorageSelected)

    If loc_storage == None
    ; ???
        UDmain.Error(Self + "::resetModifiersPage() Selected storage was None (index = " + UD_ModifierStorageSelected + ").")
        UD_ModifierStorageSelected = 0
        Return
    EndIf
    
    If loc_storage.GetModifierNum() <= UD_ModifierSelected || UD_ModifierSelected < 0
        UDmain.Warning(Self + "::resetModifiersPage() Selected modifier index was outside the array")
        UD_ModifierSelected = 0
    EndIf
    UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
    
    If loc_mod == None
    ; ???
        UDmain.Error(Self + "::resetModifiersPage() Selected modifier was None (index = " + UD_ModifierSelected + ").")
        UD_ModifierSelected = 0
        Return
    EndIf
    
    UD_ModStorageList_M = AddMenuOption("$UD_MODSTORAGE_SELECTED", loc_storage.GetName(), FlagSwitch(true))       ; Selected storage
    UD_ModifierList_M = AddMenuOption("$UD_CUSTOMMOD_SELECTED", loc_mod.NameFull, FlagSwitch(true))               ; Selected modifier
    UD_ModReset_T = AddTextOption("==RESET==", "$-PRESS-")
    AddEmptyOption()
    
    String[] loc_presets_names = loc_mod.GetPatcherPresetsNames()
        
    SetCursorPosition(18)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_CUSTOMMOD_BASEDETAILS")             ; Base Details

    AddTextOption("$UD_CUSTOMMOD_DETAILNAME", loc_mod.NameFull, FlagSwitch(true))                                                           ; Name
    AddTextOption("$UD_CUSTOMMOD_DETAILALIAS", loc_mod.NameAlias, FlagSwitch(true))                                                         ; Alias
    UD_ModifierDescription_T = AddTextOption("$UD_CUSTOMMOD_DETAILDESC", "$-INFO-", FlagSwitch(true))                                       ; Description
    UD_ModifierDetailTags_T = AddTextOption("$UD_CUSTOMMOD_DETAILTAGS", "[" + MCM.StringArrayToString(loc_mod.Tags) + "]", FlagSwitch(true))    ; Tags
    
    SetCursorPosition(19)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_CUSTOMMOD_RUNTIMECONFIG")                ; Runtime Configuration
   
    UD_ModifierMultiplier1_S = AddSliderOption("$UD_CUSTOMMOD_MULTPROB", loc_mod.MultProbabilities, "{1} x", UD_LockMenu_flag)          ; Probabilities multiplier
    UD_ModifierMultiplier2_S = AddSliderOption("$UD_CUSTOMMOD_MULTIN", loc_mod.MultInputQuantities, "{1} x", UD_LockMenu_flag)          ; Input multiplier
    UD_ModifierMultiplier3_S = AddSliderOption("$UD_CUSTOMMOD_MULTOUT", loc_mod.MultOutputQuantities, "{1} x", UD_LockMenu_flag)        ; Output multiplier
    UD_Modifier_AddToTest_T = addToggleOption("$UD_CUSTOMMOD_ADDTOTEST", loc_mod.NameAlias == UDCDmain.UDPatcher.UD_ModAddToTest, FlagSwitchOr(FlagSwitch(loc_presets_names.Length > 0), UD_LockMenu_flag))         ; add to test in the next Patcher call

    SetCursorPosition(28)
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("$UD_CUSTOMMOD_PPSCONFIG")            ; Patcher Presets Configuration
    AddHeaderOption("")

    If loc_presets_names.Length == 0
        UD_ModifierNoPPDesc_T = AddTextOption("$UD_CUSTOMMOD_ERROR_NOPPS", "$-INFO-", FlagSwitch(true))                     ; No patcher presets found!
        Return
    Else 
        UD_ModifierNoPPDesc_T = -1
    EndIf
    If UD_ModifierPatchSelected < 0 || UD_ModifierPatchSelected > loc_presets_names.Length
        UD_ModifierPatchSelected = 0
    EndIf
    UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
    UD_ModifierPatchList_M = AddMenuOption("$UD_CUSTOMMOD_PPSSELECTED", loc_mod_pp.DisplayName, FlagSwitch(true))           ; Selected patch preset:
    AddEmptyOption()
    
    UD_ModifierVarEasyDesc_T = AddTextOption("$UD_CUSTOMMOD_VAREASY", "$-PREVIEW-", FlagSwitch(true))
    UD_ModifierVarEasy_T = AddTextOption("", loc_mod_pp.DataStr_Easy, FlagSwitch(true))
    UD_ModifierVarNormDesc_T = AddTextOption("$UD_CUSTOMMOD_VARNORM", "$-PREVIEW-", FlagSwitch(true))
    UD_ModifierVarNorm_T = AddTextOption("", loc_mod_pp.DataStr_Ground, FlagSwitch(true))
    UD_ModifierVarHardDesc_T = AddTextOption("$UD_CUSTOMMOD_VARHARD", "$-PREVIEW-", FlagSwitch(true))
    UD_ModifierVarHard_T = AddTextOption("", loc_mod_pp.DataStr_Hard, FlagSwitch(true))

    UD_ModifierDeviceTagsDesc_T = AddTextOption("$UD_CUSTOMMOD_DEVTAGS", "$-INFO-", FlagSwitch(true))
    UD_ModifierDeviceTags_T = AddTextOption("", "[" + MCM.StringArrayToString(loc_mod_pp.ConflictedDeviceModTags) + "]", FlagSwitch(true))
    UD_ModifierGlobalTagsDesc_T = AddTextOption("$UD_CUSTOMMOD_GLOBTAGS", "$-INFO-", FlagSwitch(true))
    UD_ModifierGlobalTags_T = AddTextOption("", "[" + MCM.StringArrayToString(loc_mod_pp.ConflictedGlobalModTags) + "]", FlagSwitch(true))

    UD_ModifierPreferredDevicesDesc_T = AddTextOption("$UD_CUSTOMMOD_PREFERREDDEVICES", "$-INFO-", FlagSwitch(true))
    UD_ModifierPreferredDevices_T = AddTextOption("", "[" + MCM.KeywordArrayToString(loc_mod_pp.PreferredDevices) + "]", FlagSwitch(true))
    UD_ModifierForbiddenDevicesDesc_T = AddTextOption("$UD_CUSTOMMOD_FORBIDDENDEVICES", "$-INFO-", FlagSwitch(true))
    UD_ModifierForbiddenDevices_T = AddTextOption("", "[" + MCM.KeywordArrayToString(loc_mod_pp.ForbiddenDevices) + "]", FlagSwitch(true))
    
    UD_ModPP_ApplicableToPlayer_T = addToggleOption("$UD_CUSTOMMOD_APPTOPLAYER", loc_mod_pp.ApplicableToPlayer, UD_LockMenu_flag)                       ; Applicable to Player
    AddEmptyOption()
    UD_ModPP_ApplicableToNPC_T = addToggleOption("$UD_CUSTOMMOD_APPTONPC", loc_mod_pp.ApplicableToNPC, UD_LockMenu_flag)                                ; Applicable to NPCs
    AddEmptyOption()
    
    UD_ModPP_BaseProbability_S = AddSliderOption("$UD_CUSTOMMOD_BASEPROB", loc_mod_pp.BaseProbability, "{0} %", UD_LockMenu_flag)                       ; Base probability
    UD_ModPP_BaseSeverity_S = AddSliderOption("$UD_CUSTOMMOD_BASESEVERITY", loc_mod_pp.BaseSeverity, "{2}", UD_LockMenu_flag)                           ; Base severity
    UD_ModPP_IsAbsoluteProbability_T = addToggleOption("$UD_CUSTOMMOD_PROBABS", loc_mod_pp.IsAbsoluteProbability, UD_LockMenu_flag)                     ; Probability is absolute
    UD_ModPP_SeverityDispersion_S = AddSliderOption("$UD_CUSTOMMOD_SEVERITYDISP", loc_mod_pp.SeverityDispersion, "{2}", UD_LockMenu_flag)               ; Severity dispersion

EndFunction

Function PageOptionSelect(Int aiOption)
    if(aiOption == UD_ModifierDescription_T)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        ShowMessage(loc_mod.Description, false, "$Close")
    ElseIf(aiOption == UD_ModifierNoModsDesc_T)
        ShowMessage("$UD_CUSTOMMOD_ERROR_NOMODS_INFO", False, "$Close")
    ElseIf(aiOption == UD_ModifierNoPPDesc_T)
        ShowMessage("$UD_CUSTOMMOD_ERROR_NOPPS_INFO", false, "$Close")
    ElseIf(aiOption == UD_ModifierVarEasyDesc_T)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        ; set of argument is not complete, could break the function
        String loc_msg = loc_mod.GetDetails(None, loc_mod_pp.DataStr_Easy, None, None, None, None, None)
        UDMMM.ShowMessageBox(loc_msg, UDMTF.HasHtmlMarkup())
    ElseIf(aiOption == UD_ModifierVarNormDesc_T)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        ; set of argument is not complete, could break the function
        String loc_msg = loc_mod.GetDetails(None, loc_mod_pp.DataStr_Ground, None, None, None, None, None)
        UDMMM.ShowMessageBox(loc_msg, UDMTF.HasHtmlMarkup())
    ElseIf(aiOption == UD_ModifierVarHardDesc_T)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        ; set of argument is not complete, could break the function
        String loc_msg = loc_mod.GetDetails(None, loc_mod_pp.DataStr_Hard, None, None, None, None, None)
        UDMMM.ShowMessageBox(loc_msg, UDMTF.HasHtmlMarkup())
    elseif aiOption == UD_ModPP_ApplicableToPlayer_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        loc_mod_pp.ApplicableToPlayer = !loc_mod_pp.ApplicableToPlayer
        SetToggleOptionValue(UD_ModPP_ApplicableToPlayer_T, loc_mod_pp.ApplicableToPlayer)
    elseif aiOption == UD_ModPP_ApplicableToNPC_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        loc_mod_pp.ApplicableToNPC = !loc_mod_pp.ApplicableToNPC
        SetToggleOptionValue(UD_ModPP_ApplicableToNPC_T, loc_mod_pp.ApplicableToNPC)
    elseif aiOption == UD_Modifier_AddToTest_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        If UDCDMain.UDPatcher.UD_ModAddToTest != loc_mod.NameAlias
            UDCDMain.UDPatcher.UD_ModAddToTest = loc_mod.NameAlias
        Else
            UDCDMain.UDPatcher.UD_ModAddToTest = ""
        EndIf
        SetToggleOptionValue(UD_Modifier_AddToTest_T, UDCDMain.UDPatcher.UD_ModAddToTest == loc_mod.NameAlias)
    elseif aiOption == UD_ModPP_IsAbsoluteProbability_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        loc_mod_pp.IsAbsoluteProbability = !loc_mod_pp.IsAbsoluteProbability
        SetToggleOptionValue(UD_ModPP_IsAbsoluteProbability_T, loc_mod_pp.IsAbsoluteProbability)
    elseif aiOption == UD_ModReset_T
        if ShowMessage("Do you really want to reset the modifier storage and set it to default values?")
            UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
            Quest loc_storage   = loc_mod.GetOwningQuest()
            loc_storage.Stop()
            Utility.WaitMenuMode(1.0)
            loc_storage.Reset()
            ;loc_outfit.Reset()
            forcePageReset()
        endif
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    if (aiOption == UD_ModifierMultiplier1_S)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        SetSliderDialogStartValue(loc_mod.MultProbabilities)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(0.1)
    ElseIf (aiOption == UD_ModifierMultiplier2_S)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        SetSliderDialogStartValue(loc_mod.MultInputQuantities)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(0.1)
    ElseIf (aiOption == UD_ModifierMultiplier3_S)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        SetSliderDialogStartValue(loc_mod.MultOutputQuantities)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(0.1)
    ElseIf aiOption == UD_ModsMin_S
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_ModsMin)
        SetSliderDialogDefaultValue(1)
        SetSliderDialogRange(0, 99)
        SetSliderDialogInterval(1)
    ElseIf aiOption == UD_ModsMax_S
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_ModsMax)
        SetSliderDialogDefaultValue(4)
        SetSliderDialogRange(0, 99)
        SetSliderDialogInterval(1)
    ElseIf aiOption == UD_ModGlobalProbabilityMult_S
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_ModGlobalProbabilityMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.1, 10.0)
        SetSliderDialogInterval(0.1)
    ElseIf aiOption == UD_ModGlobalSeverityShift_S
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_ModGlobalSeverityShift)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(-1.0, 1.0)
        SetSliderDialogInterval(0.01)
    ElseIf aiOption == UD_ModGlobalSeverityDispMult_S
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_ModGlobalSeverityDispMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.1, 10.0)
        SetSliderDialogInterval(0.1)
    ElseIf aiOption == UD_ModPP_BaseProbability_S
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetSliderDialogStartValue(loc_mod_pp.BaseProbability)
        SetSliderDialogDefaultValue(100)
        SetSliderDialogRange(0, 100)
        SetSliderDialogInterval(1)
    ElseIf aiOption == UD_ModPP_BaseSeverity_S
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetSliderDialogStartValue(loc_mod_pp.BaseSeverity)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(-1.0, 1.0)
        SetSliderDialogInterval(0.01)
    ElseIf aiOption == UD_ModPP_SeverityDispersion_S
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetSliderDialogStartValue(loc_mod_pp.SeverityDispersion)
        SetSliderDialogDefaultValue(0.20)
        SetSliderDialogRange(0.01, 1.0)
        SetSliderDialogInterval(0.01)
    endIf
EndFunction

Function PageOptionSliderAccept(Int aiOption, Float afValue)
    if (aiOption == UD_ModifierMultiplier1_S)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        loc_mod.MultProbabilities  = afValue
        SetSliderOptionValue(UD_ModifierMultiplier1_S, afValue, "{1} x")
    ElseIf (aiOption == UD_ModifierMultiplier2_S)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        loc_mod.MultInputQuantities  = afValue
        SetSliderOptionValue(UD_ModifierMultiplier2_S, afValue, "{1} x")
    ElseIf (aiOption == UD_ModifierMultiplier3_S)
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        loc_mod.MultOutputQuantities  = afValue
        SetSliderOptionValue(UD_ModifierMultiplier3_S, afValue, "{1} x")
    ElseIf aiOption == UD_ModsMin_S
        UDCDmain.UDPatcher.UD_ModsMin = Round(afValue)
        SetSliderOptionValue(UD_ModsMin_S, afValue, "{0}")
    ElseIf aiOption == UD_ModsMax_S
        UDCDmain.UDPatcher.UD_ModsMax = Round(afValue)
        SetSliderOptionValue(UD_ModsMax_S, afValue, "{0}")
    ElseIf aiOption == UD_ModGlobalProbabilityMult_S
        UDCDmain.UDPatcher.UD_ModGlobalProbabilityMult = afValue
        SetSliderOptionValue(UD_ModGlobalProbabilityMult_S, afValue, "{2}")
    ElseIf aiOption == UD_ModGlobalSeverityShift_S
        UDCDmain.UDPatcher.UD_ModGlobalSeverityShift = afValue
        SetSliderOptionValue(UD_ModGlobalSeverityShift_S, afValue, "{2}")
    ElseIf aiOption == UD_ModGlobalSeverityDispMult_S
        UDCDmain.UDPatcher.UD_ModGlobalSeverityDispMult = afValue
        SetSliderOptionValue(UD_ModGlobalSeverityDispMult_S, afValue, "{2}")
    ElseIf aiOption == UD_ModPP_BaseProbability_S
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        loc_mod_pp.BaseProbability = afValue
        SetSliderOptionValue(UD_ModPP_BaseProbability_S, afValue, "{0} %")
    ElseIf aiOption == UD_ModPP_BaseSeverity_S
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        loc_mod_pp.BaseSeverity = afValue
        SetSliderOptionValue(UD_ModPP_BaseSeverity_S, afValue, "{2}")
    ElseIf aiOption == UD_ModPP_SeverityDispersion_S
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        loc_mod_pp.SeverityDispersion = afValue
        SetSliderOptionValue(UD_ModPP_SeverityDispersion_S, afValue, "{2}")
    endIf
EndFunction

Function PageOptionMenuOpen(int aiOption)
    If aiOption == UD_ModifierList_M
        UD_ModifierStorage loc_storage = UDmain.UDMOM.GetNthModifierStorage(UD_ModifierStorageSelected)
        SetMenuDialogOptions(loc_storage.UD_ModifierList)
        SetMenuDialogStartIndex(UD_ModifierSelected)
        SetMenuDialogDefaultIndex(0)
    ElseIf aiOption == UD_ModStorageList_M
        SetMenuDialogOptions(UDmain.UDMOM.UD_ModStorageList)
        SetMenuDialogStartIndex(UD_ModifierStorageSelected)
        SetMenuDialogDefaultIndex(0)
    ElseIf aiOption == UD_ModifierPatchList_M
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        SetMenuDialogOptions(loc_mod.GetPatcherPresetsNames())
        SetMenuDialogStartIndex(UD_ModifierPatchSelected)
        SetMenuDialogDefaultIndex(0)
    EndIf
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
    If aiOption == UD_ModifierList_M
        UD_ModifierSelected = aiIndex
        UD_ModifierStorage loc_storage = UDmain.UDMOM.GetNthModifierStorage(UD_ModifierStorageSelected)
        SetMenuOptionValue(aiOption, loc_storage.UD_ModifierList[aiIndex])
        UD_ModifierPatchSelected = 0
        forcePageReset()
    ElseIf aiOption == UD_ModStorageList_M
        UD_ModifierStorageSelected = aiIndex
        SetMenuOptionValue(aiOption, UDmain.UDMOM.UD_ModStorageList[aiIndex])
        UD_ModifierPatchSelected = 0
        UD_ModifierSelected = 0
        forcePageReset()
    ElseIf aiOption == UD_ModifierPatchList_M
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_ModifierPatchSelected = aiIndex
        SetMenuOptionValue(aiOption, loc_mod.GetPatcherPreset(UD_ModifierPatchSelected).DisplayName)
        forcePageReset()
    EndIf
EndFunction

Function PageInfo(int aiOption)
    if(aiOption == UD_ModifierMultiplier1_S)
        SetInfoText("$UD_CUSTOMMOD_MULTPROB_INFO")
    ElseIf(aiOption == UD_ModifierMultiplier2_S)
        SetInfoText("$UD_CUSTOMMOD_MULTIN_INFO")
    ElseIf(aiOption == UD_ModifierMultiplier3_S)
        SetInfoText("$UD_CUSTOMMOD_MULTOUT_INFO")
    ElseIf aiOption == UD_ModsMin_S
        SetInfoText("$UD_PATCHER_MODSMIN_INFO")
    ElseIf aiOption == UD_ModsMax_S
        SetInfoText("$UD_PATCHER_MODSMAX_INFO")
    ElseIf aiOption == UD_Modifier_AddToTest_T
        SetInfoText("$UD_CUSTOMMOD_ADDTOTEST_INFO")
    ElseIf aiOption == UD_ModGlobalProbabilityMult_S
        SetInfoText("$UD_PATCHER_MODSPROBMULT_INFO")
    ElseIf aiOption == UD_ModGlobalSeverityShift_S
        SetInfoText("$UD_PATCHER_MODSSEVSHIFT_INFO")
    ElseIf aiOption == UD_ModGlobalSeverityDispMult_S
        SetInfoText("$UD_PATCHER_MODSSEVDISP_INFO")
    ElseIf aiOption == UD_ModPP_BaseProbability_S
        SetInfoText("$UD_CUSTOMMOD_BASEPROB_INFO")
    ElseIf aiOption == UD_ModPP_BaseSeverity_S
        SetInfoText("$UD_CUSTOMMOD_BASESEVERITY_INFO")
    ElseIf aiOption == UD_ModPP_SeverityDispersion_S
        SetInfoText("$UD_CUSTOMMOD_SEVERITYDISP_INFO")
    ElseIf aiOption == UD_ModPP_IsAbsoluteProbability_T
        SetInfoText("$UD_CUSTOMMOD_PROBABS_INFO")
    ElseIf aiOption == UD_ModifierNoModsDesc_T
        SetInfoText("$UD_CUSTOMMOD_ERROR_NOMODS_INFO")
    ElseIf aiOption == UD_ModifierNoPPDesc_T
        SetInfoText("$UD_CUSTOMMOD_ERROR_NOPPS_INFO")
    ElseIf aiOption == UD_ModifierDetailTags_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        SetInfoText("[" + MCM.StringArrayToString(loc_mod.Tags) + "]")
    ElseIf aiOption == UD_ModifierVarEasyDesc_T
        SetInfoText("$UD_CUSTOMMOD_VAREASY_INFO")
    ElseIf aiOption == UD_ModifierVarEasy_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetInfoText(loc_mod_pp.DataStr_Easy)
    ElseIf aiOption == UD_ModifierVarNormDesc_T
        SetInfoText("$UD_CUSTOMMOD_VARNORM_INFO")
    ElseIf aiOption == UD_ModifierVarNorm_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetInfoText(loc_mod_pp.DataStr_Ground)
    ElseIf aiOption == UD_ModifierVarHardDesc_T
        SetInfoText("$UD_CUSTOMMOD_VARHARD_INFO")
    ElseIf aiOption == UD_ModifierVarHard_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetInfoText(loc_mod_pp.DataStr_Hard)
    ElseIf aiOption == UD_ModifierDeviceTagsDesc_T
        SetInfoText("$UD_CUSTOMMOD_DEVTAGS_INFO")
    ElseIf aiOption == UD_ModifierDeviceTags_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetInfoText("[" + MCM.StringArrayToString(loc_mod_pp.ConflictedDeviceModTags) + "]")
    ElseIf aiOption == UD_ModifierGlobalTagsDesc_T
        SetInfoText("$UD_CUSTOMMOD_GLOBTAGS_INFO")
    ElseIf aiOption == UD_ModifierGlobalTags_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetInfoText("[" + MCM.StringArrayToString(loc_mod_pp.ConflictedGlobalModTags) + "]")
    ElseIf aiOption == UD_ModifierPreferredDevicesDesc_T
        SetInfoText("$UD_CUSTOMMOD_PREFERREDDEVICES_INFO")
    ElseIf aiOption == UD_ModifierPreferredDevices_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetInfoText("[" + MCM.KeywordArrayToString(loc_mod_pp.PreferredDevices) + "]")
    ElseIf aiOption == UD_ModifierForbiddenDevicesDesc_T
        SetInfoText("$UD_CUSTOMMOD_FORBIDDENDEVICES_INFO")
    ElseIf aiOption == UD_ModifierForbiddenDevices_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        UD_Patcher_ModPreset loc_mod_pp = loc_mod.GetPatcherPreset(UD_ModifierPatchSelected)
        SetInfoText("[" + MCM.KeywordArrayToString(loc_mod_pp.ForbiddenDevices) + "]")
    ElseIf aiOption == UD_ModifierDescription_T
        UD_Modifier loc_mod = UDmain.UDMOM.GetModifierFromStorage(UD_ModifierStorageSelected, UD_ModifierSelected)
        SetInfoText(loc_mod.Description)
    endif
EndFunction