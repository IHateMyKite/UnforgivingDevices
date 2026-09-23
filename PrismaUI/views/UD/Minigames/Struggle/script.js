
Durability      = 0.0
Condition       = 0.0
Combo           = 0

window.Init = (arg) =>
{
    var r = document.querySelector(':root');
    if ('pos_y' in arg)r.style.setProperty('--minigame-offset-y', String(arg.pos_y));
    if ('pos_x' in arg)r.style.setProperty('--minigame-offset-x', String(arg.pos_x));
    
    if (('scale' in arg))
    {
        var rs = getComputedStyle(r);
        let loc_base_meter = Number(rs.getPropertyValue('--meter-width-base').replace("%",""))
        let loc_base_font  = Number(rs.getPropertyValue('--combo-size').replace("vh",""))
        r.style.setProperty('--meter-width-base', String(arg.scale*loc_base_meter) + "%");
        r.style.setProperty('--combo-size', String(arg.scale*loc_base_font) + "vh");
    }
    
    if (!('mcurvis' in arg) || arg.mcurvis)
    {
        document.getElementById('mg_bar_cursor').style.display = 'inherit';
    }
    if (!('mdurvis' in arg) || arg.mdurvis)
    {
        document.getElementById('mg_bar_health').style.display = 'inherit';
    }
    if (!('mconvis' in arg) || arg.mconvis)
    {
        document.getElementById('mg_bar_condition').style.display = 'inherit';
    }
    if (!('combvis' in arg) || arg.combvis)
    {
        document.getElementById('mg_combo').style.display = 'inherit';
    }
    
    ReloadMeters();
}

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
    //let loc_size = window.getComputedStyle(loc_combocntr).fontSize
    //loc_combocntr.style.setProperty("font-size",String(Number(loc_size.replace("px",""))+2)+"px")
}

function UpdateCursor(pos)
{
    let loc_cursor = document.getElementById("mg_cursor")
    loc_cursor.style.setProperty("left",String(pos*100.0)+"%")
}