var devices = []
var callbacks = []
var selected_device = -1

window.InitDeviceList = (values) => {
  devices = [];
  callbacks = [];
  selected_device = -1;

  //document.getElementById('dm_con_info').textContent = "Select device first";
  //document.getElementById('dm_con_name').textContent = "";

  devices = values.devices;
  document.getElementById('dm_devcnt').textContent = devices.length;
  document.getElementById('dm_wearer').textContent = values.wearer;
  document.getElementById('dm_helper').textContent = values.helper;
  document.getElementById('dm_arousal').textContent = values.arousal;
  document.getElementById('dm_orgasm').textContent = values.orgasm;

  var buttons = document.getElementById('dm_list');
  while (buttons.hasChildNodes()) {
    buttons.removeChild(buttons.firstChild);
  }

//   var minigames = document.getElementById('dm_entry');
  var minigames = document.getElementById('dm_minigames');
  while (minigames.hasChildNodes()) {
    minigames.removeChild(minigames.firstChild);
  }

  for (let i = 0; i < devices.length; i++) {
    var button1 = document.createElement('button');
    button1.textContent = devices[i].name;
    button1.className = 'dm_entry';
    button1.setAttribute('onmouseover', '_DeviceDetails(' + i + ')');
    button1.setAttribute('onclick', '_SelectDevice(' + i + ')');
    console.log(devices[i].name);
    buttons.appendChild(button1);
  }

  callbacks = values.callbacks;

  var controls = document.getElementById('dm_con_callbacks');

  while (controls.hasChildNodes()) {
    controls.removeChild(controls.firstChild);
  }

  if (callbacks) {
    for (let i = 0; i < callbacks.length; i++) {
      var header = document.createElement('th');
      header.className = 'dm_con_h';
      header.id = 'dm_con_h_callback';
      controls.appendChild(header);
      var button = document.createElement('button');
      button.textContent = callbacks[i].name;
      if (callbacks[i].module == 'this') button.className = 'dm_control_dis';
      else {
        button.setAttribute('onclick', '_SendCallback(' + i + ')');
        button.className = 'dm_control_ena';
      }
      header.appendChild(button);
    }
  }

  if (devices.length != 0) _DeviceDetails(0);

  var main = document.getElementById('main');
  main.style = 'display: visible;';
};

function _SendCallback(indx) {
    console.log("_SendCallback("+selected_device+","+indx+")")
    if (selected_device >= 0 || callbacks[indx].module != "this")
    {
        window.SendCallback(selected_device + "," + indx);
    }
};

function _SelectDevice(arg)
{
    if (devices.length == 0) return;
    
    var buttons = document.getElementById("dm_list");
    if (selected_device >= 0)
    {
        var loc_selecteddevice = buttons.childNodes[selected_device];
        loc_selecteddevice.className = "dm_entry";
    }
    
    selected_device = arg;
    
    var loc_device = buttons.childNodes[selected_device];
    loc_device.className = "dm_entry_selected";
    
    if (callbacks)
    {
        var loc_buttons = document.getElementById("dm_con_callbacks");
        for (let i = 0; i < callbacks.length; i++) 
        {
            if (callbacks[i].module == "this") 
            {
                let button = loc_buttons.children[i].firstChild
                button.setAttribute("onclick","_SendCallback("+i+")")
                button.className = "dm_control_ena";
            }
        }
    }
    
    _DeviceDetails(arg);
}

function _DeviceDetails(arg) {
    
    document.getElementById('dm_description').textContent   = devices[arg].desc
    
    _InitValueDetails(arg)
    
    console.log("_DeviceDetails("+arg+")")
    let loc_mods = document.getElementById('dm_modifiers')
    while (loc_mods.hasChildNodes()) {
      loc_mods.removeChild(loc_mods.firstChild);
    }
    
    for (let i = 0; i < devices[arg].mods.length; i++)
    {
        var loc_modbutton = document.createElement("button");
        loc_modbutton.textContent = devices[arg].mods[i].name;
        loc_modbutton.className = "dm_entry"
        loc_modbutton.setAttribute("onmouseover","ShowDetails(event,\""+devices[arg].mods[i].desc+"\")")
        loc_modbutton.setAttribute("onmouseout","HideDetails(event)")
        loc_mods.appendChild(loc_modbutton);
    }
    
    let loc_minigames = document.getElementById('dm_minigames')
    while (loc_minigames.hasChildNodes()) {
      loc_minigames.removeChild(loc_minigames.firstChild);
    }
    for (let i = 0; i < devices[arg].minigames.length; i++)
    {
        var loc_button = document.createElement("button");
        loc_button.textContent = devices[arg].minigames[i].name;
        if (devices[arg].minigames[i].state == 1) loc_button.className = "dm_entry_enabled"
        else loc_button.className = "dm_entry_disabled"
        loc_button.setAttribute("onmouseover","ShowDetails(event,\""+devices[arg].minigames[i].desc+"\")")
        loc_button.setAttribute("onmouseout","HideDetails(event)")
        loc_button.setAttribute("onclick","_StartMinigame("+arg+","+i+")")
        loc_minigames.appendChild(loc_button);
    }
};

function ShowDetails(event, str)
{
    d = document.getElementById('dm_Detail');
    d.innerText = str;
    d.style.setProperty("top",event.clientY-10+"px")
    d.style.setProperty("left",event.clientX+"px")
    d.style.setProperty("display","inline")
}

function HideDetails(event)
{
    d = document.getElementById('dm_Detail');
    d.innerText = "";
    d.style.setProperty("display","none")
}

function _InitValueDetails(arg)
{
    let loc_values = document.getElementById('dm_detailtable')
    while (loc_values.hasChildNodes()) {
      loc_values.removeChild(loc_values.firstChild);
    }
    
    for (let i = 0; i < devices[arg].values.length; i++)
    {
        let loc_value = devices[arg].values[i];
        
        var loc_tr = document.createElement("tr");
        
        var loc_th_name = document.createElement("th");
        loc_th_name.className   = "dm_det_value_h";
        loc_th_name.textContent = loc_value.name;
        loc_tr.appendChild(loc_th_name);
        
        var loc_th_value = document.createElement("th");
        loc_th_value.className   = "dm_det_value";
        if (loc_value.id) loc_th_value.id = loc_value.id;
        loc_th_value.textContent = loc_value.value;
        loc_tr.appendChild(loc_th_value);
        
        loc_values.appendChild(loc_tr);
        
    }
}

function _Exit(arg) {
    window.ExitMenu(arg);
};

function _StartMinigame(dev,min)
{
    if (devices[dev].minigames[min].state == 1) StartMinigame(dev+","+devices[dev].minigames[min].id)
}