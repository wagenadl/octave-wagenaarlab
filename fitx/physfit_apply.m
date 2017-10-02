function [y, dy] = physfit_apply(x, p, v)
% PHYSFIT_APPLY - Applies fit results to data points
%    yy = PHYSFIT_APPLY(xx, p), where P is a result from PHYSFIT,
%    applies the function form contained in P to the data XX and returns
%    the result. PHYSFIT_APPLY(p, xx) is also accepted.
%    yy = PHYSFIT_APPLY(xx, p, v) specifies to use other than the last
%    element of P.
%    [yy, dy] = PHYSFIT_APPLY(...) also returns uncertainties at each point.

if isstruct(x)
  xx=x;
  x=p;
  p=xx;
  clear xx
end

if nargin<3 || isempty(v)
  v=length(p);
end

fn0 = p(v).form;
fnc = fn0;
N=0; % Count number of parameters
for k=0:25
  if any(fnc=='A'+k)
    N=k+1;
  end
  fnc = strrep(fnc, sprintf('%c','A'+k), sprintf('p(%i).p(%i)',v,k+1));
end

y = eval(fnc);

if nargout<2
  return
end

% I would like to also evaluate uncertainties.
% If y = f(p₁,p₂,...,pₙ)[x], then:
%   σ²_y = sumᵢⱼ df/dpᵢ df/dpⱼ Vᵢⱼ [1]
% where Vᵢⱼ is the covariance of the parameters pᵢ and pⱼ.
% This is certainly what Wikipedia says, too.
% For the simple case y = Ax, I expect
%   σ²_y = x² V_AA,
% so I think [1] may be correct.
% How about y = Ax + B? Then [2] says
%   σ²_y = x² V_AA + x V_AB + V_BB
% That looks right, because V_AB should be able to bring σ² closer to
% zero at selected locations.
% Good. So I need df/dpᵢ for each parameter. Of course I don't have those.
% Two possibilities: I could demand that I be given the functional form.
% Or I can numerically estimate. For that I need a reasonable step size for
% each of the parameters. The uncertainty in each parameter is a reasonable
% scale factor.

% So I estimate df/dA = [f(A+eps*sA) - f(A-eps*sA)] / (2*eps*sA).
EPS = 1e-4;
dfdp = zeros(N,length(x));
for n=1:N
  fnp = strrep(fnc, sprintf('p(%i).p(%i)',v,n), ...
      sprintf('%g', p(v).p(n) + EPS*p(v).s(n)));
  fnm = strrep(fnc, sprintf('p(%i).p(%i)',v,n), ...
      sprintf('%g', p(v).p(n) - EPS*p(v).s(n)));
  dfdp(n,:) = (eval(fnp) - eval(fnm)) / (2*EPS*p(v).s(n));
end

dy = sqrt(sum(dfdp .* (p(v).cov * dfdp)));
