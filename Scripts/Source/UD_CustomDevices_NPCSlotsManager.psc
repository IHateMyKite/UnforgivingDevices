Scriptname UD_CustomDevices_NPCSlotsManager extends Quest  

import UnforgivingDevicesMain

UDCustomDeviceMain      Property UDCDmain                               auto
UnforgivingDevicesMain  Property UDmain                     hidden
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
EndProperty

Float                   Property UD_SlotScanUpdateTime      Hidden
    Float Function get()
        return UDmain.UDGV.UDG_NPCScanUpT.Value
    EndFunction
EndProperty
Float                   Property UD_HeavySlotUpdateTime     Hidden
    Float Function get()
        return UDmain.UDGV.UDG_NPCHeavyUpT.Value
    EndFunction
EndProperty

Quest               Property UDCD_NPCF                                  auto ;finder
zadlibs             Property libs                                       auto
UD_OrgasmManager    Property UDOM                                       auto
Message             Property UD_FixMenu_MSG                             auto
Int                 Property UD_Slots                       = 10        auto
Float               Property UD_SlotUpdateTime              = 10.0      auto
Bool                Property Ready                          = False     auto

Bool                         _PlayerSlotReady               = false
Float                        _LastUpdateTime                = 0.0
Float                        _UpdateTimePassed              = 0.0
Float                        _UpdateTimePassed2             = 0.0
float                        LastUpdateTime_Hour            = 0.0 ;last time the update happened in days
Form[]                       _ScanInCompatibilityFactions

Event OnInit()
    Utility.wait(0.1)
    UD_Slots = GetNumAliases()
    int index = 0
    while index < UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        while !loc_slot.ready
            Utility.wait(0.1)
        endwhile
        if UDmain.TraceAllowed()
            UDCDMain.Log("NPCslot["+ index +"] ready!")
        endif
        index += 1
        Utility.wait(0.1)
    endwhile
    registerForSingleUpdate(10.0)
    Ready = True
EndEvent

Function GameUpdate()
    CheckOrgasmLoops()
    RegisterForSingleUpdate(UDCDmain.UD_UpdateTime*2.0)
    registerForSingleUpdateGameTime(1.0)
EndFunction

Function CheckOrgasmLoops()
    int index = UD_Slots ;all aliases
    while index
        index -= 1
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if loc_slot
            if loc_slot.isUsed() && !loc_slot.isDead()
                UDOM.CheckArousalCheck(loc_slot.getActor())
                UDOM.CheckOrgasmCheck(loc_slot.getActor())
            endif
        endif
    endwhile
EndFunction

Event OnUpdate()
    ;init player slot
    if !_PlayerSlotReady
        _PlayerSlotReady = True
        initPlayerSlot()
    endif
    
    if UDmain.UDReady()
        if !UDmain.UD_DisableUpdate
            float loc_timePassed = Utility.GetCurrentGameTime() - _LastUpdateTime
            UpdateDevices(loc_timePassed)
            _LastUpdateTime = Utility.GetCurrentGameTime()
            if UDmain.AllowNPCSupport
                _UpdateTimePassed2 += UDCDmain.UD_UpdateTime
                if _UpdateTimePassed2 >= UD_SlotScanUpdateTime
                     scanSlots()
                     UndressSlots()
                    _UpdateTimePassed2 = 0.0
                endif
            endif
        endif
        removeDeadNPCs()
        _UpdateTimePassed += UDCDmain.UD_UpdateTime
        if _UpdateTimePassed >= UD_HeavySlotUpdateTime
            CheckOrgasmLoops()
            UpdateSlots() ;update slots, this only update variables, not devices
            _UpdateTimePassed = 0.0
        endif
    endif
    RegisterForSingleUpdate(UDCDmain.UD_UpdateTime)
EndEvent

Event OnUpdateGameTime()
    if UDmain.UDReady()
        if !UDmain.UD_DisableUpdate
            Utility.wait(Utility.randomFloat(2.0,4.0))
            float currentgametime = Utility.GetCurrentGameTime()
            float mult = 24.0*(currentgametime - LastUpdateTime_Hour) ;multiplier for how much more then 1 hour have passed, ex: for 2.5 hours passed without update, the mult will be 2.5
            UpdateSlotsHour(mult)
            UpdateDevicesHour(mult)
            LastUpdateTime_Hour = Utility.GetCurrentGameTime()
        endif
    endif
    registerForSingleUpdateGameTime(1.0)
endEvent

Function UpdateSlots()
    int index = UD_Slots ;all aliases
    while index
        index -= 1
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        UpdateSlot(loc_slot)
    endwhile
EndFunction

Function UndressSlots()
    int index = UD_Slots ;all aliases
    while index
        index -= 1
        UD_CustomDevice_NPCSlot loc_slot    = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        Actor                   loc_actor   = none
        if loc_slot
            loc_actor = loc_slot.GetActor()
            if loc_actor && loc_actor.Is3DLoaded() && !loc_slot.hasFreeHands() && !UDmain.ActorIsPlayer(loc_actor) && !UDmain.ActorIsFollower(loc_actor)
                libs.strip(loc_slot.GetActor(),false)
            endif
        endif
    endwhile
EndFunction

Function UpdateSlot(UD_CustomDevice_NPCSlot akSlot)
    if akSlot.isUsed()
        if !akSlot.isDead()
            akSlot.UpdateSlot()
        endif
    endif
EndFunction

;bool _updating = false
bool Function scanSlots(bool debugMsg = False)
    UDCD_NPCF.Stop()
    Utility.wait(0.25)
    UDCD_NPCF.Start()
    Utility.wait(0.25)

    updateSlotedActors(debugMsg)
    return true
EndFunction

Function CheckSlots()
    int index = UD_Slots - 1 ;all aliases, excluding player
    while index
        index -= 1
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if loc_slot
            if loc_slot.isUsed()
                loc_slot.QuickFix()
            endif
        endif
    endwhile
EndFunction

Function resetNPCFSlots()
    int index = UDCD_NPCF.GetNumAliases() - 1 ;all aliases, excluding player
    while index
        index -= 1
        ReferenceAlias loc_refAl = (UDCD_NPCF.GetNthAlias(index) as ReferenceAlias)
        if loc_refAl.getActorReference()
            Actor loc_akActor = loc_refAl.getActorReference()
            if !isInPlayerCell(loc_akActor) && !StorageUtil.GetIntValue(loc_akActor, "UD_GlobalUpdate" , 0)
                loc_refAl.clear()
            endif
        endif
    endwhile
EndFunction

Function FreeUnusedSlots()
    int index = 0 
    while index < GetNumAliases() - 1 ;all aliases, excluding player
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if loc_slot && loc_slot.getActor() && !StorageUtil.GetIntValue(loc_slot.getActor(), "UD_ManualRegister", 0)
            int index2 = 0
            bool loc_found = false
            while (index2 < UDCD_NPCF.GetNumAliases() - 1) && !loc_found
                ReferenceAlias loc_refAl = (UDCD_NPCF.GetNthAlias(index2) as ReferenceAlias)
                if loc_refAl.getActorReference() == loc_slot.GetActor()
                    loc_found = true
                endif
                index2 += 1
            endwhile
            if !loc_found
                loc_slot.GetActor().RemoveFromFaction(UDCDmain.RegisteredNPCFaction)
                loc_slot.unregisterSlot()
                ;GInfo("Removed unused slot " + loc_slot.getSlotedNPCName())
            endif
        endif
        index += 1
    endwhile
EndFunction

bool Function isInPlayerCell(Actor akActor)
    if UDmain.Player.getParentCell() == akActor.getParentCell()
        return true
    else
        return false
    endif
EndFunction

Function initPlayerSlot()
    getPlayerSlot().ForceRefTo(UDmain.Player)
    UDOM.CheckOrgasmCheck(UDmain.Player)
    UDOM.CheckArousalCheck(UDmain.Player)
    if UDmain.TraceAllowed()    
        UDCDMain.Log("PlayerSlot ready!")
    endif
EndFunction

Function removeDeadNPCs()
    int index = UD_Slots - 1 ;all aliases, excluding player
    while index
        index -= 1
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if loc_slot.isUsed()
            if loc_slot.isDead()
                unregisterNPC(loc_slot.getActor())
            endif
        endif
    endwhile
EndFunction

Function updateSlotedActors(bool debugMsg = False)
    int index = 0
    int loc_aliases = UDCD_NPCF.GetNumAliases() - 1 ;all slots excluding player
    int mover = 0
    GoToState("UpdatePaused")
    while index < loc_aliases
        ReferenceAlias loc_finderSlot = (UDCD_NPCF.GetNthAlias(index + mover) as ReferenceAlias)
        ObjectReference loc_ref = loc_finderSlot.GetReference()
        Actor currentSelectedActor = loc_ref as Actor
        if currentSelectedActor
            if !isRegistered(currentSelectedActor) && !StorageUtil.GetIntValue(currentSelectedActor,"UDLockOperations",0) && AdditionalScanCheck(currentSelectedActor);do not register already registered actors or actor which currently have active lock operations
                if !StorageUtil.GetIntValue(currentSelectedActor, "UD_blockSlotUpdate", 0)
                    UD_CustomDevice_NPCSlot slot = GetNthAlias(index) as UD_CustomDevice_NPCSlot
                    Actor currentSlotActor = slot.getActor()
                    if StorageUtil.GetIntValue(currentSlotActor, "UD_ManualRegister", 0)
                        mover -= 1
                    else
                        if currentSlotActor
                            if currentSelectedActor != currentSlotActor
                                currentSlotActor.RemoveFromFaction(UDCDmain.RegisteredNPCFaction)
                                slot.unregisterSlot()
                                slot.SetSlotTo(currentSelectedActor)
                                if debugMsg || UDmain.DebugMod
                                    debug.notification("[UD]: NPC /" + slot.getSlotedNPCName() + "/ registered!")
                                endif
                                UDmain.Info("Registered NPC " + getActorName(currentSelectedActor))
                            endif
                        else
                            slot.unregisterSlot()
                            slot.SetSlotTo(currentSelectedActor)
                            if debugMsg || UDmain.DebugMod
                                debug.notification("[UD]: NPC /" + slot.getSlotedNPCName() + "/ registered!")
                            endif
                            UDmain.Info("Registered NPC " + getActorName(currentSelectedActor))
                        endif
                    endif
                endif
            endif
        endif
        index += 1
    endwhile
    
    ;remove unfinded NPCs
    FreeUnusedSlots()
    
    GoToState("")
EndFunction

Function AddScanIncompatibleFaction(Faction akFaction)
    if akFaction
        _ScanInCompatibilityFactions = PapyrusUtil.PushForm(_ScanInCompatibilityFactions, akFaction)
        ;GInfo("Added " + akFaction + " to incompatible NPC factions")
    endif
EndFunction

Function ResetIncompatibleFactionArray()
    _ScanInCompatibilityFactions = Utility.CreateFormArray(0)
EndFunction

;Compatibility check
Bool Function AdditionalScanCheck(Actor akActor)
    Bool loc_res = True
    
    if _ScanInCompatibilityFactions
        Int loc_id = _ScanInCompatibilityFactions.length
        while loc_id
            loc_id -= 1
            Faction loc_faction = _ScanInCompatibilityFactions[loc_id] as Faction
            if loc_faction
                loc_res = loc_res && !akActor.IsInFaction(loc_faction)
            endif
        endwhile
    endif
    return loc_res
EndFunction

bool Function RegisterNPC(Actor akActor,bool debugMsg = false)
    Actor currentSelectedActor = akActor
    
    if !currentSelectedActor
        UDmain.Error("RegisterNPC - none actor passed!")
        return false
    endif
    
    if isRegistered(akActor)
        UDmain.Error("RegisterNPC - " + GetActorName(akActor) + " is already registered!")
        return false
    endif
    
    if !StorageUtil.GetIntValue(currentSelectedActor, "UD_blockSlotUpdate", 0)
        int index = 0
        while index < UD_Slots - 1
                UD_CustomDevice_NPCSlot slot = GetNthAlias(index) as UD_CustomDevice_NPCSlot
                Actor currentSlotActor = slot.getActor()
                if !currentSlotActor
                    slot.unregisterSlot()
                    slot.GoToState("UpdatePaused")
                    slot.SetSlotTo(currentSelectedActor)
                    StorageUtil.SetIntValue(currentSelectedActor, "UD_ManualRegister", 1)
                    if debugMsg || UDCDmain.UDmain.DebugMod
                        UDmain.Print("NPC slot ["+ index +"] => " + slot.getSlotedNPCName() + " registered!",0)
                    endif
                    UDmain.Info(GetActorName(akActor) + " registered!")
                    slot.GoToState("")
                    return true
                endif
            index += 1
        endwhile
    else
        UDmain.Print(GetActorName(akActor) + " can't be currently registered!",0)
        return false
    endif
    UDmain.Error("RegisterNPC - Can't find free slot for " + GetActorName(akActor) + " !")
    return false
EndFunction

Function regainDeviceSlots(Form akActor, int slotID,String sSlotedActorName)
    getNPCSlotByIndex(slotID).regainDevices()
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByActor(Actor akActor)
    if akActor == UDmain.Player
        return getPlayerSlot()
    endif
    int index = UD_Slots
    while index
        index -= 1
        if (GetNthAlias(index) as ReferenceAlias).GetActorReference() == akActor
            return GetNthAlias(index) as UD_CustomDevice_NPCSlot
        endif
    endwhile
    return none
EndFunction

int Function getPlayerIndex()
    return UD_Slots - 1
EndFunction

int Function getNumSlots()
    return UD_Slots
EndFunction

bool Function isRegistered(Actor akActor)
    return akActor.isInFaction(UDCDmain.RegisteredNPCFaction)
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByName(string sName)
    return GetAliasByName(sName) as UD_CustomDevice_NPCSlot
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByActorName(string sName)
    if sName == UDmain.Player.getLeveledActorBase().getName()
        return getPlayerSlot()
    endif
    int index = UD_Slots
    while index
        index -= 1
        UD_CustomDevice_NPCSlot slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if slot.isUsed()
            if slot.getSlotedNPCName() == sName
                return slot
            endif
        endif
    endwhile
    return none
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByIndex(int iIndex)
    return GetNthAlias(iIndex) as UD_CustomDevice_NPCSlot
EndFunction

UD_CustomDevice_NPCSlot Function getPlayerSlot()
    return GetNthAlias(UD_Slots - 1) as UD_CustomDevice_NPCSlot
EndFunction

Function UpdateDevices(float fTimePassed)
    int index = 0
    while index < UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if loc_slot
            UpdateSlotDevices(loc_slot,fTimePassed)
        endif
        index += 1
        Utility.waitMenuMode(0.1)
    endwhile
EndFunction

Function UpdateSlotDevices(UD_CustomDevice_NPCSlot akSlot, Float afTimePassed)
    if akSlot.isScriptRunning() && akSlot.isUsed() && akSlot.canUpdate()
        akSlot.update(afTimePassed)
    endif
EndFunction

Function UpdateDevicesHour(float fMult)
    int index = UD_Slots
    while index
        index -= 1
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if loc_slot.isScriptRunning() && loc_slot.isUsed() && loc_slot.canUpdate()
            loc_slot.updateDeviceHour(fMult)
        endif
        Utility.waitMenuMode(0.1)
    endwhile
EndFunction

Function UpdateSlotsHour(float fMult)
    int index = UD_Slots
    while index
        index -= 1
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if loc_slot.isUsed()
            loc_slot.updateHour(fMult)
        endif
        Utility.waitMenuMode(0.1)
    endwhile
EndFunction

bool Function NPCAlreadyRegistred(Actor akActor)
    return akActor.isInFaction(UDCDmain.RegisteredNPCFaction)
EndFunction

int Function numberOfFreeSlots()
    int res = 0
    int index = UD_Slots
    while index
        index -= 1
        if !((GetNthAlias(index) as UD_CustomDevice_NPCSlot).GetActorReference()) && !(GetNthAlias(index) as UD_CustomDevice_NPCSlot).isPlayer()
            res += 1
        endif
    endwhile
    return res
EndFunction

bool Function unregisterNPC(Actor akActor,bool bDebugMsg = false)
    if !isRegistered(akActor)
        return false
    endif
    int index = UD_Slots - 1
    while index
        index -= 1
        UD_CustomDevice_NPCSlot slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        Actor loc_slotedNPC = slot.getActor()
        if loc_slotedNPC == akActor
            slot.unregisterSlot()
            StorageUtil.UnSetIntValue(loc_slotedNPC, "UD_blockSlotUpdate")
            akActor.RemoveFromFaction(UDCDmain.RegisteredNPCFaction)
            if bDebugMsg || UDCDmain.UDmain.DebugMod
                debug.notification("[UD]: NPC slot ["+ index +"] = " + getActorName(loc_slotedNPC) + " =>  unregistered!")
            endif
            return True
        endif
        Utility.waitMenuMode(0.1)
    endwhile
    return False
EndFunction

State UpdatePaused
    Function UpdateSlots()
    EndFunction
    Event OnUpdate()
        RegisterForSingleUpdate(UDCDmain.UD_UpdateTime/2)
    EndEvent
    Function UpdateSlot(UD_CustomDevice_NPCSlot akSlot)
    EndFunction
    Function UpdateDevices(float fTimePassed)
    EndFunction
    Function UpdateSlotDevices(UD_CustomDevice_NPCSlot akSlot, Float afTimePassed)
    EndFunction
EndState
