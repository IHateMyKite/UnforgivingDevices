
----------------------------
--     NATIVE FUNCTIONS   --
----------------------------

function        GetConfigVar(context,varstr,defval)
    return Host_GetConfigVar(context,"minigame",varstr,defval)
end

----------------------------
--   UTILITY  FUNCTIONS   --
----------------------------

MinigameVars = {}

function InitMinigameVars(C)
    if C then
        if not MinigameVars[C['MinigameId']] then
            MinigameVars[C['MinigameId']] = {}
        else
            Log("InitMinigameVars -> Already ready, skipping")
        end
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

function GetAllMinigameVars(C)
    if C then
        return MinigameVars[C['MinigameId']]
    else
        Log("ERROR: GetAllMinigameVars() - Context is nil")
        return nil
    end
end

function SetMinigameVar(C,name,val)
    if C then
        MinigameVars[C['MinigameId']][name] = val
        return val
    else
        Log("ERROR: SetMinigameVar() - Context is nil")
        return nil
    end
end

function SetAllMinigameVar(C,val)
    if C then
        MinigameVars[C['MinigameId']] = val
    else
        Log("ERROR: SetAllMinigameVar() - Context is nil")
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
    loc_statDrain['Stamina']    = tonumber(GetConfigVar(C,"StaminaDrain","0.0"))*tonumber(GetConfigVar(C,"DrainMult","1.0"))
    loc_statDrain['Health']     = tonumber(GetConfigVar(C,"HealthDrain","0.0"))*tonumber(GetConfigVar(C,"DrainMult","1.0"))
    loc_statDrain['Magicka']    = tonumber(GetConfigVar(C,"MagickaDrain","0.0"))*tonumber(GetConfigVar(C,"DrainMult","1.0"))
    SetMinigameVar(C,'StatDrain',loc_statDrain)
end

function DisableRegen(C)
    if not C then
        Log("ERROR: DisableRegen() - Context is nil")
        return
    end
    --Log("DisableRegen() called")
    local loc_regens = {}
    loc_regens['Actor'] = {}
    loc_regens['Actor']['StaminaRate'] = GetVariableValue(C,"actor::StaminaRate(A)")
    loc_regens['Actor']['HealRate']    = GetVariableValue(C,"actor::HealRate(A)")
    loc_regens['Actor']['MagickaRate'] = GetVariableValue(C,"actor::MagickaRate(A)")
    UpdateVariableValue(C,"actor::StaminaRate(A)",0.0)
    UpdateVariableValue(C,"actor::HealRate(A)",0.0)
    UpdateVariableValue(C,"actor::MagickaRate(A)",0.0)
    if UseHelper(C) then
        --Log("Helper is present")
        loc_regens['Helper'] = {}
        loc_regens['Helper']['StaminaRate'] = GetVariableValue(C,"helper::StaminaRate(A)")
        loc_regens['Helper']['HealRate']    = GetVariableValue(C,"helper::HealRate(A)")
        loc_regens['Helper']['MagickaRate'] = GetVariableValue(C,"helper::MagickaRate(A)")
        UpdateVariableValue(C,"helper::StaminaRate(A)",0.0)
        UpdateVariableValue(C,"helper::HealRate(A)",0.0)
        UpdateVariableValue(C,"helper::MagickaRate(A)",0.0)
    end
    SetMinigameVar(C,'Regens',loc_regens)
    --Log("DisableRegen() - regens disabled")
end

function EnableRegen(C)
    if not C then
        Log("ERROR: EnableRegen() - Context is nil")
        return
    end
    --Log("EnableRegen() called")
    local loc_regens = GetMinigameVar(C,'Regens')
    if loc_regens then
        UpdateVariableValue(C,"actor::StaminaRate(A)" ,loc_regens['Actor']['StaminaRate'])
        UpdateVariableValue(C,"actor::HealRate(A)"    ,loc_regens['Actor']['HealRate'])
        UpdateVariableValue(C,"actor::MagickaRate(A)" ,loc_regens['Actor']['MagickaRate'])
        
        if UseHelper(C) then
            UpdateVariableValue(C,"helper::StaminaRate(A)" ,loc_regens['Helper']['StaminaRate'])
            UpdateVariableValue(C,"helper::HealRate(A)"    ,loc_regens['Helper']['HealRate'])
            UpdateVariableValue(C,"helper::MagickaRate(A)" ,loc_regens['Helper']['MagickaRate'])
        end
    end
end

function GetStoredRegen(C)
    if not C then
        Log("ERROR: GetStoredRegen() - Context is nil")
        return
    end
    local loc_regens = GetMinigameVar(C,'Regens')
    return loc_regens
end

function DamageStats(C,stamina,health,magicka)
    if not C then
        Log("ERROR: DamageStats() - Context is nil")
        return
    end
    UpdateVariableValue(C,"actor::stamina(D)",stamina)
    UpdateVariableValue(C,"actor::health(D)",health)
    UpdateVariableValue(C,"actor::magicka(D)",magicka)
    if UseHelper(C) then
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
        loc_res = loc_res and GetVariableValue(C,"actor::stamina(A)") > 0.0
    end
    if health then
        loc_res = loc_res and GetVariableValue(C,"actor::health(A)") > 0.0
    end
    if magicka then
        loc_res = loc_res and GetVariableValue(C,"actor::magicka(A)") > 0.0
    end
    if UseHelper(C) then
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
    return loc_res
end


function UseHelper(C)
    return GetMinigameVar(C,"Helping")
end

function UseHelperCond(C)
    return not IsNull(C['Helper']) and (not C['Context'] or C['Context'] == "help")
end

function PlayerInMinigame(C)
    if ActorIsPlayer(C['Actor']) or (ActorIsPlayer(C['Helper'])) then
        return true
    else
        return false
    end
end

function CheckMinStatsActor(C)
    local loc_stamina = GetVariableValue(C,"actor::stamina(R)") > tonumber(GetConfigVar(C,"minStamina","0.0"))
    local loc_magicka = GetVariableValue(C,"actor::magicka(R)") > tonumber(GetConfigVar(C,"minMagicka","0.0"))
    local loc_health  = GetVariableValue(C,"actor::health(R)")  > tonumber(GetConfigVar(C,"minHealth","0.0"))
    return loc_stamina and loc_magicka and loc_health
end

function CheckMinStatsHelper(C)
    local loc_stamina = GetVariableValue(C,"helper::stamina(R)") > tonumber(GetConfigVar(C,"minStamina","0.0"))
    local loc_magicka = GetVariableValue(C,"helper::magicka(R)") > tonumber(GetConfigVar(C,"minMagicka","0.0"))
    local loc_health  = GetVariableValue(C,"helper::health(R)")  > tonumber(GetConfigVar(C,"minHealth","0.0"))
    return loc_stamina and loc_magicka and loc_health
end