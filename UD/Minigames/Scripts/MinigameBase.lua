
-- Check if minigame should be available for selected device
function Precondition(C)
    return false
end

-- Check if actor can struggle or if other conditions are met
function Condition(C)
    return CheckMinStatsWearer(C) and GetDeviceAccessibility(C) > 0.0
end

function CheckMinStatsWearer(C)
    local loc_stamina = GetVariableValue(C,"wearer::stamina(R)") > tonumber(GetConfigVar(C,"minStamina","0.0"))
    local loc_magicka = GetVariableValue(C,"wearer::magicka(R)") > tonumber(GetConfigVar(C,"minMagicka","0.0"))
    local loc_health  = GetVariableValue(C,"wearer::health(R)")  > tonumber(GetConfigVar(C,"minHealth","0.0"))
    return loc_stamina and loc_magicka and loc_health
end

function CheckMinStatsHelper(C)
    local loc_stamina = loc_stamina and (GetVariableValue(C,"helper::stamina(R)") > tonumber(GetConfigVar(C,"minStamina","0.0")))
    local loc_magicka = loc_magicka and (GetVariableValue(C,"helper::magicka(R)") > tonumber(GetConfigVar(C,"minMagicka","0.0")))
    local loc_health  = loc_health  and (GetVariableValue(C,"helper::health(R)")  > tonumber(GetConfigVar(C,"minHealth","0.0")))
    return loc_stamina and loc_magicka and loc_health
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
    
    if UseHelper(C) then
        CallPapyrusFunction(C,"thisdevice::Lua_ReadyMinigame","OnMinigameReady",{"actor",C['Helper']})
    else
        CallPapyrusFunction(C,"thisdevice::Lua_ReadyMinigame","OnMinigameReady",{"actor",nil})
    end
    
    -- Ready local minigame variables
    SetMinigameVar(C,'TimerExpr',0.0)
    SetMinigameVar(C,'PauseDrain',false)
    
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
    if not GetMinigameVar(C,"PauseDrain") then
        local loc_drains = GetMinigameVar(C,'StatDrain')
        DamageStats(C,loc_drains['Stamina']*delta,loc_drains['Health']*delta,loc_drains['Magicka']*delta)
        -- Check if actors have enough stats
        if not CheckStats(C,StrToBool(GetConfigVar(C,"CheckStamina","true")),StrToBool(GetConfigVar(C,"CheckHealth","true")),StrToBool(GetConfigVar(C,"CheckMagicka","true"))) then
            StopDeviceMinigame(C)
            return
        end
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
        if UseHelper(C) then
            CallPapyrusFunction(C,"thisdevice::Lua_UpdateMinigameExpression","",{"actor",C['Helper']})
        else
            Log("Updating expression")
            CallPapyrusFunction(C,"thisdevice::Lua_UpdateMinigameExpression","",{"actor",nil})
        end
    end
end

function OnStop(C)
    Log("OnStop called")
    CloseMinigameUI(C)
    if UseHelper(C) then
        CallPapyrusFunction(C,"thisdevice::Lua_StopMinigame","",{"actor",C['Helper']})
    else
        CallPapyrusFunction(C,"thisdevice::Lua_StopMinigame","",{"actor",nil})
    end
    UpdateVariableValue(C,"thisdevice::_MinigameMainLoopON(A)",false)
end

-- Called after Papyrus finish the ready stage (start animation, expressions, etc...)
function OnMinigameReady(C)
    Log("OnMinigameReady")
    DisableRegen(C)
    OpenUI(C)
end

function OpenUI(C)
    -- Open UI
    if (PlayerInMinigame(C) and UseHelper(C)) or ActorIsPlayer(C['Wearer']) then
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

function SaveData(C)
    -- Store all data to be save in returned map
    local loc_res = {}
    loc_res = GetDataToSave(C,loc_res)
    return json.stringify(GetAllMinigameVars(C))
end

function LoadData(C,data)
    Log("LoadData called - "..data)
    local loc_data = json.parse(data)
    SetAllMinigameVar(C,loc_data)
    EnableRegen(C)
    DisableRegen(C)
    if UseHelper(C) then
        CallPapyrusFunction(C,"thisdevice::Lua_LoadMinigame","OnMinigameLoaded",{"actor",C['Helper']})
    else
        CallPapyrusFunction(C,"thisdevice::Lua_LoadMinigame","OnMinigameLoaded",{"actor",nil})
    end
end

function OnMinigameLoaded(C)
    Log("OnMinigameLoaded")
    OpenUI(C)
end

function RegisterCallbacks(C)
end

function ProcessMinigame(C,delta)
end

function ProcessMinigameNPC(C,delta)
end

function GetDataToSave(C,data)
    return data
end
