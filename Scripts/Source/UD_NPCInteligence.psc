Scriptname UD_NPCInteligence extends Quest

import UnforgivingDevicesMain

;Device priorities
; Vibrator      = 15 (40 when vibrating)
; Abadon plug   = 20 (45 when vibrating)
; Other         = 25
; Gag           = 26
; Blindfold     = 27
; Hood          = 30
; Belt          = 35
; HB            = 75

Int     Property UD_UpdateTime  = 10    auto
Int     Property UD_AICooldown  = 30    auto        ;by default 30 minutes
Bool    Property Ready          = False auto hidden

UD_CustomDevices_NPCSlotsManager    Property UDNPCM auto
UnforgivingDevicesMain              Property UDmain auto

Faction                             Property UD_AIDisableFaction auto ;NPCs in this faction will have AI disabled

;Enable variable. Can be used to disable/enable script
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

Event OnInit()
    Ready = True
    RegisterForModEvent("UDEvaluateNPCAI","EvaluateNPCAI")
    RegisterForSingleUpdate(2*UD_UpdateTime)
EndEvent

Event OnUpdate()
    Evaluate()
    RegisterForSingleUpdate(UD_UpdateTime)
EndEvent

Function Evaluate()
    EvaluateSlots(UDNPCM)
    Int loc_SSlotsNum = UDNPCM.GetNumberOfStatisSlots()
    while loc_SSlotsNum
        loc_SSlotsNum -= 1
        EvaluateSlots(UDNPCM.GetNthStaticSlots(loc_SSlotsNum))
    endwhile
EndFunction

Function EvaluateSlots(UD_CustomDevices_NPCSlotsManager akSlots)
    Int loc_id = akSlots.GetNumAliases()
    while loc_id
        loc_id -= 1
        UD_CustomDevice_NPCSlot loc_Slot = akSlots.getNPCSlotByIndex(loc_id)
        if !loc_Slot.IsPlayer()
            if SlotAIEnabled(loc_Slot)
                SendEvaluationEvent(loc_Slot)
            endif
            if loc_Slot.UD_AITimer
                loc_Slot.UD_AITimer -= 1
            endif
        endif
    endwhile
EndFunction


Bool Function SlotAIEnabled(UD_CustomDevice_NPCSlot akSlot)
    Actor loc_actor = akSlot.GetActor()
    Bool loc_cond = true
    loc_cond = loc_cond && akSlot.isUsed()                                  ;there is actor in slot
    loc_cond = loc_cond && !akSlot.UD_AITimer                               ;safety cooldown
    loc_cond = loc_cond && akSlot.getNumberOfRegisteredDevices()            ;actor needs to have at least one device
    loc_cond = loc_cond && !loc_actor.IsInCombat()                          ;actor is not in combat
    loc_cond = loc_cond && !akSlot.isInMinigame()                           ;actor is not in minigame
    loc_cond = loc_cond && !loc_actor.IsInFaction(UD_AIDisableFaction)      ;actor have no AI disabled
    loc_cond = loc_cond && EvaluateAICooldown(loc_actor)                    ;actor have passed cooldown
    loc_cond = loc_cond && !akSlot.HaveLockingOperations()                  ;actor have no locking operations
    loc_cond = loc_cond && EvaluateAIStats(loc_actor)                       ;actor have minimum stats
    ;GInfo("SlotAIEnabled("+akSlot.GetSlotedNPCName()+")")
    ;GInfo(akSlot.isUsed() + "," + !akSlot.UD_AITimer + "," + akSlot.getNumberOfRegisteredDevices() + "," + !akSlot.GetActor().IsInCombat() + "," + !akSlot.isInMinigame() + "," + EvaluateAICooldown(loc_actor) + "," + !akSlot.HaveLockingOperations() + "," + EvaluateAIStats(loc_actor))
    return loc_cond
EndFunction

Function SendEvaluationEvent(UD_CustomDevice_NPCSlot akSlot)
    Int loc_handle = ModEvent.Create("UDEvaluateNPCAI")
    if loc_handle
        ModEvent.PushForm(loc_handle, akSlot.GetActor())
        ModEvent.Send(loc_handle)
    endif
EndFunction

Event EvaluateNPCAI(Form akFormActor)
    Actor loc_actor = akFormActor as Actor
    UD_CustomDevice_NPCSlot loc_Slot = UDNPCM.getNPCSlotByActor(loc_actor)
    EvaluateSlot(loc_Slot)
EndEvent

;Main evaluate function, this is very experimental and it will need tweeking in future
Function EvaluateSlot(UD_CustomDevice_NPCSlot akSlot)
    UD_CustomDevice_RenderScript[]  loc_orderedList = GetOrderedDevicePriorityList(akSlot)
    
    Int loc_id = 0
    While loc_orderedList[loc_id] && !loc_orderedList[loc_id].EvaluateNPCAI()
        ;Failed to start minigame for top priority device, choose second top priority device, then third, etc...
        loc_id += 1
    EndWhile
    
    ;actor have tried to escape, reset cooldown
    if loc_orderedList[loc_id]
        ResetCooldown(akSlot.GetActor())
    endif
EndFunction

UD_CustomDevice_RenderScript Function GetTopPriorityDevice(UD_CustomDevice_NPCSlot akSlot, Int aiMaxPriority = 1000)
    UD_CustomDevice_RenderScript[] loc_devices = akSlot.UD_equipedCustomDevices
    UD_CustomDevice_RenderScript loc_topPriorityDevice = none
    Int loc_id = 0
    while loc_id < loc_devices.length
        UD_CustomDevice_RenderScript loc_device = loc_devices[loc_id]
        if loc_device
            Int loc_priority = loc_device.GetAiPriority()
            if loc_topPriorityDevice
                if loc_priority > loc_topPriorityDevice.GetAiPriority() && loc_priority < aiMaxPriority
                    loc_topPriorityDevice = loc_device
                endif
            elseif loc_priority < aiMaxPriority
                loc_topPriorityDevice = loc_device
            endif
            loc_id += 1
        else
            loc_id = loc_devices.length
        endif
    endwhile
    return loc_topPriorityDevice
EndFunction

UD_CustomDevice_RenderScript[] Function GetOrderedDevicePriorityList(UD_CustomDevice_NPCSlot akSlot)
    UD_CustomDevice_RenderScript[] loc_devices      = akSlot.UD_equipedCustomDevices
    UD_CustomDevice_RenderScript[] loc_orderedList  = UDmain.UDCDmain.MakeNewDeviceSlots()
    
    ;copy values
    Int loc_cid = 0
    while loc_devices[loc_cid]
        loc_orderedList[loc_cid] = loc_devices[loc_cid]
        loc_cid += 1
    endwhile
    
    ;sort algorithm. Something like Bubble sort, but worse
    Bool    loc_ordered = False
    while !loc_ordered
        loc_ordered = True
        Int     loc_id      = 0
        while loc_id < loc_orderedList.length - 1
            UD_CustomDevice_RenderScript loc_device     = loc_orderedList[loc_id]
            UD_CustomDevice_RenderScript loc_deviceNext = loc_orderedList[loc_id + 1]
            if loc_device && loc_deviceNext
                if loc_device.GetAiPriority() < loc_deviceNext.GetAiPriority()
                    loc_orderedList[loc_id]     = loc_deviceNext
                    loc_orderedList[loc_id + 1] = loc_device
                    loc_ordered = False
                else
                    loc_orderedList[loc_id]     = loc_device
                    loc_orderedList[loc_id + 1] = loc_deviceNext
                endif
                loc_id += 1
            elseif !loc_device && loc_deviceNext
                loc_orderedList[loc_id]     = loc_deviceNext
                loc_orderedList[loc_id + 1] = none
                loc_ordered = False
                loc_id += 1
            else
                loc_id = loc_orderedList.length
            endif
        endwhile
    endwhile
    return loc_orderedList
EndFunction

;returns next time on which NPC can again try to struggle
Float Function GetAICooldown(Actor akActor) Global
    return StorageUtil.GetFloatValue(akActor,"UDAICooldown",0)
EndFunction

Function ResetCooldown(Actor akActor)
    Float loc_time = Utility.GetCurrentGameTime()
    Int loc_motivation = GetMotivation(akActor)
    Float loc_nextTime = loc_time
    if loc_motivation > 0
        loc_nextTime = loc_time + ConvertTime(0,UD_AICooldown)*100.0/loc_motivation
    else
        loc_nextTime = 0.0 ;no motivation -> never try
    endif
    StorageUtil.SetFloatValue(akActor,"UDAICooldown",loc_nextTime)
EndFunction

;returns true if cooldown have passed
Bool Function EvaluateAICooldown(Actor akActor) Global
    return (GetAICooldown(akActor) < Utility.GetCurrentGameTime())
EndFunction

;checks npc stats
Bool Function EvaluateAIStats(Actor akActor) Global
    Bool loc_res = True
    if akActor.Is3DLoaded() ;check if actor is loaded, for some rewason, some NPC don't have their stats updated when unloaded and some does
        ;actor is loaded, check stats
        loc_res = loc_res && (getCurrentActorValuePerc(akActor,"Stamina") > 0.9) ;check that actors stamina is at least 90%
    else
        ;actor is not loaded, so just refill the stats (assuming they can't regen them) and call it a day
        akActor.RestoreAV("Health",1000)
        akActor.RestoreAV("Stamina",1000)
        akActor.RestoreAV("Magicka",1000)
    endif
    return loc_res
EndFunction

;returns remaining cooldown in minutes
Int Function GetAIRemainingCooldown(Actor akActor) Global
    return Round((GetAICooldown(akActor) - Utility.GetCurrentGameTime())*24*60)
EndFunction

;returns actor motivation to escape the device
;0 = zero motivation -> actor will not try to escape the devices
;100 = default motivation -> Actor will try to escape every 30 minutes
;200 = default motivation -> Actor will try to escape 2x faster (15 minutes), etc...
Int Function GetMotivation(Actor akActor) Global
    return StorageUtil.GetIntValue(akActor,"UDAIMotivation",100) ;by default 100 motivation 
EndFunction
Function SetMotivation(Actor akActor, Int aiValue) Global
    StorageUtil.SetIntValue(akActor,"UDAIMotivation",iRange(aiValue,0,500))
EndFunction
Function UpdateMotivation(Actor akActor, Int aiValue, Bool aiAllowUnder = false) Global
    Int loc_motivationOld = GetMotivation(akActor)
    Int loc_motivationNew = loc_motivationOld + aiValue
    if aiAllowUnder
        loc_motivationNew = iRange(loc_motivationNew,0,500)
    else
        loc_motivationNew = iRange(loc_motivationNew,100,500)
    endif
    StorageUtil.SetIntValue(akActor,"UDAIMotivation",loc_motivationNew)
EndFunction
;Update motivation by aiDValue to decrease difference to default 100
Function UpdateMotivationToDef(Actor akActor, Int aiDValue) Global
    Int loc_dVal = iAbs(aiDValue)
    Int loc_motivationOld = GetMotivation(akActor)
    Int loc_motivationNew = loc_motivationOld
    if loc_motivationOld > 100
        loc_motivationNew = iRange(loc_motivationNew - loc_dVal,100,500)
    elseif loc_motivationOld < 100
        loc_motivationNew = iRange(loc_motivationNew + loc_dVal,0,100)
    endif
    StorageUtil.SetIntValue(akActor,"UDAIMotivation",loc_motivationNew)
EndFunction

State Paused
    Event OnUpdate()
        RegisterForSingleUpdate(3*UD_UpdateTime)
    EndEvent
    Function Evaluate()
    EndFunction
EndState

State Disabled
    Event OnUpdate()
        RegisterForSingleUpdate(3*UD_UpdateTime)
    EndEvent
    Function Evaluate()
    EndFunction
EndState