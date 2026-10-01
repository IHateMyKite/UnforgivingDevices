
Durability      = 0.0
Condition       = 0.0
Combo           = 0

function Test()
{
    //Direction.x = (2*Math.random() - 1)*Direction.x;
    //Direction.y = (2*Math.random() - 1)*Direction.y;
    setInterval(Test_Update,10)
}

Pos = {x:200.0,y:200.0,size:80,zonex:200,zoney:200,zonescale:0.5}
Direction = {x:15.0,y:15.0}

function Test_Update()
{
    
    Pos.x += Direction.x;
    Pos.y += Direction.y;
    
    Test_CheckPosBound();
    
    UpdateCursorPosition(Pos);
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

window.Init = (arg) =>
{
    var r = document.querySelector(':root');
    if ('y' in arg)r.style.setProperty('--minigame-offset-y', String(arg.y));
    if ('x' in arg)r.style.setProperty('--minigame-offset-x', String(arg.x));
    
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
    
    var loc_hints  = false
    if (('hints' in arg))
    {
        loc_hints = arg.hints
    }
    
    if (!('focvis' in arg) || arg.focvis)
    {
        document.getElementById('mg_bar_focus').style.display = 'inherit';
        if (!loc_hints) document.getElementById('mg_focus_over').style.display = "none";
    }
    
    if ('actions' in arg)
    {
        RegisterActions(arg.actions,"mg_actions_table");
    }
}

function Test_CheckPosBound()
{
    let loc_ref = false
    if (Pos.x > 400.0-20.0)
    {
        Pos.x = 400.0-20.0;
        loc_ref = true;
    }
    if (Pos.y > 400.0-20.0)
    {
        Pos.y = 400.0-20.0;
        loc_ref = true;
    }
    if (Pos.x < 20.0)
    {
        Pos.x = 20.0;
        loc_ref = true;
    }
    if (Pos.y < 20.0)
    {
        Pos.y = 20.0;
        loc_ref = true;
    }
    if (loc_ref)
    {
        Test_ReflectVec();
    }
}

function Test_ReflectVec()
{
    let loc_posX = Direction.x
    let loc_posY = Direction.y
    let loc_angle = Math.PI/2*(1.0 - 0.15*Math.random())
    Direction.x = loc_posX*Math.cos(loc_angle) - loc_posY*Math.sin(loc_angle);
    Direction.y = loc_posX*Math.sin(loc_angle) + loc_posY*Math.cos(loc_angle);
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

