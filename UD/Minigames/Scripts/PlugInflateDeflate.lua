
local _Precondition = Precondition -- Save previous function
function Precondition(C)
    Log("Precondition(Struggle.lua) called")
    local loc_inflatelvl = GetVariableValue(C,"thisdevice::_inflateLevel(A)")
    if tonumber(GetConfigVar(C,"Type","1")) == 1 then
        return _Precondition(C) and loc_inflatelvl < 5
    else
        return _Precondition(C) and loc_inflatelvl > 0
    end
end

-- Called when minigame starts
local _OnStart = OnStart -- Save previous function
function OnStart(C)
    Log("OnStart(PlugInflateDeflate.lua) called")
    
    InitMinigameVars(C)
    
    if SetMinigameVar(C,"Type",tonumber(GetConfigVar(C,"Type","0"))) == 1 then
        Log("Progress = "..tostring(SetMinigameVar(C,"Progress",GetVariableValue(C,"thisdevice::inflateprogress(A)"))))
    else
        Log("Progress = "..tostring(SetMinigameVar(C,"Progress",GetVariableValue(C,"thisdevice::deflateprogress(A)"))))
    end
    
    SetMinigameVar(C,"ProgressRate",5.0)
    SetMinigameVar(C,"PressureChange",tonumber(GetConfigVar(C,"PressureChange","1")))
    
    if SetMinigameVar(C,"Accessibility",tonumber(GetDeviceAccessibility(C,true))) >= 1.0 then
        InflateDeflatePlug(C)
        StopDeviceMinigame(C)
        return
    end
    
    SetMinigameVar(C,"ProgressMax",GetVariableValue(C,"thisdevice::UD_PumpDifficulty(A)"))
    
    _OnStart(C)
end

function OnHoldingZone(C,delta)
    local loc_prog = 0.0
    local loc_change = GetMinigameVar(C,"ProgressRate")*delta*GetMinigameVar(C,"Multiplier")
    if GetMinigameVar(C,"Type") == 1 then
        loc_prog = UpdateVariableValue(C,"thisdevice::inflateprogress(U)",loc_change)
    else
        loc_prog = UpdateVariableValue(C,"thisdevice::deflateprogress(U)",loc_change)
    end
    SetMinigameVar(C,"Progress",Clamp(loc_prog,0.0,GetMinigameVar(C,"ProgressMax")))
end

function GetUIUpdateString(C)
    return ",prog:"..tostring(GetMinigameVar(C,"Progress")/GetMinigameVar(C,"ProgressMax"))
end

local _ProcessMinigame = ProcessMinigame
function ProcessMinigame(C,delta)
    _ProcessMinigame(C,delta)
    
    if GetMinigameVar(C,"Progress") >= GetMinigameVar(C,"ProgressMax") then
        SetMinigameVar(C,"Progress",0.0)
        
        InflateDeflatePlug(C)
        StopDeviceMinigame(C)
    end
end

function InflateDeflatePlug(C)
    local loc_pressure = GetMinigameVar(C,"PressureChange")
    if GetMinigameVar(C,"Type") == 1 then
        CallPapyrusFunction(C,"thisdevice::inflate","",{"bool",false},{"int",loc_pressure})
    else
        CallPapyrusFunction(C,"thisdevice::deflate","",{"bool",false},{"int",loc_pressure})
    end
end
