var devices = []
var selected_device = -1

window.InitDeviceList = (values) => {
    devices = [];
    selected_device = -1;

    devices = values.devices;
    document.getElementById('dm_wearer').textContent = values.wearer;
    document.getElementById('dm_helper').textContent = values.helper;

    var buttons = document.getElementById('dm_list');
    while (buttons.hasChildNodes()) {
        buttons.removeChild(buttons.firstChild);
    }

    var minigames = document.getElementById('dm_minigames');
    while (minigames.hasChildNodes()) {
        minigames.removeChild(minigames.firstChild);
    }

    let loc_detailvalues = document.getElementById('dm_detailtable')
    while (loc_detailvalues.hasChildNodes()) {
        loc_detailvalues.removeChild(loc_detailvalues.firstChild);
    }
    
    var modifiers = document.getElementById('dm_modifiers');
    while (modifiers.hasChildNodes()) {
        modifiers.removeChild(modifiers.firstChild);
    }
    
    HideDetails(null)
    
    for (let i = 0; i < devices.length; i++) {
        var button1 = document.createElement('button');
        button1.textContent = devices[i].name;
        
        var loc_usable = false
        for (let y = 0; y < devices[i].minigames.length; y++)
        {
            if (devices[i].minigames[y].state == 1) 
            {
                loc_usable = true;
                break;
            }
        }
        
        if (loc_usable) button1.className = 'dm_entry';
        else button1.className = 'dm_entry dm_entry_disabled';
        
        button1.setAttribute('onmouseover', '_HoverDeviceOver(event,' + i + ')');
        button1.setAttribute('onclick', '_SelectDevice(' + i + ')');
        //button1.setAttribute("onmouseover","ShowDetails(event,\""+devices[i].desc+"\")")
        button1.setAttribute("onmouseout","HideDetails(event)")
        buttons.appendChild(button1);
    }
    
    _SelectTab(document.getElementById('dm_tabdetailsbutton'),"dm_tabdetails");
    
    var main = document.getElementById('main');
    main.style = 'display: visible;';
};

window.InitDeviceListSingle = (values) => {
    devices = [];
    selected_device = 0;

    devices = values.devices;
    document.getElementById('dm_wearer').textContent = values.wearer;
    document.getElementById('dm_helper').textContent = values.helper;

    var minigames = document.getElementById('dm_minigames');
    while (minigames.hasChildNodes()) {
        minigames.removeChild(minigames.firstChild);
    }

    let context = document.getElementById('dm_Context');
    while (context.hasChildNodes()) {
      context.removeChild(context.firstChild);
    }

    var modifiers = document.getElementById('dm_modifiers');
    while (modifiers.hasChildNodes()) {
        modifiers.removeChild(modifiers.firstChild);
    }

    HideDetails(null)

    var main = document.getElementById('main');
    main.style = 'display: visible;';
    
    if (devices.length != 0) _DeviceDetails(0);
    
    _SelectTab(document.getElementById('dm_tabdetailsbutton'),"dm_tabdetails");
};

function _HoverDeviceOver(event,arg)
{
    ShowDetails(event,devices[arg].desc)
    if (selected_device == -1)
    {
        _DeviceDetails(arg);
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
    
    if (arg == selected_device)
    {
        // Deselect
        selected_device = -1
        return;
    }
    
    selected_device = arg;
    
    var loc_device = buttons.childNodes[selected_device];
    loc_device.className = "dm_entry_selected";
    
    _DeviceDetails(arg);
}

function _DeviceDetails(arg) {
    //document.getElementById('dm_description').textContent   = devices[arg].desc
    
    _InitValueDetails(arg)
    _InitValueLocks(arg)
    
    let loc_mods = document.getElementById('dm_modifiers')
    if (loc_mods)
    {
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
        loc_button.setAttribute("onmouseover","ShowDetailsOrContext(event,"+JSON.stringify(devices[arg])+","+JSON.stringify(devices[arg].minigames[i])+")")
        loc_button.setAttribute("onmouseout","HideDetailsOrContext(event,"+JSON.stringify(devices[arg])+","+JSON.stringify(devices[arg].minigames[i])+")")
        //loc_button.setAttribute("onclick","_StartMinigame("+arg+","+i+",\"\")")
        loc_button.setAttribute("onclick","StartMinigameOrContext(event,"+JSON.stringify(devices[arg])+","+JSON.stringify(devices[arg].minigames[i])+","+arg+","+i+",\"\")")
        loc_minigames.appendChild(loc_button);
    }
};

function ShowDetailsOrContext(event,dev,min)
{
    ShowDetails(event,min.desc)
}

function StartMinigameOrContext(event,dev,min,arg,i,cntx)
{
    if (min.context)
    {
        if (!InContext)
        {
            ShowContext(event,dev,min)
        }
    }
    else
    {
        _StartMinigame(arg,i,cntx)
    }
}

function ShowDetails(event, str)
{
    d = document.getElementById('dm_Detail');
    d.textContent = str;
    d.style.setProperty("top",event.clientY-10+"px")
    d.style.setProperty("left",event.clientX+"px")
    d.style.setProperty("display","inline")
}

function ShowContext(event,dev,min)
{
    let c = document.getElementById('dm_Context');
    while (c.hasChildNodes()) {
      c.removeChild(c.firstChild);
    }
    
    for(let i = 0; i < min.context.length; i++)
    {
        var b = document.createElement("button")
        b.textContent = min.context[i].name
        
        if (min.context[i].state == 1) b.className = "dm_entry_enabled"
        else b.className = "dm_entry_disabled"
        
        b.setAttribute("onclick","ContextSelected(event,"+JSON.stringify(dev)+","+JSON.stringify(min)+","+JSON.stringify(min.context[i])+")")
        c.appendChild(b);
    }
    
    c.style.setProperty("display","inline")
    
    c.style.setProperty("top",event.clientY-c.clientHeight/2+"px")
    c.style.setProperty("left",event.clientX-c.clientWidth/2+"px")
    
    c.setAttribute("onmouseover","ContextEntered(event,"+JSON.stringify(dev)+","+JSON.stringify(min)+")")
    c.setAttribute("onmouseout","ContextLeft(event,"+JSON.stringify(dev)+","+JSON.stringify(min)+")")
    
    InContext = true;
}

InContext = false
function ContextEntered(event,dev,min)
{
    if (MouseOverContext(event) && !InContext)
    {
        InContext = true
    }
}
function ContextLeft(event,dev,min)
{
    if (!MouseOverContext(event) && InContext)
    {
        InContext = false
        HideContext(event,dev,min)
    }
}
function ContextSelected(event,dev,min,cntx)
{
    if (cntx.state == 1)
    {
        let loc_devindx = devices.map(e => JSON.stringify(e)).indexOf(JSON.stringify(dev))
        let loc_minindx = dev.minigames.map(e => JSON.stringify(e)).indexOf(JSON.stringify(min))
        
        console.log(cntx)
        console.log(loc_devindx + "," + loc_minindx)
        _StartMinigame(loc_devindx,loc_minindx,cntx.value)
    }
}

function MouseOverContext(event)
{
    let c = document.getElementById('dm_Context');
    
    var loc_box = {x:c.offsetLeft,y:c.offsetTop,sizeX:c.clientWidth,sizeY:c.clientHeight};
    var loc_mouse = {x:event.clientX,y:event.clientY};
    
    if ((loc_mouse.x > loc_box.x) && (loc_mouse.x < (loc_box.x + loc_box.sizeX)))
    {
        if ((loc_mouse.y > loc_box.y) && (loc_mouse.y < (loc_box.y + loc_box.sizeY)))
        {
            return true;
        }
    }
    return false;
}

function HideDetailsOrContext(event,dev,min)
{
    if (min.context)
    {
        if (!InContext)
        {
            HideContext(event,dev,min)
        }
    }
    else
    {
        HideDetails(event)
    }
}

function HideDetails(event)
{
    d = document.getElementById('dm_Detail');
    d.innerText = "";
    d.style.setProperty("display","none")
}

function HideContext(event,dev,min)
{
    //console.log("HideContext")
    c = document.getElementById('dm_Context');
    c.style.setProperty("display","none")
    
    while (c.hasChildNodes()) {
      c.removeChild(c.firstChild);
    }
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
        loc_tr.className = "dm_detailtable";
        
        var loc_th_name = document.createElement("th");
        loc_th_name.className   = "dm_det_value_h";
        loc_th_name.textContent = loc_value.name;
        loc_tr.appendChild(loc_th_name);
        
        var loc_th_value = document.createElement("th");
        loc_th_value.className   = "dm_det_value";
        if (loc_value.style) loc_th_value.style = loc_value.style;
        loc_th_value.textContent = loc_value.value;
        loc_tr.appendChild(loc_th_value);
        
        loc_values.appendChild(loc_tr);
    }
}

function _OnLockHoverOn(event,arg)
{
    let loc_values = document.getElementById('dm_lockstable')
    while (loc_values.hasChildNodes()) {
      loc_values.removeChild(loc_values.firstChild);
    }
    
    let loc_lock = arg
    
    AddTableRow(loc_values,"dm_lockstable","Name",loc_lock.name)
    AddTableRow(loc_values,"dm_lockstable","Accessibility",'acc' in loc_lock ? loc_lock.acc : 0)
    AddTableRow(loc_values,"dm_lockstable","Difficulty",'diff' in loc_lock ? loc_lock.diff : 0)
    AddTableRow(loc_values,"dm_lockstable","Shields",'shl' in loc_lock ? loc_lock.shl : 0)
    
    let loc_timelocked = 'tmlk' in loc_lock ? loc_lock.tmlk : "false";
    
    if ('unl' in loc_lock && loc_lock.unl) AddTableRow(loc_values,"dm_lockstable","State","Unlocked");
    else if ('jam' in loc_lock && loc_lock.jam) AddTableRow(loc_values,"dm_lockstable","State","Jammed");
    else if (loc_timelocked.toLowerCase() == "true")
    {
        AddTableRow(loc_values,"dm_lockstable","Auto Unlock",'atmlk' in loc_lock ? loc_lock.atmlk : "FALSE")
        AddTableRow(loc_values,"dm_lockstable","Timelock unlocks in",('tml_r' in loc_lock ? Number(loc_lock.tml_r).toFixed(1) : "0.0") + " h")
        AddTableRow(loc_values,"dm_lockstable","State","Timelocked");
    }
    else AddTableRow(loc_values,"dm_lockstable","State","Locked");
}

function AddTableRow(table,classname,name,value)
{
    var loc_tr = document.createElement("tr");
    loc_tr.className = classname;
    
    var loc_th = document.createElement("th");
    loc_th.className   = "dm_det_value_h";
    loc_th.textContent = name;
    loc_tr.appendChild(loc_th);
    loc_th = document.createElement("th");
    loc_th.className   = "dm_det_value";
    loc_th.textContent = value;
    loc_tr.appendChild(loc_th);
    
    table.appendChild(loc_tr);
}

function _OnLockHoverOff(event,arg)
{
    let loc_values = document.getElementById('dm_lockstable')
    while (loc_values.hasChildNodes()) {
      loc_values.removeChild(loc_values.firstChild);
    }
};

function _InitValueLocks(arg)
{
    let loc_values = document.getElementById('dm_lockstable')
    while (loc_values.hasChildNodes()) {
      loc_values.removeChild(loc_values.firstChild);
    }
    
    var loc_lockbuttons = document.getElementById('dm_locklist');
    while (loc_lockbuttons.hasChildNodes()) {
        loc_lockbuttons.removeChild(loc_lockbuttons.firstChild);
    }
    
    var loc_locks = ConvertToIDict(devices[arg].locks);
    Object.keys(loc_locks).forEach(function(key)
    {
        if (key != "n")
        {
            let loc_lock = loc_locks[key]
            var button1 = document.createElement('button');
            
            button1.textContent = loc_lock.name;
            
            let loc_usable = 'unl' in loc_lock && loc_lock.unl;
            if (loc_usable) button1.className = 'dm_entry dm_entry_enabled';
            else button1.className = 'dm_entry dm_entry_disabled';
            
            button1.setAttribute('onmouseover', '_OnLockHoverOn(event,' + JSON.stringify(loc_lock) + ')');
            button1.setAttribute("onmouseout","_OnLockHoverOff(event)")
            loc_lockbuttons.appendChild(button1);
        }
    });
}

// 1 -> Device menu
// 2 -> Device menu Single
function _Exit(arg) {
    console.log("Exit called")
    window.ExitMenu(arg);
};

function _StartMinigame(dev,min,cntx)
{
    if (devices[dev].minigames[min].state == 1) StartMinigame(dev+","+devices[dev].minigames[min].id+","+cntx)
}

function SelectTab(evt, tabName) {
  var i, tabcontent, tablinks;
  tabcontent = document.getElementsByClassName("dm_tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }
  
  tablinks = document.getElementsByClassName("dm_tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }
  
  document.getElementById(tabName).style.display = "block";
  evt.currentTarget.className += " active";
}

function _SelectTab(butt, tabName) {
  var i, tabcontent, tablinks;
  tabcontent = document.getElementsByClassName("dm_tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }
  
  tablinks = document.getElementsByClassName("dm_tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }
  
  document.getElementById(tabName).style.display = "block";
  butt.className += " active";
}