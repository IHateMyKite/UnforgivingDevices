
local _Precondition = Precondition -- Save previous function
function Precondition(C)
    Log("Precondition(PlugTurnOnOff.lua) called")
    local loc_res = _Precondition(C)
    if loc_res then
        local loc_strength = GetVibStrength(C)
        if loc_strength > 0 then
            local loc_duration = GetVariableValue(C,"thisdevice::_currentVibRemainingDuration(A)")
            if tonumber(GetConfigVar(C,"Type","1")) == 1 then
                loc_res = loc_res and _Precondition(C) and loc_duration == 0 -- Turn On
            else
                loc_res = loc_res and _Precondition(C) and (loc_duration > 0 or loc_duration < 0) -- Turn Off
            end
        else
            loc_res = false
        end
    end
    return loc_res
end

-- Called when minigame starts
local _OnStart = OnStart -- Save previous function
function OnStart(C)
    Log("OnStart(PlugInflateDeflate.lua) called")
    
    InitMinigameVars(C)
    
    if SetMinigameVar(C,"Type",tonumber(GetConfigVar(C,"Type","0"))) == 1 then
        Log("Progress = "..tostring(SetMinigameVar(C,"Progress",GetVariableValue(C,"thisdevice::_turnOnProgress(A)"))))
    else
        Log("Progress = "..tostring(SetMinigameVar(C,"Progress",GetVariableValue(C,"thisdevice::_turnOffProgress(A)"))))
    end
    
    SetMinigameVar(C,"Strength",GetVibStrength(C))
    if SetMinigameVar(C,"Duration",GetVariableValue(C,"thisdevice::UD_VibDuration(A)")) < 0 then
        -- Infinite vib -> Use big value instead
        SetMinigameVar(C,"Duration",80)
    end
    SetMinigameVar(C,"Accessibility",tonumber(GetDeviceAccessibility(C,true)))
    SetMinigameVar(C,"ProgressRate",2.5)
    if GetMinigameVar(C,"Type") == 1 then
        SetMinigameVar(C,"ProgressMax",GetMinigameVar(C,"Strength")*GetMinigameVar(C,"Duration")/50.0)
    else
        SetMinigameVar(C,"ProgressMax",GetMinigameVar(C,"Strength")*GetMinigameVar(C,"Duration")/25.0)
    end
    
    _OnStart(C)
end

function OnHoldingZone(C,delta)
    local loc_prog = 0.0
    local loc_change = GetMinigameVar(C,"ProgressRate")*delta*GetMinigameVar(C,"Multiplier")*Clamp(GetMinigameVar(C,"Accessibility"),0.25,1.0)*GetMinigameVar(C,"SkillMult")
    if GetMinigameVar(C,"Type") == 1 then
        loc_prog = UpdateVariableValue(C,"thisdevice::_turnOnProgress(U)",loc_change)
    else
        loc_prog = UpdateVariableValue(C,"thisdevice::_turnOffProgress(U)",loc_change)
    end
    SetMinigameVar(C,"Progress",Clamp(loc_prog,0.0,GetMinigameVar(C,"ProgressMax")))
end

function GetUIUpdateString(C)
    return ",prog:"..tostring(GetMinigameVar(C,"Progress")/GetMinigameVar(C,"ProgressMax"))
end

local _ProcessMinigame = ProcessMinigame
function ProcessMinigame(C,delta)
    local loc_res = _ProcessMinigame(C,delta)
    
    if loc_res and GetMinigameVar(C,"Progress") >= GetMinigameVar(C,"ProgressMax") then
        SetMinigameVar(C,"Progress",0.0)
        
        TurnOnOffPlug(C)
        StopDeviceMinigame(C)
        loc_res = false
    end
    return loc_res
end

function TurnOnOffPlug(C)
    UpdateVariableValue(C,"thisdevice::_turnOnProgress(A)",0.0)
    UpdateVariableValue(C,"thisdevice::_turnOffProgress(A)",0.0)
    if GetMinigameVar(C,"Type") == 1 then
        CallPapyrusFunction(C,"thisdevice::vibrate","",{"float",1.0})
    else
        CallPapyrusFunction(C,"thisdevice::stopVibrating","")
    end
end

function GetVibStrength(C)
    local loc_strength = GetVariableValue(C,"thisdevice::UD_VibStrength(A)")
    if loc_strength == -1 then
        if ArmorHasKeyword(C['RD'],"zad_EffectVibratingVeryStrong") then
            loc_strength = 85
        elseif ArmorHasKeyword(C['RD'],"zad_EffectVibratingStrong") then
            loc_strength = 65
        elseif ArmorHasKeyword(C['RD'],"zad_EffectVibrating") then
            loc_strength = 40
        elseif ArmorHasKeyword(C['RD'],"zad_EffectVibratingWeak") then
            loc_strength = 25
        elseif ArmorHasKeyword(C['RD'],"zad_EffectVibratingVeryWeak") then
            loc_strength = 10
        else
            loc_strength = 0
        end
    end
    return loc_strength
end