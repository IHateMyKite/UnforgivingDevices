Scriptname UD_MenuMsgManager extends Quest Conditional

import UD_Native

Bool                    Property Ready = False                  Auto Hidden

UnforgivingDevicesMain  Property UDmain                         Auto

UD_MenuTextFormatter    Property UDMTF                          Auto

String[]                Property NoButtons                      Auto Hidden
Float[]                 Property NoValues                       Auto Hidden

Message                 Property MsgTemplate                    Auto

Bool                    Property currentMenu_button0 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button1 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button2 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button3 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button4 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button5 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button6 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button7 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button8 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button9 = false    Auto Conditional Hidden

; HELP MESSAGES
Message                 Property HelpStruggleGameMsg            Auto
Message                 Property HelpCuttingGameMsg             Auto
Message                 Property HelpPlugRemoveGameMsg          Auto
Message                 Property HelpLockpickingGameMsg         Auto
Message                 Property HelpRepairGameMsg              Auto
Message                 Property HelpChangeIconMsg              Auto
Message                 Property HelpChangeWidgetsPosMsg        Auto
Message                 Property HelpActionKeyMsg               Auto
Message                 Property HelpActionKeyHoldMsg           Auto
Message                 Property HelpHelperMsg                  Auto

Bool                    Property ShowHelpEnable = False         Auto Hidden
Float                   Property ShowHelpDuration = 7.0         Auto Hidden
Float                   Property ShowHelpInterval = 60.0        Auto Hidden
Int                     Property ShowHelpMaxTimes = 1           Auto Hidden

Event OnInit()
    RegisterForSingleUpdate(20.0)
EndEvent

Function OnUpdate()
    if UDmain.WaitForReady()
        Update()
    endif
    _CheckHelpMessageQueue()
EndFunction

Function Update()
    _Modes = Utility.CreateStringArray(0)
    NoButtons = Utility.CreateStringArray(0)
    NoValues = Utility.CreateFloatArray(0)
    UnregisterMenuEvents()
    RegisterMenuEvents()
    RegisterModEvents()
    Ready = True
EndFunction

Function RegisterMenuEvents()
    RegisterForMenu("MessageBoxMenu")
EndFunction

Function UnregisterMenuEvents()
    UnregisterForAllMenus()
EndFunction

Function RegisterModEvents(Bool abRegister = True)
    If abRegister && ShowHelpEnable
;        RegisterForModEvent("UDEvent_DeviceMinigameBegin", "OnDeviceMinigameBegin")
    Else
;        UnRegisterForModEvent("UDEvent_DeviceMinigameBegin")
    EndIf
EndFunction

;/  Group: Mode Control
===========================================================================================
===========================================================================================
===========================================================================================
/;

String[] _Modes

;/  Function: GetModes

    The function returns all possible operation modes of the script as an array of strings
    
    Returns:
        Array of strings with possible modes
/;
String[] Function GetModes()
    If _Modes.Length == 0
        _Modes = Utility.CreateStringArray(3)
        _Modes[0] = "Legacy"
        _Modes[1] = "PapyrusUI"
    ;   _Modes[2] = "NativeUI"
    EndIf
    Return _Modes
EndFunction

;/  Function: SetMode

    The function sets new operation mode for the script
    
    Parameters:
        abMode                   - New operation mode
/;
Function SetMode(String abMode)
    If abMode == "Legacy"
        abMode = ""
    EndIf
    GoToState(abMode)
EndFunction

;/  Function: GetMode

    The function returns current operation mode of the script
    
    Returns:
        Operation mode
/;
String Function GetMode()
    If GetState() == ""
        Return "Legacy"
    EndIf
    Return GetState()
EndFunction

;/  Function: GetModeIndex

    The function returns index of the current operation mode
    
    Returns:
        Operation mode index
/;
Int Function GetModeIndex()
    If GetState() == ""
        Return 0
    EndIf
    Return GetModes().Find(GetState())
EndFunction

; Help messages

Event OnDeviceMinigameBegin(String asSource, Form akFActor, Form akFHelper, String asMinigameName, Float afRelativeDurability, Form akFID, Form akFRD)
    If asMinigameName == "Struggle_0" || asMinigameName == "Struggle_1" || asMinigameName == "Struggle_2"
        ShowHelpMessage("StruggleGame")
    ElseIf asMinigameName == "Lockpick"
        ShowHelpMessage("LockpickingGame")
    ElseIf asMinigameName == "RepairLock"
        ShowHelpMessage("RepairGame")
    ElseIf asMinigameName == "Cutting"
        ShowHelpMessage("CuttingGame")
    ElseIf asMinigameName == "KeyUnlock"
        ShowHelpMessage("KeyUnlockGame")            ; TODO: Add message for that
    ElseIf asMinigameName == "Plug_ForceOut" || asMinigameName == "AbadonPlug_ForceOut"
        ShowHelpMessage("PlugRemoveGame")
    EndIf
EndEvent

Message _HelpMessage
String _HelpEventName

Function ShowHelpMessage(String asEventName)
    If !ShowHelpEnable
        Return
    EndIf
    If _HelpMessage 
        Return
    EndIf
    Message loc_msg = None
    If asEventName == "StruggleGame"
        loc_msg = HelpStruggleGameMsg
    ElseIf asEventName == "LockpickingGame"
        loc_msg = HelpLockpickingGameMsg
    ElseIf asEventName == "PlugRemoveGame"
        loc_msg = HelpPlugRemoveGameMsg
    ElseIf asEventName == "CuttingGame"
        loc_msg = HelpCuttingGameMsg
    ElseIf asEventName == "RepairGame"
        loc_msg = HelpCuttingGameMsg
    ElseIf asEventName == "KeyUnlockGame"
    ; TODO: Add message for that
    ElseIf asEventName == "DebuffAdded"
        loc_msg = _GetHelpMessage(HelpChangeIconMsg, HelpChangeWidgetsPosMsg)
    ElseIf asEventName == "DebuffRemoved"
        loc_msg = _GetHelpMessage(HelpActionKeyHoldMsg, HelpActionKeyMsg)
    ElseIf asEventName == "DeviceIcon"
        loc_msg = HelpChangeWidgetsPosMsg
    ElseIf asEventName == "DeviceLocked"
        loc_msg = _GetHelpMessage(HelpActionKeyHoldMsg, HelpActionKeyMsg, HelpHelperMsg)
    ElseIf asEventName == "DeviceUnlocked"
    ; TODO: Add message for that
    ElseIf asEventName == "Helper"
        loc_msg = HelpHelperMsg
    EndIf
    If loc_msg != None
        _HelpMessage = loc_msg
        _HelpEventName = _GetHelpEventName(loc_msg)
        RegisterForSingleUpdate(0.1)
    EndIf
EndFunction
;//;
Function _CheckHelpMessageQueue()
    If ShowHelpEnable && _HelpMessage
        Int loc_counter = StorageUtil.GetIntValue(_HelpMessage, "UD_HelpEvent_Counter", 0)
        If loc_counter >= ShowHelpMaxTimes
            Return
        EndIf
        StorageUtil.SetIntValue(_HelpMessage, "UD_HelpEvent_Counter", loc_counter + 1)
        _HelpMessage.ShowAsHelpMessage("UD_HelpEvent", ShowHelpDuration, ShowHelpInterval, 1)
        Utility.Wait(ShowHelpDuration + 0.5)
        Message.ResetHelpMessage("UD_HelpEvent")
        _HelpMessage = None
    EndIf
EndFunction

; State: Legacy

Event OnMenuOpen(String MenuName)
EndEvent

Bool Function IsMessageboxOpen()
    Return UI.IsMenuOpen("MessageBoxMenu")
EndFunction

Function ShowMessageBox(String asMessage, Bool abHasHTML = False)
    ; SplitMessageIntoPages should be compatible with both plain and html text if more advanced mode is used
    String[] loc_pages = UDMTF.SplitMessageIntoPages(asMessage)
    Int loc_i = 0
    While loc_i < loc_pages.Length
        ShowSingleMessageBox(loc_pages[loc_i], abHasHTML)
        loc_i += 1
    EndWhile
EndFunction

Function ShowSingleMessageBox(String asMessage, Bool abHasHTML = False)
    If abHasHTML 
        UDMain.Warning(Self + "::ShowSingleMessageBox() Legacy Mode: Can't display HTML text properly!")
    EndIf
    String loc_msg = asMessage
    If StringUtil.GetLength(loc_msg) > 2047
        UDMain.Warning(Self + "::ShowSingleMessageBox() Message is too long to display it on a single page!")
        loc_msg = StringUtil.Substring(loc_msg, 0, 2000) + " [message is too long]"
    EndIf
    Debug.MessageBox(loc_msg)

    ;wait for fucking messagebox to actually get OKd before continuing thread (holy FUCKING shit toad)
    Utility.waitMenuMode(0.3)
    while IsMessageboxOpen()
        Utility.waitMenuMode(0.05)
    EndWhile
EndFunction

Int Function ShowMessageBoxMenu(Message akTemplate, Float[] aafValues, String asMessageOverride, String[] aasButtonsOverride, Bool abHasHTML = False)

    If abHasHTML 
        UDMain.Warning(Self + "::ShowMessageBoxMenu() Legacy Mode: Can't display HTML text properly!")
    EndIf
    
    Int loc_last_btn = -1
    
    If akTemplate == None
        UDMain.Error(Self + "::ShowMessageBoxMenu() Legacy Mode: akTemplate must be specified!")
        Debug.MessageBox("ShowMessageBoxMenu() Legacy Mode: akTemplate must be specified!")
    Else
        loc_last_btn = _ShowMessageboxArrayTemplate(akTemplate,asMessageOverride, aafValues, aasButtonsOverride, abGetIndex = true, abUseHTML = abHasHTML) as Int
    EndIf
    
    Return loc_last_btn
EndFunction
    
Bool        _InjectReady = False
Bool        _InjectMessageHTML = False
String      _InjectMessage = ""
String[]    _InjectButtons

Auto State PapyrusUI

; State: PapyrusUI

    Event OnMenuOpen(String MenuName)
    EndEvent

    Function ShowSingleMessageBox(String asMessage, Bool abHasHTML = False)
        String loc_msg = asMessage
        If StringUtil.GetLength(loc_msg) > 2047
            UDMain.Warning(Self + "::ShowSingleMessageBox() Message is too long to display it on a single page!")
            loc_msg = StringUtil.Substring(loc_msg, 0, 2000) + " [message is too long]"
        EndIf        
        If !abHasHTML
            _ShowMessagebox(loc_msg,"Ok", abGetIndex = true, abUseHTML = false)
        Else
            _ShowMessagebox(asMessage,"Ok", abGetIndex = true, abUseHTML = true)
        EndIf
    EndFunction

    Int Function ShowMessageBoxMenu(Message akTemplate, Float[] aafValues, String asMessageOverride, String[] aasButtonsOverride, Bool abHasHTML = False)
        Int loc_last_btn = -1
        
        If akTemplate == None
            ; TODO
            If aasButtonsOverride.Length == 0 || asMessageOverride == ""
                UDMain.Warning(Self + "::ShowMessageBoxMenu() PapyrusUI Mode: If no message template is specified, you must explicitly set the text and menu buttons!")
            EndIf
            loc_last_btn = _ShowMessageboxArray(asMessageOverride,aasButtonsOverride, abGetIndex = true,abUseHTML = abHasHTML) as Int
        Else
            loc_last_btn = _ShowMessageboxArrayTemplate(akTemplate,asMessageOverride, aafValues, aasButtonsOverride, abGetIndex = true,abUseHTML = abHasHTML) as Int
        EndIf
        
        Return loc_last_btn
    EndFunction

EndState

Function _initButtons(String[] aasButtonsOverride)
    currentMenu_button0 = aasButtonsOverride.Length > 0 && aasButtonsOverride[0] != ""
    currentMenu_button1 = aasButtonsOverride.Length > 1 && aasButtonsOverride[1] != ""
    currentMenu_button2 = aasButtonsOverride.Length > 2 && aasButtonsOverride[2] != ""
    currentMenu_button3 = aasButtonsOverride.Length > 3 && aasButtonsOverride[3] != ""
    currentMenu_button4 = aasButtonsOverride.Length > 4 && aasButtonsOverride[4] != ""
    currentMenu_button5 = aasButtonsOverride.Length > 5 && aasButtonsOverride[5] != ""
    currentMenu_button6 = aasButtonsOverride.Length > 6 && aasButtonsOverride[6] != ""
    currentMenu_button7 = aasButtonsOverride.Length > 7 && aasButtonsOverride[7] != ""
    currentMenu_button8 = aasButtonsOverride.Length > 8 && aasButtonsOverride[8] != ""
    currentMenu_button9 = aasButtonsOverride.Length > 9 && aasButtonsOverride[9] != ""
EndFunction

; get value from the array
Float Function _gv(Float[] aafValues, Int aiIndex, Float afDefault = 0.0)
    If aafValues.Length > aiIndex
        Return aafValues[aiIndex]
    Else
        Return afDefault
    EndIf
EndFunction

Int Function _showMsgWithValues(Message akMessage, Float[] vv)
    Return akMessage.Show(_gv(vv, 0), _gv(vv, 1), _gv(vv, 2), _gv(vv, 3), _gv(vv, 4), _gv(vv, 5), _gv(vv, 6), _gv(vv, 7), _gv(vv, 8))
EndFunction

; It is just a random message for loc_now.
Message Function _GetHelpMessage(Message akMessage1, Message akMessage2 = None, Message akMessage3 = None, Message akMessage4 = None, Message akMessage5 = None)
    Form[] loc_arr
    loc_arr = PapyrusUtil.PushForm(loc_arr, akMessage1)
    loc_arr = PapyrusUtil.PushForm(loc_arr, akMessage2)
    loc_arr = PapyrusUtil.PushForm(loc_arr, akMessage3)
    loc_arr = PapyrusUtil.PushForm(loc_arr, akMessage4)
    loc_arr = PapyrusUtil.PushForm(loc_arr, akMessage5)
    loc_arr = PapyrusUtil.RemoveForm(loc_arr, None)
    If loc_arr.Length < 1
        Return None
    EndIf
    Int loc_i = Utility.RandomInt(0, loc_arr.Length - 1)
    Return loc_arr[loc_i] as Message
EndFunction

String Function _GetHelpEventName(Message akMessage)
    Int loc_id = akMessage.GetFormID()
    loc_id = loc_id % (Math.Pow(16, 4) as Int)
    Return "UD_Help_" + (loc_id as String)
EndFunction

String function _ShowMessagebox(String asbodyText, String asButton1, String asButton2 = "", String asButton3 = "", String asButton4 = "", String asButton5 = "", String asButton6 = "", String asButton7 = "", String asButton8 = "", String asButton9 = "", String asButton10 = "", bool abGetIndex = false, Float afWaitInterval = 0.1, Float afTimeoutSeconds = 0.0, Bool abUseHTML = False) global
    int loc_messageBoxId = ShowNonBlocking(asbodyText, asButton1, asButton2, asButton3, asButton4, asButton5, asButton6, asButton7, asButton8, asButton9, asButton10, abUseHTML)

    ; Block and wait for the player to close the message
    Bool loc_waiting = true
    Float loc_startWaitTime = Utility.GetCurrentRealTime()
    while loc_waiting && ! IsMessageResultAvailable(loc_messageBoxId)
        Float loc_now = Utility.GetCurrentRealTime()
        Float loc_duration = loc_now - loc_startWaitTime
        if afTimeoutSeconds && loc_duration >= afTimeoutSeconds
            loc_waiting = false
        else
            Utility.WaitMenuMode(afWaitInterval)
        endIf
    endWhile

    if IsMessageResultAvailable(loc_messageBoxId)
        if abGetIndex
            return GetResultIndex(loc_messageBoxId)
        else
            return GetResultText(loc_messageBoxId)
        endIf
    else
        return "TIMED_OUT"
    endIf
endFunction

String function _ShowMessageboxArray(String asBodyText, String[] aasButtons, bool abGetIndex = false, Float afWaitInterval = 0.1, Float afTimeoutSeconds = 0.0, Bool abUseHTML = False) global
    int loc_messageBoxId = ShowArrayNonBlocking(asBodyText, aasButtons, abUseHTML)
    
    ; Block and wait for the player to close the message
    Bool loc_waiting = true
    Float loc_startWaitTime = Utility.GetCurrentRealTime()
    while loc_waiting && ! IsMessageResultAvailable(loc_messageBoxId)
        Float loc_now = Utility.GetCurrentRealTime()
        Float loc_duration = loc_now - loc_startWaitTime
        if afTimeoutSeconds && loc_duration >= afTimeoutSeconds
            loc_waiting = false
        else
            Utility.WaitMenuMode(afWaitInterval)
        endIf
    endWhile

    if IsMessageResultAvailable(loc_messageBoxId)
        if abGetIndex
            return GetResultIndex(loc_messageBoxId)
        else
            return GetResultText(loc_messageBoxId)
        endIf
    else
        return "TIMED_OUT"
    endIf
endFunction

String function _ShowMessageboxArrayTemplate(Message akTemplate,String asBodyText, Float[] aafValues, String[] asButtons, bool abGetIndex = false, Float afWaitInterval = 0.1, Float afTimeoutSeconds = 0.0, Bool abUseHTML = False) global
    int loc_messageBoxId = ShowArrayNonBlockingTemplate(akTemplate,asBodyText, aafValues, asButtons, abUseHTML)

    ; Block and wait for the player to close the message
    Bool loc_waiting = true
    Float loc_startWaitTime = Utility.GetCurrentRealTime()
    while loc_waiting && !IsMessageResultAvailable(loc_messageBoxId)
        Float loc_now = Utility.GetCurrentRealTime()
        Float loc_duration = loc_now - loc_startWaitTime
        if afTimeoutSeconds && loc_duration >= afTimeoutSeconds
            loc_waiting = false
        else
            Utility.WaitMenuMode(afWaitInterval)
        endIf
    endWhile

    if IsMessageResultAvailable(loc_messageBoxId)
        String loc_res
        if abGetIndex
            loc_res = GetResultIndex(loc_messageBoxId)
        else
            loc_res = GetResultText(loc_messageBoxId)
        endIf
        return loc_res
    else
        return "TIMED_OUT"
    endIf
endFunction