Scriptname UD_UIEListMenu extends UIListMenu
{Override of UIExtension script UIListMenu with slight edits to make the ListMenu work while in other menu}

Bool _waitLock = False

Function Lock()
    _waitLock = true
EndFunction

bool Function WaitLock()
    While _waitLock
        Utility.WaitMenuMode(0.1)
    EndWhile
    return true
EndFunction

Function Unlock()
    _waitLock = false
EndFunction

bool Function WaitForReset()
    While isResetting
        Utility.WaitMenuMode(0.1)
    EndWhile
    return true
EndFunction

bool Function BlockUntilClosed()
    While UI.IsMenuOpen("CustomMenu")
        Utility.WaitMenuMode(0.1)
    EndWhile
    return true
EndFunction