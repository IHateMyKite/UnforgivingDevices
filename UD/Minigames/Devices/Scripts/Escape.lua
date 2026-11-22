
-- Check if minigame should be available for selected device
local _Precondition = Precondition -- Save previous function
function Precondition(C)
    return _Precondition(C) and GetVariableValue(C,"thisdevice::UD_Manipulated(A)") == true
end

-- Called when minigame starts
function OnStart(C)
    InitMinigameVars(C)
    CallPapyrusFunction(C,"thisdevice::unlockRestrain","",{"bool",false},{"bool",false},{"bool",false})
    StopMinigame(C)
end

function GetContext(C)
    return ""
end
