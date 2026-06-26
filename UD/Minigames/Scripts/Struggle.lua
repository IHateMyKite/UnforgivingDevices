
-- Check if minigame should be available for selected device
function Precondition(C)
    --Log("Precondition called")
    local loc_physres       = GetVariableValue(C,"thisdevice::UD_ResistPhysical(A)")
    local loc_physresmult   = GetConfigVar(C,"PhysResMult","1.0")
    local loc_magres        = GetVariableValue(C,"thisdevice::UD_ResistMagicka(A)")
    local loc_magresmult    = GetConfigVar(C,"MagResMult","0.0")
    local loc_resistence    = (loc_physres*loc_physresmult) + (loc_magres*loc_magresmult)
    
    return GetVariableValue(C,"thisdevice::UD_durability_damage_base(A)") > 0.0 and loc_resistence < 1.0
end

-- Check if actor can struggle or if other conditions are met
local _Condition = Condition -- Save previous function
function Condition(C)
    return _Condition(C)
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
    
    local loc_durability_r  = GetVariableValue(C,"thisdevice::current_device_health(U)")/GetMinigameVar(C,'MaxDurability')
    local loc_condition_r   = 1.0 - GetVariableValue(C,"thisdevice::_total_durability_drain(U)")/100.0
    SetMinigameVar(C,"Durability",loc_durability_r)
    SetMinigameVar(C,"Condition",loc_condition_r)
    
    local loc_physres       = GetVariableValue(C,"thisdevice::UD_ResistPhysical(A)")
    local loc_physresmult   = GetMinigameVar(C,"PhysResMult")
    local loc_magres        = GetVariableValue(C,"thisdevice::UD_ResistMagicka(A)")
    local loc_magresmult    = GetMinigameVar(C,"MagResMult")
    local loc_resistence    = (loc_physres*loc_physresmult) + (loc_magres*loc_magresmult)
    SetMinigameVar(C,"Resistence",loc_resistence)
end

function DamageDurability(C,dmg)
    Log("DamageDurability - "..tostring(dmg))
    local loc_resistence    = 1.0 - GetMinigameVar(C,"Resistence")
    local loc_durability    = UpdateVariableValue(C,"thisdevice::current_device_health(U)",-1.0*dmg*loc_resistence)
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
        UpdateVariableValue(C,"thisdevice::UD_condition(U)",1)
        
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

local _RegisterCallbacks = RegisterCallbacks
function RegisterCallbacks(C)
    _RegisterCallbacks()
    RegisterActionCallback(C,"press_stop","StopDeviceMinigame")
    RegisterActionCallback(C,"press_left","ClickLeft")
    RegisterActionCallback(C,"press_right","ClickRight")
    DamageDurability(C,0.0)
end

function ClickLeft(C)
    local loc_pos           = GetMinigameVar(C,"CursorPos")
    local loc_zone          = GetMinigameVar(C,"ZoneSize")
    --local loc_cursorsize    = GetMinigameVar(C,"CursorSize")
    --Log("ClickLeft - "..tostring(loc_pos).." , "..tostring(loc_zone))
    if loc_pos <= loc_zone then
        ClickSuccess(C)
    else
        ClickFail(C)
    end
end

function ClickRight(C)
    local loc_pos           = GetMinigameVar(C,"CursorPos")
    local loc_zone          = GetMinigameVar(C,"ZoneSize")
    local loc_cursorsize    = GetMinigameVar(C,"CursorSize")
    --Log("ClickRight - "..tostring((loc_pos + loc_cursorsize)).." , "..tostring((1.0 - loc_zone)))
    if (loc_pos + loc_cursorsize) >= (1.0 - loc_zone) then
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
end

function ClickFail(C)
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"CursorSpeed",tonumber(GetConfigVar(C,"BaseSpeed","100.0")))
    SetMinigameVar(C,"Combo",0)
    InvokeMinigameUI(C,"UpdateCombo({val:"..tostring(0).."})")
end

function ProcessMinigame(C,delta)
    Log("ProcessMinigame(Struggle.lua) called")

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
    
    local loc_durability_r = GetMinigameVar(C,"Durability")
    local loc_condition_r  = GetMinigameVar(C,"Condition")
    local loc_combo = GetMinigameVar(C,"Combo")
    local loc_zonesize = GetMinigameVar(C,"ZoneSize")
    local loc_zonesizerecution = GetMinigameVar(C,"ZoneSizeReduction")
    
    InvokeMinigameUI(C,"SetZones({zonesize:"..tostring(loc_zonesize*(1.0 - loc_combo*loc_zonesizerecution)).."})")
    InvokeMinigameUI(C,"UpdateMinigame({dur:"..tostring(loc_durability_r)..",cond:"..tostring(loc_condition_r)..",pos:"..tostring(loc_pos).."})")
end

function ProcessMinigameNPC(C,delta)
    local loc_dmg = GetMinigameVar(C,'DamageBase')*0.5
    DamageDurability(C,loc_dmg*delta)
end