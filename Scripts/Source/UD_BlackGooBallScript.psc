Scriptname UD_BlackGooBallScript Extends ObjectReference

import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto

Armor   Property UD_GooBall                 auto
Int     Property UD_Type            = 0     auto
Int     Property UD_MinDevices      = 1     auto
Int     Property UD_MaxDevices      = 5     auto


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if (akNewContainer as Actor) && (akOldContainer as Actor) ;check that ball is transfered between actors
        Actor loc_victim = akNewContainer as Actor
        Actor loc_giver  = akOldContainer as Actor
        if UDMain.ActorIsValidForUD(loc_victim)
            loc_victim.RemoveItem(UD_GooBall,1)
            if UD_Type == 0 ;abadon hand restrain
                UDmain.UDAbadonQuest.EquipAbadonDevices(loc_victim, UD_MinDevices, UD_MaxDevices)
            elseif UD_Type == 1 ;abadon suit
                UDmain.UDAbadonQuest.AbadonEquipSuit(loc_victim,UDmain.UDAbadonQuest.final_finisher_pref)
            elseif UD_Type == 2 ;purified goo
                UDmain.UDRRM.LockAnyRandomRestrain(loc_victim,Utility.RandomInt(UD_MinDevices, UD_MaxDevices))
            endif
        else
            UDmain.Error("Can't process UD_BlackGooBallScript because actor " + GetActorName(loc_victim) + " is not valid")
        endif
    endif
EndEvent