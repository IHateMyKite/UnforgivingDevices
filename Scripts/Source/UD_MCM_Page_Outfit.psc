Scriptname UD_MCM_Page_Outfit extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_OutfitManager  Property UDOTM hidden
    UD_OutfitManager Function Get()
        return UDmain.UDOTM
    EndFunction
EndProperty

Int         UD_OutfitSelected = 0
int         UD_OutfitList_M
int         UD_OutfitDisable_T
Int         UD_OutfitReset_T
Int         UD_OutfitEquip_T
Int         UD_OutfitSectionSelected = 0
int         UD_OutfitSections_M
string[]    UD_OutfitSections_ML
Int[]       UD_OutfitDeviceSelected_S
Int[]       UD_OutfitDeviceSelectedType
Int[]       UD_OutfitDeviceSelectedIndex

Function PageUpdate()
    UD_OutfitSections_ML = new String[5]
    UD_OutfitSections_ML[0] = "Head"
    UD_OutfitSections_ML[1] = "Body"
    UD_OutfitSections_ML[2] = "Hands"
    UD_OutfitSections_ML[3] = "Legs"
    UD_OutfitSections_ML[4] = "Toys"
EndFunction

Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("Custom Outfits")
    addEmptyOption()
    
    UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
    
    UD_OutfitList_M = AddMenuOption("Selected outfit: ", UDOTM.UD_OutfitList[UD_OutfitSelected])
    AddTextOption("Source",loc_outfit.GetOwningQuest().GetName(),FlagSwitch(false))
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("Base details")
    addEmptyOption()
    
    AddTextOption("Name",loc_outfit.NameFull,FlagSwitch(false))
    AddTextOption("Alias",loc_outfit.NameAlias,FlagSwitch(false))
    
    UD_OutfitDisable_T  = AddToggleOption("Disabled",loc_outfit.Disable)
    AddTextOption("Random?",loc_outfit.Random as String,FlagSwitch(false))
    
    UD_OutfitReset_T    = AddTextOption("==RESET==", "$-PRESS-")
    UD_OutfitEquip_T    = AddTextOption("==EQUIP==", "$-PRESS-",FlagSwitch(UDMain.DebugMod))
    
    addEmptyOption()
    addEmptyOption()
    
    AddHeaderOption("Devices")
    UD_OutfitSections_M = AddMenuOption("Section: ", UD_OutfitSections_ML[UD_OutfitSectionSelected])
    
    ShowOutfitDevices(loc_outfit)
    ; TODO - Show all devices locked by outfit
EndFunction

Function PageOptionSelect(Int aiOption)
    if(aiOption == UD_OutfitDisable_T)
        UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
        loc_outfit.Disable = !loc_outfit.Disable
        SetToggleOptionValue(UD_OutfitDisable_T, loc_outfit.Disable)
    elseif aiOption == UD_OutfitReset_T
        if ShowMessage("Do you really want to reset the outfit storage and set it to default values?")
            Alias loc_outfit    = UDOTM.UD_OutfitListRef[UD_OutfitSelected]
            UD_OutfitStorage loc_storage   = loc_outfit.GetOwningQuest() as UD_OutfitStorage
            loc_storage.ResetModule()
            loc_storage.WaitForReady(10.0)
            ;loc_outfit.Reset()
            forcePageReset()
        endif
    elseif aiOption == UD_OutfitEquip_T
        UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
        closeMCM()
        loc_outfit.LockDevices(UDMain.Player)
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)
    if UD_OutfitDeviceSelected_S
        int loc_i = UD_OutfitDeviceSelected_S.find(aiOption)
        if loc_i >= 0
            UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
            SetSliderDialogStartValue(loc_outfit.GetRnd(UD_OutfitDeviceSelectedType[loc_i],UD_OutfitDeviceSelectedIndex[loc_i]))
            SetSliderDialogDefaultValue(50.0)
            SetSliderDialogRange(0.0, 100.0)
            SetSliderDialogInterval(1.0)
        endif
    endif
EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)
    if UD_OutfitDeviceSelected_S
        int loc_i = UD_OutfitDeviceSelected_S.find(aiOption)
        if loc_i >= 0
            UD_Outfit loc_outfit = (UDOTM.UD_OutfitListRef[UD_OutfitSelected] as UD_Outfit)
            loc_outfit.UpdateRnd(UD_OutfitDeviceSelectedType[loc_i],UD_OutfitDeviceSelectedIndex[loc_i],Round(afValue))
            SetSliderOptionValue(aiOption, loc_outfit.GetRnd(UD_OutfitDeviceSelectedType[loc_i],UD_OutfitDeviceSelectedIndex[loc_i]), "{0}")
        endif
    endif
EndFunction

Function PageOptionMenuOpen(int aiOption)
    If aiOption == UD_OutfitList_M
        SetMenuDialogOptions(UDOTM.UD_OutfitList)
        SetMenuDialogStartIndex(UD_OutfitSelected)
        SetMenuDialogDefaultIndex(UD_OutfitSelected)
    elseif aiOption == UD_OutfitSections_M
        SetMenuDialogOptions(UD_OutfitSections_ML)
        SetMenuDialogStartIndex(UD_OutfitSectionSelected)
        SetMenuDialogDefaultIndex(UD_OutfitSectionSelected)
    EndIf
EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)
    If aiOption == UD_OutfitList_M
        UD_OutfitSelected = aiIndex
        SetMenuOptionValue(aiOption, UDOTM.UD_OutfitList[aiIndex])
        forcePageReset()
    elseif aiOption == UD_OutfitSections_M
        UD_OutfitSectionSelected = aiIndex
        SetMenuOptionValue(aiOption, UD_OutfitSections_ML[aiIndex])
        forcePageReset()
    EndIf
EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int aiOption)

EndFunction

Function ShowOutfitDevices(UD_Outfit akOutfit)
    UD_OutfitDeviceSelected_S = Utility.CreateIntArray(0)
    UD_OutfitDeviceSelectedType = Utility.CreateIntArray(0)
    UD_OutfitDeviceSelectedIndex = Utility.CreateIntArray(0)
    if UD_OutfitSectionSelected == 0
        ShowOutfitDevicesFromList("Hoods",akOutfit.UD_Hood, akOutfit.UD_Hood_RND,1)
        ShowOutfitDevicesFromList("Gags",akOutfit.UD_Gag, akOutfit.UD_Gag_RND,2)
        ShowOutfitDevicesFromList("Blindfold",akOutfit.UD_Blindfold, akOutfit.UD_Blindfold_RND,3)
        ShowOutfitDevicesFromList("Collar",akOutfit.UD_Collar, akOutfit.UD_Collar_RND,4)
    elseif UD_OutfitSectionSelected == 1
        ShowOutfitDevicesFromList("Suit",akOutfit.UD_Suit, akOutfit.UD_Suit_RND,5)
        ShowOutfitDevicesFromList("Belt",akOutfit.UD_Belt, akOutfit.UD_Belt_RND,6)
        ShowOutfitDevicesFromList("Bra",akOutfit.UD_Bra, akOutfit.UD_Bra_RND,7)
        ShowOutfitDevicesFromList("CorsetHarness",akOutfit.UD_CorsetHarness, akOutfit.UD_CorsetHarness_RND,8)
    elseif UD_OutfitSectionSelected == 2
        ShowOutfitDevicesFromList("Gloves",akOutfit.UD_Gloves, akOutfit.UD_Gloves_RND,9)
        ShowOutfitDevicesFromList("Arm cuffs",akOutfit.UD_CuffsArms, akOutfit.UD_CuffsArms_RND,10)
        ShowOutfitDevicesFromList("Heavy Bondage",akOutfit.UD_HeavyBondage, akOutfit.UD_HeavyBondage_RND,11)
    elseif UD_OutfitSectionSelected == 3
        ShowOutfitDevicesFromList("Boots",akOutfit.UD_Boots, akOutfit.UD_Boots_RND,12)
        ShowOutfitDevicesFromList("Leg cuffs",akOutfit.UD_CuffsLegs, akOutfit.UD_CuffsLegs_RND,13)
    elseif UD_OutfitSectionSelected == 4
        ShowOutfitDevicesFromList("Plug Vaginal",akOutfit.UD_PlugVaginal, akOutfit.UD_PlugVaginal_RND,14)
        ShowOutfitDevicesFromList("Plug Anal",akOutfit.UD_PlugAnal, akOutfit.UD_PlugAnal_RND,15)
        ShowOutfitDevicesFromList("Piercing vaginal",akOutfit.UD_PiercingVag, akOutfit.UD_PiercingVag_RND,16)
        ShowOutfitDevicesFromList("Piercing nipple",akOutfit.UD_PiercingNip, akOutfit.UD_PiercingNip_RND,17)
    endif
EndFunction

Function ShowOutfitDevicesFromList(String asSubSection, Armor[] aakList, Int[] aaiRnd,Int aiType)
    if !aakList
        return
    endif
    
    AddHeaderOption(asSubSection)
    addEmptyOption()

    int loc_i = 0
    while loc_i < aakList.length
        AddTextOption("["+loc_i+"]",aakList[loc_i].GetName())
        int loc_id = AddSliderOption("Weight: ",aaiRnd[loc_i],"{0}")
        UD_OutfitDeviceSelected_S   = PapyrusUtil.PushInt(UD_OutfitDeviceSelected_S,loc_id)
        UD_OutfitDeviceSelectedType = PapyrusUtil.PushInt(UD_OutfitDeviceSelectedType,aiType)
        UD_OutfitDeviceSelectedIndex = PapyrusUtil.PushInt(UD_OutfitDeviceSelectedIndex,loc_i)
        loc_i += 1
    endwhile
EndFunction