function blobroi_adjust(h, xy1)
phi = getappdata(h,'blob_phi');
blobs = getappdata(h,'blob_blobs');
idx = getappdata(h,'blob_idx');
outline_h = getappdata(h,'blob_outline_hh');
xy0 = mean(blobs{idx},1);
dx1 = xy1(1)-xy0(1);
dy1 = xy1(2)-xy0(2);
dr1 = sqrt(dx1.^2+dy1.^2);
phi1 = atan2(dy1,dx1);

dr2 = getappdata(h,'blob_lastr');
phi2 = getappdata(h,'blob_lastphi');
if isempty(dr2)
  dr2=dr1;
  phi2=phi1;
end
xy2 = xy0+dr2*[cos(phi2),sin(phi2)];

setappdata(h,'blob_lastr',dr1);
setappdata(h,'blob_lastphi',phi1);

% OK. How do I find out if phi lies between phi1 and phi2?
% First, let's get them sorted
if phi1>phi2 
  phi1=phi1-2*pi;
end
% So now, phi1 is always smaller than phi2, but I don't know which way is the shorter distance
if phi2 - phi1 < pi
  % Work on arc from phi1 to phi2
else
  % Swap, then work on arc from phi1 to phi2
  [phi1, phi2] = identity(phi2-2*pi, phi1);
  [xy1,xy2] = identity(xy2,xy1);
end

phi(phi<phi1)=phi(phi<phi1)+2*pi;
phi(phi>phi2)=phi(phi>phi2)-2*pi;
phi(phi>phi2)=phi(phi>phi2)-2*pi;
phi(phi>phi2)=phi(phi>phi2)-2*pi;
near = find(phi>=phi1);
%dr1 = sqrt(sum((xy1-xy0).^2)); % Distance to center
%dr2 = sqrt(sum((xy1-xy0).^2)); % Distance to center from old pt
%
%phi1 = atan2(
%
%circx = dr0*cos(phi)+xy0(1);
%circy = dr0*sin(phi)+xy0(2);
%dx1 = circx-xy1(1);
%dy1 = circy-xy1(2);
%near = find(dx1.^2+dy1.^2 < 2);


if phi2>phi1 & ~isempty(near)
  dq = (phi(near)-phi1) / (phi2-phi1);
  if 0
    dr = dr1*(1-dq) + dr2*dq;
    blobs{idx}(near,1) = xy0(1) + dr.*cos(phi(near));
    blobs{idx}(near,2) = xy0(2) + dr.*sin(phi(near));
  else
    % Could also linearize
    blobs{idx}(near,1) = xy1(1) + dq*(xy2(1)-xy1(1));
    blobs{idx}(near,2) = xy1(2) + dq*(xy2(2)-xy1(2));
  end
else
  blobs{idx}(near,1)=xy1(1);
  blobs{idx}(near,2)=xy1(2);
end

setappdata(h,'blob_blobs',blobs);
set(outline_h(idx), 'xdata',blobs{idx}(:,1), 'ydata',blobs{idx}(:,2));
