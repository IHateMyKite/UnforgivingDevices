
-- Check if minigame should be available for selected device
function Precondition(C)
    return GetVariableValue(C,"thisdevice::UD_Manipulated(A)") == true
end

-- Check if actor can struggle or if other conditions are met
function Condition(C)
    return true
end

-- Called when minigame starts
function OnStart(C)
    InitMinigameVars(C)
    CallPapyrusFunction(C,"thisdevice::unlockRestrain","",{"bool",false},{"bool",false},{"bool",false})
    StopMinigame(C)
end

-- Called on every player update frame
-- Is not called while in menu mode
function OnUpdate(C,delta)
end
