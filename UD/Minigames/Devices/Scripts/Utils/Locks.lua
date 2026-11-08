
function IsLockUnlocked(C,lock)
    return StrToBool(lock['unl'])
end

function IsLockLockpickable(C,lock)
    local loc_diff = tonumber(lock['diff'])
    return loc_diff <= 100 and loc_diff > 0
end

function GetLockAccesibility(C,lock)
    local loc_acc = tonumber(lock['acc'])/100.0
    return loc_acc
end

function IsAllLocksUnlocked(C)
    local loc_res = true
    local loc_locks = json.iparse(GetVariableValue(C,"thisdevice::UD_LocksJson(A)"))
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
    local loc_locks = json.iparse(GetVariableValue(C,"thisdevice::UD_LocksJson(A)"))
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
