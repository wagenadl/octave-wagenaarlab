function [p, mu, sigma] = findapeak(x, lim)
% [p, mu, sigma] = FINDAPEAK(x) finds the largest peak in the data
% vector x and fits a Gaussian to it, i.e, it fits
%
%    X(i) = p/sqrt(2*pi*sigma^2) * exp(-(i-mu)^2/(2*sigma^2)).
%
% It uses only the central portion of the peak, i.e. the continuous
% region that's 0.5 or more times the top value. This limit can be
% modified by calling as FINDAPEAK(x,lim).
% Notice that p corresponds to the total area under the curve, i.e.
% typically the estimated total number of spike events classified as 
% part of this peak.

if nargin<2
  lim=.5;
end
if isempty(lim)
  lim=.5;
end

[pk, idx] = max(x);
left=max(find(x(1:idx-1) < lim*pk));
right=idx+min(find(x(idx+1:end) < lim*pk));

if isempty(left) | isempty(right)
  p=0;
  mu=0;
  sigma=0;
  return;
end

data=x(left:right);
par0 = [pk idx-left ((right-left)/3)^2];
[par, dummy, ok] = fminsearch(@fap_fitgaus, par0, [], data);
if ok
  mu=par(2) + left - 1;
  sigma=sqrt(par(3));
  p=par(1)*sqrt(2*pi)*sigma;
else
  mu=0;
  sigma=0;
  p=0;
end
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function chi2 = fap_fitgaus(par, data)
N=length(data);
t=[1:N];
f=par(1)*exp(-.5 * (t-par(2)).^2 ./ par(3));
chi2 = sum((data-f).^2)/(N-3);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test stuff follows:

% spks=loadspksnoc('/anidata/dw/011001/a3exp.negv-4.5.spike');
% trial=fix(spks.time./0.1);
% time=spks.time-(trial*0.1);
% time=time - 0.010;
% time = time*1000;
% 
% t13=time(find(spks.channel==cr12hw(13)));
% 
% [p mu sig] = findapeak(t13);
