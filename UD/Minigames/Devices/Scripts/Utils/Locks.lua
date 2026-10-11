
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

function GetLockMultiplier(C,maxincrease)
    local loc_res = 1.0
    local loc_locks = GetVariableValue(C,"thisdevice::UD_LockList(A)")
    if loc_locks['n'] > 0 then
        for i = 0, loc_locks['n']-1, 1 do
            if IsLockUnlocked(C,loc_locks[i]) then
                loc_res = loc_res + maxincrease/loc_locks['n']
            end
        end
    end
    return loc_res
end
