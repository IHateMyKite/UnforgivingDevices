Scriptname UD_UIEListMenu extends UIListMenu
{Override of UIExtension script UIListMenu with slight edits to make the ListMenu work while in other menu}

Import UnforgivingDevicesMain

Function Update()
EndFunction

Bool    _waitLock       = False

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

; overrides

Int _entryHeight = -1                   ; Height of the list item. Works only with customized listmenu-ud.swf. Default value: 25
Int _listWidth = -1                     ; Width of the list. Works only with customized listmenu-ud.swf. Default value: ~256
Int _minViewport = -1                   ; Minimum height of the list, measured by the number of visible items. Default value: 5
Int _maxViewport = -1                   ; Maximum height of the list, measured by the number of visible items. Default value: 15
Bool _extraFormatting = False           ; Flag to use listmenu-ud.swf. Default value: False

Function SetPropertyInt(string propertyName, int value)
    If propertyName == "entryHeight"
        _entryHeight = value
    ElseIf propertyName == "listWidth"
        _listWidth = value
    ElseIf propertyName == "minViewport"
        _minViewport = value
    ElseIf propertyName == "maxViewport"
        _maxViewport = value
    EndIf
    Parent.SetPropertyInt(propertyName, value)
EndFunction

Function SetPropertyBool(string propertyName, bool value)
    If propertyName == "extraFormatting"
        _extraFormatting = value
    EndIf
    Parent.SetPropertyBool(propertyName, value)
EndFunction

Function ResetMenu()
    isResetting = true
    _extraFormatting = False
    _entryHeight = -1
    _listWidth = -1
    Parent.ResetMenu()
    isResetting = false
EndFunction

; No access to private fields, so we use our own
Float _resultFloat2 = -1.0
Int _resultInt2 = -1
String _resultString2 = ""

int Function OpenMenu(Form aForm = none, Form aReceiver = none)
    _resultFloat2 = -1.0
    _resultInt2 = -1
    _resultString2 = ""

    If !BlockUntilClosed() || !WaitForReset()
        return 0
    Endif

    RegisterForModEvent("UIListMenu_LoadMenu", "OnLoadMenu")
    RegisterForModEvent("UIListMenu_CloseMenu", "OnUnloadMenu")
    RegisterForModEvent("UIListMenu_SelectItemText", "OnSelectText")
    RegisterForModEvent("UIListMenu_SelectItem", "OnSelect")

    Lock()
    If _extraFormatting || (_entryHeight > 0 || _listWidth > 0)
        UI.OpenCustomMenu("listmenu-ud")
    Else
        UI.OpenCustomMenu("listmenu")
    EndIf
    If !WaitLock()
        return 0
    Endif
    If _resultFloat2 == -1.0 ; Back initiated
        return 0
    Endif
    return 1
EndFunction

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
    If _entryHeight > 0
        UI.SetInt(ROOT_MENU, MENU_ROOT + "itemList.entryHeight", _entryHeight)
    EndIf
    If _listWidth > 0
        UI.SetInt(ROOT_MENU, MENU_ROOT + "itemView.background._width", _listWidth)
        UI.SetInt(ROOT_MENU, MENU_ROOT + "itemList.background._width", _listWidth)
        UI.SetInt(ROOT_MENU, MENU_ROOT + "itemList.scrollbar._x", _listWidth)
        UI.SetInt(ROOT_MENU, MENU_ROOT + "._x", (1280 - _listWidth) / 2)
    EndIf
    If _minViewport > 0
        UI.SetInt(ROOT_MENU, MENU_ROOT + "itemList.minViewport", _minViewport)
    EndIf
    If _maxViewport > 0
        UI.SetInt(ROOT_MENU, MENU_ROOT + "itemList.maxViewport", _maxViewport)
    EndIf
    Parent.OnLoadMenu(eventName, strArg, numArg, formArg)
EndEvent

Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
    _resultInt2 = strArg as int
    _resultFloat2 = numArg
    Unlock()
EndEvent

Event OnSelectText(string eventName, string strArg, float numArg, Form formArg)
    _resultString2 = strArg
    ; Do not unlock on this event, it's part of OnSelect sequence
EndEvent

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
    Parent.OnUnloadMenu(eventName, strArg, numArg, formArg)
    UnregisterForModEvent("UIListMenu_SelectItemText")  ; Forgot to unregister?
EndEvent

int Function GetResultInt()
    return _resultInt2
EndFunction

float Function GetResultFloat()
    return _resultFloat2
EndFunction

string Function GetResultString()
    return _resultString2
EndFunction