function blobroi_create(h)
% BLOBROI_CREATE - Create new blob
%   Called in response to a button press away from old ROIs, this starts
%   a drag that creates a new blob.
%   This new blob is initially drawn in red.
%   Once the mouse is released, the outline is converted to proper blobroi
%   format iff its radius is at least five pixels.
axes_h = getappdata(h,'blob_axes_h');
xy1 = get(axes_h,'currentpoint');
xy1 = xy1(1,1:2);
setappdata(h,'blob_newblob',xy1);
set(h,'WindowButtonMotionFcn',@blobroi_createdrag);
set(h,'windowbuttonupfcn',@blobroi_createdone);
axes(axes_h);
x=ishold;
hold on
h0 = plot(xy1(1),xy1(2),'r-');
if ~x
  hold off
end
setappdata(h,'blob_newh',h0);

function blobroi_createdrag(h,x)
axes_h = getappdata(h,'blob_axes_h');
xy=getappdata(h,'blob_newblob');
xy1 = get(axes_h,'currentpoint');
xy1 = xy1(1,1:2);
xy=[xy; xy1];
h0 = getappdata(h,'blob_newh');
set(h0, 'xdata',xy(:,1), 'ydata',xy(:,2));
setappdata(h,'blob_newblob',xy);

function blobroi_createdone(h,x)
axes_h = getappdata(h,'blob_axes_h');
xy=getappdata(h,'blob_newblob');
set(h,'windowbuttonupfcn',@blobroi_unclick);
set(h,'windowbuttonmotionfcn',[]);
h0 = getappdata(h,'blob_newh');
delete(h0);

phi=getappdata(h,'blob_phi');

xy0 = mean(xy,1);
dx = xy(:,1)-xy0(1);
dy = xy(:,2)-xy0(2);
dr = sqrt(dx.^2 + dy.^2);
if max(dr)<5
  % Too tiny, let's forget about it
  return
end

phi1 = atan2(dy,dx);
phi1(phi1<=0) = phi1(phi1<=0)+2*pi;
[phi1,ord] = sort(phi1);
xy=xy(ord,:);
phi1=[0;phi1;2*pi];
xy1 = (xy(1,:)+xy(end,:))/2;
xy=[xy1; xy; xy1];
[phi1,idx] = uniq(phi1);
xy = xy(idx,:);
xx = interp1(phi1,xy(:,1),phi);
yy = interp1(phi1,xy(:,2),phi);

blobs = getappdata(h,'blob_blobs');
blobs{end+1} = [xx yy];
setappdata(h,'blob_blobs',blobs);
setappdata(h,'blob_idx',length(blobs));
blobroi_redraw(h);
