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
Function OnInit()
    Ready = true
    UDCDMain.CLog("UD_ModifierManager_Script ready")
    _LastUpdateTime = Utility.GetCurrentGameTime()
    _LastUpdateTime_Hour = Utility.GetCurrentGameTime()
    RegisterForSingleUpdate(1.0) ;start update loop, 5 s
    RegisterForSingleUpdateGameTime(1.0) ;start update loop, 1 game hour
EndFunction

Function Update()

EndFunction


float _LastUpdateTime = 0.0
Event OnUpdate()
    if UDmain.ready
        float loc_timePassed = Utility.GetCurrentGameTime() - _LastUpdateTime
        UpdateModifiers(loc_timePassed)
        _LastUpdateTime = Utility.GetCurrentGameTime()
    endif
    RegisterForSingleUpdate(5.0)
EndEvent

float _LastUpdateTime_Hour = 0.0 ;last time the update happened in days
Event OnUpdateGameTime()
    float loc_currentgametime = Utility.GetCurrentGameTime()
    float loc_mult = 24.0*(loc_currentgametime - _LastUpdateTime_Hour) ;time multiplier
    UpdateModifiers_Hour(loc_mult)
    _LastUpdateTime_Hour = Utility.GetCurrentGameTime()
    RegisterForSingleUpdateGameTime(1.0)
EndEvent

;====================================================================================
;                            receive modifier update events
;====================================================================================

Function UpdateModifiers(float argTimePassed)
    int loc_i = 0
    while loc_i < UDNPCM.UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByIndex(loc_i)
        if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
            UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
            int loc_x = 0
            while loc_devices[loc_x]
                Procces_UpdateModifiers(loc_devices[loc_x],argTimePassed)
                loc_x += 1
            endwhile
        endif
        loc_i += 1
    endwhile
EndFunction

Function UpdateModifiers_Hour(float argMult)
    int loc_i = 0
    while loc_i < UDNPCM.UD_Slots
        UD_CustomDevice_NPCSlot loc_slot = UDNPCM.getNPCSlotByIndex(loc_i)
        if loc_slot.isUsed() && !loc_slot.isDead() && loc_slot.isScriptRunning()
            UD_CustomDevice_RenderScript[] loc_devices = loc_slot.UD_equipedCustomDevices
            int loc_x = 0
            while loc_devices[loc_x]
                Procces_UpdateModifiers_Hour(loc_devices[loc_x],argMult)
                loc_x += 1
            endwhile
        endif
        loc_i += 1
    endwhile
EndFunction

Function UpdateModifiers_Orgasm(UD_CustomDevice_NPCSlot argSlot)
    UD_CustomDevice_NPCSlot loc_slot = argSlot
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

Function Procces_UpdateModifiers(UD_CustomDevice_RenderScript argDevice,float argTimePassed)
    argDevice.updateMend(argTimePassed) ;Regen, _HEAL
    ;...
EndFunction

Function Procces_UpdateModifiers_Hour(UD_CustomDevice_RenderScript argDevice,float argMult)
    Procces_MAH_Hour(argDevice,argMult) ;MAH
    Procces__L_CHEAP_Hour(argDevice,argMult) ;_L_CHEAP
EndFunction

Function Procces_UpdateModifiers_Orgasm(UD_CustomDevice_RenderScript argDevice)
    Procces_MAO_Orgasm(argDevice) ;MAO
EndFunction

Function Procces_UpdateModifiers_Remove(UD_CustomDevice_RenderScript argDevice) ;directly accesed from device
    Procces_LootGold_Remove(argDevice) ;LootGold
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
    if UDmain.TraceAllowed()
        UDCDMain.Log(argDevice.getDeviceHeader()+"MAH found, proccesing. C="+loc_chance+",N="+loc_number,1)
    endif
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
    argDevice.AddJammedLock(loc_chance)
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
    if UDmain.TraceAllowed()
        UDCDMain.Log(argDevice.getDeviceHeader()+"MAO found, proccesing. C="+loc_chance+",N="+loc_number,1)
    endif
    ManifestDevices(argDevice.GetWearer(),argDevice.getDeviceName() ,loc_chance,loc_number)
EndFunction

Function Procces_LootGold_Remove(UD_CustomDevice_RenderScript argDevice)
    Actor akActor = argDevice.getWearer()
    if argDevice.zad_DestroyOnRemove || argDevice.hasModifier("DOR") || !akActor.isDead()
        if argDevice.hasModifier("LootGold")
            if UDmain.TraceAllowed()
                UDCDmain.Log("Gold added: " + argDevice.getModifierIntParam("LootGold"),1)
            endif
            int goldNumMin = argDevice.getModifierIntParam("LootGold",0,0)
            int goldMode   = argDevice.getModifierIntParam("LootGold",2,0)
            if argDevice.getModifierParamNum("LootGold") > 1
                int goldNumMax = argDevice.getModifierIntParam("LootGold",1,0)
                if goldNumMax < goldNumMin
                    goldNumMax = goldNumMin
                endif
                int goldNumMin2    = goldNumMin ;modified value
                int goldNumMax2    = goldNumMax ;modified value
                
                float goldModeParam = 0.0
                
                if goldMode == 0
                    ;nothink
                elseif goldMode == 1 ;increase % gold based on level per parameter
                    goldModeParam   = argDevice.getModifierFloatParam("LootGold",3,0.05)
                    goldNumMin2     = Round(goldNumMin2*(1.0 + goldModeParam*argDevice.UD_Level))
                    goldNumMax2     = Round(goldNumMax2*(1.0 + goldModeParam*argDevice.UD_Level))
                elseif goldMode == 2 ;increase ABS gold based on level per parameter
                    goldModeParam   = argDevice.getModifierFloatParam("LootGold",3,10.0)
                    goldNumMin2     = Round(goldNumMin2 + (goldModeParam*argDevice.UD_Level))
                    goldNumMax2     = Round(goldNumMax2 + (goldModeParam*argDevice.UD_Level))
                else    ;unused
                endif
                
                int randomNum = Utility.randomInt(goldNumMin2,goldNumMax2)
                if randomNum > 0
                    akActor.addItem(UDlibs.Gold,randomNum)    
                endif                
            else
                akActor.addItem(UDlibs.Gold,goldNumMin)
            endif
        endif
    endif
EndFunction

int Function ManifestDevices(Actor akActor,string strSource ,int iChance,int iNumber)
    Form[] loc_array
    if Utility.randomInt(1,99) < iChance
        while iNumber
            while UDCDmain.UDOM.isOrgasming(akActor);UDCDmain.InSelabAnimation(getWearer()) || UDCDmain.InZadAnimation(getWearer())
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
                UDCDmain.Print(strSource + " suddenly locks you in bondage restraint!",1)
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
                UDCDmain.Print(GetActorName(akActor) + "s "+ strSource +" suddenly locks them in bondage restraint!",3)
            endif
        endif
    endif
    if loc_array
        return loc_array.length
    else
        return 0
    endif
EndFunction