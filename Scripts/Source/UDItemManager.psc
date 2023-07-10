Scriptname UDItemManager extends Quest  

import UnforgivingDevicesMain

UDCustomDeviceMain      Property UDCDmain               auto
UnforgivingDevicesMain  Property UDmain                 auto
bool                    Property UD_useHoods = True     auto
UD_AbadonQuest_script   Property AbadonScript           auto

Bool Property Ready = False auto
Event OnInit()
    if IsRunning()
        Ready = True
    endif
EndEvent

Function lockAbadonPiercings(Actor akTarget)
    if !akTarget.wornhaskeyword(libs.zad_DeviousPiercingsVaginal)
        libs.LockDevice(akTarget,UDmain.UDlibs.AbadonPiercingVaginal)
    endif
    if !akTarget.wornhaskeyword(libs.zad_DeviousPiercingsNipple)
        libs.LockDevice(akTarget,UDmain.UDlibs.AbadonPiercingNipple)
    endif
EndFunction

Function lockAbadonHelperPlugs(Actor akTarget)
    if !akTarget.wornhaskeyword(libs.zad_deviousPlugAnal) && !AbadonScript.UseAnalVariant
        if Utility.randomInt(0,1)
            libs.lockdevice(akTarget,UDmain.UDlibs.LittleHelper)
        else
            libs.lockdevice(akTarget,UDmain.UDlibs.InflatablePlugAnal)
        endif
    endif
    if !akTarget.wornhaskeyword(libs.zad_DeviousPlugVaginal)
        libs.lockdevice(akTarget,UDmain.UDlibs.InflatablePlugVag)
    endif
EndFunction

Function equipAbadonLatexSuit(Actor target)
    if (!target.WornhasKeyword(libs.zad_DeviousHeavyBondage))
        if Utility.randomInt(0,1)
            libs.LockDevice(target,UDmain.UDlibs.AbadonElbowbinderEbonite)
        else
            libs.LockDevice(target,UDmain.UDlibs.AbadonArmbinderEbonite)
        endif
    endif

    lockAbadonPiercings(target)
    lockAbadonHelperPlugs(target)

    int color = Utility.randomInt(1,16)
    
    if (!target.WornhasKeyword(libs.zad_DeviousSuit))
        libs.LockDevice(target,randomColorCatsuitDevice(color,"catsuit"))
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousBoots))
        libs.LockDevice(target,randomColorCatsuitDevice(color,"socks"))
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousGloves))
        libs.LockDevice(target,randomColorCatsuitDevice(color,"gloves"))
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousCollar))
        libs.LockDevice(target,randomColorCatsuitDevice(color,"collar"))
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousGag))
        libs.LockDevice(target,UDmain.UDlibs.AbadonGagTape)
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousBlindfold))
        libs.LockDevice(target,randomColorNormDevice(1,"blindfold"),True)
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousHood) && UD_useHoods)
        int loc_random = Utility.randomInt(1,2)
        if loc_random == 1
            libs.LockDevice(target,randomColorCatsuitDevice(color,"gasmask-tube"))
        elseif loc_random == 2
            libs.LockDevice(target,libsx.zadx_hood_rubber_black_Inventory)
        endif
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBelt))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
    endif
    

EndFunction

Function equipAbadonRestrictiveSuit(Actor target)
    if (!target.WornhasKeyword(libs.zad_DeviousHeavyBondage))    
        if Utility.randomInt(0,1)
            libs.LockDevice(target,UDmain.UDlibs.AbadonArmbinderEbonite)
        else
            libs.LockDevice(target,UDmain.UDlibs.AbadonStraitjacketEbonite)
        endif
    endif
    
    lockAbadonPiercings(target)
    lockAbadonHelperPlugs(target)
    
    if !target.wornHasKeyword(libs.zad_DeviousBoots)
        libs.LockDevice(target,UDmain.UDlibs.AbadonRestrictiveBoots)
    endif    

    if !target.wornHasKeyword(libs.zad_DeviousGloves)
        libs.LockDevice(target,UDmain.UDlibs.AbadonRestrictiveGloves)
    endif    

    if !target.wornHasKeyword(libs.zad_DeviousCollar)
        libs.LockDevice(target,UDmain.UDlibs.AbadonRestrictiveCollar)
    endif    

    if !target.wornHasKeyword(libs.zad_DeviousCorset)
        libs.LockDevice(target,UDmain.UDlibs.AbadonCorset)
    endif    
    
    if (!target.WornhasKeyword(libs.zad_DeviousBelt))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousGag))
        if Utility.randomInt(0,1)
            libs.LockDevice(target,UDmain.UDlibs.AbadonExtremeBallGag)
        else
            libs.LockDevice(target,UDmain.UDlibs.AbadonExtremeInflatableGag)
        endif
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBlindfold))
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
        if Utility.randomInt(0,1)
            libs.LockDevice(target,libsx.zadx_gag_rope_ball_Inventory)
        else
            libs.LockDevice(target,libsx.zadx_gag_rope_bit_Inventory)
        endif
    endif
    
    libs.LockDevice(target,libsx2.zadx_rope_harness_FullTop_Inventory)
EndFunction

Function equipAbadonTransparentSuit(Actor target)
    if (!target.WornhasKeyword(libs.zad_DeviousHeavyBondage))
        libs.LockDevice(target,UDmain.UDlibs.AbadonArmbinderWhite)
    endif
    
    lockAbadonPiercings(target)
    lockAbadonHelperPlugs(target)
    
    if (!target.WornhasKeyword(libs.zad_DeviousSuit))
        libs.LockDevice(target,UDmain.UDlibs.AbadonTransSuit)    
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousBoots))
        ;if Utility.randomInt(0,1)
            libs.LockDevice(target,UDmain.UDlibs.AbadonTransBoots)
        ;else
            ;libs.LockDevice(target, UDmain.UDlibs.AbadonPonyBootsWhite)
        ;endif
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBlindfold))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBlindfoldWhite)
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousGag))
        libs.LockDevice(target,UDmain.UDlibs.AbadonGagTape)
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousBelt))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
    endif
    
EndFunction

Function equipAbadonSimpleSuit(Actor target)
    if Utility.randomInt(0,1)
        libs.LockDevice(target,UDmain.UDlibs.AbadonArmbinderEbonite)
    else
        libs.LockDevice(target,UDmain.UDlibs.AbadonStraitjacketEboniteOpen)
    endif
    
    lockAbadonPiercings(target)
    lockAbadonHelperPlugs(target)
        
    int loc_subVar = 0;Utility.randomInt(0,1)
    
    if loc_subVar == 0 ;black
        if (!target.WornhasKeyword(libs.zad_DeviousLegCuffs))
            libs.LockDevice(target,UDmain.UDlibs.AbadonLegsCuffs)
        endif
        
        if (!target.WornhasKeyword(libs.zad_DeviousArmCuffs))
            libs.LockDevice(target,UDmain.UDlibs.AbadonArmCuffs)
        endif
        
        if (!target.WornhasKeyword(libs.zad_DeviousBoots))
            ;libs.LockDevice(target,UDmain.UDlibs.AbadonTransBoots)
            ;libs.LockDevice(target, UDmain.UDlibs.AbadonPonyBootsWhite)
            ;libs.LockDevice(target,libsx.zadx_HR_IronBalletBootsInventory)
            libs.LockDevice(target,libsx2.zadx_leather_heels_black_Inventory) ; iron boots were total mismatch, these are much better
        endif
        
        if (!target.WornhasKeyword(libs.zad_DeviousBlindfold))
            libs.LockDevice(target,UDmain.UDlibs.AbadonBlindfold)
        endif
        
        if (!target.WornhasKeyword(libs.zad_DeviousGag))
            int loc_rand = 1;Utility.randomInt(1,2)
            if GActorIsPlayer(target) ;panel gag is only for player, as its buggy for NPCs
                loc_rand = Utility.randomInt(1,2)
            endif
            if loc_rand == 1
                libs.LockDevice(target,UDmain.UDlibs.AbadonRingGag)
            else 
                libs.LockDevice(target,UDmain.UDlibs.AbadonPanelGag)
            endif
        endif
        
        if (!target.WornhasKeyword(libs.zad_DeviousCollar))
            if (!target.WornhasKeyword(libs.zad_DeviousBelt))
                if !target.WornhasKeyword(libs.zad_DeviousCorset) && !target.WornhasKeyword(libs.zad_DeviousStraitJacket)
                    libs.LockDevice(target,UDmain.UDlibs.AbadonHarness)
                else
                    libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
                endif
            else
                libs.LockDevice(target,UDmain.UDlibs.AbadonCuffCollar)
            endif
        endif

    elseif loc_subVar == 1 ;white
        if (!target.WornhasKeyword(libs.zad_DeviousBlindfold))
            libs.LockDevice(target,UDmain.UDlibs.AbadonBlindfoldWhite)
        endif
        
        if (!target.WornhasKeyword(libs.zad_DeviousGag))
            libs.LockDevice(target,UDmain.UDlibs.AbadonGagTape)
        endif

        if (!target.WornhasKeyword(libs.zad_DeviousHeavyBondage))
            libs.LockDevice(target,UDmain.UDlibs.AbadonArmbinderWhite)
        endif
    endif

EndFunction

Function equipAbadonYokeSuit(Actor target)
    if !target.wornHasKeyword(libs.zad_deviousHeavyBondage)
        libs.LockDevice(target,UDmain.UDlibs.AbadonYoke)
    endif
    
    lockAbadonPiercings(target)
    lockAbadonHelperPlugs(target)
    
    if (!target.WornhasKeyword(libs.zad_DeviousBlindfold))
        libs.LockDevice(target,UDmain.UDlibs.AbadonBlindfold)
    endif
        
    if (!target.WornhasKeyword(libs.zad_DeviousBoots))
        int loc_random = Utility.randomInt(1,3)
        if loc_random == 1
            libs.LockDevice(target,libsx.zadx_SlaveHighHeelsInventory)
        elseif loc_random == 2
            libs.LockDevice(target,libsx.zadx_HR_IronBalletBootsInventory)
        elseif loc_random == 3
            libs.LockDevice(target,UDmain.UDlibs.AbadonRestrictiveBoots)
        endif
    endif

    if (!target.WornhasKeyword(libs.zad_DeviousHood) && UD_useHoods)
        if (!target.WornhasKeyword(libs.zad_DeviousGag))
            libs.LockDevice(target,UDmain.UDlibs.AbadonGagTape)
        endif
                
        libs.LockDevice(target,libsx.zadx_catsuit_gasmask_filter_black_Inventory)
    else
        
        if (!target.WornhasKeyword(libs.zad_DeviousGag))
            int loc_rand;Utility.randomInt(1,2)
            if GActorIsPlayer(target) ;panel gag is only for player, as its buggy for NPCs
                loc_rand = Utility.randomInt(1,3)
            else
                loc_rand = Utility.randomInt(1,2)
            endif
            if loc_rand == 1
                libs.LockDevice(target,UDmain.UDlibs.AbadonBallGag)
            elseif loc_rand == 2
                libs.LockDevice(target,UDmain.UDlibs.AbadonRingGag)
            else
                libs.LockDevice(target,UDmain.UDlibs.AbadonPanelGag)
            endif
        endif
    endif
    
    if (!target.WornhasKeyword(libs.zad_DeviousCollar))
        if (!target.WornhasKeyword(libs.zad_DeviousBelt))
            if (!target.WornhasKeyword(libs.zad_DeviousCorset))
                libs.LockDevice(target,UDmain.UDlibs.AbadonHarness)
            else
                libs.LockDevice(target,UDmain.UDlibs.AbadonBelt)
            endif
        else
            libs.LockDevice(target,UDmain.UDlibs.AbadonCuffCollar)
        endif
    endif

    if !target.wornHasKeyword(libs.zad_DeviousGloves)
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
        if Utility.RandomInt(0,1) == 0
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
    
;    if !target.wornHasKeyword(libs.zad_DeviousHood) && UD_useHoods
;        libs.LockDevice(target,UDmain.UDlibs.CursedAbadonGasmask)
;    endif
 
    if UD_useHoods
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

Armor Function randomColorCatsuitDevice(int col = 0,string dev = "catsuit")
    if (col == 0)
        col = Utility.RandomInt(1,16)
    endif
    if col == 1
        
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_black_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_black_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_black_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_black_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_black_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_black_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_black_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_black_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_black_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_black_Inventory 
        endif
    elseif col == 3
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_red_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_red_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_red_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_red_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_red_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_red_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_red_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_red_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_red_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_red_Inventory 
        endif
    elseif col == 2
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_white_Inventory
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_white_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_white_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_white_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_white_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_white_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_white_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_white_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_white_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_white_Inventory 
        endif
    elseif col == 4
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_blue_Inventory
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_blue_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_blue_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_blue_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_blue_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_blue_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_blue_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_blue_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_blue_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_blue_Inventory 
        endif
    elseif col == 5
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_cyan_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_cyan_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_cyan_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_cyan_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_cyan_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_cyan_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_cyan_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_cyan_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_cyan_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_cyan_Inventory 
        endif
    elseif col == 6
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_dgreen_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_dgreen_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_dgreen_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_dgreen_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_dgreen_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_dgreen_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_dgreen_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_dgreen_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_dgreen_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_dgreen_Inventory 
        endif
    elseif col == 7
        if(dev == "catsuit")
            return libsx.zadx_catsuit_dgrey_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_dgrey_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_dgrey_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_dgrey_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_dgrey_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_dgrey_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_dgrey_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_dgrey_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_dgrey_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_dgrey_Inventory 
        endif
    elseif col == 8
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_dred_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_dred_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_dred_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_dred_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_dred_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_dred_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_dred_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_dred_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_dred_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_dred_Inventory 
        endif
    elseif col == 9
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_gold_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_gold_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_gold_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_gold_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_gold_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_gold_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_gold_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_gold_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_gold_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_gold_Inventory 
        endif
    elseif col == 10
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_green_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_green_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_green_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_green_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_green_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_green_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_green_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_green_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_green_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_green_Inventory 
        endif
    elseif col == 11
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_lgrey_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_lgrey_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_lgrey_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_lgrey_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_lgrey_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_lgrey_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_lgrey_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_lgrey_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_lgrey_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_lgrey_Inventory 
        endif
    elseif col == 12
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_orange_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_orange_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_orange_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_orange_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_orange_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_orange_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_orange_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_orange_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_orange_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_orange_Inventory 
        endif
    elseif col == 13
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_pink_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_pink_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_pink_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_pink_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_pink_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_pink_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_pink_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_pink_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_pink_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_pink_Inventory 
        endif
    elseif col == 14
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_purple_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_purple_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_purple_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_purple_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_purple_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_purple_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_purple_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_purple_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_purple_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_purple_Inventory 
        endif
    elseif col == 15
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_redwhite_Inventory 
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_red_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_redwhite_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_white_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_redwhite_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_red_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_white_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_red_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_white_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_red_Inventory 
        endif
    elseif col == 16
        if(dev == "catsuit") 
            return libsx.zadx_catsuit_yellow_Inventory     
        endif
        if(dev == "collar") 
            return libsx.zadx_catsuit_collar_yellow_Inventory 
        endif
        if(dev == "gloves") 
            return libsx.zadx_catsuit_gloves_yellow_Inventory 
        endif
        if(dev == "long-gloves") 
            return libsx.zadx_catsuit_longgloves_yellow_Inventory 
        endif
        if(dev == "socks") 
            return libsx.zadx_catsuit_boots_yellow_Inventory 
        endif
        if(dev == "ballet") 
            return libsx.zadx_catsuit_balletboots_yellow_Inventory
        endif
        if(dev == "gasmask") 
            return libsx.zadx_catsuit_gasmask_yellow_Inventory 
        endif
        if(dev == "gasmask-filter") 
            return libsx.zadx_catsuit_gasmask_filter_yellow_Inventory 
        endif
        if(dev == "gasmask-rebreather") 
            return libsx.zadx_catsuit_gasmask_rebr_yellow_Inventory 
        endif
        if(dev == "gasmask-tube") 
            return libsx.zadx_catsuit_gasmask_tube_yellow_Inventory 
        endif
    endif
    debug.trace("[UD] (randomColorCatsuitDevice): No device of color (" + col + ") and name (" + dev + ") exist!")
    return libsx.cuffsEboniteCollar
endfunction

Armor Function randomColorNormDevice(int col = 0, string dev = "armbinder")
    if (col == 0)
        col = Utility.RandomInt(1,3)
    endif
    if col == 1
        if(dev == "cuffs-arms") 
            return libsx.cuffsEboniteArms
        endif
        if(dev == "cuffs-legs") 
            return libsx.cuffsEboniteLegs 
        endif
        if(dev == "armbinder") 
            return libsx.eboniteArmbinder
        endif
        if(dev == "elbowbinder") 
            return libsx.zadx_ElbowbinderEboniteInventory 
        endif
        if (dev == "mittens")
            return libsx.zadx_PawBondageMittensLatexInventory
        endif
        if(dev == "res-boots") 
            return libsx.EbRestrictiveBoots 
        endif
        if(dev == "res-gloves") 
            return libsx.EbRestrictiveGloves
        endif
        if(dev == "res-collar") 
            return libsx.EbRestrictiveCollar 
        endif
        if(dev == "res-corset") 
            return libsx.EbRestrictiveCorset 
        endif
        if(dev == "collar") 
            return libsx.cuffsEboniteCollar 
        endif
        if(dev == "har-collar") 
            return libsx.eboniteHarnessCollar 
        endif
        if(dev == "pos-collar") 
            return libsx.collarPostureEbonite 
        endif
        if(dev == "chas-harness") 
            return libsx.eboniteHarnessBody 
        endif
        if(dev == "gag-ball-strap") 
            return libsx.gagEboniteStrapBall 
        endif
        if(dev == "gag-ball") 
            return libsx.gagEboniteBall 
        endif
        if(dev == "gag-ring") 
            return libsx.gagEboniteRing 
        endif
        if(dev == "gag-ring-strap") 
            return libsx.gagEboniteStrapRing 
        endif
        if(dev == "gag-pad") 
            return libsx.gagEbonitePanel 
        endif
        if(dev == "blindfold") 
            return libsx.eboniteBlindfold 
        endif
        if(dev == "pony-boots") 
            return libsx.EbonitePonyBoots 
        endif
        if(dev == "ballet")
            return libsx.zadx_SlaveHighHeelsInventory
        endif
        if(dev == "hobble")
            return libsx.zadx_HobbleDressLatexInventory
        endif
        if(dev == "hobble-open")
            return libsx.zadx_HobbleDressLatexOpenInventory
        endif
    elseif col == 2
        if(dev == "cuffs-arms") 
            return libsx.cuffsWTEboniteArms
        endif
        if(dev == "cuffs-legs") 
            return libsx.cuffsWTEboniteLegs 
        endif
        if(dev == "armbinder") 
            return libsx.wtEboniteArmbinder
        endif
        if(dev == "elbowbinder") 
            return libsx.zadx_ElbowbinderEboniteWhiteInventory 
        endif
        if (dev == "mittens")
            return libsx.zadx_PawBondageMittensWhiteLatexInventory
        endif
        if(dev == "res-boots") 
            return libsx.WTErestrictiveBoots 
        endif
        if(dev == "res-gloves") 
            return libsx.WTERestrictiveGloves
        endif
        if(dev == "res-collar") 
            return libsx.WTERestrictiveCollar 
        endif
        if(dev == "res-corset") 
            return libsx.WTERestrictiveCorset 
        endif
        if (dev == "collar")
            return libsx.cuffsWTEboniteCollar
        endif
        if(dev == "har-collar") 
            return libsx.wtEboniteHarnessCollar 
        endif
        if(dev == "pos-collar") 
            return libsx.collarPostureWTEbonite 
        endif
        if(dev == "chas-harness") 
            return libsx.wtEboniteHarnessBody 
        endif
        if(dev == "gag-ball-strap") 
            return libsx.gagWTEboniteStrapBall 
        endif
        if(dev == "gag-ball") 
            return libsx.gagWTEboniteBall 
        endif
        if(dev == "gag-ring") 
            return libsx.gagWTEboniteRing 
        endif
        if(dev == "gag-ring-strap") 
            return libsx.gagWTEboniteStrapRing 
        endif
        if(dev == "gag-pad") 
            return libsx.gagWTEbonitePanel 
        endif
        if(dev == "blindfold") 
            return libsx.wtEboniteBlindfold 
        endif
        if(dev == "pony-boots") 
            return libsx.WTEbonitePonyBoots 
        endif
        if(dev == "ballet")
            return libsx.zadx_SlaveHighHeelsWhiteInventory
        endif
        if(dev == "hobble")
            return libsx.zadx_HobbleDressLatexWhiteInventory
        endif
        if(dev == "hobble-open")
            return libsx.zadx_HobbleDressLatexWhiteOpenInventory
        endif
    elseif col == 3
        if(dev == "cuffs-arms") 
            return libsx.cuffsRDEboniteArms
        endif
        if(dev == "cuffs-legs") 
            return libsx.cuffsRDEboniteLegs 
        endif
        if(dev == "armbinder") 
            return libsx.RDEboniteArmbinder
        endif
        if(dev == "elbowbinder") 
            return libsx.zadx_ElbowbinderEboniteRedInventory 
        endif
        if (dev == "mittens")
            return libsx.zadx_PawBondageMittensRedLatexInventory
        endif
        if(dev == "res-boots") 
            return libsx.RDErestrictiveBoots 
        endif
        if(dev == "res-gloves") 
            return libsx.RDERestrictiveGloves
        endif
        if(dev == "res-collar") 
            return libsx.RDERestrictiveCollar 
        endif
        if(dev == "res-corset") 
            return libsx.RDERestrictiveCorset 
        endif
        if (dev == "collar")
            return libsx.cuffsRDEboniteCollar
        endif
        if(dev == "har-collar") 
            return libsx.RDEboniteHarnessCollar 
        endif
        if(dev == "pos-collar") 
            return libsx.collarPostureRDEbonite 
        endif
        if(dev == "chas-harness") 
            return libsx.RDEboniteHarnessBody 
        endif
        if(dev == "gag-ball-strap") 
            return libsx.gagRDEboniteStrapBall 
        endif
        if(dev == "gag-ball") 
            return libsx.gagRDEboniteBall 
        endif
        if(dev == "gag-ring") 
            return libsx.gagRDEboniteRing 
        endif
        if(dev == "gag-ring-strap") 
            return libsx.gagRDEboniteStrapRing 
        endif
        if(dev == "gag-pad") 
            return libsx.gagRDEbonitePanel 
        endif
        if(dev == "blindfold") 
            return libsx.RDEboniteBlindfold 
        endif
        if(dev == "pony-boots") 
            return libsx.RDEbonitePonyBoots 
        endif
        if(dev == "ballet")
            return libsx.zadx_SlaveHighHeelsRedInventory
        endif
        if(dev == "hobble")
            return libsx.zadx_HobbleDressLatexRedInventory
        endif
        if(dev == "hobble-open")
            return libsx.zadx_HobbleDressLatexRedOpenInventory
        endif
    elseif col == 4
        if(dev == "res-boots") 
            return libsx.zadx_restrictiveBootsTrans_Inventory
        endif
        if(dev == "res-gloves") 
            return libsx.zadx_catsuit_longgloves_transparent_Inventory
        endif
        if(dev == "res-collar") 
            return libsx.zadx_restrictiveCollarTrans_Inventory 
        endif
        if(dev == "res-corset") 
            return libsx.zadx_restrictiveCorsetTrans_Inventory
        endif
        if(dev == "hobble")
            return libsx.zadx_HobbleDressTransparentInventory
        endif
        
    endif
    
    ;shit went wrong, return harmless collar
    debug.trace("[UD] (randomColorNormDevice): No device of color (" + col + ") and name (" + dev + ") exist!")
    return libsx.cuffsEboniteCollar
    
EndFunction

Armor Function randomColorStraitjacketDevice(int col = 0, string dev = "normal")
    if (col == 0)
        col = Utility.RandomInt(1,3)
    endif
    if col == 1
        if(dev == "normal")
            return libsx.zadx_StraitJacketLatexBlackInventory 
        endif
        if(dev == "open")
            return libsx.zadx_StraitJacketLatexToplessBlackInventory 
        endif
        if(dev == "leg")
            return libsx.zadx_StraitJacketLatexLegsBlackInventory 
        endif
        if(dev == "leg-open")
            return libsx.zadx_StraitJacketLatexLegsToplessBlackInventory 
        endif
        if(dev == "dress")
            return libsx2.zadx_StraitJacketFormalDressEboniteBlackInventory 
        endif
        if(dev == "dress-open")
            return libsx2.zadx_StraitJacketFormalDressEboniteBlackToplessInventory 
        endif
        if(dev == "hobbl")
            return libsx2.zadx_StraitJacketHobbleDressEboniteBlackCleavageInventory 
        endif
        if(dev == "hobbl-open")
            return libsx2.zadx_StraitJacketHobbleDressEboniteBlackOpenInventory 
        endif
        if(dev == "catsuit")
            return libsx2.zadx_StraitJacketCatsuitEboniteBlackInventory 
        endif
        if(dev == "catsuit-open")
            return libsx2.zadx_StraitJacketCatsuitEboniteBlackToplessInventory 
        endif
        if(dev == "latexdress")
            return libsx2.zadx_StraitJacketLatexDressBlackInventory 
        endif
        if(dev == "latexdress-open")
            return libsx2.zadx_StraitJacketLatexDressToplessBlackInventory 
        endif
    elseif col == 2
        if(dev == "normal")
            return libsx.zadx_StraitJacketLatexWhiteInventory 
        endif
        if(dev == "open")
            return libsx.zadx_StraitJacketLatexToplessWhiteInventory 
        endif
        if(dev == "leg")
            return libsx.zadx_StraitJacketLatexLegsWhiteInventory 
        endif
        if(dev == "leg-open")
            return libsx.zadx_StraitJacketLatexLegsToplessWhiteInventory 
        endif
        if(dev == "dress")
            return libsx2.zadx_StraitJacketFormalDressEboniteWhiteInventory 
        endif
        if(dev == "dress-open")
            return libsx2.zadx_StraitJacketFormalDressEboniteWhiteToplessInventory 
        endif
        if(dev == "hobbl")
            return libsx2.zadx_StraitJacketHobbleDressEboniteWhiteCleavageInventory 
        endif
        if(dev == "hobbl-open")
            return libsx2.zadx_StraitJacketHobbleDressEboniteWhiteOpenInventory 
        endif
        if(dev == "catsuit")
            return libsx2.zadx_StraitJacketCatsuitEboniteWhiteInventory 
        endif
        if(dev == "catsuit-open")
            return libsx2.zadx_StraitJacketCatsuitEboniteWhiteToplessInventory 
        endif
        if(dev == "latexdress")
            return libsx2.zadx_StraitJacketLatexDressWhiteInventory 
        endif
        if(dev == "latexdress-open")
            return libsx2.zadx_StraitJacketLatexDressToplessWhiteInventory 
        endif
    elseif col == 3
        if(dev == "normal")
            return libsx.zadx_StraitJacketLatexRedInventory 
        endif
        if(dev == "open")
            return libsx.zadx_StraitJacketLatexToplessRedInventory 
        endif
        if(dev == "leg")
            return libsx.zadx_StraitJacketLatexLegsRedInventory 
        endif
        if(dev == "leg-open")
            return libsx.zadx_StraitJacketLatexLegsToplessRedInventory 
        endif
        if(dev == "dress")
            return libsx2.zadx_StraitJacketFormalDressEboniteRedInventory 
        endif
        if(dev == "dress-open")
            return libsx2.zadx_StraitJacketFormalDressEboniteRedToplessInventory 
        endif
        if(dev == "hobbl")
            return libsx2.zadx_StraitJacketHobbleDressEboniteRedCleavageInventory 
        endif
        if(dev == "hobbl-open")
            return libsx2.zadx_StraitJacketHobbleDressEboniteRedOpenInventory 
        endif
        if(dev == "catsuit")
            return libsx2.zadx_StraitJacketCatsuitEboniteRedInventory 
        endif
        if(dev == "catsuit-open")
            return libsx2.zadx_StraitJacketCatsuitEboniteRedToplessInventory 
        endif
        if(dev == "latexdress")
            return libsx2.zadx_StraitJacketLatexDressRedInventory 
        endif
        if(dev == "latexdress-open")
            return libsx2.zadx_StraitJacketLatexDressToplessRedInventory 
        endif    
    endif
    debug.trace("[UD] (randomColorStraitjacketDevice): No device of color (" + col + ") and name (" + dev + ") exist!")
    return libsx.cuffsEboniteCollar
EndFunction
 
zadlibs property libs auto 
zadxlibs property libsx auto
zadxlibs2 property libsx2 auto


