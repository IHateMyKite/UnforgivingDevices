
-- Check if minigame should be available for selected device
function Precondition(C)
    return true
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
    local loc_res = ""
    local loc_locks         = GetVariableValue(C,"thisdevice::UD_LockList(A)")
    local loc_locksNames    = GetVariableValue(C,"thisdevice::UD_LockNameList(A)")
    if loc_locks['n'] > 0 then
        loc_res = "["
        for i = 0, loc_locks['n']-1, 1
        do
            loc_res = loc_res.."{"
            loc_res = loc_res.."name:\""..loc_locksNames[i].."\","
            loc_res = loc_res.."value:\""..tostring(i).."\","
            
            if IsLockSelectable(C,loc_locks[i]) then
                loc_res = loc_res.."state:1"
            else
                loc_res = loc_res.."state:0"
            end
            
            loc_res = loc_res.."}"
            
            if i ~= (loc_locks['n']-1) then
                loc_res = loc_res..","
            end
            
        end
        loc_res = loc_res.."]"
    end
    return loc_res
end

-- Should be overwriten by other script
function IsLockSelectable(C,lock)
    return true
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
    
    SetMinigameVar(C,"CursorDir",0)
    SetMinigameVar(C,"ZoneSize",tonumber(GetConfigVar(C,"ZoneSize","0.1")))
    SetMinigameVar(C,"CursorSize",40)
    SetMinigameVar(C,"CursorSpeed",tonumber(GetConfigVar(C,"BaseSpeed","100.0")))
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"LockPosX",200)
    SetMinigameVar(C,"LockPosY",140)
    
    Log("OnStart")
    
    local loc_pos = {}
    loc_pos['x'] = 20.0 + 360.0*math.random()
    loc_pos['y'] = 20.0 + 360.0*math.random()
    SetMinigameVar(C,"CursorPos",loc_pos)
    
    local loc_vec = {}
    loc_vec['x'] = 600.0
    loc_vec['y'] = 600.0
    RotateVec(loc_vec,2.0*math.pi*math.random())
    SetMinigameVar(C,"CursorVector",loc_vec)
end

-- Called on every player update frame
-- Is not called while in menu mode
function OnUpdate(C,delta)
    -- Log("OnUpdate called")
    -- Check if minigame is already ready
    if not GetMinigameVar(C,"Ready") then
        return
    end
    
    if GetMinigameVar(C,"MinigamePaused") then
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
        -- TODO: NPC support
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
    SetMinigameVar(C,'Ready',true)
end

function ClickLeft(C)
    if IsCursorInZone(C) then
        ClickSuccess(C)
    else
        ClickFail(C)
    end
end

function ClickSuccess(C)
    if not GetMinigameVar(C,"MinigamePaused") then
        SetMinigameVar(C,"MinigamePaused",true)
        CloseMinigameUI(C)
        OnLockAccessed(C)
    end
end

function OnLockAccessed(C)
end

function ClickFail(C)
    if not GetMinigameVar(C,"MinigamePaused") then
        -- TODO: Penalize player
    end
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
    UpdateCursorPosition(C,delta)
    --InvokeUI(C,"SetZones({zonesize:"..tostring(loc_zonesize*(1.0 - loc_combo*loc_zonesizerecution)).."})")
    --InvokeUI(C,"UpdateMinigame({dur:"..tostring(loc_durability_r)..",cond:"..tostring(loc_condition_r)..",pos:"..tostring(loc_pos).."})")
end

function IsLockUnlocked(C,lock)
    local loc_unlocked = (lock) & 0x01
    return loc_unlocked == 0x01
end

function IsLockLockpickable(C,lock)
    local loc_diff = (lock >> 15) & 0xFF
    return loc_diff <= 100 and loc_diff > 0
end

function IsAllLocksUnlocked(C)
    local loc_res = true
    local loc_locks = GetVariableValue(C,"thisdevice::UD_LockList(A)")
    for i = 0, loc_locks['n']-1, 1
    do
        loc_res = loc_res and IsLockUnlocked(C,loc_locks[i])
    end
    return loc_res
end

function GetSelectedLock(C)
    local loc_locks = GetVariableValue(C,"thisdevice::UD_LockList(A)")
    local loc_lock = loc_locks[C['Context']]
    Log("GetSelectedLock - "..tostring(loc_lock))
    return loc_lock
end

function UnlockLock(C)
    Log("UnlockLock called for lock "..tostring(C['Context']))
    CallPapyrusFunction(C,"thisdevice::UnlockNthLock","OnLockUnlocked",{"int",tonumber(C['Context'])},{"bool",true})
    return loc_lock
end

function OnLockUnlocked(C,res)
    Log("OnLockUnlocked")
    
    if res then
        Log("Checking if all locks are unlocked")
        if IsAllLocksUnlocked(C) then
            Log("All locks are unlocked. Unlocking device")
            CallPapyrusFunction(C,"thisdevice::unlockRestrain","",{"bool",false},{"bool",false},{"bool",false})
        end
    end
    
    StopDeviceMinigame(C)
end

-------------------
-- Cursor movement
-------------------

function UpdateCursor(C,pos,vec)
    local loc_ref = false
    
    local loc_size = GetMinigameVar(C,"CursorSize")
    
    if pos['x'] > 400.0-loc_size/2 then
        pos['x'] = 400.0-loc_size/2;
        loc_ref = true;
    end
    
    if pos['y'] > 400.0-loc_size/2 then
        pos['y'] = 400.0-loc_size/2;
        loc_ref = true;
    end
    
    if pos['x'] < loc_size/2 then
        pos['x'] = loc_size/2;
        loc_ref = true;
    end
    
    if pos['y'] < loc_size/2 then
        pos['y'] = loc_size/2;
        loc_ref = true;
    end
    
    if loc_ref then
        ReflectCursorVec(vec);
    end
end

function ReflectCursorVec(vec)
    local loc_angle = math.pi/2 + (math.pi/4 - math.pi/2*math.random())
    RotateVec(vec,loc_angle)
end

function RotateVec(vec,angle)
    local loc_vecX = vec['x']
    local loc_vecY = vec['y']
    vec['x'] = loc_vecX*math.cos(angle) - loc_vecY*math.sin(angle);
    vec['y'] = loc_vecX*math.sin(angle) + loc_vecY*math.cos(angle);
end

function IsCursorInZone(C)
    local loc_pos = GetMinigameVar(C,"CursorPos")
    local loc_inzone = false
    
    local loc_size = GetMinigameVar(C,"CursorSize")
    local loc_posX = GetMinigameVar(C,"LockPosX")
    local loc_posY = GetMinigameVar(C,"LockPosY")
    
    if  loc_pos['x'] + loc_size/2 > (loc_posX - 70.0) and loc_pos['x'] - loc_size/2 < (loc_posX + 70) and  -- X
        loc_pos['y'] + loc_size/2 > (loc_posY - 70.0) and loc_pos['y'] - loc_size/2 < (loc_posY + 70) then -- Y
        loc_inzone = true
    end
    if  loc_pos['x'] + loc_size/2 > (loc_posX - 40.0)       and loc_pos['x'] - loc_size/2 < (loc_posX + 40.0)         and   -- X
        loc_pos['y'] + loc_size/2 > (loc_posY + 100 - 80.0) and loc_pos['y'] - loc_size/2 < (loc_posY + 100 + 80.0)   then  -- Y
        loc_inzone = true
    end
    
    return loc_inzone
end

function UpdateCursorPosition(C,delta)
    local loc_pos = GetMinigameVar(C,"CursorPos")
    local loc_vec = GetMinigameVar(C,"CursorVector")
    loc_pos['x'] = loc_pos['x'] + loc_vec['x']*delta
    loc_pos['y'] = loc_pos['y'] + loc_vec['y']*delta
    
    UpdateCursor(C,loc_pos,loc_vec)
    
    SetMinigameVar(C,"CursorPos",loc_pos)
    SetMinigameVar(C,"CursorVector",loc_vec)
    
    local loc_payload = "UpdateCursorPosition({"
    loc_payload = loc_payload.."x:"..tostring(loc_pos['x'])..","
    loc_payload = loc_payload.."y:"..tostring(loc_pos['y'])..","
    loc_payload = loc_payload.."size:"..tostring(GetMinigameVar(C,"CursorSize"))..","
    loc_payload = loc_payload.."in:"..BoolToInt(IsCursorInZone(C))..","
    loc_payload = loc_payload.."zonex:"..tostring(GetMinigameVar(C,"LockPosX"))..","
    loc_payload = loc_payload.."zoney:"..tostring(GetMinigameVar(C,"LockPosY"))..","
    loc_payload = loc_payload.."zonescale:"..tostring(1.0)
    loc_payload = loc_payload.."})"
    
    InvokeUI(C,loc_payload)
end
