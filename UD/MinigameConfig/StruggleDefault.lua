
-- Check if minigame should be available for selected device
function Precondition(C)
    return GetVariableValue(C,"thisdevice::UD_durability_damage_base(A)") > 0.0 and GetVariableValue(C,"thisdevice::UD_ResistPhysical(A)" < 1.0)
end

-- Check if actor can struggle or if other conditions are met
function Condition(C)
    local loc_stamina = GetVariableValue(C,"wearer::stamina(R)") > tonumber(GetConfigVar(C,"minStamina","0.0"))
    local loc_magicka = GetVariableValue(C,"wearer::magicka(R)") > tonumber(GetConfigVar(C,"minMagicka","0.0"))
    local loc_health  = GetVariableValue(C,"wearer::health(R)")  > tonumber(GetConfigVar(C,"minHealth","0.0"))
    if not IsNull(C['Helper']) then
        loc_stamina = loc_stamina and (GetVariableValue(C,"helper::stamina(R)") > tonumber(GetConfigVar(C,"minStamina","0.0")))
        loc_magicka = loc_magicka and (GetVariableValue(C,"helper::magicka(R)") > tonumber(GetConfigVar(C,"minMagicka","0.0")))
        loc_health  = loc_health  and (GetVariableValue(C,"helper::health(R)")  > tonumber(GetConfigVar(C,"minHealth","0.0")))
    end
    return loc_stamina and loc_magicka and loc_health
end

-- Called when minigame starts
function OnStart(C)
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
    
    SetMinigameVar(C,'DamageBase',tonumber(GetConfigVar(C,"DamageBase","10.0")))
end

-- Called on every player update frame
-- Is not called while in menu mode
function OnUpdate(C,delta)
    if not GetMinigameVar(C,"Ready") then
        Log("Minigame is not yet ready, wait...")
        return
    end

    --Log("Update")
    -- Reduce device durability
    if DamageDurability(C,-1.0*delta*GetMinigameVar(C,'DamageBase')) then
        -- Drain stats
        local loc_drains = GetMinigameVar(C,'StatDrain')
        DamageStats(C,loc_drains['Stamina']*delta,loc_drains['Health']*delta,loc_drains['Magicka']*delta)
        
        -- Check if actors have enough stats
        if not CheckStats(C,StrToBool(GetConfigVar(C,"CheckStamina","true")),StrToBool(GetConfigVar(C,"CheckHealth","true")),StrToBool(GetConfigVar(C,"CheckMagicka","true"))) then
            StopDeviceMinigame(C)
        else
            -- Update expression once in the while
            local loc_time = UpdateMinigameVar(C,'TimerExpr',-1.0*delta)
            if loc_time <= 0.0 then
                SetMinigameVar(C,'TimerExpr',5.0)
                CallPapyrusFunction(C,"thisdevice::Lua_UpdateMinigameExpression","",{"actor",C['Helper']})
            end
        end
    end

end

function DamageDurability(C,dmg)
    local loc_durability    = UpdateVariableValue(C,"thisdevice::current_device_health(U)",dmg)
    local loc_durability_r  = loc_durability/GetMinigameVar(C,'MaxDurability')
    InvokeUI(C,"UpdateDurability("..tostring(loc_durability_r)..")")
    if loc_durability <= 0.0 then
        CallPapyrusFunction(C,"thisdevice::unlockRestrain","",{"bool",false},{"bool",false},{"bool",false})
        StopDeviceMinigame(C)
        return false
    end
    return true
end

function OnMinigameReady(C)
    Log("OnMinigameReady")
    DisableRegen(C)
    
    -- Open UI
    if ActorIsPlayer(C['Wearer']) or ActorIsPlayer(C['Helper']) then
        OpenMinigameUI(C)
    end
    
    -- Register actions
    RegisterActionCallback(C,"press_stop","StopDeviceMinigame")
    RegisterActionCallback(C,"press_left","CritLeft")
    
    SetMinigameVar(C,'Ready',true)
end

function CritLeft(C)
    DamageDurability(C,-10.0)
end

function StopDeviceMinigame(C)
    Log("StopDeviceMinigame called")
    CloseMinigameUI(C)
    StopMinigame(C)
    CallPapyrusFunction(C,"thisdevice::Lua_StopMinigame","",{"actor",C['Helper']})
    UpdateVariableValue(C,"thisdevice::_MinigameMainLoopON(A)",false)
end
