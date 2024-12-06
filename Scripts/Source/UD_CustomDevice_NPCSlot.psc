Scriptname UD_CustomDevice_NPCSlot  extends ReferenceAlias

import UnforgivingDevicesMain
import UD_NPCInteligence
import UD_Native

UDCustomDeviceMain Property UDCDmain auto

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDmain()
        endif
        return _udmain
    EndFunction
EndProperty

UD_CustomDevices_NPCSlotsmanager Property UDNPCM hidden
    UD_CustomDevices_NPCSlotsmanager Function get()
        return GetOwningQuest() as UD_CustomDevices_NPCSlotsmanager
    EndFunction
EndProperty

zadlibs_UDPatch _libs
zadlibs_UDPatch Property libs hidden
    zadlibs_UDPatch Function get()
        if !_libs
            _libs = UDmain.libsp
        endif
        return _libs
    EndFunction
EndProperty

UD_OrgasmManager _udom
UD_OrgasmManager Property UDOM Hidden
    UD_OrgasmManager Function get()
        if !_udom
            if IsPlayer()
                _udom = UDmain.UDOMPlayer
            else
                _udom = UDmain.UDOMNPC
            endif
        endif
        return _udom
    EndFunction
EndProperty
UD_Config _udconf
UD_Config Property UDCONF hidden
    UD_Config Function Get()
        if !_udconf
            _udconf = UDmain.UDCONF
        endif
        return _udconf
    EndFunction
EndProperty

UD_CustomDevice_RenderScript[]          Property UD_equipedCustomDevices    auto hidden

UD_CustomDevice_RenderScript[] _ActiveVibrators
UD_CustomDevice_RenderScript[]          Property UD_ActiveVibrators         hidden
    UD_CustomDevice_RenderScript[] Function Get()
        if !_ActiveVibrators
            _ActiveVibrators = UDCDMain.MakeNewDeviceSlots()
        endif
        return _ActiveVibrators
    EndFunction
    Function Set(UD_CustomDevice_RenderScript[] akVal)
        _ActiveVibrators = akVal
    EndFunction
EndProperty

UD_CustomDevice_RenderScript _handRestrain = none
UD_CustomDevice_RenderScript Property UD_HandRestrain Hidden
    UD_CustomDevice_RenderScript Function get()
        if _handRestrain
            if _handRestrain.IsUnlocked
                _handRestrain = none
            endif
        endif
        if GetActor().wornhaskeyword(libs.zad_deviousHeavyBondage)
            if !_handRestrain
                _handRestrain = getHeavyBondageDevice()
            endif
        else
            _handRestrain = none
        endif
        return _handRestrain
    EndFunction
    
    Function set(UD_CustomDevice_RenderScript akDevice)
        _handRestrain = akDevice
    EndFunction
EndProperty

int _iUsedSlots = 0
int _iScriptState = 0
bool Property Ready = False auto hidden
bool    _isplayer = false

;Weapon Property BestWeapon = none auto hidden
Weapon _BestWeapon
Weapon Property UD_BestWeapon Hidden
    Weapon Function get()
        if !_BestWeapon || GetActor().getItemCount(_BestWeapon) == 0
            _BestWeapon = GetBestWeapon()
        endif
        return _BestWeapon
    EndFunction
    Function set(Weapon akWeapon)
        _BestWeapon = akWeapon
    EndFunction
EndProperty
float Property AgilitySkill         = 0.0   auto hidden
float Property StrengthSkill        = 0.0   auto hidden
float Property MagickSkill          = 0.0   auto hidden
float Property CuttingSkill         = 0.0   auto hidden
float Property SmithingSkill        = 0.0   auto hidden

float Property ArousalSkillMult     = 1.0   auto hidden

;timer used to prevent AI being activated too early
;number means how many AI updates will be ommited
Int   Property UD_AITimer           = 2     auto hidden

;prevent slot update
State UpdatePaused
    Function update(float fTimePassed)
    EndFunction
    Function updateDeviceHour()
    EndFunction
    Function UpdateSlot(Bool abUpdateSkill = true)
    EndFunction
    Function DeviceUpdate(UD_CustomDevice_RenderScript akDevice,Float afTimePassed)
    EndFunction
    Function UpdateSkills()
    EndFunction
EndState

Function GameUpdate()
    If isUsed()
        if !IsPlayer()
            UDOM.RemoveAbilities(GetActor())
        endif
        _OrgasmGameUpdate()
        CheckVibrators()
    endif
EndFunction

Bool Function IsBlocked()
    Bool loc_res = UDCDmain.ActorInMinigame(GetActor())
    ;loc_res = loc_res || _MinigameStarter_ON
    ;loc_res = loc_res || _MinigameParalel_ON
    ;loc_res = loc_res || _MinigameCritLoop_ON
    return loc_res
EndFunction

;update other variables
Function UpdateSlot(Bool abUpdateSkill = true)
    ArousalSkillMult = UDCDmain.getArousalSkillMult(getActor())
    if abUpdateSkill && (isPlayer() || isFollower())
        ;only update skills if actor is player or follower
        ;TODO: Add switch to allow users to also update skills for other NPCs
        UpdateSkills()
    endif
    if !GetActor().wornhaskeyword(libs.zad_deviousHeavyBondage)
        _handRestrain = none ;unreference device
    endif
EndFunction

Form[] Function GetBodySlots()
    int     loc_i       = 0
    Actor   loc_actor   = GetActor()
    Form[]  loc_slots   = new form[32]
    
    while loc_i < 32
        loc_slots[loc_i] = loc_actor.GetWornForm(Math.LeftShift(0x1,loc_i))
        loc_i += 1
    endwhile
    
    return loc_slots
EndFunction

bool _DeviceManipMutex = false
Function startDeviceManipulation()
    float loc_time = 0.0
    while _DeviceManipMutex && loc_time <= 60.0
        Utility.waitMenuMode(0.1)
        loc_time += 0.1
    endwhile
    _DeviceManipMutex = true
    
    if loc_time >= 60.0
        UDmain.Error("startDeviceManipulation timeout!!!")
    endif
EndFunction

Function endDeviceManipulation()
    _DeviceManipMutex = false
EndFunction

Event OnInit()
    UD_equipedCustomDevices = UDCDMain.MakeNewDeviceSlots()
    UD_ActiveVibrators      = UDCDMain.MakeNewDeviceSlots()
    Ready = True
EndEvent

Event OnPlayerLoadGame()
EndEvent

Event OnLoad()
    _ValidateOutfit()
endEvent

Event OnUnload()
endEvent

;check if device was not replaced by outfit
Function _ValidateOutfit()
    int loc_i = 0
    Actor loc_actor = GetActor()
    while (loc_i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[loc_i]
        UD_CustomDevice_RenderScript loc_device = UD_equipedCustomDevices[loc_i]
        ;check if device is equipped, if not, equip it
        if !loc_actor.isEquipped(loc_device.deviceRendered) 
            loc_actor.equipitem(loc_device.deviceRendered, true, true)
            UDmain.Info("Equipping unequipped device " + loc_device.getDeviceName() + " for " + GetSlotedNPCName())
        endif
        loc_i += 1
    endwhile
EndFunction

UD_CustomDevice_RenderScript Function GetUserSelectedDevice()
    String[] loc_devicesString = getSlotsStringA()
    loc_devicesString = PapyrusUtil.PushString(loc_devicesString,"--BACK--")
    int loc_deviceIndx = UDmain.GetUserListInput(loc_devicesString)
    
    if loc_deviceIndx != (loc_devicesString.length - 1) && loc_deviceIndx >= 0
        UD_CustomDevice_RenderScript loc_device = UD_equipedCustomDevices[loc_deviceIndx]
        ReorderSlots(loc_device)
        return loc_device
    else
        return none
    endif
EndFunction

String[] Function getSlotsStringA()
    String[] loc_res
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        loc_res = PapyrusUtil.PushString(loc_res,UD_equipedCustomDevices[i].getDeviceName())
        i+=1
    endwhile
    return loc_res
EndFunction

Function ReorderSlots(UD_CustomDevice_RenderScript firstDevice)
    startDeviceManipulation()
    int loc_reorderIndx = GetDeviceSlotIndx(firstDevice)
    int i = loc_reorderIndx 
    while i < UD_equipedCustomDevices.length
        if UD_equipedCustomDevices[i] && ((i + 1) != UD_equipedCustomDevices.length)
            UD_equipedCustomDevices[i] = UD_equipedCustomDevices[i + 1]
        endif
        i+=1
    endwhile
    
    ;push back
    i = UD_equipedCustomDevices.length - 1
    while i
        if !UD_equipedCustomDevices[i] && UD_equipedCustomDevices[i - 1]
            UD_equipedCustomDevices[i] = UD_equipedCustomDevices[i - 1]
            UD_equipedCustomDevices[i - 1] = none
        endif
        i-=1
    endwhile
    
    UD_equipedCustomDevices[0] = firstDevice
    endDeviceManipulation()
EndFunction

int Function GetDeviceSlotIndx(UD_CustomDevice_RenderScript device)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i] == device
            return i
        endif
        i+=1
    endwhile
    return -1
EndFunction

int Function GetVibratorSlotIndx(UD_CustomDevice_RenderScript akVib)
    if !(akVib as UD_CustomVibratorBase_RenderScript)
        ;device is not vibrator, return -1
        return -1
    endif
    int i = 0
    while (i < UD_ActiveVibrators.length) && UD_ActiveVibrators[i]
        if UD_ActiveVibrators[i] == akVib
            return i
        endif
        i+=1
    endwhile
    return -1
EndFunction

Function SetSlotTo(Actor akActor)
    UD_AITimer = 2
    if UDmain.TraceAllowed()
        UDmain.Log("SetSlotTo("+getActorName(akActor)+") for " + self)
    endif

    if !IsPlayer()
        ForceRefTo(akActor)
    endif

    akActor.addToFaction(UDCDmain.RegisteredNPCFaction)

    InitOrgasmUpdate()

    UpdateSlot(false)

    if !IsPlayer()
        regainDevices()
        CheckVibrators()
    endif
EndFunction

Function Init()
EndFunction

bool Function isInPlayerCell()
    if UDmain.Player.getParentCell() == getActor().getParentCell()
        return true
    else
        return false
    endif
EndFunction

bool Function isScriptRunning()
    if _iUsedSlots > 0
        return True
    else
        return False
    endif
EndFunction

bool Function canUpdate()
    return !IsDead() && !getActor().getCurrentScene()
EndFunction

bool Function IsDead()
    if isUsed()
        return getActor().isDead() && !isPlayer()
    else
        return false
    endif
EndFunction

int Function getNumberOfRegisteredDevices()
    return _iUsedSlots
EndFunction

Function unregisterSlot()
    ;UDmain.Info("Unregistered NPC " + GetSlotedNPCName())
    if UDmain.TraceAllowed()
        UDmain.Log("NPC " + getSlotedNPCName() + " unregistered",2)
    endif
    if _iUsedSlots
        unregisterAllDevices()
        EndAllVibrators()
    endif
    StorageUtil.UnSetIntValue(getActor(), "UD_ManualRegister")
    _iScriptState = 0
    if IsPlayer()
        UDOM.RemoveAbilities(getActor())
    else
        CleanArousalUpdate()
        CleanOrgasmUpdate()
    endif
    self.Clear()
EndFunction

Function sortSlots(bool mutex = true)
    if mutex
        startDeviceManipulation()
    endif
    int counted = 0
    int i = 0
    while i < UD_equipedCustomDevices.length
        if UD_equipedCustomDevices[i]
            UD_equipedCustomDevices[counted] = UD_equipedCustomDevices[i]
            counted += 1
        endif
        i+=1
    endwhile

    i = counted
    while i < UD_equipedCustomDevices.length
        UD_equipedCustomDevices[i] = none
        i+=1
    endwhile

    ; Just to be safe, set _iUsedSlots to the correct count
    _iUsedSlots = counted

    if mutex
        endDeviceManipulation()
    endif
EndFunction

Function SortVibrators(bool mutex = true)
    if mutex
        startVibratorManipulation()
    endif
    int i = 0
    while i < UD_ActiveVibrators.length - 1
        if UD_ActiveVibrators[i] == none && UD_ActiveVibrators[i + 1]
            UD_ActiveVibrators[i] = UD_ActiveVibrators[i + 1]
            UD_ActiveVibrators[i + 1] = none
        endif
        
        ;sorted
        if UD_ActiveVibrators[i] == none && UD_ActiveVibrators[i + 1] == none
            endVibratorManipulation()
            return
        endif
        
        i+=1
    endwhile
    if mutex
        endVibratorManipulation()
    endif
EndFunction

;removes bullshit
Function QuickFix()
    removeCopies()
    removeUnusedDevices()
EndFunction

String Function _GetNPCSlotFixText()
    String loc_res = ""
    
    loc_res += UDmain.UDMTF.Header(GetActor().GetLeveledActorBase().GetName(), 4)
    loc_res += UDmain.UDMTF.FontBegin(aiFontSize = UDmain.UDMTF.FontSize, asColor = UDmain.UDMTF.TextColorDefault)
    loc_res += UDmain.UDMTF.ParagraphBegin(asAlign = "center")
    loc_res += UDmain.UDMTF.LineGap()
; TODO


    loc_res += UDmain.UDMTF.LineBreak()
    loc_res += UDmain.UDMTF.Text("What do you want to do?")
    
    loc_res += UDmain.UDMTF.ParagraphEnd()
    loc_res += UDmain.UDMTF.FontEnd()
    
    Return loc_res
EndFunction

;fix bunch of problems
Function fix()
    String loc_str = _GetNPCSlotFixText()
    Int loc_res = UDMain.UDMMM.ShowMessageBoxMenu(UDCDmain.UDCD_NPCM.UD_FixMenu_MSG, UDMain.UDMMM.NoValues, loc_str, UDMain.UDMMM.NoButtons, UDMain.UDMTF.HasHtmlMarkup(), False)
    if loc_res == 0 ;general fix
        UDmain.Print("[UD] Starting general fixes")
        UDCDMain.ResetFetchFunction()
        removeCopies()
        removeUnusedDevices()
        removeLostRenderDevices()

        UDCDmain.EnableActor(getActor())

        getActor().removeFromFaction(UDCDmain.MinigameFaction)
        getActor().removeFromFaction(UDCDmain.BlockExpressionFaction)
        
        if IsPlayer()
            Game.EnablePlayerControls()
            Game.SetPlayerAiDriven(False)
        else
            getActor().SetDontMove(False)
        endif
        
        getActor().SheatheWeapon()
        
        getActor().SetAnimationVariableInt("FNIS_abc_h2h_LocomotionPose", 0)
        
        UDmain.UDAM.StopAnimation(getActor(), none, abEnableActors = True)
        
        getActor().RemoveFromFaction(libs.zadAnimatingFaction)
        getActor().RemoveFromFaction(libs.Sexlab.AnimatingFaction)
        
        UDCDmain.libs.StartBoundEffects(getActor())
        
        ; fix current devices
        int i = UD_equipedCustomDevices.length
        while i
            UD_equipedCustomDevices[i].StopMinigame()
            i -= 1
        endwhile
        _DeviceManipMutex = false
        
        UDmain.Print("[UD] General fixes done!")
    elseif loc_res == 1 ;reset orgasm var
        string[] loc_list = OrgasmSystem.GetAllOrgasmChanges(GetActor())
        loc_list = PapyrusUtil.PushString(loc_list,"-ALL-")
        loc_list = PapyrusUtil.PushString(loc_list,"-BACK-")
        
        int loc_ores = UDMain.GetUserListInput(loc_list)
        
        if loc_ores >= 0 
            if loc_ores == (loc_list.length - 1)
                ; DO NOTHING
            elseif loc_ores == (loc_list.length - 2)
                OrgasmSystem.RemoveAllOrgasmChanges(GetActor())
            else
                OrgasmSystem.RemoveOrgasmChange(GetActor(),loc_list[loc_ores])
            endif
        endif
        if IsPlayer()
            GetActor().DispelSpell(UDmain.UDlibs.ArousalCheckAbilitySpell)
            GetActor().DispelSpell(UDmain.UDlibs.OrgasmCheckAbilitySpell)
        endif
        UDmain.Print("[UD] Orgasm variables reseted!")
    elseif loc_res == 2 ;reset expression
        libs.ExpLibs.ResetExpressionRaw(getActor(),100)
    elseif loc_res == 3 ;unequip slot
        UDmain.Print("[UD] Loading slots...")
        Form[] loc_slots = GetBodySlots()
        UDmain.Print("[UD] Slots loaded.")
        if loc_slots
            int loc_i = 0
            string[] loc_list
            while loc_i < 32
                String loc_string = "[" +(30 + loc_i) + "] "
                if loc_slots[loc_i] && loc_slots[loc_i].getName()
                    loc_string += loc_slots[loc_i].getName() ;armor have name, use it
                else
                    loc_string += loc_slots[loc_i] ;armor doesn't have name, show editor ID
                    if loc_slots[loc_i].HasKeyWord(UDmain.UDlibs.UnforgivingDevice)
                        loc_string += " (UD)"
                    elseif loc_slots[loc_i].HasKeyWord(libs.zad_Lockable)
                        loc_string += " (DD)"
                    elseif loc_slots[loc_i] == libs.DevicesUnderneath.zad_DeviceHider
                        loc_string += " (HIDER)" 
                    endif
                endif
                
                loc_list = PapyrusUtil.PushString(loc_list,loc_string)
                loc_i += 1
            endwhile
            loc_list = PapyrusUtil.PushString(loc_list,"-BACK-")
            int loc_slot = UDMain.GetUserListInput(loc_list)
            if loc_slot >= 0 && loc_slot < 32
                ;armor is device, do some additional shit
                if loc_slots[loc_slot].HasKeyWord(UDmain.UDlibs.UnforgivingDevice)
                    Armor loc_ID = StorageUtil.GetFormValue(loc_slots[loc_slot],"UD_InventoryDevice",none) as Armor
                    getActor().removeitem(loc_slots[loc_slot],getActor().getItemCount(loc_slots[loc_slot]))
                    libs.unlockDevice(getActor(),loc_ID,loc_slots[loc_slot] as Armor)
                else ;normal armor, only unequip
                    getActor().unequipItem(loc_slots[loc_slot])
                endif
            endif
        endif
    endif
EndFunction

;check if actor have activated vibrators but don't have them registered
Function CheckVibrators()
    int i = 0
    Bool loc_Error = false
    while UD_equipedCustomDevices[i]
        ;check if device is vibrators
        UD_CustomVibratorBase_RenderScript loc_vib = (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript)
        if loc_vib
            ;check if vib is activtaed and not registered
            if UD_ActiveVibrators.Find(UD_equipedCustomDevices[i]) < 0
                if loc_vib.IsVibrating()
                    ;UDmain.Warning(self + "::CheckVibrators - Found unregistered active vibrator , registering " + loc_vib.GetDeviceName())
                    if RegisterVibrator(loc_vib)
                        loc_Error = True
                    endif
                elseif !loc_vib.IsVibrating() && !loc_vib.isVibPaused() && loc_vib.UD_VibDuration == -1
                    loc_vib.Vibrate()
                endif
            endif
        endif
        i+=1
    endwhile
EndFunction

Function removeLostRenderDevices()
    ;if !isPlayer()
    ;    UDmain.Print("removeLostRenderDevices doesn't work for NPCs. Skipping!",1)
    ;endif
    
    startDeviceManipulation()
    if UDmain.TraceAllowed()
        UDmain.Log("removeLostRenderDevices("+getSlotedNPCName()+")")
    endif
    Actor _currentSlotedActor = getActor()
    Form[] loc_toRemove
    
    ;check if faster native function should be not used instead
    int loc_deviceId = 0
    Armor[] loc_devices = UD_Native.GetRenderDevices(_currentSlotedActor,false)
    while loc_deviceId < loc_devices.length
        Armor ArmorDevice = loc_devices[loc_deviceId]
        ;get script and check if player have inventory device
        Armor loc_RenDevice = ArmorDevice
        Armor loc_InvDevice = zadNativeFunctions.GetInventoryDevice(loc_RenDevice)
        bool loc_cond = !UDCDmain.CheckRenderDeviceEquipped(_currentSlotedActor,loc_RenDevice)
        if  loc_cond
            loc_toRemove = PapyrusUtil.PushForm(loc_toRemove, ArmorDevice)
            UDmain.Print("Lost device found: " + loc_InvDevice.getName() + " removed!")
        else
            if !getDeviceByRender(loc_RenDevice)
                UDmain.Print("Found unregistred device "+loc_InvDevice.getName()+" , registering")
                UD_CustomDevice_RenderScript loc_device = UDCDmain.getDeviceScriptByRender(GetActor(),loc_RenDevice)
                if loc_device
                    RegisterDevice(loc_device,false)
                    UDmain.Print(loc_device.getDeviceHeader() + " registered")
                else
                    UDmain.Print("Can't get device. Aborting.")
                endif
            else
                ;UDMain.Error("removeLostRenderDevices() - Could not get script for " + loc_RenDevice)
            endif
        endif
        loc_deviceId += 1
    endwhile
    
    int loc_toRemoveNum = loc_toRemove.length
    
    while loc_toRemoveNum
        loc_toRemoveNum -= 1
        if deviceAlreadyRegisteredRender(loc_toRemove[loc_toRemoveNum] as Armor)
            unregisterDeviceByRend(loc_toRemove[loc_toRemoveNum] as Armor,0,true,false) ;no mutex
        endif
        _currentSlotedActor.removeItem(loc_toRemove[loc_toRemoveNum],1,true)
    endwhile
    endDeviceManipulation()
EndFunction

bool Function registerDevice(UD_CustomDevice_RenderScript oref,bool mutex = true)
    if UDmain.TraceAllowed()    
        UDmain.Log("Starting slot device register for " + oref.getDeviceHeader() )
    endif
    if GetDeviceSlotIndx(oref) > 0
        UDmain.Error("registerDevice("+oref.getDeviceHeader()+") is already registered")
        return false
    endif
    if mutex
    startDeviceManipulation()
    endif
    int size = UD_equipedCustomDevices.length
    int i = 0
    while i < size
        if !UD_equipedCustomDevices[i]
            UD_equipedCustomDevices[i] = oref
            
            ; Device is not initialized yet for some reason, so just stimulate the init function
            if UD_equipedCustomDevices[i].IsInit() < 3
                UD_equipedCustomDevices[i].ResetInit()
                UD_equipedCustomDevices[i].OnContainerChanged(GetActor(),none)
            endif
            
            _iUsedSlots+=1
            if mutex
                endDeviceManipulation()
            endif
            return true
        endif
        i+=1
    endwhile
    if mutex
        endDeviceManipulation()
    endif
    return false
EndFunction

Bool _VibratorMutex = False
Function startVibratorManipulation()
    while _VibratorMutex
        Utility.waitMenuMode(0.05)
    endwhile
    _VibratorMutex = True
EndFUnction
Function endVibratorManipulation()
    _VibratorMutex = False
EndFUnction

bool Function RegisterVibrator(UD_CustomDevice_RenderScript akVib)
    if UDmain.TraceAllowed()
        UDmain.Log("Starting slot vibrator register for " + akVib.getDeviceHeader() )
    endif
    if !(akVib as UD_CustomVibratorBase_RenderScript)
        ;device is not vibrator, return -1
        UDmain.Error(self+"::RegisterVibrator("+akVib+") failed because device is not vibrator")
        return False
    endif
    if UD_ActiveVibrators.Find(akVib) > 0
        UDmain.Error("RegisterVibrator("+akVib.getDeviceHeader()+") - Vibrator is already registered")
        return false
    endif
    startVibratorManipulation()
    int size = UD_ActiveVibrators.length
    int i = 0
    while i < size
        if !UD_ActiveVibrators[i]
            UD_ActiveVibrators[i] = akVib
            endVibratorManipulation()
            return true
        endif
        i+=1
    endwhile
    endVibratorManipulation()
    return false
EndFunction

int Function unregisterDevice(UD_CustomDevice_RenderScript oref,int i = 0,bool sort = True,bool mutex = true)
    if mutex
        startDeviceManipulation()
    endif
    int res = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i] == oref
            UD_equipedCustomDevices[i] = none
            _iUsedSlots-=1
            res += 1
        endif
        i+=1
    endwhile
    if mutex
        endDeviceManipulation()
    endif
    ;if isScriptRunning() && _iUsedSlots == 0
        ;resetScriptState()
    ;    return res
    ;endif    
    
    ; Only sort slots if at least one device is unregistered and there are still used slots
    if res > 0 && isScriptRunning() && sort
        sortSlots(mutex)
    endif
    
    return res
EndFunction

int Function UnregisterVibrator(UD_CustomDevice_RenderScript akVib,int i = 0,bool sort = True)
    startVibratorManipulation()
    int res = 0
    while (i < UD_ActiveVibrators.length) && UD_ActiveVibrators[i]
        if UD_ActiveVibrators[i] == akVib
            UD_ActiveVibrators[i] = none
            res += 1
        endif
        i+=1
    endwhile
    
    if isScriptRunning() && sort
        SortVibrators(false)
    endif
    
    endVibratorManipulation()
    return res
EndFunction

int Function unregisterDeviceByInv(Armor invDevice,int i = 0,bool sort = True,bool mutex = true)

    int res = 0
    UD_CustomDevice_RenderScript loc_device = getDeviceByInventory(invDevice)
    
    if !loc_device
        UDmain.Error("unregisterDeviceByInv("+getSlotedNPCName()+","+invDevice.getName()+") failed!! No registered device found")
        return res
    endif
    
    return unregisterDevice(loc_device,i,sort,mutex)
EndFunction

int Function unregisterDeviceByRend(Armor rendDevice,int i = 0,bool sort = True,bool mutex = true)

    int res = 0
    UD_CustomDevice_RenderScript loc_device = getDeviceByRender(rendDevice)
    
    if !loc_device
        UDmain.Error("unregisterDeviceByRend("+getSlotedNPCName()+","+rendDevice+") failed!! No registered device found")
        return res
    endif
    
    return unregisterDevice(loc_device,i,sort,mutex)
EndFunction

int Function unregisterAllDevices(int i = 0,bool mutex = true)
    if mutex
        startDeviceManipulation()
    endif
    int res = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        UD_equipedCustomDevices[i] = none
        _iUsedSlots-=1
        res += 1
        i += 1
    endwhile
    if mutex
        endDeviceManipulation()
    endif
    return res
EndFunction

bool Function deviceAlreadyRegistered(Armor deviceInventory)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].deviceInventory == deviceInventory
            return true
        endif
        i+=1
    endwhile
    return false
EndFunction

bool Function deviceAlreadyRegisteredKw(Keyword kw,Bool abCheckAllKw = false)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if (UD_equipedCustomDevices[i].UD_DeviceKeyword == kw) || (abCheckAllKw && UD_equipedCustomDevices[i].DeviceRendered.haskeyword(kw))
            return true
        endif
        i+=1
    endwhile
    return false
EndFunction

bool FUnction deviceAlreadyRegisteredRender(Armor deviceRendered)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].deviceRendered == deviceRendered
            return true
        endif
        i+=1
    endwhile
    return false
EndFunction

Function removeAllDevices()
    ;startDeviceManipulation()
    StorageUtil.SetIntValue(getActor(), "UD_blockSlotUpdate",1)
    while UD_equipedCustomDevices[0]
        UD_equipedCustomDevices[0].unlockRestrain()
    endwhile
    ;regainDevices()
    StorageUtil.UnSetIntValue(getActor(), "UD_blockSlotUpdate")
    ;endDeviceManipulation()
EndFunction

Function removeUnusedDevices()
    startDeviceManipulation()
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        UD_CustomDevice_RenderScript loc_device = UD_equipedCustomDevices[i]
        bool loc_condInv  =  loc_device.getWearer().getItemCount(loc_device.deviceInventory) == 0
        bool loc_condRend =  loc_device.getWearer().getItemCount(loc_device.deviceRendered)  == 0
        
        if loc_condInv || loc_condRend
            if !loc_condRend && loc_condInv ;remove render device if it for some reason doesn't removed it before
                loc_device.removeDevice(loc_device.getWearer())
                loc_device.getWearer().removeItem(loc_device.deviceRendered)
            endif
            UD_equipedCustomDevices[i] = none
            if UDmain.TraceAllowed()
                UDmain.Log(loc_device.getDeviceName() + " is unused, removing from " + getSlotedNPCName(),2)
            endif
            _iUsedSlots -= 1
        endif
        i+=1
    endwhile
    endDeviceManipulation()
    
    sortSlots()
EndFunction

int Function numberOfUnusedDevices()
    int res = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if !UD_equipedCustomDevices[i].getWearer().IsEquipped(UD_equipedCustomDevices[i].deviceInventory) && isPlayer()
            res += 1
        endif
        i+=1
    endwhile
    return res
EndFunction

;replece slot with new device
Function replaceSlot(UD_CustomDevice_RenderScript oref, Armor inventoryDevice)
    startDeviceManipulation()
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].deviceInventory == inventoryDevice
            UD_equipedCustomDevices[i] = oref
        endif
        i+=1
    endwhile
    endDeviceManipulation()
EndFunction

int Function getCopiesOfDevice(UD_CustomDevice_RenderScript oref)
    int res = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].deviceInventory == oref.deviceInventory
            res += 1
        endif
        i+=1
    endwhile
    
    return res
EndFunction

Function removeCopies()
    ;startDeviceManipulation()
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if i < _iUsedSlots - 1
            unregisterDevice(UD_equipedCustomDevices[i],i + 1)
        endif
        i+=1
    endwhile
    ;endDeviceManipulation()
EndFunction

int Function numberOfCopies()
    int res = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if i < _iUsedSlots - 1
            res += getCopiesOfDevice(UD_equipedCustomDevices[i])
        endif
        i+=1
    endwhile
    return res
EndFunction

int Function debugSize()
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        i+=1
    endwhile
    return i
EndFunction

Function orgasm()
    if UDmain.UD_OrgasmExhaustion
        AddOrgasmExhaustion()
    endif
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].isReady()
            UD_equipedCustomDevices[i].orgasm()
            UDmain.UDMOM.Procces_UpdateModifiers_Orgasm(UD_equipedCustomDevices[i])
        else
            GError("Device " + UD_equipedCustomDevices[i].GetDeviceName() + " is not ready -> aborting orgasm call")
        endif
        i+=1
    endwhile
EndFunction

;adds orgasm exhastion to slotted actor. 
;If actor is NPC, it will directly update orgasm values.
;If actor is Player, it will cast UD_OrgasmExhastion_AME magick effect
;NOTE: THIS DOESN'T ACTUALLY DO THE LATTER
Function AddOrgasmExhaustion()
    Actor loc_actor = GetActor()
    ;Exhaustion to NPCs for 30 second
    String loc_key = OrgasmSystem.MakeUniqueKey(loc_actor,"OrgasmExhaustion")
    OrgasmSystem.AddOrgasmChange(loc_actor,loc_key,0x64000C,0x00000200, afOrgasmRateMult = -0.1, afOrgasmResistenceMult = 0.35)
    OrgasmSystem.UpdateOrgasmChangeVar(loc_actor,loc_key,10,-0.15,1)
EndFunction

Function _UpdateOrgasmExhaustion(Int aiUpdateTime)
EndFunction

Event OnActivateDevice(string sDeviceName)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].deviceInventory.getName() == sDeviceName && UD_equipedCustomDevices[i].isReady()
            UD_equipedCustomDevices[i].activateDevice()
            return
        endif
        i+=1
    endwhile
EndEvent

;call devices function orgasm() when player have sexlab orgasm
Event SexlabOrgasmStart(bool abHasPlayer)
    int size = UD_equipedCustomDevices.length
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].isReady()
            UD_equipedCustomDevices[i].orgasm(True)
        endif
        i+=1
    endwhile
EndEvent 

;call devices function edge() when player get edged
Function edge()
    int size = UD_equipedCustomDevices.length
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].isReady()
            UD_equipedCustomDevices[i].edge()
        endif
        i+=1
    endwhile
EndFunction

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    if isScriptRunning()
        if UDmain.TraceAllowed()
            UDmain.Log("OnHit("+akAggressor+","+akSource+","+akProjectile+") on " + getSlotedNPCName())
        endif
        if akSource
            if akSource as Weapon
                OnWeaponHit(akSource as Weapon)
            elseif akSource as Spell
                OnSpellHit(akSource as Spell)
            endif
        endif
    endif
EndEvent

Function OnWeaponHit(Weapon source)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        UD_equipedCustomDevices[i].weaponHit(source)
        i+=1
    endwhile
EndFunction

Function OnSpellHit(Spell source)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        UD_equipedCustomDevices[i].spellHit(source)
        i+=1
    endwhile
EndFunction

String Function _GetDebugMenuText(UD_CustomDevice_RenderScript akDevice)
    String loc_res = ""
    loc_res += UDmain.UDMTF.Header(akDevice.getDeviceName(), 4)
    loc_res += UDmain.UDMTF.FontBegin(aiFontSize = UDmain.UDMTF.FontSize, asColor = UDmain.UDMTF.TextColorDefault)
    loc_res += UDmain.UDMTF.ParagraphBegin(asAlign = "center")
    loc_res += UDmain.UDMTF.LineGap()
    
    loc_res += UDmain.UDMTF.Text("Durability: " + FormatFloat(akDevice.getDurability(), 1) + "/" + FormatFloat(akDevice.getMaxDurability(), 1))
    loc_res += UDmain.UDMTF.LineBreak()
    loc_res += UDmain.UDMTF.Text("Condition: " + FormatFloat(akDevice.getCondition(), 1) + "/100")
    loc_res += UDmain.UDMTF.LineBreak()
    
    loc_res += UDmain.UDMTF.ParagraphEnd()
    loc_res += UDmain.UDMTF.FontEnd()
    Return loc_res
EndFunction

Function showDebugMenu(int slot_id)
    if slot_id >= 0 && slot_id < UD_equipedCustomDevices.length && slot_id < _iUsedSlots
    UD_CustomDevice_RenderScript selectedDevice = UD_equipedCustomDevices[slot_id]
        while UD_equipedCustomDevices[slot_id] == selectedDevice && UD_equipedCustomDevices[slot_id]
            Float[] loc_vals = new Float[3]
            loc_vals[0] = UD_equipedCustomDevices[slot_id].getDurability()
            loc_vals[1] = UD_equipedCustomDevices[slot_id].getMaxDurability()
            loc_vals[2] = 100.0 - UD_equipedCustomDevices[slot_id].getCondition()
            String loc_str = _GetDebugMenuText(UD_equipedCustomDevices[slot_id])
            Int loc_res = UDMain.UDMMM.ShowMessageBoxMenu(UDCDmain.DebugMessage, loc_vals, loc_str, UDMain.UDMMM.NoButtons, UDMain.UDMTF.HasHtmlMarkup(), False)
            if loc_res == 0 ;dmg dur
                UD_equipedCustomDevices[slot_id].decreaseDurabilityAndCheckUnlock(10.0)
                if UD_equipedCustomDevices[slot_id].isUnlocked
                    return
                endif
            elseif loc_res == 1 ;repair dur
                UD_equipedCustomDevices[slot_id].decreaseDurabilityAndCheckUnlock(-10.0)
            elseif loc_res == 2 ;repatch
                if UD_equipedCustomDevices[slot_id].deviceRendered.hasKeyword(UDmain.UDlibs.PatchedDevice) ;patched device
                    
                    UD_equipedCustomDevices[slot_id].patchDevice()
                else
                    UDmain.Print("Cant repatch device as device is not patched")
                endif
                return
            elseif loc_res == 3 ;unlock
                UD_equipedCustomDevices[slot_id].unlockRestrain()
                return
            elseif loc_res == 4 ;unregister
                unregisterDevice(UD_equipedCustomDevices[slot_id])
                return
            elseif loc_res == 5 ;activate
                UD_equipedCustomDevices[slot_id].activateDevice()
                return
            elseif loc_res == 6 ;Add modifier
                UDmain.UDMOM.Debug_AddModifier(UD_equipedCustomDevices[slot_id])
            elseif loc_res == 7 ;Remove modifier
                UDmain.UDMOM.Debug_RemoveModifier(UD_equipedCustomDevices[slot_id])
            else
                return
            endif
        endwhile
    endif
EndFunction

Function update(float fTimePassed)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        DeviceUpdate(UD_equipedCustomDevices[i],fTimePassed)
        i+=1
    endwhile
EndFunction

Function DeviceUpdate(UD_CustomDevice_RenderScript akDevice,Float afTimePassed)
    if akDevice.isReady()
        akDevice.update(afTimePassed)
    endif
EndFunction

Function updateDeviceHour()
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].isReady()
            UD_equipedCustomDevices[i].updateHour()
        endif
        i+=1
    endwhile
EndFunction

Function updateHour()
    UpdateMotivationToDef(GetActor(),20) ;decrease/increase motivation so it will finally reach default 100
EndFunction

;returns first device which have connected corresponding Inventory Device
UD_CustomDevice_RenderScript Function getDeviceByInventory(Armor deviceInventory)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].deviceInventory == deviceInventory
            return UD_equipedCustomDevices[i]
        endif
        i+=1
    endwhile
    return none
EndFunction

;returns first device which have connected corresponding Render Device
UD_CustomDevice_RenderScript Function getDeviceByRender(Armor deviceRendered)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].deviceRendered == deviceRendered
            return UD_equipedCustomDevices[i]
        endif
        i+=1
    endwhile
    return none
EndFunction

;returns heavy bondage (hand restrain) device
UD_CustomDevice_RenderScript Function getHeavyBondageDevice()
    int size = UD_equipedCustomDevices.length
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].isHeavyBondage()
            return UD_equipedCustomDevices[i]
        endif
        i+=1
    endwhile
    
    return none
EndFunction

;returs first device by keywords
;mod = 0 => AND     (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
UD_CustomDevice_RenderScript Function getFirstDeviceByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
    if !kw2
        kw2 = kw1
    endif
    
    if !kw3
        kw3 = kw1
    endif
    
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if mod == 0
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                return UD_equipedCustomDevices[i]
            endif
        elseif mod == 1
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                return UD_equipedCustomDevices[i]
            endif
        endif
        i+=1
    endwhile
    return none
EndFunction

;returns last device containing keyword
UD_CustomDevice_RenderScript Function getLastDeviceByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
    if !kw2
        kw2 = kw1
    endif
    
    if !kw3
        kw3 = kw1
    endif
    
    int i = _iUsedSlots
    while i
        i-=1
        if mod == 0
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                return UD_equipedCustomDevices[i]
            endif
        elseif mod == 1
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                return UD_equipedCustomDevices[i]
            endif
        endif
    endwhile
    return none
EndFunction

;returs first device by keywords
;mod = 0 => AND     (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
UD_CustomDevice_RenderScript Function getDeviceByKeyword(keyword akKeyword)
    if !akKeyword
        UDmain.Error(getSlotedNPCName() + " slot - getDeviceByKeyword - keyword = none")
        return none
    endif
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].UD_DeviceKeyword == (akKeyword)
            return UD_equipedCustomDevices[i]
        endif
        i+=1
    endwhile
    return none
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND     (device need all provided keyword)
;mod = 1 => OR         (device need one provided keyword)
UD_CustomDevice_RenderScript[] Function getAllDevicesByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
    if !kw2
        kw2 = kw1
    endif
    
    if !kw3
        kw3 = kw1
    endif
    
    UD_CustomDevice_RenderScript[] res = UDCDMain.MakeNewDeviceSlots()
    int found_devices = 0
    int size = UD_equipedCustomDevices.length
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if mod == 0
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                res[found_devices] = UD_equipedCustomDevices[i]
                found_devices += 1
            endif
        elseif mod == 1
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                res[found_devices] = UD_equipedCustomDevices[i]
                found_devices += 1
            endif
        endif
        i+=1
    endwhile
    return res
EndFunction

;returns array of all device containing keyword in their render device
;mod = 0 => AND     (device need all provided keyword)
;mod = 1 => OR         (device need one provided keyword)
UD_CustomDevice_RenderScript[] Function getAllActivableDevicesByKeyword(bool bCheckCondition, keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
    if !kw2
        kw2 = kw1
    endif
    
    if !kw3
        kw3 = kw1
    endif
    
    UD_CustomDevice_RenderScript[] res = UDCDMain.MakeNewDeviceSlots()
    int found_devices = 0
    int size = UD_equipedCustomDevices.length
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if mod == 0
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                if (UD_equipedCustomDevices[i].canBeActivated() || !bCheckCondition)  && UD_equipedCustomDevices[i].isNotShareActive()
                    res[found_devices] = UD_equipedCustomDevices[i]
                    found_devices += 1
                endif
            endif
        elseif mod == 1
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                if (UD_equipedCustomDevices[i].canBeActivated() || !bCheckCondition) && UD_equipedCustomDevices[i].isNotShareActive()
                    res[found_devices] = UD_equipedCustomDevices[i]
                    found_devices += 1
                endif
            endif
        endif
        i+=1
    endwhile
    return res
EndFunction

;returns number of all device containing keyword in their render device
;mod = 0 => AND     (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
int Function getNumberOfDevicesWithKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
    if !kw2
        kw2 = kw1
    endif
    
    if !kw3
        kw3 = kw1
    endif

    int found_devices = 0
    int size = UD_equipedCustomDevices.length
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if mod == 0
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                found_devices += 1
            endif
        elseif mod == 1
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                found_devices += 1
            endif
        endif
        i+=1
    endwhile
    return found_devices
EndFunction

;returns number of all device containing keyword in their render device
;mod = 0 => AND     (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
int Function getNumberOfActivableDevicesWithKeyword(bool bCheckCondition, keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)
    if !kw2
        kw2 = kw1
    endif
    
    if !kw3
        kw3 = kw1
    endif

    int found_devices = 0
    int size = UD_equipedCustomDevices.length
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if mod == 0
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) && UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                if (UD_equipedCustomDevices[i].canBeActivated() || !bCheckCondition) && UD_equipedCustomDevices[i].isNotShareActive()
                    found_devices += 1
                endif
            endif
        elseif mod == 1
            if UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw1) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw2) || UD_equipedCustomDevices[i].deviceRendered.hasKeyword(kw3)
                if (UD_equipedCustomDevices[i].canBeActivated() || !bCheckCondition) && UD_equipedCustomDevices[i].isNotShareActive()
                    found_devices += 1
                endif
            endif
        endif
        i+=1
    endwhile
    return found_devices
EndFunction

;returns number of devices that can be activated
int Function getActiveDevicesNum()
    int found_devices = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].canBeActivated() && UD_equipedCustomDevices[i].isNotShareActive()
            found_devices += 1
        endif
        i+=1
    endwhile
    return found_devices
EndFunction

;returns all device that can be activated
UD_CustomDevice_RenderScript[] Function getActiveDevices()
    UD_CustomDevice_RenderScript[] res = UDCDMain.MakeNewDeviceSlots()
    int found_devices = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].canBeActivated() && UD_equipedCustomDevices[i].isNotShareActive()
            res[found_devices] = UD_equipedCustomDevices[i]
            found_devices += 1
        endif
        i+=1
    endwhile
    return res
EndFunction


Function TurnOffAllVibrators()
    if UDmain.TraceAllowed()    
        UDmain.Log("TurnOffAllVibrators() called for " + getSlotedNPCName(),1)
    endif
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        UD_CustomVibratorBase_RenderScript loc_vib = (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript)
        if loc_vib && !(loc_vib as UD_ControlablePlug_RenderScript)
            ;do not stp vibrators which are turned or forever
            if loc_vib.isVibrating() && !loc_vib.isVibratingForever()
                if UDmain.TraceAllowed()
                    UDmain.Log("Stoping " + UD_equipedCustomDevices[i].getDeviceName() + " on " + getSlotedNPCName())
                endif
                (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript).stopVibrating()
            endif
        endif
        i+=1
    endwhile
EndFunction

;returns number of vibrators
int Function getVibratorNum()
    if UDmain.TraceAllowed()    
        UDmain.Log("getVibratorNum() called for " + getSlotedNPCName(),3)
    endif
    int found_devices = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
            found_devices += 1
        endif
        i+=1
    endwhile
    if UDmain.TraceAllowed()    
        UDmain.Log("getOffVibratorNum() - return value: " + found_devices,3)
    endif
    return found_devices
EndFunction

;returns number of vibrators
int Function getActivableVibratorNum()
    int found_devices = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        UD_CustomVibratorBase_RenderScript loc_vib = UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
        if loc_vib
            if loc_vib.canVibrate()
                found_devices += 1
            endif
        endif
        i+=1
    endwhile
    return found_devices
EndFunction

;returns number of turned off vibrators (and the ones which can be turned on)
int Function getOffVibratorNum()
    if UDmain.TraceAllowed()    
        UDmain.Log("getOffVibratorNum() called for " + getSlotedNPCName(),3)
    endif
    int found_devices = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
            UD_CustomVibratorBase_RenderScript loc_vibrator = (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript)
            if loc_vibrator.CanVibrate() && !loc_vibrator.isVibrating()
                found_devices += 1
            endif
        endif
        i+=1
    endwhile
    if UDmain.TraceAllowed()    
        UDmain.Log("getOffVibratorNum() - return value: " + found_devices,3)
    endif
    return found_devices
EndFunction

;returns all vibrators
UD_CustomDevice_RenderScript[] Function getVibrators()
    if UDmain.TraceAllowed()    
        UDmain.Log("getVibrators() called for " + getSlotedNPCName(),3)
    endif
    UD_CustomDevice_RenderScript[] res = UDCDmain.MakeNewDeviceSlots()
    int found_devices = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
            UD_CustomVibratorBase_RenderScript loc_vibrator = (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript)
            ;if loc_vibrator.CanVibrate()
                if UDmain.TraceAllowed()                
                    UDmain.Log("getVibrators() - usable vibrator found: " + loc_vibrator.getDeviceName(),3)
                endif
                res[found_devices] = loc_vibrator
                found_devices += 1
            ;endif
        endif
        i+=1
    endwhile
    if UDmain.TraceAllowed()    
        UDmain.Log("getVibrators() - return array: " + res,3)
    endif
    return res
EndFunction

;returns all turned off vibrators
UD_CustomDevice_RenderScript[] Function getOffVibrators()
    if UDmain.TraceAllowed()    
        UDmain.Log("getOffVibrators() called for " + getSlotedNPCName(),3)
    endif
    UD_CustomDevice_RenderScript[] res = UDCDmain.MakeNewDeviceSlots()
    int found_devices = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
            if UDmain.TraceAllowed()            
                UDmain.Log("getOffVibrators() - vibrator found: " + UD_equipedCustomDevices[i].getDeviceName(),3)
            endif
            UD_CustomVibratorBase_RenderScript loc_vibrator = (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript)
            if loc_vibrator.CanVibrate() && !loc_vibrator.isVibrating()
                if UDmain.TraceAllowed()                
                    UDmain.Log("getOffVibrators() - non used vibrator found: " + UD_equipedCustomDevices[i].getDeviceName(),3)
                endif
                res[found_devices] = loc_vibrator
                found_devices += 1
            endif
        endif
        i+=1
    endwhile
    if UDmain.TraceAllowed()    
        UDmain.Log("getOffVibrators() - return array: " + res,3)
    endif
    return res
EndFunction

;returns all turned activable vibrators
UD_CustomDevice_RenderScript[] Function getActivableVibrators()
    UD_CustomDevice_RenderScript[] res = UDCDmain.MakeNewDeviceSlots()
    int found_devices = 0
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript
            UD_CustomVibratorBase_RenderScript loc_vibrator = (UD_equipedCustomDevices[i] as UD_CustomVibratorBase_RenderScript)
            if loc_vibrator.CanVibrate()
                res[found_devices] = loc_vibrator
                found_devices += 1
            endif
        endif
        i+=1
    endwhile
    return res
EndFunction

;returns current device that have minigame on (return none if no minigame is on)
UD_CustomDevice_RenderScript Function getMinigameDevice()
    int size = UD_equipedCustomDevices.length
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i].isMinigameOn()
            return UD_equipedCustomDevices[i]
        endif
        i+=1
    endwhile
    
    return none
EndFunction

bool Function hasFreeHands(bool checkGrasp = false)
    bool res = !getActor().wornhaskeyword(UDCDmain.libs.zad_deviousHeavyBondage) 
        
    if checkGrasp
        if getActor().wornhaskeyword(UDCDmain.libs.zad_DeviousBondageMittens)
            res = false
        endif
    endif
    return res
EndFunction

bool Function isPlayer()
    return False
EndFunction

Bool Function isFollower()
    return UDmain.ActorIsFollower(GetActor())
EndFunction

bool Function isUsed()
    if getActor()
        return true
    else
        return false
    endif
EndFunction

Bool Function IsInMinigame()
    Actor loc_actor = getActor()
    if loc_actor
        return loc_actor.IsInFaction(UDCDmain.MinigameFaction)
    else
        return false
    endif
EndFunction

Bool Function HaveLockingOperations()
    Actor loc_actor = getActor()
    if loc_actor
        return StorageUtil.GetIntValue(loc_actor,"UDLockOperations",0)
    else
        return 0
    endif
EndFunction

String Function getSlotedNPCName()
    if isUsed()
        return (getActorReference()).getLeveledActorBase().getName()
    else
        return "Empty"
    endif
EndFunction

Actor Function getActor()
    return self.getActorReference()
EndFunction

int Function removeWrongWearerDevices()
    ;startDeviceManipulation()
    int res = 0
    int i = 0
    Actor _currentSlotedActor = getActor()
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if (UD_equipedCustomDevices[i].getWearer() != _currentSlotedActor) || UD_equipedCustomDevices[i].isUnlocked
            res += unregisterDevice(UD_equipedCustomDevices[i],i,False)
        endif
        i+=1
    endwhile
    ;endDeviceManipulation()
    if res > 0
        sortSlots()
    endif
    return res
EndFunction

Function resetValues()
    _iScriptState = 1
EndFunction

bool _regainMutex = false
Function regainDevices()
    Actor _currentSlotedActor = getActor()
    if _currentSlotedActor.GetItemCount(UDCDmain.UDlibs.PatchedInventoryDevice) == 0 || _currentSlotedActor.GetItemCount(UDCDmain.UDlibs.UnforgivingDevice) == 0
        return
    endif
    
    while _regainMutex
        Utility.waitMenuMode(0.1)
    endwhile
    _regainMutex = True
    
    ;super complex shit
    ;int removedDevices = removeWrongWearerDevices()
    
    ;Armor[] loc_devices = zadNativeFunctions.GetDevices(_currentSlotedActor,1,true)
    ;UDmain.Info("Registering " + loc_devices.length + " devices")
    
    int loc_registered = UD_Native.RegisterDeviceScripts(_currentSlotedActor)
    
    UDmain.Info("Registered " + loc_registered + " devices")
    ;wait for all devices to get registered
    ;float loc_timeout = 3.0
    ;while (_iUsedSlots != loc_toregister) && (loc_timeout > 0.0)
    ;    Utility.waitMenuMode(0.1)
    ;    loc_timeout -= 0.1
    ;endwhile
    
    _regainMutex = False
EndFunction

Weapon Function GetBestWeapon()
    return UD_Native.GetSharpestWeapon(getActor())
EndFunction

Function UpdateSkills()
    AgilitySkill    = UDmain.UDSKILL.getActorAgilitySkills(getActor())
    StrengthSkill   = UDmain.UDSKILL.getActorStrengthSkills(getActor())
    MagickSkill     = UDmain.UDSKILL.getActorMagickSkills(getActor())
    CuttingSkill    = UDmain.UDSKILL.getActorCuttingSkills(getActor())
    SmithingSkill   = UDmain.UDSKILL.getActorSmithingSkills(getActor())
EndFunction


;===============================================================================
;===============================================================================
;                                    MUTEX
;===============================================================================
;===============================================================================

;LOCK MUTEX
bool        Property UD_GlobalDeviceMutex_InventoryScript                   = false     auto hidden
Int         Property UD_GlobalDeviceMutex_InventoryScript_Failed            = 0         auto hidden
Armor       Property UD_GlobalDeviceMutex_Device                            = none      auto hidden

;UNLOCK MUTEX
bool        Property UD_GlobalDeviceUnlockMutex_InventoryScript             = false     auto hidden
bool        Property UD_GlobalDeviceUnlockMutex_InventoryScript_Failed      = false     auto hidden
Armor       Property UD_GlobalDeviceUnlockMutex_Device                      = none      auto hidden

Keyword     Property UD_UnlockToken                                         = none      auto hidden    

Function ResetMutex_Lock(Armor invDevice)
    if UDmain.TraceAllowed()
        UDmain.Log(self+"::ResetMutex_Lock()",2)
    endif
    UD_GlobalDeviceMutex_inventoryScript                = false
    UD_GlobalDeviceMutex_InventoryScript_Failed         = 0
    UD_GlobalDeviceMutex_Device                         = invDevice
EndFunction

Function ResetMutex_Unlock(Armor invDevice)
    if UDmain.TraceAllowed()
        UDmain.Log(self+"::ResetMutex_Unlock()",2)
    endif
    UD_GlobalDeviceUnlockMutex_InventoryScript            = false
    UD_GlobalDeviceUnlockMutex_InventoryScript_Failed     = false
    UD_UnlockToken                                        = none
    UD_GlobalDeviceUnlockMutex_Device                     = invDevice
EndFunction

Bool Function IsMutexOn()
    return _LOCKDEVICE_MUTEX || _UNLOCKDEVICE_MUTEX
EndFunction

;function made as replacemant for akActor.isEquipped, because that function doesn't work for NPCs
bool Function CheckRenderDeviceEquipped(Armor rendDevice)
    if !isUsed()
        return false
    endif
    
    int loc_mask = 0x00000001
    while loc_mask != 0x80000000
        Form loc_armor = getActor().GetWornForm(loc_mask)
        if loc_armor ;check if there is anything in slot
            if (loc_armor as Armor) == rendDevice
                return true ;render device is equipped
            endif
        endif
        loc_mask = Math.LeftShift(loc_mask,1)
    endwhile
    return false ;device is not equipped
EndFunction

Bool _LOCKDEVICE_MUTEX = false
Function StartLockMutex()
    while _LOCKDEVICE_MUTEX
        Utility.waitMenuMode(0.1)
    endwhile
    _LOCKDEVICE_MUTEX = true
    GoToState("UpdatePaused")
    if UDmain.TraceAllowed()
        UDmain.Log(self+"::StartLockMutex()",2)
    endif
EndFunction

Function EndLockMutex()
    if UDmain.TraceAllowed()
        UDmain.Log(self+"::EndLockMutex()",2)
    endif
    GoToState("")
    UD_GlobalDeviceMutex_Device = none
    UD_GlobalDeviceMutex_InventoryScript = false
    UD_GlobalDeviceMutex_InventoryScript_Failed = 0
    _LOCKDEVICE_MUTEX = false
EndFunction

Bool Function IsLockMutexed(Armor invDevice)
    return UD_GlobalDeviceMutex_Device == invDevice
EndFunction

Bool _UNLOCKDEVICE_MUTEX = false
Function StartUnLockMutex()
    while _UNLOCKDEVICE_MUTEX
        Utility.waitMenuMode(0.1)
    endwhile
    _UNLOCKDEVICE_MUTEX = true
    GoToState("UpdatePaused")
    if UDmain.TraceAllowed()
        UDmain.Log(self+"::StartUnLockMutex()",2)
    endif
EndFunction

Function EndUnLockMutex()
    if UDmain.TraceAllowed()
        UDmain.Log(self+"::EndUnLockMutex()",2)
    endif
    GoToState("")
    UD_GlobalDeviceUnlockMutex_Device = none
    UD_GlobalDeviceUnlockMutex_InventoryScript = false
    UD_GlobalDeviceUnlockMutex_InventoryScript_Failed = false
    _UNLOCKDEVICE_MUTEX = false
EndFunction

Bool Function IsUnlockMutexed(Armor invDevice)
    return UD_GlobalDeviceUnlockMutex_Device == invDevice
EndFunction

Function ProccesLockMutex()
    if UDmain.TraceAllowed()
        UDmain.Log(self+"::ProccesLockMutex()",2)
    endif
    float loc_time = 0.0
    while loc_time <= UDmain.UDGV.UD_MutexTimeout && (!UD_GlobalDeviceMutex_InventoryScript)
        Utility.waitMenuMode(0.01)
        loc_time += 0.01
    endwhile
    
    if UDmain.IsAnyMenuOpenRT() && loc_time >= UDmain.UDGV.UD_MutexTimeout && !IsPlayer()
        if UDmain.TraceAllowed()
            UDmain.Log(self+"::ProccesLockMutex() - Timeout on NPC, waiting for menu to close and try again",2)
        endif
        Utility.wait(0.01)
        loc_time = 0.0
        while loc_time <= UDmain.UDGV.UD_MutexTimeout && (!UD_GlobalDeviceMutex_InventoryScript)
            Utility.waitMenuMode(0.01)
            loc_time += 0.01
        endwhile
    endif
    
    if loc_time >= UDmain.UDGV.UD_MutexTimeout
        UD_GlobalDeviceMutex_InventoryScript_Failed = 8
    endif
    
    if UD_GlobalDeviceMutex_InventoryScript_Failed
        UDCDMain.DeviceLockIssueReport(GetActor(),UD_GlobalDeviceMutex_Device,UD_GlobalDeviceMutex_InventoryScript_Failed)
    endif
    
    UD_GlobalDeviceMutex_Device = none
EndFunction

Function ProccesUnlockMutex()
    if UDmain.TraceAllowed()
        UDmain.Log(self+"::ProccesUnlockMutex()",2)
    endif
    float loc_time = 0.0
    bool  loc_failed = false
    while loc_time <= UDmain.UDGV.UD_MutexTimeout && (!UD_GlobalDeviceUnlockMutex_InventoryScript)
        Utility.waitMenuMode(0.01)
        loc_time += 0.01
    endwhile
    
    if UDmain.IsAnyMenuOpenRT() && loc_time >= UDmain.UDGV.UD_MutexTimeout && !IsPlayer()
        if UDmain.TraceAllowed()
            UDmain.Log(self+"::ProccesUnlockMutex() - Timeout on NPC, waiting for menu to close and try again",2)
        endif
        Utility.wait(0.01)
        loc_time = 0.0
        while loc_time <= UDmain.UDGV.UD_MutexTimeout && (!UD_GlobalDeviceUnlockMutex_InventoryScript)
            Utility.waitMenuMode(0.01)
            loc_time += 0.01
        endwhile
    endif
    
    if UD_GlobalDeviceUnlockMutex_InventoryScript_Failed || loc_time >= UDmain.UDGV.UD_MutexTimeout
        UDmain.Error("UnLockDevicePatched("+GetSlotedNPCName()+","+UD_GlobalDeviceUnlockMutex_Device.getName()+") failed!!! ID Fail? " + UD_GlobalDeviceUnlockMutex_InventoryScript_Failed)
    endif
    
    UD_GlobalDeviceUnlockMutex_Device = none
EndFunction

;===============================================================================
;===============================================================================
;                             AROUSAL/ORGASM UPDATE
;===============================================================================
;===============================================================================

;Arousal update
Float _dfArousal = 0.0

Function InitArousalUpdate()
    ;GetActor().AddToFaction(UDOM.ArousalCheckLoopFaction)
EndFunction

Function UpdateArousal(Int aiUpdateTime)
    ;Actor   loc_actor       = GetActor()
    ;if loc_actor
    ;    ;libs.Aroused.SetActorExposure(loc_actor, Round(OrgasmSystem.GetOrgasmVariable(loc_actor,8)))
    ;    ;UDOM.UpdateArousal(loc_actor ,Round(OrgasmSystem.GetOrgasmVariable(8)))
    ;else
    ;    UDmain.Error(self + "::Cant update arousal  because sloted actor is none!")
    ;endif
EndFunction

Function CleanArousalUpdate()
    if GetActor()
        ;GetActor().RemoveFromFaction(UDOM.ArousalCheckLoopFaction)
    endif
EndFunction

;Orgasm update
float   _currentUpdateTime       = 1.0
bool    _actorinminigame         = false
int     _tick                    = 1
int     _tickS                   = 0
int     _hornyAnimTimer          = 0
bool[]  _cameraState
int     _msID                    = -1

UD_WidgetMeter_RefAlias _orgasmMeterIWW
UD_WidgetBase           _orgasmMeterSkyUi
sslBaseExpression expression
float[] _org_expression
float[] _org_expression2
float[] _org_expression3

Function InitOrgasmUpdate()
    Actor loc_actor = GetActor()
    if loc_actor
        _tick                       = 1
        _tickS                      = 0
        _hornyAnimTimer             = 0
        _msID                       = -1
        _actorinminigame            = UDCDMain.actorInMinigame(loc_actor)
        
        _OrgasmGameUpdate()
    endif
EndFunction

Function _OrgasmGameUpdate()
    OrgasmSystem.RegisterForOrgasmEvent_Ref(self)
    RegisterForModEvent("ORS_LinkedWidgetUpdate", "ORSLinkedWidgetUpdate")
    
    if IsPlayer()
        UDmain.UDWC.Meter_RegisterNative("player-orgasm",0,0.0,0.0, true)
        UDmain.UDWC.Meter_LinkActorOrgasm(GetActor(),"player-orgasm")
    endif
EndFunction

Function UpdateOrgasm(Float afUpdateTime)
    if !UDmain.IsEnabled() || (UD_Native.GetCameraState() == 3)
        return
    endif
    _currentUpdateTime = afUpdateTime
    
    Actor akActor = GetActor()
    
    CalculateOrgasmProgress()
    
    if _tick * afUpdateTime >= 1.0
        UpdateOrgasmSecond()
        _UpdateOrgasmExhaustion(Round(afUpdateTime))
    endif
    _tick += 1
EndFunction

Function ORSEvent_OnActorOrgasm(Actor akActor, float afOrgasmRate, float afArousal, float afHornyLevel, int aiOrgasmCount)
    if (GetActor() == akActor)
        _hornyAnimTimer  = -45 ;cooldown
    endif
EndFunction

Function CalculateOrgasmProgress()
    Actor akActor = GetActor()
    _actorinminigame    = UDCDMain.actorInMinigame(akActor)
EndFunction

Function UpdateOrgasmSecond()
    Actor akActor = GetActor()
    Bool  loc_is3dLoaded = IsPlayer() || akActor.Is3DLoaded()
    
    _tick = 0
    _tickS += 1
    
    if loc_is3dLoaded
        if (OrgasmSystem.GetOrgasmVariable(akActor,1) > 0.5*OrgasmSystem.GetOrgasmVariable(akActor,4)*OrgasmSystem.GetOrgasmVariable(akActor,3)) 
            ;start moaning sound again. Not play when actor orgasms
            if _msID == -1 && !OrgasmSystem.GetOrgasmingCount(akActor) && !_actorinminigame
                _msID = libs.MoanSound.Play(akActor)
                Sound.SetInstanceVolume(_msID, fRange(OrgasmSystem.GetOrgasmProgress(akActor,1)*2.0,0.75,1.0)*libs.GetMoanVolume(akActor,Round(OrgasmSystem.GetOrgasmVariable(akActor,8))))
            endif
        else
            ;disable moaning sound when orgasm rate is too low
            if _msID != -1
                Sound.StopInstance(_msID)
                _msID = -1
            endif
        endif
        
        ;can play horny animation ?
        UpdateOrgasmHornyAnimation()
    else
        ;stop moan sound if actor is out of range
        if _msID != -1
            Sound.StopInstance(_msID)
            _msID = -1
        endif
    endif
EndFunction

Function ORSLinkedWidgetUpdate(String asEventName, String asUnused, Float afMod, Form akActorF)
    if (GetActor() != (akActorF as Actor))
        return
    endif
    
    Actor akActor = akActorF as Actor
    if UDCONF.UD_UseOrgasmWidget
        if afMod == 0.0
            UDmain.UDWC.Meter_SetVisible("player-orgasm", True)
        else
            UDmain.UDWC.Meter_SetVisible("player-orgasm", False)
        endif
    endif
EndFunction

String[] _HornyAnimDefs
Int _ActorConstraints = -1

FUnction UpdateOrgasmHornyAnimation()
    Actor akActor = GetActor()
    if !_actorinminigame 
        bool loc_orgasmResisting = akActor.isInFaction(UDOM.OrgasmResistFaction)
        if (_hornyAnimTimer == 0) && UDCONF.UD_HornyAnimation && (OrgasmSystem.GetOrgasmVariable(akActor,1) > 0.5*OrgasmSystem.GetOrgasmVariable(akActor,4)*OrgasmSystem.GetOrgasmVariable(akActor,3)) && !loc_orgasmResisting && !akActor.IsInCombat() ;orgasm progress is increasing
            if !UDmain.UDAM.IsAnimating(akActor) ;start horny animation for UD_HornyAnimationDuration
                if RandomInt(0,99) <= 10 + Round(10*(fRange(OrgasmSystem.GetOrgasmProgress(akActor),0.0,50.0)/50.0))
                    ; Requesting and selecting animation
                    Int loc_constraints = UDmain.UDAM.GetActorConstraintsInt(akActor, abUseCache = False)
                    If _ActorConstraints != loc_constraints
                        _ActorConstraints = loc_constraints
                        _HornyAnimDefs = UDmain.UDAM.GetHornyAnimDefs(akActor)
                    EndIf
                    If _HornyAnimDefs.Length > 0
                        Actor[] loc_actors = new Actor[1]
                        loc_actors[0] = akActor
                        UDmain.UDAM.PlayAnimationByDef(_HornyAnimDefs[RandomInt(0, _HornyAnimDefs.Length - 1)], loc_actors)
                    Else
                        UDmain.Warning("UD_CustomDevice_NPCSlot::UpdateOrgasmHornyAnimation() Can't find horny animations for the actor")
                    EndIf
                    _hornyAnimTimer += UDCONF.UD_HornyAnimationDuration
                Else
                    _hornyAnimTimer = -3 ;3s cooldown
                endif
            Endif
        endif
        
        if !loc_orgasmResisting
            if _hornyAnimTimer > 0 ;reduce horny animation timer 
                _hornyAnimTimer -= 1
                if (_hornyAnimTimer == 0)
                    UDmain.UDAM.StopAnimation(akActor)
                    _hornyAnimTimer = -20 ;cooldown
                EndIf
            elseif _hornyAnimTimer < 0 ;cooldown
                _hornyAnimTimer += 1
            endif
        endif
    endif
EndFunction

Function CleanOrgasmUpdate()
    Actor akActor = GetActor()
    ;stop moan sound
    if _msID != -1
        Sound.StopInstance(_msID)
    endif
    
    ;end animation if it still exist
    if  _hornyAnimTimer > 0 && akActor
        libs.EndThirdPersonAnimation(akActor, _cameraState, permitRestrictive=true)
        _hornyAnimTimer = 0
    EndIf
    
    ;hide widget
    UDmain.UDWC.Meter_UnlinkActorOrgasm(akActor)

    ;reset expression
    if akActor
        libs.ExpLibs.ResetExpressionRaw(akActor, 10)
    endif
    
    ;end mutex
EndFunction

Function VibrateUpdate(Int aiUpdateTime)
    int i = 0
    while (i < UD_ActiveVibrators.length) && UD_ActiveVibrators[i]
        UD_CustomVibratorBase_RenderScript loc_vib = UD_ActiveVibrators[i] as UD_CustomVibratorBase_RenderScript
        if loc_vib
            loc_vib.VibrateUpdate(aiUpdateTime)
        endif
        i+=1
    endwhile
EndFunction

Function EndAllVibrators()
    int i = 0
    while (i < UD_ActiveVibrators.length) && UD_ActiveVibrators[i]
        UD_CustomVibratorBase_RenderScript loc_vib = UD_ActiveVibrators[i] as UD_CustomVibratorBase_RenderScript
        if loc_vib
            loc_vib._VibrateEnd(True,False)
            UD_ActiveVibrators[i] = none
        endif
        i+=1
    endwhile
EndFunction

;===============================================================================
;===============================================================================
;                             MINIGAME PARALEL PROCESSES
;===============================================================================
;===============================================================================
;==============================
;           MINIGAME
;==============================

;starter
bool                             _MinigameStarter_ON                         = false
bool                             _MinigameParalel_ON                         = false
bool                             _MinigameCritLoop_ON                       = false
