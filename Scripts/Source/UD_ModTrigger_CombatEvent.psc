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

Bool Function ActorAction(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiActorAction, String aiDataStr)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_CombatEvent::ActorAction() akModifier = " + akModifier + ", akDevice = " + akDevice + ", aiActorAction = " + aiActorAction + ", aiDataStr = " + aiDataStr, 3)
    EndIf
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
