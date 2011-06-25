function y = physfit_apply(x, p, v)
% PHYSFIT_APPLY - Applies fit results to data points
%    yy = PHYSFIT_APPLY(xx, p), where P is a result from PHYSFIT,
%    applies the function form contained in P to the data XX and returns
%    the result.
%    yy = PHYSFIT_APPLY(xx, p, v) specifies to use other than the last
%    element of P.

if nargin<3 | isempty(v)
  v=length(p);
end

fnc = p(v).form;
for k=0:25
  fnc = strrep(fnc,sprintf('%c','A'+k),sprintf('p(%i).p(%i)',v,k+1));
end

y = eval(fnc);
