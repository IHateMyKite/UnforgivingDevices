var devices = []
var callbacks = []
var selected_device = -1

window.InitDeviceList = (values) => {
    devices = []
    callbacks = []
    selected_device = -1
    
    //document.getElementById('dm_con_info').textContent = "Select device first";
    //document.getElementById('dm_con_name').textContent = "";
    
    devices = values.devices
    document.getElementById('dm_devcnt').textContent    = devices.length;
    document.getElementById('dm_wearer').textContent    = values.wearer;
    document.getElementById('dm_helper').textContent    = values.helper;
    document.getElementById('dm_arousal').textContent   = values.arousal;
    document.getElementById('dm_orgasm').textContent    = values.orgasm;
    
    var buttons = document.getElementById("dm_list");
    
    while (buttons.hasChildNodes()) {
      buttons.removeChild(buttons.firstChild);
    }
    
    for (let i = 0; i < devices.length; i++) 
    {
        var button1 = document.createElement("button");
        button1.textContent = devices[i].name;
        button1.className = "dm_entry"
        button1.setAttribute("onmouseover","_DeviceDetails("+i+")")
        button1.setAttribute("onclick","_SelectDevice("+i+")")
        console.log(devices[i].name)
        buttons.appendChild(button1);
    }
    
    callbacks = values.callbacks
    
    var controls = document.getElementById("dm_con_callbacks");
    
    while (controls.hasChildNodes()) {
      controls.removeChild(controls.firstChild);
    }
    
    if (callbacks)
    {
        for (let i = 0; i < callbacks.length; i++) 
        {
            var header = document.createElement("th");
            header.className = "dm_con_h"
            header.id = "dm_con_h_callback"
            controls.appendChild(header);
            var button = document.createElement("button");
            button.textContent = callbacks[i].name;
            if (callbacks[i].module == "this") button.className = "dm_control_dis";
            else
            {
                button.setAttribute("onclick","_SendCallback("+i+")")
                button.className = "dm_control_ena";
            }
            header.appendChild(button)
        }
    }
    
    if (devices.length != 0) _DeviceDetails(0)
    
    var main = document.getElementById("main");
    main.style = "display: visible;"
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

    //document.getElementById('dm_det_name').textContent      = devices[arg].name
    //document.getElementById('dm_det_health').textContent    = devices[arg].health
    //document.getElementById('dm_det_cond').textContent      = devices[arg].condition
    //document.getElementById('dm_det_resphys').textContent   = devices[arg].resphys
    //document.getElementById('dm_det_resmagk').textContent   = devices[arg].resmagk
    //document.getElementById('dm_det_lvl').textContent       = devices[arg].level
    
    
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
        loc_modbutton.setAttribute("onmouseover","_ModDetails("+arg+","+i+")")
        loc_modbutton.setAttribute("onmouseout","_ModDetailsReset()")
        loc_mods.appendChild(loc_modbutton);
    }
};

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

function _ModDetails(arg1,arg2)
{
    
    let loc_mod = devices[arg1].mods[arg2]
    document.getElementById('dm_mod_name').textContent   = loc_mod.name
    document.getElementById('dm_mod_desc').textContent   = loc_mod.desc
};

function _ModDetailsReset()
{
    document.getElementById('dm_mod_name').textContent   = ""
    document.getElementById('dm_mod_desc').textContent   = ""
}


function _Exit(arg) {
    window.ExitMenu(arg);
};
