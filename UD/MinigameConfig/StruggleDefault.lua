
function Precondition(context)
    Log("Precondition called")
    Log("Context: "..tostring(context))
    return GetVariableValue(context,"thisdevice::UD_durability_damage_base") > 0.0
end

function Update(delta)

end

function DamageWearerStats(stamina, health, magicka)

end