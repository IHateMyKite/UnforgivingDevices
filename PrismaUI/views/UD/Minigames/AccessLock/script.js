
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
    //for(let i = 0; i < argZones.length;i++)
    //{
    //    let loc_zone = argZones[i];
    //    let loc_style = getComputedStyle(loc_zone);
    //    let Zone = {x:0,y:0,size:0};
    //    Zone.x = Number(loc_style.left.replace("px",""))
    //    Zone.y = Number(loc_style.top.replace("px",""))
    //    Zone.sizeX = Number(loc_style.width.replace("px",""))
    //    Zone.sizeY = Number(loc_style.height.replace("px",""))
    //    
    //    if (argPos.x > Zone.x-Zone.sizeX/2 && argPos.x < Zone.x+Zone.sizeX/2)
    //    {
    //        if (argPos.y > Zone.y-Zone.sizeY/2 && argPos.y < Zone.y+Zone.sizeY/2)
    //        {
    //            loc_inzone = true;
    //        }
    //    }
    //}
    
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

// UpdateCursorPosition({x:200,y:200,size:80,in:1,zonex:100,zoney:100,zonescale:0.5})

OriginalWidth1 = 0.0
OriginalWidth2 = 0.0
OriginalHeight1 = 0.0
OriginalHeight2 = 0.0
OriginalDelta = 0.0
FirstTimeCalled = false

window.UpdateCursorPosition = (arg) =>
{
    let loc_cursor = document.getElementById("mg_cursor");
    loc_cursor.style.left       = arg.x + "px";
    loc_cursor.style.top        = arg.y + "px";
    loc_cursor.style.height     = arg.size + "px";
    loc_cursor.style.width      = arg.size + "px";
    loc_cursor.style.marginTop  = -1*arg.size/2 + "px";
    loc_cursor.style.marginLeft = -1*arg.size/2 + "px";
    
    let loc_zone1 = document.getElementById("mg_minigamezone1");
    let loc_zone2 = document.getElementById("mg_minigamezone2");
    
    if (!FirstTimeCalled)
    {
        OriginalWidth1  = loc_zone1.clientWidth;
        OriginalWidth2  = loc_zone2.clientWidth;
        OriginalHeight1 = loc_zone1.clientHeight;
        OriginalHeight2 = loc_zone2.clientHeight;
        OriginalDelta   = loc_zone2.offsetTop - loc_zone1.offsetTop;
        FirstTimeCalled = true;
    }
    
    loc_zone1.style.left        = arg.zonex + "px";
    loc_zone1.style.top         = arg.zoney + "px";
    loc_zone2.style.left        = arg.zonex + "px";
    loc_zone2.style.top         = arg.zoney + OriginalDelta*arg.zonescale + "px";
    
    loc_zone1.style.width       = OriginalWidth1*arg.zonescale + "px";
    loc_zone1.style.height      = OriginalHeight1*arg.zonescale + "px";
    loc_zone1.style.marginLeft  = -1*loc_zone1.clientWidth/2 + "px"
    loc_zone1.style.marginTop   = -1*loc_zone1.clientHeight/2 + "px"
    
    loc_zone2.style.width       = OriginalWidth2*arg.zonescale + "px";
    loc_zone2.style.height      = OriginalHeight2*arg.zonescale + "px";
    loc_zone2.style.marginLeft  = -1*loc_zone2.clientWidth/2 + "px"
    loc_zone2.style.marginTop   = -1*loc_zone2.clientHeight/2 + "px"
    
    CheckZones(arg,[loc_zone1,loc_zone2]);
}

