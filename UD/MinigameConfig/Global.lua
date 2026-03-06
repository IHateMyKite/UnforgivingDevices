
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
    return Host_GetConfigVar(context,varstr,defval)
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

function OpenMinigameUI(C)
    Host_OpenMinigameUI(C['MinigameId'])
end

function CloseMinigameUI(C)
    Host_CloseMinigameUI(C['MinigameId'])
end

function        ActorIsPlayer(actor)
    return Host_ActorIsPlayer(actor)
end

function InvokeUI(C,msg)
    Host_InvokeUI(C['MinigameId'],msg)
end

function        IsNull(ptr)
    return Host_IsNull(ptr)
end

function RegisterActionCallback(C,action,callback)
    Host_RegisterActionCallback(C['MinigameId'],action,callback)
end

----------------------------
--   UTILITY  FUNCTIONS   --
----------------------------

MinigameVars = {}
StringToBoolTable={ ["true"]=true, ["false"]=false }

function InitMinigameVars(C)
    if C then
        MinigameVars[C['MinigameId']] = {}
    else
        Log("ERROR: InitMinigameVars() - Context is nil")
    end
end

function GetMinigameVar(C,name)
    if C then
        return MinigameVars[C['MinigameId']][name]
    else
        Log("ERROR: GetMinigameVar() - Context is nil")
        return nil
    end
end

function SetMinigameVar(C,name,val)
    if C then
        MinigameVars[C['MinigameId']][name] = val
    else
        Log("ERROR: SetMinigameVar() - Context is nil")
    end
end

function UpdateMinigameVar(C,name,val)
    if C then
        local loc_res = GetMinigameVar(C,name) + val
        SetMinigameVar(C,name,loc_res)
        return loc_res
    else
        Log("ERROR: UpdateMinigameVar() - Context is nil")
        return nil
    end
end

function StoreConfigDrain(C)
    local loc_statDrain = {}
    loc_statDrain['Stamina']    = tonumber(GetConfigVar(C,"StaminaDrain","0.0"))
    loc_statDrain['Health']     = tonumber(GetConfigVar(C,"HealthDrain","0.0"))
    loc_statDrain['Magicka']    = tonumber(GetConfigVar(C,"MagickaDrain","0.0"))
    SetMinigameVar(C,'StatDrain',loc_statDrain)
end

function DisableRegen(C)
    if not C then
        Log("ERROR: DisableRegen() - Context is nil")
        return
    end
    local loc_regens = {}
    loc_regens['Wearer'] = {}
    loc_regens['Wearer']['StaminaRate'] = GetVariableValue(C,"wearer::StaminaRate(A)")
    loc_regens['Wearer']['HealRate']    = GetVariableValue(C,"wearer::HealRate(A)")
    loc_regens['Wearer']['MagickaRate'] = GetVariableValue(C,"wearer::MagickaRate(A)")
    UpdateVariableValue(C,"wearer::StaminaRate(A)",0.0)
    UpdateVariableValue(C,"wearer::HealRate(A)",0.0)
    UpdateVariableValue(C,"wearer::MagickaRate(A)",0.0)
    if C['Helper'] then
        Log("Helper is present")
        loc_regens['Helper'] = {}
        loc_regens['Helper']['StaminaRate'] = GetVariableValue(C,"helper::StaminaRate(A)")
        loc_regens['Helper']['HealRate']    = GetVariableValue(C,"helper::HealRate(A)")
        loc_regens['Helper']['MagickaRate'] = GetVariableValue(C,"helper::MagickaRate(A)")
        UpdateVariableValue(C,"helper::StaminaRate(A)",0.0)
        UpdateVariableValue(C,"helper::HealRate(A)",0.0)
        UpdateVariableValue(C,"helper::MagickaRate(A)",0.0)
    end
    SetMinigameVar(C,'Regens',loc_regens)
end

function EnableRegen(C)
    if not C then
        Log("ERROR: EnableRegen() - Context is nil")
        return
    end
    local loc_regens = GetMinigameVar(C,'Regens')
    UpdateVariableValue(C,"wearer::StaminaRate(A)" ,loc_regens['Wearer']['StaminaRate'])
    UpdateVariableValue(C,"wearer::HealRate(A)"    ,loc_regens['Wearer']['HealRate'])
    UpdateVariableValue(C,"wearer::MagickaRate(A)" ,loc_regens['Wearer']['MagickaRate'])
    
    if C['Helper'] then
        UpdateVariableValue(C,"helper::StaminaRate(A)" ,loc_regens['Helper']['StaminaRate'])
        UpdateVariableValue(C,"helper::HealRate(A)"    ,loc_regens['Helper']['HealRate'])
        UpdateVariableValue(C,"helper::MagickaRate(A)" ,loc_regens['Helper']['MagickaRate'])
    end
end

function DamageStats(C,stamina,health,magicka)
    if not C then
        Log("ERROR: DamageStats() - Context is nil")
        return
    end
    UpdateVariableValue(C,"wearer::stamina(D)",stamina)
    UpdateVariableValue(C,"wearer::health(D)",health)
    UpdateVariableValue(C,"wearer::magicka(D)",magicka)
    if C['Helper'] then
        UpdateVariableValue(C,"helper::stamina(D)",stamina)
        UpdateVariableValue(C,"helper::health(D)",health)
        UpdateVariableValue(C,"helper::magicka(D)",magicka)
    end
end

function CheckStats(C,stamina,health,magicka)
    if not C then
        Log("ERROR: DamageStats() - Context is nil")
        return
    end
    local loc_res = true
    if stamina then
        loc_res = loc_res and GetVariableValue(C,"wearer::stamina(A)") > 0.0
    end
    if health then
        loc_res = loc_res and GetVariableValue(C,"wearer::health(A)") > 0.0
    end
    if magicka then
        loc_res = loc_res and GetVariableValue(C,"wearer::magicka(A)") > 0.0
    end
    if C['Helper'] then
        if stamina then
            loc_res = loc_res and GetVariableValue(C,"helper::stamina(A)") > 0.0
        end
        if health then
            loc_res = loc_res and GetVariableValue(C,"helper::health(A)") > 0.0
        end
        if magicka then
            loc_res = loc_res and GetVariableValue(C,"helper::magicka(A)") > 0.0
        end
    end
end

-- Converts string to bool
function StrToBool(str)
    return StringToBoolTable[str]
end