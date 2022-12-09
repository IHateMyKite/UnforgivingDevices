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

GlobalVariable _validDevice
GlobalVariable Property ValidDevice
    GlobalVariable Function Get()
        if !_validDevice
            _validDevice = GetMeMyForm(0x15D5FA, "PR100_NPCAI.esp") as GlobalVariable
        endif
        return _validDevice
    EndFunction
EndProperty

Function SetHelpPrice_0G(ObjectReference akSpeakerRef) ;Free
   GInfo("SetHelpPrice_0G")
   MoneyForHelp.Value = 0
EndFunction
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
    ValidatePrice()
    if Round(MoneyForHelp.Value)
        Game.GetPlayer().RemoveItem(UDCDMain.UDlibs.Gold,Round(MoneyForHelp.Value),false,akSpeakerRef) ;move the gold to the speaker
        MoneyForHelp.Value = 0 ;reset
    endif
    
    if UDCDMain.UDDmain.SelectedDevice
        UDCDmain.OpenHelpDeviceMenu(UDCDMain.UDDmain.SelectedDevice,akSpeakerRef as Actor,False,True)
    else
        GError("Error: Selected device is none")
    endif
EndFunction

Function ChooseDeviceAndCheckFree(ObjectReference akSpeakerRef)
    MoneyForHelp.Value = 0 ;reset
    ChooseDeviceAndCheck(akSpeakerRef)
EndFunction

Function ChooseDeviceAndCheck(ObjectReference akSpeakerRef)
    Actor akHelper = akSpeakerRef as Actor
    float loc_currenttime = Utility.GetCurrentGameTime()
    float loc_cooldowntime = StorageUtil.GetFloatValue(akHelper,"UDNPCCD:"+Game.GetPlayer(),0)
    if loc_cooldowntime > loc_currenttime
        ValidDevice.Value = 1 ;NPC is on cooldown
        return
    endif
    
    UD_CustomDevice_NPCSlot loc_slot = UDCDmain.getNPCSlot(Game.GetPlayer())
    if loc_slot
        UD_CustomDevice_RenderScript loc_device = loc_slot.GetUserSelectedDevice()
        if loc_device
            UDCDMain.UDDmain.SelectedDevice = loc_device
            ValidDevice.Value = 0 ;Player choose device
            return
        else
            ValidDevice.Value = 2 ;Player didnt choose device
            ValidatePrice()
            return
        endif
    else
        ValidDevice.Value = 3 ;actor is not registered
        return
    endif
EndFunction

Function ValidatePrice()
    if ValidDevice.Value
        MoneyForHelp.Value = 0
    endif
EndFunction

Function LockRandomHandRestrain(ObjectReference akSpeakerRef)
    UDCDmain.UDmain.UDRRM.LockRandomRestrain(Game.GetPlayer(),false,0x00000010) ;lock hand restrain
    UDCDmain.UDmain.UDRRM.LockAnyRandomRestrain(Game.GetPlayer(),Utility.randomInt(3,8),false) ;lock other random devices
    Debug.Messagebox(GetActorName(akSpeakerRef as Actor) + " didn't like your attitude and locked you in variaty of devices to teach you a lesson.")
EndFunction

UDCustomDeviceMain _UDCDmain
UDCustomDeviceMain Property UDCDmain 
    UDCustomDeviceMain Function Get()
        if !_UDCDmain
            _UDCDmain = GetMeMyForm(0x15E73C, "UnforgivingDevices.esp") as UDCustomDeviceMain
        endif
        return _UDCDmain
    EndFunction
    Function Set(UDCustomDeviceMain akVal)
        _UDCDmain = akVal
    EndFunction
EndProperty
