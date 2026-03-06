
Durability      = 0.0

window.UpdateDurability = (arg) => 
{
    Durability = arg
    let loc_bar = document.getElementById("mg_durability")
    loc_bar.style.setProperty("width",String(arg*100.0)+"%")
}
