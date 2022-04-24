;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF__0715AA5E Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
if UDCDmain.IsRegistered(akSpeaker)
		UD_CustomDevice_NPCSlot loc_slot = UDCDmain.UDCD_NPCM.getNPCSlotByActor(akSpeaker)
		if loc_slot
			UD_CustomDevice_RenderScript loc_device = loc_slot.GetUserSelectedDevice()
			if loc_device
				loc_device.deviceMenuWH(Game.getPlayer(),new Bool[30])
			endif
		endif
	endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

UDCustomDeviceMain Property UDCDmain  Auto  
