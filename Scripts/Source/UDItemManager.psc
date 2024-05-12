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

Function equipAbadonRestrictiveSuit(Actor akActor)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_RESTR")
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

Function equipAbadonTransparentSuit(Actor akActor)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_TRANSP")
EndFunction

Function equipAbadonSimpleSuit(Actor akActor)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_SIMPLE")
EndFunction

Function equipAbadonYokeSuit(Actor akActor)
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_YOKE")
EndFunction

Function equipAbadonFinisherSuit(Actor akActor)
    ;libs.SwapDevices(target,UDmain.UDlibs.AbadonCursedStraitjacket,libs.zad_DeviousHeavyBondage) ;TFuck
    UDmain.UDOTM.LockOutfitByAlias(akActor,"UDFW_CURSED")
EndFunction
 
zadlibs property libs auto 
zadxlibs property libsx auto
zadxlibs2 property libsx2 auto


