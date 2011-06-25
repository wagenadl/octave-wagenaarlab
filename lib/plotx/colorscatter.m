function colorscatter(x,y,binsw,binsh,xnoise,ynoise)
% COLORSCATTER(x,y,binsw,binsh,xnoise,ynoise) plots a scatter plots of the
% distribution of points (x,y).
% If xnoise and ynoise are given, they specify noise to be added for
% the prevention of aliasing.

if (nargin<3)
  binsw=10;
end
if (nargin<4)
  binsh=binsw;
end
if (nargin<5)
  xnoise=0;
end
if (nargin<6)
  ynoise=0;
end

% make color map

cc=[0:.0002:1];
% For on screen:
% red-yellow-white on black
rr=2*cc+.5; rr(1)=0; rr(rr>1)=1;
gg=cc*1.3; gg(gg>1)=1;
bb=2*cc-1; bb(bb<0)=0;

% For on screen, alternative
% white-green-red
%rr=1-sin(cc*pi); rr(rr<0)=0;
%gg=cos(cc*pi/2); gg(gg<0)=0;
%bb=1-80*sin(cc*pi/2); bb(bb<0)=0;

% For printout - use gimp's solid color option after screen grab
% yellow-red-black on white
gg=1-2*cc; gg(gg<0)=0; gg=gg.^1.5;
bb=0*cc; bb(1)=1;
rr=2-2*cc; rr(rr>1)=1; rr=(rr+rr.^1.5)/2;

cmap=[rr',gg',bb'];   

marg = .1;

hnow = y;
wnow = x;
  
% Add noise to remove aliasing: fill out digital steps
hrnd = (rand(1,nnow)-.5) .* ynoise;
wrnd = (rand(1,nnow)-.5) .* xnoise;
hnow = hnow + hrnd;
wnow = wnow + wrnd;
  
minh = min(hnow);
maxh = max(hnow);
minh = minh - marg*(maxh-minh);
maxh = maxh + marg*(1-marg)*(maxh-minh);
dh = (maxh+.0001-minh) / binsh;
maxw = max(wnow)*(1+marg);
minw = -marg*(1-marg)*maxw;
dw = (maxw+.0001-minw) / binsw;
hei = floor((hnow-minh)/dh)+1;
wid = floor((wnow-minw)/dw)+1;
  
% add junk to ensure all columns and rows are really generated
wid2 = cat(2,wid,[1:binsw],[1:binsh]+1000);
hei2 = cat(2,hei,[1:binsw]+1000,[1:binsh]);
cta = crosstab(wid2,hei2);
ct = cta(1:binsw,1:binsh);
w0 = minw + .5*dw;
w1 = minw + (size(ct,1)-.5)*dw;
h0 = minh + .5*dh;
h1 = minh + (size(ct,2)-.5)*dh;

ww = [w0:dw:w1]';
hh = [h0:dh:h1];

pcolor(repmat(ww,[1 size(ct,2)]),repmat(hh,[size(ct,1) 1]),ct);
colormap(cmap);
shading flat;
colorbar;
