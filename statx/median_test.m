function p = median_test(xx,yy)
% MEDIAN_TEST - Test for significant difference of two medians
%   p = MEDIAN_TEST(xx,yy) returns the one-tailed probability that 
%   H0: median(XX) <= median(YY) holds, given the data.

nx=length(xx);
ny=length(yy);
N=nx+ny;
med=median([xx(:);yy(:)]);
mx=sum(xx<med);
my=sum(yy<med);
m=mx+my;
if nx<ny
  n1=nx;
  H=mx;
  flip=0;
else
  n1=ny;
  H=my;
  flip=1;
end

%keyboard

if n1>=130;
  Z = (H + 0.5 - (n1*m/N)) / sqrt(n1*(N-n1)*N*(N-m)/(N*N*(N-1)));
  p = cdf_norm(Z);
else
  if H<m/2
    p=0;
    for k=0:H
      p = p + out(k,m)*out(n1-k,N-m)/out(n1,N);
    end
  else
    p=1;
    for k=H:m
      p = p - out(k,m)*out(n1-k,N-m)/out(n1,N);
    end
  end
end

if flip
  p=1-p;
end

function n=out(k,N)
n=factorial(N)/(factorial(k)*factorial(N-k));

