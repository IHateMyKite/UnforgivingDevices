
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
        var loc_scale = parseFloat(arg.scale)
        r.style.setProperty('--scale', String(loc_scale));
    }
    
    var loc_hints  = true
    if (('hints' in arg))
    {
        loc_hints = arg.hints
    }
    
    if (!('mcurvis' in arg) || arg.mcurvis)
    {
        document.getElementById('mg_bar_cursor').style.display = 'inherit';
    }
    if (!('mdurvis' in arg) || arg.mdurvis)
    {
        document.getElementById('mg_bar_health').style.display = 'inherit';
        if (!loc_hints) document.getElementById('mg_durability_over').style.display = "none";
    }
    if (!('mconvis' in arg) || arg.mconvis)
    {
        document.getElementById('mg_bar_condition').style.display = 'inherit';
        if (!loc_hints) document.getElementById('mg_condition_over').style.display = "none";
    }
    if (!('mprovis' in arg) || arg.mprovis)
    {
        document.getElementById('mg_bar_progress').style.display = 'inherit';
        if (!loc_hints) document.getElementById('mg_progress_over').style.display = "none";
    }
    if (!('combvis' in arg) || arg.combvis)
    {
        document.getElementById('mg_combo').style.display = 'inherit';
    }
    
    if ('actions' in arg)
    {
        RegisterActions(arg.actions,"mg_actions_table");
    }
}

window.SetZones = (arg) =>
{
    zones = document.getElementsByClassName("mg_minigamezone")
    //console.log(arg.size)
    for (const el of zones) {
      el.style.setProperty("width",String(arg.size*100.0)+"%")
      el.style.setProperty("left",String(arg.pos*100.0)+"%")
    }
}

window.UpdateMinigame = (arg) =>
{
    Durability = arg.dur
    let loc_bar = document.getElementById("mg_durability")
    loc_bar.style.setProperty("mask-size","100% 100%,"+String(Durability*100.0)+"% 100%")
    
    Condition = arg.cond
    ConditionLvl = arg.condlvl
    let loc_bar2 = document.getElementsByClassName("mg_condition")[0]
    loc_bar2.style.setProperty("mask-size","100% 100%,"+String(Condition*100.0)+"% 100%")
    loc_bar2.id = "mg_condition_"+ConditionLvl
    
    Cutting = arg.cut
    let loc_bar3 = document.getElementById("mg_cutting")
    loc_bar3.style.setProperty("mask-size","100% 100%,"+String(Cutting*100.0)+"% 100%")
    
    UpdateCursor(arg.pos)
}

window.UpdateCombo = (arg) =>
{
    Combo = arg.val
    let loc_combocntr = document.getElementById("mg_combo")
    loc_combocntr.innerHTML = Combo + "x"
}

function UpdateCursor(pos)
{
    let loc_cursor = document.getElementById("mg_cursor")
    loc_cursor.style.setProperty("left",String(pos*100.0)+"%")
}