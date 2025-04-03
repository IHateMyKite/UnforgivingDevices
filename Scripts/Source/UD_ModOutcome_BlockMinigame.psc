;/  File: UD_ModOutcome_BlockMinigame
    Prohibits or allows attempts to escape for a specified time when a trigger occurs

    NameFull: Block minigame

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    String      (optional) Initial state
                                B   - mini-game is blocked
                                A   - mini-game is allowed
                            Default value: B (blocked)

        [+1]    Float       (optional) The duration of the toggled state (in hours). After the specified time has elapsed, 
                            the mini-game will be blocked if it was allowed by a trigger.
                                pos. values         - actual duration.
                                non-pos. values     - toggled state is lasted forever.
                            Default value: 0.0 (Forever)

        [+2]    Int         (optional) Repeat (used only when positive duration is set)
                            Default value: 0 (False)

        [+3]    String      (Script) Current state

        [+4]    Float       (Script) Last trigger timestamp (in game hours) (used only when positive duration is set)

    Example:
        ,,,,,,,B,4.5,1      Minigames are initially blocked. After each trigger, minigames are allowed for the next 4.5 hours.
        ,,,,,,,A            Minigames are initially allowed. After the trigger, all minigames are permanently blocked.
/;
Scriptname UD_ModOutcome_BlockMinigame extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

String Property ChangeToBlockedMessage Auto
String Property ChangeToAllowedMessage Auto

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_init = GetStringParamString(aiDataStr, DataStrOffset + 0, "B")
    Float loc_duration = MultFloat(GetStringParamFloat(aiDataStr, DataStrOffset + 1, 0.0), akModifier.MultOutputQuantities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, DataStrOffset + 2, 0) > 0
    String loc_state = GetStringParamString(aiDataStr, DataStrOffset + 3, "")
    Float loc_ts = GetStringParamFloat(aiDataStr, DataStrOffset + 4, 0.0)

    If loc_state != "" && !loc_repeat
    ; done it once already
        Return
    EndIf

    If loc_state == ""
        loc_state = loc_init
    EndIf

    If loc_state == "B"
        loc_state = "A"
    Else
        loc_state = "B"
    EndIf

    akDevice.editStringModifier(akModifier.NameAlias, DataStrOffset + 3, loc_state)
    If loc_duration > 0.0
        akDevice.editStringModifier(akModifier.NameAlias, DataStrOffset + 1, FormatFloat(Utility.GetCurrentGameTime() * 24.0, 2))
    EndIf

    ; print a message if the state has changed
    If akDevice.WearerIsPlayer()
        String loc_msg = ""
        If loc_state == "B" && StringUtil.GetLength(ChangeToBlockedMessage) > 0
            loc_msg = UDmain.UDMTF.ReplaceSubstr(ChangeToBlockedMessage, "%device%", akDevice.UD_DeviceType)
            UDmain.Print(loc_msg)
        ElseIf loc_state == "A" && StringUtil.GetLength(ChangeToAllowedMessage) > 0
            loc_msg = UDmain.UDMTF.ReplaceSubstr(ChangeToAllowedMessage, "%device%", akDevice.UD_DeviceType)
            UDmain.Print(loc_msg)
        EndIf
    EndIf
    
EndFunction

Bool Function MinigameAllowed(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    if akDevice.GetRealTimeLockedTime() > 0.5
        return true
    endif
    String loc_init = GetStringParamString(aiDataStr, DataStrOffset + 0, "B")
    Float loc_duration = MultFloat(GetStringParamFloat(aiDataStr, DataStrOffset + 1, 0.0), akModifier.MultOutputQuantities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, DataStrOffset + 2, 0) > 0
    String loc_state = GetStringParamString(aiDataStr, DataStrOffset + 3, loc_init)
    Float loc_ts = GetStringParamFloat(aiDataStr, DataStrOffset + 4, 0.0)

    Float loc_time = Utility.GetCurrentGameTime() * 24.0

    If loc_ts > 0.0 && loc_duration > 0.0 && loc_time > loc_ts + loc_duration && loc_init != loc_state
    ; toggled back to initial state by duration
        akDevice.editStringModifier(akModifier.NameAlias, DataStrOffset + 3, loc_init)
        loc_state = loc_init
    EndIf

    If loc_state == "B"
        Return False
    Else
        Return True
    EndIf

EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_init = GetStringParamString(aiDataStr, DataStrOffset + 0, "B")
    Float loc_duration = MultFloat(GetStringParamFloat(aiDataStr, DataStrOffset + 1, 0.0), akModifier.MultOutputQuantities)
    Bool loc_repeat = GetStringParamInt(aiDataStr, DataStrOffset + 2, 0) > 0
    String loc_state = GetStringParamString(aiDataStr, DataStrOffset + 3, loc_init)
    Float loc_ts = GetStringParamFloat(aiDataStr, DataStrOffset + 4, 0.0)
    Float loc_time = Utility.GetCurrentGameTime() * 24.0

    If loc_ts > 0.0 && loc_duration > 0.0 && loc_time > loc_ts + loc_duration && loc_init != loc_state
    ; toggled back to initial state by duration
        akDevice.editStringModifier(akModifier.NameAlias, DataStrOffset + 3, loc_init)
        loc_state = loc_init
    EndIf

    String loc_frag = ""
    If loc_state == "B"
        loc_frag = UDmain.UDMTF.Text("BLOCKED", asColor = UDmain.UDMTF.BoolToRainbow(False))
    Else
        loc_frag = UDmain.UDMTF.Text("ALLOWED", asColor = UDmain.UDMTF.BoolToRainbow(True))
    EndIf

    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Minigames:", loc_frag)
    If loc_init == loc_state
        loc_res += UDmain.UDMTF.TableRowDetails("Time left:", UDmain.UDMTF.Text("Until trigger", asColor = UDmain.UDMTF.BoolToRainbow(False)))
    ElseIf loc_ts > 0.0 && loc_duration > 0.0
        loc_res += UDmain.UDMTF.TableRowDetails("Time left:", UDmain.UDMTF.Text(FormatFloat(loc_ts + loc_duration - loc_time, 2) + " hours", asColor = UDmain.UDMTF.BoolToRainbow(True)))
    Else
        loc_res += UDmain.UDMTF.TableRowDetails("Time left:", UDmain.UDMTF.Text("Forever", asColor = UDmain.UDMTF.BoolToRainbow(True)))
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:", InlineIfStr(loc_repeat, "True", "False"))
    Return loc_res
EndFunction