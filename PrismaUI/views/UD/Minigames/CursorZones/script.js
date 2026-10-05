
Durability      = 0.0
Condition       = 0.0
Combo           = 0

window.Init = (arg) =>
{
    var r = document.querySelector(':root');
    
    if ('visibility' in arg)
    {
        var loc_vis = arg.visibility;
        if (loc_vis <= 0.0) return;
        if (loc_vis < 1.0)
        {
            document.getElementById('mg_base').style.opacity = String(loc_vis);
        }
    }
    
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
    
    var loc_bars = 0
    if (!('mdurvis' in arg) || arg.mdurvis)
    {
        document.getElementById('mg_bar_health').style.display = 'inherit';
        if (!loc_hints) document.getElementById('mg_durability_over').style.display = "none";
        loc_bars++;
    }
    r.style.setProperty('--durability-indx', String(loc_bars));
    
    if (!('mconvis' in arg) || arg.mconvis)
    {
        document.getElementById('mg_bar_condition').style.display = 'inherit';
        if (!loc_hints) document.getElementById('mg_condition_over').style.display = "none";
        loc_bars++;
    }
    r.style.setProperty('--condition-indx', String(loc_bars));
    
    if (!('mprovis' in arg) || arg.mprovis)
    {
        document.getElementById('mg_bar_progress').style.display = 'inherit';
        if (!loc_hints) document.getElementById('mg_progress_over').style.display = "none";
        loc_bars++;
    }
    r.style.setProperty('--progress-indx', String(loc_bars));
    
    if (!('combvis' in arg) || arg.combvis)
    {
        document.getElementById('mg_combo').style.display = 'inherit';
    }
    
    if ('actions' in arg)
    {
        RegisterActions(arg.actions,"mg_actions_table");
    }
    r.style.setProperty('--actions-indx', String(loc_bars));
}

window.SetZones = (arg) =>
{
    var loc_cur = document.getElementById("mg_bar_cursor")
    
    for (const zone of arg) {
        var loc_zone = document.getElementById(zone.name)
        if (!loc_zone)
        {
            loc_zone = document.createElement("div");
            loc_zone.className = "mg_minigamezone";
            loc_zone.id = zone.name;
            loc_cur.appendChild(loc_zone);
        }
        
        loc_zone.style.setProperty("width",String(zone.size*100.0)+"%")
        if ('left' in zone)
        {
            loc_zone.style.setProperty("left",String(zone.left*100.0)+"%")
        }
        if ('right' in zone)
        {
            loc_zone.style.setProperty("right",String(zone.right*100.0)+"%")
        }
        if ('color' in zone)
        {
            loc_zone.style.setProperty("background-color",zone.color)
        }
    }
}

window.Update = (arg) =>
{
    if ('dur' in arg)
    {
        Durability = arg.dur
        let loc_bar = document.getElementById("mg_durability")
        loc_bar.style.setProperty("mask-size","100% 100%,"+String(Durability*100.0)+"% 100%")
    }
    
    let loc_bar2 = document.getElementsByClassName("mg_condition")[0]
    if ('cond' in arg)
    {
        Condition = arg.cond
        loc_bar2.style.setProperty("mask-size","100% 100%,"+String(Condition*100.0)+"% 100%")
    }
    
    if ('condlvl' in arg)
    {
        ConditionLvl = arg.condlvl
        loc_bar2.id = "mg_condition_"+ConditionLvl
    }
    
    
    if ('prog' in arg)
    {
        Progress = arg.prog
        let loc_bar3 = document.getElementById("mg_progress")
        loc_bar3.style.setProperty("mask-size","100% 100%,"+String(Progress*100.0)+"% 100%")
    }
    
    if ('pos' in arg) UpdateCursor(arg.pos)
}

window.UpdateCombo = (arg) =>
{
    if ('val' in arg)
    {
        Combo = arg.val
        let loc_combocntr = document.getElementById("mg_combo")
        loc_combocntr.innerHTML = Combo + "x"
    }
}

function UpdateCursor(pos)
{
    let loc_cursor = document.getElementById("mg_cursor")
    loc_cursor.style.setProperty("left",String(pos*100.0)+"%")
}