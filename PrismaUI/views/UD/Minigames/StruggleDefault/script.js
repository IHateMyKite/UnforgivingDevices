
Durability      = 0.0
Condition       = 0.0
Combo           = 0

window.InitMinigame = (arg) =>
{
    zones = document.getElementsByClassName("mg_minigamezone")
    console.log(zones)
    for (const el of zones) {
      el.style.setProperty("width",String(arg.zonesize)+"%")
    }
}

window.UpdateMinigame = (arg) =>
{
    Durability = arg.dur
    let loc_bar = document.getElementById("mg_durability")
    loc_bar.style.setProperty("width",String(Durability*100.0)+"%")
    
    Condition = arg.cond
    let loc_bar2 = document.getElementById("mg_condition")
    loc_bar2.style.setProperty("width",String(Condition*100.0)+"%")
    
    UpdateCursor(arg.pos)
}

window.UpdateCombo = (arg) =>
{
    Combo = arg.val
    let loc_combocntr = document.getElementById("mg_combo")
    loc_combocntr.innerHTML = Combo + "x"
    loc_combocntr.style.setProperty("font-size",String(25+arg.val*2)+"px")
}

function UpdateCursor(pos)
{
    let loc_cursor = document.getElementById("mg_cursor")
    loc_cursor.style.setProperty("left",String(pos*100.0)+"%")
}