function [xx0,qq0] = gausspart2_iter(xx,yy,lvl)
% xx0 = GAUSSPART2_ITER(xx,yy) finds many positions X0 to split the 
% histogram XX,YY optimally.
% It shifts X0 around, always finding mu+ and mu-: the c.o.m. of the left
% and right parts. It then sets sigma := (mu+ - mu-)/4, and finds
% p0 = sum(histo .* gauss(x0,sigma)) and 
% p+- = sum(histo .* gauss(mu+-,sigma)).
% It finds the value of x0 for which p0 / sqrt(p+ * p-) is minimal.
% If the quotient is not less than 1, nan is returned.

if nargin<2
  if isempty(xx)
    xx0=[];
    if nargout>1
      qq0=[];
    end
    return
  end
  xx=sort(xx); X=length(xx);
  x0=xx(ceil(X*.01));
  x1=xx(ceil(X*.99));
  dx=x1-x0+1e-9;
  [yy,xx] = hist(xx,[x0-dx:dx/333:x1+dx]);
end

if nargin<3
  lvl=0;
end

[x0,q0] = gausspart2(xx,yy);
%fprintf(1,'xx=[%.3f,%.3f] -> %.3f\n',xx(1),xx(end),x0);
%hold on; plot(x0,exp(-q0),'r.');
xx0 = [];
qq0 = [];
if ~isnan(x0)
  if lvl<10 & sum(yy(xx<x0))>=10
    [xx0,qq0] = gausspart2_iter(xx(xx<x0),yy(xx<x0),lvl+1);
  end
  xx0 = [xx0 x0]; qq0 = [qq0 q0];
  if lvl<10 & sum(yy(xx>x0))>=10
    [x0_,q0_] = gausspart2_iter(xx(xx>x0),yy(xx>x0),lvl+1);
    xx0 = [xx0 x0_]; qq0 = [qq0 q0_];
  end
end

