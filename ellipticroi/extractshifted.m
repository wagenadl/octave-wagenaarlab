function [pxs,ims,dx,dy] = extractshifted(imgs,xyrra,R,idx,ref,tst)
% EXTRACTSHIFTED - Motion artifact reduced vsn of EXTRACTELLIPTICROI
%   pxs = EXTRACTSHIFTED(imgs,xyrra,R) is like EXTRACTELLIPTICROI, after
%   first applying CALCIMSHIFT / IMSHIFT.
%   pxs = EXTRACTSHIFTED(imgs,xyrra,R,idx,ref) calculates shifts based on
%   frames in IDX and assumes that XYRRA is defined relative to frame(s) REF.
%   Default is IDX=(all frames), REF=(first frame).
%   If IMGS is YxXxTx2 and XYRRA is a 2x1 cell array, this works on two 
%   channels of (vsd) image sequences in parallel: shift is first
%   independently calculated for the two sequences, then a consensus shift
%   is calculated as the average between the two sequences, and this is
%   used for extracting the pixels. In this case, PXS will be a 2x1 cell array.
%   [pxs,ims,dx,dy] also returns the relevant rectangular area of the shifted
%   images as well as the calculated shifts.

[Y X T Q]=size(imgs);
if ~iscell(xyrra)
  xyrra={xyrra};
end
if nargin<5 | isempty(ref)
  ref=1;
end
if nargin<4 | isempty(idx)
  idx=[1:T];
end
if nargin<6
  tst=0;
end
if length(xyrra)<Q
  for q=2:Q
    xyrra{q} = xyrra{1};
  end
end


R1=3;

for q=1:Q
  xywh = elbbox(xyrra{q});
  rx=xywh(3)/2;
  ry=xywh(4)/2;
  
  x0 = floor(xyrra{q}(1) - rx - R1 - R);
  x1 = ceil(xyrra{q}(1) + rx + R1 + R);
  y0 = floor(xyrra{q}(2) - ry - R1 - R);
  y1 = ceil(xyrra{q}(2) + ry + R1 + R);

  x0=max(x0,1);
  x1=min(x1,X);
  y0=max(y0,1);
  y1=min(y1,Y);

  ims{q}=imgs(y0:y1,x0:x1,:,q);
  
  [dx{q},dy{q}]=calcimshift(ims{q},R,idx);
  dx{q}=dx{q}-mean(dx{q}(ref));
  dy{q}=dy{q}-mean(dy{q}(ref));
end

if Q==2
  dx = (dx{1}+dx{2})/2;
  dy = (dy{1}+dy{2})/2;
elseif Q==1
  dx = dx{1};
  dy = dy{1};
else
  error('EXTRACTSHIFTED assumes either 1 or 2 channels.');
end
if tst
  dx=0*dx;
  dy=0*dy;
end

if any(dx.^2+dy.^2 > R^2/2)
  warning('EXTRACTSHIFTED: dangerously large shift detected');
end

for q=1:Q
  ims{q}=imshift(ims{q},dx,dy,R);
  
  xyrra{q}(1)=xyrra{q}(1)-x0+1;
  xyrra{q}(2)=xyrra{q}(2)-y0+1;
  
  if Q>1
    pxs{q} = extractellipticroi(ims{q},xyrra{q});
  else
    pxs = extractellipticroi(ims{q},xyrra{q});
  end
end

if nargout>1 & Q==1
  ims=ims{1};
end
