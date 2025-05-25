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
UD_CustomDevice_RenderScript            Property UD_LastSelectedDevice      Auto Hidden

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
    String[] loc_devicesString

    If UDCDMain.UD_DeviceListGroups
        loc_devicesString = getDeviceGroupsPremade()
    Else
        loc_devicesString = getDeviceItemsPremade()
    EndIf
    loc_devicesString = PapyrusUtil.PushString(loc_devicesString, _getHeaderListItem("(CLOSE)") + ";;-1;;-10;;button;;0")

    Int loc_deviceIndx = -1
    If UDCDMain.UD_DeviceListEx
        loc_deviceIndx = UDmain.GetUserListInputEx(loc_devicesString, aiListWidth = 440, aiEntryHeight = 22)
    Else
        loc_deviceIndx = UDmain.GetUserListInput(loc_devicesString, abPremade = True)
    EndIf
    
    if loc_deviceIndx < UD_equipedCustomDevices.Length && loc_deviceIndx >= 0
        UD_CustomDevice_RenderScript loc_device = UD_equipedCustomDevices[loc_deviceIndx]
        If loc_device != None
            UD_LastSelectedDevice = loc_device
;            ReorderSlots(loc_device)
        EndIf
        return loc_device
    else
        return none
    endif
EndFunction

String[] Function getSlotsStringA()
    String[] loc_res
    If UDCDMain.UD_DeviceListLastOnTop && UD_LastSelectedDevice != None
        loc_res = PapyrusUtil.PushString(loc_res, UD_LastSelectedDevice.getDeviceName())
    EndIf
    int loc_i = 0
    while (loc_i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[loc_i]
        If !UDCDMain.UD_DeviceListLastOnTop || UD_LastSelectedDevice != UD_equipedCustomDevices[loc_i]
            loc_res = PapyrusUtil.PushString(loc_res, UD_equipedCustomDevices[loc_i].getDeviceName())
        EndIf
        loc_i+=1
    endwhile
    return loc_res
EndFunction

String[] Function getDeviceItemsPremade()
    String[] loc_res
    String loc_str = ""
    int loc_i = 0
    while (loc_i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[loc_i]
        loc_str = _getDeviceListItem(UD_equipedCustomDevices[loc_i]) + ";;-1;;" + (loc_i as String) + ";;device;;0"
        If UDCDMain.UD_DeviceListLastOnTop && UD_LastSelectedDevice == UD_equipedCustomDevices[loc_i]
            String[] loc_temp_arr = new String[1]
            loc_temp_arr[0] = loc_str
            loc_res = PapyrusUtil.MergeStringArray(loc_temp_arr, loc_res)
        Else
            loc_res = PapyrusUtil.PushString(loc_res, loc_str)
        EndIf
        loc_i += 1
    endwhile
    return loc_res
EndFunction

String[] Function getDeviceGroupsPremade()
    String[] loc_res
    String[] loc_res_head
    String[] loc_res_arms
    String[] loc_res_upper
    String[] loc_res_lower
    String[] loc_res_legs

    Int loc_slots_head =  0x0200F823    ; 0x00004000 | 0x00008000 | 0x02000000 | 0x00000001 | 0x00001000 | 0x00000020 | 0x00000002 | 0x00000800 | 0x00002000
    Int loc_slots_arms =  0x20010058    ; 0x00000008 | 0x00000010 | 0x00000040 | 0x00010000 | 0x20000000
    Int loc_slots_upper = 0x14200004    ; 0x00000004 | 0x00200000 | 0x10000000 | 0x04000000 
    Int loc_slots_lower = 0x081C0400    ; 0x00040000 | 0x00080000 | 0x00100000 | 0x08000000 | 0x00000400 
    Int loc_slots_legs =  0x00800180    ; 0x00000080 | 0x00000100 | 0x00800000 

    int loc_i = 0
    while (loc_i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[loc_i]
        Int loc_slot = UD_equipedCustomDevices[loc_i].deviceRendered.GetSlotMask()
        String loc_str = _getDeviceListItem(UD_equipedCustomDevices[loc_i]) + ";;-1;;" + (loc_i as String) + ";;device;;0"
        If UDCDMain.UD_DeviceListLastOnTop && UD_LastSelectedDevice == UD_equipedCustomDevices[loc_i]
            loc_res = PapyrusUtil.PushString(loc_res, loc_str)
        EndIf
        If Math.LogicalAnd(loc_slot, loc_slots_head) > 0
            loc_res_head = PapyrusUtil.PushString(loc_res_head, loc_str)
        EndIf
        If Math.LogicalAnd(loc_slot, loc_slots_arms) > 0
            loc_res_arms = PapyrusUtil.PushString(loc_res_arms, loc_str)
        EndIf
        If Math.LogicalAnd(loc_slot, loc_slots_upper) > 0
            loc_res_upper = PapyrusUtil.PushString(loc_res_upper, loc_str)
        EndIf
        If Math.LogicalAnd(loc_slot, loc_slots_lower) > 0
            loc_res_lower = PapyrusUtil.PushString(loc_res_lower, loc_str)
        EndIf
        If Math.LogicalAnd(loc_slot, loc_slots_legs) > 0
            loc_res_legs = PapyrusUtil.PushString(loc_res_legs, loc_str)
        EndIf
        loc_i += 1
    endwhile

    loc_res = PapyrusUtil.PushString(loc_res, _getHeaderListItem("--HEAD--") + ";;-1;;-2;;separator;;0")
    loc_res = PapyrusUtil.MergeStringArray(loc_res, loc_res_head)
    loc_res = PapyrusUtil.PushString(loc_res, _getHeaderListItem("--ARMS--") + ";;-1;;-3;;separator;;0")
    loc_res = PapyrusUtil.MergeStringArray(loc_res, loc_res_arms)
    loc_res = PapyrusUtil.PushString(loc_res, _getHeaderListItem("--UPPER BODY--") + ";;-1;;-4;;separator;;0")
    loc_res = PapyrusUtil.MergeStringArray(loc_res, loc_res_upper)
    loc_res = PapyrusUtil.PushString(loc_res, _getHeaderListItem("--LOWER BODY--") + ";;-1;;-5;;separator;;0")
    loc_res = PapyrusUtil.MergeStringArray(loc_res, loc_res_lower)
    loc_res = PapyrusUtil.PushString(loc_res, _getHeaderListItem("--LEGS--") + ";;-1;;-6;;separator;;0")
    loc_res = PapyrusUtil.MergeStringArray(loc_res, loc_res_legs)

    return loc_res
EndFunction

String Function _getDeviceListItem(UD_CustomDevice_RenderScript akDevice)
    String loc_str = ""
    String loc_name = akDevice.getDeviceName()
    If UDCDMain.UD_DeviceListEx && UDMain.UDMTF.HasHtmlMarkup()
        If StringUtil.GetLength(loc_name) > 37
            loc_name = StringUtil.Substring(loc_name, 0, 36) + "..."
        EndIf
        Int loc_health = Round(100 * akDevice.getRelativeDurability())
        String loc_health_str = UDMain.UDMTF.Text((loc_health as String) + "%", asColor = UDMain.UDMTF.PercentToGrayscale(loc_health))
        Int loc_acc = Round(100 * akDevice.getAccesibility())               ; without helper
        String loc_acc_str = UDMain.UDMTF.Text((loc_acc as String) + "%", asColor = UDMain.UDMTF.PercentToRainbow(loc_acc))
        String loc_locks = akDevice.GetLocksIcons(asSeparator = "")
        String[] loc_tags_arr = akDevice.GetModifierTags()
        String loc_tags = ""
        If loc_tags_arr.Length > 0
            loc_tags_arr = PapyrusUtil.RemoveDupeString(loc_tags_arr)
            Int loc_j = 0
            Int loc_tags_length = 0
            While loc_j < loc_tags_arr.Length
                If loc_tags_length > 0
                    loc_tags_length += 1
                    loc_tags += " "
                EndIf
                loc_tags_length += StringUtil.GetLength(loc_tags_arr[loc_j])
                loc_tags += UDMain.UDMTF.Text(loc_tags_arr[loc_j], asColor = UDMain.UDMTF.StringHashToColor(loc_tags_arr[loc_j]))
                loc_j += 1
            EndWhile
            Int loc_tags_font_size = UD_Native.iRange((22 * 16 / loc_tags_length) as Int, 10, 16)                       ; Font size: 10 .. 16. Base length: 22 symbols
            loc_tags = UDMain.UDMTF.AddTag("ucase", loc_tags)                                                           ; decorate with a made-up <ucase> tag to convert this substring to uppercase in swf
            loc_tags = UDMain.UDMTF.Text(loc_tags, aiFontSize = loc_tags_font_size)                                     ; change font size to avoid clipping
        EndIf
        loc_str += UDMain.UDMTF.FontBegin(asFontFace = "$EverywhereFont", aiFontSize = 16)
        loc_str += UDMain.UDMTF.TableBegin(5, 180, 33, 33, 70)                                                      ; 119 on the last column
        loc_str += UDMain.UDMTF.TableRowWide(loc_name, loc_acc_str, loc_health_str, loc_locks, loc_tags)
        loc_str += UDMain.UDMTF.TableEnd()
        loc_str += UDMain.UDMTF.FontEnd()
    Else
        loc_str = loc_name
    EndIf
    Return loc_str
EndFunction

String Function _getHeaderListItem(String asText)
    String loc_str = ""
    If UDCDMain.UD_DeviceListEx && UDMain.UDMTF.HasHtmlMarkup()
        loc_str += UDMain.UDMTF.ParagraphBegin(asAlign = "center")
        loc_str += UDMain.UDMTF.Text(asText, aiFontSize = 16, asFontFace = "$EverywhereBoldFont")
        loc_str += UDMain.UDMTF.ParagraphEnd()
    Else
        loc_str = asText
    EndIf
    Return loc_str
EndFunction

Function ReorderSlots(UD_CustomDevice_RenderScript firstDevice)
    startDeviceManipulation()
    int loc_reorderIndx = GetDeviceSlotIndx(firstDevice)
    int i = loc_reorderIndx 
    while (i < UD_equipedCustomDevices.length)
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
    RegisterEmptyItemEvent()
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
    UnregisterAllItemEvents(True)
    GetModifierTags_Update()
    UD_LastSelectedDevice = None
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
    sortSlots()
    removeCopies()
    removeUnusedDevices()
EndFunction

String Function _GetNPCSlotFixText()
    String loc_res = ""
    
    loc_res += UDmain.UDMTF.Header(GetActor().GetLeveledActorBase().GetName(), UDMain.UDMTF.FontSize + 4)
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
        sortSlots()
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
            GetModifierTags_Update()
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
    Bool loc_sort = False
    If oref == UD_LastSelectedDevice
        UD_LastSelectedDevice = None
    EndIf
    int res = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if UD_equipedCustomDevices[i] == oref
            UD_equipedCustomDevices[i] = none
            _iUsedSlots-=1
            res += 1
        ElseIf res > 0 && UD_equipedCustomDevices[i - res] == None
        ; immediately move all elements after the deleted one
            UD_equipedCustomDevices[i - res] = UD_equipedCustomDevices[i]
            UD_equipedCustomDevices[i] = None
        Else
        ; ???
            ; This is intended behaviour when device is not first element in array and i = 0. Why print warning ???
            ;UDmain.Warning(Self + "::unregisterDevice() Something wrong with UD_equipedCustomDevices array. Unexpected element value.")
            loc_sort = True
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
    if loc_sort
        sortSlots(mutex)
    endif

    GetModifierTags_Update()
    
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
    UD_LastSelectedDevice = None
    int res = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        UD_equipedCustomDevices[i] = none
        _iUsedSlots-=1
        res += 1
        i += 1
    endwhile
    If _iUsedSlots != 0
        UDmain.Warning(Self + "::unregisterAllDevices() _iUsedSlots is not 0 at the end!")
        _iUsedSlots = 0
    EndIf
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
        if UD_equipedCustomDevices[0].isUnlocked
            Utility.waitMenuMode(0.2)
            if UD_equipedCustomDevices[0].isUnlocked
                removeCopies()
                removeUnusedDevices()
                removeLostRenderDevices()
            endif
        endif    
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
            loc_device.onRemoveDevicePost(loc_device.getWearer())
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

Float _LastHitTime = 0.0
Float _LastSpellConcTime = 0.0
Float _LastEnchConcTime = 0.0
Float _LastTrapHitTime = 0.0

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    if !isScriptRunning()
        Return
    EndIf
    If UDmain.TraceAllowed()
        UDmain.Log("UD_CustomDevice_NPCSlot::OnHit() [" + getSlotedNPCName() + "] akAggressor = " + akAggressor + ", akSource = " + akSource + ", akProjectile = " + akProjectile + ", abPowerAttack = " + abPowerAttack + ", abSneakAttack = " + abSneakAttack + ", abBashAttack = " + abBashAttack + ", abHitBlocked = " + abHitBlocked, 3)
    EndIf

    If akSource as Weapon && akProjectile == None
    ; ignoring weapons with projectile because it's their enchantment
        Float loc_dmg = CalculatePhysDamage(akAggressor, akSource, akProjectile, abPowerAttack, abSneakAttack, abBashAttack, abHitBlocked)
        if UDmain.TraceAllowed()
            UDmain.Log("UD_CustomDevice_NPCSlot::OnHit() [" + getSlotedNPCName() + "] Physical damage = " + loc_dmg, 3)
        endif
        If IsTrapHit(akAggressor, akSource)
        ; checking the delta between the current time and the time of the last hit to skip spam
            Float loc_time = Utility.GetCurrentRealTime()
            If loc_time - _LastTrapHitTime < 1.0
                Return
            EndIf
            _LastTrapHitTime = loc_time
        EndIf
        If loc_dmg > 0.0
            OnWeaponHit(akSource as Weapon, loc_dmg)
        EndIf
        If (akSource as Weapon).GetEnchantment() != None
            loc_dmg = CalculateMagDamage(akAggressor, akSource, akProjectile, abPowerAttack, abSneakAttack, abBashAttack, abHitBlocked)
            if UDmain.TraceAllowed()
                UDmain.Log("UD_CustomDevice_NPCSlot::OnHit() [" + getSlotedNPCName() + "] Enchantment (weapon) damage = " + loc_dmg, 3)
            endif
            If loc_dmg > 0.0
                OnSpellHit((akSource as Weapon).GetEnchantment(), loc_dmg)
            EndIf
        EndIf
    ElseIf akSource as Spell
        If UD_Native.IsConcentrationSpell(akSource as Spell)
        ; checking the delta between the current time and the time of the last hit to skip spam
            Float loc_time = Utility.GetCurrentRealTime()
            If loc_time - _LastSpellConcTime < 1.0
                Return
            EndIf
            _LastSpellConcTime = loc_time
        EndIf
        Float loc_dmg = CalculateMagDamage(akAggressor, akSource, akProjectile, abPowerAttack, abSneakAttack, abBashAttack, abHitBlocked)
        If UDmain.TraceAllowed()
            UDmain.Log("UD_CustomDevice_NPCSlot::OnHit() [" + getSlotedNPCName() + "] Spell damage = " + loc_dmg, 3)
        EndIf
        If loc_dmg > 0.0
            OnSpellHit(akSource as Spell, loc_dmg)
        EndIf
    ElseIf akSource as Enchantment != None && akProjectile == None
        If UD_Native.IsConcentrationEnch(akSource as Enchantment)
            Float loc_time = Utility.GetCurrentRealTime()
            If loc_time - _LastEnchConcTime < 1.0
                Return
            EndIf
            _LastEnchConcTime = loc_time
        EndIf
        Float loc_dmg = CalculateMagDamage(akAggressor, akSource, akProjectile, abPowerAttack, abSneakAttack, abBashAttack, abHitBlocked)
        If UDmain.TraceAllowed()
            UDmain.Log("UD_CustomDevice_NPCSlot::OnHit() [" + getSlotedNPCName() + "] Enchantment (staff) damage = " + loc_dmg, 3)
        EndIf
        If loc_dmg > 0.0
            OnSpellHit(akSource as Enchantment, loc_dmg)
        EndIf
    Endif
EndEvent

Function OnWeaponHit(Weapon akSource, Float afDamage = -1.0)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        UD_equipedCustomDevices[i].weaponHit(akSource, afDamage)
        i+=1
    endwhile
EndFunction

Function OnSpellHit(Form akSource, Float afDamage = -1.0)
    int i = 0
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        UD_equipedCustomDevices[i].spellHit(akSource, afDamage)
        i+=1
    endwhile
EndFunction

Function OnSpellCast(Form akSource)
    If UDmain.TraceAllowed()
        UDmain.Log(Self + "::OnSpellCast() akSource = " + akSource, 3)
    EndIf
    Spell loc_spell = akSource as Spell
    If loc_spell == None
        Return
    EndIf

    int i = 0
    while UD_equipedCustomDevices[i]
        UD_equipedCustomDevices[i].spellCast(loc_spell)
        i+=1
    endwhile
EndFunction

String Function _GetDebugMenuText(UD_CustomDevice_RenderScript akDevice)
    String loc_res = ""
    loc_res += UDmain.UDMTF.Header(akDevice.getDeviceName(), UDMain.UDMTF.FontSize + 4)
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
                GetModifierTags_Update()
            elseif loc_res == 7 ;Remove modifier
                UDmain.UDMOM.Debug_RemoveModifier(UD_equipedCustomDevices[slot_id])
                GetModifierTags_Update()
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

;returns device with biggest priority
UD_CustomDevice_RenderScript Function getDeviceByPriority()
    int i = 0
    UD_CustomDevice_RenderScript loc_res = none
    while (i < UD_equipedCustomDevices.length) && UD_equipedCustomDevices[i]
        if !loc_res
            loc_res = UD_equipedCustomDevices[i]
        else
            if UD_equipedCustomDevices[i].GetAiPriority() > loc_res.GetAiPriority()
                loc_res = UD_equipedCustomDevices[i]
            endif
        endif
        i+=1
    endwhile
    return loc_res
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
    _iUsedSlots = loc_registered

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

Float Function CalculatePhysDamage(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
; calculation in the first approximation without taking into account difficulty and perks
    Weapon loc_weapon = akSource as Weapon
    If loc_weapon == None
        Return 5.0 * (1.0 + 0.02 * GetActor().GetLevel()) * (1.0 + 0.5 * (abPowerAttack as Int))
    ElseIf IsTrapHit(akAggressor, akSource)
    ; it's a trap!
        Return 30.0 * (1.0 + 0.02 * GetActor().GetLevel())
    ElseIf loc_weapon.GetFormID() == 0x000001F4
    ; predator
        Return 10.0 * (1.0 + 0.02 * (akAggressor as Actor).GetActorValue("OneHanded")) * (1.0 + 0.5 * (abPowerAttack as Int)) * (1.0 - 0.5 * (abHitBlocked as Int))
    Else
        Float loc_base = fRange(loc_weapon.GetBaseDamage(), 5.0, 100.0)
        Float loc_skill
        If akAggressor as Actor != None
            loc_skill = (akAggressor as Actor).GetActorValue(loc_weapon.GetSkill())
        Else
            loc_skill = GetActor().GetLevel()
        EndIf
        Return loc_base * (1.0 + 0.02 * loc_skill) * (1.0 + 0.5 * (abPowerAttack as Int)) * (1.0 - 0.5 * (abHitBlocked as Int))
    EndIf
EndFunction

Float Function CalculateMagDamage(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    MagicEffect loc_me
    Float loc_magn
    If akSource as Spell
        Spell loc_spell = akSource as Spell
        If !loc_spell.IsHostile()
            Return -1.0
        EndIf
        Int loc_i = loc_spell.GetCostliestEffectIndex()
        loc_me = loc_spell.GetNthEffectMagicEffect(loc_i)
        loc_magn = fRange(loc_spell.GetNthEffectMagnitude(loc_i), 5.0, 100.0)
    ElseIf akSource as Enchantment
        Enchantment loc_ench = akSource as Enchantment
        If !loc_ench.IsHostile()
            Return -1.0
        EndIf
        Int loc_i = loc_ench.GetCostliestEffectIndex()
        loc_me = loc_ench.GetNthEffectMagicEffect(loc_i)
        loc_magn = fRange(loc_ench.GetNthEffectMagnitude(loc_i), 5.0, 100.0)
    Else
        Return 5.0 * (1.0 + 0.02 * GetActor().GetLevel())
    EndIf
    If loc_me.GetAssociatedSkill() != "Destruction"
        Return -1.0
    EndIf
    If !loc_me.IsEffectFlagSet(0x00000001)
        Return -1.0
    EndIf
    Float loc_skill = 0.0
    If akSource as Spell
        If akAggressor as Actor
            loc_skill = (akAggressor as Actor).GetActorValue("Destruction")
        Else
            loc_skill = GetActor().GetLevel()
        EndIf
    EndIf
    Return loc_magn * (1.0 + 0.02 * loc_skill)

EndFunction

Bool Function IsConcentrationSpell(Spell akSpell)
    If akSpell == None
        Return False
    EndIf
    Int loc_i = akSpell.GetCostliestEffectIndex()
    MagicEffect loc_me = akSpell.GetNthEffectMagicEffect(loc_i)
    Return loc_me.GetCastingType() == 2
EndFunction

Bool Function IsConcentrationEnch(Enchantment akEnchantment)
    If akEnchantment == None
        Return False
    EndIf
    Int loc_i = akEnchantment.GetCostliestEffectIndex()
    MagicEffect loc_me = akEnchantment.GetNthEffectMagicEffect(loc_i)
    Return loc_me.GetCastingType() == 2
EndFunction

Bool Function IsTrapHit(ObjectReference akAggressor, Form akSource)
    Return (akAggressor == None && akSource.GetFormID() == 0x000001F4)
EndFunction

;===============================================================================
;===============================================================================
;                             INVENTORY EVENTS
;===============================================================================
;===============================================================================

Form[] _ItemFilter_Forms
Int[] _ItemFilter_Refs

Int Function _GetItemFilterIndex(Form akFilter)
    Int loc_i = _ItemFilter_Forms.Length
    While loc_i > 0
        loc_i -= 1
        If _ItemFilter_Forms[loc_i] == akFilter
            Return loc_i
        EndIf
    EndWhile
    Return -1
EndFunction

Function RegisterEmptyItemEvent()
    If UDmain.TraceAllowed()
        UDmain.Log("UD_CustomDevice_NPCSlot::RegisterEmptyItemEvent() Actor = " + GetActor(), 2)
    EndIf
    FormList loc_filter = (GetOwningQuest() as UD_CustomDevices_NPCSlotsManager).EmptyItemFilter
    Self.AddInventoryEventFilter(loc_filter)
EndFunction

Function RegisterItemEvent(Form akFilter)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_CustomDevice_NPCSlot::RegisterItemEvent() Actor = " + GetActor() + " akFilter = " + akFilter, 2)
    EndIf
    ; access from multiple threads is unlikely
    Int loc_i = _GetItemFilterIndex(akFilter)
    If loc_i < 0
        _ItemFilter_Forms = PapyrusUtil.PushForm(_ItemFilter_Forms, akFilter)
        _ItemFilter_Refs = PapyrusUtil.PushInt(_ItemFilter_Refs, 1)
        Self.AddInventoryEventFilter(akFilter)
        Return
    EndIf
    
    Int loc_refs = _ItemFilter_Refs[loc_i]
    If loc_refs == 0
        Self.AddInventoryEventFilter(akFilter)
    EndIf
    _ItemFilter_Refs[loc_i] = loc_refs + 1
EndFunction

Function UnregisterItemEvent(Form akFilter)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_CustomDevice_NPCSlot::UnregisterItemEvent() Actor = " + GetActor() + " akFilter = " + akFilter, 2)
    EndIf
    ; access from multiple threads is unlikely
    Int loc_i = _GetItemFilterIndex(akFilter)
    If loc_i < 0
        Return
    EndIf
    Int loc_refs = _ItemFilter_Refs[loc_i]
    If loc_refs == 1
        Self.RemoveInventoryEventFilter(akFilter)
    EndIf
    If loc_refs < 1
        UDmain.Warning("UD_CustomDevice_NPCSlot::UnregisterForAddItemEvent() An unnecessary call to unregister the filter " + akFilter)
        _ItemFilter_Refs[loc_i] = 0
    Else
        _ItemFilter_Refs[loc_i] = _ItemFilter_Refs[loc_i] - 1
    EndIf
EndFunction

Function UnregisterAllItemEvents(Bool abClearArray = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_CustomDevice_NPCSlot::UnregisterAllItemEvents() Actor = " + GetActor() + " abClearArray = " + abClearArray, 2)
    EndIf
    ; access from multiple threads is unlikely
    Int loc_i = _ItemFilter_Forms.Length
    While loc_i > 0
        loc_i -= 1
        _ItemFilter_Refs[loc_i] = 0
        Self.RemoveInventoryEventFilter(_ItemFilter_Forms[loc_i])
    EndWhile
    If abClearArray
        _ItemFilter_Forms = Utility.ResizeFormArray(_ItemFilter_Forms, 0)
        _ItemFilter_Refs = Utility.ResizeIntArray(_ItemFilter_Refs, 0)
    EndIf
EndFunction

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_CustomDevice_NPCSlot::OnItemAdded() akBaseItem = " + akBaseItem + " Owner = " + akItemReference.GetActorOwner() + ", Faction = " + akItemReference.GetFactionOwner(), 3)
    EndIf
    Faction loc_owner_faction = akItemReference.GetFactionOwner()
    ActorBase loc_owner_actor = akItemReference.GetActorOwner()
    Bool loc_stolen = (loc_owner_actor != None && loc_owner_actor != GetActorRef().GetActorBase()) || (loc_owner_faction != None && !GetActorRef().IsInFaction(loc_owner_faction))
    Int loc_i = 0
    While UD_equipedCustomDevices[loc_i]
        Udmain.UDMOM.Procces_UpdateModifiers_ItemAdded(UD_equipedCustomDevices[loc_i], akBaseItem, aiItemCount, akSourceContainer, loc_stolen)
        loc_i += 1
    EndWhile
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    Int loc_i = 0
    While UD_equipedCustomDevices[loc_i]
        Udmain.UDMOM.Procces_UpdateModifiers_ItemRemoved(UD_equipedCustomDevices[loc_i], akBaseItem, aiItemCount, akDestContainer)
        loc_i += 1
    EndWhile    
EndEvent

;===============================================================================
;===============================================================================
;                             MODIFIERS TAGS
;===============================================================================
;===============================================================================

Bool Function ModifiersHaveTag(String asTag)
    String[] loc_mod_tags = GetModifierTags()
    Return PapyrusUtil.CountString(loc_mod_tags, asTag) > 0
EndFunction

Bool _ModifierTagsArrray_Update = True
String[] _ModifierTagsArrray

String[] Function GetModifierTags(Bool abForceUpdate = False)
    If !_ModifierTagsArrray_Update && !abForceUpdate
        Return _ModifierTagsArrray
    EndIf

    String[] loc_mod_tags
    Int loc_length = UD_equipedCustomDevices.Length
    Int loc_i = 0
    While loc_i < loc_length && UD_equipedCustomDevices[loc_i]
        loc_mod_tags = PapyrusUtil.MergeStringArray(loc_mod_tags, UD_equipedCustomDevices[loc_i].GetModifierTags(), False)
        loc_i += 1
    Endwhile

    _ModifierTagsArrray = loc_mod_tags
    _ModifierTagsArrray_Update = False
    Return _ModifierTagsArrray
EndFunction

Function GetModifierTags_Update(Bool abNow = False)
    _ModifierTagsArrray_Update = True
    If abNow
        String[] loc_temp = GetModifierTags()
    EndIf
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