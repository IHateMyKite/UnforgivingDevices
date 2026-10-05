
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
local _OnStart = OnStart -- Save previous function
function OnStart(C)
    
    _OnStart(C)
    
    local loc_lock   = GetSelectedLock(C)
    local loc_devacc = GetDeviceAccessibility(C,true)
    local loc_locacc = GetLockAccesibility(C,loc_lock)
    
    if WornHasKeyword(C['Wearer'],"zad_DeviousBlindfold") and (not UseHelper(C) or WornHasKeyword(C['Helper'],"zad_DeviousBlindfold")) then
        Log("OnStart(AccessLock.lua) - Wearer uses blindfold, reducing accessibility")
        loc_locacc = loc_locacc*0.5
    end
    
    Log("Lock accessibility -> "..tostring(loc_locacc))
    Log("Device accessibility -> "..tostring(loc_devacc))
    
    local loc_accmult = 1.0/loc_devacc
    
    Log("Speed multiplier -> "..tostring(loc_accmult))
    
    SetMinigameVar(C,"CursorDir",0)
    SetMinigameVar(C,"ZoneSize",tonumber(GetConfigVar(C,"ZoneSize","0.1")))
    SetMinigameVar(C,"CursorSize",35)
    SetMinigameVar(C,"CursorSpeed",tonumber(GetConfigVar(C,"BaseSpeed","600.0"))*loc_accmult)
    SetMinigameVar(C,"ZoneScale",Clamp(tonumber(loc_locacc),0.5,1.0))
    SetMinigameVar(C,"Multiplier",1.0)
    SetMinigameVar(C,"LockPosX",200)
    SetMinigameVar(C,"LockPosY",140)
    SetMinigameVar(C,"FocusRate",tonumber(GetConfigVar(C,"FocusRate",75.0)))
    SetMinigameVar(C,"FocusSpeedMult",tonumber(GetConfigVar(C,"FocusSpeedMult",0.15)))
    SetMinigameVar(C,"Focus",SetMinigameVar(C,"FocusMax",100))
    SetMinigameVar(C,"Focusing",false)
    
    --Log("OnStart")
    
    local loc_pos = {}
    loc_pos['x'] = 20.0 + 360.0*math.random()
    loc_pos['y'] = 20.0 + 360.0*math.random()
    SetMinigameVar(C,"CursorPos",loc_pos)
    
    UpdateSpeed(C,true)
end

function UpdateSpeed(C,rotate)
    local loc_vec = {}
    loc_vec['x'] = GetMinigameVar(C,"CursorSpeed")
    loc_vec['y'] = GetMinigameVar(C,"CursorSpeed")
    if rotate then
        RotateVec(loc_vec,2.0*math.pi*math.random())
    end
    SetMinigameVar(C,"CursorVector",loc_vec)
end

local _RegisterCallbacks = RegisterCallbacks
function RegisterCallbacks(C)
    _RegisterCallbacks(C)
    RegisterActionCallback(C,"press_left","Click","Reach lock")
    RegisterActionCallback(C,"press_right","Click","Reach lock")
    RegisterActionCallback(C,"press_middle","Focus","Focus")
end

local _OnUIOpen = OnUIOpen
function OnUIOpen(C)
    local loc_vars = _OnUIOpen(C)
    local loc_pos_x = GetConfigVar(C,"PosX","nan")
    
    loc_vars["scalezone"] = GetMinigameVar(C,"ZoneScale")
    loc_vars["scalecursor"] = GetMinigameVar(C,"ZoneScale")
    
    GetMinigameVar(C,"ZoneScale")
    return loc_vars
end

function Click(C,eventtype)
    if eventtype == 1 then
        return
    end
    if IsCursorInZone(C) then
        ClickSuccess(C)
    else
        ClickFail(C)
    end
end

function Focus(C,eventtype)
    Log("Focus() -> "..tostring(eventtype))
    if eventtype == 0 then
        ChangeFocus(C,true)
    elseif eventtype == 1 then
        ChangeFocus(C,false)
    end
end

function ChangeFocus(C,val)
    Log("ChangeFocus called")
    local loc_speed = GetMinigameVar(C,"CursorVector")
    local loc_focusing = GetMinigameVar(C,"Focusing")
    local loc_focusemult = GetMinigameVar(C,"FocusSpeedMult")
    
    if val == true and not loc_focusing then
        loc_speed['x'] = loc_speed['x']*loc_focusemult
        loc_speed['y'] = loc_speed['y']*loc_focusemult
        SetMinigameVar(C,"Focusing",true)
        SetMinigameVar(C,"CursorVector",loc_speed)
        Log("Focusing ON")
    elseif loc_focusing then
        loc_speed['x'] = loc_speed['x']/loc_focusemult
        loc_speed['y'] = loc_speed['y']/loc_focusemult
        SetMinigameVar(C,"Focusing",false)
        SetMinigameVar(C,"CursorVector",loc_speed)
        Log("Focusing OFF")
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
        local loc_drains = GetMinigameVar(C,'StatDrain')
        DamageStats(C,loc_drains['Stamina']*0.5,loc_drains['Health']*0.5,loc_drains['Magicka']*0.5)
    end
end

function ProcessMinigame(C,delta)
    local loc_focusing      = GetMinigameVar(C,"Focusing")
    local loc_focuserate    = GetMinigameVar(C,"FocusRate")
    
    local loc_focus = 0.0
    if loc_focusing then
        loc_focus = UpdateMinigameVar(C,'Focus',-1*loc_focuserate*delta)
    else
        loc_focus = UpdateMinigameVar(C,'Focus',0.5*loc_focuserate*delta)
    end
    -- Update focus so its always in range
    loc_focus = SetMinigameVar(C,"Focus",Clamp(loc_focus,0.0,GetMinigameVar(C,"FocusMax")))
    
    if loc_focus == 0.0 then
        ChangeFocus(C,false)
    end
    
    UpdateCursorPosition(C,delta)
    
    return true
end

function IsLockUnlocked(C,lock)
    local loc_unlocked = (lock) & 0x01
    return loc_unlocked == 0x01
end

function IsLockLockpickable(C,lock)
    local loc_diff = (lock >> 15) & 0xFF
    return loc_diff <= 100 and loc_diff > 0
end

function GetLockAccesibility(C,lock)
    local loc_acc = ((lock >> 8) & 0x7F)/100.0
    return loc_acc
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
    local loc_lock = loc_locks[tonumber(C['Context'])]
    --Log("GetSelectedLock - "..tostring(loc_lock))
    return loc_lock
end

function UnlockLock(C)
    --Log("UnlockLock called for lock "..tostring(C['Context']))
    CallPapyrusFunction(C,"thisdevice::UnlockNthLock","OnLockUnlocked",{"int",tonumber(C['Context'])},{"bool",true})
    return loc_lock
end

function OnLockUnlocked(C,res)
    --Log("OnLockUnlocked")
    
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
    
    local loc_size = GetMinigameVar(C,"CursorSize")
    local loc_posX = GetMinigameVar(C,"LockPosX")
    local loc_posY = GetMinigameVar(C,"LockPosY")
    
    local loc_scale = GetMinigameVar(C,"ZoneScale")
    if (PointInCircle(loc_posX,loc_posY,70*loc_scale,loc_pos['x'],loc_pos['y'])) or PointInRectangle(loc_posX,loc_posY + 100*loc_scale,80*loc_scale,160*loc_scale,loc_pos['x'],loc_pos['y']) then
        return true
    end
    return false
end

function UpdateCursorPosition(C,delta)
    local loc_pos = GetMinigameVar(C,"CursorPos")
    local loc_vec = GetMinigameVar(C,"CursorVector")
    loc_pos['x'] = loc_pos['x'] + loc_vec['x']*delta
    loc_pos['y'] = loc_pos['y'] + loc_vec['y']*delta
    
    UpdateCursor(C,loc_pos,loc_vec)
    
    SetMinigameVar(C,"CursorPos",loc_pos)
    SetMinigameVar(C,"CursorVector",loc_vec)
    
    local loc_focus     = GetMinigameVar(C,"Focus")
    local loc_focusMax  = GetMinigameVar(C,"FocusMax")
    local loc_focusr = loc_focus/loc_focusMax
    
    local loc_payload = "Update({"
    loc_payload = loc_payload.."x:\""..tostring((loc_pos['x']/400)*100).."%\","
    loc_payload = loc_payload.."y:\""..tostring((loc_pos['y']/400)*100).."%\","
    loc_payload = loc_payload.."in:"..BoolToInt(IsCursorInZone(C))..","
    loc_payload = loc_payload.."foc:"..tostring(loc_focusr)..","
    loc_payload = loc_payload.."})"
    
    InvokeMinigameUI(C,loc_payload)
end
