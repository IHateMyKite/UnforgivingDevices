
-- Check if minigame should be available for selected device
local _Precondition = Precondition -- Save previous function
function Precondition(C)
    local loc_res = _Precondition(C)
    if loc_res then
        local loc_locks = GetVariableValue(C,"thisdevice::UD_LockList(A)")
        if loc_locks['n'] > 0 then
            loc_res = true
        else
            loc_res = false
        end
    end
    return loc_res
end

-- Check if actor can struggle or if other conditions are met
local _Condition = Condition -- Save previous function
function Condition(C)
    local loc_res = _Condition(C) and GetDeviceAccessibility(C,false) > 0.0
    -- Additional logic
    local loc_key = GetVariableValue(C,"thisdevice::zad_deviceKey(A)")
    loc_res = loc_res and (GetItemCount(C['Wearer'],loc_key) > 0)
    return loc_res
end

-- If lock should be selectable in context menu in Device Menu
function IsLockSelectable(C,lock)
    return not IsLockUnlocked(C,lock)
end

function OnLockAccessed(C)
    SetMinigameVar(C,"PauseDrain",true)
    UnlockLock(C)
    --CallPapyrusFunction(C,"thisdevice::Lua_StartLockpickMinigame","OnLockpickMinigameOver",{"int",tonumber(C['Context'])})
end
