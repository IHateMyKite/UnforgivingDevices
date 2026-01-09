Scriptname UDItemManager extends UD_ModuleBase

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain      Property UDCDmain               auto
UD_AbadonQuest_script   Property AbadonScript           auto

Int Function lockAbadonPiercings(Actor akTarget)
    WaitForReady(10.0)
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
    WaitForReady(10.0)
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
    WaitForReady(10.0)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_LATEX")
EndFunction

Function equipAbadonRestrictiveSuit(Actor akActor)
    WaitForReady(10.0)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_RESTR")
EndFunction

Function equipAbadonRopeSuit(Actor target)
    WaitForReady(10.0)
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

Function equipAbadonTransparentSuit(Actor akActor)
    WaitForReady(10.0)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_TRANSP")
EndFunction

Function equipAbadonSimpleSuit(Actor akActor)
    WaitForReady(10.0)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_SIMPLE")
EndFunction

Function equipAbadonYokeSuit(Actor akActor)
    WaitForReady(10.0)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_YOKE")
EndFunction

Function equipAbadonFinisherSuit(Actor akActor)
    WaitForReady(10.0)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_CURSED")
EndFunction
 
zadlibs property libs auto 
zadxlibs property libsx auto
zadxlibs2 property libsx2 auto


