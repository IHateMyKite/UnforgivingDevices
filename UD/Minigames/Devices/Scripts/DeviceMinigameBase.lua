
-- Check if minigame should be available for selected device
function Precondition(C)
    return not StrToBool(GetConfigVar(C,"Disabled","false")) and CheckTags(C)
end

-- Check if actor can struggle or if other conditions are met
function Condition(C)
    return CheckMinStatsWearer(C) and (not UseHelper(C) or CheckMinStatsHelper(C)) and (not StrToBool(GetConfigVar(C,"CheckAccessibility","true")) or GetDeviceAccessibility(C,true) > 0.0)
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
    
    SetMinigameVar(C,'Ready',false)
    SetMinigameVar(C,"Running",false)
    
    UpdateVariableValue(C,"thisdevice::_PauseMinigame(A)",false)
    UpdateVariableValue(C,"thisdevice::_StopMinigame(A)",false)
    UpdateVariableValue(C,"thisdevice::_MinigameMainLoopON(A)",true)
    
    if UseHelper(C) then
        CallPapyrusFunction(C,"MINM::ReadyDeviceMinigame","OnMinigameReady",{"object",C['DeviceObj']},{"actor",C['Helper']})
    else
        CallPapyrusFunction(C,"MINM::ReadyDeviceMinigame","OnMinigameReady",{"object",C['DeviceObj']},{"actor",nil})
    end
    
    -- Ready local minigame variables
    SetMinigameVar(C,'TimerExpr',0.0)
    SetMinigameVar(C,'PauseDrain',false)
    SetMinigameVar(C,'TimerSkill',0.0)
    SetMinigameVar(C,'SkillGain',tonumber(GetConfigVar(C,"SkillGain","10.0")))
    SetMinigameVar(C,"SkillMult",GetMinigameSkillMult(C))
    SetMinigameVar(C,'UseNoUI',StrToBool(GetConfigVar(C,"UseNoUI","false")))
    SetMinigameVar(C,"AutoMode",StrToBool(GetConfigVar(C,"AutoMode","false")))
    SetMinigameVar(C,"AutoModeTimer",SetMinigameVar(C,"AutoModeBase",tonumber(GetSaveConfig("Minigames.AutoModePauseTime","0.25"))))
    SetMinigameVar(C,"UseShaders",StrToBool(GetConfigVar(C,"UseShaders","true")) and not GetMinigameVar(C,"AutoMode"))
    
    SetMinigameVar(C,"Hints",StrToBool(GetConfigVar(C,"Hints","true")))
    SetMinigameVar(C,"ShowActions",StrToBool(GetConfigVar(C,"ShowActions","true")))
    SetMinigameVar(C,"PosX",GetConfigVar(C,"PosX","50"))
    SetMinigameVar(C,"PosY",GetConfigVar(C,"PosY","65"))
    SetMinigameVar(C,"Scale",GetConfigVar(C,"Scale","1.0"))
    SetMinigameVar(C,"Visibility",tonumber(GetConfigVar(C,"Visibility","1.0")))
    
    Log("SkillMult -> "..tostring(GetMinigameVar(C,"SkillMult")))
    
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
        if not CheckStats(C,true,true,true) then
            StopDeviceMinigame(C)
            return
        end
    end
    
    if PlayerInMinigame(C) then
        if not ProcessMinigame(C,delta) then
            return
        end
        UpdateSkill(C,delta)
    end
    
    -- Update expression once in the while
    local loc_time = UpdateMinigameVar(C,'TimerExpr',-1.0*delta)
    if loc_time <= 0.0 then
        SetMinigameVar(C,'TimerExpr',5.0)
        if UseHelper(C) then
            CallPapyrusFunction(C,"MINM::UpdateMinigameExpression","",{"object",C['DeviceObj']},{"actor",C['Helper']})
        else
            --Log("Updating expression")
            CallPapyrusFunction(C,"MINM::UpdateMinigameExpression","",{"object",C['DeviceObj']},{"actor",nil})
        end
    end
end

function OnStop(C)
    Log("OnStop called")
    EnableRegen(C)
    CloseMinigameUI(C)
    if UseHelper(C) then
        CallPapyrusFunction(C,"MINM::StopDeviceMinigame","",{"object",C['DeviceObj']},{"actor",C['Helper']})
    else
        CallPapyrusFunction(C,"MINM::StopDeviceMinigame","",{"object",C['DeviceObj']},{"actor",nil})
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
    if PlayerInMinigame(C) and GetMinigameVar(C,'UseNoUI') then
        UIOpen(C)
    elseif PlayerInMinigame(C) then
        OpenMinigameUI(C,"UIOpen")
    else
        SetMinigameVar(C,'Ready',true)
        SetMinigameVar(C,"Running",true)
    end
end

-- Called after PrismaUI minigame object is open
function UIOpen(C)
    Log("UIOpen")
    -- Register actions
    RegisterCallbacks(C)
    
    local loc_payload = OnUIOpen(C)
    
    loc_payload["pos_x"] = GetMinigameVar(C,"PosX").."%"
    loc_payload["pos_y"] = GetMinigameVar(C,"PosY").."%"
    loc_payload["scale"] = GetMinigameVar(C,"Scale")
    loc_payload["visibility"] = GetMinigameVar(C,"Visibility")
    loc_payload["hints"]    = GetMinigameVar(C,"Hints")
    
    if GetMinigameVar(C,"ShowActions") then
        loc_payload['actions']  = GetRegisteredActions(C)
    end
    
    local loc_msg = "Init("..json.stringify(loc_payload)..")"
    Log("UIOpen(MinigameBase.lua) Invoking msg -> "..loc_msg)
    InvokeMinigameUI(C,loc_msg)
    
    SetMinigameVar(C,'Ready',true)
    SetMinigameVar(C,"Running",true)
    Log("Minigame ready")
end

function OnUIOpen(C)
    return {}
end

function StopDeviceMinigame(C,eventtype)
    if eventtype == 1 then
        return
    end
    Log("StopDeviceMinigame called")
    StopMinigame(C)
end

function PlayerInMinigame(C)
    if ActorIsPlayer(C['Wearer']) or (ActorIsPlayer(C['Helper']) and UseHelper(C)) then
        return true
    else
        return false
    end
end

function UpdateSkill(C,delta)
    local loc_skillgain = GetMinigameVar(C,"SkillGain")
    if loc_skillgain > 0 then
        local loc_skilltime = UpdateMinigameVar(C,'TimerSkill',-1.0*delta)
        if loc_skilltime <= 0.0 then
            AdvanceMinigameSkill(C,GetMinigameVar(C,"SkillGain"))
            SetMinigameVar(C,'TimerSkill',1.0)
        end
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
        CallPapyrusFunction(C,"MINM::LoadDeviceMinigame","OnMinigameLoaded",{"object",C['DeviceObj']},{"actor",C['Helper']})
    else
        CallPapyrusFunction(C,"MINM::LoadDeviceMinigame","OnMinigameLoaded",{"object",C['DeviceObj']},{"actor",nil})
    end
end

function OnMinigameLoaded(C)
    Log("OnMinigameLoaded")
    OpenUI(C)
end

function RegisterCallbacks(C)
    Log("RegisterCallbacks(MinigameBase.lua)")
    RegisterActionCallback(C,"press_stop","StopDeviceMinigame","Stop Minigame")
end

function ProcessMinigame(C,delta)
    return true
end

function GetDataToSave(C,data)
    return data
end

function PlayShader(C,color)
    if color == "green" then
        CallPapyrusFunction(C,"MINM::PlayGreenShader","",{"actor",C['Wearer']},{"actor",C['Helper']})
    elseif color == "red" then
        CallPapyrusFunction(C,"MINM::PlayRedShader","",{"actor",C['Wearer']},{"actor",C['Helper']})
    elseif color == "blue" then
        CallPapyrusFunction(C,"MINM::PlayBlueShader","",{"actor",C['Wearer']},{"actor",C['Helper']})
    end
end