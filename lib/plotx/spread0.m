function yy=spread0(xx,dx)
% SPREAD0 - Returns data replaced with uniform spread
%    yy = SPREAD0(xx,dx) where xx is an N-vector returns
%    yy = ([.5:N]-(N/2))*dx/(N/2).
%    See also: JITTER0

N=length(xx);
yy = [1:N]; 
yy=yy-mean(yy); 
yy=yy*dx/(N/2);
if size(xx,1)>1
  yy=yy';
end
