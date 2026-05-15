
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
function Condition(C)
    --Log("Condition called")
    local loc_stamina = GetVariableValue(C,"wearer::stamina(R)") > tonumber(GetConfigVar(C,"minStamina","0.0"))
    local loc_magicka = GetVariableValue(C,"wearer::magicka(R)") > tonumber(GetConfigVar(C,"minMagicka","0.0"))
    local loc_health  = GetVariableValue(C,"wearer::health(R)")  > tonumber(GetConfigVar(C,"minHealth","0.0"))
    if not IsNull(C['Helper']) then
        loc_stamina = loc_stamina and (GetVariableValue(C,"helper::stamina(R)") > tonumber(GetConfigVar(C,"minStamina","0.0")))
        loc_magicka = loc_magicka and (GetVariableValue(C,"helper::magicka(R)") > tonumber(GetConfigVar(C,"minMagicka","0.0")))
        loc_health  = loc_health  and (GetVariableValue(C,"helper::health(R)")  > tonumber(GetConfigVar(C,"minHealth","0.0")))
    end
    return loc_stamina and loc_magicka and loc_health and GetDeviceAccessibility(C) > 0.0
end

-- Called when minigame starts
function OnStart(C)
    Log("OnStart called")
    InitMinigameVars(C)
    
    UpdateVariableValue(C,"thisdevice::_PauseMinigame(A)",false)
    UpdateVariableValue(C,"thisdevice::_StopMinigame(A)",false)
    UpdateVariableValue(C,"thisdevice::_MinigameMainLoopON(A)",true)
    
    CallPapyrusFunction(C,"thisdevice::Lua_ReadyMinigame","OnMinigameReady",{"actor",C['Helper']})
    
    -- Ready local minigame variables
    SetMinigameVar(C,'TimerExpr',0.0)
    
    -- Store drains from config for faster access
    StoreConfigDrain(C)
    
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
    
    local loc_physres       = GetVariableValue(C,"thisdevice::UD_ResistPhysical(A)")
    local loc_physresmult   = GetMinigameVar(C,"PhysResMult")
    local loc_magres        = GetVariableValue(C,"thisdevice::UD_ResistMagicka(A)")
    local loc_magresmult    = GetMinigameVar(C,"MagResMult")
    local loc_resistence    = (loc_physres*loc_physresmult) + (loc_magres*loc_magresmult)
    SetMinigameVar(C,"Resistence",loc_resistence)
end

-- Called on every player update frame
-- Is not called while in menu mode
function OnUpdate(C,delta)
    -- Log("OnUpdate called")
    -- Check if minigame is already ready
    if not GetMinigameVar(C,"Ready") then
        return
    end
    
    -- Drain stats
    local loc_drains = GetMinigameVar(C,'StatDrain')
    DamageStats(C,loc_drains['Stamina']*delta,loc_drains['Health']*delta,loc_drains['Magicka']*delta)
    -- Check if actors have enough stats
    if not CheckStats(C,StrToBool(GetConfigVar(C,"CheckStamina","true")),StrToBool(GetConfigVar(C,"CheckHealth","true")),StrToBool(GetConfigVar(C,"CheckMagicka","true"))) then
        StopDeviceMinigame(C)
        return
    end
    
    if PlayerInMinigame(C) then
        ProcessMinigame(C,delta)
    else
        -- Reduce device durability - fallback when player is not present
        if not DamageDurability(C,delta*GetMinigameVar(C,'DamageBase')) then
            StopDeviceMinigame(C)
            return
        end
    end
    
    -- Update expression once in the while
    local loc_time = UpdateMinigameVar(C,'TimerExpr',-1.0*delta)
    if loc_time <= 0.0 then
        SetMinigameVar(C,'TimerExpr',5.0)
        CallPapyrusFunction(C,"thisdevice::Lua_UpdateMinigameExpression","",{"actor",C['Helper']})
    end
end

function OnStop(C)
    Log("OnStop called")
    CloseMinigameUI(C)
    CallPapyrusFunction(C,"thisdevice::Lua_StopMinigame","",{"actor",C['Helper']})
    UpdateVariableValue(C,"thisdevice::_MinigameMainLoopON(A)",false)
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

-- Called after Papyrus finish the ready stage (start animation, expressions, etc...)
function OnMinigameReady(C)
    Log("OnMinigameReady")
    DisableRegen(C)
    
    -- Open UI
    if PlayerInMinigame(C) then
        DamageDurability(C,0.0)
        OpenMinigameUI(C,"OnUIOpen")
    else
        SetMinigameVar(C,'Ready',true)
    end
end

-- Called after PrismaUI minigame object is open
function OnUIOpen(C)
    Log("OnUIOpen")
    -- Register actions
    RegisterActionCallback(C,"press_stop","StopDeviceMinigame")
    RegisterActionCallback(C,"press_left","ClickLeft")
    RegisterActionCallback(C,"press_right","ClickRight")
    SetMinigameVar(C,'Ready',true)
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
    InvokeUI(C,"UpdateCombo({val:"..tostring(loc_combo).."})")
    
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
    InvokeUI(C,"UpdateCombo({val:"..tostring(0).."})")
end

function StopDeviceMinigame(C)
    Log("StopDeviceMinigame called")
    StopMinigame(C)
end

function PlayerInMinigame(C)
    if ActorIsPlayer(C['Wearer']) or ActorIsPlayer(C['Helper']) then
        return true
    else
        return false
    end
end

function ProcessMinigame(C,delta)
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
    
    InvokeUI(C,"SetZones({zonesize:"..tostring(loc_zonesize*(1.0 - loc_combo*loc_zonesizerecution)).."})")
    InvokeUI(C,"UpdateMinigame({dur:"..tostring(loc_durability_r)..",cond:"..tostring(loc_condition_r)..",pos:"..tostring(loc_pos).."})")
end