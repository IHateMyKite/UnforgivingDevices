
-- Check if minigame should be available for selected device
function Precondition(C)
    return not StrToBool(GetConfigVar(C,"Disabled","false"))
end

-- Check if actor can struggle or if other conditions are met
function Condition(C)
    return CheckMinStatsActor(C) and (not UseHelperCond(C) or CheckMinStatsHelper(C))
end

function GetContext(C)
    local loc_res = ""
    if ActorIsPlayer(C['Helper']) then
        -- TODO: Check if NPC can be commanded
        local loc_actor     = CheckMinStatsActor(C)
        local loc_helper    = CheckMinStatsHelper(C)
        
        loc_res = loc_res.."["
        if loc_actor then
            loc_res = loc_res.."{\"name\":\"Command\",\"value\":\"command\",\"state\":1},"
        else
            loc_res = loc_res.."{\"name\":\"Command\",\"value\":\"command\",\"state\":0},"
        end

        if loc_actor and loc_helper then
            loc_res = loc_res.."{\"name\":\"Help\",\"value\":\"help\",\"state\":1}"
        else
            loc_res = loc_res.."{\"name\":\"Help\",\"value\":\"help\",\"state\":0}"
        end

        loc_res = loc_res.."]"
    end
    return loc_res
end

-- Called when minigame starts
function OnStart(C)
    Log("OnStart(ActorMinigameBase.lua)")
    InitMinigameVars(C)
    
    SetMinigameVar(C,'Ready',false)
    SetMinigameVar(C,"Running",false)
    
    if (not C['Context'] or C['Context'] == "" or C['Context'] == "help") and not IsNull(C['Helper']) then
        Log("Setting minigame to Helping")
        SetMinigameVar(C,"Helping",true)
    else
        SetMinigameVar(C,"Helping",false)
    end
    
    if UseHelper(C) then
        CallPapyrusFunction(C,"MINM::ReadyActorMinigame","OnMinigameReady",{"actor",C['Actor']},{"actor",C['Helper']})
    else
        CallPapyrusFunction(C,"MINM::ReadyActorMinigame","OnMinigameReady",{"actor",C['Actor']},{"actor",nil})
    end
    
    -- Ready local minigame variables
    SetMinigameVar(C,'TimerExpr',0.0)
    SetMinigameVar(C,'PauseDrain',false)
    SetMinigameVar(C,'TimerSkill',0.0)
    SetMinigameVar(C,'SkillGain',tonumber(GetConfigVar(C,"SkillGain","10.0"))*tonumber(GetConfigVar(C,"SkillGainMult","1.0")))
    SetMinigameVar(C,"SkillMult",GetMinigameSkillMult(C))
    SetMinigameVar(C,'UseNoUI',StrToBool(GetConfigVar(C,"UseNoUI","false")))
    
    if PlayerInMinigame(C) then
        SetMinigameVar(C,"AutoMode",StrToBool(GetConfigVar(C,"AutoMode","false")))
    else
        SetMinigameVar(C,"AutoMode",true)
        Log("No player present -> Activating Auto Mode")
    end
    
    SetMinigameVar(C,"AutoModeTimer",SetMinigameVar(C,"AutoModeBase",tonumber(GetSaveConfig("Minigames.AutoModePauseTime","0.25"))))
    SetMinigameVar(C,"UseShaders",StrToBool(GetConfigVar(C,"UseShaders","true")) and not GetMinigameVar(C,"AutoMode"))
    SetMinigameVar(C,"Hints",StrToBool(GetConfigVar(C,"Hints","true")))
    SetMinigameVar(C,"ShowActions",StrToBool(GetConfigVar(C,"ShowActions","true")))
    SetMinigameVar(C,"PosX",GetConfigVar(C,"PosX","50"))
    SetMinigameVar(C,"PosY",GetConfigVar(C,"PosY","65"))
    SetMinigameVar(C,"Scale",GetConfigVar(C,"Scale","1.0"))
    SetMinigameVar(C,"Visibility",tonumber(GetConfigVar(C,"Visibility","1.0")))
    SetMinigameVar(C,"Multiplier",1.0)
    
    local loc_helpmult = 1.0
    if UseHelper(C) then
        loc_helpmult = GetConfigVar(C,"HelpMult","1.5")
    end
    SetMinigameVar(C,"Difficulty",loc_helpmult/(tonumber(GetConfigVar(C,"Difficulty","1.0"))*tonumber(GetConfigVar(C,"GlobalDifficulty","1.0"))))
    SetMinigameVar(C,"MultiplierConst",GetMinigameVar(C,"Difficulty")*GetMinigameVar(C,"SkillMult"))

    Log("SkillMult -> "..tostring(GetMinigameVar(C,"SkillMult")))
    
    -- Store drains from config for faster access
    StoreConfigDrain(C)
end

-- Called on every player update frame
-- Is not called while in menu mode
function OnUpdate(C,delta)
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
            StopActorMinigame(C)
            return
        end
    end
    
    if not ProcessMinigame(C,delta) then
        return
    end
    
    if PlayerInMinigame(C) then
        UpdateSkill(C,delta)
    end
    
    -- Update expression once in the while
    local loc_time = UpdateMinigameVar(C,'TimerExpr',-1.0*delta)
    if loc_time <= 0.0 then
        SetMinigameVar(C,'TimerExpr',5.0)
        if UseHelper(C) then
            CallPapyrusFunction(C,"MINM::UpdateMinigameExpression","",{"actor",C['Actor']},{"actor",C['Helper']})
        else
            --Log("Updating expression")
            CallPapyrusFunction(C,"MINM::UpdateMinigameExpression","",{"actor",C['Actor']},{"actor",nil})
        end
    end
end

function OnStop(C)
    EnableRegen(C)
    CloseMinigameUI(C)
    if UseHelper(C) then
        CallPapyrusFunction(C,"MINM::StopActorMinigame","",{"actor",C['Actor']},{"actor",C['Helper']})
    else
        CallPapyrusFunction(C,"MINM::StopActorMinigame","",{"actor",C['Actor']},{"actor",nil})
    end
end

-- Called after Papyrus finish the ready stage (start animation, expressions, etc...)
function OnMinigameReady(C)
    --Log("OnMinigameReady")
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
    --Log("UIOpen")
    -- Register actions
    RegisterCallbacks(C)
    
    local loc_payload = OnUIOpen(C)
    
    loc_payload["pos_x"] = GetMinigameVar(C,"PosX").."%"
    loc_payload["pos_y"] = GetMinigameVar(C,"PosY").."%"
    loc_payload["scale"] = GetMinigameVar(C,"Scale")
    loc_payload["visibility"]   = GetMinigameVar(C,"Visibility")
    loc_payload["hints"]        = GetMinigameVar(C,"Hints")
    loc_payload["fps"]          = tonumber(GetConfigVar(C,"Fps","60"))
    
    if GetMinigameVar(C,"ShowActions") then
        loc_payload['actions']  = GetRegisteredActions(C)
    end
    
    local loc_msg = "Init("..json.stringify(loc_payload)..")"
    Log("UIOpen(MinigameBase.lua) Invoking msg -> "..loc_msg)
    InvokeMinigameUI(C,loc_msg)
    
    SetMinigameVar(C,'Ready',true)
    SetMinigameVar(C,"Running",true)
    --Log("Minigame ready")
end

function OnUIOpen(C)
    return {}
end

function StopActorMinigame(C,eventtype)
    if eventtype == 1 then
        return
    end
    --Log("StopActorMinigame called")
    StopMinigame(C)
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
        CallPapyrusFunction(C,"MINM::LoadDeviceMinigame","OnMinigameLoaded",{"actor",C['Actor']},{"actor",C['Helper']})
    else
        CallPapyrusFunction(C,"MINM::LoadDeviceMinigame","OnMinigameLoaded",{"actor",C['Actor']},{"actor",nil})
    end
end

function OnMinigameLoaded(C)
    Log("OnMinigameLoaded")
    OpenUI(C)
end

function RegisterCallbacks(C)
    Log("RegisterCallbacks(ActorMinigameBase.lua)")
    RegisterActionCallback(C,"press_stop","StopActorMinigame","Stop Minigame")
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
