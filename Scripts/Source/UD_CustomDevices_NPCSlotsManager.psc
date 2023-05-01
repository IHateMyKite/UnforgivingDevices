Scriptname UD_CustomDevices_NPCSlotsManager extends Quest

import UnforgivingDevicesMain

String Property SLOTSNAME = "Error" auto

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
UD_OrgasmManager    Property UDOM                                       auto
Message             Property UD_FixMenu_MSG                             auto
Int                 Property UD_Slots                       = 15        auto hidden
Float               Property UD_SlotUpdateTime              = 10.0      auto hidden
Bool                Property Ready                          = False     auto hidden

Bool                         _PlayerSlotReady               = false
Float                        _LastUpdateTime                = 0.0
Float                        _UpdateTimePassed              = 0.0
Float                        _UpdateTimePassed2             = 0.0
float                        LastUpdateTime_Hour            = 0.0 ;last time the update happened in days
Form[]                       _ScanInCompatibilityFactions

;Static slots used by quests
Form[] _StaticSlots

Bool Function IsManager()
    return True
EndFunction

Bool _StaticSlotMutex = False

Function AddStaticSlot(UD_StaticNPCSlots akSlots)
    while _StaticSlotMutex
        Utility.waitMenuMode(0.1)
    endwhile
    _StaticSlotMutex = True
    _StaticSlots = PapyrusUtil.PushForm(_StaticSlots,akSlots)
    UDMain.Info(self + "::AddStaticSlot() - Static slot added = " + akSlots + ", Total number of slots = " + _StaticSlots.length)
    _StaticSlotMutex = False
EndFunction

Function RemoveStaticSlot(UD_StaticNPCSlots akSlots)
    while _StaticSlotMutex
        Utility.waitMenuMode(0.1)
    endwhile
    _StaticSlotMutex = True
    _StaticSlots = PapyrusUtil.RemoveForm(_StaticSlots,akSlots)
    _StaticSlotMutex = False
EndFunction

Function ResetStaticSlots()
    _StaticSlots = Utility.CreateFormArray(0)
EndFunction

Function RegisterStaticEvents()
EndFunction

Function UnRegisterStaticEvents()
EndFunction

Function ReregisterStaticSlots()
    ResetStaticSlots()
    int handle = ModEvent.Create("UDRegisterStaticSlots")
    if (handle)
        ModEvent.Send(handle)
    endif
    Utility.waitMenuMode(3.0) ;wait some time for all slots to be installed
EndFunction

Int Function GetNumberOfStatisSlots()
    return _StaticSlots.length
EndFunction

UD_StaticNPCSlots Function GetStaticSlots(String asName)
    if IsManager()
        Int loc_slotsnum = _StaticSlots.length
        Int loc_y = 0
        while loc_y < loc_slotsnum
            UD_StaticNPCSlots loc_slots = _StaticSlots[loc_y] as UD_StaticNPCSlots
            if loc_slots.SLOTSNAME == asName
                return loc_slots
            endif
            loc_y += 1
        endwhile
    endif
    return none
EndFunction

UD_StaticNPCSlots Function GetNthStaticSlots(Int aiId)
    if IsManager()
        return _StaticSlots[aiId] as UD_StaticNPCSlots
    endif
    return none
EndFunction

Event OnInit()
    UD_Slots = GetNumAliases()
    int     index = 0
    float   loc_time = 0.0
    UD_CustomDevice_NPCSlot loc_slot = none
    while index < UD_Slots
        loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if loc_slot
            loc_time = 0.0
            while !loc_slot.ready && loc_time < 1.5
                Utility.WaitMenuMode(0.5)
                loc_time += 0.5
            endwhile
            if loc_time >= 1.5
                GError(self + "::OnInit() - NPCslot["+ index +"] - ERROR initializing npc slot!")
            endif
        else
            GError(self + "::OnInit() - NPCslot["+ index +"] - alias is recognized as NPC slot!")
        endif
        index += 1
        Utility.WaitMenuMode(0.05)
    endwhile
    registerForSingleUpdate(10.0)
    Ready = True
EndEvent

Function GameUpdate()
    ; === Check player slot ===
    UD_CustomDevice_NPCSlot loc_playerslot = GetPlayerSlot()
    ;Player is not swet to reference, set it and init it
    if loc_playerslot.GetActor() != UDmain.Player
        loc_playerslot.ForceRefTo(UDmain.Player)
        loc_playerslot.OnInit()
    endif
    ; ==== check static slots ====
    if IsManager()
        ReregisterStaticSlots()
        Int loc_slotsnum = _StaticSlots.length
        Int loc_y = 0
        while loc_y < loc_slotsnum
            UD_StaticNPCSlots loc_slots = _StaticSlots[loc_y] as UD_StaticNPCSlots
            loc_slots.GameUpdate()
            loc_y += 1
        endwhile
    endif
    UD_Slots = GetNumAliases()
    SlotGameUpdate()
    CheckOrgasmLoops()
    RegisterForSingleUpdate(10.0)
    registerForSingleUpdateGameTime(1.0)
EndFunction

Function SlotGameUpdate()
    int index = 0
    while index < UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        loc_slot.GameUpdate()
        index += 1
    endwhile
EndFunction

Function CheckOrgasmLoops()
    if IsManager()
        UD_CustomDevice_NPCSlot loc_slot = GetPlayerSlot()
        UDOM.CheckArousalCheck(loc_slot.getActor())
        UDOM.CheckOrgasmCheck(loc_slot.getActor())
    endif
EndFunction

Event OnUpdate()
    ;init player slot
    if IsManager() && !_PlayerSlotReady
        _PlayerSlotReady = True
        initPlayerSlot()
    endif
    
    if UDmain.UDReady()
        if !UDmain.UD_DisableUpdate
            float loc_timePassed = Utility.GetCurrentGameTime() - _LastUpdateTime
            UpdateDevices(loc_timePassed)
            _LastUpdateTime = Utility.GetCurrentGameTime()
            _UpdateTimePassed2 += UDCDmain.UD_UpdateTime
            if _UpdateTimePassed2 >= UD_SlotScanUpdateTime
                if IsManager() && UDmain.AllowNPCSupport
                    scanSlots()
                endif
                UndressSlots()
                _UpdateTimePassed2 = 0.0
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
    Bool loc_NPC        = UDmain.UDGV.UDG_UndressNPC.Value
    Bool loc_Follower   = UDmain.UDGV.UDG_UndressFollower.Value
    int index = UD_Slots ;all aliases
    while index
        index -= 1
        UD_CustomDevice_NPCSlot loc_slot    = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        Actor                   loc_actor   = none
        if loc_slot
            loc_actor = loc_slot.GetActor()
            if loc_actor && loc_actor.Is3DLoaded() && !loc_slot.hasFreeHands() && !UDmain.ActorIsPlayer(loc_actor) && ((loc_Follower && UDmain.ActorIsFollower(loc_actor)) || (loc_NPC && !UDmain.ActorIsFollower(loc_actor)))
                UDCDmain.UndressAllArmor(loc_actor)
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
    if IsManager()
        UDCD_NPCF.Stop()
        Utility.wait(0.25)
        UDCD_NPCF.Start()
        Utility.wait(0.25)

        updateSlotedActors(debugMsg)
    endif
    return true
EndFunction

Function FreeUnusedSlots()
    int index = 0
    Int loc_Size1 = GetNumAliases() - 1
    Int loc_Size2 = UDCD_NPCF.GetNumAliases()
    while index < loc_Size1 ;all aliases, excluding player
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        Actor loc_actor = loc_slot.GetActor()
        if loc_slot.IsUsed() && !StorageUtil.GetIntValue(loc_actor, "UD_ManualRegister", 0)
            ;try to find actor in finder. If actor is not present, it means it is not in range or out of the cell
            int  index2 = 0
            bool loc_found = false
            while !loc_found && (index2 < loc_Size2)
                ReferenceAlias loc_refAl = (UDCD_NPCF.GetNthAlias(index2) as ReferenceAlias)
                if loc_refAl.getActorReference() == loc_actor
                    loc_found = true
                endif
                index2 += 1
            endwhile
            
            ;unregister NPC if it was not found
            if !loc_found && !loc_slot.IsBlocked()
                loc_actor.RemoveFromFaction(UDCDmain.RegisteredNPCFaction)
                loc_slot.unregisterSlot()
            endif
        endif
        index += 1
    endwhile
EndFunction

Function initPlayerSlot()
    if IsManager()
        getPlayerSlot().ForceRefTo(UDmain.Player)
        UDOM.CheckOrgasmCheck(UDmain.Player)
        UDOM.CheckArousalCheck(UDmain.Player)
        if UDmain.TraceAllowed()    
            UDmain.Log("PlayerSlot ready!")
        endif
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
                    if StorageUtil.GetIntValue(currentSlotActor, "UD_ManualRegister", 0) || slot.IsBlocked()
                        mover -= 1
                    else
                        if currentSlotActor
                            if currentSelectedActor != currentSlotActor
                                slot.GoToState("UpdatePaused")
                                currentSlotActor.RemoveFromFaction(UDCDmain.RegisteredNPCFaction)
                                slot.unregisterSlot()
                                slot.SetSlotTo(currentSelectedActor)
                                if debugMsg || UDmain.DebugMod
                                    debug.notification("[UD]: NPC /" + slot.getSlotedNPCName() + "/ registered!")
                                endif
                                UDmain.Info("Registered NPC " + getActorName(currentSelectedActor))
                                slot.GoToState("")
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
    if IsManager() && akFaction
        _ScanInCompatibilityFactions = PapyrusUtil.PushForm(_ScanInCompatibilityFactions, akFaction)
    endif
EndFunction

Function ResetIncompatibleFactionArray()
    if IsManager()
        _ScanInCompatibilityFactions = Utility.CreateFormArray(0)
    endif
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
    if IsManager() && akActor == UDmain.Player
        return getPlayerSlot()
    endif
    int index = UD_Slots
    while index
        index -= 1
        if (GetNthAlias(index) as ReferenceAlias).GetActorReference() == akActor
            return GetNthAlias(index) as UD_CustomDevice_NPCSlot
        endif
    endwhile
    ; ==== check static slots ====
    if IsManager()
        Int loc_slotsnum = _StaticSlots.length
        Int loc_y = 0
        while loc_y < loc_slotsnum
            UD_StaticNPCSlots loc_slots = _StaticSlots[loc_y] as UD_StaticNPCSlots
            int loc_x = loc_slots.UD_Slots
            while loc_x
                loc_x -= 1
                UD_CustomDevice_NPCSlot loc_slot = loc_slots.GetNthAlias(loc_x) as UD_CustomDevice_NPCSlot
                if loc_slot && loc_slot.GetActor() == akActor
                    return loc_slot
                endif
            endwhile
            loc_y += 1
        endwhile
    endif
    return none
EndFunction

;get index of player slot, or -1 if it doesn't exist
int Function getPlayerIndex()
    if IsManager()
        return UD_Slots - 1
    else
        return -1
    endif
EndFunction

;returns number of slots
int Function getNumSlots()
    return UD_Slots
EndFunction

bool Function isRegistered(Actor akActor)
    return akActor.isInFaction(UDCDmain.RegisteredNPCFaction)
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByName(string sName)
    return GetAliasByName(sName) as UD_CustomDevice_NPCSlot
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByActorName(string asName)
    if IsManager() && asName == UDmain.Player.getLeveledActorBase().getName()
        return getPlayerSlot()
    endif
    int index = UD_Slots
    while index
        index -= 1
        UD_CustomDevice_NPCSlot slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if slot.isUsed()
            if slot.getSlotedNPCName() == asName
                return slot
            endif
        endif
    endwhile
    ; ==== check static slots ====
    if IsManager()
        Int loc_slotsnum = _StaticSlots.length
        Int loc_y = 0
        while loc_y < loc_slotsnum
            UD_StaticNPCSlots loc_slots = _StaticSlots[loc_y] as UD_StaticNPCSlots
            int loc_x = loc_slots.UD_Slots
            while loc_x
                loc_x -= 1
                UD_CustomDevice_NPCSlot loc_slot = loc_slots.GetNthAlias(loc_x) as UD_CustomDevice_NPCSlot
                if loc_slot && loc_slot.isUsed() && (loc_slot.getSlotedNPCName() == asName)
                    return loc_slot
                endif
            endwhile
            loc_y += 1
        endwhile
    endif
    return none
EndFunction

UD_CustomDevice_NPCSlot Function getNPCSlotByIndex(int iIndex)
    return GetNthAlias(iIndex) as UD_CustomDevice_NPCSlot
EndFunction

UD_CustomDevice_NPCSlot Function getPlayerSlot()
    return GetAliasByName("NPCSlot_Player") as UD_CustomDevice_NPCSlot
EndFunction

Function UpdateDevices(float fTimePassed)
    int index = 0
    while index < UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = (GetNthAlias(index) as UD_CustomDevice_NPCSlot)
        if loc_slot
            UpdateSlotDevices(loc_slot,fTimePassed)
        endif
        index += 1
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
    if !akActor || !isRegistered(akActor)
        return false
    endif
    UD_CustomDevice_NPCSlot loc_slot = getNPCSlotByActor(akActor)
    if loc_slot
        if !loc_slot.IsBlocked()
            loc_slot.unregisterSlot()
            StorageUtil.UnSetIntValue(akActor, "UD_blockSlotUpdate")
            akActor.RemoveFromFaction(UDCDmain.RegisteredNPCFaction)
            if bDebugMsg || UDCDmain.UDmain.DebugMod
                debug.notification("[UD]: NPC slot [X] = " + getActorName(akActor) + " =>  unregistered!")
            endif
            return True
        else
            if bDebugMsg || UDCDmain.UDmain.DebugMod
                debug.notification("[UD]: NPC slot [X] = " + getActorName(akActor) + " =>  slot blocked!")
            endif
            return False
        endif
    endif
    return False
EndFunction

State UpdatePaused
    Function UpdateSlots()
    EndFunction
    Event OnUpdate()
        RegisterForSingleUpdate(UDCDmain.UD_UpdateTime/2)
    EndEvent
    Event OnUpdateGameTime()
        RegisterForSingleUpdateGameTime(1.0)
    endEvent
    Function UpdateSlot(UD_CustomDevice_NPCSlot akSlot)
    EndFunction
    Function UpdateDevices(float fTimePassed)
    EndFunction
    Function UpdateSlotDevices(UD_CustomDevice_NPCSlot akSlot, Float afTimePassed)
    EndFunction
EndState

State Disabled
    Function UpdateSlots()
    EndFunction
    Event OnUpdate()
        RegisterForSingleUpdate(UDCDmain.UD_UpdateTime/2)
    EndEvent
    Event OnUpdateGameTime()
        RegisterForSingleUpdateGameTime(1.0)
    endEvent
    Function UpdateSlot(UD_CustomDevice_NPCSlot akSlot)
    EndFunction
    Function UpdateDevices(float fTimePassed)
    EndFunction
    Function UpdateSlotDevices(UD_CustomDevice_NPCSlot akSlot, Float afTimePassed)
    EndFunction
EndState
