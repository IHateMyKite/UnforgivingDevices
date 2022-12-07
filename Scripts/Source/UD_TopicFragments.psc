;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname UD_TopicFragments Extends TopicInfo Hidden conditional

import UnforgivingDevicesMain

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
akSPeaker.OpenInventory(abForceOpen = True)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
UDCDmain.HelpNPC(akSpeaker,Game.getPlayer(),UDCDmain.ActorIsFollower(akSpeaker))
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
UDCDmain.HelpNPC(Game.getPlayer(),akSpeaker,false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
bool[] loc_arrcontrol = new bool[30]
loc_arrcontrol[6] = true
loc_arrcontrol[7] = true
loc_arrcontrol[14] = true
UDCDmain.UDCD_NPCM.getPlayerSlot().getHeavyBondageDevice().DeviceMenuWH(akSpeaker,loc_arrcontrol)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
UDCDmain.getMinigameDevice(akSpeaker).StopMinigame()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;akSpeaker.ShowGiftMenu(False, UDCDmain.UDlibs.GiftMenuFilter,True,False)
UDCDmain.openNPCHelpMenu(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable _moneyForHelp
GlobalVariable Property MoneyForHelp
    GlobalVariable Function Get()
        if !_moneyForHelp
            _moneyForHelp = GetMeMyForm(0x15D5F2, "PR100_NPCAI.esp") as GlobalVariable
        endif
        return _moneyForHelp
    EndFunction
EndProperty



Function SetHelpPrice_50G(ObjectReference akSpeakerRef)
   MoneyForHelp.Value = 50
EndFunction
Function SetHelpPrice_100G(ObjectReference akSpeakerRef)
    MoneyForHelp.Value = 100
EndFunction
Function SetHelpPrice_200G(ObjectReference akSpeakerRef)
    MoneyForHelp.Value = 200
EndFunction
Function SetHelpPrice_300G(ObjectReference akSpeakerRef)
    MoneyForHelp.Value = 300
EndFunction
Function SetHelpPrice_500G(ObjectReference akSpeakerRef)
    MoneyForHelp.Value = 500
EndFunction

Function PayAndHelp(ObjectReference akSpeakerRef)
    Game.GetPlayer().RemoveItem(UDCDMain.UDlibs.Gold,Round(MoneyForHelp.Value),false,akSpeakerRef) ;move the gold to the speaker
    (akSpeakerRef as Actor).PathToReference(Game.GetPlayer(), 0.5)
    UDCDmain.HelpNPC(Game.getPlayer(),akSpeakerRef as Actor,false)
EndFunction

Function LockRandomHandRestrain(ObjectReference akSpeakerRef)
    ;Game.GetPlayer().RemoveItem(UDCDMain.UDlibs.Gold,Round(MoneyForHelp.Value),akSpeakerRef) ;move the gold to the speaker
    ;UDCDmain.HelpNPC(Game.getPlayer(),akSpeakerRef as Actor,false)
    UDCDmain.UDmain.UDRRM.LockRandomRestrain(Game.GetPlayer(),false,0x00000010)
EndFunction

UDCustomDeviceMain Property UDCDmain  Auto
