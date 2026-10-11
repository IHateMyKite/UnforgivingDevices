
-- Check if minigame should be available for selected device
local _Precondition = Precondition -- Save previous function
function Precondition(C)
    --Log("Precondition(Struggle.lua) called")
    local loc_physres       = GetVariableValue(C,"thisdevice::UD_ResistPhysical(A)")
    local loc_physresmult   = GetConfigVar(C,"PhysResMult","1.0")
    local loc_magres        = GetVariableValue(C,"thisdevice::UD_ResistMagicka(A)")
    local loc_magresmult    = GetConfigVar(C,"MagResMult","0.0")
    local loc_resistence    = (loc_physres*loc_physresmult) + (loc_magres*loc_magresmult)
    return _Precondition(C) and GetVariableValue(C,"thisdevice::UD_durability_damage_base(A)") > 0.0 and loc_resistence < 1.0
end

-- Check if actor can struggle or if other conditions are met
local _Condition = Condition -- Save previous function
function Condition(C)
    return _Condition(C)
end

function GetContext(C)
    local loc_res = ""
    if PlayerInMinigame(C) and not ActorIsPlayer(C['Wearer']) then
        -- TODO: Check if NPC can be commanded
        loc_res = loc_res.."["
        loc_res = loc_res.."{name:\"Command\",value:\"command\",state:\"1\"},"
        if CheckMinStatsHelper(C) then
            loc_res = loc_res.."{name:\"Help\",value:\"help\",state:\"1\"}"
        else
            loc_res = loc_res.."{name:\"Help\",value:\"help\",state:\"0\"}"
        end
        loc_res = loc_res.."]"
    end
    return loc_res
end

-- Called when minigame starts
local _OnStart = OnStart -- Save previous function
function OnStart(C)
    Log("OnStart(Struggle.lua) called")
    
    InitMinigameVars(C)
    
    SetMinigameVar(C,'DamageMult',tonumber(GetConfigVar(C,"DamageMult","1.0")))
    SetMinigameVar(C,"CursorPos",0.0)
    SetMinigameVar(C,"CursorDir",0)
    SetMinigameVar(C,"ZoneSizeCalc",SetMinigameVar(C,"ZoneSize",tonumber(GetConfigVar(C,"ZoneSize","0.1"))))
    SetMinigameVar(C,"ZoneSizeReduction",tonumber(GetConfigVar(C,"ZoneSizeReduction","0.04")))
    SetMinigameVar(C,"CursorSize",0.025)
    SetMinigameVar(C,"CursorPosMax",1.0-GetMinigameVar(C,"CursorSize"))
    SetMinigameVar(C,"CursorSpeed",tonumber(GetConfigVar(C,"BaseSpeed","100.0")))
    SetMinigameVar(C,"DamageBase",GetVariableValue(C,"thisdevice::UD_durability_damage_base(A)")*GetMinigameVar(C,"DamageMult"))
    SetMinigameVar(C,"Combo",0)
    SetMinigameVar(C,"DamageSpeedMult",tonumber(GetConfigVar(C,"DamageSpeedMult","1.25")))
    SetMinigameVar(C,"SpeedMult",tonumber(GetConfigVar(C,"SpeedMult","1.05")))
    
    
    if SetMinigameVar(C,"UnlockOnAccess",StrToBool(GetConfigVar(C,"UnlockOnAccess","false"))) and GetDeviceAccessibility(C,true) >= 1.0 then
        CallPapyrusFunction(C,"thisdevice::unlockRestrain","",{"bool",false},{"bool",false},{"bool",false})
        StopDeviceMinigame(C)
        return
    end
    
    _OnStart(C)
end

local _OnUIOpen = OnUIOpen
function OnUIOpen(C)
    local loc_vars = _OnUIOpen(C)
    
    if GetMinigameVar(C,'AutoMode') then
        --loc_vars["mcurvis"] = false
        loc_vars["combvis"] = false
    elseif not StrToBool(GetConfigVar(C,"ShowCombo","true")) then
        loc_vars["combvis"] = false
    end
    
    loc_vars["mprovis"] = false
    
    return loc_vars
end

local _RegisterCallbacks = RegisterCallbacks
function RegisterCallbacks(C)
    --Log("RegisterCallbacks(Struggle.lua)")
    _RegisterCallbacks(C)
    if not GetMinigameVar(C,'UseNoUI') and not GetMinigameVar(C,'AutoMode') then
        RegisterActionCallback(C,"press_left","ClickLeft","Struggle")
        RegisterActionCallback(C,"press_right","ClickRight","Struggle")
    end
end

function CheckZone(C,side)
    local loc_pos           = GetMinigameVar(C,"CursorPos")
    local loc_zone          = GetMinigameVar(C,"ZoneSizeCalc")
    local loc_cursorsize    = GetMinigameVar(C,"CursorSize")
    if side == 0 then
        return loc_pos <= loc_zone
    elseif side == 1 then
        return (loc_pos + loc_cursorsize) >= (1.0 - loc_zone)
    end
end

function ClickLeft(C,eventtype)
    if eventtype == 1 then
        return
    end
    if CheckZone(C,0) then
        ClickSuccess(C)
    else
        ClickFail(C)
    end
end

function ClickRight(C,eventtype)
    if eventtype == 1 then
        return
    end
    if CheckZone(C,1) then
        ClickSuccess(C)
    else
        ClickFail(C)
    end
end

function ClickSuccess(C)
    -- Increase reward and speed
    local loc_mult = GetMinigameVar(C,"Multiplier")
    loc_mult = loc_mult*GetMinigameVar(C,"DamageSpeedMult")
    SetMinigameVar(C,"Multiplier",loc_mult)
    
    local loc_combo = UpdateMinigameVar(C,"Combo",1)
    SetMinigameVar(C,"ZoneSizeCalc",GetMinigameVar(C,"ZoneSize")*(1.0 - loc_combo*GetMinigameVar(C,"ZoneSizeReduction")))
    InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(loc_combo).."})")
    
    local loc_dmg = GetMinigameVar(C,'DamageBase')*GetMinigameVar(C,'MultiplierConst')
    DamageDurability(C,loc_dmg*loc_mult)
    
    local loc_speed = GetMinigameVar(C,"CursorSpeed")
    loc_speed = loc_speed*GetMinigameVar(C,"SpeedMult")
    SetMinigameVar(C,"CursorSpeed",loc_speed)
    if GetMinigameVar(C,"UseShaders") and not GetMinigameVar(C,'UseNoUI') then
        PlayShader(C,"green")
    end
end

function ClickFail(C)
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"CursorSpeed",tonumber(GetConfigVar(C,"BaseSpeed","100.0")))
    SetMinigameVar(C,"Combo",0)
    SetMinigameVar(C,"ZoneSizeCalc",GetMinigameVar(C,"ZoneSize"))
    InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(0).."})")
    if GetMinigameVar(C,"UseShaders") and not GetMinigameVar(C,'UseNoUI') then
        PlayShader(C,"red")
    end
end

function ProcessMinigame(C,delta)
    --Log("ProcessMinigame(Struggle.lua) called")

    local loc_auto = GetMinigameVar(C,'AutoMode')
    local loc_noui = GetMinigameVar(C,'UseNoUI')

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
    
    if loc_auto or loc_noui then
        local loc_timer = UpdateMinigameVar(C,"AutoModeTimer",-1*delta)
        if loc_timer <= 0.0 then
            SetMinigameVar(C,"AutoModeTimer",GetMinigameVar(C,"AutoModeBase"))
            if (CheckZone(C,0) or CheckZone(C,1)) and math.random() <= 0.8 then
                ClickSuccess(C)
            elseif math.random() > 0.9 then
                ClickFail(C)
            end
        end
    end
    
    if not loc_noui then
        local loc_durability_r      = GetMinigameVar(C,"Durability")
        local loc_condition_r       = GetMinigameVar(C,"Condition")
        local loc_conditionlvl      = GetMinigameVar(C,"ConditionLvl")
        local loc_combo             = GetMinigameVar(C,"Combo")
        local loc_zonesize          = GetMinigameVar(C,"ZoneSizeCalc")
        
        local loc_color_left = "yellow"
        local loc_color_right = "yellow"
        if CheckZone(C,0) then
            loc_color_left = "green"
        end
        if CheckZone(C,1) then
            loc_color_right = "green"
        end
        
        local loc_zones = {}
        loc_zones[1] = {}
        loc_zones[1]["name"] = "left"
        loc_zones[1]["left"] = 0.0
        loc_zones[1]["size"] = loc_zonesize
        loc_zones[1]["color"] = loc_color_left
        loc_zones[2] = {}
        loc_zones[2]["name"] = "right"
        loc_zones[2]["right"] = 0.0
        loc_zones[2]["size"] = loc_zonesize
        loc_zones[2]["color"] = loc_color_right

        local loc_update = {}
        loc_update["dur"] = loc_durability_r
        loc_update["cond"] = loc_condition_r
        loc_update["condlvl"] = loc_conditionlvl
        loc_update["pos"] = loc_pos
        loc_update["zones"] = loc_zones
        local loc_updateminigame_payload = "Update("..json.stringify(loc_update)..")"
        
        --Log("Update = "..loc_updateminigame_payload)
        
        InvokeMinigameUI(C,loc_updateminigame_payload)
    end
    return true
end