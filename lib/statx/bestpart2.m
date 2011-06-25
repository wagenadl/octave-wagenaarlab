function x0 = bestpart2(xx)
% x0 = BESTPART2(XX) finds the best value X0 to split the one-dimensional
% data XX at so that it splits up in two subsets s.t. the squared distance
% to the means is minimal.

xx=sort(xx);
X=length(xx);
err=zeros(1,X)+inf;
for x=1:X-1
  mn1 = mean(xx(1:x));
  mn2 = mean(xx(x+1:X));
  err1 = sum((xx(1:x)-mn1).^2);
  err2 = sum((xx(x+1:X)-mn2).^2);
  err(x) = err1+err2;
end
[err0,idx]=min(err);
x0 = mean(xx(idx:idx+1));
