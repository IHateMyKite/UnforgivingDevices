Scriptname UD_AbadonWeapon_AME extends ActiveMagicEffect

Import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto

Function OnEffectStart(Actor akTarget, Actor akCaster)
    Actor loc_actor = akTarget
    if !UDmain.ActorIsValidForUD(loc_actor)
        return ;non valid actor, return
    endif
    
    if loc_actor.wornhaskeyword(UDmain.libs.zad_DeviousHeavyBondage)
        return ;actor is already tied
    endif
    

    
    int loc_chance = iRange(Round(GetMagnitude()),0,100)
    if Utility.randomInt(1,99) < loc_chance
        if UDmain.TraceAllowed()
            UDmain.Log(GetActorName(akTarget) + " hit by abadon weapon. Locking device")
        endif
        
        ;25 % chance of locking random abadon suit
        if Utility.randomInt(1,100) > 75
            UDmain.UDAbadonQuest.AbadonEquipSuit(akTarget,0)
            return
        endif
        
        UDmain.UDCDmain.DisableActor(akTarget)
        bool loc_haveSuit = akTarget.wornhaskeyword(UDmain.libs.zad_deviousSuit)
        Armor loc_device = none
        Formlist loc_formlist = UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageWeak ;only lock weak devices
        if loc_haveSuit
            Keyword[] loc_filter = new keyword[1]
            loc_filter[0] = UDmain.libs.zad_deviousStraitjacket
            loc_device = UDmain.UDRRM.getRandomFormFromFormlistFilter(loc_formlist,loc_filter,2) as Armor
        else
            loc_device = UDmain.UDRRM.getRandomFormFromFormlist(loc_formlist) as Armor
        endif
        UDmain.libsp.LockDevicePatched(akTarget,loc_device)
        UDmain.UDCDmain.EnableActor(akTarget)
        ;UDmain.UDRRM.LockAnyRandomRestrain(loc_actor,iNumber = 1)
    endif
EndFunction