Scriptname UD_MCM_Page_ModsTags extends UD_MCM_Page

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

String[] UD_ModTags_Array
Int UD_ModTags_StartIndex
Int UD_ModTags_EndIndex
Int UD_ModTags_Hint_T
Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("$UD_CUSTOMMOD_TAGLIST")
    AddHeaderOption("")

    UD_ModTags_Hint_T = AddTextOption("$UD_CUSTOMMOD_TAGLIST_HINT", "$-INFO-", FlagSwitch(True))
    AddEmptyOption()

    UD_ModTags_Array = UDMain.UDMOM.GetModifiersTags()
    PapyrusUtil.SortStringArray(UD_ModTags_Array)
    Int loc_i = 0
    UD_ModTags_StartIndex = -1
    While loc_i < UD_ModTags_Array.Length
        String loc_tag = UD_ModTags_Array[loc_i]
        String loc_tag_case = UDMain.UDMTF.ForceCase(loc_tag, abUpperCase = True)
        Int loc_temp = AddToggleOption(loc_tag_case, UDCDmain.UDPatcher.IsModifierTagEnabled(loc_tag), UD_LockMenu_flag)
        If UD_ModTags_StartIndex < 0 
            UD_ModTags_StartIndex = loc_temp
        EndIf
        loc_i += 1
    EndWhile
    UD_ModTags_EndIndex = UD_ModTags_StartIndex + loc_i

    If UDMain.TraceAllowed() && False
        UDMain.Log(Self + "::resetModifierTagsPage() Tags = [\n" + PapyrusUtil.StringJoin(UD_ModTags_Array, "\n") + "\n]")
    EndIf
EndFunction

Function PageOptionSelect(Int aiOption)
    if (aiOption >= UD_ModTags_StartIndex && aiOption < UD_ModTags_EndIndex)
        Int loc_index = aiOption - UD_ModTags_StartIndex
        String loc_tag = UD_ModTags_Array[loc_index]
        UDCDMain.UDPatcher.ToggleModifierTag(loc_tag)
        SetToggleOptionValue(aiOption, UDCDMain.UDPatcher.IsModifierTagEnabled(loc_tag))
    EndIf
EndFunction

Function PageInfo(int aiOption)
    if (aiOption >= UD_ModTags_StartIndex && aiOption < UD_ModTags_EndIndex)
        Int loc_index = aiOption - UD_ModTags_StartIndex
        String loc_tag = UD_ModTags_Array[loc_index]
        If StringUtil.GetNthChar(loc_tag, StringUtil.GetLength(loc_tag) - 1) == "-"
            loc_tag = StringUtil.Substring(loc_tag, 0, StringUtil.GetLength(loc_tag) - 1) + "M"
        ElseIf StringUtil.GetNthChar(loc_tag, StringUtil.GetLength(loc_tag) - 1) == "+"
            loc_tag = StringUtil.Substring(loc_tag, 0, StringUtil.GetLength(loc_tag) - 1) + "P"
        EndIf
        SetInfoText("$UD_CUSTOMMOD_TAG_" + loc_tag + "_INFO")
    ElseIf (aiOption == UD_ModTags_Hint_T)
        SetInfoText("$UD_CUSTOMMOD_TAGLIST_HINT_INFO")
    EndIf
EndFunction