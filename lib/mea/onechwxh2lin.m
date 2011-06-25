function onechwxh2lin(spks,hw,binsw,binsh)
% ONECHWXH2lin(spks,hw,binsw,binsh) plots a scatter plots of the spike 
% width x height distribution in the given spks.
% spks must be structured as per LOADSPKS.
% This version uses linear scale for counts.

if (nargin<3)
  binsw=10;
end
if (nargin<4)
  binsh=binsw;
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

N=length(spks);
i=hw;
idx = find(spks.channel==i);
%  plot(spks.width(idx),spks.height(idx),'r.');


hnow = spks.height(idx);
wnow = spks.width(idx);
nnow=size(hnow,2);
tnow = spks.time(idx);
dtnow = cat(2,[100],tnow(2:nnow)-tnow(1:(nnow-1))) .* 1000;
dtnow(dtnow>40)=40;

% Add noise to remove aliasing: fill out digital steps
%  hrnd = (rand(1,nnow)-.5) * 341/2048;
%  wrnd = (rand(1,nnow)-.5) / 25;
%  hnow = hnow + hrnd;
%  wnow = wnow + wrnd;
  
minh = min(hnow);
maxh = max(hnow);
minh = minh - marg*(maxh-minh);
maxh = maxh + marg*(1-marg)*(maxh-minh);
dh = (maxh+.0001-minh) / binsh;
maxw = max(wnow)*(1+marg);
minw = -marg*(1-marg)*maxw;
dw = (maxw+.0001-minw) / binsw;

% Recompute bin sizes to avoid sampling problems
dw = round(dw*25)/25; if dw<1/25, dw=1/25; end;
dh = round(dh*2048/341)*341/2048; if dh<341/2048, dh=341/2048; end;
hei = floor((hnow-minh)/dh)+1;
wid = floor((wnow-minw)/dw)+1;
binsh=ceil((maxh-minh)/dh);
binsw=ceil((maxw-minw)/dw);

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
%  whos
%  keyboard
%subplot(2,2,1);
%  subplot(8,8,hw2cr(i));
pcolor(repmat(ww,[1 size(ct,2)]),repmat(hh,[size(ct,1) 1]),ct);
colormap(cmap);
shading flat;
colorbar;
title(sprintf('Channel CR=%i',hw2crd(i)));
xlabel('Width (ms)');
ylabel('Height (uV)');

%subplot(2,2,3);
%%  subplot(8,8,hw2cr(i));
%[ y, x ] = hist(wnow,ww);
%bar(x+dw*.5, log10(y));
%title(sprintf('Channel CR=%i',hw2crd(i)));
%xlabel('Log10(Width (ms))');
%ylabel('Count');
%colorbar;
%axis tight;
%  
%subplot(2,2,2);
%%  subplot(8,8,hw2cr(i));
%[y, x] = hist(hnow,hh);
%barh(x+dh*.5,log10(y));
%title(sprintf('Channel CR=%i',hw2crd(i)));
%xlabel('Count');
%ylabel('Log10(Height (uV))');
%axis tight;
%
%return;
%
%subplot(2,2,4);
%autocontour(dtnow,hnow,binsw,binsh);
%title(sprintf('Channel CR=%i',hw2crd(i)));
%xlabel('ISI_{before} (ms)');
%ylabel('Height (uV)');

