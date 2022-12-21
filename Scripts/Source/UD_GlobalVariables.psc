Scriptname UD_GlobalVariables extends Quest conditional
{Scripts containing all global variables and switches}
import UnforgivingDevicesMain

;shows details about crit in device details if different from 0, short
GlobalVariable _ShowCritVars
GlobalVariable Property UDG_ShowCritVars
    GlobalVariable Function Get()
        if !_ShowCritVars
            _ShowCritVars = GetMeMyForm(0x15D5FF,"PR100_NPCAI.esp")  as GlobalVariable
        endif
        return _ShowCritVars
    EndFunction
    Function Set(GlobalVariable akVal)
        _ShowCritVars = akVal
    EndFunction
EndProperty

;minigame update time, is used if its different from 0, float
GlobalVariable _CustomMinigameUpT
GlobalVariable Property UDG_CustomMinigameUpT
    GlobalVariable Function Get()
        if !_CustomMinigameUpT
            _CustomMinigameUpT = GetMeMyForm(0x15D600,"PR100_NPCAI.esp")   as GlobalVariable
        endif
        return _CustomMinigameUpT
    EndFunction
    Function Set(GlobalVariable akVal)
        _CustomMinigameUpT = akVal
    EndFunction
EndProperty

;update time for NPC scan, float
GlobalVariable _NPCScanUpT
GlobalVariable Property UDG_NPCScanUpT
    GlobalVariable Function Get()
        if !_NPCScanUpT
            _NPCScanUpT = GetMeMyForm(0x15D601,"PR100_NPCAI.esp")  as GlobalVariable
        endif
        return _NPCScanUpT
    EndFunction
    Function Set(GlobalVariable akVal)
        _NPCScanUpT = akVal
    EndFunction
EndProperty


;update time for NPC heavy processing (skill update), float
GlobalVariable _NPCHeavyUpT
GlobalVariable Property UDG_NPCHeavyUpT
    GlobalVariable Function Get()
        if !_NPCHeavyUpT
            _NPCHeavyUpT = GetMeMyForm(0x15D602,"PR100_NPCAI.esp") as GlobalVariable
        endif
        return _NPCHeavyUpT
    EndFunction
    Function Set(GlobalVariable akVal)
        _NPCHeavyUpT = akVal
    EndFunction
EndProperty