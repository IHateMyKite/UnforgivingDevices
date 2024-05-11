Scriptname UD_OutfitManager extends Quest

import UD_Native

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty

Form[] _OutfitStorages
int Function AddOutfitStorage(UD_OutfitStorage akStorage)
    if !akStorage
        return -1
    endif
    
    UDmain.Info("UD_OutfitManager::AddOutfitStorage() - Adding outfit storage -> " + akStorage.GetName())
    int loc_i = 0
    while loc_i < akStorage.GetOutfitNum()
        UD_Outfit loc_outfit = akStorage.GetNthOutfit(loc_i)
        UDmain.Info("\t\t-> Outfit["+loc_i+"] = " + loc_outfit.NameFull + "("+loc_outfit.NameAlias+")")
        loc_i += 1
    endwhile
    
    _OutfitStorages = PapyrusUtil.PushForm(_OutfitStorages,akStorage as Form)
    return _OutfitStorages.length
EndFunction


Bool Function LockAnyOutfit(Actor akActor)
    return LockOutfit(akActor,0)
EndFunction

Bool Function LockAbadonOutfit(Actor akActor)
    return LockOutfit(akActor,1)
EndFunction

; Type = 0 -> Any
; Type = 1 -> Abadon outfit (extends UD_OutfitAbadon)
Bool Function LockOutfit(Actor akActor, Int aiType)
    if !_OutfitStorages
        return false
    endif

    Alias[] loc_possibleoutfits
    
    int loc_storage_id = 0
    
    while loc_storage_id < _OutfitStorages.length
        UD_OutfitStorage loc_OutfitStorage = _OutfitStorages[loc_storage_id] as UD_OutfitStorage
        
        int loc_outfit_id = 0
        while loc_outfit_id < loc_OutfitStorage.GetOutfitNum()
            UD_Outfit loc_outfit = loc_OutfitStorage.GetNthOutfit(loc_outfit_id)
            if loc_outfit && ((aiType == 0) || (aiType == 1 && loc_outfit as UD_OutfitAbadon))
                if loc_outfit.Condition(akActor)
                    loc_possibleoutfits = PapyrusUtil.PushAlias(loc_possibleoutfits,loc_outfit)
                endif
            endif
            loc_outfit_id += 1
        endwhile
        
        loc_storage_id += 1
    endwhile
    
    if loc_possibleoutfits.length > 0
        UD_Outfit loc_selectedoutfit = loc_possibleoutfits[RandomInt(0,loc_possibleoutfits.length - 1)] as UD_Outfit
        if loc_selectedoutfit
            return loc_selectedoutfit.LockDevices(akActor)
        endif
    endif
    return false
EndFunction

Bool Function LockOutfitByAlias(Actor akActor, String asOutfit)
    int loc_storage_id = 0
    while loc_storage_id < _OutfitStorages.length
        UD_OutfitStorage loc_OutfitStorage = _OutfitStorages[loc_storage_id] as UD_OutfitStorage
        if loc_OutfitStorage
            UD_Outfit loc_outfit = loc_OutfitStorage.GetOutfitByAlias(asOutfit)
            
            if loc_outfit
                return loc_outfit.LockDevices(akActor)
            endif
        endif
        loc_storage_id += 1
    endwhile
EndFunction