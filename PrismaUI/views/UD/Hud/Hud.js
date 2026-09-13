
window.AddMeter = (arg) =>
{
    base = document.getElementById("hud_base");
    
    meter_border = document.createElement("div");
    meter_border.className = "hud_meter_border";
    
    meter_border.style.left = arg.x;
    meter_border.style.top = arg.y;
    meter_border.style.width = arg.width;
    meter_border.style.height = arg.height;
    meter_border.id = "base_"+arg.id;
    
    meter_base = document.createElement("div");
    meter_base.className = "hud_meter_base";
    meter_base.style.backgroundColor = arg.color2;
    
    meter = document.createElement("div");
    meter.className = "hud_meter";
    meter.id = arg.id;
    meter.style.backgroundColor = arg.color;
    
    meter_base.appendChild(meter);
    meter_border.appendChild(meter_base);
    
    base.appendChild(meter_border);
}

window.UpdateMeter = (arg) =>
{
    meter = document.getElementById(arg.id);
    if (meter)
    {
        meter.style.setProperty("width",String(arg.val*100.0)+"%")
    }
}

window.RemoveMeter = (arg) =>
{
    meter = document.getElementById("base_"+arg.id);
    if (meter)
    {
        meter.remove();
    }
}
