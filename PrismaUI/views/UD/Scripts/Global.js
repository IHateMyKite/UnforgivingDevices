
window.onload = (event) => {
  console.log("page is fully loaded");
  var r = document.querySelector(':root');
  
  let vw = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0)
  let vh = Math.max(document.documentElement.clientHeight || 0, window.innerHeight || 0)
  let ar = vw/vh;
  
  r.style.setProperty('--w', String(vw)+"px");
  r.style.setProperty('--h', String(vh)+"px");
  r.style.setProperty('--ar', String(ar));
};
