
function Condition(C)
    Log("Meter Condition called")
    return true
end

function OnShown(C)
    Log("Meter OnShown called")
    local loc_payload = "AddMeter({"
    loc_payload = loc_payload.."id:\""..tostring(C['Id']).."\","
    loc_payload = loc_payload.."x:\""..tostring(GetConfigVar(C,"posX","50%")).."\","
    loc_payload = loc_payload.."y:\""..tostring(GetConfigVar(C,"posY","50%")).."\","
    loc_payload = loc_payload.."color:\""..tostring(GetConfigVar(C,"color","green").."\"")
    loc_payload = loc_payload.."})"
    
    Log("Creating new meter with payload "..loc_payload)
    
    InvokeHud(loc_payload)
end

function OnHidden(C)
    -- TODO : Invoke UI
end

function OnUpdate(C,delta)
    -- TODO : Invoke UI
end