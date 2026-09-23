
window.onload = (event) => {
  ReloadMeters();
};

function ReloadMeters()
{
  console.log("page is fully loaded");
  var r = document.querySelector(':root');
  
  let vw = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0)
  let vh = Math.max(document.documentElement.clientHeight || 0, window.innerHeight || 0)
  let ar = vw/vh;
  
  var rs = getComputedStyle(r);
  let loc_base = Number(rs.getPropertyValue('--meter-width-base').replace("%",""))
  let loc_meter_width = vw*loc_base/100
  let loc_meter_height = loc_meter_width/12
  let loc_meter_margin_left = -1*loc_meter_width/2
  let loc_meter_margin_top = -1*loc_meter_height/2
  
  console.log(loc_base);
  console.log(vw);
  console.log(vh);
  console.log(ar);
  r.style.setProperty('--w', String(vw)+"px");
  r.style.setProperty('--h', String(vh)+"px");
  r.style.setProperty('--ar', String(ar));
  r.style.setProperty('--meter-width', String(loc_meter_width)+"px");
  r.style.setProperty('--meter-height', String(loc_meter_height)+"px");
  r.style.setProperty('--meter-margin-left', String(loc_meter_margin_left)+"px");
  r.style.setProperty('--meter-margin-top', String(loc_meter_margin_top)+"px");
}

