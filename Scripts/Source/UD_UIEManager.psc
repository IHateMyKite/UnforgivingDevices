Scriptname UD_UIEManager Extends Quest
{Manager for UI Extensions mod}

UnforgivingDevicesMain  Property UDmain                 auto
Quest                   Property UD_UIEManagerQuest     auto hidden
UD_UIEListMenu          Property UD_ListMenu            auto
UD_UIETextInput         Property UD_TextMenu            auto

Bool Property Ready = False auto

Event OnInit()
    Ready = _LoadMenuScripts()
    RegisterForSingleUpdate(120)
EndEvent

Event OnUpdate()
    ;MAINTENANCE
    RegisterForSingleUpdate(120)
EndEvent

;Update of UD_UIEManager scirpt on game update
Function Update()
    Ready = _LoadMenuScripts()
    if Ready
        UD_ListMenu.Update()
        UD_TextMenu.Update()
    else
        OnInit() ;try to reinit the quest
    endif
EndFunction

Bool Function _LoadMenuScripts()
    UD_UIEManagerQuest = (self as Quest)
    UD_ListMenu = UD_UIEManagerQuest as UD_UIEListMenu
    UD_TextMenu = UD_UIEManagerQuest as UD_UIETextInput
    Bool loc_error = false
    if !UD_ListMenu
        UDmain.Error("Error loading UD_UIEListMenu script on quest " + self)
        loc_error = true
    endif
    if !UD_TextMenu
        UDmain.Error("Error loading UD_UIETextInput script on quest " + self)
        loc_error = true
    endif
    Return !loc_error
EndFunction


;/  Function: GetUserTextInput

    Open text input for user and return string

    Returns:
        User input string
/;
string Function GetUserTextInput()
    if Ready
        UD_TextMenu.ResetMenu()
        UD_TextMenu.OpenMenu()
        return UD_TextMenu.GetResultString()
    else
        return "ERROR"
    endif
EndFunction

;/  Function: GetUserTextInput

    Open list of options for user and return selected item from it

    Parameters:
        aaList                  - List of options to choose from.
        abPremade               - The format in which the elements of the source list are generated. If True then entries should contain explicit value for IDs and callback:
                                    entries[i] = _entryName[i] + ";;" + _entryParent[i] + ";;" + _entryId[i] + ";;" + _entryCallback[i] + ";;" + (_entryChildren[i] as int)

    Returns:
        Index of the selected item
/;
Int Function GetUserListInput(string[] aaList, Bool abPremade = False)
    if Ready
        UD_ListMenu.ResetMenu()
        UD_ListMenu.SetPropertyBool("extraFormatting", False)
        If abPremade
            ; append premade entries
            UD_ListMenu.SetPropertyStringA("appendEntries", aaList)
        Else
            int loc_i = 0
            while loc_i < aaList.length
                UD_ListMenu.AddEntryItem(aaList[loc_i])
                loc_i += 1
            endwhile
        EndIf
        UD_ListMenu.OpenMenu()
        return UD_ListMenu.GetResultInt()
    else
        return -1
    endif
EndFunction

;/  Function: GetUserListInputEx

    Open list of options for user with extra parameters and text formatting and return selected item from it

    Parameters:
        aaList                  - List of options to choose from.
        abPremade               - The format in which the elements of the source list are generated. If True then entries should contain explicit value for IDs and callback:
                                    entries[i] = _entryName[i] + ";;" + _entryParent[i] + ";;" + _entryId[i] + ";;" + _entryCallback[i] + ";;" + (_entryChildren[i] as int)
        aiListWidth             - Desired width of the list (1280 is screen width). Default value: ~256
        aiEntryHeight           - Desired height of the item in the list. Default value: 25

    Returns:
        Index of the selected item
/;
Int Function GetUserListInputEx(string[] aaList, Bool abPremade = True, Int aiListWidth = -1, Int aiEntryHeight = -1)
    if Ready
        UD_ListMenu.ResetMenu()
        UD_ListMenu.SetPropertyBool("extraFormatting", True)
        UD_ListMenu.SetPropertyInt("entryHeight", aiEntryHeight)
        UD_ListMenu.SetPropertyInt("listWidth", aiListWidth)
        If abPremade
            ; append premade entries
            ; entries[i] = _entryName[i] + ";;" + _entryParent[i] + ";;" + _entryId[i] + ";;" + _entryCallback[i] + ";;" + (_entryChildren[i] as int)
            UD_ListMenu.SetPropertyStringA("appendEntries", aaList)
        Else
            int loc_i = 0
            while loc_i < aaList.length
                UD_ListMenu.AddEntryItem(aaList[loc_i])
                loc_i += 1
            endwhile
        EndIf
        UD_ListMenu.OpenMenu()
        return UD_ListMenu.GetResultInt()
    else
        return -1
    endif
EndFunction