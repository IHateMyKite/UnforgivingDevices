Scriptname UD_OutfitStorage extends UD_ModuleBase

Event OnSetup()
    UDMain.UDOTM.IncToBeRegCnt()
    ValidateOutfits()
    UDMain.UDOTM.AddOutfitStorage(self)
    UDMain.UDOTM.DecToBeRegCnt()
EndEvent

Int Function GetOutfitNum()
    return self.GetNumAliases()
EndFunction

UD_Outfit Function GetNthOutfit(Int aiIndex)
    return self.GetNthAlias(aiIndex) as UD_Outfit
EndFunction

UD_Outfit Function GetOutfitByAlias(String asAlias)
    int loc_i = 0
    while loc_i < GetOutfitNum()
        UD_Outfit loc_outfit = GetNthOutfit(loc_i)
        if loc_outfit.NameAlias == asAlias
            return loc_outfit
        endif
        loc_i += 1
    endwhile
    return none
EndFunction

Function ValidateOutfits()
    int loc_i = 0
    while loc_i < GetOutfitNum()
        UD_Outfit loc_outfit = GetNthOutfit(loc_i)
        loc_outfit.ValidateRnd()
        loc_i += 1
    endwhile
EndFunction

Bool Function ResetModule()
    UDMain.UDOTM.RemoveOutfitStorage(self)
    parent.ResetModule()
EndFunction