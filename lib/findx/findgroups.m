function [xx,yy] = findgroups(x,y,plotflag,scaleratio)
% FINDGROUPS - Find groups in series of points
%    grps = FINDGROUPS(x,y) finds groups in the data (x,y), that is, sets
%    of points that are close to each other in a linear fashion.
%    [xx,yy] = FINDGROUPS(x,y) returns cell arrays of points rather than
%    group identifiers.
%    FINDGROUPS(x,y,1) plots the results
%    FINDGROUPS(x,y,plotflag,scaleratio) prescales X-distances by the given
%    factor when calculating distances (but *not* in the [xx,yy] output!).

% This works as follows:
% For each point, find its nearest neighbor and its next nearest neighbor.
% Each point is in the same group as its nearest neighbor by definition.
% It is also in the same group as its next nearest neighbor if that relation
% is reciprocal (or if the nearest neighbor of the next nearest neighbor of
% a point is that point itself).
% We start at the leftmost point, and work from there.

if nargin<3
  plotflag=0;
end

if nargin<4
  scaleratio=1;
end

% -- Preparation --
% Setup id1(k) as the index number of the point nearest to point k,
% and id2(k) as the index of k's next nearest neighbor.
id1=zeros(size(x));
id2=zeros(size(x));
N=length(x);
for k=1:N
  x_=x; 
  x_(k)=inf;
  [dr,id1(k)] = min((x_-x(k)).^2*scaleratio^2+(y-y(k)).^2);
  x_(id1(k))=inf;
  [dr,id2(k)] = min((x_-x(k)).^2*scaleratio^2+(y-y(k)).^2);
end

% -- Core of algorithm --
% Iteratively find the leftmost point that has not been grouped yet, and
% put it in a new group, with all points that should be together with it.
grp=0;
grps=zeros(size(x));
idx=find(grps==0);
while ~isempty(idx)
  [x0,id]=min(x(idx));
  idx=idx(id);
  grp=max(grps)+1;
  grps = fg_add(grps,x,y,idx,grp,id1,id2);
  idx=find(grps==0);
end

% -- Prepare output: either indices, or coordinates --
if nargout==1
  xx=grps;
else
  xx=cell(grp,1);
  yy=cell(grp,1);
  for k=1:grp
    idx=find(grps==k);
    xx{k}=x(idx);
    yy{k}=y(idx);
  end
end

% -- Optionally, plot results --
if plotflag
  clf; hold on
  for k=1:N
    plotarc([x(k) x(id1(k))],[y(k) y(id1(k))],pi/6,'b');
  end
  for k=1:N
    [h,a]=plotarc([x(k) x(id2(k))],[y(k) y(id2(k))],pi/3,'g');
    if grps(id2(k))~=grps(k)
      set(h,'color','r','linest',':');
      set(a,'facec','r');
    end
  end

  clr=jet(1000);
  clr=clr(round(1+[0:grp-1]*999/grp),:);
  for k=1:grp
    plot(x(grps==k),y(grps==k),'.','color',clr(k,:),'markersize',16);
  end
  autoextend
end

function [grps,grp] = fg_add(grps,x,y,k,grp,id1,id2)
grps(k) = grp;
if grps(id1(k))==0
  % Our nearest neighbor was not in any group yet. Let's usurp it.
  [grps,grp] = fg_add(grps,x,y,id1(k),grp,id1,id2);
elseif grps(id1(k)) < grp
  % Our nearest neighbor was already grouped. But it *is* our nearest 
  % neighbor. Let's merge groups.
  targetgrp = grps(id1(k));
  grps(grps==grp) = targetgrp;
  grp = targetgrp;
end
if grps(id2(k))==0 & (id1(id2(k))==k | id2(id2(k))==k )
  grps = fg_add(grps,x,y,id2(k),grp,id1,id2);
end
