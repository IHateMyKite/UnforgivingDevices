;/  File: UD_PatchInit

    Script used for initializing patches. Should be used on all patches to make loading safer. Also provide additional features like adding quest keyword and generic keys.
   
    Extending this script with new screipt allow user to create new abadon suits.
/;
Scriptname UD_PatchInit extends Quest

import unforgivingDevicesMain

;/  Group: Important properties
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: UD_PatchSource
    
    Source of patch .esp. Need to have also extension. *Allways have to be filled!!*
    
    Example:
        If this script in on quest in the patch *UnforgivingDevices Some Patch.esp* then the UD_PatchSource will be *UnforgivingDevices Some Patch.esp*
/;
String      Property UD_PatchSource     = "error"           auto ;

;/  Variable: UD_PatchName
    
    Name of the patch. This is only used in case of error, so user can know what patch have issue
/;
String      Property UD_PatchName       = "UnNamedPatch"    auto

;/  Variable: QuestKeywords
    
    Array of quest keywords which will be injected to main pool of quest keywords. All quest related ekywords from patched mod should be added there
/;
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

UD_RandomRestraintManager Property UDRRM hidden
    UD_RandomRestraintManager Function Get()
        return UDmain.UDRRM
    EndFunction
EndProperty
zadlibs Property libs hidden
    zadlibs Function Get()
        return UDmain.libs
    EndFunction
EndProperty
zadxlibs Property libsx hidden
    zadxlibs Function Get()
        return UDmain.ItemManager.libsx
    EndFunction
EndProperty
zadxlibs2 Property libsx2 hidden
    zadxlibs2 Function Get()
        return UDmain.ItemManager.libsx2
    EndFunction
EndProperty
UDCustomDeviceMain Property UDCDmain hidden
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty

;/  Group: Custom Abadon Suit
===========================================================================================
===========================================================================================
===========================================================================================
/;


;Max 5 custom suits per patch for now. In case more are needed, other quest with UD_PatchInit will have to be created

;/  Variable: UD_CustomAbadonSuitEvent_1
    
    Name of event for custom abadon suit. Should be allways made in such so its impossible that other patch uses same named event!!
    
    Example: UD_Patch_NameOfThePatch_NameOfTheSuit
/;
String  Property UD_CustomAbadonSuitEvent_1                         auto

;/  Variable: UD_CustomAbadonSuitEvent_1
    
    Name of event for custom abadon suit. Should be allways made in such so its impossible that other patch uses same named event!!
    
    Example: UD_Patch_NameOfThePatch_NameOfTheSuit
/;
String  Property UD_CustomAbadonSuitEvent_2                         auto

;/  Variable: UD_CustomAbadonSuitEvent_3
    
    Name of event for custom abadon suit. Should be allways made in such so its impossible that other patch uses same named event!!
    
    Example: UD_Patch_NameOfThePatch_NameOfTheSuit
/;
String  Property UD_CustomAbadonSuitEvent_3                         auto

;/  Variable: UD_CustomAbadonSuitEvent_4
    
    Name of event for custom abadon suit. Should be allways made in such so its impossible that other patch uses same named event!!
    
    Example: UD_Patch_NameOfThePatch_NameOfTheSuit
/;
String  Property UD_CustomAbadonSuitEvent_4                         auto

;/  Variable: UD_CustomAbadonSuitEvent_5
    
    Name of event for custom abadon suit. Should be allways made in such so its impossible that other patch uses same named event!!
    
    Example: UD_Patch_NameOfThePatch_NameOfTheSuit
/;
String  Property UD_CustomAbadonSuitEvent_5                         auto

;/  Variable: UD_CustomAbadonSuitName_1
    
    Name of the custom abadon suit, which shows in MCM. UD_CustomAbadonSuitName_X corresponds to the UD_CustomAbadonSuitEvent_X
/;
String  Property UD_CustomAbadonSuitName_1      = "UnNamedSuit"     auto

;/  Variable: UD_CustomAbadonSuitName_2
    
    Name of the custom abadon suit, which shows in MCM. UD_CustomAbadonSuitName_X corresponds to the UD_CustomAbadonSuitEvent_X
/;
String  Property UD_CustomAbadonSuitName_2      = "UnNamedSuit"     auto

;/  Variable: UD_CustomAbadonSuitName_3
    
    Name of the custom abadon suit, which shows in MCM. UD_CustomAbadonSuitName_X corresponds to the UD_CustomAbadonSuitEvent_X
/;
String  Property UD_CustomAbadonSuitName_3      = "UnNamedSuit"     auto

;/  Variable: UD_CustomAbadonSuitName_4
    
    Name of the custom abadon suit, which shows in MCM. UD_CustomAbadonSuitName_X corresponds to the UD_CustomAbadonSuitEvent_X
/;
String  Property UD_CustomAbadonSuitName_4      = "UnNamedSuit"     auto

;/  Variable: UD_CustomAbadonSuitName_5
    
    Name of the custom abadon suit, which shows in MCM. UD_CustomAbadonSuitName_X corresponds to the UD_CustomAbadonSuitEvent_X
/;
String  Property UD_CustomAbadonSuitName_5      = "UnNamedSuit"     auto

;keys which should be taken by UD as generic. Theese cays can be destroyed (either by failing unlock, or by using the key too many times)
Key[]   Property UD_GenericKeys                                     auto

Event onInit()
    Utility.wait(Utility.randomFloat(1.0,2.0))
    ProcessLists()
    Update()
    RegisterForModEvent("UD_PatchUpdate", "UpdateEvent")
    UpdateSuit()
    UDCDmain.InjectQuestKeywords(QuestKeywords)
    UDCDmain.InjectGenericKeys(UD_GenericKeys)
EndEvent

Function ProccesRandomDevices(Armor[] aaPatchList,FormList akTargetList)
    if !aaPatchList || !akTargetList
        return
    endif
    if aaPatchList.length
        Int i = aaPatchList.length
        while i
            i-=1
            akTargetList.addForm(aaPatchList[i])
        endwhile
    endif
EndFunction

Event UpdateEvent(string eventName, string strArg, float numArg, Form sender)
    if eventName == "UD_PatchUpdate"
        Update()
    elseif eventName == "UD_AbadonSuitUpdate"
        UpdateSuit()
    elseif eventName == "UD_QuestKeywordUpdate"
        UDCDmain.InjectQuestKeywords(QuestKeywords)
    elseif eventName == "UD_GenericKeyUpdate"
        UDCDmain.InjectGenericKeys(UD_GenericKeys)
    endif
EndEvent

Event EquipSuitEvent(Form kActor,String asEvent)
    EquipSuit(kActor as Actor,asEvent)
EndEvent

Function Update()
    ;validate patch
    Bool loc_Installed = CheckPatchInstalled()
    if loc_Installed
        RegisterForModEvent("UD_AbadonSuitUpdate","UpdateEvent")
        RegisterForModEvent("UD_QuestKeywordUpdate","UpdateEvent")
        RegisterForModEvent("UD_GenericKeyUpdate","UpdateEvent")
    else
        UnregisterForModEvent("UD_AbadonSuitUpdate")
        UnregisterForModEvent("UD_QuestKeywordUpdate")
        UnregisterForModEvent("UD_GenericKeyUpdate")
    endif
EndFunction

Bool Function CheckPatchInstalled()
    if UD_PatchSource != "error"
        if !ModInstalled(UD_PatchSource)
            WaitRandomTime(0.5,1.5)
            debug.messagebox("--!ERROR!--\nUD detected that patch "+ UD_PatchSource +" is not installed, but script is still present!")
            return False
        endif
        if !ModInstalledAfterUD(UD_PatchSource)
            WaitRandomTime(0.5,1.5)
            debug.messagebox("--!ERROR!--\nUD detected that patch "+ UD_PatchSource +" is loaded before main mod! Patch always needs to be loaded after main mod or it will not work!!! Please change the load order, and reload save.")
            return False
        endif
    endif
    return True
EndFunction

Function ProcessLists()
    UDCDmain.InjectQuestKeywords(QuestKeywords)
    UDCDmain.InjectGenericKeys(UD_GenericKeys)
EndFunction

Bool    _updateSuitMutex    = False
Function UpdateSuit()
    while _updateSuitMutex
        Utility.waitMenuMode(0.01)
    endwhile
    _updateSuitMutex = True
    
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
        UDmain.UDAbadonQuest.AddCustomAbadonSet(asEvent,asSuitName,UD_PatchName)
        RegisterForModEvent(asEvent, "EquipSuitEvent")
    endif
EndFunction

;OVERRIDE NEEDED

;/  Function: EquipSuit

    This function is called if actor is about to be locked in custom abadon suit.
    
    This function have to be overrided by extended script, and the event have to be filtered.

    Parameters:

        akActor         - Actor that will be locked in abadon suit
        asEventName     - Name of event, which is equivalent to UD_CustomAbadonSuitEvent_X on one of the patches
        
    _Example_:
        --- Code
        Scriptname MyCustomPatchScript extends UD_PatchInit

        UD_CustomAbadonSuitEvent_1  -> "MyCustomAbadonSuit1"
        UD_CustomAbadonSuitName_1   -> "My Custom Abadon Suit 1"
        
        UD_CustomAbadonSuitEvent_2  -> "MyCustomAbadonSuit2"
        UD_CustomAbadonSuitName_2   -> "My Custom Abadon Suit 2"

        Function EquipSuit(Actor akActor,String asEventName)
            Utility.wait(0.01) ;wait for menu to close
            UDmain.UDCDmain.DisableActor(akActor)
            if asEventName == "MyCustomAbadonSuit1"
                ;Lock some devices ...
                libs.LockDevice(akActor,...)
            elseif asEventName == "MyCustomAbadonSuit2"
                ;Lock some other devices ...
                libs.LockDevice(akActor,...)
            endif
            UDmain.UDCDmain.EnableActor(akActor)
        EndFunction
        ---
/;
Function EquipSuit(Actor akActor,String asEventName)
EndFunction