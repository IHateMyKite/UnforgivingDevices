Scriptname UD_BlackGooMagEffect_Script extends activemagiceffect  

import UnforgivingDevicesMain

;Int Property rare_device_chance = 25 auto
UD_AbadonQuest_script Property AbadonQuest auto
UD_libs Property UDlibs auto
UDCustomDeviceMain Property UDCDmain auto
zadlibs Property libs auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if !akTarget.wornhaskeyword(libs.zad_deviousheavybondage)
		UDCDmain.DisableActor(akTarget)
		
		if Utility.randomInt() < AbadonQuest.gooRareDeviceChance 
			;rare devices, drop more loot and goo
			if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
				int random = Utility.randomInt(1,3)
				if random == 1
					libs.LockDevice(akTarget,UDlibs.AbadonBlueArmbinder)
				elseif random == 2
					libs.LockDevice(akTarget,UDlibs.MageBinder)
				elseif random == 3
					libs.LockDevice(akTarget,UDlibs.RogueBinder)
				endif
			else
				int random = Utility.randomInt(1,2)
				if random == 1
					libs.LockDevice(akTarget,UDlibs.AbadonBlueArmbinder)
				elseif random == 2
					libs.LockDevice(akTarget,UDlibs.RogueBinder)
				endif
			endif
			if ActorIsPlayer(akTarget)
				ShowMessageBox("Black goo covers your body and tie your hands while changing shape to RARE bondage restraint!")
			endif
		else
			if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
				int random = Utility.randomInt(1,4)
				if random == 1
					libs.LockDevice(akTarget,UDlibs.AbadonWeakArmbinder)
				elseif random == 2
					libs.LockDevice(akTarget,UDlibs.AbadonWeakStraitjacket)
				elseif random == 3
					libs.LockDevice(akTarget,UDlibs.AbadonWeakElbowbinder)
				elseif random == 4
					libs.LockDevice(akTarget,UDlibs.AbadonWeakYoke)
				endif
			else
				int random = Utility.randomInt(1,3)
				if random == 1
					libs.LockDevice(akTarget,UDlibs.AbadonWeakArmbinder)
				elseif random == 2
					libs.LockDevice(akTarget,UDlibs.AbadonWeakElbowbinder)
				elseif random == 3
					libs.LockDevice(akTarget,UDlibs.AbadonWeakYoke)
				endif
			endif
			if ActorIsPlayer(akTarget)
				ShowMessageBox("Black goo covers your body and tie your hands while changing shape to bondage restraint!")
			endif
		endif
		
		UDCDmain.EnableActor(akTarget)
	endif
EndEvent


