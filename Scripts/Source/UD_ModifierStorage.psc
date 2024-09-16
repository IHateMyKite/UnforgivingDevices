ScriptName UD_ModifierStorage extends Quest

UD_ModifierManager_Script _udmom
UD_ModifierManager_Script Property UDMOM
    UD_ModifierManager_Script Function Get()
        if (!_udmom)
            _udmom = UnforgivingDevicesMain.GetUDmain().UDMOM
        endif
        return _udmom
    EndFunction
EndProperty

Event OnInit()
    RegisterForSingleUpdate(10.0)
EndEvent

Event OnUpdate()
    UDMOM.AddModifierStorage(self)
    
    Int loc_i = self.GetNumAliases()
    While loc_i > 0
        loc_i -= 1
        (self.GetNthAlias(loc_i) as UD_Modifier).Update()
    EndWhile
EndEvent

Int Function GetModifierNum()
    return self.GetNumAliases()
EndFunction

UD_Modifier Function GetNthModifier(Int aiIndex)
    return self.GetNthAlias(aiIndex) as UD_Modifier
EndFunction
