
----------------------------
-- HOST LIBRARY FUNCTIONS --
----------------------------

-- Logs message to native skse log
function Log(msg)
    Host_Log(msg)
end

-- Returns variable value based on variable string
-- Example 1: thisdevice::UD_durability_damage_base() -> Returns current devices UD_durability_damage_base papyrus value
-- Example 2: wearer::stamina(R) -> Returns current relative stamina of wearer
function        GetVariableValue(context,varstr)
    return Host_GetVariableValue(context,varstr)
end

function        UpdateVariableValue(context,varstr,newval)
    return Host_UpdateVariableValue(context,varstr,newval)
end

-- Returns true if passed 'armor' has keyword 'kwstr'
function        ArmorHasKeyword(armor,kwstr)
    return Host_ArmorHasKeyword(armor,kwstr)
end

-- Returns valuo of config variable 'varstr' loaded for current 'context' (minigame json config). If variable is not present, 'defval' is returned
function        GetConfigVar(context,varstr,defval)
    return Host_GetConfigVar(context,"",varstr,defval)
end

function        CallPapyrusFunction(C,fun,callback,...)
    if ... then
        local arg={...}
        local argParsed={}
        local n = 0
        for i,v in ipairs(arg) do
            argParsed[tostring(n).."_t"] = v[1] -- Convert to array
            argParsed[tostring(n).."_v"] = v[2] -- Convert to array
            n = n + 1
        end
        argParsed["n"] = n -- Add size element
        return Host_CallPapyrusFunction(C,fun,callback,argParsed)
    else
        return Host_CallPapyrusFunction(C,fun,callback,nil)
    end
    
end

-- Stops minigame on native level
function StopMinigame(C)
    Log("StopMinigame("..tostring(C['MinigameId'])..")")
    Host_StopMinigame(C['MinigameId'])
end

function OpenMinigameUI(C,callback)
    Host_OpenMinigameUI(C['MinigameId'],callback)
end

function CloseMinigameUI(C)
    Host_CloseMinigameUI(C['MinigameId'])
end

function        ActorIsPlayer(actor)
    return Host_ActorIsPlayer(actor)
end

function InvokeMinigameUI(C,msg)
    Host_InvokeUI(C['MinigameId'],msg)
end

function InvokeHud(msg)
    Host_InvokeUI(-1,msg)
end

function        IsNull(ptr)
    return Host_IsNull(ptr)
end

function RegisterActionCallback(C,action,callback)
    Host_RegisterActionCallback(C['MinigameId'],action,callback)
end

function GetDeviceAccessibility(C,checkHB)
    return Host_GetDeviceAccesibility(C,checkHB)
end

function ActorFreeHands(actor,checkgrasp,ignoreheavybondage)
    return Host_ActorFreeHands(actor,checkgrasp,ignoreheavybondage)
end

function WornHasKeyword(actor,kw)
    return Host_WornHasKeyword(actor,kw)
end

function GetGameForm(formID,modName)
    return Host_GetGameForm(formID,modName)
end

function GetItemCount(container,item)
    return Host_GetItemCount(container,item)
end

function GetHudValue(C,val)
    return Host_GetHudValue(C,val)
end

function AdvanceMinigameSkill(C,value)
    Host_AdvanceMinigameSkill(C['MinigameId'],value/100.0)
end

function GetSharpestWeaponPower(actor)
    return Host_GetSharpestWeaponPower(actor)
end

function GetDeviceTags(C)
    return Host_GetDeviceTags(C)
end

----------------------------
--   UTILITY  FUNCTIONS   --
----------------------------

StringToBoolTable={ ["true"]=true, ["false"]=false }

-- Converts string to bool
function StrToBool(str)
    return StringToBoolTable[str]
end

function BoolToInt(bool)
    if bool then
        return 1
    else
        return 0
    end
end

function Clamp(x,minval,maxval)
    if x > maxval then
        return maxval
    end
    if x < minval then
        return minval
    end
    return x
end

function PointInCircle(center_x, center_y, radius, x, y)
    local square_dist = (center_x - x)^2 + (center_y - y)^2
    return square_dist <= (radius)^2
end

function PointInRectangle(center_x, center_y, size_x, size_y, x, y)
    return x > (center_x - size_x/2) and x < (center_x + size_x/2) and y > (center_y - size_y/2) and y < (center_y + size_y/2)
end