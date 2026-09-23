
-- Check if HUD element should be shown or hidden
function Condition(C)
    return false
end

-- Called to show element
function Show(C)
    Log("Show called")
    InitVars(C)
    OnShown(C)
end

-- Called to hide element
function Hide(C)
    Log("Hide called")
    OnHidden(C)
end

-- Called on every player update frame
-- Is not called while in menu mode
function Update(C,delta)
    OnUpdate(C,delta)
end

-- Overrides
function OnShown(C)
end
function OnHidden(C)
end
function OnUpdate(C,delta)
end

