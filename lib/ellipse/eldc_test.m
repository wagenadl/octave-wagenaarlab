function eldc_test
el.x0=1; el.y0=2; el.R=2; el.r=1; el.phi=pi/8;
clf
elplot_xyrra(el,32,'b');
set(gca,'buttondownfcn',@eldc_click)


function eldc_click(h,x)
el.x0=1; el.y0=2; el.R=2; el.r=1; el.phi=pi/8;
EL = eldrag_center(el,32,'r');
