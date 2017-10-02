function e=derrorbar(x,y,dy,w)
% e = HALFERRORBAR(x,y,dy,w) - only plots upward
N=length(x);
e=zeros(1,N);
for n=1:N
  e(n)=line([0 0]+x(n),[0 1]*dy(n)+y(n));
end

if nargin>3
  e=[e; zeros(1,N)];
  for n=1:N
    e(2,n) = line([-w w]+x(n),[1 1]*dy(n)+y(n));
  end
end
