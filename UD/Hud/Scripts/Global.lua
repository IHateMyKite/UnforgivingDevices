
----------------------------
--   UTILITY  FUNCTIONS   --
----------------------------

ElementVars = {}

function InitVars(C)
    if C then
        ElementVars[C['Id']] = {}
    else
        Log("ERROR: InitVars() - Context is nil")
    end
end

function GetVar(C,name)
    if C then
        return ElementVars[C['Id']][name]
    else
        Log("ERROR: GetVar() - Context is nil")
        return nil
    end
end

function SetVar(C,name,val)
    if C then
        ElementVars[C['Id']][name] = val
    else
        Log("ERROR: SetVar() - Context is nil")
    end
end

function UpdateVar(C,name,val)
    if C then
        local loc_res = GetVar(C,name) + val
        SetVar(C,name,loc_res)
        return loc_res
    else
        Log("ERROR: UpdateVar() - Context is nil")
        return nil
    end
end
