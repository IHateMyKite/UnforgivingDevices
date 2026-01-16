Scriptname UD_MCM_Page_Filter extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_Config         Property UDCONF hidden
    UD_Config Function Get()
        return UDmain.UDCONF
    EndFunction
EndProperty

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

Function PageReset(Bool abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)

    AddHeaderOption("$UD_DEVICEFILTER")
    addEmptyOption()

    UD_UseArmCuffs_T        = AddToggleOption("$UD_USEARMCUFFS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00001000), FlagSwitch(!abLockMenu))
    UD_UseLegCuffs_T        = AddToggleOption("$UD_USELEGCUFFS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00002000), FlagSwitch(!abLockMenu))
    UD_UseBras_T            = AddToggleOption("$UD_USECHASTITYBRAS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00010000), FlagSwitch(!abLockMenu))
    UD_UseBelts_T           = AddToggleOption("$UD_USECHASTITYBELTS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00020000), FlagSwitch(!abLockMenu))
    UD_UseBlindfolds_T      = AddToggleOption("$UD_USEBLINDFOLDS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000400), FlagSwitch(!abLockMenu))
    UD_UseBoots_T           = AddToggleOption("$UD_USEBOOTS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000800), FlagSwitch(!abLockMenu))
    UD_UseCollars_T         = AddToggleOption("$UD_USECOLLARS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000100), FlagSwitch(!abLockMenu))
    UD_UseCorsets_T         = AddToggleOption("$UD_USECORSETS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000040), FlagSwitch(!abLockMenu))
    UD_UseGags_T            = AddToggleOption("$UD_USEGAGS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000200), FlagSwitch(!abLockMenu))
    UD_UseGloves_T          = AddToggleOption("$UD_USEGLOVES", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00008000), FlagSwitch(!abLockMenu))
    UD_UseHarnesses_T       = AddToggleOption("$UD_USEHARNESSES", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000020), FlagSwitch(!abLockMenu))
    UD_UseHoods_T           = AddToggleOption("$UD_USEHOODS",Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000080),FlagSwitch(!abLockMenu)) ; leave it as it is, no point in changing, unless we get rid of this variable
    UD_UsePiercingsNipple_T = AddToggleOption("$UD_USEPIERCINGSNIPPLE", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000002), FlagSwitch(!abLockMenu))
    UD_UsePiercingsVaginal_T= AddToggleOption("$UD_USEPIERCINGSVAGINAL", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000001), FlagSwitch(!abLockMenu))
    UD_UsePlugsAnal_T       = AddToggleOption("$UD_USEPLUGSANAL", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000008), FlagSwitch(!abLockMenu))
    UD_UsePlugsVaginal_T    = AddToggleOption("$UD_USEPLUGSVAGINAL", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000004), FlagSwitch(!abLockMenu))
    UD_UseHeavyBondage_T    = AddToggleOption("$UD_USEHEAVYBONDAGE", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000010), FlagSwitch(!abLockMenu))
    UD_UseSuits_T           = AddToggleOption("$UD_USESUITS", Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00004000), FlagSwitch(!abLockMenu))
    addEmptyOption()
    addEmptyOption()
    UD_RandomFilter_T       = AddInputOption("$UD_RANDOMFILTER", Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0xFFFFFFFF), FlagSwitch(!abLockMenu)) ; leaving this just in case
    addEmptyOption()

EndFunction

Function PageOptionSelect(Int aiOption)
    if (aiOption == UD_UseArmCuffs_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00001000)
        SetToggleOptionValue(UD_UseArmCuffs_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00001000))
        forcePageReset()
    elseif (aiOption == UD_UseBelts_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00020000)
        SetToggleOptionValue(UD_UseBelts_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00020000))
        forcePageReset()
    elseif (aiOption == UD_UseBlindfolds_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000400)
        SetToggleOptionValue(UD_UseBlindfolds_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000400))
        forcePageReset()
    elseif (aiOption == UD_UseBoots_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000800)
        SetToggleOptionValue(UD_UseBoots_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000800))
        forcePageReset()
    elseif (aiOption == UD_UseBras_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00010000)
        SetToggleOptionValue(UD_UseBras_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00010000))
        forcePageReset()
    elseif (aiOption == UD_UseCollars_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000100)
        SetToggleOptionValue(UD_UseCollars_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000100))
        forcePageReset()
    elseif (aiOption == UD_UseCorsets_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000040)
        SetToggleOptionValue(UD_UseCorsets_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000040))
        forcePageReset()
    elseif (aiOption == UD_UseGags_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000200)
        SetToggleOptionValue(UD_UseGags_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000200))
        forcePageReset()
    elseif (aiOption == UD_UseGloves_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00008000)
        SetToggleOptionValue(UD_UseGloves_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00008000))
        forcePageReset()
    elseif (aiOption == UD_UseHarnesses_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000020)
        SetToggleOptionValue(UD_UseHarnesses_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000020))
        forcePageReset()
    elseif (aiOption == UD_UseHeavyBondage_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000010)
        SetToggleOptionValue(UD_UseHeavyBondage_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000010))
        forcePageReset()
    elseif (aiOption == UD_UseHoods_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000080)
        SetToggleOptionValue(UD_UseHeavyBondage_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000080))
        forcePageReset()
    elseif (aiOption == UD_UseLegCuffs_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00002000)
        SetToggleOptionValue(UD_UseLegCuffs_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00002000))
        forcePageReset()
    elseif (aiOption == UD_UsePiercingsNipple_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000002)
        SetToggleOptionValue(UD_UsePiercingsNipple_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000002))
        forcePageReset()
    elseif (aiOption == UD_UsePiercingsVaginal_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000001)
        SetToggleOptionValue(UD_UsePiercingsVaginal_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000001))
        forcePageReset()
    elseif (aiOption == UD_UsePlugsAnal_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000008)
        SetToggleOptionValue(UD_UsePlugsAnal_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000008))
        forcePageReset()
    elseif (aiOption == UD_UsePlugsVaginal_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00000004)
        SetToggleOptionValue(UD_UsePlugsVaginal_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00000004))
        forcePageReset()
    elseif (aiOption == UD_UseSuits_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0x00004000)
        SetToggleOptionValue(UD_UseSuits_T, Math.LogicalAnd(UDCONF.UD_RandomDevice_GlobalFilter,0x00004000))
        forcePageReset()
    endif
EndFunction

Function PageOptionInputOpen(Int aiOption)
    if aiOption == UD_RandomFilter_T
        SetInputDialogStartText(Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0xFFFFFFFF))
    endif
EndFunction
Function PageOptionInputAccept(Int aiOption, String asValue)
    if(aiOption == UD_RandomFilter_T)
        UDCONF.UD_RandomDevice_GlobalFilter = Math.LogicalXor(asValue as Int,0xFFFFFFFF)
        SetInputOptionValue(UD_RandomFilter_T, Math.LogicalXor(UDCONF.UD_RandomDevice_GlobalFilter,0xFFFFFFFF))
    endif
EndFunction

Function PageDefault(int aiOption)
    ; todo
EndFunction

Function PageInfo(int aiOption)
    if(aiOption == UD_UseArmCuffs_T)
        SetInfoText("$UD_USEARMCUFFS_INFO")
    elseif(aiOption == UD_UseBelts_T)
        SetInfoText("$UD_USECHASTITYBELTS_INFO")
    elseif(aiOption == UD_UseBlindfolds_T)
        SetInfoText("$UD_USEBLINDFOLDS_INFO")
    elseif(aiOption == UD_UseBoots_T)
        SetInfoText("$UD_USEBOOTS_INFO")
    elseif(aiOption == UD_UseBras_T)
        SetInfoText("$UD_USECHASTITYBRAS_INFO")
    elseif(aiOption == UD_UseCollars_T)
        SetInfoText("$UD_USECOLLARS_INFO")
    elseif(aiOption == UD_UseCorsets_T)
        SetInfoText("$UD_USECORSETS_INFO")
    elseif(aiOption == UD_UseGags_T)
        SetInfoText("$UD_USEGAGS_INFO")
    elseif(aiOption == UD_UseGloves_T)
        SetInfoText("$UD_USEGLOVES_INFO")
    elseif(aiOption == UD_UseHarnesses_T)
        SetInfoText("$UD_USEHARNESSES_INFO")
    elseif(aiOption == UD_UseHeavyBondage_T)
        SetInfoText("$UD_USEHEAVYBONDAGE_INFO")
    elseif(aiOption == UD_UseHoods_T)
        SetInfoText("$UD_USEHOODS_INFO")
    elseif(aiOption == UD_UseLegCuffs_T)
        SetInfoText("$UD_USELEGCUFFS_INFO")
    elseif(aiOption == UD_UsePiercingsNipple_T)
        SetInfoText("$UD_USEPIERCINGSNIPPLE_INFO")
    elseif(aiOption == UD_UsePiercingsVaginal_T)
        SetInfoText("$UD_USEPIERCINGSVAGINAL_INFO")
    elseif(aiOption == UD_UsePlugsAnal_T)
        SetInfoText("$UD_USEPLUGSANAL_INFO")
    elseif(aiOption == UD_UsePlugsVaginal_T)
        SetInfoText("$UD_USEPLUGSVAGINAL_INFO")
    elseif(aiOption == UD_UseSuits_T)
        SetInfoText("$UD_USESUITS_INFO")
    elseif aiOption == UD_RandomFilter_T ;this aiOption will be deleted
        SetInfoText("$UD_RANDOMFILTER_INFO")
    endif
EndFunction