
-- Called when minigame starts
local _OnStart = OnStart -- Save previous function
function OnStart(C)
    Log("OnStart(MinigameZoneSlide.lua) called")
    
    _OnStart(C)
    
    SetMinigameVar(C,"ZoneDir",0)
    SetMinigameVar(C,"ZoneSize",tonumber(GetConfigVar(C,"ZoneSize","0.25")))
    SetMinigameVar(C,"ZonePos",math.random()*(1.0 - GetMinigameVar(C,"ZoneSize")))
    SetMinigameVar(C,"ZonePosMax",1.0-GetMinigameVar(C,"ZoneSize"))
    SetMinigameVar(C,"ZoneSpeed",tonumber(GetConfigVar(C,"ZoneSpeed","25.0")))
    SetMinigameVar(C,"ZoneSizeReduction",tonumber(GetConfigVar(C,"ZoneSizeReduction","0.04")))
    
    SetMinigameVar(C,"CursorPos",0.0)
    SetMinigameVar(C,"CursorDir",0)
    SetMinigameVar(C,"CursorSize",0.025)
    SetMinigameVar(C,"CursorPosMax",1.0-GetMinigameVar(C,"CursorSize"))
    SetMinigameVar(C,"CursorSpeed",tonumber(GetConfigVar(C,"CursorSpeed","100.0")))
    
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"Combo",0.0)
    SetMinigameVar(C,"SpeedMult",tonumber(GetConfigVar(C,"SpeedMult","1.05")))
    SetMinigameVar(C,"ActionName",GetConfigVar(C,"ActionName","Action"))
    
    SetMinigameVar(C,"HoldingZone",false)
end

local _OnUIOpen = OnUIOpen
function OnUIOpen(C)
    local loc_vars = _OnUIOpen(C)
    local loc_pos_x = GetConfigVar(C,"PosX","nan")
    if loc_pos_x ~= "nan" then
        loc_vars["pos_x"] = loc_pos_x.."%"
    end
    local loc_pos_y = GetConfigVar(C,"PosY","nan")
    if loc_pos_y ~= "nan" then
        loc_vars["pos_y"] = loc_pos_y.."%"
    end
    local loc_scale = GetConfigVar(C,"Scale","nan")
    if loc_scale ~= "nan" then
        loc_vars["scale"] = loc_scale
    end
    local loc_hints = GetConfigVar(C,"Hints","nan")
    if loc_hints ~= "nan" then
        loc_vars["hints"] = StrToBool(loc_hints)
    end
    
    if not StrToBool(GetConfigVar(C,"ShowCombo","true")) then
        loc_vars["combvis"] = false
    end
    
    loc_vars["mdurvis"] = false
    loc_vars["mconvis"] = false
    
    local loc_actions = GetRegisteredActions(C)
    loc_vars["actions"] = loc_actions
    
    return loc_vars
end

local _RegisterCallbacks = RegisterCallbacks
function RegisterCallbacks(C)
    _RegisterCallbacks(C)
    if not GetMinigameVar(C,'AutoMode') then
        RegisterActionCallback(C,"press_middle","Click",GetMinigameVar(C,"ActionName"))
    end
end

function CheckZone(C)
    local loc_pos           = GetMinigameVar(C,"CursorPos")
    local loc_zonesize      = GetMinigameVar(C,"ZoneSize")
    local loc_zonepos       = GetMinigameVar(C,"ZonePos")
    return loc_pos <= loc_zonesize + loc_zonepos and loc_pos >= loc_zonepos
end

function Click(C,eventtype)
    Log("Click(MinigameZoneSlide.lua) - "..tostring(eventtype))
    if eventtype == 0 then
        if CheckZone(C) then
            SetMinigameVar(C,"HoldingZone",true)
            if GetMinigameVar(C,"UseShaders") then
                CallPapyrusFunction(C,"thisdevice::_MG_CastGreenShader","")
            end
        else
            SetMinigameVar(C,"HoldingZone",false)
        end
    elseif eventtype == 1 and GetMinigameVar(C,"HoldingZone") then
        if CheckZone(C) then
            SetMinigameVar(C,"HoldingZone",false)
        else
            ReleaseZone(C)
        end
    end
end

function ProcessMinigame(C,delta)
    --Log("ProcessMinigame(Cutting.lua) called")
    
    -- Check if cursor is in zone and zone is pressed
    if GetMinigameVar(C,"HoldingZone") then
        if CheckZone(C) then
            HoldZone(C,delta)
        else
            ReleaseZone(C)
        end
    end
    
    UpdateCursor(C,delta)
    
    UpdateZone(C,delta)
    
    local loc_auto = GetMinigameVar(C,'AutoMode')
    local loc_noui = GetMinigameVar(C,'UseNoUI')
    if loc_auto or loc_noui then
        local loc_timer = UpdateMinigameVar(C,"AutoModeTimer",-1*delta)
        if loc_timer <= 0.0 then
            SetMinigameVar(C,"AutoModeTimer",GetMinigameVar(C,"AutoModeBase"))
            if CheckZone(C) and not GetMinigameVar(C,"HoldingZone") and math.random() <= 0.8 then
                Click(C,0)
            elseif math.random() > 0.25 and GetMinigameVar(C,"HoldingZone") then
                Click(C,1)
            end
        end
    end
    
    if not loc_noui then
        local loc_combo     = GetMinigameVar(C,"Combo")
        local loc_zonesize  = GetMinigameVar(C,"ZoneSize")
        local loc_zonepos   = GetMinigameVar(C,"ZonePos")
        local loc_zonesizerecution = GetMinigameVar(C,"ZoneSizeReduction")
        local loc_zonesizeui= loc_zonesize*(1.0 - loc_combo*loc_zonesizerecution)
        local loc_cursor    = GetMinigameVar(C,"CursorPos")
        local loc_prog      = GetUIUpdateString(C)
        
        local loc_color     = "yellow"
        if GetMinigameVar(C,"HoldingZone") then
            loc_color = "green"
        end
        
        local loc_setzone_payload           = "SetZones([{name:\"zone\",color:\""..loc_color.."\",size:"..tostring(loc_zonesizeui)..",left:"..tostring(loc_zonepos).."}])"
        local loc_updateminigame_payload    = "Update({pos:"..tostring(loc_cursor)..loc_prog.."})"
        
        --Log("SetZone = "..loc_setzone_payload)
        --Log("Update = "..loc_updateminigame_payload)
        
        InvokeMinigameUI(C,loc_setzone_payload)
        InvokeMinigameUI(C,loc_updateminigame_payload)
    end
end

function UpdateCursor(C,delta)
    if GetMinigameVar(C,"HoldingZone") then
        if CheckZone(C) then
            delta = delta*0.5
        end
    end

    local loc_pos       = GetMinigameVar(C,"CursorPos")
    local loc_speed     = GetMinigameVar(C,"CursorSpeed")
    local loc_posmax    = GetMinigameVar(C,"CursorPosMax")
    if GetMinigameVar(C,"CursorDir") == 0 then
        loc_pos = loc_pos + ((loc_speed/100.0)*delta)
        if (loc_pos >= loc_posmax) then
            loc_pos = loc_posmax
            SetMinigameVar(C,"CursorDir",1)
        end
    else
        loc_pos = loc_pos - ((loc_speed/100.0)*delta)
        if loc_pos <= 0.0 then
            loc_pos = 0.0
            SetMinigameVar(C,"CursorDir",0)
        end
    end
    SetMinigameVar(C,"CursorPos",loc_pos)
end

function UpdateZone(C,delta)
    if GetMinigameVar(C,"HoldingZone") then
        if CheckZone(C) then
            delta = delta*0.1
        end
    end

    local loc_pos       = GetMinigameVar(C,"ZonePos")
    local loc_speed     = GetMinigameVar(C,"ZoneSpeed")
    local loc_posmax    = GetMinigameVar(C,"ZonePosMax")
    if GetMinigameVar(C,"ZoneDir") == 0 then
        loc_pos = loc_pos + ((loc_speed/100.0)*delta)
        if (loc_pos >= loc_posmax) then
            loc_pos = loc_posmax
            SetMinigameVar(C,"ZoneDir",1)
        end
    else
        loc_pos = loc_pos - ((loc_speed/100.0)*delta)
        if loc_pos <= 0.0 then
            loc_pos = 0.0
            SetMinigameVar(C,"ZoneDir",0)
        end
    end
    SetMinigameVar(C,"ZonePos",loc_pos)
end

function HoldZone(C,delta)
    local loc_mult = GetMinigameVar(C,"Multiplier")
    loc_mult = loc_mult*GetMinigameVar(C,"SpeedMult")
    SetMinigameVar(C,"Multiplier",loc_mult)
    
    local loc_combo = UpdateMinigameVar(C,"Combo",delta)
    if not GetMinigameVar(C,'UseNoUI') then
        InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(math.floor(loc_combo*10.0)/10.0).."})")
    end
    OnHoldingZone(C,delta)
end

function ReleaseZone(C)
    SetMinigameVar(C,"HoldingZone",false)
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"Combo",0.0)
    if not GetMinigameVar(C,'UseNoUI') then
        InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(0).."})")
    end
    if GetMinigameVar(C,"UseShaders") then
        CallPapyrusFunction(C,"thisdevice::_MG_CastRedShader","")
    end
    OnReleasingZone(C)
end

function OnHoldingZone(C,delta)
end

function OnReleasingZone(C)
end

function GetUIUpdateString(C)
    return ""
end