
local _Condition = Condition -- Save previous function
function Condition(C)
    return _Condition(C) and GetOrgasmProgress(C['Actor'],1) > 0.25
end

-- Called when minigame starts
local _OnStart = OnStart
function OnStart(C)
    _OnStart(C)
    SetMinigameVar(C,"CursorSpeed",GetMinigameVar(C,"CursorSpeed")*Clamp(4*GetOrgasmProgress(C['Actor'],1),1.0,2.0))
    SetMinigameVar(C,"ZoneSpeed",GetMinigameVar(C,"ZoneSpeed")*Clamp(2*GetOrgasmProgress(C['Actor'],1),1.0,1.5))
    AddOrgasmChange(C['Actor'],"MINM_ResistOrgasm",0,0x00000200,0.0,0.0,0.0,0.0,0.0,0.25)
end

local _OnStop = OnStop
function OnStop(C)
    RemoveOrgasmChange(C['Actor'],"MINM_ResistOrgasm")
    _OnStop(C)
end

function OnHoldingZone(C,delta)
    local loc_mult = GetMinigameVar(C,"MultiplierConst")
    UpdateOrgasmChangeVar(C['Actor'],"MINM_ResistOrgasm",3,1.5*delta*loc_mult,2)
end

function OnReleasingZone(C)
    UpdateOrgasmChangeVar(C['Actor'],"MINM_ResistOrgasm",3,0,1)
end

local _OnUIOpen = OnUIOpen
function OnUIOpen(C)
    local loc_vars = _OnUIOpen(C)
    loc_vars["mprovis"] = false
    return loc_vars
end