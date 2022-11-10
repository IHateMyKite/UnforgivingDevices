Scriptname UD_RandomRestraintManager extends Quest  

import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain 
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction    
EndProperty
zadlibs Property libs auto

Formlist Property UD_RandomDeviceList_Collar auto             ;0
Formlist Property UD_RandomDeviceList_ArmCuffs auto         ;1
Formlist Property UD_RandomDeviceList_Belt auto             ;2
Formlist Property UD_RandomDeviceList_Blindfold auto        ;3

Formlist Property UD_RandomDeviceList_Bra auto                 ;4
Formlist Property UD_RandomDeviceList_Boots auto             ;5
Formlist Property UD_RandomDeviceList_Gag auto                 ;6
Formlist Property UD_RandomDeviceList_HeavyBondage auto     ;7

Formlist Property UD_RandomDeviceList_LegCuffs auto         ;8
FormList Property UD_RandomDeviceList_Suit auto                ;9
FormList Property UD_RandomDeviceList_PlugVaginal auto        ;10
FormList Property UD_RandomDeviceList_PlugAnal auto            ;11

FormList Property UD_RandomDeviceList_PiercingVag auto        ;12
FormList Property UD_RandomDeviceList_PiercingNipple auto    ;13
FormList Property UD_RandomDeviceList_Gloves auto             ;14
Formlist Property UD_RandomDeviceList_Hood auto                ;15

;unimplemented
Formlist Property UD_RandomDeviceList_HeavyBondageWeak auto
Formlist Property UD_RandomDeviceList_HeavyBondage_Suit auto
Formlist Property UD_RandomDeviceList_HeavyBondageHard auto
Formlist Property UD_AbadonDeviceList_HeavyBondageWeak auto
Formlist Property UD_AbadonDeviceList_HeavyBondage auto
Formlist Property UD_AbadonDeviceList_HeavyBondageHard auto


zadDeviceLists Property zadDL auto

int Property UD_RandomDevice_GlobalFilter = 0xFFFFFFFF auto


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

;DO NOT MODIFY

;0b = zad_DeviousCollar
;1b = zad_DeviousArmCuffs
;2b = zad_DeviousBelt
;3b = zad_DeviousBlindfold

;4b = zad_DeviousBra
;5b = zad_DeviousBoots
;6b = zad_DeviousGag
;7b = zad_DeviousHeavyBondage

;8b = zad_DeviousLegCuffs
;9b= zad_DeviousSuit
;10b= zad_DeviousPlugVaginal
;11b= zad_DeviousPlugAnal

;12b= zad_DeviousPiercingsVaginal
;13b= zad_DeviousPiercingsNipple
;14b= zad_DeviousGloves
;15b= zad_DeviousHood

;adding missed items
;16b= zad_DeviousCorset
;17b= zad_DeviousHarness

FormList Property UD_CheckKeywords auto
FormList Property SuitableKeywords auto

bool ready = false
Event onInit()

    UD_CheckKeywords.revert()

 ; rearrange keywords order to ensure better compatibility while locking up multiples, probably broke device filter here...

    UD_CheckKeywords.addForm(libs.zad_DeviousPiercingsVaginal)	;iIndex = 12,	new 0
    UD_CheckKeywords.addForm(libs.zad_DeviousPiercingsNipple)	;iIndex = 13,	new 1
    UD_CheckKeywords.addForm(libs.zad_DeviousPlugVaginal)		;iIndex = 10,	new 2
    UD_CheckKeywords.addForm(libs.zad_DeviousPlugAnal)			;iIndex = 11,	new 3

    UD_CheckKeywords.addForm(libs.zad_DeviousHeavyBondage)		;iIndex = 7,	new 4
    UD_CheckKeywords.addForm(libs.zad_deviousHarness)			;iIndex = 17,	new 5
    UD_CheckKeywords.addForm(libs.zad_DeviousCorset)            ;iIndex = 16,	new 6
    UD_CheckKeywords.addForm(libs.zad_deviousHood)				;iIndex = 15,	new 7

    UD_CheckKeywords.addForm(libs.zad_DeviousCollar)			;iIndex = 0,	new 8
    UD_CheckKeywords.addForm(libs.zad_DeviousArmCuffs)			;iIndex = 1,	new 9
    UD_CheckKeywords.addForm(libs.zad_DeviousBlindfold)			;iIndex = 3,	new 10
    UD_CheckKeywords.addForm(libs.zad_DeviousBoots)				;iIndex = 5,	new 11

    UD_CheckKeywords.addForm(libs.zad_DeviousGag)				;iIndex = 6,	new 12
    UD_CheckKeywords.addForm(libs.zad_DeviousLegCuffs)			;iIndex = 8,	new 13
    UD_CheckKeywords.addForm(libs.zad_DeviousSuit)				;iIndex = 9,	new 14
    UD_CheckKeywords.addForm(libs.zad_DeviousGloves)            ;iIndex = 14,	new 15

    UD_CheckKeywords.addForm(libs.zad_DeviousBra)				;iIndex = 4,	new 16
    UD_CheckKeywords.addForm(libs.zad_DeviousBelt)				;iIndex = 2,	new 17

    
    if UDmain.TraceAllowed()    
        UDCDmain.Log("-UDRRM initiated-")
    endif
    ready = True
EndEvent

Armor Function getRandomDeviceByKeyword(Actor akActor,Keyword kwKeyword)
    Armor res = none
    if kwKeyword == libs.zad_DeviousCollar 
        res = getRandomFormFromFormlist(UD_RandomDeviceList_Collar) as Armor
    elseif kwKeyword == libs.zad_DeviousArmCuffs
        res = getRandomFormFromFormlist(UD_RandomDeviceList_ArmCuffs) as Armor
    elseif kwKeyword == libs.zad_DeviousLegCuffs
        res = getRandomFormFromFormlist(UD_RandomDeviceList_LegCuffs) as Armor
    elseif kwKeyword == libs.zad_DeviousGag
        res = getRandomFormFromFormlist(UD_RandomDeviceList_Gag) as Armor
    elseif kwKeyword == libs.zad_DeviousBoots
        res = getRandomFormFromFormlist(UD_RandomDeviceList_Boots) as Armor
    elseif kwKeyword == libs.zad_DeviousBlindfold
        res = getRandomFormFromFormlist(UD_RandomDeviceList_Blindfold) as Armor
    elseif kwKeyword == libs.zad_DeviousBra
        res = getRandomFormFromFormlist(UD_RandomDeviceList_Bra) as Armor
    elseif kwKeyword == libs.zad_DeviousBelt
        res = getRandomFormFromFormlist(UD_RandomDeviceList_Belt) as Armor
    elseif kwKeyword == libs.zad_DeviousHeavyBondage
        if akActor.wornhaskeyword(libs.zad_DeviousSuit)
            res = getRandomFormFromFormlist(UD_RandomDeviceList_HeavyBondage) as Armor
        else
            if Utility.randomInt(0,1)
                res = getRandomFormFromFormlist(UD_RandomDeviceList_HeavyBondage) as Armor
            else
                res = getRandomFormFromFormlist(UD_RandomDeviceList_HeavyBondage_Suit) as Armor
            endif
        endif
    elseif kwKeyword == libs.zad_DeviousSuit
        if !akActor.wornhaskeyword(libs.zad_DeviousSuit)
            res = getRandomFormFromFormlist(UD_RandomDeviceList_Suit) as Armor
        endif
    elseif kwKeyword == libs.zad_DeviousPlugVaginal
        res = getRandomFormFromFormlist(UD_RandomDeviceList_PlugVaginal) as Armor
    elseif kwKeyword == libs.zad_DeviousPlugAnal
        res = getRandomFormFromFormlist(UD_RandomDeviceList_PlugAnal) as Armor
    elseif kwKeyword == libs.zad_DeviousPiercingsVaginal
        res = getRandomFormFromFormlist(UD_RandomDeviceList_PiercingVag) as Armor
    elseif kwKeyword == libs.zad_DeviousPiercingsNipple
        res = getRandomFormFromFormlist(UD_RandomDeviceList_PiercingNipple) as Armor
    elseif kwKeyword == libs.zad_DeviousGloves
        res = getRandomFormFromFormlist(UD_RandomDeviceList_Gloves) as Armor
    elseif kwKeyword == libs.zad_DeviousHood
        res = getRandomFormFromFormlist(UD_RandomDeviceList_Hood) as Armor
    endif
    return res
EndFunction

Armor Function getRandomDeviceByKeyword_LL(Actor akActor,Keyword kwKeyword)
	LeveledItem LL = none
    Armor res = none
    if kwKeyword == libs.zad_DeviousCollar 
        LL = zadDL.zad_dev_collars
    elseif kwKeyword == libs.zad_DeviousArmCuffs
        LL = zadDL.zad_dev_armcuffs
    elseif kwKeyword == libs.zad_DeviousLegCuffs
        LL = zadDL.zad_dev_legcuffs
    elseif kwKeyword == libs.zad_DeviousGag
        LL = zadDL.zad_dev_gags
    elseif kwKeyword == libs.zad_DeviousBoots
        LL = zadDL.zad_dev_boots
    elseif kwKeyword == libs.zad_DeviousBlindfold
        LL = zadDL.zad_dev_blindfolds
    elseif kwKeyword == libs.zad_DeviousBra
        LL = zadDL.zad_dev_chastitybras
    elseif kwKeyword == libs.zad_DeviousBelt
        LL = zadDL.zad_dev_chastitybelts
    elseif kwKeyword == libs.zad_DeviousHeavyBondage
        if akActor.wornhaskeyword(libs.zad_DeviousSuit)
            LL = zadDL.zad_dev_heavyrestraints
        else
            if Utility.randomInt(0,1)
                LL = zadDL.zad_dev_suits_straitjackets
            else
                LL = zadDL.zad_dev_heavyrestraints
            endif
        endif
    elseif kwKeyword == libs.zad_DeviousSuit
        if !akActor.wornhaskeyword(libs.zad_DeviousHeavyBondage)
            LL = zadDL.zad_dev_suits									; can use any suit, including straitjacket
        else
            int rnd_suit = Utility.randomInt(0,4)						; can solve this by adding leveled list without SJs...
			if rnd_suit == 0											; but this should be good enough
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
    elseif kwKeyword == libs.zad_DeviousPlugVaginal
        LL = zadDL.zad_dev_plugs_vaginal
    elseif kwKeyword == libs.zad_DeviousPlugAnal
        LL = zadDL.zad_dev_plugs_anal
    elseif kwKeyword == libs.zad_DeviousPiercingsVaginal
        LL = zadDL.zad_dev_piercings_vaginal
    elseif kwKeyword == libs.zad_DeviousPiercingsNipple
        LL = zadDL.zad_dev_piercings_nipple
    elseif kwKeyword == libs.zad_DeviousGloves
        LL = zadDL.zad_dev_gloves
    elseif kwKeyword == libs.zad_DeviousHood
        LL = zadDL.zad_dev_hoods
    elseif kwKeyword == libs.zad_DeviousCorset
        LL = zadDL.zad_dev_corsets
    elseif kwKeyword == libs.zad_DeviousHarness
        LL = zadDL.zad_dev_harnesses
    endif

	if LL
		int tries = 10						; 10 attempts
		while tries > 0			
	    	res = zadDL.GetRandomDevice(LL)
			if ConflictNone(akActor,res)	; if no coflict - good to go, return device
		    	return res
			endif
			tries -= 1						; else we go and try to get another device
			Utility.wait(0.1)	 			; small delay to ensure better random
		endwhile
	else
		return none
	endif
EndFunction

;PC frier 8000
Armor Function getRandomSuitableRestrain(Actor akActor,Int iPrefSwitch = 0xffffffff)
    if UDmain.TraceAllowed()    
        UDCDmain.Log("getRandomSuitableRestrain called for " + GetActorName(akActor),3)
    endif
    iPrefSwitch = Math.LogicalAnd(iPrefSwitch,UD_RandomDevice_GlobalFilter)
    Armor res = none
    Keyword selected_keyword = getRandomSuitableKeyword(akActor,iPrefSwitch)
    if !selected_keyword
        return none
    endif
    return getRandomDeviceByKeyword_LL(akActor,selected_keyword)
EndFunction

bool Function LockAnyRandomRestrain(Actor akActor,int iNumber = 1,bool bForce = false)
    if iNumber < 1
        iNumber = 1
    endif

    bool loc_res = false
    
    while iNumber
        iNumber -= 1
        loc_res = loc_res || LockRandomRestrain(akActor)
		Utility.wait(3)	 ; small delay to ensure of no equips running into one another
    endwhile
    
    return loc_res
EndFunction

Armor Function LockRandomRestrain(Actor akActor,Bool force = false,Int iPrefSwitch = 0xffffffff)
    if UDmain.TraceAllowed()    
        UDCDmain.Log("LockRandomRestrain called for " + GetActorName(akActor))
    endif
    iPrefSwitch = Math.LogicalAnd(iPrefSwitch,UD_RandomDevice_GlobalFilter)
    Armor device = none
    Keyword selected_keyword = getRandomSuitableKeyword(akActor,iPrefSwitch)
    if !selected_keyword
        UDCDmain.Log("No suitable keyword found. Skipping!")
        return none
    endif
    if UDmain.TraceAllowed()    
        UDCDmain.Log("Selected keyword: " + selected_keyword)
    endif
    device = getRandomDeviceByKeyword_LL(akActor, selected_keyword);switch to LL is here
    if device
        if UDmain.TraceAllowed()        
            UDCDmain.Log("Selected device: " + device.getName())
        endif
        
        if libs.lockdevice(akActor,device,force)
            return device
        else
            return none
        endif
    else
        return none
    endif
    return none
EndFunction

int Function LockAllSuitableRestrains(Actor akActor,Bool force = false,Int iPrefSwitch = 0xffffffff)
    if UDmain.TraceAllowed()    
        UDCDmain.Log("LockAllSuitableRestrains called for " + akActor.getActorBase().getName(),2)
    endif
    iPrefSwitch = Math.LogicalAnd(iPrefSwitch,UD_RandomDevice_GlobalFilter)
    Form[] loc_keywords = getAllSuitableKeywords(akActor,iPrefSwitch)
    if !loc_keywords
        if UDmain.TraceAllowed()        
            UDCDmain.Log("No suitable keyword found. Skipping!")
        endif
        return 0
    endif
    if UDmain.TraceAllowed()    
        UDCDmain.Log("Selected keyword: " + loc_keywords,2)
    endif
    
    Armor device = none
    int loc_i = 0
    int loc_res = 0
    while loc_i < loc_keywords.length
        device = getRandomDeviceByKeyword_LL(akActor,loc_keywords[loc_i] as Keyword)
        if device
            if UDmain.TraceAllowed()            
                UDCDmain.Log("Selected device: " + device.getName(),2)
            endif
            if libs.lockdevice(akActor,device,force)
                loc_res += 1
            endif
        endif
        loc_i += 1
		Utility.wait(3)	 ; small delay to ensure of no equips running into one another
    endwhile
    return loc_res
EndFunction


bool Function lockRandomDeviceFromFormList(Actor akActor,Formlist list,bool force = False)
    Armor device = getRandomFormFromFormlist(list) as Armor
    if device
        libs.lockdevice(akActor,device,force)
        return True
    else
        return False
    endif
EndFunction

Form Function getRandomFormFromFormlist(Formlist list)
    int iter = Utility.randomInt(0,list.GetSize() - 1)
    return list.getAt(iter)
EndFunction

Armor Function getRandomFormFromLeveledlist(LeveledItem argList) ;this function is redundant, easier to use zadDL.GetRandomDevice
    if !argList ;wrong leveledlist, exit
        UDCDmain.Error("getRandomFormFromLeveledlist(), argList = none!")
        return none
    endif
    LeveledItem loc_list = argList
    while True
        if UDmain.TraceAllowed()
            UDCDmain.Log("getRandomFormFromLeveledlist(), Proccesing " + loc_list)
        endif
        int loc_size = loc_list.GetNumForms()
        if loc_size > 0
            int loc_iter = Utility.randomInt(0,loc_size - 1)
            Form loc_selectedForm = loc_list.GetNthForm(loc_iter)
            if loc_selectedForm as Armor
                return loc_selectedForm as Armor
            elseif loc_selectedForm as LeveledItem
                loc_list = loc_selectedForm as LeveledItem
            else
                ;wrong form found, exit
                return none
            endif
        else
            return none ;empty leveledlist, exit
        endif
    endwhile
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
    iPrefSwitch = Math.LogicalAnd(iPrefSwitch,UD_RandomDevice_GlobalFilter)
    while i < UD_CheckKeywords.getSize()
        if !akActor.wornhaskeyword(UD_CheckKeywords.getAt(i) as Keyword) && additionCheck(akActor,i) && Math.LogicalAnd(iPrefSwitch,Math.LeftShift(0x01,i))
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
    iPrefSwitch = Math.LogicalAnd(iPrefSwitch,UD_RandomDevice_GlobalFilter)
    while i < UD_CheckKeywords.getSize()
        if !akActor.wornhaskeyword(UD_CheckKeywords.getAt(i) as Keyword) && additionCheck(akActor,i) && Math.LogicalAnd(iPrefSwitch,Math.LeftShift(0x01,i))
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

bool Function additionCheck(Actor akActor,int iIndex)
;    if iIndex == 10    ;needed check for suit, checks if actor have straitjacket
;        return !akActor.wornhaskeyword(libs.zad_DeviousStraitjacket)
    if iIndex == 7
        return UDCDmain.UDmain.ItemManager.UD_useHoods
    elseif iIndex == 6    ;needed check for corset, checks if actor has harness
        return !akActor.wornhaskeyword(libs.zad_DeviousHarness)
    elseif iIndex == 5    ;needed check for harness, checks if actor have corset
        return !akActor.wornhaskeyword(libs.zad_DeviousCorset)
    endif
    return true
EndFunction

bool Function ConflictNone(Actor akActor,Armor to_check)										; returns true if no conflicts present
	Keyword checking_kw
    Armor rend_to_check  = libs.GetRenderedDevice(to_check) 									; getting rendered device 
	int iCheck = 0 
	int kw_size = UD_CheckKeywords.getSize()
    while iCheck < (kw_size) 																		; go through all keywords one by one
		checking_kw = UD_CheckKeywords.getAt(iCheck) as Keyword
		if (rend_to_check.haskeyword(checking_kw) && akActor.wornhaskeyword(checking_kw))		; and see if the current keyword both present on rendered device and worn by actor
            return false																		; in such situation no need to continue check, abort and return false
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
	return true																					; no conflicts found, good to go!
EndFunction
