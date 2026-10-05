
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
    
    _OnStart(C)
    
    -- Store max helath for later operations
    local loc_maxhealth = GetVariableValue(C,"thisdevice::_MaxHealth(A)")
    SetMinigameVar(C,'MaxDurability',loc_maxhealth)
    SetMinigameVar(C,'DamageMult',tonumber(GetConfigVar(C,"DamageMult","1.0")))
    SetMinigameVar(C,"CursorPos",0.0)
    SetMinigameVar(C,"CursorDir",0)
    SetMinigameVar(C,"ZoneSize",tonumber(GetConfigVar(C,"ZoneSize","0.1")))
    SetMinigameVar(C,"ZoneSizeReduction",tonumber(GetConfigVar(C,"ZoneSizeReduction","0.04")))
    SetMinigameVar(C,"CursorSize",0.025)
    SetMinigameVar(C,"CursorPosMax",1.0-GetMinigameVar(C,"CursorSize"))
    SetMinigameVar(C,"CursorSpeed",tonumber(GetConfigVar(C,"BaseSpeed","100.0")))
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"CondMult",tonumber(GetConfigVar(C,"CondMult","1.0")))
    SetMinigameVar(C,"PhysResMult",tonumber(GetConfigVar(C,"PhysResMult","1.0")))
    SetMinigameVar(C,"MagResMult",tonumber(GetConfigVar(C,"MagResMult","0.0")))
    SetMinigameVar(C,"DamageBase",GetVariableValue(C,"thisdevice::UD_durability_damage_base(A)")*GetMinigameVar(C,"DamageMult"))
    SetMinigameVar(C,"Combo",0)
    SetMinigameVar(C,"DamageSpeedMult",tonumber(GetConfigVar(C,"DamageSpeedMult","1.25")))
    SetMinigameVar(C,"SpeedMult",tonumber(GetConfigVar(C,"SpeedMult","1.05")))
    SetMinigameVar(C,"Accessibility",tonumber(GetDeviceAccessibility(C,true)))
    SetMinigameVar(C,"DurabilityScaling",tonumber(GetConfigVar(C,"DurabilityScaling","0.0")))
    
    local loc_durability_r  = GetVariableValue(C,"thisdevice::current_device_health(U)")/GetMinigameVar(C,'MaxDurability')
    local loc_condition_r   = 1.0 - GetVariableValue(C,"thisdevice::_total_durability_drain(U)")/100.0
    local loc_conditionLvl  = GetVariableValue(C,"thisdevice::UD_condition(A)")
    SetMinigameVar(C,"Durability",loc_durability_r)
    SetMinigameVar(C,"Condition",loc_condition_r)
    SetMinigameVar(C,"ConditionLvl",loc_conditionLvl)
    
    local loc_physres       = GetVariableValue(C,"thisdevice::UD_ResistPhysical(A)")
    local loc_physresmult   = GetMinigameVar(C,"PhysResMult")
    local loc_magres        = GetVariableValue(C,"thisdevice::UD_ResistMagicka(A)")
    local loc_magresmult    = GetMinigameVar(C,"MagResMult")
    local loc_resistence    = (loc_physres*loc_physresmult) + (loc_magres*loc_magresmult)
    SetMinigameVar(C,"Resistence",loc_resistence)
end

function DamageDurability(C,dmg)
    --Log("DamageDurability - "..tostring(dmg))
    
    local loc_lastdur_r     = GetMinigameVar(C,"Durability")
    local loc_durscalingmult = 1.0 + ((1.0 - loc_lastdur_r)*10.0)*GetMinigameVar(C,"DurabilityScaling")
    --Log("loc_durscalingmult = "..tostring(loc_durscalingmult))
    
    local loc_resistence    = 1.0 - GetMinigameVar(C,"Resistence")
    local loc_acc           = GetMinigameVar(C,"Accessibility")
    local loc_skillmult     = GetMinigameVar(C,"SkillMult")
    local loc_durability    = UpdateVariableValue(C,"thisdevice::current_device_health(U)",-1.0*dmg*loc_resistence*loc_acc*loc_skillmult*loc_durscalingmult)
    local loc_durability_r  = loc_durability/GetMinigameVar(C,'MaxDurability')
    local loc_condition     = UpdateVariableValue(C,"thisdevice::_total_durability_drain(U)",dmg*GetMinigameVar(C,"CondMult"))
    local loc_condition_r   = 1.0 - loc_condition/100.0
    
    
    -- For faster UI update
    SetMinigameVar(C,"Durability",loc_durability_r)
    SetMinigameVar(C,"Condition",loc_condition_r)
    
    if loc_durability <= 0.0 then
        CallPapyrusFunction(C,"thisdevice::unlockRestrain","",{"bool",false},{"bool",false},{"bool",false})
        StopDeviceMinigame(C)
        return false
    end
    if loc_condition >= 100.0 then
        UpdateVariableValue(C,"thisdevice::_total_durability_drain(A)",0.0)
        SetMinigameVar(C,"ConditionLvl",UpdateVariableValue(C,"thisdevice::UD_condition(U)",1))
        
        -- Reduce resistence
        local loc_physres       = UpdateVariableValue(C,"thisdevice::UD_ResistPhysical(U)",-0.25)
        local loc_physresmult   = GetMinigameVar(C,"PhysResMult")
        local loc_magres        = UpdateVariableValue(C,"thisdevice::UD_ResistMagicka(U)",-0.25)
        local loc_magresmult    = GetMinigameVar(C,"MagResMult")
        local loc_resistence    = (loc_physres*loc_physresmult) + (loc_magres*loc_magresmult)
        SetMinigameVar(C,"Resistence",loc_resistence)
    end
    return true
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
    Log("RegisterCallbacks(Struggle.lua)")
    _RegisterCallbacks(C)
    if not GetMinigameVar(C,'UseNoUI') and not GetMinigameVar(C,'AutoMode') then
        RegisterActionCallback(C,"press_left","ClickLeft","Struggle")
        RegisterActionCallback(C,"press_right","ClickRight","Struggle")
    end
end

function CheckZone(C,side)
    local loc_pos           = GetMinigameVar(C,"CursorPos")
    local loc_zone          = GetMinigameVar(C,"ZoneSize")
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
    InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(loc_combo).."})")
    
    local loc_dmg = GetMinigameVar(C,'DamageBase')*1.0
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
        local loc_zonesize          = GetMinigameVar(C,"ZoneSize")
        local loc_zonesizerecution  = GetMinigameVar(C,"ZoneSizeReduction")
        local loc_zonesizeui        = tostring(loc_zonesize*(1.0 - loc_combo*loc_zonesizerecution))
        
        local loc_setzone_payload           = "SetZones([{name:\"left\",left:0.0,size:"..loc_zonesizeui.."},{name:\"right\",right:0.0,size:"..loc_zonesizeui.."}])"
        local loc_updateminigame_payload    = "Update({dur:"..tostring(loc_durability_r)..",cond:"..tostring(loc_condition_r)..",condlvl:"..tostring(loc_conditionlvl)..",pos:"..tostring(loc_pos).."})"
        
        --Log("SetZone = "..loc_setzone_payload)
        --Log("Update = "..loc_updateminigame_payload)
        
        InvokeMinigameUI(C,loc_setzone_payload)
        InvokeMinigameUI(C,loc_updateminigame_payload)
    end
    return true
end