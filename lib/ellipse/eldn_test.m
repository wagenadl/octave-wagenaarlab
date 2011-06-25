function eldn_test
figure(1); clf
axis([-5 5 -5 5]);
hold on
set(gca,'buttondownfcn',@eldn_click)

function eldn_click(h,x)
el = eldrag_new(32,'r');
if ~isempty(el)
  elplot_xyrra(el,32,'b');
end
