
function CheckTags(C)
    local loc_tags          = json.parse(Host_GetDeviceTags(C))
    
    if loc_tags then
        -- Check blacklist
        local loc_blacklist = GetConfigVar(C,"TagBlacklist","")
        if loc_blacklist and loc_blacklist ~= "" then
            for i in string.gmatch(loc_blacklist, "%S+") do
                --Log("Checking blacklist tag "..i)
                if loc_tags[i] then
                    --Log("Blacklisted tag "..i.." present")
                    return false
                end
            end
        end
        
        -- Check Whitelist
        local loc_whitelist = GetConfigVar(C,"TagWhitelist","")
        if loc_whitelist and loc_whitelist ~= "" then
            for i in string.gmatch(loc_whitelist, "%S+") do
                --Log("Checking whitelist tag "..i)
                if loc_tags[i] then
                    --Log("Whitelisted tag "..i.." present")
                    return true
                end
            end
            return false -- No whitelisted tag found
        end
    end
    return true
end