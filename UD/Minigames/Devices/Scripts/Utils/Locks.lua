
function GetLocks(C)
    return json.iparse(GetVariableValue(C,"thisdevice::UD_LocksJson(A)"))
end

function IsLockUnlocked(C,lock)
    if lock['unl'] ~= nil then
        return StrToBool(lock['unl'])
    else
        return false
    end
end

function IsLockLockpickable(C,lock)
    local loc_diff = 0
    if lock['diff'] ~= nil then
        loc_diff = tonumber(lock['diff'])
    end
    return loc_diff <= 100 and loc_diff >= 0
end

function GetLockAccesibility(C,lock)
    local loc_acc = 0.0
    if lock['acc'] ~= nil then
        loc_acc = tonumber(lock['acc'])/100.0
    end
    return loc_acc
end

function IsAllLocksUnlocked(C)
    local loc_res = true
    local loc_locks = GetLocks(C)
    local loc_count = tonumber(loc_locks['n'])
    if loc_count then
        for i = 0, loc_count-1, 1
        do
            loc_res = loc_res and IsLockUnlocked(C,loc_locks[tostring(i)])
        end
    end
    return loc_res
end

function GetLockMultiplier(C,maxincrease)
    local loc_res = 1.0
    local loc_locks = GetLocks(C)
    local loc_count = tonumber(loc_locks['n'])
    if loc_count and loc_count > 0 then
        for i = 0, loc_count-1, 1 do
            if IsLockUnlocked(C,loc_locks[tostring(i)]) then
                loc_res = loc_res + maxincrease/loc_count
            end
        end
    end
    return loc_res
end

function IsAnyLockAccessible(C)
    local loc_res = false
    local loc_locks = GetLocks(C)
    local loc_count = tonumber(loc_locks['n'])
    if loc_count then
        for i = 0, loc_count-1, 1
        do
            loc_res = loc_res or GetLockAccesibility(C,loc_locks[tostring(i)]) > 0
        end
    end
    return loc_res
end
