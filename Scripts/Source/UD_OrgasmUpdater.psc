Scriptname UD_OrgasmUpdater extends Quest conditional

import UnforgivingDevicesMain

UnforgivingDevicesMain              Property    UDmain              auto
UD_OrgasmManager                    Property    UDOM                auto
UD_CustomDevices_NPCSlotsManager    Property    UDNPCM              auto
Bool                                Property    Ready   = False     auto conditional

Bool _IsEnabled = True
Bool Property Enabled Hidden
    Function Set(Bool abVal)
        _IsEnabled = abVal
        if _IsEnabled
            GoToState("")
        else
            GoToState("Paused")
        endif
    EndFunction
    Bool Function Get()
        return _IsEnabled
    EndFunction
EndProperty

Int _UpdateTime = 1
Int Property UD_UpdateTime  Hidden
    Int Function Get()
        return _UpdateTime
    EndFunction
    Function Set(Int aiVal)
        _UpdateTime = aiVal
    EndFunction
EndProperty

Event OnInit()
    Ready = True
    RegisterForSingleUpdate(5.0)
EndEvent

Event OnUpdate()
    Evaluate()
    RegisterForSingleUpdate(UD_UpdateTime)
EndEvent

Function Evaluate()
    Int loc_updateTime = UD_UpdateTime
    Int loc_id = UDNPCM.GetNumAliases() - 1 ;all except player
    while loc_id
        loc_id -= 1
        UD_CustomDevice_NPCSlot loc_Slot = UDNPCM.getNPCSlotByIndex(loc_id)
        if SlotOrgasmUpdateEnabled(loc_Slot)
            UpdateArousal(loc_Slot,loc_updateTime)
        endif
    endwhile
EndFunction

Bool Function SlotOrgasmUpdateEnabled(UD_CustomDevice_NPCSlot akSlot)
    if !akSlot || !akSlot.GetActor()
        return false
    endif
    Actor   loc_actor   = akSlot.GetActor()
    Bool    loc_cond    = true
    ;loc_cond = loc_cond && loc_actor.Is3DLoaded() ;only enable update if actor 3D is loaded
    return loc_cond
EndFunction

Function UpdateArousal(UD_CustomDevice_NPCSlot akSlot,Int aiupdateTime)
    akSlot.UpdateArousal(aiupdateTime)
EndFunction

State Paused
    Event OnUpdate()
        RegisterForSingleUpdate(UD_UpdateTime*3)
    EndEvent
    Bool Function SlotOrgasmUpdateEnabled(UD_CustomDevice_NPCSlot akSlot)
        return False
    EndFunction
    Function Evaluate()
    EndFunction
EndState