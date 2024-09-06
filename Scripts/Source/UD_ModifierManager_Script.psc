Scriptname UD_ModifierManager_Script extends Quest

import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto

UDCustomDeviceMain Property UDCDmain 
    UDCustomDeviceMain Function get()
        return UDmain.UDCDmain
    EndFunction
EndProperty

zadlibs_UDPatch Property libsp
    zadlibs_UDPatch Function get()
        return UDmain.libsp
    EndFunction
EndProperty 

UD_CustomDevices_NPCSlotsManager Property UDNPCM
    UD_CustomDevices_NPCSlotsManager Function get()
        return UDmain.UDNPCM
    EndFunction
EndProperty

UD_Patcher Property UDPatcher 
    UD_Patcher Function get()
        return UDCDmain.UDPatcher
    EndFunction
EndProperty

UD_RandomRestraintManager Property UDRRM 
    UD_RandomRestraintManager Function get()
        return UDmain.UDRRM
    EndFunction
EndProperty

UD_Libs Property UDLibs 
    UD_Libs Function get()
        return UDmain.UDLibs
    EndFunction
EndProperty

bool Property Ready = false auto Hidden

Int _ModDeviceEvent_Locked      = 0x01
Int _ModDeviceEvent_Unlocked    = 0x02
Int _ModDeviceEvent_Broken      = 0x04

;saved modifier storages
Form[] _modifierstorages
int Function AddModifierStorage(UD_ModifierStorage akStorage)
    if !akStorage
        return -1
    endif
    UDmain.Info("Adding modifier storage -> " + akStorage)
    
    _modifierstorages = PapyrusUtil.PushForm(_modifierstorages,akStorage as Form)
    
    ; repopulating modifiers list
;    Ready = False
;    RegisterForSingleUpdate(2.0)
    
    return _modifierstorages.length
EndFunction

int Function GetModifierStorageCount()
    if _modifierstorages
        return _modifierstorages.length
    else
        return 0
    endif
EndFunction

UD_ModifierStorage Function GetNthModifierStorage(Int aiIndex)
    return _modifierstorages[aiIndex] as UD_ModifierStorage
EndFunction

UD_Modifier Function GetModifier(String asAlias)
    int loc_count = GetModifierStorageCount()
    while loc_count
        loc_count -= 1
        
        UD_ModifierStorage loc_storage = GetNthModifierStorage(loc_count)
        Int loc_modnum = loc_storage.GetModifierNum()
        while loc_modnum
            loc_modnum -= 1
            UD_Modifier loc_mod = loc_storage.GetNthModifier(loc_modnum)
            if loc_mod && (loc_mod.NameAlias == asAlias)
                return loc_mod
            endif
        endwhile
    endwhile
    return none
EndFunction

Function UpdateStorage()
    UDmain.Info("Updating modifiers - Start")
    int loc_i = 0
    while loc_i < _modifierstorages.length
        UDmain.Info("Updating modifiers -> " + _modifierstorages[loc_i])
        ResetQuest(_modifierstorages[loc_i] as Quest)
        loc_i += 1
    endwhile
    UDmain.Info("Updating modifiers - Done!")
EndFunction

Function OnInit()
    RegisterForSingleUpdate(20.0)
    UpdateEventRegistrations()
EndFunction

Function Update()
    ;UpdateStorage()
    UpdateLists()
    UpdateModifiers_Load()
    UpdateEventRegistrations()
EndFunction

Function UpdateEventRegistrations(Bool abUnregister = False)
    If !abUnregister
        RegisterForTrackedStatsEvent()
        RegisterForSleep()
        RegisterForActorAction(0)       ; weapon swing
        RegisterForActorAction(1)       ; 
        RegisterForActorAction(2)       ; 
        RegisterForActorAction(3)       ; voice cast
        RegisterForActorAction(4)       ; voice fire
        RegisterForActorAction(5)       ; 
        RegisterForActorAction(6)       ; 
        RegisterForActorAction(7)       ; 
        RegisterForActorAction(8)       ; 
        RegisterForActorAction(9)       ; 
        RegisterForActorAction(10)      ; 
    Else
    EndIf
EndFunction

String[]        Property UD_ModifierList    auto hidden
Alias[]         Property UD_ModifierListRef auto hidden

Function UpdateLists()
    UD_ModifierList     = Utility.CreateStringArray(0)
    UD_ModifierListRef  = Utility.CreateAliasArray(0)

    Int loc_i1      = 0
    int loc_count   = GetModifierStorageCount()
    while loc_i1 < loc_count
        UD_ModifierStorage loc_storage = GetNthModifierStorage(loc_i1)
        Int loc_modnum = loc_storage.GetModifierNum()
        Int loc_i2 = 0
        while loc_i2 < loc_modnum
            UD_Modifier loc_mod = loc_storage.GetNthModifier(loc_i2)
            if loc_mod
                UD_ModifierList    = PapyrusUtil.PushString(UD_ModifierList,loc_mod.NameFull)
                UD_ModifierListRef = PapyrusUtil.PushAlias(UD_ModifierListRef,loc_mod)
            endif
            loc_i2 += 1
        endwhile
        loc_i1 += 1
    endwhile
EndFunction


float _LastUpdateTime = 0.0
Event OnUpdate()
    if !Ready
        Ready = true
        _LastUpdateTime         = Utility.GetCurrentGameTime()
        _LastUpdateTime_Hour    = Utility.GetCurrentGameTime()
        Update()
        RegisterForSingleUpdate(30.0) ;start update loop, 5 s
        RegisterForSingleUpdateGameTime(1.0) ;start update loop, 1 game hour
    else
        if UDmain.IsEnabled() && (UD_Native.GetCameraState() != 3)
            float loc_timePassed = Utility.GetCurrentGameTime() - _LastUpdateTime
            UpdateModifiers(loc_timePassed)
            _LastUpdateTime = Utility.GetCurrentGameTime()
            RegisterForSingleUpdate(UDCDmain.UD_UpdateTime)
        else
            RegisterForSingleUpdate(30.0)
        endif
    endif
EndEvent

float _LastUpdateTime_Hour = 0.0 ;last time the update happened in days
Event OnUpdateGameTime()
    if UDmain.IsEnabled() && (UD_Native.GetCameraState() != 3)
        UpdateModifiers_Hour()
    endif
    _LastUpdateTime_Hour = Utility.GetCurrentGameTime()
    RegisterForSingleUpdateGameTime(1.0)
EndEvent

; An insane number of different events that can be caught in this call. Assuming it works.
; See https://ck.uesp.net/wiki/ListOfTrackedStats
Event OnTrackedStatsEvent(string arStatName, int aiStatValue)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModifierManager_Script::OnTrackedStatsEvent() arStatName = " + arStatName + ", aiStatValue = " + aiStatValue, 3)
    EndIf
    UpdateModifiers_StatEvent(arStatName, aiStatValue)
EndEvent

Float _SleepStart = -1.0
Float _SleepDesiredEnd = -1.0

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
    _SleepStart = afSleepStartTime
    _SleepDesiredEnd = afDesiredSleepEndTime
EndEvent

Event OnSleepStop(bool abInterrupted)
    If _SleepStart > 0.0
        Float loc_dur = (Utility.GetCurrentGameTime() - _SleepStart) * 24.0
        If UDmain.TraceAllowed()
            UDmain.Log("UD_ModifierManager_Script::OnSleepStop() Sleep was detected: duration = " + loc_dur + ", interrupted = " + abInterrupted, 3)
        EndIf
        UpdateModifiers_Sleep(loc_dur, abInterrupted)
    EndIf
EndEvent

; ActionTypes
; 0 - Weapon Swing (Melee weapons that are swung, also barehand)
; 1 - Spell Cast (Spells and staves)
; 2 - Spell Fire (Spells and staves)
; 3 - Voice Cast
; 4 - Voice Fire
; 5 - Bow Draw
; 6 - Bow Release
; 7 - Unsheathe Begin
; 8 - Unsheathe End
; 9 - Sheathe Begin
; 10 - Sheathe End
; Slots
; 0 - Left Hand
; 1 - Right Hand
; 2 - Voice
Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
    UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByActor(akActor)
    If loc_slot == None
        Return
    EndIf

    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModifierManager_Script::OnActorAction() actionType = " + actionType + ", akActor = " + akActor + ", source = " + source + ", slot = " + slot, 3)
    EndIf
    
    UpdateModifiers_ActorAction(loc_slot, actionType, source)

EndEvent

;====================================================================================
;                            receive modifier update events
;====================================================================================

Function UpdateModifiers_Load()
    int loc_i = 0
    while loc_i < UDNPCM.UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByIndex(loc_i)
        if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
            UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
            int loc_x = 0
            while loc_devices[loc_x]
                if !loc_devices[loc_x].isMinigameOn() && !loc_devices[loc_x].IsUnlocked ;not update device which are in minigame
                    Procces_UpdateModifiers_Load(loc_devices[loc_x])
                endif
                loc_x += 1
            endwhile
        endif
        loc_i += 1
    endwhile
EndFunction

Function UpdateModifiers(float aiTimePassed)
    int loc_i = 0
    while loc_i < UDNPCM.UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByIndex(loc_i)
        if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
            UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
            int loc_x = 0
            while loc_devices[loc_x]
                if !loc_devices[loc_x].isMinigameOn() && !loc_devices[loc_x].IsUnlocked ;not update device which are in minigame
                    Procces_UpdateModifiers(loc_devices[loc_x],aiTimePassed)
                endif
                loc_x += 1
            endwhile
        endif
        loc_i += 1
    endwhile
EndFunction

Function UpdateModifiers_Hour()
    int loc_i = 0
    while loc_i < UDNPCM.UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByIndex(loc_i)
        if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
            UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
            int loc_x = 0
            while loc_devices[loc_x]
                if !loc_devices[loc_x].isMinigameOn() && !loc_devices[loc_x].IsUnlocked
                    Procces_UpdateModifiers_Hour(loc_devices[loc_x])
                endif
                loc_x += 1
            endwhile
        endif
        loc_i += 1
    endwhile
EndFunction

Function UpdateModifiers_Orgasm(UD_CustomDevice_NPCSlot akSlot)
    UD_CustomDevice_NPCSlot loc_slot = akSlot
    if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
        UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
        int loc_x = 0
        while loc_devices[loc_x]
            if !loc_devices[loc_x].IsUnlocked
                Procces_UpdateModifiers_Orgasm(loc_devices[loc_x])
            endif
            loc_x += 1
        endwhile
    endif
EndFunction

Function UpdateModifiers_StatEvent(string arStatName, int aiStatValue)
    UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getPlayerSlot()
    if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
        UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
        int loc_x = 0
        while loc_devices[loc_x]
            if !loc_devices[loc_x].isMinigameOn() && !loc_devices[loc_x].IsUnlocked ;not update device which are in minigame
                Procces_UpdateModifiers_StatEvent(loc_devices[loc_x], arStatName, aiStatValue)
            endif
            loc_x += 1
        endwhile
    endif
EndFunction

Function UpdateModifiers_Sleep(Float afDuration, Bool abInterrupted)
    int loc_i = 0
    while loc_i < UDNPCM.UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByIndex(loc_i)
        if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
            UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
            int loc_x = 0
            while loc_devices[loc_x]
                if !loc_devices[loc_x].isMinigameOn() && !loc_devices[loc_x].IsUnlocked ;not update device which are in minigame
                    Procces_UpdateModifiers_Sleep(loc_devices[loc_x], afDuration, abInterrupted)
                endif
                loc_x += 1
            endwhile
        endif
        loc_i += 1
    endwhile
EndFunction

Function UpdateModifiers_ActorAction(UD_CustomDevice_NPCSlot akSlot, Int aiActorAction, Form akSource)
    UD_CustomDevice_NPCSlot loc_slot = akSlot
    if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
        UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
        int loc_x = 0
        while loc_devices[loc_x]
            if !loc_devices[loc_x].isMinigameOn() && !loc_devices[loc_x].IsUnlocked ;not update device which are in minigame
                Procces_UpdateModifiers_ActorAction(loc_devices[loc_x], aiActorAction, akSource)
            endif
            loc_x += 1
        endwhile
    endif
EndFunction

Function UpdateModifiers_KillMonitor(ObjectReference akVictim, ObjectReference akKiller, Location akLocation, Int aiCrimeStatus)
    If akKiller as Actor == None || akVictim as Actor == None
        Return
    EndIf
    UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByActor(akKiller as Actor)
    If loc_slot == None
        Return
    EndIf
    if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
        UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
        int loc_x = 0
        while loc_devices[loc_x]
            if !loc_devices[loc_x].isMinigameOn() && !loc_devices[loc_x].IsUnlocked ;not update device which are in minigame
                Procces_UpdateModifiers_KillMonitor(loc_devices[loc_x], akVictim, aiCrimeStatus)
            endif
            loc_x += 1
        endwhile
    endif
EndFunction

;====================================================================================
;                            Procces modifiers groups
;====================================================================================

Function ValidateModifiers(UD_CustomDevice_RenderScript akDevice)
    int loc_count = akDevice.UD_ModifiersRef.length
    Bool loc_error = False
    If akDevice.UD_ModifiersDataStr.Length < loc_count
        akDevice.UD_ModifiersDataStr = Utility.ResizeStringArray(akDevice.UD_ModifiersDataStr, loc_count)
        loc_error = True
    EndIf
    If akDevice.UD_ModifiersDataForm1.Length < loc_count
        akDevice.UD_ModifiersDataForm1 = Utility.ResizeFormArray(akDevice.UD_ModifiersDataForm1, loc_count)
        loc_error = True
    EndIf
    If akDevice.UD_ModifiersDataForm2.Length < loc_count
        akDevice.UD_ModifiersDataForm2 = Utility.ResizeFormArray(akDevice.UD_ModifiersDataForm2, loc_count)
        loc_error = True
    EndIf
    If akDevice.UD_ModifiersDataForm3.Length < loc_count
        akDevice.UD_ModifiersDataForm3 = Utility.ResizeFormArray(akDevice.UD_ModifiersDataForm3, loc_count)
        loc_error = True
    EndIf
    If akDevice.UD_ModifiersDataForm4.Length < loc_count
        akDevice.UD_ModifiersDataForm4 = Utility.ResizeFormArray(akDevice.UD_ModifiersDataForm4, loc_count)
        loc_error = True
    EndIf
    If akDevice.UD_ModifiersDataForm5.Length < loc_count
        akDevice.UD_ModifiersDataForm5 = Utility.ResizeFormArray(akDevice.UD_ModifiersDataForm5, loc_count)
        loc_error = True
    EndIf
    If loc_error
        UDmain.Warning(akDevice + " Modifier's datas were fixed during validation!")
    EndIf
EndFunction

Function Procces_UpdateModifiers_Load(UD_CustomDevice_RenderScript akDevice)
    ValidateModifiers(akDevice)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.GameLoaded(akDevice,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid],akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers(UD_CustomDevice_RenderScript akDevice,float aiTimePassed)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.TimeUpdateSecond(akDevice,aiTimePassed,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid],akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_Hour(UD_CustomDevice_RenderScript akDevice)
    int loc_modid  = akDevice.UD_ModifiersRef.length
    Float loc_mult = akDevice.ResetLastHourUpdateMod()
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.TimeUpdateHour(akDevice,loc_mult,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid],akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_Orgasm(UD_CustomDevice_RenderScript akDevice)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.Orgasm(akDevice,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid],akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_Added(UD_CustomDevice_RenderScript akDevice) ;directly accesed from device
    ValidateModifiers(akDevice)
    Int loc_flags = StorageUtil.GetIntValue(akDevice.GetWearer(), "UD_ignoreModEvent" + akDevice.DeviceInventory)
    If Math.LogicalAnd(loc_flags, 0x01) != 0
        Return
    EndIf
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.DeviceLocked(akDevice,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid],akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_Remove(UD_CustomDevice_RenderScript akDevice) ;directly accesed from device
    Int loc_flags = StorageUtil.GetIntValue(akDevice.GetWearer(), "UD_ignoreModEvent" + akDevice.DeviceInventory)
    If Math.LogicalAnd(loc_flags, 0x02) != 0
        Return
    EndIf
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.DeviceUnlocked(akDevice,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid],akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Bool Function GetModifierState_MinigameAllowed(UD_CustomDevice_RenderScript akDevice) ;directly accesed from device
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        if !loc_mod.MinigameAllowed(akDevice,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid],akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
            return false
        endif
    endwhile
    return true
EndFunction

Function Procces_UpdateModifiers_MinigameStarted(UD_CustomDevice_RenderScript akDevice) ;directly accesed from device
    UD_CustomDevice_NPCSlot loc_slot = akDevice.UD_WearerSlot
    if !loc_slot || !loc_slot.isUsed() || loc_slot.isDead() || !loc_slot.isScriptRunning()
        return
    endif
    
    int i = 0
    UD_CustomDevice_RenderScript loc_device = loc_slot.UD_equipedCustomDevices[i]
    
    while loc_device
        int loc_modid = loc_device.UD_ModifiersRef.length
        while loc_modid 
            loc_modid -= 1
            UD_Modifier loc_mod = (loc_device.UD_ModifiersRef[loc_modid] as UD_Modifier)
            loc_mod.MinigameStarted(loc_device,akDevice,loc_device.UD_ModifiersDataStr[loc_modid],loc_device.UD_ModifiersDataForm1[loc_modid],loc_device.UD_ModifiersDataForm2[loc_modid],loc_device.UD_ModifiersDataForm3[loc_modid],loc_device.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
        endwhile
        
        i+=1
        loc_device = loc_slot.UD_equipedCustomDevices[i]
    endwhile
EndFunction

Function Procces_UpdateModifiers_MinigameEnded(UD_CustomDevice_RenderScript akDevice) ;directly accesed from device
    UD_CustomDevice_NPCSlot loc_slot = akDevice.UD_WearerSlot
    if !loc_slot || !loc_slot.isUsed() || loc_slot.isDead() || !loc_slot.isScriptRunning()
        return
    endif
    
    int i = 0
    UD_CustomDevice_RenderScript loc_device = loc_slot.UD_equipedCustomDevices[i]
    
    while loc_device
        int loc_modid = loc_device.UD_ModifiersRef.length
        while loc_modid 
            loc_modid -= 1
            UD_Modifier loc_mod = (loc_device.UD_ModifiersRef[loc_modid] as UD_Modifier)
            loc_mod.MinigameEnded(loc_device,akDevice,loc_device.UD_ModifiersDataStr[loc_modid],loc_device.UD_ModifiersDataForm1[loc_modid],loc_device.UD_ModifiersDataForm2[loc_modid],loc_device.UD_ModifiersDataForm3[loc_modid],loc_device.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
        endwhile
        
        i+=1
        loc_device = loc_slot.UD_equipedCustomDevices[i]
    endwhile
EndFunction

Function Procces_UpdateModifiers_WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage)
    If akDevice.GetRealTimeLockedTime() < 0.001
        Return
    EndIf
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.WeaponHit(akDevice, akWeapon, afDamage, akDevice.UD_ModifiersDataStr[loc_modid], akDevice.UD_ModifiersDataForm1[loc_modid], akDevice.UD_ModifiersDataForm2[loc_modid], akDevice.UD_ModifiersDataForm3[loc_modid], akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_SpellHit(UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage)
    If akDevice.GetRealTimeLockedTime() < 0.001
        Return
    EndIf
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.SpellHit(akDevice, akSpell, afDamage, akDevice.UD_ModifiersDataStr[loc_modid], akDevice.UD_ModifiersDataForm1[loc_modid], akDevice.UD_ModifiersDataForm2[loc_modid], akDevice.UD_ModifiersDataForm3[loc_modid], akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell)
    If akDevice.GetRealTimeLockedTime() < 0.001
        Return
    EndIf
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.SpellCast(akDevice, akSpell, akDevice.UD_ModifiersDataStr[loc_modid], akDevice.UD_ModifiersDataForm1[loc_modid], akDevice.UD_ModifiersDataForm2[loc_modid], akDevice.UD_ModifiersDataForm3[loc_modid], akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.ConditionLoss(akDevice, aiCondition, akDevice.UD_ModifiersDataStr[loc_modid], akDevice.UD_ModifiersDataForm1[loc_modid], akDevice.UD_ModifiersDataForm2[loc_modid], akDevice.UD_ModifiersDataForm3[loc_modid], akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_StatEvent(UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.StatEvent(akDevice, asStatName, aiStatValue, akDevice.UD_ModifiersDataStr[loc_modid], akDevice.UD_ModifiersDataForm1[loc_modid], akDevice.UD_ModifiersDataForm2[loc_modid], akDevice.UD_ModifiersDataForm3[loc_modid], akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_Sleep(UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.Sleep(akDevice, afDuration, abInterrupted, akDevice.UD_ModifiersDataStr[loc_modid], akDevice.UD_ModifiersDataForm1[loc_modid], akDevice.UD_ModifiersDataForm2[loc_modid], akDevice.UD_ModifiersDataForm3[loc_modid], akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.ActorAction(akDevice, aiActorAction, akSource, akDevice.UD_ModifiersDataStr[loc_modid], akDevice.UD_ModifiersDataForm1[loc_modid], akDevice.UD_ModifiersDataForm2[loc_modid], akDevice.UD_ModifiersDataForm3[loc_modid], akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_KillMonitor(UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.KillMonitor(akDevice, akVictim, aiCrimeStatus, akDevice.UD_ModifiersDataStr[loc_modid], akDevice.UD_ModifiersDataForm1[loc_modid], akDevice.UD_ModifiersDataForm2[loc_modid], akDevice.UD_ModifiersDataForm3[loc_modid], akDevice.UD_ModifiersDataForm4[loc_modid],akDevice.UD_ModifiersDataForm5[loc_modid])
    endwhile
EndFunction

;DEBUG
Function Debug_AddModifier(UD_CustomDevice_RenderScript akDevice)
    string[] loc_ModifierList
    Alias[]  loc_ModifierListRef
    int loc_count = GetModifierStorageCount()
    while loc_count
        loc_count -= 1
        UD_ModifierStorage loc_storage = GetNthModifierStorage(loc_count)
        Int loc_modnum = loc_storage.GetModifierNum()
        while loc_modnum
            loc_modnum -= 1
            UD_Modifier loc_mod = loc_storage.GetNthModifier(loc_modnum)
            if loc_mod
                loc_ModifierList = PapyrusUtil.PushString(loc_ModifierList,loc_mod.NameFull)
                loc_ModifierListRef = PapyrusUtil.PushAlias(loc_ModifierListRef,loc_mod as Alias)
            endif
        endwhile
    endwhile
    if loc_ModifierList
        int loc_res1 = UDMain.GetUserListInput(loc_ModifierList)
        if loc_res1 >= 0
            UD_Modifier loc_mod = loc_ModifierListRef[loc_res1] as UD_Modifier
            if !akDevice.HasModifierRef(loc_mod)
                String      loc_param = UDMain.GetUserTextInput()
                if !akDevice.addModifier(loc_mod,loc_param)
                    UDmain.Print("Error! Can't add " + loc_mod.NameFull)
                endif
            else
                UDmain.Print("Error! Can't add " + loc_mod.NameFull + " becausei t is already on device")
            endif
        endif
    endif
EndFunction

Function Debug_RemoveModifier(UD_CustomDevice_RenderScript akDevice)
    if akDevice.UD_ModifiersRef.length > 0
        string[] loc_ModifierList
        Int loc_i = 0
        while loc_i < akDevice.UD_ModifiersRef.length
            UD_Modifier loc_mod = akDevice.UD_ModifiersRef[loc_i] as UD_Modifier
            if loc_mod
                loc_ModifierList    = PapyrusUtil.PushString(loc_ModifierList,loc_mod.NameFull)
            endif
            loc_i += 1
        endwhile
    
        int loc_res = UDMain.GetUserListInput(loc_ModifierList)
        if loc_res >= 0
            UD_Modifier loc_mod = akDevice.UD_ModifiersRef[loc_res] as UD_Modifier
            if !akDevice.removeModifier(loc_mod)
                UDmain.Print("Error! Can't remove " + loc_mod.NameFull)
            endif
        endif
    endif
EndFunction
