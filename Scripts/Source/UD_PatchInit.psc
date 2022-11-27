Scriptname UD_PatchInit extends Quest

String      Property UD_PatchName       = "UnNamedPatch"    auto
Formlist    Property KeywordFormList                        auto
Keyword[]   Property QuestKeywords                          auto
UnforgivingDevicesMain  _udmain
Quest                   _udquest ;kept for possible future optimization

UnforgivingDevicesMain Property UDmain hidden ;main function
    UnforgivingDevicesMain Function get()
        if !_udmain || !_udquest
            _udquest = Game.getFormFromFile(0x00005901,"UnforgivingDevices.esp") as Quest
            _udmain = _udquest as UnforgivingDevicesMain
        endif
        return _udmain
    EndFunction
    Function set(UnforgivingDevicesMain akForm)
        _udmain = akForm
    EndFunction
EndProperty

UD_RandomRestraintManager Property UDRRM    auto

zadlibs Property libs
    zadlibs Function Get()
        return UDmain.libs
    EndFunction
EndProperty
zadxlibs Property libsx
    zadxlibs Function Get()
        return UDmain.ItemManager.libsx
    EndFunction
EndProperty
zadxlibs2 Property libsx2
    zadxlibs2 Function Get()
        return UDmain.ItemManager.libsx2
    EndFunction
EndProperty


;Armor arrays
Armor[] Property UD_PatchRandomDeviceList_ArmCuffs          auto
Armor[] Property UD_PatchRandomDeviceList_LegCuffs          auto
Armor[] Property UD_PatchRandomDeviceList_Collar            auto
Armor[] Property UD_PatchRandomDeviceList_Boots             auto
Armor[] Property UD_PatchRandomDeviceList_Belt              auto
Armor[] Property UD_PatchRandomDeviceList_Bra               auto
Armor[] Property UD_PatchRandomDeviceList_Gag               auto
Armor[] Property UD_PatchRandomDeviceList_Hood              auto
Armor[] Property UD_PatchRandomDeviceList_Blindfold         auto

Armor[] Property UD_PatchRandomDeviceList_HeavyBondageWeak  auto
Armor[] Property UD_PatchRandomDeviceList_HeavyBondage      auto
Armor[] Property UD_PatchRandomDeviceList_HeavyBondage_Suit auto
Armor[] Property UD_PatchRandomDeviceList_HeavyBondageHard  auto

Armor[] Property UD_PatchRandomDeviceList_Suit              auto    ;9
Armor[] Property UD_PatchRandomDeviceList_PlugVaginal       auto    ;10
Armor[] Property UD_PatchRandomDeviceList_PlugAnal          auto    ;11
Armor[] Property UD_PatchRandomDeviceList_PiercingVag       auto    ;12
Armor[] Property UD_PatchRandomDeviceList_PiercingNipple    auto    ;13
Armor[] Property UD_PatchRandomDeviceList_Gloves            auto    ;14


;String[] Property UD_CustomAbadonSuitEvent                  auto

;Max 5 custom suits per patch for now. In case more are needed, other quest with UD_PatchInit will have to be created
String  Property UD_CustomAbadonSuitEvent_1                         auto
String  Property UD_CustomAbadonSuitEvent_2                         auto
String  Property UD_CustomAbadonSuitEvent_3                         auto
String  Property UD_CustomAbadonSuitEvent_4                         auto
String  Property UD_CustomAbadonSuitEvent_5                         auto

String  Property UD_CustomAbadonSuitName_1      = "UnNamedSuit"     auto
String  Property UD_CustomAbadonSuitName_2      = "UnNamedSuit"     auto
String  Property UD_CustomAbadonSuitName_3      = "UnNamedSuit"     auto
String  Property UD_CustomAbadonSuitName_4      = "UnNamedSuit"     auto
String  Property UD_CustomAbadonSuitName_5      = "UnNamedSuit"     auto

Event onInit()
    Utility.wait(Utility.randomFloat(1.0,4.0))
    Update()
    RegisterForModEvent("UD_PatchUpdate", "UpdateEvent")
    UpdateSuit()
EndEvent

Function ProccesRandomDevices(Armor[] aPatchList,FormList flTargetList)
    if !aPatchList 
        return
    endif
    if aPatchList.length
        Int i = aPatchList.length
        while i
            i-=1
            flTargetList.addForm(aPatchList[i])
        endwhile
    endif
EndFunction

Event UpdateEvent(string eventName, string strArg, float numArg, Form sender)
    if eventName == "UD_PatchUpdate"
        Update()
    elseif eventName == "UD_AbadonSuitUpdate"
        UpdateSuit()
    endif
EndEvent

Event EquipSuitEvent(Form kActor,String asEvent)
    EquipSuit(kActor as Actor,asEvent)
EndEvent

Function Update()
    if !UDRRM
        UDRRM = UDmain.UDRRM
    endif
    int i = QuestKeywords.length
    while i
        i-=1
        KeywordFormList.addForm(QuestKeywords[i])
    endwhile
    if UDRRM
        ProccesRandomDevices(UD_PatchRandomDeviceList_ArmCuffs,UDRRM.UD_RandomDeviceList_ArmCuffs)
        ProccesRandomDevices(UD_PatchRandomDeviceList_LegCuffs,UDRRM.UD_RandomDeviceList_LegCuffs)
        ProccesRandomDevices(UD_PatchRandomDeviceList_Collar,UDRRM.UD_RandomDeviceList_Collar)
        ProccesRandomDevices(UD_PatchRandomDeviceList_Boots,UDRRM.UD_RandomDeviceList_Boots)
        ProccesRandomDevices(UD_PatchRandomDeviceList_Belt,UDRRM.UD_RandomDeviceList_Belt)
        ProccesRandomDevices(UD_PatchRandomDeviceList_Bra,UDRRM.UD_RandomDeviceList_Bra)
        ProccesRandomDevices(UD_PatchRandomDeviceList_Gag,UDRRM.UD_RandomDeviceList_Gag)
        ProccesRandomDevices(UD_PatchRandomDeviceList_Hood,UDRRM.UD_RandomDeviceList_Hood)
        ProccesRandomDevices(UD_PatchRandomDeviceList_Blindfold,UDRRM.UD_RandomDeviceList_Blindfold)
        ProccesRandomDevices(UD_PatchRandomDeviceList_HeavyBondageWeak,UDRRM.UD_RandomDeviceList_HeavyBondageWeak)
        ProccesRandomDevices(UD_PatchRandomDeviceList_HeavyBondage,UDRRM.UD_RandomDeviceList_HeavyBondage)
        ProccesRandomDevices(UD_PatchRandomDeviceList_HeavyBondage_Suit,UDRRM.UD_RandomDeviceList_HeavyBondage_Suit)
        ProccesRandomDevices(UD_PatchRandomDeviceList_HeavyBondageHard,UDRRM.UD_RandomDeviceList_HeavyBondageHard)
        ProccesRandomDevices(UD_PatchRandomDeviceList_Suit,UDRRM.UD_RandomDeviceList_Suit)
        ProccesRandomDevices(UD_PatchRandomDeviceList_PlugVaginal,UDRRM.UD_RandomDeviceList_PlugVaginal)
        ProccesRandomDevices(UD_PatchRandomDeviceList_PlugAnal,UDRRM.UD_RandomDeviceList_PlugAnal)
        ProccesRandomDevices(UD_PatchRandomDeviceList_PiercingVag,UDRRM.UD_RandomDeviceList_PiercingVag)
        ProccesRandomDevices(UD_PatchRandomDeviceList_PiercingNipple,UDRRM.UD_RandomDeviceList_PiercingNipple)
        ProccesRandomDevices(UD_PatchRandomDeviceList_Gloves,UDRRM.UD_RandomDeviceList_Gloves)
    endif
EndFunction

Bool    _updateSuitMutex    = False
Function UpdateSuit()
    while _updateSuitMutex
        Utility.waitMenuMode(0.01)
    endwhile
    _updateSuitMutex = True
    
    UDmain.Info("Updating custom abadon suit on patch " + UD_PatchName)
    
    RegisterForModEvent("UD_AbadonSuitUpdate", "UpdateEvent")

    RegisterCustomAbadonSuitEvent(UD_CustomAbadonSuitEvent_1,UD_CustomAbadonSuitName_1)
    RegisterCustomAbadonSuitEvent(UD_CustomAbadonSuitEvent_2,UD_CustomAbadonSuitName_2)
    RegisterCustomAbadonSuitEvent(UD_CustomAbadonSuitEvent_3,UD_CustomAbadonSuitName_3)
    RegisterCustomAbadonSuitEvent(UD_CustomAbadonSuitEvent_4,UD_CustomAbadonSuitName_4)
    RegisterCustomAbadonSuitEvent(UD_CustomAbadonSuitEvent_5,UD_CustomAbadonSuitName_5)

    _updateSuitMutex = False
EndFunction

Function RegisterCustomAbadonSuitEvent(String asEvent,String asSuitName)
    if asEvent
        UnregisterForModEvent(asEvent)
        UDmain.UDAbadonQuest.AddCustomAbadonSet(asEvent,asSuitName)
        RegisterForModEvent(asEvent, "EquipSuitEvent")
    endif
EndFunction

;OVERRIDE NEEDED
Function EquipSuit(Actor akActor,String asEventName)
EndFunction