
-- Check if minigame should be available for selected device
local _Precondition = Precondition -- Save previous function
function Precondition(C)
    --Log("Precondition called")
    local loc_cutpower = GetVariableValue(C,"thisdevice::UD_CutChance(A)")
    return _Precondition(C) and loc_cutpower > 0.0
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
    Log("OnStart(Cutting.lua) called")
    
    _OnStart(C)
    
    -- Store max helath for later operations
    local loc_maxhealth = GetVariableValue(C,"thisdevice::_MaxHealth(A)")
    SetMinigameVar(C,'MaxDurability',loc_maxhealth)
    SetMinigameVar(C,"CursorPos",0.0)
    SetMinigameVar(C,"CursorDir",0)
    SetMinigameVar(C,"ZoneSizeCalc",SetMinigameVar(C,"ZoneSize",tonumber(GetConfigVar(C,"ZoneSize","0.1"))))
    SetMinigameVar(C,"ZonePos",math.random()*(1.0 - GetMinigameVar(C,"ZoneSize")))
    SetMinigameVar(C,"ZoneSizeReduction",tonumber(GetConfigVar(C,"ZoneSizeReduction","0.04")))
    SetMinigameVar(C,"CursorSize",0.025)
    SetMinigameVar(C,"CursorPosMax",1.0-GetMinigameVar(C,"CursorSize"))
    SetMinigameVar(C,"CursorSpeed",tonumber(GetConfigVar(C,"BaseSpeed","100.0")))
    SetMinigameVar(C,"Combo",0)
    SetMinigameVar(C,"SpeedMult",tonumber(GetConfigVar(C,"SpeedMult","1.25")))
    SetMinigameVar(C,"CutPower",tonumber(GetVariableValue(C,"thisdevice::UD_CutChance(A)")))
    SetMinigameVar(C,"ConditionDamageBase",tonumber(GetConfigVar(C,"ConditionDamageBase","15.0")))
    
    local loc_weaponpower = GetSharpestWeaponPower(C['Wearer'])
    if UseHelper(C) then
        loc_weaponpower = loc_weaponpower + GetSharpestWeaponPower(C['Helper'])
    end
    local loc_weaponmult = 1.0 + loc_weaponpower/100.0
    Log("WeaponMult -> "..loc_weaponmult)
    SetMinigameVar(C,"WeaponMult",loc_weaponmult)
end

local _OnUIOpen = OnUIOpen
function OnUIOpen(C)
    local loc_vars = _OnUIOpen(C)
    
    if GetMinigameVar(C,'AutoMode') then
        loc_vars["mcurvis"] = false
        loc_vars["combvis"] = false
    elseif not StrToBool(GetConfigVar(C,"ShowCombo","true")) then
        loc_vars["combvis"] = false
    end
    
    return loc_vars
end

local _RegisterCallbacks = RegisterCallbacks
function RegisterCallbacks(C)
    _RegisterCallbacks(C)
    if not GetMinigameVar(C,'AutoMode') then
        RegisterActionCallback(C,"press_left","Click","Cut")
        RegisterActionCallback(C,"press_right","Click","Cut")
    end
end

function CheckZone(C)
    local loc_pos           = GetMinigameVar(C,"CursorPos")
    local loc_zonesize      = GetMinigameVar(C,"ZoneSizeCalc")
    local loc_zonepos       = GetMinigameVar(C,"ZonePos")
    return loc_pos <= loc_zonesize + loc_zonepos and loc_pos >= loc_zonepos
end

function Click(C,eventtype)
    if eventtype == 1 then
        return
    end
    if CheckZone(C) then
        ClickSuccess(C)
    else
        ClickFail(C)
    end
end

function ClickSuccess(C)
    -- Increase reward and speed
    local loc_mult = GetMinigameVar(C,"Multiplier")
    loc_mult = loc_mult*GetMinigameVar(C,"SpeedMult")
    SetMinigameVar(C,"Multiplier",loc_mult)
    
    local loc_combo = UpdateMinigameVar(C,"Combo",1)
    if not GetMinigameVar(C,'UseNoUI') then
        InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(loc_combo).."})")
    end
    
    SetMinigameVar(C,"ZoneSizeCalc",GetMinigameVar(C,"ZoneSize")*(1.0 - loc_combo*GetMinigameVar(C,"ZoneSizeReduction")))
    
    CutDevice(C)
    
    -- Move zone
    SetMinigameVar(C,"ZonePos",math.random()*(1.0 - GetMinigameVar(C,"ZoneSize")))
    if GetMinigameVar(C,"UseShaders") then
        PlayShader(C,"green")
    end
end

function ClickFail(C)
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"Combo",0)
    SetMinigameVar(C,"ZoneSizeCalc",GetMinigameVar(C,"ZoneSize"))
    if not GetMinigameVar(C,'UseNoUI') then
        InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(0).."})")
    end
    if GetMinigameVar(C,"UseShaders") then
        PlayShader(C,"red")
    end
end

function ProcessMinigame(C,delta)
    --Log("ProcessMinigame(Cutting.lua) called")
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
    
    local loc_auto = GetMinigameVar(C,'AutoMode')
    local loc_noui = GetMinigameVar(C,'UseNoUI')
    if loc_auto or loc_noui then
        local loc_timer = UpdateMinigameVar(C,"AutoModeTimer",-1*delta)
        if loc_timer <= 0.0 then
            SetMinigameVar(C,"AutoModeTimer",GetMinigameVar(C,"AutoModeBase"))
            if CheckZone(C) and math.random() <= 0.8 then
                ClickSuccess(C)
            elseif math.random() > 0.9 then
                ClickFail(C)
            end
        end
    end
    
    local loc_durability    = GetVariableValue(C,"thisdevice::current_device_health(A)")
    local loc_durability_r  = Clamp(loc_durability/GetMinigameVar(C,'MaxDurability'),0.0,1.0)
    local loc_condition     = GetVariableValue(C,"thisdevice::_total_durability_drain(A)")
    local loc_condition_r   = Clamp(1.0 - loc_condition/100.0,0.0,1.0)
    local loc_cutting_r     = Clamp(GetVariableValue(C,"thisdevice::_CuttingProgress(A)")/100.0,0.0,1.0)
    local loc_conditionLvl  = GetVariableValue(C,"thisdevice::UD_condition(A)")
    
    -- For faster UI update
    SetMinigameVar(C,"Durability",loc_durability_r)
    SetMinigameVar(C,"Condition",loc_condition_r)
    SetMinigameVar(C,"ConditionLvl",loc_conditionLvl)
    
    if not loc_noui then
        local loc_zonesize = GetMinigameVar(C,"ZoneSizeCalc")
        local loc_zonepos = GetMinigameVar(C,"ZonePos")
        
        local loc_zones = {}
        loc_zones[1] = {}
        loc_zones[1]["name"] = "cutzone"
        loc_zones[1]["left"] = loc_zonepos
        loc_zones[1]["size"] = loc_zonesize
        
        if CheckZone(C) then
            loc_zones[1]["color"] = "green"
        else
            loc_zones[1]["color"] = "orange"
        end

        local loc_update = {}
        loc_update["dur"] = loc_durability_r
        loc_update["cond"] = loc_condition_r
        loc_update["condlvl"] = loc_conditionlvl
        loc_update["prog"] = loc_cutting_r
        loc_update["pos"] = loc_pos
        loc_update["zones"] = loc_zones
        local loc_updateminigame_payload    = "Update("..json.stringify(loc_update)..")"
        --Log(loc_updateminigame_payload)
        InvokeMinigameUI(C,loc_updateminigame_payload)
    end
    
    return true
end

function CutDevice(C)
    --Log("CutDevice called")
    local loc_mult       = GetMinigameVar(C,"WeaponMult")
    local loc_cutdmg     = 2.0*GetMinigameVar(C,"CutPower")*GetMinigameVar(C,"Multiplier")*GetMinigameVar(C,'MultiplierConst')
    local loc_progress   = UpdateVariableValue(C,"thisdevice::_CuttingProgress(U)",loc_cutdmg)
    Log("Increasing progress by "..tostring(loc_cutdmg).." to "..tostring(loc_progress))
    while loc_progress >= 100.0 do
        --Log("Cutting device")
        loc_progress = loc_progress - 100.0
        local loc_cond = UpdateVariableValue(C,"thisdevice::_total_durability_drain(U)",GetMinigameVar(C,"ConditionDamageBase")*loc_mult)
        Log("Condition updated to "..tostring(loc_cond))
        
        if UpdateCondition(C) == -1 then
            CallPapyrusFunction(C,"thisdevice::unlockRestrain","",{"bool",false},{"bool",false},{"bool",false})
            StopDeviceMinigame(C)
        end
        
        --Log("Nubmer of times cutted = "..tostring(loc_cutted))
        --while loc_cutted > 0 do
        --    loc_cutted = loc_cutted - 1
        --    DamageDurability(C,10.0,false)
        --end
    end
    UpdateVariableValue(C,"thisdevice::_CuttingProgress(A)",loc_progress)
end