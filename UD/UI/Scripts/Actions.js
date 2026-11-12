
function RegisterActions(actions,basename)
{
    const obj = JSON.parse(actions);
    let loc_table = document.getElementById(basename);
    let loc_actions = Object.entries(obj.Keyboard)
    for (const [key, value] of loc_actions) {
      let loc_th = document.createElement("th");
      let loc_span = document.createElement("span");
      loc_span.className = "mg_action_text";
      loc_span.innerHTML = `[${value}] ${key}`;
      loc_th.appendChild(loc_span);
      loc_th.style.width = String(100/loc_actions.length) + "%";
      loc_table.appendChild(loc_th);
    }
}

