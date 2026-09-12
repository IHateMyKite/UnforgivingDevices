
----------------------------
--   UTILITY  FUNCTIONS   --
----------------------------

MinigameVars = {}

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
    else
        Log("ERROR: SetMinigameVar() - Context is nil")
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
    if UseHelper(C) then
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
    
    if UseHelper(C) then
        UpdateVariableValue(C,"helper::StaminaRate(A)" ,loc_regens['Helper']['StaminaRate'])
        UpdateVariableValue(C,"helper::HealRate(A)"    ,loc_regens['Helper']['HealRate'])
        UpdateVariableValue(C,"helper::MagickaRate(A)" ,loc_regens['Helper']['MagickaRate'])
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
    UpdateVariableValue(C,"wearer::stamina(D)",stamina)
    UpdateVariableValue(C,"wearer::health(D)",health)
    UpdateVariableValue(C,"wearer::magicka(D)",magicka)
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
        loc_res = loc_res and GetVariableValue(C,"wearer::stamina(A)") > 0.0
    end
    if health then
        loc_res = loc_res and GetVariableValue(C,"wearer::health(A)") > 0.0
    end
    if magicka then
        loc_res = loc_res and GetVariableValue(C,"wearer::magicka(A)") > 0.0
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
    return not IsNull(C['Helper']) and (not C['Context'] or C['Context'] == "help")
end
