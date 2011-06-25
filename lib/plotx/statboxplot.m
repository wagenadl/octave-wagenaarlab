function p=statboxplot(x,w,yy,pbot,plow,pmed,phigh,ptop)
% STATBOXPLOT   Plot box and edges based on statistics of distribution
%    STATBOXPLOT(x,w,yy,pbot,plow,pmed,phigh,ptop) plots a box of 
%    width W at horizontal position X, based on the percentiles of YY.
%    At PBOT and PTOP, horizontal lines are drawn.
%    From PLOW to PHIGH a box is drawn, with a mark at PMED.
%    All of these are specified as a fraction 0--1, rather than a percentile.
%    p = STATBOXPLOT(...) returns a structure of handles:
%    p.pf is the handle of the fill of the box.
%    p.pl are the handles of the various lines:
%      (1): the vertical line between BOT and LOW;
%      (2): the vertical line between TOP and HIGH;
%      (3): the horizontal line at BOT;
%      (4): the horizontal line at TOP;
%      (5): the horizontal line at MED.

if prod(size(w))>1
  error('STATBOXPLOT now takes (x,w,yy,pbot,...) as args. Please update your code');
end

yavg = mean(yy);
srt = sort(yy);
Y=length(srt);
ybot = srt(ceil(pbot*Y+1e-9));
ylow = srt(ceil(plow*Y+1e-9));
ymed = srt(ceil(pmed*Y+1e-9));
yhigh = srt(ceil(phigh*Y+1e-9));
ytop = srt(ceil(ptop*Y+1e-9));

pf=fill(x+[-w w w/2 w -w -w/2 -w],[ylow ylow ymed yhigh yhigh ymed ylow],'c');
p1=line([x x],[ybot ylow]);
p2=line([x x],[yhigh ytop]);
p3=line([-w w]+x,[ybot ybot]);
p4=line([-w w]+x,[ytop ytop]);
p5=line([-w w]/2+x,[ymed ymed]);
% pa=line([-w w]+x,[yavg yavg]);

pl = [p1 p2 p3 p4 p5];

set(pf,'edgec','k');
set(pf,'facec',[.7 .7 .7]);
set(pl,'color','k');
% set(pa,'color','b');

if nargout>0
  p.pf=pf;
  p.pl=pl;
  % p.pa=pa;
end
