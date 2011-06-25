function pickellipses
% PICKELLIPSE allows the user to add an ellipse to the current image using
% RBELLIPSE.
set(gca,'buttondownfcn',@pe_fcn);
set(get(gca,'children'),'buttondownfcn',@pe_fcn);
setappdata(gca,'ellipses',[]);

function pe_fcn(h,x)
if ~strcmp(get(h,'type'),'axes')
  h=get(h,'parent');
end
xyxy = rbellipse(h);
fprintf(1,'Ellipse: (%.1f,%.1f)-(%.1f,%.1f)\n',xyxy);
xyxys = getappdata(gca,'ellipses');
xyxys = [ xyxys, xyxy'];
setappdata(gca,'ellipses',xyxys);
return
