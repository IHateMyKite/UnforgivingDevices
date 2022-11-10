Scriptname UD_TrapManifest_ME_Script extends activemagiceffect  

import UnforgivingDevicesMain
;import UD_CustomDevice_RenderScript 

;Int Property rare_device_chance = 25 auto
UD_AbadonQuest_script Property AbadonQuest auto
UD_libs Property UDlibs auto
UDCustomDeviceMain Property UDCDmain auto
zadlibs Property libs auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

    if !akTarget.wornhaskeyword(libs.zad_deviousheavybondage)
        UDCDmain.DisableActor(akTarget)

		bool loc_haveSuit = akTarget.wornhaskeyword(libs.zad_deviousSuit)
		Formlist loc_formlist = none
	    Armor device = none
        Int loc_arousal = UDCDmain.UDOM.getArousal(akTarget)

;        if Utility.randomInt(1,99) < Round(UDCDMain.UD_BlackGooRareDeviceChance*fRange(loc_arousal/50,1.0,2.0))
;rare devices, drop more loot and goo
;            if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
;                int random = Utility.randomInt(1,3)
;                if random == 1
;                    libs.LockDevice(akTarget,UDlibs.AbadonBlueArmbinder)
;                elseif random == 2
;                    libs.LockDevice(akTarget,UDlibs.MageBinder)
;                elseif random == 3
;                    libs.LockDevice(akTarget,UDlibs.RogueBinder)
;                endif
;            else
;                int random = Utility.randomInt(1,2)
;                if random == 1
;                    libs.LockDevice(akTarget,UDlibs.AbadonBlueArmbinder)
;                elseif random == 2
;                    libs.LockDevice(akTarget,UDlibs.RogueBinder)
;                endif
;            endif
;            if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
;                int random = Utility.randomInt(1,4)
;                if random == 1
;                    libs.LockDevice(akTarget,UDlibs.AbadonWeakArmbinder)
;                elseif random == 2
;                    libs.LockDevice(akTarget,UDlibs.AbadonWeakStraitjacket)
;                elseif random == 3
;                    libs.LockDevice(akTarget,UDlibs.AbadonWeakElbowbinder)
;                elseif random == 4
;                    libs.LockDevice(akTarget,UDlibs.AbadonWeakYoke)
;                endif
;            else
;                int random = Utility.randomInt(1,3)
;                if random == 1
;                    libs.LockDevice(akTarget,UDlibs.AbadonWeakArmbinder)
;                elseif random == 2
;                    libs.LockDevice(akTarget,UDlibs.AbadonWeakElbowbinder)
;                elseif random == 3
;                    libs.LockDevice(akTarget,UDlibs.AbadonWeakYoke)
;                endif
;            endif


        int random = Round(Utility.randomInt(1,100) + (loc_arousal/5))
        
		if random > 90
		    loc_formlist = UDCDmain.UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageHard
        elseif random > 60 
			loc_formlist = UDCDmain.UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondage
		else
		    loc_formlist = UDCDmain.UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageWeak
        endif

        if loc_haveSuit
            Keyword[] loc_filter = new keyword[1]
            loc_filter[0] = libs.zad_deviousStraitjacket
            device = UDCDmain.UDmain.UDRRM.getRandomFormFromFormlistFilter(loc_formlist,loc_filter,2) as Armor
        else
            device = UDCDmain.UDmain.UDRRM.getRandomFormFromFormlist(loc_formlist) as Armor
        endif
        	
		UDCDMain.LockDeviceParalel(akTarget,device)

            if GActorIsPlayer(akTarget)
                UDCDmain.Print("Black goo smacks you and transforms into " + device.getName())
			else
                UDCDmain.Print("Black goo smacks " + GetActorName(akTarget) + " and transforms into " + device.getName())
            endif

        UDCDmain.EnableActor(akTarget)

	else
	    int loc_devicenum = Utility.randomInt(0,iRange(Round(GetMagnitude()),1,20))
    	UDCDmain.UDmain.UDRRM.LockAnyRandomRestrain(akTarget,loc_devicenum)
    endif

EndEvent


