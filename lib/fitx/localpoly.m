function yy = localpoly(xx,L,P,alpha)
% LOCALPOLY - Local polynomial spline approximation
%    yy = LOCALPOLY(xx,L,P) fits a series of splines of halfbase L and
%    order P to the data XX, and returns the resulting curve.
%    yy = LOCALPOLY(xx,L,P,alpha) specifies what happens at edges:
%    ALPHA=0 means use progressively shorter bases at the edge, ALPHA=1 means
%    use more and more asymmetric bases at the edge. Intermediate values
%    are allowed. Default is ALPHA=0. ALPHA may be a scalar or two numbers,
%    to specify start and and asymmetries separately.

if nargin<4
  alpha=0;
end

if nargin<3
  error('Not enough arguments');
end

if length(xx) ~= prod(size(xx))
  error('xx must be a vector');
end

if length(alpha)==1
  alpha=[alpha alpha];
end

N=length(xx);
yy=zeros(size(xx));

xx=xx(:)';

i0=1;
for k=1:L
  i1=L+round(alpha(1)*L + (1-alpha(1))*k);
  tt=[i0:i1]-k;
  p=polyfit(tt,xx(i0:i1),P);
  yy(k)=p(end);
end
for k=L+1:N-L
  i0=k-L; i1=k+L;
  tt=[i0:i1]-k;
  p=polyfit(tt,xx(i0:i1),P);
  yy(k)=p(end);
end
i1=N;
for k=N-L+1:N
  i0=N+1-L-round(alpha(2)*L + (1-alpha(2))*(N+1-k));
  tt=[i0:i1]-k;
  p=polyfit(tt,xx(i0:i1),P);
  yy(k)=p(end);
end
