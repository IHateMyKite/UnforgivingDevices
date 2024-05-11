Scriptname UDItemManager extends Quest  

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain      Property UDCDmain               auto
UnforgivingDevicesMain  Property UDmain                 auto
UD_AbadonQuest_script   Property AbadonScript           auto

Bool Property Ready = False auto
Event OnInit()
    if IsRunning()
        Ready = True
    endif
EndEvent

; TODO
; boots high heels
; boots pony

Int Function lockAbadonPiercings(Actor akTarget)
    Int loc_res = 0
    if !akTarget.wornhaskeyword(libs.zad_DeviousPiercingsVaginal) && UDmain.UDRRM.IsDeviceFiltered(0)
        loc_res += libs.LockDevice(akTarget,UDmain.UDlibs.AbadonPiercingVaginal) as Int
    endif
    if !akTarget.wornhaskeyword(libs.zad_DeviousPiercingsNipple) && UDmain.UDRRM.IsDeviceFiltered(1)
        loc_res += libs.LockDevice(akTarget,UDmain.UDlibs.AbadonPiercingNipple) as Int
    endif
    return loc_res
EndFunction

Int Function lockAbadonHelperPlugs(Actor akTarget)
    Int loc_res = 0
    if !akTarget.wornhaskeyword(libs.zad_deviousPlugAnal) && !AbadonScript.UseAnalVariant && UDmain.UDRRM.IsDeviceFiltered(3)
        if AbadonScript.IsCompleted() && RandomInt(0,1) ;only equip helper plug if abadon quest was completed
            loc_res += libs.lockdevice(akTarget,UDmain.UDlibs.LittleHelper) as Int
        else
            loc_res += libs.lockdevice(akTarget,UDmain.UDlibs.InflatablePlugAnal) as Int
        endif
    endif
    if !akTarget.wornhaskeyword(libs.zad_DeviousPlugVaginal) && UDmain.UDRRM.IsDeviceFiltered(2)
        loc_res += libs.lockdevice(akTarget,UDmain.UDlibs.InflatablePlugVag) as Int
    endif
    return loc_res
EndFunction

Function equipAbadonLatexSuit(Actor akActor)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_LATEX")
EndFunction

Function equipAbadonRestrictiveSuit(Actor target)
    if (!target.WornhasKeyword(libs.zad_DeviousHeavyBondage)) && UDmain.UDRRM.IsDeviceFiltered(4)
        if RandomInt(0,1)
            libs.LockDevice(target,UDmain.UDlibs.AbadonArmbinderEbonite)
        else
            libs.LockDevice(target,UDmain.UDlibs.AbadonStraitjacketEbonite)
        endif
    endif
    
    lockAbadonPiercings(target)
    lockAbadonHelperPlugs(target)
    
    if !target.wornHasKeyword(libs.zad_DeviousBoots) && UDmain.UDRRM.IsDeviceFiltered(11)
        libs.LockDevice(target,UDmain.UDlibs.AbadonRestrictiveBoots)
    endif

    if !target.wornHasKeyword(libs.zad_DeviousGloves) && UDmain.UDRRM.IsDeviceFiltered(15)
        libs.LockDevice(target,UDmain.UDlibs.AbadonRestrictiveGloves)
    endif

    if !target.wornHasKeyword(libs.zad_DeviousCollar) && UDmain.UDRRM.IsDeviceFiltered(8)
        libs.LockDevice(target,UDmain.UDlibs.AbadonRestrictiveCollar)
    endif

    if !target.wornHasKeyword(libs.zad_DeviousCorset) && UDmain.UDRRM.IsDeviceFiltered(6)
        libs.LockDevice(target,UDmain.UDlibs.AbadonCorset)
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBelt) && UDmain.UDRRM.IsDeviceFiltered(17))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousGag) && UDmain.UDRRM.IsDeviceFiltered(9))
        if RandomInt(0,1)
            libs.LockDevice(target,UDmain.UDlibs.AbadonExtremeBallGag)
        else
            libs.LockDevice(target,UDmain.UDlibs.AbadonExtremeInflatableGag)
        endif
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBlindfold) && UDmain.UDRRM.IsDeviceFiltered(10))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBlindfold)
    endif
EndFunction

Function equipAbadonRopeSuit(Actor target)
    if (!target.WornhasKeyword(libs.zad_DeviousHeavyBondage))
        libs.LockDevice(target,UDmain.UDlibs.AbadonArmbinderRope)
    endif
    
    lockAbadonPiercings(target)
    lockAbadonHelperPlugs(target)
        
    if (!target.WornhasKeyword(libs.zad_DeviousCollar))
        libs.LockDevice(target,libsx.zadx_Collar_Rope_2_Inventory)
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBlindfold))
        libs.LockDevice(target,libsx.zadx_blindfold_Rope_Inventory)
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousGag))
        if RandomInt(0,1)
            libs.LockDevice(target,libsx.zadx_gag_rope_ball_Inventory)
        else
            libs.LockDevice(target,libsx.zadx_gag_rope_bit_Inventory)
        endif
    endif
    
    libs.LockDevice(target,libsx2.zadx_rope_harness_FullTop_Inventory)
EndFunction

Function equipAbadonTransparentSuit(Actor target)
    if (!target.WornhasKeyword(libs.zad_DeviousHeavyBondage) && UDmain.UDRRM.IsDeviceFiltered(4))
        libs.LockDevice(target,UDmain.UDlibs.AbadonArmbinderWhite)
    endif
    
    lockAbadonPiercings(target)
    lockAbadonHelperPlugs(target)
    
    if (!target.WornhasKeyword(libs.zad_DeviousSuit) && UDmain.UDRRM.IsDeviceFiltered(14))
        libs.LockDevice(target,UDmain.UDlibs.AbadonTransSuit)
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousBoots) && UDmain.UDRRM.IsDeviceFiltered(11))
        if RandomInt(0,1)
            libs.LockDevice(target,UDmain.UDlibs.AbadonTransBoots)
        else
            libs.LockDevice(target, UDmain.UDlibs.AbadonPonyBootsWhite)
        endif
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBlindfold) && UDmain.UDRRM.IsDeviceFiltered(10))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBlindfoldWhite)
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousGag) && UDmain.UDRRM.IsDeviceFiltered(9))
        libs.LockDevice(target,UDmain.UDlibs.AbadonGagTape)
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBelt) && UDmain.UDRRM.IsDeviceFiltered(17))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
    endif
    
EndFunction

Function equipAbadonSimpleSuit(Actor akActor)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_SIMPLE")
EndFunction

Function equipAbadonYokeSuit(Actor target)
    if !target.wornHasKeyword(libs.zad_deviousHeavyBondage) && UDmain.UDRRM.IsDeviceFiltered(4)
        libs.LockDevice(target,UDmain.UDlibs.AbadonYoke)
    endif
    
    lockAbadonPiercings(target)
    lockAbadonHelperPlugs(target)
    
    if (!target.WornhasKeyword(libs.zad_DeviousBlindfold) && UDmain.UDRRM.IsDeviceFiltered(10))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBlindfold)
    endif
        
    if (!target.WornhasKeyword(libs.zad_DeviousBoots) && UDmain.UDRRM.IsDeviceFiltered(11))
        int loc_random = RandomInt(1,3)
        if loc_random == 1
            libs.LockDevice(target,libsx.zadx_SlaveHighHeelsInventory)
        elseif loc_random == 2
            libs.LockDevice(target,libsx.zadx_HR_IronBalletBootsInventory)
        elseif loc_random == 3
            libs.LockDevice(target,UDmain.UDlibs.AbadonRestrictiveBoots)
        endif
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousHood) && UDmain.UDRRM.IsDeviceFiltered(7))
        if (!target.WornhasKeyword(libs.zad_DeviousGag))
            libs.LockDevice(target,UDmain.UDlibs.AbadonGagTape)
        endif
        libs.LockDevice(target,UDmain.UDlibs.AbadonGasmask)
    elseif (!target.WornhasKeyword(libs.zad_DeviousGag) && UDmain.UDRRM.IsDeviceFiltered(9))
        int loc_rand;RandomInt(1,2)
        if UD_Native.IsPlayer(target) ;panel gag is only for player, as its buggy for NPCs
            loc_rand = RandomInt(1,3)
        else
            loc_rand = RandomInt(1,2)
        endif
        if loc_rand == 1
            libs.LockDevice(target,UDmain.UDlibs.AbadonBallGag)
        elseif loc_rand == 2
            libs.LockDevice(target,UDmain.UDlibs.AbadonRingGag)
        else
            libs.LockDevice(target,UDmain.UDlibs.AbadonPanelGag)
        endif
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBelt) && UDmain.UDRRM.IsDeviceFiltered(17))
        bool loc_useharness = false
        bool loc_usebelt    = true
        
        if !target.WornhasKeyword(libs.zad_DeviousCorset) && UDmain.UDRRM.IsDeviceFiltered(5)
            loc_useharness = true
        endif
        
        if loc_useharness && loc_usebelt
            if RandomInt(0,1)
                libs.LockDevice(target,UDmain.UDlibs.AbadonHarness)
            else
                libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
            endif
        elseif loc_useharness
            libs.LockDevice(target,UDmain.UDlibs.AbadonHarness)
        elseif loc_usebelt
            libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
        endif
    elseif (!target.WornhasKeyword(libs.zad_DeviousCollar) && UDmain.UDRRM.IsDeviceFiltered(8))
        libs.LockDevice(target,UDmain.UDlibs.AbadonCuffCollar)
    endif

    if !target.wornHasKeyword(libs.zad_DeviousGloves) && UDmain.UDRRM.IsDeviceFiltered(15)
        libs.LockDevice(target,UDmain.UDlibs.AbadonMittens)
    endif
    
EndFunction

Function equipAbadonFinisherSuit(Actor target)
    lockAbadonPiercings(target)

    if target.wornHasKeyword(libs.zad_DeviousBondageMittens)
        libs.UnlockDeviceByKeyword(target,libs.zad_DeviousBondageMittens)
    endif
    
    if target.wornHasKeyword(libs.zad_DeviousSuit) && !target.wornHasKeyword(libs.zad_DeviousStraitjacket)
        libs.UnlockDeviceByKeyword(target,libs.zad_DeviousSuit)
    endif
    
    libs.SwapDevices(target,UDmain.UDlibs.AbadonCursedStraitjacket,libs.zad_DeviousHeavyBondage) ;TFuck

; unlock corset? no way, we have to punish!
;    if target.wornHasKeyword(libs.zad_DeviousCorset)
;        libs.UnlockDeviceByKeyword(target,libs.zad_DeviousCorset)
;    endif

    if target.wornHasKeyword(libs.zad_DeviousBelt) && !target.wornHasKeyword(libs.zad_DeviousCorset) && !target.wornHasKeyword(libs.zad_DeviousHarness) 
        libs.LockDevice(target,UDmain.UDlibs.AbadonCorset) ; has belt and no corset? wear it!
    elseif !target.wornHasKeyword(libs.zad_DeviousBelt) && !target.wornHasKeyword(libs.zad_DeviousCorset) && !target.wornHasKeyword(libs.zad_DeviousHarness) && !target.WornhasKeyword(libs.zad_DeviousCollar) ; no belt and no corset and no harness? time to decide what we will do!
        if RandomInt(0,1) == 0
            libs.LockDevice(target,UDmain.UDlibs.AbadonHarness) ; either harness...
        else    
            libs.LockDevice(target,UDmain.UDlibs.AbadonCorset)    ; ...or corset and belt combo!
            libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
        endif
    elseif !target.wornHasKeyword(libs.zad_DeviousBelt) ; last resolve, maybe add at least the belt?
        libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
    endif
    
    libs.SwapDevices(target,UDmain.UDlibs.AbadonBra,libs.zad_DeviousBra)
    
    if !target.wornHasKeyword(libs.zad_DeviousPlugAnal)
        libs.LockDevice(target,UDmain.UDlibs.CursedInflatablePlugAnal)
    endif
    
    if !target.wornHasKeyword(libs.zad_DeviousBoots)
        libs.LockDevice(target,UDmain.UDlibs.AbadonBalletBoots)
    endif

    if !target.WornhasKeyword(libs.zad_DeviousCollar)
        libs.LockDevice(target,UDmain.UDlibs.AbadonCuffCollar)
    endif
     
    if UDmain.UDRRM.IsDeviceFiltered(7)
        libs.SwapDevices(target,UDmain.UDlibs.CursedAbadonGasmask,libs.zad_DeviousHood) ; force to wear cursed gasmask too
    endif
   
    if !target.WornhasKeyword(libs.zad_DeviousGag)
        libs.LockDevice(target,UDmain.UDlibs.AbadonGagTape)
    endif
    
    if !target.WornhasKeyword(libs.zad_DeviousBlindfold)
        libs.LockDevice(target,UDmain.UDlibs.AbadonBlindfold)
    endif
; and here we also add mittens and cuffs, more is better!
    if !target.WornhasKeyword(libs.zad_DeviousGloves)
        libs.LockDevice(target,UDmain.UDlibs.AbadonMittens)
    endif

    if !target.WornhasKeyword(libs.zad_DeviousArmCuffs)
        libs.LockDevice(target,UDmain.UDlibs.AbadonArmCuffs)
    endif

    if !target.WornhasKeyword(libs.zad_DeviousLegCuffs)
        libs.LockDevice(target,UDmain.UDlibs.AbadonLegsCuffs)
    endif
EndFunction
 
zadlibs property libs auto 
zadxlibs property libsx auto
zadxlibs2 property libsx2 auto


