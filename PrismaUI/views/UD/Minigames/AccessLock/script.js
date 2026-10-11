
Durability      = 0.0
Condition       = 0.0
Combo           = 0
Fps             = 60
UpdateTime      = 1000.0/Fps

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
    
    if ('fps' in arg)
    {
        Fps = arg.fps;
    }
    UpdateTime = 1000.0/Fps;
    
    if ('pos_y' in arg)r.style.setProperty('--minigame-offset-y', String(arg.pos_y));
    if ('pos_x' in arg)r.style.setProperty('--minigame-offset-x', String(arg.pos_x));
    
    if (('scale' in arg))
    {
        var loc_scale = parseFloat(arg.scale)
        r.style.setProperty('--scale', String(loc_scale));
    }
    
    if (('scalezone' in arg))
    {
        var loc_scale = parseFloat(arg.scalezone)
        r.style.setProperty('--zone-scale', String(loc_scale));
    }
    
    if (('scalecursor' in arg))
    {
        var loc_scale = parseFloat(arg.scalecursor)
        r.style.setProperty('--cursor-scale', String(loc_scale));
    }
    
    document.getElementById('mg_cursor').style.transition = "left top " + UpdateTime + "ms";
    
    var loc_hints  = false
    if (('hints' in arg))
    {
        loc_hints = arg.hints
    }
    
    if (!('focvis' in arg) || arg.focvis)
    {
        document.getElementById('mg_bar_focus').style.display = 'inherit';
        document.getElementById('mg_bar_focus').style.transition = "mask-size " + UpdateTime + "ms";
        if (!loc_hints) document.getElementById('mg_focus_over').style.display = "none";
    }
    
    if ('actions' in arg)
    {
        RegisterActions(arg.actions,"mg_actions_table");
    }
}

function CheckZones(argPos,argZones)
{
    let loc_inzone = argPos.in;

    if (loc_inzone)
    {
        for(let i = 0; i < argZones.length;i++)
        {
            let loc_zone = argZones[i];
            loc_zone.style.setProperty("background-color","green")
        }
    }
    else
    {
        for(let i = 0; i < argZones.length;i++)
        {
            let loc_zone = argZones[i];
            loc_zone.style.setProperty("background-color","red")
        }
    }
}

window.Update = (arg) =>
{
    let loc_cursor = document.getElementById("mg_cursor");
    loc_cursor.style.left       = arg.x;
    loc_cursor.style.top        = arg.y;
    
    let loc_zone1 = document.getElementById("mg_minigamezone1");
    let loc_zone2 = document.getElementById("mg_minigamezone2");
    CheckZones(arg,[loc_zone1,loc_zone2]);
    
    Focus = arg.foc
    let loc_bar = document.getElementById("mg_focus")
    loc_bar.style.setProperty("mask-size","100% 100%,"+String(Focus*100.0)+"% 100%")
}

