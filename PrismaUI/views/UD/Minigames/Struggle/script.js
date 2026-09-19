
Durability      = 0.0
Condition       = 0.0
Combo           = 0

window.SetZones = (arg) =>
{
    zones = document.getElementsByClassName("mg_minigamezone")
    console.log(arg.zonesize)
    for (const el of zones) {
      el.style.setProperty("width",String(arg.zonesize*100.0)+"%")
    }
}

window.UpdateMinigame = (arg) =>
{
    Durability = arg.dur
    let loc_bar = document.getElementById("mg_durability")
    loc_bar.style.setProperty("mask-size",String(Durability*100.0)+"%")
    
    Condition = arg.cond
    ConditionLvl = arg.condlvl
    let loc_bar2 = document.getElementsByClassName("mg_condition")[0]
    loc_bar2.style.setProperty("mask-size",String(Condition*100.0)+"%")
    loc_bar2.id = "mg_condition_"+ConditionLvl
    
    UpdateCursor(arg.pos)
}

window.UpdateCombo = (arg) =>
{
    Combo = arg.val
    let loc_combocntr = document.getElementById("mg_combo")
    loc_combocntr.innerHTML = Combo + "x"
    let loc_size = window.getComputedStyle(loc_combocntr).fontSize
    loc_combocntr.style.setProperty("font-size",String(Number(loc_size.replace("px",""))+2)+"px")
}

function UpdateCursor(pos)
{
    let loc_cursor = document.getElementById("mg_cursor")
    loc_cursor.style.setProperty("left",String(pos*100.0)+"%")
}