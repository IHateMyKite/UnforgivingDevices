
-- Check if minigame should be available for selected device
local _Precondition = Precondition -- Save previous function
function Precondition(C)
    local loc_res = _Precondition()
    if loc_res then
        local loc_locks = GetVariableValue(C,"thisdevice::UD_LockList(A)")
        if loc_locks['n'] > 0 then
            for i = 0, loc_locks['n']-1, 1
            do
                if IsLockLockpickable(C,loc_locks[i]) then
                    loc_res = true
                end
            end
        end
    end
    return loc_res
end

-- Check if actor can struggle or if other conditions are met
local _Condition = Condition -- Save previous function
function Condition(C)
    local loc_res = _Condition(C)
    -- Additional logic
    local loc_lockpick = GetGameForm(0x0000000A,"Skyrim.esm")
    loc_res = loc_res and (GetItemCount(C['Wearer'],loc_lockpick) > 0)
    return loc_res
end

-- If lock should be selectable in context menu in Device Menu
function IsLockSelectable(C,lock)
    return IsLockLockpickable(C,lock) and not IsLockUnlocked(C,lock)
end

function OnLockAccessed(C)
    CallPapyrusFunction(C,"thisdevice::Lua_StartLockpickMinigame","OnLockpickMinigameOver",{"int",tonumber(C['Context'])})
end

function OnLockpickMinigameOver(C,res)
    Log("OnLockpickMinigameOver - Result = "..tostring(res))
    
    if res == 1 then
        UnlockLock(C)
    else
        StopDeviceMinigame(C)
    end
end