;/  File: UD_RandomRestraintManager
    Contains functionality for getting random devices from Leveled Lists or Form Lists
/;
Scriptname UD_RandomRestraintManager extends Quest  

import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain 
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction    
EndProperty
zadlibs Property libs auto

;/  Group: Abadon Form Lists
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: UD_AbadonDeviceList_HeavyBondageWeak

    Form List filled with all weak abadon devices
/;
Formlist Property UD_AbadonDeviceList_HeavyBondageWeak auto

;/  Variable: UD_AbadonDeviceList_HeavyBondage

    Form List filled with all normal abadon devices
/;
Formlist Property UD_AbadonDeviceList_HeavyBondage auto

;/  Variable: UD_AbadonDeviceList_HeavyBondageHard

    Form List filled with all hard abadon devices
/;
Formlist Property UD_AbadonDeviceList_HeavyBondageHard auto

zadDeviceLists Property zadDL auto

Function StartMutex()
    while _mutex
        Utility.waitMenuMode(0.15)
    endwhile
    _mutex = true
EndFunction

Function EndMutex()
    _mutex = false
EndFunction

bool _mutex = false


FormList Property UD_CheckKeywords auto
FormList Property SuitableKeywords auto

bool ready = false

Event onInit()
    if IsRunning()
        ready = True
        RegisterForSingleupdate(15.0)
    endif
EndEvent

Event OnUpdate()
    if UDmain.UDReady()
        FillOutCheckKeywords()
    else
        RegisterForSingleupdate(30.0)
    endif
EndEvent

Function Update()
    FillOutCheckKeywords()
    if UDmain.TraceAllowed()
        UDmain.Log("Refilled Keywords formlist")
    endif
EndFunction

;/  Group: Random Functions
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function FillOutCheckKeywords()
    UD_CheckKeywords.revert()

    UD_CheckKeywords.addForm(libs.zad_DeviousPiercingsVaginal)   ;iIndex = 0
    UD_CheckKeywords.addForm(libs.zad_DeviousPiercingsNipple)    ;iIndex = 1
    UD_CheckKeywords.addForm(libs.zad_DeviousPlugVaginal)        ;iIndex = 2
    UD_CheckKeywords.addForm(libs.zad_DeviousPlugAnal)           ;iIndex = 3

    UD_CheckKeywords.addForm(libs.zad_DeviousHeavyBondage)       ;iIndex = 4
    UD_CheckKeywords.addForm(libs.zad_deviousHarness)            ;iIndex = 5
    UD_CheckKeywords.addForm(libs.zad_DeviousCorset)             ;iIndex = 6
    UD_CheckKeywords.addForm(libs.zad_deviousHood)               ;iIndex = 7

    UD_CheckKeywords.addForm(libs.zad_DeviousCollar)             ;iIndex = 8
    UD_CheckKeywords.addForm(libs.zad_DeviousGag)                ;iIndex = 9
    UD_CheckKeywords.addForm(libs.zad_DeviousBlindfold)          ;iIndex = 10
    UD_CheckKeywords.addForm(libs.zad_DeviousBoots)              ;iIndex = 11

    UD_CheckKeywords.addForm(libs.zad_DeviousArmCuffs)           ;iIndex = 12
    UD_CheckKeywords.addForm(libs.zad_DeviousLegCuffs)           ;iIndex = 13
    UD_CheckKeywords.addForm(libs.zad_DeviousSuit)               ;iIndex = 14
    UD_CheckKeywords.addForm(libs.zad_DeviousGloves)             ;iIndex = 15

    UD_CheckKeywords.addForm(libs.zad_DeviousBra)                ;iIndex = 16
    UD_CheckKeywords.addForm(libs.zad_DeviousBelt)               ;iIndex = 17
EndFunction

;/  Function: IsDeviceFiltered
    Parameters:
        aiIndex     - Index of device type
    --- Code
    |==================================|
    |  aiIndex  |    Device type       |
    |==================================|
    |    00     =     PiercingsVaginal |
    |    01     =     PiercingsNipple  |
    |    02     =     PlugVaginal      |
    |    03     =     PlugAnal         |
    |    04     =     HeavyBondage     |
    |    05     =     Harness          |
    |    06     =     Corset           |
    |    07     =     Hood             |
    |    08     =     Collar           |
    |    09     =     Gag              |
    |    10     =     Blindfold        |
    |    11     =     Boots            |
    |    12     =     ArmCuffs         |
    |    13     =     LegCuffs         |
    |    14     =     Suit             |
    |    15     =     Gloves           |
    |    16     =     Bra              |
    |    17     =     Belt             |
    |==================================|
    ---
    
    Returns:
    
        True if device is filtered
/;
Bool Function IsDeviceFiltered(Int aiIndex)
    return Math.LogicalAnd(UDmain.UDCONF.UD_RandomDevice_GlobalFilter,Math.LeftShift(0x01,aiIndex))
EndFunction

;/  Function: getRandomDeviceByKeyword_LL

    Parameters:

        akActor     - Actor to check random on. Device will not be locked on, but this function will return none if actor already have device with akKeyword
        akKeyword   - Keyword which will random device have
        
    Returns:
    
        Random device with *akKeyword*, or *none* in case of error
/;
Armor Function getRandomDeviceByKeyword_LL(Actor akActor,Keyword akKeyword)
    LeveledItem LL = none
    Armor res = none
    if akActor.wornhaskeyword(akKeyword)            ; excessive check, useful when a lot of additions happening and script load is heavy
        return none
    elseif akKeyword == libs.zad_DeviousCollar 
        LL = zadDL.zad_dev_collars
    elseif akKeyword == libs.zad_DeviousArmCuffs
        LL = zadDL.zad_dev_armcuffs
    elseif akKeyword == libs.zad_DeviousLegCuffs
        LL = zadDL.zad_dev_legcuffs
    elseif akKeyword == libs.zad_DeviousGag
        LL = zadDL.zad_dev_gags
    elseif akKeyword == libs.zad_DeviousBoots
        LL = zadDL.zad_dev_boots
    elseif akKeyword == libs.zad_DeviousBlindfold
        LL = zadDL.zad_dev_blindfolds
    elseif akKeyword == libs.zad_DeviousBra
        LL = zadDL.zad_dev_chastitybras
    elseif akKeyword == libs.zad_DeviousBelt
        LL = zadDL.zad_dev_chastitybelts
    elseif akKeyword == libs.zad_DeviousHeavyBondage
        if akActor.wornhaskeyword(libs.zad_DeviousSuit)
            LL = zadDL.zad_dev_heavyrestraints
        else
            if Utility.randomInt(0,1)
                LL = zadDL.zad_dev_suits_straitjackets
            else
                LL = zadDL.zad_dev_heavyrestraints
            endif
        endif
    elseif akKeyword == libs.zad_DeviousSuit
        if !akActor.wornhaskeyword(libs.zad_DeviousHeavyBondage)
            LL = zadDL.zad_dev_suits                                ; can use any suit, including straitjackets
        else
            int rnd_suit = Utility.randomInt(0,4)                   ; can solve this by adding leveled list without SJs...
            if rnd_suit == 0                                        ; but this should be good enough
                LL = zadDL.zad_dev_suits_catsuits
            elseif rnd_suit == 1
                LL = zadDL.zad_dev_suits_hobbledresses
            elseif rnd_suit == 2
                LL = zadDL.zad_dev_suits_relaxed_hobbledresses
            elseif rnd_suit == 3
                LL = zadDL.zad_dev_suits_hobbledresses
            elseif rnd_suit == 4
                LL = zadDL.zad_dev_suits_formaldresses
            endif
        endif
    elseif akKeyword == libs.zad_DeviousPlugVaginal
        LL = zadDL.zad_dev_plugs_vaginal
    elseif akKeyword == libs.zad_DeviousPlugAnal
        LL = zadDL.zad_dev_plugs_anal
    elseif akKeyword == libs.zad_DeviousPiercingsVaginal
        LL = zadDL.zad_dev_piercings_vaginal
    elseif akKeyword == libs.zad_DeviousPiercingsNipple
        LL = zadDL.zad_dev_piercings_nipple
    elseif akKeyword == libs.zad_DeviousGloves
        LL = zadDL.zad_dev_gloves
    elseif akKeyword == libs.zad_DeviousHood
        LL = zadDL.zad_dev_hoods
    elseif akKeyword == libs.zad_DeviousCorset && !akActor.wornhaskeyword(libs.zad_DeviousHarness)
        LL = zadDL.zad_dev_corsets
    elseif akKeyword == libs.zad_DeviousHarness && !akActor.wornhaskeyword(libs.zad_DeviousCorset)
        LL = zadDL.zad_dev_harnesses
    else
        return none
    endif

    if LL
        int tries = 10                        ; 10 attempts
        while tries > 0            
            res = GetRandomDevice(LL)
            if res
                if ConflictNone(akActor,res)      ; if no conflict - good to go, return device
                    return res
                endif
                tries -= 1                        ; else we go and try to get another device
                Utility.wait(0.1)                 ; small delay to ensure better random
            else
                return none
            endif
        endwhile
        return none                           ; if we reached this point - all devices were in conflict, return none
    else
        return none
    endif
EndFunction

;fixed function from zadDeviceList
;Original function can break the game if recursive LeveledList is empty
;BEcause there is no Wait, this will drain most computere resources just for nothing, making the game almost non playable
Int     Property    UD_MaxStepBacksLeveledItem = 6 auto
Armor Function GetRandomDevice(LeveledItem akDeviceList)
    Form loc_form                   = none
    Form loc_startLeveledList       = akDeviceList

    Int loc_size = akDeviceList.GetNumForms() - 1
    If loc_size < 0
        return none
    EndIf

    Form loc_prevForm               = akDeviceList

    loc_form = akDeviceList.GetNthForm(Utility.RandomInt(0, loc_size))
    LeveledItem loc_nestedLL        = loc_form As LeveledItem
    Armor       loc_armor           = loc_form As Armor
    Int         loc_stepsBacks      = UD_MaxStepBacksLeveledItem
    While (!loc_armor && loc_nestedLL) ;check if form is not armor, and is LL, otherwise do nothing
        ;it's not an armor, but a nested LeveledItem list
        loc_size = loc_nestedLL.GetNumForms() - 1
        if loc_size > 0
            loc_prevForm = loc_form
            loc_form = loc_nestedLL.GetNthForm(Utility.RandomInt(0, loc_size))
            Utility.waitMenuMode(0.01) ;little wait time in case of error
        else
            ;empty LeveledList entered, do step back
            if loc_stepsBacks
                GWarning("Empty LeveledList entered = "+ loc_form +". Stepping back in to "+ loc_prevForm +" and finding other random device")
                loc_stepsBacks -= 1
                loc_form = loc_prevForm
            else
                ;no more chances, return none
                GError("No correct device found in LeveledList "+loc_startLeveledList+". Returning none")
                return none
            endif
        endif
        loc_nestedLL    = loc_form As LeveledItem
        loc_armor       = loc_form As Armor
    EndWhile
    
    Return loc_form as Armor
EndFunction

;PC frier 8000

;/  Function: getRandomSuitableRestrain

    Parameters:

        akActor         - Actor to check random device on
        aiPrefSwitch    - Filter for setting which devices can be choosen. This value gets ANDed with <UD_RandomDevice_GlobalFilter>. See <UD_RandomDevice_GlobalFilter> for more info
        
    Returns:
    
        Random device based on *aiPrefSwitch*
/;
Armor Function getRandomSuitableRestrain(Actor akActor,Int aiPrefSwitch = 0xffffffff)
    if UDmain.TraceAllowed()
        UDmain.Log("getRandomSuitableRestrain called for " + GetActorName(akActor),3)
    endif
    aiPrefSwitch = Math.LogicalAnd(aiPrefSwitch,UDmain.UDCONF.UD_RandomDevice_GlobalFilter)
    Armor res = none
    Keyword selected_keyword = getRandomSuitableKeyword(akActor,aiPrefSwitch)
    if !selected_keyword
        return none
    endif
    return getRandomDeviceByKeyword_LL(akActor,selected_keyword)
EndFunction

;/  Function: LockAnyRandomRestrain

    Choose any random suitable device and locks it on actor. Is still affected by <UD_RandomDevice_GlobalFilter>

    Parameters:

        akActor     - Actor to lock device on
        aiNumber    - Number of random devices to lock on
        abForce     - If device should be force locked
        
    Returns:
    
        True if at least one device was locked on
/;
bool Function LockAnyRandomRestrain(Actor akActor,int aiNumber = 1,bool abForce = false)
    if aiNumber < 1
        aiNumber = 1
    endif

    bool loc_res = false
    
    while aiNumber
        aiNumber -= 1
        loc_res = LockRandomRestrain(akActor,abForce) || loc_res
    endwhile
    
    return loc_res
EndFunction

;/  Function: LockRandomRestrain

    Locks exactly one random device

    Parameters:

        akActor         - Actor to lock device on
        abForce         - If device should be force locked
        aiPrefSwitch    - Filter to specify which exact devices can be locked on. See <UDmain.UDCONF.UD_RandomDevice_GlobalFilter> for more info
        
    Returns:
    
        Inventory device of device that is locked on, or *none* in case of error
        
    See:
    
        <LockAllSuitableRestrains>, <LockAnyRandomRestrain>
/;
Armor Function LockRandomRestrain(Actor akActor,Bool abForce = false,Int aiPrefSwitch = 0xffffffff)
    if UDmain.TraceAllowed()    
        UDmain.Log("LockRandomRestrain called for " + GetActorName(akActor))
    endif
    
                aiPrefSwitch            = Math.LogicalAnd(aiPrefSwitch,UDmain.UDCONF.UD_RandomDevice_GlobalFilter)
    Armor       loc_device              = none
    Keyword     loc_selected_keyword    = getRandomSuitableKeyword(akActor,aiPrefSwitch)
    
    if !loc_selected_keyword
        UDmain.Log("No suitable keyword found. Skipping!")
        return none
    endif
    
    if UDmain.TraceAllowed()
        UDmain.Log("Selected keyword: " + loc_selected_keyword)
    endif
    
    loc_device = getRandomDeviceByKeyword_LL(akActor, loc_selected_keyword);switch to LL is here
    
    if loc_device
        if UDmain.TraceAllowed()
            UDmain.Log("Selected device: " + loc_device.getName())
        endif
        
        if libs.lockdevice(akActor,loc_device,abForce)
            return loc_device
        else
            return none
        endif
    else
        return none
    endif
    
    return none
EndFunction

;/  Function: LockAllSuitableRestrains

    Locks all suitable random devices.

    Parameters:

        akActor         - Actor to lock devices on
        abForce         - If device should be force locked
        aiPrefSwitch    - Filter to specify which exact devices can be locked on. See <UDmain.UDCONF.UD_RandomDevice_GlobalFilter> for more info
        
    Returns:
    
        How many devices were locked on
        
    See:
    
        <LockRandomRestrain>, <LockAnyRandomRestrain>
/;
int Function LockAllSuitableRestrains(Actor akActor,Bool abForce = false,Int aiPrefSwitch = 0xffffffff)
    if !akActor
        UDmain.Error(self + "::LockAllSuitableRestrains() - Passed akActor is none!")
        return 0
    endif

    if UDmain.TraceAllowed()    
        UDmain.Log("LockAllSuitableRestrains called for " + GetActorName(akActor),2)
    endif
            aiPrefSwitch    = Math.LogicalAnd(aiPrefSwitch,UDmain.UDCONF.UD_RandomDevice_GlobalFilter)
    Form[]  loc_keywords    = getAllSuitableKeywords(akActor,aiPrefSwitch)
    
    if !loc_keywords
        if UDmain.TraceAllowed()
            UDmain.Log("No suitable keyword found. Skipping!")
        endif
        return 0
    endif
    if UDmain.TraceAllowed()    
        UDmain.Log("Selected keyword: " + loc_keywords,2)
    endif
    
    Armor   loc_device  = none
    int     loc_i       = 0
    int     loc_res     = 0
    while loc_i < loc_keywords.length
        loc_device = getRandomDeviceByKeyword_LL(akActor,loc_keywords[loc_i] as Keyword)
        if loc_device
            if UDmain.TraceAllowed()            
                UDmain.Log("Selected device: " + loc_device.getName(),2)
            endif
            if libs.lockdevice(akActor,loc_device,abForce)
                loc_res += 1
            endif
        endif
        loc_i += 1
    endwhile
    return loc_res
EndFunction

;/  Function: lockRandomDeviceFromFormList

    Locks random device from passed formlist

    Parameters:

        akActor         - Actor to lock devices on
        akList          - Form list from which will be device choosen
        abForce         - If device should be force locked
        
    Returns:
    
        True if device was locked on
/;
bool Function lockRandomDeviceFromFormList(Actor akActor,Formlist akList,bool abForce = False)
    Armor loc_device = getRandomFormFromFormlist(akList) as Armor
    if loc_device
        libs.lockdevice(akActor,loc_device,abForce)
        return True
    else
        return False
    endif
EndFunction

Form Function getRandomFormFromFormlist(Formlist akList)
    int loc_i = Utility.randomInt(0,akList.GetSize() - 1)
    return akList.getAt(loc_i)
EndFunction

;VEEEEEEEEEEEEEEEEEEEEEEEEEEEEERY SLOW
Form Function getRandomFormFromFormlistFilter(Formlist list,Keyword[] kwaFilter,int iMode = 0)
    int loc_listSize = list.GetSize()
    
    int loc_filteredDevice = 0
    
    Form[] loc_deviceArray; = CreateFormArray(, Form fill = None)
    
    while loc_listSize
        loc_listSize -= 1
        if iMode == 0
            if AndFilterForm(list.getAt(loc_listSize),kwaFilter)
                loc_filteredDevice += 1
                loc_deviceArray = PapyrusUtil.PushForm(loc_deviceArray,list.getAt(loc_listSize))
            endif
        elseif iMode == 1
            if OrFilterForm(list.getAt(loc_listSize),kwaFilter)
                loc_filteredDevice += 1
                loc_deviceArray = PapyrusUtil.PushForm(loc_deviceArray,list.getAt(loc_listSize))
            endif
        elseif iMode == 2
            if NorFilterForm(list.getAt(loc_listSize),kwaFilter)
                loc_filteredDevice += 1
                loc_deviceArray = PapyrusUtil.PushForm(loc_deviceArray,list.getAt(loc_listSize))
            endif
        endif
    endwhile
    
    if loc_filteredDevice > 0
        int iter = Utility.randomInt(0,loc_deviceArray.length - 1)
        return loc_deviceArray[iter]
    else
        return none
    endif
EndFunction

Bool Function AndFilterForm(Form fForm,Keyword[] kwaFilter)
    int loc_i = kwaFilter.length
    bool loc_res = false
    zadequipscript loc_script = (UDCDmain.TransfereContainer_ObjRef.placeatme(fForm as Armor,1) as zadequipscript)
    while loc_i
        loc_i -= 1
        if loc_script.deviceRendered.hasKeyword(kwaFilter[loc_i])
            loc_res = true
        else
            loc_res = false
            loc_script.delete()
            return loc_res
        endif
    endwhile
    loc_script.delete()
    return loc_res
EndFunction

Bool Function OrFilterForm(Form fForm,Keyword[] kwaFilter)
    int loc_i = kwaFilter.length
    zadequipscript loc_script = (UDCDmain.TransfereContainer_ObjRef.placeatme(fForm as Armor,1) as zadequipscript)
    while loc_i
        loc_i -= 1
        if loc_script.deviceRendered.hasKeyword(kwaFilter[loc_i])
            loc_script.delete()
            return true
        endif
    endwhile
    loc_script.delete()
    return false
EndFunction

Bool Function NorFilterForm(Form fForm,Keyword[] kwaFilter)
    int loc_i = kwaFilter.length
    zadequipscript loc_script = (UDCDmain.TransfereContainer_ObjRef.placeatme(fForm as Armor,1) as zadequipscript)
    while loc_i
        loc_i -= 1
        if loc_script.deviceRendered.hasKeyword(kwaFilter[loc_i])
            loc_script.delete()
            return false
        endif
    endwhile
    loc_script.delete()
    return true
EndFunction

Keyword Function getRandomSuitableKeyword(Actor akActor,int iPrefSwitch = 0xffffffff)
    StartMutex()
    int i = 0
    SuitableKeywords.Revert()
    iPrefSwitch = Math.LogicalAnd(iPrefSwitch,UDmain.UDCONF.UD_RandomDevice_GlobalFilter)
    while i < UD_CheckKeywords.getSize()
        if !akActor.wornhaskeyword(UD_CheckKeywords.getAt(i) as Keyword) && _additionCheck(akActor,i) && Math.LogicalAnd(iPrefSwitch,Math.LeftShift(0x01,i))
            SuitableKeywords.AddForm(UD_CheckKeywords.getAt(i))
        endif
        i += 1
    endwhile
    Keyword loc_res = none
    if SuitableKeywords.getSize() > 0
        loc_res = SuitableKeywords.getAt(Utility.randomInt(0,SuitableKeywords.getSize() - 1)) as Keyword
    else
        loc_res = none
    endif
    EndMutex()
    return loc_res
EndFunction

Form[] Function getAllSuitableKeywords(Actor akActor,int iPrefSwitch = 0xffffffff)
    StartMutex()
    int i = 0
    SuitableKeywords.Revert()
    iPrefSwitch = Math.LogicalAnd(iPrefSwitch,UDmain.UDCONF.UD_RandomDevice_GlobalFilter)
        
    while i < UD_CheckKeywords.getSize()
        if !akActor.wornhaskeyword(UD_CheckKeywords.getAt(i) as Keyword) && _additionCheck(akActor,i) && Math.LogicalAnd(iPrefSwitch,Math.LeftShift(0x01,i))
            SuitableKeywords.AddForm(UD_CheckKeywords.getAt(i))
        endif
        i += 1
    endwhile
    Form[] loc_res
    if SuitableKeywords.getSize() > 0
        i = 0 
        while i < SuitableKeywords.getSize()
            loc_res = PapyrusUtil.PushForm(loc_res,SuitableKeywords.getAt(i))
            i+=1
        endwhile
    endif
    EndMutex()
    return loc_res
EndFunction

bool Function _additionCheck(Actor akActor,int iIndex)
    if iIndex == 14    ;needed check for suit, checks if actor have straitjacket
        return !akActor.wornhaskeyword(libs.zad_DeviousStraitjacket)
    elseif iIndex == 7
        return IsDeviceFiltered(7)
    elseif iIndex == 6    ;needed check for corset, checks if actor has harness
        return !akActor.wornhaskeyword(libs.zad_DeviousHarness)
    elseif iIndex == 5    ;needed check for harness, checks if actor have corset
        return !akActor.wornhaskeyword(libs.zad_DeviousCorset)
    endif
    return true
EndFunction

bool Function ConflictNone(Actor akActor,Armor to_check)                                        ; returns true if no conflicts present
    Keyword checking_kw
    Armor rend_to_check  = libs.GetRenderedDevice(to_check)                                     ; getting rendered device 
    int i = 0 
    int kw_size = UD_CheckKeywords.getSize()
    while i < (kw_size)                                                                         ; go through all keywords one by one
        checking_kw = UD_CheckKeywords.getAt(i) as Keyword
        if (rend_to_check.haskeyword(checking_kw) && akActor.wornhaskeyword(checking_kw))        ; and see if the current keyword both present on rendered device and worn by actor
            return false                                                                        ; in such situation no need to continue check, abort and return false
        endif                                                                               
        if i == 6                                                                               ; again cross-checking harness and corset keywords, just to be safe...
            if rend_to_check.haskeyword(checking_kw) && akActor.wornhaskeyword(libs.zad_DeviousHarness)  
                return false
            endif
        elseif i == 5 
            if rend_to_check.haskeyword(checking_kw) && akActor.wornhaskeyword(libs.zad_DeviousCorset)
                return false
            endif
        endif
        i += 1
    endwhile
    return true                                                                                    ; no conflicts found, good to go!
EndFunction
