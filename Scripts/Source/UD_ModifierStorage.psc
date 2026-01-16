ScriptName UD_ModifierStorage extends UD_ModuleBase

UD_ModifierManager_Script _udmom
UD_ModifierManager_Script Property UDMOM
    UD_ModifierManager_Script Function Get()
        if (!_udmom)
            _udmom = UDmain.UDMOM
        endif
        return _udmom
    EndFunction
EndProperty

String[] Property UD_ModifierList Auto Hidden

Event OnSetup()
    UpdateList()
    UDMOM.AddModifierStorage(self)
EndEvent

Function UpdateList()
    UD_ModifierList = Utility.CreateStringArray(0)
    Int loc_i = 0
    Int loc_n = Self.GetNumAliases()
    while loc_i < loc_n
        UD_Modifier loc_mod = Self.GetNthAlias(loc_i) as UD_Modifier
        UD_ModifierList = PapyrusUtil.PushString(UD_ModifierList, loc_mod.NameFull)
        loc_i += 1
    endwhile
EndFunction

Int Function GetModifierNum()
    Int loc_num = Self.GetNumAliases()
    If UD_ModifierList.Length != loc_num
        UpdateList()
    EndIf
    return loc_num
EndFunction

UD_Modifier Function GetNthModifier(Int aiIndex)
    If UD_ModifierList.Length != Self.GetNumAliases()
        UpdateList()
    EndIf
    return self.GetNthAlias(aiIndex) as UD_Modifier
EndFunction
