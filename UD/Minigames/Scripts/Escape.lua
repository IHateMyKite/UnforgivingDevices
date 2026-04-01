
-- Check if minigame should be available for selected device
function Precondition(C)
    return GetVariableValue(C,"thisdevice::UD_Manipulated(A)") == true
end

-- Called when minigame starts
function OnStart(C)
    InitMinigameVars(C)
    CallPapyrusFunction(C,"thisdevice::unlockRestrain","",{"bool",false},{"bool",false},{"bool",false})
    StopMinigame(C)
end
