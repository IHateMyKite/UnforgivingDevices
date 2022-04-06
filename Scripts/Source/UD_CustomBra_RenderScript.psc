Scriptname UD_CustomBra_RenderScript extends UD_CustomDevice_RenderScript  

Function InitPost()
	UD_DeviceType = "Chastity bra"
	UD_ActiveEffectName = "Activate Nipple Piercings"
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchBra(self)
EndFunction

bool Function canBeActivated()
	;/
	int loc_num = UDCDmain.getNumberOfActivableDevicesWithKeyword(getWearer(),libs.zad_DeviousPiercingsNipple)
	if loc_num > 0
		return true
	endif
	return false
	/;
	if getWearer().wornhaskeyword(libs.zad_DeviousPiercingsNipple) && getRelativeElapsedCooldownTime() >= 0.1
		if UDCDmain.getVibratorNum(getWearer())
			return true
		endif
	else
		return false
	endif
EndFunction

Function activateDevice()
	int loc_num = UDCDmain.getNumberOfDevicesWithKeyword(getWearer(),libs.zad_DeviousPiercingsNipple)
	if loc_num > 0
		UD_CustomDevice_RenderScript[] loc_piercings_arr = UDCDmain.getAllDevicesByKeyword(getWearer(),libs.zad_DeviousPiercingsNipple)
		UD_CustomDevice_RenderScript loc_piercings = loc_piercings_arr[Utility.randomInt(0,loc_num - 1)]

		if (loc_piercings as UD_CustomVibratorBase_RenderScript)
			UD_CustomVibratorBase_RenderScript loc_vibrator = loc_piercings as UD_CustomVibratorBase_RenderScript
			if WearerIsPLayer()
				debug.notification(getDeviceName() + " activates your nipple piercings!")
			elseif WearerIsFollower()
				debug.notification(getWearerName() + "s "+ getDeviceName() +" activates their nipple piercings!")
			endif
			if loc_vibrator.canVibrate()
				if !loc_vibrator.isVibrating()
					loc_vibrator.ForceModDuration(1.5)
					loc_vibrator.ForceModStrength(1.5)
					loc_vibrator.activateDevice()
					;UDCDmain.startVibFunction(self,true)
				else
					loc_vibrator.addVibDuration(30)
					loc_vibrator.addVibStrength(25)
				endif
			else
				loc_piercings.activateDevice()
			endif
		endif
	endif
EndFunction