function [y,dy] = pf_predict(fform,x,p,spp)
% PF_PREDICT - Predict function values after PHYSFIT
%    [y,dy] = PF_PREDICT(fform, x, p, spp) where FFORM is a function form
%    as for PHYSFIT, P is p(n).p from PHYSFIT, and SPP is p(n).cov from 
%    PHYSFIT, returns extimated function values and their uncertainties.
%
% CAUTION: As of 6/5/07, I have only tested LINEAR and FREEFORM.

switch lower(fform)
  case 'slope'
    foo = inline('p*x', 'x','p');
    dfdp = { inline('x', 'x','p') };
  case 'linear'
    foo = inline('p(1)*x+p(2)', 'x','p');
    dfdp = { inline('x', 'x','p'), ...
	inline('1', 'x','p') };
  case 'quadratic'
    foo = inline('p(1)*x.^2+p(2)*x + p(3)', 'x','p');
    dfdp = { inline('x.^2', 'x','p'), ...
	inline('x', 'x','p'), ...
	inline('1', 'x','p') };
  case 'power'
    foo = inline('p(1)*x.^p(2)', 'x','p');
    dfdp = { inline('x.^p(2)', 'x','p'), ...
	inline('p(1)*log(x).*x^p(2)', 'x','p') };
  case 'log'
    foo = inline('p(1)*log(x)+p(2)', 'x','p');
    dfdp = { inline('log(x)', 'x','p'), ...
	inline('1', 'x','p') };
  case 'exp'
    foo = inline('p(1)*exp(p(2)*x)', 'x','p');
    dfdp = { inline('exp(p(2)*x)', 'x','p'), ...
	inline('p(1)*x.*exp(p(2)*x)', 'x','p') };
    
  case 'expc'
    foo = inline('p(1)*exp(p(2)*x)+p(3)', 'x','p');
    dfdp = { inline('exp(p(2)*x)', 'x','p'), ...
	inline('p(1)*x.*exp(p(2)*x)', 'x','p'), ...
	inline('1', 'x','p') };
  case 'cos'
    foo = inline('p(1)*cos(p(2)*x+p(3))');
    dfdp = { inline('cos(p(2)*x+p(3))', 'x','p'), ...
	inline('-p(1)*x.*sin(p(2)*x+p(3))', 'x','p'), ...
	inline('-p(1)*sin(p(2)*x+p(3))', 'x','p') };
  otherwise
    if length(fform>=6) & strcmp(lower(fform(1:min(5,length(fform)))),'poly-')
      N = str2double(fform(6:end));
      if N ~= floor(N) | N<1 | N>20
	error('poly-n fitting only defined for integer n=1..20');
      end
      str='';
      for n=1:N+1
	str = sprintf('%s + p(%i)*x.^%i',str,n,N+1-n);
      end
      foo = inline(str(4:end-5),'x','p');
      dfdp = cell(1,N+1);
      for n=1:N
	dfdp{n} = inline(sprintf('x.^%i',N+1-n), 'x','p');
      end
      dfdp{N+1} = inline('1', 'x','p');
    else
      % Arbitrary form
      N = 0;
      k=1;
      fform = [ ' ' fform ' ' ];
      while k<=length(fform)
	if fform(k)>='A' & fform(k)<='Z'
	  n = 1+fform(k)-'A';
	  N = max(N,n);
	  ins = sprintf('p(%i)',n);
	  fform = [ fform(1:k-1) ins fform(k+1:end) ];
	  k=k+length(ins);
	else
	  k=k+1;
	end
      end
      if N==0
	error('No parameters found in free-form function.');
      end
      foo = inline(fform,'x','p');
      try
        z=feval(foo,mean(x),p);
      catch
        lasterr
	error('Free-form function cannot be evaluated.');
      end
      dfdp = []; % Oh well.
  end
end

y = feval(foo,x,p);
N=length(p);
dy2=zeros(size(x));

if ~isempty(dfdp)
  for n=1:N
    for m=1:N
      dy2 = dy2 + spp(n,m) * feval(dfdp{n},x,p) .* feval(dfdp{m},x,p);
    end
  end
else
  % Harder, this is.
  % Differentiate the primitive way...
  dfdp = cell(1,N);
  for n=1:N
    dp=0*p; dp(n)=1e-10;
    y_p = feval(foo,x,p+dp);
    y_m = feval(foo,x,p-dp);
    dfdp{n} = (y_p-y_m) / 2e-10;
  end
  for n=1:N
    for m=1:N
      dy2 = dy2 + spp(n,m) * dfdp{n}.*dfdp{m};
    end
  end
  
end

dy = sqrt(dy2);
