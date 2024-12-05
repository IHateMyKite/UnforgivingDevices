;/  File: UD_ModOutcome_BlockMinigame
    Blocks the mini-game until a trigger is triggered

    NameFull: Block mini-game

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    String      (optional) Initial state
                                B   BLOCKED     - mini-game is blocked
                                A   ALLOWED     - mini-game is allowed
                            Default value: BLOCKED

        [+1]    Int         (optional) Toggle the switch on each trigger or do it once
                            Default value: 0 (False)

        [+2]    String      (Script) Current state

    Example:
/;
Scriptname UD_ModOutcome_BlockMinigame extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    String loc_init = GetStringParamString(aiDataStr, DataStrOffset + 0, "B")
    String loc_state = GetStringParamString(aiDataStr, DataStrOffset + 2, "")
    Bool loc_redo = GetStringParamInt(aiDataStr, DataStrOffset + 1, 0) > 0

    If loc_state != "" && !loc_redo
    ; done it once already
        Return
    EndIf

    If loc_state == ""
        loc_state = loc_init
    EndIf

    If loc_state == "B" || loc_state == "BLOCKED"
        loc_state = "A"
    Else
        loc_state = "B"
    EndIf

    akDevice.editStringModifier(akModifier.NameAlias, DataStrOffset + 2, loc_state)
EndFunction

Bool Function MinigameAllowed(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5)
    String loc_init = GetStringParamString(aiDataStr, DataStrOffset + 0, "B")
    String loc_state = GetStringParamString(aiDataStr, DataStrOffset + 2, loc_init)
    If loc_state == "B" || loc_state == "BLOCKED"
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
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm4, Form akForm5 = None)
    String loc_init = GetStringParamString(aiDataStr, DataStrOffset + 0, "B")
    String loc_state = GetStringParamString(aiDataStr, DataStrOffset + 2, loc_init)
    Bool loc_redo = GetStringParamInt(aiDataStr, DataStrOffset + 1, 0) > 0

    String loc_frag = ""
    If loc_state == "B" || loc_state == "BLOCKED"
        loc_frag = UDmain.UDMTF.Text("BLOCKED", asColor = UDmain.UDMTF.BoolToRainbow(False))
    Else
        loc_frag = UDmain.UDMTF.Text("ALLOWED", asColor = UDmain.UDMTF.BoolToRainbow(True))
    EndIf

    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Mini-games state:", loc_frag)
    loc_res += UDmain.UDMTF.TableRowDetails("Redo switch:", InlineIfStr(loc_redo, "True", "False"))
    Return loc_res
EndFunction