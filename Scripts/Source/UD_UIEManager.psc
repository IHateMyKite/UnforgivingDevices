Scriptname UD_UIEManager Extends Quest
{Manager for UI Extensions mod}

UnforgivingDevicesMain  Property UDmain                 auto
Quest                   Property UD_UIEManagerQuest     auto hidden
UD_UIEListMenu          Property UD_ListMenu            auto
UD_UIETextInput         Property UD_TextMenu            auto

Bool Property Ready = False auto

Event OnInit()
    UD_UIEManagerQuest = (self as Quest)
    UD_ListMenu = UD_UIEManagerQuest as UD_UIEListMenu
    UD_TextMenu = UD_UIEManagerQuest as UD_UIETextInput
    Bool loc_error = false
    if !UD_ListMenu
        UDmain.Error("Error loading UD_UIEListMenu script on quest " + self)
        loc_error = true
    endif
    if !UD_TextMenu
        UDmain.Error("Error loading UD_TextMenu script on quest " + self)
        loc_error = true
    endif
    if !loc_error
        Ready = True
    endif
    RegisterForSingleUpdate(120)
EndEvent

Event OnUpdate()
    ;MAINTENANCE
    RegisterForSingleUpdate(120)
EndEvent

;Update of UD_UIEManager scirpt on game update
Function Update()
    if Ready
        UD_ListMenu.Update()
        UD_TextMenu.Update()
    else
        OnInit() ;try to reinit the quest
    endif
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
Int Function GetUserListInput(string[] aaList)
    if Ready
        UD_ListMenu.ResetMenu()
        int loc_i = 0
        while loc_i < aaList.length
            UD_ListMenu.AddEntryItem(aaList[loc_i])
            loc_i += 1
        endwhile
        UD_ListMenu.OpenMenu()
        return UD_ListMenu.GetResultInt()
    else
        return -1
    endif
EndFunction


