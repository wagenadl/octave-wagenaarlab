function y=boxcaravg(x,N)
% y = BOXCARAVG(x,n) passes the vector through a 2N+1 point 
% box car averaging filter.
% If X is a matrix, works in first dimension.

[X_ Y_] = size(x);
if X_==1
  x=x';
end

[X,Y]=size(x);
z=zeros(X,Y,2*N+1);
for n=-N:N
  z(:,:,n+N+1) = shift(x,n);
end

y = mean(z,3);

if X_==1
  y=y';
end
