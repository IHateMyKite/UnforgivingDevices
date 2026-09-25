
function RegisterActions(actions,basename)
{
    const obj = JSON.parse(actions);
    let loc_table = document.getElementById(basename);
    
    for (const [key, value] of Object.entries(obj.Keyboard)) {
      let loc_th = document.createElement("th");
      let loc_span = document.createElement("span");
      loc_span.className = "mg_action_text";
      loc_span.innerHTML = `[${value}] ${key}`;
      loc_th.appendChild(loc_span);
      loc_table.appendChild(loc_th);
    }
}

