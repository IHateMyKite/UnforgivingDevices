
local _Condition = Condition -- Save previous function
function Condition(C)
    return _Condition(C)
end

-- Called when minigame starts
local _OnStart = OnStart
function OnStart(C)
    _OnStart(C)
    
    local loc_mult = GetMinigameVar(C,"MultiplierConst")
    if not SetMinigameVar(C,"FreeHands",ActorFreeHands(C['Actor'],false,false)) then
        loc_mult = loc_mult*0.1
    elseif not SetMinigameVar(C,"FreeHands",ActorFreeHands(C['Actor'],true,true)) then
        loc_mult = loc_mult*0.4
    end
    
    SetMinigameVar(C,"GenitalBaseRate",tonumber(GetConfigVar(C,"GenitalBaseRate","15.0")))
    SetMinigameVar(C,"AnalBaseRate",tonumber(GetConfigVar(C,"AnalBaseRate","7.5")))
    SetMinigameVar(C,"NippleBaseRate",tonumber(GetConfigVar(C,"NippleBaseRate","4.0")))
    
    SetMinigameVar(C,"GenitalPlugInc",tonumber(GetConfigVar(C,"GenitalPlugInc","2.5")))
    SetMinigameVar(C,"AnalPlugInc",tonumber(GetConfigVar(C,"AnalPlugInc","1.5")))
    
    SetMinigameVar(C,"BeltedEffectivenes",tonumber(GetConfigVar(C,"BeltedEffectivenes","1.0")))
    
    SetMinigameVar(C,"BeltedGenitals",WornHasKeyword(C['Actor'],"zad_DeviousBelt"))
    SetMinigameVar(C,"BeltedBreasts",WornHasKeyword(C['Actor'],"zad_DeviousBra"))
    SetMinigameVar(C,"BeltedAnal",GetMinigameVar(C,"BeltedGenitals") and not WornHasKeyword(C['Actor'],"zad_PermitAnal"))
    SetMinigameVar(C,"PluggedGenital",WornHasKeyword(C['Actor'],"zad_DeviousPlugVaginal"))
    SetMinigameVar(C,"PluggedAnal",WornHasKeyword(C['Actor'],"zad_DeviousPlugAnal"))
    
    
    SetMinigameVar(C,"MultiplierConst",loc_mult)
    SetMinigameVar(C,"MasturbationTarget",C['Context'])
    
    Log("Mult = "..tostring(loc_mult))
    Log("Base OrgasmRate = "..tostring(GetOrgasmRate(C)))
    
    AddOrgasmChange(C['Actor'],"MINM_Masturbate",0,GetEroZone(C),GetOrgasmRate(C)*loc_mult,0.0,0.0,0.0,0.0,-0.25*loc_mult)
end

local _OnStop = OnStop
function OnStop(C)
    RemoveOrgasmChange(C['Actor'],"MINM_Masturbate")
    _OnStop(C)
end

function OnHoldingZone(C,delta)
    local loc_mult = GetMinigameVar(C,"MultiplierConst")*GetMinigameVar(C,"Multiplier")
    UpdateOrgasmChangeVar(C['Actor'],"MINM_Masturbate",1,GetOrgasmRate(C)*loc_mult*delta,2)
end

function OnZoneExited(C)
    ReleaseZone(C)
end

function OnZoneOutside(C)
    UpdateOrgasmChangeVar(C['Actor'],"MINM_Masturbate",1,0.995,3)
end

local _OnUIOpen = OnUIOpen
function OnUIOpen(C)
    local loc_vars = _OnUIOpen(C)
    loc_vars["mprovis"] = false
    return loc_vars
end

function GetContext(C)
    local loc_res = ""
    loc_res = loc_res.."["
    loc_res = loc_res.."{\"name\":\"Genitals\",\"value\":\"genitals\",\"state\":1},"
    loc_res = loc_res.."{\"name\":\"Anal\",\"value\":\"anal\",\"state\":1},"
    loc_res = loc_res.."{\"name\":\"Nipples\",\"value\":\"nipples\",\"state\":1}"
    loc_res = loc_res.."]"
    return loc_res
end

function GetOrgasmRate(C)
    local loc_target = GetMinigameVar(C,"MasturbationTarget")
    local loc_res = 0.0
    if loc_target == "anal" then
        if GetMinigameVar(C,"PluggedAnal") then
            loc_res = loc_res + GetMinigameVar(C,"AnalPlugInc")
        end
        if not GetMinigameVar(C,"BeltedAnal") then
            loc_res = loc_res + GetMinigameVar(C,"AnalBaseRate")
        else
            loc_res = loc_res * GetMinigameVar(C,"BeltedEffectivenes")
        end
    elseif loc_target == "nipples" then
        if not GetMinigameVar(C,"BeltedBreasts") then
            loc_res = GetMinigameVar(C,"NippleBaseRate")
        end
    else -- genitals
        if GetMinigameVar(C,"PluggedGenital") then
            loc_res = loc_res + GetMinigameVar(C,"GenitalPlugInc")
        end
        if not GetMinigameVar(C,"BeltedGenitals") then
            loc_res = loc_res + GetMinigameVar(C,"GenitalBaseRate")
        else
            loc_res = loc_res * GetMinigameVar(C,"BeltedEffectivenes")
        end
    end
    
    return loc_res
end

function GetEroZone(C)
    local loc_target = GetMinigameVar(C,"MasturbationTarget")
    if loc_target == "anal" then
        return 0x00000180
    elseif loc_target == "nipples" then
        return 0x00000040
    else -- genitals
        return 0x0000003F
    end
end
