function blobroi_click(h,x)
% BLOBROI_CLICK - Handle click in a blobroi window
% Semantics are:
%   If nothing was selected, this may select a blob, or, if none near, start
%     creating a new one.
%   If there was a selection, this moves the edge if the click was closer 
%     to the edge then to the center, and if it was no more than 2 pixels
%     outside of the greatest diameter.
blobs = getappdata(h,'blob_blobs');
idx = getappdata(h,'blob_idx');
axes_h = getappdata(h,'blob_axes_h');
xy1 = get(axes_h,'currentpoint');
xy1 = xy1(1,1:2);

if idx
  % We have a selected blob, so we will change it or deselect it
  xy0 = mean(blobs{idx},1);
  dx = xy1(1)-blobs{idx}(:,1);
  dy = xy1(2)-blobs{idx}(:,2);
  dr0 = sqrt(sum((xy1-xy0).^2)); % Distance to center
  dr1 = min(sqrt(dx.^2+dy.^2));
  if dr0<dr1
    % We are closer to the center, let's deselect
    setappdata(h,'blob_idx',0);
    blobroi_redraw(h);
    % But don't set idx=0 'coz we don't want to reselect imm'ly.
  else
    dx0 = blobs{idx}(:,1)-xy0(1);
    dy0 = blobs{idx}(:,2)-xy0(2);
    drr = sqrt(dx0.^2+dy0.^2);
    if dr0<max(drr)+2
      setappdata(h,'blob_lastphi',[]);
      setappdata(h,'blob_lastr',[]);
      blobroi_adjust(h, xy1); 
      set(h,'WindowButtonMotionFcn',@blobroi_move);
    else
      idx = 0;
      setappdata(h,'blob_idx',0);
      blobroi_redraw(h);
    end
  end
end
if ~idx
  % We might select a blob, if click is inside one
  d_near=inf;
  i_near=nan;
  for k=1:length(blobs)
    xy0 = mean(blobs{k},1);
    dr0 = sqrt(sum((xy1-xy0).^2));
    if dr0 < d_near
      d_near = dr0;
      i_near = k;
    end
  end
  if ~isnan(i_near)
    % We have a nearest blob. Do we want to select it?
    % Really, we should check whether we're inside, but we'll take the
    % mean radius as a proxy
    xy0 = mean(blobs{i_near},1);
    dr0 = sqrt(sum((xy1-xy0).^2));
    dx = xy0(1)-blobs{i_near}(:,1);
    dy = xy0(2)-blobs{i_near}(:,2);
    if dr0 > mean(sqrt(dx.^2+dy.^2))
      i_near = nan;
    end
  end
  if ~isnan(i_near)
    % Gotcha
    setappdata(h,'blob_idx',i_near);
    blobroi_redraw(h);
  else
    blobroi_create(h)
  end
end
