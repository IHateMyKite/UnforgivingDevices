
function Condition(C)
    --Log("Meter Condition called")
    local loc_thdmin    = GetHudValue(C,GetConfigVar(C,"thd_min","0.0"))
    local loc_thdmax    = GetHudValue(C,GetConfigVar(C,"thd_max","1.0"))
    local loc_val       = GetHudValue(C,GetConfigVar(C,"value","0.0"))
    local loc_valmax    = GetHudValue(C,GetConfigVar(C,"maxvalue","1.0"))
    local loc_val_p     = loc_val/loc_valmax
    return loc_val_p >= loc_thdmin and loc_val_p <= loc_thdmax
end

function OnShown(C)
    -- Log("Meter OnShown called")
    local loc_payload = "AddMeter({"
    loc_payload = loc_payload.."id:\""..tostring(C['Id']).."\","
    loc_payload = loc_payload.."x:\""..tostring(GetConfigVar(C,"posX","50%")).."\","
    loc_payload = loc_payload.."y:\""..tostring(GetConfigVar(C,"posY","50%")).."\","
    loc_payload = loc_payload.."width:\""..tostring(GetConfigVar(C,"width","20%")).."\","
    loc_payload = loc_payload.."height:\""..tostring(GetConfigVar(C,"height","4%")).."\","
    loc_payload = loc_payload.."color:\""..tostring(GetConfigVar(C,"color_fill","green").."\",")
    loc_payload = loc_payload.."color2:\""..tostring(GetConfigVar(C,"color_back","red").."\",")
    loc_payload = loc_payload.."})"
    
    Log("Creating new meter with payload "..loc_payload)
    
    InvokeHud(loc_payload)
end

function OnHidden(C)
    Log("Meter OnHidden called")
    local loc_payload = "RemoveMeter({"
    loc_payload = loc_payload.."id:\""..tostring(C['Id']).."\""
    loc_payload = loc_payload.."})"
    
    Log("Removing meter with payload "..loc_payload)
    
    InvokeHud(loc_payload)
end

function OnUpdate(C,delta)
    local loc_valstr    = GetConfigVar(C,"value","0.0")
    local loc_valmaxstr = GetConfigVar(C,"maxvalue","1.0")
    local loc_val       = GetHudValue(C,loc_valstr)
    local loc_valmax    = GetHudValue(C,loc_valmaxstr)
    
    local loc_payload = "UpdateMeter({"
    loc_payload = loc_payload.."id:\""..tostring(C['Id']).."\","
    loc_payload = loc_payload.."val:\""..tostring(math.min(math.max(loc_val/loc_valmax,0.0),1.0)).."\""
    loc_payload = loc_payload.."})"
    
    --Log("Updating meter with payload "..loc_payload)
    
    InvokeHud(loc_payload)
end