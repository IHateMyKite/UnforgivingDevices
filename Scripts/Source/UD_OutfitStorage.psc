Scriptname UD_OutfitStorage extends Quest

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty

Event OnInit()
    RegisterForSingleUpdate(10.0)
EndEvent

Event OnUpdate()
    UDmain.UDOTM.AddOutfitStorage(self)
EndEvent

Int Function GetOutfitNum()
    return self.GetNumAliases()
EndFunction

UD_Outfit Function GetNthOutfit(Int aiIndex)
    return self.GetNthAlias(aiIndex) as UD_Outfit
EndFunction