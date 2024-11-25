;/  File: UD_ModTrigger_CombatEvent
    It triggers on combat event
    
    NameFull: On Combat Event
    
    Parameters (DataStr):
        [0]     String  Combat event to trigger (one or several literals separated by space)
                            WS - Weapon Swing
                            SC - Spell Cast
                            SF - Spell Fire
                            VC - Voice Cast
                            VF - Voice Fire
                            BD - Bow Draw
                            BR - Bow Release
                            UB - Unsheathe Begin (doesn't fire with spells)
                            UE - Unsheathe End
                            SB - Sheathe Begin (doesn't fire with spells)
                            SE - Sheathe End

        [1]     Float   Base probability to trigger on event (in %)
                        Default value: 100.0%
                        
    Example:

/;
Scriptname UD_ModTrigger_CombatEvent extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Int Function GetEventProcessingMask()
    Return 0x00000800
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1)
    String loc_event = GetStringParamString(aiDataStr, 0, "")
    If aiActorAction == 0 && StringUtil.Find(loc_event, "WS") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 1 && StringUtil.Find(loc_event, "SC") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 2 && StringUtil.Find(loc_event, "SF") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 3 && StringUtil.Find(loc_event, "VC") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 4 && StringUtil.Find(loc_event, "VF") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 5 && StringUtil.Find(loc_event, "BD") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 6 && StringUtil.Find(loc_event, "BR") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 7 && StringUtil.Find(loc_event, "UB") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 8 && StringUtil.Find(loc_event, "UE") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 9 && StringUtil.Find(loc_event, "SB") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    If aiActorAction == 10 && StringUtil.Find(loc_event, "SE") >= 0
        Return (RandomFloat(0.0, 100.0) < GetStringParamFloat(aiDataStr, 1, 100.0))
    EndIf
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    String loc_frag = GetStringParamString(aiDataStr, 0, "")
    If UDmain.UDMTF.HasHtmlMarkup()
        loc_frag = GetCombatEventString(loc_frag, "<br/> \t")
    Else
        loc_frag = GetCombatEventString(loc_frag, ", ")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Event(s):", loc_frag)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(GetStringParamFloat(aiDataStr, 1, 100.0), 1) + "%")
    Return loc_res
EndFunction

;/  Group: Protected Methods
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetCombatEventString(String asAbbr, String asSep = ", ")
    String loc_str = ""
    Bool loc_comma = False
    If StringUtil.Find(asAbbr, "WS") >= 0
        loc_str += "Weapon Swing"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "SC") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Spell Cast"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "SF") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Spell Fire"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "VC") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Voice Cast"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "VF") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Voice Fire"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "BD") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Bow Draw"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "BR") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Bow Release"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "UB") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Unsheathe Begin"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "UD") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Unsheathe End"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "SB") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Sheathe Begin"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "SE") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Sheathe End"
        loc_comma = True
    EndIf
    Return loc_str
EndFunction