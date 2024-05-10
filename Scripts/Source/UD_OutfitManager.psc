Scriptname UD_OutfitManager extends Quest

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
    
    UDmain.Info("Adding outfit storage -> " + akStorage.GetName())
    
    _OutfitStorages = PapyrusUtil.PushForm(_OutfitStorages,akStorage as Form)
    return _OutfitStorages.length
EndFunction

