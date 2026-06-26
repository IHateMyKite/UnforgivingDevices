
-- Check if minigame should be available for selected device
function Precondition(C)
    return false
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
    return loc_stamina and loc_magicka and loc_health and GetDeviceAccessibility(C) > 0.0
end

function GetContext(C)
    return ""
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
        ProcessMinigameNPC(C,delta)
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

-- Called after Papyrus finish the ready stage (start animation, expressions, etc...)
function OnMinigameReady(C)
    Log("OnMinigameReady")
    DisableRegen(C)
    
    -- Open UI
    if PlayerInMinigame(C) then
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

function RegisterCallbacks(C)
end

function ProcessMinigame(C,delta)
end

function ProcessMinigameNPC(C,delta)
end
