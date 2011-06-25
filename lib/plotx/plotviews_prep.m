function [l,ll,tt]=plotviews_prep(xdim,ydim,lbls)
% l = PLOTVIEWS_PREP(xdim,ydim) creates a graph ready for PLOTVIEWS.
% [l,ll] = PLOTVIEWS_PREP(...) also plots gray lines half way.
% [l,ll,tt] = PLOTVIEWS_PREP(...,lbls) adds labels to the axes

[R,C] = size(xdim);

clf; axes('position',[0 0 1 1]);

for c=1:C-1
  l(c) = line([c c],[0 R]);
end
for r=1:R-1
  l(r+C-1) = line([0 C],[r r]);
end
set(l,'color','k');

if nargout>=2

  ll = zeros(C,R,2);
  tt = zeros(C,R,2);
  for c=1:C
    for r=1:R
      if xdim(r,c) & ydim(r,c)
	ll(c,r,1) = line([.05 .95]+c-1,[.5 .5]+(2-r));
	ll(c,r,2) = line([.5 .5]+c-1,[.05 .95]+(2-r));
	if nargin>=3
	  tt(c,r,1) = text(.95+c-1,.48+R-r,lbls{xdim(r,c)});
	  tt(c,r,2) = text(.48+c-1,.95+R-r,lbls{ydim(r,c)});
	end
      end
    end
  end
  set(ll(ll>0),'color',[.7 .7 .7]);
  
  if nargin>=3
    set(tt(tt>0),'horizontala','right');
    set(tt(tt>0),'verticala','top');
  end

end

set(gca,'xtick',[0:C]);
set(gca,'ytick',[0:R]);
set(gca,'xtickl',[]);
set(gca,'ytickl',[]);
set(gca,'box','on') 
hold on

if nargout<1
  clear l
end
