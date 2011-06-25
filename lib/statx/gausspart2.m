function [x0,q0] = gausspart2(xx,yy)
% x0 = GAUSSPART2(xx,yy) finds a position X0 to split the histogram XX,YY
% optimally.
% It shifts X0 around, always finding mu+ and mu-: the c.o.m. of the left
% and right parts. It then sets sigma := (mu+ - mu-)/4, and finds
% p0 = sum(histo .* gauss(x0,sigma)) and 
% p+- = sum(histo .* gauss(mu+-,sigma)).
% It finds the value of x0 for which p0 / sqrt(p+ * p-) is minimal.
% If the quotient is not less than 1, nan is returned.

if nargin<2
  if length(xx)<10
    x0=nan;
    if nargout>1
      q0=nan;
    end
    return
  end
  xx=sort(xx); X=length(xx);
  x0=xx(ceil(X*.01));
  x1=xx(ceil(X*.99));
  dx=x1-x0 + 1e-9;
  %   fprintf(1,'X=%i x0=%.3f x1=%.3f\n',X,x0,x1);
  [yy,xx] = hist(xx,[x0-dx:dx/333:x1+dx]);
end

X=length(xx);
sy0=sum(yy);
mu0 = sum(xx.*yy)./sy0;
sig02 = sum((xx-mu0).^2.*yy) ./ sy0;

sigm_thr = sqrt(sig02) ./ sqrt(sy0);

qual = zeros(size(xx))+inf;
 mmm=zeros(size(xx))+nan;
 mmp=mmm; pp0=mmm; ppmin=mmm;ppplus=mmm;

for k=1:X-1
  x0 = (xx(k)+xx(k+1))/2;
  sy_min = sum(yy(1:k));
  sy_plus = sum(yy(k+1:end));
  if sy_min>=5 & sy_plus>=5
    mu_min = sum(xx(1:k).*yy(1:k)) ./ (sum(yy(1:k))+1e-9);
    mu_plus = sum(xx(k+1:end).*yy(k+1:end)) ./ (sum(yy(k+1:end))+1e-9);
    mmm(k)=mu_min;
     mmp(k)=mu_plus;
    sigm = max([(mu_plus + mu_min)/10, sigm_thr]);
    p0 = sum(yy.*exp(-.5*(xx-x0).^2./sigm.^2));
    p_min = sum(yy.*exp(-.5*(xx-mu_min).^2./sigm.^2));
    p_plus = sum(yy.*exp(-.5*(xx-mu_plus).^2./sigm.^2));
    qual(k) = p0 ./ min([p_min p_plus]);
     pp0(k) = p0;
     ppmin(k) = p_min;
     ppplus(k) = p_plus;
  end
end

[q0,id0] = min(qual);
if q0<1 | nargout==2
  x0 = (xx(id0)+xx(id0+1))/2;
else
  x0 = nan;
end

if nargout<2
  clear q0;
end
