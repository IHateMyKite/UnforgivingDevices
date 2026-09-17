
-- Check if minigame should be available for selected device
function Precondition(C)
    --Log("Precondition called")
    local loc_cutpower = GetVariableValue(C,"thisdevice::UD_CutChance(A)")
    
    return loc_cutpower > 0.0 and CheckTags(C)
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
    SetMinigameVar(C,"ZoneSize",tonumber(GetConfigVar(C,"ZoneSize","0.1")))
    SetMinigameVar(C,"ZonePos",math.random()*(1.0 - GetMinigameVar(C,"ZoneSize")))
    SetMinigameVar(C,"ZoneSizeReduction",tonumber(GetConfigVar(C,"ZoneSizeReduction","0.04")))
    SetMinigameVar(C,"CursorSize",0.025)
    SetMinigameVar(C,"CursorPosMax",1.0-GetMinigameVar(C,"CursorSize"))
    SetMinigameVar(C,"CursorSpeed",tonumber(GetConfigVar(C,"BaseSpeed","100.0")))
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"Combo",0)
    SetMinigameVar(C,"SpeedMult",tonumber(GetConfigVar(C,"SpeedMult","1.25")))
    SetMinigameVar(C,"CutPower",tonumber(GetVariableValue(C,"thisdevice::UD_CutChance(A)")))
    
    local loc_weaponpower = GetSharpestWeaponPower(C['Wearer'])
    if UseHelper(C) then
        loc_weaponpower = loc_weaponpower + GetSharpestWeaponPower(C['Helper'])
    end
    local loc_weaponmult = 1.0 + loc_weaponpower/100.0
    Log("WeaponMult = "..loc_weaponmult)
    SetMinigameVar(C,"WeaponMult",loc_weaponmult)
    
    
    local loc_durability_r  = GetVariableValue(C,"thisdevice::current_device_health(U)")/GetMinigameVar(C,'MaxDurability')
    local loc_condition_r   = 1.0 - GetVariableValue(C,"thisdevice::_total_durability_drain(U)")/100.0
    SetMinigameVar(C,"Durability",loc_durability_r)
    SetMinigameVar(C,"Condition",loc_condition_r)
end

local _RegisterCallbacks = RegisterCallbacks
function RegisterCallbacks(C)
    _RegisterCallbacks(C)
    RegisterActionCallback(C,"press_left","Click")
    RegisterActionCallback(C,"press_right","Click")
end

function Click(C)
    local loc_pos           = GetMinigameVar(C,"CursorPos")
    local loc_zonesize      = GetMinigameVar(C,"ZoneSize")
    local loc_zonepos       = GetMinigameVar(C,"ZonePos")
    if loc_pos <= loc_zonesize + loc_zonepos and loc_pos >= loc_zonepos then
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
    InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(loc_combo).."})")
    
    local loc_weaponmult = GetMinigameVar(C,"WeaponMult")
    local loc_dmg = GetMinigameVar(C,"CutPower")*loc_mult*loc_weaponmult
    CallPapyrusFunction(C,"thisdevice::_CuttingMG_SKPress","",{"float",loc_dmg})
    
    -- Move zone
    SetMinigameVar(C,"ZonePos",math.random()*(1.0 - GetMinigameVar(C,"ZoneSize")))
end

function ClickFail(C)
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"Combo",0)
    InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(0).."})")
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
    
    local loc_durability    = GetVariableValue(C,"thisdevice::current_device_health(A)")
    local loc_durability_r  = Clamp(loc_durability/GetMinigameVar(C,'MaxDurability'),0.0,1.0)
    local loc_condition     = GetVariableValue(C,"thisdevice::_total_durability_drain(A)")
    local loc_condition_r   = Clamp(1.0 - loc_condition/100.0,0.0,1.0)
    local loc_cutting_r     = Clamp(GetVariableValue(C,"thisdevice::_CuttingProgress(A)")/100.0,0.0,1.0)
    local loc_conditionLvl  = GetVariableValue(C,"thisdevice::UD_condition(A)")
    
    if loc_durability <= 0.0 then
        CallPapyrusFunction(C,"thisdevice::unlockRestrain","",{"bool",false},{"bool",false},{"bool",false})
        StopDeviceMinigame(C)
        return false
    end
    if loc_condition >= 100.0 then
        UpdateVariableValue(C,"thisdevice::_total_durability_drain(A)",0.0)
        loc_conditionLvl = UpdateVariableValue(C,"thisdevice::UD_condition(U)",1)
    end
    
    -- For faster UI update
    SetMinigameVar(C,"Durability",loc_durability_r)
    SetMinigameVar(C,"Condition",loc_condition_r)
    SetMinigameVar(C,"ConditionLvl",loc_conditionLvl)
    
    local loc_combo = GetMinigameVar(C,"Combo")
    local loc_zonesize = GetMinigameVar(C,"ZoneSize")
    local loc_zonepos = GetMinigameVar(C,"ZonePos")
    local loc_zonesizerecution = GetMinigameVar(C,"ZoneSizeReduction")
    
    InvokeMinigameUI(C,"SetZones({size:"..tostring(loc_zonesize*(1.0 - loc_combo*loc_zonesizerecution))..",pos:"..tostring(loc_zonepos).."})")
    InvokeMinigameUI(C,"UpdateMinigame({dur:"..tostring(loc_durability_r)..",cond:"..tostring(loc_condition_r)..",condlvl:"..tostring(loc_conditionLvl)..",cut:"..tostring(loc_cutting_r)..",pos:"..tostring(loc_pos).."})")
end

function ProcessMinigameNPC(C,delta)
    -- TODO
end