Scriptname UD_MCM_Page_Animation extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_AnimationManagerScript Property UDAM Hidden
    UD_AnimationManagerScript Function Get()
        return UDmain.UDAM
    EndFunction
EndProperty

Int UDAM_AnimationJSON_First_T
Int UDAM_AnimationJSON_First_INFO
Int UDAM_Reload_T

Int UD_AlternateAnimation_T
Int UD_AlternateAnimationPeriod_S

Int UD_UseSingleStruggleKeyword_T

function PageInit()
endfunction

Function PageUpdate()
EndFunction

Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
       
    Int flags = OPTION_FLAG_NONE
        
    MCM.UpdateLockMenuFlag()
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

EndFunction

Function PageOptionSelect(Int option)
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

Function PageOptionSliderOpen(Int option)
    if (option == UD_AlternateAnimationPeriod_S)
        SetSliderDialogStartValue(UDAM.UD_AlternateAnimationPeriod)
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(3.0, 15.0)
        SetSliderDialogInterval(1.0)
    endIf
EndFunction
Function PageOptionSliderAccept(Int option, Float value)
    if option == UD_AlternateAnimationPeriod_S
        UDAM.UD_AlternateAnimationPeriod = (value As Int)
        SetSliderOptionValue(UD_AlternateAnimationPeriod_S, value, "{0} s")
    endIf
EndFunction

Function PageOptionMenuOpen(int aiOption)

EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)

EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int option)
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
