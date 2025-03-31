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

;open text input for user and return string
string Function GetUserTextInput()
    if Ready
        UD_TextMenu.ResetMenu()
        UD_TextMenu.OpenMenu()
        return UD_TextMenu.GetResultString()
    else
        return "ERROR"
    endif
EndFunction

;open list of options and return selected option
Int Function GetUserListInput(string[] aaList, Bool abPremade = False, Int aiListWidth = -1)
    if Ready
        UD_ListMenu.ResetMenu()
        UD_ListMenu.SetPropertyBool("extraFormatting", False)
        UD_ListMenu.SetPropertyInt("listWidth", aiListWidth)
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

; open list of options and return selected option with extra parameters and text formatting
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