Scriptname UD_MCM_Page_Patcher extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty

int UD_PatchMult_S
int UD_EscapeModifier_S
int UD_MinLocks_S
int UD_MaxLocks_S
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

function PageInit()
endfunction

Function PageUpdate()
EndFunction

Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
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
EndFunction

Function PageOptionSelect(Int aiOption)
    if(aiOption == UD_TimedLocks_T)
        UDCDmain.UDPatcher.UD_TimedLocks = !UDCDmain.UDPatcher.UD_TimedLocks
        SetToggleOptionValue(UD_TimedLocks_T, UDCDmain.UDPatcher.UD_TimedLocks)
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    if (aiOption == UD_PatchMult_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_EscapeModifier_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_EscapeModifier)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(5.0,30.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_MinLocks_S
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_MinLocks)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(0.0,UDCDmain.UDPatcher.UD_MaxLocks)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_MaxLocks_S
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_MaxLocks)
        SetSliderDialogDefaultValue(2.0)
        SetSliderDialogRange(UDCDmain.UDPatcher.UD_MinLocks,30.0)
        SetSliderDialogInterval(1.0)
    elseif aiOption == UD_MinResistMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_MinResistMult * 100))
        SetSliderDialogDefaultValue(-100.0)
        SetSliderDialogRange(-200.0,Round(UDCDmain.UDPatcher.UD_MaxResistMult * 100))
        SetSliderDialogInterval(10.0)
    elseif aiOption == UD_MaxResistMult_S
        SetSliderDialogStartValue(Round(UDCDmain.UDPatcher.UD_MaxResistMult * 100))
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(Round(UDCDmain.UDPatcher.UD_MinResistMult * 100),200.0)
        SetSliderDialogInterval(10.0)
    elseif (aiOption == UD_PatchMult_HeavyBondage_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_PatchMult_Blindfold_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Blindfold)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_PatchMult_Gag_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Gag)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_PatchMult_Hood_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Hood)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_PatchMult_ChastityBelt_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_PatchMult_ChastityBra_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_ChastityBra)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_PatchMult_Plug_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Plug)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_PatchMult_Piercing_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Piercing)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    elseif (aiOption == UD_PatchMult_Generic_S)
        SetSliderDialogStartValue(UDCDmain.UDPatcher.UD_PatchMult_Generic)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.3,10.0)
        SetSliderDialogInterval(0.1)
    endif
EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)
    int loc_value = Round(afValue)
    if (aiOption == UD_PatchMult_S)
        UDCDmain.UDPatcher.UD_PatchMult = afValue
        SetSliderOptionValue(UD_PatchMult_S, UDCDmain.UDPatcher.UD_PatchMult, "{1} x")
    elseif (aiOption == UD_EscapeModifier_S)
        UDCDmain.UDPatcher.UD_EscapeModifier = Round(afValue)
        SetSliderOptionValue(UD_EscapeModifier_S, UDCDmain.UDPatcher.UD_EscapeModifier, "{0}")
    elseif aiOption == UD_MinLocks_S
        UDCDmain.UDPatcher.UD_MinLocks = Round(afValue)
        SetSliderOptionValue(UD_MinLocks_S, UDCDmain.UDPatcher.UD_MinLocks, "{0}")
    elseif aiOption == UD_MaxLocks_S
        UDCDmain.UDPatcher.UD_MaxLocks = Round(afValue)
        SetSliderOptionValue(UD_MaxLocks_S, UDCDmain.UDPatcher.UD_MaxLocks, "{0}")
    elseif aiOption == UD_MinResistMult_S
        UDCDmain.UDPatcher.UD_MinResistMult = afValue/100.0
        SetSliderOptionValue(UD_MinResistMult_S, Round(UDCDmain.UDPatcher.UD_MinResistMult * 100), "{0} %")
    elseif aiOption == UD_MaxResistMult_S
        UDCDmain.UDPatcher.UD_MaxResistMult = afValue/100.0
        SetSliderOptionValue(UD_MaxResistMult_S, Round(UDCDmain.UDPatcher.UD_MaxResistMult * 100), "{0} %")
    elseif (aiOption == UD_PatchMult_HeavyBondage_S)
        UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage = afValue
        SetSliderOptionValue(UD_PatchMult_HeavyBondage_S, UDCDmain.UDPatcher.UD_PatchMult_HeavyBondage, "{1} x")
    elseif (aiOption == UD_PatchMult_Blindfold_S)
        UDCDmain.UDPatcher.UD_PatchMult_Blindfold = afValue
        SetSliderOptionValue(UD_PatchMult_Blindfold_S, UDCDmain.UDPatcher.UD_PatchMult_Blindfold, "{1} x")
    elseif (aiOption == UD_PatchMult_Gag_S)
        UDCDmain.UDPatcher.UD_PatchMult_Gag = afValue
        SetSliderOptionValue(UD_PatchMult_Gag_S, UDCDmain.UDPatcher.UD_PatchMult_Gag, "{1} x")
    elseif (aiOption == UD_PatchMult_Hood_S)
        UDCDmain.UDPatcher.UD_PatchMult_Hood = afValue
        SetSliderOptionValue(UD_PatchMult_Hood_S, UDCDmain.UDPatcher.UD_PatchMult_Hood, "{1} x")
    elseif (aiOption == UD_PatchMult_ChastityBelt_S)
        UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt = afValue
        SetSliderOptionValue(UD_PatchMult_ChastityBelt_S, UDCDmain.UDPatcher.UD_PatchMult_ChastityBelt, "{1} x")
    elseif (aiOption == UD_PatchMult_ChastityBra_S)
        UDCDmain.UDPatcher.UD_PatchMult_ChastityBra = afValue
        SetSliderOptionValue(UD_PatchMult_ChastityBra_S, UDCDmain.UDPatcher.UD_PatchMult_ChastityBra, "{1} x")
    elseif (aiOption == UD_PatchMult_Plug_S)
        UDCDmain.UDPatcher.UD_PatchMult_Plug = afValue
        SetSliderOptionValue(UD_PatchMult_Plug_S, UDCDmain.UDPatcher.UD_PatchMult_Plug, "{1} x")
    elseif (aiOption == UD_PatchMult_Piercing_S)
        UDCDmain.UDPatcher.UD_PatchMult_Piercing = afValue
        SetSliderOptionValue(UD_PatchMult_Piercing_S, UDCDmain.UDPatcher.UD_PatchMult_Piercing, "{1} x")
    elseif (aiOption == UD_PatchMult_Generic_S)
        UDCDmain.UDPatcher.UD_PatchMult_Generic = afValue
        SetSliderOptionValue(UD_PatchMult_Generic_S, UDCDmain.UDPatcher.UD_PatchMult_Generic, "{1} x")
    endif
EndFunction

Function PageOptionMenuOpen(int aiOption)

EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)

EndFunction

Function PageDefault(int aiOption)
    if aiOption == UD_TimedLocks_T
        UDCDmain.UDPatcher.UD_TimedLocks = false
        SetToggleOptionValue(UD_TimedLocks_T, UDCDmain.UDPatcher.UD_TimedLocks)
    endif
EndFunction

Function PageInfo(int aiOption)
    if  aiOption == UD_PatchMult_S
        SetInfoText("$UD_PATCHMULT_INFO")
    elseif aiOption == UD_EscapeModifier_S
        SetInfoText("$UD_ESCAPEMODIFIER_INFO")
    elseif aiOption == UD_MinLocks_S
        SetInfoText("$UD_MINLOCKS_INFO")
    elseif aiOption == UD_MaxLocks_S
        SetInfoText("$UD_MAXLOCKS_INFO")
    elseif aiOption == UD_MinResistMult_S
        SetInfoText("$UD_MINRESISTMULT_INFO")
    elseif aiOption == UD_MaxResistMult_S
        SetInfoText("$UD_MAXRESISTMULT_INFO")
    elseif aiOption == UD_TimedLocks_T
        SetInfoText("If patched devices can have timed locks")
    endif
EndFunction
