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

;saved modifier storages
Form[] _modifierstorages
int Function AddModifierStorage(UD_ModifierStorage akStorage)
    if !akStorage
        return -1
    endif
    _modifierstorages = PapyrusUtil.PushForm(_modifierstorages,akStorage as Form)
    return _modifierstorages.length
EndFunction

Function OnInit()
    RegisterForSingleUpdate(20.0)
EndFunction

Function Update()
EndFunction

float _LastUpdateTime = 0.0
Event OnUpdate()
    if !Ready
        Ready = true
        _LastUpdateTime         = Utility.GetCurrentGameTime()
        _LastUpdateTime_Hour    = Utility.GetCurrentGameTime()
        RegisterForSingleUpdate(30.0) ;start update loop, 5 s
        RegisterForSingleUpdateGameTime(1.0) ;start update loop, 1 game hour
    else
        if UDmain.IsEnabled()
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
    if UDmain.IsEnabled()
        float loc_currentgametime = Utility.GetCurrentGameTime()
        float loc_mult = 24.0*(loc_currentgametime - _LastUpdateTime_Hour) ;time multiplier
        UpdateModifiers_Hour(loc_mult)
    endif
    _LastUpdateTime_Hour = Utility.GetCurrentGameTime()
    RegisterForSingleUpdateGameTime(1.0)
EndEvent

;====================================================================================
;                            receive modifier update events
;====================================================================================

Function UpdateModifiers(float aiTimePassed)
    int loc_i = 0
    while loc_i < UDNPCM.UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByIndex(loc_i)
        if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
            UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
            int loc_x = 0
            while loc_devices[loc_x]
                if !loc_devices[loc_x].isMinigameOn() ;not update device which are in minigame
                    Procces_UpdateModifiers(loc_devices[loc_x],aiTimePassed)
                endif
                loc_x += 1
            endwhile
        endif
        loc_i += 1
    endwhile
EndFunction

Function UpdateModifiers_Hour(float afMult)
    int loc_i = 0
    while loc_i < UDNPCM.UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByIndex(loc_i)
        if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
            UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
            int loc_x = 0
            while loc_devices[loc_x]
                Procces_UpdateModifiers_Hour(loc_devices[loc_x],afMult)
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
            Procces_UpdateModifiers_Orgasm(loc_devices[loc_x])
            loc_x += 1
        endwhile
    endif
EndFunction
;====================================================================================
;                            Procces modifiers groups
;====================================================================================

Function Procces_UpdateModifiers(UD_CustomDevice_RenderScript akDevice,float aiTimePassed)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.TimeUpdateSecond(akDevice,aiTimePassed,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_Hour(UD_CustomDevice_RenderScript akDevice,float afMult)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.TimeUpdateHour(akDevice,afMult,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid])
    endwhile
    ;Procces_MAH_Hour(argDevice,argMult) ;MAH
    ;Procces__L_CHEAP_Hour(argDevice,argMult) ;_L_CHEAP
EndFunction

Function Procces_UpdateModifiers_Orgasm(UD_CustomDevice_RenderScript akDevice)
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.Orgasm(akDevice,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_Added(UD_CustomDevice_RenderScript akDevice) ;directly accesed from device
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.DeviceLocked(akDevice,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid])
    endwhile
EndFunction

Function Procces_UpdateModifiers_Remove(UD_CustomDevice_RenderScript akDevice) ;directly accesed from device
    int loc_modid = akDevice.UD_ModifiersRef.length
    while loc_modid 
        loc_modid -= 1
        UD_Modifier loc_mod = (akDevice.UD_ModifiersRef[loc_modid] as UD_Modifier)
        loc_mod.DeviceUnlocked(akDevice,akDevice.UD_ModifiersDataStr[loc_modid],akDevice.UD_ModifiersDataForm1[loc_modid],akDevice.UD_ModifiersDataForm2[loc_modid],akDevice.UD_ModifiersDataForm3[loc_modid])
    endwhile
EndFunction

;====================================================================================
;                            implementation of modifiers
;====================================================================================

Function Procces_MAH_Hour(UD_CustomDevice_RenderScript argDevice,float argMult)
    if !libsp.isValidActor(argDevice.GetWearer())
        return
    endif    
    if !argDevice.hasModifier("MAH")
        return
    endif
    int loc_chance = Round(argDevice.getModifierIntParam("MAH",0)*(UDPatcher.UD_MAHMod/100.0))
    int loc_number = argDevice.getModifierIntParam("MAH",1,1)
    ManifestDevices(argDevice.GetWearer(),argDevice.getDeviceName() ,loc_chance,loc_number)
EndFunction

Function Procces__L_CHEAP_Hour(UD_CustomDevice_RenderScript argDevice,float argMult)
    if !argDevice.HaveUnlockableLocks()
        return
    endif
    if !argDevice.hasModifier("_L_CHEAP")
        return
    endif
    int loc_chance = argDevice.getModifierIntParam("_L_CHEAP",0)
    if loc_chance
        argDevice.AddJammedLock(loc_chance)
    endif
EndFunction

Function Procces_MAO_Orgasm(UD_CustomDevice_RenderScript argDevice)
    if !libsp.isValidActor(argDevice.GetWearer())
        return
    endif
    if !argDevice.hasModifier("MAO")
        return
    endif
    int loc_chance = Round(argDevice.getModifierIntParam("MAO",0)*(UDPatcher.UD_MAOMod/100.0))
    int loc_number = argDevice.getModifierIntParam("MAO",1,1)
    ManifestDevices(argDevice.GetWearer(),argDevice.getDeviceName() ,loc_chance,loc_number)
EndFunction

Function Procces_LootGold_Remove(UD_CustomDevice_RenderScript argDevice)
EndFunction

int Function ManifestDevices(Actor akActor,string strSource ,int iChance,int iNumber)
    Form[] loc_array
    if Utility.randomInt(1,99) < iChance
        while iNumber
            while UDmain.UDOM.isOrgasming(akActor)
                Utility.wait(0.1)
            endwhile
            iNumber -= 1
            Armor loc_device = UDRRM.LockRandomRestrain(akActor)
            if loc_device
                loc_array = PapyrusUtil.PushForm(loc_array,loc_device)
            else
                iNumber = 0 ;end, because no more devices can be locked
            endif
        endwhile
    endif
    if loc_array
        if loc_array.length > 0
            if UDmain.ActorIsPlayer(akActor)
                UDmain.Print(strSource + " suddenly locks you in bondage restraint!",1)
                ;/
                string loc_str = "Devices locked: \n"
                int i = 0
                while i < loc_array.length
                    loc_str += (loc_array[i] as Armor).getName() + "\n"
                    i+= 1
                endwhile
                ShowMessageBox(loc_str)
                /;
            elseif UDCDmain.AllowNPCMessage(akActor)
                UDmain.Print(GetActorName(akActor) + "s "+ strSource +" suddenly locks them in bondage restraint!",3)
            endif
        endif
    endif
    if loc_array
        return loc_array.length
    else
        return 0
    endif
EndFunction