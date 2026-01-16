Scriptname UD_MCM_Page_DDPatch extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
zadlibs_UDPatch Property libs
    zadlibs_UDPatch Function Get()
        return MCM.libs
    EndFunction
EndProperty
UD_Config Property UDCONF hidden
    UD_Config Function Get()
        return UDmain.UDCONF
    EndFunction
EndProperty

int UD_StartThirdpersonAnimation_Switch_T
Int UD_OutfitRemove_T
Int UD_CheckAllKw_T
Int UD_AllowMenBondage_T
int UD_OrgasmAnimation_M
string[] orgasmAnimation
int UD_GagPhonemModifier_S
function PageInit()
endfunction

Function PageUpdate()
    orgasmAnimation = new String[2]
    orgasmAnimation[0] = "$Normal"
    orgasmAnimation[1] = "$Expanded"
EndFunction

Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)
    
    AddHeaderOption("$UD_GENERAL")
    addEmptyOption()
    
    addEmptyOption()
    UD_CheckAllKw_T = addToggleOption("$UD_CHECKALLKW",UDmain.UD_CheckAllKw)
    
    AddHeaderOption("$UD_H_ANIMATIONSETTING")
    addEmptyOption()
    
    UD_StartThirdpersonAnimation_Switch_T = addToggleOption("$UD_STARTTHIRDPERSONANIMATIONSWITCH", libs.UD_StartThirdPersonAnimation_Switch)
    UD_OrgasmAnimation_M = AddMenuOption("$UD_ORGASMANIMATION", orgasmAnimation[UDCONF.UD_OrgasmAnimation]) 
    
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("$UD_H_DEVICESETTING")
    addEmptyOption()

    UD_AllowMenBondage_T = addToggleOption("$UD_ALLOWMENBONDAGE", UDmain.AllowMenBondage,FlagSwitch(UDmain.ForHimInstalled))
EndFunction

Function PageOptionSelect(Int aiOption)
    if(aiOption == UD_StartThirdpersonAnimation_Switch_T)
        libs.UD_StartThirdpersonAnimation_Switch = !libs.UD_StartThirdpersonAnimation_Switch
        SetToggleOptionValue(UD_StartThirdpersonAnimation_Switch_T, libs.UD_StartThirdpersonAnimation_Switch)
    elseif aiOption == UD_AllowMenBondage_T
        UDmain.AllowMenBondage = !UDmain.AllowMenBondage
        SetToggleOptionValue(UD_AllowMenBondage_T, UDmain.AllowMenBondage)
    elseif aiOption == UD_CheckAllKw_T
        UDmain.UD_CheckAllKw = !UDmain.UD_CheckAllKw
        SetToggleOptionValue(UD_CheckAllKw_T, UDMain.UD_CheckAllKw)
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)

EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)

EndFunction

Function PageOptionMenuOpen(int aiOption)
    if (aiOption == UD_OrgasmAnimation_M)
        SetMenuDialogOptions(orgasmAnimation)
        SetMenuDialogStartIndex(UDCONF.UD_OrgasmAnimation)
        SetMenuDialogDefaultIndex(0)
    endif
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
    if (aiOption == UD_OrgasmAnimation_M)
        UDCONF.UD_OrgasmAnimation = aiIndex
        SetMenuOptionValue(UD_OrgasmAnimation_M, orgasmAnimation[UDCONF.UD_OrgasmAnimation])
    endIf
EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int aiOption)
    if aiOption == UD_GagPhonemModifier_S
        SetInfoText("$UD_GAGPHONEMMODIFIER_INFO")
    elseif aiOption == UD_OutfitRemove_T
        SetInfoText("$UD_OUTFITREMOVE_INFO")
    elseif aiOption == UD_AllowMenBondage_T
        SetInfoText("$UD_ALLOWMENBONDAGE")
    elseif aiOption == UD_OrgasmAnimation_M
        SetInfoText("$UD_ORGASMANIMATION_INFO")
    elseif aiOption == UD_CheckAllKw_T
        SetInfoText("$UD_CHECKALLKW_INFO")
    endif
EndFunction
