function e=Errorbar(x,y,dx,dy,w,h)
N=length(x);
e=zeros(2,N);
for n=1:N
  e(1,n)=line([0 0]+x(n),[-1 1]*dy(n)+y(n));
  e(2,n)=line([-1 1]*dx(n)+x(n),[0 0]+y(n));
end

if nargin>4
  e=[e; zeros(4,N)];
  for n=1:N
    e(3,n) = line([-w w]+x(n),[1 1]*dy(n)+y(n));
    e(4,n) = line([-w w]+x(n),[-1 -1]*dy(n)+y(n));
    e(3,n) = line([-1 -1]*dx(n)+x(n),[-h h]+y(n));
    e(4,n) = line([1 1]*dx(n)+x(n),[-h h]+y(n));
  end
end
