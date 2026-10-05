
id = 0
window.AddMeter = (arg) =>
{
    id++;
    
    let loc_x = "50%";
    if('x' in arg) loc_x = arg.x;
    let loc_y = "50%";
    if('y' in arg) loc_y = arg.y;
    let loc_id = id;
    if('id' in arg) loc_id = arg.id;
    let loc_color = "red";
    if('color' in arg) loc_color = arg.color;
    
    let loc_w = "var(--meter-width)";
    let loc_woff = "calc(-1*var(--meter-width)/2)";
    if('width' in arg)
    {
        loc_w = arg.width;
        loc_woff = "calc(-1*"+loc_w+"/2)";
    }
    let loc_h = "var(--meter-height)";
    let loc_hoff = "calc(-1*var(--meter-height)/2)";
    if('height' in arg)
    {
        loc_h = arg.height;
        loc_hoff = "calc(-1*"+loc_h+"/2)";
    }
    
    
    base = document.getElementById("main");
    
    meter_base = document.createElement("div");
    meter_base.className = "mg_bar_base";
    meter_base.style = "left:"+loc_x+";top:"+loc_y+";width:"+loc_w+";margin-left:"+loc_woff+";height:"+loc_h+";margin-top:"+loc_hoff+";"
    meter_base.id = "meter_"+loc_id+"_base";
    
    meter_border = document.createElement("div");
    meter_border.className = "mg_bar mg_bar_border";
    
    meter_fill = document.createElement("div");
    meter_fill.className = "mg_bar_fill";
    meter_fill.style.backgroundColor = loc_color;
    meter_fill.id = "meter_"+loc_id+"_fill";
    
    meter_fill_bcg = document.createElement("div");
    meter_fill_bcg.className = "mg_bar_fill mg_bar_background";
    meter_fill_bcg.style.backgroundColor = loc_color;
    meter_fill_bcg.style.filter = "opacity(20%)";
    
    meter_base.appendChild(meter_border);
    meter_base.appendChild(meter_fill);
    meter_base.appendChild(meter_fill_bcg);
    base.appendChild(meter_base);
}

window.UpdateMeter = (arg) =>
{
    if ('id' in arg && 'val' in arg)
    {
        meter = document.getElementById("meter_"+arg.id+"_fill");
        if (meter)
        {
            meter.style.setProperty("mask-size","100% 100%,"+String(arg.val*100.0)+"% 100%")
        }
    }
}

window.RemoveMeter = (arg) =>
{
    if ('id' in arg)
    {
        meter = document.getElementById("meter_"+arg.id+"_base");
        if (meter)
        {
            meter.remove();
        }
    }
}
