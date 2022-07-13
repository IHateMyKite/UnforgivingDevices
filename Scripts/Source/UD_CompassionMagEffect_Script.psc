Scriptname UD_CompassionMagEffect_Script extends activemagiceffect  

import UnforgivingDevicesMain

UD_libs Property UDlibs auto
UDCustomDeviceMain Property UDCDmain auto
zadlibs Property libs auto
; UD_CustomDevice_RenderScript Property UDCDRS = none auto
string[] loc_ModifierList

bool _transferMutex = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if !_transferMutex
        _transferMutex = True
        loc_ModifierList = new String[9]
        loc_ModifierList[0] = "Regen"
        loc_ModifierList[1] = "Sentient"
        loc_ModifierList[2] = "Loose"
        loc_ModifierList[3] = "MAO"
        loc_ModifierList[4] = "MAH"
        loc_ModifierList[5] = "_HEAL"
        loc_ModifierList[6] = "LootGold"
        loc_ModifierList[7] = "DOR"
        loc_ModifierList[8] = "_L_CHEAP"
        TransferDevices(akTarget, akCaster)
        _transferMutex = False
    else
        UDCDmain.Log("Compassion: device transfer already in progress, abort!",1)
    endif
EndEvent

Function TransferDevices(Actor akTarget, Actor akCaster)
    if UDCDmain.isRegistered(akTarget) && UDCDmain.isRegistered(akCaster)
        UD_CustomDevice_NPCSlot targetSlot = UDCDmain.getNPCSlot(akTarget)
        UD_CustomDevice_NPCSlot casterSlot = UDCDmain.getNPCSlot(akCaster)
        string[] temporalMods = new String[9]
        actor _currentSlotedActor = targetSlot.getActor()
        int iItem = _currentSlotedActor.GetNumItems()
        while iItem
            iItem -= 1
            Armor ArmorDevice = _currentSlotedActor.GetNthForm(iItem) as Armor
            if ArmorDevice
                if ArmorDevice.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
                    if !libs.GetWornDevice(akCaster, libs.GetDeviceKeyword(ArmorDevice)) && !ArmorDevice.HasKeyword(libs.zad_QuestItem)
                        if targetSlot.deviceAlreadyRegistered(ArmorDevice)
                            UD_CustomDevice_RenderScript script = UDCDmain.FetchDeviceByInventory(_currentSlotedActor,ArmorDevice)
                            if _currentSlotedActor.getItemCount(script.DeviceInventory) && _currentSlotedActor.getItemCount(script.DeviceRendered)
                                temporalMods = CopyModifiers(script)
                                libs.UnlockDevice(_currentSlotedActor, ArmorDevice)
                                libs.LockDevice(akCaster, ArmorDevice)

                                script = UDCDmain.FetchDeviceByInventory(akCaster,ArmorDevice)
                                int timeout = 50
                                while !script.isReady() && timeout > 0
                                    Utility.Wait(0.1)
                                    timeout -= 1
                                endwhile
                                OverwriteModifiers(script, temporalMods)
                            endif
                        endif
                    Else
                        UDCDmain.Log("Note: device skipped because is either a quest device or conflicts with caster slots.",1)
                    endif
                endif
            endif
        endwhile
    else
        UDCDmain.Print("Compassion abort: one of actors is not registered",1)
    endif
endFunction

string[] Function CopyModifiers(UD_CustomDevice_RenderScript device)
    ; UDCDmain.Log("Copy device called on: "+device,1)
    int iCount = device.UD_Modifiers.length
    string[] sArray = new string[9]
    int i = 0
    int j = 0
    while i < loc_ModifierList.length
        j = device.getModifierIndex(loc_ModifierList[i])
        if j >= 0
            sArray[i] = device.UD_Modifiers[j]
        EndIf
        i += 1
    endwhile
    return sArray
endFunction

Function OverwriteModifiers(UD_CustomDevice_RenderScript device, string[] sArray)
    int iCount = device.UD_Modifiers.length
    int jCount = sArray.length
    int i = 0
    while i < jCount
        int impIndex = -1
        int expIndex = -1
        bool flag = false
        int j = 0
        while (j < iCount || j < jCount) && !flag
            If j < iCount && device.GetModifierHeader(device.UD_Modifiers[j]) == loc_ModifierList[i]
                impIndex = j
            EndIf
            If device.GetModifierHeader(sArray[j]) == loc_ModifierList[i]
                expIndex = j
            EndIf
            if (impIndex >= 0 && expIndex >= 0)
                flag = true
            endif
            ; UDCDmain.Log("i:"+i+" ImpIndex:"+impIndex+" ExpIndex:"+expIndex+" Modifier:"+loc_ModifierList[i],1)
            j += 1
        endwhile


        if impIndex < 0 && expIndex >= 0
            ; UDCDmain.Log("Adding modifier: "+ sArray[expIndex],1)
            device.UD_Modifiers = PapyrusUtil.PushString(device.UD_Modifiers, sArray[expIndex])
        elseif impIndex > 0 && expIndex > 0
            ; UDCDmain.Log("Replacing" + device.UD_Modifiers[impIndex] + "modifier with: "+sArray[expIndex],1)
            device.UD_Modifiers = PapyrusUtil.RemoveString(device.UD_Modifiers, device.UD_Modifiers[impIndex]) ;SUPER UNSTABLE
            iCount -= 1
            device.UD_Modifiers = PapyrusUtil.PushString(device.UD_Modifiers, sArray[expIndex])
        elseif expIndex < 0 && impIndex >= 0
            ; UDCDmain.Log("Removing modifier: "+ device.UD_Modifiers[impIndex],1)
            device.UD_Modifiers = PapyrusUtil.RemoveString(device.UD_Modifiers, device.UD_Modifiers[impIndex]) ;SUPER UNSTABLE
            iCount -= 1
        endif
        i += 1
    endwhile
endFunction