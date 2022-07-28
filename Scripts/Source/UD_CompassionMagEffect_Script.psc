Scriptname UD_CompassionMagEffect_Script extends activemagiceffect  

import UnforgivingDevicesMain

UD_libs Property UDlibs auto
UDCustomDeviceMain Property UDCDmain auto
zadlibs Property libs auto
string[] loc_ModifierList

bool _transferMutex = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if !_transferMutex
        _transferMutex = True
        TransferDevices(akTarget, akCaster)
        _transferMutex = False
    else
        ; UDCDmain.Log("Compassion: device transfer already in progress, abort!",1)
    endif
EndEvent

Function TransferDevices(Actor akTarget, Actor akCaster)
    if UDCDmain.isRegistered(akTarget) && UDCDmain.isRegistered(akCaster)
        UD_CustomDevice_NPCSlot targetSlot = UDCDmain.getNPCSlot(akTarget)
        UD_CustomDevice_NPCSlot casterSlot = UDCDmain.getNPCSlot(akCaster)
        actor _currentSlotedActor = targetSlot.getActor()
        int iItem = _currentSlotedActor.GetNumItems()
        while iItem
            iItem -= 1
            Armor ArmorDevice = _currentSlotedActor.GetNthForm(iItem) as Armor
            if Validate(akCaster, ArmorDevice)
                if targetSlot.deviceAlreadyRegistered(ArmorDevice)
                    UD_CustomDevice_RenderScript loc_device = UDCDmain.FetchDeviceByInventory(_currentSlotedActor, ArmorDevice)
                    if _currentSlotedActor.getItemCount(loc_device.DeviceInventory) && _currentSlotedActor.getItemCount(loc_device.DeviceRendered)
                        int iQuantity = akTarget.GetItemCount(ArmorDevice)
                        if iQuantity == 1
                            AppropriateDevice(loc_device, akCaster, akTarget, targetSlot, casterSlot)
                        else
                            aktarget.RemoveItem(ArmorDevice,iQuantity - 1)
                            AppropriateDevice(loc_device, akCaster, akTarget, targetSlot, casterSlot)
                            aktarget.AddItem(ArmorDevice,iQuantity - 1)
                        endif
                    endif
                endif
            endif
        endwhile

        libs.StartBoundEffects(akCaster)
        libs.StopBoundEffects(akTarget)
        akTarget.removespell(UDlibs.PreventCombatSpell)
        if akCaster != libs.PlayerRef && akCaster.wornhaskeyword(libs.zad_deviousheavybondage)
            akCaster.addspell(UDlibs.PreventCombatSpell)
        endif
        Outfit OriginalOutfit = StorageUtil.GetFormValue(akTarget.GetActorBase(), "zad_OriginalOutfit") As Outfit
        if OriginalOutfit && akTarget != libs.PlayerRef && akTarget.GetActorBase().IsUnique()
            akTarget.SetOutfit(OriginalOutfit, false)
            StorageUtil.UnSetFormValue(akTarget.GetActorBase(), "zad_OriginalOutfit")
        endIf

    endif
endFunction                                                                                
                                                                                          
; PPPPPPPPPPPPPPPPP   RRRRRRRRRRRRRRRRR                  AAA           YYYYYYY       YYYYYYY
; P::::::::::::::::P  R::::::::::::::::R                A:::A          Y:::::Y       Y:::::Y
; P::::::PPPPPP:::::P R::::::RRRRRR:::::R              A:::::A         Y:::::Y       Y:::::Y
; PP:::::P     P:::::PRR:::::R     R:::::R            A:::::::A        Y::::::Y     Y::::::Y
;   P::::P     P:::::P  R::::R     R:::::R           A:::::::::A       YYY:::::Y   Y:::::YYY
;   P::::P     P:::::P  R::::R     R:::::R          A:::::A:::::A         Y:::::Y Y:::::Y   
;   P::::PPPPPP:::::P   R::::RRRRRR:::::R          A:::::A A:::::A         Y:::::Y:::::Y    
;   P:::::::::::::PP    R:::::::::::::RR          A:::::A   A:::::A         Y:::::::::Y     
;   P::::PPPPPPPPP      R::::RRRRRR:::::R        A:::::A     A:::::A         Y:::::::Y      
;   P::::P              R::::R     R:::::R      A:::::AAAAAAAAA:::::A         Y:::::Y       
;   P::::P              R::::R     R:::::R     A:::::::::::::::::::::A        Y:::::Y       
;   P::::P              R::::R     R:::::R    A:::::AAAAAAAAAAAAA:::::A       Y:::::Y       
; PP::::::PP          RR:::::R     R:::::R   A:::::A             A:::::A      Y:::::Y       
; P::::::::P          R::::::R     R:::::R  A:::::A               A:::::A  YYYY:::::YYYY    
; P::::::::P          R::::::R     R:::::R A:::::A                 A:::::A Y:::::::::::Y    
; PPPPPPPPPP          RRRRRRRR     RRRRRRRAAAAAAA                   AAAAAAAYYYYYYYYYYYYY    
                                                                                                                                                 
Function AppropriateDevice(UD_CustomDevice_RenderScript loc_device, Actor akCaster, Actor akTarget, UD_CustomDevice_NPCSlot targetSlot, UD_CustomDevice_NPCSlot casterSlot)
    if casterSlot.registerDevice(loc_device)
        loc_device.setWearer(akCaster)
        if targetSlot.unregisterDevice(loc_device)
            akTarget.removeItem(loc_device.DeviceRendered,1,True,akCaster)
            akCaster.equipItem(loc_device.DeviceRendered,True,True)
            akTarget.removeItem(loc_device.DeviceInventory,1,True,akCaster)
            akCaster.equipItem(loc_device.DeviceInventory,True,True)
        Else
            casterSlot.unregisterDevice(loc_device)
            loc_device.setWearer(akTarget)
        endif
    endif
EndFunction

bool Function Validate(actor target, Armor ArmorDevice)
    ; if !ArmorDevice
    ;     UDCDmain.Log("Note: device does not exist.",1)
    ;     return false
    ; endif
    if !ArmorDevice.hasKeyword(UDCDmain.UDlibs.PatchedInventoryDevice)
        return false
    endif
    If ArmorDevice.HasKeyword(libs.zad_QuestItem)
        UDCDmain.Log("Note: device skipped because is a quest device.",1)
        return false
    EndIf
    If !CanWearDevice(target, ArmorDevice)
        UDCDmain.Log("Note: device skipped because conflicts with caster slots.",1)
        return false
    EndIf

    return true
EndFunction

bool Function CanWearDevice(actor akActor, armor InventoryDevice)
    if CanWearDeviceByKwd(akActor, libs.GetDeviceKeyword(InventoryDevice))
        return true
    endif
    return false
EndFunction

bool Function CanWearDeviceByKwd(actor akActor, keyword akKwd)
    if akActor.WornHasKeyword(akKwd)
        return false
    endif
    return true
endFunction