function [a,b,x,y]=shrinkgon(x,y,p,l,rr)
% [a,b]=SHRINKGON(x,y) returns a set of line segments that encloses
%                      the data cloud (X,Y) most succintly.
% [a,b]=SHRINKGON(x,y,p) discards a fraction P of the points to minimize the
%                        area.
% [a,b,x,y] = SHRINKGON(x,y,p) also returns the identities of the
%                              points still on the inside.
% SHRINKGON(x,y,p,l,r) only considers a fraction L of points nearby the 
%                      previous point, thus relaxing convexity, and
%                      only that subset of those points that are not
%                      farther than R * the maximum existing distance.
% NB - Non-convex polygons don't quite work. I need to rethink the math.

x=x(:);
y=y(:);

if nargin<3 
  p=0;
end
if isempty(p)
  p=0;
end
if nargin<4
  l=1;
end
if nargin<5
  rr=1;
end

if p==0
  % OK, this is the "easy" case.
  
  % Find topmost point
  [y0,idx] = max(y);
  x0 = x(idx); y0=y(idx);
  a=x0; b=y0;

  rr=rr.^2;
  
  if l<1
    r=(y-y0).^2+(x-x0).^2;
    [r,ord]=sort(r);
    if r(ceil(l*length(r)))>rr*r(end)
      ord=ord(1:ceil(l*length(r)));
    else
      ord=ord(find(r<=rr*r(end)));
    end
  else
    ord=[1:length(x)];
  end  
  phi = atan2(y(ord)-y0,x(ord)-x0);
  [phi0,idx] = min(phi);
  idx=ord(idx);
  x0 = x(idx); y0=y(idx);
  a=[a x0]; b=[b y0];
  x=drop(x,idx); y=drop(y,idx);
  while 1
    if l<1
      r=(y-y0).^2+(x-x0).^2;
      [r,ord]=sort(r);
      if r(ceil(l*length(r)))>rr*r(end)
	ord=ord(1:ceil(l*length(r)));
      else
	ord=ord(find(r<=rr*r(end)));
      end
    else
      ord=[1:length(x)];
    end  
    phi = atan2(y(ord)-y0,x(ord)-x0);
    phi(phi<=phi0-pi/2)=inf;
    [phi0,idx] = min(phi);
    idx=ord(idx);
    if phi0==inf
      break
    end
    x0 = x(idx); y0=y(idx);
    a=[a x0]; b=[b y0];
    x=drop(x,idx); y=drop(y,idx);
%    hold on;plot(a,b,'r'); pause
  end
  a=[a a(1)];
  b=[b b(1)];
else
  % Must drop some points
  ndrop = ceil(p*length(x));
  [a,b] = shrinkgon(x,y,[],l,rr);
  for q=1:ndrop
    a=a(2:end); b=b(2:end);
    N=length(a);
    ar=zeros(1,N);
    for n=1:N
      idx = min(find(x==a(n) & y==b(n)));
      [c,d] = shrinkgon(drop(x,idx),drop(y,idx),[],l,rr);
      ar(n) = abs(dpolyarea(c,d));
    end
    [dropar,dropn] = min(ar);
    idx = min(find(x==a(dropn) & y==b(dropn)));
    x = drop(x,idx); y=drop(y,idx);
    [a,b] = shrinkgon(x,y,[],l,rr);
  end
end

  